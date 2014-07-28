Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751874AbaG1RjA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 13:39:00 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:58308 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073AbaG1RiC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 13:38:02 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 08/10] nohz: Fetch timekeeping max deferment only for timekeeper
Date: Mon, 28 Jul 2014 19:37:34 +0200
Message-Id: <1406569056-30217-9-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1406569056-30217-1-git-send-email-fweisbec@gmail.com>
References: <1406569056-30217-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We fetch it unconditionally from the tick stop code whereas only
the timekeeper, or the CPU that carried that duty last, needs it.

Fetching the timekeeping max deferment should be lightweight but it
still involves a few read side barriers and a seqcount that may well
be cache cold for non-timekeepers.

So lets spare it when possible by inverting the way we handle timekeeper
deferment state machine.

Cc: Ingo Molnar <mingo@kernel.org>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/time/tick-sched.c | 57 ++++++++++++++++++++++++++----------------------
 1 file changed, 31 insertions(+), 26 deletions(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 2ea2143..bcba79d 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -529,6 +529,36 @@ u64 get_cpu_iowait_time_us(int cpu, u64 *last_update_time)
 }
 EXPORT_SYMBOL_GPL(get_cpu_iowait_time_us);
 
+/*
+ * If this cpu is the one which updates jiffies, then
+ * give up the assignment and let it be taken by the
+ * cpu which runs the tick timer next, which might be
+ * this cpu as well. If we don't drop this here the
+ * jiffies might be stale and do_timer() never
+ * invoked. Keep track of the fact that it was the one
+ * which had the do_timer() duty last. If this cpu is
+ * the one which had the do_timer() duty last, we
+ * limit the sleep time to the timekeeping max deferement
+ * value. Otherwise we can sleep as long as we want.
+ */
+static u64 timekeeping_deferment(struct tick_sched *ts, int cpu)
+{
+	u64 time_delta = KTIME_MAX;
+
+	if (tick_do_timer_cpu == cpu) {
+		time_delta = timekeeping_max_deferment();
+		tick_do_timer_cpu = TICK_DO_TIMER_NONE;
+		ts->do_timer_last = 1;
+	} else if (ts->do_timer_last) {
+		if (tick_do_timer_cpu == TICK_DO_TIMER_NONE)
+			time_delta = timekeeping_max_deferment();
+		else
+			ts->do_timer_last = 0;
+	}
+
+	return time_delta;
+}
+
 static ktime_t tick_nohz_stop_sched_tick(struct tick_sched *ts,
 					 ktime_t now, int cpu)
 {
@@ -536,9 +566,6 @@ static ktime_t tick_nohz_stop_sched_tick(struct tick_sched *ts,
 	ktime_t last_update, expires, ret = { .tv64 = 0 };
 	unsigned long rcu_delta_jiffies;
 	struct clock_event_device *dev = __get_cpu_var(tick_cpu_device).evtdev;
-	u64 time_delta;
-
-	time_delta = timekeeping_max_deferment();
 
 	/* Read jiffies and the time when jiffies were updated last */
 	do {
@@ -570,29 +597,7 @@ static ktime_t tick_nohz_stop_sched_tick(struct tick_sched *ts,
 
 	/* Schedule the tick, if we are at least one jiffie off */
 	if ((long)delta_jiffies >= 1) {
-
-		/*
-		 * If this cpu is the one which updates jiffies, then
-		 * give up the assignment and let it be taken by the
-		 * cpu which runs the tick timer next, which might be
-		 * this cpu as well. If we don't drop this here the
-		 * jiffies might be stale and do_timer() never
-		 * invoked. Keep track of the fact that it was the one
-		 * which had the do_timer() duty last. If this cpu is
-		 * the one which had the do_timer() duty last, we
-		 * limit the sleep time to the timekeeping
-		 * max_deferement value which we retrieved
-		 * above. Otherwise we can sleep as long as we want.
-		 */
-		if (cpu == tick_do_timer_cpu) {
-			tick_do_timer_cpu = TICK_DO_TIMER_NONE;
-			ts->do_timer_last = 1;
-		} else if (tick_do_timer_cpu != TICK_DO_TIMER_NONE) {
-			time_delta = KTIME_MAX;
-			ts->do_timer_last = 0;
-		} else if (!ts->do_timer_last) {
-			time_delta = KTIME_MAX;
-		}
+		u64 time_delta = timekeeping_deferment(ts, cpu);
 
 #ifdef CONFIG_NO_HZ_FULL
 		if (!ts->inidle) {
-- 
1.8.3.1

