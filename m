Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755964AbaJXJRO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 05:17:14 -0400
Received: from service87.mimecast.com ([91.220.42.44]:37753 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752127AbaJXJQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 05:16:52 -0400
From: Juri Lelli <juri.lelli@arm.com>
To: linux-kernel@vger.kernel.org, peterz@infradead.org
Cc: juri.lelli@gmail.com, mingo@redhat.com, daniel.wagner@bmw-carit.de,
        vincent@legout.info, Juri Lelli <juri.lelli@arm.com>,
        Dario Faggioli <raistlin@linux.it>,
        Michael Trimarchi <michael@amarulasolutions.com>,
        Fabio Checconi <fchecconi@gmail.com>
Subject: [PATCH 3/4] sched/deadline: don't replenish from a !SCHED_DEADLINE entity
Date: Fri, 24 Oct 2014 10:16:37 +0100
Message-Id: <1414142198-18552-4-git-send-email-juri.lelli@arm.com>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <1414142198-18552-1-git-send-email-juri.lelli@arm.com>
References: <1414142198-18552-1-git-send-email-juri.lelli@arm.com>
X-OriginalArrivalTime: 24 Oct 2014 09:16:51.0201 (UTC) FILETIME=[3ED96F10:01CFEF6B]
X-MC-Unique: 114102410165105301
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by nfs id s9O9Hahr022062

In the deboost path, right after the dl_boosted flag has been
reset, we can currently end up replenishing using -deadline
parameters of a !SCHED_DEADLINE entity. This of course causes
a bug, as those parameters are empty.

In the case depicted above it is safe to simply bail out, as
the deboosted task is going to be back to its original scheduling
class anyway.

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
 kernel/sched/deadline.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 710621b..cf2c040 100644
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
-- 
2.1.2


