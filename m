Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932488AbaKMKaR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 05:30:17 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:55470 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932336AbaKMKaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 05:30:14 -0500
Message-ID: <5464882D.40504@gmail.com>
Date: Thu, 13 Nov 2014 18:30:05 +0800
From: Wanpeng Li <kernellwp@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.10; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Juri Lelli <juri.lelli@arm.com>, Wanpeng Li <wanpeng.li@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
CC: Kirill Tkhai <ktkhai@parallels.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] sched/deadline: fix start high-res preemption tick
 for a non-running task
References: <1415670747-58726-1-git-send-email-wanpeng.li@linux.intel.com> <1415670747-58726-2-git-send-email-wanpeng.li@linux.intel.com> <54647BDC.6050804@arm.com>
In-Reply-To: <54647BDC.6050804@arm.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Juri,
On 11/13/14, 5:37 PM, Juri Lelli wrote:
> Hi,
>
> not sure I understand what the problem is here.
>
> On 11/11/14 01:52, Wanpeng Li wrote:
>> Queued ticks are scheduled to match the budget, which means the budget
>> is overall consumed and the dl task should be throttled.
> ... enforce the budget? It means that when the budget is consumed the
> task has to be throttled...

Agreed.

>
>> Dl task will
>> be replenished immediately if fail to start a dl timer.
>>
>> However, the curr maybe not the left most dl task in the rb tree any
>> more after this immediately replenished and reschedule is needed.
>> Start high-res preemption tick for this upcoming rescheduled dl task
>> is not correct.
>>
> So, the task that is going to preempt curr is picked by
> pick_next_task_dl(), that correctly starts the hrtick for this new task.
>
> Maybe you can add more information about what you are seeing? A callpath
> maybe?

The parameter of task_tick_dl() queued == 1 means that hrtick is fired. 
hrtick() => task_tick_dl( , ,1), so p->dl.runtime should be <= 0 if 
queued == 1. What I see is queued == 1 && p->dl.runtime > 0 && p is not 
the left most task and hrtick is start for this task.

Regards,
Wanpeng Li

>
> Thanks,
>
> - Juri
>
>> This patch fix it by not starting high-res preemption tick for a
>> non-running dl task.
>>
>> Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
>> ---
>>   kernel/sched/deadline.c | 3 ++-
>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
>> index 56674f6..2a6a5bb 100644
>> --- a/kernel/sched/deadline.c
>> +++ b/kernel/sched/deadline.c
>> @@ -1090,7 +1090,8 @@ static void task_tick_dl(struct rq *rq, struct task_struct *p, int queued)
>>   {
>>   	update_curr_dl(rq);
>>   
>> -	if (hrtick_enabled(rq) && queued && p->dl.runtime > 0)
>> +	if (hrtick_enabled(rq) && queued && p->dl.runtime > 0 &&
>> +	    is_leftmost(p, &rq->dl))
>>   		start_hrtick_dl(rq, p);
>>   }
>>   
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

