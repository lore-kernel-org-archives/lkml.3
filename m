Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755571AbaJ1LFI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 07:05:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50963 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056AbaJ1LEb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 07:04:31 -0400
Date: Tue, 28 Oct 2014 04:03:45 -0700
From: tip-bot for Kirill Tkhai <tipbot@zytor.com>
Message-ID: <tip-f3a7e1a9c464a32ee186ab91388313c82e7ce018@git.kernel.org>
Cc: juri.lelli@gmail.com, ktkhai@parallels.com, linux-kernel@vger.kernel.org,
        hpa@zytor.com, torvalds@linux-foundation.org, tglx@linutronix.de,
        mingo@kernel.org, peterz@infradead.org
Reply-To: peterz@infradead.org, torvalds@linux-foundation.org,
        tglx@linutronix.de, mingo@kernel.org, hpa@zytor.com,
        ktkhai@parallels.com, linux-kernel@vger.kernel.org,
        juri.lelli@gmail.com
In-Reply-To: <1413909356.19914.128.camel@tkhai>
References: <1413909356.19914.128.camel@tkhai>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/dl: Fix preemption checks
Git-Commit-ID: f3a7e1a9c464a32ee186ab91388313c82e7ce018
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

Commit-ID:  f3a7e1a9c464a32ee186ab91388313c82e7ce018
Gitweb:     http://git.kernel.org/tip/f3a7e1a9c464a32ee186ab91388313c82e7ce018
Author:     Kirill Tkhai <ktkhai@parallels.com>
AuthorDate: Tue, 21 Oct 2014 20:35:56 +0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 28 Oct 2014 10:46:10 +0100

sched/dl: Fix preemption checks

1) switched_to_dl() check is wrong. We reschedule only
   if rq->curr is deadline task, and we do not reschedule
   if it's a lower priority task. But we must always
   preempt a task of other classes.

2) dl_task_timer():
   Policy does not change in case of priority inheritance.
   rt_mutex_setprio() changes prio, while policy remains old.

So we lose some balancing logic in dl_task_timer() and
switched_to_dl() when we check policy instead of priority. Boosted
task may be rq->curr.

(I didn't change switched_from_dl() because no check is necessary
there at all).

I've looked at this place(switched_to_dl) several times and even fixed
this function, but found just now...  I suppose some performance tests
may work better after this.

Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Juri Lelli <juri.lelli@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/1413909356.19914.128.camel@tkhai
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/deadline.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 4616789..5285332 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -540,7 +540,7 @@ again:
 	dl_se->dl_yielded = 0;
 	if (task_on_rq_queued(p)) {
 		enqueue_task_dl(rq, p, ENQUEUE_REPLENISH);
-		if (task_has_dl_policy(rq->curr))
+		if (dl_task(rq->curr))
 			check_preempt_curr_dl(rq, p, 0);
 		else
 			resched_curr(rq);
@@ -1626,8 +1626,12 @@ static void switched_to_dl(struct rq *rq, struct task_struct *p)
 			/* Only reschedule if pushing failed */
 			check_resched = 0;
 #endif /* CONFIG_SMP */
-		if (check_resched && task_has_dl_policy(rq->curr))
-			check_preempt_curr_dl(rq, p, 0);
+		if (check_resched) {
+			if (dl_task(rq->curr))
+				check_preempt_curr_dl(rq, p, 0);
+			else
+				resched_curr(rq);
+		}
 	}
 }
 
