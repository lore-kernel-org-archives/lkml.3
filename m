Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753393AbaFMQ1m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 12:27:42 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:45052 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750901AbaFMQ1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 12:27:41 -0400
Date: Fri, 13 Jun 2014 12:27:39 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [patch V4 03/10] rtmutex: Simplify and document
 try_to_take_rtmutex()
Message-ID: <20140613122739.2eb7ba1f@gandalf.local.home>
In-Reply-To: <20140611183853.118544688@linutronix.de>
References: <20140611182944.108526809@linutronix.de>
	<20140611183853.118544688@linutronix.de>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jun 2014 18:44:05 -0000
Thomas Gleixner <tglx@linutronix.de> wrote:

> The current implementation of try_to_take_rtmutex() is correct, but
> requires more than a single brain twist to understand the clever
> encoded conditionals.
> 
> Untangle it and document the cases proper.
> 
> Looks less efficient at the first glance, but actually reduces the
> binary code size on x8664 by 80 bytes.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> ---
>  kernel/locking/rtmutex.c |  131 +++++++++++++++++++++++++++++++----------------
>  1 file changed, 87 insertions(+), 44 deletions(-)
> 
> Index: tip/kernel/locking/rtmutex.c
> ===================================================================
> --- tip.orig/kernel/locking/rtmutex.c
> +++ tip/kernel/locking/rtmutex.c
> @@ -535,74 +535,117 @@ static int rt_mutex_adjust_prio_chain(st
>   *
>   * @lock:   the lock to be acquired.
>   * @task:   the task which wants to acquire the lock
> - * @waiter: the waiter that is queued to the lock's wait list. (could be NULL)
> + * @waiter: the waiter that is queued to the lock's wait list. (can be
> + *	    NULL, if called due to trylock attempts from
> + *	    rt_mutex_slowlock() or rt_mutex_slowtrylock().

In other words, waiter is non null iff @task is already queued on the
lock (task_blocked_on_lock() was called).


>   */
>  static int try_to_take_rt_mutex(struct rt_mutex *lock, struct task_struct *task,
> -		struct rt_mutex_waiter *waiter)
> +				struct rt_mutex_waiter *waiter)
>  {
> +	unsigned long flags;
> +
>  	/*
> -	 * We have to be careful here if the atomic speedups are
> -	 * enabled, such that, when
> -	 *  - no other waiter is on the lock
> -	 *  - the lock has been released since we did the cmpxchg
> -	 * the lock can be released or taken while we are doing the
> -	 * checks and marking the lock with RT_MUTEX_HAS_WAITERS.
> +	 * Before testing whether we can acquire @lock, we set the
> +	 * RT_MUTEX_HAS_WAITERS bit in @lock->owner. This forces all
> +	 * other tasks which try to modify @lock into the slow path
> +	 * and they serialize on @lock->wait_lock.
> +	 *
> +	 * The RT_MUTEX_HAS_WAITERS bit can have a transitional state
> +	 * as explained at the top of this file if and only if:
>  	 *
> -	 * The atomic acquire/release aware variant of
> -	 * mark_rt_mutex_waiters uses a cmpxchg loop. After setting
> -	 * the WAITERS bit, the atomic release / acquire can not
> -	 * happen anymore and lock->wait_lock protects us from the
> -	 * non-atomic case.
> +	 * - There is a lock owner. The caller must fixup the
> +	 *   transient state if it does a trylock or leaves the lock
> +	 *   function due to a signal or timeout.
>  	 *
> -	 * Note, that this might set lock->owner =
> -	 * RT_MUTEX_HAS_WAITERS in the case the lock is not contended
> -	 * any more. This is fixed up when we take the ownership.
> -	 * This is the transitional state explained at the top of this file.
> +	 * - @task acquires the lock and there are no other
> +	 *   waiters. This is undone in rt_mutex_set_owner(@task) at
> +	 *   the end of this function.
>  	 */
>  	mark_rt_mutex_waiters(lock);
>  
> +	/*
> +	 * If @lock has an owner, give up.
> +	 */
>  	if (rt_mutex_owner(lock))
>  		return 0;
>  
>  	/*
> -	 * It will get the lock because of one of these conditions:
> -	 * 1) there is no waiter
> -	 * 2) higher priority than waiters
> -	 * 3) it is top waiter
> -	 */
> -	if (rt_mutex_has_waiters(lock)) {
> -		if (task->prio >= rt_mutex_top_waiter(lock)->prio) {
> -			if (!waiter || waiter != rt_mutex_top_waiter(lock))
> -				return 0;
> -		}
> -	}
> +	 * If @waiter != NULL, @task has already enqueued the waiter
> +	 * into @lock waiter list. If @waiter == NULL then this is a

Ah, you state my comment here :-)

> +	 * trylock attempt.
> +	 */
> +	if (waiter) {
> +		/*
> +		 * If waiter is not the highest priority waiter of
> +		 * @lock, give up.
> +		 */
> +		if (waiter != rt_mutex_top_waiter(lock))
> +			return 0;
>  
> -	if (waiter || rt_mutex_has_waiters(lock)) {
> -		unsigned long flags;
> -		struct rt_mutex_waiter *top;
> -
> -		raw_spin_lock_irqsave(&task->pi_lock, flags);
> -
> -		/* remove the queued waiter. */
> -		if (waiter) {
> -			rt_mutex_dequeue(lock, waiter);
> -			task->pi_blocked_on = NULL;
> -		}
> +		/*
> +		 * We can acquire the lock. Remove the waiter from the
> +		 * lock waiters list.
> +		 */
> +		rt_mutex_dequeue(lock, waiter);
>  
> +	} else {
>  		/*
> -		 * We have to enqueue the top waiter(if it exists) into
> -		 * task->pi_waiters list.
> +		 * If the lock has waiters already we check whether @task is
> +		 * eligible to take over the lock.
> +		 *
> +		 * If there are no other waiters, @task can acquire the lock.


> +		 * @task->pi_blocked_on is NULL

This is rather out of the blue. What does it mean? Why did you state
this? Maybe you meant to continue to say:

 ... is NULL, so it does not need to be dequeued.


>  		 */
>  		if (rt_mutex_has_waiters(lock)) {
> -			top = rt_mutex_top_waiter(lock);
> -			rt_mutex_enqueue_pi(task, top);
> +			/*
> +			 * If @task->prio is greater than or equal to
> +			 * the top waiter priority (kernel view),
> +			 * @task lost.
> +			 */
> +			if (task->prio >= rt_mutex_top_waiter(lock)->prio)

Didn't we have a function for this test? Oh wait, that's for the -rt
patch ;-)

> +				return 0;
> +
> +			/*
> +			 * The current top waiter stays enqueued. We
> +			 * don't have to change anything in the lock
> +			 * waiters order.
> +			 */
> +		} else {
> +			/*
> +			 * No waiters. Take the lock without the
> +			 * pi_lock dance.@task->pi_blocked_on is NULL

s/\.\@/. @/

> +			 * and we have no waiters to enqueue in @task
> +			 * pi waiters list.
> +			 */
> +			goto takeit;
>  		}
> -		raw_spin_unlock_irqrestore(&task->pi_lock, flags);
>  	}
>  
> +	/*
> +	 * Clear @task->pi_blocked_on. Requires protection by
> +	 * @task->pi_lock. Redundant operation for the @waiter == NULL
> +	 * case, but conditionals are more expensive than a redundant
> +	 * store.
> +	 */
> +	raw_spin_lock_irqsave(&task->pi_lock, flags);
> +	task->pi_blocked_on = NULL;
> +	/*
> +	 * Finish the lock acquisition. @task is the new owner. If
> +	 * other waiters exist we have to insert the highest priority
> +	 * waiter into @task->pi_waiters list.
> +	 */
> +	if (rt_mutex_has_waiters(lock))
> +		rt_mutex_enqueue_pi(task, rt_mutex_top_waiter(lock));
> +	raw_spin_unlock_irqrestore(&task->pi_lock, flags);
> +
> +takeit:
>  	/* We got the lock. */
>  	debug_rt_mutex_lock(lock);
>  
> +	/*
> +	 * This either preserves the RT_MUTEX_HAS_WAITERS bit if there
> +	 * are still waiters or clears it.
> +	 */
>  	rt_mutex_set_owner(lock, task);
>  
>  	rt_mutex_deadlock_account_lock(lock, task);
> 

Much more readable and honestly, it looks more efficient than the
original maze. Good job!

Reviewed-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve

