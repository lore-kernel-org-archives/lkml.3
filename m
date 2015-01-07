Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762AbbAGRfr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 12:35:47 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:56864 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755221AbbAGRcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 12:32:48 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 12/14] rcu: Revert "Allow post-unlock reference for rt_mutex" to avoid priority-inversion
Date: Wed,  7 Jan 2015 09:32:31 -0800
Message-Id: <1420651953-2651-12-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1420651953-2651-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20150107173215.GA897@linux.vnet.ibm.com>
 <1420651953-2651-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15010717-0029-0000-0000-00000703EF14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

The patch dfeb9765ce3c ("Allow post-unlock reference for rt_mutex")
ensured rcu-boost safe even the rt_mutex has post-unlock reference.

But rt_mutex allowing post-unlock reference is definitely a bug and it was
fixed by the commit 27e35715df54 ("rtmutex: Plug slow unlock race").
This fix made the previous patch (dfeb9765ce3c) useless.

And even worse, the priority-inversion introduced by the the previous
patch still exists.

rcu_read_unlock_special() {
	rt_mutex_unlock(&rnp->boost_mtx);
	/* Priority-Inversion:
	 * the current task had been deboosted and preempted as a low
	 * priority task immediately, it could wait long before reschedule in,
	 * and the rcu-booster also waits on this low priority task and sleeps.
	 * This priority-inversion makes rcu-booster can't work
	 * as expected.
	 */
	complete(&rnp->boost_completion);
}

Just revert the patch to avoid it.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcu/tree.h        | 5 -----
 kernel/rcu/tree_plugin.h | 8 +-------
 2 files changed, 1 insertion(+), 12 deletions(-)

diff --git a/kernel/rcu/tree.h b/kernel/rcu/tree.h
index 883ebc8e2b6e..95356477d560 100644
--- a/kernel/rcu/tree.h
+++ b/kernel/rcu/tree.h
@@ -172,11 +172,6 @@ struct rcu_node {
 				/*  queued on this rcu_node structure that */
 				/*  are blocking the current grace period, */
 				/*  there can be no such task. */
-	struct completion boost_completion;
-				/* Used to ensure that the rt_mutex used */
-				/*  to carry out the boosting is fully */
-				/*  released with no future boostee accesses */
-				/*  before that rt_mutex is re-initialized. */
 	struct rt_mutex boost_mtx;
 				/* Used only for the priority-boosting */
 				/*  side effect, not as a lock. */
diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index 1fac68220999..625e26040e6b 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -429,10 +429,8 @@ void rcu_read_unlock_special(struct task_struct *t)
 
 #ifdef CONFIG_RCU_BOOST
 		/* Unboost if we were boosted. */
-		if (drop_boost_mutex) {
+		if (drop_boost_mutex)
 			rt_mutex_unlock(&rnp->boost_mtx);
-			complete(&rnp->boost_completion);
-		}
 #endif /* #ifdef CONFIG_RCU_BOOST */
 
 		/*
@@ -1081,15 +1079,11 @@ static int rcu_boost(struct rcu_node *rnp)
 	 */
 	t = container_of(tb, struct task_struct, rcu_node_entry);
 	rt_mutex_init_proxy_locked(&rnp->boost_mtx, t);
-	init_completion(&rnp->boost_completion);
 	raw_spin_unlock_irqrestore(&rnp->lock, flags);
 	/* Lock only for side effect: boosts task t's priority. */
 	rt_mutex_lock(&rnp->boost_mtx);
 	rt_mutex_unlock(&rnp->boost_mtx);  /* Then keep lockdep happy. */
 
-	/* Wait for boostee to be done w/boost_mtx before reinitializing. */
-	wait_for_completion(&rnp->boost_completion);
-
 	return ACCESS_ONCE(rnp->exp_tasks) != NULL ||
 	       ACCESS_ONCE(rnp->boost_tasks) != NULL;
 }
-- 
1.8.1.5

