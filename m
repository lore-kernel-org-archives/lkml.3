Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751692AbaLQLB4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 06:01:56 -0500
Received: from mail3.unitn.it ([193.205.206.24]:53462 "EHLO mail3.unitn.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750999AbaLQLBx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 06:01:53 -0500
From: Luca Abeni <luca.abeni@unitn.it>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@gmail.com>,
        Dario Faggioli <raistlin@linux.it>, linux-kernel@vger.kernel.org,
        luca.abeni@unitn.it
Subject: [PATCH 2/2] Avoid double-accounting in case of missed deadlines
Date: Wed, 17 Dec 2014 11:50:32 +0100
Message-Id: <1418813432-20797-3-git-send-email-luca.abeni@unitn.it>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1418813432-20797-1-git-send-email-luca.abeni@unitn.it>
References: <1418813432-20797-1-git-send-email-luca.abeni@unitn.it>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
 kernel/sched/deadline.c | 19 +------------------
 1 file changed, 1 insertion(+), 18 deletions(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 55af498..b52092f 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -570,24 +570,7 @@ void init_dl_task_timer(struct sched_dl_entity *dl_se)
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
1.9.1

