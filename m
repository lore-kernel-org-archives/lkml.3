Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751533AbaKCKba (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 05:31:30 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:47568 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228AbaKCKbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 05:31:22 -0500
From: "pang.xunlei" <pang.xunlei@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        "pang.xunlei" <pang.xunlei@linaro.org>
Subject: [PATCH 3/3] sched/rt: Optimize select_task_rq_rt() for non-RT curr task
Date: Mon,  3 Nov 2014 18:30:20 +0800
Message-Id: <1415010620-6176-3-git-send-email-pang.xunlei@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1415010620-6176-1-git-send-email-pang.xunlei@linaro.org>
References: <1415010620-6176-1-git-send-email-pang.xunlei@linaro.org>
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
index d024e6c..89202ab 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -1319,6 +1319,11 @@ select_task_rq_rt(struct task_struct *p, int cpu, int sd_flag, int flags)
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
@@ -1335,9 +1340,8 @@ select_task_rq_rt(struct task_struct *p, int cpu, int sd_flag, int flags)
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

