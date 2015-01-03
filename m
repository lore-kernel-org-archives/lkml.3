Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751969AbbACRVy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2015 12:21:54 -0500
Received: from mail-qg0-f49.google.com ([209.85.192.49]:63118 "EHLO
	mail-qg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017AbbACRVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2015 12:21:52 -0500
From: Zhihui Zhang <zzhsuny@gmail.com>
To: mingo@redhat.com, peterz@infradead.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] [sched] Account the elapse of each period accurately
Date: Sat,  3 Jan 2015 12:21:43 -0500
Message-Id: <1420305703-2877-1-git-send-email-zzhsuny@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, the decayed values of previous periods can spill into the lower 10 bits of
runnable_avg_period. This makes the next period to be less than 1024 us. If we want
to decay exactly every 1024us, which I see no reason not to (less math overhead and
consistent decay period among all tasks), we can use a separate field to track how
much time the current period has elapsed instead of overloading runnable_avg_period.
This patch achieves this.

Signed-off-by: Zhihui Zhang <zzhsuny@gmail.com>
---
 include/linux/sched.h | 2 +-
 kernel/sched/fair.c   | 5 ++++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 8db31ef..fa6b23b 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1116,7 +1116,7 @@ struct sched_avg {
 	 * above by 1024/(1-y).  Thus we only need a u32 to store them for all
 	 * choices of y < 1-2^(-32)*1024.
 	 */
-	u32 runnable_avg_sum, runnable_avg_period;
+	u32 accrue, runnable_avg_sum, runnable_avg_period;
 	u64 last_runnable_update;
 	s64 decay_count;
 	unsigned long load_avg_contrib;
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index df2cdf7..c87ecf5 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -676,6 +676,7 @@ void init_task_runnable_average(struct task_struct *p)
 {
 	u32 slice;
 
+	p->se.avg.accrue = 0;
 	p->se.avg.decay_count = 0;
 	slice = sched_slice(task_cfs_rq(p), &p->se) >> 10;
 	p->se.avg.runnable_avg_sum = slice;
@@ -2526,11 +2527,12 @@ static __always_inline int __update_entity_runnable_avg(u64 now,
 	sa->last_runnable_update = now;
 
 	/* delta_w is the amount already accumulated against our next period */
-	delta_w = sa->runnable_avg_period % 1024;
+	delta_w = sa->accrue;
 	if (delta + delta_w >= 1024) {
 		/* period roll-over */
 		decayed = 1;
 
+		sa->accrue = 0;
 		/*
 		 * Now that we know we're crossing a period boundary, figure
 		 * out how much from delta we need to complete the current
@@ -2558,6 +2560,7 @@ static __always_inline int __update_entity_runnable_avg(u64 now,
 			sa->runnable_avg_sum += runnable_contrib;
 		sa->runnable_avg_period += runnable_contrib;
 	}
+	sa->accrue += delta;
 
 	/* Remainder of delta accrued against u_0` */
 	if (runnable)
-- 
1.9.1

