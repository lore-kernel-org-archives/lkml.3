Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755046Ab3LDJFu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 04:05:50 -0500
Received: from mga09.intel.com ([134.134.136.24]:3966 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754731Ab3LDJFq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 04:05:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,823,1378882800"; 
   d="scan'208";a="438249028"
Date: Wed, 4 Dec 2013 17:06:15 +0800
From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
To: Alex Shi <alex.shi@linaro.org>
Cc: mingo@redhat.com, peterz@infradead.org, morten.rasmussen@arm.com,
        vincent.guittot@linaro.org, daniel.lezcano@linaro.org,
        fweisbec@gmail.com, linux@arm.linux.org.uk, tony.luck@intel.com,
        fenghua.yu@intel.com, tglx@linutronix.de, akpm@linux-foundation.org,
        arjan@linux.intel.com, pjt@google.com, fengguang.wu@intel.com,
        james.hogan@imgtec.com, jason.low2@hp.com, gregkh@linuxfoundation.org,
        hanjun.guo@linaro.org, linux-kernel@vger.kernel.org,
        Huang Ying <ying.huang@intel.com>
Subject: Re: [PATCH 4/4] sched: bias to target cpu load to reduce task moving
Message-ID: <20131204090615.GA5135@yliu-dev.sh.intel.com>
References: <1386061556-28233-1-git-send-email-alex.shi@linaro.org>
 <1386061556-28233-5-git-send-email-alex.shi@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386061556-28233-5-git-send-email-alex.shi@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 03, 2013 at 05:05:56PM +0800, Alex Shi wrote:
> Task migration happens when target just a bit less then source cpu load.
> To reduce such situation happens, aggravate the target cpu load with
> sd->imbalance_pct/100.
> 
> This patch removes the hackbench thread regression on Daniel's
> Intel Core2 server.
> 
> a5d6e63		+patch1~3		+patch1~4
> hackbench -T -s 4096 -l 1000 -g 10 -f 40
> 27.914"         38.694"			28.587"
> 28.390"         38.341"			29.513"
> 28.048"         38.626"			28.706"
> 
> Signed-off-by: Alex Shi <alex.shi@linaro.org>

Hi Alex,

We obsevered 150% performance gain with vm-scalability/300s-mmap-pread-seq
testcase with this patch applied. Here is a list of changes we got so far:

testbox : brickland
testcase: vm-scalability/300s-mmap-pread-seq


    f1b6442c7dd12802e622      d70495ef86f397816d73  
       (parent commit)            (this commit)
------------------------  ------------------------  
             26393249.80      +150.9%  66223933.60  vm-scalability.throughput

                  225.12       -49.9%       112.75  time.elapsed_time
                36333.40       -90.7%      3392.20  vmstat.system.cs
                    2.40      +375.0%        11.40  vmstat.cpu.id
              3770081.60       -97.7%     87673.40  time.major_page_faults
              3975276.20       -97.0%    117409.60  time.voluntary_context_switches
                    3.05      +301.7%        12.24  iostat.cpu.idle
                21118.41       -70.3%      6277.19  time.system_time
                   18.40      +130.4%        42.40  vmstat.cpu.us
                   77.00       -41.3%        45.20  vmstat.cpu.sy
                47459.60       -31.3%     32592.20  vmstat.system.in
                82435.40       -12.1%     72443.60  time.involuntary_context_switches
                 5128.13       +14.0%      5848.30  time.user_time
                11656.20        -7.8%     10745.60  time.percent_of_cpu_this_job_got
           1069997484.80        +0.3% 1073679919.00 time.minor_page_faults


	--yliu
> ---
>  kernel/sched/fair.c | 18 ++++++++++++------
>  1 file changed, 12 insertions(+), 6 deletions(-)
> 
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index bccdd89..c49b7ba 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -978,7 +978,7 @@ static inline unsigned long group_weight(struct task_struct *p, int nid)
>  
>  static unsigned long weighted_cpuload(const int cpu);
>  static unsigned long source_load(int cpu);
> -static unsigned long target_load(int cpu);
> +static unsigned long target_load(int cpu, int imbalance_pct);
>  static unsigned long power_of(int cpu);
>  static long effective_load(struct task_group *tg, int cpu, long wl, long wg);
>  
> @@ -3809,11 +3809,17 @@ static unsigned long source_load(int cpu)
>   * Return a high guess at the load of a migration-target cpu weighted
>   * according to the scheduling class and "nice" value.
>   */
> -static unsigned long target_load(int cpu)
> +static unsigned long target_load(int cpu, int imbalance_pct)
>  {
>  	struct rq *rq = cpu_rq(cpu);
>  	unsigned long total = weighted_cpuload(cpu);
>  
> +	/*
> +	 * without cpu_load decay, in most of time cpu_load is same as total
> +	 * so we need to make target a bit heavier to reduce task migration
> +	 */
> +	total = total * imbalance_pct / 100;
> +
>  	if (!sched_feat(LB_BIAS))
>  		return total;
>  
> @@ -4033,7 +4039,7 @@ static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
>  	this_cpu  = smp_processor_id();
>  	prev_cpu  = task_cpu(p);
>  	load	  = source_load(prev_cpu);
> -	this_load = target_load(this_cpu);
> +	this_load = target_load(this_cpu, 100);
>  
>  	/*
>  	 * If sync wakeup then subtract the (maximum possible)
> @@ -4089,7 +4095,7 @@ static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
>  
>  	if (balanced ||
>  	    (this_load <= load &&
> -	     this_load + target_load(prev_cpu) <= tl_per_task)) {
> +	     this_load + target_load(prev_cpu, 100) <= tl_per_task)) {
>  		/*
>  		 * This domain has SD_WAKE_AFFINE and
>  		 * p is cache cold in this domain, and
> @@ -4135,7 +4141,7 @@ find_idlest_group(struct sched_domain *sd, struct task_struct *p, int this_cpu)
>  			if (local_group)
>  				load = source_load(i);
>  			else
> -				load = target_load(i);
> +				load = target_load(i, sd->imbalance_pct);
>  
>  			avg_load += load;
>  		}
> @@ -5478,7 +5484,7 @@ static inline void update_sg_lb_stats(struct lb_env *env,
>  
>  		/* Bias balancing toward cpus of our domain */
>  		if (local_group)
> -			load = target_load(i);
> +			load = target_load(i, env->sd->imbalance_pct);
>  		else
>  			load = source_load(i);
>  
> -- 
> 1.8.1.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
