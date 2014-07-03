Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759593AbaGCQ3O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 12:29:14 -0400
Received: from service87.mimecast.com ([91.220.42.44]:55749 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758091AbaGCQ3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 12:29:12 -0400
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        peterz@infradead.org, mingo@kernel.org
Cc: rjw@rjwysocki.net, vincent.guittot@linaro.org, daniel.lezcano@linaro.org,
        preeti@linux.vnet.ibm.com, Dietmar.Eggemann@arm.com, pjt@google.com
Subject: [RFCv2 PATCH 09/23] sched: Maintain the unweighted load contribution of blocked entities
Date: Thu,  3 Jul 2014 17:25:56 +0100
Message-Id: <1404404770-323-10-git-send-email-morten.rasmussen@arm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1404404770-323-1-git-send-email-morten.rasmussen@arm.com>
References: <1404404770-323-1-git-send-email-morten.rasmussen@arm.com>
X-OriginalArrivalTime: 03 Jul 2014 16:26:13.0366 (UTC) FILETIME=[819E1960:01CF96DB]
X-MC-Unique: 114070317261401001
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id s63GTKbG010680

From: Dietmar Eggemann <dietmar.eggemann@arm.com>

The unweighted blocked load on a run queue is maintained alongside the
existing (weighted) blocked load.

This patch is the unweighted counterpart of "sched: Maintain the load
contribution of blocked entities" (commit id 9ee474f55664).

Note: The unweighted blocked load is not used for energy aware
scheduling yet.

Signed-off-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
---
 kernel/sched/debug.c |    2 ++
 kernel/sched/fair.c  |   22 +++++++++++++++++-----
 kernel/sched/sched.h |    2 +-
 3 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index 78d4151..ffa56a8 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -220,6 +220,8 @@ void print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
 			cfs_rq->uw_runnable_load_avg);
 	SEQ_printf(m, "  .%-30s: %ld\n", "blocked_load_avg",
 			cfs_rq->blocked_load_avg);
+	SEQ_printf(m, "  .%-30s: %ld\n", "uw_blocked_load_avg",
+			cfs_rq->uw_blocked_load_avg);
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	SEQ_printf(m, "  .%-30s: %ld\n", "tg_load_contrib",
 			cfs_rq->tg_load_contrib);
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 1ee47b3..c6207f7 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2481,12 +2481,18 @@ static long __update_entity_load_avg_contrib(struct sched_entity *se,
 }
 
 static inline void subtract_blocked_load_contrib(struct cfs_rq *cfs_rq,
-						 long load_contrib)
+						 long load_contrib,
+						 long uw_load_contrib)
 {
 	if (likely(load_contrib < cfs_rq->blocked_load_avg))
 		cfs_rq->blocked_load_avg -= load_contrib;
 	else
 		cfs_rq->blocked_load_avg = 0;
+
+	if (likely(uw_load_contrib < cfs_rq->uw_blocked_load_avg))
+		cfs_rq->uw_blocked_load_avg -= uw_load_contrib;
+	else
+		cfs_rq->uw_blocked_load_avg = 0;
 }
 
 static inline u64 cfs_rq_clock_task(struct cfs_rq *cfs_rq);
@@ -2521,7 +2527,8 @@ static inline void update_entity_load_avg(struct sched_entity *se,
 		cfs_rq->uw_runnable_load_avg += uw_contrib_delta;
 	}
 	else
-		subtract_blocked_load_contrib(cfs_rq, -contrib_delta);
+		subtract_blocked_load_contrib(cfs_rq, -contrib_delta,
+					      -uw_contrib_delta);
 }
 
 /*
@@ -2540,12 +2547,14 @@ static void update_cfs_rq_blocked_load(struct cfs_rq *cfs_rq, int force_update)
 	if (atomic_long_read(&cfs_rq->removed_load)) {
 		unsigned long removed_load;
 		removed_load = atomic_long_xchg(&cfs_rq->removed_load, 0);
-		subtract_blocked_load_contrib(cfs_rq, removed_load);
+		subtract_blocked_load_contrib(cfs_rq, removed_load, 0);
 	}
 
 	if (decays) {
 		cfs_rq->blocked_load_avg = decay_load(cfs_rq->blocked_load_avg,
 						      decays);
+		cfs_rq->uw_blocked_load_avg =
+				decay_load(cfs_rq->uw_blocked_load_avg, decays);
 		atomic64_add(decays, &cfs_rq->decay_counter);
 		cfs_rq->last_decay = now;
 	}
@@ -2591,7 +2600,8 @@ static inline void enqueue_entity_load_avg(struct cfs_rq *cfs_rq,
 
 	/* migrated tasks did not contribute to our blocked load */
 	if (wakeup) {
-		subtract_blocked_load_contrib(cfs_rq, se->avg.load_avg_contrib);
+		subtract_blocked_load_contrib(cfs_rq, se->avg.load_avg_contrib,
+					      se->avg.uw_load_avg_contrib);
 		update_entity_load_avg(se, 0);
 	}
 
@@ -2620,6 +2630,7 @@ static inline void dequeue_entity_load_avg(struct cfs_rq *cfs_rq,
 
 	if (sleep) {
 		cfs_rq->blocked_load_avg += se->avg.load_avg_contrib;
+		cfs_rq->uw_blocked_load_avg += se->avg.uw_load_avg_contrib;
 		se->avg.decay_count = atomic64_read(&cfs_rq->decay_counter);
 	} /* migrations, e.g. sleep=0 leave decay_count == 0 */
 }
@@ -7481,7 +7492,8 @@ static void switched_from_fair(struct rq *rq, struct task_struct *p)
 	*/
 	if (se->avg.decay_count) {
 		__synchronize_entity_decay(se);
-		subtract_blocked_load_contrib(cfs_rq, se->avg.load_avg_contrib);
+		subtract_blocked_load_contrib(cfs_rq, se->avg.load_avg_contrib,
+					      se->avg.uw_load_avg_contrib);
 	}
 #endif
 }
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 46cb8bd..3f1eeb3 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -337,7 +337,7 @@ struct cfs_rq {
 	 * the FAIR_GROUP_SCHED case).
 	 */
 	unsigned long runnable_load_avg, blocked_load_avg;
-	unsigned long uw_runnable_load_avg;
+	unsigned long uw_runnable_load_avg, uw_blocked_load_avg;
 	atomic64_t decay_counter;
 	u64 last_decay;
 	atomic_long_t removed_load;
-- 
1.7.9.5


