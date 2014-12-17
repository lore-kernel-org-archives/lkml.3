Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751538AbaLQLBz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 06:01:55 -0500
Received: from mail3.unitn.it ([193.205.206.24]:55733 "EHLO mail3.unitn.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750894AbaLQLBx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 06:01:53 -0500
X-Greylist: delayed 651 seconds by postgrey-1.27 at vger.kernel.org; Wed, 17 Dec 2014 06:01:53 EST
From: Luca Abeni <luca.abeni@unitn.it>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@gmail.com>,
        Dario Faggioli <raistlin@linux.it>, linux-kernel@vger.kernel.org,
        luca.abeni@unitn.it
Subject: [PATCH 1/2] Fix migration of SCHED_DEADLINE tasks
Date: Wed, 17 Dec 2014 11:50:31 +0100
Message-Id: <1418813432-20797-2-git-send-email-luca.abeni@unitn.it>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1418813432-20797-1-git-send-email-luca.abeni@unitn.it>
References: <1418813432-20797-1-git-send-email-luca.abeni@unitn.it>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to global EDF, tasks should be migrated between runqueues
without checking if their scheduling deadlines and runtimes are valid.
However, SCHED_DEADLINE currently performs such a check:
a migration happens doing
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
---
 kernel/sched/deadline.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index e5db8c6..55af498 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -826,10 +826,10 @@ enqueue_dl_entity(struct sched_dl_entity *dl_se,
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
1.9.1

