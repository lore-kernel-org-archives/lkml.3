Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756350AbaFQS6G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 14:58:06 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:50710 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755447AbaFQS6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 14:58:03 -0400
Date: Tue, 17 Jun 2014 11:57:55 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Clark Williams <williams@redhat.com>
Subject: Re: safety of *mutex_unlock() (Was: [BUG] signal: sighand
 unprotected when accessed by /proc)
Message-ID: <20140617185755.GA8600@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140611172958.GF4581@linux.vnet.ibm.com>
 <20140611175934.GA28912@redhat.com>
 <20140611195613.GM4581@linux.vnet.ibm.com>
 <20140612172844.GA15795@redhat.com>
 <20140612203518.GZ4581@linux.vnet.ibm.com>
 <alpine.DEB.2.10.1406122337060.5170@nanos>
 <20140612222748.GF4581@linux.vnet.ibm.com>
 <20140612231944.GA30683@linux.vnet.ibm.com>
 <20140613150830.GB31794@redhat.com>
 <20140615054058.GJ4581@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140615054058.GJ4581@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14061718-9332-0000-0000-0000011EF02E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 14, 2014 at 10:40:58PM -0700, Paul E. McKenney wrote:
> On Fri, Jun 13, 2014 at 05:08:30PM +0200, Oleg Nesterov wrote:
> > On 06/12, Paul E. McKenney wrote:
> > >
> > > @@ -398,11 +399,9 @@ void rcu_read_unlock_special(struct task_struct *t)
> > >  #ifdef CONFIG_RCU_BOOST
> > >  		if (&t->rcu_node_entry == rnp->boost_tasks)
> > >  			rnp->boost_tasks = np;
> > > -		/* Snapshot/clear ->rcu_boost_mutex with rcu_node lock held. */
> > > -		if (t->rcu_boost_mutex) {
> > > -			rbmp = t->rcu_boost_mutex;
> > > -			t->rcu_boost_mutex = NULL;
> > > -		}
> > > +		/* Snapshot/clear ->boost_mutex with rcu_node lock held. */
> > > +		if (rt_mutex_owner(&rnp->boost_mtx) == t)
> > > +			rbmp = &rnp->boost_mtx;
> > 
> > The comment above looks confusing after this change ;) We do not clear it,
> > and it doesn't explain "with rcu_node lock held".
> > 
> > And, with or without this change it is not obvious why do we need "rbmp",
> > after this patch this becomes even more unobvious.
> > 
> > This is subjective of course, but perhaps it would be more understandable
> > to do
> > 
> > 	bool xxx;
> > 
> > 	...
> > 
> > 	// Check this under rcu_node lock to ensure that unlock below
> > 	// can't race with rt_mutex_init_proxy_locked() in progress.
> > 	xxx = rt_mutex_owner(&rnp->boost_mtx) == t;
> > 
> > 	...
> > 
> > 	// rnp->lock was dropped
> > 	if (xxx)
> > 		rt_mutex_unlock(&rnp->boost_mtx);
> > 
> > 
> > But this is very minor, I won't insist of course. Mostly I am just trying
> > to check my understanding.
> 
> No, this is good, and I will update accordingly.

I suppose I could have included the patch...

							Thanx, Paul

------------------------------------------------------------------------

rcu: Simplify priority boosting by putting rt_mutex in rcu_node

RCU priority boosting currently checks for boosting via a pointer in
task_struct.  However, this is not needed: As Oleg noted, if the
rt_mutex is placed in the rcu_node instead of on the booster's stack,
the boostee can simply check it see if it owns the lock.  This commit
makes this change, shrinking task_struct by one pointer and the kernel
by thirteen lines.

Suggested-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index 6df7f9fe0d01..2bb4c4f3531a 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -102,12 +102,6 @@ extern struct group_info init_groups;
 #define INIT_IDS
 #endif
 
-#ifdef CONFIG_RCU_BOOST
-#define INIT_TASK_RCU_BOOST()						\
-	.rcu_boost_mutex = NULL,
-#else
-#define INIT_TASK_RCU_BOOST()
-#endif
 #ifdef CONFIG_TREE_PREEMPT_RCU
 #define INIT_TASK_RCU_TREE_PREEMPT()					\
 	.rcu_blocked_node = NULL,
@@ -119,8 +113,7 @@ extern struct group_info init_groups;
 	.rcu_read_lock_nesting = 0,					\
 	.rcu_read_unlock_special = 0,					\
 	.rcu_node_entry = LIST_HEAD_INIT(tsk.rcu_node_entry),		\
-	INIT_TASK_RCU_TREE_PREEMPT()					\
-	INIT_TASK_RCU_BOOST()
+	INIT_TASK_RCU_TREE_PREEMPT()
 #else
 #define INIT_TASK_RCU_PREEMPT(tsk)
 #endif
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 306f4f0c987a..3cfbc05e66e6 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1270,9 +1270,6 @@ struct task_struct {
 #ifdef CONFIG_TREE_PREEMPT_RCU
 	struct rcu_node *rcu_blocked_node;
 #endif /* #ifdef CONFIG_TREE_PREEMPT_RCU */
-#ifdef CONFIG_RCU_BOOST
-	struct rt_mutex *rcu_boost_mutex;
-#endif /* #ifdef CONFIG_RCU_BOOST */
 
 #if defined(CONFIG_SCHEDSTATS) || defined(CONFIG_TASK_DELAY_ACCT)
 	struct sched_info sched_info;
@@ -2009,9 +2006,6 @@ static inline void rcu_copy_process(struct task_struct *p)
 #ifdef CONFIG_TREE_PREEMPT_RCU
 	p->rcu_blocked_node = NULL;
 #endif /* #ifdef CONFIG_TREE_PREEMPT_RCU */
-#ifdef CONFIG_RCU_BOOST
-	p->rcu_boost_mutex = NULL;
-#endif /* #ifdef CONFIG_RCU_BOOST */
 	INIT_LIST_HEAD(&p->rcu_node_entry);
 }
 
diff --git a/kernel/rcu/tree.h b/kernel/rcu/tree.h
index 31194ee9dfa6..db3f096ed80b 100644
--- a/kernel/rcu/tree.h
+++ b/kernel/rcu/tree.h
@@ -177,6 +177,9 @@ struct rcu_node {
 				/*  to carry out the boosting is fully */
 				/*  released with no future boostee accesses */
 				/*  before that rt_mutex is re-initialized. */
+	struct rt_mutex boost_mtx;
+				/* Used only for the priority-boosting */
+				/*  side effect, not as a lock. */
 	unsigned long boost_time;
 				/* When to start boosting (jiffies). */
 	struct task_struct *boost_kthread_task;
diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index dc98cacfef21..d8ae20f5ca87 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -29,6 +29,7 @@
 #include <linux/oom.h>
 #include <linux/smpboot.h>
 #include "../time/tick-internal.h"
+#include "../locking/rtmutex_common.h"
 
 #define RCU_KTHREAD_PRIO 1
 
@@ -336,7 +337,7 @@ void rcu_read_unlock_special(struct task_struct *t)
 	unsigned long flags;
 	struct list_head *np;
 #ifdef CONFIG_RCU_BOOST
-	struct rt_mutex *rbmp = NULL;
+	bool drop_boost_mutex = false;
 #endif /* #ifdef CONFIG_RCU_BOOST */
 	struct rcu_node *rnp;
 	int special;
@@ -398,11 +399,8 @@ void rcu_read_unlock_special(struct task_struct *t)
 #ifdef CONFIG_RCU_BOOST
 		if (&t->rcu_node_entry == rnp->boost_tasks)
 			rnp->boost_tasks = np;
-		/* Snapshot/clear ->rcu_boost_mutex with rcu_node lock held. */
-		if (t->rcu_boost_mutex) {
-			rbmp = t->rcu_boost_mutex;
-			t->rcu_boost_mutex = NULL;
-		}
+		/* Snapshot ->boost_mtx ownership with rcu_node lock held. */
+		drop_boost_mutex = rt_mutex_owner(&rnp->boost_mtx) == t;
 #endif /* #ifdef CONFIG_RCU_BOOST */
 
 		/*
@@ -427,8 +425,8 @@ void rcu_read_unlock_special(struct task_struct *t)
 
 #ifdef CONFIG_RCU_BOOST
 		/* Unboost if we were boosted. */
-		if (rbmp) {
-			rt_mutex_unlock(rbmp);
+		if (drop_boost_mutex) {
+			rt_mutex_unlock(&rnp->boost_mtx);
 			complete(&rnp->boost_completion);
 		}
 #endif /* #ifdef CONFIG_RCU_BOOST */
@@ -1151,7 +1149,6 @@ static void rcu_wake_cond(struct task_struct *t, int status)
 static int rcu_boost(struct rcu_node *rnp)
 {
 	unsigned long flags;
-	struct rt_mutex mtx;
 	struct task_struct *t;
 	struct list_head *tb;
 
@@ -1202,14 +1199,14 @@ static int rcu_boost(struct rcu_node *rnp)
 	 * section.
 	 */
 	t = container_of(tb, struct task_struct, rcu_node_entry);
-	rt_mutex_init_proxy_locked(&mtx, t);
-	t->rcu_boost_mutex = &mtx;
+	rt_mutex_init_proxy_locked(&rnp->boost_mtx, t);
 	init_completion(&rnp->boost_completion);
 	raw_spin_unlock_irqrestore(&rnp->lock, flags);
-	rt_mutex_lock(&mtx);  /* Side effect: boosts task t's priority. */
-	rt_mutex_unlock(&mtx);  /* Keep lockdep happy. */
+	/* Lock only for side effect: boosts task t's priority. */
+	rt_mutex_lock(&rnp->boost_mtx);
+	rt_mutex_unlock(&rnp->boost_mtx);  /* Then keep lockdep happy. */
 
-	/* Wait until boostee is done accessing mtx before reinitializing. */
+	/* Wait for boostee to be done w/boost_mtx before reinitializing. */
 	wait_for_completion(&rnp->boost_completion);
 
 	return ACCESS_ONCE(rnp->exp_tasks) != NULL ||

