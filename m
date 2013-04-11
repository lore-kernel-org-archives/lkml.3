Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765434Ab3DKNGT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 09:06:19 -0400
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:50639 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752087Ab3DKNGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 09:06:17 -0400
From: Neil Zhang <zhangwm@marvell.com>
To: <mingo@redhat.com>, <peterz@infradead.org>, <linux-kernel@vger.kernel.org>
CC: Neil Zhang <zhangwm@marvell.com>
Subject: [PATCH] sched: remove redundant update_runtime notifier
Date: Thu, 11 Apr 2013 21:04:59 +0800
Message-ID: <1365685499-26515-1-git-send-email-zhangwm@marvell.com>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

migration_call() will do all the things that update_runtime() does.
So let's remove it.

Furthermore, there is potential risk that the current code will catch
BUG_ON at line 689 of rt.c when do cpu hotplug while there are realtime
threads running because of enabling runtime twice while the rt_runtime
may already changed.

Signed-off-by: Neil Zhang <zhangwm@marvell.com>
---
 kernel/sched/core.c  |    3 ---
 kernel/sched/rt.c    |   40 ----------------------------------------
 kernel/sched/sched.h |    1 -
 3 files changed, 0 insertions(+), 44 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 7f12624..3719c3c 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6831,9 +6831,6 @@ void __init sched_init_smp(void)
 	hotcpu_notifier(cpuset_cpu_active, CPU_PRI_CPUSET_ACTIVE);
 	hotcpu_notifier(cpuset_cpu_inactive, CPU_PRI_CPUSET_INACTIVE);
 
-	/* RT runtime code needs to handle some hotplug events */
-	hotcpu_notifier(update_runtime, 0);
-
 	init_hrtick();
 
 	/* Move init over to a non-isolated CPU */
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 127a2c4..111539a 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -699,15 +699,6 @@ balanced:
 	}
 }
 
-static void disable_runtime(struct rq *rq)
-{
-	unsigned long flags;
-
-	raw_spin_lock_irqsave(&rq->lock, flags);
-	__disable_runtime(rq);
-	raw_spin_unlock_irqrestore(&rq->lock, flags);
-}
-
 static void __enable_runtime(struct rq *rq)
 {
 	rt_rq_iter_t iter;
@@ -732,37 +723,6 @@ static void __enable_runtime(struct rq *rq)
 	}
 }
 
-static void enable_runtime(struct rq *rq)
-{
-	unsigned long flags;
-
-	raw_spin_lock_irqsave(&rq->lock, flags);
-	__enable_runtime(rq);
-	raw_spin_unlock_irqrestore(&rq->lock, flags);
-}
-
-int update_runtime(struct notifier_block *nfb, unsigned long action, void *hcpu)
-{
-	int cpu = (int)(long)hcpu;
-
-	switch (action) {
-	case CPU_DOWN_PREPARE:
-	case CPU_DOWN_PREPARE_FROZEN:
-		disable_runtime(cpu_rq(cpu));
-		return NOTIFY_OK;
-
-	case CPU_DOWN_FAILED:
-	case CPU_DOWN_FAILED_FROZEN:
-	case CPU_ONLINE:
-	case CPU_ONLINE_FROZEN:
-		enable_runtime(cpu_rq(cpu));
-		return NOTIFY_OK;
-
-	default:
-		return NOTIFY_DONE;
-	}
-}
-
 static int balance_runtime(struct rt_rq *rt_rq)
 {
 	int more = 0;
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index cc03cfd..e73a8bd 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -892,7 +892,6 @@ extern void sysrq_sched_debug_show(void);
 extern void sched_init_granularity(void);
 extern void update_max_interval(void);
 extern void update_group_power(struct sched_domain *sd, int cpu);
-extern int update_runtime(struct notifier_block *nfb, unsigned long action, void *hcpu);
 extern void init_sched_rt_class(void);
 extern void init_sched_fair_class(void);
 
-- 
1.7.4.1

