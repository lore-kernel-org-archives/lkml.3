Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934606AbaE2OCP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 10:02:15 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:36298 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932867AbaE2OCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 10:02:13 -0400
Date: Thu, 29 May 2014 16:02:04 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, preeti@linux.vnet.ibm.com,
        Morten.Rasmussen@arm.com, efault@gmx.de, nicolas.pitre@linaro.org,
        linaro-kernel@lists.linaro.org, daniel.lezcano@linaro.org
Subject: Re: [PATCH v2 11/11] sched: replace capacity by activity
Message-ID: <20140529140204.GH11074@laptop.programming.kicks-ass.net>
References: <1400860385-14555-1-git-send-email-vincent.guittot@linaro.org>
 <1400860385-14555-12-git-send-email-vincent.guittot@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400860385-14555-12-git-send-email-vincent.guittot@linaro.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 23, 2014 at 05:53:05PM +0200, Vincent Guittot wrote:
> @@ -6052,8 +6006,8 @@ static inline void update_sd_lb_stats(struct lb_env *env, struct sd_lb_stats *sd
>  		 * with a large weight task outweighs the tasks on the system).
>  		 */
>  		if (prefer_sibling && sds->local &&
> -		    sds->local_stat.group_has_capacity)
> -			sgs->group_capacity = min(sgs->group_capacity, 1U);
> +		    sds->local_stat.group_capacity > 0)
> +			sgs->group_capacity = min(sgs->group_capacity, 1L);
>  
>  		if (update_sd_pick_busiest(env, sds, sg, sgs)) {
>  			sds->busiest = sg;
> @@ -6228,7 +6182,7 @@ static inline void calculate_imbalance(struct lb_env *env, struct sd_lb_stats *s
>  		 * have to drop below capacity to reach cpu-load equilibrium.
>  		 */
>  		load_above_capacity =
> -			(busiest->sum_nr_running - busiest->group_capacity);
> +			(busiest->sum_nr_running - busiest->group_weight);
>  
>  		load_above_capacity *= (SCHED_LOAD_SCALE * SCHED_POWER_SCALE);
>  		load_above_capacity /= busiest->group_power;

I think you just broke PREFER_SIBLING here..

So we want PREFER_SIBLING to work on nr_running, not utilization because
we want to spread single tasks around, regardless of their utilization.

