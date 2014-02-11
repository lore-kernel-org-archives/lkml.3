Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752093AbaBKMRv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 07:17:51 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46530 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055AbaBKMRn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 07:17:43 -0500
Date: Tue, 11 Feb 2014 04:16:57 -0800
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-6c3b4d44ba2838f00614a5a2d777d4401e0bfd71@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, rostedt@goodmis.org, vincent.guittot@linaro.org,
        tglx@linutronix.de, daniel.lezcano@linaro.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, rostedt@goodmis.org, vincent.guittot@linaro.org,
        tglx@linutronix.de, daniel.lezcano@linaro.org
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Clean up idle task SMP logic
Git-Commit-ID: 6c3b4d44ba2838f00614a5a2d777d4401e0bfd71
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 11 Feb 2014 04:17:04 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6c3b4d44ba2838f00614a5a2d777d4401e0bfd71
Gitweb:     http://git.kernel.org/tip/6c3b4d44ba2838f00614a5a2d777d4401e0bfd71
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Fri, 17 Jan 2014 15:09:39 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 10 Feb 2014 16:17:22 +0100

sched: Clean up idle task SMP logic

The idle post_schedule flag is just a vile waste of time, furthermore
it appears unneeded, move the idle_enter_fair() call into
pick_next_task_idle().

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: alex.shi@linaro.org
Cc: mingo@kernel.org
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/n/tip-aljykihtxJt3mkokxi0qZurb@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/idle_task.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/kernel/sched/idle_task.c b/kernel/sched/idle_task.c
index e5c922a..721371b 100644
--- a/kernel/sched/idle_task.c
+++ b/kernel/sched/idle_task.c
@@ -19,11 +19,6 @@ static void pre_schedule_idle(struct rq *rq, struct task_struct *prev)
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
@@ -41,8 +36,7 @@ pick_next_task_idle(struct rq *rq, struct task_struct *prev)
 
 	schedstat_inc(rq, sched_goidle);
 #ifdef CONFIG_SMP
-	/* Trigger the post schedule to do an idle_enter for CFS */
-	rq->post_schedule = 1;
+	idle_enter_fair(rq);
 #endif
 	return rq->idle;
 }
@@ -106,7 +100,6 @@ const struct sched_class idle_sched_class = {
 #ifdef CONFIG_SMP
 	.select_task_rq		= select_task_rq_idle,
 	.pre_schedule		= pre_schedule_idle,
-	.post_schedule		= post_schedule_idle,
 #endif
 
 	.set_curr_task          = set_curr_task_idle,
