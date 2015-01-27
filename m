Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932967AbbA0Mpz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 07:45:55 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34957 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758378AbbA0MRk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 07:17:40 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Luca Abeni <luca.abeni@unitn.it>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Dario Faggioli <raistlin@linux.it>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 029/126] sched/deadline: Avoid double-accounting in case of missed deadlines
Date: Tue, 27 Jan 2015 12:15:34 +0000
Message-Id: <1422361031-19364-30-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
References: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luca Abeni <luca.abeni@unitn.it>

commit 269ad8015a6b2bb1cf9e684da4921eb6fa0a0c88 upstream.

The dl_runtime_exceeded() function is supposed to ckeck if
a SCHED_DEADLINE task must be throttled, by checking if its
current runtime is <= 0. However, it also checks if the
scheduling deadline has been missed (the current time is
larger than the current scheduling deadline), further
decreasing the runtime if this happens.
This "double accounting" is wrong:

- In case of partitioned scheduling (or single CPU), this
  happens if task_tick_dl() has been called later than expected
  (due to small HZ values). In this case, the current runtime is
  also negative, and replenish_dl_entity() can take care of the
  deadline miss by recharging the current runtime to a value smaller
  than dl_runtime

- In case of global scheduling on multiple CPUs, scheduling
  deadlines can be missed even if the task did not consume more
  runtime than expected, hence penalizing the task is wrong

This patch fix this problem by throttling a SCHED_DEADLINE task
only when its runtime becomes negative, and not modifying the runtime

Signed-off-by: Luca Abeni <luca.abeni@unitn.it>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Juri Lelli <juri.lelli@gmail.com>
Cc: Dario Faggioli <raistlin@linux.it>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/1418813432-20797-3-git-send-email-luca.abeni@unitn.it
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 kernel/sched/deadline.c | 19 +------------------
 1 file changed, 1 insertion(+), 18 deletions(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index a07b08ce8307..d10e40862f7f 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -567,24 +567,7 @@ void init_dl_task_timer(struct sched_dl_entity *dl_se)
 static
 int dl_runtime_exceeded(struct rq *rq, struct sched_dl_entity *dl_se)
 {
-	int dmiss = dl_time_before(dl_se->deadline, rq_clock(rq));
-	int rorun = dl_se->runtime <= 0;
-
-	if (!rorun && !dmiss)
-		return 0;
-
-	/*
-	 * If we are beyond our current deadline and we are still
-	 * executing, then we have already used some of the runtime of
-	 * the next instance. Thus, if we do not account that, we are
-	 * stealing bandwidth from the system at each deadline miss!
-	 */
-	if (dmiss) {
-		dl_se->runtime = rorun ? dl_se->runtime : 0;
-		dl_se->runtime -= rq_clock(rq) - dl_se->deadline;
-	}
-
-	return 1;
+	return (dl_se->runtime <= 0);
 }
 
 extern bool sched_rt_bandwidth_account(struct rt_rq *rt_rq);
-- 
2.1.4

