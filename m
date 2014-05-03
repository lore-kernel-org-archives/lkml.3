Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753276AbaECSx6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2014 14:53:58 -0400
Received: from www.linutronix.de ([62.245.132.108]:46384 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752193AbaECSx5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2014 14:53:57 -0400
Date: Sat, 3 May 2014 20:54:08 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Kirill Tkhai <tkhai@yandex.ru>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: Re: [RFC] rtmutex: Do not boost fair tasks each other
In-Reply-To: <5362122B.8060305@yandex.ru>
Message-ID: <alpine.DEB.2.02.1405032041460.6261@ionos.tec.linutronix.de>
References: <5362122B.8060305@yandex.ru>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 May 2014, Kirill Tkhai wrote:
> Higher priority does not provide exclusive privilege
> of one fair task over the other. In this case priority
> boosting looks excess.
> 
> On RT patch with enabled PREEMPT_RT_FULL I see a lot of
> rt_mutex_setprio() actions like
> 
> 	120 -> 118
> 	118 -> 120
> 
> They harm RT tasks.

That's not the main problem. The point is that it is useless and
therefor harming performace and throughput as well.
 
> RT patch has lazy preemtion feature, so if idea is we care
> about excess preemption inside fair class, we should care
> about excess priority inheritance too.
> 
> In case of vanila kernel the problem is the same, but there
> are no so many rt mutexes. Do I skip anything?

Almost a decade ago we decided to do the boosting for everything
including SCHED_OTHER due to the very simple reason that exercising
that code path more is likely to trigger more bugs.
 
But yes in a production environment, it's pointless for SCHED_OTHER
tasks.

Though exercising that code path as much as we can is not a bad thing
either. So I'd like to see that made compile time conditional on one
of the lock testing CONFIG items.

And the patch should be made against mainline, where we have the same
issue (reduced to PI-futexes).

Thanks,

	tglx

> Kirill
> ---
>  kernel/locking/rtmutex.c | 21 ++++++++++++++-------
>  1 file changed, 14 insertions(+), 7 deletions(-)
> 
> diff --git a/kernel/locking/rtmutex.c b/kernel/locking/rtmutex.c
> index aa4dff0..609a57e 100644
> --- a/kernel/locking/rtmutex.c
> +++ b/kernel/locking/rtmutex.c
> @@ -197,11 +197,14 @@ rt_mutex_dequeue_pi(struct task_struct *task,
> struct rt_mutex_waiter *waiter)
>   */
>  int rt_mutex_getprio(struct task_struct *task)
>  {
> -	if (likely(!task_has_pi_waiters(task)))
> -		return task->normal_prio;
> +	if (unlikely(task_has_pi_waiters(task))) {
> +		int prio = task_top_pi_waiter(task)->prio;
> +
> +		if (rt_prio(prio) || dl_prio(prio))
> +			return min(prio, task->normal_prio);
> +	}
> 
> -	return min(task_top_pi_waiter(task)->prio,
> -		   task->normal_prio);
> +	return task->normal_prio;
>  }
> 
>  struct task_struct *rt_mutex_get_top_task(struct task_struct *task)
> @@ -218,10 +221,14 @@ struct task_struct *rt_mutex_get_top_task(struct
> task_struct *task)
>   */
>  int rt_mutex_check_prio(struct task_struct *task, int newprio)
>  {
> -	if (!task_has_pi_waiters(task))
> -		return 0;
> +	if (unlikely(task_has_pi_waiters(task))) {
> +		int prio = task_top_pi_waiter(task)->task->prio;
> 
> -	return task_top_pi_waiter(task)->task->prio <= newprio;
> +		if (rt_prio(prio) || dl_prio(prio))
> +			return prio <= newprio;
> +	}
> +
> +	return 0;
>  }
> 
>  /*
> 
