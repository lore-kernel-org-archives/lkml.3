Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752411Ab3FNLKV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 07:10:21 -0400
Received: from mail-lb0-f180.google.com ([209.85.217.180]:34972 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752311Ab3FNLKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 07:10:19 -0400
MIME-Version: 1.0
In-Reply-To: <1370589652-24549-4-git-send-email-alex.shi@intel.com>
References: <1370589652-24549-1-git-send-email-alex.shi@intel.com> <1370589652-24549-4-git-send-email-alex.shi@intel.com>
From: Paul Turner <pjt@google.com>
Date: Fri, 14 Jun 2013 04:09:47 -0700
Message-ID: <CAPM31RJFsh_gBXBHc4E6z=MtORR9D8sWs=86Yqy9onxK9x9fOg@mail.gmail.com>
Subject: Re: [patch v8 3/9] sched: set initial value of runnable avg for new
 forked task
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
        Jason Low <jason.low2@hp.com>,
        Changlong Xie <changlongx.xie@intel.com>, sgruszka@redhat.com,
        =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Minor comments; looks good otherwise.

Signed-off-by: Paul Turner <pjt@google.com>

On Fri, Jun 7, 2013 at 12:20 AM, Alex Shi <alex.shi@intel.com> wrote:
> We need initialize the se.avg.{decay_count, load_avg_contrib} for a
> new forked task.
> Otherwise random values of above variables cause mess when do new task
> enqueue:
>     enqueue_task_fair
>         enqueue_entity
>             enqueue_entity_load_avg
>
> and make forking balancing imbalance since incorrect load_avg_contrib.
>
> Further more, Morten Rasmussen notice some tasks were not launched at
> once after created. So Paul and Peter suggest giving a start value for
> new task runnable avg time same as sched_slice().
>
> Signed-off-by: Alex Shi <alex.shi@intel.com>
> ---
>  kernel/sched/core.c  |  6 ++----
>  kernel/sched/fair.c  | 23 +++++++++++++++++++++++
>  kernel/sched/sched.h |  2 ++
>  3 files changed, 27 insertions(+), 4 deletions(-)
>
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index b9e7036..6f226c2 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -1598,10 +1598,6 @@ static void __sched_fork(struct task_struct *p)
>         p->se.vruntime                  = 0;
>         INIT_LIST_HEAD(&p->se.group_node);
>
> -#ifdef CONFIG_SMP
> -       p->se.avg.runnable_avg_period = 0;
> -       p->se.avg.runnable_avg_sum = 0;
> -#endif
>  #ifdef CONFIG_SCHEDSTATS
>         memset(&p->se.statistics, 0, sizeof(p->se.statistics));
>  #endif
> @@ -1745,6 +1741,8 @@ void wake_up_new_task(struct task_struct *p)
>         set_task_cpu(p, select_task_rq(p, SD_BALANCE_FORK, 0));
>  #endif
>
> +       /* Give new task start runnable values */

/* Initialize new task's runnable average */

> +       set_task_runnable_avg(p);
>         rq = __task_rq_lock(p);
>         activate_task(rq, p, 0);
>         p->on_rq = 1;
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index f404468..1fc30b9 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -680,6 +680,26 @@ static u64 sched_vslice(struct cfs_rq *cfs_rq, struct sched_entity *se)
>         return calc_delta_fair(sched_slice(cfs_rq, se), se);
>  }
>
> +#ifdef CONFIG_SMP
> +static inline void __update_task_entity_contrib(struct sched_entity *se);
> +
> +/* Give new task start runnable values to heavy its load in infant time */
> +void set_task_runnable_avg(struct task_struct *p)

init_task_runnable_average

> +{
> +       u32 slice;
> +
> +       p->se.avg.decay_count = 0;
> +       slice = sched_slice(task_cfs_rq(p), &p->se) >> 10;
> +       p->se.avg.runnable_avg_sum = slice;
> +       p->se.avg.runnable_avg_period = slice;
> +       __update_task_entity_contrib(&p->se);
> +}
> +#else
> +void set_task_runnable_avg(struct task_struct *p)
> +{
> +}
> +#endif
> +
>  /*
>   * Update the current task's runtime statistics. Skip current tasks that
>   * are not in our scheduling class.
> @@ -1527,6 +1547,9 @@ static inline void enqueue_entity_load_avg(struct cfs_rq *cfs_rq,
>          * We track migrations using entity decay_count <= 0, on a wake-up
>          * migration we use a negative decay count to track the remote decays
>          * accumulated while sleeping.
> +        *
> +        * When enqueue a new forked task, the se->avg.decay_count == 0, so
> +        * we bypass update_entity_load_avg(), use avg.load_avg_contrib direct.

Newly forked tasks are enqueued with se->avg.decay_count == 0, they
are seen by enqueue_entity_load_avg() as a migration with an already
constructed load_avg_contrib.

>          */
>         if (unlikely(se->avg.decay_count <= 0)) {
>                 se->avg.last_runnable_update = rq_clock_task(rq_of(cfs_rq));
> diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
> index 24b1503..8bc66c6 100644
> --- a/kernel/sched/sched.h
> +++ b/kernel/sched/sched.h
> @@ -1058,6 +1058,8 @@ extern void init_rt_bandwidth(struct rt_bandwidth *rt_b, u64 period, u64 runtime
>
>  extern void update_idle_cpu_load(struct rq *this_rq);
>
> +extern void set_task_runnable_avg(struct task_struct *p);
> +
>  #ifdef CONFIG_PARAVIRT
>  static inline u64 steal_ticks(u64 steal)
>  {
> --
> 1.7.12
>
