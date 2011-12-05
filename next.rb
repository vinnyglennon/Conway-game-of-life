class Cell
	def initialize(prob_of_life)
		@alive = prob_of_life > rand	
	end

	def to_s
		@alive ? "x" : " "  # blank for dead cells
	end

	def to_i
		@alive ? 1 : 0
	end

	def dead?
		!@alive
	end
	
	def alive?
		@alive
	end
end


class Game

	def initialize(height, width, prob_of_life)
		@height, @width, @prob_of_life = height, width, prob_of_life
		@board = Array.new(@height) { Array.new(@width) { Cell.new(prob_of_life) } }		
		@stats = []
	end

	def start(steps)
		1.upto(steps).each{|step|
			next_step
			count_live_cells
			puts "On step #{step}/#{steps}  alive: #{@stats.last}  max: #{@stats.max}  prob_of_life:#{@prob_of_life} \n======================================"
			p self	
		}
	end
	
	def count_live_cells
		@stats << @board.flatten.inject(0) { |result, element| result + element.to_i}
	end

	def next_step
		 @board.each_with_index{|row, h|
      row.each_with_index{|cell, w|
				neighbours = get_neighbours_count h,w

				# should be extracted out, not sequential, as it is working in realtime, rather than against each step.
				if @board[h][w].dead? and neighbours==3
		          @board[h][w] = Cell.new(1) #born  . overkill to create new object each time, todo
		    else
						unless @board[h][w].alive? and (2..3).cover?(neighbours) 
		          @board[h][w] = Cell.new(0)  #die
						end
		    end

			}
		}
	end
	
	def to_s
		@board.map{|row| row.join}.join("\n")	
	end

	def get_neighbours_count x, y
		[
		   [x + 1, y],
		   [x - 1, y + 1],
		   [x, y + 1],
		   [x - 1, y - 1],
		   [x, y - 1],
		   [x + 1, y - 1],
		   [x - 1, y],
		   [x + 1, y + 1]
		 ].reject{|element| x_val = element.first 
												y_val = element.last
												x_val >= @width or y_val >= @height or x_val < 0 or y_val < 0  # drop all out of bounds
							}.inject(0) { |result, element| 
																							 result + @board[element.first][element.last].to_i   # count actual neighbours
													}
	end

end

width, height = 47,47
steps = 1000
prob_of_life = 0.1

Game.new(width, height, prob_of_life).start(steps)
