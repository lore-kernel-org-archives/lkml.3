Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934035Ab3E1NHY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 09:07:24 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50161 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933994Ab3E1NHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 09:07:23 -0400
Date: Tue, 28 May 2013 06:06:49 -0700
From: tip-bot for Neil Zhang <tipbot@zytor.com>
Message-ID: <tip-c5405a495e88d93cf9b4f4cc91507c7f4afcb901@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, zhangwm@marvell.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, zhangwm@marvell.com, tglx@linutronix.de
In-Reply-To: <1365685499-26515-1-git-send-email-zhangwm@marvell.com>
References: <1365685499-26515-1-git-send-email-zhangwm@marvell.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Remove redundant update_runtime notifier
Git-Commit-ID: c5405a495e88d93cf9b4f4cc91507c7f4afcb901
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

Commit-ID:  c5405a495e88d93cf9b4f4cc91507c7f4afcb901
Gitweb:     http://git.kernel.org/tip/c5405a495e88d93cf9b4f4cc91507c7f4afcb901
Author:     Neil Zhang <zhangwm@marvell.com>
AuthorDate: Thu, 11 Apr 2013 21:04:59 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 28 May 2013 09:40:22 +0200

sched: Remove redundant update_runtime notifier

migration_call() will do all the things that update_runtime() does.
So let's remove it.

Furthermore, there is potential risk that the current code will catch
BUG_ON at line 689 of rt.c when do cpu hotplug while there are realtime
threads running because of enabling runtime twice while the rt_runtime
may already changed.

Signed-off-by: Neil Zhang <zhangwm@marvell.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1365685499-26515-1-git-send-email-zhangwm@marvell.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c  |  3 ---
 kernel/sched/rt.c    | 40 ----------------------------------------
 kernel/sched/sched.h |  1 -
 3 files changed, 44 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index bfa7e77..79e48e6 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6285,9 +6285,6 @@ void __init sched_init_smp(void)
 	hotcpu_notifier(cpuset_cpu_active, CPU_PRI_CPUSET_ACTIVE);
 	hotcpu_notifier(cpuset_cpu_inactive, CPU_PRI_CPUSET_INACTIVE);
 
-	/* RT runtime code needs to handle some hotplug events */
-	hotcpu_notifier(update_runtime, 0);
-
 	init_hrtick();
 
 	/* Move init over to a non-isolated CPU */
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 7aced2e..8853ab1 100644
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
index f1f6256..c806c61 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1041,7 +1041,6 @@ static inline void idle_balance(int cpu, struct rq *rq)
 extern void sysrq_sched_debug_show(void);
 extern void sched_init_granularity(void);
 extern void update_max_interval(void);
-extern int update_runtime(struct notifier_block *nfb, unsigned long action, void *hcpu);
 extern void init_sched_rt_class(void);
 extern void init_sched_fair_class(void);
 
