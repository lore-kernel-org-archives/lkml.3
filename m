Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753935Ab3HBEmt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 00:42:49 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:50128 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853Ab3HBEms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 00:42:48 -0400
Message-ID: <51FB382B.80209@linux.vnet.ibm.com>
Date: Fri, 02 Aug 2013 10:10:11 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
CC: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org, Mike Galbraith <efault@gmx.de>,
        Paul Turner <pjt@google.com>, Alex Shi <alex.shi@intel.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Namhyung Kim <namhyung@kernel.org>, Joonsoo Kim <js1304@gmail.com>
Subject: Re: [PATCH v2 3/3] sched: clean-up struct sd_lb_stat
References: <1375408223-10934-1-git-send-email-iamjoonsoo.kim@lge.com> <1375408223-10934-4-git-send-email-iamjoonsoo.kim@lge.com>
In-Reply-To: <1375408223-10934-4-git-send-email-iamjoonsoo.kim@lge.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13080204-0260-0000-0000-0000036910EA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joonsoo,

On 08/02/2013 07:20 AM, Joonsoo Kim wrote:
> There is no reason to maintain separate variables for this_group
> and busiest_group in sd_lb_stat, except saving some space.
> But this structure is always allocated in stack, so this saving
> isn't really benificial.
> 
> This patch unify these variables, so IMO, readability may be improved.
> 
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> 
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 7f51b8c..f72ee7d 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -4195,36 +4195,6 @@ static unsigned long task_h_load(struct task_struct *p)
> 
>  /********** Helpers for find_busiest_group ************************/
>  /*
> - * sd_lb_stats - Structure to store the statistics of a sched_domain
> - * 		during load balancing.
> - */
> -struct sd_lb_stats {
> -	struct sched_group *busiest; /* Busiest group in this sd */
> -	struct sched_group *this;  /* Local group in this sd */
> -	unsigned long total_load;  /* Total load of all groups in sd */
> -	unsigned long total_pwr;   /*	Total power of all groups in sd */
> -	unsigned long avg_load;	   /* Average load across all groups in sd */
> -
> -	/** Statistics of this group */
> -	unsigned long this_load;
> -	unsigned long this_load_per_task;
> -	unsigned long this_nr_running;
> -	unsigned long this_has_capacity;
> -	unsigned int  this_idle_cpus;
> -
> -	/* Statistics of the busiest group */
> -	unsigned int  busiest_idle_cpus;
> -	unsigned long max_load;
> -	unsigned long busiest_load_per_task;
> -	unsigned long busiest_nr_running;
> -	unsigned long busiest_group_capacity;
> -	unsigned long busiest_has_capacity;
> -	unsigned int  busiest_group_weight;
> -
> -	int group_imb; /* Is there imbalance in this sd */
> -};

There are a few parameters that you should not be removing.
busiest_load_per_task and max_load. busiest_load_per_task is a metric
that is not present for sg_lb_stats. And max_load going by its usage in
load balancing is best placed under sd_lb_stats. Removing it could cause
some confusion. See below.
>  /**
> @@ -4732,11 +4715,20 @@ void fix_small_imbalance(struct lb_env *env, struct sd_lb_stats *sds)
>  static inline void calculate_imbalance(struct lb_env *env, struct sd_lb_stats *sds)
>  {
>  	unsigned long max_pull, load_above_capacity = ~0UL;
> -
> -	sds->busiest_load_per_task /= sds->busiest_nr_running;
> -	if (sds->group_imb) {
> -		sds->busiest_load_per_task =
> -			min(sds->busiest_load_per_task, sds->avg_load);
> +	struct sg_lb_stats *this, *busiest;
> +
> +	/* After below code, we use sum_weighted_load of
> +	 * this_stat and busiest_stat as load_per_task */
> +	this = &sds->this_stat;
> +	if (this->sum_nr_running)
> +		this->sum_weighted_load /= this->sum_nr_running;
> +
> +	busiest = &sds->busiest_stat;
> +	/* busiest must have some tasks */
> +	busiest->sum_weighted_load /= busiest->sum_nr_running;

You cannot change sum_weighted_load of this_grp and busiest_grp like
this. They are meant to carry the total load of the group and not the
load per task in that group. This is why there is a separate metric
busiest_load_per_task and this_load_per_task under sd_lb_stats to convey
exactly what is being done. Doing the above will confuse the readers of
this code.

> +	if (busiest->group_imb) {
> +		busiest->sum_weighted_load =
> +			min(busiest->sum_weighted_load, sds->sd_avg_load);

Right here we get confused as to why the total load is being compared
against load per task (although you are changing it to load per task above).

>  	}
> 
>  	/*
> @@ -4744,17 +4736,17 @@ static inline void calculate_imbalance(struct lb_env *env, struct sd_lb_stats *s
>  	 * max load less than avg load(as we skip the groups at or below
>  	 * its cpu_power, while calculating max_load..)
>  	 */
> -	if (sds->max_load < sds->avg_load) {
> +	if (busiest->avg_load < this->avg_load) {
>  		env->imbalance = 0;
>  		return fix_small_imbalance(env, sds);
>  	}
> 
> -	if (!sds->group_imb) {
> +	if (!busiest->group_imb) {
>  		/*
>  		 * Don't want to pull so many tasks that a group would go idle.
>  		 */
> -		load_above_capacity = (sds->busiest_nr_running -
> -						sds->busiest_group_capacity);
> +		load_above_capacity = (busiest->sum_nr_running -
> +						busiest->group_capacity);
> 
>  		load_above_capacity *= (SCHED_LOAD_SCALE * SCHED_POWER_SCALE);
> 
> @@ -4771,12 +4763,13 @@ static inline void calculate_imbalance(struct lb_env *env, struct sd_lb_stats *s
>  	 * Be careful of negative numbers as they'll appear as very large values
>  	 * with unsigned longs.
>  	 */
> -	max_pull = min(sds->max_load - sds->avg_load, load_above_capacity);
> +	max_pull = min(busiest->avg_load - sds->sd_avg_load,
> +						load_above_capacity);

This is ok, but readability wise max_load is much better. max_load
signifies the maximum load per task on a group in this sd, and avg_load
signifies the total load per task across the sd. You are checking if
there is imbalance in the total load in the sd and try to even it out
across the sd.  Here "busiest" does not convey this immediately.

Regards
Preeti U Murthy

