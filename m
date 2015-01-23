Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756272AbbAWSKC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 13:10:02 -0500
Received: from mail-yh0-f44.google.com ([209.85.213.44]:34016 "EHLO
	mail-yh0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752097AbbAWSJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 13:09:57 -0500
MIME-Version: 1.0
In-Reply-To: <1421642980-10045-1-git-send-email-pang.xunlei@linaro.org>
References: <1421642980-10045-1-git-send-email-pang.xunlei@linaro.org>
Date: Sat, 24 Jan 2015 02:09:56 +0800
Message-ID: <CADcy93VSNRH=LmT8U+-GB4GdUjF4tcZ3MfySqbnY6OhgpF1Jsw@mail.gmail.com>
Subject: Re: [PATCH 1/5] sched/deadline: Modify cpudl::free_cpus to reflect rd->online
From: Xunlei Pang <pang.xunlei@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@gmail.com>,
        Xunlei Pang <pang.xunlei@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter, Juri,

Could you please give some comments on these 5 patches?
Thanks for your time.

Regards,
Xunlei

On 19 January 2015 at 12:49, Xunlei Pang <pang.xunlei@linaro.org> wrote:
> Currently, cpudl::free_cpus contains all cpus during init, see
> cpudl_init(). When calling cpudl_find(), we have to add rd->span
> to avoid selecting the cpu outside current root domain, because
> cpus_allowed is undependable when performing clustered scheduling
> using the cpuset, see find_later_rq().
>
> This patch adds cpudl_set_freecpu() and cpudl_clear_freecpu() for
> changing cpudl::free_cpus when doing rq_online_dl()/rq_offline_dl(),
> so we can avoid the rd->span operation when calling cpudl_find()
> in find_later_rq().
>
> Signed-off-by: Xunlei Pang <pang.xunlei@linaro.org>
> ---
>  kernel/sched/cpudeadline.c | 28 ++++++++++++++++++++++++----
>  kernel/sched/cpudeadline.h |  2 ++
>  kernel/sched/deadline.c    |  5 ++---
>  3 files changed, 28 insertions(+), 7 deletions(-)
>
> diff --git a/kernel/sched/cpudeadline.c b/kernel/sched/cpudeadline.c
> index 539ca3c..fd9d3fb 100644
> --- a/kernel/sched/cpudeadline.c
> +++ b/kernel/sched/cpudeadline.c
> @@ -107,7 +107,9 @@ int cpudl_find(struct cpudl *cp, struct task_struct *p,
>         int best_cpu = -1;
>         const struct sched_dl_entity *dl_se = &p->dl;
>
> -       if (later_mask && cpumask_and(later_mask, later_mask, cp->free_cpus)) {
> +       if (later_mask &&
> +           cpumask_and(later_mask, cp->free_cpus, &p->cpus_allowed) &&
> +           cpumask_and(later_mask, later_mask, cpu_active_mask)) {
>                 best_cpu = cpumask_any(later_mask);
>                 goto out;
>         } else if (cpumask_test_cpu(cpudl_maximum(cp), &p->cpus_allowed) &&
> @@ -186,6 +188,26 @@ out:
>  }
>
>  /*
> + * cpudl_set_freecpu - Set the cpudl.free_cpus
> + * @cp: the cpudl max-heap context
> + * @cpu: rd attached cpu
> + */
> +void cpudl_set_freecpu(struct cpudl *cp, int cpu)
> +{
> +       cpumask_set_cpu(cpu, cp->free_cpus);
> +}
> +
> +/*
> + * cpudl_clear_freecpu - Clear the cpudl.free_cpus
> + * @cp: the cpudl max-heap context
> + * @cpu: rd attached cpu
> + */
> +void cpudl_clear_freecpu(struct cpudl *cp, int cpu)
> +{
> +       cpumask_clear_cpu(cpu, cp->free_cpus);
> +}
> +
> +/*
>   * cpudl_init - initialize the cpudl structure
>   * @cp: the cpudl max-heap context
>   */
> @@ -203,7 +225,7 @@ int cpudl_init(struct cpudl *cp)
>         if (!cp->elements)
>                 return -ENOMEM;
>
> -       if (!alloc_cpumask_var(&cp->free_cpus, GFP_KERNEL)) {
> +       if (!zalloc_cpumask_var(&cp->free_cpus, GFP_KERNEL)) {
>                 kfree(cp->elements);
>                 return -ENOMEM;
>         }
> @@ -211,8 +233,6 @@ int cpudl_init(struct cpudl *cp)
>         for_each_possible_cpu(i)
>                 cp->elements[i].idx = IDX_INVALID;
>
> -       cpumask_setall(cp->free_cpus);
> -
>         return 0;
>  }
>
> diff --git a/kernel/sched/cpudeadline.h b/kernel/sched/cpudeadline.h
> index 020039b..1a0a6ef 100644
> --- a/kernel/sched/cpudeadline.h
> +++ b/kernel/sched/cpudeadline.h
> @@ -24,6 +24,8 @@ int cpudl_find(struct cpudl *cp, struct task_struct *p,
>                struct cpumask *later_mask);
>  void cpudl_set(struct cpudl *cp, int cpu, u64 dl, int is_valid);
>  int cpudl_init(struct cpudl *cp);
> +void cpudl_set_freecpu(struct cpudl *cp, int cpu);
> +void cpudl_clear_freecpu(struct cpudl *cp, int cpu);
>  void cpudl_cleanup(struct cpudl *cp);
>  #endif /* CONFIG_SMP */
>
> diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
> index b52092f..e7b2722 100644
> --- a/kernel/sched/deadline.c
> +++ b/kernel/sched/deadline.c
> @@ -1165,9 +1165,6 @@ static int find_later_rq(struct task_struct *task)
>          * We have to consider system topology and task affinity
>          * first, then we can look for a suitable cpu.
>          */
> -       cpumask_copy(later_mask, task_rq(task)->rd->span);
> -       cpumask_and(later_mask, later_mask, cpu_active_mask);
> -       cpumask_and(later_mask, later_mask, &task->cpus_allowed);
>         best_cpu = cpudl_find(&task_rq(task)->rd->cpudl,
>                         task, later_mask);
>         if (best_cpu == -1)
> @@ -1562,6 +1559,7 @@ static void rq_online_dl(struct rq *rq)
>         if (rq->dl.overloaded)
>                 dl_set_overload(rq);
>
> +       cpudl_set_freecpu(&rq->rd->cpudl, rq->cpu);
>         if (rq->dl.dl_nr_running > 0)
>                 cpudl_set(&rq->rd->cpudl, rq->cpu, rq->dl.earliest_dl.curr, 1);
>  }
> @@ -1573,6 +1571,7 @@ static void rq_offline_dl(struct rq *rq)
>                 dl_clear_overload(rq);
>
>         cpudl_set(&rq->rd->cpudl, rq->cpu, 0, 0);
> +       cpudl_clear_freecpu(&rq->rd->cpudl, rq->cpu);
>  }
>
>  void init_sched_dl_class(void)
> --
> 1.9.1
>
