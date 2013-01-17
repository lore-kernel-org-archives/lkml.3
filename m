Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755666Ab3AQNlf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 08:41:35 -0500
Received: from mga02.intel.com ([134.134.136.20]:47635 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752350Ab3AQNld (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 08:41:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,486,1355126400"; 
   d="scan'208";a="248325355"
Message-ID: <50F7FF79.6080603@intel.com>
Date: Thu, 17 Jan 2013 21:41:13 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
CC: Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Mike Galbraith <bitbucket@online.de>,
        LKML <linux-kernel@vger.kernel.org>,
        "svaidy@linux.vnet.ibm.com" <svaidy@linux.vnet.ibm.com>,
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
Subject: Re: sched: Consequences of integrating the Per Entity Load Tracking
 Metric into the Load Balancer
References: <50E3B61A.3040808@linux.vnet.ibm.com> <1357114354.5586.39.camel@marge.simpson.net> <50E55F99.6090104@linux.vnet.ibm.com> <1357373590.5690.172.camel@marge.simpson.net> <1357489955.5717.21.camel@marge.simpson.net> <50EA5D41.4090502@linux.vnet.ibm.com> <1357544184.5792.140.camel@marge.simpson.net> <50EBDBB7.5060803@linux.vnet.ibm.com> <50F6B455.2040508@intel.com> <87k3rcl75q.fsf@sejong.aot.lge.com>
In-Reply-To: <87k3rcl75q.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/17/2013 01:17 PM, Namhyung Kim wrote:
> On Wed, 16 Jan 2013 22:08:21 +0800, Alex Shi wrote:
>> On 01/08/2013 04:41 PM, Preeti U Murthy wrote:
>>> Hi Mike,
>>>
>>> Thank you very much for such a clear and comprehensive explanation.
>>> So when I put together the problem and the proposed solution pieces in the current
>>> scheduler scalability,the following was what I found:
>>>
>>> 1. select_idle_sibling() is needed as an agent to correctly find the right cpu for wake
>>>    up tasks to go to."Correctly" would be to find an idle cpu at the lowest cost possible.
>>> 2."Cost could be lowered" either by optimizing the order of searching for an idle cpu or
>>>    restricting the search to a few cpus alone.
>>> 3. The former has the problem that it would not prevent bouncing tasks all over the domain
>>>    sharing an L3 cache,which could potentially affect the fast moving tasks.
>>> 4. The latter has the problem that it is not aggressive enough in finding an idle cpu.
>>>
>>> This is some tangled problem,but I think the solution at best could be smoothed to a a flowchart.
>>>
>>>        STEP1                       STEP2                STEP3
>>>  _____________________
>>> |                     |
>>> |See if the idle buddy|No    _________________  Yes   ________________
>>> |is free at all sched |---->| Do we search the|----> |Optimized search|
>>> |domains              |     |sched domains    |      |________________|
>>> |_____________________|     |for an idle cpu  |                 |
>>>           |Yes              |_________________|                \|/
>>>          \|/                        |No: saturated     Return target cpu
>>>         Return                     \|/     system
>>>         cpu buddy                Return prev_cpu
>>>
>>
>>
>>
>> I re-written the patch as following. hackbench/aim9 doest show clean performance change.
>> Actually we can get some profit. it also will be very slight. :) 
>> BTW, it still need another patch before apply this. Just to show the logical.
>>
>> ===========
>>> From 145ff27744c8ac04eda056739fe5aa907a00877e Mon Sep 17 00:00:00 2001
>> From: Alex Shi <alex.shi@intel.com>
>> Date: Fri, 11 Jan 2013 16:49:03 +0800
>> Subject: [PATCH 3/7] sched: select_idle_sibling optimization
>>
>> Current logical in this function will insist to wake up the task in a
>> totally idle group, otherwise it would rather back to previous cpu.
> 
> Or current cpu depending on result of wake_affine(), right?
> 
>>
>> The new logical will try to wake up the task on any idle cpu in the same
>> cpu socket (in same sd_llc), while idle cpu in the smaller domain has
>> higher priority.
> 
> But what about SMT domain?
> 
> I mean it seems that the code prefers running a task on a idle cpu which
> is a sibling thread in the same core rather than running it on an idle
> cpu in another idle core.  I guess we didn't do that before.
> 
>>
>> It should has some help on burst wake up benchmarks like aim7.
>>
>> Original-patch-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
>> Signed-off-by: Alex Shi <alex.shi@intel.com>
>> ---
>>  kernel/sched/fair.c |   40 +++++++++++++++++++---------------------
>>  1 files changed, 19 insertions(+), 21 deletions(-)
>>
>> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
>> index e116215..fa40e49 100644
>> --- a/kernel/sched/fair.c
>> +++ b/kernel/sched/fair.c
>> @@ -3253,13 +3253,13 @@ find_idlest_cpu(struct sched_group *group, struct task_struct *p, int this_cpu)
>>  /*
>>   * Try and locate an idle CPU in the sched_domain.
>>   */
>> -static int select_idle_sibling(struct task_struct *p)
>> +static int select_idle_sibling(struct task_struct *p,
>> +				struct sched_domain *affine_sd, int sync)
> 
> Where are these arguments used?
> 
> 
>>  {
>>  	int cpu = smp_processor_id();
>>  	int prev_cpu = task_cpu(p);
>>  	struct sched_domain *sd;
>>  	struct sched_group *sg;
>> -	int i;
>>  
>>  	/*
>>  	 * If the task is going to be woken-up on this cpu and if it is
>> @@ -3281,27 +3281,25 @@ static int select_idle_sibling(struct task_struct *p)
>>  	/*
>>  	 * Otherwise, iterate the domains and find an elegible idle cpu.
>>  	 */
>> -	sd = rcu_dereference(per_cpu(sd_llc, prev_cpu));
>> -	for_each_lower_domain(sd) {
>> +	for_each_domain(prev_cpu, sd) {
> 
> Always start from the prev_cpu?

a previous patch will check wake_affine and set prev_cpu = cpu accordingly.
> 
> 
>>  		sg = sd->groups;
>>  		do {
>> -			if (!cpumask_intersects(sched_group_cpus(sg),
>> -						tsk_cpus_allowed(p)))
>> -				goto next;
>> -
>> -			for_each_cpu(i, sched_group_cpus(sg)) {
>> -				if (!idle_cpu(i))
>> -					goto next;
>> -			}
>> -
>> -			prev_cpu = cpumask_first_and(sched_group_cpus(sg),
>> -					tsk_cpus_allowed(p));
>> -			goto done;
>> -next:
>> -			sg = sg->next;
>> -		} while (sg != sd->groups);
>> +			int nr_busy = atomic_read(&sg->sgp->nr_busy_cpus);
>> +			int i;
>> +
>> +			/* no idle cpu in the group */
>> +			if (nr_busy == sg->group_weight)
>> +				continue;
> 
> Maybe we can skip local group since it's a bottom-up search so we know
> there's no idle cpu in the lower domain from the prior iteration.
> 

I did this change but seems results are worse on my machines, guess start seeking idle cpu bottom up is a bad idea.
The following is full version with above change.

diff --git a/include/linux/topology.h b/include/linux/topology.h
index d3cf0d6..386bcf4 100644
--- a/include/linux/topology.h
+++ b/include/linux/topology.h
@@ -132,6 +132,7 @@ int arch_update_cpu_topology(void);
 				| 0*SD_SHARE_CPUPOWER			\
 				| 1*SD_SHARE_PKG_RESOURCES		\
 				| 0*SD_SERIALIZE			\
+				| 1*SD_PREFER_SIBLING			\
 				,					\
 	.last_balance		= jiffies,				\
 	.balance_interval	= 1,					\
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 5eea870..271b335 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3169,6 +3169,7 @@ static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
 
 		return 1;
 	}
+	/* bias toward prev cpu */
 	return 0;
 }
 
@@ -3252,53 +3253,56 @@ find_idlest_cpu(struct sched_group *group, struct task_struct *p, int this_cpu)
 /*
  * Try and locate an idle CPU in the sched_domain.
  */
-static int select_idle_sibling(struct task_struct *p, int target)
+static int select_idle_sibling(struct task_struct *p,
+				struct sched_domain *affine_sd, int sync)
 {
 	int cpu = smp_processor_id();
 	int prev_cpu = task_cpu(p);
-	struct sched_domain *sd;
+	struct sched_domain *sd, *llcsd;
 	struct sched_group *sg;
-	int i;
 
 	/*
 	 * If the task is going to be woken-up on this cpu and if it is
 	 * already idle, then it is the right target.
 	 */
-	if (target == cpu && idle_cpu(cpu))
+	if (idle_cpu(cpu))
 		return cpu;
 
 	/*
 	 * If the task is going to be woken-up on the cpu where it previously
 	 * ran and if it is currently idle, then it the right target.
 	 */
-	if (target == prev_cpu && idle_cpu(prev_cpu))
+	if (cpu != prev_cpu && idle_cpu(prev_cpu))
 		return prev_cpu;
 
+	if (cpu != prev_cpu && !wake_affine(affine_sd, p, sync))
+		cpu = prev_cpu;
+
 	/*
 	 * Otherwise, iterate the domains and find an elegible idle cpu.
 	 */
-	sd = rcu_dereference(per_cpu(sd_llc, target));
-	for_each_lower_domain(sd) {
+	llcsd = rcu_dereference(per_cpu(sd_llc, cpu));
+	for_each_domain(cpu, sd) {
 		sg = sd->groups;
 		do {
-			if (!cpumask_intersects(sched_group_cpus(sg),
-						tsk_cpus_allowed(p)))
-				goto next;
-
-			for_each_cpu(i, sched_group_cpus(sg)) {
-				if (!idle_cpu(i))
-					goto next;
-			}
-
-			target = cpumask_first_and(sched_group_cpus(sg),
-					tsk_cpus_allowed(p));
-			goto done;
-next:
-			sg = sg->next;
-		} while (sg != sd->groups);
+			int nr_busy = atomic_read(&sg->sgp->nr_busy_cpus);
+			int i;
+
+			/* skip local group and if no idle cpu in group */
+			if (cpumask_test_cpu(cpu, sched_group_cpus(sg)) ||
+					nr_busy == sg->group_weight)
+				continue;
+			for_each_cpu_and(i, sched_group_cpus(sg),
+							tsk_cpus_allowed(p))
+				if (idle_cpu(i))
+					return i;
+		} while (sg = sg->next, sg != sd->groups);
+
+		/* only wake up task on the same cpu socket as prev cpu */
+		if (sd == llcsd)
+			break;
 	}
-done:
-	return target;
+	return cpu;
 }
 
 /*
@@ -3351,10 +3355,7 @@ select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flags)
 	}
 
 	if (affine_sd) {
-		if (cpu != prev_cpu && wake_affine(affine_sd, p, sync))
-			prev_cpu = cpu;
-
-		new_cpu = select_idle_sibling(p, prev_cpu);
+		new_cpu = select_idle_sibling(p, affine_sd, sync);
 		goto unlock;
 	}
 
