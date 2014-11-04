Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752271AbaKDLPe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 06:15:34 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:39271 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706AbaKDLPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 06:15:31 -0500
From: "pang.xunlei" <pang.xunlei@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Juri Lelli <juri.lelli@gmail.com>,
        "pang.xunlei" <pang.xunlei@linaro.org>
Subject: [PATCH v2 2/6] sched/rt: Optimize select_task_rq_rt() for non-RT curr task
Date: Tue,  4 Nov 2014 19:13:01 +0800
Message-Id: <1415099585-31174-2-git-send-email-pang.xunlei@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1415099585-31174-1-git-send-email-pang.xunlei@linaro.org>
References: <1415099585-31174-1-git-send-email-pang.xunlei@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When selecting the cpu for a waking RT task, if curr is a non-RT
task which is bound only on this cpu, then we can give it a chance
to select a different cpu(definitely an idle cpu if existing) for
the RT task to avoid curr starving.

Signed-off-by: pang.xunlei <pang.xunlei@linaro.org>
---
 kernel/sched/rt.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index da6922e..dc1f7f0 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -1340,6 +1340,11 @@ select_task_rq_rt(struct task_struct *p, int cpu, int sd_flag, int flags)
 	 * runqueue. Otherwise simply start this RT task
 	 * on its current runqueue.
 	 *
+	 * If the current task on @p's runqueue is a non-RT task,
+	 * and this task is bound on current runqueue, then try to
+	 * see if we can wake this RT task up on a different runqueue,
+	 * we will definitely find an idle cpu if there is any.
+	 *
 	 * We want to avoid overloading runqueues. If the woken
 	 * task is a higher priority, then it will stay on this CPU
 	 * and the lower prio task should be moved to another CPU.
@@ -1356,9 +1361,8 @@ select_task_rq_rt(struct task_struct *p, int cpu, int sd_flag, int flags)
 	 * This test is optimistic, if we get it wrong the load-balancer
 	 * will have to sort it out.
 	 */
-	if (curr && unlikely(rt_task(curr)) &&
-	    (curr->nr_cpus_allowed < 2 ||
-	     curr->prio <= p->prio)) {
+	if (curr && unlikely(curr->nr_cpus_allowed < 2 ||
+				curr->prio <= p->prio)) {
 		int target = find_lowest_rq(p);
 
 		if (target != -1)
-- 
1.7.9.5

