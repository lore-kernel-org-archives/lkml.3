Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751692AbaFFOZT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 10:25:19 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:42824 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750908AbaFFOZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 10:25:17 -0400
Date: Fri, 6 Jun 2014 10:25:15 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Brad Mouring <bmouring@ni.com>
Subject: Re: [patch 2/2] rtmutex: Detect changes in the pi lock chain
Message-ID: <20140606102515.4e2c9574@gandalf.local.home>
In-Reply-To: <20140605152801.930031935@linutronix.de>
References: <20140605152544.641846795@linutronix.de>
	<20140605152801.930031935@linutronix.de>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 05 Jun 2014 15:28:33 -0000
Thomas Gleixner <tglx@linutronix.de> wrote:
 
> @@ -536,8 +569,9 @@ static int task_blocks_on_rt_mutex(struc
>  {
>  	struct task_struct *owner = rt_mutex_owner(lock);
>  	struct rt_mutex_waiter *top_waiter = waiter;
> +	struct rt_mutex *next_lock = NULL;
>  	unsigned long flags;
> -	int chain_walk = 0, res;
> +	int chain_walk, res;
>  
>  	/*
>  	 * Early deadlock detection. We really don't want the task to
> @@ -569,19 +603,21 @@ static int task_blocks_on_rt_mutex(struc
>  	if (!owner)
>  		return 0;
>  
> +	raw_spin_lock_irqsave(&owner->pi_lock, flags);
>  	if (waiter == rt_mutex_top_waiter(lock)) {
> -		raw_spin_lock_irqsave(&owner->pi_lock, flags);
>  		rt_mutex_dequeue_pi(owner, top_waiter);
>  		rt_mutex_enqueue_pi(owner, waiter);
>  
>  		__rt_mutex_adjust_prio(owner);
>  		if (owner->pi_blocked_on)
>  			chain_walk = 1;
> -		raw_spin_unlock_irqrestore(&owner->pi_lock, flags);
> -	}
> -	else if (debug_rt_mutex_detect_deadlock(waiter, detect_deadlock))
> +	} else if (debug_rt_mutex_detect_deadlock(waiter, detect_deadlock)) {
>  		chain_walk = 1;
> +	}
> +	if (owner->pi_blocked_on)
> +		next_lock = owner->pi_blocked_on->lock;
>  
> +	raw_spin_unlock_irqrestore(&owner->pi_lock, flags);
>  	if (!chain_walk)
>  		return 0;

Here's another optimization:

	/* If the owner is not blocked, no need to walk the chain */
	if (!chain_walk || !next_lock)
		return 0;



-- Steve
