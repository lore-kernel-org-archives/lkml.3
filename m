Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932623Ab3FQKUL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 06:20:11 -0400
Received: from mail-lb0-f171.google.com ([209.85.217.171]:40403 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932300Ab3FQKUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 06:20:07 -0400
MIME-Version: 1.0
In-Reply-To: <1370590169-24804-4-git-send-email-alex.shi@intel.com>
References: <1370590169-24804-1-git-send-email-alex.shi@intel.com> <1370590169-24804-4-git-send-email-alex.shi@intel.com>
From: Paul Turner <pjt@google.com>
Date: Mon, 17 Jun 2013 03:19:35 -0700
Message-ID: <CAPM31RKUW2vM7BJFXOPtGHnSHbreWLL_7pyBVwPZG617xStxBA@mail.gmail.com>
Subject: Re: [RFC patch 3/4] sched/cfs_rq: change atomic64_t removed_load to atomic_long_t
To: Alex Shi <alex.shi@intel.com>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Namhyung Kim <namhyung@kernel.org>,
        Mike Galbraith <efault@gmx.de>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>,
        Michael Wang <wangyun@linux.vnet.ibm.com>,
        Jason Low <jason.low2@hp.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 7, 2013 at 12:29 AM, Alex Shi <alex.shi@intel.com> wrote:
> Like as runnable_load_avg, blocked_load_avg variable, long type is
> enough for removed_load in 64 bit or 32 bit machine.
>
> Then we avoid the expensive atomic64 operations on 32 bit machine.
>
> Signed-off-by: Alex Shi <alex.shi@intel.com>

So while this isn't under quite the same constraints as blocked_load
since this is per-migration and only cleared on the tick; it would
take an awful lot (~47k) of wake-upmigrations of a large (nice-20)
task to overflow.

One concern is that this would be potentially user-triggerable using
sched_setaffinity() when combined with a sufficiently low HZ.

Although all this would actually do would strand blocked load on the
cpu, which mostly punishes the cgroup doing this (likely an ok
behavior).  If it ever became an issue we could force a
update_cfs_rq_blocked_load() when a removal would result in an
overflow, but I think this is fine for now.

Reviewed-by: Paul Turner <pjt@google.com>

> ---
>  kernel/sched/fair.c  | 10 ++++++----
>  kernel/sched/sched.h |  3 ++-
>  2 files changed, 8 insertions(+), 5 deletions(-)
>
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 30fb7dc..9cc4211 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -1517,8 +1517,9 @@ static void update_cfs_rq_blocked_load(struct cfs_rq *cfs_rq, int force_update)
>         if (!decays && !force_update)
>                 return;
>
> -       if (atomic64_read(&cfs_rq->removed_load)) {
> -               u64 removed_load = atomic64_xchg(&cfs_rq->removed_load, 0);
> +       if (atomic_long_read(&cfs_rq->removed_load)) {
> +               unsigned long removed_load;
> +               removed_load = atomic_long_xchg(&cfs_rq->removed_load, 0);
>                 subtract_blocked_load_contrib(cfs_rq, removed_load);
>         }
>
> @@ -3479,7 +3480,8 @@ migrate_task_rq_fair(struct task_struct *p, int next_cpu)
>          */
>         if (se->avg.decay_count) {
>                 se->avg.decay_count = -__synchronize_entity_decay(se);
> -               atomic64_add(se->avg.load_avg_contrib, &cfs_rq->removed_load);
> +               atomic_long_add(se->avg.load_avg_contrib,
> +                                               &cfs_rq->removed_load);
>         }
>  }
>  #endif /* CONFIG_SMP */
> @@ -5944,7 +5946,7 @@ void init_cfs_rq(struct cfs_rq *cfs_rq)
>  #endif
>  #if defined(CONFIG_FAIR_GROUP_SCHED) && defined(CONFIG_SMP)
>         atomic64_set(&cfs_rq->decay_counter, 1);
> -       atomic64_set(&cfs_rq->removed_load, 0);
> +       atomic_long_set(&cfs_rq->removed_load, 0);
>  #endif
>  }
>
> diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
> index 1bfa91a..874731f 100644
> --- a/kernel/sched/sched.h
> +++ b/kernel/sched/sched.h
> @@ -278,8 +278,9 @@ struct cfs_rq {
>          * the FAIR_GROUP_SCHED case).
>          */
>         unsigned long runnable_load_avg, blocked_load_avg;
> -       atomic64_t decay_counter, removed_load;
> +       atomic64_t decay_counter;
>         u64 last_decay;
> +       atomic_long_t removed_load;
>
>  #ifdef CONFIG_FAIR_GROUP_SCHED
>         /* Required to track per-cpu representation of a task_group */
> --
> 1.7.12
>
