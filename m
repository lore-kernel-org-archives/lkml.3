Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751759AbaENAbM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 20:31:12 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:57339 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776AbaENAbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 20:31:08 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu, Uma Sharma <uma.sharma523@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 1/1] rcu: Variable name changed in tree_plugin.h and used in tree.c
Date: Tue, 13 May 2014 17:30:59 -0700
Message-Id: <1400027459-29427-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14051400-7164-0000-0000-000001BB6987
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Uma Sharma <uma.sharma523@gmail.com>

The variable and struct both having the name "rcu_state" confuses
sparse in some situations, so this commit changes the variable to
"rcu_state_p" in order to avoid this confusion.  This also makes
things easier for human readers.

Signed-off-by: Uma Sharma <uma.sharma523@gmail.com>
[ paulmck: Changed the declaration and several additional uses. ]
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcu/tree.c        | 16 ++++++++--------
 kernel/rcu/tree_plugin.h | 16 ++++++++--------
 2 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 3bbe48939e47..3e3f13e8b429 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -101,7 +101,7 @@ DEFINE_PER_CPU(struct rcu_data, sname##_data)
 RCU_STATE_INITIALIZER(rcu_sched, 's', call_rcu_sched);
 RCU_STATE_INITIALIZER(rcu_bh, 'b', call_rcu_bh);
 
-static struct rcu_state *rcu_state;
+static struct rcu_state *rcu_state_p;
 LIST_HEAD(rcu_struct_flavors);
 
 /* Increase (but not decrease) the CONFIG_RCU_FANOUT_LEAF at boot time. */
@@ -275,7 +275,7 @@ EXPORT_SYMBOL_GPL(rcu_batches_completed_bh);
  */
 void rcu_force_quiescent_state(void)
 {
-	force_quiescent_state(rcu_state);
+	force_quiescent_state(rcu_state_p);
 }
 EXPORT_SYMBOL_GPL(rcu_force_quiescent_state);
 
@@ -327,7 +327,7 @@ void rcutorture_get_gp_data(enum rcutorture_type test_type, int *flags,
 
 	switch (test_type) {
 	case RCU_FLAVOR:
-		rsp = rcu_state;
+		rsp = rcu_state_p;
 		break;
 	case RCU_BH_FLAVOR:
 		rsp = &rcu_bh_state;
@@ -910,7 +910,7 @@ static int rcu_implicit_dynticks_qs(struct rcu_data *rdp,
 	 * we will beat on the first one until it gets unstuck, then move
 	 * to the next.  Only do this for the primary flavor of RCU.
 	 */
-	if (rdp->rsp == rcu_state &&
+	if (rdp->rsp == rcu_state_p &&
 	    ULONG_CMP_GE(jiffies, rdp->rsp->jiffies_resched)) {
 		rdp->rsp->jiffies_resched += 5;
 		resched_cpu(rdp->cpu);
@@ -2660,7 +2660,7 @@ EXPORT_SYMBOL_GPL(call_rcu_bh);
 void kfree_call_rcu(struct rcu_head *head,
 		    void (*func)(struct rcu_head *rcu))
 {
-	__call_rcu(head, func, rcu_state, -1, 1);
+	__call_rcu(head, func, rcu_state_p, -1, 1);
 }
 EXPORT_SYMBOL_GPL(kfree_call_rcu);
 
@@ -2787,7 +2787,7 @@ unsigned long get_state_synchronize_rcu(void)
 	 * time-consuming work between get_state_synchronize_rcu()
 	 * and cond_synchronize_rcu().
 	 */
-	return smp_load_acquire(&rcu_state->gpnum);
+	return smp_load_acquire(&rcu_state_p->gpnum);
 }
 EXPORT_SYMBOL_GPL(get_state_synchronize_rcu);
 
@@ -2813,7 +2813,7 @@ void cond_synchronize_rcu(unsigned long oldstate)
 	 * Ensure that this load happens before any RCU-destructive
 	 * actions the caller might carry out after we return.
 	 */
-	newstate = smp_load_acquire(&rcu_state->completed);
+	newstate = smp_load_acquire(&rcu_state_p->completed);
 	if (ULONG_CMP_GE(oldstate, newstate))
 		synchronize_rcu();
 }
@@ -3354,7 +3354,7 @@ static int rcu_cpu_notify(struct notifier_block *self,
 				    unsigned long action, void *hcpu)
 {
 	long cpu = (long)hcpu;
-	struct rcu_data *rdp = per_cpu_ptr(rcu_state->rda, cpu);
+	struct rcu_data *rdp = per_cpu_ptr(rcu_state_p->rda, cpu);
 	struct rcu_node *rnp = rdp->mynode;
 	struct rcu_state *rsp;
 
diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index 2e579c38bd91..29977ae84e7e 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -116,7 +116,7 @@ static void __init rcu_bootup_announce_oddness(void)
 #ifdef CONFIG_TREE_PREEMPT_RCU
 
 RCU_STATE_INITIALIZER(rcu_preempt, 'p', call_rcu);
-static struct rcu_state *rcu_state = &rcu_preempt_state;
+static struct rcu_state *rcu_state_p = &rcu_preempt_state;
 
 static int rcu_preempted_readers_exp(struct rcu_node *rnp);
 
@@ -947,7 +947,7 @@ void exit_rcu(void)
 
 #else /* #ifdef CONFIG_TREE_PREEMPT_RCU */
 
-static struct rcu_state *rcu_state = &rcu_sched_state;
+static struct rcu_state *rcu_state_p = &rcu_sched_state;
 
 /*
  * Tell them what RCU they are running.
@@ -1468,11 +1468,11 @@ static int __init rcu_spawn_kthreads(void)
 	for_each_possible_cpu(cpu)
 		per_cpu(rcu_cpu_has_work, cpu) = 0;
 	BUG_ON(smpboot_register_percpu_thread(&rcu_cpu_thread_spec));
-	rnp = rcu_get_root(rcu_state);
-	(void)rcu_spawn_one_boost_kthread(rcu_state, rnp);
+	rnp = rcu_get_root(rcu_state_p);
+	(void)rcu_spawn_one_boost_kthread(rcu_state_p, rnp);
 	if (NUM_RCU_NODES > 1) {
-		rcu_for_each_leaf_node(rcu_state, rnp)
-			(void)rcu_spawn_one_boost_kthread(rcu_state, rnp);
+		rcu_for_each_leaf_node(rcu_state_p, rnp)
+			(void)rcu_spawn_one_boost_kthread(rcu_state_p, rnp);
 	}
 	return 0;
 }
@@ -1480,12 +1480,12 @@ early_initcall(rcu_spawn_kthreads);
 
 static void rcu_prepare_kthreads(int cpu)
 {
-	struct rcu_data *rdp = per_cpu_ptr(rcu_state->rda, cpu);
+	struct rcu_data *rdp = per_cpu_ptr(rcu_state_p->rda, cpu);
 	struct rcu_node *rnp = rdp->mynode;
 
 	/* Fire up the incoming CPU's kthread and leaf rcu_node kthread. */
 	if (rcu_scheduler_fully_active)
-		(void)rcu_spawn_one_boost_kthread(rcu_state, rnp);
+		(void)rcu_spawn_one_boost_kthread(rcu_state_p, rnp);
 }
 
 #else /* #ifdef CONFIG_RCU_BOOST */
-- 
1.8.1.5

