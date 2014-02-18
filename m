Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752758AbaBRX56 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 18:57:58 -0500
Received: from mail-ob0-f170.google.com ([209.85.214.170]:55466 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752537AbaBRX5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 18:57:53 -0500
From: George McCollister <george.mccollister@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: George McCollister <george.mccollister@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH] sched: fix double normalization of vruntime
Date: Tue, 18 Feb 2014 17:56:51 -0600
Message-Id: <1392767811-28916-1-git-send-email-george.mccollister@gmail.com>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dequeue_entity() is called when p->on_rq and sets se->on_rq = 0
which appears to guarentee that the !se->on_rq condition is met.
If the task has done set_current_state(TASK_INTERRUPTIBLE) without
schedule() the second condition will be met and vruntime will be
incorrectly adjusted twice.

In certain cases this can result in the task's vruntime never increasing
past the vruntime of other tasks on the CFS' run queue, starving them of
CPU time.

This patch changes switched_from_fair() to use !p->on_rq instead of
!se->on_rq.

I'm able to cause a task with a priority of 120 to starve all other
tasks with the same priority on an ARM platform running 3.2.51-rt72
PREEMPT RT by writing one character at time to a serial tty (16550 UART)
in a tight loop. I'm also able to verify making this change corrects the
problem on that platform and kernel version.

I haven't and not sure I will have an opportunity to get a newer kernel
version running on the platform mentioned above and have yet to
reproduce the problem on another platform.
---
 kernel/sched/fair.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 966cc2b..fa1c6df 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -6999,15 +6999,15 @@ static void switched_from_fair(struct rq *rq, struct task_struct *p)
 	struct cfs_rq *cfs_rq = cfs_rq_of(se);
 
 	/*
-	 * Ensure the task's vruntime is normalized, so that when its
+	 * Ensure the task's vruntime is normalized, so that when it's
 	 * switched back to the fair class the enqueue_entity(.flags=0) will
 	 * do the right thing.
 	 *
-	 * If it was on_rq, then the dequeue_entity(.flags=0) will already
-	 * have normalized the vruntime, if it was !on_rq, then only when
+	 * If it's on_rq, then the dequeue_entity(.flags=0) will already
+	 * have normalized the vruntime, if it's !on_rq, then only when
 	 * the task is sleeping will it still have non-normalized vruntime.
 	 */
-	if (!se->on_rq && p->state != TASK_RUNNING) {
+	if (!p->on_rq && p->state != TASK_RUNNING) {
 		/*
 		 * Fix up our vruntime so that the current sleep doesn't
 		 * cause 'unlimited' sleep bonus.
-- 
1.8.2.1

