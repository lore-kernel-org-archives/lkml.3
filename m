Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753165AbaGGWih (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 18:38:37 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:57481 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752672AbaGGWib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 18:38:31 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 08/17] rcu: Allow post-unlock reference for rt_mutex
Date: Mon,  7 Jul 2014 15:38:12 -0700
Message-Id: <1404772701-8804-8-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1404772701-8804-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140707223756.GA7187@linux.vnet.ibm.com>
 <1404772701-8804-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14070722-8236-0000-0000-000003A71C84
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

The current approach to RCU priority boosting uses an rt_mutex strictly
for its priority-boosting side effects.  The rt_mutex_init_proxy_locked()
function is used by the booster to initialize the lock as held by the
boostee.  The booster then uses rt_mutex_lock() to acquire this rt_mutex,
which priority-boosts the boostee.  When the boostee reaches the end
of its outermost RCU read-side critical section, it checks a field in
its task structure to see whether it has been boosted, and, if so, uses
rt_mutex_unlock() to release the rt_mutex.  The booster can then go on
to boost the next task that is blocking the current RCU grace period.

But reasonable implementations of rt_mutex_unlock() might result in the
boostee referencing the rt_mutex's data after releasing it.  But the
booster might have re-initialized the rt_mutex between the time that the
boostee released it and the time that it later referenced it.  This is
clearly asking for trouble, so this commit introduces a completion that
forces the booster to wait until the boostee has completely finished with
the rt_mutex, thus avoiding the case where the booster is re-initializing
the rt_mutex before the last boostee's last reference to that rt_mutex.

This of course does introduce some overhead, but the priority-boosting
code paths are miles from any possible fastpath, and the overhead of
executing the completion will normally be quite small compared to the
overhead of priority boosting and deboosting, so this should be OK.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcu/tree.h        | 5 +++++
 kernel/rcu/tree_plugin.h | 8 +++++++-
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/kernel/rcu/tree.h b/kernel/rcu/tree.h
index 0f69a79c5b7d..3eeb919e26a2 100644
--- a/kernel/rcu/tree.h
+++ b/kernel/rcu/tree.h
@@ -172,6 +172,11 @@ struct rcu_node {
 				/*  queued on this rcu_node structure that */
 				/*  are blocking the current grace period, */
 				/*  there can be no such task. */
+	struct completion boost_completion;
+				/* Used to ensure that the rt_mutex used */
+				/*  to carry out the boosting is fully */
+				/*  released with no future boostee accesses */
+				/*  before that rt_mutex is re-initialized. */
 	unsigned long boost_time;
 				/* When to start boosting (jiffies). */
 	struct task_struct *boost_kthread_task;
diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index 5da9f9b3abc9..9c811879d31e 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -427,8 +427,10 @@ void rcu_read_unlock_special(struct task_struct *t)
 
 #ifdef CONFIG_RCU_BOOST
 		/* Unboost if we were boosted. */
-		if (rbmp)
+		if (rbmp) {
 			rt_mutex_unlock(rbmp);
+			complete(&rnp->boost_completion);
+		}
 #endif /* #ifdef CONFIG_RCU_BOOST */
 
 		/*
@@ -1202,10 +1204,14 @@ static int rcu_boost(struct rcu_node *rnp)
 	t = container_of(tb, struct task_struct, rcu_node_entry);
 	rt_mutex_init_proxy_locked(&mtx, t);
 	t->rcu_boost_mutex = &mtx;
+	init_completion(&rnp->boost_completion);
 	raw_spin_unlock_irqrestore(&rnp->lock, flags);
 	rt_mutex_lock(&mtx);  /* Side effect: boosts task t's priority. */
 	rt_mutex_unlock(&mtx);  /* Keep lockdep happy. */
 
+	/* Wait until boostee is done accessing mtx before reinitializing. */
+	wait_for_completion(&rnp->boost_completion);
+
 	return ACCESS_ONCE(rnp->exp_tasks) != NULL ||
 	       ACCESS_ONCE(rnp->boost_tasks) != NULL;
 }
-- 
1.8.1.5

