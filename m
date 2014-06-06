Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752642AbaFFJ6c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 05:58:32 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:3529 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751701AbaFFJ6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 05:58:31 -0400
Date: Fri, 6 Jun 2014 05:58:29 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Brad Mouring <bmouring@ni.com>
Subject: Re: [patch 2/2] rtmutex: Detect changes in the pi lock chain
Message-ID: <20140606055829.3f214902@gandalf.local.home>
In-Reply-To: <20140606094859.GW6758@twins.programming.kicks-ass.net>
References: <20140605152544.641846795@linutronix.de>
	<20140605152801.930031935@linutronix.de>
	<20140606094859.GW6758@twins.programming.kicks-ass.net>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Jun 2014 11:48:59 +0200
Peter Zijlstra <peterz@infradead.org> wrote:

> 
> 
> hehe, I can almost follow this code :-)
> 
> How about something like this on top?

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve

> 
> ---
> --- a/kernel/locking/rtmutex.c
> +++ b/kernel/locking/rtmutex.c
> @@ -260,6 +260,11 @@ static void rt_mutex_adjust_prio(struct
>   */
>  int max_lock_depth = 1024;
>  
> +static inline struct rt_mutex *task_blocked_on(struct task_struct *p)
> +{
> +	return p->pi_blocked_on ? p->pi_blocked_on->lock : NULL;
> +}
> +
>  /*
>   * Adjust the priority chain. Also used for deadlock detection.
>   * Decreases task's usage by one - may thus free the task.
> @@ -443,10 +448,7 @@ static int rt_mutex_adjust_prio_chain(st
>  	 * blocked itself. If yes we store a pointer to the lock for
>  	 * the lock chain change detection above.
>  	 */
> -	if (task->pi_blocked_on)
> -		next_lock = task->pi_blocked_on->lock;
> -	else
> -		next_lock = NULL;
> +	next_lock = task_blocked_on(task);
>  
>  	raw_spin_unlock_irqrestore(&task->pi_lock, flags);
>  
> @@ -569,7 +571,7 @@ static int task_blocks_on_rt_mutex(struc
>  {
>  	struct task_struct *owner = rt_mutex_owner(lock);
>  	struct rt_mutex_waiter *top_waiter = waiter;
> -	struct rt_mutex *next_lock = NULL;
> +	struct rt_mutex *next_lock;
>  	unsigned long flags;
>  	int chain_walk, res;
>  
> @@ -614,8 +616,8 @@ static int task_blocks_on_rt_mutex(struc
>  	} else if (debug_rt_mutex_detect_deadlock(waiter, detect_deadlock)) {
>  		chain_walk = 1;
>  	}
> -	if (owner->pi_blocked_on)
> -		next_lock = owner->pi_blocked_on->lock;
> +
> +	next_lock = task_blocked_on(owner);
>  
>  	raw_spin_unlock_irqrestore(&owner->pi_lock, flags);
>  	if (!chain_walk)
> @@ -705,8 +707,7 @@ static void remove_waiter(struct rt_mute
>  		}
>  		__rt_mutex_adjust_prio(owner);
>  
> -		if (owner->pi_blocked_on)
> -			next_lock = owner->pi_blocked_on->lock;
> +		next_lock = task_blocked_on(owner);
>  
>  		raw_spin_unlock_irqrestore(&owner->pi_lock, flags);
>  	}

