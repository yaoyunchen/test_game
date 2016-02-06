require 'gosu'

require_relative 'player'
require_relative 'star'
require_relative 'zorder'

class MyWindow < Gosu::Window
	def initialize
		#Setting to true will be fulslcreen.
		super 640, 480, false

		self.caption = "Gosu Tutorial Game"

		@background_img = Gosu::Image.new("media/space.png", :tileable => true)

		@player = Player.new
		@player.warp(320, 240)

		@star_anim = Gosu::Image::load_tiles("media/star.png", 25, 25)
		@stars = Array.new

		@font = Gosu::Font.new(20)
	end

	#Called 60 times per second (by dafault) and contains maing ame logic (move objects, handle collisions, etc)
	def update
		if Gosu::button_down? Gosu::KbLeft or Gosu::button_down? Gosu::GpLeft then @player.turn_left
		end
		if Gosu::button_down? Gosu::KbRight or Gosu::button_down? Gosu::GpRight then @player.turn_right
		end
		if Gosu::button_down? Gosu::KbUp or Gosu::button_down? Gosu::GpButton0 then @player.accelerate
		end
		
		@player.move
		@player.collect_stars(@stars)

		if rand(100) < 4 and @stars.size < 25 then
			@stars.push(Star.new(@star_anim))
		end
	end

	#Code to redraw screen, but does not affect game's state.
	def draw
		@player.draw
		@background_img.draw(0, 0, 0)
		@stars.each{|star| star.draw}
		@font.draw("Score:#{@player.score}", 10, 10, ZOrder::UI, 1.0, 1.0, 0xff_ffff00)
	end

	def button_down(id)
		if id == Gosu::KbEscape
			close
		end
	end
end

window = MyWindow.new

#Shows window.  Does not close until window is closed by  user or close() is called.
window.show