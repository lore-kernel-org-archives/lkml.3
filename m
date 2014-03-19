Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933771AbaCSK7n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 06:59:43 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:38625 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933367AbaCSK7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 06:59:42 -0400
MIME-Version: 1.0
In-Reply-To: <1394835307.18748.34.camel@HP-250-G1-Notebook-PC>
References: <1394835307.18748.34.camel@HP-250-G1-Notebook-PC>
Date: Wed, 19 Mar 2014 16:29:41 +0530
Message-ID: <CAM4v1pO52-ACatsrN6Sj=ALFJpsLO_a01k8t8YQaHyHG_Pj9Og@mail.gmail.com>
Subject: Re: [PATCH 4/4] sched: Revert commit 4c6c4e38c4e9
From: Preeti Murthy <preeti.lkml@gmail.com>
To: Kirill Tkhai <tkhai@yandex.ru>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 15, 2014 at 3:45 AM, Kirill Tkhai <tkhai@yandex.ru> wrote:
> This reverts commit 4c6c4e38c4e9 [sched/core: Fix endless loop in
> pick_next_task()], which is not necessary after [sched/rt: Substract number
> of tasks of throttled queues from rq->nr_running]

Reviewed-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
>
> Signed-off-by: Kirill Tkhai <tkhai@yandex.ru>
> CC: Peter Zijlstra <peterz@infradead.org>
> CC: Ingo Molnar <mingo@kernel.org>
> ---
>  kernel/sched/fair.c  |    4 +---
>  kernel/sched/rt.c    |   10 ++++++++++
>  kernel/sched/sched.h |   12 ------------
>  3 files changed, 11 insertions(+), 15 deletions(-)
>
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 7e9bd0b..0d39ef7 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -6726,9 +6726,7 @@ static int idle_balance(struct rq *this_rq)
>
>  out:
>         /* Is there a task of a high priority class? */
> -       if (this_rq->nr_running != this_rq->cfs.h_nr_running &&
> -           (this_rq->dl.dl_nr_running ||
> -            (this_rq->rt.rt_nr_running && !rt_rq_throttled(&this_rq->rt))))
> +       if (this_rq->nr_running != this_rq->cfs.h_nr_running)
>                 pulled_task = -1;
>
>         if (pulled_task) {
> diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
> index c961350..ec0933e 100644
> --- a/kernel/sched/rt.c
> +++ b/kernel/sched/rt.c
> @@ -493,6 +493,11 @@ static void sched_rt_rq_dequeue(struct rt_rq *rt_rq)
>                 dequeue_rt_entity(rt_se);
>  }
>
> +static inline int rt_rq_throttled(struct rt_rq *rt_rq)
> +{
> +       return rt_rq->rt_throttled && !rt_rq->rt_nr_boosted;
> +}
> +
>  static int rt_se_boosted(struct sched_rt_entity *rt_se)
>  {
>         struct rt_rq *rt_rq = group_rt_rq(rt_se);
> @@ -569,6 +574,11 @@ static inline void sched_rt_rq_dequeue(struct rt_rq *rt_rq)
>         dequeue_top_rt_rq(rt_rq);
>  }
>
> +static inline int rt_rq_throttled(struct rt_rq *rt_rq)
> +{
> +       return rt_rq->rt_throttled;
> +}
> +
>  static inline const struct cpumask *sched_rt_period_mask(void)
>  {
>         return cpu_online_mask;
> diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
> index 8327b4e..e8493b4 100644
> --- a/kernel/sched/sched.h
> +++ b/kernel/sched/sched.h
> @@ -425,18 +425,6 @@ struct rt_rq {
>  #endif
>  };
>
> -#ifdef CONFIG_RT_GROUP_SCHED
> -static inline int rt_rq_throttled(struct rt_rq *rt_rq)
> -{
> -       return rt_rq->rt_throttled && !rt_rq->rt_nr_boosted;
> -}
> -#else
> -static inline int rt_rq_throttled(struct rt_rq *rt_rq)
> -{
> -       return rt_rq->rt_throttled;
> -}
> -#endif
> -
>  /* Deadline class' related fields in a runqueue */
>  struct dl_rq {
>         /* runqueue is an rbtree, ordered by deadline */
>
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
