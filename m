Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752205AbaKZAq3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 19:46:29 -0500
Received: from mga01.intel.com ([192.55.52.88]:59901 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752085AbaKZApT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 19:45:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,459,1413270000"; 
   d="scan'208";a="628294357"
From: Wanpeng Li <wanpeng.li@linux.intel.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Cc: Juri Lelli <juri.lelli@arm.com>, Kirill Tkhai <ktkhai@parallels.com>,
        linux-kernel@vger.kernel.org, Wanpeng Li <wanpeng.li@linux.intel.com>
Subject: [PATCH v6 5/7] sched/fair: fix idle balance when remaining tasks are all non-CFS tasks
Date: Wed, 26 Nov 2014 08:44:05 +0800
Message-Id: <1416962647-76792-6-git-send-email-wanpeng.li@linux.intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1416962647-76792-1-git-send-email-wanpeng.li@linux.intel.com>
References: <1416962647-76792-1-git-send-email-wanpeng.li@linux.intel.com>
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
index a1c9267..8b7e131 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -6192,7 +6192,7 @@ static inline void update_sg_lb_stats(struct lb_env *env,
 		sgs->group_load += load;
 		sgs->sum_nr_running += rq->cfs.h_nr_running;
 
-		if (rq->nr_running > 1)
+		if (rq->nr_running > 1 && rq->cfs.h_nr_running > 0)
 			*overload = true;
 
 #ifdef CONFIG_NUMA_BALANCING
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 31f1e4d..f7dd978 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1269,7 +1269,8 @@ static inline void add_nr_running(struct rq *rq, unsigned count)
 
 	rq->nr_running = prev_nr + count;
 
-	if (prev_nr < 2 && rq->nr_running >= 2) {
+	if (prev_nr < 2 && rq->nr_running >= 2 &&
+		rq->cfs.h_nr_running > 0) {
 #ifdef CONFIG_SMP
 		if (!rq->rd->overload)
 			rq->rd->overload = true;
-- 
1.9.1

