Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758023AbaAFXwW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 18:52:22 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:47712 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932342AbaAFWj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:39:26 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Kirill Tkhai <tkhai@yandex.ru>, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 3.12 059/144] sched/rt: Fix rqs cpupri leak while enqueue/dequeue child RT entities
Date: Mon,  6 Jan 2014 14:37:00 -0800
Message-Id: <20140106223747.035975426@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140106223745.326293132@linuxfoundation.org>
References: <20140106223745.326293132@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kirill Tkhai <tkhai@yandex.ru>

commit 757dfcaa41844595964f1220f1d33182dae49976 upstream.

This patch touches the RT group scheduling case.

Functions inc_rt_prio_smp() and dec_rt_prio_smp() change (global) rq's
priority, while rt_rq passed to them may be not the top-level rt_rq.
This is wrong, because changing of priority on a child level does not
guarantee that the priority is the highest all over the rq. So, this
leak makes RT balancing unusable.

The short example: the task having the highest priority among all rq's
RT tasks (no one other task has the same priority) are waking on a
throttle rt_rq.  The rq's cpupri is set to the task's priority
equivalent, but real rq->rt.highest_prio.curr is less.

The patch below fixes the problem.

Signed-off-by: Kirill Tkhai <tkhai@yandex.ru>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
CC: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/49231385567953@web4m.yandex.ru
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/sched/rt.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -899,6 +899,13 @@ inc_rt_prio_smp(struct rt_rq *rt_rq, int
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
@@ -908,6 +915,13 @@ dec_rt_prio_smp(struct rt_rq *rt_rq, int
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


