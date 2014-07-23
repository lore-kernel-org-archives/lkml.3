Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932343AbaGWFL5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 01:11:57 -0400
Received: from mail-yk0-f181.google.com ([209.85.160.181]:41402 "EHLO
	mail-yk0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757491AbaGWFLI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 01:11:08 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        linux-kernel@vger.kernel.org (open list:READ-COPY UPDATE...)
Subject: [PATCH 14/16] rcu: Remove redundant checks for rcu_scheduler_fully_active
Date: Wed, 23 Jul 2014 01:09:51 -0400
Message-Id: <1406092194-13004-15-git-send-email-bobby.prani@gmail.com>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <1406092194-13004-1-git-send-email-bobby.prani@gmail.com>
References: <1406092194-13004-1-git-send-email-bobby.prani@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rcu_scheduler_fully_active is set to true early in the boot process.

The check for this flag is only needed in rcu_prepare_kthreads() as this
function is called before the above flag is set. All other checks are redundant.
Hence this commit removes those redundant checks.

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
---
 kernel/rcu/tree_plugin.h | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index 9a50e1d..541c776 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -1341,7 +1341,7 @@ static void rcu_spawn_one_boost_kthread(struct rcu_state *rsp,
 	if (&rcu_preempt_state != rsp)
 		return 0;
 
-	if (!rcu_scheduler_fully_active || rnp->qsmaskinit == 0)
+	if (rnp->qsmaskinit == 0)
 		return 0;
 
 	rsp->boost = 1;
@@ -1486,9 +1486,10 @@ static void rcu_prepare_kthreads(int cpu)
 	struct rcu_node *rnp = rdp->mynode;
 
 	/* Fire up the incoming CPU's kthread and leaf rcu_node kthread. */
-	if (rcu_scheduler_fully_active)
-		rcu_spawn_one_boost_kthread(rcu_state_p, rnp);
+	if (!rcu_scheduler_fully_active)
+		return;
 
+	rcu_spawn_one_boost_kthread(rcu_state_p, rnp);
 	rcu_spawn_all_nocb_kthreads(cpu);
 }
 
@@ -2508,9 +2509,8 @@ static void rcu_spawn_all_nocb_kthreads(int cpu)
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
2.0.0.rc2

