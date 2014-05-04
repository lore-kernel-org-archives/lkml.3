Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753895AbaEDWiN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 18:38:13 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:35709 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752462AbaEDWiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 18:38:12 -0400
Date: Sun, 4 May 2014 15:38:04 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: lock_task_sighand() && rcu_boost()
Message-ID: <20140504223804.GF8754@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140503161133.GA8838@redhat.com>
 <20140504180145.GC8754@linux.vnet.ibm.com>
 <20140504191757.GA11319@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140504191757.GA11319@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14050422-0928-0000-0000-000001A4BFAF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 04, 2014 at 09:17:57PM +0200, Oleg Nesterov wrote:
> On 05/04, Paul E. McKenney wrote:
> >
> > On Sat, May 03, 2014 at 06:11:33PM +0200, Oleg Nesterov wrote:
> > >
> > > OK, if we can't rcu_read_unlock() with irqs disabled, then we can at least
> > > cleanup it (and document the problem).
> >
> > Just to clarify (probably unnecessarily), it is OK to invoke rcu_read_unlock()
> > with irqs disabled, but only if preemption has been disabled throughout
> > the entire RCU read-side critical section.
> 
> Yes, yes, I understand, thanks.
> 
> > > and add rcu_read_unlock() into unlock_task_sighand().
> >
> > That should also work.
> 
> OK.
> 
> > > But. I simply can't understand why lockdep should complain? Why it is bad
> > > to lock/unlock ->wait_lock with irqs disabled?
> >
> > Well, lockdep doesn't -always- complain, and some cases are OK.
> >
> > The problem is that if the RCU read-side critical section has been
> > preempted, and if this task gets RCU priority-boosted in the meantime,
> > then the task will need to acquire scheduler rq and pi locks at
> > rcu_read_unlock() time.
> 
> Yes,
> 
> > If the reason that interrupts are disabled at
> > rcu_read_unlock() time is that either rq or pi locks are held (or some
> > other locks are held that are normally acquired while holding rq or
> > pi locks), then we can deadlock.  And lockdep will of course complain.
> 
> Yes. but not in this case?
> 
> > If I recall corectly, at one point, the ->siglock lock was acquired
> > while holding the rq locks, which would have resulted in lockdep
> > complaints.
> 
> No, this must not be possible. signal_wake_up_state() was always called
> under ->siglock and it does wake_up_state() which takes rq/pi locks.
> 
> And if lock_task_sighand() is preempted after rcu_read_lock(), then the
> caller doesn't hold any lock.
> 
> So perhaps we can revert a841796f11c90d53 ?

Or just update it, your choice.

> Otherwise please see below.
> 
> > Hmmm...  A better description of the bad case might be as follows:
> >
> > 	Deadlock can occur if you have an RCU read-side critical
> > 	section that is anywhere preemptible, and where the outermost
> > 	rcu_read_unlock() is invoked while holding and lock acquired
> > 	by either wakeup_next_waiter() or rt_mutex_adjust_prio(),
> > 	or while holding any lock that is ever acquired while holding
> > 	one of those locks.
> >
> > Does that help?
> >
> > Avoiding this bad case could be a bit ugly, as it is a dynamic set
> > of locks that is acquired while holding any lock acquired by either
> > wakeup_next_waiter() or rt_mutex_adjust_prio().  So I simplified the
> > rule by prohibiting invoking rcu_read_unlock() with irqs disabled
> > if the RCU read-side critical section had ever been preemptible.
> 
> OK, if you prefer to enforce this rule even if (say) lock_task_sighand()
> is fine, then it needs the comment. And a cleanup ;)

Please see below for a proposed comment.  Thinking more about it, I list
both rules and leave the choice to the caller.  Please see the end of
this email for a patch adding a comment to rcu_read_unlock().

> We can move rcu_read_unlock() into unlock_task_sighand() as I suggested
> before, or we can simply add preempt_disable/enable into lock_(),
> 
> 	struct sighand_struct *__lock_task_sighand(struct task_struct *tsk,
> 						   unsigned long *flags)
> 	{
> 		struct sighand_struct *sighand;
> 		/*
> 		 * COMMENT TO EXPLAIN WHY
> 		 */
> 		preempt_disable();
> 		rcu_read_lock();
> 		for (;;) {
> 			sighand = rcu_dereference(tsk->sighand);
> 			if (unlikely(sighand == NULL))
> 				break;
> 
> 			spin_lock_irqsave(&sighand->siglock, *flags);
> 			if (likely(sighand == tsk->sighand))
> 				break;
> 			spin_unlock_irqrestore(&sighand->siglock, *flags);
> 		}
> 		rcu_read_unlock();
> 		preempt_enable();
> 
> 		return sighand;
> 	}
> 
> The only problem is the "COMMENT" above. Perhaps the "prohibit invoking
> rcu_read_unlock() with irqs disabled if ..." rule should documented
> near/above rcu_read_unlock() ? In this case that COMMENT could simply
> say "see the comment above rcu_read_unlock()".
> 
> What do you think?

Looks good to me!

							Thanx, Paul

------------------------------------------------------------------------

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index ca6fe55913b7..17ac3c63415f 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -884,6 +884,27 @@ static inline void rcu_read_lock(void)
 /**
  * rcu_read_unlock() - marks the end of an RCU read-side critical section.
  *
+ * In most situations, rcu_read_unlock() is immune from deadlock.
+ * However, in kernels built with CONFIG_RCU_BOOST, rcu_read_unlock()
+ * is responsible for deboosting, which it does via rt_mutex_unlock().
+ * However, this function acquires the scheduler's runqueue and
+ * priority-inheritance spinlocks.  Thus, deadlock could result if the
+ * caller of rcu_read_unlock() already held one of these locks or any lock
+ * acquired while holding them.
+ *
+ * That said, RCU readers are never priority boosted unless they were
+ * preempted.  Therefore, one way to avoid deadlock is to make sure
+ * that preemption never happens within any RCU read-side critical
+ * section whose outermost rcu_read_unlock() is called with one of
+ * rt_mutex_unlock()'s locks held.
+ *
+ * Given that the set of locks acquired by rt_mutex_unlock() might change
+ * at any time, a somewhat more future-proofed approach is to make sure that
+ * that preemption never happens within any RCU read-side critical
+ * section whose outermost rcu_read_unlock() is called with one of
+ * irqs disabled.  This approach relies on the fact that rt_mutex_unlock()
+ * currently only acquires irq-disabled locks.
+ *
  * See rcu_read_lock() for more information.
  */
 static inline void rcu_read_unlock(void)

