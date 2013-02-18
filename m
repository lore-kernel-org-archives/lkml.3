Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752545Ab3BRFH4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 00:07:56 -0500
Received: from mga03.intel.com ([143.182.124.21]:12556 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751876Ab3BRFHw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 00:07:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,684,1355126400"; 
   d="scan'208";a="258209949"
From: Alex Shi <alex.shi@intel.com>
To: torvalds@linux-foundation.org, mingo@redhat.com, peterz@infradead.org,
        tglx@linutronix.de, akpm@linux-foundation.org, arjan@linux.intel.com,
        bp@alien8.de, pjt@google.com, namhyung@kernel.org, efault@gmx.de
Cc: vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, alex.shi@intel.com,
        morten.rasmussen@arm.com
Subject: [patch v5 03/15] Revert "sched: Introduce temporary FAIR_GROUP_SCHED dependency for load-tracking"
Date: Mon, 18 Feb 2013 13:07:30 +0800
Message-Id: <1361164062-20111-4-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1361164062-20111-1-git-send-email-alex.shi@intel.com>
References: <1361164062-20111-1-git-send-email-alex.shi@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove CONFIG_FAIR_GROUP_SCHED that covers the runnable info, then
we can use runnable load variables.

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 include/linux/sched.h |  8 +-------
 kernel/sched/core.c   |  7 +------
 kernel/sched/fair.c   | 13 ++-----------
 kernel/sched/sched.h  |  9 +--------
 4 files changed, 5 insertions(+), 32 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index f283d3d..66b05e1 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1195,13 +1195,7 @@ struct sched_entity {
 	/* rq "owned" by this entity/group: */
 	struct cfs_rq		*my_q;
 #endif
-/*
- * Load-tracking only depends on SMP, FAIR_GROUP_SCHED dependency below may be
- * removed when useful for applications beyond shares distribution (e.g.
- * load-balance).
- */
-#if defined(CONFIG_SMP) && defined(CONFIG_FAIR_GROUP_SCHED)
-	/* Per-entity load-tracking */
+#ifdef CONFIG_SMP
 	struct sched_avg	avg;
 #endif
 };
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 7292965..0bd9d5f 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1551,12 +1551,7 @@ static void __sched_fork(struct task_struct *p)
 	p->se.vruntime			= 0;
 	INIT_LIST_HEAD(&p->se.group_node);
 
-/*
- * Load-tracking only depends on SMP, FAIR_GROUP_SCHED dependency below may be
- * removed when useful for applications beyond shares distribution (e.g.
- * load-balance).
- */
-#if defined(CONFIG_SMP) && defined(CONFIG_FAIR_GROUP_SCHED)
+#ifdef CONFIG_SMP
 	p->se.avg.runnable_avg_period = 0;
 	p->se.avg.runnable_avg_sum = 0;
 	p->se.avg.decay_count = 0;
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 171790c..350eb8d 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1109,8 +1109,7 @@ static inline void update_cfs_shares(struct cfs_rq *cfs_rq)
 }
 #endif /* CONFIG_FAIR_GROUP_SCHED */
 
-/* Only depends on SMP, FAIR_GROUP_SCHED may be removed when useful in lb */
-#if defined(CONFIG_SMP) && defined(CONFIG_FAIR_GROUP_SCHED)
+#ifdef CONFIG_SMP
 /*
  * We choose a half-life close to 1 scheduling period.
  * Note: The tables below are dependent on this value.
@@ -3410,12 +3409,6 @@ unlock:
 }
 
 /*
- * Load-tracking only depends on SMP, FAIR_GROUP_SCHED dependency below may be
- * removed when useful for applications beyond shares distribution (e.g.
- * load-balance).
- */
-#ifdef CONFIG_FAIR_GROUP_SCHED
-/*
  * Called immediately before a task is migrated to a new cpu; task_cpu(p) and
  * cfs_rq_of(p) references at time of call are still valid and identify the
  * previous cpu.  However, the caller only guarantees p->pi_lock is held; no
@@ -3438,7 +3431,6 @@ migrate_task_rq_fair(struct task_struct *p, int next_cpu)
 		atomic64_add(se->avg.load_avg_contrib, &cfs_rq->removed_load);
 	}
 }
-#endif
 #endif /* CONFIG_SMP */
 
 static unsigned long
@@ -6130,9 +6122,8 @@ const struct sched_class fair_sched_class = {
 
 #ifdef CONFIG_SMP
 	.select_task_rq		= select_task_rq_fair,
-#ifdef CONFIG_FAIR_GROUP_SCHED
 	.migrate_task_rq	= migrate_task_rq_fair,
-#endif
+
 	.rq_online		= rq_online_fair,
 	.rq_offline		= rq_offline_fair,
 
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index fc88644..ae3511e 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -225,12 +225,6 @@ struct cfs_rq {
 #endif
 
 #ifdef CONFIG_SMP
-/*
- * Load-tracking only depends on SMP, FAIR_GROUP_SCHED dependency below may be
- * removed when useful for applications beyond shares distribution (e.g.
- * load-balance).
- */
-#ifdef CONFIG_FAIR_GROUP_SCHED
 	/*
 	 * CFS Load tracking
 	 * Under CFS, load is tracked on a per-entity basis and aggregated up.
@@ -240,8 +234,7 @@ struct cfs_rq {
 	u64 runnable_load_avg, blocked_load_avg;
 	atomic64_t decay_counter, removed_load;
 	u64 last_decay;
-#endif /* CONFIG_FAIR_GROUP_SCHED */
-/* These always depend on CONFIG_FAIR_GROUP_SCHED */
+
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	u32 tg_runnable_contrib;
 	u64 tg_load_contrib;
-- 
1.7.12

