Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753808AbaKRI04 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 03:26:56 -0500
Received: from cn.fujitsu.com ([59.151.112.132]:4533 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752937AbaKRI0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 03:26:55 -0500
X-IronPort-AV: E=Sophos;i="5.04,848,1406563200"; 
   d="scan'208";a="43555037"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
CC: Lai Jiangshan <laijs@cn.fujitsu.com>, Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [PATCH] rcu: revert "Allow post-unlock reference for rt_mutex" to avoid priority-inversion
Date: Tue, 18 Nov 2014 16:30:01 +0800
Message-ID: <1416299401-4681-1-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
 kernel/rcu/tree.h        |    5 -----
 kernel/rcu/tree_plugin.h |    8 +-------
 2 files changed, 1 insertions(+), 12 deletions(-)

diff --git a/kernel/rcu/tree.h b/kernel/rcu/tree.h
index 49b3da7..f14580c 100644
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
index 152f0e3..272d837 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -427,10 +427,8 @@ void rcu_read_unlock_special(struct task_struct *t)
 
 #ifdef CONFIG_RCU_BOOST
 		/* Unboost if we were boosted. */
-		if (drop_boost_mutex) {
+		if (drop_boost_mutex)
 			rt_mutex_unlock(&rnp->boost_mtx);
-			complete(&rnp->boost_completion);
-		}
 #endif /* #ifdef CONFIG_RCU_BOOST */
 
 		/*
@@ -1100,15 +1098,11 @@ static int rcu_boost(struct rcu_node *rnp)
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
1.7.4.4

