Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932881AbbAIMee (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 07:34:34 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60269 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932755AbbAIMe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 07:34:29 -0500
Date: Fri, 9 Jan 2015 04:33:43 -0800
From: tip-bot for Luca Abeni <tipbot@zytor.com>
Message-ID: <tip-6a503c3be937d275113b702e0421e5b0720abe8a@git.kernel.org>
Cc: hpa@zytor.com, mingo@kernel.org, torvalds@linux-foundation.org,
        peterz@infradead.org, tglx@linutronix.de, luca.abeni@unitn.it,
        linux-kernel@vger.kernel.org, juri.lelli@gmail.com, raistlin@linux.it,
        stable@vger.kernel.org
Reply-To: raistlin@linux.it, juri.lelli@gmail.com, stable@vger.kernel.org,
        luca.abeni@unitn.it, linux-kernel@vger.kernel.org,
        peterz@infradead.org, torvalds@linux-foundation.org,
        tglx@linutronix.de, hpa@zytor.com, mingo@kernel.org
In-Reply-To: <1418813432-20797-2-git-send-email-luca.abeni@unitn.it>
References: <1418813432-20797-2-git-send-email-luca.abeni@unitn.it>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched/deadline:
  Fix migration of SCHED_DEADLINE tasks
Git-Commit-ID: 6a503c3be937d275113b702e0421e5b0720abe8a
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

Commit-ID:  6a503c3be937d275113b702e0421e5b0720abe8a
Gitweb:     http://git.kernel.org/tip/6a503c3be937d275113b702e0421e5b0720abe8a
Author:     Luca Abeni <luca.abeni@unitn.it>
AuthorDate: Wed, 17 Dec 2014 11:50:31 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 9 Jan 2015 11:18:56 +0100

sched/deadline: Fix migration of SCHED_DEADLINE tasks

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
Cc: <stable@vger.kernel.org>
Cc: Dario Faggioli <raistlin@linux.it>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/1418813432-20797-2-git-send-email-luca.abeni@unitn.it
Signed-off-by: Ingo Molnar <mingo@kernel.org>
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
