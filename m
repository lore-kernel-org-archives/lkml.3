Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752906AbaKJNtb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 08:49:31 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:46544 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752431AbaKJNt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 08:49:29 -0500
Date: Mon, 10 Nov 2014 14:49:11 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Shilpasri G Bhat <shilpa.bhat@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        mturquette@linaro.org, amit.kucheria@linaro.org,
        vincent.guittot@linaro.org, daniel.lezcano@linaro.org,
        Morten.Rasmussen@arm.com, efault@gmx.de, nicolas.pitre@linaro.org,
        dietmar.eggemann@arm.com, pjt@google.com, bsegall@google.com,
        mingo@kernel.org, linaro-kernel@lists.linaro.org
Subject: Re: [RFC 1/2] sched/fair: Add cumulative average of load_avg_contrib
 to a task
Message-ID: <20141110134911.GG29390@twins.programming.kicks-ass.net>
References: <1415598358-26505-1-git-send-email-shilpa.bhat@linux.vnet.ibm.com>
 <1415598358-26505-2-git-send-email-shilpa.bhat@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415598358-26505-2-git-send-email-shilpa.bhat@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 10, 2014 at 11:15:57AM +0530, Shilpasri G Bhat wrote:
> +/**
> + * task_cumulative_load - return the cumulative load of
> + * the previous task if cpu is the current cpu OR the
> + * cumulative load of current task on the cpu. If cpu
> + * is idle then return 0.
> + *
> + * Invoked by the cpufreq governor to calculate the
> + * load when the CPU is woken from an idle state.
> + *
> + */
> +unsigned int task_cumulative_load(int cpu)
> +{
> +	struct rq *rq = cpu_rq(cpu);
> +	struct task_struct *p;
> +
> +	if (cpu == smp_processor_id()) {
> +		if (rq->prev == rq->idle)
> +			goto idle;
> +		p = rq->prev;
> +	} else {
> +		if (rq->curr == rq->idle)
> +			goto idle;
> +		p = rq->curr;
> +	}
> +	/*
> +	 * Removing the priority as we are interested in CPU
> +	 * utilization of the task
> +	 */
> +	return (100 * p->se.avg.cumulative_avg / p->se.load.weight);
> +idle:
> +	return 0;
> +}
> +EXPORT_SYMBOL(task_cumulative_load);

This doesn't make any sense, its wrong and also its broken.

This doesn't make any sense, because the load of a cpu is unrelated to
whatever task ran there last. You want to look at the task that is
waking now.

It is wrong because dividing out the load.weight doesn't quite work
right. Also there's patches that introduce unweighted stats like you
want, you could have used those.

It it broken because who says rq->prev still exists?

> @@ -2476,11 +2478,13 @@ static inline void update_rq_runnable_avg(struct rq *rq, int runnable) {}
>  static inline void __update_task_entity_contrib(struct sched_entity *se)
>  {
>  	u32 contrib;
> -
>  	/* avoid overflowing a 32-bit type w/ SCHED_LOAD_SCALE */
>  	contrib = se->avg.runnable_avg_sum * scale_load_down(se->load.weight);
>  	contrib /= (se->avg.runnable_avg_period + 1);
>  	se->avg.load_avg_contrib = scale_load(contrib);
> +	se->avg.cumulative_avg *= se->avg.cumulative_avg_count;
> +	se->avg.cumulative_avg += se->avg.load_avg_contrib;
> +	se->avg.cumulative_avg /= ++se->avg.cumulative_avg_count;
>  }

This is not a numerically stable algorithm. Look what happens when
cumulative_avg_count gets large. Also, whatever made you choose an
absolute decay filter like that?
