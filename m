Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757646AbaGPBtm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 21:49:42 -0400
Received: from mail-yk0-f179.google.com ([209.85.160.179]:63642 "EHLO
	mail-yk0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751593AbaGPBti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 21:49:38 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        linux-kernel@vger.kernel.org (open list:READ-COPY UPDATE...)
Subject: [PATCH 1/1] rcu: Remove redundant checks for rcu_scheduler_fully_active
Date: Tue, 15 Jul 2014 21:50:02 -0400
Message-Id: <1405475402-7181-1-git-send-email-bobby.prani@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rcu_scheduler_fully_active is set to true early in the boot process.

rcu_prepare_kthreads() is called in two locations. Once after setting the above
flag and the other while hotplugging a CPU from rcu_cpu_notify(). CPU hotplug is
enabled much later by which time the above flag is already set. Hence checking
for this flag is redundant in this function.

The checks in rcu_spawn_one_boost_kthread() and rcu_spawn_all_nocb_kthreads()
are similarly redundant.

This commit removes the redundant checks for this flag from the above
locations.

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
---
 kernel/rcu/tree_plugin.h | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index 17ccb62..a2113f6 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -1341,7 +1341,7 @@ static int rcu_spawn_one_boost_kthread(struct rcu_state *rsp,
 	if (&rcu_preempt_state != rsp)
 		return 0;
 
-	if (!rcu_scheduler_fully_active || rnp->qsmaskinit == 0)
+	if (rnp->qsmaskinit == 0)
 		return 0;
 
 	rsp->boost = 1;
@@ -1489,8 +1489,7 @@ static void rcu_prepare_kthreads(int cpu)
 	struct rcu_node *rnp = rdp->mynode;
 
 	/* Fire up the incoming CPU's kthread and leaf rcu_node kthread. */
-	if (rcu_scheduler_fully_active)
-		(void)rcu_spawn_one_boost_kthread(rcu_state_p, rnp);
+	(void)rcu_spawn_one_boost_kthread(rcu_state_p, rnp);
 }
 
 #else /* #ifdef CONFIG_RCU_BOOST */
@@ -2509,9 +2508,8 @@ static void rcu_spawn_all_nocb_kthreads(int cpu)
 {
 	struct rcu_state *rsp;
 
-	if (rcu_scheduler_fully_active)
-		for_each_rcu_flavor(rsp)
-			rcu_spawn_one_nocb_kthread(rsp, cpu);
+	for_each_rcu_flavor(rsp)
+		rcu_spawn_one_nocb_kthread(rsp, cpu);
 }
 
 /*
-- 
1.9.1

