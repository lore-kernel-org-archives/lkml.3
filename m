Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754589Ab3AaGjh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 01:39:37 -0500
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:32953 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054Ab3AaGjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 01:39:35 -0500
Message-ID: <510A1198.2070803@linux.vnet.ibm.com>
Date: Thu, 31 Jan 2013 14:39:20 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
CC: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        tglx@linutronix.de
Subject: Re: [RFC 2/2] sched/fair: prefer a CPU in the "lowest" idle state
References: <1359580757-4121-1-git-send-email-bigeasy@linutronix.de> <1359580757-4121-3-git-send-email-bigeasy@linutronix.de> <5109D313.1020409@linux.vnet.ibm.com> <8738xiue31.fsf@sejong.aot.lge.com>
In-Reply-To: <8738xiue31.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13013106-5564-0000-0000-0000066E2E20
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/31/2013 01:16 PM, Namhyung Kim wrote:
> Hi Sebastian and Michael,
> 
> On Thu, 31 Jan 2013 10:12:35 +0800, Michael Wang wrote:
>> On 01/31/2013 05:19 AM, Sebastian Andrzej Siewior wrote:
>>> If a new CPU has to be choosen for a task, then the scheduler first selects
>>> the group with the least load. This group is returned if its load is lower
>>> compared to the group to which the task is currently assigned.
>>> If there are several groups with completely idle CPU(s) (the CPU is in
>>> an idle state like C1) then the first group is returned.
>>> This patch extends this decision by considering the idle state of CPU(s)
>>> in the group and the first group with a CPU in the lowest idle state
>>> wins (C1 is prefered over C2). If there is a CPU which is not in an idle
>>> state (C0) but has no tasks assigned then it is consider as a valid target.
>>> Should there be no CPU in an idle state at disposal then the loadavg is
>>> used as a fallback.
> [snip]
>>> @@ -3181,8 +3182,10 @@ find_idlest_group(struct sched_domain *sd, struct task_struct *p,
>>>  		  int this_cpu, int load_idx)
>>>  {
>>>  	struct sched_group *idlest = NULL, *group = sd->groups;
>>> +	struct sched_group *idle_group = NULL;
>>>  	unsigned long min_load = ULONG_MAX, this_load = 0;
>>>  	int imbalance = 100 + (sd->imbalance_pct-100)/2;
>>> +	int least_idle_cpu = INT_MAX;
>>>
>>>  	do {
>>>  		unsigned long load, avg_load;
>>> @@ -3208,6 +3211,25 @@ find_idlest_group(struct sched_domain *sd, struct task_struct *p,
>>>  				load = target_load(i, load_idx);
>>>
>>>  			avg_load += load;
>>> +			if (!local_group && sd->prefer_lp && least_idle_cpu) {
>>> +				int idle_level;
>>> +
>>> +				idle_level = cpuidle_get_state(i);
>>> +				/*
>>> +				 * Select the CPU which is in the lowest
>>> +				 * possible power state. Take the active
>>> +				 * CPU only if its run queue is empty.
>>> +				 */
>>> +				if (!idle_level) {
>>> +					if (idle_cpu(i)) {
>>> +						least_idle_cpu = idle_level;
>>> +						idle_group = group;
>>> +					}
>>> +				} else if (least_idle_cpu > idle_level) {
>>> +					least_idle_cpu = idle_level;
>>> +					idle_group = group;
>>> +				}
>>> +			}
>>>  		}
>>>
>>>  		/* Adjust by relative CPU power of the group */
>>> @@ -3221,6 +3243,8 @@ find_idlest_group(struct sched_domain *sd, struct task_struct *p,
>>>  		}
>>>  	} while (group = group->next, group != sd->groups);
>>>
>>> +	if (idle_group)
>>> +		return idle_group;
>>
>> I'm not sure, but just concern about this case:
>>
>> 	group 0		cpu 0			cpu 1
>> 			least idle		4 task
>>
>> 	group 1		cpu 2			cpu 3
>> 			1 task			1 task
>>
>> The previous logical will pick group 1 and now it will take group 0, and
>> that cause more imbalance, doesn't it?
>>
>> May be check that state in find_idlest_cpu() will be better?
> 
> Right, at least find_idlest_cpu() should also check the idle_level IMHO.
> 
> Anyway, I have an idea with this in mind.  It's like adding a new "idle
> load" to each idle cpu rather than special casing the idle cpus like
> above.  IOW an idle cpu will get very small load weight depends on how
> deep it's slept so that it can be compared to other cpus in a same way
> but we can find prefered (lowest load) cpu among the idle cpus.
> 
> The simple way I can think of is adding idle_level to a rq load in
> weighted_cpuload():
> 
> static unsigned long weighted_cpuload(const int cpu)
> {
> 	return cpu_rq(cpu)->load.weight + cpuidle_get_state(cpu);
> }

Hmm... then we don't need changes in find_idlest_cpu(), just compare the
load as before, but it works only when the appendix state value is
smaller than the lowest load of one task, which is 15 currently, I'm not
sure whether we have the promise...

Regards,
Michael Wang

> 
> What do you think?
> 
> Thanks,
> Namhyung
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

