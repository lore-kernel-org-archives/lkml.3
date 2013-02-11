Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932680Ab3BKVkX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 16:40:23 -0500
Received: from forward4h.mail.yandex.net ([84.201.186.22]:34780 "EHLO
	forward4h.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760072Ab3BKVkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 16:40:20 -0500
X-Greylist: delayed 500 seconds by postgrey-1.27 at vger.kernel.org; Mon, 11 Feb 2013 16:40:19 EST
From: Kirill Tkhai <tkhai@yandex.ru>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: [PATCH] sched/rt: Unthrottle the highest RT task of the rq if there are no another available tasks to be picked
MIME-Version: 1.0
Message-Id: <2260671360618316@web22h.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Tue, 12 Feb 2013 01:31:56 +0400
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's possible a situation when rq->rt is throttled or
it has no child entities and there are RT tasks ready
for execution in the rq which are the only tasks
of TASK_RUNNING state. In this case pick_next_task
takes idle tasks and idle wastes cpu time.

The patch change logic of pre_schedule a little bit.
We are looking at the rq's tasks and if there is a
case described bellow we unthrottle the highest RT
task (its rt_rq) of the rq if it is available. He
receives a rt_time equal to 'rt_runtime-1' and the
time spent at 'manually unthrottled' condition is
not accounted. The manually unthrottled task is
preempted by any other task when the new task of
any class will be available.

Signed-off-by: Kirill V Tkhai <tkhai@yandex.ru>
CC: Steven Rostedt <rostedt@goodmis.org>
CC: Ingo Molnar <mingo@kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>
CC: linux-rt-users <linux-rt-users@vger.kernel.org>
---
 kernel/sched/core.c  |   22 +++++---
 kernel/sched/fair.c  |    2 +-
 kernel/sched/rt.c    |  143 ++++++++++++++++++++++++++++++++++++++++----------
 kernel/sched/sched.h |    5 +-
 4 files changed, 135 insertions(+), 37 deletions(-)
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 55a5ae3..a77447d 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -910,7 +910,9 @@ void check_preempt_curr(struct rq *rq, struct task_struct *p, int flags)
 {
 	const struct sched_class *class;
 
-	if (p->sched_class == rq->curr->sched_class) {
+	if (unlikely(rq->rt_man_unthrottle)) {
+		resched_task(rq->curr);
+	} else if (p->sched_class == rq->curr->sched_class) {
 		rq->curr->sched_class->check_preempt_curr(rq, p, flags);
 	} else {
 		for_each_class(class) {
@@ -1860,15 +1862,23 @@ static void finish_task_switch(struct rq *rq, struct task_struct *prev)
 	}
 }
 
-#ifdef CONFIG_SMP
-
 /* assumes rq->lock is held */
 static inline void pre_schedule(struct rq *rq, struct task_struct *prev)
 {
+	struct rt_rq *rt_rq = &rq->rt;
+	unsigned long rt_total = rt_rq->rt_nr_total;
+
+#ifdef CONFIG_SMP
 	if (prev->sched_class->pre_schedule)
 		prev->sched_class->pre_schedule(rq, prev);
+#endif
+	/* The rq has only RT tasks and they are available */
+	if (rt_total == rq->nr_running && rt_total)
+		check_rt_rq_throttled(rq);
 }
 
+#ifdef CONFIG_SMP
+
 /* rq->lock is NOT held, but preemption is disabled */
 static inline void post_schedule(struct rq *rq)
 {
@@ -1886,10 +1896,6 @@ static inline void post_schedule(struct rq *rq)
 
 #else
 
-static inline void pre_schedule(struct rq *rq, struct task_struct *p)
-{
-}
-
 static inline void post_schedule(struct rq *rq)
 {
 }
@@ -2933,6 +2939,7 @@ need_resched:
 		switch_count = &prev->nvcsw;
 	}
 
+	rq->rt_man_unthrottle = 0;
 	pre_schedule(rq, prev);
 
 	if (unlikely(!rq->nr_running))
@@ -6972,6 +6979,7 @@ void __init sched_init(void)
 		rq->nohz_flags = 0;
 #endif
 #endif
+		rq->rt_man_unthrottle = 0;
 		init_rq_hrtick(rq);
 		atomic_set(&rq->nr_iowait, 0);
 	}
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 7a33e59..7d98302 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2309,7 +2309,7 @@ void unthrottle_cfs_rq(struct cfs_rq *cfs_rq)
 		rq->nr_running += task_delta;
 
 	/* determine whether we need to wake up potentially idle cpu */
-	if (rq->curr == rq->idle && rq->cfs.nr_running)
+	if ((rq->curr == rq->idle || rq->rt_man_unthrottle) && rq->cfs.nr_running)
 		resched_task(rq->curr);
 }
 
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 839718d..1cbe5dc 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -274,15 +274,8 @@ static void update_rt_migration(struct rt_rq *rt_rq)
 
 static void inc_rt_migration(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
 {
-	struct task_struct *p;
-
-	if (!rt_entity_is_task(rt_se))
-		return;
-
-	p = rt_task_of(rt_se);
-	rt_rq = &rq_of_rt_rq(rt_rq)->rt;
+	struct task_struct *p = rt_task_of(rt_se);
 
-	rt_rq->rt_nr_total++;
 	if (p->nr_cpus_allowed > 1)
 		rt_rq->rt_nr_migratory++;
 
@@ -291,15 +284,8 @@ static void inc_rt_migration(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
 
 static void dec_rt_migration(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
 {
-	struct task_struct *p;
-
-	if (!rt_entity_is_task(rt_se))
-		return;
-
-	p = rt_task_of(rt_se);
-	rt_rq = &rq_of_rt_rq(rt_rq)->rt;
+	struct task_struct *p = rt_task_of(rt_se);
 
-	rt_rq->rt_nr_total--;
 	if (p->nr_cpus_allowed > 1)
 		rt_rq->rt_nr_migratory--;
 
@@ -783,6 +769,31 @@ static inline int balance_runtime(struct rt_rq *rt_rq)
 }
 #endif /* CONFIG_SMP */
 
+static void check_new_entity_available(struct rq *rq, struct rt_rq *rt_rq)
+{
+	struct task_struct *curr = rq->curr;
+	struct sched_rt_entity *rt_se = &curr->rt;
+
+	if (rt_rq->rt_nr_running == 0)
+		return;
+
+	for_each_sched_rt_entity(rt_se) {
+		/* rt_rq is an entity of rt stack of curr */
+		if (rt_rq_of_se(rt_se) == rt_rq) {
+			/*
+			 * We don't know which entity of the stack was
+			 * throttled during check_rt_rq_throttled().
+			 */
+			rq->rt_man_unthrottle = 0;
+			if (rt_rq->rt_nr_running == 1)
+				return;
+			break;
+		}
+	}
+
+	resched_task(curr);
+}
+
 static int do_sched_rt_period_timer(struct rt_bandwidth *rt_b, int overrun)
 {
 	int i, idle = 1, throttled = 0;
@@ -837,6 +848,8 @@ static int do_sched_rt_period_timer(struct rt_bandwidth *rt_b, int overrun)
 		}
 		if (rt_rq->rt_throttled)
 			throttled = 1;
+		else if (rq->rt_man_unthrottle)
+			check_new_entity_available(rq, rt_rq);
 
 		if (enqueue)
 			sched_rt_rq_enqueue(rt_rq);
@@ -939,7 +952,7 @@ static void update_curr_rt(struct rq *rq)
 
 	sched_rt_avg_update(rq, delta_exec);
 
-	if (!rt_bandwidth_enabled())
+	if (!rt_bandwidth_enabled() || rq->rt_man_unthrottle)
 		return;
 
 	for_each_sched_rt_entity(rt_se) {
@@ -1071,8 +1084,14 @@ void inc_rt_tasks(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
 	WARN_ON(!rt_prio(prio));
 	rt_rq->rt_nr_running++;
 
+	if (rt_entity_is_task(rt_se)) {
+		struct rt_rq *rt = &rq_of_rt_rq(rt_rq)->rt;
+
+		rt->rt_nr_total++;
+		inc_rt_migration(rt_se, rt);
+	}
+
 	inc_rt_prio(rt_rq, prio);
-	inc_rt_migration(rt_se, rt_rq);
 	inc_rt_group(rt_se, rt_rq);
 }
 
@@ -1083,8 +1102,15 @@ void dec_rt_tasks(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
 	WARN_ON(!rt_rq->rt_nr_running);
 	rt_rq->rt_nr_running--;
 
+	if (rt_entity_is_task(rt_se)) {
+		struct rt_rq *rt = &rq_of_rt_rq(rt_rq)->rt;
+
+		WARN_ON(!rt->rt_nr_total);
+		rt->rt_nr_total--;
+		dec_rt_migration(rt_se, rt);
+	}
+
 	dec_rt_prio(rt_rq, rt_se_prio(rt_se));
-	dec_rt_migration(rt_se, rt_rq);
 	dec_rt_group(rt_se, rt_rq);
 }
 
@@ -1419,17 +1445,15 @@ static void put_prev_task_rt(struct rq *rq, struct task_struct *p)
 		enqueue_pushable_task(rq, p);
 }
 
-#ifdef CONFIG_SMP
-
-/* Only try algorithms three times */
-#define RT_MAX_TRIES 3
-
 static int pick_rt_task(struct rq *rq, struct task_struct *p, int cpu)
 {
-	if (!task_running(rq, p) &&
-	    cpumask_test_cpu(cpu, tsk_cpus_allowed(p)))
-		return 1;
-	return 0;
+	if (task_running(rq, p))
+		return 0;
+#ifdef CONFIG_SMP
+	if (!cpumask_test_cpu(cpu, tsk_cpus_allowed(p)))
+		return 0;
+#endif
+	return 1;
 }
 
 /* Return the second highest RT task, NULL otherwise */
@@ -1470,6 +1494,11 @@ next_idx:
 	return next;
 }
 
+#ifdef CONFIG_SMP
+
+/* Only try algorithms three times */
+#define RT_MAX_TRIES 3
+
 static DEFINE_PER_CPU(cpumask_var_t, local_cpu_mask);
 
 static int find_lowest_rq(struct task_struct *task)
@@ -1906,6 +1935,64 @@ void init_sched_rt_class(void)
 }
 #endif /* CONFIG_SMP */
 
+static void unthrottle_single_rt_rq(struct rt_rq *rt_rq)
+{
+	u64 runtime;
+
+	raw_spin_lock(&rt_rq->rt_runtime_lock);
+
+	rt_rq->rt_throttled = 0;
+
+	runtime = sched_rt_runtime(rt_rq);
+	WARN_ON(runtime == RUNTIME_INF);
+
+	rt_rq->rt_time = min(rt_rq->rt_time, runtime - 1);
+
+	raw_spin_unlock(&rt_rq->rt_runtime_lock);
+}
+
+static void unthrottle_highest_rt_rq(struct rq *rq)
+{
+	struct task_struct *curr = rq->curr, *p;
+	struct sched_rt_entity *rt_se;
+
+	p = pick_next_highest_task_rt(rq, cpu_of(rq));
+
+	if (!p || (curr->sched_class == &rt_sched_class &&
+		   curr->prio <= p->prio && curr->on_rq))
+		p = curr;
+
+	rt_se = &p->rt;
+
+	dequeue_rt_stack(rt_se);
+
+	for_each_sched_rt_entity(rt_se) {
+		struct rt_rq *rt_rq = rt_rq_of_se(rt_se);
+
+		/* Unthrottle parent rt_rq */
+		if (rt_rq->rt_throttled)
+			unthrottle_single_rt_rq(rt_rq);
+
+		/* Enqueue on parent rt_rq */
+		__enqueue_rt_entity(rt_se, true);
+	}
+}
+
+void check_rt_rq_throttled(struct rq *rq)
+{
+	struct rt_rq *rt_rq = &rq->rt;
+
+	/* Do update here to recognize if rt_rq is throttled */
+	update_curr_rt(rq);
+
+	/* The rt_rq is throttled or all of its children are dequeued */
+	if (unlikely(rt_rq_throttled(rt_rq) || !rt_rq->rt_nr_running)) {
+		unthrottle_highest_rt_rq(rq);
+		rq->rt_man_unthrottle = 1;
+	}
+
+}
+
 /*
  * When switching a task to RT, we may overload the runqueue
  * with RT tasks. In this case we try to push them off to
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index fc88644..d7a49b0 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -293,6 +293,7 @@ static inline int rt_bandwidth_enabled(void)
 struct rt_rq {
 	struct rt_prio_array active;
 	unsigned int rt_nr_running;
+	unsigned long rt_nr_total;
 #if defined CONFIG_SMP || defined CONFIG_RT_GROUP_SCHED
 	struct {
 		int curr; /* highest queued rt task prio */
@@ -303,7 +304,6 @@ struct rt_rq {
 #endif
 #ifdef CONFIG_SMP
 	unsigned long rt_nr_migratory;
-	unsigned long rt_nr_total;
 	int overloaded;
 	struct plist_head pushable_tasks;
 #endif
@@ -375,6 +375,8 @@ struct rq {
 	unsigned long nohz_flags;
 #endif
 	int skip_clock_update;
+	/* rt rq was manually unthrottled */
+	int rt_man_unthrottle;
 
 	/* capture load from *all* tasks on this cpu: */
 	struct load_weight load;
@@ -782,6 +784,7 @@ static inline void finish_lock_switch(struct rq *rq, struct task_struct *prev)
 }
 #endif /* __ARCH_WANT_UNLOCKED_CTXSW */
 
+extern void check_rt_rq_throttled(struct rq *rq);
 
 static inline void update_load_add(struct load_weight *lw, unsigned long inc)
 {
