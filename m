Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755550AbaA1RiC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 12:38:02 -0500
Received: from merlin.infradead.org ([205.233.59.134]:60566 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755191AbaA1Rdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 12:33:47 -0500
Message-Id: <20140128171948.351282894@infradead.org>
User-Agent: quilt/0.60-1
Date: Tue, 28 Jan 2014 18:16:42 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, daniel.lezcano@linaro.org, pjt@google.com,
        bsegall@google.com, Steven Rostedt <rostedt@goodmis.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 8/9] sched: Clean up idle task SMP logic
References: <20140128171634.974847076@infradead.org>
Content-Disposition: inline; filename=peterz-sched-idle-1.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The idle post_schedule hook is just a vile waste of time, furthermore
it appears unneeded, move the idle_enter_fair() call into
pick_next_task_idle().

Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: alex.shi@linaro.org
Cc: mingo@kernel.org
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 kernel/sched/idle_task.c |    9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

--- a/kernel/sched/idle_task.c
+++ b/kernel/sched/idle_task.c
@@ -19,11 +19,6 @@ static void pre_schedule_idle(struct rq
 	idle_exit_fair(rq);
 	rq_last_tick_reset(rq);
 }
-
-static void post_schedule_idle(struct rq *rq)
-{
-	idle_enter_fair(rq);
-}
 #endif /* CONFIG_SMP */
 /*
  * Idle tasks are unconditionally rescheduled:
@@ -40,8 +35,7 @@ pick_next_task_idle(struct rq *rq, struc
 
 	schedstat_inc(rq, sched_goidle);
 #ifdef CONFIG_SMP
-	/* Trigger the post schedule to do an idle_enter for CFS */
-	rq->post_schedule = 1;
+	idle_enter_fair(rq);
 #endif
 	return rq->idle;
 }
@@ -105,7 +99,6 @@ const struct sched_class idle_sched_clas
 #ifdef CONFIG_SMP
 	.select_task_rq		= select_task_rq_idle,
 	.pre_schedule		= pre_schedule_idle,
-	.post_schedule		= post_schedule_idle,
 #endif
 
 	.set_curr_task          = set_curr_task_idle,


