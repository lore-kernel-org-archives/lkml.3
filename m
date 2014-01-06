Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753655AbaAFNfx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 08:35:53 -0500
Received: from mail-pd0-f173.google.com ([209.85.192.173]:44215 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320AbaAFNfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 08:35:51 -0500
Message-ID: <52CAB12B.4090701@linaro.org>
Date: Mon, 06 Jan 2014 21:35:39 +0800
From: Alex Shi <alex.shi@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Morten Rasmussen <morten.rasmussen@arm.com>
CC: Peter Zijlstra <peterz@infradead.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "fenghua.yu@intel.com" <fenghua.yu@intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "arjan@linux.intel.com" <arjan@linux.intel.com>,
        "pjt@google.com" <pjt@google.com>,
        "fengguang.wu@intel.com" <fengguang.wu@intel.com>,
        "james.hogan@imgtec.com" <james.hogan@imgtec.com>,
        "jason.low2@hp.com" <jason.low2@hp.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "hanjun.guo@linaro.org" <hanjun.guo@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] sched: bias to target cpu load to reduce task moving
References: <1386061556-28233-1-git-send-email-alex.shi@linaro.org> <1386061556-28233-5-git-send-email-alex.shi@linaro.org> <20131217141012.GG10134@e103034-lin> <20131217153809.GP21999@twins.programming.kicks-ass.net> <52B2F5D0.2050707@linaro.org> <20131220111926.GA11605@e103034-lin> <52BAF292.1070404@linaro.org> <20140102160404.GA3000@e103034-lin>
In-Reply-To: <20140102160404.GA3000@e103034-lin>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/03/2014 12:04 AM, Morten Rasmussen wrote:
> On Wed, Dec 25, 2013 at 02:58:26PM +0000, Alex Shi wrote:
>>
>>>> From 5cd67d975001edafe2ee820e0be5d86881a23bd6 Mon Sep 17 00:00:00 2001
>>>> From: Alex Shi <alex.shi@linaro.org>
>>>> Date: Sat, 23 Nov 2013 23:18:09 +0800
>>>> Subject: [PATCH 4/4] sched: bias to target cpu load to reduce task moving
>>>>
>>>> Task migration happens when target just a bit less then source cpu load.
>>>> To reduce such situation happens, aggravate the target cpu load with
>>>> sd->imbalance_pct/100 in wake_affine.
>>>>
>>>> In find_idlest/busiest_group, change the aggravate to local cpu only
>>>> from old group aggravation.
>>>>
>>>> on my pandaboard ES.
>>>>
>>>> 	latest kernel 527d1511310a89		+ whole patchset
>>>> hackbench -T -g 10 -f 40
>>>> 	23.25"					21.99"
>>>> 	23.16"					21.20"
>>>> 	24.24"					21.89"
>>>> hackbench -p -g 10 -f 40
>>>> 	26.52"					21.46"
>>>> 	23.89"					22.96"
>>>> 	25.65"					22.73"
>>>> hackbench -P -g 10 -f 40
>>>> 	20.14"					19.72"
>>>> 	19.96"					19.10"
>>>> 	21.76"					20.03"
>>>>
>>>> Signed-off-by: Alex Shi <alex.shi@linaro.org>
>>>> ---
>>>>  kernel/sched/fair.c | 35 ++++++++++++++++-------------------
>>>>  1 file changed, 16 insertions(+), 19 deletions(-)
>>>>
>>>> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
>>>> index bccdd89..3623ba4 100644
>>>> --- a/kernel/sched/fair.c
>>>> +++ b/kernel/sched/fair.c
>>>> @@ -978,7 +978,7 @@ static inline unsigned long group_weight(struct task_struct *p, int nid)
>>>>  
>>>>  static unsigned long weighted_cpuload(const int cpu);
>>>>  static unsigned long source_load(int cpu);
>>>> -static unsigned long target_load(int cpu);
>>>> +static unsigned long target_load(int cpu, int imbalance_pct);
>>>>  static unsigned long power_of(int cpu);
>>>>  static long effective_load(struct task_group *tg, int cpu, long wl, long wg);
>>>>  
>>>> @@ -3809,11 +3809,17 @@ static unsigned long source_load(int cpu)
>>>>   * Return a high guess at the load of a migration-target cpu weighted
>>>>   * according to the scheduling class and "nice" value.
>>>>   */
>>>> -static unsigned long target_load(int cpu)
>>>> +static unsigned long target_load(int cpu, int imbalance_pct)
>>>>  {
>>>>  	struct rq *rq = cpu_rq(cpu);
>>>>  	unsigned long total = weighted_cpuload(cpu);
>>>>  
>>>> +	/*
>>>> +	 * without cpu_load decay, in most of time cpu_load is same as total
>>>> +	 * so we need to make target a bit heavier to reduce task migration
>>>> +	 */
>>>> +	total = total * imbalance_pct / 100;
>>>> +
>>>>  	if (!sched_feat(LB_BIAS))
>>>>  		return total;
>>>>  
>>>> @@ -4033,7 +4039,7 @@ static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
>>>>  	this_cpu  = smp_processor_id();
>>>>  	prev_cpu  = task_cpu(p);
>>>>  	load	  = source_load(prev_cpu);
>>>> -	this_load = target_load(this_cpu);
>>>> +	this_load = target_load(this_cpu, 100);
>>>>  
>>>>  	/*
>>>>  	 * If sync wakeup then subtract the (maximum possible)
>>>> @@ -4089,7 +4095,7 @@ static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
>>>>  
>>>>  	if (balanced ||
>>>>  	    (this_load <= load &&
>>>> -	     this_load + target_load(prev_cpu) <= tl_per_task)) {
>>>> +	     this_load + target_load(prev_cpu, 100) <= tl_per_task)) {
>>>>  		/*
>>>>  		 * This domain has SD_WAKE_AFFINE and
>>>>  		 * p is cache cold in this domain, and
>>>> @@ -4112,7 +4118,6 @@ find_idlest_group(struct sched_domain *sd, struct task_struct *p, int this_cpu)
>>>>  {
>>>>  	struct sched_group *idlest = NULL, *group = sd->groups;
>>>>  	unsigned long min_load = ULONG_MAX, this_load = 0;
>>>> -	int imbalance = 100 + (sd->imbalance_pct-100)/2;
>>>>  
>>>>  	do {
>>>>  		unsigned long load, avg_load;
>>>> @@ -4132,10 +4137,10 @@ find_idlest_group(struct sched_domain *sd, struct task_struct *p, int this_cpu)
>>>>  
>>>>  		for_each_cpu(i, sched_group_cpus(group)) {
>>>>  			/* Bias balancing toward cpus of our domain */
>>>> -			if (local_group)
>>>> +			if (i == this_cpu)
>>>
>>> What is the motivation for changing the local_group load calculation?
>>> Now the load contributions of all cpus in the local group, except
>>> this_cpu, will contribute more as their contribution (this_load) is
>>> determined using target_load() instead.
>>
>> This part code 147cbb4bbe99, written in 2005 for x86, at that time, only
>> 2 cores(guess no HT at that time) in cpu socket. With the cores number
> 
> NUMA support was already present. I guess that means support for systems
> with significantly more than two cpus.

Thanks a lot for comments, Morten!
the find_idlest_group used in select_task_rq_fair, that designed to
select cpu near by old cpu whenever for wake or fork tasks. So in common
case, the selected cpu is rarely on another NUMA.
> 
>> increasing trend, the sched_group become large and large, to give whole
>> group this bias value is becoming non-sense. So it looks reasonable to
>> just bias this cpu only.
> 
> I think that is question whether you want to bias the whole group or
> not at wake-up balancing. If you don't change the bias weight and only
> apply it to this_cpu, you will be more prone to send the waking task
> somewhere else.

We don't need to follow the exactly old logical. Guess people will be
more happier to see the code/logical simple with better benchmark
performance. :)
> 
>>>
>>> If I'm not mistaken, that will lead to more frequent load balancing as
>>> the local_group bias has been reduced. That is the opposite of your
>>> intentions based on your comment in target_load().
>>>
>>>>  				load = source_load(i);
>>>>  			else
>>>> -				load = target_load(i);
>>>> +				load = target_load(i, sd->imbalance_pct);
>>>
>>> You scale by sd->imbalance_pct instead of 100+(sd->imbalance_pct-100)/2
>>> that you removed above. sd->imbalance_pct may have been arbitrarily
>>> chosen in the past, but changing it may affect behavior. 
>>
>> the first commit with this line:
>> int imbalance = 100 + (sd->imbalance_pct-100)/2;
>> is 147cbb4bbe99, that also has no explanation for this imbalance value.
> 
> 100 + (sd->imbalance_pct-100)/2 is used several places in sched.c before
> 147cbb4bbe99. It seems that it was used to encourage balancing in
> certain situations such as wake-up, while sd->imbalance_pct was used
> unmodified in other situations.
> 
> That seems to still be the case in v3.13-rc6. find_busiest_group() and
> task_numa_compare() use sd->imbalance_pct, while task_numa_migrate(),
> wake_affine(), and find_idlest_group() use 100 + (sd->imbalance_pct -
> 100)/2. The pattern seems to be to use the reduced imbalance_pct for
> wake-up and the full imbalance_pct for balancing of runnable tasks.
> 
> AFAICT, using sd->imbalance_pct in find_idlest_group() will increase the
> bias towards the local group. However, I would not be comfortable
> changing it without understanding the full implications.
> 
>> AFAIK, at that time, maybe only 2 LCPU in one socket, so, guess it is
>> reason to use half of imbalance_pct.
> 
> Based on the comment removed in 147cbb4bbe99 it seems that the reason is
> to encourage balancing at wake-up. It doesn't seem to have any relation
> to the number of cpus.
> 
>> but sched_domain is used widely for many kinds of platform/cpu type, the
>> value is arbitrary too.
>> Another reason to use it, I scaled any cpu load which is not this_cpu,
>> so a bit conservation is to use origin imbalance_pct, not half of it.
> 
> The net result is almost the same if the groups have two cpus each.
> Stronger for groups with one cpu, and weaker for groups with more than
> two cpus.
> 
>>>
>>>>  
>>>>  			avg_load += load;
>>>>  		}
>>>> @@ -4151,7 +4156,7 @@ find_idlest_group(struct sched_domain *sd, struct task_struct *p, int this_cpu)
>>>>  		}
>>>>  	} while (group = group->next, group != sd->groups);
>>>>  
>>>> -	if (!idlest || 100*this_load < imbalance*min_load)
>>>> +	if (!idlest || this_load < min_load)
>>>>  		return NULL;
>>>>  	return idlest;
>>>>  }
>>>> @@ -5476,9 +5481,9 @@ static inline void update_sg_lb_stats(struct lb_env *env,
>>>>  
>>>>  		nr_running = rq->nr_running;
>>>>  
>>>> -		/* Bias balancing toward cpus of our domain */
>>>> -		if (local_group)
>>>> -			load = target_load(i);
>>>> +		/* Bias balancing toward dst cpu */
>>>> +		if (env->dst_cpu == i)
>>>> +			load = target_load(i, env->sd->imbalance_pct);
>>>
>>> Here you do the same group load bias change as above.
>>>
> 
> I don't think it is right to change the bias here to only apply to the
> dst_cpu. rebalance_domains()/load_balance() is balancing groups not just
> pulling task to dst_cpu. It must pull enough tasks to balance the
> groups, even if it means temporarily overloading dst_cpu. The bias
> should therefore apply to the whole group.

I have different understanding for load_balance(). It the dst_cpu
overloaded, other cpu need to move back some load. That cause more
expensive task CS.
> 
>>>>  		else
>>>>  			load = source_load(i);
>>>>  
>>>> @@ -5918,14 +5923,6 @@ static struct sched_group *find_busiest_group(struct lb_env *env)
>>>>  		if ((local->idle_cpus < busiest->idle_cpus) &&
>>>>  		    busiest->sum_nr_running <= busiest->group_weight)
>>>>  			goto out_balanced;
>>>> -	} else {
>>>> -		/*
>>>> -		 * In the CPU_NEWLY_IDLE, CPU_NOT_IDLE cases, use
>>>> -		 * imbalance_pct to be conservative.
>>>> -		 */
>>>> -		if (100 * busiest->avg_load <=
>>>> -				env->sd->imbalance_pct * local->avg_load)
>>>> -			goto out_balanced;
>>>>  	}
>>>>  
>>>>  force_balance:
>>>
>>> As said my previous replies to this series, I think this problem should
>>> be solved by fixing the cause of the problem, that is the cpu_load
>>> calculation, instead of biasing the cpu_load where-ever it is used to
>>> hide the problem.
>>>
>>> Doing a bit of git archaeology reveals that the cpu_load code goes back
>>> to 7897986bad8f6cd50d6149345aca7f6480f49464 and that in the original
>>> patch x86 was using *_idx > 0 for all sched_domain levels except SMT. In
>>> my opinion that made logical sense. If we are about to change to *_idx=0
>>> we are removing the main idea behind that code and there needs to be a
>>> new one. Otherwise, cpu_load doesn't make sense.
>>
>> The commit is written in 2005. The CFS scheduler merged into kernel in
>> Oct 2007. it is a too old legacy for us ...
> 
> And that is why I think cpu_load should be reconsidered. It doesn't make
> sense to cripple the cpu_load code without fully understanding what it
> is doing and then try to hide the problems it causes.

I understand your concern, Morten.
But if no one explain well what these code for, it means it run out of
control, and should be out of kernel. On the contrary, the new code has
the better performance both on arm and x86 -- I'd like take fengguang's
testing result as advantages, since the task migration and CS reduced.
So, consider above reasons, I don't know how to refuse a better
performance code, but keep the unclean legacy.
> 
> The cpu_load code might be older than CFS but in my opinion it still
> makes sense. Changing cpu_load to be a snapshot of weighted_cpuload()
> does not.


> 
> Morten
> 


-- 
Thanks
    Alex
