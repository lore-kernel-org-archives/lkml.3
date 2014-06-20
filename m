Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758031AbaFTWVX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 18:21:23 -0400
Received: from mail-pa0-f73.google.com ([209.85.220.73]:40208 "EHLO
	mail-pa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753880AbaFTWVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 18:21:21 -0400
Subject: [PATCH] sched: Fix potential near-infinite distribute_cfs_runtime
 loop
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        pjt@google.com
From: Ben Segall <bsegall@google.com>
Cc: linux-kernel@vger.kernel.org
Date: Fri, 20 Jun 2014 15:21:20 -0700
Message-ID: <20140620222120.13814.21652.stgit@sword-of-the-dawn.mtv.corp.google.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

distribute_cfs_runtime intentionally only hands out enough runtime to
bring each cfs_rq to 1 ns of runtime, expecting the cfs_rqs to then take
the runtime they need only once they actually get to run. However, if
they get to run sufficiently quickly, the period timer is still in
distribute_cfs_runtime and no runtime is available, causing them to
throttle. Then distribute has to handle them again, and this can go on
until distribute has handed out all of the runtime 1ns at a time, which
takes far too long.

Instead allow access to the same runtime that distribute is handing out,
accepting that corner cases with very low quota may be able to spend the
entire cfs_b->runtime during distribute_cfs_runtime, meaning that the
runtime directly handed out by distribute_cfs_runtime was over quota. In
addition, if a cfs_rq does manage to throttle like this, make sure the
existing distribute_cfs_runtime no longer loops over it again.

Signed-off-by: Ben Segall <bsegall@google.com>
---
 kernel/sched/fair.c |   41 ++++++++++++++++++++---------------------
 1 file changed, 20 insertions(+), 21 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 1f9c457..ef5eac7 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3361,7 +3361,11 @@ static void throttle_cfs_rq(struct cfs_rq *cfs_rq)
 	cfs_rq->throttled = 1;
 	cfs_rq->throttled_clock = rq_clock(rq);
 	raw_spin_lock(&cfs_b->lock);
-	list_add_tail_rcu(&cfs_rq->throttled_list, &cfs_b->throttled_cfs_rq);
+	/*
+	 * Add to the _head_ of the list, so that an already-started
+	 * distribute_cfs_runtime will not see us
+	 */
+	list_add_rcu(&cfs_rq->throttled_list, &cfs_b->throttled_cfs_rq);
 	if (!cfs_b->timer_active)
 		__start_cfs_bandwidth(cfs_b, false);
 	raw_spin_unlock(&cfs_b->lock);
@@ -3418,7 +3422,8 @@ static u64 distribute_cfs_runtime(struct cfs_bandwidth *cfs_b,
 		u64 remaining, u64 expires)
 {
 	struct cfs_rq *cfs_rq;
-	u64 runtime = remaining;
+	u64 runtime;
+	u64 starting_runtime = remaining;
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(cfs_rq, &cfs_b->throttled_cfs_rq,
@@ -3449,7 +3454,7 @@ next:
 	}
 	rcu_read_unlock();
 
-	return remaining;
+	return starting_runtime - remaining;
 }
 
 /*
@@ -3495,22 +3500,17 @@ static int do_sched_cfs_period_timer(struct cfs_bandwidth *cfs_b, int overrun)
 	/* account preceding periods in which throttling occurred */
 	cfs_b->nr_throttled += overrun;
 
-	/*
-	 * There are throttled entities so we must first use the new bandwidth
-	 * to unthrottle them before making it generally available.  This
-	 * ensures that all existing debts will be paid before a new cfs_rq is
-	 * allowed to run.
-	 */
-	runtime = cfs_b->runtime;
 	runtime_expires = cfs_b->runtime_expires;
-	cfs_b->runtime = 0;
 
 	/*
-	 * This check is repeated as we are holding onto the new bandwidth
-	 * while we unthrottle.  This can potentially race with an unthrottled
-	 * group trying to acquire new bandwidth from the global pool.
+	 * This check is repeated as we are holding onto the new bandwidth while
+	 * we unthrottle. This can potentially race with an unthrottled group
+	 * trying to acquire new bandwidth from the global pool. This can result
+	 * in us over-using our runtime if it is all used during this loop, but
+	 * only by limited amounts in that extreme case.
 	 */
-	while (throttled && runtime > 0) {
+	while (throttled && cfs_b->runtime > 0) {
+		runtime = cfs_b->runtime;
 		raw_spin_unlock(&cfs_b->lock);
 		/* we can't nest cfs_b->lock while distributing bandwidth */
 		runtime = distribute_cfs_runtime(cfs_b, runtime,
@@ -3518,10 +3518,10 @@ static int do_sched_cfs_period_timer(struct cfs_bandwidth *cfs_b, int overrun)
 		raw_spin_lock(&cfs_b->lock);
 
 		throttled = !list_empty(&cfs_b->throttled_cfs_rq);
+
+		cfs_b->runtime -= min(runtime, cfs_b->runtime);
 	}
 
-	/* return (any) remaining runtime */
-	cfs_b->runtime = runtime;
 	/*
 	 * While we are ensured activity in the period following an
 	 * unthrottle, this also covers the case in which the new bandwidth is
@@ -3632,10 +3632,9 @@ static void do_sched_cfs_slack_timer(struct cfs_bandwidth *cfs_b)
 		return;
 	}
 
-	if (cfs_b->quota != RUNTIME_INF && cfs_b->runtime > slice) {
+	if (cfs_b->quota != RUNTIME_INF && cfs_b->runtime > slice)
 		runtime = cfs_b->runtime;
-		cfs_b->runtime = 0;
-	}
+
 	expires = cfs_b->runtime_expires;
 	raw_spin_unlock(&cfs_b->lock);
 
@@ -3646,7 +3645,7 @@ static void do_sched_cfs_slack_timer(struct cfs_bandwidth *cfs_b)
 
 	raw_spin_lock(&cfs_b->lock);
 	if (expires == cfs_b->runtime_expires)
-		cfs_b->runtime = runtime;
+		cfs_b->runtime -= min(runtime, cfs_b->runtime);
 	raw_spin_unlock(&cfs_b->lock);
 }
 

