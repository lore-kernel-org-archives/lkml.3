Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753421AbaE0WJe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 18:09:34 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:39437 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753255AbaE0WJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 18:09:33 -0400
Date: Tue, 27 May 2014 18:09:30 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: [patch 1/6] rtmutex: Fix deadlock detector for real
Message-ID: <20140527180930.1e9b020e@gandalf.local.home>
In-Reply-To: <20140522031949.725272460@linutronix.de>
References: <20140522031841.797415507@linutronix.de>
	<20140522031949.725272460@linutronix.de>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 May 2014 03:25:39 -0000
Thomas Gleixner <tglx@linutronix.de> wrote:

> The current deadlock detection logic does not work reliably due to the
> following early exit path:
> 
> 	/*
> 	 * Drop out, when the task has no waiters. Note,
> 	 * top_waiter can be NULL, when we are in the deboosting
> 	 * mode!
> 	 */
> 	if (top_waiter && (!task_has_pi_waiters(task) ||
> 			   top_waiter != task_top_pi_waiter(task)))
> 		goto out_unlock_pi;
> 
> So this not only exits when the task has no waiters, it also exits
> unconditionally when the current waiter is not the top priority waiter
> of the task.
> 
> So in a nested locking scenario, it might abort the lock chain walk
> and therefor miss a potential deadlock.
> 
> Simple fix: Continue the chain walk, when deadlock detection is
> enabled.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: stable@vger.kernel.org
> ---
>  kernel/locking/rtmutex.c |   27 +++++++++++++++++++++------
>  1 file changed, 21 insertions(+), 6 deletions(-)
> 
> Index: tip/kernel/locking/rtmutex.c
> ===================================================================
> --- tip.orig/kernel/locking/rtmutex.c
> +++ tip/kernel/locking/rtmutex.c
> @@ -343,16 +343,22 @@ static int rt_mutex_adjust_prio_chain(st
>  	 * top_waiter can be NULL, when we are in the deboosting
>  	 * mode!
>  	 */
> -	if (top_waiter && (!task_has_pi_waiters(task) ||
> -			   top_waiter != task_top_pi_waiter(task)))
> -		goto out_unlock_pi;
> +	if (top_waiter) {
> +		if (!task_has_pi_waiters(task))
> +			goto out_unlock_pi;
> +
> +		if (!detect_deadlock && top_waiter != task_top_pi_waiter(task))
> +			goto out_unlock_pi;
> +	}

The above seems obvious.

>  
>  	/*
>  	 * When deadlock detection is off then we check, if further
>  	 * priority adjustment is necessary.
>  	 */
> -	if (!detect_deadlock && waiter->prio == task->prio)
> -		goto out_unlock_pi;
> +	if (waiter->prio == task->prio) {
> +		if (!detect_deadlock)
> +			goto out_unlock_pi;
> +	}

This too.

Although! if you want to micro-optimize the detect_deadlock case
where !detect_deadlock is false. You might want to reverse the order.
That way we don't need to dereference the ->prio for both waiter and
task before seeing that we don't go to the out_unlock_pi.

	if (!detect_deadlock) {
		if (waiter->prio == task->prio)
			goto out_unlock_pi;
	}

Hmm, or you did it this way for your "don't requeue" patch? Looking at
that one, it seems you did.

	if (waiter->prio == task->prio) {
		if (!detect_deadlock)
			goto out_unlock_pi;
		requeue = false;
	}

Oh well. But for stable maybe have the optimized way? And change it
back when you add the requeue patch?

>  
>  	lock = waiter->lock;
>  	if (!raw_spin_trylock(&lock->wait_lock)) {
> @@ -361,7 +367,12 @@ static int rt_mutex_adjust_prio_chain(st
>  		goto retry;
>  	}
>  
> -	/* Deadlock detection */
> +	/*
> +	 * Deadlock detection. If the lock is the same as the original
> +	 * lock which caused us to walk the lock chain or if the
> +	 * current lock is owned by the task which initiated the chain
> +	 * walk, we detected a deadlock.
> +	 */
>  	if (lock == orig_lock || rt_mutex_owner(lock) == top_task) {
>  		debug_rt_mutex_deadlock(deadlock_detect, orig_waiter, lock);
>  		raw_spin_unlock(&lock->wait_lock);
> @@ -527,6 +538,10 @@ static int task_blocks_on_rt_mutex(struc
>  	unsigned long flags;
>  	int chain_walk = 0, res;
>  
> +	/* Early deadlock detection */
> +	if (detect_deadlock && owner == task)
> +		return -EDEADLK;
> +

This is an optimization, right? Does it belong for stable?

-- Steve

>  	raw_spin_lock_irqsave(&task->pi_lock, flags);
>  	__rt_mutex_adjust_prio(task);
>  	waiter->task = task;
> 

