extends Node


@export var mob_scene: PackedScene
var score


func game_over() -> void:
    $ScoreTimer.stop()
    $MobTimer.stop()
    $Music.stop()
    $DeathSound.play()
    $HUD.show_game_over()


func new_game() -> void:
    score = 0
    $Player.start($StartPosition.position)
    $StartTimer.start()
    $Music.play()
    $HUD.update_score(score)
    $HUD.show_message("Get Ready...")
    get_tree().call_group("mobs", "queue_free")


func _on_mob_timer_timeout() -> void:
    var mob = mob_scene.instantiate()

    var mob_spawn_location = $MobPath/MobSpawnLocation
    mob_spawn_location.progress_ratio = randf()

    var direction = mob_spawn_location.rotation + PI / 2

    mob.position = mob_spawn_location.position

    direction += randf_range(-PI / 4, PI / 4)
    mob.rotation = direction

    var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
    mob.linear_velocity = velocity.rotated(direction)

    add_child(mob)


func _on_start_timer_timeout() -> void:
    $MobTimer.start()
    $ScoreTimer.start()


func _on_score_timer_timeout() -> void:
    score += 1
    $HUD.update_score(score)
