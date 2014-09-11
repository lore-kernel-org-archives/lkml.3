Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176AbaIKKNM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 06:13:12 -0400
Received: from casper.infradead.org ([85.118.1.10]:55175 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138AbaIKKNK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 06:13:10 -0400
Date: Thu, 11 Sep 2014 12:13:08 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org, preeti@linux.vnet.ibm.com,
        linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        riel@redhat.com, Morten.Rasmussen@arm.com, efault@gmx.de,
        nicolas.pitre@linaro.org, linaro-kernel@lists.linaro.org,
        daniel.lezcano@linaro.org, dietmar.eggemann@arm.com
Subject: Re: [PATCH v5 08/12] sched: move cfs task on a CPU with higher
 capacity
Message-ID: <20140911101308.GU3190@worktop.ger.corp.intel.com>
References: <1409051215-16788-1-git-send-email-vincent.guittot@linaro.org>
 <1409051215-16788-9-git-send-email-vincent.guittot@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409051215-16788-9-git-send-email-vincent.guittot@linaro.org>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2014 at 01:06:51PM +0200, Vincent Guittot wrote:

> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 18db43e..60ae1ce 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -6049,6 +6049,14 @@ static bool update_sd_pick_busiest(struct lb_env *env,
>  			return true;
>  	}
>  
> +	/*
> +	 * The group capacity is reduced probably because of activity from other
> +	 * sched class or interrupts which use part of the available capacity
> +	 */
> +	if ((sg->sgc->capacity_orig * 100) > (sgs->group_capacity *
> +				env->sd->imbalance_pct))
> +		return true;
> +
>  	return false;
>  }
>  
> @@ -6534,13 +6542,23 @@ static int need_active_balance(struct lb_env *env)
>  	struct sched_domain *sd = env->sd;
>  
>  	if (env->idle == CPU_NEWLY_IDLE) {
> +		int src_cpu = env->src_cpu;
>  
>  		/*
>  		 * ASYM_PACKING needs to force migrate tasks from busy but
>  		 * higher numbered CPUs in order to pack all tasks in the
>  		 * lowest numbered CPUs.
>  		 */
> -		if ((sd->flags & SD_ASYM_PACKING) && env->src_cpu > env->dst_cpu)
> +		if ((sd->flags & SD_ASYM_PACKING) && src_cpu > env->dst_cpu)
> +			return 1;
> +
> +		/*
> +		 * If the CPUs share their cache and the src_cpu's capacity is
> +		 * reduced because of other sched_class or IRQs, we trig an
> +		 * active balance to move the task
> +		 */
> +		if ((capacity_orig_of(src_cpu) * 100) > (capacity_of(src_cpu) *
> +				sd->imbalance_pct))
>  			return 1;
>  	}

Should you not also check -- in both cases -- that the destination is
any better?

Also, there's some obvious repetition going on there, maybe add a
helper?

Also, both sites should probably ensure they're operating in the
non-saturated/overloaded scenario. Because as soon as we're completely
saturated we want SMP nice etc. and that all already works right
(presumably).
