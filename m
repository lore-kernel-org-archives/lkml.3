Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757265Ab3GEKZJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 06:25:09 -0400
Received: from merlin.infradead.org ([205.233.59.134]:37595 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757069Ab3GEKZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 06:25:07 -0400
Date: Fri, 5 Jul 2013 12:24:53 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Kirill Tkhai <tkhai@yandex.ru>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        David Howells <dhowells@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: Re: [RFC PATCH] sched, wait: wake_up_preempt() for first-order
 low-latency wakeups (to use in input subsystem)
Message-ID: <20130705102453.GM23916@twins.programming.kicks-ass.net>
References: <1238421373018792@web6g.yandex.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1238421373018792@web6g.yandex.ru>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 05, 2013 at 02:06:32PM +0400, Kirill Tkhai wrote:
> The patch introduces new primitives for waking up tasks, latencies of which
> are appreciable by user directly, that need the first-order interactivity.
> 
> The appliable area is not wide. It's generally input subsystem and wake_ups
> of tasks waiting for user actions: keyboard press, mouse movement etc. 

Ha! before you know it tons of drivers are using this because they all
think their interrupts it the most important thing on earth.. seriously!

> diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
> index 01970c8..8b8b328 100644
> --- a/kernel/sched/rt.c
> +++ b/kernel/sched/rt.c
> @@ -1226,8 +1226,21 @@ out:
>  	return cpu;
>  }
>  
> -static void check_preempt_equal_prio(struct rq *rq, struct task_struct *p)
> +static void check_preempt_equal_prio(struct rq *rq, struct task_struct *p, int flags)
>  {
> +	/*
> +	 * If:
> +	 *
> +	 * - the newly woken task is of equal priority to the current task
> +	 * - the newly woken task is non-migratable while current is migratable
> +	 * - current will be preempted on the next reschedule
> +	 *
> +	 * we should check to see if current can readily move to a different
> +	 * cpu.  If so, we will reschedule to allow the push logic to try
> +	 * to move current somewhere else, making room for our non-migratable
> +	 * task.
> +	 */
> +
>  	if (rq->curr->nr_cpus_allowed == 1)
>  		return;
>  
> @@ -1235,7 +1248,8 @@ static void check_preempt_equal_prio(struct rq *rq, struct task_struct *p)
>  	    && cpupri_find(&rq->rd->cpupri, p, NULL))
>  		return;
>  
> -	if (!cpupri_find(&rq->rd->cpupri, rq->curr, NULL))
> +	if (!cpupri_find(&rq->rd->cpupri, rq->curr, NULL) &&
> +	    !(flags & WF_PREEMPT))
>  		return;
>  
>  	/*
> @@ -1246,7 +1260,15 @@ static void check_preempt_equal_prio(struct rq *rq, struct task_struct *p)
>  	requeue_task_rt(rq, p, 1);
>  	resched_task(rq->curr);
>  }
> +#else /* !CONFIG_SMP */
> +static void check_preempt_equal_prio(struct rq *rq, struct task_struct *p, int flags)
> +{
> +	if (!(flags & WF_PREEMPT))
> +		return;
>  
> +	requeue_task_rt(rq, p, 1);
> +	resched_task(rq->curr);
> +}

You can't do this:

  http://pubs.opengroup.org/onlinepubs/009696899/functions/xsh_chap02_08.html

SCHED_FIFO;

2) When a blocked thread becomes a runnable thread, it becomes the tail
   of the thread list for its priority.

