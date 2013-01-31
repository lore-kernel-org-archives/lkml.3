Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753309Ab3AaFQh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 00:16:37 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:51221 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069Ab3AaFQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 00:16:36 -0500
X-AuditID: 9c930197-b7ca4ae000006ba8-f9-5109fe32ce8b
From: Namhyung Kim <namhyung@kernel.org>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        tglx@linutronix.de
Subject: Re: [RFC 2/2] sched/fair: prefer a CPU in the "lowest" idle state
References: <1359580757-4121-1-git-send-email-bigeasy@linutronix.de>
	<1359580757-4121-3-git-send-email-bigeasy@linutronix.de>
	<5109D313.1020409@linux.vnet.ibm.com>
Date: Thu, 31 Jan 2013 14:16:34 +0900
In-Reply-To: <5109D313.1020409@linux.vnet.ibm.com> (Michael Wang's message of
	"Thu, 31 Jan 2013 10:12:35 +0800")
Message-ID: <8738xiue31.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sebastian and Michael,

On Thu, 31 Jan 2013 10:12:35 +0800, Michael Wang wrote:
> On 01/31/2013 05:19 AM, Sebastian Andrzej Siewior wrote:
>> If a new CPU has to be choosen for a task, then the scheduler first selects
>> the group with the least load. This group is returned if its load is lower
>> compared to the group to which the task is currently assigned.
>> If there are several groups with completely idle CPU(s) (the CPU is in
>> an idle state like C1) then the first group is returned.
>> This patch extends this decision by considering the idle state of CPU(s)
>> in the group and the first group with a CPU in the lowest idle state
>> wins (C1 is prefered over C2). If there is a CPU which is not in an idle
>> state (C0) but has no tasks assigned then it is consider as a valid target.
>> Should there be no CPU in an idle state at disposal then the loadavg is
>> used as a fallback.
[snip]
>> @@ -3181,8 +3182,10 @@ find_idlest_group(struct sched_domain *sd, struct task_struct *p,
>>  		  int this_cpu, int load_idx)
>>  {
>>  	struct sched_group *idlest = NULL, *group = sd->groups;
>> +	struct sched_group *idle_group = NULL;
>>  	unsigned long min_load = ULONG_MAX, this_load = 0;
>>  	int imbalance = 100 + (sd->imbalance_pct-100)/2;
>> +	int least_idle_cpu = INT_MAX;
>> 
>>  	do {
>>  		unsigned long load, avg_load;
>> @@ -3208,6 +3211,25 @@ find_idlest_group(struct sched_domain *sd, struct task_struct *p,
>>  				load = target_load(i, load_idx);
>> 
>>  			avg_load += load;
>> +			if (!local_group && sd->prefer_lp && least_idle_cpu) {
>> +				int idle_level;
>> +
>> +				idle_level = cpuidle_get_state(i);
>> +				/*
>> +				 * Select the CPU which is in the lowest
>> +				 * possible power state. Take the active
>> +				 * CPU only if its run queue is empty.
>> +				 */
>> +				if (!idle_level) {
>> +					if (idle_cpu(i)) {
>> +						least_idle_cpu = idle_level;
>> +						idle_group = group;
>> +					}
>> +				} else if (least_idle_cpu > idle_level) {
>> +					least_idle_cpu = idle_level;
>> +					idle_group = group;
>> +				}
>> +			}
>>  		}
>> 
>>  		/* Adjust by relative CPU power of the group */
>> @@ -3221,6 +3243,8 @@ find_idlest_group(struct sched_domain *sd, struct task_struct *p,
>>  		}
>>  	} while (group = group->next, group != sd->groups);
>> 
>> +	if (idle_group)
>> +		return idle_group;
>
> I'm not sure, but just concern about this case:
>
> 	group 0		cpu 0			cpu 1
> 			least idle		4 task
>
> 	group 1		cpu 2			cpu 3
> 			1 task			1 task
>
> The previous logical will pick group 1 and now it will take group 0, and
> that cause more imbalance, doesn't it?
>
> May be check that state in find_idlest_cpu() will be better?

Right, at least find_idlest_cpu() should also check the idle_level IMHO.

Anyway, I have an idea with this in mind.  It's like adding a new "idle
load" to each idle cpu rather than special casing the idle cpus like
above.  IOW an idle cpu will get very small load weight depends on how
deep it's slept so that it can be compared to other cpus in a same way
but we can find prefered (lowest load) cpu among the idle cpus.

The simple way I can think of is adding idle_level to a rq load in
weighted_cpuload():

static unsigned long weighted_cpuload(const int cpu)
{
	return cpu_rq(cpu)->load.weight + cpuidle_get_state(cpu);
}

What do you think?

Thanks,
Namhyung
