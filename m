Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751909AbaFJO6H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 10:58:07 -0400
Received: from skprod3.natinst.com ([130.164.80.24]:48168 "EHLO ni.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750842AbaFJO6G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 10:58:06 -0400
From: "Brad Mouring" <bmouring@ni.com>
Date: Tue, 10 Jun 2014 09:57:25 -0500
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Jason Low <jason.low2@hp.com>,
        Brad Mouring <bmouring@ni.com>
Subject: Re: [patch V3 7/7] rtmutex: Avoid pointless requeueing in the
 deadlock detection chain walk
Message-ID: <20140610145725.GA29976@linuxgetsreal>
References: <20140609201118.387571774@linutronix.de>
 <20140609202336.506044876@linutronix.de>
MIME-Version: 1.0
In-Reply-To: <20140609202336.506044876@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-MIMETrack: Itemize by SMTP Server on US-AUS-MGWOut2/AUS/H/NIC(Release 8.5.3FP5|July 31, 2013) at
 06/10/2014 09:57:26 AM,
	Serialize by Router on US-AUS-MGWOut2/AUS/H/NIC(Release 8.5.3FP5|July 31, 2013) at
 06/10/2014 09:57:26 AM,
	Serialize complete at 06/10/2014 09:57:26 AM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-06-10_05:2014-06-10,2014-06-10,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 09, 2014 at 08:28:10PM -0000, Thomas Gleixner wrote:
> In case the dead lock detector is enabled we follow the lock chain to
> the end in rt_mutex_adjust_prio_chain, even if we could stop earlier
> due to the priority/waiter constellation.
> 
> But once we are not longer the top priority waiter in a certain step
> or the task holding the lock has already the same priority then there
> is no point in dequeing and enqueing along the lock chain as there is
> no change at all.
> 
> So stop the requeueing at this point.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> ---
>  kernel/locking/rtmutex.c |   61 +++++++++++++++++++++++++++++++++++++++++------
>  1 file changed, 54 insertions(+), 7 deletions(-)
> 
> Index: tip/kernel/locking/rtmutex.c
> ===================================================================
> --- tip.orig/kernel/locking/rtmutex.c
> +++ tip/kernel/locking/rtmutex.c
> @@ -359,6 +359,7 @@ static int rt_mutex_adjust_prio_chain(st
>  	struct rt_mutex *lock;
>  	bool detect_deadlock;
>  	unsigned long flags;
> +	bool requeue = true;
>  
>  	detect_deadlock = rt_mutex_cond_detect_deadlock(orig_waiter, chwalk);
>  
> @@ -436,18 +437,31 @@ static int rt_mutex_adjust_prio_chain(st
>  			goto out_unlock_pi;
>  		/*
>  		 * If deadlock detection is off, we stop here if we
> -		 * are not the top pi waiter of the task.
> +		 * are not the top pi waiter of the task. If deadlock
> +		 * detection is enabled we continue, but stop the
> +		 * requeueing in the chain walk.
>  		 */
> -		if (!detect_deadlock && top_waiter != task_top_pi_waiter(task))
> -			goto out_unlock_pi;
> +		if (top_waiter != task_top_pi_waiter(task)) {
> +			if (!detect_deadlock)
> +				goto out_unlock_pi;
> +			else
> +				requeue = false;
> +		}
>  	}
>  
>  	/*
> -	 * When deadlock detection is off then we check, if further
> -	 * priority adjustment is necessary.
> +	 * If the waiter priority is the same as the task priority
> +	 * then there is no further priority adjustment necessary.  If
> +	 * deadlock detection is off, we stop the chain walk. If its
s/its/it's/
> +	 * enabled we continue, but stop the requeueing in the chain
> +	 * walk.
>  	 */
> -	if (!detect_deadlock && waiter->prio == task->prio)
> -		goto out_unlock_pi;
> +	if (waiter->prio == task->prio) {
> +		if (!detect_deadlock)
> +			goto out_unlock_pi;
> +		else
> +			requeue = false;
> +	}
>  
>  	/*
>  	 * We need to trylock here as we are holding task->pi_lock,
> @@ -475,6 +489,39 @@ static int rt_mutex_adjust_prio_chain(st
>  	}
>  
>  	/*
> +	 * If we just follow the lock chain for deadlock detection, no
> +	 * need to do all the requeue operations. We avoid a truckload
> +	 * of conditinals around the various places below and just do
> +	 * the minimum chain walk checks here.
> +	 */
> +	if (!requeue) {
> +		/* Release the task */
> +		raw_spin_unlock_irqrestore(&task->pi_lock, flags);
> +		put_task_struct(task);
> +
> +		/* If there is no owner of the lock, end of chain. */
> +		if (!rt_mutex_owner(lock)) {
> +			raw_spin_unlock(&lock->wait_lock);
> +			return 0;
> +		}
> +
> +		/* Grab the next task, i.e. owner of @lock */
> +		task = rt_mutex_owner(lock);
> +		get_task_struct(task);
> +		raw_spin_lock_irqsave(&task->pi_lock, flags);
> +
> +		/* Store whether owner is blocked itself and drop locks */
> +		next_lock = task_blocked_on(task);
task_blocked_on(task) is not clear to me, the recipient of the
return is the only clue that hints at what the function does.
> +		raw_spin_unlock_irqrestore(&task->pi_lock, flags);
> +		raw_spin_unlock(&lock->wait_lock);
> +
> +		/* If owner is not blocked, end of chain. */
> +		if (!next_lock)
> +			goto out_put_task;
> +		goto again;
> +	}
> +
> +	/*
>  	 * Store the current top waiter before doing the requeue
>  	 * operation on @lock. We need it for the boost/deboost
>  	 * decision below.
> 
> 
