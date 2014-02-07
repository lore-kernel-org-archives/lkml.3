Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753586AbaBGT7X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 14:59:23 -0500
Received: from www.linutronix.de ([62.245.132.108]:48267 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752376AbaBGT7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 14:59:21 -0500
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Dario Faggioli <raistlin@linux.it>, stable@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 6/6] sched: Consider pi boosting in setscheduler
Date: Fri,  7 Feb 2014 20:58:42 +0100
Message-Id: <1391803122-4425-7-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.9.rc1
In-Reply-To: <1391803122-4425-1-git-send-email-bigeasy@linutronix.de>
References: <1391803122-4425-1-git-send-email-bigeasy@linutronix.de>
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

If a PI boosted task policy/priority is modified by a setscheduler()
call we unconditionally dequeue and requeue the task if it is on the
runqueue even if the new priority is lower than the current effective
boosted priority. This can result in undesired reordering of the
priority bucket list.

If the new priority is less or equal than the current effective we
just store the new parameters in the task struct and leave the
scheduler class and the runqueue untouched. This is handled when the
task deboosts itself. Only if the new priority is higher than the
effective boosted priority we apply the change immediately.

Cc: Dario Faggioli <raistlin@linux.it>
Cc: stable@vger.kernel.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
[bigeasy: rebase ontop of v3.14-rc1]
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 include/linux/sched/rt.h |  7 +++++++
 kernel/locking/rtmutex.c | 12 ++++++++++++
 kernel/sched/core.c      | 41 ++++++++++++++++++++++++++++++-----------
 3 files changed, 49 insertions(+), 11 deletions(-)

diff --git a/include/linux/sched/rt.h b/include/linux/sched/rt.h
index 34e4ebe..72c9f3a 100644
--- a/include/linux/sched/rt.h
+++ b/include/linux/sched/rt.h
@@ -35,6 +35,7 @@ static inline int rt_task(struct task_struct *p)
 #ifdef CONFIG_RT_MUTEXES
 extern int rt_mutex_getprio(struct task_struct *p);
 extern void rt_mutex_setprio(struct task_struct *p, int prio);
+extern int rt_mutex_check_prio(struct task_struct *task, int newprio);
 extern struct task_struct *rt_mutex_get_top_task(struct task_struct *task);
 extern void rt_mutex_adjust_pi(struct task_struct *p);
 static inline bool tsk_is_pi_blocked(struct task_struct *tsk)
@@ -46,6 +47,12 @@ static inline int rt_mutex_getprio(struct task_struct *p)
 {
 	return p->normal_prio;
 }
+
+static inline int rt_mutex_check_prio(struct task_struct *task, int newprio)
+{
+	return 0;
+}
+
 static inline struct task_struct *rt_mutex_get_top_task(struct task_struct *task)
 {
 	return NULL;
diff --git a/kernel/locking/rtmutex.c b/kernel/locking/rtmutex.c
index 2e960a2..aa4dff0 100644
--- a/kernel/locking/rtmutex.c
+++ b/kernel/locking/rtmutex.c
@@ -213,6 +213,18 @@ struct task_struct *rt_mutex_get_top_task(struct task_struct *task)
 }
 
 /*
+ * Called by sched_setscheduler() to check whether the priority change
+ * is overruled by a possible priority boosting.
+ */
+int rt_mutex_check_prio(struct task_struct *task, int newprio)
+{
+	if (!task_has_pi_waiters(task))
+		return 0;
+
+	return task_top_pi_waiter(task)->task->prio <= newprio;
+}
+
+/*
  * Adjust the priority of a task, after its pi_waiters got modified.
  *
  * This can be both boosting and unboosting. task->pi_lock must be held.
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index d0e7825..6dda083 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2920,7 +2920,8 @@ EXPORT_SYMBOL(sleep_on_timeout);
  * This function changes the 'effective' priority of a task. It does
  * not touch ->normal_prio like __setscheduler().
  *
- * Used by the rt_mutex code to implement priority inheritance logic.
+ * Used by the rt_mutex code to implement priority inheritance
+ * logic. Call site only calls if the priority of the task changed.
  */
 void rt_mutex_setprio(struct task_struct *p, int prio)
 {
@@ -3201,9 +3202,8 @@ __setparam_dl(struct task_struct *p, const struct sched_attr *attr)
 	dl_se->dl_new = 1;
 }
 
-/* Actually do priority change: must hold pi & rq lock. */
-static void __setscheduler(struct rq *rq, struct task_struct *p,
-			   const struct sched_attr *attr)
+static void __setscheduler_params(struct task_struct *p,
+		const struct sched_attr *attr)
 {
 	int policy = attr->sched_policy;
 
@@ -3223,9 +3223,14 @@ static void __setscheduler(struct rq *rq, struct task_struct *p,
 	 * getparam()/getattr() don't report silly values for !rt tasks.
 	 */
 	p->rt_priority = attr->sched_priority;
+	set_load_weight(p);
+}
 
-	p->normal_prio = normal_prio(p);
-	p->prio = rt_mutex_getprio(p);
+/* Actually do priority change: must hold pi & rq lock. */
+static void __setscheduler(struct rq *rq, struct task_struct *p,
+			   const struct sched_attr *attr)
+{
+	__setscheduler_params(p, attr);
 
 	if (dl_prio(p->prio))
 		p->sched_class = &dl_sched_class;
@@ -3233,8 +3238,6 @@ static void __setscheduler(struct rq *rq, struct task_struct *p,
 		p->sched_class = &rt_sched_class;
 	else
 		p->sched_class = &fair_sched_class;
-
-	set_load_weight(p);
 }
 
 static void
@@ -3287,6 +3290,7 @@ static int __sched_setscheduler(struct task_struct *p,
 				const struct sched_attr *attr,
 				bool user)
 {
+	int newprio = MAX_RT_PRIO - 1 - attr->sched_priority;
 	int retval, oldprio, oldpolicy = -1, on_rq, running;
 	int policy = attr->sched_policy;
 	unsigned long flags;
@@ -3457,6 +3461,24 @@ static int __sched_setscheduler(struct task_struct *p,
 		return -EBUSY;
 	}
 
+	p->sched_reset_on_fork = reset_on_fork;
+	oldprio = p->prio;
+
+	/*
+	 * Special case for priority boosted tasks.
+	 *
+	 * If the new priority is lower or equal (user space view)
+	 * than the current (boosted) priority, we just store the new
+	 * normal parameters and do not touch the scheduler class and
+	 * the runqueue. This will be done when the task deboost
+	 * itself.
+	 */
+	if (rt_mutex_check_prio(p, newprio)) {
+		__setscheduler_params(p, attr);
+		task_rq_unlock(rq, p, &flags);
+		return 0;
+	}
+
 	on_rq = p->on_rq;
 	running = task_current(rq, p);
 	if (on_rq)
@@ -3464,9 +3486,6 @@ static int __sched_setscheduler(struct task_struct *p,
 	if (running)
 		p->sched_class->put_prev_task(rq, p);
 
-	p->sched_reset_on_fork = reset_on_fork;
-
-	oldprio = p->prio;
 	prev_class = p->sched_class;
 	__setscheduler(rq, p, attr);
 
-- 
1.9.rc1

