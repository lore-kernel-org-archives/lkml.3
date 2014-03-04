Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932364AbaCDPZ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 10:25:59 -0500
Received: from relay.parallels.com ([195.214.232.42]:57983 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932134AbaCDPZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 10:25:58 -0500
Message-ID: <1393946746.3643.3.camel@tkhai>
Subject: [PATCH tip] sched/rt: Fix picking RT and DL tasks from empty queue
From: Kirill Tkhai <ktkhai@parallels.com>
To: <linux-kernel@vger.kernel.org>
CC: Juri Lelli <juri.lelli@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, <tkhai@yandex.ru>
Date: Tue, 4 Mar 2014 19:25:46 +0400
Organization: Parallels
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.26.172]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The problems:

1)We check for rt_nr_running before call of put_prev_task().
If previous task is RT, its rt_rq may become throttled
and dequeued after this call.

In case of p is from rt->rq this just causes picking a task
from throttled queue, but in case of its rt_rq is child
we are guaranteed catch BUG_ON.
    
2)The same with deadline class. The only difference we operate
on only dl_rq.
    
This patch fix all above and it adds a small skip in DL update
like we've already done for RT class:

	if (unlikely((s64)delta_exec <= 0))
		return;

This will optimize sequential update_curr_dl() calls a little.

Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>
CC: Juri Lelli <juri.lelli@gmail.com>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@redhat.com>
---
 kernel/sched/deadline.c | 10 ++++++++--
 kernel/sched/rt.c       |  7 +++++++
 2 files changed, 15 insertions(+), 2 deletions(-)
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index e4f3ac3..27ef409 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -609,8 +609,8 @@ static void update_curr_dl(struct rq *rq)
 	 * approach need further study.
 	 */
 	delta_exec = rq_clock_task(rq) - curr->se.exec_start;
-	if (unlikely((s64)delta_exec < 0))
-		delta_exec = 0;
+	if (unlikely((s64)delta_exec <= 0))
+		return;
 
 	schedstat_set(curr->se.statistics.exec_max,
 		      max(curr->se.statistics.exec_max, delta_exec));
@@ -1023,6 +1023,12 @@ struct task_struct *pick_next_task_dl(struct rq *rq, struct task_struct *prev)
 
 	if (need_pull_dl_task(rq, prev))
 		pull_dl_task(rq);
+	/*
+	 * When prev is DL, we may throttle it in put_prev_task().
+	 * So, we update time before we check for dl_nr_running.
+	 */
+	if (prev->sched_class == &dl_sched_class)
+		update_curr_dl(rq);
 
 	if (unlikely(!dl_rq->dl_nr_running))
 		return NULL;
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index facc824..f3cee0a 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -1379,6 +1379,13 @@ pick_next_task_rt(struct rq *rq, struct task_struct *prev)
 			return RETRY_TASK;
 	}
 
+	/*
+	 * We may dequeue prev's rt_rq in put_prev_task().
+	 * So, we update time before rt_nr_running check.
+	 */
+	if (prev->sched_class == &rt_sched_class)
+		update_curr_rt(rq);
+
 	if (!rt_rq->rt_nr_running)
 		return NULL;
 


