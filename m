Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751762AbaJBJw1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 05:52:27 -0400
Received: from relay.parallels.com ([195.214.232.42]:41398 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066AbaJBJwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 05:52:25 -0400
Message-ID: <1412243541.20287.28.camel@tkhai>
Subject: Re: [PATCH v2 2/3] sched/dl: Cleanup prio_changed_dl()
From: Kirill Tkhai <ktkhai@parallels.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Kirill Tkhai <tkhai@yandex.ru>, <linux-kernel@vger.kernel.org>,
        "Ingo Molnar" <mingo@redhat.com>, Juri Lelli <juri.lelli@gmail.com>
Date: Thu, 2 Oct 2014 13:52:21 +0400
In-Reply-To: <20141002093600.GC2849@worktop.programming.kicks-ass.net>
References: <20140930210412.5258.35299.stgit@localhost>
	 <20140930210428.5258.32223.stgit@localhost>
	 <20141002093600.GC2849@worktop.programming.kicks-ass.net>
Organization: Parallels
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b3 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.30.26.172]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

В Чт, 02/10/2014 в 11:36 +0200, Peter Zijlstra пишет:
> On Wed, Oct 01, 2014 at 01:04:35AM +0400, Kirill Tkhai wrote:
> > From: Kirill Tkhai <ktkhai@parallels.com>
> > 
> > rq->curr task can't be in "dequeued" state in prio_changed_dl().
> > (The only place we can have that is __schedule()). So, we delete
> > rq->curr check.
> 
> the CBS timer can throttle it right?

Yeah, it's better to check for on_dl_rq():

[PATCH]sched/dl: Cleanup prio_changed_dl()
    
rq->curr task can't be in "dequeued" state in prio_changed_dl().
(The only place we can have that is __schedule()). So, we delete
rq->curr check.

We shouldn't do balancing if deadline task is throttled too.

Also delete "else" branch which is dead code (switched_to_dl()
is not interested in dequeued tasks and we are not interested
in balancing in this case).
    
Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 63f8b4a..ccea917 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -1638,35 +1638,33 @@ static void switched_to_dl(struct rq *rq, struct task_struct *p)
 static void prio_changed_dl(struct rq *rq, struct task_struct *p,
 			    int oldprio)
 {
-	if (task_on_rq_queued(p) || rq->curr == p) {
+	if (!on_dl_rq(&p->dl))
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


