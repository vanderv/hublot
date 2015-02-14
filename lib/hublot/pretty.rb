module Hublot

  # Clock argument for testing; defaults to Time
  def pretty(clock=Time.now)
    @expired = (clock-self).to_i
    @today_week = clock.strftime('%u').to_i
    @created_week = self.to_time.strftime('%u').to_i

    return just_now     if just_now?
    return a_second_ago if a_second_ago?
    return seconds_ago  if seconds_ago?
    return a_minute_ago if a_minute_ago?
    return minutes_ago  if minutes_ago?
    return an_hour_ago  if an_hour_ago?
    return today        if is_today?
    return yesterday    if is_yesterday?
    return this_week    if this_week?
    return datetimefiesta    if last_week?
    return datetimefiesta
  end

private
  def just_now
    'только что'
  end

  def just_now?
    @expired == 0
  end

  def a_second_ago
    'секунду назад'
  end

  def a_second_ago?
    @expired == 1
  end

  def seconds_ago

    @expired.to_s + " #{Russian::p(@expired, "секунду назад", "секунды назад", "секунд назад")}"
  end

  def seconds_ago?
    @expired >= 2 && @expired <= 59
  end

  def a_minute_ago
    'минуту назад'
  end

  def a_minute_ago?
    @expired >= 60 && @expired <= 119 #120 = 2 minutes
  end

  def minutes_ago
    (@expired/60).to_i.to_s + " #{Russian::p((@expired/60).to_i, "минуту назад", "минуты назад", "минут назад")}"
  end

  def minutes_ago?
    @expired >= 120 && @expired <= 3599
  end

  def an_hour_ago
    'час назад'
  end

  def an_hour_ago?
    @expired >= 3600 && @expired <= 7199 # 3600 = 1 hour
  end

  def today
    "сегодня в #{timeify}"
  end

  def timeify
    "#{self.to_time.strftime("%R")}"
  end

  def is_today?
    @today_week - @created_week == 0 && @expired >= 7200 && @expired <= 82800
  end

  def yesterday
    "вчера в #{timeify}"
  end

  def is_yesterday?
    (@today_week - @created_week == 1 || @created_week + @today_week == 8) && @expired <= 172800 
  end

  def this_week
    "#{@created_week} в #{timeify}"
  end

  def this_week?
    @expired <= 604800 && @today_week - @created_week != 0 
  end

  def last_week
    self.datetimefiesta
  end

  def last_week?
    @expired >= 518400 && @expired <= 1123200
  end

  def datetimefiesta
    Russian::strftime(self, "%e %b %Y в %R")
  end
end
