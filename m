Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932135AbaFBOO0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 10:14:26 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:20648 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932095AbaFBOOZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 10:14:25 -0400
Date: Mon, 2 Jun 2014 10:14:23 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Jason Low <jason.low2@hp.com>
Subject: Re: [patch v2 5/5] rtmutex: Avoid pointless requeueing in the
 deadlock detection chain walk
Message-ID: <20140602101423.3b01e427@gandalf.local.home>
In-Reply-To: <20140531155739.518873369@linutronix.de>
References: <20140531155229.493650009@linutronix.de>
	<20140531155739.518873369@linutronix.de>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 31 May 2014 15:57:51 -0000
Thomas Gleixner <tglx@linutronix.de> wrote:
	/*
> -	 * When deadlock detection is off then we check, if further
> -	 * priority adjustment is necessary.
> +	 * If the waiter priority is the same as the task priority
> +	 * then there is no further priority adjustment necessary.  If
> +	 * deadlock detection is off, we stop the chain walk. If its
> +	 * enable we continue, but stop the requeueing in the chain
> +	 * walk.
>  	 */
> -	if (!detect_deadlock && waiter->prio == task->prio)
> -		goto out_unlock_pi;
> +	if (waiter->prio == task->prio) {
> +		if (!detect_deadlock)
> +			goto out_unlock_pi;
> +		requeue = false;
> +	}

I've been thinking about this some more. Not just from an optimization
point of view, but also code clarity point of view. For some reason,
every time I look at this if block, I need to formulate how and why
this works. I'm wondering, for readability, if we should add an else?

	if (waiter->prio == task->prio) {
		if (detect_deadlock)
			requeue = false;
		else
			goto out_unlock_pi;
	}

Does that read better? Functionality wise it's the same, so this would
only be to help understand the code better.

>  
>  	/*
>  	 * We need to trylock here as we are holding task->pi_lock,
> @@ -413,10 +425,16 @@ static int rt_mutex_adjust_prio_chain(st
>  	 */
>  	prerequeue_top_waiter = rt_mutex_top_waiter(lock);

We could move the setting of prerequeue_top_waiter into the if (requeue)
block too.

>  
> -	/* Requeue the waiter */
> -	rt_mutex_dequeue(lock, waiter);
> -	waiter->prio = task->prio;
> -	rt_mutex_enqueue(lock, waiter);
> +	/*
> +	 * Requeue the waiter, if we are in the boost/deboost
> +	 * operation and not just following the lock chain for
> +	 * deadlock detection.
> +	 */
> +	if (requeue) {
> +		rt_mutex_dequeue(lock, waiter);
> +		waiter->prio = task->prio;
> +		rt_mutex_enqueue(lock, waiter);
> +	}
>  
>  	/* Release the task */
>  	raw_spin_unlock_irqrestore(&task->pi_lock, flags);
> @@ -431,7 +449,8 @@ static int rt_mutex_adjust_prio_chain(st
>  		 * If the requeue above changed the top waiter, then we need
>  		 * to wake the new top waiter up to try to get the lock.
>  		 */
> -		if (prerequeue_top_waiter != rt_mutex_top_waiter(lock))
> +		if (requeue &&
> +		    prerequeue_top_waiter != rt_mutex_top_waiter(lock))
>  			wake_up_process(rt_mutex_top_waiter(lock)->task);
>  		raw_spin_unlock(&lock->wait_lock);
>  		goto out_put_task;
> @@ -441,38 +460,44 @@ static int rt_mutex_adjust_prio_chain(st
>  	/* Grab the next task */
>  	task = rt_mutex_owner(lock);
>  	get_task_struct(task);
> -	raw_spin_lock_irqsave(&task->pi_lock, flags);
>  
> -	if (waiter == rt_mutex_top_waiter(lock)) {
> -		/*
> -		 * The waiter became the new top (highest priority)
> -		 * waiter on the lock. Replace the previous top waiter
> -		 * in the owner tasks pi waiters list with this waiter.
> -		 */
> -		rt_mutex_dequeue_pi(task, prerequeue_top_waiter);
> -		rt_mutex_enqueue_pi(task, waiter);
> -		__rt_mutex_adjust_prio(task);
> +	if (requeue) {
> +		raw_spin_lock_irqsave(&task->pi_lock, flags);
>  
> -	} else if (prerequeue_top_waiter == waiter) {
> -		/*
> -		 * The waiter was the top waiter on the lock, but is
> -		 * no longer the top prority waiter. Replace waiter in
> -		 * the owner tasks pi waiters list with the new top
> -		 * (highest priority) waiter.
> -		 */
> -		rt_mutex_dequeue_pi(task, waiter);
> -		waiter = rt_mutex_top_waiter(lock);
> -		rt_mutex_enqueue_pi(task, waiter);
> -		__rt_mutex_adjust_prio(task);
> +		if (waiter == rt_mutex_top_waiter(lock)) {
> +			/*
> +			 * The waiter became the new top (highest
> +			 * priority) waiter on the lock. Replace the
> +			 * previous top waiter in the owner tasks pi
> +			 * waiters list with this waiter.

FYI,

			* The waiter became the new top (highest priority)
			* waiter on the lock. Replace the previous top waiter
			* in the owner tasks pi waiters list with this waiter.

Is still under the 80 char limit.


> +			 */
> +			rt_mutex_dequeue_pi(task, prerequeue_top_waiter);
> +			rt_mutex_enqueue_pi(task, waiter);
> +			__rt_mutex_adjust_prio(task);
> +
> +		} else if (prerequeue_top_waiter == waiter) {
> +			/*
> +			 * The waiter was the top waiter on the lock,
> +			 * but is no longer the top prority
> +			 * waiter. Replace waiter in the owner tasks
> +			 * pi waiters list with the new top (highest
> +			 * priority) waiter.

FYI,

			* The waiter was the top waiter on the lock, but is no
			* longer the top priority waiter. Replace waiter in the
			* owner tasks pi waiters list with the new top (hightest
			* priority) waiter.

Is also under the 80 char limit.


> +			 */
> +			rt_mutex_dequeue_pi(task, waiter);
> +			waiter = rt_mutex_top_waiter(lock);
> +			rt_mutex_enqueue_pi(task, waiter);
> +			__rt_mutex_adjust_prio(task);
> +
> +		} else {
> +			/*
> +			 * Nothing changed. No need to do any priority
> +			 * adjustment.
> +			 */
>  
> -	} else {
> -		/*
> -		 * Nothing changed. No need to do any priority
> -		 * adjustment.
> -		 */
> -	}
> +		}
>  
> -	raw_spin_unlock_irqrestore(&task->pi_lock, flags);
> +		raw_spin_unlock_irqrestore(&task->pi_lock, flags);
> +	}
>  
>  	top_waiter = rt_mutex_top_waiter(lock);
>  	raw_spin_unlock(&lock->wait_lock);
> 

As I only had small nits to comment about, the rest looks good...


Reviewed-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve
