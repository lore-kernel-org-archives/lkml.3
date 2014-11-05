Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755562AbaKEPtX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 10:49:23 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:54227 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755183AbaKEPtT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 10:49:19 -0500
From: "pang.xunlei" <pang.xunlei@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Juri Lelli <juri.lelli@gmail.com>,
        "pang.xunlei" <pang.xunlei@linaro.org>
Subject: [PATCH v3 7/7] sched/deadline: Modify cpudl_find() for more cases of electing best_cpu
Date: Wed,  5 Nov 2014 23:48:26 +0800
Message-Id: <1415202506-7800-7-git-send-email-pang.xunlei@linaro.org>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1415202506-7800-1-git-send-email-pang.xunlei@linaro.org>
References: <1415202506-7800-1-git-send-email-pang.xunlei@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a runqueue runs out of DL tasks, it may have RT tasks or non-RT
tasks or just idle. It'd be better to push the DL task to an idle cpu
or non-RT cpu if there is any.

Adds idle_enter_dl()/idle_exit_dl() to detect idle cases.
Adds rt_enter_dl()/rt_exit_dl() to detect non-RT cases.

Use the same thought as tackling RT in the former patch.

Signed-off-by: pang.xunlei <pang.xunlei@linaro.org>
---
 kernel/sched/cpudeadline.c | 80 +++++++++++++++++++++++++++++++++++++---------
 kernel/sched/cpudeadline.h | 13 ++++++--
 kernel/sched/deadline.c    | 32 ++++++++++++++++---
 kernel/sched/idle_task.c   |  2 ++
 kernel/sched/rt.c          |  7 ++++
 kernel/sched/sched.h       | 11 +++++++
 6 files changed, 123 insertions(+), 22 deletions(-)

diff --git a/kernel/sched/cpudeadline.c b/kernel/sched/cpudeadline.c
index 72a3da3..8254310 100644
--- a/kernel/sched/cpudeadline.c
+++ b/kernel/sched/cpudeadline.c
@@ -98,7 +98,7 @@ static inline int cpudl_maximum(struct cpudl *cp)
  * @cp: the cpudl max-heap context
  * @p: the task
  * @later_mask: a mask used to filter cpus, also used to fill
- *     in with the selected CPUs if set_flag is set. Not NULL.
+ *  back in with the selected CPUs if set_flag is set. Not NULL.
  * @set_flag: a flag to determine if should set the later_mask.
  *
  * Returns: (int)bool - CPUs were found
@@ -110,7 +110,15 @@ int cpudl_find(struct cpudl *cp, struct task_struct *p,
 	const struct sched_dl_entity *dl_se = &p->dl;
 
 
-	if (cpumask_and(&tmp_mask, later_mask, cp->free_cpus)) {
+	if (cpumask_and(&tmp_mask, later_mask, cp->idle_cpus)) {
+		if (set_flag)
+			cpumask_copy(later_mask, &tmp_mask);
+		return 1;
+	} else if (cpumask_and(&tmp_mask, later_mask, cp->freert_cpus)) {
+		if (set_flag)
+			cpumask_copy(later_mask, &tmp_mask);
+		return 1;
+	} else if (cpumask_and(&tmp_mask, later_mask, cp->freedl_cpus)) {
 		if (set_flag)
 			cpumask_copy(later_mask, &tmp_mask);
 		return 1;
@@ -127,21 +135,47 @@ int cpudl_find(struct cpudl *cp, struct task_struct *p,
  * @cp: the cpudl max-heap context
  * @cpu: the target cpu
  * @dl: the new earliest deadline for this cpu
- *
+ * @set_flags: CPUDL_SET_XXX, CPUDL_CLEAR_XXX
  * Notes: assumes cpu_rq(cpu)->lock is locked
  *
  * Returns: (void)
  */
-void cpudl_set(struct cpudl *cp, int cpu, u64 dl, int is_valid)
+void cpudl_set(struct cpudl *cp, int cpu, u64 dl, int set_flags)
 {
 	int old_idx, new_cpu;
 	unsigned long flags;
 
 	WARN_ON(!cpu_present(cpu));
 
+	/* We can do this percpu operation without spinlock */
+	switch (set_flags) {
+	case CPUDL_SET_IDLE:
+		cpumask_set_cpu(cpu, cp->idle_cpus);
+		/* sync for cpudl_find() */
+		smp_rmb();
+		return;
+	case CPUDL_CLEAR_IDLE:
+		cpumask_clear_cpu(cpu, cp->idle_cpus);
+		/* sync for cpudl_find() */
+		smp_rmb();
+		return;
+	case CPUDL_SET_FREERT:
+		cpumask_set_cpu(cpu, cp->freert_cpus);
+		/* sync for cpudl_find() */
+		smp_rmb();
+		return;
+	case CPUDL_CLEAR_FREERT:
+		cpumask_clear_cpu(cpu, cp->freert_cpus);
+		/* sync for cpudl_find() */
+		smp_rmb();
+		return;
+	default:
+		break;
+	}
+
 	raw_spin_lock_irqsave(&cp->lock, flags);
 	old_idx = cp->elements[cpu].idx;
-	if (!is_valid) {
+	if (set_flags == CPUDL_SET_FREEDL) {
 		/* remove item */
 		if (old_idx == IDX_INVALID) {
 			/*
@@ -163,8 +197,8 @@ void cpudl_set(struct cpudl *cp, int cpu, u64 dl, int is_valid)
 			cpudl_exchange(cp, old_idx, parent(old_idx));
 			old_idx = parent(old_idx);
 		}
-		cpumask_set_cpu(cpu, cp->free_cpus);
-                cpudl_heapify(cp, old_idx);
+		cpumask_set_cpu(cpu, cp->freedl_cpus);
+		cpudl_heapify(cp, old_idx);
 
 		goto out;
 	}
@@ -175,7 +209,7 @@ void cpudl_set(struct cpudl *cp, int cpu, u64 dl, int is_valid)
 		cp->elements[cp->size - 1].cpu = cpu;
 		cp->elements[cpu].idx = cp->size - 1;
 		cpudl_change_key(cp, cp->size - 1, dl);
-		cpumask_clear_cpu(cpu, cp->free_cpus);
+		cpumask_clear_cpu(cpu, cp->freedl_cpus);
 	} else {
 		cpudl_change_key(cp, old_idx, dl);
 	}
@@ -200,19 +234,33 @@ int cpudl_init(struct cpudl *cp)
 			       sizeof(struct cpudl_item),
 			       GFP_KERNEL);
 	if (!cp->elements)
-		return -ENOMEM;
+		goto out;
+
+	if (!alloc_cpumask_var(&cp->freedl_cpus, GFP_KERNEL))
+		goto free_elements;
+
+	if (!zalloc_cpumask_var(&cp->freert_cpus, GFP_KERNEL))
+		goto free_freedl_cpus;
+
+	if (!zalloc_cpumask_var(&cp->idle_cpus, GFP_KERNEL))
+		goto free_freert_cpus;
 
-	if (!alloc_cpumask_var(&cp->free_cpus, GFP_KERNEL)) {
-		kfree(cp->elements);
-		return -ENOMEM;
-	}
 
 	for_each_possible_cpu(i)
 		cp->elements[i].idx = IDX_INVALID;
 
-	cpumask_setall(cp->free_cpus);
+	cpumask_setall(cp->freedl_cpus);
 
 	return 0;
+
+free_freert_cpus:
+	kfree(cp->freert_cpus);
+free_freedl_cpus:
+	kfree(cp->freedl_cpus);
+free_elements:
+	kfree(cp->elements);
+out:
+	return -ENOMEM;
 }
 
 /*
@@ -221,6 +269,8 @@ int cpudl_init(struct cpudl *cp)
  */
 void cpudl_cleanup(struct cpudl *cp)
 {
-	free_cpumask_var(cp->free_cpus);
+	free_cpumask_var(cp->freedl_cpus);
+	free_cpumask_var(cp->freert_cpus);
+	free_cpumask_var(cp->idle_cpus);
 	kfree(cp->elements);
 }
diff --git a/kernel/sched/cpudeadline.h b/kernel/sched/cpudeadline.h
index dfdf594..20ebfffe 100644
--- a/kernel/sched/cpudeadline.h
+++ b/kernel/sched/cpudeadline.h
@@ -5,6 +5,13 @@
 
 #define IDX_INVALID     -1
 
+#define CPUDL_SET_DL		1 /* set deadline value, clear freedl_cpus */
+#define CPUDL_SET_FREEDL	2 /* set freedl_cpus */
+#define CPUDL_SET_FREERT	3 /* set freert_cpus */
+#define CPUDL_CLEAR_FREERT	4 /* clear freert_cpus */
+#define CPUDL_SET_IDLE		5 /* set idle_cpus */
+#define CPUDL_CLEAR_IDLE	6 /* clear idle_cpus */
+
 struct cpudl_item {
 	u64 dl;
 	int cpu;
@@ -14,7 +21,9 @@ struct cpudl_item {
 struct cpudl {
 	raw_spinlock_t lock;
 	int size;
-	cpumask_var_t free_cpus;
+	cpumask_var_t idle_cpus;
+	cpumask_var_t freert_cpus;
+	cpumask_var_t freedl_cpus;
 	struct cpudl_item *elements;
 };
 
@@ -22,7 +31,7 @@ struct cpudl {
 #ifdef CONFIG_SMP
 int cpudl_find(struct cpudl *cp, struct task_struct *p,
 	       struct cpumask *later_mask, int set_flag);
-void cpudl_set(struct cpudl *cp, int cpu, u64 dl, int is_valid);
+void cpudl_set(struct cpudl *cp, int cpu, u64 dl, int set_flags);
 int cpudl_init(struct cpudl *cp);
 void cpudl_cleanup(struct cpudl *cp);
 #endif /* CONFIG_SMP */
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index ddb6185..dc021a1 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -665,6 +665,26 @@ static void update_curr_dl(struct rq *rq)
 
 #ifdef CONFIG_SMP
 
+void idle_enter_dl(struct rq *this_rq)
+{
+	cpudl_set(&this_rq->rd->cpudl, this_rq->cpu, 0, CPUDL_SET_IDLE);
+}
+
+void idle_exit_dl(struct rq *this_rq)
+{
+	cpudl_set(&this_rq->rd->cpudl, this_rq->cpu, 0, CPUDL_CLEAR_IDLE);
+}
+
+void rt_enter_dl(struct rq *this_rq)
+{
+	cpudl_set(&this_rq->rd->cpudl, this_rq->cpu, 0, CPUDL_CLEAR_FREERT);
+}
+
+void rt_exit_dl(struct rq *this_rq)
+{
+	cpudl_set(&this_rq->rd->cpudl, this_rq->cpu, 0, CPUDL_SET_FREERT);
+}
+
 static struct task_struct *pick_next_earliest_dl_task(struct rq *rq, int cpu);
 
 static inline u64 next_deadline(struct rq *rq)
@@ -691,7 +711,7 @@ static void inc_dl_deadline(struct dl_rq *dl_rq, u64 deadline)
 		 */
 		dl_rq->earliest_dl.next = dl_rq->earliest_dl.curr;
 		dl_rq->earliest_dl.curr = deadline;
-		cpudl_set(&rq->rd->cpudl, rq->cpu, deadline, 1);
+		cpudl_set(&rq->rd->cpudl, rq->cpu, deadline, CPUDL_SET_DL);
 	} else if (dl_rq->earliest_dl.next == 0 ||
 		   dl_time_before(deadline, dl_rq->earliest_dl.next)) {
 		/*
@@ -715,7 +735,7 @@ static void dec_dl_deadline(struct dl_rq *dl_rq, u64 deadline)
 	if (!dl_rq->dl_nr_running) {
 		dl_rq->earliest_dl.curr = 0;
 		dl_rq->earliest_dl.next = 0;
-		cpudl_set(&rq->rd->cpudl, rq->cpu, 0, 0);
+		cpudl_set(&rq->rd->cpudl, rq->cpu, 0, CPUDL_SET_FREEDL);
 	} else {
 		struct rb_node *leftmost = dl_rq->rb_leftmost;
 		struct sched_dl_entity *entry;
@@ -723,7 +743,8 @@ static void dec_dl_deadline(struct dl_rq *dl_rq, u64 deadline)
 		entry = rb_entry(leftmost, struct sched_dl_entity, rb_node);
 		dl_rq->earliest_dl.curr = entry->deadline;
 		dl_rq->earliest_dl.next = next_deadline(rq);
-		cpudl_set(&rq->rd->cpudl, rq->cpu, entry->deadline, 1);
+		cpudl_set(&rq->rd->cpudl, rq->cpu,
+					entry->deadline, CPUDL_SET_DL);
 	}
 }
 
@@ -1560,7 +1581,8 @@ static void rq_online_dl(struct rq *rq)
 		dl_set_overload(rq);
 
 	if (rq->dl.dl_nr_running > 0)
-		cpudl_set(&rq->rd->cpudl, rq->cpu, rq->dl.earliest_dl.curr, 1);
+		cpudl_set(&rq->rd->cpudl, rq->cpu,
+					rq->dl.earliest_dl.curr, CPUDL_SET_DL);
 }
 
 /* Assumes rq->lock is held */
@@ -1569,7 +1591,7 @@ static void rq_offline_dl(struct rq *rq)
 	if (rq->dl.overloaded)
 		dl_clear_overload(rq);
 
-	cpudl_set(&rq->rd->cpudl, rq->cpu, 0, 0);
+	cpudl_set(&rq->rd->cpudl, rq->cpu, 0, CPUDL_SET_FREEDL);
 }
 
 void init_sched_dl_class(void)
diff --git a/kernel/sched/idle_task.c b/kernel/sched/idle_task.c
index e053347..7838e56 100644
--- a/kernel/sched/idle_task.c
+++ b/kernel/sched/idle_task.c
@@ -26,6 +26,7 @@ static void check_preempt_curr_idle(struct rq *rq, struct task_struct *p, int fl
 static struct task_struct *
 pick_next_task_idle(struct rq *rq, struct task_struct *prev)
 {
+	idle_enter_dl(rq);
 	idle_enter_rt(rq);
 
 	put_prev_task(rq, prev);
@@ -49,6 +50,7 @@ dequeue_task_idle(struct rq *rq, struct task_struct *p, int flags)
 
 static void put_prev_task_idle(struct rq *rq, struct task_struct *prev)
 {
+	idle_exit_dl(rq);
 	idle_exit_rt(rq);
 	idle_exit_fair(rq);
 	rq_last_tick_reset(rq);
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 49164f1..ee49b94 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -1484,6 +1484,9 @@ pick_next_task_rt(struct rq *rq, struct task_struct *prev)
 	if (!rt_rq->rt_queued)
 		return NULL;
 
+	if (prev->sched_class != &rt_sched_class)
+		rt_enter_dl(rq);
+
 	put_prev_task(rq, prev);
 
 	p = _pick_next_task_rt(rq);
@@ -1498,6 +1501,10 @@ pick_next_task_rt(struct rq *rq, struct task_struct *prev)
 
 static void put_prev_task_rt(struct rq *rq, struct task_struct *p)
 {
+	/* Neglect stop preempt. As for dl preempt, doesn't matter */
+	if (rq->curr->sched_class != &rt_sched_class)
+		rt_exit_dl(rq);
+
 	update_curr_rt(rq);
 
 	/*
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index cc603fa..b76dfef 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1162,6 +1162,12 @@ extern void update_group_capacity(struct sched_domain *sd, int cpu);
 
 extern void trigger_load_balance(struct rq *rq);
 
+extern void rt_enter_dl(struct rq *this_rq);
+extern void rt_exit_dl(struct rq *this_rq);
+
+extern void idle_enter_dl(struct rq *this_rq);
+extern void idle_exit_dl(struct rq *this_rq);
+
 extern void idle_enter_rt(struct rq *this_rq);
 extern void idle_exit_rt(struct rq *this_rq);
 
@@ -1169,6 +1175,11 @@ extern void idle_enter_fair(struct rq *this_rq);
 extern void idle_exit_fair(struct rq *this_rq);
 
 #else
+static inline void rt_enter_dl(struct rq *rq) { }
+static inline void rt_exit_dl(struct rq *rq) { }
+
+static inline void idle_enter_dl(struct rq *rq) { }
+static inline void idle_exit_dl(struct rq *rq) { }
 
 static inline void idle_enter_rt(struct rq *rq) { }
 static inline void idle_exit_rt(struct rq *rq) { }
-- 
2.1.0

