Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758532AbaKUMfg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 07:35:36 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:36599 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757176AbaKUMfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 07:35:31 -0500
Date: Fri, 21 Nov 2014 12:36:14 +0000
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: "peterz@infradead.org" <peterz@infradead.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "kamalesh@linux.vnet.ibm.com" <kamalesh@linux.vnet.ibm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "riel@redhat.com" <riel@redhat.com>, "efault@gmx.de" <efault@gmx.de>,
        "nicolas.pitre@linaro.org" <nicolas.pitre@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>
Subject: Re: [PATCH v9 07/10] sched: get CPU's usage statistic
Message-ID: <20141121123614.GG23177@e105550-lin.cambridge.arm.com>
References: <1415033687-23294-1-git-send-email-vincent.guittot@linaro.org>
 <1415033687-23294-8-git-send-email-vincent.guittot@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415033687-23294-8-git-send-email-vincent.guittot@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 03, 2014 at 04:54:44PM +0000, Vincent Guittot wrote:
> Monitor the usage level of each group of each sched_domain level. The usage is
> the portion of cpu_capacity_orig that is currently used on a CPU or group of
> CPUs. We use the utilization_load_avg to evaluate the usage level of each
> group.

Here 'usage' is defined for the first time.

> 
> The utilization_load_avg only takes into account the running time of the CFS
> tasks on a CPU with a maximum value of SCHED_LOAD_SCALE when the CPU is fully
> utilized. Nevertheless, we must cap utilization_load_avg which can be temporaly
> greater than SCHED_LOAD_SCALE after the migration of a task on this CPU and
> until the metrics are stabilized.
> 
> The utilization_load_avg is in the range [0..SCHED_LOAD_SCALE] to reflect the
> running load on the CPU whereas the available capacity for the CFS task is in
> the range [0..cpu_capacity_orig]. In order to test if a CPU is fully utilized
> by CFS tasks, we have to scale the utilization in the cpu_capacity_orig range
> of the CPU to get the usage of the latter. The usage can then be compared with
> the available capacity (ie cpu_capacity) to deduct the usage level of a CPU.

So 'usage' is more precisely scaled utilization (by
cpu_capacity_orig/SCHED_LOAD_SCALE). Do we need to use 'usage' to
describe this?

So far we only have introduced frequency invariant load tracking, once
we add uarch invariance utilization_load_avg will be in the range
[0..cpu_capacity_orig] as the scaling will happen as part of the load
tracking (just like the frequency invariance). Then 'usage' becomes
equal to utilization_load_avg which means that there is very little
reason to keep the term. No?

I haven't pointed out all uses of 'usage' in this and following patches.
If 'usage' is kept the previous patches should be revisited to define
it.

> 
> The frequency scaling invariance of the usage is not taken into account in this
> patch, it will be solved in another patch which will deal with frequency
> scaling invariance on the running_load_avg.
> 
> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
> ---
>  kernel/sched/fair.c | 29 +++++++++++++++++++++++++++++
>  1 file changed, 29 insertions(+)
> 
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 4782733..884578e 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -4559,6 +4559,33 @@ static int select_idle_sibling(struct task_struct *p, int target)
>  done:
>  	return target;
>  }
> +/*
> + * get_cpu_usage returns the amount of capacity of a CPU that is used by CFS
> + * tasks. The unit of the return value must capacity so we can compare the

s/must/must be/

> + * usage with the capacity of the CPU that is available for CFS task (ie
> + * cpu_capacity).
> + * cfs.utilization_load_avg is the sum of running time of runnable tasks on a
> + * CPU. It represents the amount of utilization of a CPU in the range
> + * [0..SCHED_LOAD_SCALE].  The usage of a CPU can't be higher than the full

s/  / /

> + * capacity of the CPU because it's about the running time on this CPU.

Maybe add (cpu_capacity_orig) to make it clear what full capacity means.

> + * Nevertheless, cfs.utilization_load_avg can be higher than SCHED_LOAD_SCALE
> + * because of unfortunate rounding in avg_period and running_load_avg or just
> + * after migrating tasks until the average stabilizes with the new running
> + * time. So we need to check that the usage stays into the range
> + * [0..cpu_capacity_orig] and cap if necessary.
> + * Without capping the usage, a group could be seen as overloaded (CPU0 usage
> + * at 121% + CPU1 usage at 80%) whereas CPU1 has 20% of available capacity/
> + */
> +static int get_cpu_usage(int cpu)
> +{
> +	unsigned long usage = cpu_rq(cpu)->cfs.utilization_load_avg;
> +	unsigned long capacity = capacity_orig_of(cpu);
> +
> +	if (usage >= SCHED_LOAD_SCALE)
> +		return capacity;
> +
> +	return (usage * capacity) >> SCHED_LOAD_SHIFT;
> +}
>  
>  /*
>   * select_task_rq_fair: Select target runqueue for the waking task in domains
> @@ -5688,6 +5715,7 @@ struct sg_lb_stats {
>  	unsigned long sum_weighted_load; /* Weighted load of group's tasks */
>  	unsigned long load_per_task;
>  	unsigned long group_capacity;
> +	unsigned long group_usage; /* Total usage of the group */
>  	unsigned int sum_nr_running; /* Nr tasks running in the group */
>  	unsigned int group_capacity_factor;
>  	unsigned int idle_cpus;
> @@ -6036,6 +6064,7 @@ static inline void update_sg_lb_stats(struct lb_env *env,
>  			load = source_load(i, load_idx);
>  
>  		sgs->group_load += load;
> +		sgs->group_usage += get_cpu_usage(i);
>  		sgs->sum_nr_running += rq->cfs.h_nr_running;
>  
>  		if (rq->nr_running > 1)

The last two hunks do not appear to be used in this patch. Would it be
better to have them with the code that uses the statistics? The patch
however do what the subject says. Just a thought.
