Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752272AbaAQJFC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 04:05:02 -0500
Received: from mail-wg0-f43.google.com ([74.125.82.43]:42547 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751548AbaAQJEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 04:04:10 -0500
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: peterz@infradead.org, mingo@kernel.org
Cc: linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        alex.shi@linaro.org
Subject: [PATCH 4/4] sched: Idle task shortcut optimization
Date: Fri, 17 Jan 2014 10:04:04 +0100
Message-Id: <1389949444-14821-4-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1389949444-14821-1-git-send-email-daniel.lezcano@linaro.org>
References: <1389949444-14821-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the previous patch, we have no ambiguity on going to idle. So we can pick
directly the idle task instead of looking up all the domains which will in any
case return no task except the idle_task.

Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 kernel/sched/core.c      |   43 ++++++++++++++++++++++++++++++++++++++-----
 kernel/sched/idle_task.c |   15 +++++----------
 2 files changed, 43 insertions(+), 15 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index b7e3635..c7a8f4e 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2586,7 +2586,43 @@ pick_next_task(struct rq *rq)
 			return p;
 	}
 
-	BUG(); /* the idle class will always have a runnable task */
+	/*
+	 * We must have at least one task to run, the idle task is
+	 * returned by the shortcut in pick_next_task_or_idle. If we
+	 * fall here, we don't have any task to run, so something is
+	 * wrong when we thought the cpu was not going to idle.
+	 */
+	BUG();
+}
+
+static inline struct task_struct *pick_next_task_or_idle(struct rq *rq)
+{
+	if (likely(rq->nr_running))
+		return pick_next_task(rq);
+
+	rq->idle_stamp = 0;
+
+	/*
+	 * If there is a task balanced on this cpu, pick the next task,
+	 * otherwise fall in the optimization by picking the idle task
+	 * directly.
+	 */
+	if (idle_balance(rq))
+		return pick_next_task(rq);
+
+	rq->idle_stamp = rq_clock(rq);
+
+	/*
+	 * Optimization: pick_next_task will return rq->idle in any case but
+	 * after walking through the different sched domains. Let's add a
+	 * shortcut to directly return the idle task.
+	 */
+	schedstat_inc(rq, sched_goidle);
+#ifdef CONFIG_SMP
+	/* Trigger the post schedule to do an idle_enter for CFS */
+	rq->post_schedule = 1;
+#endif
+	return rq->idle;
 }
 
 /*
@@ -2679,11 +2715,8 @@ need_resched:
 
 	pre_schedule(rq, prev);
 
-	if (unlikely(!rq->nr_running))
-		rq->idle_stamp = idle_balance(rq) ? 0 : rq_clock(rq);
-
 	put_prev_task(rq, prev);
-	next = pick_next_task(rq);
+	next = pick_next_task_or_idle(rq);
 	clear_tsk_need_resched(prev);
 	clear_preempt_need_resched();
 	rq->skip_clock_update = 0;
diff --git a/kernel/sched/idle_task.c b/kernel/sched/idle_task.c
index 516c3d9..0b4c94b 100644
--- a/kernel/sched/idle_task.c
+++ b/kernel/sched/idle_task.c
@@ -33,16 +33,6 @@ static void check_preempt_curr_idle(struct rq *rq, struct task_struct *p, int fl
 	resched_task(rq->idle);
 }
 
-static struct task_struct *pick_next_task_idle(struct rq *rq)
-{
-	schedstat_inc(rq, sched_goidle);
-#ifdef CONFIG_SMP
-	/* Trigger the post schedule to do an idle_enter for CFS */
-	rq->post_schedule = 1;
-#endif
-	return rq->idle;
-}
-
 /*
  * It is not legal to sleep in the idle task - print a warning
  * message if some code attempts to do it:
@@ -60,6 +50,11 @@ static void put_prev_task_idle(struct rq *rq, struct task_struct *prev)
 {
 }
 
+static struct task_struct *pick_next_task_idle(struct rq *rq)
+{
+	return NULL;
+}
+
 static void task_tick_idle(struct rq *rq, struct task_struct *curr, int queued)
 {
 }
-- 
1.7.9.5

