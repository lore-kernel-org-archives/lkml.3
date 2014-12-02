Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754118AbaLBOIw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 09:08:52 -0500
Received: from service88.mimecast.com ([195.130.217.12]:50583 "EHLO
	service88.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753528AbaLBOHC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 09:07:02 -0500
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: peterz@infradead.org, mingo@redhat.com
Cc: dietmar.eggemann@arm.com, vincent.guittot@linaro.org, pjt@google.com,
        bsegall@google.com, mturquette@linaro.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        Morten Rasmussen <morten.rasmussen@arm.com>
Subject: [RFC PATCH 08/10] sched: Track blocked utilization contributions
Date: Tue,  2 Dec 2014 14:06:30 +0000
Message-Id: <1417529192-11579-9-git-send-email-morten.rasmussen@arm.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417529192-11579-1-git-send-email-morten.rasmussen@arm.com>
References: <1417529192-11579-1-git-send-email-morten.rasmussen@arm.com>
X-OriginalArrivalTime: 02 Dec 2014 14:06:58.0854 (UTC) FILETIME=[3CBABC60:01D00E39]
X-MC-Unique: 114120214065906001
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by nfs id sB2E941J016988

Introduces the blocked utilization, the utilization counter-part to
cfs_rq->utilization_load_avg. It is the sum of sched_entity utilization
contributions of entities that were recently on the cfs_rq that are
currently blocked. Combined with sum of contributions of entities
currently on the cfs_rq or currently running
(cfs_rq->utilization_load_avg) this can provide a more stable average
view of the cpu usage.

cc: Ingo Molnar <mingo@redhat.com>
cc: Peter Zijlstra <peterz@infradead.org>

Signed-off-by: Morten Rasmussen <morten.rasmussen@arm.com>
---
 kernel/sched/fair.c  | 30 +++++++++++++++++++++++++++++-
 kernel/sched/sched.h |  8 ++++++--
 2 files changed, 35 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 090223f..adf64df 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2778,6 +2778,15 @@ static inline void subtract_blocked_load_contrib(struct cfs_rq *cfs_rq,
 		cfs_rq->blocked_load_avg = 0;
 }
 
+static inline void subtract_utilization_blocked_contrib(struct cfs_rq *cfs_rq,
+						long utilization_contrib)
+{
+	if (likely(utilization_contrib < cfs_rq->utilization_blocked_avg))
+		cfs_rq->utilization_blocked_avg -= utilization_contrib;
+	else
+		cfs_rq->utilization_blocked_avg = 0;
+}
+
 static inline u64 cfs_rq_clock_task(struct cfs_rq *cfs_rq);
 
 /* Update a sched_entity's runnable average */
@@ -2813,6 +2822,8 @@ static inline void update_entity_load_avg(struct sched_entity *se,
 		cfs_rq->utilization_load_avg += utilization_delta;
 	} else {
 		subtract_blocked_load_contrib(cfs_rq, -contrib_delta);
+		subtract_utilization_blocked_contrib(cfs_rq,
+							-utilization_delta);
 	}
 }
 
@@ -2830,14 +2841,20 @@ static void update_cfs_rq_blocked_load(struct cfs_rq *cfs_rq, int force_update)
 		return;
 
 	if (atomic_long_read(&cfs_rq->removed_load)) {
-		unsigned long removed_load;
+		unsigned long removed_load, removed_utilization;
 		removed_load = atomic_long_xchg(&cfs_rq->removed_load, 0);
+		removed_utilization =
+			atomic_long_xchg(&cfs_rq->removed_utilization, 0);
 		subtract_blocked_load_contrib(cfs_rq, removed_load);
+		subtract_utilization_blocked_contrib(cfs_rq,
+							removed_utilization);
 	}
 
 	if (decays) {
 		cfs_rq->blocked_load_avg = decay_load(cfs_rq->blocked_load_avg,
 						      decays);
+		cfs_rq->utilization_blocked_avg =
+			decay_load(cfs_rq->utilization_blocked_avg, decays);
 		atomic64_add(decays, &cfs_rq->decay_counter);
 		cfs_rq->last_decay = now;
 	}
@@ -2884,6 +2901,8 @@ static inline void enqueue_entity_load_avg(struct cfs_rq *cfs_rq,
 	/* migrated tasks did not contribute to our blocked load */
 	if (wakeup) {
 		subtract_blocked_load_contrib(cfs_rq, se->avg.load_avg_contrib);
+		subtract_utilization_blocked_contrib(cfs_rq,
+					se->avg.utilization_avg_contrib);
 		update_entity_load_avg(se, 0);
 	}
 
@@ -2910,6 +2929,8 @@ static inline void dequeue_entity_load_avg(struct cfs_rq *cfs_rq,
 	cfs_rq->utilization_load_avg -= se->avg.utilization_avg_contrib;
 	if (sleep) {
 		cfs_rq->blocked_load_avg += se->avg.load_avg_contrib;
+		cfs_rq->utilization_blocked_avg +=
+						se->avg.utilization_avg_contrib;
 		se->avg.decay_count = atomic64_read(&cfs_rq->decay_counter);
 	} /* migrations, e.g. sleep=0 leave decay_count == 0 */
 }
@@ -4929,6 +4950,8 @@ migrate_task_rq_fair(struct task_struct *p, int next_cpu)
 		se->avg.decay_count = -__synchronize_entity_decay(se);
 		atomic_long_add(se->avg.load_avg_contrib,
 						&cfs_rq->removed_load);
+		atomic_long_add(se->avg.utilization_avg_contrib,
+					&cfs_rq->removed_utilization);
 	}
 
 	/* We have migrated, no longer consider this task hot */
@@ -7944,6 +7967,8 @@ static void switched_from_fair(struct rq *rq, struct task_struct *p)
 	if (se->avg.decay_count) {
 		__synchronize_entity_decay(se);
 		subtract_blocked_load_contrib(cfs_rq, se->avg.load_avg_contrib);
+		subtract_utilization_blocked_contrib(cfs_rq,
+					se->avg.utilization_avg_contrib);
 	}
 #endif
 }
@@ -8003,6 +8028,7 @@ void init_cfs_rq(struct cfs_rq *cfs_rq)
 #ifdef CONFIG_SMP
 	atomic64_set(&cfs_rq->decay_counter, 1);
 	atomic_long_set(&cfs_rq->removed_load, 0);
+	atomic_long_set(&cfs_rq->removed_utilization, 0);
 #endif
 }
 
@@ -8055,6 +8081,8 @@ static void task_move_group_fair(struct task_struct *p, int queued)
 		 */
 		se->avg.decay_count = atomic64_read(&cfs_rq->decay_counter);
 		cfs_rq->blocked_load_avg += se->avg.load_avg_contrib;
+		cfs_rq->utilization_blocked_avg +=
+						se->avg.utilization_avg_contrib;
 #endif
 	}
 }
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index e402133..208237f 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -368,11 +368,15 @@ struct cfs_rq {
 	 * the blocked sched_entities on the rq.
 	 * utilization_load_avg is the sum of the average running time of the
 	 * sched_entities on the rq.
+	 * utilization_blocked_avg is the utilization equivalent of
+	 * blocked_load_avg, i.e. the sum of running contributions of blocked
+	 * sched_entities associated with the rq.
 	 */
-	unsigned long runnable_load_avg, blocked_load_avg, utilization_load_avg;
+	unsigned long runnable_load_avg, blocked_load_avg;
+	unsigned long utilization_load_avg, utilization_blocked_avg;
 	atomic64_t decay_counter;
 	u64 last_decay;
-	atomic_long_t removed_load;
+	atomic_long_t removed_load, removed_utilization;
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	/* Required to track per-cpu representation of a task_group */
-- 
1.9.1


