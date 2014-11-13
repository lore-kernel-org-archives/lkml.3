Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932220AbaKMIsA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 03:48:00 -0500
Received: from mga11.intel.com ([192.55.52.93]:10846 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932098AbaKMIr7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 03:47:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,375,1413270000"; 
   d="scan'208";a="631263192"
From: Wanpeng Li <wanpeng.li@linux.intel.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Cc: Juri Lelli <juri.lelli@arm.com>, Kirill Tkhai <ktkhai@parallels.com>,
        linux-kernel@vger.kernel.org, Wanpeng Li <wanpeng.li@linux.intel.com>
Subject: [PATCH] sched/rt: fix rt runtime corrupt when dl refuse a smaller bandwidth
Date: Thu, 13 Nov 2014 16:47:39 +0800
Message-Id: <1415868459-7043-1-git-send-email-wanpeng.li@linux.intel.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dl class will refuse the bandwidth being set to some value smaller 
than the currently allocated bandwidth in any of the root_domains 
through sched_rt_runtime_us and sched_rt_period_us. RT runtime will 
be set according to sched_rt_runtime_us before dl class verify if 
the new bandwidth is suitable in the case of !CONFIG_RT_GROUP_SCHED.

However, rt runtime will be corrupt if dl refuse the new bandwidth 
since there is no undo to reset the rt runtime to the old value. 

This patch fix it by setting rt runtime after all kinds of rational 
checking in the case of !CONFIG_RT_GROUP_SCHED.

Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
---
 kernel/sched/core.c | 30 ++++++++++++++++--------------
 1 file changed, 16 insertions(+), 14 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 2e7578a..355dde3 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -7795,20 +7795,7 @@ static int sched_rt_can_attach(struct task_group *tg, struct task_struct *tsk)
 #else /* !CONFIG_RT_GROUP_SCHED */
 static int sched_rt_global_constraints(void)
 {
-	unsigned long flags;
-	int i, ret = 0;
-
-	raw_spin_lock_irqsave(&def_rt_bandwidth.rt_runtime_lock, flags);
-	for_each_possible_cpu(i) {
-		struct rt_rq *rt_rq = &cpu_rq(i)->rt;
-
-		raw_spin_lock(&rt_rq->rt_runtime_lock);
-		rt_rq->rt_runtime = global_rt_runtime();
-		raw_spin_unlock(&rt_rq->rt_runtime_lock);
-	}
-	raw_spin_unlock_irqrestore(&def_rt_bandwidth.rt_runtime_lock, flags);
-
-	return ret;
+	return 0;
 }
 #endif /* CONFIG_RT_GROUP_SCHED */
 
@@ -7890,6 +7877,21 @@ static int sched_rt_global_validate(void)
 
 static void sched_rt_do_global(void)
 {
+#ifndef CONFIG_RT_GROUP_SCHED
+	unsigned long flags;
+	int i;
+
+	raw_spin_lock_irqsave(&def_rt_bandwidth.rt_runtime_lock, flags);
+	for_each_possible_cpu(i) {
+		struct rt_rq *rt_rq = &cpu_rq(i)->rt;
+
+		raw_spin_lock(&rt_rq->rt_runtime_lock);
+		rt_rq->rt_runtime = global_rt_runtime();
+		raw_spin_unlock(&rt_rq->rt_runtime_lock);
+	}
+	raw_spin_unlock_irqrestore(&def_rt_bandwidth.rt_runtime_lock, flags);
+#endif
+
 	def_rt_bandwidth.rt_runtime = global_rt_runtime();
 	def_rt_bandwidth.rt_period = ns_to_ktime(global_rt_period());
 }
-- 
1.9.1

