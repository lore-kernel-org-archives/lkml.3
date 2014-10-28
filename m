Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755215AbaJ1LDL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 07:03:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50904 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752636AbaJ1LDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 07:03:09 -0400
Date: Tue, 28 Oct 2014 04:02:07 -0700
From: tip-bot for Juri Lelli <tipbot@zytor.com>
Message-ID: <tip-aee38ea95419c818dfdde52b115aeffe9cbb259b@git.kernel.org>
Cc: juri.lelli@arm.com, hpa@zytor.com, peterz@infradead.org,
        tglx@linutronix.de, michael@amarulasolutions.com,
        daniel.wagner@bmw-carit.de, mingo@kernel.org,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        raistlin@linux.it, fchecconi@gmail.com
Reply-To: daniel.wagner@bmw-carit.de, michael@amarulasolutions.com,
        tglx@linutronix.de, hpa@zytor.com, juri.lelli@arm.com,
        peterz@infradead.org, fchecconi@gmail.com,
        torvalds@linux-foundation.org, raistlin@linux.it,
        linux-kernel@vger.kernel.org, mingo@kernel.org
In-Reply-To: <1414142198-18552-5-git-send-email-juri.lelli@arm.com>
References: <1414142198-18552-5-git-send-email-juri.lelli@arm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/deadline:
  Fix races between rt_mutex_setprio() and dl_task_timer()
Git-Commit-ID: aee38ea95419c818dfdde52b115aeffe9cbb259b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  aee38ea95419c818dfdde52b115aeffe9cbb259b
Gitweb:     http://git.kernel.org/tip/aee38ea95419c818dfdde52b115aeffe9cbb259b
Author:     Juri Lelli <juri.lelli@arm.com>
AuthorDate: Fri, 24 Oct 2014 10:16:38 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 28 Oct 2014 10:46:01 +0100

sched/deadline: Fix races between rt_mutex_setprio() and dl_task_timer()

dl_task_timer() is racy against several paths. Daniel noticed that
the replenishment timer may experience a race condition against an
enqueue_dl_entity() called from rt_mutex_setprio(). With his own
words:

 rt_mutex_setprio() resets p->dl.dl_throttled. So the pattern is:
 start_dl_timer() throttled = 1, rt_mutex_setprio() throlled = 0,
 sched_switch() -> enqueue_task(), dl_task_timer-> enqueue_task()
 throttled is 0

=> BUG_ON(on_dl_rq(dl_se)) fires as the scheduling entity is already
enqueued on the -deadline runqueue.

As we do for the other races, we just bail out in the replenishment
timer code.

Reported-by: Daniel Wagner <daniel.wagner@bmw-carit.de>
Tested-by: Daniel Wagner <daniel.wagner@bmw-carit.de>
Signed-off-by: Juri Lelli <juri.lelli@arm.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: vincent@legout.info
Cc: Dario Faggioli <raistlin@linux.it>
Cc: Michael Trimarchi <michael@amarulasolutions.com>
Cc: Fabio Checconi <fchecconi@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/1414142198-18552-5-git-send-email-juri.lelli@arm.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/deadline.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 92279ea..4616789 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -518,12 +518,20 @@ again:
 	}
 
 	/*
-	 * We need to take care of a possible races here. In fact, the
-	 * task might have changed its scheduling policy to something
-	 * different from SCHED_DEADLINE or changed its reservation
-	 * parameters (through sched_setattr()).
+	 * We need to take care of several possible races here:
+	 *
+	 *   - the task might have changed its scheduling policy
+	 *     to something different than SCHED_DEADLINE
+	 *   - the task might have changed its reservation parameters
+	 *     (through sched_setattr())
+	 *   - the task might have been boosted by someone else and
+	 *     might be in the boosting/deboosting path
+	 *
+	 * In all this cases we bail out, as the task is already
+	 * in the runqueue or is going to be enqueued back anyway.
 	 */
-	if (!dl_task(p) || dl_se->dl_new)
+	if (!dl_task(p) || dl_se->dl_new ||
+	    dl_se->dl_boosted || !dl_se->dl_throttled)
 		goto unlock;
 
 	sched_clock_tick();
