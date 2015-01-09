Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932913AbbAIMel (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 07:34:41 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60274 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932755AbbAIMeg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 07:34:36 -0500
Date: Fri, 9 Jan 2015 04:34:02 -0800
From: tip-bot for Luca Abeni <tipbot@zytor.com>
Message-ID: <tip-269ad8015a6b2bb1cf9e684da4921eb6fa0a0c88@git.kernel.org>
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        hpa@zytor.com, juri.lelli@gmail.com, raistlin@linux.it,
        torvalds@linux-foundation.org, peterz@infradead.org, mingo@kernel.org,
        luca.abeni@unitn.it
Reply-To: tglx@linutronix.de, linux-kernel@vger.kernel.org, hpa@zytor.com,
        stable@vger.kernel.org, juri.lelli@gmail.com, raistlin@linux.it,
        torvalds@linux-foundation.org, peterz@infradead.org, mingo@kernel.org,
        luca.abeni@unitn.it
In-Reply-To: <1418813432-20797-3-git-send-email-luca.abeni@unitn.it>
References: <1418813432-20797-3-git-send-email-luca.abeni@unitn.it>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched/deadline:
  Avoid double-accounting in case of missed deadlines
Git-Commit-ID: 269ad8015a6b2bb1cf9e684da4921eb6fa0a0c88
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

Commit-ID:  269ad8015a6b2bb1cf9e684da4921eb6fa0a0c88
Gitweb:     http://git.kernel.org/tip/269ad8015a6b2bb1cf9e684da4921eb6fa0a0c88
Author:     Luca Abeni <luca.abeni@unitn.it>
AuthorDate: Wed, 17 Dec 2014 11:50:32 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 9 Jan 2015 11:18:57 +0100

sched/deadline: Avoid double-accounting in case of missed deadlines

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
Cc: <stable@vger.kernel.org>
Cc: Dario Faggioli <raistlin@linux.it>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/1418813432-20797-3-git-send-email-luca.abeni@unitn.it
Signed-off-by: Ingo Molnar <mingo@kernel.org>
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
