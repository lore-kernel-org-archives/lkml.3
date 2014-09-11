Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756797AbaIKQPV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 12:15:21 -0400
Received: from casper.infradead.org ([85.118.1.10]:57024 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860AbaIKQPT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 12:15:19 -0400
Date: Thu, 11 Sep 2014 18:15:17 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org, preeti@linux.vnet.ibm.com,
        linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        riel@redhat.com, Morten.Rasmussen@arm.com, efault@gmx.de,
        nicolas.pitre@linaro.org, linaro-kernel@lists.linaro.org,
        daniel.lezcano@linaro.org, dietmar.eggemann@arm.com
Subject: Re: [PATCH v5 11/12] sched: replace capacity_factor by utilization
Message-ID: <20140911161517.GA3190@worktop.ger.corp.intel.com>
References: <1409051215-16788-1-git-send-email-vincent.guittot@linaro.org>
 <1409051215-16788-12-git-send-email-vincent.guittot@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409051215-16788-12-git-send-email-vincent.guittot@linaro.org>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2014 at 01:06:54PM +0200, Vincent Guittot wrote:
> +static inline int group_has_free_capacity(struct sg_lb_stats *sgs,
> +			struct lb_env *env)
>  {
> +	if ((sgs->group_capacity_orig * 100) >
> +			(sgs->group_utilization * env->sd->imbalance_pct))
> +		return 1;
> +
> +	if (sgs->sum_nr_running < sgs->group_weight)
> +		return 1;
>  
> +	return 0;
> +}
>  
> +static inline int group_is_overloaded(struct sg_lb_stats *sgs,
> +			struct lb_env *env)
> +{
> +	if (sgs->sum_nr_running <= sgs->group_weight)
> +		return 0;
>  
> +	if ((sgs->group_capacity_orig * 100) <
> +			(sgs->group_utilization * env->sd->imbalance_pct))
> +		return 1;
>  
> +	return 0;
>  }

I'm confused about the utilization vs capacity_orig. I see how we should
maybe scale things with the capacity when comparing between CPUs/groups,
but not on the same CPU/group.

I would have expected something simple like:

static inline bool group_has_capacity()
{
	/* Is there a spare cycle? */
	if (sgs->group_utilization < sgs->group_weight * SCHED_LOAD_SCALE)
		return true;

	/* Are there less tasks than logical CPUs? */
	if (sgs->sum_nr_running < sgs->group_weight)
		return true;

	return false;
}

Where group_utilization a pure sum of running_avg.

Now this has a hole when there are RT tasks on the system, in that case
the utilization will never hit 1, but we could fix that another way. I
don't think the capacity_orig thing is right.
