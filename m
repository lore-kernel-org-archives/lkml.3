Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755881AbaJXJRK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 05:17:10 -0400
Received: from service87.mimecast.com ([91.220.42.44]:37818 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753499AbaJXJQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 05:16:53 -0400
From: Juri Lelli <juri.lelli@arm.com>
To: linux-kernel@vger.kernel.org, peterz@infradead.org
Cc: juri.lelli@gmail.com, mingo@redhat.com, daniel.wagner@bmw-carit.de,
        vincent@legout.info, Juri Lelli <juri.lelli@arm.com>,
        Dario Faggioli <raistlin@linux.it>,
        Michael Trimarchi <michael@amarulasolutions.com>,
        Fabio Checconi <fchecconi@gmail.com>
Subject: [PATCH 4/4] sched/deadline: fix races between rt_mutex_setprio and dl_task_timer
Date: Fri, 24 Oct 2014 10:16:38 +0100
Message-Id: <1414142198-18552-5-git-send-email-juri.lelli@arm.com>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <1414142198-18552-1-git-send-email-juri.lelli@arm.com>
References: <1414142198-18552-1-git-send-email-juri.lelli@arm.com>
X-OriginalArrivalTime: 24 Oct 2014 09:16:51.0732 (UTC) FILETIME=[3F2A7540:01CFEF6B]
X-MC-Unique: 114102410165201801
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by nfs id s9O9I1Ct022074

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

Signed-off-by: Juri Lelli <juri.lelli@arm.com>
Reported-by: Daniel Wagner <daniel.wagner@bmw-carit.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Juri Lelli <juri.lelli@gmail.com>
Cc: Dario Faggioli <raistlin@linux.it>
Cc: Michael Trimarchi <michael@amarulasolutions.com>
Cc: Fabio Checconi <fchecconi@gmail.com>
Cc: linux-kernel@vger.kernel.org
---
 kernel/sched/deadline.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index cf2c040..28d6088 100644
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
-- 
2.1.2


