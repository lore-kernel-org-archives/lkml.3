Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752589AbaI0IlV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2014 04:41:21 -0400
Received: from forward6l.mail.yandex.net ([84.201.143.139]:41259 "EHLO
	forward6l.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751654AbaI0IlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2014 04:41:18 -0400
X-Yandex-Uniq: 807d32f2-886c-4abc-9010-5a7a22128488
Authentication-Results: smtp12.mail.yandex.net; dkim=pass header.i=@yandex.ru
Subject: [PATCH 2/2] sched/dl: Cleanup prio_changed_dl()
From: Kirill Tkhai <tkhai@yandex.ru>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>, Kirill Tkhai <ktkhai@parallels.com>,
        Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@gmail.com>
Date: Sat, 27 Sep 2014 12:41:09 +0400
Message-ID: <20140927084104.1634.88783.stgit@localhost>
In-Reply-To: <20140927084044.1634.60573.stgit@localhost>
References: <20140927084044.1634.60573.stgit@localhost>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kirill Tkhai <ktkhai@parallels.com>

Now rq->curr task can't be dequeued in this function
(it's possible only in __schedule()).

Also, delete "else" branch which is dead code.

Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>
---
 kernel/sched/deadline.c |   50 +++++++++++++++++++++++------------------------
 1 file changed, 24 insertions(+), 26 deletions(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 63f8b4a..38b4f19 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -1638,35 +1638,33 @@ static void switched_to_dl(struct rq *rq, struct task_struct *p)
 static void prio_changed_dl(struct rq *rq, struct task_struct *p,
 			    int oldprio)
 {
-	if (task_on_rq_queued(p) || rq->curr == p) {
+	if (!task_on_rq_queued(p))
+		return;
 #ifdef CONFIG_SMP
-		/*
-		 * This might be too much, but unfortunately
-		 * we don't have the old deadline value, and
-		 * we can't argue if the task is increasing
-		 * or lowering its prio, so...
-		 */
-		if (!rq->dl.overloaded)
-			pull_dl_task(rq);
-
-		/*
-		 * If we now have a earlier deadline task than p,
-		 * then reschedule, provided p is still on this
-		 * runqueue.
-		 */
-		if (dl_time_before(rq->dl.earliest_dl.curr, p->dl.deadline) &&
-		    rq->curr == p)
-			resched_curr(rq);
-#else
-		/*
-		 * Again, we don't know if p has a earlier
-		 * or later deadline, so let's blindly set a
-		 * (maybe not needed) rescheduling point.
-		 */
+	/*
+	 * This might be too much, but unfortunately
+	 * we don't have the old deadline value, and
+	 * we can't argue if the task is increasing
+	 * or lowering its prio, so...
+	 */
+	if (!rq->dl.overloaded)
+		pull_dl_task(rq);
+	/*
+	 * If we now have a earlier deadline task than p,
+	 * then reschedule, provided p is still on this
+	 * runqueue.
+	 */
+	if (dl_time_before(rq->dl.earliest_dl.curr, p->dl.deadline) &&
+	    rq->curr == p)
 		resched_curr(rq);
+#else
+	/*
+	 * Again, we don't know if p has a earlier
+	 * or later deadline, so let's blindly set a
+	 * (maybe not needed) rescheduling point.
+	 */
+	resched_curr(rq);
 #endif /* CONFIG_SMP */
-	} else
-		switched_to_dl(rq, p);
 }
 
 const struct sched_class dl_sched_class = {

