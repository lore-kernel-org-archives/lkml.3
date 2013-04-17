Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755645Ab3DQQZd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 12:25:33 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:46023 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753828Ab3DQQZB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 12:25:01 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Kevin Hilman <khilman@linaro.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 2/3] nohz: Ensure full dynticks CPUs are RCU nocbs
Date: Wed, 17 Apr 2013 18:24:48 +0200
Message-Id: <1366215889-2635-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1366215889-2635-1-git-send-email-fweisbec@gmail.com>
References: <1366215889-2635-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need full dynticks CPU to also be RCU nocb so
that we don't have to keep the tick to handle RCU
callbacks.

Make sure the range passed to nohz_full= boot
parameter is a subset of rcu_nocbs=

The CPUs that fail to meet this requirement will be
excluded from the nohz_full range. This is checked
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
 kernel/time/tick-sched.c            |   22 ++++++++++++++++------
 8 files changed, 35 insertions(+), 19 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 887b297..4865e9b 100644
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
index b4e3b0c..0b6873c 100644
--- a/include/linux/tick.h
+++ b/include/linux/tick.h
@@ -158,8 +158,10 @@ static inline u64 get_cpu_iowait_time_us(int cpu, u64 *unused) { return -1; }
 # endif /* !CONFIG_NO_HZ_COMMON */
 
 #ifdef CONFIG_NO_HZ_FULL
+extern void tick_nohz_init(void);
 extern int tick_nohz_full_cpu(int cpu);
 #else
+static inline void tick_nohz_init(void) { }
 static inline int tick_nohz_full_cpu(int cpu) { return 0; }
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
index f5ab502..1d4ceff 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1695,7 +1695,7 @@ rcu_send_cbs_to_orphanage(int cpu, struct rcu_state *rsp,
 			  struct rcu_node *rnp, struct rcu_data *rdp)
 {
 	/* No-CBs CPUs do not have orphanable callbacks. */
-	if (is_nocb_cpu(rdp->cpu))
+	if (rcu_is_nocb_cpu(rdp->cpu))
 		return;
 
 	/*
@@ -2757,10 +2757,10 @@ static void _rcu_barrier(struct rcu_state *rsp)
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
index f993c0a..38acc49 100644
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
index a5745e9..0cd91cc 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -2167,7 +2167,7 @@ static int __init parse_rcu_nocb_poll(char *arg)
 early_param("rcu_nocb_poll", parse_rcu_nocb_poll);
 
 /* Is the specified CPU a no-CPUs CPU? */
-static bool is_nocb_cpu(int cpu)
+bool rcu_is_nocb_cpu(int cpu)
 {
 	if (have_rcu_nocb_mask)
 		return cpumask_test_cpu(cpu, rcu_nocb_mask);
@@ -2225,7 +2225,7 @@ static bool __call_rcu_nocb(struct rcu_data *rdp, struct rcu_head *rhp,
 			    bool lazy)
 {
 
-	if (!is_nocb_cpu(rdp->cpu))
+	if (!rcu_is_nocb_cpu(rdp->cpu))
 		return 0;
 	__call_rcu_nocb_enqueue(rdp, rhp, &rhp->next, 1, lazy);
 	return 1;
@@ -2242,7 +2242,7 @@ static bool __maybe_unused rcu_nocb_adopt_orphan_cbs(struct rcu_state *rsp,
 	long qll = rsp->qlen_lazy;
 
 	/* If this is not a no-CBs CPU, tell the caller to do it the old way. */
-	if (!is_nocb_cpu(smp_processor_id()))
+	if (!rcu_is_nocb_cpu(smp_processor_id()))
 		return 0;
 	rsp->qlen = 0;
 	rsp->qlen_lazy = 0;
@@ -2282,7 +2282,7 @@ static bool nocb_cpu_expendable(int cpu)
 	 * If there are no no-CB CPUs or if this CPU is not a no-CB CPU,
 	 * then offlining this CPU is harmless.  Let it happen.
 	 */
-	if (!have_rcu_nocb_mask || is_nocb_cpu(cpu))
+	if (!have_rcu_nocb_mask || rcu_is_nocb_cpu(cpu))
 		return 1;
 
 	/* If no memory, play it safe and keep the CPU around. */
@@ -2464,11 +2464,6 @@ static void __init rcu_init_nocb(void)
 
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
index 2bac5ea..d71a5f2 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -203,17 +203,27 @@ static int __cpuinit tick_nohz_cpu_down_callback(struct notifier_block *nfb,
  */
 static char __initdata nohz_full_buf[NR_CPUS + 1];
 
-static int __init init_tick_nohz_full(void)
+void __init tick_nohz_init(void)
 {
-	if (have_nohz_full_mask)
-		cpu_notifier(tick_nohz_cpu_down_callback, 0);
+	int cpu;
+
+	if (!have_nohz_full_mask)
+		return;
+
+	cpu_notifier(tick_nohz_cpu_down_callback, 0);
+
+	/* Make sure full dynticks CPU are also RCU nocbs */
+	for_each_cpu(cpu, nohz_full_mask) {
+		if (!rcu_is_nocb_cpu(cpu)) {
+			pr_warning("NO_HZ: CPU %d is not RCU nocb: "
+				   "cleared from nohz_full range", cpu);
+			cpumask_clear_cpu(cpu, nohz_full_mask);
+		}
+	}
 
 	cpulist_scnprintf(nohz_full_buf, sizeof(nohz_full_buf), nohz_full_mask);
 	pr_info("NO_HZ: Full dynticks CPUs: %s.\n", nohz_full_buf);
-
-	return 0;
 }
-core_initcall(init_tick_nohz_full);
 #else
 #define have_nohz_full_mask (0)
 #endif
-- 
1.7.5.4

