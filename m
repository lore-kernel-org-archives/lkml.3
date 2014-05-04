Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503AbaEDSBz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 14:01:55 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:47157 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751909AbaEDSBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 14:01:54 -0400
Date: Sun, 4 May 2014 11:01:46 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: lock_task_sighand() && rcu_boost()
Message-ID: <20140504180145.GC8754@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140503161133.GA8838@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140503161133.GA8838@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14050418-1542-0000-0000-0000018D6910
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 03, 2014 at 06:11:33PM +0200, Oleg Nesterov wrote:
> Paul,
> 
> I just noticed by accident that __lock_task_sighand() looks ugly and
> mysterious ;) And I am puzzled.
> 
> a841796f11c90d53 "signal: align __lock_task_sighand() irq disabling and RCU"
> says:
> 
> 	The __lock_task_sighand() function calls rcu_read_lock() with interrupts
> 	and preemption enabled, but later calls rcu_read_unlock() with interrupts
> 	disabled.  It is therefore possible that this RCU read-side critical
> 	section will be preempted and later RCU priority boosted, which means that
> 	rcu_read_unlock() will call rt_mutex_unlock() in order to deboost itself, but
> 	with interrupts disabled. This results in lockdep splats ...
> 
> OK, if we can't rcu_read_unlock() with irqs disabled, then we can at least
> cleanup it (and document the problem).

Just to clarify (probably unnecessarily), it is OK to invoke rcu_read_unlock()
with irqs disabled, but only if preemption has been disabled throughout
the entire RCU read-side critical section.

>                                        Say,
> 
> 	struct sighand_struct *__lock_task_sighand(struct task_struct *tsk,
> 						   unsigned long *flags)
> 	{
> 		struct sighand_struct *sighand;
> 
> 		rcu_read_lock();
> 		for (;;) {
> 			sighand = rcu_dereference(tsk->sighand);
> 			if (unlikely(sighand == NULL))
> 				break;
> 
> 			spin_lock_irqsave(&sighand->siglock, *flags);
> 			/*
> 			 * We delay rcu_read_unlock() till unlock_task_sighand()
> 			 * to avoid rt_mutex_unlock(current->rcu_boost_mutex) with
> 			 * irqs disabled.
> 			 */
> 			if (likely(sighand == tsk->sighand))
> 				return sighand;
> 			spin_unlock_irqrestore(&sighand->siglock, *flags);
> 		}
> 		rcu_read_unlock();
> 
> 		return sighand;	/* NULL */
> 	}
> 
> and add rcu_read_unlock() into unlock_task_sighand().

That should also work.

> But. I simply can't understand why lockdep should complain? Why it is bad
> to lock/unlock ->wait_lock with irqs disabled?

Well, lockdep doesn't -always- complain, and some cases are OK.

The problem is that if the RCU read-side critical section has been
preempted, and if this task gets RCU priority-boosted in the meantime,
then the task will need to acquire scheduler rq and pi locks at
rcu_read_unlock() time.  If the reason that interrupts are disabled at
rcu_read_unlock() time is that either rq or pi locks are held (or some
other locks are held that are normally acquired while holding rq or
pi locks), then we can deadlock.  And lockdep will of course complain.

If I recall corectly, at one point, the ->siglock lock was acquired
while holding the rq locks, which would have resulted in lockdep
complaints.

> wakeup_next_waiter() and rt_mutex_adjust_prio() should be fine, they start
> with _irqsave().

Hmmm...  A better description of the bad case might be as follows:

	Deadlock can occur if you have an RCU read-side critical
	section that is anywhere preemptible, and where the outermost
	rcu_read_unlock() is invoked while holding and lock acquired
	by either wakeup_next_waiter() or rt_mutex_adjust_prio(),
	or while holding any lock that is ever acquired while holding
	one of those locks.

Does that help?

Avoiding this bad case could be a bit ugly, as it is a dynamic set
of locks that is acquired while holding any lock acquired by either
wakeup_next_waiter() or rt_mutex_adjust_prio().  So I simplified the
rule by prohibiting invoking rcu_read_unlock() with irqs disabled
if the RCU read-side critical section had ever been preemptible.

Perhaps it is time to start using the more complex but more accurate
rule, though keeping it all straight could be tough.  Plus RCU priority
boosting happens rarely, so there is no guarantee that lockdep will
catch problems in a reasonable timeframe.

> The changelog also says:
> 
> 	It is quite possible that a better long-term fix is to make rt_mutex_unlock()
> 	disable irqs when acquiring the rt_mutex structure's ->wait_lock.
> 
> and if it is actually bad, then how the change above can fix the problem?

At this point, I am not seeing how it would help.  Color me confused.  :-/

							Thanx, Paul

> Help!
> 
> Oleg.
> 

