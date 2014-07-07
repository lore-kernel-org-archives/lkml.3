Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753339AbaGGWkK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 18:40:10 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:57489 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752689AbaGGWic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 18:38:32 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 11/17] rcu: Bind grace-period kthreads to non-NO_HZ_FULL CPUs
Date: Mon,  7 Jul 2014 15:38:15 -0700
Message-Id: <1404772701-8804-11-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1404772701-8804-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140707223756.GA7187@linux.vnet.ibm.com>
 <1404772701-8804-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14070722-8236-0000-0000-000003A71C88
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Binding the grace-period kthreads to the timekeeping CPU resulted in
significant performance decreases for some workloads.  For more detail,
see:

https://lkml.org/lkml/2014/6/3/395 for benchmark numbers

https://lkml.org/lkml/2014/6/4/218 for CPU statistics

It turns out that it is necessary to bind the grace-period kthreads
to the timekeeping CPU only when all but CPU 0 is a nohz_full CPU
on the one hand or if CONFIG_NO_HZ_FULL_SYSIDLE=y on the other.
In other cases, it suffices to bind the grace-period kthreads to the
set of non-nohz_full CPUs.

This commit therefore creates a tick_nohz_not_full_mask that is the
complement of tick_nohz_full_mask, and then binds the grace-period
kthread to the set of CPUs indicated by this new mask, which covers
the CONFIG_NO_HZ_FULL_SYSIDLE=n case.  The CONFIG_NO_HZ_FULL_SYSIDLE=y
case still binds the grace-period kthreads to the timekeeping CPU.
This commit also includes the tick_nohz_full_enabled() check suggested
by Frederic Weisbecker.

Reported-by: Jet Chen <jet.chen@intel.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
[ paulmck: Created housekeeping_affine() per fweisbec feedback. ]
---
 include/linux/tick.h     | 19 +++++++++++++++++++
 kernel/rcu/tree_plugin.h | 14 +++++++++-----
 kernel/time/tick-sched.c | 10 ++++++++++
 3 files changed, 38 insertions(+), 5 deletions(-)

diff --git a/include/linux/tick.h b/include/linux/tick.h
index b84773cb9f4c..c39af3261351 100644
--- a/include/linux/tick.h
+++ b/include/linux/tick.h
@@ -12,6 +12,7 @@
 #include <linux/hrtimer.h>
 #include <linux/context_tracking_state.h>
 #include <linux/cpumask.h>
+#include <linux/sched.h>
 
 #ifdef CONFIG_GENERIC_CLOCKEVENTS
 
@@ -162,6 +163,7 @@ static inline u64 get_cpu_iowait_time_us(int cpu, u64 *unused) { return -1; }
 #ifdef CONFIG_NO_HZ_FULL
 extern bool tick_nohz_full_running;
 extern cpumask_var_t tick_nohz_full_mask;
+extern cpumask_var_t tick_nohz_not_full_mask;
 
 static inline bool tick_nohz_full_enabled(void)
 {
@@ -194,6 +196,23 @@ static inline void tick_nohz_full_kick_all(void) { }
 static inline void __tick_nohz_task_switch(struct task_struct *tsk) { }
 #endif
 
+static inline bool is_housekeeping_cpu(int cpu)
+{
+#ifdef CONFIG_NO_HZ_FULL
+	if (tick_nohz_full_enabled())
+		return cpumask_test_cpu(cpu, tick_nohz_not_full_mask);
+#endif
+	return true;
+}
+
+static inline void housekeeping_affine(struct task_struct *t)
+{
+#ifdef CONFIG_NO_HZ_FULL
+	if (tick_nohz_full_enabled())
+		set_cpus_allowed_ptr(t, tick_nohz_not_full_mask);
+#endif
+}
+
 static inline void tick_nohz_full_check(void)
 {
 	if (tick_nohz_full_enabled())
diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index 719587af7b10..b39ba7239bd6 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -2846,12 +2846,16 @@ static bool rcu_nohz_full_cpu(struct rcu_state *rsp)
  */
 static void rcu_bind_gp_kthread(void)
 {
-#ifdef CONFIG_NO_HZ_FULL
-	int cpu = tick_do_timer_cpu;
+	int __maybe_unused cpu;
 
-	if (cpu < 0 || cpu >= nr_cpu_ids)
+	if (!tick_nohz_full_enabled())
 		return;
-	if (raw_smp_processor_id() != cpu)
+#ifdef CONFIG_NO_HZ_FULL_SYSIDLE
+	cpu = tick_do_timer_cpu;
+	if (cpu >= 0 && cpu < nr_cpu_ids && raw_smp_processor_id() != cpu)
 		set_cpus_allowed_ptr(current, cpumask_of(cpu));
-#endif /* #ifdef CONFIG_NO_HZ_FULL */
+#else /* #ifdef CONFIG_NO_HZ_FULL_SYSIDLE */
+	if (!is_housekeeping_cpu(raw_smp_processor_id()))
+		housekeeping_affine(current);
+#endif /* #else #ifdef CONFIG_NO_HZ_FULL_SYSIDLE */
 }
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 6558b7ac112d..e023134d63a1 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -154,6 +154,7 @@ static void tick_sched_handle(struct tick_sched *ts, struct pt_regs *regs)
 
 #ifdef CONFIG_NO_HZ_FULL
 cpumask_var_t tick_nohz_full_mask;
+cpumask_var_t tick_nohz_not_full_mask;
 bool tick_nohz_full_running;
 
 static bool can_stop_full_tick(void)
@@ -281,6 +282,7 @@ static int __init tick_nohz_full_setup(char *str)
 	int cpu;
 
 	alloc_bootmem_cpumask_var(&tick_nohz_full_mask);
+	alloc_bootmem_cpumask_var(&tick_nohz_not_full_mask);
 	if (cpulist_parse(str, tick_nohz_full_mask) < 0) {
 		pr_warning("NOHZ: Incorrect nohz_full cpumask\n");
 		return 1;
@@ -291,6 +293,8 @@ static int __init tick_nohz_full_setup(char *str)
 		pr_warning("NO_HZ: Clearing %d from nohz_full range for timekeeping\n", cpu);
 		cpumask_clear_cpu(cpu, tick_nohz_full_mask);
 	}
+	cpumask_andnot(tick_nohz_not_full_mask,
+		       cpu_possible_mask, tick_nohz_full_mask);
 	tick_nohz_full_running = true;
 
 	return 1;
@@ -332,9 +336,15 @@ static int tick_nohz_init_all(void)
 		pr_err("NO_HZ: Can't allocate full dynticks cpumask\n");
 		return err;
 	}
+	if (!alloc_cpumask_var(&tick_nohz_not_full_mask, GFP_KERNEL)) {
+		pr_err("NO_HZ: Can't allocate not-full dynticks cpumask\n");
+		return err;
+	}
 	err = 0;
 	cpumask_setall(tick_nohz_full_mask);
 	cpumask_clear_cpu(smp_processor_id(), tick_nohz_full_mask);
+	cpumask_clear(tick_nohz_not_full_mask);
+	cpumask_set_cpu(smp_processor_id(), tick_nohz_not_full_mask);
 	tick_nohz_full_running = true;
 #endif
 	return err;
-- 
1.8.1.5

