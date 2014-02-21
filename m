Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755943AbaBUVbx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 16:31:53 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59288 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755824AbaBUVbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 16:31:51 -0500
Date: Fri, 21 Feb 2014 13:31:17 -0800
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-uuwge7mqn3jk72v4jdkwbixd@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, rostedt@goodmis.org, wangyun@linux.vnet.ibm.com,
        tglx@linutronix.de, juri.lelli@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, rostedt@goodmis.org, wangyun@linux.vnet.ibm.com,
        tglx@linutronix.de, juri.lelli@gmail.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Guarantee task priority in pick_next_task
 ()
Git-Commit-ID: 477af336ba06ef4c32e97892bb0d2027ce30f466
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

Commit-ID:  477af336ba06ef4c32e97892bb0d2027ce30f466
Gitweb:     http://git.kernel.org/tip/477af336ba06ef4c32e97892bb0d2027ce30f466
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Fri, 14 Feb 2014 12:25:08 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 21 Feb 2014 21:43:18 +0100

sched: Guarantee task priority in pick_next_task()

Michael spotted that the idle_balance() push down created a task
priority problem.

Previously, when we called idle_balance() before pick_next_task() it
wasn't a problem when -- because of the rq->lock droppage -- an rt/dl
task slipped in.

Similarly for pre_schedule(), rt pre-schedule could have a dl task
slip in.

But by pulling it into the pick_next_task() loop, we'll not try a
higher task priority again.

Cure this by creating a re-start condition in pick_next_task(); and
triggering this from pick_next_task_{rt,fair}().

Fixes: 38033c37faab ("sched: Push down pre_schedule() and idle_balance()")
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Juri Lelli <juri.lelli@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Reported-by: Michael Wang <wangyun@linux.vnet.ibm.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/n/tip-uuwge7mqn3jk72v4jdkwbixd@git.kernel.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/sched/core.c | 16 ++++++++++++----
 kernel/sched/fair.c | 16 +++++++++++++++-
 kernel/sched/rt.c   | 10 +++++++++-
 3 files changed, 36 insertions(+), 6 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 49db434..4c8aaf0 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2574,24 +2574,32 @@ static inline void schedule_debug(struct task_struct *prev)
 static inline struct task_struct *
 pick_next_task(struct rq *rq, struct task_struct *prev)
 {
-	const struct sched_class *class;
+	const struct sched_class *class = &fair_sched_class;
 	struct task_struct *p;
 
 	/*
 	 * Optimization: we know that if all tasks are in
 	 * the fair class we can call that function directly:
 	 */
-	if (likely(prev->sched_class == &fair_sched_class &&
+	if (likely(prev->sched_class == class &&
 		   rq->nr_running == rq->cfs.h_nr_running)) {
 		p = fair_sched_class.pick_next_task(rq, prev);
-		if (likely(p))
+		if (likely(p && p->sched_class == class))
 			return p;
 	}
 
+again:
 	for_each_class(class) {
 		p = class->pick_next_task(rq, prev);
-		if (p)
+		if (p) {
+			/*
+			 * See pick_next_task_{fair,rt}(); they return rq->idle
+			 * in case they want to re-start the task selection.
+			 */
+			if (unlikely(p->sched_class != class))
+				goto again;
 			return p;
+		}
 	}
 
 	BUG(); /* the idle class will always have a runnable task */
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index e884e45..fb6f220 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4684,6 +4684,7 @@ pick_next_task_fair(struct rq *rq, struct task_struct *prev)
 	struct cfs_rq *cfs_rq = &rq->cfs;
 	struct sched_entity *se;
 	struct task_struct *p;
+	int new_tasks;
 
 again:
 #ifdef CONFIG_FAIR_GROUP_SCHED
@@ -4782,7 +4783,20 @@ simple:
 	return p;
 
 idle:
-	if (idle_balance(rq)) /* drops rq->lock */
+	/*
+	 * Because idle_balance() releases (and re-acquires) rq->lock, it is
+	 * possible for any higher priority task to appear. In that case we
+	 * must re-start the pick_next_entity() loop.
+	 */
+	new_tasks = idle_balance(rq);
+
+	/*
+	 * See pick_next_task(); we return rq->idle to restart task selection.
+	 */
+	if (rq->nr_running != rq->cfs.h_nr_running)
+		return rq->idle;
+
+	if (new_tasks)
 		goto again;
 
 	return NULL;
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 3e488ca..b22a090 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -1360,8 +1360,16 @@ pick_next_task_rt(struct rq *rq, struct task_struct *prev)
 	struct task_struct *p;
 	struct rt_rq *rt_rq = &rq->rt;
 
-	if (need_pull_rt_task(rq, prev))
+	if (need_pull_rt_task(rq, prev)) {
 		pull_rt_task(rq);
+		/*
+		 * pull_rt_task() can drop (and re-acquire) rq->lock; this
+		 * means a dl task can slip in, in which case we need to
+		 * re-start task selection.
+		 */
+		if (unlikely(rq->dl.dl_nr_running))
+			return rq->idle;
+	}
 
 	if (!rt_rq->rt_nr_running)
 		return NULL;
