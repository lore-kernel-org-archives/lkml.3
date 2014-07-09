Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754644AbaGIG4M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 02:56:12 -0400
Received: from mail-qa0-f51.google.com ([209.85.216.51]:57463 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054AbaGIG4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 02:56:09 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, arvind.chauhan@arm.com, preeti@linux.vnet.ibm.com,
        khilman@linaro.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [RFC 3/7] tick: don't check for active hrtimer after adding it
Date: Wed,  9 Jul 2014 12:25:35 +0530
Message-Id: <e64d17918edf00028917cdc745a112139342bb66.1404888801.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <cover.1404888801.git.viresh.kumar@linaro.org>
References: <cover.1404888801.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1404888801.git.viresh.kumar@linaro.org>
References: <cover.1404888801.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hrtimer_start*() family never fails to enqueue a hrtimer to a clock-base. The
only special case is when the hrtimer was in past. If it is getting enqueued to
local CPUs's clock-base, we raise a softirq and exit, else we handle that on
next interrupt on remote CPU.

At several places in the kernel, we try to make sure if hrtimer was added
properly or not by calling hrtimer_active(), like:

	hrtimer_start(timer, expires, mode);
	if (hrtimer_active(timer)) {
		/* Added successfully */
	} else {
		/* Was added in the past */
	}

As hrtimer_start*() never fails, hrtimer_active() is guaranteed to return '1'.
So, there is no point calling hrtimer_active().

This is done in while loop at several places, which isn't required anymore.

This patch updates tick core to get this fixed. This also removes the confusing
comment present over usage of hrtimer_active().

-                       /* Check, if the timer was already in the past */

This comment says that hrtimer_active() would check if timer was already in the
past, but hrtimer_active() can't check it. It just checks if timer is in
INACTIVE state or not.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 kernel/time/tick-sched.c | 45 ++++++++++++++++++---------------------------
 1 file changed, 18 insertions(+), 27 deletions(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 6558b7a..66ca5ab 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -658,9 +658,7 @@ static ktime_t tick_nohz_stop_sched_tick(struct tick_sched *ts,
 		if (ts->nohz_mode == NOHZ_MODE_HIGHRES) {
 			hrtimer_start(&ts->sched_timer, expires,
 				      HRTIMER_MODE_ABS_PINNED);
-			/* Check, if the timer was already in the past */
-			if (hrtimer_active(&ts->sched_timer))
-				goto out;
+			goto out;
 		} else if (!tick_program_event(expires, 0))
 				goto out;
 		/*
@@ -844,24 +842,25 @@ static void tick_nohz_restart(struct tick_sched *ts, ktime_t now)
 	hrtimer_cancel(&ts->sched_timer);
 	hrtimer_set_expires(&ts->sched_timer, ts->last_tick);
 
-	while (1) {
-		/* Forward the time to expire in the future */
-		hrtimer_forward(&ts->sched_timer, now, tick_period);
+	/* Forward the time to expire in the future */
+	hrtimer_forward(&ts->sched_timer, now, tick_period);
 
-		if (ts->nohz_mode == NOHZ_MODE_HIGHRES) {
-			hrtimer_start_expires(&ts->sched_timer,
-					      HRTIMER_MODE_ABS_PINNED);
-			/* Check, if the timer was already in the past */
-			if (hrtimer_active(&ts->sched_timer))
-				break;
-		} else {
-			if (!tick_program_event(
-				hrtimer_get_expires(&ts->sched_timer), 0))
-				break;
-		}
+	if (ts->nohz_mode == NOHZ_MODE_HIGHRES) {
+		hrtimer_start_expires(&ts->sched_timer,
+				      HRTIMER_MODE_ABS_PINNED);
+		return;
+	}
+
+	while (1) {
+		if (!tick_program_event(hrtimer_get_expires(&ts->sched_timer),
+					0))
+			break;
 		/* Reread time and update jiffies */
 		now = ktime_get();
 		tick_do_update_jiffies64(now);
+
+		/* Forward the time to expire in the future */
+		hrtimer_forward(&ts->sched_timer, now, tick_period);
 	}
 }
 
@@ -1104,7 +1103,6 @@ early_param("skew_tick", skew_tick);
 void tick_setup_sched_timer(void)
 {
 	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
-	ktime_t now = ktime_get();
 
 	/*
 	 * Emulate tick processing via per-CPU hrtimers:
@@ -1123,15 +1121,8 @@ void tick_setup_sched_timer(void)
 		hrtimer_add_expires_ns(&ts->sched_timer, offset);
 	}
 
-	for (;;) {
-		hrtimer_forward(&ts->sched_timer, now, tick_period);
-		hrtimer_start_expires(&ts->sched_timer,
-				      HRTIMER_MODE_ABS_PINNED);
-		/* Check, if the timer was already in the past */
-		if (hrtimer_active(&ts->sched_timer))
-			break;
-		now = ktime_get();
-	}
+	hrtimer_forward(&ts->sched_timer, ktime_get(), tick_period);
+	hrtimer_start_expires(&ts->sched_timer, HRTIMER_MODE_ABS_PINNED);
 
 #ifdef CONFIG_NO_HZ_COMMON
 	if (tick_nohz_enabled) {
-- 
2.0.0.rc2

