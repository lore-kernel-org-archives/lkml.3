Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756020AbaEOVjk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 17:39:40 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:61919 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753379AbaEOVjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 17:39:39 -0400
Date: Thu, 15 May 2014 17:39:37 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [patch 2/2] rtmutex: Avoid pointless requeueing in the deadlock
 detection chain walk
Message-ID: <20140515173937.402a9fae@gandalf.local.home>
In-Reply-To: <20140514200104.670614672@linutronix.de>
References: <20140514195705.618583609@linutronix.de>
	<20140514200104.670614672@linutronix.de>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 May 2014 20:03:27 -0000
Thomas Gleixner <tglx@linutronix.de> wrote:
 
>  	/* Release the task */
>  	raw_spin_unlock_irqrestore(&task->pi_lock, flags);
> +	/*
> +	 * We must abort the chain walk if there is no lock owner even
> +	 * in the dead lock detection case, as we have nothing to
> +	 * follow here.
> +	 */
>  	if (!rt_mutex_owner(lock)) {
>  		/*
>  		 * If the requeue above changed the top waiter, then we need
>  		 * to wake the new top waiter up to try to get the lock.
>  		 */
> -
>  		if (top_waiter != rt_mutex_top_waiter(lock))
>  			wake_up_process(rt_mutex_top_waiter(lock)->task);

Seems we can change the above if condition to:

	if (requeue && top_waiter != rt_mutex_top_waiter(lock))

as there was no "requeue above" that could change anything.

-- Steve


>  		raw_spin_unlock(&lock->wait_lock);
> @@ -404,18 +413,20 @@ static int rt_mutex_adjust_prio_chain(st
>  	get_task_struct(task);
>  	raw_spin_lock_irqsave(&task->pi_lock, flags);
>  
> -	if (waiter == rt_mutex_top_waiter(lock)) {
> -		/* Boost the owner */
> -		rt_mutex_dequeue_pi(task, top_waiter);
> -		rt_mutex_enqueue_pi(task, waiter);
> -		__rt_mutex_adjust_prio(task);
> -
> -	} else if (top_waiter == waiter) {
> -		/* Deboost the owner */
> -		rt_mutex_dequeue_pi(task, waiter);
> -		waiter = rt_mutex_top_waiter(lock);
> -		rt_mutex_enqueue_pi(task, waiter);
> -		__rt_mutex_adjust_prio(task);
> +	if (requeue) {
> +		if (waiter == rt_mutex_top_waiter(lock)) {
> +			/* Boost the owner */
> +			rt_mutex_dequeue_pi(task, top_waiter);
> +			rt_mutex_enqueue_pi(task, waiter);
> +			__rt_mutex_adjust_prio(task);
> +
> +		} else if (top_waiter == waiter) {
> +			/* Deboost the owner */
> +			rt_mutex_dequeue_pi(task, waiter);
> +			waiter = rt_mutex_top_waiter(lock);
> +			rt_mutex_enqueue_pi(task, waiter);
> +			__rt_mutex_adjust_prio(task);
> +		}
>  	}
>  
>  	raw_spin_unlock_irqrestore(&task->pi_lock, flags);
> 

