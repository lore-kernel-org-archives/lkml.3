Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755461AbaCKMpX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 08:45:23 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35742 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755322AbaCKMkr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 08:40:47 -0400
Date: Tue, 11 Mar 2014 05:39:39 -0700
From: tip-bot for Kirill Tkhai <tipbot@zytor.com>
Message-ID: <tip-e4aa358b6c23f98b2715594f6b1e9a4996a55f04@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, ktkhai@parallels.com, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, vincent.guittot@linaro.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, ktkhai@parallels.com,
        linux-kernel@vger.kernel.org, peterz@infradead.org,
        vincent.guittot@linaro.org, tglx@linutronix.de
In-Reply-To: <1394098315.19290.10.camel@tkhai>
References: <1394098315.19290.10.camel@tkhai>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/fair:
  Push down check for high priority class task into idle_balance()
Git-Commit-ID: e4aa358b6c23f98b2715594f6b1e9a4996a55f04
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

Commit-ID:  e4aa358b6c23f98b2715594f6b1e9a4996a55f04
Gitweb:     http://git.kernel.org/tip/e4aa358b6c23f98b2715594f6b1e9a4996a55f04
Author:     Kirill Tkhai <ktkhai@parallels.com>
AuthorDate: Thu, 6 Mar 2014 13:31:55 +0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 11 Mar 2014 12:05:37 +0100

sched/fair: Push down check for high priority class task into idle_balance()

We close idle_exit_fair() bracket in case of we've pulled something or we've received
task of high priority class.

Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Link: http://lkml.kernel.org/r/1394098315.19290.10.camel@tkhai
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c      | 15 ++++++++++-----
 kernel/sched/idle_task.c |  1 -
 2 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index d8482e1..b956e70 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4787,17 +4787,16 @@ simple:
 	return p;
 
 idle:
+	new_tasks = idle_balance(rq);
 	/*
 	 * Because idle_balance() releases (and re-acquires) rq->lock, it is
 	 * possible for any higher priority task to appear. In that case we
 	 * must re-start the pick_next_entity() loop.
 	 */
-	new_tasks = idle_balance(rq);
-
-	if (rq->nr_running != rq->cfs.h_nr_running)
+	if (new_tasks < 0)
 		return RETRY_TASK;
 
-	if (new_tasks)
+	if (new_tasks > 0)
 		goto again;
 
 	return NULL;
@@ -6728,8 +6727,14 @@ static int idle_balance(struct rq *this_rq)
 		this_rq->max_idle_balance_cost = curr_cost;
 
 out:
-	if (pulled_task)
+	/* Is there a task of a high priority class? */
+	if (this_rq->nr_running != this_rq->cfs.h_nr_running)
+		pulled_task = -1;
+
+	if (pulled_task) {
+		idle_exit_fair(this_rq);
 		this_rq->idle_stamp = 0;
+	}
 
 	return pulled_task;
 }
diff --git a/kernel/sched/idle_task.c b/kernel/sched/idle_task.c
index 1f37258..879f2b7 100644
--- a/kernel/sched/idle_task.c
+++ b/kernel/sched/idle_task.c
@@ -29,7 +29,6 @@ pick_next_task_idle(struct rq *rq, struct task_struct *prev)
 	put_prev_task(rq, prev);
 
 	schedstat_inc(rq, sched_goidle);
-	idle_enter_fair(rq);
 	return rq->idle;
 }
 
