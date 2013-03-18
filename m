Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933748Ab3CRVk7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 17:40:59 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:57722 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933134Ab3CRVhB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 17:37:01 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 01/15] rcu: Remove restrictions on no-CBs CPUs
Date: Mon, 18 Mar 2013 14:36:36 -0700
Message-Id: <1363642610-21390-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <20130318213608.GA20296@linux.vnet.ibm.com>
References: <20130318213608.GA20296@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13031821-5406-0000-0000-0000067F0C17
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paul.mckenney@linaro.org>

Currently, CPU 0 is constrained to not be a no-CBs CPU, and furthermore
at least one no-CBs CPU must remain online at any given time.  These
restrictions are problematic in some situations, such as cases where
all CPUs must run a real-time workload that needs to be insulated from
OS jitter and latencies due to RCU callback invocation.  This commit
therefore provides no-CBs CPUs a (very crude and energy-inefficient)
way to start and to wait for grace periods independently of the normal
RCU callback mechanisms.  This approach allows any or all of the CPUs to
be designated as no-CBs CPUs, and allows any proper subset of the CPUs
(whether no-CBs CPUs or not) to be offlined.

This commit also provides a fix for a locking bug spotted by Xie
ChanglongX <changlongx.xie@intel.com>.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 init/Kconfig            |   4 +-
 kernel/rcutree.c        |  14 ++---
 kernel/rcutree.h        |  12 +---
 kernel/rcutree_plugin.h | 156 ++++++++++++++----------------------------------
 4 files changed, 57 insertions(+), 129 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index 22616cd..c8bd349 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -655,7 +655,7 @@ config RCU_BOOST_DELAY
 	  Accept the default if unsure.
 
 config RCU_NOCB_CPU
-	bool "Offload RCU callback processing from boot-selected CPUs"
+	bool "Offload RCU callback processing from boot-selected CPUs (EXPERIMENTAL"
 	depends on TREE_RCU || TREE_PREEMPT_RCU
 	default n
 	help
@@ -673,7 +673,7 @@ config RCU_NOCB_CPU
 	  callback, and (2) affinity or cgroups can be used to force
 	  the kthreads to run on whatever set of CPUs is desired.
 
-	  Say Y here if you want reduced OS jitter on selected CPUs.
+	  Say Y here if you want to help to debug reduced OS jitter.
 	  Say N here if you are unsure.
 
 endmenu # "RCU Subsystem"
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 5b8ad82..6ad0716 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -310,6 +310,8 @@ cpu_needs_another_gp(struct rcu_state *rsp, struct rcu_data *rdp)
 
 	if (rcu_gp_in_progress(rsp))
 		return 0;  /* No, a grace period is already in progress. */
+	if (rcu_nocb_needs_gp(rdp))
+		return 1;  /* Yes, a no-CBs CPU needs one. */
 	if (!rdp->nxttail[RCU_NEXT_TAIL])
 		return 0;  /* No, this is a no-CBs (or offline) CPU. */
 	if (*rdp->nxttail[RCU_NEXT_READY_TAIL])
@@ -1035,10 +1037,11 @@ static void init_callback_list(struct rcu_data *rdp)
 {
 	int i;
 
+	if (init_nocb_callback_list(rdp))
+		return;
 	rdp->nxtlist = NULL;
 	for (i = 0; i < RCU_NEXT_SIZE; i++)
 		rdp->nxttail[i] = &rdp->nxtlist;
-	init_nocb_callback_list(rdp);
 }
 
 /*
@@ -2909,7 +2912,6 @@ static int __cpuinit rcu_cpu_notify(struct notifier_block *self,
 	struct rcu_data *rdp = per_cpu_ptr(rcu_state->rda, cpu);
 	struct rcu_node *rnp = rdp->mynode;
 	struct rcu_state *rsp;
-	int ret = NOTIFY_OK;
 
 	trace_rcu_utilization("Start CPU hotplug");
 	switch (action) {
@@ -2923,10 +2925,7 @@ static int __cpuinit rcu_cpu_notify(struct notifier_block *self,
 		rcu_boost_kthread_setaffinity(rnp, -1);
 		break;
 	case CPU_DOWN_PREPARE:
-		if (nocb_cpu_expendable(cpu))
-			rcu_boost_kthread_setaffinity(rnp, cpu);
-		else
-			ret = NOTIFY_BAD;
+		rcu_boost_kthread_setaffinity(rnp, cpu);
 		break;
 	case CPU_DYING:
 	case CPU_DYING_FROZEN:
@@ -2950,7 +2949,7 @@ static int __cpuinit rcu_cpu_notify(struct notifier_block *self,
 		break;
 	}
 	trace_rcu_utilization("End CPU hotplug");
-	return ret;
+	return NOTIFY_OK;
 }
 
 /*
@@ -3170,7 +3169,6 @@ void __init rcu_init(void)
 	rcu_init_one(&rcu_sched_state, &rcu_sched_data);
 	rcu_init_one(&rcu_bh_state, &rcu_bh_data);
 	__rcu_init_preempt();
-	rcu_init_nocb();
 	 open_softirq(RCU_SOFTIRQ, rcu_process_callbacks);
 
 	/*
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index c896b50..7af39f4 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -326,6 +326,7 @@ struct rcu_data {
 	int nocb_p_count_lazy;		/*  (approximate). */
 	wait_queue_head_t nocb_wq;	/* For nocb kthreads to sleep on. */
 	struct task_struct *nocb_kthread;
+	bool nocb_needs_gp;
 #endif /* #ifdef CONFIG_RCU_NOCB_CPU */
 
 	int cpu;
@@ -375,12 +376,6 @@ struct rcu_state {
 	struct rcu_data __percpu *rda;		/* pointer of percu rcu_data. */
 	void (*call)(struct rcu_head *head,	/* call_rcu() flavor. */
 		     void (*func)(struct rcu_head *head));
-#ifdef CONFIG_RCU_NOCB_CPU
-	void (*call_remote)(struct rcu_head *head,
-		     void (*func)(struct rcu_head *head));
-						/* call_rcu() flavor, but for */
-						/*  placing on remote CPU. */
-#endif /* #ifdef CONFIG_RCU_NOCB_CPU */
 
 	/* The following fields are guarded by the root rcu_node's lock. */
 
@@ -529,16 +524,15 @@ static void print_cpu_stall_info(struct rcu_state *rsp, int cpu);
 static void print_cpu_stall_info_end(void);
 static void zero_cpu_stall_ticks(struct rcu_data *rdp);
 static void increment_cpu_stall_ticks(void);
+static int rcu_nocb_needs_gp(struct rcu_data *rdp);
 static bool is_nocb_cpu(int cpu);
 static bool __call_rcu_nocb(struct rcu_data *rdp, struct rcu_head *rhp,
 			    bool lazy);
 static bool rcu_nocb_adopt_orphan_cbs(struct rcu_state *rsp,
 				      struct rcu_data *rdp);
-static bool nocb_cpu_expendable(int cpu);
 static void rcu_boot_init_nocb_percpu_data(struct rcu_data *rdp);
 static void rcu_spawn_nocb_kthreads(struct rcu_state *rsp);
-static void init_nocb_callback_list(struct rcu_data *rdp);
-static void __init rcu_init_nocb(void);
+static bool init_nocb_callback_list(struct rcu_data *rdp);
 
 #endif /* #ifndef RCU_TREE_NONCORE */
 
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index c1cc7e1..44f958a 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -86,10 +86,6 @@ static void __init rcu_bootup_announce_oddness(void)
 		printk(KERN_INFO "\tRCU restricting CPUs from NR_CPUS=%d to nr_cpu_ids=%d.\n", NR_CPUS, nr_cpu_ids);
 #ifdef CONFIG_RCU_NOCB_CPU
 	if (have_rcu_nocb_mask) {
-		if (cpumask_test_cpu(0, rcu_nocb_mask)) {
-			cpumask_clear_cpu(0, rcu_nocb_mask);
-			pr_info("\tCPU 0: illegal no-CBs CPU (cleared).\n");
-		}
 		cpulist_scnprintf(nocb_buf, sizeof(nocb_buf), rcu_nocb_mask);
 		pr_info("\tExperimental no-CBs CPUs: %s.\n", nocb_buf);
 		if (rcu_nocb_poll)
@@ -2165,6 +2161,14 @@ static int __init parse_rcu_nocb_poll(char *arg)
 }
 early_param("rcu_nocb_poll", parse_rcu_nocb_poll);
 
+/*
+ * Does this CPU needs a grace period due to offloaded callbacks?
+ */
+static int rcu_nocb_needs_gp(struct rcu_data *rdp)
+{
+	return rdp->nocb_needs_gp;
+}
+
 /* Is the specified CPU a no-CPUs CPU? */
 static bool is_nocb_cpu(int cpu)
 {
@@ -2265,95 +2269,39 @@ static bool __maybe_unused rcu_nocb_adopt_orphan_cbs(struct rcu_state *rsp,
 }
 
 /*
- * There must be at least one non-no-CBs CPU in operation at any given
- * time, because no-CBs CPUs are not capable of initiating grace periods
- * independently.  This function therefore complains if the specified
- * CPU is the last non-no-CBs CPU, allowing the CPU-hotplug system to
- * avoid offlining the last such CPU.  (Recursion is a wonderful thing,
- * but you have to have a base case!)
+ * If necessary, kick off a new grace period, and either way wait
+ * for a subsequent grace period to complete.
  */
-static bool nocb_cpu_expendable(int cpu)
+static void rcu_nocb_wait_gp(struct rcu_data *rdp)
 {
-	cpumask_var_t non_nocb_cpus;
-	int ret;
+	unsigned long c;
+	unsigned long flags;
+	unsigned long j;
+	struct rcu_node *rnp = rdp->mynode;
+
+	raw_spin_lock_irqsave(&rnp->lock, flags);
+	c = rnp->completed + 2;
+	rdp->nocb_needs_gp = true;
+	raw_spin_unlock_irqrestore(&rnp->lock, flags);
 
 	/*
-	 * If there are no no-CB CPUs or if this CPU is not a no-CB CPU,
-	 * then offlining this CPU is harmless.  Let it happen.
+	 * Wait for the grace period.  Do so interruptibly to avoid messing
+	 * up the load average.
 	 */
-	if (!have_rcu_nocb_mask || is_nocb_cpu(cpu))
-		return 1;
-
-	/* If no memory, play it safe and keep the CPU around. */
-	if (!alloc_cpumask_var(&non_nocb_cpus, GFP_NOIO))
-		return 0;
-	cpumask_andnot(non_nocb_cpus, cpu_online_mask, rcu_nocb_mask);
-	cpumask_clear_cpu(cpu, non_nocb_cpus);
-	ret = !cpumask_empty(non_nocb_cpus);
-	free_cpumask_var(non_nocb_cpus);
-	return ret;
-}
-
-/*
- * Helper structure for remote registry of RCU callbacks.
- * This is needed for when a no-CBs CPU needs to start a grace period.
- * If it just invokes call_rcu(), the resulting callback will be queued,
- * which can result in deadlock.
- */
-struct rcu_head_remote {
-	struct rcu_head *rhp;
-	call_rcu_func_t *crf;
-	void (*func)(struct rcu_head *rhp);
-};
-
-/*
- * Register a callback as specified by the rcu_head_remote struct.
- * This function is intended to be invoked via smp_call_function_single().
- */
-static void call_rcu_local(void *arg)
-{
-	struct rcu_head_remote *rhrp =
-		container_of(arg, struct rcu_head_remote, rhp);
-
-	rhrp->crf(rhrp->rhp, rhrp->func);
-}
-
-/*
- * Set up an rcu_head_remote structure and the invoke call_rcu_local()
- * on CPU 0 (which is guaranteed to be a non-no-CBs CPU) via
- * smp_call_function_single().
- */
-static void invoke_crf_remote(struct rcu_head *rhp,
-			      void (*func)(struct rcu_head *rhp),
-			      call_rcu_func_t crf)
-{
-	struct rcu_head_remote rhr;
-
-	rhr.rhp = rhp;
-	rhr.crf = crf;
-	rhr.func = func;
-	smp_call_function_single(0, call_rcu_local, &rhr, 1);
-}
-
-/*
- * Helper functions to be passed to wait_rcu_gp(), each of which
- * invokes invoke_crf_remote() to register a callback appropriately.
- */
-static void __maybe_unused
-call_rcu_preempt_remote(struct rcu_head *rhp,
-			void (*func)(struct rcu_head *rhp))
-{
-	invoke_crf_remote(rhp, func, call_rcu);
-}
-static void call_rcu_bh_remote(struct rcu_head *rhp,
-			       void (*func)(struct rcu_head *rhp))
-{
-	invoke_crf_remote(rhp, func, call_rcu_bh);
-}
-static void call_rcu_sched_remote(struct rcu_head *rhp,
-				  void (*func)(struct rcu_head *rhp))
-{
-	invoke_crf_remote(rhp, func, call_rcu_sched);
+	for (;;) {
+		j = jiffies;
+		schedule_timeout_interruptible(2);
+		raw_spin_lock_irqsave(&rnp->lock, flags);
+		if (ULONG_CMP_GE(rnp->completed, c)) {
+			rdp->nocb_needs_gp = false;
+			raw_spin_unlock_irqrestore(&rnp->lock, flags);
+			break;
+		}
+		if (j == jiffies)
+			flush_signals(current);
+		raw_spin_unlock_irqrestore(&rnp->lock, flags);
+	}
+	smp_mb(); /* Ensure that CB invocation happens after GP end. */
 }
 
 /*
@@ -2390,7 +2338,7 @@ static int rcu_nocb_kthread(void *arg)
 		cl = atomic_long_xchg(&rdp->nocb_q_count_lazy, 0);
 		ACCESS_ONCE(rdp->nocb_p_count) += c;
 		ACCESS_ONCE(rdp->nocb_p_count_lazy) += cl;
-		wait_rcu_gp(rdp->rsp->call_remote);
+		rcu_nocb_wait_gp(rdp);
 
 		/* Each pass through the following loop invokes a callback. */
 		trace_rcu_batch_start(rdp->rsp->name, cl, c, -1);
@@ -2443,26 +2391,22 @@ static void __init rcu_spawn_nocb_kthreads(struct rcu_state *rsp)
 }
 
 /* Prevent __call_rcu() from enqueuing callbacks on no-CBs CPUs */
-static void init_nocb_callback_list(struct rcu_data *rdp)
+static bool init_nocb_callback_list(struct rcu_data *rdp)
 {
 	if (rcu_nocb_mask == NULL ||
 	    !cpumask_test_cpu(rdp->cpu, rcu_nocb_mask))
-		return;
+		return false;
 	rdp->nxttail[RCU_NEXT_TAIL] = NULL;
+	return true;
 }
 
-/* Initialize the ->call_remote fields in the rcu_state structures. */
-static void __init rcu_init_nocb(void)
+#else /* #ifdef CONFIG_RCU_NOCB_CPU */
+
+static int rcu_nocb_needs_gp(struct rcu_data *rdp)
 {
-#ifdef CONFIG_PREEMPT_RCU
-	rcu_preempt_state.call_remote = call_rcu_preempt_remote;
-#endif /* #ifdef CONFIG_PREEMPT_RCU */
-	rcu_bh_state.call_remote = call_rcu_bh_remote;
-	rcu_sched_state.call_remote = call_rcu_sched_remote;
+	return 0;
 }
 
-#else /* #ifdef CONFIG_RCU_NOCB_CPU */
-
 static bool is_nocb_cpu(int cpu)
 {
 	return false;
@@ -2480,11 +2424,6 @@ static bool __maybe_unused rcu_nocb_adopt_orphan_cbs(struct rcu_state *rsp,
 	return 0;
 }
 
-static bool nocb_cpu_expendable(int cpu)
-{
-	return 1;
-}
-
 static void __init rcu_boot_init_nocb_percpu_data(struct rcu_data *rdp)
 {
 }
@@ -2493,12 +2432,9 @@ static void __init rcu_spawn_nocb_kthreads(struct rcu_state *rsp)
 {
 }
 
-static void init_nocb_callback_list(struct rcu_data *rdp)
-{
-}
-
-static void __init rcu_init_nocb(void)
+static bool init_nocb_callback_list(struct rcu_data *rdp)
 {
+	return false;
 }
 
 #endif /* #else #ifdef CONFIG_RCU_NOCB_CPU */
-- 
1.8.1.5

