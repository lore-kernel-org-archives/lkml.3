Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757314AbaJIOQe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 10:16:34 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:57526 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684AbaJIOQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 10:16:27 -0400
Date: Thu, 9 Oct 2014 16:16:07 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org, preeti@linux.vnet.ibm.com,
        Morten.Rasmussen@arm.com, kamalesh@linux.vnet.ibm.com,
        linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        riel@redhat.com, efault@gmx.de, nicolas.pitre@linaro.org,
        linaro-kernel@lists.linaro.org, daniel.lezcano@linaro.org,
        dietmar.eggemann@arm.com, pjt@google.com, bsegall@google.com
Subject: Re: [PATCH v7 6/7] sched: replace capacity_factor by usage
Message-ID: <20141009141607.GR4750@worktop.programming.kicks-ass.net>
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
> +		 * first, lower the sg capacity to one so that we'll try
>  		 * and move all the excess tasks away. We lower the capacity
>  		 * of a group only if the local group has the capacity to fit
> +		 * these excess tasks, i.e. group_capacity > 0. The
>  		 * extra check prevents the case where you always pull from the
>  		 * heaviest group when it is already under-utilized (possible
>  		 * with a large weight task outweighs the tasks on the system).
>  		 */
>  		if (prefer_sibling && sds->local &&
> +		    group_has_capacity(env, &sds->local_stat)) {
> +			if (sgs->sum_nr_running > 1)
> +				sgs->group_no_capacity = 1;
> +			sgs->group_capacity = min(sgs->group_capacity,
> +						SCHED_CAPACITY_SCALE);
> +		}
>  
>  		if (update_sd_pick_busiest(env, sds, sg, sgs)) {
>  			sds->busiest = sg;

> @@ -6490,8 +6460,8 @@ static struct sched_group *find_busiest_group(struct lb_env *env)
>  		goto force_balance;
>  
>  	/* SD_BALANCE_NEWIDLE trumps SMP nice when underutilized */
> -	if (env->idle == CPU_NEWLY_IDLE && local->group_has_free_capacity &&
> -	    !busiest->group_has_free_capacity)
> +	if (env->idle == CPU_NEWLY_IDLE && group_has_capacity(env, local) &&
> +	    busiest->group_no_capacity)
>  		goto force_balance;
>  
>  	/*

This is two calls to group_has_capacity() on the local group. Why not
compute once in update_sd_lb_stats()?
