Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753786AbaEDTSh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 15:18:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21067 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753397AbaEDTSf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 15:18:35 -0400
Date: Sun, 4 May 2014 21:17:57 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: lock_task_sighand() && rcu_boost()
Message-ID: <20140504191757.GA11319@redhat.com>
References: <20140503161133.GA8838@redhat.com> <20140504180145.GC8754@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140504180145.GC8754@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/04, Paul E. McKenney wrote:
>
> On Sat, May 03, 2014 at 06:11:33PM +0200, Oleg Nesterov wrote:
> >
> > OK, if we can't rcu_read_unlock() with irqs disabled, then we can at least
> > cleanup it (and document the problem).
>
> Just to clarify (probably unnecessarily), it is OK to invoke rcu_read_unlock()
> with irqs disabled, but only if preemption has been disabled throughout
> the entire RCU read-side critical section.

Yes, yes, I understand, thanks.

> > and add rcu_read_unlock() into unlock_task_sighand().
>
> That should also work.

OK.

> > But. I simply can't understand why lockdep should complain? Why it is bad
> > to lock/unlock ->wait_lock with irqs disabled?
>
> Well, lockdep doesn't -always- complain, and some cases are OK.
>
> The problem is that if the RCU read-side critical section has been
> preempted, and if this task gets RCU priority-boosted in the meantime,
> then the task will need to acquire scheduler rq and pi locks at
> rcu_read_unlock() time.

Yes,

> If the reason that interrupts are disabled at
> rcu_read_unlock() time is that either rq or pi locks are held (or some
> other locks are held that are normally acquired while holding rq or
> pi locks), then we can deadlock.  And lockdep will of course complain.

Yes. but not in this case?

> If I recall corectly, at one point, the ->siglock lock was acquired
> while holding the rq locks, which would have resulted in lockdep
> complaints.

No, this must not be possible. signal_wake_up_state() was always called
under ->siglock and it does wake_up_state() which takes rq/pi locks.

And if lock_task_sighand() is preempted after rcu_read_lock(), then the
caller doesn't hold any lock.

So perhaps we can revert a841796f11c90d53 ?

Otherwise please see below.

> Hmmm...  A better description of the bad case might be as follows:
>
> 	Deadlock can occur if you have an RCU read-side critical
> 	section that is anywhere preemptible, and where the outermost
> 	rcu_read_unlock() is invoked while holding and lock acquired
> 	by either wakeup_next_waiter() or rt_mutex_adjust_prio(),
> 	or while holding any lock that is ever acquired while holding
> 	one of those locks.
>
> Does that help?
>
> Avoiding this bad case could be a bit ugly, as it is a dynamic set
> of locks that is acquired while holding any lock acquired by either
> wakeup_next_waiter() or rt_mutex_adjust_prio().  So I simplified the
> rule by prohibiting invoking rcu_read_unlock() with irqs disabled
> if the RCU read-side critical section had ever been preemptible.

OK, if you prefer to enforce this rule even if (say) lock_task_sighand()
is fine, then it needs the comment. And a cleanup ;)

We can move rcu_read_unlock() into unlock_task_sighand() as I suggested
before, or we can simply add preempt_disable/enable into lock_(),

	struct sighand_struct *__lock_task_sighand(struct task_struct *tsk,
						   unsigned long *flags)
	{
		struct sighand_struct *sighand;
		/*
		 * COMMENT TO EXPLAIN WHY
		 */
		preempt_disable();
		rcu_read_lock();
		for (;;) {
			sighand = rcu_dereference(tsk->sighand);
			if (unlikely(sighand == NULL))
				break;

			spin_lock_irqsave(&sighand->siglock, *flags);
			if (likely(sighand == tsk->sighand))
				break;
			spin_unlock_irqrestore(&sighand->siglock, *flags);
		}
		rcu_read_unlock();
		preempt_enable();

		return sighand;
	}

The only problem is the "COMMENT" above. Perhaps the "prohibit invoking
rcu_read_unlock() with irqs disabled if ..." rule should documented
near/above rcu_read_unlock() ? In this case that COMMENT could simply
say "see the comment above rcu_read_unlock()".

What do you think?

Oleg.

