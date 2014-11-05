Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754070AbaKEKgJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 05:36:09 -0500
Received: from mail-pd0-f180.google.com ([209.85.192.180]:45268 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447AbaKEKgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 05:36:05 -0500
Message-ID: <5459FD8E.8070903@gmail.com>
Date: Wed, 05 Nov 2014 18:35:58 +0800
From: Wanpeng Li <kernellwp@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.10; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Juri Lelli <juri.lelli@arm.com>, Wanpeng Li <wanpeng.li@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
CC: Kirill Tkhai <ktkhai@parallels.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH v2] sched/deadline: support dl task migration during
 cpu hotplug
References: <1415177517-7189-1-git-send-email-wanpeng.li@linux.intel.com> <5459F70C.3060204@arm.com>
In-Reply-To: <5459F70C.3060204@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Juri,
On 14/11/5 下午6:08, Juri Lelli wrote:
> Hi,
>
> On 05/11/14 08:51, Wanpeng Li wrote:
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
>> Note: dl task can be migrated successfully if rq is offline currently, however,
>> I'm still not sure why task_rq(task)->rd->span just include the cpu which the dl
>> task previous running on, so cpu_active_mask is used in the patch.
>>
>> Peterz, Juri?
>>
>> Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
>> ---
>> v1 -> v2:
>>   * push the task to another cpu in dl_task_timer() if rq is offline.
>>
>>   kernel/sched/deadline.c | 39 ++++++++++++++++++++++++++++++++++++---
>>   1 file changed, 36 insertions(+), 3 deletions(-)
>>
>> diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
>> index 04c2cbb..233e482 100644
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
>> @@ -538,6 +539,39 @@ again:
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
>> +		/* We will release rq lock */
>> +		get_task_struct(p);
>> +
>> +		raw_spin_unlock(&rq->lock);
>> +
>> +		later_rq = find_lock_later_rq(p, rq);
>> +
>> +		if (!later_rq) {
>> +			put_task_struct(p);
>> +			goto out;
>> +		}
>> +
>> +		deactivate_task(rq, p, 0);
>> +		set_task_cpu(p, later_rq->cpu);
>> +		activate_task(later_rq, p, 0);
>> +
>> +		resched_curr(later_rq);
>> +
>> +		double_unlock_balance(rq, later_rq);
>> +
>> +		put_task_struct(p);
>> +
>> +		goto out;
>> +	}
>> +
>>   	if (task_on_rq_queued(p)) {
>>   		enqueue_task_dl(rq, p, ENQUEUE_REPLENISH);
>>   		if (dl_task(rq->curr))
>> @@ -555,7 +589,7 @@ again:
>>   	}
>>   unlock:
>>   	raw_spin_unlock(&rq->lock);
>> -
>> +out:
>>   	return HRTIMER_NORESTART;
>>   }
>>   
>> @@ -1182,8 +1216,7 @@ static int find_later_rq(struct task_struct *task)
>>   	 * We have to consider system topology and task affinity
>>   	 * first, then we can look for a suitable cpu.
>>   	 */
>> -	cpumask_copy(later_mask, task_rq(task)->rd->span);
>> -	cpumask_and(later_mask, later_mask, cpu_active_mask);
>> +	cpumask_copy(later_mask, cpu_active_mask);
> I fear this breaks what I lately fixed in commit 91ec6778ec4f
> ("sched/deadline: Fix inter- exclusive cpusets migrations"), as

As I mentioned in the patch description:

Note: dl task can be migrated successfully if rq is offline currently, 
however, I'm still not sure why
task_rq(task)->rd->span just include the cpu which the dl task previous 
running on, so cpu_active_mask is used in the patch.

Any explantion after your test is a great approciated. ;-)

> we first have to consider exclusive cpusets topology in looking
> for a cpu. But, I'd have to test this to see if I'm right, and
> I'll try to do it soon.

Thanks for your help. ;-)

Regards,
Wanpeng Li

>
> Thanks,
>
> - Juri
>
>>   	cpumask_and(later_mask, later_mask, &task->cpus_allowed);
>>   	best_cpu = cpudl_find(&task_rq(task)->rd->cpudl,
>>   			task, later_mask);
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

