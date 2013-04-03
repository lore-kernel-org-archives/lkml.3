Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761522Ab3DCFII (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 01:08:08 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:44292 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759832Ab3DCFIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 01:08:07 -0400
X-AuditID: 9c930179-b7b2aae000000518-7f-515bb932eadd
From: Namhyung Kim <namhyung@kernel.org>
To: Alex Shi <alex.shi@intel.com>
Cc: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, bp@alien8.de,
        pjt@google.com, efault@gmx.de, vincent.guittot@linaro.org,
        gregkh@linuxfoundation.org, preeti@linux.vnet.ibm.com,
        viresh.kumar@linaro.org, linux-kernel@vger.kernel.org
Subject: Re: [patch v6 13/21] sched: using avg_idle to detect bursty wakeup
References: <1364654108-16307-1-git-send-email-alex.shi@intel.com>
	<1364654108-16307-14-git-send-email-alex.shi@intel.com>
Date: Wed, 03 Apr 2013 14:08:01 +0900
In-Reply-To: <1364654108-16307-14-git-send-email-alex.shi@intel.com> (Alex
	Shi's message of "Sat, 30 Mar 2013 22:35:00 +0800")
Message-ID: <876204fbgu.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alex,

On Sat, 30 Mar 2013 22:35:00 +0800, Alex Shi wrote:
> Sleeping task has no utiliation, when they were bursty waked up, the
> zero utilization make scheduler out of balance, like aim7 benchmark.
>
> rq->avg_idle is 'to used to accommodate bursty loads in a dirt simple
> dirt cheap manner' -- Mike Galbraith.
>
> With this cheap and smart bursty indicator, we can find the wake up
> burst, and use nr_running as instant utilization in this scenario.
>
> For other scenarios, we still use the precise CPU utilization to
> judage if a domain is eligible for power scheduling.
>
> Thanks for Mike Galbraith's idea!
>
> Signed-off-by: Alex Shi <alex.shi@intel.com>
> ---
>  kernel/sched/fair.c | 33 ++++++++++++++++++++++++++-------
>  1 file changed, 26 insertions(+), 7 deletions(-)
>
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 83b2c39..ae07190 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -3371,12 +3371,19 @@ static unsigned int max_rq_util(int cpu)
>   * Try to collect the task running number and capacity of the group.
>   */
>  static void get_sg_power_stats(struct sched_group *group,
> -	struct sched_domain *sd, struct sg_lb_stats *sgs)
> +	struct sched_domain *sd, struct sg_lb_stats *sgs, int burst)
>  {
>  	int i;
>  
> -	for_each_cpu(i, sched_group_cpus(group))
> -		sgs->group_util += max_rq_util(i);
> +	for_each_cpu(i, sched_group_cpus(group)) {
> +		struct rq *rq = cpu_rq(i);
> +
> +		if (burst && rq->nr_running > 1)
> +			/* use nr_running as instant utilization */
> +			sgs->group_util += rq->nr_running;

I guess multiplying FULL_UTIL to rq->nr_running here will remove
special-casing the burst in is_sd_full().  Also moving this logic to
max_rq_util() looks better IMHO.


> +		else
> +			sgs->group_util += max_rq_util(i);
> +	}
>  
>  	sgs->group_weight = group->group_weight;
>  }
> @@ -3390,6 +3397,8 @@ static int is_sd_full(struct sched_domain *sd,
>  	struct sched_group *group;
>  	struct sg_lb_stats sgs;
>  	long sd_min_delta = LONG_MAX;
> +	int cpu = task_cpu(p);
> +	int burst = 0;
>  	unsigned int putil;
>  
>  	if (p->se.load.weight == p->se.avg.load_avg_contrib)
> @@ -3399,15 +3408,21 @@ static int is_sd_full(struct sched_domain *sd,
>  		putil = (u64)(p->se.avg.runnable_avg_sum << SCHED_POWER_SHIFT)
>  				/ (p->se.avg.runnable_avg_period + 1);
>  
> +	if (cpu_rq(cpu)->avg_idle < sysctl_sched_burst_threshold)
> +		burst = 1;

Sorry, I don't understand this.

Given that sysctl_sched_burst_threshold is twice of
sysctl_sched_migration_cost which is max value of rq->avg_idle, the
avg_idle will be almost always less than the threshold, right?

So how does it find out the burst case?  I thought it's the case of a
cpu is in idle for a while and then wakes number of tasks at once.  If
so, shouldn't it check whether the avg_idle is *longer* than certain
threshold?  What am I missing?

Thanks,
Namhyung


> +
>  	/* Try to collect the domain's utilization */
>  	group = sd->groups;
>  	do {
>  		long g_delta;
>  
>  		memset(&sgs, 0, sizeof(sgs));
> -		get_sg_power_stats(group, sd, &sgs);
> +		get_sg_power_stats(group, sd, &sgs, burst);
>  
> -		g_delta = sgs.group_weight * FULL_UTIL - sgs.group_util;
> +		if (burst)
> +			g_delta = sgs.group_weight - sgs.group_util;
> +		else
> +			g_delta = sgs.group_weight * FULL_UTIL - sgs.group_util;
>  
>  		if (g_delta > 0 && g_delta < sd_min_delta) {
>  			sd_min_delta = g_delta;
> @@ -3417,8 +3432,12 @@ static int is_sd_full(struct sched_domain *sd,
>  		sds->sd_util += sgs.group_util;
>  	} while  (group = group->next, group != sd->groups);
>  
> -	if (sds->sd_util + putil < sd->span_weight * FULL_UTIL)
> -		return 0;
> +	if (burst) {
> +		if (sds->sd_util < sd->span_weight)
> +			return 0;
> +	} else
> +		if (sds->sd_util + putil < sd->span_weight * FULL_UTIL)
> +			return 0;
>  
>  	/* can not hold one more task in this domain */
>  	return 1;
