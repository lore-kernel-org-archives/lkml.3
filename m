Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757236Ab3K0QGm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 11:06:42 -0500
Received: from forward5m.mail.yandex.net ([37.140.138.5]:58705 "EHLO
	forward5m.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753430Ab3K0QGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 11:06:40 -0500
X-Greylist: delayed 441 seconds by postgrey-1.27 at vger.kernel.org; Wed, 27 Nov 2013 11:06:39 EST
From: Kirill Tkhai <tkhai@yandex.ru>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, stable@vger.kernel.org
Subject: [PATCH] sched/rt: Fix rq's cpupri leak while enqueue/dequeue child RT entities
MIME-Version: 1.0
Message-Id: <49231385567953@web4m.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Wed, 27 Nov 2013 19:59:13 +0400
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch touches RT group scheduling case.

Functions inc_rt_prio_smp() and dec_rt_prio_smp() change (global) rq's priority,
while rt_rq passed to them may be not the top-level rt_rq. This is wrong, because
changing of priority on a child level does not guarantee that the priority is
the highest all over the rq. So, this leak makes RT balancing unusable.

The short example: the task having the highest priority among all rq's RT tasks
(no one other task has the same priority) are waking on a throttle rt_rq.
The rq's cpupri is set to the task's priority equivalent, but real
rq->rt.highest_prio.curr is less.

The patch below fixes the problem.

It looks like all version have this bug, so I CC'ed stable mailing list.

Signed-off-by: Kirill Tkhai <tkhai@yandex.ru>
CC: Ingo Molnar <mingo@redhat.com>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Steven Rostedt <rostedt@goodmis.org>
CC: stable@vger.kernel.org
---
 kernel/sched/rt.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 7d57275..1c40655 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -901,6 +901,13 @@ inc_rt_prio_smp(struct rt_rq *rt_rq, int prio, int prev_prio)
 {
 	struct rq *rq = rq_of_rt_rq(rt_rq);
 
+#ifdef CONFIG_RT_GROUP_SCHED
+	/*
+	 * Change rq's cpupri only if rt_rq is the top queue.
+	 */
+	if (&rq->rt != rt_rq)
+		return;
+#endif
 	if (rq->online && prio < prev_prio)
 		cpupri_set(&rq->rd->cpupri, rq->cpu, prio);
 }
@@ -910,6 +917,13 @@ dec_rt_prio_smp(struct rt_rq *rt_rq, int prio, int prev_prio)
 {
 	struct rq *rq = rq_of_rt_rq(rt_rq);
 
+#ifdef CONFIG_RT_GROUP_SCHED
+	/*
+	 * Change rq's cpupri only if rt_rq is the top queue.
+	 */
+	if (&rq->rt != rt_rq)
+		return;
+#endif
 	if (rq->online && rt_rq->highest_prio.curr != prev_prio)
 		cpupri_set(&rq->rd->cpupri, rq->cpu, rt_rq->highest_prio.curr);
 }
