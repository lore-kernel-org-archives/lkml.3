Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932739Ab3CUPYm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 11:24:42 -0400
Received: from mail-ve0-f173.google.com ([209.85.128.173]:59412 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932167Ab3CUPYj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 11:24:39 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Kevin Hilman <khilman@linaro.org>, Li Zhong <zhong@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 2/3] nohz: Assign timekeeping duty to a CPU outside the full dynticks range
Date: Thu, 21 Mar 2013 16:24:19 +0100
Message-Id: <1363879460-21595-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1363879460-21595-1-git-send-email-fweisbec@gmail.com>
References: <1363879460-21595-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This way the full nohz CPUs can safely run with the tick
stopped with a guarantee that somebody else is taking
care of the jiffies and GTOD progression.

Once the duty is attributed to a CPU, it won't change. Also that
CPU can't enter into dyntick idle mode or be hot unplugged.

This may later be improved from a power consumption POV. At
least we should be able to share the duty amongst all CPUs
outside the full dynticks range. Then the duty could even be
shared with full dynticks CPUs when those can't stop their
tick for any reason.

But let's start with that very simple approach first.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Geoff Levand <geoff@infradead.org>
Cc: Gilad Ben Yossef <gilad@benyossef.com>
Cc: Hakan Akkan <hakanakkan@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Kevin Hilman <khilman@linaro.org>
Cc: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
[fix have_nohz_full_mask offcase]
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/time/tick-broadcast.c |    3 +-
 kernel/time/tick-common.c    |    5 +++-
 kernel/time/tick-sched.c     |   47 ++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 51 insertions(+), 4 deletions(-)

diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index 2fb8cb8..8a6875c 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -573,7 +573,8 @@ void tick_broadcast_setup_oneshot(struct clock_event_device *bc)
 		bc->event_handler = tick_handle_oneshot_broadcast;
 
 		/* Take the do_timer update */
-		tick_do_timer_cpu = cpu;
+		if (!tick_nohz_extended_cpu(cpu))
+			tick_do_timer_cpu = cpu;
 
 		/*
 		 * We must be careful here. There might be other CPUs
diff --git a/kernel/time/tick-common.c b/kernel/time/tick-common.c
index b1600a6..b7dc0cb 100644
--- a/kernel/time/tick-common.c
+++ b/kernel/time/tick-common.c
@@ -163,7 +163,10 @@ static void tick_setup_device(struct tick_device *td,
 		 * this cpu:
 		 */
 		if (tick_do_timer_cpu == TICK_DO_TIMER_BOOT) {
-			tick_do_timer_cpu = cpu;
+			if (!tick_nohz_extended_cpu(cpu))
+				tick_do_timer_cpu = cpu;
+			else
+				tick_do_timer_cpu = TICK_DO_TIMER_NONE;
 			tick_next_period = ktime_get();
 			tick_period = ktime_set(0, NSEC_PER_SEC / HZ);
 		}
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 79c275f0..57bb3fe 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -112,7 +112,8 @@ static void tick_sched_do_timer(ktime_t now)
 	 * this duty, then the jiffies update is still serialized by
 	 * jiffies_lock.
 	 */
-	if (unlikely(tick_do_timer_cpu == TICK_DO_TIMER_NONE))
+	if (unlikely(tick_do_timer_cpu == TICK_DO_TIMER_NONE)
+	    && !tick_nohz_extended_cpu(cpu))
 		tick_do_timer_cpu = cpu;
 #endif
 
@@ -166,6 +167,25 @@ static int __init tick_nohz_extended_setup(char *str)
 }
 __setup("nohz_extended=", tick_nohz_extended_setup);
 
+static int __cpuinit tick_nohz_cpu_down_callback(struct notifier_block *nfb,
+						 unsigned long action,
+						 void *hcpu)
+{
+	unsigned int cpu = (unsigned long)hcpu;
+
+	switch (action & ~CPU_TASKS_FROZEN) {
+	case CPU_DOWN_PREPARE:
+		/*
+		 * If we handle the timekeeping duty for full dynticks CPUs,
+		 * we can't safely shutdown that CPU.
+		 */
+		if (have_nohz_extended_mask && tick_do_timer_cpu == cpu)
+			return -EINVAL;
+		break;
+	}
+	return NOTIFY_OK;
+}
+
 static int __init init_tick_nohz_extended(void)
 {
 	cpumask_var_t online_nohz;
@@ -174,6 +194,8 @@ static int __init init_tick_nohz_extended(void)
 	if (!have_nohz_extended_mask)
 		return 0;
 
+	cpu_notifier(tick_nohz_cpu_down_callback, 0);
+
 	if (!zalloc_cpumask_var(&online_nohz, GFP_KERNEL)) {
 		pr_warning("NO_HZ: Not enough memory to check extended nohz mask\n");
 		return -ENOMEM;
@@ -188,11 +210,17 @@ static int __init init_tick_nohz_extended(void)
 	/* Ensure we keep a CPU outside the dynticks range for timekeeping */
 	cpumask_and(online_nohz, cpu_online_mask, nohz_extended_mask);
 	if (cpumask_equal(online_nohz, cpu_online_mask)) {
-		cpu = cpumask_any(cpu_online_mask);
 		pr_warning("NO_HZ: Must keep at least one online CPU "
 			   "out of nohz_extended range\n");
+		/*
+		 * We know the current CPU doesn't have its tick stopped.
+		 * Let's use it for the timekeeping duty.
+		 */
+		preempt_disable();
+		cpu = smp_processor_id();
 		pr_warning("NO_HZ: Clearing %d from nohz_extended range\n", cpu);
 		cpumask_clear_cpu(cpu, nohz_extended_mask);
+		preempt_enable();
 	}
 	put_online_cpus();
 	free_cpumask_var(online_nohz);
@@ -551,6 +579,21 @@ static bool can_stop_idle_tick(int cpu, struct tick_sched *ts)
 		return false;
 	}
 
+	if (have_nohz_extended_mask) {
+		/*
+		 * Keep the tick alive to guarantee timekeeping progression
+		 * if there are full dynticks CPUs around
+		 */
+		if (tick_do_timer_cpu == cpu)
+			return false;
+		/*
+		 * Boot safety: make sure the timekeeping duty has been
+		 * assigned before entering dyntick-idle mode,
+		 */
+		if (tick_do_timer_cpu == TICK_DO_TIMER_NONE)
+			return false;
+	}
+
 	return true;
 }
 
-- 
1.7.5.4

