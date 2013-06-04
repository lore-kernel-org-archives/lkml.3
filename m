Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759594Ab3FDGwz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 02:52:55 -0400
Received: from mail-lb0-f170.google.com ([209.85.217.170]:38321 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759292Ab3FDGww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 02:52:52 -0400
MIME-Version: 1.0
In-Reply-To: <51AD87D0.7020300@linux.vnet.ibm.com>
References: <51AD87A8.6080608@linux.vnet.ibm.com> <51AD87D0.7020300@linux.vnet.ibm.com>
From: Paul Turner <pjt@google.com>
Date: Mon, 3 Jun 2013 23:52:20 -0700
Message-ID: <CAPM31RJfWWJuMg-2Byb7uGFQPQY1v+8OWVpwO2Ggz_mtTYpjVQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] sched: don't repeat the initialization in sched_init()
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 3, 2013 at 11:23 PM, Michael Wang
<wangyun@linux.vnet.ibm.com> wrote:
> In sched_init(), there is no need to initialize 'root_task_group.shares' and
> 'root_task_group.cfs_bandwidth' repeatedly.
>
> CC: Ingo Molnar <mingo@kernel.org>
> CC: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>
> ---
>  kernel/sched/core.c |   46 +++++++++++++++++++++++++---------------------
>  1 files changed, 25 insertions(+), 21 deletions(-)
>
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 58453b8..c0c3716 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -6955,6 +6955,31 @@ void __init sched_init(void)
>
>  #endif /* CONFIG_CGROUP_SCHED */
>
> +#ifdef CONFIG_FAIR_GROUP_SCHED
> +       root_task_group.shares = ROOT_TASK_GROUP_LOAD;
> +
> +       /*
> +        * How much cpu bandwidth does root_task_group get?
> +        *
> +        * In case of task-groups formed thr' the cgroup filesystem, it
> +        * gets 100% of the cpu resources in the system. This overall
> +        * system cpu resource is divided among the tasks of
> +        * root_task_group and its child task-groups in a fair manner,
> +        * based on each entity's (task or task-group's) weight
> +        * (se->load.weight).
> +        *
> +        * In other words, if root_task_group has 10 tasks of weight
> +        * 1024) and two child groups A0 and A1 (of weight 1024 each),
> +        * then A0's share of the cpu resource is:
> +        *
> +        *      A0's bandwidth = 1024 / (10*1024 + 1024 + 1024) = 8.33%
> +        *
> +        * We achieve this by letting root_task_group's tasks sit
> +        * directly in rq->cfs (i.e root_task_group->se[] = NULL).
> +        */

This comment has become unglued from what it's supposed to be attached
to (it's tied to root_task_group.shares & init_tg_cfs_entry, not
init_cfs_bandwidth).

> +       init_cfs_bandwidth(&root_task_group.cfs_bandwidth);
> +#endif
> +
>         for_each_possible_cpu(i) {
>                 struct rq *rq;
>
> @@ -6966,28 +6991,7 @@ void __init sched_init(void)
>                 init_cfs_rq(&rq->cfs);
>                 init_rt_rq(&rq->rt, rq);
>  #ifdef CONFIG_FAIR_GROUP_SCHED
> -               root_task_group.shares = ROOT_TASK_GROUP_LOAD;
>                 INIT_LIST_HEAD(&rq->leaf_cfs_rq_list);
> -               /*
> -                * How much cpu bandwidth does root_task_group get?
> -                *
> -                * In case of task-groups formed thr' the cgroup filesystem, it
> -                * gets 100% of the cpu resources in the system. This overall
> -                * system cpu resource is divided among the tasks of
> -                * root_task_group and its child task-groups in a fair manner,
> -                * based on each entity's (task or task-group's) weight
> -                * (se->load.weight).
> -                *
> -                * In other words, if root_task_group has 10 tasks of weight
> -                * 1024) and two child groups A0 and A1 (of weight 1024 each),
> -                * then A0's share of the cpu resource is:
> -                *
> -                *      A0's bandwidth = 1024 / (10*1024 + 1024 + 1024) = 8.33%
> -                *
> -                * We achieve this by letting root_task_group's tasks sit
> -                * directly in rq->cfs (i.e root_task_group->se[] = NULL).
> -                */
> -               init_cfs_bandwidth(&root_task_group.cfs_bandwidth);
>                 init_tg_cfs_entry(&root_task_group, &rq->cfs, NULL, i, NULL);
>  #endif /* CONFIG_FAIR_GROUP_SCHED */
>
> --
> 1.7.4.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
