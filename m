Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935594Ab3FTCWI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 22:22:08 -0400
Received: from mga03.intel.com ([143.182.124.21]:16182 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935677Ab3FTCVS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 22:21:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,901,1363158000"; 
   d="scan'208";a="319759547"
From: Alex Shi <alex.shi@intel.com>
To: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, bp@alien8.de,
        pjt@google.com, namhyung@kernel.org, efault@gmx.de,
        morten.rasmussen@arm.com
Cc: vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, alex.shi@intel.com, len.brown@intel.com,
        rafael.j.wysocki@intel.com, jkosina@suse.cz, clark.williams@gmail.com,
        tony.luck@intel.com, keescook@chromium.org, mgorman@suse.de,
        riel@redhat.com
Subject: [Resend patch v8 10/13] sched/tg: use 'unsigned long' for load variable in task group
Date: Thu, 20 Jun 2013 10:18:54 +0800
Message-Id: <1371694737-29336-11-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1371694737-29336-1-git-send-email-alex.shi@intel.com>
References: <1371694737-29336-1-git-send-email-alex.shi@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since tg->load_avg is smaller than tg->load_weight, we don't need a
atomic64_t variable for load_avg in 32 bit machine.
The same reason for cfs_rq->tg_load_contrib.

The atomic_long_t/unsigned long variable type are more efficient and
convenience for them.

Signed-off-by: Alex Shi <alex.shi@intel.com>
Tested-by: Vincent Guittot <vincent.guittot@linaro.org>
---
 kernel/sched/debug.c |  6 +++---
 kernel/sched/fair.c  | 12 ++++++------
 kernel/sched/sched.h |  4 ++--
 3 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index 160afdc..d803989 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -215,9 +215,9 @@ void print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
 			cfs_rq->runnable_load_avg);
 	SEQ_printf(m, "  .%-30s: %ld\n", "blocked_load_avg",
 			cfs_rq->blocked_load_avg);
-	SEQ_printf(m, "  .%-30s: %lld\n", "tg_load_avg",
-			(unsigned long long)atomic64_read(&cfs_rq->tg->load_avg));
-	SEQ_printf(m, "  .%-30s: %lld\n", "tg_load_contrib",
+	SEQ_printf(m, "  .%-30s: %ld\n", "tg_load_avg",
+			atomic_long_read(&cfs_rq->tg->load_avg));
+	SEQ_printf(m, "  .%-30s: %ld\n", "tg_load_contrib",
 			cfs_rq->tg_load_contrib);
 	SEQ_printf(m, "  .%-30s: %d\n", "tg_runnable_contrib",
 			cfs_rq->tg_runnable_contrib);
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 39a5bae..c2a2a36 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1075,7 +1075,7 @@ static inline long calc_tg_weight(struct task_group *tg, struct cfs_rq *cfs_rq)
 	 * to gain a more accurate current total weight. See
 	 * update_cfs_rq_load_contribution().
 	 */
-	tg_weight = atomic64_read(&tg->load_avg);
+	tg_weight = atomic_long_read(&tg->load_avg);
 	tg_weight -= cfs_rq->tg_load_contrib;
 	tg_weight += cfs_rq->load.weight;
 
@@ -1356,13 +1356,13 @@ static inline void __update_cfs_rq_tg_load_contrib(struct cfs_rq *cfs_rq,
 						 int force_update)
 {
 	struct task_group *tg = cfs_rq->tg;
-	s64 tg_contrib;
+	long tg_contrib;
 
 	tg_contrib = cfs_rq->runnable_load_avg;
 	tg_contrib -= cfs_rq->tg_load_contrib;
 
-	if (force_update || abs64(tg_contrib) > cfs_rq->tg_load_contrib / 8) {
-		atomic64_add(tg_contrib, &tg->load_avg);
+	if (force_update || abs(tg_contrib) > cfs_rq->tg_load_contrib / 8) {
+		atomic_long_add(tg_contrib, &tg->load_avg);
 		cfs_rq->tg_load_contrib += tg_contrib;
 	}
 }
@@ -1397,8 +1397,8 @@ static inline void __update_group_entity_contrib(struct sched_entity *se)
 	u64 contrib;
 
 	contrib = cfs_rq->tg_load_contrib * tg->shares;
-	se->avg.load_avg_contrib = div64_u64(contrib,
-					     atomic64_read(&tg->load_avg) + 1);
+	se->avg.load_avg_contrib = div_u64(contrib,
+				     atomic_long_read(&tg->load_avg) + 1);
 
 	/*
 	 * For group entities we need to compute a correction term in the case
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 762fa63..78bb990 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -150,7 +150,7 @@ struct task_group {
 
 	atomic_t load_weight;
 #ifdef	CONFIG_SMP
-	atomic64_t load_avg;
+	atomic_long_t load_avg;
 	atomic_t runnable_avg;
 #endif
 #endif
@@ -284,7 +284,7 @@ struct cfs_rq {
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	/* Required to track per-cpu representation of a task_group */
 	u32 tg_runnable_contrib;
-	u64 tg_load_contrib;
+	unsigned long tg_load_contrib;
 #endif /* CONFIG_FAIR_GROUP_SCHED */
 
 	/*
-- 
1.7.12

