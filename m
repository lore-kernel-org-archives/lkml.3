Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752867AbaKKNHS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 08:07:18 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:64342 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980AbaKKNHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 08:07:16 -0500
Message-ID: <546209FD.8060102@gmail.com>
Date: Tue, 11 Nov 2014 21:07:09 +0800
From: Wanpeng Li <kernellwp@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.10; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Kirill Tkhai <ktkhai@parallels.com>,
        Wanpeng Li <wanpeng.li@linux.intel.com>
CC: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@arm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] sched/deadline: support dl task migration during cpu
 hotplug
References: <1415673043-62281-1-git-send-email-wanpeng.li@linux.intel.com> <1415704209.15631.14.camel@tkhai>
In-Reply-To: <1415704209.15631.14.camel@tkhai>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kirill,
On 11/11/14, 7:10 PM, Kirill Tkhai wrote:
> В Вт, 11/11/2014 в 10:30 +0800, Wanpeng Li пишет:
>> I observe that dl task can't be migrated to other cpus during cpu hotplug, in
>> addition, task may/may not be running again if cpu is added back. The root cause
>> which I found is that dl task will be throtted and removed from dl rq after
>> comsuming all budget, which leads to stop task can't pick it up from dl rq and
>> migrate to other cpus during hotplug.
>>
>> The method to reproduce:
>> schedtool -E -t 50000:100000 -e ./test
>> Actually test is just a simple for loop. Then observe which cpu the test
>> task is on.
>> echo 0 > /sys/devices/system/cpu/cpuN/online
>>
>> This patch fix it by push the task to another cpu in dl_task_timer() if
>> rq is offline.
>>
>> Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
> I'm still thinking we don't have to guarantee any "deadlines" during cpu hotplug...
> But, if speaking about this way:
>
>> ---
>> v3 -> v4:
>>   * use tsk_cpus_allowed wrapper
>>   * fix compile error
>> v2 -> v3:
>>   * don't get_task_struct
>>   * if cannot preempt any rq, fallback to pick any online cpus
>>   * use cpu_active_mask as original later_mask if cpu is offline
>> v1 -> v2:
>>   * push the task to another cpu in dl_task_timer() if rq is offline.
>>
>>
>>   kernel/sched/deadline.c | 51 ++++++++++++++++++++++++++++++++++++++++++++++---
>>   1 file changed, 48 insertions(+), 3 deletions(-)
>>
>> diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
>> index 00324af..e0fbba4 100644
>> --- a/kernel/sched/deadline.c
>> +++ b/kernel/sched/deadline.c
>> @@ -487,6 +487,7 @@ static int start_dl_timer(struct sched_dl_entity *dl_se, bool boosted)
>>   	return hrtimer_active(&dl_se->dl_timer);
>>   }
>>   
>> +static struct rq *find_lock_later_rq(struct task_struct *task, struct rq *rq);
>>   /*
>>    * This is the bandwidth enforcement timer callback. If here, we know
>>    * a task is not on its dl_rq, since the fact that the timer was running
>> @@ -538,6 +539,46 @@ again:
>>   	update_rq_clock(rq);
>>   	dl_se->dl_throttled = 0;
>>   	dl_se->dl_yielded = 0;
>> +
>> +	/*
>> +	 * So if we find that the rq the task was on is no longer
>> +	 * available, we need to select a new rq.
>> +	 */
>> +	if (!rq->online) {
>> +		struct rq *later_rq = NULL;
>> +
>> +		raw_spin_unlock(&rq->lock);
>> +
>> +		later_rq = find_lock_later_rq(p, rq);
> find_lock_later_rq() expects that rq is locked.
>
> The comment near its head confuses a reader. It locks newly found rq.

Sorry for my bad, what's you think should be changed?

Regards,
Wanpeng Li

>
>> +
>> +		if (!later_rq) {
>> +			int cpu;
>> +
>> +			/*
>> +			 * If cannot preempt any rq, fallback to pick any
>> +			 * online cpu.
>> +			 */
>> +			for_each_cpu(cpu, tsk_cpus_allowed(p))
>> +				if (cpu_online(cpu))
>> +					later_rq = cpu_rq(cpu);
>> +			if (!later_rq) {
>> +				pr_warn("fail to find any online and task "
>> +				    "will never come back to us\n");
>> +				goto out;
>> +			}
>> +		}
>> +
>> +		deactivate_task(rq, p, 0);
>> +		set_task_cpu(p, later_rq->cpu);
>> +		activate_task(later_rq, p, 0);
>> +
>> +		resched_curr(later_rq);
>> +
>> +		double_unlock_balance(rq, later_rq);
> double_unlock_balance() unlocks later_rq only.
>
>> +
>> +		goto out;
>> +	}
>> +
>>   	if (task_on_rq_queued(p)) {
>>   		enqueue_task_dl(rq, p, ENQUEUE_REPLENISH);
>>   		if (dl_task(rq->curr))
>> @@ -555,7 +596,7 @@ again:
>>   	}
>>   unlock:
>>   	raw_spin_unlock(&rq->lock);
>> -
>> +out:
>>   	return HRTIMER_NORESTART;
>>   }
>>   
>> @@ -1185,8 +1226,12 @@ static int find_later_rq(struct task_struct *task)
>>   	 * We have to consider system topology and task affinity
>>   	 * first, then we can look for a suitable cpu.
>>   	 */
>> -	cpumask_copy(later_mask, task_rq(task)->rd->span);
>> -	cpumask_and(later_mask, later_mask, cpu_active_mask);
>> +	if (likely(task_rq(task)->online)) {
>> +		cpumask_copy(later_mask, task_rq(task)->rd->span);
>> +		cpumask_and(later_mask, later_mask, cpu_active_mask);
>> +	} else
>> +		/* for offline cpus we have a singleton rd */
>> +		cpumask_copy(later_mask, cpu_active_mask);
>>   	cpumask_and(later_mask, later_mask, &task->cpus_allowed);
>>   	best_cpu = cpudl_find(&task_rq(task)->rd->cpudl,
>>   			task, later_mask);
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

