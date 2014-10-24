Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755980AbaJXJcf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 05:32:35 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:62776 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186AbaJXJcd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 05:32:33 -0400
Message-ID: <544A1C96.10009@gmail.com>
Date: Fri, 24 Oct 2014 17:32:06 +0800
From: Wanpeng Li <kernellwp@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.10; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: tkhai@yandex.ru
CC: Kirill Tkhai <ktkhai@parallels.com>, linux-kernel@vger.kernel.org,
        peterz@infradead.org, pjt@google.com, oleg@redhat.com,
        rostedt@goodmis.org, umgwanakikbuti@gmail.com,
        tim.c.chen@linux.intel.com, mingo@kernel.org, nicolas.pitre@linaro.org
Subject: Re: [PATCH v4 1/6] sched/fair: Fix reschedule which is generated
 on throttled cfs_rq
References: <20140806075138.24858.23816.stgit@tkhai>	 <1407312361.8424.35.camel@tkhai> <54498ED2.1070308@gmail.com> <1414130514.21462.2.camel@yandex.ru>
In-Reply-To: <1414130514.21462.2.camel@yandex.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kirill,
10/24/14, 2:01 PM, Kirill Tkhai:
> Hi, Wanpeng,
>
> the commit commentary confuses, I'm agree. Really it's just a cleanup.
>
> On Пт, 2014-10-24 at 07:27 +0800, Wanpeng Li wrote:
>> Hi Kirill,
>> 8/6/14, 4:06 PM, Kirill Tkhai:
>>> (sched_entity::on_rq == 1) does not guarantee the task is pickable;
>>> changes on throttled cfs_rq must not lead to reschedule.
>> Why (sched_entity::on_rq == 1) doesn't guarantee the task is pickable
>> since entity will be dequeued during throttling cfs_rq?
> Because one of task's (grand)parents in hierarhy may be throtthed and
> dequeued.
>
> But task_struct::on_rq check doesn't guarantee this too. So, just ignore
> commit commentary; the commentary is wrong.
>
>>> Check for task_struct::on_rq instead.
>> Do you mean task_struct::on_rq will be cleared during throttling cfs_rq?
>> I can't find codes do this.
> No, it not cleared. The commit commentary should be:
> "sched: Cleanup. Check task_struct::on_rq instead of sched_entity::on_rq,
> because it is the same for a task"

IIUR, for fair class, sched_entity::on_rq will be set/clear during 
enqueue/dequeue, task_struct::on_rq will changed during task migration, 
I'm not sure why they are the same.

Regards,
Wanpeng Li

>
>
>> Regards,
>> Wanpeng Li
>>
>>> Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>
>>> ---
>>>    kernel/sched/fair.c |    6 +++---
>>>    1 file changed, 3 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
>>> index bfa3c86..6f0ce2b 100644
>>> --- a/kernel/sched/fair.c
>>> +++ b/kernel/sched/fair.c
>>> @@ -7465,7 +7465,7 @@ static void task_fork_fair(struct task_struct *p)
>>>    static void
>>>    prio_changed_fair(struct rq *rq, struct task_struct *p, int oldprio)
>>>    {
>>> -	if (!p->se.on_rq)
>>> +	if (!p->on_rq)
>>>    		return;
>>>    
>>>    	/*
>>> @@ -7521,15 +7521,15 @@ static void switched_from_fair(struct rq *rq, struct task_struct *p)
>>>     */
>>>    static void switched_to_fair(struct rq *rq, struct task_struct *p)
>>>    {
>>> -	struct sched_entity *se = &p->se;
>>>    #ifdef CONFIG_FAIR_GROUP_SCHED
>>> +	struct sched_entity *se = &p->se;
>>>    	/*
>>>    	 * Since the real-depth could have been changed (only FAIR
>>>    	 * class maintain depth value), reset depth properly.
>>>    	 */
>>>    	se->depth = se->parent ? se->parent->depth + 1 : 0;
>>>    #endif
>>> -	if (!se->on_rq)
>>> +	if (!p->on_rq)
>>>    		return;
>>>    
>>>    	/*
>>>
>>>
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> Please read the FAQ at  http://www.tux.org/lkml/
>

