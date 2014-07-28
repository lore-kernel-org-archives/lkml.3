Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751687AbaG1RiL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 13:38:11 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:33691 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751614AbaG1RiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 13:38:07 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 10/10] nohz: Warn on illegal timekeeper switch in nohz full
Date: Mon, 28 Jul 2014 19:37:36 +0200
Message-Id: <1406569056-30217-11-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1406569056-30217-1-git-send-email-fweisbec@gmail.com>
References: <1406569056-30217-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In full dynticks idle mode, the timekeeper should never be set to another
CPU than 0.

Lets enforce that through a dedicated mutator.

Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/time/tick-common.c   | 9 ++++-----
 kernel/time/tick-internal.h | 7 +++++++
 kernel/time/tick-sched.c    | 7 +++----
 3 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/kernel/time/tick-common.c b/kernel/time/tick-common.c
index cb57bce..72ccaf2 100644
--- a/kernel/time/tick-common.c
+++ b/kernel/time/tick-common.c
@@ -180,9 +180,9 @@ static void tick_setup_device(struct tick_device *td,
 		 */
 		if (tick_do_timer_cpu == TICK_DO_TIMER_BOOT) {
 			if (tick_nohz_full_enabled())
-				tick_do_timer_cpu = TICK_DO_TIMER_DEFAULT;
+				tick_do_timer_cpu_set(TICK_DO_TIMER_DEFAULT);
 			else
-				tick_do_timer_cpu = cpu;
+				tick_do_timer_cpu_set(cpu);
 			tick_next_period = ktime_get();
 			tick_period = ktime_set(0, NSEC_PER_SEC / HZ);
 		}
@@ -341,9 +341,8 @@ void tick_handover_do_timer(int *cpup)
 {
 	if (*cpup == tick_do_timer_cpu) {
 		int cpu = cpumask_first(cpu_online_mask);
-
-		tick_do_timer_cpu = (cpu < nr_cpu_ids) ? cpu :
-			TICK_DO_TIMER_NONE;
+		tick_do_timer_cpu_set((cpu < nr_cpu_ids) ? cpu :
+				      TICK_DO_TIMER_NONE);
 	}
 }
 
diff --git a/kernel/time/tick-internal.h b/kernel/time/tick-internal.h
index 6b592a8..eadfd89 100644
--- a/kernel/time/tick-internal.h
+++ b/kernel/time/tick-internal.h
@@ -23,6 +23,13 @@ extern void tick_setup_periodic(struct clock_event_device *dev, int broadcast);
 extern void tick_handle_periodic(struct clock_event_device *dev);
 extern void tick_check_new_device(struct clock_event_device *dev);
 extern void tick_handover_do_timer(int *cpup);
+
+static inline void tick_do_timer_cpu_set(int cpu)
+{
+	WARN_ON_ONCE(tick_nohz_full_enabled() && cpu != TICK_DO_TIMER_DEFAULT);
+	tick_do_timer_cpu = cpu;
+}
+
 extern void tick_shutdown(unsigned int *cpup);
 extern void tick_suspend(void);
 extern void tick_resume(void);
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 845aaff..3b5102a 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -123,7 +123,7 @@ static void tick_sched_do_timer(ktime_t now)
 	 */
 	if (unlikely(tick_do_timer_cpu == TICK_DO_TIMER_NONE)
 	    && !tick_nohz_full_cpu(cpu))
-		tick_do_timer_cpu = cpu;
+		tick_do_timer_cpu_set(cpu);
 #endif
 
 	/* Check, if the jiffies need an update */
@@ -550,7 +550,7 @@ static u64 timekeeping_deferment(struct tick_sched *ts, int cpu)
 		ts->do_timer_last = 1;
 		/* In full dynticks mode, CPU 0 always keeps the duty */
 		if (!tick_nohz_full_enabled())
-			tick_do_timer_cpu = TICK_DO_TIMER_NONE;
+			tick_do_timer_cpu_set(TICK_DO_TIMER_NONE);
 	} else if (ts->do_timer_last) {
 		if (tick_do_timer_cpu == TICK_DO_TIMER_NONE)
 			time_delta = timekeeping_max_deferment();
@@ -600,7 +600,6 @@ static ktime_t tick_nohz_stop_sched_tick(struct tick_sched *ts,
 	/* Schedule the tick, if we are at least one jiffie off */
 	if ((long)delta_jiffies >= 1) {
 		u64 time_delta = timekeeping_deferment(ts, cpu);
-
 #ifdef CONFIG_NO_HZ_FULL
 		if (!ts->inidle) {
 			time_delta = min(time_delta,
@@ -717,7 +716,7 @@ static bool can_stop_idle_tick(int cpu, struct tick_sched *ts)
 	 */
 	if (unlikely(!cpu_online(cpu))) {
 		if (cpu == tick_do_timer_cpu)
-			tick_do_timer_cpu = TICK_DO_TIMER_NONE;
+			tick_do_timer_cpu_set(TICK_DO_TIMER_NONE);
 		return false;
 	}
 
-- 
1.8.3.1

