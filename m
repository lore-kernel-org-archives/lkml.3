Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966420AbaCUAS3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 20:18:29 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37370 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966029AbaCUAJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 20:09:36 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        George McCollister <george.mccollister@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 3.4 03/35] sched: Fix double normalization of vruntime
Date: Thu, 20 Mar 2014 17:10:54 -0700
Message-Id: <20140321001054.247107992@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140321001054.038170009@linuxfoundation.org>
References: <20140321001054.038170009@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: George McCollister <george.mccollister@gmail.com>

commit 791c9e0292671a3bfa95286bb5c08129d8605618 upstream.

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

Signed-off-by: George McCollister <george.mccollister@gmail.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1392767811-28916-1-git-send-email-george.mccollister@gmail.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/sched/fair.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5270,15 +5270,15 @@ static void switched_from_fair(struct rq
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


