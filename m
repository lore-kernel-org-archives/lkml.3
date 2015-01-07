Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755266AbbAGRcu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 12:32:50 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:56850 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753668AbbAGRcq (ORCPT
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
Subject: [PATCH tip/core/rcu 13/14] rcu: Don't scan root rcu_node structure for stalled tasks
Date: Wed,  7 Jan 2015 09:32:32 -0800
Message-Id: <1420651953-2651-13-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1420651953-2651-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20150107173215.GA897@linux.vnet.ibm.com>
 <1420651953-2651-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15010717-0029-0000-0000-00000703EF13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Now that blocked tasks are no longer migrated to the root rcu_node
structure, there is no need to scan the root rcu_node structure for
blocked tasks stalling the current grace period.  This commit therefore
removes this scan.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcu/tree.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 24d3c67f7be7..4ed2c2842103 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -1107,15 +1107,6 @@ static void print_other_cpu_stall(struct rcu_state *rsp)
 		raw_spin_unlock_irqrestore(&rnp->lock, flags);
 	}
 
-	/*
-	 * Now rat on any tasks that got kicked up to the root rcu_node
-	 * due to CPU offlining.
-	 */
-	rnp = rcu_get_root(rsp);
-	raw_spin_lock_irqsave(&rnp->lock, flags);
-	ndetected += rcu_print_task_stall(rnp);
-	raw_spin_unlock_irqrestore(&rnp->lock, flags);
-
 	print_cpu_stall_info_end();
 	for_each_possible_cpu(cpu)
 		totqlen += per_cpu_ptr(rsp->rda, cpu)->qlen;
-- 
1.8.1.5

