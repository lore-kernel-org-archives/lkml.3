Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754930AbaC3XtK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 19:49:10 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:37332 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754701AbaC3Xns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 19:43:48 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Peter Zijlstra" <peterz@infradead.org>,
        "George McCollister" <george.mccollister@gmail.com>,
        "Ingo Molnar" <mingo@kernel.org>
Date: Mon, 31 Mar 2014 00:23:35 +0100
Message-ID: <lsq.1396221815.998103892@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 149/200] sched: Fix double normalization of vruntime
In-Reply-To: <lsq.1396221814.369444335@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.56-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust filename]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/sched_fair.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -4953,15 +4953,15 @@ static void switched_from_fair(struct rq
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

