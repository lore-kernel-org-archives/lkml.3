Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753654Ab3JBK0J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 06:26:09 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:60971 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753127Ab3JBK0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 06:26:07 -0400
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: tglx@linutronix.de, sboyd@codeaurora.org
Cc: linux-kernel@vger.kernel.org, patches@linaro.org,
        linaro-kernel@lists.linaro.org
Subject: [PATCH V2] tick: Make sleep length calculation more accurate
Date: Wed,  2 Oct 2013 12:26:05 +0200
Message-Id: <1380709565-22153-1-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The sleep_length is computed in the tick_nohz_stop_sched_tick function but it
is used later in the code with in between the local irq enabled.

cpu_idle_loop
  tick_nohz_idle_enter         [ exits with local irq enabled ]
   __tick_nohz_idle_enter
     tick_nohz_stop_sched_tick
  ...

  arch_cpu_idle
     menu_select               [ uses here 'sleep_length' ]
  ...

Between the computation of the sleep length and its usage, some interrupts
may occur, making the sleep length shorter than actually it is because of the
interrupt processing, or different if the timer itself expired.

This patch fixes that by moving the sleep_length computation in the
tick_nohz_get_sleep_length function and using the tick device's next_event.

As the sleep_length field is no longer needed, it is removed from the
tick_sched structure.

Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 include/linux/tick.h     |    2 --
 kernel/time/tick-sched.c |    5 +++--
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/include/linux/tick.h b/include/linux/tick.h
index 5128d33..53dbbd7 100644
--- a/include/linux/tick.h
+++ b/include/linux/tick.h
@@ -48,7 +48,6 @@ enum tick_nohz_mode {
  * @idle_exittime:	Time when the idle state was left
  * @idle_sleeptime:	Sum of the time slept in idle with sched tick stopped
  * @iowait_sleeptime:	Sum of the time slept in idle with sched tick stopped, with IO outstanding
- * @sleep_length:	Duration of the current idle sleep
  * @do_timer_lst:	CPU was the last one doing do_timer before going idle
  */
 struct tick_sched {
@@ -67,7 +66,6 @@ struct tick_sched {
 	ktime_t				idle_exittime;
 	ktime_t				idle_sleeptime;
 	ktime_t				iowait_sleeptime;
-	ktime_t				sleep_length;
 	unsigned long			last_jiffies;
 	unsigned long			next_jiffies;
 	ktime_t				idle_expires;
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 3612fc7..60b1dcd 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -673,7 +673,6 @@ static ktime_t tick_nohz_stop_sched_tick(struct tick_sched *ts,
 out:
 	ts->next_jiffies = next_jiffies;
 	ts->last_jiffies = last_jiffies;
-	ts->sleep_length = ktime_sub(dev->next_event, now);
 
 	return ret;
 }
@@ -837,8 +836,10 @@ void tick_nohz_irq_exit(void)
 ktime_t tick_nohz_get_sleep_length(void)
 {
 	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
+	struct clock_event_device *dev = __get_cpu_var(tick_cpu_device).evtdev;
+	ktime_t now = ktime_get();
 
-	return ts->sleep_length;
+	return ktime_sub(dev->next_event, now);
 }
 
 static void tick_nohz_restart(struct tick_sched *ts, ktime_t now)
-- 
1.7.9.5

