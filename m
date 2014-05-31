Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932784AbaEaCGz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 22:06:55 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:50541 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755609AbaEaCGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 22:06:54 -0400
Date: Fri, 30 May 2014 22:06:52 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: [patch 4/6] rtmutex: Confine deadlock logic to futex
Message-ID: <20140530220652.28457405@gandalf.local.home>
In-Reply-To: <20140522031950.044848781@linutronix.de>
References: <20140522031841.797415507@linutronix.de>
	<20140522031950.044848781@linutronix.de>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 May 2014 03:25:50 -0000
Thomas Gleixner <tglx@linutronix.de> wrote:

> Index: tip/kernel/locking/rtmutex.c
> ===================================================================
> --- tip.orig/kernel/locking/rtmutex.c
> +++ tip/kernel/locking/rtmutex.c
> @@ -957,47 +957,53 @@ EXPORT_SYMBOL_GPL(rt_mutex_lock);
>  /**
>   * rt_mutex_lock_interruptible - lock a rt_mutex interruptible
>   *
> - * @lock: 		the rt_mutex to be locked
> - * @detect_deadlock:	deadlock detection on/off
> + * @lock:		the rt_mutex to be locked
>   *
>   * Returns:
> - *  0 		on success
> - * -EINTR 	when interrupted by a signal
> - * -EDEADLK	when the lock would deadlock (when deadlock detection is on)
> + *  0		on success
> + * -EINTR	when interrupted by a signal
>   */
> -int __sched rt_mutex_lock_interruptible(struct rt_mutex *lock,
> -						 int detect_deadlock)
> +int __sched rt_mutex_lock_interruptible(struct rt_mutex *lock)
>  {
>  	might_sleep();
>  
>  	return rt_mutex_fastlock(lock, TASK_INTERRUPTIBLE,
> -				 detect_deadlock, rt_mutex_slowlock);
> +				 RT_MUTEX_MIN_CHAINWALK, rt_mutex_slowlock);


I noticed after this change, the only two callers of rt_mutex_fastlock()
only pass in RT_MUTEX_MIN_CHAINWALK. We could remove the passing of
detect_deadlock to that too, and simplify that function.

-- Steve


>  }
>  EXPORT_SYMBOL_GPL(rt_mutex_lock_interruptible);
>  
> +/*
> + * Futex variant to allow full deadlock detection.
> + */
> +int __rt_mutex_timed_lock(struct rt_mutex *lock,
> +			  struct hrtimer_sleeper *timeout)
> +{
> +	might_sleep();
> +
> +	return rt_mutex_timed_fastlock(lock, TASK_INTERRUPTIBLE, timeout,
> +				       RT_MUTEX_FULL_CHAINWALK,
> +				       rt_mutex_slowlock);
> +}
> +
