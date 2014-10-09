Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752790AbaJILY1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 07:24:27 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:54384 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137AbaJILYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 07:24:18 -0400
Date: Thu, 9 Oct 2014 13:23:52 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org, preeti@linux.vnet.ibm.com,
        Morten.Rasmussen@arm.com, kamalesh@linux.vnet.ibm.com,
        linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        riel@redhat.com, efault@gmx.de, nicolas.pitre@linaro.org,
        linaro-kernel@lists.linaro.org, daniel.lezcano@linaro.org,
        dietmar.eggemann@arm.com, pjt@google.com, bsegall@google.com
Subject: Re: [PATCH v7 2/7] sched: move cfs task on a CPU with higher capacity
Message-ID: <20141009112352.GO4750@worktop.programming.kicks-ass.net>
References: <1412684017-16595-1-git-send-email-vincent.guittot@linaro.org>
 <1412684017-16595-3-git-send-email-vincent.guittot@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412684017-16595-3-git-send-email-vincent.guittot@linaro.org>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 07, 2014 at 02:13:32PM +0200, Vincent Guittot wrote:
> +++ b/kernel/sched/fair.c
> @@ -5896,6 +5896,18 @@ fix_small_capacity(struct sched_domain *sd, struct sched_group *group)
>  }
>  
>  /*
> + * Check whether the capacity of the rq has been noticeably reduced by side
> + * activity. The imbalance_pct is used for the threshold.
> + * Return true is the capacity is reduced
> + */
> +static inline int
> +check_cpu_capacity(struct rq *rq, struct sched_domain *sd)
> +{
> +	return ((rq->cpu_capacity * sd->imbalance_pct) <
> +				(rq->cpu_capacity_orig * 100));
> +}
> +
> +/*
>   * Group imbalance indicates (and tries to solve) the problem where balancing
>   * groups is inadequate due to tsk_cpus_allowed() constraints.
>   *
> @@ -6567,6 +6579,14 @@ static int need_active_balance(struct lb_env *env)
>  		 */
>  		if ((sd->flags & SD_ASYM_PACKING) && env->src_cpu > env->dst_cpu)
>  			return 1;
> +
> +		/*
> +		 * The src_cpu's capacity is reduced because of other
> +		 * sched_class or IRQs, we trig an active balance to move the
> +		 * task
> +		 */
> +		if (check_cpu_capacity(env->src_rq, sd))
> +			return 1;
>  	}

So does it make sense to first check if there's a better candidate at
all? By this time we've already iterated the current SD while trying
regular load balancing, so we could know this.


