Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753695Ab3F0JDV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 05:03:21 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46071 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753563Ab3F0JDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 05:03:17 -0400
Date: Thu, 27 Jun 2013 02:02:41 -0700
From: tip-bot for Alex Shi <tipbot@zytor.com>
Message-ID: <tip-bf5b986ed4d20428eeec3df4a03dbfebb9b6538c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, vincent.guittot@linaro.org, alex.shi@intel.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, vincent.guittot@linaro.org, tglx@linutronix.de,
        alex.shi@intel.com
In-Reply-To: <1371694737-29336-11-git-send-email-alex.shi@intel.com>
References: <1371694737-29336-11-git-send-email-alex.shi@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/tg: Use 'unsigned long'
  for load variable in task group
Git-Commit-ID: bf5b986ed4d20428eeec3df4a03dbfebb9b6538c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 27 Jun 2013 02:02:48 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bf5b986ed4d20428eeec3df4a03dbfebb9b6538c
Gitweb:     http://git.kernel.org/tip/bf5b986ed4d20428eeec3df4a03dbfebb9b6538c
Author:     Alex Shi <alex.shi@intel.com>
AuthorDate: Thu, 20 Jun 2013 10:18:54 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 27 Jun 2013 10:07:40 +0200

sched/tg: Use 'unsigned long' for load variable in task group

Since tg->load_avg is smaller than tg->load_weight, we don't need a
atomic64_t variable for load_avg in 32 bit machine.
The same reason for cfs_rq->tg_load_contrib.

The atomic_long_t/unsigned long variable type are more efficient and
convenience for them.

Signed-off-by: Alex Shi <alex.shi@intel.com>
Tested-by: Vincent Guittot <vincent.guittot@linaro.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1371694737-29336-11-git-send-email-alex.shi@intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
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
index f19772d..30ccc37 100644
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
 
 	tg_contrib = cfs_rq->runnable_load_avg + cfs_rq->blocked_load_avg;
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
index 9eb12d9..5585eb2 100644
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
