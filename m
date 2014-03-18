Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754188AbaCRLoJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 07:44:09 -0400
Received: from forward14.mail.yandex.net ([95.108.130.92]:37995 "EHLO
	forward14.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754064AbaCRLoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 07:44:08 -0400
From: Kirill Tkhai <tkhai@yandex.ru>
To: Preeti Murthy <preeti.lkml@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>
In-Reply-To: <CAM4v1pOtUDNn_yFG3HyYbBy0VDy4qCh-Ms3jMO_+hfOVQLhw-A@mail.gmail.com>
References: <1394835289.18748.31.camel@HP-250-G1-Notebook-PC> <CAM4v1pOtUDNn_yFG3HyYbBy0VDy4qCh-Ms3jMO_+hfOVQLhw-A@mail.gmail.com>
Subject: Re: [PATCH 1/4] sched/rt: Sum number of all children tasks in hierarhy at rt_nr_running
MIME-Version: 1.0
Message-Id: <2983961395143041@web25j.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Tue, 18 Mar 2014 15:44:01 +0400
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=koi8-r
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



18.03.2014, 15:08, "Preeti Murthy" <preeti.lkml@gmail.com>:
> On Sat, Mar 15, 2014 at 3:44 AM, Kirill Tkhai <tkhai@yandex.ru> wrote:
>
>> š{inc,dec}_rt_tasks used to count entities which are directly queued
>> šon rt_rq. If an entity was not a task (i.e., it is some queue), its
>> šchildren were not counted.
>
> Its always the case that a task is queued right, never a sched entity?

With patch applied, when sched entity is group queue, we add number of
its child tasks instead of "1".

> When a task is queued, the nr_running of every rt_rq in the hierarchy
> of sched entities which are parents of this task is incremented by 1.

Only if they had not had a queued task before.

> Similar is with dequeue of a sched_entity. If the sched_entity has
> just 1 task on it, then its dequeued from its parent queue and its number
> decremented for every rq in the hierarchy. But you would
> never dequeue a sched_entity if it has more than 1 task in it. The
> granularity of enqueue and dequeue of sched_entities is one task
> at a time. You can extend this to enqueue and dequeue of a sched_entity
> only if it has just one task in its queue.

We do not queue entites, which are empty. In __enqueue_rt_entity():

if (group_rq && (rt_rq_throttled(group_rq) || !group_rq->rt_nr_running))
         return;

Where do you see a collision? Please explain, if so.

> Regards
> Preeti U Murthy
>
>> šThere is no problem here, but now we want to count number of all tasks
>> šwhich are actually queued under the rt_rq in all the hierarhy (except
>> šthrottled rt queues).
>>
>> šEmpty queues are not able to be queued and all of the places, which
>> šuse rt_nr_running, just compare it with zero, so we do not break
>> šanything here.
>>
>> šSigned-off-by: Kirill Tkhai <tkhai@yandex.ru>
>> šCC: Peter Zijlstra <peterz@infradead.org>
>> šCC: Ingo Molnar <mingo@kernel.org>
>> š---
>> šškernel/sched/rt.c | šš15 +++++++++++++--
>> šš1 file changed, 13 insertions(+), 2 deletions(-)
>>
>> šdiff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
>> šindex d8cdf16..e4def13 100644
>> š--- a/kernel/sched/rt.c
>> š+++ b/kernel/sched/rt.c
>> š@@ -1045,12 +1045,23 @@ void dec_rt_group(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq) {}
>> šš#endif /* CONFIG_RT_GROUP_SCHED */
>>
>> ššstatic inline
>> š+unsigned int rt_se_nr_running(struct sched_rt_entity *rt_se)
>> š+{
>> š+ ššššššstruct rt_rq *group_rq = group_rt_rq(rt_se);
>> š+
>> š+ ššššššif (group_rq)
>> š+ ššššššššššššššreturn group_rq->rt_nr_running;
>> š+ ššššššelse
>> š+ ššššššššššššššreturn 1;
>> š+}
>> š+
>> š+static inline
>> ššvoid inc_rt_tasks(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
>> šš{
>> šššššššššint prio = rt_se_prio(rt_se);
>>
>> šššššššššWARN_ON(!rt_prio(prio));
>> š- ššššššrt_rq->rt_nr_running++;
>> š+ ššššššrt_rq->rt_nr_running += rt_se_nr_running(rt_se);
>>
>> šššššššššinc_rt_prio(rt_rq, prio);
>> šššššššššinc_rt_migration(rt_se, rt_rq);
>> š@@ -1062,7 +1073,7 @@ void dec_rt_tasks(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
>> šš{
>> šššššššššWARN_ON(!rt_prio(rt_se_prio(rt_se)));
>> šššššššššWARN_ON(!rt_rq->rt_nr_running);
>> š- ššššššrt_rq->rt_nr_running--;
>> š+ ššššššrt_rq->rt_nr_running -= rt_se_nr_running(rt_se);
>>
>> šššššššššdec_rt_prio(rt_rq, rt_se_prio(rt_se));
>> šššššššššdec_rt_migration(rt_se, rt_rq);
>>
>> š--
>> šTo unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> šthe body of a message to majordomo@vger.kernel.org
>> šMore majordomo info at šhttp://vger.kernel.org/majordomo-info.html
>> šPlease read the FAQ at šhttp://www.tux.org/lkml/
