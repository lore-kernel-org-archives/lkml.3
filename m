Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752635AbaECQML (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2014 12:12:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20700 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750855AbaECQMK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2014 12:12:10 -0400
Date: Sat, 3 May 2014 18:11:33 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: lock_task_sighand() && rcu_boost()
Message-ID: <20140503161133.GA8838@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul,

I just noticed by accident that __lock_task_sighand() looks ugly and
mysterious ;) And I am puzzled.

a841796f11c90d53 "signal: align __lock_task_sighand() irq disabling and RCU"
says:

	The __lock_task_sighand() function calls rcu_read_lock() with interrupts
	and preemption enabled, but later calls rcu_read_unlock() with interrupts
	disabled.  It is therefore possible that this RCU read-side critical
	section will be preempted and later RCU priority boosted, which means that
	rcu_read_unlock() will call rt_mutex_unlock() in order to deboost itself, but
	with interrupts disabled. This results in lockdep splats ...

OK, if we can't rcu_read_unlock() with irqs disabled, then we can at least
cleanup it (and document the problem). Say,

	struct sighand_struct *__lock_task_sighand(struct task_struct *tsk,
						   unsigned long *flags)
	{
		struct sighand_struct *sighand;

		rcu_read_lock();
		for (;;) {
			sighand = rcu_dereference(tsk->sighand);
			if (unlikely(sighand == NULL))
				break;

			spin_lock_irqsave(&sighand->siglock, *flags);
			/*
			 * We delay rcu_read_unlock() till unlock_task_sighand()
			 * to avoid rt_mutex_unlock(current->rcu_boost_mutex) with
			 * irqs disabled.
			 */
			if (likely(sighand == tsk->sighand))
				return sighand;
			spin_unlock_irqrestore(&sighand->siglock, *flags);
		}
		rcu_read_unlock();

		return sighand;	/* NULL */
	}

and add rcu_read_unlock() into unlock_task_sighand().

But. I simply can't understand why lockdep should complain? Why it is bad
to lock/unlock ->wait_lock with irqs disabled?

wakeup_next_waiter() and rt_mutex_adjust_prio() should be fine, they start
with _irqsave().

The changelog also says:

	It is quite possible that a better long-term fix is to make rt_mutex_unlock()
	disable irqs when acquiring the rt_mutex structure's ->wait_lock.

and if it is actually bad, then how the change above can fix the problem?

Help!

Oleg.

