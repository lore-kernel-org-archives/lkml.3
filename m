Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755256AbaAUR1f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 12:27:35 -0500
Received: from mail-ob0-f181.google.com ([209.85.214.181]:57850 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755084AbaAUR1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 12:27:33 -0500
MIME-Version: 1.0
In-Reply-To: <20140121112258.459329467@infradead.org>
References: <20140121111754.580142558@infradead.org> <20140121112258.459329467@infradead.org>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Tue, 21 Jan 2014 18:27:11 +0100
Message-ID: <CAKfTPtDVvyH45fF9=Z-AZuf7c74uqvVfCdGDqksWSviDJj1JXA@mail.gmail.com>
Subject: Re: [PATCH 4/9] sched: Clean up idle task SMP logic
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Paul Turner <pjt@google.com>, Benjamin Segall <bsegall@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21 January 2014 12:17, Peter Zijlstra <peterz@infradead.org> wrote:
> The idle post_schedule hook is just a vile waste of time, fix it proper.
>
> Cc: alex.shi@linaro.org
> Cc: mingo@kernel.org
> Cc: Vincent Guittot <vincent.guittot@linaro.org>
> Tested-by: Daniel Lezcano <daniel.lezcano@linaro.org>
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> Link: http://lkml.kernel.org/r/20140117140939.GH11314@laptop.programming.kicks-ass.net
> ---
>  kernel/sched/fair.c      |    5 +++--
>  kernel/sched/idle_task.c |   21 ++++++---------------
>  2 files changed, 9 insertions(+), 17 deletions(-)
>
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -2416,7 +2416,8 @@ void idle_exit_fair(struct rq *this_rq)
>         update_rq_runnable_avg(this_rq, 0);
>  }
>
> -#else
> +#else /* CONFIG_SMP */
> +
>  static inline void update_entity_load_avg(struct sched_entity *se,
>                                           int update_cfs_rq) {}
>  static inline void update_rq_runnable_avg(struct rq *rq, int runnable) {}
> @@ -2428,7 +2429,7 @@ static inline void dequeue_entity_load_a
>                                            int sleep) {}
>  static inline void update_cfs_rq_blocked_load(struct cfs_rq *cfs_rq,
>                                               int force_update) {}
> -#endif
> +#endif /* CONFIG_SMP */
>
>  static void enqueue_sleeper(struct cfs_rq *cfs_rq, struct sched_entity *se)
>  {
> --- a/kernel/sched/idle_task.c
> +++ b/kernel/sched/idle_task.c
> @@ -13,18 +13,8 @@ select_task_rq_idle(struct task_struct *
>  {
>         return task_cpu(p); /* IDLE tasks as never migrated */
>  }
> -
> -static void pre_schedule_idle(struct rq *rq, struct task_struct *prev)
> -{
> -       idle_exit_fair(rq);
> -       rq_last_tick_reset(rq);
> -}
> -
> -static void post_schedule_idle(struct rq *rq)
> -{
> -       idle_enter_fair(rq);
> -}
>  #endif /* CONFIG_SMP */
> +
>  /*
>   * Idle tasks are unconditionally rescheduled:
>   */
> @@ -37,8 +27,7 @@ static struct task_struct *pick_next_tas
>  {
>         schedstat_inc(rq, sched_goidle);
>  #ifdef CONFIG_SMP
> -       /* Trigger the post schedule to do an idle_enter for CFS */
> -       rq->post_schedule = 1;
> +       idle_enter_fair(rq);

If i have correctly followed the new function path that is introduced
by the patchset, idle_enter_fair is called after idle_balance whereas
it must be called before in order to update the
runnable_avg_sum/period of the rq before evaluating the interest of
pulling cfs task

Regards,
vincent

>  #endif
>         return rq->idle;
>  }
> @@ -58,6 +47,10 @@ dequeue_task_idle(struct rq *rq, struct
>
>  static void put_prev_task_idle(struct rq *rq, struct task_struct *prev)
>  {
> +#ifdef CONFIG_SMP
> +       idle_exit_fair(rq);
> +       rq_last_tick_reset(rq);
> +#endif
>  }
>
>  static void task_tick_idle(struct rq *rq, struct task_struct *curr, int queued)
> @@ -101,8 +94,6 @@ const struct sched_class idle_sched_clas
>
>  #ifdef CONFIG_SMP
>         .select_task_rq         = select_task_rq_idle,
> -       .pre_schedule           = pre_schedule_idle,
> -       .post_schedule          = post_schedule_idle,
>  #endif
>
>         .set_curr_task          = set_curr_task_idle,
>
>
