Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841AbaEHKmZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 06:42:25 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33086 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753188AbaEHKmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 06:42:19 -0400
Date: Thu, 8 May 2014 03:41:20 -0700
From: tip-bot for Juri Lelli <tipbot@zytor.com>
Message-ID: <tip-5bfd126e80dca70431aef8fdbc1cf14535f3c338@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, tglx@linutronix.de, yjay.kim@lge.com,
        juri.lelli@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, yjay.kim@lge.com,
        juri.lelli@gmail.com
In-Reply-To: <20140429103953.e68eba1b2ac3309214e3dc5a@gmail.com>
References: <20140429103953.e68eba1b2ac3309214e3dc5a@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/deadline: Fix sched_yield() behavior
Git-Commit-ID: 5bfd126e80dca70431aef8fdbc1cf14535f3c338
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

Commit-ID:  5bfd126e80dca70431aef8fdbc1cf14535f3c338
Gitweb:     http://git.kernel.org/tip/5bfd126e80dca70431aef8fdbc1cf14535f3c338
Author:     Juri Lelli <juri.lelli@gmail.com>
AuthorDate: Tue, 15 Apr 2014 13:49:04 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 7 May 2014 11:51:31 +0200

sched/deadline: Fix sched_yield() behavior

yield_task_dl() is broken:

 o it forces current to be throttled setting its runtime to zero;
 o it sets current's dl_se->dl_new to one, expecting that dl_task_timer()
   will queue it back with proper parameters at replenish time.

Unfortunately, dl_task_timer() has this check at the very beginning:

	if (!dl_task(p) || dl_se->dl_new)
		goto unlock;

So, it just bails out and the task is never replenished. It actually
yielded forever.

To fix this, introduce a new flag indicating that the task properly yielded
the CPU before its current runtime expired. While this is a little overdoing
at the moment, the flag would be useful in the future to discriminate between
"good" jobs (of which remaining runtime could be reclaimed, i.e. recycled)
and "bad" jobs (for which dl_throttled task has been set) that needed to be
stopped.

Reported-by: yjay.kim <yjay.kim@lge.com>
Signed-off-by: Juri Lelli <juri.lelli@gmail.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20140429103953.e68eba1b2ac3309214e3dc5a@gmail.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/sched.h   | 7 +++++--
 kernel/sched/core.c     | 1 +
 kernel/sched/deadline.c | 5 +++--
 3 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 25f54c7..2a4298f 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1153,9 +1153,12 @@ struct sched_dl_entity {
 	 *
 	 * @dl_boosted tells if we are boosted due to DI. If so we are
 	 * outside bandwidth enforcement mechanism (but only until we
-	 * exit the critical section).
+	 * exit the critical section);
+	 *
+	 * @dl_yielded tells if task gave up the cpu before consuming
+	 * all its available runtime during the last job.
 	 */
-	int dl_throttled, dl_new, dl_boosted;
+	int dl_throttled, dl_new, dl_boosted, dl_yielded;
 
 	/*
 	 * Bandwidth enforcement timer. Each -deadline task has its
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 9fe2190..e62c65a 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3124,6 +3124,7 @@ __setparam_dl(struct task_struct *p, const struct sched_attr *attr)
 	dl_se->dl_bw = to_ratio(dl_se->dl_period, dl_se->dl_runtime);
 	dl_se->dl_throttled = 0;
 	dl_se->dl_new = 1;
+	dl_se->dl_yielded = 0;
 }
 
 static void __setscheduler_params(struct task_struct *p,
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index b080957..800e99b 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -528,6 +528,7 @@ static enum hrtimer_restart dl_task_timer(struct hrtimer *timer)
 	sched_clock_tick();
 	update_rq_clock(rq);
 	dl_se->dl_throttled = 0;
+	dl_se->dl_yielded = 0;
 	if (p->on_rq) {
 		enqueue_task_dl(rq, p, ENQUEUE_REPLENISH);
 		if (task_has_dl_policy(rq->curr))
@@ -893,10 +894,10 @@ static void yield_task_dl(struct rq *rq)
 	 * We make the task go to sleep until its current deadline by
 	 * forcing its runtime to zero. This way, update_curr_dl() stops
 	 * it and the bandwidth timer will wake it up and will give it
-	 * new scheduling parameters (thanks to dl_new=1).
+	 * new scheduling parameters (thanks to dl_yielded=1).
 	 */
 	if (p->dl.runtime > 0) {
-		rq->curr->dl.dl_new = 1;
+		rq->curr->dl.dl_yielded = 1;
 		p->dl.runtime = 0;
 	}
 	update_curr_dl(rq);
