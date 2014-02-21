Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755901AbaBUVbm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 16:31:42 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59275 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755824AbaBUVbj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 16:31:39 -0500
Date: Fri, 21 Feb 2014 13:31:05 -0800
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-nnzddp5c4fijyzzxxrwlxghf@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        rostedt@goodmis.org, peterz@infradead.org, tglx@linutronix.de,
        juri.lelli@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, peterz@infradead.org, tglx@linutronix.de,
        juri.lelli@gmail.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Remove some #ifdeffery
Git-Commit-ID: dc87734106bb6e97c92d8bd81f261fb71976ec2c
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

Commit-ID:  dc87734106bb6e97c92d8bd81f261fb71976ec2c
Gitweb:     http://git.kernel.org/tip/dc87734106bb6e97c92d8bd81f261fb71976ec2c
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Wed, 12 Feb 2014 15:47:29 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 21 Feb 2014 21:43:18 +0100

sched: Remove some #ifdeffery

Remove a few gratuitous #ifdefs in pick_next_task*().

Cc: Ingo Molnar <mingo@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Juri Lelli <juri.lelli@gmail.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/n/tip-nnzddp5c4fijyzzxxrwlxghf@git.kernel.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/sched/deadline.c  | 31 +++++++++++++++++++++++++------
 kernel/sched/idle_task.c |  4 ----
 kernel/sched/rt.c        | 41 ++++++++++++++++++++++++++++++-----------
 kernel/sched/sched.h     |  5 +++++
 4 files changed, 60 insertions(+), 21 deletions(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index bfeb84e..3185b77 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -214,6 +214,16 @@ static inline int has_pushable_dl_tasks(struct rq *rq)
 
 static int push_dl_task(struct rq *rq);
 
+static inline bool need_pull_dl_task(struct rq *rq, struct task_struct *prev)
+{
+	return dl_task(prev);
+}
+
+static inline void set_post_schedule(struct rq *rq)
+{
+	rq->post_schedule = has_pushable_dl_tasks(rq);
+}
+
 #else
 
 static inline
@@ -236,6 +246,19 @@ void dec_dl_migration(struct sched_dl_entity *dl_se, struct dl_rq *dl_rq)
 {
 }
 
+static inline bool need_pull_dl_task(struct rq *rq, struct task_struct *prev)
+{
+	return false;
+}
+
+static inline int pull_dl_task(struct rq *rq)
+{
+	return 0;
+}
+
+static inline void set_post_schedule(struct rq *rq)
+{
+}
 #endif /* CONFIG_SMP */
 
 static void enqueue_task_dl(struct rq *rq, struct task_struct *p, int flags);
@@ -1000,10 +1023,8 @@ struct task_struct *pick_next_task_dl(struct rq *rq, struct task_struct *prev)
 
 	dl_rq = &rq->dl;
 
-#ifdef CONFIG_SMP
-	if (dl_task(prev))
+	if (need_pull_dl_task(rq, prev))
 		pull_dl_task(rq);
-#endif
 
 	if (unlikely(!dl_rq->dl_nr_running))
 		return NULL;
@@ -1024,9 +1045,7 @@ struct task_struct *pick_next_task_dl(struct rq *rq, struct task_struct *prev)
 		start_hrtick_dl(rq, p);
 #endif
 
-#ifdef CONFIG_SMP
-	rq->post_schedule = has_pushable_dl_tasks(rq);
-#endif /* CONFIG_SMP */
+	set_post_schedule(rq);
 
 	return p;
 }
diff --git a/kernel/sched/idle_task.c b/kernel/sched/idle_task.c
index 53ff9e7..1f37258 100644
--- a/kernel/sched/idle_task.c
+++ b/kernel/sched/idle_task.c
@@ -29,9 +29,7 @@ pick_next_task_idle(struct rq *rq, struct task_struct *prev)
 	put_prev_task(rq, prev);
 
 	schedstat_inc(rq, sched_goidle);
-#ifdef CONFIG_SMP
 	idle_enter_fair(rq);
-#endif
 	return rq->idle;
 }
 
@@ -50,10 +48,8 @@ dequeue_task_idle(struct rq *rq, struct task_struct *p, int flags)
 
 static void put_prev_task_idle(struct rq *rq, struct task_struct *prev)
 {
-#ifdef CONFIG_SMP
 	idle_exit_fair(rq);
 	rq_last_tick_reset(rq);
-#endif
 }
 
 static void task_tick_idle(struct rq *rq, struct task_struct *curr, int queued)
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 65c2d68..3e488ca 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -231,6 +231,12 @@ int alloc_rt_sched_group(struct task_group *tg, struct task_group *parent)
 
 static int pull_rt_task(struct rq *this_rq);
 
+static inline bool need_pull_rt_task(struct rq *rq, struct task_struct *prev)
+{
+	/* Try to pull RT tasks here if we lower this rq's prio */
+	return rq->rt.highest_prio.curr > prev->prio;
+}
+
 static inline int rt_overloaded(struct rq *rq)
 {
 	return atomic_read(&rq->rd->rto_count);
@@ -317,6 +323,15 @@ static inline int has_pushable_tasks(struct rq *rq)
 	return !plist_head_empty(&rq->rt.pushable_tasks);
 }
 
+static inline void set_post_schedule(struct rq *rq)
+{
+	/*
+	 * We detect this state here so that we can avoid taking the RQ
+	 * lock again later if there is no need to push
+	 */
+	rq->post_schedule = has_pushable_tasks(rq);
+}
+
 static void enqueue_pushable_task(struct rq *rq, struct task_struct *p)
 {
 	plist_del(&p->pushable_tasks, &rq->rt.pushable_tasks);
@@ -361,6 +376,19 @@ void dec_rt_migration(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
 {
 }
 
+static inline bool need_pull_rt_task(struct rq *rq, struct task_struct *prev)
+{
+	return false;
+}
+
+static inline int pull_rt_task(struct rq *this_rq)
+{
+	return 0;
+}
+
+static inline void set_post_schedule(struct rq *rq)
+{
+}
 #endif /* CONFIG_SMP */
 
 static inline int on_rt_rq(struct sched_rt_entity *rt_se)
@@ -1332,11 +1360,8 @@ pick_next_task_rt(struct rq *rq, struct task_struct *prev)
 	struct task_struct *p;
 	struct rt_rq *rt_rq = &rq->rt;
 
-#ifdef CONFIG_SMP
-	/* Try to pull RT tasks here if we lower this rq's prio */
-	if (rq->rt.highest_prio.curr > prev->prio)
+	if (need_pull_rt_task(rq, prev))
 		pull_rt_task(rq);
-#endif
 
 	if (!rt_rq->rt_nr_running)
 		return NULL;
@@ -1352,13 +1377,7 @@ pick_next_task_rt(struct rq *rq, struct task_struct *prev)
 	if (p)
 		dequeue_pushable_task(rq, p);
 
-#ifdef CONFIG_SMP
-	/*
-	 * We detect this state here so that we can avoid taking the RQ
-	 * lock again later if there is no need to push
-	 */
-	rq->post_schedule = has_pushable_tasks(rq);
-#endif
+	set_post_schedule(rq);
 
 	return p;
 }
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index d276147..caf4abd 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1172,6 +1172,11 @@ extern void trigger_load_balance(struct rq *rq);
 extern void idle_enter_fair(struct rq *this_rq);
 extern void idle_exit_fair(struct rq *this_rq);
 
+#else
+
+static inline void idle_enter_fair(struct rq *rq) { }
+static inline void idle_exit_fair(struct rq *rq) { }
+
 #endif
 
 extern void sysrq_sched_debug_show(void);
