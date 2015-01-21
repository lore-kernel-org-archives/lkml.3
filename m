Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753109AbbAUKJI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 05:09:08 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:38708 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752964AbbAUKId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 05:08:33 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 6/7] rcu: Move early-boot callbacks to no-CBs lists for no-CBs CPUs
Date: Wed, 21 Jan 2015 02:08:19 -0800
Message-Id: <1421834900-23987-6-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1421834900-23987-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20150121100750.GA22883@linux.vnet.ibm.com>
 <1421834900-23987-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15012110-0017-0000-0000-0000081BA333
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

When a CPU is first determined to be a no-CBs CPUs, this commit causes
any early boot callbacks to be moved to the no-CBs callback list,
allowing them t obe invoked.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcu/tree.c        |  1 +
 kernel/rcu/tree_plugin.h | 24 ++++++++++++------------
 2 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 02fa29a4d104..c5241cdd4daf 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -2852,6 +2852,7 @@ __call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu),
 		 * and then drop through to queue the callback.
 		 */
 		BUG_ON(cpu != -1);
+		WARN_ON_ONCE(!rcu_is_watching());
 		if (!likely(rdp->nxtlist))
 			init_default_callback_list(rdp);
 	}
diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index 9b7f8c8ca355..bb947ef1a2a4 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -2386,18 +2386,8 @@ void __init rcu_init_nohz(void)
 		pr_info("\tPoll for callbacks from no-CBs CPUs.\n");
 
 	for_each_rcu_flavor(rsp) {
-		for_each_cpu(cpu, rcu_nocb_mask) {
-			struct rcu_data *rdp = per_cpu_ptr(rsp->rda, cpu);
-
-			/*
-			 * If there are early callbacks, they will need
-			 * to be moved to the nocb lists.
-			 */
-			WARN_ON_ONCE(rdp->nxttail[RCU_NEXT_TAIL] !=
-				     &rdp->nxtlist &&
-				     rdp->nxttail[RCU_NEXT_TAIL] != NULL);
-			init_nocb_callback_list(rdp);
-		}
+		for_each_cpu(cpu, rcu_nocb_mask)
+			init_nocb_callback_list(per_cpu_ptr(rsp->rda, cpu));
 		rcu_organize_nocb_kthreads(rsp);
 	}
 }
@@ -2534,6 +2524,16 @@ static bool init_nocb_callback_list(struct rcu_data *rdp)
 	if (!rcu_is_nocb_cpu(rdp->cpu))
 		return false;
 
+	/* If there are early-boot callbacks, move them to nocb lists. */
+	if (rdp->nxtlist) {
+		rdp->nocb_head = rdp->nxtlist;
+		rdp->nocb_tail = rdp->nxttail[RCU_NEXT_TAIL];
+		atomic_long_set(&rdp->nocb_q_count, rdp->qlen);
+		atomic_long_set(&rdp->nocb_q_count_lazy, rdp->qlen_lazy);
+		rdp->nxtlist = NULL;
+		rdp->qlen = 0;
+		rdp->qlen_lazy = 0;
+	}
 	rdp->nxttail[RCU_NEXT_TAIL] = NULL;
 	return true;
 }
-- 
1.8.1.5

