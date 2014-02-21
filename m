Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756197AbaBUVdE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 16:33:04 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59339 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754457AbaBUVc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 16:32:59 -0500
Date: Fri, 21 Feb 2014 13:32:24 -0800
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-58b067579d824034dd1fa28b5fe384cd85d7adbc@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, raistlin@linux.it,
        tglx@linutronix.de, bigeasy@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com,
        linux-kernel@vger.kernel.org, peterz@infradead.org, raistlin@linux.it,
        tglx@linutronix.de, bigeasy@linutronix.de
In-Reply-To: <1391803122-4425-7-git-send-email-bigeasy@linutronix.de>
References: <1391803122-4425-7-git-send-email-bigeasy@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Consider pi boosting in setscheduler
Git-Commit-ID: 58b067579d824034dd1fa28b5fe384cd85d7adbc
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  58b067579d824034dd1fa28b5fe384cd85d7adbc
Gitweb:     http://git.kernel.org/tip/58b067579d824034dd1fa28b5fe384cd85d7adbc
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Fri, 7 Feb 2014 20:58:42 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 21 Feb 2014 21:43:19 +0100

sched: Consider pi boosting in setscheduler

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

[bigeasy: rebase ontop of v3.14-rc1]
Cc: stable@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Dario Faggioli <raistlin@linux.it>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1391803122-4425-7-git-send-email-bigeasy@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/sched/rt.h |  7 +++++++
 kernel/locking/rtmutex.c | 12 ++++++++++++
 kernel/sched/core.c      | 41 ++++++++++++++++++++++++++++++-----------
 3 files changed, 49 insertions(+), 11 deletions(-)

diff --git a/include/linux/sched/rt.h b/include/linux/sched/rt.h
index f7453d4..6341f5b 100644
--- a/include/linux/sched/rt.h
+++ b/include/linux/sched/rt.h
@@ -18,6 +18,7 @@ static inline int rt_task(struct task_struct *p)
 #ifdef CONFIG_RT_MUTEXES
 extern int rt_mutex_getprio(struct task_struct *p);
 extern void rt_mutex_setprio(struct task_struct *p, int prio);
+extern int rt_mutex_check_prio(struct task_struct *task, int newprio);
 extern struct task_struct *rt_mutex_get_top_task(struct task_struct *task);
 extern void rt_mutex_adjust_pi(struct task_struct *p);
 static inline bool tsk_is_pi_blocked(struct task_struct *tsk)
@@ -29,6 +30,12 @@ static inline int rt_mutex_getprio(struct task_struct *p)
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
index a41d239..c1687de 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2910,7 +2910,8 @@ EXPORT_SYMBOL(sleep_on_timeout);
  * This function changes the 'effective' priority of a task. It does
  * not touch ->normal_prio like __setscheduler().
  *
- * Used by the rt_mutex code to implement priority inheritance logic.
+ * Used by the rt_mutex code to implement priority inheritance
+ * logic. Call site only calls if the priority of the task changed.
  */
 void rt_mutex_setprio(struct task_struct *p, int prio)
 {
@@ -3179,9 +3180,8 @@ __setparam_dl(struct task_struct *p, const struct sched_attr *attr)
 	dl_se->dl_new = 1;
 }
 
-/* Actually do priority change: must hold pi & rq lock. */
-static void __setscheduler(struct rq *rq, struct task_struct *p,
-			   const struct sched_attr *attr)
+static void __setscheduler_params(struct task_struct *p,
+		const struct sched_attr *attr)
 {
 	int policy = attr->sched_policy;
 
@@ -3201,9 +3201,14 @@ static void __setscheduler(struct rq *rq, struct task_struct *p,
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
@@ -3211,8 +3216,6 @@ static void __setscheduler(struct rq *rq, struct task_struct *p,
 		p->sched_class = &rt_sched_class;
 	else
 		p->sched_class = &fair_sched_class;
-
-	set_load_weight(p);
 }
 
 static void
@@ -3265,6 +3268,7 @@ static int __sched_setscheduler(struct task_struct *p,
 				const struct sched_attr *attr,
 				bool user)
 {
+	int newprio = MAX_RT_PRIO - 1 - attr->sched_priority;
 	int retval, oldprio, oldpolicy = -1, on_rq, running;
 	int policy = attr->sched_policy;
 	unsigned long flags;
@@ -3435,6 +3439,24 @@ change:
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
@@ -3442,9 +3464,6 @@ change:
 	if (running)
 		p->sched_class->put_prev_task(rq, p);
 
-	p->sched_reset_on_fork = reset_on_fork;
-
-	oldprio = p->prio;
 	prev_class = p->sched_class;
 	__setscheduler(rq, p, attr);
 
