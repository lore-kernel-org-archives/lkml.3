Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752633AbaFLUf1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 16:35:27 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:44151 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751964AbaFLUfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 16:35:25 -0400
Date: Thu, 12 Jun 2014 13:35:18 -0700
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
Message-ID: <20140612203518.GZ4581@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140610141306.04a4bcf3@gandalf.local.home>
 <alpine.DEB.2.10.1406102203430.5170@nanos>
 <alpine.DEB.2.10.1406102210580.5170@nanos>
 <20140611155251.GA4581@linux.vnet.ibm.com>
 <20140611170705.GA26816@redhat.com>
 <20140611171734.GA27457@redhat.com>
 <20140611172958.GF4581@linux.vnet.ibm.com>
 <20140611175934.GA28912@redhat.com>
 <20140611195613.GM4581@linux.vnet.ibm.com>
 <20140612172844.GA15795@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140612172844.GA15795@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14061220-7164-0000-0000-00000268F9BF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2014 at 07:28:44PM +0200, Oleg Nesterov wrote:
> On 06/11, Paul E. McKenney wrote:
> >
> > On Wed, Jun 11, 2014 at 07:59:34PM +0200, Oleg Nesterov wrote:
> > > On 06/11, Paul E. McKenney wrote:
> > > >
> > > > I was thinking of ->boost_completion as the way to solve it easily, but
> > > > what did you have in mind?
> > >
> > > I meant, rcu_boost() could probably just do "mtx->owner = t", we know that
> > > it was unlocked by us and nobody else can use it until we set
> > > t->rcu_boost_mutex.
> >
> > My concern with this is that rcu_read_unlock_special() could hypothetically
> > get preempted (either by kernel or hypervisor), so that it might be a long
> > time until it makes its reference.  But maybe that reference would be
> > harmless in this case.
> 
> Confused... Not sure I understand what did you mean, and certainly I do not
> understand how this connects to the proxy-locking method.
> 
> Could you explain?

Here is the hypothetical sequence of events, which cannot happen unless
the CPU releasing the lock accesses the structure after releasing
the lock:

	CPU 0				CPU 1 (booster)

	releases boost_mutex

					acquires boost_mutex
					releases boost_mutex
					post-release boost_mutex access?
					Loops to next task to boost
					proxy-locks boost_mutex

	post-release boost_mutex access:
		confused due to proxy-lock
		operation?

Now maybe this ends up being safe, but it sure feels like an accident
waiting to happen.  Some bright developer comes up with a super-fast
handoff, and blam, RCU priority boosting takes it in the shorts.  ;-)
In contrast, using the completion prevents this.

> > > And if we move it into rcu_node, then we can probably kill ->rcu_boost_mutex,
> > > rcu_read_unlock_special() could check rnp->boost_mutex->owner == current.
> >
> > If this was anywhere near a hot code path, I would be sorely tempted.
> 
> Ah, but I didn't mean perfomance. I think it is always good to try to remove
> something from task_struct, it is huge. I do not mean sizeof() in the first
> place, the very fact that I can hardly understand the purpose of a half of its
> members makes me sad ;)

Now -that- just might make a huge amount of sense!  Let's see...

o	We hold the rcu_node structure's ->lock when checking the owner
	(looks like rt_mutex_owner() is the right API).

o	We hold the rcu_node structure's ->lock when doing
	rt_mutex_init_proxy_locked().

o	We -don't- hold ->lock when releasing the rt_mutex, but that
	should be OK: The owner is releasing it, and it is going to
	not-owned, so no other task can possibly see ownership moving
	to/from them.

o	The rcu_node structure grows a bit, but not enough to worry
	about, and on most systems, the decrease in task_struct size
	will more than outweigh the increase in rcu_node size.

Looks quite promising, how about the following?  (Hey, it builds, so it
must be correct, right?)

							Thanx, Paul

------------------------------------------------------------------------

rcu: Simplify priority boosting by putting rt_mutex in rcu_node

RCU priority boosting currently checks for boosting via a pointer in
task_struct.  However, this is not needed: As Oleg noted, if the
rt_mutex is placed in the rcu_node instead of on the booster's stack,
the boostee can simply check it see if it owns the lock.  This commit
makes this change, shrinking task_struct by one pointer and the kernel
by three lines.

Suggested-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

 b/include/linux/sched.h    |    3 ---
 b/kernel/rcu/tree.h        |    3 +++
 b/kernel/rcu/tree_plugin.h |   19 ++++++++-----------
 3 files changed, 11 insertions(+), 14 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 25f54c79f757..6b90114764ff 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1222,9 +1222,6 @@ struct task_struct {
 #ifdef CONFIG_TREE_PREEMPT_RCU
 	struct rcu_node *rcu_blocked_node;
 #endif /* #ifdef CONFIG_TREE_PREEMPT_RCU */
-#ifdef CONFIG_RCU_BOOST
-	struct rt_mutex *rcu_boost_mutex;
-#endif /* #ifdef CONFIG_RCU_BOOST */
 
 #if defined(CONFIG_SCHEDSTATS) || defined(CONFIG_TASK_DELAY_ACCT)
 	struct sched_info sched_info;
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
index 99743e9ea8ed..7628095f1c47 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -398,11 +398,9 @@ void rcu_read_unlock_special(struct task_struct *t)
 #ifdef CONFIG_RCU_BOOST
 		if (&t->rcu_node_entry == rnp->boost_tasks)
 			rnp->boost_tasks = np;
-		/* Snapshot/clear ->rcu_boost_mutex with rcu_node lock held. */
-		if (t->rcu_boost_mutex) {
-			rbmp = t->rcu_boost_mutex;
-			t->rcu_boost_mutex = NULL;
-		}
+		/* Snapshot/clear ->boost_mutex with rcu_node lock held. */
+		if (rt_mutex_owner(&rnp->boost_mtx) == t)
+			rbmp = &rnp->boost_mtx;
 #endif /* #ifdef CONFIG_RCU_BOOST */
 
 		/*
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

