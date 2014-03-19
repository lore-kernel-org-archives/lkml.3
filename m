Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758793AbaCSK5Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 06:57:24 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:60482 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758484AbaCSK5X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 06:57:23 -0400
Message-ID: <53297729.3040708@linux.vnet.ibm.com>
Date: Wed, 19 Mar 2014 16:23:29 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Kirill Tkhai <tkhai@yandex.ru>
CC: Preeti Murthy <preeti.lkml@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 1/4] sched/rt: Sum number of all children tasks in hierarhy
 at rt_nr_running
References: <1394835289.18748.31.camel@HP-250-G1-Notebook-PC> <CAM4v1pOtUDNn_yFG3HyYbBy0VDy4qCh-Ms3jMO_+hfOVQLhw-A@mail.gmail.com> <2983961395143041@web25j.yandex.ru>
In-Reply-To: <2983961395143041@web25j.yandex.ru>
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14031910-0320-0000-0000-000002B95BD9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/18/2014 05:14 PM, Kirill Tkhai wrote:
> 
> 
> 18.03.2014, 15:08, "Preeti Murthy" <preeti.lkml@gmail.com>:
>> On Sat, Mar 15, 2014 at 3:44 AM, Kirill Tkhai <tkhai@yandex.ru> wrote:
>>
>>>  {inc,dec}_rt_tasks used to count entities which are directly queued
>>>  on rt_rq. If an entity was not a task (i.e., it is some queue), its
>>>  children were not counted.
>>
>> Its always the case that a task is queued right, never a sched entity?
> 
> With patch applied, when sched entity is group queue, we add number of
> its child tasks instead of "1".
> 
>> When a task is queued, the nr_running of every rt_rq in the hierarchy
>> of sched entities which are parents of this task is incremented by 1.
> 
> Only if they had not had a queued task before.
> 
>> Similar is with dequeue of a sched_entity. If the sched_entity has
>> just 1 task on it, then its dequeued from its parent queue and its number
>> decremented for every rq in the hierarchy. But you would
>> never dequeue a sched_entity if it has more than 1 task in it. The
>> granularity of enqueue and dequeue of sched_entities is one task
>> at a time. You can extend this to enqueue and dequeue of a sched_entity
>> only if it has just one task in its queue.
> 
> We do not queue entites, which are empty. In __enqueue_rt_entity():
> 
> if (group_rq && (rt_rq_throttled(group_rq) || !group_rq->rt_nr_running))
>          return;
> 
> Where do you see a collision? Please explain, if so.

Ok I went through the patchset more closely and I understand it better
now. So this patchset targets the throttled rt runqueues specifically. I
am sorry I missed this focal point. So this patch looks good to me.

Reviewed-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
> 
>> Regards
>> Preeti U Murthy
>>
>>>  There is no problem here, but now we want to count number of all tasks
>>>  which are actually queued under the rt_rq in all the hierarhy (except
>>>  throttled rt queues).
>>>
>>>  Empty queues are not able to be queued and all of the places, which
>>>  use rt_nr_running, just compare it with zero, so we do not break
>>>  anything here.
>>>
>>>  Signed-off-by: Kirill Tkhai <tkhai@yandex.ru>
>>>  CC: Peter Zijlstra <peterz@infradead.org>
>>>  CC: Ingo Molnar <mingo@kernel.org>
>>>  ---
>>>   kernel/sched/rt.c |   15 +++++++++++++--
>>>   1 file changed, 13 insertions(+), 2 deletions(-)
>>>
>>>  diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
>>>  index d8cdf16..e4def13 100644
>>>  --- a/kernel/sched/rt.c
>>>  +++ b/kernel/sched/rt.c
>>>  @@ -1045,12 +1045,23 @@ void dec_rt_group(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq) {}
>>>   #endif /* CONFIG_RT_GROUP_SCHED */
>>>
>>>   static inline
>>>  +unsigned int rt_se_nr_running(struct sched_rt_entity *rt_se)
>>>  +{
>>>  +       struct rt_rq *group_rq = group_rt_rq(rt_se);
>>>  +
>>>  +       if (group_rq)
>>>  +               return group_rq->rt_nr_running;
>>>  +       else
>>>  +               return 1;
>>>  +}
>>>  +
>>>  +static inline
>>>   void inc_rt_tasks(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
>>>   {
>>>          int prio = rt_se_prio(rt_se);
>>>
>>>          WARN_ON(!rt_prio(prio));
>>>  -       rt_rq->rt_nr_running++;
>>>  +       rt_rq->rt_nr_running += rt_se_nr_running(rt_se);
>>>
>>>          inc_rt_prio(rt_rq, prio);
>>>          inc_rt_migration(rt_se, rt_rq);
>>>  @@ -1062,7 +1073,7 @@ void dec_rt_tasks(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
>>>   {
>>>          WARN_ON(!rt_prio(rt_se_prio(rt_se)));
>>>          WARN_ON(!rt_rq->rt_nr_running);
>>>  -       rt_rq->rt_nr_running--;
>>>  +       rt_rq->rt_nr_running -= rt_se_nr_running(rt_se);
>>>
>>>          dec_rt_prio(rt_rq, rt_se_prio(rt_se));
>>>          dec_rt_migration(rt_se, rt_rq);
>>>
>>>  --
>>>  To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>>>  the body of a message to majordomo@vger.kernel.org
>>>  More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>  Please read the FAQ at  http://www.tux.org/lkml/
> 

