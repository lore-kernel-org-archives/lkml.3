Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759620AbaGSDGs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 23:06:48 -0400
Received: from mail-yh0-f46.google.com ([209.85.213.46]:53971 "EHLO
	mail-yh0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756253AbaGSDGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 23:06:47 -0400
Message-ID: <53C9E0C3.60907@gmail.com>
Date: Fri, 18 Jul 2014 23:06:43 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH 1/1] rcu: Consolidate kthread launches
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

I looked at why my previous change removing checks for
rcu_scheduler_fully_active failed to boot.

The reason is that rcu_init() is called earlier than rest_init() from within
which the early_init() is being called. rcu_init() calls rcu_cpu_notify() which
in turn calls rcu_spawn_all_nocb_kthread().

This patch does the following:

* since we are launching other threads now from rcu_spawn_gp_kthread() rename it
  to rcu_spawn_kthreads()
* move nocb kthread launches on cpu hotplug to rcu_prepare_kthreads(), the name
  is generic so thre is no need to rename ;)
* check whether CPU is a no-CB CPU before calling rcu_spawn_all_nocb_kthreads()
  on that CPU

I've got the KVM rcutorture setup running and verified these changes.

Side note: we should probably change the trace comment for rcu_cpu_notify() which says it is for Hotplug :)

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
---
 kernel/rcu/tree.c        |  8 ++++----
 kernel/rcu/tree_plugin.h | 19 ++++++++++++-------
 2 files changed, 16 insertions(+), 11 deletions(-)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 72e0b1f..2866464 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -3451,7 +3451,6 @@ static int rcu_cpu_notify(struct notifier_block *self,
 	case CPU_UP_PREPARE_FROZEN:
 		rcu_prepare_cpu(cpu);
 		rcu_prepare_kthreads(cpu);
-		rcu_spawn_all_nocb_kthreads(cpu);
 		break;
 	case CPU_ONLINE:
 	case CPU_DOWN_FAILED:
@@ -3499,9 +3498,10 @@ static int rcu_pm_notify(struct notifier_block *self,
 }
 
 /*
- * Spawn the kthreads that handle each RCU flavor's grace periods.
+ * Spawn the kthreads that handle each RCU flavor's grace periods
+ * and the no-CB and boost kthreads.
  */
-static int __init rcu_spawn_gp_kthread(void)
+static int __init rcu_spawn_kthreads(void)
 {
 	unsigned long flags;
 	struct rcu_node *rnp;
@@ -3521,7 +3521,7 @@ static int __init rcu_spawn_gp_kthread(void)
 	rcu_spawn_boost_kthreads();
 	return 0;
 }
-early_initcall(rcu_spawn_gp_kthread);
+early_initcall(rcu_spawn_kthreads);
 
 /*
  * This function is invoked towards the end of the scheduler's initialization
diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index eaa32e4..42e113b 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -1339,7 +1339,7 @@ static int rcu_spawn_one_boost_kthread(struct rcu_state *rsp,
 	if (&rcu_preempt_state != rsp)
 		return 0;
 
-	if (!rcu_scheduler_fully_active || rnp->qsmaskinit == 0)
+	if (rnp->qsmaskinit == 0)
 		return 0;
 
 	rsp->boost = 1;
@@ -1486,9 +1486,14 @@ static void rcu_prepare_kthreads(int cpu)
 	struct rcu_data *rdp = per_cpu_ptr(rcu_state_p->rda, cpu);
 	struct rcu_node *rnp = rdp->mynode;
 
+	if (!rcu_scheduler_fully_active)
+		return;
+
 	/* Fire up the incoming CPU's kthread and leaf rcu_node kthread. */
-	if (rcu_scheduler_fully_active)
-		(void)rcu_spawn_one_boost_kthread(rcu_state_p, rnp);
+	(void)rcu_spawn_one_boost_kthread(rcu_state_p, rnp);
+
+	if (rcu_is_nocb_cpu(cpu))
+		rcu_spawn_all_nocb_kthreads(cpu);
 }
 
 #else /* #ifdef CONFIG_RCU_BOOST */
@@ -2507,9 +2512,8 @@ static void rcu_spawn_all_nocb_kthreads(int cpu)
 {
 	struct rcu_state *rsp;
 
-	if (rcu_scheduler_fully_active)
-		for_each_rcu_flavor(rsp)
-			rcu_spawn_one_nocb_kthread(rsp, cpu);
+	for_each_rcu_flavor(rsp)
+		rcu_spawn_one_nocb_kthread(rsp, cpu);
 }
 
 /*
@@ -2523,7 +2527,8 @@ static void __init rcu_spawn_nocb_kthreads(void)
 	int cpu;
 
 	for_each_online_cpu(cpu)
-		rcu_spawn_all_nocb_kthreads(cpu);
+		if (rcu_is_nocb_cpu(cpu))
+			rcu_spawn_all_nocb_kthreads(cpu);
 }
 
 /* How many follower CPU IDs per leader?  Default of -1 for sqrt(nr_cpu_ids). */
-- 
1.9.1
