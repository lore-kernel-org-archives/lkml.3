Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755767AbaKERnB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 12:43:01 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:47034 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754596AbaKERlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 12:41:45 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 09/10] rcu: Don't spawn rcub kthreads on root rcu_node structure
Date: Wed,  5 Nov 2014 09:41:33 -0800
Message-Id: <1415209294-2534-9-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1415209294-2534-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20141105174109.GA1306@linux.vnet.ibm.com>
 <1415209294-2534-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14110517-0029-0000-0000-000005661B85
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
index 65786864dcfb..fb05d963eaaa 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -1371,12 +1371,8 @@ static void __init rcu_spawn_boost_kthreads(void)
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

