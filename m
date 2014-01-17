Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752747AbaAQQp1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 11:45:27 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:49906 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752090AbaAQQpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 11:45:06 -0500
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: peterz@infradead.org
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org, alex.shi@linaro.org
Subject: [PATCH 2/2] sched: Use idle task shortcut
Date: Fri, 17 Jan 2014 17:45:02 +0100
Message-Id: <1389977102-4420-2-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1389977102-4420-1-git-send-email-daniel.lezcano@linaro.org>
References: <52D95C5E.4070209@linaro.org>
 <1389977102-4420-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

With the previous patches, we have no ambiguity on going to idle. So we can
return directly the idle task instead of looking up all the domains which will in
any case return the idle_task.

Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 kernel/sched/core.c |   39 +++++++++++++++++++++++----------------
 1 file changed, 23 insertions(+), 16 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 76f0075..b5237dc 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2563,23 +2563,33 @@ pick_next_task(struct rq *rq, struct task_struct *prev)
 	const struct sched_class *class;
 	struct task_struct *p;
 
+again:
+	if (likely(rq->nr_running)) {
+		/*
+		 * Optimization: we know that if all tasks are in
+		 * the fair class we can call that function directly:
+		 */
+		if (likely(rq->nr_running == rq->cfs.h_nr_running))
+			return fair_sched_class.pick_next_task(rq, prev);
+
+		for_each_class(class) {
+			p = class->pick_next_task(rq, prev);
+			if (p)
+				return p;
+		}
+	}
+
 	/*
-	 * Optimization: we know that if all tasks are in
-	 * the fair class we can call that function directly:
+	 * If there is a task balanced on this cpu, pick the next task,
+	 * otherwise fall in the optimization by picking the idle task
+	 * directly.
 	 */
-	if (likely(rq->nr_running == rq->cfs.h_nr_running)) {
-		p = fair_sched_class.pick_next_task(rq, prev);
-		if (likely(p))
-			return p;
-	}
+	if (idle_balance(rq))
+		goto again;
 
-	for_each_class(class) {
-		p = class->pick_next_task(rq, prev);
-		if (p)
-			return p;
-	}
+	rq->idle_stamp = rq_clock(rq);
 
-	BUG(); /* the idle class will always have a runnable task */
+	return idle_sched_class.pick_next_task(rq, prev);
 }
 
 /*
@@ -2672,9 +2682,6 @@ need_resched:
 
 	pre_schedule(rq, prev);
 
-	if (unlikely(!rq->nr_running))
-		rq->idle_stamp = idle_balance(rq) ? 0 : rq_clock(rq);
-
 	if (prev->on_rq || rq->skip_clock_update < 0)
 		update_rq_clock(rq);
 
-- 
1.7.9.5

