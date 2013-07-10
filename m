Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754101Ab3GJKa3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 06:30:29 -0400
Received: from forward3h.mail.yandex.net ([84.201.187.148]:42197 "EHLO
	forward3h.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753201Ab3GJKa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 06:30:28 -0400
From: Kirill Tkhai <tkhai@yandex.ru>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH] sched: Skip update_rq_clock() in enqueue_task() following right after dequeue_task()
MIME-Version: 1.0
Message-Id: <41561373452224@web22h.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Wed, 10 Jul 2013 14:30:24 +0400
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add new flag ENQUEUE_NO_CLK to skip microscopic rq->clock update.

This update is less even than in places where skip_clock_update is used.

Signed-off-by: Kirill Tkhai <tkhai@yandex.ru>
CC: Ingo Molnar <mingo@redhat.com>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/sched/core.c  |   12 +++++++-----
 kernel/sched/sched.h |    1 +
 2 files changed, 8 insertions(+), 5 deletions(-)
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 9d06ad6..0b99057 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -764,7 +764,9 @@ static void set_load_weight(struct task_struct *p)
 
 static void enqueue_task(struct rq *rq, struct task_struct *p, int flags)
 {
-	update_rq_clock(rq);
+	if (!(flags & ENQUEUE_NO_CLK))
+		update_rq_clock(rq);
+
 	sched_info_queued(p);
 	p->sched_class->enqueue_task(rq, p, flags);
 }
@@ -3107,7 +3109,7 @@ void set_user_nice(struct task_struct *p, long nice)
 	delta = p->prio - old_prio;
 
 	if (on_rq) {
-		enqueue_task(rq, p, 0);
+		enqueue_task(rq, p, ENQUEUE_NO_CLK);
 		/*
 		 * If the task increased its priority or is running and
 		 * lowered its priority, then reschedule its CPU:
@@ -3414,7 +3416,7 @@ recheck:
 	if (running)
 		p->sched_class->set_curr_task(rq);
 	if (on_rq)
-		enqueue_task(rq, p, 0);
+		enqueue_task(rq, p, ENQUEUE_NO_CLK);
 
 	check_class_changed(rq, p, prev_class, oldprio);
 	task_rq_unlock(rq, p, &flags);
@@ -6562,7 +6564,7 @@ static void normalize_task(struct rq *rq, struct task_struct *p)
 		dequeue_task(rq, p, 0);
 	__setscheduler(rq, p, SCHED_NORMAL, 0);
 	if (on_rq) {
-		enqueue_task(rq, p, 0);
+		enqueue_task(rq, p, ENQUEUE_NO_CLK);
 		resched_task(rq->curr);
 	}
 
@@ -6777,7 +6779,7 @@ void sched_move_task(struct task_struct *tsk)
 	if (unlikely(running))
 		tsk->sched_class->set_curr_task(rq);
 	if (on_rq)
-		enqueue_task(rq, tsk, 0);
+		enqueue_task(rq, tsk, ENQUEUE_NO_CLK);
 
 	task_rq_unlock(rq, tsk, &flags);
 }
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index ef0a7b2..4b8dfd7 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -957,6 +957,7 @@ static const u32 prio_to_wmult[40] = {
 #else
 #define ENQUEUE_WAKING		0
 #endif
+#define ENQUEUE_NO_CLK		8	/* skip update_rq_clock() */
 
 #define DEQUEUE_SLEEP		1
 
