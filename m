Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933282AbaJUQgK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 12:36:10 -0400
Received: from relay.parallels.com ([195.214.232.42]:43410 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932452AbaJUQgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 12:36:06 -0400
Message-ID: <1413909356.19914.128.camel@tkhai>
Subject: [RFC] sched/dl: Fix preemption checks
From: Kirill Tkhai <ktkhai@parallels.com>
To: Juri Lelli <juri.lelli@gmail.com>, <linux-kernel@vger.kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Kirill Tkhai <tkhai@yandex.ru>
Date: Tue, 21 Oct 2014 20:35:56 +0400
Organization: Parallels
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b3 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.26.172]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


1)switched_to_dl() check is wrong. We reschedule only
if rq->curr is deadline task, and we do not reschedule
if it's a lower priority task. But we must always
preempt a task of other classes.

2)dl_task_timer():
Policy does not change in case of priority inheritance.
rt_mutex_setprio() changes prio, while policy remains old.

So we lose some balancing logic in dl_task_timer() and
switched_to_dl() when we check policy instead of priority.
Boosted task may be rq->curr.

(I didn't change switched_from_dl() because no check is
necessary there at all).

I've looked at this place(switched_to_dl) several times
and even fixed this function, but found just now...
I suppose some performance tests may work better after this.

Completely untested, just RFC.

Juri how about this?

Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>
---
 kernel/sched/deadline.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 256e577..937a875 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -532,7 +532,7 @@ static enum hrtimer_restart dl_task_timer(struct hrtimer *timer)
 	dl_se->dl_yielded = 0;
 	if (task_on_rq_queued(p)) {
 		enqueue_task_dl(rq, p, ENQUEUE_REPLENISH);
-		if (task_has_dl_policy(rq->curr))
+		if (dl_task(rq->curr))
 			check_preempt_curr_dl(rq, p, 0);
 		else
 			resched_curr(rq);
@@ -1607,8 +1607,12 @@ static void switched_to_dl(struct rq *rq, struct task_struct *p)
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
 




