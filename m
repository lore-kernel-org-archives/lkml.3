Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782AbaCFJcJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 04:32:09 -0500
Received: from relay.parallels.com ([195.214.232.42]:54850 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752247AbaCFJcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 04:32:05 -0500
Message-ID: <1394098315.19290.10.camel@tkhai>
Subject: [PATCH tip 1/2] sched/fair: Push down check for high priority class
 task into idle_balance()
From: Kirill Tkhai <ktkhai@parallels.com>
To: <linux-kernel@vger.kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Date: Thu, 6 Mar 2014 13:31:55 +0400
Organization: Parallels
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.26.172]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We close idle_exit_fair() bracket in case of we've pulled something or we've received
task of high priority class.

Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@redhat.com>
---
 kernel/sched/fair.c      |   15 ++++++++++-----
 kernel/sched/idle_task.c |    1 -
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
 



