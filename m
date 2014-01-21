Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754628AbaAULaE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 06:30:04 -0500
Received: from merlin.infradead.org ([205.233.59.134]:51878 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754224AbaAUL30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 06:29:26 -0500
Message-Id: <20140121112258.764101400@infradead.org>
User-Agent: quilt/0.60-1
Date: Tue, 21 Jan 2014 12:18:03 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, daniel.lezcano@linaro.org, pjt@google.com,
        bsegall@google.com, Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 9/9] sched: Use idle task shortcut
References: <20140121111754.580142558@infradead.org>
Content-Disposition: inline; filename=peter_zijlstra-2_sched-use_idle_task_shortcut.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the previous patches, we have no ambiguity on going to idle. So we can
return directly the idle task instead of looking up all the domains which will in
any case return the idle_task.

Cc: alex.shi@linaro.org
Cc: peterz@infradead.org
Cc: mingo@kernel.org
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1389977102-4420-2-git-send-email-daniel.lezcano@linaro.org
---
 kernel/sched/core.c |   39 +++++++++++++++++++++++----------------
 1 file changed, 23 insertions(+), 16 deletions(-)

--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2563,23 +2563,33 @@ pick_next_task(struct rq *rq, struct tas
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
@@ -2672,9 +2682,6 @@ static void __sched __schedule(void)
 
 	pre_schedule(rq, prev);
 
-	if (unlikely(!rq->nr_running))
-		rq->idle_stamp = idle_balance(rq) ? 0 : rq_clock(rq);
-
 	if (prev->on_rq || rq->skip_clock_update < 0)
 		update_rq_clock(rq);
 


