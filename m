Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752555AbaKDIaQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 03:30:16 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:38315 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163AbaKDIaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 03:30:13 -0500
Message-ID: <54588E89.1080108@gmail.com>
Date: Tue, 04 Nov 2014 16:30:01 +0800
From: Wanpeng Li <kernellwp@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.10; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Vincent Guittot <vincent.guittot@linaro.org>, peterz@infradead.org,
        mingo@kernel.org, linux-kernel@vger.kernel.org,
        preeti@linux.vnet.ibm.com, Morten.Rasmussen@arm.com,
        kamalesh@linux.vnet.ibm.com, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org
CC: riel@redhat.com, efault@gmx.de, nicolas.pitre@linaro.org,
        linaro-kernel@lists.linaro.org
Subject: Re: [PATCH v8 03/10] sched: move cfs task on a CPU with higher capacity
References: <1414745252-4895-1-git-send-email-vincent.guittot@linaro.org> <1414745252-4895-4-git-send-email-vincent.guittot@linaro.org>
In-Reply-To: <1414745252-4895-4-git-send-email-vincent.guittot@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 14/10/31 下午4:47, Vincent Guittot wrote:
> When a CPU is used to handle a lot of IRQs or some RT tasks, the remaining
> capacity for CFS tasks can be significantly reduced. Once we detect such
> situation by comparing cpu_capacity_orig and cpu_capacity, we trig an idle
> load balance to check if it's worth moving its tasks on an idle CPU.
>
> Once the idle load_balance has selected the busiest CPU, it will look for an
> active load balance for only two cases :
> - there is only 1 task on the busiest CPU.
> - we haven't been able to move a task of the busiest rq.
>
> A CPU with a reduced capacity is included in the 1st case, and it's worth to
> actively migrate its task if the idle CPU has got full capacity. This test has
> been added in need_active_balance.
>
> As a sidenote, this will note generate more spurious ilb because we already
> trig an ilb if there is more than 1 busy cpu. If this cpu is the only one that
> has a task, we will trig the ilb once for migrating the task.
>
> The nohz_kick_needed function has been cleaned up a bit while adding the new
> test
>
> env.src_cpu and env.src_rq must be set unconditionnally because they are used
> in need_active_balance which is called even if busiest->nr_running equals 1
>
> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
> ---
>   kernel/sched/fair.c | 86 ++++++++++++++++++++++++++++++++++++++++-------------
>   1 file changed, 65 insertions(+), 21 deletions(-)
>
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index bd214d2..54468f3 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -5889,6 +5889,18 @@ fix_small_capacity(struct sched_domain *sd, struct sched_group *group)
>   }
>   
>   /*
> + * Check whether the capacity of the rq has been noticeably reduced by side
> + * activity. The imbalance_pct is used for the threshold.
> + * Return true is the capacity is reduced
> + */
> +static inline int
> +check_cpu_capacity(struct rq *rq, struct sched_domain *sd)
> +{
> +	return ((rq->cpu_capacity * sd->imbalance_pct) <
> +				(rq->cpu_capacity_orig * 100));
> +}
> +
> +/*
>    * Group imbalance indicates (and tries to solve) the problem where balancing
>    * groups is inadequate due to tsk_cpus_allowed() constraints.
>    *
> @@ -6562,6 +6574,28 @@ static int need_active_balance(struct lb_env *env)
>   			return 1;
>   	}
>   
> +	/*
> +	 * The dst_cpu is idle and the src_cpu CPU has only 1 CFS task.

Why specify one task instead of not less than one?

Regards,
Wanpeng Li

> +	 * It's worth migrating the task if the src_cpu's capacity is reduced
> +	 * because of other sched_class or IRQs whereas capacity stays
> +	 * available on dst_cpu.
> +	 */
> +	if ((env->idle != CPU_NOT_IDLE) &&
> +			(env->src_rq->cfs.h_nr_running == 1)) {
> +		unsigned long src_eff_capacity, dst_eff_capacity;
> +
> +		dst_eff_capacity = 100;
> +		dst_eff_capacity *= capacity_of(env->dst_cpu);
> +		dst_eff_capacity *= capacity_orig_of(env->src_cpu);
> +
> +		src_eff_capacity = sd->imbalance_pct;
> +		src_eff_capacity *= capacity_of(env->src_cpu);
> +		src_eff_capacity *= capacity_orig_of(env->dst_cpu);
> +
> +		if (src_eff_capacity < dst_eff_capacity)
> +			return 1;
> +	}
> +
>   	return unlikely(sd->nr_balance_failed > sd->cache_nice_tries+2);
>   }
>   
> @@ -6661,6 +6695,9 @@ static int load_balance(int this_cpu, struct rq *this_rq,
>   
>   	schedstat_add(sd, lb_imbalance[idle], env.imbalance);
>   
> +	env.src_cpu = busiest->cpu;
> +	env.src_rq = busiest;
> +
>   	ld_moved = 0;
>   	if (busiest->nr_running > 1) {
>   		/*
> @@ -6670,8 +6707,6 @@ static int load_balance(int this_cpu, struct rq *this_rq,
>   		 * correctly treated as an imbalance.
>   		 */
>   		env.flags |= LBF_ALL_PINNED;
> -		env.src_cpu   = busiest->cpu;
> -		env.src_rq    = busiest;
>   		env.loop_max  = min(sysctl_sched_nr_migrate, busiest->nr_running);
>   
>   more_balance:
> @@ -7371,22 +7406,25 @@ static void nohz_idle_balance(struct rq *this_rq, enum cpu_idle_type idle)
>   
>   /*
>    * Current heuristic for kicking the idle load balancer in the presence
> - * of an idle cpu is the system.
> + * of an idle cpu in the system.
>    *   - This rq has more than one task.
> - *   - At any scheduler domain level, this cpu's scheduler group has multiple
> - *     busy cpu's exceeding the group's capacity.
> + *   - This rq has at least one CFS task and the capacity of the CPU is
> + *     significantly reduced because of RT tasks or IRQs.
> + *   - At parent of LLC scheduler domain level, this cpu's scheduler group has
> + *     multiple busy cpu.
>    *   - For SD_ASYM_PACKING, if the lower numbered cpu's in the scheduler
>    *     domain span are idle.
>    */
> -static inline int nohz_kick_needed(struct rq *rq)
> +static inline bool nohz_kick_needed(struct rq *rq)
>   {
>   	unsigned long now = jiffies;
>   	struct sched_domain *sd;
>   	struct sched_group_capacity *sgc;
>   	int nr_busy, cpu = rq->cpu;
> +	bool kick = false;
>   
>   	if (unlikely(rq->idle_balance))
> -		return 0;
> +		return false;
>   
>          /*
>   	* We may be recently in ticked or tickless idle mode. At the first
> @@ -7400,38 +7438,44 @@ static inline int nohz_kick_needed(struct rq *rq)
>   	 * balancing.
>   	 */
>   	if (likely(!atomic_read(&nohz.nr_cpus)))
> -		return 0;
> +		return false;
>   
>   	if (time_before(now, nohz.next_balance))
> -		return 0;
> +		return false;
>   
>   	if (rq->nr_running >= 2)
> -		goto need_kick;
> +		return true;
>   
>   	rcu_read_lock();
>   	sd = rcu_dereference(per_cpu(sd_busy, cpu));
> -
>   	if (sd) {
>   		sgc = sd->groups->sgc;
>   		nr_busy = atomic_read(&sgc->nr_busy_cpus);
>   
> -		if (nr_busy > 1)
> -			goto need_kick_unlock;
> +		if (nr_busy > 1) {
> +			kick = true;
> +			goto unlock;
> +		}
> +
>   	}
>   
> -	sd = rcu_dereference(per_cpu(sd_asym, cpu));
> +	sd = rcu_dereference(rq->sd);
> +	if (sd) {
> +		if ((rq->cfs.h_nr_running >= 1) &&
> +				check_cpu_capacity(rq, sd)) {
> +			kick = true;
> +			goto unlock;
> +		}
> +	}
>   
> +	sd = rcu_dereference(per_cpu(sd_asym, cpu));
>   	if (sd && (cpumask_first_and(nohz.idle_cpus_mask,
>   				  sched_domain_span(sd)) < cpu))
> -		goto need_kick_unlock;
> +		kick = true;
>   
> +unlock:
>   	rcu_read_unlock();
> -	return 0;
> -
> -need_kick_unlock:
> -	rcu_read_unlock();
> -need_kick:
> -	return 1;
> +	return kick;
>   }
>   #else
>   static void nohz_idle_balance(struct rq *this_rq, enum cpu_idle_type idle) { }

