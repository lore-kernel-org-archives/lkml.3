Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749AbaAWLiX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 06:38:23 -0500
Received: from merlin.infradead.org ([205.233.59.134]:59414 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751819AbaAWLiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 06:38:22 -0500
Date: Thu, 23 Jan 2014 12:37:54 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Paul Turner <pjt@google.com>, Benjamin Segall <bsegall@google.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 4/9] sched: Clean up idle task SMP logic
Message-ID: <20140123113754.GW31570@twins.programming.kicks-ass.net>
References: <20140121111754.580142558@infradead.org>
 <20140121112258.459329467@infradead.org>
 <CAKfTPtDVvyH45fF9=Z-AZuf7c74uqvVfCdGDqksWSviDJj1JXA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKfTPtDVvyH45fF9=Z-AZuf7c74uqvVfCdGDqksWSviDJj1JXA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 21, 2014 at 06:27:11PM +0100, Vincent Guittot wrote:
> On 21 January 2014 12:17, Peter Zijlstra <peterz@infradead.org> wrote:

> If i have correctly followed the new function path that is introduced
> by the patchset, idle_enter_fair is called after idle_balance whereas
> it must be called before in order to update the
> runnable_avg_sum/period of the rq before evaluating the interest of
> pulling cfs task

Its idle_exit_fair, that's moved from pre_schedule to put_prev_task and
thus indeed has crossed idle_balance.

Yeah, I can leave that pre_schedule thing in place, however all that has
be thinking.

Ideally we'd do something like the below; but I must admit to still
being slightly confused about the idle_{enter,exit}_fair() calls, their
comment doesn't seem to clarify things.

Steve, I don't think I wrecked rt/deadline by pulling in the
pre_schedule call into pick_next_task(), but then, who knows :-)

The only thing I really don't like is having that double conditional for
the direct fair_sched_class call, but I didn't see a way around that,
other than dropping that entirely. Then again, we cut out a conditional
and indirect call by getting rid of pre_schedule() -- so it might just
balance out.

---
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2146,13 +2146,6 @@ static void finish_task_switch(struct rq
 
 #ifdef CONFIG_SMP
 
-/* assumes rq->lock is held */
-static inline void pre_schedule(struct rq *rq, struct task_struct *prev)
-{
-	if (prev->sched_class->pre_schedule)
-		prev->sched_class->pre_schedule(rq, prev);
-}
-
 /* rq->lock is NOT held, but preemption is disabled */
 static inline void post_schedule(struct rq *rq)
 {
@@ -2170,10 +2163,6 @@ static inline void post_schedule(struct
 
 #else
 
-static inline void pre_schedule(struct rq *rq, struct task_struct *p)
-{
-}
-
 static inline void post_schedule(struct rq *rq)
 {
 }
@@ -2571,7 +2560,8 @@ pick_next_task(struct rq *rq, struct tas
 		 * Optimization: we know that if all tasks are in
 		 * the fair class we can call that function directly:
 		 */
-		if (likely(rq->nr_running == rq->cfs.h_nr_running))
+		if (likely(prev->sched_class == &fair_sched_class &&
+			   rq->nr_running == rq->cfs.h_nr_running))
 			return fair_sched_class.pick_next_task(rq, prev);
 
 		for_each_class(class) {
@@ -2581,14 +2571,6 @@ pick_next_task(struct rq *rq, struct tas
 		}
 	}
 
-	/*
-	 * If there is a task balanced on this cpu, pick the next task,
-	 * otherwise fall in the optimization by picking the idle task
-	 * directly.
-	 */
-	if (idle_balance(rq))
-		goto again;
-
 	rq->idle_stamp = rq_clock(rq);
 
 	return idle_sched_class.pick_next_task(rq, prev);
@@ -2682,8 +2664,6 @@ static void __sched __schedule(void)
 		switch_count = &prev->nvcsw;
 	}
 
-	pre_schedule(rq, prev);
-
 	if (prev->on_rq || rq->skip_clock_update < 0)
 		update_rq_clock(rq);
 
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -997,6 +997,9 @@ struct task_struct *pick_next_task_dl(st
 
 	dl_rq = &rq->dl;
 
+	if (dl_task(prev))
+		pull_dl_task(rq);
+
 	if (unlikely(!dl_rq->dl_nr_running))
 		return NULL;
 
@@ -1430,8 +1433,6 @@ static int pull_dl_task(struct rq *this_
 static void pre_schedule_dl(struct rq *rq, struct task_struct *prev)
 {
 	/* Try to pull other tasks here */
-	if (dl_task(prev))
-		pull_dl_task(rq);
 }
 
 static void post_schedule_dl(struct rq *rq)
@@ -1626,7 +1627,6 @@ const struct sched_class dl_sched_class
 	.set_cpus_allowed       = set_cpus_allowed_dl,
 	.rq_online              = rq_online_dl,
 	.rq_offline             = rq_offline_dl,
-	.pre_schedule		= pre_schedule_dl,
 	.post_schedule		= post_schedule_dl,
 	.task_woken		= task_woken_dl,
 #endif
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2581,7 +2581,8 @@ void idle_exit_fair(struct rq *this_rq)
 	update_rq_runnable_avg(this_rq, 0);
 }
 
-#else
+#else /* CONFIG_SMP */
+
 static inline void update_entity_load_avg(struct sched_entity *se,
 					  int update_cfs_rq) {}
 static inline void update_rq_runnable_avg(struct rq *rq, int runnable) {}
@@ -2593,7 +2594,7 @@ static inline void dequeue_entity_load_a
 					   int sleep) {}
 static inline void update_cfs_rq_blocked_load(struct cfs_rq *cfs_rq,
 					      int force_update) {}
-#endif
+#endif /* CONFIG_SMP */
 
 static void enqueue_sleeper(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
@@ -4700,10 +4701,11 @@ pick_next_task_fair(struct rq *rq, struc
 	struct sched_entity *se;
 	struct task_struct *p;
 
+again:
+#ifdef CONFIG_FAIR_GROUP_SCHED
 	if (!cfs_rq->nr_running)
-		return NULL;
+		goto idle;
 
-#ifdef CONFIG_FAIR_GROUP_SCHED
 	if (prev->sched_class != &fair_sched_class)
 		goto simple;
 
@@ -4769,11 +4771,10 @@ pick_next_task_fair(struct rq *rq, struc
 
 	return p;
 simple:
-#endif
 	cfs_rq = &rq->cfs;
-
+#endif
 	if (!cfs_rq->nr_running)
-		return NULL;
+		goto idle;
 
 	prev->sched_class->put_prev_task(rq, prev);
 
@@ -4789,6 +4790,13 @@ pick_next_task_fair(struct rq *rq, struc
 		hrtick_start_fair(rq, p);
 
 	return p;
+
+idle:
+	idle_exit_fair();
+	if (idle_balance()) /* drops rq->lock */
+		goto again;
+
+	return NULL;
 }
 
 /*
--- a/kernel/sched/idle_task.c
+++ b/kernel/sched/idle_task.c
@@ -13,18 +13,8 @@ select_task_rq_idle(struct task_struct *
 {
 	return task_cpu(p); /* IDLE tasks as never migrated */
 }
-
-static void pre_schedule_idle(struct rq *rq, struct task_struct *prev)
-{
-	idle_exit_fair(rq);
-	rq_last_tick_reset(rq);
-}
-
-static void post_schedule_idle(struct rq *rq)
-{
-	idle_enter_fair(rq);
-}
 #endif /* CONFIG_SMP */
+
 /*
  * Idle tasks are unconditionally rescheduled:
  */
@@ -40,8 +30,7 @@ pick_next_task_idle(struct rq *rq, struc
 
 	schedstat_inc(rq, sched_goidle);
 #ifdef CONFIG_SMP
-	/* Trigger the post schedule to do an idle_enter for CFS */
-	rq->post_schedule = 1;
+	idle_enter_fair(rq);
 #endif
 	return rq->idle;
 }
@@ -61,6 +50,10 @@ dequeue_task_idle(struct rq *rq, struct
 
 static void put_prev_task_idle(struct rq *rq, struct task_struct *prev)
 {
+#ifdef CONFIG_SMP
+	idle_exit_fair(rq);
+	rq_last_tick_reset(rq);
+#endif
 }
 
 static void task_tick_idle(struct rq *rq, struct task_struct *curr, int queued)
@@ -104,8 +97,6 @@ const struct sched_class idle_sched_clas
 
 #ifdef CONFIG_SMP
 	.select_task_rq		= select_task_rq_idle,
-	.pre_schedule		= pre_schedule_idle,
-	.post_schedule		= post_schedule_idle,
 #endif
 
 	.set_curr_task          = set_curr_task_idle,
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -1330,6 +1330,10 @@ pick_next_task_rt(struct rq *rq, struct
 	struct task_struct *p;
 	struct rt_rq *rt_rq = &rq->rt;
 
+	/* Try to pull RT tasks here if we lower this rq's prio */
+	if (rq->rt.highest_prio.curr > prev->prio)
+		pull_rt_task(rq);
+
 	if (!rt_rq->rt_nr_running)
 		return NULL;
 
@@ -1720,13 +1724,6 @@ static int pull_rt_task(struct rq *this_
 	return ret;
 }
 
-static void pre_schedule_rt(struct rq *rq, struct task_struct *prev)
-{
-	/* Try to pull RT tasks here if we lower this rq's prio */
-	if (rq->rt.highest_prio.curr > prev->prio)
-		pull_rt_task(rq);
-}
-
 static void post_schedule_rt(struct rq *rq)
 {
 	push_rt_tasks(rq);
@@ -2003,7 +2000,6 @@ const struct sched_class rt_sched_class
 	.set_cpus_allowed       = set_cpus_allowed_rt,
 	.rq_online              = rq_online_rt,
 	.rq_offline             = rq_offline_rt,
-	.pre_schedule		= pre_schedule_rt,
 	.post_schedule		= post_schedule_rt,
 	.task_woken		= task_woken_rt,
 	.switched_from		= switched_from_rt,
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1136,7 +1136,6 @@ struct sched_class {
 	int  (*select_task_rq)(struct task_struct *p, int task_cpu, int sd_flag, int flags);
 	void (*migrate_task_rq)(struct task_struct *p, int next_cpu);
 
-	void (*pre_schedule) (struct rq *this_rq, struct task_struct *task);
 	void (*post_schedule) (struct rq *this_rq);
 	void (*task_waking) (struct task_struct *task);
 	void (*task_woken) (struct rq *this_rq, struct task_struct *task);
