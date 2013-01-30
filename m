Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753687Ab3A3Mup (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 07:50:45 -0500
Received: from forward19.mail.yandex.net ([95.108.253.144]:44933 "EHLO
	forward19.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751851Ab3A3Mul (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 07:50:41 -0500
From: Kirill Tkhai <tkhai@yandex.ru>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: [PATCH]sched/rt: Do not account zero delta_exec in update_curr_rt()
MIME-Version: 1.0
Message-Id: <931541359550236@web1g.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Wed, 30 Jan 2013 16:50:36 +0400
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are several places of consecutive calls of dequeue_task_rt()
and put_prev_task_rt() in the scheduler. For example, function
rt_mutex_setprio() does it.

The both calls lead to update_curr_rt(), the second of it receives
zeroed delta_exec. The only effective action in this case is call of
sched_rt_avg_update(), which can change rq->age_stamp and rq->rt_avg.
But it is possible in case of ""floating"" rq->clock. This fact is
not reasonable to be accounted. Another actions do nothing.

Signed-off-by: Kirill V Tkhai <tkhai@yandex.ru>
CC: Steven Rostedt <rostedt@goodmis.org>
CC: Ingo Molnar <mingo@kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>
CC: linux-rt-users <linux-rt-users@vger.kernel.org>
---
 kernel/sched/rt.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 4e8f0f4..c6d7993 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -925,8 +925,8 @@ static void update_curr_rt(struct rq *rq)
 		return;
 
 	delta_exec = rq->clock_task - curr->se.exec_start;
-	if (unlikely((s64)delta_exec < 0))
-		delta_exec = 0;
+	if (unlikely((s64)delta_exec <= 0))
+		return;
 
 	schedstat_set(curr->se.statistics.exec_max,
 		      max(curr->se.statistics.exec_max, delta_exec));

