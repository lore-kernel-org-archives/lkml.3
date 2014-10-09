Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757384AbaJIO6i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 10:58:38 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:42707 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757266AbaJIO6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 10:58:30 -0400
Date: Thu, 9 Oct 2014 16:58:16 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org, preeti@linux.vnet.ibm.com,
        Morten.Rasmussen@arm.com, kamalesh@linux.vnet.ibm.com,
        linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        riel@redhat.com, efault@gmx.de, nicolas.pitre@linaro.org,
        linaro-kernel@lists.linaro.org, daniel.lezcano@linaro.org,
        dietmar.eggemann@arm.com, pjt@google.com, bsegall@google.com
Subject: Re: [PATCH v7 6/7] sched: replace capacity_factor by usage
Message-ID: <20141009145816.GS4750@worktop.programming.kicks-ass.net>
References: <1412684017-16595-1-git-send-email-vincent.guittot@linaro.org>
 <1412684017-16595-7-git-send-email-vincent.guittot@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412684017-16595-7-git-send-email-vincent.guittot@linaro.org>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 07, 2014 at 02:13:36PM +0200, Vincent Guittot wrote:
> @@ -6214,17 +6178,21 @@ static inline void update_sd_lb_stats(struct lb_env *env, struct sd_lb_stats *sd
>  
>  		/*
>  		 * In case the child domain prefers tasks go to siblings
> -		 * first, lower the sg capacity factor to one so that we'll try
> +		 * first, lower the sg capacity to one so that we'll try
>  		 * and move all the excess tasks away. We lower the capacity
>  		 * of a group only if the local group has the capacity to fit
> -		 * these excess tasks, i.e. nr_running < group_capacity_factor. The
> +		 * these excess tasks, i.e. group_capacity > 0. The
>  		 * extra check prevents the case where you always pull from the
>  		 * heaviest group when it is already under-utilized (possible
>  		 * with a large weight task outweighs the tasks on the system).
>  		 */
>  		if (prefer_sibling && sds->local &&
> -		    sds->local_stat.group_has_free_capacity)
> -			sgs->group_capacity_factor = min(sgs->group_capacity_factor, 1U);
> +		    group_has_capacity(env, &sds->local_stat)) {
> +			if (sgs->sum_nr_running > 1)
> +				sgs->group_no_capacity = 1;
> +			sgs->group_capacity = min(sgs->group_capacity,
> +						SCHED_CAPACITY_SCALE);
> +		}
>  
>  		if (update_sd_pick_busiest(env, sds, sg, sgs)) {
>  			sds->busiest = sg;

So this is your PREFER_SIBLING implementation, why is this a good one?

That is, the current PREFER_SIBLING works because we account against
nr_running, and setting it to 1 makes 2 tasks too much and we end up
moving stuff away.

But if I understand things right, we're now measuring tasks in
'utilization' against group_capacity, so setting group_capacity to
CAPACITY_SCALE, means we can end up with many tasks on the one cpu
before we move over to another group, right?

So I think that for 'idle' systems we want to do the
nr_running/work-conserving thing -- get as many cpus running
'something' and avoid queueing like the plague.

Then when there's some queueing, we want to go do the utilization thing,
basically minimize queueing by leveling utilization.

Once all cpus are fully utilized, we switch to fair/load based balancing
and try and get equal load on cpus.

Does that make sense?


If so, how about adding a group_type and splitting group_other into say
group_idle and group_util:

enum group_type {
	group_idle = 0,
	group_util,
	group_imbalanced,
	group_overloaded,
}

we change group_classify() into something like:

	if (sgs->group_usage > sgs->group_capacity)
		return group_overloaded;

	if (sg_imbalanced(group))
		return group_imbalanced;

	if (sgs->nr_running < sgs->weight)
		return group_idle;

	return group_util;


And then have update_sd_pick_busiest() something like:

	if (sgs->group_type > busiest->group_type)
		return true;

	if (sgs->group_type < busiest->group_type)
		return false;

	switch (sgs->group_type) {
	case group_idle:
		if (sgs->nr_running < busiest->nr_running)
			return false;
		break;

	case group_util:
		if (sgs->group_usage < busiest->group_usage)
			return false;
		break;

	default:
		if (sgs->avg_load < busiest->avg_load)
			return false;
		break;
	}

	....


And then some calculate_imbalance() magic to complete it..


If we have that, we can play tricks with the exact busiest condition in
update_sd_pick_busiest() to implement PREFER_SIBLING or so.

Makes sense?
