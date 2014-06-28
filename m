Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753568AbaF1UED (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 16:04:03 -0400
Received: from forward1l.mail.yandex.net ([84.201.143.144]:39621 "EHLO
	forward1l.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751978AbaF1UEB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 16:04:01 -0400
X-Yandex-Uniq: 4f1b876c-28c9-4531-b5e6-dfcb4a6c963f
Authentication-Results: smtp2h.mail.yandex.net; dkim=pass header.i=@yandex.ru
Subject: [PATCH] sched: Transform resched_task() into resched_curr()
From: Kirill Tkhai <tkhai@yandex.ru>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, tkhai@yandex.ru, mingo@redhat.com
Date: Sun, 29 Jun 2014 00:03:57 +0400
Message-ID: <20140628200219.1778.18735.stgit@localhost>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We always use resched_task() with rq->curr argument.
It's not possible to reschedule any task but rq's current.

The patch introduces resched_curr(struct rq *) to
replace all of the repeating patterns. The main aim
is cleanup, but there is a little size profit too:

(before)
$ size kernel/sched/built-in.o
   text	   data	    bss	    dec	    hex	filename
155274	  16445	   7042	 178761	  2ba49	kernel/sched/built-in.o

$ size vmlinux
   text	   data	    bss	    dec	    hex	filename
7411490	1178376	 991232	9581098	 92322a	vmlinux

(after)
$ size kernel/sched/built-in.o
   text	   data	    bss	    dec	    hex	filename
155130	  16445	   7042	 178617	  2b9b9	kernel/sched/built-in.o

$ size vmlinux
   text	   data	    bss	    dec	    hex	filename
7411362	1178376	 991232	9580970	 9231aa	vmlinux

I was choosing between resched_curr() and resched_rq(),
and the first name looks better for me.

A little lie in Documentation/trace/ftrace.txt. I have not
actually collected the tracing again. With a hope the patch
won't make execution times much worse :)

Signed-off-by: Kirill Tkhai <tkhai@yandex.ru>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@kernel.org>
---
 Documentation/trace/ftrace.txt |    2 +-
 include/linux/sched.h          |    6 +++---
 kernel/sched/core.c            |   25 +++++++++++++------------
 kernel/sched/deadline.c        |   16 ++++++++--------
 kernel/sched/fair.c            |   20 ++++++++++----------
 kernel/sched/idle_task.c       |    2 +-
 kernel/sched/rt.c              |   27 ++++++++++++++-------------
 kernel/sched/sched.h           |    2 +-
 8 files changed, 51 insertions(+), 49 deletions(-)

diff --git a/Documentation/trace/ftrace.txt b/Documentation/trace/ftrace.txt
index 2479b2a..4da4261 100644
--- a/Documentation/trace/ftrace.txt
+++ b/Documentation/trace/ftrace.txt
@@ -1515,7 +1515,7 @@ Doing the same with chrt -r 5 and function-trace set.
   <idle>-0       3d.h4    1us+:      0:120:R   + [003]  2448: 94:R sleep
   <idle>-0       3d.h4    2us : ttwu_do_activate.constprop.87 <-try_to_wake_up
   <idle>-0       3d.h3    3us : check_preempt_curr <-ttwu_do_wakeup
-  <idle>-0       3d.h3    3us : resched_task <-check_preempt_curr
+  <idle>-0       3d.h3    3us : resched_curr <-check_preempt_curr
   <idle>-0       3dNh3    4us : task_woken_rt <-ttwu_do_wakeup
   <idle>-0       3dNh3    4us : _raw_spin_unlock <-try_to_wake_up
   <idle>-0       3dNh3    4us : sub_preempt_count <-_raw_spin_unlock
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 306f4f0..9d177b8 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2788,7 +2788,7 @@ static inline bool __must_check current_set_polling_and_test(void)
 
 	/*
 	 * Polling state must be visible before we test NEED_RESCHED,
-	 * paired by resched_task()
+	 * paired by resched_curr()
 	 */
 	smp_mb__after_atomic();
 
@@ -2806,7 +2806,7 @@ static inline bool __must_check current_clr_polling_and_test(void)
 
 	/*
 	 * Polling state must be visible before we test NEED_RESCHED,
-	 * paired by resched_task()
+	 * paired by resched_curr()
 	 */
 	smp_mb__after_atomic();
 
@@ -2838,7 +2838,7 @@ static inline void current_clr_polling(void)
 	 * TIF_NEED_RESCHED and the IPI handler, scheduler_ipi(), will also
 	 * fold.
 	 */
-	smp_mb(); /* paired with resched_task() */
+	smp_mb(); /* paired with resched_curr() */
 
 	preempt_fold_need_resched();
 }
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index ceea8d0..8da054f 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -587,30 +587,31 @@ static bool set_nr_if_polling(struct task_struct *p)
 #endif
 
 /*
- * resched_task - mark a task 'to be rescheduled now'.
+ * resched_curr - mark rq's current task 'to be rescheduled now'.
  *
  * On UP this means the setting of the need_resched flag, on SMP it
  * might also involve a cross-CPU call to trigger the scheduler on
  * the target CPU.
  */
-void resched_task(struct task_struct *p)
+void resched_curr(struct rq *rq)
 {
+	struct task_struct *curr = rq->curr;
 	int cpu;
 
-	lockdep_assert_held(&task_rq(p)->lock);
+	lockdep_assert_held(&rq->lock);
 
-	if (test_tsk_need_resched(p))
+	if (test_tsk_need_resched(curr))
 		return;
 
-	cpu = task_cpu(p);
+	cpu = rq->cpu;
 
 	if (cpu == smp_processor_id()) {
-		set_tsk_need_resched(p);
+		set_tsk_need_resched(curr);
 		set_preempt_need_resched();
 		return;
 	}
 
-	if (set_nr_and_not_polling(p))
+	if (set_nr_and_not_polling(curr))
 		smp_send_reschedule(cpu);
 	else
 		trace_sched_wake_idle_without_ipi(cpu);
@@ -623,7 +624,7 @@ void resched_cpu(int cpu)
 
 	if (!raw_spin_trylock_irqsave(&rq->lock, flags))
 		return;
-	resched_task(cpu_curr(cpu));
+	resched_curr(rq);
 	raw_spin_unlock_irqrestore(&rq->lock, flags);
 }
 
@@ -1029,7 +1030,7 @@ void check_preempt_curr(struct rq *rq, struct task_struct *p, int flags)
 			if (class == rq->curr->sched_class)
 				break;
 			if (class == p->sched_class) {
-				resched_task(rq->curr);
+				resched_curr(rq);
 				break;
 			}
 		}
@@ -3068,7 +3069,7 @@ void set_user_nice(struct task_struct *p, long nice)
 		 * lowered its priority, then reschedule its CPU:
 		 */
 		if (delta < 0 || (delta > 0 && task_running(rq, p)))
-			resched_task(rq->curr);
+			resched_curr(rq);
 	}
 out_unlock:
 	task_rq_unlock(rq, p, &flags);
@@ -4289,7 +4290,7 @@ int __sched yield_to(struct task_struct *p, bool preempt)
 		 * fairness.
 		 */
 		if (preempt && rq != p_rq)
-			resched_task(p_rq->curr);
+			resched_curr(p_rq);
 	}
 
 out_unlock:
@@ -7096,7 +7097,7 @@ static void normalize_task(struct rq *rq, struct task_struct *p)
 	__setscheduler(rq, p, &attr);
 	if (on_rq) {
 		enqueue_task(rq, p, 0);
-		resched_task(rq->curr);
+		resched_curr(rq);
 	}
 
 	check_class_changed(rq, p, prev_class, old_prio);
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index fc4f98b1..df0b77a 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -535,7 +535,7 @@ static enum hrtimer_restart dl_task_timer(struct hrtimer *timer)
 		if (task_has_dl_policy(rq->curr))
 			check_preempt_curr_dl(rq, p, 0);
 		else
-			resched_task(rq->curr);
+			resched_curr(rq);
 #ifdef CONFIG_SMP
 		/*
 		 * Queueing this task back might have overloaded rq,
@@ -634,7 +634,7 @@ static void update_curr_dl(struct rq *rq)
 			enqueue_task_dl(rq, curr, ENQUEUE_REPLENISH);
 
 		if (!is_leftmost(curr, &rq->dl))
-			resched_task(curr);
+			resched_curr(rq);
 	}
 
 	/*
@@ -964,7 +964,7 @@ static void check_preempt_equal_dl(struct rq *rq, struct task_struct *p)
 	    cpudl_find(&rq->rd->cpudl, p, NULL) != -1)
 		return;
 
-	resched_task(rq->curr);
+	resched_curr(rq);
 }
 
 static int pull_dl_task(struct rq *this_rq);
@@ -979,7 +979,7 @@ static void check_preempt_curr_dl(struct rq *rq, struct task_struct *p,
 				  int flags)
 {
 	if (dl_entity_preempt(&p->dl, &rq->curr->dl)) {
-		resched_task(rq->curr);
+		resched_curr(rq);
 		return;
 	}
 
@@ -1333,7 +1333,7 @@ static int push_dl_task(struct rq *rq)
 	if (dl_task(rq->curr) &&
 	    dl_time_before(next_task->dl.deadline, rq->curr->dl.deadline) &&
 	    rq->curr->nr_cpus_allowed > 1) {
-		resched_task(rq->curr);
+		resched_curr(rq);
 		return 0;
 	}
 
@@ -1373,7 +1373,7 @@ static int push_dl_task(struct rq *rq)
 	set_task_cpu(next_task, later_rq->cpu);
 	activate_task(later_rq, next_task, 0);
 
-	resched_task(later_rq->curr);
+	resched_curr(later_rq);
 
 	double_unlock_balance(rq, later_rq);
 
@@ -1632,14 +1632,14 @@ static void prio_changed_dl(struct rq *rq, struct task_struct *p,
 		 */
 		if (dl_time_before(rq->dl.earliest_dl.curr, p->dl.deadline) &&
 		    rq->curr == p)
-			resched_task(p);
+			resched_curr(rq);
 #else
 		/*
 		 * Again, we don't know if p has a earlier
 		 * or later deadline, so let's blindly set a
 		 * (maybe not needed) rescheduling point.
 		 */
-		resched_task(p);
+		resched_curr(rq);
 #endif /* CONFIG_SMP */
 	} else
 		switched_to_dl(rq, p);
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 1f9c457..64f294b 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2900,7 +2900,7 @@ check_preempt_tick(struct cfs_rq *cfs_rq, struct sched_entity *curr)
 	ideal_runtime = sched_slice(cfs_rq, curr);
 	delta_exec = curr->sum_exec_runtime - curr->prev_sum_exec_runtime;
 	if (delta_exec > ideal_runtime) {
-		resched_task(rq_of(cfs_rq)->curr);
+		resched_curr(rq_of(cfs_rq));
 		/*
 		 * The current task ran long enough, ensure it doesn't get
 		 * re-elected due to buddy favours.
@@ -2924,7 +2924,7 @@ check_preempt_tick(struct cfs_rq *cfs_rq, struct sched_entity *curr)
 		return;
 
 	if (delta > ideal_runtime)
-		resched_task(rq_of(cfs_rq)->curr);
+		resched_curr(rq_of(cfs_rq));
 }
 
 static void
@@ -3064,7 +3064,7 @@ entity_tick(struct cfs_rq *cfs_rq, struct sched_entity *curr, int queued)
 	 * validating it and just reschedule.
 	 */
 	if (queued) {
-		resched_task(rq_of(cfs_rq)->curr);
+		resched_curr(rq_of(cfs_rq));
 		return;
 	}
 	/*
@@ -3255,7 +3255,7 @@ static void __account_cfs_rq_runtime(struct cfs_rq *cfs_rq, u64 delta_exec)
 	 * hierarchy can be throttled
 	 */
 	if (!assign_cfs_rq_runtime(cfs_rq) && likely(cfs_rq->curr))
-		resched_task(rq_of(cfs_rq)->curr);
+		resched_curr(rq_of(cfs_rq));
 }
 
 static __always_inline
@@ -3411,7 +3411,7 @@ void unthrottle_cfs_rq(struct cfs_rq *cfs_rq)
 
 	/* determine whether we need to wake up potentially idle cpu */
 	if (rq->curr == rq->idle && rq->cfs.nr_running)
-		resched_task(rq->curr);
+		resched_curr(rq);
 }
 
 static u64 distribute_cfs_runtime(struct cfs_bandwidth *cfs_b,
@@ -3855,7 +3855,7 @@ static void hrtick_start_fair(struct rq *rq, struct task_struct *p)
 
 		if (delta < 0) {
 			if (rq->curr == p)
-				resched_task(p);
+				resched_curr(rq);
 			return;
 		}
 
@@ -4724,7 +4724,7 @@ static void check_preempt_wakeup(struct rq *rq, struct task_struct *p, int wake_
 	return;
 
 preempt:
-	resched_task(curr);
+	resched_curr(rq);
 	/*
 	 * Only set the backward buddy when the current task is still
 	 * on the rq. This can happen when a wakeup gets interleaved
@@ -7398,7 +7398,7 @@ static void task_fork_fair(struct task_struct *p)
 		 * 'current' within the tree based on its new key value.
 		 */
 		swap(curr->vruntime, se->vruntime);
-		resched_task(rq->curr);
+		resched_curr(rq);
 	}
 
 	se->vruntime -= cfs_rq->min_vruntime;
@@ -7423,7 +7423,7 @@ prio_changed_fair(struct rq *rq, struct task_struct *p, int oldprio)
 	 */
 	if (rq->curr == p) {
 		if (p->prio > oldprio)
-			resched_task(rq->curr);
+			resched_curr(rq);
 	} else
 		check_preempt_curr(rq, p, 0);
 }
@@ -7486,7 +7486,7 @@ static void switched_to_fair(struct rq *rq, struct task_struct *p)
 	 * if we can still preempt the current task.
 	 */
 	if (rq->curr == p)
-		resched_task(rq->curr);
+		resched_curr(rq);
 	else
 		check_preempt_curr(rq, p, 0);
 }
diff --git a/kernel/sched/idle_task.c b/kernel/sched/idle_task.c
index 879f2b7..67ad4e7 100644
--- a/kernel/sched/idle_task.c
+++ b/kernel/sched/idle_task.c
@@ -20,7 +20,7 @@ select_task_rq_idle(struct task_struct *p, int cpu, int sd_flag, int flags)
  */
 static void check_preempt_curr_idle(struct rq *rq, struct task_struct *p, int flags)
 {
-	resched_task(rq->idle);
+	resched_curr(rq);
 }
 
 static struct task_struct *
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index a490831..289eb94 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -463,9 +463,10 @@ static void dequeue_rt_entity(struct sched_rt_entity *rt_se);
 static void sched_rt_rq_enqueue(struct rt_rq *rt_rq)
 {
 	struct task_struct *curr = rq_of_rt_rq(rt_rq)->curr;
+	struct rq *rq = rq_of_rt_rq(rt_rq);
 	struct sched_rt_entity *rt_se;
 
-	int cpu = cpu_of(rq_of_rt_rq(rt_rq));
+	int cpu = cpu_of(rq);
 
 	rt_se = rt_rq->tg->rt_se[cpu];
 
@@ -476,7 +477,7 @@ static void sched_rt_rq_enqueue(struct rt_rq *rt_rq)
 			enqueue_rt_entity(rt_se, false);
 
 		if (rt_rq->highest_prio.curr < curr->prio)
-			resched_task(curr);
+			resched_curr(rq);
 	}
 }
 
@@ -566,7 +567,7 @@ static inline void sched_rt_rq_enqueue(struct rt_rq *rt_rq)
 		return;
 
 	enqueue_top_rt_rq(rt_rq);
-	resched_task(rq->curr);
+	resched_curr(rq);
 }
 
 static inline void sched_rt_rq_dequeue(struct rt_rq *rt_rq)
@@ -948,7 +949,7 @@ static void update_curr_rt(struct rq *rq)
 			raw_spin_lock(&rt_rq->rt_runtime_lock);
 			rt_rq->rt_time += delta_exec;
 			if (sched_rt_runtime_exceeded(rt_rq))
-				resched_task(curr);
+				resched_curr(rq);
 			raw_spin_unlock(&rt_rq->rt_runtime_lock);
 		}
 	}
@@ -1363,7 +1364,7 @@ static void check_preempt_equal_prio(struct rq *rq, struct task_struct *p)
 	 * to try and push current away:
 	 */
 	requeue_task_rt(rq, p, 1);
-	resched_task(rq->curr);
+	resched_curr(rq);
 }
 
 #endif /* CONFIG_SMP */
@@ -1374,7 +1375,7 @@ static void check_preempt_equal_prio(struct rq *rq, struct task_struct *p)
 static void check_preempt_curr_rt(struct rq *rq, struct task_struct *p, int flags)
 {
 	if (p->prio < rq->curr->prio) {
-		resched_task(rq->curr);
+		resched_curr(rq);
 		return;
 	}
 
@@ -1690,7 +1691,7 @@ static int push_rt_task(struct rq *rq)
 	 * just reschedule current.
 	 */
 	if (unlikely(next_task->prio < rq->curr->prio)) {
-		resched_task(rq->curr);
+		resched_curr(rq);
 		return 0;
 	}
 
@@ -1737,7 +1738,7 @@ static int push_rt_task(struct rq *rq)
 	activate_task(lowest_rq, next_task, 0);
 	ret = 1;
 
-	resched_task(lowest_rq->curr);
+	resched_curr(lowest_rq);
 
 	double_unlock_balance(rq, lowest_rq);
 
@@ -1936,7 +1937,7 @@ static void switched_from_rt(struct rq *rq, struct task_struct *p)
 		return;
 
 	if (pull_rt_task(rq))
-		resched_task(rq->curr);
+		resched_curr(rq);
 }
 
 void __init init_sched_rt_class(void)
@@ -1974,7 +1975,7 @@ static void switched_to_rt(struct rq *rq, struct task_struct *p)
 			check_resched = 0;
 #endif /* CONFIG_SMP */
 		if (check_resched && p->prio < rq->curr->prio)
-			resched_task(rq->curr);
+			resched_curr(rq);
 	}
 }
 
@@ -2003,11 +2004,11 @@ prio_changed_rt(struct rq *rq, struct task_struct *p, int oldprio)
 		 * Only reschedule if p is still on the same runqueue.
 		 */
 		if (p->prio > rq->rt.highest_prio.curr && rq->curr == p)
-			resched_task(p);
+			resched_curr(rq);
 #else
 		/* For UP simply resched on drop of prio */
 		if (oldprio < p->prio)
-			resched_task(p);
+			resched_curr(rq);
 #endif /* CONFIG_SMP */
 	} else {
 		/*
@@ -2016,7 +2017,7 @@ prio_changed_rt(struct rq *rq, struct task_struct *p, int oldprio)
 		 * then reschedule.
 		 */
 		if (p->prio < rq->curr->prio)
-			resched_task(rq->curr);
+			resched_curr(rq);
 	}
 }
 
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index eb85676..8283c4d 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1196,7 +1196,7 @@ extern void init_sched_rt_class(void);
 extern void init_sched_fair_class(void);
 extern void init_sched_dl_class(void);
 
-extern void resched_task(struct task_struct *p);
+extern void resched_curr(struct rq *rq);
 extern void resched_cpu(int cpu);
 
 extern struct rt_bandwidth def_rt_bandwidth;

