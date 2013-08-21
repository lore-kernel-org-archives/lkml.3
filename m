Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752474Ab3HUQwj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 12:52:39 -0400
Received: from mail-wg0-f53.google.com ([74.125.82.53]:55869 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985Ab3HUQwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 12:52:37 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        John Stultz <john.stultz@linaro.org>,
        Steven Rostedt <rostedt@goodmis.org>, Don Zickus <dzickus@redhat.com>
Subject: [RFC PATCH 6/6] timekeeping: Debug missing timekeeping updates
Date: Wed, 21 Aug 2013 18:42:21 +0200
Message-Id: <1377103341-15235-7-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1377103341-15235-1-git-send-email-fweisbec@gmail.com>
References: <1377103341-15235-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the full dynticks feature and the tricky full system idle
detection code that is coming soon, it becomes necessary to have
some debug code that makes sure that the timekeeping is always
maintained and moving forward as expected.

This provides a simple detection of missing timekeeping updates
inspired by the lockup detector's use of CPU cycles clock.

The jiffies are compared to the cpu clock after several snapshots taken
from NMIs that trigger after arbitrary CPU cycles period overflow.

If the jiffies progression appears to drift too far away from the CPU
clock's, this triggers a warning.

We just make sure not to account the tiny code on irq entry that
may have stale jiffies values before tick_check_nohz() is called
after the CPU is woken up while the system went full idle for some
time.

Same goes for idle exit in case the tick were stopped but idle
was polling on need_resched().

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Don Zickus <dzickus@redhat.com>
---
 include/linux/time.h               |   11 +++
 kernel/time/Makefile               |    1 +
 kernel/time/tick-sched.c           |    4 +
 kernel/time/timekeeping.c          |    1 +
 kernel/time/timekeeping_selftest.c |  125 ++++++++++++++++++++++++++++++++++++
 lib/Kconfig.debug                  |   12 ++++
 6 files changed, 154 insertions(+), 0 deletions(-)
 create mode 100644 kernel/time/timekeeping_selftest.c

diff --git a/include/linux/time.h b/include/linux/time.h
index d5d229b..39d8493 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -181,6 +181,17 @@ extern s32 timekeeping_get_tai_offset(void);
 extern void timekeeping_set_tai_offset(s32 tai_offset);
 extern void timekeeping_clocktai(struct timespec *ts);
 
+#ifdef CONFIG_DEBUG_TIMEKEEPING
+extern void timekeeping_selftest_update(void);
+extern void timekeeping_selftest_start(void);
+extern void timekeeping_selftest_stop(void);
+
+#else
+static inline void timekeeping_selftest_update(void) { }
+static inline void timekeeping_selftest_start(void) { }
+static inline void timekeeping_selftest_stop(void) { }
+#endif
+
 struct tms;
 extern void do_sys_times(struct tms *);
 
diff --git a/kernel/time/Makefile b/kernel/time/Makefile
index 9250130..cbea072 100644
--- a/kernel/time/Makefile
+++ b/kernel/time/Makefile
@@ -9,3 +9,4 @@ obj-$(CONFIG_TICK_ONESHOT)			+= tick-oneshot.o
 obj-$(CONFIG_TICK_ONESHOT)			+= tick-sched.o
 obj-$(CONFIG_TIMER_STATS)			+= timer_stats.o
 obj-$(CONFIG_DEBUG_FS)				+= timekeeping_debug.o
+obj-$(CONFIG_DEBUG_TIMEKEEPING)			+= timekeeping_selftest.o
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index e77edc9..dcba0e1 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -771,6 +771,8 @@ static void __tick_nohz_idle_enter(struct tick_sched *ts)
 
 		if (!was_stopped && ts->tick_stopped)
 			ts->idle_jiffies = ts->last_jiffies;
+
+		timekeeping_selftest_stop();
 	}
 }
 
@@ -937,6 +939,7 @@ void tick_nohz_idle_exit(void)
 	if (ts->tick_stopped) {
 		tick_nohz_restart_sched_tick(ts, now);
 		tick_nohz_account_idle_ticks(ts);
+		timekeeping_selftest_start();
 	}
 
 	local_irq_enable();
@@ -1049,6 +1052,7 @@ static inline void tick_check_nohz(int cpu)
 	if (ts->tick_stopped) {
 		tick_nohz_update_jiffies(now);
 		tick_nohz_kick_tick(cpu, now);
+		timekeeping_selftest_start();
 	}
 }
 
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 48b9fff..1dcb216 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -1583,6 +1583,7 @@ struct timespec get_monotonic_coarse(void)
 void do_timer(unsigned long ticks)
 {
 	jiffies_64 += ticks;
+	timekeeping_selftest_update();
 	update_wall_time();
 	calc_global_load(ticks);
 }
diff --git a/kernel/time/timekeeping_selftest.c b/kernel/time/timekeeping_selftest.c
new file mode 100644
index 0000000..f66331f
--- /dev/null
+++ b/kernel/time/timekeeping_selftest.c
@@ -0,0 +1,125 @@
+#include "tick-internal.h"
+#include <linux/perf_event.h>
+#include <linux/percpu.h>
+#include <linux/sched.h>
+#include <asm/cycles.h>
+
+#define TIMEKEEPING_CHECK_DELAY (100 * NSEC_PER_MSEC) /* 0.1 sec */
+#define TIMEKEEPING_MAX_DELAY (500 * NSEC_PER_MSEC) /* 0.5 sec */
+
+static long jiffies_snap;
+static u64 clock_snap;
+static int warned;
+static DEFINE_PER_CPU(bool, selftest_running) = true;
+
+static struct perf_event_attr event_hw_attr = {
+	.type		= PERF_TYPE_HARDWARE,
+	.config		= PERF_COUNT_HW_CPU_CYCLES,
+	.size		= sizeof(struct perf_event_attr),
+	.pinned		= 1,
+};
+
+static DEFINE_PER_CPU(struct perf_event *, cpu_event);
+
+static void timekeeping_missing_warn(long jiffies_old, u64 clock_old,
+				     long jiffies_now, u64 clock_now)
+{
+	unsigned int nsecs;
+
+	pr_err("INFO: Suspicion of missing timekeeping update\n");
+	nsecs = do_div(clock_old, NSEC_PER_SEC);
+	pr_err("Jiffies last update at %llu.%u with jiffies=%ld\n", clock_old, nsecs, jiffies_old);
+	nsecs = do_div(clock_now, NSEC_PER_SEC);
+	pr_err("Now is %llu.%u, and jiffies = %ld\n", clock_now, nsecs, jiffies_now);
+	WARN_ON(1);
+}
+
+static void selftest_event_overflow(struct perf_event *event,
+				    struct perf_sample_data *data,
+				    struct pt_regs *regs)
+{
+	long jiffies_now, jiffies_old;
+	u64 clock_now, clock_old;
+	s64 old_diff, new_diff;
+	int seq;
+
+	/* Quick check if already warned, stop there */
+	if (warned)
+		return;
+
+	/* Allow out of date jiffies on sleeping CPUs */
+	if (!__this_cpu_read(selftest_running))
+		return;
+
+	/*
+	 * If we race with a jiffies updater, we can't wait for it
+	 * as it may well be the current CPU
+	 */
+	seq = raw_seqbegin(&jiffies_lock);
+
+	jiffies_old = jiffies_snap;
+	clock_old = clock_snap;
+
+	jiffies_now = ACCESS_ONCE(jiffies);
+	clock_now = sched_clock_cpu(0);
+
+	old_diff = (s64)clock_snap - jiffies_to_nsecs(jiffies_snap);
+	new_diff = (s64)clock_now - jiffies_to_nsecs(jiffies_now);
+
+	if (abs(new_diff - old_diff) < TIMEKEEPING_MAX_DELAY)
+		return;
+
+	/* Abort if we raced with a snapshot updater */
+	if (read_seqretry(&jiffies_lock, seq))
+		return;
+
+	if (!xchg(&warned, 1))
+		timekeeping_missing_warn(jiffies_old, clock_old, jiffies_now, clock_now);
+}
+
+/*
+ * Called under jiffies lock, so NMIs don't see half way updates
+ */
+void timekeeping_selftest_update(void)
+{
+	jiffies_snap = jiffies;
+	/*
+	 * sched_clock_cpu(random constant nr) is used to mimic a global
+	 * monotonic clock. It's a hacky equivalent to trace_clock_global().
+	 * We need that to compare two snapshots reliably.
+	 */
+	clock_snap = sched_clock_cpu(0);
+}
+
+void timekeeping_selftest_start(void)
+{
+	__this_cpu_write(selftest_running, true);
+}
+
+void timekeeping_selftest_stop(void)
+{
+	__this_cpu_write(selftest_running, false);
+}
+
+static int __init timekeeping_selftest_init(void)
+{
+	int cpu;
+
+	event_hw_attr.sample_period = nsecs_to_cycles(TIMEKEEPING_CHECK_DELAY);
+
+	/* TODO: proper CPU hotplug handling ?*/
+	get_online_cpus();
+
+	for_each_online_cpu(cpu) {
+		struct perf_event *event;
+		event = perf_event_create_kernel_counter(&event_hw_attr, cpu, NULL,
+							 selftest_event_overflow, NULL);
+		if (event)
+			per_cpu(cpu_event, cpu) = event;
+	}
+
+	put_online_cpus();
+
+	return 0;
+}
+core_initcall(timekeeping_selftest_init);
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 568179d..419f2e9 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -788,6 +788,18 @@ config TIMER_STATS
 	  (it defaults to deactivated on bootup and will only be activated
 	  if some application like powertop activates it explicitly).
 
+config DEBUG_TIMEKEEPING
+	bool "Debug timekeeping"
+	depends on HAVE_SCHED_CLOCK_NMI
+	depends on PERF_EVENTS && HAVE_PERF_EVENTS_NMI && HAVE_NSECS_TO_CYCLES
+	help
+	  This enables detection of missing timekeeping updates. This option
+	  is mostly useful to check the correctness of the full system idle
+	  detection used by full dynticks to adaptively run the timekeeper
+	  in order to keep reasonable power consumption. But it can also be
+	  used anytime to ensure that timekeeping is correctly moving foward
+	  when it is expected to.
+
 config DEBUG_PREEMPT
 	bool "Debug preemptible kernel"
 	depends on DEBUG_KERNEL && PREEMPT && TRACE_IRQFLAGS_SUPPORT
-- 
1.7.5.4

