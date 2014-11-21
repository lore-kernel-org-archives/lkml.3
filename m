Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757523AbaKUCha (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 21:37:30 -0500
Received: from mga11.intel.com ([192.55.52.93]:27075 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756487AbaKUCh3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 21:37:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="419621575"
From: Wanpeng Li <wanpeng.li@linux.intel.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Wanpeng Li <wanpeng.li@linux.intel.com>
Subject: [PATCH] sched/fair: fix idle balance when remaining tasks are all non-CFS tasks
Date: Fri, 21 Nov 2014 10:37:08 +0800
Message-Id: <1416537428-36715-1-git-send-email-wanpeng.li@linux.intel.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The overload indicator is used for knowing when we can totally avoid load
balancing to a cpu that is about to go idle. We can avoid load balancing 
when no cpu has cfs task and both rt and deadline have push/pull mechanism 
to do their own balancing.

However, rq->nr_running on behalf of the total number of each class tasks 
on the cpu, do idle balance when remaining tasks are all non-CFS tasks does
not make any sense.

This patch fix it by idle balance when there are still other CFS tasks in 
the rq's root domain.

Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
---
 kernel/sched/fair.c  | 2 +-
 kernel/sched/sched.h | 3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index df2cdf7..90a74e7 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -6197,7 +6197,7 @@ static inline void update_sg_lb_stats(struct lb_env *env,
 		sgs->group_load += load;
 		sgs->sum_nr_running += rq->cfs.h_nr_running;
 
-		if (rq->nr_running > 1)
+		if (rq->nr_running > 1 && rq->cfs.h_nr_running > 0)
 			*overload = true;
 
 #ifdef CONFIG_NUMA_BALANCING
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 9a2a45c..98f2d8f 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1271,7 +1271,8 @@ static inline void add_nr_running(struct rq *rq, unsigned count)
 
 	rq->nr_running = prev_nr + count;
 
-	if (prev_nr < 2 && rq->nr_running >= 2) {
+	if (prev_nr < 2 && rq->nr_running >= 2 &&
+		rq->cfs.h_nr_running > 0) {
 #ifdef CONFIG_SMP
 		if (!rq->rd->overload)
 			rq->rd->overload = true;
-- 
1.9.1

