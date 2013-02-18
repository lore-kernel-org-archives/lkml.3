Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755349Ab3BRIod (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 03:44:33 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:42552 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752334Ab3BRIoc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 03:44:32 -0500
X-AuditID: 9c930197-b7ca4ae000006ba8-c0-5121e9ec578e
Date: Mon, 18 Feb 2013 17:44:39 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Alex Shi <alex.shi@intel.com>
Cc: torvalds@linux-foundation.org, mingo@redhat.com, peterz@infradead.org,
        tglx@linutronix.de, akpm@linux-foundation.org, arjan@linux.intel.com,
        bp@alien8.de, pjt@google.com, namhyung@kernel.org, efault@gmx.de,
        vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, morten.rasmussen@arm.com
Subject: Re: [patch v5 10/15] sched: packing transitory tasks in wake/exec
 power balancing
Message-ID: <20130218084439.GB10009@lge.com>
References: <1361164062-20111-1-git-send-email-alex.shi@intel.com>
 <1361164062-20111-11-git-send-email-alex.shi@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1361164062-20111-11-git-send-email-alex.shi@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Alex.

On Mon, Feb 18, 2013 at 01:07:37PM +0800, Alex Shi wrote:
> If the waked/execed task is transitory enough, it will has a chance to be
> packed into a cpu which is busy but still has time to care it.
> For powersaving policy, only the history util < 25% task has chance to
> be packed, and for balance policy, only histroy util < 12.5% has chance.
> If there is no cpu eligible to handle it, will use a idlest cpu in
> leader group.

After exec(), task's behavior may be changed, and history util may be
changed, too. So, IMHO, exec balancing by history util is not good idea.
How do you think about it?

Thanks.

> Morten Rasmussen catch a type bug and suggest using different criteria
> for different policy, thanks!
> 
> Inspired-by: Vincent Guittot <vincent.guittot@linaro.org>
> Signed-off-by: Alex Shi <alex.shi@intel.com>
> ---
>  kernel/sched/fair.c | 66 ++++++++++++++++++++++++++++++++++++++++++++++++-----
>  1 file changed, 60 insertions(+), 6 deletions(-)
> 
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index b172678..2e8131d 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -3455,19 +3455,72 @@ static inline int get_sd_sched_balance_policy(struct sched_domain *sd,
>  }
>  
>  /*
> + * find_leader_cpu - find the busiest but still has enough leisure time cpu
> + * among the cpus in group.
> + */
> +static int
> +find_leader_cpu(struct sched_group *group, struct task_struct *p, int this_cpu,
> +		int policy)
> +{
> +	/* percentage of the task's util */
> +	unsigned putil = p->se.avg.runnable_avg_sum * 100
> +				/ (p->se.avg.runnable_avg_period + 1);
> +
> +	struct rq *rq = cpu_rq(this_cpu);
> +	int nr_running = rq->nr_running > 0 ? rq->nr_running : 1;
> +	int vacancy, min_vacancy = INT_MAX, max_util;
> +	int leader_cpu = -1;
> +	int i;
> +
> +	if (policy == SCHED_POLICY_POWERSAVING)
> +		max_util = FULL_UTIL;
> +	else
> +		/* maximum allowable util is 60% */
> +		max_util = 60;
> +
> +	/* bias toward local cpu */
> +	if (cpumask_test_cpu(this_cpu, tsk_cpus_allowed(p)) &&
> +		max_util - (rq->util * nr_running + (putil << 2)) > 0)
> +			return this_cpu;
> +
> +	/* Traverse only the allowed CPUs */
> +	for_each_cpu_and(i, sched_group_cpus(group), tsk_cpus_allowed(p)) {
> +		if (i == this_cpu)
> +			continue;
> +
> +		rq = cpu_rq(i);
> +		nr_running = rq->nr_running > 0 ? rq->nr_running : 1;
> +
> +		/* only light task allowed, like putil < 25% for powersaving */
> +		vacancy = max_util - (rq->util * nr_running + (putil << 2));
> +
> +		if (vacancy > 0 && vacancy < min_vacancy) {
> +			min_vacancy = vacancy;
> +			leader_cpu = i;
> +		}
> +	}
> +	return leader_cpu;
> +}
> +
> +/*
>   * If power policy is eligible for this domain, and it has task allowed cpu.
>   * we will select CPU from this domain.
>   */
>  static int get_cpu_for_power_policy(struct sched_domain *sd, int cpu,
> -		struct task_struct *p, struct sd_lb_stats *sds)
> +		struct task_struct *p, struct sd_lb_stats *sds, int fork)
>  {
>  	int policy;
>  	int new_cpu = -1;
>  
>  	policy = get_sd_sched_balance_policy(sd, cpu, p, sds);
> -	if (policy != SCHED_POLICY_PERFORMANCE && sds->group_leader)
> -		new_cpu = find_idlest_cpu(sds->group_leader, p, cpu);
> -
> +	if (policy != SCHED_POLICY_PERFORMANCE && sds->group_leader) {
> +		if (!fork)
> +			new_cpu = find_leader_cpu(sds->group_leader,
> +							p, cpu, policy);
> +		/* for fork balancing and a little busy task */
> +		if (new_cpu == -1)
> +			new_cpu = find_idlest_cpu(sds->group_leader, p, cpu);
> +	}
>  	return new_cpu;
>  }
>  
> @@ -3518,14 +3571,15 @@ select_task_rq_fair(struct task_struct *p, int sd_flag, int flags)
>  		if (tmp->flags & sd_flag) {
>  			sd = tmp;
>  
> -			new_cpu = get_cpu_for_power_policy(sd, cpu, p, &sds);
> +			new_cpu = get_cpu_for_power_policy(sd, cpu, p, &sds,
> +						flags & SD_BALANCE_FORK);
>  			if (new_cpu != -1)
>  				goto unlock;
>  		}
>  	}
>  
>  	if (affine_sd) {
> -		new_cpu = get_cpu_for_power_policy(affine_sd, cpu, p, &sds);
> +		new_cpu = get_cpu_for_power_policy(affine_sd, cpu, p, &sds, 0);
>  		if (new_cpu != -1)
>  			goto unlock;
>  
> -- 
> 1.7.12
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
