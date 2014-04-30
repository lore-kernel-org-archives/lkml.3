Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945967AbaD3QnC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 12:43:02 -0400
Received: from g4t3425.houston.hp.com ([15.201.208.53]:51306 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933593AbaD3QnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 12:43:00 -0400
Message-ID: <1398876176.2618.12.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH v2] rwsem: Support optimistic spinning
From: Davidlohr Bueso <davidlohr@hp.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Alex Shi <alex.shi@linaro.org>,
        Andi Kleen <andi@firstfloor.org>,
        Michel Lespinasse <walken@google.com>, Rik van Riel <riel@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E.McKenney" <paulmck@linux.vnet.ibm.com>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>, linux-kernel@vger.kernel.org
Date: Wed, 30 Apr 2014 09:42:56 -0700
In-Reply-To: <20140430100047.GE11096@twins.programming.kicks-ass.net>
References: <1398205166.6345.7.camel@buesod1.americas.hpqcorp.net>
	 <1398722941.25549.16.camel@buesod1.americas.hpqcorp.net>
	 <20140430100047.GE11096@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-04-30 at 12:00 +0200, Peter Zijlstra wrote:
> On Mon, Apr 28, 2014 at 03:09:01PM -0700, Davidlohr Bueso wrote:
> >  __visible
> >  struct rw_semaphore __sched *rwsem_down_write_failed(struct rw_semaphore *sem)
> >  {
> > -	long count, adjustment = -RWSEM_ACTIVE_WRITE_BIAS;
> > +	long count;
> >  	struct rwsem_waiter waiter;
> >  	struct task_struct *tsk = current;
> > +	bool waiting = true;
> > +
> > +	/* undo write bias from down_write operation, stop active locking */
> > +	count = rwsem_atomic_update(-RWSEM_ACTIVE_WRITE_BIAS, sem);
> > +
> > +	/* do optimistic spinning and steal lock if possible */
> > +	if (rwsem_optimistic_spin(sem))
> > +		goto done;
> 
> Why done, why not return? Afaict there's not yet been a change to the
> state.

Right.

> >  
> >  	/* set up my own style of waitqueue */
> >  	waiter.task = tsk;
> > @@ -204,34 +382,29 @@ struct rw_semaphore __sched *rwsem_down_write_failed(struct rw_semaphore *sem)
> >  
> >  	raw_spin_lock_irq(&sem->wait_lock);
> >  	if (list_empty(&sem->wait_list))
> > -		adjustment += RWSEM_WAITING_BIAS;
> > +		waiting = false;
> >  	list_add_tail(&waiter.list, &sem->wait_list);
> >  
> >  	/* we're now waiting on the lock, but no longer actively locking */
> > -	count = rwsem_atomic_update(adjustment, sem);
> > +	if (waiting)
> > +		count = ACCESS_ONCE(sem->count);
> > +	else
> > +		count = rwsem_atomic_update(RWSEM_WAITING_BIAS, sem);
> > +
> 
> Is there a reason we must delay this? Why not do away with the waiting
> variable and do it where we check the list_empty() ?

Yeah, that would simplify things, afaict.

> 
> If there is a reason -- eg. we must order the list op vs the count op,
> then there's a comment missing.

There is no such reason.

> 
> > -	/* If there were already threads queued before us and there are no
> > +	/*
> > +	 * If there were already threads queued before us and there are no
> >  	 * active writers, the lock must be read owned; so we try to wake
> > -	 * any read locks that were queued ahead of us. */
> > -	if (count > RWSEM_WAITING_BIAS &&
> > -	    adjustment == -RWSEM_ACTIVE_WRITE_BIAS)
> > +	 * any read locks that were queued ahead of us.
> > +	 */
> > +	if ((count > RWSEM_WAITING_BIAS) && waiting)
> >  		sem = __rwsem_do_wake(sem, RWSEM_WAKE_READERS);
> >  
> >  	/* wait until we successfully acquire the lock */
> >  	set_task_state(tsk, TASK_UNINTERRUPTIBLE);
> 
> We should really use set_current_state(), there is no way tsk is
> anything other than current, and using set_task_state() implies we're
> changing someone else's state.
> 
> >  	while (true) {
> > -		if (!(count & RWSEM_ACTIVE_MASK)) {
> > -			/* Try acquiring the write lock. */
> > -			count = RWSEM_ACTIVE_WRITE_BIAS;
> > -			if (!list_is_singular(&sem->wait_list))
> > -				count += RWSEM_WAITING_BIAS;
> > -
> > -			if (sem->count == RWSEM_WAITING_BIAS &&
> > -			    cmpxchg(&sem->count, RWSEM_WAITING_BIAS, count) ==
> > -							RWSEM_WAITING_BIAS)
> > -				break;
> > -		}
> > -
> > +		if (rwsem_try_write_lock(count, sem))
> > +			break;
> >  		raw_spin_unlock_irq(&sem->wait_lock);
> >  
> >  		/* Block until there are no active lockers. */
> > @@ -245,8 +418,8 @@ struct rw_semaphore __sched *rwsem_down_write_failed(struct rw_semaphore *sem)
> >  
> >  	list_del(&waiter.list);
> >  	raw_spin_unlock_irq(&sem->wait_lock);
> > +done:
> >  	tsk->state = TASK_RUNNING;
> 
> __set_current_state(TASK_RUNNING);
> 
> Also, I would really expect this to be done right after the wait loop,
> not outside of the lock.

Sure.

> > -
> >  	return sem;
> >  }
> 
> Otherwise this looks ok I suppose.

Thanks for the review!

