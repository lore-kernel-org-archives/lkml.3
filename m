Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755492AbaDQNxO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 09:53:14 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:41717 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755330AbaDQNxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 09:53:09 -0400
Message-ID: <534FDCDC.6000806@linaro.org>
Date: Thu, 17 Apr 2014 15:53:32 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Nicolas Pitre <nicolas.pitre@linaro.org>
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, peterz@infradead.org,
        rjw@rjwysocki.net, linux-pm@vger.kernel.org, alex.shi@linaro.org,
        vincent.guittot@linaro.org, morten.rasmussen@arm.com
Subject: Re: [RFC PATCHC 3/3] sched/fair: use the idle state info to choose
 the idlest cpu
References: <1396009796-31598-1-git-send-email-daniel.lezcano@linaro.org> <1396009796-31598-4-git-send-email-daniel.lezcano@linaro.org> <alpine.LFD.2.11.1404012208110.1571@knanqh.ubzr>
In-Reply-To: <alpine.LFD.2.11.1404012208110.1571@knanqh.ubzr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/2014 05:05 AM, Nicolas Pitre wrote:
> On Fri, 28 Mar 2014, Daniel Lezcano wrote:
>
>> As we know in which idle state the cpu is, we can investigate the following:
>>
>> 1. when did the cpu entered the idle state ? the longer the cpu is idle, the
>> deeper it is idle
>> 2. what exit latency is ? the greater the exit latency is, the deeper it is
>>
>> With both information, when all cpus are idle, we can choose the idlest cpu.
>>
>> When one cpu is not idle, the old check against weighted load applies.
>>
>> Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
>
> There seems to be some problems with the implementation.
>
>> @@ -4336,20 +4337,53 @@ static int
>>   find_idlest_cpu(struct sched_group *group, struct task_struct *p, int this_cpu)
>>   {
>>   	unsigned long load, min_load = ULONG_MAX;
>> -	int idlest = -1;
>> +	unsigned int min_exit_latency = UINT_MAX;
>> +	u64 idle_stamp, min_idle_stamp = ULONG_MAX;
>
> I don't think you really meant to assign an u64 variable with ULONG_MAX.
> You probably want ULLONG_MAX here.  And probably not in fact (more
> later).
>
>> +
>> +	struct rq *rq;
>> +	struct cpuidle_power *power;
>> +
>> +	int cpu_idle = -1;
>> +	int cpu_busy = -1;
>>   	int i;
>>
>>   	/* Traverse only the allowed CPUs */
>>   	for_each_cpu_and(i, sched_group_cpus(group), tsk_cpus_allowed(p)) {
>> -		load = weighted_cpuload(i);
>>
>> -		if (load < min_load || (load == min_load && i == this_cpu)) {
>> -			min_load = load;
>> -			idlest = i;
>> +		if (idle_cpu(i)) {
>> +
>> +			rq = cpu_rq(i);
>> +			power = rq->power;
>> +			idle_stamp = rq->idle_stamp;
>> +
>> +			/* The cpu is idle since a shorter time */
>> +			if (idle_stamp < min_idle_stamp) {
>> +				min_idle_stamp = idle_stamp;
>> +				cpu_idle = i;
>> +				continue;
>
> Don't you want the highest time stamp in order to select the most
> recently idled CPU?  Favoring the CPU which has been idle the longest
> makes little sense.
>
>> +			}
>> +
>> +			/* The cpu is idle but the exit_latency is shorter */
>> +			if (power && power->exit_latency < min_exit_latency) {
>> +				min_exit_latency = power->exit_latency;
>> +				cpu_idle = i;
>> +				continue;
>> +			}
>
> I think this is wrong.  This gives priority to CPUs which have been idle
> for a (longer... although this should have been) shorter period of time
> over those with a shallower idle state.  I think this should rather be:
>
> 	if (power && power->exit_latency < min_exit_latency) {
> 		min_exit_latency = power->exit_latency;
> 		latest_idle_stamp = idle_stamp;
> 	       	cpu_idle = i;
> 	} else if ((!power || power->exit_latency == min_exit_latency) &&
> 		   idle_stamp > latest_idle_stamp) {
> 		latest_idle_stamp = idle_stamp;
> 		cpu_idle = i;
> 	}
>
> So the CPU with the shallowest idle state is selected in priority, and
> if many CPUs are in the same state then the time stamp is used to
> select the most recent one. Whenever
> a shallower idle state is found then the latest_idle_stamp is reset for
> that state even if it is further in the past.
>
>> +		} else {
>> +
>> +			load = weighted_cpuload(i);
>> +
>> +			if (load < min_load ||
>> +			    (load == min_load && i == this_cpu)) {
>> +				min_load = load;
>> +				cpu_busy = i;
>> +				continue;
>> +			}
>>   		}
>
> I think this is wrong to do an if-else based on idle_cpu() here.  What
> if a CPU is heavily loaded, but for some reason it happens to be idle at
> this very moment?  With your patch it could be selected as an idle CPU
> while it would be discarded as being too busy otherwise.
>
> It is important to determine both cpu_busy and cpu_idle for all CPUs.
>
> And cpu_busy is a bad name for this.  Something like least_loaded would
> be more self explanatory.  Same thing for cpu_idle which could be
> clearer if named shalloest_idle.
>
>> -	return idlest;
>> +	/* Busy cpus are considered less idle than idle cpus ;) */
>> +	return cpu_busy != -1 ? cpu_busy : cpu_idle;
>
> And finally it is a policy decision whether or not we want to return
> least_loaded over shallowest_idle e.g do we pack tasks on non idle CPUs
> first or not.  That in itself needs more investigation.  To keep the
> existing policy unchanged for now the above condition should have its
> variables swapped.


Ok, refreshed the patchset but before sending it out I would to discuss 
about the rational of the changes and the policy, and change the 
patchset consequently.

What order to choose if the cpu is idle ?

Let's assume all cpus are idle on a dual socket quad core.

Also, we can reasonably do the hypothesis if the cluster is in low power 
mode, the cpus belonging to the same cluster are in the same idle state 
(putting apart the auto-promote where we don't have control on).

If the policy you talk above is 'aggressive power saving', we can follow 
the rules with decreasing priority:

1. We want to prevent to wakeup the entire cluster
	=> as the cpus are in the same idle state, by choosing a cpu in shallow 
state, we should have the guarantee we won't wakeup a cluster (except if 
no shallowest idle cpu are found).

2. We want to prevent to wakeup a cpu which did not reach the target 
residency time (will need some work to unify cpuidle idle time and idle 
task run time)
	=> with the target residency and, as a first step, with the idle stamp, 
we can determine if the cpu slept enough

3. We want to prevent to wakeup a cpu in deep idle state
	=> by looking for the cpu in shallowest idle state

4. We want to prevent to wakeup a cpu where the exit latency is longer 
than the expected run time of the task (and the time to migrate the task ?)

Concerning the policy, I would suggest to create an entry in
/proc/sys/kernel/sched_power, where a couple of values could be 
performance - power saving (0 / 1).

Does it make sense ? Any ideas ?

Thanks
   -- Daniel




-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

