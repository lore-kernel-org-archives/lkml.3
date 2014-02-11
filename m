Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752067AbaBKMRn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 07:17:43 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46529 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783AbaBKMRl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 07:17:41 -0500
Date: Tue, 11 Feb 2014 04:17:09 -0800
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-a8k6vvaebtn64nie345kx1je@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        peterz@infradead.org, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Push down pre_schedule() and idle_balance
 ()
Git-Commit-ID: 38033c37faab850ed5d33bb675c4de6c66be84d8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 11 Feb 2014 04:17:15 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  38033c37faab850ed5d33bb675c4de6c66be84d8
Gitweb:     http://git.kernel.org/tip/38033c37faab850ed5d33bb675c4de6c66be84d8
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Thu, 23 Jan 2014 20:32:21 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 11 Feb 2014 09:58:10 +0100

sched: Push down pre_schedule() and idle_balance()

This patch both merged idle_balance() and pre_schedule() and pushes
both of them into pick_next_task().

Conceptually pre_schedule() and idle_balance() are rather similar,
both are used to pull more work onto the current CPU.

We cannot however first move idle_balance() into pre_schedule_fair()
since there is no guarantee the last runnable task is a fair task, and
thus we would miss newidle balances.

Similarly, the dl and rt pre_schedule calls must be ran before
idle_balance() since their respective tasks have higher priority and
it would not do to delay their execution searching for less important
tasks first.

However, by noticing that pick_next_tasks() already traverses the
sched_class hierarchy in the right order, we can get the right
behaviour and do away with both calls.

We must however change the special case optimization to also require
that prev is of sched_class_fair, otherwise we can miss doing a dl or
rt pull where we needed one.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/n/tip-a8k6vvaebtn64nie345kx1je@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c      | 26 ++------------------------
 kernel/sched/deadline.c  | 15 +++++++--------
 kernel/sched/fair.c      | 26 ++++++++++++++++++++++----
 kernel/sched/idle_task.c | 12 +++++-------
 kernel/sched/rt.c        | 16 ++++++++--------
 kernel/sched/sched.h     |  1 -
 6 files changed, 44 insertions(+), 52 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index dedb5f0..3068f37 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2169,13 +2169,6 @@ static void finish_task_switch(struct rq *rq, struct task_struct *prev)
 
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
@@ -2193,10 +2186,6 @@ static inline void post_schedule(struct rq *rq)
 
 #else
 
-static inline void pre_schedule(struct rq *rq, struct task_struct *p)
-{
-}
-
 static inline void post_schedule(struct rq *rq)
 {
 }
@@ -2592,7 +2581,8 @@ pick_next_task(struct rq *rq, struct task_struct *prev)
 	 * Optimization: we know that if all tasks are in
 	 * the fair class we can call that function directly:
 	 */
-	if (likely(rq->nr_running == rq->cfs.h_nr_running)) {
+	if (likely(prev->sched_class == &fair_sched_class &&
+		   rq->nr_running == rq->cfs.h_nr_running)) {
 		p = fair_sched_class.pick_next_task(rq, prev);
 		if (likely(p))
 			return p;
@@ -2695,18 +2685,6 @@ need_resched:
 		switch_count = &prev->nvcsw;
 	}
 
-	pre_schedule(rq, prev);
-
-	if (unlikely(!rq->nr_running)) {
-		/*
-		 * We must set idle_stamp _before_ calling idle_balance(), such
-		 * that we measure the duration of idle_balance() as idle time.
-		 */
-		rq->idle_stamp = rq_clock(rq);
-		if (idle_balance(rq))
-			rq->idle_stamp = 0;
-	}
-
 	if (prev->on_rq || rq->skip_clock_update < 0)
 		update_rq_clock(rq);
 
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 50797d5..ed31ef6 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -944,6 +944,8 @@ static void check_preempt_equal_dl(struct rq *rq, struct task_struct *p)
 	resched_task(rq->curr);
 }
 
+static int pull_dl_task(struct rq *this_rq);
+
 #endif /* CONFIG_SMP */
 
 /*
@@ -998,6 +1000,11 @@ struct task_struct *pick_next_task_dl(struct rq *rq, struct task_struct *prev)
 
 	dl_rq = &rq->dl;
 
+#ifdef CONFIG_SMP
+	if (dl_task(prev))
+		pull_dl_task(rq);
+#endif
+
 	if (unlikely(!dl_rq->dl_nr_running))
 		return NULL;
 
@@ -1429,13 +1436,6 @@ skip:
 	return ret;
 }
 
-static void pre_schedule_dl(struct rq *rq, struct task_struct *prev)
-{
-	/* Try to pull other tasks here */
-	if (dl_task(prev))
-		pull_dl_task(rq);
-}
-
 static void post_schedule_dl(struct rq *rq)
 {
 	push_dl_tasks(rq);
@@ -1628,7 +1628,6 @@ const struct sched_class dl_sched_class = {
 	.set_cpus_allowed       = set_cpus_allowed_dl,
 	.rq_online              = rq_online_dl,
 	.rq_offline             = rq_offline_dl,
-	.pre_schedule		= pre_schedule_dl,
 	.post_schedule		= post_schedule_dl,
 	.task_woken		= task_woken_dl,
 #endif
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index a81b241..43b49fe 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2577,7 +2577,8 @@ void idle_exit_fair(struct rq *this_rq)
 	update_rq_runnable_avg(this_rq, 0);
 }
 
-#else
+#else /* CONFIG_SMP */
+
 static inline void update_entity_load_avg(struct sched_entity *se,
 					  int update_cfs_rq) {}
 static inline void update_rq_runnable_avg(struct rq *rq, int runnable) {}
@@ -2589,7 +2590,7 @@ static inline void dequeue_entity_load_avg(struct cfs_rq *cfs_rq,
 					   int sleep) {}
 static inline void update_cfs_rq_blocked_load(struct cfs_rq *cfs_rq,
 					      int force_update) {}
-#endif
+#endif /* CONFIG_SMP */
 
 static void enqueue_sleeper(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
@@ -4682,9 +4683,10 @@ pick_next_task_fair(struct rq *rq, struct task_struct *prev)
 	struct sched_entity *se;
 	struct task_struct *p;
 
+again: __maybe_unused
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	if (!cfs_rq->nr_running)
-		return NULL;
+		goto idle;
 
 	if (!prev || prev->sched_class != &fair_sched_class)
 		goto simple;
@@ -4760,7 +4762,7 @@ simple:
 #endif
 
 	if (!cfs_rq->nr_running)
-		return NULL;
+		goto idle;
 
 	if (prev)
 		prev->sched_class->put_prev_task(rq, prev);
@@ -4777,6 +4779,22 @@ simple:
 		hrtick_start_fair(rq, p);
 
 	return p;
+
+idle:
+#ifdef CONFIG_SMP
+	idle_enter_fair(rq);
+	/*
+	 * We must set idle_stamp _before_ calling idle_balance(), such that we
+	 * measure the duration of idle_balance() as idle time.
+	 */
+	rq->idle_stamp = rq_clock(rq);
+	if (idle_balance(rq)) { /* drops rq->lock */
+		rq->idle_stamp = 0;
+		goto again;
+	}
+#endif
+
+	return NULL;
 }
 
 /*
diff --git a/kernel/sched/idle_task.c b/kernel/sched/idle_task.c
index 721371b..f7d03af 100644
--- a/kernel/sched/idle_task.c
+++ b/kernel/sched/idle_task.c
@@ -13,13 +13,8 @@ select_task_rq_idle(struct task_struct *p, int cpu, int sd_flag, int flags)
 {
 	return task_cpu(p); /* IDLE tasks as never migrated */
 }
-
-static void pre_schedule_idle(struct rq *rq, struct task_struct *prev)
-{
-	idle_exit_fair(rq);
-	rq_last_tick_reset(rq);
-}
 #endif /* CONFIG_SMP */
+
 /*
  * Idle tasks are unconditionally rescheduled:
  */
@@ -56,6 +51,10 @@ dequeue_task_idle(struct rq *rq, struct task_struct *p, int flags)
 
 static void put_prev_task_idle(struct rq *rq, struct task_struct *prev)
 {
+#ifdef CONFIG_SMP
+	idle_exit_fair(rq);
+	rq_last_tick_reset(rq);
+#endif
 }
 
 static void task_tick_idle(struct rq *rq, struct task_struct *curr, int queued)
@@ -99,7 +98,6 @@ const struct sched_class idle_sched_class = {
 
 #ifdef CONFIG_SMP
 	.select_task_rq		= select_task_rq_idle,
-	.pre_schedule		= pre_schedule_idle,
 #endif
 
 	.set_curr_task          = set_curr_task_idle,
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index a15ca1c..72f9ec7 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -229,6 +229,8 @@ int alloc_rt_sched_group(struct task_group *tg, struct task_group *parent)
 
 #ifdef CONFIG_SMP
 
+static int pull_rt_task(struct rq *this_rq);
+
 static inline int rt_overloaded(struct rq *rq)
 {
 	return atomic_read(&rq->rd->rto_count);
@@ -1330,6 +1332,12 @@ pick_next_task_rt(struct rq *rq, struct task_struct *prev)
 	struct task_struct *p;
 	struct rt_rq *rt_rq = &rq->rt;
 
+#ifdef CONFIG_SMP
+	/* Try to pull RT tasks here if we lower this rq's prio */
+	if (rq->rt.highest_prio.curr > prev->prio)
+		pull_rt_task(rq);
+#endif
+
 	if (!rt_rq->rt_nr_running)
 		return NULL;
 
@@ -1721,13 +1729,6 @@ skip:
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
@@ -2004,7 +2005,6 @@ const struct sched_class rt_sched_class = {
 	.set_cpus_allowed       = set_cpus_allowed_rt,
 	.rq_online              = rq_online_rt,
 	.rq_offline             = rq_offline_rt,
-	.pre_schedule		= pre_schedule_rt,
 	.post_schedule		= post_schedule_rt,
 	.task_woken		= task_woken_rt,
 	.switched_from		= switched_from_rt,
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index c534cf4..1bf34c2 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1118,7 +1118,6 @@ struct sched_class {
 	int  (*select_task_rq)(struct task_struct *p, int task_cpu, int sd_flag, int flags);
 	void (*migrate_task_rq)(struct task_struct *p, int next_cpu);
 
-	void (*pre_schedule) (struct rq *this_rq, struct task_struct *task);
 	void (*post_schedule) (struct rq *this_rq);
 	void (*task_waking) (struct task_struct *task);
 	void (*task_woken) (struct rq *this_rq, struct task_struct *task);
