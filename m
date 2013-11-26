Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756804Ab3KZMf5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 07:35:57 -0500
Received: from mail-bk0-f45.google.com ([209.85.214.45]:61556 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755495Ab3KZMfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 07:35:54 -0500
Message-ID: <529495AF.4020600@linaro.org>
Date: Tue, 26 Nov 2013 13:35:59 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Alex Shi <alex.shi@linaro.org>, mingo@redhat.com, peterz@infradead.org,
        morten.rasmussen@arm.com, vincent.guittot@linaro.org,
        fweisbec@gmail.com, linux@arm.linux.org.uk, tony.luck@intel.com,
        fenghua.yu@intel.com, tglx@linutronix.de, akpm@linux-foundation.org,
        arjan@linux.intel.com, pjt@google.com, fengguang.wu@intel.com
CC: james.hogan@imgtec.com, jason.low2@hp.com, gregkh@linuxfoundation.org,
        hanjun.guo@linaro.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/4] sched: remove cpu_load decay.
References: <1385102235-25664-1-git-send-email-alex.shi@linaro.org> <528F4A78.1080505@linaro.org> <52918ECC.6080707@linaro.org>
In-Reply-To: <52918ECC.6080707@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/24/2013 06:29 AM, Alex Shi wrote:
> On 11/22/2013 08:13 PM, Daniel Lezcano wrote:
>>
>> Hi Alex,
>>
>> I tried on my Xeon server (2 x 4 cores) your patchset and got the
>> following result:
>>
>> kernel a5d6e63323fe7799eb0e6  / + patchset
>>
>> hackbench -T -s 4096 -l 1000 -g 10 -f 40
>>        27.604              38.556
>
> Wondering if the following patch is helpful on your Xeon server?
>
> Btw, you can run vmstat as background tool or use 'perf sched'
> to get scheduler statistics change for this patchset.
>
> The following are results of original kernel and all 5 patches
> on pandaboard ES.
>
>      latest kernel 527d1511310a89        + this patchset
> hackbench -T -g 10 -f 40
>      23.25"                    20.79"
>      23.16"                    20.4"
>      24.24"                    20.29"
> hackbench -p -g 10 -f 40
>      26.52"                    21.2"
>      23.89"                    24.07"
>      25.65"                    20.30"
> hackbench -P -g 10 -f 40
>      20.14"                    19.53"
>      19.96"                    20.37"
>      21.76"                    20.39"
>


Here the new results with your patchset + patch #5

I have some issues with perf for the moment, so I will fix it up and 
send the result after.


527d1511310a          / + patchset + #5

hackbench -T -s 4096 -l 1000 -g 10 -f 40
26.677	     	     30.308
27.914		     28.497
28.390		     30.360
28.048		     28.587
26.344		     29.513
27.848		     28.706
28.315		     30.152
28.232		     29.721
26.549		     28.766
30.340		     38.801
hackbench -p -s 4096 -l 1000 -g 10 -f 40
34.522	     	     35.469
34.545		     34.966
34.469		     35.342
34.115		     35.286
34.457		     35.592
34.561		     35.314
34.459		     35.316
34.054		     35.629
34.532		     35.149
34.459		     34.876
hackbench -P -s 4096 -l 1000 -g 10 -f 40
38.938	     	     30.308
39.363		     28.497
39.340		     30.360
38.909		     28.587
39.095		     29.513
38.869		     28.706
39.041		     30.152
38.939		     29.721
38.992		     28.766
38.947		     38.801


> ------
>  From 4f5efd6c2b1e7293410ad57c3db24dcf3394c4a3 Mon Sep 17 00:00:00 2001
> From: Alex Shi <alex.shi@linaro.org>
> Date: Sat, 23 Nov 2013 23:18:09 +0800
> Subject: [PATCH] sched: aggravate target cpu load to reduce task moving
>
> Task migration happens when target just a bit less then source cpu load
> to reduce such situation happens, aggravate the target cpu with sd->
> imbalance_pct.
>
> Signed-off-by: Alex Shi <alex.shi@linaro.org>
> ---
>   kernel/sched/fair.c | 18 ++++++++++++------
>   1 file changed, 12 insertions(+), 6 deletions(-)
>
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index bccdd89..c49b7ba 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -978,7 +978,7 @@ static inline unsigned long group_weight(struct task_struct *p, int nid)
>
>   static unsigned long weighted_cpuload(const int cpu);
>   static unsigned long source_load(int cpu);
> -static unsigned long target_load(int cpu);
> +static unsigned long target_load(int cpu, int imbalance_pct);
>   static unsigned long power_of(int cpu);
>   static long effective_load(struct task_group *tg, int cpu, long wl, long wg);
>
> @@ -3809,11 +3809,17 @@ static unsigned long source_load(int cpu)
>    * Return a high guess at the load of a migration-target cpu weighted
>    * according to the scheduling class and "nice" value.
>    */
> -static unsigned long target_load(int cpu)
> +static unsigned long target_load(int cpu, int imbalance_pct)
>   {
>   	struct rq *rq = cpu_rq(cpu);
>   	unsigned long total = weighted_cpuload(cpu);
>
> +	/*
> +	 * without cpu_load decay, in most of time cpu_load is same as total
> +	 * so we need to make target a bit heavier to reduce task migration
> +	 */
> +	total = total * imbalance_pct / 100;
> +
>   	if (!sched_feat(LB_BIAS))
>   		return total;
>
> @@ -4033,7 +4039,7 @@ static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
>   	this_cpu  = smp_processor_id();
>   	prev_cpu  = task_cpu(p);
>   	load	  = source_load(prev_cpu);
> -	this_load = target_load(this_cpu);
> +	this_load = target_load(this_cpu, 100);
>
>   	/*
>   	 * If sync wakeup then subtract the (maximum possible)
> @@ -4089,7 +4095,7 @@ static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
>
>   	if (balanced ||
>   	    (this_load <= load &&
> -	     this_load + target_load(prev_cpu) <= tl_per_task)) {
> +	     this_load + target_load(prev_cpu, 100) <= tl_per_task)) {
>   		/*
>   		 * This domain has SD_WAKE_AFFINE and
>   		 * p is cache cold in this domain, and
> @@ -4135,7 +4141,7 @@ find_idlest_group(struct sched_domain *sd, struct task_struct *p, int this_cpu)
>   			if (local_group)
>   				load = source_load(i);
>   			else
> -				load = target_load(i);
> +				load = target_load(i, sd->imbalance_pct);
>
>   			avg_load += load;
>   		}
> @@ -5478,7 +5484,7 @@ static inline void update_sg_lb_stats(struct lb_env *env,
>
>   		/* Bias balancing toward cpus of our domain */
>   		if (local_group)
> -			load = target_load(i);
> +			load = target_load(i, env->sd->imbalance_pct);
>   		else
>   			load = source_load(i);
>
>


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

