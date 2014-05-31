Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933793AbaEaCT6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 22:19:58 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:21460 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932229AbaEaCT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 22:19:57 -0400
Date: Fri, 30 May 2014 22:19:55 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: [patch 5/6] rtmutex: Clarify the lock chain walk
Message-ID: <20140530221955.620e2b61@gandalf.local.home>
In-Reply-To: <20140522031950.168005692@linutronix.de>
References: <20140522031841.797415507@linutronix.de>
	<20140522031950.168005692@linutronix.de>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 May 2014 03:25:54 -0000
Thomas Gleixner <tglx@linutronix.de> wrote:

> Add a separate local variable for the boost/deboost logic to make the
> code more readable. Add comments where appropriate.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> ---
>  kernel/locking/rtmutex.c |   50 +++++++++++++++++++++++++++++++++++++++--------
>  1 file changed, 42 insertions(+), 8 deletions(-)
> 
> Index: tip/kernel/locking/rtmutex.c
> ===================================================================
> --- tip.orig/kernel/locking/rtmutex.c
> +++ tip/kernel/locking/rtmutex.c
> @@ -302,9 +302,10 @@ static int rt_mutex_adjust_prio_chain(st
>  				      struct rt_mutex_waiter *orig_waiter,
>  				      struct task_struct *top_task)
>  {
> -	struct rt_mutex *lock;
>  	struct rt_mutex_waiter *waiter, *top_waiter = orig_waiter;
> +	struct rt_mutex_waiter *prerequeue_top_waiter;
>  	int detect_deadlock, ret = 0, depth = 0;
> +	struct rt_mutex *lock;
>  	unsigned long flags;
>  
>  	detect_deadlock = rt_mutex_cond_detect_deadlock(orig_waiter,
> @@ -379,6 +380,11 @@ static int rt_mutex_adjust_prio_chain(st
>  	}
>  
>  	lock = waiter->lock;
> +	/*
> +	 * We need to trylock here as we are holding task->pi_lock,
> +	 * which is the reverse lock order versus the other rtmutex
> +	 * operations.
> +	 */
>  	if (!raw_spin_trylock(&lock->wait_lock)) {
>  		raw_spin_unlock_irqrestore(&task->pi_lock, flags);
>  		cpu_relax();
> @@ -398,7 +404,11 @@ static int rt_mutex_adjust_prio_chain(st
>  		goto out_unlock_pi;
>  	}
>  
> -	top_waiter = rt_mutex_top_waiter(lock);
> +	/*
> +	 * Store the top waiter before doing any requeue operation. We
> +	 * need it for the boost/deboost decision below.
> +	 */
> +	prerequeue_top_waiter = rt_mutex_top_waiter(lock);
>  
>  	/* Requeue the waiter */
>  	rt_mutex_dequeue(lock, waiter);
> @@ -407,13 +417,18 @@ static int rt_mutex_adjust_prio_chain(st
>  
>  	/* Release the task */
>  	raw_spin_unlock_irqrestore(&task->pi_lock, flags);
> +
> +	/*
> +	 * We must abort the chain walk if there is no lock owner even
> +	 * in the dead lock detection case, as we have nothing to
> +	 * follow here.

You could mention that this is the end of the chain. That is, the chain
is lock->owner->lock->owner->lock->...  Once you have a lock without
owner, or a owner not blocked on a lock, that's it. Pretty self
explanatory. Don't Need to change anything. Just add "This is the end
of the chain that we are walking."


> +	 */
>  	if (!rt_mutex_owner(lock)) {
>  		/*
>  		 * If the requeue above changed the top waiter, then we need
>  		 * to wake the new top waiter up to try to get the lock.
>  		 */
> -
> -		if (top_waiter != rt_mutex_top_waiter(lock))
> +		if (prerequeue_top_waiter != rt_mutex_top_waiter(lock))
>  			wake_up_process(rt_mutex_top_waiter(lock)->task);
>  		raw_spin_unlock(&lock->wait_lock);
>  		goto out_put_task;
> @@ -426,17 +441,31 @@ static int rt_mutex_adjust_prio_chain(st
>  	raw_spin_lock_irqsave(&task->pi_lock, flags);
>  
>  	if (waiter == rt_mutex_top_waiter(lock)) {
> -		/* Boost the owner */
> -		rt_mutex_dequeue_pi(task, top_waiter);
> +		/*
> +		 * The waiter became the top waiter on the
> +		 * lock. Remove the previous top waiter from the tasks
> +		 * pi waiters list and add waiter to it.

Just to be a bit more verbose:

 The waiter became the new top waiter on the lock. Replace the previous
 top waiter from the tasks pi waiters list with this waiter.

If anything, I like to use "Replace .. with" instead of "Remove .. add"
as for me, it gives a better idea of what is actually being done
instead of just stating how it is being implemented.


> +		 */
> +		rt_mutex_dequeue_pi(task, prerequeue_top_waiter);
>  		rt_mutex_enqueue_pi(task, waiter);
>  		__rt_mutex_adjust_prio(task);
>  
> -	} else if (top_waiter == waiter) {
> -		/* Deboost the owner */
> +	} else if (prerequeue_top_waiter == waiter) {
> +		/*
> +		 * The waiter was the top waiter on the lock. Remove
> +		 * waiter from the tasks pi waiters list and add the
> +		 * new top waiter to it.

Again, I would prefer to use "Replace .. with":

 The waiter was the top waiter on the lock but it is no longer the
 highest priority waiter. Replace the waiter from the tasks pi waiters
 list with the new top waiter (the highest priority one).


> +		 */
>  		rt_mutex_dequeue_pi(task, waiter);
>  		waiter = rt_mutex_top_waiter(lock);
>  		rt_mutex_enqueue_pi(task, waiter);
>  		__rt_mutex_adjust_prio(task);
> +
> +	} else {
> +		/*
> +		 * Nothing changed. No need to do any priority
> +		 * adjustment.
> +		 */
>  	}
>  
>  	raw_spin_unlock_irqrestore(&task->pi_lock, flags);
> @@ -444,6 +473,11 @@ static int rt_mutex_adjust_prio_chain(st
>  	top_waiter = rt_mutex_top_waiter(lock);
>  	raw_spin_unlock(&lock->wait_lock);
>  
> +	/*
> +	 * If the current waiter is not the top waiter on the lock,
> +	 * then we can stop the chain walk here if we are not in full
> +	 * deadlock detection mode.
> +	 */
>  	if (!detect_deadlock && waiter != top_waiter)
>  		goto out_put_task;
>  
> 

Rest looks good.

-- Steve
