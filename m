Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934259AbaFJA7L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 20:59:11 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:47584 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932226AbaFJA7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 20:59:10 -0400
Date: Mon, 9 Jun 2014 20:59:08 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Jason Low <jason.low2@hp.com>, Brad Mouring <bmouring@ni.com>
Subject: Re: [patch V3 5/7] rtmutex: Confine deadlock logic to futex
Message-ID: <20140609205908.521f7eba@gandalf.local.home>
In-Reply-To: <20140609202336.338874430@linutronix.de>
References: <20140609201118.387571774@linutronix.de>
	<20140609202336.338874430@linutronix.de>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 09 Jun 2014 20:28:09 -0000
Thomas Gleixner <tglx@linutronix.de> wrote:
  
> +/*
> + * Futex variant to allow full deadlock detection.
> + */
> +int __rt_mutex_timed_lock(struct rt_mutex *lock,
> +			  struct hrtimer_sleeper *timeout)
> +{
> +	might_sleep();
> +
> +	return rt_mutex_timed_fastlock(lock, TASK_INTERRUPTIBLE, timeout, 0,
> +				       rt_mutex_slowlock);
> +}
> +
>  /**
>   * rt_mutex_timed_lock - lock a rt_mutex interruptible
>   *			the timeout structure is provided
>   *			by the caller
>   *
> - * @lock: 		the rt_mutex to be locked
> + * @lock:		the rt_mutex to be locked
>   * @timeout:		timeout structure or NULL (no timeout)
> - * @detect_deadlock:	deadlock detection on/off
>   *
>   * Returns:
> - *  0 		on success
> - * -EINTR 	when interrupted by a signal
> + *  0		on success
> + * -EINTR	when interrupted by a signal
>   * -ETIMEDOUT	when the timeout expired
> - * -EDEADLK	when the lock would deadlock (when deadlock detection is on)
>   */
>  int
> -rt_mutex_timed_lock(struct rt_mutex *lock, struct hrtimer_sleeper *timeout,
> -		    int detect_deadlock)
> +rt_mutex_timed_lock(struct rt_mutex *lock, struct hrtimer_sleeper *timeout)
>  {
>  	might_sleep();
>  
> -	return rt_mutex_timed_fastlock(lock, TASK_INTERRUPTIBLE, timeout,
> -				       detect_deadlock, rt_mutex_slowlock);
> +	return rt_mutex_timed_fastlock(lock, TASK_INTERRUPTIBLE, timeout, 0,
> +				       rt_mutex_slowlock);
>  }
>  EXPORT_SYMBOL_GPL(rt_mutex_timed_lock);
>  

I must be missing something. What's the difference between the above
and the futex variant one? They both do the exact same thing:


int foo(struct rt_mutex *lock, struct hrtimer_sleeper *timeout)
{
	might_sleep();

	return rt_mutex_timed_fastlock(lock, TASK_INTERRUPTIBLE, timout,
				       0, rt_mutex_slowlock);
}


??

-- Steve
