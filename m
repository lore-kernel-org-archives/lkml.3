Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753276Ab3IWTki (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 15:40:38 -0400
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:35836 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752854Ab3IWTkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 15:40:10 -0400
From: Waiman Long <Waiman.Long@hp.com>
Cc: Waiman Long <Waiman.Long@hp.com>, linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: [PATCH 1/2] sched: reduce contention on tg's load_avg & runnable_avg
Date: Mon, 23 Sep 2013 15:39:22 -0400
Message-Id: <1379965163-18440-2-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1379965163-18440-1-git-send-email-Waiman.Long@hp.com>
References: <1379965163-18440-1-git-send-email-Waiman.Long@hp.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It was found that with a perf profile of a kernbench running on a
8-socket 80-core system (HT off) on a 3.11 kernel that the scheduler
accounts for a non-insignificant portion of the total cpu cycles.

  4.58%    cc1  [kernel.kallsyms]    [k] entity_tick
  2.41%    cc1  [kernel.kallsyms]    [k] update_cfs_rq_blocked_load
  0.38%    cc1  [kernel.kallsyms]    [k] update_curr
  0.25%    cc1  [kernel.kallsyms]    [k] update_cfs_shares

The scheduler accounts for about 7.6% of the total CPU cycles. Of
the top 2 function in the above list, the reading and writing of the
tg->load_avg variable account for over 90% of the CPU cycles:

  atomic_long_add(tg_contrib, &tg->load_avg);
  atomic_long_read(&tg->load_avg) + 1);

This patch reduces the contention on the load_avg variable (and
secondarily on the runnable_avg variable) by the following 2 measures:

1. Make the load_avg and runnable_avg fields of the task_group
   structure sit in their own cacheline without sharing it with others.
2. Use atomic_long_add_return() to update the fields and save the
   returned value in a temporary location in the cfs structure to
   be used later instead of reading the fields directly.

The second change does require some changes in the ordering of how
some of the average counts are being computed and hence may have a
slight effect on their behavior.

With these 2 changes, the perf profile becomes:

  3.77%    cc1  [kernel.kallsyms]    [k] update_cfs_rq_blocked_load
  1.50%    cc1  [kernel.kallsyms]    [k] update_curr
  0.78%    cc1  [kernel.kallsyms]    [k] update_cfs_shares
  0.11%    cc1  [kernel.kallsyms]    [k] entity_tick

The % CPU cycle is reduced to about 6.2%. The kernbench elapsed time
was reduced from 151.5s to 149s.

Apparently, the %CPU cycle reduction was bigger with HT on:

  1.08%    cc1  [kernel.kallsyms]    [k] update_cfs_rq_blocked_load
  0.21%    cc1  [kernel.kallsyms]    [k] update_cfs_shares
  0.16%    cc1  [kernel.kallsyms]    [k] entity_tick
  0.09%    cc1  [kernel.kallsyms]    [k] update_curr

However, the actual elapsed time reduction was less (from 139.8s to
139s) in this case.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
---
 kernel/sched/fair.c  |   29 ++++++++++++++++++++++-------
 kernel/sched/sched.h |    6 ++++--
 2 files changed, 26 insertions(+), 9 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 68f1609..979f04d 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1075,7 +1075,10 @@ static inline long calc_tg_weight(struct task_group *tg, struct cfs_rq *cfs_rq)
 	 * to gain a more accurate current total weight. See
 	 * update_cfs_rq_load_contribution().
 	 */
-	tg_weight = atomic_long_read(&tg->load_avg);
+	/* Use the saved version of tg's load_avg, if available */
+	tg_weight = cfs_rq->tg_load_save;
+	if (!tg_weight)
+		tg_weight = atomic_long_read(&tg->load_avg);
 	tg_weight -= cfs_rq->tg_load_contrib;
 	tg_weight += cfs_rq->load.weight;
 
@@ -1362,7 +1365,8 @@ static inline void __update_cfs_rq_tg_load_contrib(struct cfs_rq *cfs_rq,
 	tg_contrib -= cfs_rq->tg_load_contrib;
 
 	if (force_update || abs(tg_contrib) > cfs_rq->tg_load_contrib / 8) {
-		atomic_long_add(tg_contrib, &tg->load_avg);
+		cfs_rq->tg_load_save =
+			atomic_long_add_return(tg_contrib, &tg->load_avg);
 		cfs_rq->tg_load_contrib += tg_contrib;
 	}
 }
@@ -1383,7 +1387,8 @@ static inline void __update_tg_runnable_avg(struct sched_avg *sa,
 	contrib -= cfs_rq->tg_runnable_contrib;
 
 	if (abs(contrib) > cfs_rq->tg_runnable_contrib / 64) {
-		atomic_add(contrib, &tg->runnable_avg);
+		cfs_rq->tg_runnable_save =
+			atomic_add_return(contrib, &tg->runnable_avg);
 		cfs_rq->tg_runnable_contrib += contrib;
 	}
 }
@@ -1393,12 +1398,19 @@ static inline void __update_group_entity_contrib(struct sched_entity *se)
 	struct cfs_rq *cfs_rq = group_cfs_rq(se);
 	struct task_group *tg = cfs_rq->tg;
 	int runnable_avg;
+	long load_avg;
 
 	u64 contrib;
 
 	contrib = cfs_rq->tg_load_contrib * tg->shares;
-	se->avg.load_avg_contrib = div_u64(contrib,
-				     atomic_long_read(&tg->load_avg) + 1);
+	/*
+	 * Retrieve & clear the saved tg's load_avg and use it if not 0
+	 */
+	load_avg = cfs_rq->tg_load_save;
+	cfs_rq->tg_load_save = 0;
+	if (unlikely(!load_avg))
+		load_avg = atomic_long_read(&tg->load_avg);
+	se->avg.load_avg_contrib = div_u64(contrib, load_avg + 1);
 
 	/*
 	 * For group entities we need to compute a correction term in the case
@@ -1423,7 +1435,10 @@ static inline void __update_group_entity_contrib(struct sched_entity *se)
 	 * of consequential size guaranteed to see n_i*w_i quickly converge to
 	 * our upper bound of 1-cpu.
 	 */
-	runnable_avg = atomic_read(&tg->runnable_avg);
+	runnable_avg = cfs_rq->tg_runnable_save;
+	cfs_rq->tg_runnable_save = 0;
+	if (unlikely(!runnable_avg))
+		runnable_avg = atomic_read(&tg->runnable_avg);
 	if (runnable_avg < NICE_0_LOAD) {
 		se->avg.load_avg_contrib *= runnable_avg;
 		se->avg.load_avg_contrib >>= NICE_0_SHIFT;
@@ -2030,9 +2045,9 @@ entity_tick(struct cfs_rq *cfs_rq, struct sched_entity *curr, int queued)
 	/*
 	 * Ensure that runnable average is periodically updated.
 	 */
-	update_entity_load_avg(curr, 1);
 	update_cfs_rq_blocked_load(cfs_rq, 1);
 	update_cfs_shares(cfs_rq);
+	update_entity_load_avg(curr, 1);
 
 #ifdef CONFIG_SCHED_HRTICK
 	/*
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index ef0a7b2..255e340 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -149,8 +149,8 @@ struct task_group {
 	unsigned long shares;
 
 #ifdef	CONFIG_SMP
-	atomic_long_t load_avg;
-	atomic_t runnable_avg;
+	atomic_long_t load_avg ____cacheline_aligned;
+	atomic_t runnable_avg ____cacheline_aligned;
 #endif
 #endif
 
@@ -284,7 +284,9 @@ struct cfs_rq {
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	/* Required to track per-cpu representation of a task_group */
 	u32 tg_runnable_contrib;
+	int tg_runnable_save;
 	unsigned long tg_load_contrib;
+	long tg_load_save;
 #endif /* CONFIG_FAIR_GROUP_SCHED */
 
 	/*
-- 
1.7.1

