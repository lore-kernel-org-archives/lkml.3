Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755569AbaIKMeq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 08:34:46 -0400
Received: from casper.infradead.org ([85.118.1.10]:55855 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755517AbaIKMeO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 08:34:14 -0400
Date: Thu, 11 Sep 2014 14:34:12 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org, preeti@linux.vnet.ibm.com,
        linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        riel@redhat.com, Morten.Rasmussen@arm.com, efault@gmx.de,
        nicolas.pitre@linaro.org, linaro-kernel@lists.linaro.org,
        daniel.lezcano@linaro.org, dietmar.eggemann@arm.com
Subject: Re: [PATCH v5 10/12] sched: get CPU's utilization statistic
Message-ID: <20140911123412.GY3190@worktop.ger.corp.intel.com>
References: <1409051215-16788-1-git-send-email-vincent.guittot@linaro.org>
 <1409051215-16788-11-git-send-email-vincent.guittot@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409051215-16788-11-git-send-email-vincent.guittot@linaro.org>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2014 at 01:06:53PM +0200, Vincent Guittot wrote:
> Monitor the utilization level of each group of each sched_domain level. The
> utilization is the amount of cpu_capacity that is currently used on a CPU or
> group of CPUs. We use the usage_load_avg to evaluate this utilization level.
> In the special use case where the CPU is fully loaded by more than 1 task,
> the activity level is set above the cpu_capacity in order to reflect the overload
> of the CPU
> 
> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
> ---
>  kernel/sched/fair.c | 19 ++++++++++++++++++-
>  1 file changed, 18 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 1fd2131..2f95d1c 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -4126,6 +4126,11 @@ static unsigned long capacity_of(int cpu)
>  	return cpu_rq(cpu)->cpu_capacity;
>  }
>  
> +static unsigned long capacity_orig_of(int cpu)
> +{
> +	return cpu_rq(cpu)->cpu_capacity_orig;
> +}
> +
>  static unsigned long cpu_avg_load_per_task(int cpu)
>  {
>  	struct rq *rq = cpu_rq(cpu);

This hunk should probably go into patch 6.

> @@ -4514,6 +4519,17 @@ static int select_idle_sibling(struct task_struct *p, int target)
>  	return target;
>  }
>  
> +static int get_cpu_utilization(int cpu)
> +{
> +	unsigned long usage = cpu_rq(cpu)->cfs.usage_load_avg;
> +	unsigned long capacity = capacity_of(cpu);
> +
> +	if (usage >= SCHED_LOAD_SCALE)
> +		return capacity + 1;
> +
> +	return (usage * capacity) >> SCHED_LOAD_SHIFT;
> +}

So if I understood patch 9 correct, your changelog is iffy.
usage_load_avg should never get > 1 (of whatever unit), no matter how
many tasks are on the rq. You can only maximally run all the time.

Therefore I can only interpret the if (usage >= SCHED_LOAD_SCALE) as
numerical error handling, nothing more.

Also I'm not entirely sure I like the usage, utilization names/metrics.
I would suggest to reverse them. Call the pure running number
'utilization' and this scaled with capacity 'usage' or so.

> @@ -6188,7 +6206,6 @@ static inline void update_sd_lb_stats(struct lb_env *env, struct sd_lb_stats *sd
>  		/* Now, start updating sd_lb_stats */
>  		sds->total_load += sgs->group_load;
>  		sds->total_capacity += sgs->group_capacity;
> -
>  		sg = sg->next;
>  	} while (sg != env->sd->groups);
>  

I like that extra line of whitespace, it separates the body from the
loop itself.
