Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755766AbaFYIj4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 04:39:56 -0400
Received: from mga03.intel.com ([143.182.124.21]:15789 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755616AbaFYIjx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 04:39:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,544,1400050800"; 
   d="scan'208";a="449717427"
From: Yuyang Du <yuyang.du@intel.com>
To: mingo@redhat.com, peterz@infradead.org, rafael.j.wysocki@intel.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Cc: arjan.van.de.ven@intel.com, len.brown@intel.com, alan.cox@intel.com,
        mark.gross@intel.com, morten.rasmussen@arm.com,
        vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
        rajeev.d.muralidhar@intel.com, vishwesh.m.rudramuni@intel.com,
        nicole.chalhoub@intel.com, ajaya.durg@intel.com,
        harinarayanan.seshadri@intel.com, jacob.jun.pan@linux.intel.com,
        Yuyang Du <yuyang.du@intel.com>
Subject: [RFC PATCH 2/9 v4] sched: Precise accumulated time and acount runnable number in update_entity_runnable_avg
Date: Wed, 25 Jun 2014 08:36:01 +0800
Message-Id: <1403656568-32445-3-git-send-email-yuyang.du@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1403656568-32445-1-git-send-email-yuyang.du@intel.com>
References: <1403656568-32445-1-git-send-email-yuyang.du@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current amount of time already accumulated against next period is
determined by:

	delta_w = sa->runnable_avg_period % 1024

Considering the runnable_avg_period is the sum of an infinite series, this
method looks gross, even the error would be no more than 1024 (~1ms).
But precisely accounting this is not hard, just use a variable period_contrib
to record it.

The current runnable argument is either 1 or 0, indicating whether this entity
is runnable or not. In order to account the number of runnables as well, change
how runnable_avg_sum is accumulated.

Signed-off-by: Yuyang Du <yuyang.du@intel.com>
---
 include/linux/sched.h |    1 +
 kernel/sched/fair.c   |   12 ++++++++----
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 306f4f0..1b1997d 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1074,6 +1074,7 @@ struct sched_avg {
 	 * choices of y < 1-2^(-32)*1024.
 	 */
 	u32 runnable_avg_sum, runnable_avg_period;
+	u32 period_contrib;
 	u64 last_runnable_update;
 	s64 decay_count;
 	unsigned long load_avg_contrib;
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 1a2d04f..e914e32 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2294,10 +2294,12 @@ static __always_inline int __update_entity_runnable_avg(u64 now,
 	sa->last_runnable_update = now;
 
 	/* delta_w is the amount already accumulated against our next period */
-	delta_w = sa->runnable_avg_period % 1024;
+	delta_w = sa->period_contrib;
 	if (delta + delta_w >= 1024) {
 		/* period roll-over */
 		decayed = 1;
+		/* how much left for next period will start over, we don't know yet */
+		sa->period_contrib = 0;
 
 		/*
 		 * Now that we know we're crossing a period boundary, figure
@@ -2306,7 +2308,7 @@ static __always_inline int __update_entity_runnable_avg(u64 now,
 		 */
 		delta_w = 1024 - delta_w;
 		if (runnable)
-			sa->runnable_avg_sum += delta_w;
+			sa->runnable_avg_sum += runnable * delta_w;
 		sa->runnable_avg_period += delta_w;
 
 		delta -= delta_w;
@@ -2323,15 +2325,17 @@ static __always_inline int __update_entity_runnable_avg(u64 now,
 		/* Efficiently calculate \sum (1..n_period) 1024*y^i */
 		runnable_contrib = __compute_runnable_contrib(periods);
 		if (runnable)
-			sa->runnable_avg_sum += runnable_contrib;
+			sa->runnable_avg_sum += runnable * runnable_contrib;
 		sa->runnable_avg_period += runnable_contrib;
 	}
 
 	/* Remainder of delta accrued against u_0` */
 	if (runnable)
-		sa->runnable_avg_sum += delta;
+		sa->runnable_avg_sum += runnable * delta;
 	sa->runnable_avg_period += delta;
 
+	sa->period_contrib += delta;
+
 	return decayed;
 }
 
-- 
1.7.9.5

