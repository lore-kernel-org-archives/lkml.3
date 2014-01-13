Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752772AbaAMO2W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 09:28:22 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:51380 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930AbaAMO0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 09:26:09 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Kirill Tkhai <tkhai@yandex.ru>, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 41/96] sched/rt: Fix rq's cpupri leak while enqueue/dequeue child RT entities
Date: Mon, 13 Jan 2014 14:24:04 +0000
Message-Id: <1389623099-18783-42-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389623099-18783-1-git-send-email-luis.henriques@canonical.com>
References: <1389623099-18783-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.29 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 kernel/sched/rt.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 2a05e56..8480912 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -948,6 +948,13 @@ inc_rt_prio_smp(struct rt_rq *rt_rq, int prio, int prev_prio)
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
@@ -957,6 +964,13 @@ dec_rt_prio_smp(struct rt_rq *rt_rq, int prio, int prev_prio)
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
-- 
1.8.3.2

