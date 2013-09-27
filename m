Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751719Ab3I0KwZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 06:52:25 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:49026 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949Ab3I0KwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 06:52:23 -0400
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, patches@linaro.org,
        linaro-kernel@lists.linaro.org
Subject: [PATCH] tick: make sleep length calculation more accurate
Date: Fri, 27 Sep 2013 12:52:20 +0200
Message-Id: <1380279140-27728-1-git-send-email-daniel.lezcano@linaro.org>
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
can occur, making the sleep length shorter than actually it is.

This patch fixes that by moving the sleep_length computation in the
tick_nohz_get_sleep_length function and store the next_event for the device
instead of the sleep_length.

Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 include/linux/tick.h     |    2 +-
 kernel/time/tick-sched.c |    5 +++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/include/linux/tick.h b/include/linux/tick.h
index 5128d33..4932004 100644
--- a/include/linux/tick.h
+++ b/include/linux/tick.h
@@ -67,7 +67,7 @@ struct tick_sched {
 	ktime_t				idle_exittime;
 	ktime_t				idle_sleeptime;
 	ktime_t				iowait_sleeptime;
-	ktime_t				sleep_length;
+	ktime_t				next_event;
 	unsigned long			last_jiffies;
 	unsigned long			next_jiffies;
 	ktime_t				idle_expires;
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 3612fc7..2007a7f 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -673,7 +673,7 @@ static ktime_t tick_nohz_stop_sched_tick(struct tick_sched *ts,
 out:
 	ts->next_jiffies = next_jiffies;
 	ts->last_jiffies = last_jiffies;
-	ts->sleep_length = ktime_sub(dev->next_event, now);
+	ts->next_event = dev->next_event;
 
 	return ret;
 }
@@ -837,8 +837,9 @@ void tick_nohz_irq_exit(void)
 ktime_t tick_nohz_get_sleep_length(void)
 {
 	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
+	ktime_t now = ktime_get();
 
-	return ts->sleep_length;
+	return ktime_sub(ts->next_event, now);
 }
 
 static void tick_nohz_restart(struct tick_sched *ts, ktime_t now)
-- 
1.7.9.5

