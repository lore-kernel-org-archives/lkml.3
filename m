Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751713AbaKCKup (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 05:50:45 -0500
Received: from casper.infradead.org ([85.118.1.10]:55700 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097AbaKCKum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 05:50:42 -0500
Date: Mon, 3 Nov 2014 11:50:40 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: "pang.xunlei" <pang.xunlei@linaro.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Juri Lelli <juri.lelli@gmail.com>
Subject: Re: [PATCH 1/3] sched/cpupri: Deal with
 cpupri.pri_to_cpu[CPUPRI_IDLE] for idle cases
Message-ID: <20141103105040.GI12706@worktop.programming.kicks-ass.net>
References: <1415010620-6176-1-git-send-email-pang.xunlei@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415010620-6176-1-git-send-email-pang.xunlei@linaro.org>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 03, 2014 at 06:30:18PM +0800, pang.xunlei wrote:

>  kernel/sched/idle_task.c |   21 +++++++++++++++++++++
>  1 file changed, 21 insertions(+)
> 
> diff --git a/kernel/sched/idle_task.c b/kernel/sched/idle_task.c
> index 67ad4e7..3dc372e 100644
> --- a/kernel/sched/idle_task.c
> +++ b/kernel/sched/idle_task.c
> @@ -26,6 +26,15 @@ static void check_preempt_curr_idle(struct rq *rq, struct task_struct *p, int fl
>  static struct task_struct *
>  pick_next_task_idle(struct rq *rq, struct task_struct *prev)
>  {
> +#ifdef CONFIG_SMP
> +	struct cpupri *cp = &rq->rd->cpupri;
> +	int currpri = cp->cpu_to_pri[rq->cpu];
> +
> +	BUG_ON(currpri != CPUPRI_NORMAL);
> +	/* Set CPUPRI_IDLE bitmap for this cpu */
> +	cpupri_set(cp, rq->cpu, MAX_PRIO);
> +#endif
> +

This should really be idle_enter_rt() and implemented in
kernel/sched/rt.c.

>  	put_prev_task(rq, prev);
>  
>  	schedstat_inc(rq, sched_goidle);
> @@ -47,6 +56,18 @@ dequeue_task_idle(struct rq *rq, struct task_struct *p, int flags)
>  
>  static void put_prev_task_idle(struct rq *rq, struct task_struct *prev)
>  {
> +#ifdef CONFIG_SMP
> +	struct cpupri *cp = &rq->rd->cpupri;
> +	int currpri = cp->cpu_to_pri[rq->cpu];
> +
> +	/*
> +	 * Set CPUPRI_NORMAL bitmap for this cpu when exiting from idle.
> +	 * RT tasks may be queued beforehand, so the judgement is needed.
> +	 */
> +	if (currpri == CPUPRI_IDLE)
> +		cpupri_set(cp, rq->cpu, MAX_RT_PRIO);
> +#endif

idle_exit_rt() and the same.

>  	idle_exit_fair(rq);
>  	rq_last_tick_reset(rq);
>  }

Also, try and keep the deadline bits in sync with the rt semantics.
