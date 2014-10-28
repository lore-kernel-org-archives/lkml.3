Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755243AbaJ1LDN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 07:03:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50902 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755191AbaJ1LDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 07:03:08 -0400
Date: Tue, 28 Oct 2014 04:01:49 -0700
From: tip-bot for Juri Lelli <tipbot@zytor.com>
Message-ID: <tip-64be6f1f5f710f5995d41caf8a1767fe6d2b5a87@git.kernel.org>
Cc: torvalds@linux-foundation.org, peterz@infradead.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, raistlin@linux.it,
        juri.lelli@arm.com, mingo@kernel.org, hpa@zytor.com,
        daniel.wagner@bmw-carit.de, fchecconi@gmail.com,
        michael@amarulasolutions.com
Reply-To: torvalds@linux-foundation.org, raistlin@linux.it,
        peterz@infradead.org, linux-kernel@vger.kernel.org, juri.lelli@arm.com,
        tglx@linutronix.de, mingo@kernel.org, hpa@zytor.com,
        fchecconi@gmail.com, daniel.wagner@bmw-carit.de,
        michael@amarulasolutions.com
In-Reply-To: <1414142198-18552-4-git-send-email-juri.lelli@arm.com>
References: <1414142198-18552-4-git-send-email-juri.lelli@arm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/deadline: Don'
 t replenish from a !SCHED_DEADLINE entity
Git-Commit-ID: 64be6f1f5f710f5995d41caf8a1767fe6d2b5a87
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

Commit-ID:  64be6f1f5f710f5995d41caf8a1767fe6d2b5a87
Gitweb:     http://git.kernel.org/tip/64be6f1f5f710f5995d41caf8a1767fe6d2b5a87
Author:     Juri Lelli <juri.lelli@arm.com>
AuthorDate: Fri, 24 Oct 2014 10:16:37 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 28 Oct 2014 10:46:00 +0100

sched/deadline: Don't replenish from a !SCHED_DEADLINE entity

In the deboost path, right after the dl_boosted flag has been
reset, we can currently end up replenishing using -deadline
parameters of a !SCHED_DEADLINE entity. This of course causes
a bug, as those parameters are empty.

In the case depicted above it is safe to simply bail out, as
the deboosted task is going to be back to its original scheduling
class anyway.

Reported-by: Daniel Wagner <daniel.wagner@bmw-carit.de>
Tested-by: Daniel Wagner <daniel.wagner@bmw-carit.de>
Signed-off-by: Juri Lelli <juri.lelli@arm.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: vincent@legout.info
Cc: Dario Faggioli <raistlin@linux.it>
Cc: Michael Trimarchi <michael@amarulasolutions.com>
Cc: Fabio Checconi <fchecconi@gmail.com>
Link: http://lkml.kernel.org/r/1414142198-18552-4-git-send-email-juri.lelli@arm.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/deadline.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 256e577..92279ea 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -847,8 +847,19 @@ static void enqueue_task_dl(struct rq *rq, struct task_struct *p, int flags)
 	 * smaller than our one... OTW we keep our runtime and
 	 * deadline.
 	 */
-	if (pi_task && p->dl.dl_boosted && dl_prio(pi_task->normal_prio))
+	if (pi_task && p->dl.dl_boosted && dl_prio(pi_task->normal_prio)) {
 		pi_se = &pi_task->dl;
+	} else if (!dl_prio(p->normal_prio)) {
+		/*
+		 * Special case in which we have a !SCHED_DEADLINE task
+		 * that is going to be deboosted, but exceedes its
+		 * runtime while doing so. No point in replenishing
+		 * it, as it's going to return back to its original
+		 * scheduling class after this.
+		 */
+		BUG_ON(!p->dl.dl_boosted || flags != ENQUEUE_REPLENISH);
+		return;
+	}
 
 	/*
 	 * If p is throttled, we do nothing. In fact, if it exhausted
