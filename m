Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753254AbaKDLPs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 06:15:48 -0500
Received: from mail-pd0-f173.google.com ([209.85.192.173]:38802 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753144AbaKDLPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 06:15:41 -0500
From: "pang.xunlei" <pang.xunlei@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Juri Lelli <juri.lelli@gmail.com>,
        "pang.xunlei" <pang.xunlei@linaro.org>
Subject: [PATCH v2 5/6] sched/dl: Optimize select_task_rq_dl() for non-DL curr task
Date: Tue,  4 Nov 2014 19:13:04 +0800
Message-Id: <1415099585-31174-5-git-send-email-pang.xunlei@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1415099585-31174-1-git-send-email-pang.xunlei@linaro.org>
References: <1415099585-31174-1-git-send-email-pang.xunlei@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When selecting the cpu for a waking DL task, if curr is a non-DL
task which is bound only on this cpu, then we can give it a chance
to select a different cpu for this DL task to avoid curr starving.

Signed-off-by: pang.xunlei <pang.xunlei@linaro.org>
---
 kernel/sched/deadline.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 7b0b2d2..1f64d4a 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -954,6 +954,9 @@ select_task_rq_dl(struct task_struct *p, int cpu, int sd_flag, int flags)
 	struct task_struct *curr;
 	struct rq *rq;
 
+	if (p->nr_cpus_allowed == 1)
+		goto out;
+
 	if (sd_flag != SD_BALANCE_WAKE && sd_flag != SD_BALANCE_FORK)
 		goto out;
 
@@ -970,11 +973,14 @@ select_task_rq_dl(struct task_struct *p, int cpu, int sd_flag, int flags)
 	 * can!) we prefer to send it somewhere else. On the
 	 * other hand, if it has a shorter deadline, we
 	 * try to make it stay here, it might be important.
+	 *
+	 * If the current task on @p's runqueue is a non-DL task,
+	 * and this task is bound on current runqueue, then try to
+	 * see if we can wake this DL task up on a different runqueue,
 	 */
-	if (unlikely(dl_task(curr)) &&
-	    (curr->nr_cpus_allowed < 2 ||
-	     !dl_entity_preempt(&p->dl, &curr->dl)) &&
-	    (p->nr_cpus_allowed > 1)) {
+	if (unlikely(curr->nr_cpus_allowed < 2) ||
+		unlikely(dl_task(curr) &&
+				!dl_entity_preempt(&p->dl, &curr->dl))) {
 		int target = find_later_rq(p);
 
 		if (target != -1)
-- 
1.7.9.5

