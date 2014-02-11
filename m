Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751838AbaBKMQf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 07:16:35 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46480 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767AbaBKMQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 07:16:33 -0500
Date: Tue, 11 Feb 2014 04:16:01 -0800
From: tip-bot for Daniel Lezcano <tipbot@zytor.com>
Message-ID: <tip-3c4017c13f91069194fce3160944efec50f15a6e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, tglx@linutronix.de, daniel.lezcano@linaro.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, daniel.lezcano@linaro.org
In-Reply-To: <1389949444-14821-3-git-send-email-daniel.lezcano@linaro.org>
References: <1389949444-14821-3-git-send-email-daniel.lezcano@linaro.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Move rq->idle_stamp up to the core
Git-Commit-ID: 3c4017c13f91069194fce3160944efec50f15a6e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 11 Feb 2014 04:16:07 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3c4017c13f91069194fce3160944efec50f15a6e
Gitweb:     http://git.kernel.org/tip/3c4017c13f91069194fce3160944efec50f15a6e
Author:     Daniel Lezcano <daniel.lezcano@linaro.org>
AuthorDate: Fri, 17 Jan 2014 10:04:03 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 10 Feb 2014 16:17:07 +0100

sched: Move rq->idle_stamp up to the core

idle_balance() modifies the rq->idle_stamp field, making this information
shared across core.c and fair.c.

As we know if the cpu is going to idle or not with the previous patch, let's
encapsulate the rq->idle_stamp information in core.c by moving it up to the
caller.

The idle_balance() function returns true in case a balancing occured and the
cpu won't be idle, false if no balance happened and the cpu is going idle.

Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: alex.shi@linaro.org
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1389949444-14821-3-git-send-email-daniel.lezcano@linaro.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c  | 11 +++++++++--
 kernel/sched/fair.c  | 14 ++++++--------
 kernel/sched/sched.h |  2 +-
 3 files changed, 16 insertions(+), 11 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 74dd565..417cf65 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2704,8 +2704,15 @@ need_resched:
 
 	pre_schedule(rq, prev);
 
-	if (unlikely(!rq->nr_running))
-		idle_balance(rq);
+	if (unlikely(!rq->nr_running)) {
+		/*
+		 * We must set idle_stamp _before_ calling idle_balance(), such
+		 * that we measure the duration of idle_balance() as idle time.
+		 */
+		rq->idle_stamp = rq_clock(rq);
+		if (idle_balance(rq))
+			rq->idle_stamp = 0;
+	}
 
 	put_prev_task(rq, prev);
 	next = pick_next_task(rq);
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 5ebc681..04fea77 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -6531,7 +6531,7 @@ out:
  * idle_balance is called by schedule() if this_cpu is about to become
  * idle. Attempts to pull tasks from other CPUs.
  */
-void idle_balance(struct rq *this_rq)
+int idle_balance(struct rq *this_rq)
 {
 	struct sched_domain *sd;
 	int pulled_task = 0;
@@ -6539,10 +6539,8 @@ void idle_balance(struct rq *this_rq)
 	u64 curr_cost = 0;
 	int this_cpu = this_rq->cpu;
 
-	this_rq->idle_stamp = rq_clock(this_rq);
-
 	if (this_rq->avg_idle < sysctl_sched_migration_cost)
-		return;
+		return 0;
 
 	/*
 	 * Drop the rq->lock, but keep IRQ/preempt disabled.
@@ -6580,10 +6578,8 @@ void idle_balance(struct rq *this_rq)
 		interval = msecs_to_jiffies(sd->balance_interval);
 		if (time_after(next_balance, sd->last_balance + interval))
 			next_balance = sd->last_balance + interval;
-		if (pulled_task) {
-			this_rq->idle_stamp = 0;
+		if (pulled_task)
 			break;
-		}
 	}
 	rcu_read_unlock();
 
@@ -6594,7 +6590,7 @@ void idle_balance(struct rq *this_rq)
 	 * A task could have be enqueued in the meantime
 	 */
 	if (this_rq->nr_running && !pulled_task)
-		return;
+		return 1;
 
 	if (pulled_task || time_after(jiffies, this_rq->next_balance)) {
 		/*
@@ -6606,6 +6602,8 @@ void idle_balance(struct rq *this_rq)
 
 	if (curr_cost > this_rq->max_idle_balance_cost)
 		this_rq->max_idle_balance_cost = curr_cost;
+
+	return pulled_task;
 }
 
 /*
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 82c0e02..bb89991 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1158,7 +1158,7 @@ extern const struct sched_class idle_sched_class;
 extern void update_group_power(struct sched_domain *sd, int cpu);
 
 extern void trigger_load_balance(struct rq *rq);
-extern void idle_balance(struct rq *this_rq);
+extern int idle_balance(struct rq *this_rq);
 
 extern void idle_enter_fair(struct rq *this_rq);
 extern void idle_exit_fair(struct rq *this_rq);
