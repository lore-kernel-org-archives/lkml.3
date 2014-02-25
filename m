Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753370AbaBYMh7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 07:37:59 -0500
Received: from asav21.altibox.net ([109.247.116.8]:48810 "EHLO
	asav21.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752319AbaBYMgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 07:36:40 -0500
From: Henrik Austad <henrik@austad.us>
To: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linuxtronix.de>
Cc: Henrik Austad <haustad@cisco.com>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        John Stultz <john.stultz@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH 4/6] Force a specific CPU to handle all do_timer() events.
Date: Tue, 25 Feb 2014 13:33:59 +0100
Message-Id: <1393331641-14016-5-git-send-email-henrik@austad.us>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1393331641-14016-1-git-send-email-henrik@austad.us>
References: <1393331641-14016-1-git-send-email-henrik@austad.us>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Henrik Austad <haustad@cisco.com>

By default, this is disabled (set to -1) and must be explicitly set in order
to have an effect. The CPU must be online.

If the specified CPU is part of the NO_HZ_FULL set, it is removed from
the set. When forced tick is either disabled or moved to another CPU, it
will try to re-enable NO_HZ_FULL on previous CPU.

If the CPU is removed (hotpluggable CPUs), forced tick will be disabled.

CC: Thomas Gleixner <tglx@linutronix.de>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>
CC: John Stultz <john.stultz@linaro.org>
CC: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Henrik Austad <haustad@cisco.com>
---
 kernel/time/tick-common.c   |  103 +++++++++++++++++++++++++++++++++++++++++++
 kernel/time/tick-internal.h |    4 ++
 kernel/time/tick-sched.c    |   14 +++++-
 3 files changed, 120 insertions(+), 1 deletion(-)

diff --git a/kernel/time/tick-common.c b/kernel/time/tick-common.c
index 1729b4b..d4e660a 100644
--- a/kernel/time/tick-common.c
+++ b/kernel/time/tick-common.c
@@ -51,6 +51,19 @@ ktime_t tick_period;
 int tick_do_timer_cpu __read_mostly = TICK_DO_TIMER_BOOT;
 
 /*
+ * tick_do_timer_cpu_forced is YATCIV responsible for controlling the
+ * forced-timer logic. It has 2 modes
+ *
+ * - 'Off': -1  Default mode, timer ticks are being processed as normal.
+ *
+ * - 'On' : Stores the CPUid of the CPU currently assigned to handle all
+ *          do_timer() events. A CPU given this responsible will not be
+ *          allowed to enter NO_HZ_IDLE or NO_HZ_FULL mode.
+ */
+int tick_do_timer_cpu_forced __read_mostly = -1;
+
+
+/*
  * Debugging: see timer_list.c
  */
 struct tick_device *tick_get_device(int cpu)
@@ -342,6 +355,12 @@ void tick_handover_do_timer(int *cpup)
 	if (*cpup == tick_do_timer_cpu) {
 		int cpu = cpumask_first(cpu_online_mask);
 
+		/* forced tick on this */
+		if (tick_do_timer_cpu_forced == tick_do_timer_cpu) {
+			tick_set_forced_cpu(-1);
+			pr_info("Disabled forced timer-tick due to dying CPU\n");
+		}
+
 		tick_do_timer_cpu = (cpu < nr_cpu_ids) ? cpu :
 			TICK_DO_TIMER_NONE;
 	}
@@ -360,6 +379,90 @@ int tick_expose_cpu(void)
 }
 
 /*
+ * Set a forced value for tick_do_timer_cpu
+ *
+ * When not set, forced_tick_do_timer_cpu is -1, otherwise it is
+ * identical to tick_do_timer_cpu.
+ *
+ * When the core is set, this core is not able to drop into NOHZ idle
+ * and NOHZ full mode.
+ */
+int tick_set_forced_cpu(int new_cpu)
+{
+#ifdef CONFIG_NO_HZ_FULL
+	static int nohz_cpu_pre_forced = -1;
+#endif
+	int ret = 0;
+
+	DEFINE_MUTEX(forced_cpu_mutex);
+
+	mutex_lock(&forced_cpu_mutex);
+	if (new_cpu == tick_do_timer_cpu_forced)
+		goto out;
+
+	if (new_cpu == -1) {
+#ifdef CONFIG_NO_HZ_FULL
+		if (nohz_cpu_pre_forced != -1) {
+			cpumask_set_cpu(nohz_cpu_pre_forced, tick_nohz_full_mask);
+			nohz_cpu_pre_forced = -1;
+		}
+#endif
+
+		/* let the timer-machinery pick up the fallout */
+		tick_do_timer_cpu = TICK_DO_TIMER_NONE;
+		tick_do_timer_cpu_forced = -1;
+		goto out;
+	}
+
+	/*
+	 * Make sure new_cpu is actually a valid CPU.
+	 */
+	if (!cpu_online(new_cpu)) {
+		ret =  -EINVAL;
+		pr_warn("tick_set_forced_cpu(): Suggested CPU not available\n");
+		goto out;
+	}
+
+#ifdef CONFIG_NO_HZ_FULL
+	/*
+	 * no_hz_full require some extra care
+	 */
+	if (nohz_cpu_pre_forced != -1) {
+		cpumask_set_cpu(nohz_cpu_pre_forced, tick_nohz_full_mask);
+		nohz_cpu_pre_forced = -1;
+	}
+	if (tick_nohz_full_cpu(new_cpu)) {
+
+		nohz_cpu_pre_forced = new_cpu;
+		cpumask_clear_cpu(new_cpu, tick_nohz_full_mask);
+	}
+#endif
+	tick_do_timer_cpu_forced = new_cpu;
+	tick_do_timer_cpu = new_cpu;
+
+out:
+	mutex_unlock(&forced_cpu_mutex);
+	return ret;
+}
+int tick_get_forced_cpu(void)
+{
+	return tick_do_timer_cpu_forced;
+}
+
+bool forced_timer_can_stop_tick(void)
+{
+	/*
+	 * can be racy if we get an update of tick_do_timer_cpu_foced
+	 * right in the middle of this call
+	 *
+	 * Currently only called from tick-sched::can_stop_full_tick() and can_stop_idle_tick()
+	 *
+	 * If disabled, tick_do_timer_cpu_forced is -1, which will never be a CPUid.
+	 */
+	return !(tick_do_timer_cpu_forced == raw_smp_processor_id());
+}
+
+/*
  * Shutdown an event device on a given cpu:
  *
  * This is called on a life CPU, when a CPU is dead. So we cannot
diff --git a/kernel/time/tick-internal.h b/kernel/time/tick-internal.h
index 5051dbd..9eed487 100644
--- a/kernel/time/tick-internal.h
+++ b/kernel/time/tick-internal.h
@@ -155,5 +155,9 @@ static inline int tick_device_is_functional(struct clock_event_device *dev)
 #endif
 
 extern int tick_expose_cpu(void);
+int tick_set_forced_cpu(int new_cpu);
+int tick_get_forced_cpu(void);
+bool forced_timer_can_stop_tick(void);
+
 extern void do_timer(unsigned long ticks);
 extern void update_wall_time(void);
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 9f8af69..95e6d7d 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -172,6 +172,11 @@ static bool can_stop_full_tick(void)
 		return false;
 	}
 
+	if (!forced_timer_can_stop_tick()) {
+		trace_tick_stop(0, "forced timer-tick running on CPU\n");
+		return false;
+	}
+
 	/* sched_clock_tick() needs us? */
 #ifdef CONFIG_HAVE_UNSTABLE_SCHED_CLOCK
 	/*
@@ -704,11 +709,18 @@ static bool can_stop_idle_tick(int cpu, struct tick_sched *ts)
 	 * invoked.
 	 */
 	if (unlikely(!cpu_online(cpu))) {
-		if (cpu == tick_do_timer_cpu)
+		if (cpu == tick_do_timer_cpu) {
 			tick_do_timer_cpu = TICK_DO_TIMER_NONE;
+		}
 		return false;
 	}
 
+	/*
+	 * if forced do_timer is set, we cannot stop the tick on this CPU.
+	 */
+	if (unlikely(!forced_timer_can_stop_tick()))
+		return false;
+
 	if (unlikely(ts->nohz_mode == NOHZ_MODE_INACTIVE)) {
 		ts->sleep_length = (ktime_t) { .tv64 = NSEC_PER_SEC/HZ };
 		return false;
-- 
1.7.9.5

