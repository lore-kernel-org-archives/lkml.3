Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755053AbaCRLIe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 07:08:34 -0400
Received: from mail-oa0-f52.google.com ([209.85.219.52]:64814 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753374AbaCRLIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 07:08:30 -0400
MIME-Version: 1.0
In-Reply-To: <1394835289.18748.31.camel@HP-250-G1-Notebook-PC>
References: <1394835289.18748.31.camel@HP-250-G1-Notebook-PC>
Date: Tue, 18 Mar 2014 16:38:29 +0530
Message-ID: <CAM4v1pOtUDNn_yFG3HyYbBy0VDy4qCh-Ms3jMO_+hfOVQLhw-A@mail.gmail.com>
Subject: Re: [PATCH 1/4] sched/rt: Sum number of all children tasks in
 hierarhy at rt_nr_running
From: Preeti Murthy <preeti.lkml@gmail.com>
To: tkhai@yandex.ru
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 15, 2014 at 3:44 AM, Kirill Tkhai <tkhai@yandex.ru> wrote:
> {inc,dec}_rt_tasks used to count entities which are directly queued
> on rt_rq. If an entity was not a task (i.e., it is some queue), its
> children were not counted.

Its always the case that a task is queued right, never a sched entity?
When a task is queued, the nr_running of every rt_rq in the hierarchy
of sched entities which are parents of this task is incremented by 1.
Similar is with dequeue of a sched_entity. If the sched_entity has
just 1 task on it, then its dequeued from its parent queue and its number
decremented for every rq in the hierarchy. But you would
never dequeue a sched_entity if it has more than 1 task in it. The
granularity of enqueue and dequeue of sched_entities is one task
at a time. You can extend this to enqueue and dequeue of a sched_entity
only if it has just one task in its queue.

Regards
Preeti U Murthy


>
> There is no problem here, but now we want to count number of all tasks
> which are actually queued under the rt_rq in all the hierarhy (except
> throttled rt queues).
>
> Empty queues are not able to be queued and all of the places, which
> use rt_nr_running, just compare it with zero, so we do not break
> anything here.
>
> Signed-off-by: Kirill Tkhai <tkhai@yandex.ru>
> CC: Peter Zijlstra <peterz@infradead.org>
> CC: Ingo Molnar <mingo@kernel.org>
> ---
>  kernel/sched/rt.c |   15 +++++++++++++--
>  1 file changed, 13 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
> index d8cdf16..e4def13 100644
> --- a/kernel/sched/rt.c
> +++ b/kernel/sched/rt.c
> @@ -1045,12 +1045,23 @@ void dec_rt_group(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq) {}
>  #endif /* CONFIG_RT_GROUP_SCHED */
>
>  static inline
> +unsigned int rt_se_nr_running(struct sched_rt_entity *rt_se)
> +{
> +       struct rt_rq *group_rq = group_rt_rq(rt_se);
> +
> +       if (group_rq)
> +               return group_rq->rt_nr_running;
> +       else
> +               return 1;
> +}
> +
> +static inline
>  void inc_rt_tasks(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
>  {
>         int prio = rt_se_prio(rt_se);
>
>         WARN_ON(!rt_prio(prio));
> -       rt_rq->rt_nr_running++;
> +       rt_rq->rt_nr_running += rt_se_nr_running(rt_se);
>
>         inc_rt_prio(rt_rq, prio);
>         inc_rt_migration(rt_se, rt_rq);
> @@ -1062,7 +1073,7 @@ void dec_rt_tasks(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
>  {
>         WARN_ON(!rt_prio(rt_se_prio(rt_se)));
>         WARN_ON(!rt_rq->rt_nr_running);
> -       rt_rq->rt_nr_running--;
> +       rt_rq->rt_nr_running -= rt_se_nr_running(rt_se);
>
>         dec_rt_prio(rt_rq, rt_se_prio(rt_se));
>         dec_rt_migration(rt_se, rt_rq);
>
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
