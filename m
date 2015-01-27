Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932950AbbA0Mpw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 07:45:52 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34961 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758382AbbA0MRk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 07:17:40 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Luca Abeni <luca.abeni@unitn.it>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Dario Faggioli <raistlin@linux.it>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 028/126] sched/deadline: Fix migration of SCHED_DEADLINE tasks
Date: Tue, 27 Jan 2015 12:15:33 +0000
Message-Id: <1422361031-19364-29-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
References: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luca Abeni <luca.abeni@unitn.it>

commit 6a503c3be937d275113b702e0421e5b0720abe8a upstream.

According to global EDF, tasks should be migrated between runqueues
without checking if their scheduling deadlines and runtimes are valid.
However, SCHED_DEADLINE currently performs such a check:
a migration happens doing:

	deactivate_task(rq, next_task, 0);
	set_task_cpu(next_task, later_rq->cpu);
	activate_task(later_rq, next_task, 0);

which ends up calling dequeue_task_dl(), setting the new CPU, and then
calling enqueue_task_dl().

enqueue_task_dl() then calls enqueue_dl_entity(), which calls
update_dl_entity(), which can modify scheduling deadline and runtime,
breaking global EDF scheduling.

As a result, some of the properties of global EDF are not respected:
for example, a taskset {(30, 80), (40, 80), (120, 170)} scheduled on
two cores can have unbounded response times for the third task even
if 30/80+40/80+120/170 = 1.5809 < 2

This can be fixed by invoking update_dl_entity() only in case of
wakeup, or if this is a new SCHED_DEADLINE task.

Signed-off-by: Luca Abeni <luca.abeni@unitn.it>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Juri Lelli <juri.lelli@gmail.com>
Cc: Dario Faggioli <raistlin@linux.it>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/1418813432-20797-2-git-send-email-luca.abeni@unitn.it
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 kernel/sched/deadline.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index fc4f98b1258f..a07b08ce8307 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -823,10 +823,10 @@ enqueue_dl_entity(struct sched_dl_entity *dl_se,
 	 * parameters of the task might need updating. Otherwise,
 	 * we want a replenishment of its runtime.
 	 */
-	if (!dl_se->dl_new && flags & ENQUEUE_REPLENISH)
-		replenish_dl_entity(dl_se, pi_se);
-	else
+	if (dl_se->dl_new || flags & ENQUEUE_WAKEUP)
 		update_dl_entity(dl_se, pi_se);
+	else if (flags & ENQUEUE_REPLENISH)
+		replenish_dl_entity(dl_se, pi_se);
 
 	__enqueue_dl_entity(dl_se);
 }
-- 
2.1.4

