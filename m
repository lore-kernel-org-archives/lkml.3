Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752396AbaFEOfV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 10:35:21 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48344 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829AbaFEOfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 10:35:17 -0400
Date: Thu, 5 Jun 2014 07:34:21 -0700
From: tip-bot for Ben Segall <tipbot@zytor.com>
Message-ID: <tip-51f2176d74ace4c3f58579a605ef5a9720befb00@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, bsegall@google.com, hpa@zytor.com,
        mingo@kernel.org, torvalds@linux-foundation.org, peterz@infradead.org,
        tglx@linutronix.de, klamm@yandex-team.ru
Reply-To: mingo@kernel.org, hpa@zytor.com, bsegall@google.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        peterz@infradead.org, tglx@linutronix.de, klamm@yandex-team.ru
In-Reply-To: <20140519224945.20303.93530.stgit@sword-of-the-dawn.mtv.corp.google.com>
References: <20140519224945.20303.93530.stgit@sword-of-the-dawn.mtv.corp.google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/fair: Fix unlocked reads of some cfs_b->
 quota/period
Git-Commit-ID: 51f2176d74ace4c3f58579a605ef5a9720befb00
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

Commit-ID:  51f2176d74ace4c3f58579a605ef5a9720befb00
Gitweb:     http://git.kernel.org/tip/51f2176d74ace4c3f58579a605ef5a9720befb00
Author:     Ben Segall <bsegall@google.com>
AuthorDate: Mon, 19 May 2014 15:49:45 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 5 Jun 2014 11:52:00 +0200

sched/fair: Fix unlocked reads of some cfs_b->quota/period

sched_cfs_period_timer() reads cfs_b->period without locks before calling
do_sched_cfs_period_timer(), and similarly unthrottle_offline_cfs_rqs()
would read cfs_b->period without the right lock. Thus a simultaneous
change of bandwidth could cause corruption on any platform where ktime_t
or u64 writes/reads are not atomic.

Extend cfs_b->lock from do_sched_cfs_period_timer() to include the read of
cfs_b->period to solve that issue; unthrottle_offline_cfs_rqs() can just
use 1 rather than the exact quota, much like distribute_cfs_runtime()
does.

There is also an unlocked read of cfs_b->runtime_expires, but a race
there would only delay runtime expiry by a tick. Still, the comparison
should just be != anyway, which clarifies even that problem.

Signed-off-by: Ben Segall <bsegall@google.com>
Tested-by: Roman Gushchin <klamm@yandex-team.ru>
[peterz: Fix compile warn]
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20140519224945.20303.93530.stgit@sword-of-the-dawn.mtv.corp.google.com
Cc: pjt@google.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 40 +++++++++++++++++++++-------------------
 1 file changed, 21 insertions(+), 19 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index c9617b7..b71d8c3 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3224,10 +3224,12 @@ static void expire_cfs_rq_runtime(struct cfs_rq *cfs_rq)
 	 * has not truly expired.
 	 *
 	 * Fortunately we can check determine whether this the case by checking
-	 * whether the global deadline has advanced.
+	 * whether the global deadline has advanced. It is valid to compare
+	 * cfs_b->runtime_expires without any locks since we only care about
+	 * exact equality, so a partial write will still work.
 	 */
 
-	if ((s64)(cfs_rq->runtime_expires - cfs_b->runtime_expires) >= 0) {
+	if (cfs_rq->runtime_expires != cfs_b->runtime_expires) {
 		/* extend local deadline, drift is bounded above by 2 ticks */
 		cfs_rq->runtime_expires += TICK_NSEC;
 	} else {
@@ -3456,21 +3458,21 @@ next:
 static int do_sched_cfs_period_timer(struct cfs_bandwidth *cfs_b, int overrun)
 {
 	u64 runtime, runtime_expires;
-	int idle = 1, throttled;
+	int throttled;
 
-	raw_spin_lock(&cfs_b->lock);
 	/* no need to continue the timer with no bandwidth constraint */
 	if (cfs_b->quota == RUNTIME_INF)
-		goto out_unlock;
+		goto out_deactivate;
 
 	throttled = !list_empty(&cfs_b->throttled_cfs_rq);
-	/* idle depends on !throttled (for the case of a large deficit) */
-	idle = cfs_b->idle && !throttled;
 	cfs_b->nr_periods += overrun;
 
-	/* if we're going inactive then everything else can be deferred */
-	if (idle)
-		goto out_unlock;
+	/*
+	 * idle depends on !throttled (for the case of a large deficit), and if
+	 * we're going inactive then everything else can be deferred
+	 */
+	if (cfs_b->idle && !throttled)
+		goto out_deactivate;
 
 	/*
 	 * if we have relooped after returning idle once, we need to update our
@@ -3484,7 +3486,7 @@ static int do_sched_cfs_period_timer(struct cfs_bandwidth *cfs_b, int overrun)
 	if (!throttled) {
 		/* mark as potentially idle for the upcoming period */
 		cfs_b->idle = 1;
-		goto out_unlock;
+		return 0;
 	}
 
 	/* account preceding periods in which throttling occurred */
@@ -3524,12 +3526,12 @@ static int do_sched_cfs_period_timer(struct cfs_bandwidth *cfs_b, int overrun)
 	 * timer to remain active while there are any throttled entities.)
 	 */
 	cfs_b->idle = 0;
-out_unlock:
-	if (idle)
-		cfs_b->timer_active = 0;
-	raw_spin_unlock(&cfs_b->lock);
 
-	return idle;
+	return 0;
+
+out_deactivate:
+	cfs_b->timer_active = 0;
+	return 1;
 }
 
 /* a cfs_rq won't donate quota below this amount */
@@ -3706,6 +3708,7 @@ static enum hrtimer_restart sched_cfs_period_timer(struct hrtimer *timer)
 	int overrun;
 	int idle = 0;
 
+	raw_spin_lock(&cfs_b->lock);
 	for (;;) {
 		now = hrtimer_cb_get_time(timer);
 		overrun = hrtimer_forward(timer, now, cfs_b->period);
@@ -3715,6 +3718,7 @@ static enum hrtimer_restart sched_cfs_period_timer(struct hrtimer *timer)
 
 		idle = do_sched_cfs_period_timer(cfs_b, overrun);
 	}
+	raw_spin_unlock(&cfs_b->lock);
 
 	return idle ? HRTIMER_NORESTART : HRTIMER_RESTART;
 }
@@ -3774,8 +3778,6 @@ static void __maybe_unused unthrottle_offline_cfs_rqs(struct rq *rq)
 	struct cfs_rq *cfs_rq;
 
 	for_each_leaf_cfs_rq(rq, cfs_rq) {
-		struct cfs_bandwidth *cfs_b = tg_cfs_bandwidth(cfs_rq->tg);
-
 		if (!cfs_rq->runtime_enabled)
 			continue;
 
@@ -3783,7 +3785,7 @@ static void __maybe_unused unthrottle_offline_cfs_rqs(struct rq *rq)
 		 * clock_task is not advancing so we just need to make sure
 		 * there's some valid quota amount
 		 */
-		cfs_rq->runtime_remaining = cfs_b->quota;
+		cfs_rq->runtime_remaining = 1;
 		if (cfs_rq_throttled(cfs_rq))
 			unthrottle_cfs_rq(cfs_rq);
 	}
