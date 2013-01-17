Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759126Ab3AQFR5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 00:17:57 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:61386 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778Ab3AQFR4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 00:17:56 -0500
X-AuditID: 9c93016f-b7b70ae000000e36-42-50f7898140e3
From: Namhyung Kim <namhyung@kernel.org>
To: Alex Shi <alex.shi@intel.com>
Cc: Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Mike Galbraith <bitbucket@online.de>,
        LKML <linux-kernel@vger.kernel.org>,
        "svaidy\@linux.vnet.ibm.com" <svaidy@linux.vnet.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Paul McKenney <paul.mckenney@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Ingo Molnar <mingo@kernel.org>, Paul Turner <pjt@google.com>,
        Venki Pallipadi <venki@google.com>,
        Robin Randhawa <robin.randhawa@arm.com>,
        Lists linaro-dev <linaro-dev@lists.linaro.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>, srikar@linux.vnet.ibm.com
Subject: Re: sched: Consequences of integrating the Per Entity Load Tracking Metric into the Load Balancer
References: <50E3B61A.3040808@linux.vnet.ibm.com>
	<1357114354.5586.39.camel@marge.simpson.net>
	<50E55F99.6090104@linux.vnet.ibm.com>
	<1357373590.5690.172.camel@marge.simpson.net>
	<1357489955.5717.21.camel@marge.simpson.net>
	<50EA5D41.4090502@linux.vnet.ibm.com>
	<1357544184.5792.140.camel@marge.simpson.net>
	<50EBDBB7.5060803@linux.vnet.ibm.com> <50F6B455.2040508@intel.com>
Date: Thu, 17 Jan 2013 14:17:53 +0900
In-Reply-To: <50F6B455.2040508@intel.com> (Alex Shi's message of "Wed, 16 Jan
	2013 22:08:21 +0800")
Message-ID: <87k3rcl75q.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Jan 2013 22:08:21 +0800, Alex Shi wrote:
> On 01/08/2013 04:41 PM, Preeti U Murthy wrote:
>> Hi Mike,
>> 
>> Thank you very much for such a clear and comprehensive explanation.
>> So when I put together the problem and the proposed solution pieces in the current
>> scheduler scalability,the following was what I found:
>> 
>> 1. select_idle_sibling() is needed as an agent to correctly find the right cpu for wake
>>    up tasks to go to."Correctly" would be to find an idle cpu at the lowest cost possible.
>> 2."Cost could be lowered" either by optimizing the order of searching for an idle cpu or
>>    restricting the search to a few cpus alone.
>> 3. The former has the problem that it would not prevent bouncing tasks all over the domain
>>    sharing an L3 cache,which could potentially affect the fast moving tasks.
>> 4. The latter has the problem that it is not aggressive enough in finding an idle cpu.
>> 
>> This is some tangled problem,but I think the solution at best could be smoothed to a a flowchart.
>> 
>>        STEP1                       STEP2                STEP3
>>  _____________________
>> |                     |
>> |See if the idle buddy|No    _________________  Yes   ________________
>> |is free at all sched |---->| Do we search the|----> |Optimized search|
>> |domains              |     |sched domains    |      |________________|
>> |_____________________|     |for an idle cpu  |                 |
>>           |Yes              |_________________|                \|/
>>          \|/                        |No: saturated     Return target cpu
>>         Return                     \|/     system
>>         cpu buddy                Return prev_cpu
>> 
>
>
>
> I re-written the patch as following. hackbench/aim9 doest show clean performance change.
> Actually we can get some profit. it also will be very slight. :) 
> BTW, it still need another patch before apply this. Just to show the logical.
>
> ===========
>> From 145ff27744c8ac04eda056739fe5aa907a00877e Mon Sep 17 00:00:00 2001
> From: Alex Shi <alex.shi@intel.com>
> Date: Fri, 11 Jan 2013 16:49:03 +0800
> Subject: [PATCH 3/7] sched: select_idle_sibling optimization
>
> Current logical in this function will insist to wake up the task in a
> totally idle group, otherwise it would rather back to previous cpu.

Or current cpu depending on result of wake_affine(), right?

>
> The new logical will try to wake up the task on any idle cpu in the same
> cpu socket (in same sd_llc), while idle cpu in the smaller domain has
> higher priority.

But what about SMT domain?

I mean it seems that the code prefers running a task on a idle cpu which
is a sibling thread in the same core rather than running it on an idle
cpu in another idle core.  I guess we didn't do that before.

>
> It should has some help on burst wake up benchmarks like aim7.
>
> Original-patch-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
> Signed-off-by: Alex Shi <alex.shi@intel.com>
> ---
>  kernel/sched/fair.c |   40 +++++++++++++++++++---------------------
>  1 files changed, 19 insertions(+), 21 deletions(-)
>
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index e116215..fa40e49 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -3253,13 +3253,13 @@ find_idlest_cpu(struct sched_group *group, struct task_struct *p, int this_cpu)
>  /*
>   * Try and locate an idle CPU in the sched_domain.
>   */
> -static int select_idle_sibling(struct task_struct *p)
> +static int select_idle_sibling(struct task_struct *p,
> +				struct sched_domain *affine_sd, int sync)

Where are these arguments used?


>  {
>  	int cpu = smp_processor_id();
>  	int prev_cpu = task_cpu(p);
>  	struct sched_domain *sd;
>  	struct sched_group *sg;
> -	int i;
>  
>  	/*
>  	 * If the task is going to be woken-up on this cpu and if it is
> @@ -3281,27 +3281,25 @@ static int select_idle_sibling(struct task_struct *p)
>  	/*
>  	 * Otherwise, iterate the domains and find an elegible idle cpu.
>  	 */
> -	sd = rcu_dereference(per_cpu(sd_llc, prev_cpu));
> -	for_each_lower_domain(sd) {
> +	for_each_domain(prev_cpu, sd) {

Always start from the prev_cpu?


>  		sg = sd->groups;
>  		do {
> -			if (!cpumask_intersects(sched_group_cpus(sg),
> -						tsk_cpus_allowed(p)))
> -				goto next;
> -
> -			for_each_cpu(i, sched_group_cpus(sg)) {
> -				if (!idle_cpu(i))
> -					goto next;
> -			}
> -
> -			prev_cpu = cpumask_first_and(sched_group_cpus(sg),
> -					tsk_cpus_allowed(p));
> -			goto done;
> -next:
> -			sg = sg->next;
> -		} while (sg != sd->groups);
> +			int nr_busy = atomic_read(&sg->sgp->nr_busy_cpus);
> +			int i;
> +
> +			/* no idle cpu in the group */
> +			if (nr_busy == sg->group_weight)
> +				continue;

Maybe we can skip local group since it's a bottom-up search so we know
there's no idle cpu in the lower domain from the prior iteration.


> +			for_each_cpu_and(i, sched_group_cpus(sg),
> +							tsk_cpus_allowed(p))
> +				if (idle_cpu(i))
> +					return i;
> +		} while (sg = sg->next, sg != sd->groups);
> +
> +		/* only wake up task on the same cpu socket as prev cpu */
> +		if (sd == per_cpu(sd_llc, prev_cpu))
> +			break;
>  	}
> -done:
>  	return prev_cpu;
>  }
>  
> @@ -3355,7 +3353,7 @@ select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flags)
>  	}
>  
>  	if (affine_sd) {
> -		new_cpu = select_idle_sibling(p, prev_cpu);
> +		new_cpu = select_idle_sibling(p, affine_sd, sync);
>  		goto unlock;
>  	}
