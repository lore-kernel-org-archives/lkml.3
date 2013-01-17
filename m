Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759514Ab3AQKRl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 05:17:41 -0500
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:58237 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759482Ab3AQKRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 05:17:38 -0500
Message-ID: <50F7CF86.8050101@linux.vnet.ibm.com>
Date: Thu, 17 Jan 2013 15:46:38 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
CC: Alex Shi <alex.shi@intel.com>, Mike Galbraith <bitbucket@online.de>,
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13011710-9574-0000-0000-000006380F45
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Namhyung,

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

The previous approach also descended till the SMT domain.Here we start
from the SMT domain.

You could check with /proc/schedstat as to which are the different
domains the cpu is a part of and SMT domain happens to be domain0.As far
as i know for_each_lower_domain will descend till domain0.
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

We could have done this for the current logic because it checks for an
*idle* group.The local group would definitely fail this test.But here we
need to check the local group also because we are looking for an idle cpu.


Regards
Preeti U Murthy

