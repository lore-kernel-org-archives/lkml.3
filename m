Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752619AbaCBVVd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 16:21:33 -0500
Received: from forward19.mail.yandex.net ([95.108.253.144]:34820 "EHLO
	forward19.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751964AbaCBVVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 16:21:32 -0500
From: Kirill Tkhai <tkhai@yandex.ru>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Subject: [PATCH]sched/rt: Reduce race between inc_rt_group and do_sched_rt_period_timer
MIME-Version: 1.0
Message-Id: <25081393795289@web10g.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Mon, 03 Mar 2014 01:21:29 +0400
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Function do_sched_rt_period_timer() iterates through runqueues sequentially.
This makes it racy with inc_rt_group(). Sometimes when timer callback is
running we may skip hrtimer restart.

On the one hand it's not good to skip bandwidth timer. On the other hand,
there is no simple fix to complitelly get rid of the race.

So, let's use a fix, which is fast and simple and almost complitelly
reduces the race. It makes race probability very small.

Signed-off-by: Kirill Tkhai <tkhai@yandex.ru>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@redhat.com>
---
 kernel/sched/rt.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index facc824..db5303f 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -923,11 +923,23 @@ static void update_curr_rt(struct rq *rq)
 		rt_rq = rt_rq_of_se(rt_se);
 
 		if (sched_rt_runtime(rt_rq) != RUNTIME_INF) {
+			bool exceed;
 			raw_spin_lock(&rt_rq->rt_runtime_lock);
 			rt_rq->rt_time += delta_exec;
-			if (sched_rt_runtime_exceeded(rt_rq))
-				resched_task(curr);
+			exceed = sched_rt_runtime_exceeded(rt_rq);
 			raw_spin_unlock(&rt_rq->rt_runtime_lock);
+
+			if (exceed) {
+				resched_task(curr);
+				/*
+				 * The pair do_sched_rt_period_timer() and
+				 * inc_rt_group() is racy. Sometimes we may
+				 * have enqueued task and stopped timer
+				 * at this point. We reduce the race and
+				 * make its probability extremely small.
+				 */
+				start_rt_bandwidth(sched_rt_bandwidth(rt_rq));
+			}
 		}
 	}
 }
