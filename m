Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756670AbaIWTHE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 15:07:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65506 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754196AbaIWTHB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 15:07:01 -0400
Date: Tue, 23 Sep 2014 21:03:48 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] signal: simplify deadlock-avoidance in
	lock_task_sighand()
Message-ID: <20140923190348.GA13976@redhat.com>
References: <20140922164404.GA28910@redhat.com> <20140922164437.GA28939@redhat.com> <20140922145828.4d06108a@gandalf.local.home> <20140922191130.GA4527@redhat.com> <20140922172405.71c4a110@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140922172405.71c4a110@gandalf.local.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/22, Steven Rostedt wrote:
>
> On Mon, 22 Sep 2014 21:11:30 +0200
> Oleg Nesterov <oleg@redhat.com> wrote:
>
> > > > @@ -1261,30 +1261,25 @@ struct sighand_struct *__lock_task_sighand(struct task_struct *tsk,
> > > >  					   unsigned long *flags)
> > > >  {
> > > >  	struct sighand_struct *sighand;
> > > > -
> > > > +	/*
> > > > +	 * We are going to do rcu_read_unlock() under spin_lock_irqsave().
> > > > +	 * Make sure we can not be preempted after rcu_read_lock(), see
> > > > +	 * rcu_read_unlock() comment header for details.
> > > > +	 */
> > > > +	preempt_disable();
> > >
> > > The sad part is, this is going to break -rt.
> >
> > Hmm, why??
>
> Because in -rt, siglock is a mutex.

Yes, thanks... I thougt that -rt should handle this somehow, we have
more examples of preempt_disable() + spin_lock().

OK, let's forger this patch. It was supposed to be a cleanup, it should
not disturb -rt.

> > In fact this deadlock is not really possible in any case, scheduler locks
> > should be fine under ->siglock (for example, signal_wake_up() is called
> > under this lock).
> >
> > But, the comment above rcu_read_unlock() says:
> >
> > 	Given that the set of locks acquired by rt_mutex_unlock() might change
> > 	at any time, a somewhat more future-proofed approach is to make sure
> > 	that that preemption never happens ...
>
> Hmm, I'm not sure we need to worry about this. As in -rt siglock is a
> mutex, which is rt_mutex() itself, I highly doubt we will have
> rt_mutex_unlock() grab siglock, otherwise that would cause havoc in -rt.

Yes. And, the changelog in a841796f "signal: align __lock_task_sighand() irq
disabling and RCU" says:

	It is therefore possible that this RCU read-side critical
	section will be preempted and later RCU priority boosted, which means
	that rcu_read_unlock() will call rt_mutex_unlock() in order to deboost
	itself, but with interrupts disabled. This results in lockdep splats
	...
	It is quite possible that a better long-term fix is to make rt_mutex_unlock()
	disable irqs when acquiring the rt_mutex structure's ->wait_lock.

but this doesn't look right, raw_spin_lock(&lock->wait_lock) should be
fine with irqs disabled or I am totally confused. rt_mutex_adjust_prio()
does _irqsave/irqrestore, so this can't enable interrupts.

Paul, will you agree if we turn it into

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
		if (likely(sighand == tsk->sighand))
			break;
		spin_unlock_irqrestore(&sighand->siglock, *flags);
	}
	/*
	 * On the succesfull return we hold ->siglock. According to comment
	 * above rcu_read_unlock() this is against the rules, but scheduler
	 * locks are fine under this lock, signal_wake_up() takes them too.
	 */
	rcu_read_unlock();

	return sighand;
}

?

Or I can leave this code alone, this is the minor cleanup. Just to me this
sequence

	local_irq_save();
	rcu_read_lock();
	spin_lock();

looks a bit confusing/annoying even with the comment.

Oleg.

