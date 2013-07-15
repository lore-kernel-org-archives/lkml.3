Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754084Ab3GOGcF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 02:32:05 -0400
Received: from merlin.infradead.org ([205.233.59.134]:60922 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753973Ab3GOGcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 02:32:04 -0400
Date: Mon, 15 Jul 2013 08:31:50 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Kirill Tkhai <tkhai@yandex.ru>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] sched: Add logic to handle parallel try_to_wake_up() of
 the same task
Message-ID: <20130715063150.GL17211@twins.programming.kicks-ass.net>
References: <1517081373730349@web23d.yandex.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1517081373730349@web23d.yandex.ru>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 13, 2013 at 07:45:49PM +0400, Kirill Tkhai wrote:
> ---
>  include/linux/sched.h |    1 +
>  kernel/sched/core.c   |   29 +++++++++++++++++++++++++----
>  kernel/sched/debug.c  |    7 +++++++
>  kernel/sched/stats.h  |   16 ++++++++++++++++
>  4 files changed, 49 insertions(+), 4 deletions(-)
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index fc09d21..235a466 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -964,6 +964,7 @@ struct sched_statistics {
>  	u64			nr_wakeups_affine_attempts;
>  	u64			nr_wakeups_passive;
>  	u64			nr_wakeups_idle;
> +	atomic_t		nr_wakeups_parallel;

bad idea.. atomics are expensive and stats aren't generally _that_
important.

>  };
>  #endif
>  
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 9d06ad6..1e1475f 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -1336,6 +1336,11 @@ ttwu_do_wakeup(struct rq *rq, struct task_struct *p, int wake_flags)
>  
>  	p->state = TASK_RUNNING;
>  #ifdef CONFIG_SMP
> +	/*
> +	 * Pair bracket with TASK_WAKING check it try_to_wake_up()
> +	 */
> +	smp_wmb();
> +

Like Mike said, you're making the common case more expensive, this is
not appreciated.

>  	if (p->sched_class->task_woken)
>  		p->sched_class->task_woken(rq, p);
>  
> @@ -1487,20 +1492,37 @@ static int
>  try_to_wake_up(struct task_struct *p, unsigned int state, int wake_flags)
>  {
>  	unsigned long flags;
> -	int cpu, success = 0;
> +	int cpu, success = 1;
>  
> +	/*
> +	 * See commentary for commit 04e2f1741d235ba599037734878d72e57cb302b5.

That must be the worst barrier comment ever.. If you want it there, just
copy/paste the commit log here. It is also completely unrelated to the
rest of the patch.

> +	 */
>  	smp_wmb();
> +#ifdef CONFIG_SMP
> +	if (p->state == TASK_WAKING) {
> +		/*
> +		 * Pairs with sets of p->state: below and in ttwu_do_wakeup().
> +		 */
> +		smp_rmb();
> +		inc_nr_parallel_wakeups(p);
> +		return success;

This is wrong, you didn't change p->state, therefore returning 1 is not
an option. If you want to do something like this, treat it like waking
an already running task.

Also, the barrier comments fail to explain the exact problem they're
solving.


> +	}
> +#endif
>  	raw_spin_lock_irqsave(&p->pi_lock, flags);
> -	if (!(p->state & state))
> +	if (!(p->state & state)) {
> +		success = 0;
>  		goto out;
> +	}
>  
> -	success = 1; /* we're going to change ->state */
>  	cpu = task_cpu(p);
>  
>  	if (p->on_rq && ttwu_remote(p, wake_flags))
>  		goto stat;
>  
>  #ifdef CONFIG_SMP
> +	p->state = TASK_WAKING;
> +	smp_wmb();
> +

This too is broken; the loop below needs to be completed first,
otherwise we change p->state while the task is still on the CPU and it
might read the wrong p->state.

>  	/*
>  	 * If the owning (remote) cpu is still in the middle of schedule() with
>  	 * this task as prev, wait until its done referencing the task.
> @@ -1513,7 +1535,6 @@ try_to_wake_up(struct task_struct *p, unsigned int state, int wake_flags)
>  	smp_rmb();
>  
>  	p->sched_contributes_to_load = !!task_contributes_to_load(p);
> -	p->state = TASK_WAKING;
>  
>  	if (p->sched_class->task_waking)
>  		p->sched_class->task_waking(p);
