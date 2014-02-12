Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753372AbaBLI35 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 03:29:57 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50183 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752055AbaBLIOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 03:14:00 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Kirill Tkhai" <tkhai@yandex.ru>,
        "Ingo Molnar" <mingo@kernel.org>,
        "Peter Zijlstra" <peterz@infradead.org>,
        "Steven Rostedt" <rostedt@goodmis.org>
Date: Wed, 12 Feb 2014 08:10:12 +0000
Message-ID: <lsq.1392192612.216027001@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 46/79] sched/rt: Fix rq's cpupri leak while
 enqueue/dequeue child RT entities
In-Reply-To: <lsq.1392192611.998273004@decadent.org.uk>
X-SA-Exim-Connect-IP: 91.84.160.45
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.55-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust filename]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/sched_rt.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -719,6 +719,13 @@ inc_rt_prio_smp(struct rt_rq *rt_rq, int
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
@@ -728,6 +735,13 @@ dec_rt_prio_smp(struct rt_rq *rt_rq, int
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

