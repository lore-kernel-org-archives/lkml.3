Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753853AbaG2Ot7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 10:49:59 -0400
Received: from casper.infradead.org ([85.118.1.10]:37936 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751979AbaG2Ot6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 10:49:58 -0400
Date: Tue, 29 Jul 2014 16:49:52 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: riel@redhat.com
Cc: linux-kernel@vger.kernel.org, vincent.guittot@linaro.org,
        mikey@neuling.org, mingo@kernel.org, jhladky@redhat.com,
        ktkhai@parallels.com, tim.c.chen@linux.intel.com,
        nicolas.pitre@linaro.org
Subject: Re: [PATCH 1/2] sched: fix and clean up calculate_imbalance
Message-ID: <20140729144952.GG3935@laptop>
References: <1406571388-3227-1-git-send-email-riel@redhat.com>
 <1406571388-3227-2-git-send-email-riel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406571388-3227-2-git-send-email-riel@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2014 at 02:16:27PM -0400, riel@redhat.com wrote:
> @@ -6221,16 +6221,16 @@ void fix_small_imbalance(struct lb_env *env, struct sd_lb_stats *sds)
>   */
>  static inline void calculate_imbalance(struct lb_env *env, struct sd_lb_stats *sds)
>  {
> -	unsigned long max_pull, load_above_capacity = ~0UL;
>  	struct sg_lb_stats *local, *busiest;
>  
>  	local = &sds->local_stat;
>  	busiest = &sds->busiest_stat;
>  
> -	if (busiest->group_imb) {
> +	if (busiest->avg_load <= sds->avg_load) {
>  		/*
> -		 * In the group_imb case we cannot rely on group-wide averages
> -		 * to ensure cpu-load equilibrium, look at wider averages. XXX
> +		 * Busiest got picked because it is overloaded or imbalanced,
> +		 * but does not have an above-average load. Look at wider
> +		 * averages.
>  		 */
>  		busiest->load_per_task =
>  			min(busiest->load_per_task, sds->avg_load);

I don't think that's right, this code is really for imbalance only,
although I'm now wondering why (again)..

So currently the only other case is overloaded (since, as you noticed,
we don't balance for !overloaded) and that explicitly doesn't use it. So
making the overloaded case use this doesn't make sense.

> @@ -6247,32 +6247,15 @@ static inline void calculate_imbalance(struct lb_env *env, struct sd_lb_stats *s
>  		return fix_small_imbalance(env, sds);
>  	}
>  
> -	if (!busiest->group_imb) {
> -		/*
> -		 * Don't want to pull so many tasks that a group would go idle.
> -		 * Except of course for the group_imb case, since then we might
> -		 * have to drop below capacity to reach cpu-load equilibrium.
> -		 */
> -		load_above_capacity =
> -			(busiest->sum_nr_running - busiest->group_capacity_factor);
> -
> -		load_above_capacity *= (SCHED_LOAD_SCALE * SCHED_CAPACITY_SCALE);
> -		load_above_capacity /= busiest->group_capacity;
> -	}

I think we want to retain that, esp. for the overloaded case. So that
wants to be:

	if (busiest->sum_nr_running > busiest->group_capacity_factor)

Clearly it doesn't make sense for the !overload case, and we explicitly
want to avoid it in the imb case.
