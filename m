Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753982Ab3BRNCM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 08:02:12 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:42093 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753522Ab3BRNCI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 08:02:08 -0500
Date: Mon, 18 Feb 2013 18:31:46 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Cc: Mike Galbraith <efault@gmx.de>
Subject: [PATCH] sched: Skip looking at skip if next or last is set
Message-ID: <20130218130146.GA7472@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13021813-5806-0000-0000-00001FC693B8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pick_next_entity() prefers next, then last. However code checks if the
left entity can be skipped even if next / last is set.

Check if left entity should be skipped only if next/last is not set.

Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
---
 kernel/sched/fair.c |   31 +++++++++++++++----------------
 1 files changed, 15 insertions(+), 16 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index fdee793..cc97b12 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1900,27 +1900,26 @@ static struct sched_entity *pick_next_entity(struct cfs_rq *cfs_rq)
 	struct sched_entity *left = se;
 
 	/*
-	 * Avoid running the skip buddy, if running something else can
-	 * be done without getting too unfair.
+	 * Someone really wants next to run. If it's not unfair, run it.
 	 */
-	if (cfs_rq->skip == se) {
-		struct sched_entity *second = __pick_next_entity(se);
+	if (cfs_rq->next && wakeup_preempt_entity(cfs_rq->next, left) < 1) {
+		se = cfs_rq->next;
+	} else if (cfs_rq->last && wakeup_preempt_entity(cfs_rq->last, left) < 1) {
+		/*
+		 * Prefer last buddy, try to return the CPU to a preempted
+		 * task.
+		 */
+		se = cfs_rq->last;
+	} else if (cfs_rq->skip == left) {
+		/*
+		 * Avoid running the skip buddy, if running something else
+		 * can be done without getting too unfair.
+		 */
+		struct sched_entity *second = __pick_next_entity(left);
 		if (second && wakeup_preempt_entity(second, left) < 1)
 			se = second;
 	}
 
-	/*
-	 * Prefer last buddy, try to return the CPU to a preempted task.
-	 */
-	if (cfs_rq->last && wakeup_preempt_entity(cfs_rq->last, left) < 1)
-		se = cfs_rq->last;
-
-	/*
-	 * Someone really wants this to run. If it's not unfair, run it.
-	 */
-	if (cfs_rq->next && wakeup_preempt_entity(cfs_rq->next, left) < 1)
-		se = cfs_rq->next;
-
 	clear_buddies(cfs_rq, se);
 
 	return se;

