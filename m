Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751703AbaBLHH1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 02:07:27 -0500
Received: from forward5h.mail.yandex.net ([84.201.186.23]:56658 "EHLO
	forward5h.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783AbaBLHHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 02:07:14 -0500
X-Greylist: delayed 375 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 Feb 2014 02:07:14 EST
From: Kirill Tkhai <tkhai@yandex.ru>
To: "mingo@kernel.org" <mingo@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
In-Reply-To: <tip-606dba2e289446600a0b68422ed2019af5355c12@git.kernel.org>
References: <1328936700.2476.17.camel@laptop> <tip-606dba2e289446600a0b68422ed2019af5355c12@git.kernel.org>
Subject: Re: [tip:sched/core] sched: Push put_prev_task() into pick_next_task( )
MIME-Version: 1.0
Message-Id: <124891392188453@web4h.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Wed, 12 Feb 2014 11:00:53 +0400
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=koi8-r
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



11.02.2014, 16:17, "tip-bot for Peter Zijlstra" <tipbot@zytor.com>:
> Commit-ID: š606dba2e289446600a0b68422ed2019af5355c12
> Gitweb: ššššhttp://git.kernel.org/tip/606dba2e289446600a0b68422ed2019af5355c12
> Author: ššššPeter Zijlstra <peterz@infradead.org>
> AuthorDate: Sat, 11 Feb 2012 06:05:00 +0100
> Committer: šIngo Molnar <mingo@kernel.org>
> CommitDate: Mon, 10 Feb 2014 16:17:13 +0100
>
> sched: Push put_prev_task() into pick_next_task()
>
> In order to avoid having to do put/set on a whole cgroup hierarchy
> when we context switch, push the put into pick_next_task() so that
> both operations are in the same function. Further changes then allow
> us to possibly optimize away redundant work.
>
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> Link: http://lkml.kernel.org/r/1328936700.2476.17.camel@laptop
> Signed-off-by: Ingo Molnar <mingo@kernel.org>
> ---
> škernel/sched/core.c ššššš| 21 ++++++++-------------
> škernel/sched/deadline.c š| š5 ++++-
> škernel/sched/fair.c ššššš| š6 +++++-
> škernel/sched/idle_task.c | š6 +++++-
> škernel/sched/rt.c ššššššš| 27 ++++++++++++++++-----------
> škernel/sched/sched.h šššš| š8 +++++++-
> škernel/sched/stop_task.c | 16 ++++++++++------
> š7 files changed, 55 insertions(+), 34 deletions(-)
>
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 417cf65..dedb5f0 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -2579,18 +2579,11 @@ static inline void schedule_debug(struct task_struct *prev)
> šššššššššschedstat_inc(this_rq(), sched_count);
> š}
>
> -static void put_prev_task(struct rq *rq, struct task_struct *prev)
> -{
> - if (prev->on_rq || rq->skip_clock_update < 0)
> - update_rq_clock(rq);
> - prev->sched_class->put_prev_task(rq, prev);
> -}
> -
> š/*
> šš* Pick up the highest-prio task:
> šš*/
> šstatic inline struct task_struct *
> -pick_next_task(struct rq *rq)
> +pick_next_task(struct rq *rq, struct task_struct *prev)
> š{
> šššššššššconst struct sched_class *class;
> šššššššššstruct task_struct *p;
> @@ -2600,13 +2593,13 @@ pick_next_task(struct rq *rq)
> šššššššššš* the fair class we can call that function directly:
> šššššššššš*/
> šššššššššif (likely(rq->nr_running == rq->cfs.h_nr_running)) {
> - p = fair_sched_class.pick_next_task(rq);
> + p = fair_sched_class.pick_next_task(rq, prev);
> šššššššššššššššššif (likely(p))
> šššššššššššššššššššššššššreturn p;
> ššššššššš}
>
> šššššššššfor_each_class(class) {
> - p = class->pick_next_task(rq);
> + p = class->pick_next_task(rq, prev);
> šššššššššššššššššif (p)
> šššššššššššššššššššššššššreturn p;
> ššššššššš}
> @@ -2714,8 +2707,10 @@ need_resched:
> šššššššššššššššššššššššššrq->idle_stamp = 0;
> ššššššššš}
>
> - put_prev_task(rq, prev);
> - next = pick_next_task(rq);
> + if (prev->on_rq || rq->skip_clock_update < 0)
> + update_rq_clock(rq);
> +
> + next = pick_next_task(rq, prev);
> šššššššššclear_tsk_need_resched(prev);
> šššššššššclear_preempt_need_resched();
> šššššššššrq->skip_clock_update = 0;
> @@ -4748,7 +4743,7 @@ static void migrate_tasks(unsigned int dead_cpu)
> šššššššššššššššššif (rq->nr_running == 1)
> šššššššššššššššššššššššššbreak;
>
> - next = pick_next_task(rq);
> + next = pick_next_task(rq, NULL);

pick_next_task() firstly checks for prev->sched_class, doesn't it ???

The same for pick_next_task_rt().

> šššššššššššššššššBUG_ON(!next);
> šššššššššššššššššnext->sched_class->put_prev_task(rq, next);
>
> diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
> index b5700bc..50797d5 100644
> --- a/kernel/sched/deadline.c
> +++ b/kernel/sched/deadline.c
> @@ -990,7 +990,7 @@ static struct sched_dl_entity *pick_next_dl_entity(struct rq *rq,
> šššššššššreturn rb_entry(left, struct sched_dl_entity, rb_node);
> š}
>
> -struct task_struct *pick_next_task_dl(struct rq *rq)
> +struct task_struct *pick_next_task_dl(struct rq *rq, struct task_struct *prev)
> š{
> šššššššššstruct sched_dl_entity *dl_se;
> šššššššššstruct task_struct *p;
> @@ -1001,6 +1001,9 @@ struct task_struct *pick_next_task_dl(struct rq *rq)
> šššššššššif (unlikely(!dl_rq->dl_nr_running))
> šššššššššššššššššreturn NULL;
>
> + if (prev)
> + prev->sched_class->put_prev_task(rq, prev);
> +
> šššššššššdl_se = pick_next_dl_entity(rq, dl_rq);
> šššššššššBUG_ON(!dl_se);
>
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 748a7ac..c4bb0ac 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -4655,7 +4655,8 @@ preempt:
> šššššššššššššššššset_last_buddy(se);
> š}
>
> -static struct task_struct *pick_next_task_fair(struct rq *rq)
> +static struct task_struct *
> +pick_next_task_fair(struct rq *rq, struct task_struct *prev)
> š{
> šššššššššstruct task_struct *p;
> šššššššššstruct cfs_rq *cfs_rq = &rq->cfs;
> @@ -4664,6 +4665,9 @@ static struct task_struct *pick_next_task_fair(struct rq *rq)
> šššššššššif (!cfs_rq->nr_running)
> šššššššššššššššššreturn NULL;
>
> + if (prev)
> + prev->sched_class->put_prev_task(rq, prev);
> +
> šššššššššdo {
> šššššššššššššššššse = pick_next_entity(cfs_rq);
> šššššššššššššššššset_next_entity(cfs_rq, se);
> diff --git a/kernel/sched/idle_task.c b/kernel/sched/idle_task.c
> index 516c3d9..e5c922a 100644
> --- a/kernel/sched/idle_task.c
> +++ b/kernel/sched/idle_task.c
> @@ -33,8 +33,12 @@ static void check_preempt_curr_idle(struct rq *rq, struct task_struct *p, int fl
> šššššššššresched_task(rq->idle);
> š}
>
> -static struct task_struct *pick_next_task_idle(struct rq *rq)
> +static struct task_struct *
> +pick_next_task_idle(struct rq *rq, struct task_struct *prev)
> š{
> + if (prev)
> + prev->sched_class->put_prev_task(rq, prev);
> +
> šššššššššschedstat_inc(rq, sched_goidle);
> š#ifdef CONFIG_SMP
> ššššššššš/* Trigger the post schedule to do an idle_enter for CFS */
> diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
> index a2740b7..a15ca1c 100644
> --- a/kernel/sched/rt.c
> +++ b/kernel/sched/rt.c
> @@ -1310,15 +1310,7 @@ static struct task_struct *_pick_next_task_rt(struct rq *rq)
> š{
> šššššššššstruct sched_rt_entity *rt_se;
> šššššššššstruct task_struct *p;
> - struct rt_rq *rt_rq;
> -
> - rt_rq = &rq->rt;
> -
> - if (!rt_rq->rt_nr_running)
> - return NULL;
> -
> - if (rt_rq_throttled(rt_rq))
> - return NULL;
> + struct rt_rq *rt_rq š= &rq->rt;
>
> šššššššššdo {
> šššššššššššššššššrt_se = pick_next_rt_entity(rq, rt_rq);
> @@ -1332,9 +1324,22 @@ static struct task_struct *_pick_next_task_rt(struct rq *rq)
> šššššššššreturn p;
> š}
>
> -static struct task_struct *pick_next_task_rt(struct rq *rq)
> +static struct task_struct *
> +pick_next_task_rt(struct rq *rq, struct task_struct *prev)
> š{
> - struct task_struct *p = _pick_next_task_rt(rq);
> + struct task_struct *p;
> + struct rt_rq *rt_rq = &rq->rt;
> +
> + if (!rt_rq->rt_nr_running)
> + return NULL;
> +
> + if (rt_rq_throttled(rt_rq))
> + return NULL;
> +
> + if (prev)
> + prev->sched_class->put_prev_task(rq, prev);
> +
> + p = _pick_next_task_rt(rq);
>
> ššššššššš/* The running task is never eligible for pushing */
> šššššššššif (p)
> diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
> index bb89991..c534cf4 100644
> --- a/kernel/sched/sched.h
> +++ b/kernel/sched/sched.h
> @@ -1105,7 +1105,13 @@ struct sched_class {
>
> šššššššššvoid (*check_preempt_curr) (struct rq *rq, struct task_struct *p, int flags);
>
> - struct task_struct * (*pick_next_task) (struct rq *rq);
> + /*
> + * It is the responsibility of the pick_next_task() method that will
> + * return the next task to call put_prev_task() on the @prev task or
> + * something equivalent.
> + */
> + struct task_struct * (*pick_next_task) (struct rq *rq,
> + struct task_struct *prev);
> šššššššššvoid (*put_prev_task) (struct rq *rq, struct task_struct *p);
>
> š#ifdef CONFIG_SMP
> diff --git a/kernel/sched/stop_task.c b/kernel/sched/stop_task.c
> index fdb6bb0..a4147c9 100644
> --- a/kernel/sched/stop_task.c
> +++ b/kernel/sched/stop_task.c
> @@ -23,16 +23,20 @@ check_preempt_curr_stop(struct rq *rq, struct task_struct *p, int flags)
> ššššššššš/* we're never preempted */
> š}
>
> -static struct task_struct *pick_next_task_stop(struct rq *rq)
> +static struct task_struct *
> +pick_next_task_stop(struct rq *rq, struct task_struct *prev)
> š{
> šššššššššstruct task_struct *stop = rq->stop;
>
> - if (stop && stop->on_rq) {
> - stop->se.exec_start = rq_clock_task(rq);
> - return stop;
> - }
> + if (!stop || !stop->on_rq)
> + return NULL;
>
> - return NULL;
> + if (prev)
> + prev->sched_class->put_prev_task(rq, prev);
> +
> + stop->se.exec_start = rq_clock_task(rq);
> +
> + return stop;
> š}
>
> šstatic void
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at šhttp://vger.kernel.org/majordomo-info.html
> Please read the FAQ at šhttp://www.tux.org/lkml/
