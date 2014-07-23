Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757455AbaGWFK7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 01:10:59 -0400
Received: from mail-yh0-f46.google.com ([209.85.213.46]:50422 "EHLO
	mail-yh0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757413AbaGWFKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 01:10:55 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        linux-kernel@vger.kernel.org (open list:READ-COPY UPDATE...)
Subject: [PATCH 08/16] rcu: Clean up rcu_spawn_one_boost_kthread()
Date: Wed, 23 Jul 2014 01:09:45 -0400
Message-Id: <1406092194-13004-9-git-send-email-bobby.prani@gmail.com>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <1406092194-13004-1-git-send-email-bobby.prani@gmail.com>
References: <1406092194-13004-1-git-send-email-bobby.prani@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Even though we pass on the return value of kthread_create, we do not
use it anywhere. This commit uses kthread_run() and adds BUG_ON() when we create
the kthread and changes the return type of this function to void.

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
---
 kernel/rcu/tree.h        |  2 +-
 kernel/rcu/tree_plugin.h | 15 ++++++---------
 2 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/kernel/rcu/tree.h b/kernel/rcu/tree.h
index 9643f10..fc21899 100644
--- a/kernel/rcu/tree.h
+++ b/kernel/rcu/tree.h
@@ -569,7 +569,7 @@ static void invoke_rcu_callbacks_kthread(void);
 static bool rcu_is_callbacks_kthread(void);
 #ifdef CONFIG_RCU_BOOST
 static void rcu_preempt_do_callbacks(void);
-static int rcu_spawn_one_boost_kthread(struct rcu_state *rsp,
+static void rcu_spawn_one_boost_kthread(struct rcu_state *rsp,
 						 struct rcu_node *rnp);
 #endif /* #ifdef CONFIG_RCU_BOOST */
 static void __init rcu_spawn_boost_kthreads(void);
diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index dd53247..4d42791 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -1330,7 +1330,7 @@ static void rcu_preempt_boost_start_gp(struct rcu_node *rnp)
  * already exist.  We only create this kthread for preemptible RCU.
  * Returns zero if all is well, a negated errno otherwise.
  */
-static int rcu_spawn_one_boost_kthread(struct rcu_state *rsp,
+static void rcu_spawn_one_boost_kthread(struct rcu_state *rsp,
 						 struct rcu_node *rnp)
 {
 	int rnp_index = rnp - &rsp->node[0];
@@ -1347,18 +1347,15 @@ static int rcu_spawn_one_boost_kthread(struct rcu_state *rsp,
 	rsp->boost = 1;
 	if (rnp->boost_kthread_task != NULL)
 		return 0;
-	t = kthread_create(rcu_boost_kthread, (void *)rnp,
+	t = kthread_run(rcu_boost_kthread, (void *)rnp,
 			   "rcub/%d", rnp_index);
-	if (IS_ERR(t))
-		return PTR_ERR(t);
+	BUG_ON(IS_ERR(t));
 	raw_spin_lock_irqsave(&rnp->lock, flags);
 	smp_mb__after_unlock_lock();
 	rnp->boost_kthread_task = t;
 	raw_spin_unlock_irqrestore(&rnp->lock, flags);
 	sp.sched_priority = RCU_BOOST_PRIO;
 	sched_setscheduler_nocheck(t, SCHED_FIFO, &sp);
-	wake_up_process(t); /* get to TASK_INTERRUPTIBLE quickly. */
-	return 0;
 }
 
 static void rcu_kthread_do_work(void)
@@ -1476,10 +1473,10 @@ static void __init rcu_spawn_boost_kthreads(void)
 		per_cpu(rcu_cpu_has_work, cpu) = 0;
 	BUG_ON(smpboot_register_percpu_thread(&rcu_cpu_thread_spec));
 	rnp = rcu_get_root(rcu_state_p);
-	(void)rcu_spawn_one_boost_kthread(rcu_state_p, rnp);
+	rcu_spawn_one_boost_kthread(rcu_state_p, rnp);
 	if (rcu_num_nodes > 1) {
 		rcu_for_each_leaf_node(rcu_state_p, rnp)
-			(void)rcu_spawn_one_boost_kthread(rcu_state_p, rnp);
+			rcu_spawn_one_boost_kthread(rcu_state_p, rnp);
 	}
 }
 
@@ -1490,7 +1487,7 @@ static void rcu_prepare_kthreads(int cpu)
 
 	/* Fire up the incoming CPU's kthread and leaf rcu_node kthread. */
 	if (rcu_scheduler_fully_active)
-		(void)rcu_spawn_one_boost_kthread(rcu_state_p, rnp);
+		rcu_spawn_one_boost_kthread(rcu_state_p, rnp);
 }
 
 #else /* #ifdef CONFIG_RCU_BOOST */
-- 
2.0.0.rc2

