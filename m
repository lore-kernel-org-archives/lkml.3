Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933640AbaGOWbd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 18:31:33 -0400
Received: from mail-yh0-f43.google.com ([209.85.213.43]:58929 "EHLO
	mail-yh0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933768AbaGOWb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 18:31:29 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        linux-kernel@vger.kernel.org (open list:READ-COPY UPDATE...)
Subject: [PATCH 3/3] rcu: Use rcu_num_nodes instead of NUM_RCU_NODES
Date: Tue, 15 Jul 2014 18:31:49 -0400
Message-Id: <1405463509-2468-3-git-send-email-bobby.prani@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405463509-2468-1-git-send-email-bobby.prani@gmail.com>
References: <1405463509-2468-1-git-send-email-bobby.prani@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NUM_RCU_NODES is set at build time and is usually a huge number. We calculate the
actual number of rcu nodes necessary at boot time based on nr_cpu_ids in
rcu_init_geometry() and store it in rcu_num_nodes. We should use this variable
instead of NUM_RCU_NODES.

This commit changes all such uses of NUM_RCU_NODES to rcu_num_nodes.

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
---
 kernel/rcu/tree_plugin.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index cedb020..17ccb62 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -46,6 +46,8 @@ static bool __read_mostly rcu_nocb_poll;    /* Offload kthread are to poll. */
 static char __initdata nocb_buf[NR_CPUS * 5];
 #endif /* #ifdef CONFIG_RCU_NOCB_CPU */
 
+extern int rcu_num_nodes;
+
 /*
  * Check the RCU kernel configuration parameters and print informative
  * messages about anything out of the ordinary.  If you like #ifdef, you
@@ -885,7 +887,7 @@ void synchronize_rcu_expedited(void)
 	/* Snapshot current state of ->blkd_tasks lists. */
 	rcu_for_each_leaf_node(rsp, rnp)
 		sync_rcu_preempt_exp_init(rsp, rnp);
-	if (NUM_RCU_NODES > 1)
+	if (rcu_num_nodes > 1)
 		sync_rcu_preempt_exp_init(rsp, rcu_get_root(rsp));
 
 	put_online_cpus();
@@ -1475,7 +1477,7 @@ static void __init rcu_spawn_boost_kthreads(void)
 	BUG_ON(smpboot_register_percpu_thread(&rcu_cpu_thread_spec));
 	rnp = rcu_get_root(rcu_state_p);
 	(void)rcu_spawn_one_boost_kthread(rcu_state_p, rnp);
-	if (NUM_RCU_NODES > 1) {
+	if (rcu_num_nodes > 1) {
 		rcu_for_each_leaf_node(rcu_state_p, rnp)
 			(void)rcu_spawn_one_boost_kthread(rcu_state_p, rnp);
 	}
-- 
1.9.1

