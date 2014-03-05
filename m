Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756688AbaCEA0q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 19:26:46 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:44905 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755733AbaCEAZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 19:25:11 -0500
Message-Id: <20140305002508.115277517@goodmis.org>
User-Agent: quilt/0.61-1
Date: Tue, 04 Mar 2014 19:24:53 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        John Kacur <jkacur@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        <stable-rt@vger.kernel.org>, Mike Galbraith <bitbucket@online.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RT 7/8] rcu: Eliminate softirq processing from rcutree
References: <20140305002446.173840270@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0007-rcu-Eliminate-softirq-processing-from-rcutree.patch
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.14-rt28-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Running RCU out of softirq is a problem for some workloads that would
like to manage RCU core processing independently of other softirq work,
for example, setting kthread priority.  This commit therefore moves the
RCU core work from softirq to a per-CPU/per-flavor SCHED_OTHER kthread
named rcuc.  The SCHED_OTHER approach avoids the scalability problems
that appeared with the earlier attempt to move RCU core processing to
from softirq to kthreads.  That said, kernels built with RCU_BOOST=y
will run the rcuc kthreads at the RCU-boosting priority.

Cc: stable-rt@vger.kernel.org
Reported-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Mike Galbraith <bitbucket@online.de>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/rcutree.c        | 114 ++++++++++++++++++++++++++++++++++++-----
 kernel/rcutree.h        |   3 +-
 kernel/rcutree_plugin.h | 133 +++++-------------------------------------------
 3 files changed, 114 insertions(+), 136 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 6f6d133..6a34f87 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -53,6 +53,11 @@
 #include <linux/delay.h>
 #include <linux/stop_machine.h>
 #include <linux/random.h>
+#include <linux/delay.h>
+#include <linux/gfp.h>
+#include <linux/oom.h>
+#include <linux/smpboot.h>
+#include "time/tick-internal.h"
 
 #include "rcutree.h"
 #include <trace/events/rcu.h>
@@ -127,8 +132,6 @@ EXPORT_SYMBOL_GPL(rcu_scheduler_active);
  */
 static int rcu_scheduler_fully_active __read_mostly;
 
-#ifdef CONFIG_RCU_BOOST
-
 /*
  * Control variables for per-CPU and per-rcu_node kthreads.  These
  * handle all flavors of RCU.
@@ -138,8 +141,6 @@ DEFINE_PER_CPU(unsigned int, rcu_cpu_kthread_status);
 DEFINE_PER_CPU(unsigned int, rcu_cpu_kthread_loops);
 DEFINE_PER_CPU(char, rcu_cpu_has_work);
 
-#endif /* #ifdef CONFIG_RCU_BOOST */
-
 static void rcu_boost_kthread_setaffinity(struct rcu_node *rnp, int outgoingcpu);
 static void invoke_rcu_core(void);
 static void invoke_rcu_callbacks(struct rcu_state *rsp, struct rcu_data *rdp);
@@ -2048,16 +2049,14 @@ __rcu_process_callbacks(struct rcu_state *rsp)
 /*
  * Do RCU core processing for the current CPU.
  */
-static void rcu_process_callbacks(struct softirq_action *unused)
+static void rcu_process_callbacks(void)
 {
 	struct rcu_state *rsp;
 
 	if (cpu_is_offline(smp_processor_id()))
 		return;
-	trace_rcu_utilization("Start RCU core");
 	for_each_rcu_flavor(rsp)
 		__rcu_process_callbacks(rsp);
-	trace_rcu_utilization("End RCU core");
 }
 
 /*
@@ -2071,17 +2070,105 @@ static void invoke_rcu_callbacks(struct rcu_state *rsp, struct rcu_data *rdp)
 {
 	if (unlikely(!ACCESS_ONCE(rcu_scheduler_fully_active)))
 		return;
-	if (likely(!rsp->boost)) {
-		rcu_do_batch(rsp, rdp);
-		return;
-	}
-	invoke_rcu_callbacks_kthread();
+	rcu_do_batch(rsp, rdp);
 }
 
+static void rcu_wake_cond(struct task_struct *t, int status)
+{
+	/*
+	 * If the thread is yielding, only wake it when this
+	 * is invoked from idle
+	 */
+	if (t && (status != RCU_KTHREAD_YIELDING || is_idle_task(current)))
+		wake_up_process(t);
+}
+
+/*
+ * Wake up this CPU's rcuc kthread to do RCU core processing.
+ */
 static void invoke_rcu_core(void)
 {
-	raise_softirq(RCU_SOFTIRQ);
+	unsigned long flags;
+	struct task_struct *t;
+
+	if (!cpu_online(smp_processor_id()))
+		return;
+	local_irq_save(flags);
+	__this_cpu_write(rcu_cpu_has_work, 1);
+	t = __this_cpu_read(rcu_cpu_kthread_task);
+	if (t != NULL && current != t)
+		rcu_wake_cond(t, __this_cpu_read(rcu_cpu_kthread_status));
+	local_irq_restore(flags);
+}
+
+static void rcu_cpu_kthread_park(unsigned int cpu)
+{
+	per_cpu(rcu_cpu_kthread_status, cpu) = RCU_KTHREAD_OFFCPU;
+}
+
+static int rcu_cpu_kthread_should_run(unsigned int cpu)
+{
+	return __this_cpu_read(rcu_cpu_has_work);
+}
+
+/*
+ * Per-CPU kernel thread that invokes RCU callbacks.  This replaces the
+ * RCU softirq used in flavors and configurations of RCU that do not
+ * support RCU priority boosting.
+ */
+static void rcu_cpu_kthread(unsigned int cpu)
+{
+	unsigned int *statusp = &__get_cpu_var(rcu_cpu_kthread_status);
+	char work, *workp = &__get_cpu_var(rcu_cpu_has_work);
+	int spincnt;
+
+	for (spincnt = 0; spincnt < 10; spincnt++) {
+		trace_rcu_utilization("Start CPU kthread@rcu_wait");
+		local_bh_disable();
+		*statusp = RCU_KTHREAD_RUNNING;
+		this_cpu_inc(rcu_cpu_kthread_loops);
+		local_irq_disable();
+		work = *workp;
+		*workp = 0;
+		local_irq_enable();
+		if (work)
+			rcu_process_callbacks();
+		local_bh_enable();
+		if (*workp == 0) {
+			trace_rcu_utilization("End CPU kthread@rcu_wait");
+			*statusp = RCU_KTHREAD_WAITING;
+			return;
+		}
+	}
+	*statusp = RCU_KTHREAD_YIELDING;
+	trace_rcu_utilization("Start CPU kthread@rcu_yield");
+	schedule_timeout_interruptible(2);
+	trace_rcu_utilization("End CPU kthread@rcu_yield");
+	*statusp = RCU_KTHREAD_WAITING;
+}
+
+static struct smp_hotplug_thread rcu_cpu_thread_spec = {
+	.store			= &rcu_cpu_kthread_task,
+	.thread_should_run	= rcu_cpu_kthread_should_run,
+	.thread_fn		= rcu_cpu_kthread,
+	.thread_comm		= "rcuc/%u",
+	.setup			= rcu_cpu_kthread_setup,
+	.park			= rcu_cpu_kthread_park,
+};
+
+/*
+ * Spawn per-CPU RCU core processing kthreads.
+ */
+static int __init rcu_spawn_core_kthreads(void)
+{
+	int cpu;
+
+	for_each_possible_cpu(cpu)
+		per_cpu(rcu_cpu_has_work, cpu) = 0;
+	BUG_ON(smpboot_register_percpu_thread(&rcu_cpu_thread_spec));
+	return 0;
 }
+early_initcall(rcu_spawn_core_kthreads);
 
 /*
  * Handle any core-RCU processing required by a call_rcu() invocation.
@@ -3087,7 +3174,6 @@ void __init rcu_init(void)
 	rcu_init_one(&rcu_bh_state, &rcu_bh_data);
 	__rcu_init_preempt();
 	rcu_init_nocb();
-	 open_softirq(RCU_SOFTIRQ, rcu_process_callbacks);
 
 	/*
 	 * We don't need protection against CPU-hotplug here because
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index 5cfdff9..d67eaed 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -519,10 +519,9 @@ static void rcu_report_exp_rnp(struct rcu_state *rsp, struct rcu_node *rnp,
 static void __init __rcu_init_preempt(void);
 static void rcu_initiate_boost(struct rcu_node *rnp, unsigned long flags);
 static void rcu_preempt_boost_start_gp(struct rcu_node *rnp);
-static void invoke_rcu_callbacks_kthread(void);
 static bool rcu_is_callbacks_kthread(void);
+static void rcu_cpu_kthread_setup(unsigned int cpu);
 #ifdef CONFIG_RCU_BOOST
-static void rcu_preempt_do_callbacks(void);
 static int __cpuinit rcu_spawn_one_boost_kthread(struct rcu_state *rsp,
 						 struct rcu_node *rnp);
 #endif /* #ifdef CONFIG_RCU_BOOST */
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 778f138..a24ee9f 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -24,11 +24,6 @@
  *	   Paul E. McKenney <paulmck@linux.vnet.ibm.com>
  */
 
-#include <linux/delay.h>
-#include <linux/gfp.h>
-#include <linux/oom.h>
-#include <linux/smpboot.h>
-
 #define RCU_KTHREAD_PRIO 1
 
 #ifdef CONFIG_RCU_BOOST
@@ -648,15 +643,6 @@ static void rcu_preempt_check_callbacks(int cpu)
 		t->rcu_read_unlock_special |= RCU_READ_UNLOCK_NEED_QS;
 }
 
-#ifdef CONFIG_RCU_BOOST
-
-static void rcu_preempt_do_callbacks(void)
-{
-	rcu_do_batch(&rcu_preempt_state, &__get_cpu_var(rcu_preempt_data));
-}
-
-#endif /* #ifdef CONFIG_RCU_BOOST */
-
 /*
  * Queue a preemptible-RCU callback for invocation after a grace period.
  */
@@ -1092,6 +1078,19 @@ static void __init __rcu_init_preempt(void)
 
 #endif /* #else #ifdef CONFIG_TREE_PREEMPT_RCU */
 
+/*
+ * If boosting, set rcuc kthreads to realtime priority.
+ */
+static void rcu_cpu_kthread_setup(unsigned int cpu)
+{
+#ifdef CONFIG_RCU_BOOST
+	struct sched_param sp;
+
+	sp.sched_priority = RCU_KTHREAD_PRIO;
+	sched_setscheduler_nocheck(current, SCHED_FIFO, &sp);
+#endif /* #ifdef CONFIG_RCU_BOOST */
+}
+
 #ifdef CONFIG_RCU_BOOST
 
 #include "rtmutex_common.h"
@@ -1123,16 +1122,6 @@ static void rcu_initiate_boost_trace(struct rcu_node *rnp)
 
 #endif /* #else #ifdef CONFIG_RCU_TRACE */
 
-static void rcu_wake_cond(struct task_struct *t, int status)
-{
-	/*
-	 * If the thread is yielding, only wake it when this
-	 * is invoked from idle
-	 */
-	if (status != RCU_KTHREAD_YIELDING || is_idle_task(current))
-		wake_up_process(t);
-}
-
 /*
  * Carry out RCU priority boosting on the task indicated by ->exp_tasks
  * or ->boost_tasks, advancing the pointer to the next task in the
@@ -1276,23 +1265,6 @@ static void rcu_initiate_boost(struct rcu_node *rnp, unsigned long flags)
 }
 
 /*
- * Wake up the per-CPU kthread to invoke RCU callbacks.
- */
-static void invoke_rcu_callbacks_kthread(void)
-{
-	unsigned long flags;
-
-	local_irq_save(flags);
-	__this_cpu_write(rcu_cpu_has_work, 1);
-	if (__this_cpu_read(rcu_cpu_kthread_task) != NULL &&
-	    current != __this_cpu_read(rcu_cpu_kthread_task)) {
-		rcu_wake_cond(__this_cpu_read(rcu_cpu_kthread_task),
-			      __this_cpu_read(rcu_cpu_kthread_status));
-	}
-	local_irq_restore(flags);
-}
-
-/*
  * Is the current CPU running the RCU-callbacks kthread?
  * Caller must have preemption disabled.
  */
@@ -1346,67 +1318,6 @@ static int __cpuinit rcu_spawn_one_boost_kthread(struct rcu_state *rsp,
 	return 0;
 }
 
-static void rcu_kthread_do_work(void)
-{
-	rcu_do_batch(&rcu_sched_state, &__get_cpu_var(rcu_sched_data));
-	rcu_do_batch(&rcu_bh_state, &__get_cpu_var(rcu_bh_data));
-	rcu_preempt_do_callbacks();
-}
-
-static void rcu_cpu_kthread_setup(unsigned int cpu)
-{
-	struct sched_param sp;
-
-	sp.sched_priority = RCU_KTHREAD_PRIO;
-	sched_setscheduler_nocheck(current, SCHED_FIFO, &sp);
-}
-
-static void rcu_cpu_kthread_park(unsigned int cpu)
-{
-	per_cpu(rcu_cpu_kthread_status, cpu) = RCU_KTHREAD_OFFCPU;
-}
-
-static int rcu_cpu_kthread_should_run(unsigned int cpu)
-{
-	return __get_cpu_var(rcu_cpu_has_work);
-}
-
-/*
- * Per-CPU kernel thread that invokes RCU callbacks.  This replaces the
- * RCU softirq used in flavors and configurations of RCU that do not
- * support RCU priority boosting.
- */
-static void rcu_cpu_kthread(unsigned int cpu)
-{
-	unsigned int *statusp = &__get_cpu_var(rcu_cpu_kthread_status);
-	char work, *workp = &__get_cpu_var(rcu_cpu_has_work);
-	int spincnt;
-
-	for (spincnt = 0; spincnt < 10; spincnt++) {
-		trace_rcu_utilization("Start CPU kthread@rcu_wait");
-		local_bh_disable();
-		*statusp = RCU_KTHREAD_RUNNING;
-		this_cpu_inc(rcu_cpu_kthread_loops);
-		local_irq_disable();
-		work = *workp;
-		*workp = 0;
-		local_irq_enable();
-		if (work)
-			rcu_kthread_do_work();
-		local_bh_enable();
-		if (*workp == 0) {
-			trace_rcu_utilization("End CPU kthread@rcu_wait");
-			*statusp = RCU_KTHREAD_WAITING;
-			return;
-		}
-	}
-	*statusp = RCU_KTHREAD_YIELDING;
-	trace_rcu_utilization("Start CPU kthread@rcu_yield");
-	schedule_timeout_interruptible(2);
-	trace_rcu_utilization("End CPU kthread@rcu_yield");
-	*statusp = RCU_KTHREAD_WAITING;
-}
-
 /*
  * Set the per-rcu_node kthread's affinity to cover all CPUs that are
  * served by the rcu_node in question.  The CPU hotplug lock is still
@@ -1440,27 +1351,14 @@ static void rcu_boost_kthread_setaffinity(struct rcu_node *rnp, int outgoingcpu)
 	free_cpumask_var(cm);
 }
 
-static struct smp_hotplug_thread rcu_cpu_thread_spec = {
-	.store			= &rcu_cpu_kthread_task,
-	.thread_should_run	= rcu_cpu_kthread_should_run,
-	.thread_fn		= rcu_cpu_kthread,
-	.thread_comm		= "rcuc/%u",
-	.setup			= rcu_cpu_kthread_setup,
-	.park			= rcu_cpu_kthread_park,
-};
-
 /*
  * Spawn all kthreads -- called as soon as the scheduler is running.
  */
 static int __init rcu_spawn_kthreads(void)
 {
 	struct rcu_node *rnp;
-	int cpu;
 
 	rcu_scheduler_fully_active = 1;
-	for_each_possible_cpu(cpu)
-		per_cpu(rcu_cpu_has_work, cpu) = 0;
-	BUG_ON(smpboot_register_percpu_thread(&rcu_cpu_thread_spec));
 	rnp = rcu_get_root(rcu_state);
 	(void)rcu_spawn_one_boost_kthread(rcu_state, rnp);
 	if (NUM_RCU_NODES > 1) {
@@ -1488,11 +1386,6 @@ static void rcu_initiate_boost(struct rcu_node *rnp, unsigned long flags)
 	raw_spin_unlock_irqrestore(&rnp->lock, flags);
 }
 
-static void invoke_rcu_callbacks_kthread(void)
-{
-	WARN_ON_ONCE(1);
-}
-
 static bool rcu_is_callbacks_kthread(void)
 {
 	return false;
-- 
1.8.5.3


