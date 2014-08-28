Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753781AbaH1Sin (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 14:38:43 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:60878 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753668AbaH1Sig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 14:38:36 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 07/14] rcu: Rationalize kthread spawning
Date: Thu, 28 Aug 2014 11:38:10 -0700
Message-Id: <1409251097-26734-7-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1409251097-26734-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140828183754.GA25488@linux.vnet.ibm.com>
 <1409251097-26734-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14082818-9332-0000-0000-000001D6C6C4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Currently, RCU spawns kthreads from several different early_initcall()
functions.  Although this has served RCU well for quite some time,
as more kthreads are added a more deterministic approach is required.
This commit therefore causes all of RCU's early-boot kthreads to be
spawned from a single early_initcall() function.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 kernel/rcu/tree.c        |  4 +++-
 kernel/rcu/tree.h        |  1 +
 kernel/rcu/tree_plugin.h | 12 +++---------
 3 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 1b70cb6fbe3c..9be47f43903b 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -3489,7 +3489,7 @@ static int rcu_pm_notify(struct notifier_block *self,
 }
 
 /*
- * Spawn the kthread that handles this RCU flavor's grace periods.
+ * Spawn the kthreads that handle each RCU flavor's grace periods.
  */
 static int __init rcu_spawn_gp_kthread(void)
 {
@@ -3498,6 +3498,7 @@ static int __init rcu_spawn_gp_kthread(void)
 	struct rcu_state *rsp;
 	struct task_struct *t;
 
+	rcu_scheduler_fully_active = 1;
 	for_each_rcu_flavor(rsp) {
 		t = kthread_run(rcu_gp_kthread, rsp, "%s", rsp->name);
 		BUG_ON(IS_ERR(t));
@@ -3507,6 +3508,7 @@ static int __init rcu_spawn_gp_kthread(void)
 		raw_spin_unlock_irqrestore(&rnp->lock, flags);
 		rcu_spawn_nocb_kthreads(rsp);
 	}
+	rcu_spawn_boost_kthreads();
 	return 0;
 }
 early_initcall(rcu_spawn_gp_kthread);
diff --git a/kernel/rcu/tree.h b/kernel/rcu/tree.h
index 71e64c718f75..bd7b63da9a8c 100644
--- a/kernel/rcu/tree.h
+++ b/kernel/rcu/tree.h
@@ -572,6 +572,7 @@ static void rcu_preempt_do_callbacks(void);
 static int rcu_spawn_one_boost_kthread(struct rcu_state *rsp,
 						 struct rcu_node *rnp);
 #endif /* #ifdef CONFIG_RCU_BOOST */
+static void __init rcu_spawn_boost_kthreads(void);
 static void rcu_prepare_kthreads(int cpu);
 static void rcu_cleanup_after_idle(int cpu);
 static void rcu_prepare_for_idle(int cpu);
diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index d1b8b628d24e..a9971ac64e00 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -1435,14 +1435,13 @@ static struct smp_hotplug_thread rcu_cpu_thread_spec = {
 };
 
 /*
- * Spawn all kthreads -- called as soon as the scheduler is running.
+ * Spawn boost kthreads -- called as soon as the scheduler is running.
  */
-static int __init rcu_spawn_kthreads(void)
+static void __init rcu_spawn_boost_kthreads(void)
 {
 	struct rcu_node *rnp;
 	int cpu;
 
-	rcu_scheduler_fully_active = 1;
 	for_each_possible_cpu(cpu)
 		per_cpu(rcu_cpu_has_work, cpu) = 0;
 	BUG_ON(smpboot_register_percpu_thread(&rcu_cpu_thread_spec));
@@ -1452,9 +1451,7 @@ static int __init rcu_spawn_kthreads(void)
 		rcu_for_each_leaf_node(rcu_state_p, rnp)
 			(void)rcu_spawn_one_boost_kthread(rcu_state_p, rnp);
 	}
-	return 0;
 }
-early_initcall(rcu_spawn_kthreads);
 
 static void rcu_prepare_kthreads(int cpu)
 {
@@ -1492,12 +1489,9 @@ static void rcu_boost_kthread_setaffinity(struct rcu_node *rnp, int outgoingcpu)
 {
 }
 
-static int __init rcu_scheduler_really_started(void)
+static void __init rcu_spawn_boost_kthreads(void)
 {
-	rcu_scheduler_fully_active = 1;
-	return 0;
 }
-early_initcall(rcu_scheduler_really_started);
 
 static void rcu_prepare_kthreads(int cpu)
 {
-- 
1.8.1.5

