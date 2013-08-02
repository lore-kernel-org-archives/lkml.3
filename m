Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753359Ab3HBEZ3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 00:25:29 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:52943 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853Ab3HBEZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 00:25:28 -0400
Message-ID: <51FB341B.7060104@linux.vnet.ibm.com>
Date: Fri, 02 Aug 2013 09:52:51 +0530
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
Subject: Re: [PATCH v2 2/3] sched: factor out code to should_we_balance()
References: <1375408223-10934-1-git-send-email-iamjoonsoo.kim@lge.com> <1375408223-10934-3-git-send-email-iamjoonsoo.kim@lge.com>
In-Reply-To: <1375408223-10934-3-git-send-email-iamjoonsoo.kim@lge.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13080204-2000-0000-0000-00000D247347
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joonsoo,

On 08/02/2013 07:20 AM, Joonsoo Kim wrote:
> Now checking whether this cpu is appropriate to balance or not
> is embedded into update_sg_lb_stats() and this checking has no direct
> relationship to this function. There is not enough reason to place
> this checking at update_sg_lb_stats(), except saving one iteration
> for sched_group_cpus.
> 
> In this patch, I factor out this checking to should_we_balance() function.
> And before doing actual work for load_balancing, check whether this cpu is
> appropriate to balance via should_we_balance(). If this cpu is not
> a candidate for balancing, it quit the work immediately.
> 
> With this change, we can save two memset cost and can expect better
> compiler optimization.
> 
> Below is result of this patch.
> 
> * Vanilla *
>    text	   data	    bss	    dec	    hex	filename
>   34499	   1136	    116	  35751	   8ba7	kernel/sched/fair.o
> 
> * Patched *
>    text	   data	    bss	    dec	    hex	filename
>   34243	   1136	    116	  35495	   8aa7	kernel/sched/fair.o
> 
> In addition, rename @balance to @should_balance in order to represent
> its purpose more clearly.
> 
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> 
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index eaae77e..7f51b8c 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -4426,22 +4426,17 @@ fix_small_capacity(struct sched_domain *sd, struct sched_group *group)
>   * @group: sched_group whose statistics are to be updated.
>   * @load_idx: Load index of sched_domain of this_cpu for load calc.
>   * @local_group: Does group contain this_cpu.
> - * @balance: Should we balance.
>   * @sgs: variable to hold the statistics for this group.
>   */
>  static inline void update_sg_lb_stats(struct lb_env *env,
>  			struct sched_group *group, int load_idx,
> -			int local_group, int *balance, struct sg_lb_stats *sgs)
> +			int local_group, struct sg_lb_stats *sgs)
>  {
>  	unsigned long nr_running, max_nr_running, min_nr_running;
>  	unsigned long load, max_cpu_load, min_cpu_load;
> -	unsigned int balance_cpu = -1, first_idle_cpu = 0;
>  	unsigned long avg_load_per_task = 0;
>  	int i;
> 
> -	if (local_group)
> -		balance_cpu = group_balance_cpu(group);
> -
>  	/* Tally up the load of all CPUs in the group */
>  	max_cpu_load = 0;
>  	min_cpu_load = ~0UL;
> @@ -4454,15 +4449,9 @@ static inline void update_sg_lb_stats(struct lb_env *env,
>  		nr_running = rq->nr_running;
> 
>  		/* Bias balancing toward cpus of our domain */
> -		if (local_group) {
> -			if (idle_cpu(i) && !first_idle_cpu &&
> -					cpumask_test_cpu(i, sched_group_mask(group))) {
> -				first_idle_cpu = 1;
> -				balance_cpu = i;
> -			}
> -
> +		if (local_group)
>  			load = target_load(i, load_idx);
> -		} else {
> +		else {
>  			load = source_load(i, load_idx);
>  			if (load > max_cpu_load)
>  				max_cpu_load = load;
> @@ -4482,22 +4471,9 @@ static inline void update_sg_lb_stats(struct lb_env *env,
>  			sgs->idle_cpus++;
>  	}
> 
> -	/*
> -	 * First idle cpu or the first cpu(busiest) in this sched group
> -	 * is eligible for doing load balancing at this and above
> -	 * domains. In the newly idle case, we will allow all the cpu's
> -	 * to do the newly idle load balance.
> -	 */
> -	if (local_group) {
> -		if (env->idle != CPU_NEWLY_IDLE) {
> -			if (balance_cpu != env->dst_cpu) {
> -				*balance = 0;
> -				return;
> -			}
> -			update_group_power(env->sd, env->dst_cpu);
> -		} else if (time_after_eq(jiffies, group->sgp->next_update))
> -			update_group_power(env->sd, env->dst_cpu);
> -	}

Observe what is happening in the above code which checks if we should
balance on the env->dst_cpu.

Only if the env->dst_cpu "belongs" to the group considered in
update_sg_lb_stats(), which means local_group = 1,should the above
checks be carried out.

Meaning, if there is a better CPU in the same group to which
env->dst_cpu belongs, to carry out load balancing for the system (in the
above case, balance_cpu), cancel the current iteration of load balancing
on env->dst_cpu. Wait for the right cpu in this group to do the load
balancing.

Keeping this in mind see the below comments around should_we_balance().

> @@ -5001,13 +4964,47 @@ static int need_active_balance(struct lb_env *env)
> 
>  static int active_load_balance_cpu_stop(void *data);
> 
> +static int should_we_balance(struct lb_env *env)
> +{
> +	struct sched_group *sg = env->sd->groups;
> +	struct cpumask *sg_cpus, *sg_mask;
> +	int cpu, balance_cpu = -1;
> +
> +	/*
> +	 * In the newly idle case, we will allow all the cpu's
> +	 * to do the newly idle load balance.
> +	 */
> +	if (env->idle == CPU_NEWLY_IDLE)
> +		return 1;
> +
> +	sg_cpus = sched_group_cpus(sg);
> +	sg_mask = sched_group_mask(sg);
> +	/* Try to find first idle cpu */
> +	for_each_cpu_and(cpu, sg_cpus, env->cpus) {
> +		if (!cpumask_test_cpu(cpu, sg_mask) || idle_cpu(cpu))
> +			continue;
> +
> +		balance_cpu = cpu;
> +		break;
> +	}

You need to iterate over all the groups of the sched domain env->sd and
not just the first group of env->sd like you are doing above. This is to
check to which group the env->dst_cpu belongs to. Only for that group
should you do the above check and set of balance_cpu and the below check
of balance_cpu != env->dst_cpu.

> +
> +	if (balance_cpu == -1)
> +		balance_cpu = group_balance_cpu(sg);
> +
> +	/*
> +	 * First idle cpu or the first cpu(busiest) in this sched group
> +	 * is eligible for doing load balancing at this and above domains.
> +	 */
> +	return balance_cpu != env->dst_cpu;

Regards
Preeti U Murthy

