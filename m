Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932693AbaFKPw6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 11:52:58 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:58865 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752163AbaFKPw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 11:52:57 -0400
Date: Wed, 11 Jun 2014 08:52:51 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Steven Rostedt <rostedt@goodmis.org>, Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Clark Williams <williams@redhat.com>
Subject: Re: safety of *mutex_unlock() (Was: [BUG] signal: sighand
 unprotected when accessed by /proc)
Message-ID: <20140611155251.GA4581@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140609181553.GA13681@redhat.com>
 <20140609142956.3d79e9d1@gandalf.local.home>
 <CA+55aFyO8bb7fS3AaQzfMq7geERQ1JpSdcRZ9Fbs5-tZP0oRXg@mail.gmail.com>
 <20140609154114.20585056@gandalf.local.home>
 <alpine.DEB.2.10.1406101051210.3830@nanos>
 <20140610165704.GA3110@redhat.com>
 <alpine.DEB.2.10.1406101959420.5170@nanos>
 <20140610141306.04a4bcf3@gandalf.local.home>
 <alpine.DEB.2.10.1406102203430.5170@nanos>
 <alpine.DEB.2.10.1406102210580.5170@nanos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1406102210580.5170@nanos>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14061115-9332-0000-0000-000001106424
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2014 at 10:13:20PM +0200, Thomas Gleixner wrote:
> On Tue, 10 Jun 2014, Thomas Gleixner wrote:
> > On Tue, 10 Jun 2014, Steven Rostedt wrote:
> > > On Tue, 10 Jun 2014 20:08:37 +0200 (CEST)
> > > Thomas Gleixner <tglx@linutronix.de> wrote:
> > > 
> > > 
> > > > > Perhaps it could simply do ->owner = RT_MUTEX_HAS_WAITERS to make this more
> > > > > clear...
> > > > 
> > > > Good point. The new owner can cleanup the mess.
> > > >  
> > > 
> > > I thought about this too. It should work with the added overhead that
> > > every time we go into the unlock slow path, we guarantee that the next
> > > lock will go into the lock slowpath.
> > > 
> > > As long as the new acquired lock does a fast unlock, then we get out of
> > > this spiral.
> > 
> > The alternative solution is to document WHY this is safe. I think I
> > prefer that one :)
> 
> And actually we keep the waiter bit set in wakeup_next_waiter()
> because we only dequeue the waiter from the lock owners pi waiter
> list, but not from the lock waiter list.
> 
> rt_mutex_set_owner() sets the waiters bit if the lock has waiters. I
> agree with Oleg that this is not obvious from the code.
> 
> So I add both a comment and open code it.

And for my part, I have queued the following, which should prevent RCU
from relying on rt_mutex_unlock() keeping hands off after unlock.
This passes light rcutorture testing.

Thoughts?

							Thanx, Paul

------------------------------------------------------------------------

rcu: Allow post-unlock reference for rt_mutex

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

diff --git a/kernel/rcu/tree.h b/kernel/rcu/tree.h
index bf2c1e669691..31194ee9dfa6 100644
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
index ec7627becaf0..99743e9ea8ed 100644
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

