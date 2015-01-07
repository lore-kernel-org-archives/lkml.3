Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755284AbbAGRcw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 12:32:52 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:52054 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755215AbbAGRcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 12:32:46 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 08/14] rcu: Don't spawn rcub kthreads on root rcu_node structure
Date: Wed,  7 Jan 2015 09:32:27 -0800
Message-Id: <1420651953-2651-8-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1420651953-2651-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20150107173215.GA897@linux.vnet.ibm.com>
 <1420651953-2651-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15010717-0025-0000-0000-00000791CDEF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Now that offlining CPUs no longer moves leaf rcu_node structures'
->blkd_tasks lists to the root, there is no way for the root rcu_node
structure's ->blkd_task list to be nonempty, unless the root node is also
the sole leaf node.  This commit therefore refrains from creating an rcub
kthread for the root rcu_node structure unless it is also the sole leaf.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcu/tree_plugin.h | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index bcc6d9134d47..3e64bb197b1a 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -1352,12 +1352,8 @@ static void __init rcu_spawn_boost_kthreads(void)
 	for_each_possible_cpu(cpu)
 		per_cpu(rcu_cpu_has_work, cpu) = 0;
 	BUG_ON(smpboot_register_percpu_thread(&rcu_cpu_thread_spec));
-	rnp = rcu_get_root(rcu_state_p);
-	(void)rcu_spawn_one_boost_kthread(rcu_state_p, rnp);
-	if (NUM_RCU_NODES > 1) {
-		rcu_for_each_leaf_node(rcu_state_p, rnp)
-			(void)rcu_spawn_one_boost_kthread(rcu_state_p, rnp);
-	}
+	rcu_for_each_leaf_node(rcu_state_p, rnp)
+		(void)rcu_spawn_one_boost_kthread(rcu_state_p, rnp);
 }
 
 static void rcu_prepare_kthreads(int cpu)
-- 
1.8.1.5

