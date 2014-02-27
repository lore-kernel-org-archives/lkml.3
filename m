Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753462AbaB0Ndu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 08:33:50 -0500
Received: from terminus.zytor.com ([198.137.202.10]:55036 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752566AbaB0Ndr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 08:33:47 -0500
Date: Thu, 27 Feb 2014 05:33:04 -0800
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-37e117c07b89194aae7062bc63bde1104c03db02@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, sasha.levin@oracle.com, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, rostedt@goodmis.org,
        wangyun@linux.vnet.ibm.com, tglx@linutronix.de, juri.lelli@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, sasha.levin@oracle.com,
        linux-kernel@vger.kernel.org, peterz@infradead.org,
        rostedt@goodmis.org, wangyun@linux.vnet.ibm.com, tglx@linutronix.de,
        juri.lelli@gmail.com
In-Reply-To: <20140224121218.GR15586@twins.programming.kicks-ass.net>
References: <20140224121218.GR15586@twins.programming.kicks-ass.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Guarantee task priority in pick_next_task
 ()
Git-Commit-ID: 37e117c07b89194aae7062bc63bde1104c03db02
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

Commit-ID:  37e117c07b89194aae7062bc63bde1104c03db02
Gitweb:     http://git.kernel.org/tip/37e117c07b89194aae7062bc63bde1104c03db02
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Fri, 14 Feb 2014 12:25:08 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 27 Feb 2014 12:41:02 +0100

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

It also fixes a live-lock where we get stuck in pick_next_task_fair()
due to idle_balance() seeing !0 nr_running but there not actually
being any fair tasks about.

Reported-by: Michael Wang <wangyun@linux.vnet.ibm.com>
Fixes: 38033c37faab ("sched: Push down pre_schedule() and idle_balance()")
Tested-by: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Juri Lelli <juri.lelli@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/20140224121218.GR15586@twins.programming.kicks-ass.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c  | 12 ++++++++----
 kernel/sched/fair.c  | 13 ++++++++++++-
 kernel/sched/rt.c    | 10 +++++++++-
 kernel/sched/sched.h |  5 +++++
 4 files changed, 34 insertions(+), 6 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index a8a73b8..cde573d 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2586,24 +2586,28 @@ static inline void schedule_debug(struct task_struct *prev)
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
+		if (likely(p && p != RETRY_TASK))
 			return p;
 	}
 
+again:
 	for_each_class(class) {
 		p = class->pick_next_task(rq, prev);
-		if (p)
+		if (p) {
+			if (unlikely(p == RETRY_TASK))
+				goto again;
 			return p;
+		}
 	}
 
 	BUG(); /* the idle class will always have a runnable task */
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index be4f7d9..16042b5 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4686,6 +4686,7 @@ pick_next_task_fair(struct rq *rq, struct task_struct *prev)
 	struct cfs_rq *cfs_rq = &rq->cfs;
 	struct sched_entity *se;
 	struct task_struct *p;
+	int new_tasks;
 
 again:
 #ifdef CONFIG_FAIR_GROUP_SCHED
@@ -4784,7 +4785,17 @@ simple:
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
+	if (rq->nr_running != rq->cfs.h_nr_running)
+		return RETRY_TASK;
+
+	if (new_tasks)
 		goto again;
 
 	return NULL;
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 4d4b386..398b3f9 100644
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
+			return RETRY_TASK;
+	}
 
 	if (!rt_rq->rt_nr_running)
 		return NULL;
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 046084e..1929deb 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1091,6 +1091,8 @@ static const u32 prio_to_wmult[40] = {
 
 #define DEQUEUE_SLEEP		1
 
+#define RETRY_TASK		((void *)-1UL)
+
 struct sched_class {
 	const struct sched_class *next;
 
@@ -1105,6 +1107,9 @@ struct sched_class {
 	 * It is the responsibility of the pick_next_task() method that will
 	 * return the next task to call put_prev_task() on the @prev task or
 	 * something equivalent.
+	 *
+	 * May return RETRY_TASK when it finds a higher prio class has runnable
+	 * tasks.
 	 */
 	struct task_struct * (*pick_next_task) (struct rq *rq,
 						struct task_struct *prev);
