Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753814Ab3C0PdI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 11:33:08 -0400
Received: from mail-vb0-f47.google.com ([209.85.212.47]:39392 "EHLO
	mail-vb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753660Ab3C0PdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 11:33:05 -0400
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
Subject: [PATCH 3/4] nohz: Ensure full dynticks CPUs are RCU nocbs
Date: Wed, 27 Mar 2013 16:32:38 +0100
Message-Id: <1364398359-21990-4-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1364398359-21990-1-git-send-email-fweisbec@gmail.com>
References: <1364398359-21990-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need full dynticks CPU to also be RCU nocb so
that we don't have to keep the tick to handle RCU
callbacks.

Make sure the range passed to nohz_extended= boot
parameter is a subset of rcu_nocbs=

The CPUs that fail to meet this requirement will be
excluded from the nohz_extended range. This is checked
early in boot time, before any CPU has the opportunity
to stop its tick.

Suggested-by: Steven Rostedt <rostedt@goodmis.org>
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
---
 Documentation/kernel-parameters.txt |    2 ++
 include/linux/rcupdate.h            |    7 +++++++
 include/linux/tick.h                |    2 ++
 init/main.c                         |    1 +
 kernel/rcutree.c                    |    6 +++---
 kernel/rcutree.h                    |    1 -
 kernel/rcutree_plugin.h             |   13 ++++---------
 kernel/time/tick-sched.c            |   16 +++++++++++-----
 8 files changed, 30 insertions(+), 18 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 28e039c..80d17d0 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1918,6 +1918,8 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			the specified list of CPUs whose tick will be stopped
 			whenever possible. The boot CPU will be forced outside
 			the range to maintain the timekeeping.
+			The CPUs in this range must also be included in the
+			rcu_nocbs= set.
 
 	noiotrap	[SH] Disables trapped I/O port accesses.
 
diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index b758ce1..8e0948c 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -999,4 +999,11 @@ static inline notrace void rcu_read_unlock_sched_notrace(void)
 #define kfree_rcu(ptr, rcu_head)					\
 	__kfree_rcu(&((ptr)->rcu_head), offsetof(typeof(*(ptr)), rcu_head))
 
+#ifdef CONFIG_RCU_NOCB_CPU
+extern bool rcu_is_nocb_cpu(int cpu);
+#else
+static inline bool rcu_is_nocb_cpu(int cpu) { return false; }
+#endif /* #else #ifdef CONFIG_RCU_NOCB_CPU */
+
+
 #endif /* __LINUX_RCUPDATE_H */
diff --git a/include/linux/tick.h b/include/linux/tick.h
index 44bfa8a..7484034 100644
--- a/include/linux/tick.h
+++ b/include/linux/tick.h
@@ -158,8 +158,10 @@ static inline u64 get_cpu_iowait_time_us(int cpu, u64 *unused) { return -1; }
 # endif /* !NO_HZ */
 
 #ifdef CONFIG_NO_HZ_EXTENDED
+extern void tick_nohz_init(void);
 extern int tick_nohz_extended_cpu(int cpu);
 #else
+static inline void tick_nohz_init(void) { }
 static inline int tick_nohz_extended_cpu(int cpu) { return 0; }
 #endif
 
diff --git a/init/main.c b/init/main.c
index 63534a1..2acb5bb 100644
--- a/init/main.c
+++ b/init/main.c
@@ -547,6 +547,7 @@ asmlinkage void __init start_kernel(void)
 	idr_init_cache();
 	perf_event_init();
 	rcu_init();
+	tick_nohz_init();
 	radix_tree_init();
 	/* init some links before init_ISA_irqs() */
 	early_irq_init();
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 5b8ad82..7cd29b9 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1685,7 +1685,7 @@ rcu_send_cbs_to_orphanage(int cpu, struct rcu_state *rsp,
 			  struct rcu_node *rnp, struct rcu_data *rdp)
 {
 	/* No-CBs CPUs do not have orphanable callbacks. */
-	if (is_nocb_cpu(rdp->cpu))
+	if (rcu_is_nocb_cpu(rdp->cpu))
 		return;
 
 	/*
@@ -2747,10 +2747,10 @@ static void _rcu_barrier(struct rcu_state *rsp)
 	 * corresponding CPU's preceding callbacks have been invoked.
 	 */
 	for_each_possible_cpu(cpu) {
-		if (!cpu_online(cpu) && !is_nocb_cpu(cpu))
+		if (!cpu_online(cpu) && !rcu_is_nocb_cpu(cpu))
 			continue;
 		rdp = per_cpu_ptr(rsp->rda, cpu);
-		if (is_nocb_cpu(cpu)) {
+		if (rcu_is_nocb_cpu(cpu)) {
 			_rcu_barrier_trace(rsp, "OnlineNoCB", cpu,
 					   rsp->n_barrier_done);
 			atomic_inc(&rsp->barrier_cpu_count);
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index c896b50..57300ad 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -529,7 +529,6 @@ static void print_cpu_stall_info(struct rcu_state *rsp, int cpu);
 static void print_cpu_stall_info_end(void);
 static void zero_cpu_stall_ticks(struct rcu_data *rdp);
 static void increment_cpu_stall_ticks(void);
-static bool is_nocb_cpu(int cpu);
 static bool __call_rcu_nocb(struct rcu_data *rdp, struct rcu_head *rhp,
 			    bool lazy);
 static bool rcu_nocb_adopt_orphan_cbs(struct rcu_state *rsp,
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index c1cc7e1..1dec0b2 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -2166,7 +2166,7 @@ static int __init parse_rcu_nocb_poll(char *arg)
 early_param("rcu_nocb_poll", parse_rcu_nocb_poll);
 
 /* Is the specified CPU a no-CPUs CPU? */
-static bool is_nocb_cpu(int cpu)
+bool rcu_is_nocb_cpu(int cpu)
 {
 	if (have_rcu_nocb_mask)
 		return cpumask_test_cpu(cpu, rcu_nocb_mask);
@@ -2224,7 +2224,7 @@ static bool __call_rcu_nocb(struct rcu_data *rdp, struct rcu_head *rhp,
 			    bool lazy)
 {
 
-	if (!is_nocb_cpu(rdp->cpu))
+	if (!rcu_is_nocb_cpu(rdp->cpu))
 		return 0;
 	__call_rcu_nocb_enqueue(rdp, rhp, &rhp->next, 1, lazy);
 	return 1;
@@ -2241,7 +2241,7 @@ static bool __maybe_unused rcu_nocb_adopt_orphan_cbs(struct rcu_state *rsp,
 	long qll = rsp->qlen_lazy;
 
 	/* If this is not a no-CBs CPU, tell the caller to do it the old way. */
-	if (!is_nocb_cpu(smp_processor_id()))
+	if (!rcu_is_nocb_cpu(smp_processor_id()))
 		return 0;
 	rsp->qlen = 0;
 	rsp->qlen_lazy = 0;
@@ -2281,7 +2281,7 @@ static bool nocb_cpu_expendable(int cpu)
 	 * If there are no no-CB CPUs or if this CPU is not a no-CB CPU,
 	 * then offlining this CPU is harmless.  Let it happen.
 	 */
-	if (!have_rcu_nocb_mask || is_nocb_cpu(cpu))
+	if (!have_rcu_nocb_mask || rcu_is_nocb_cpu(cpu))
 		return 1;
 
 	/* If no memory, play it safe and keep the CPU around. */
@@ -2463,11 +2463,6 @@ static void __init rcu_init_nocb(void)
 
 #else /* #ifdef CONFIG_RCU_NOCB_CPU */
 
-static bool is_nocb_cpu(int cpu)
-{
-	return false;
-}
-
 static bool __call_rcu_nocb(struct rcu_data *rdp, struct rcu_head *rhp,
 			    bool lazy)
 {
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 1eb0e35..a76d95e 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -203,21 +203,27 @@ static int __cpuinit tick_nohz_cpu_down_callback(struct notifier_block *nfb,
  */
 static char __initdata nohz_ext_buf[NR_CPUS + 1];
 
-static int __init init_tick_nohz_extended(void)
+void __init tick_nohz_init(void)
 {
 	int cpu;
 
 	if (!have_nohz_extended_mask)
-		return 0;
+		return;
 
 	cpu_notifier(tick_nohz_cpu_down_callback, 0);
 
+	/* Make sure full dynticks CPU are also RCU nocbs */
+	for_each_cpu(cpu, nohz_extended_mask) {
+		if (!rcu_is_nocb_cpu(cpu)) {
+			pr_warning("NO_HZ: CPU %d is not RCU nocb: "
+				   "cleared from nohz_extended range", cpu);
+			cpumask_clear_cpu(cpu, nohz_extended_mask);
+		}
+	}
+
 	cpulist_scnprintf(nohz_ext_buf, sizeof(nohz_ext_buf), nohz_extended_mask);
 	pr_info("NO_HZ: Experimental full dynticks CPUs: %s.\n", nohz_ext_buf);
-
-	return 0;
 }
-core_initcall(init_tick_nohz_extended);
 #else
 #define have_nohz_extended_mask (0)
 #endif
-- 
1.7.5.4

