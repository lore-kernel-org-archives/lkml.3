Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759342AbaGCQ0T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 12:26:19 -0400
Received: from service87.mimecast.com ([91.220.42.44]:45321 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759282AbaGCQ0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 12:26:16 -0400
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        peterz@infradead.org, mingo@kernel.org
Cc: rjw@rjwysocki.net, vincent.guittot@linaro.org, daniel.lezcano@linaro.org,
        preeti@linux.vnet.ibm.com, Dietmar.Eggemann@arm.com, pjt@google.com
Subject: [RFCv2 PATCH 08/23] sched: Aggregate unweighted load contributed by task entities on parenting cfs_rq
Date: Thu,  3 Jul 2014 17:25:55 +0100
Message-Id: <1404404770-323-9-git-send-email-morten.rasmussen@arm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1404404770-323-1-git-send-email-morten.rasmussen@arm.com>
References: <1404404770-323-1-git-send-email-morten.rasmussen@arm.com>
X-OriginalArrivalTime: 03 Jul 2014 16:26:12.0506 (UTC) FILETIME=[811ADFA0:01CF96DB]
X-MC-Unique: 114070317261401701
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id s63GV7Zl010718

From: Dietmar Eggemann <dietmar.eggemann@arm.com>

Energy aware scheduling relies on cpu utilization and to be able to
maintain it, we need a per run queue signal of the sum of the
unweighted, i.e. not scaled with task priority, load contribution of
runnable task entries.

The unweighted runnable load on a run queue is maintained alongside the
existing (weighted) runnable load.

This patch is the unweighted counterpart of "sched: Aggregate load
contributed by task entities on parenting cfs_rq" (commit id
2dac754e10a5).

Signed-off-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
---
 include/linux/sched.h |    1 +
 kernel/sched/debug.c  |    4 ++++
 kernel/sched/fair.c   |   26 ++++++++++++++++++++++----
 kernel/sched/sched.h  |    1 +
 4 files changed, 28 insertions(+), 4 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 1507390..b5eeae0 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1105,6 +1105,7 @@ struct sched_avg {
 	u64 last_runnable_update;
 	s64 decay_count;
 	unsigned long load_avg_contrib;
+	unsigned long uw_load_avg_contrib;
 };
 
 #ifdef CONFIG_SCHEDSTATS
diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index 695f977..78d4151 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -96,6 +96,7 @@ static void print_cfs_group_stats(struct seq_file *m, int cpu, struct task_group
 	P(se->avg.runnable_avg_sum);
 	P(se->avg.runnable_avg_period);
 	P(se->avg.load_avg_contrib);
+	P(se->avg.uw_load_avg_contrib);
 	P(se->avg.decay_count);
 #endif
 #undef PN
@@ -215,6 +216,8 @@ void print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
 #ifdef CONFIG_SMP
 	SEQ_printf(m, "  .%-30s: %ld\n", "runnable_load_avg",
 			cfs_rq->runnable_load_avg);
+	SEQ_printf(m, "  .%-30s: %ld\n", "uw_runnable_load_avg",
+			cfs_rq->uw_runnable_load_avg);
 	SEQ_printf(m, "  .%-30s: %ld\n", "blocked_load_avg",
 			cfs_rq->blocked_load_avg);
 #ifdef CONFIG_FAIR_GROUP_SCHED
@@ -635,6 +638,7 @@ void proc_sched_show_task(struct task_struct *p, struct seq_file *m)
 	P(se.avg.runnable_avg_sum);
 	P(se.avg.runnable_avg_period);
 	P(se.avg.load_avg_contrib);
+	P(se.avg.uw_load_avg_contrib);
 	P(se.avg.decay_count);
 #endif
 	P(policy);
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 981406e..1ee47b3 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2345,6 +2345,8 @@ static inline u64 __synchronize_entity_decay(struct sched_entity *se)
 		return 0;
 
 	se->avg.load_avg_contrib = decay_load(se->avg.load_avg_contrib, decays);
+	se->avg.uw_load_avg_contrib = decay_load(se->avg.uw_load_avg_contrib,
+						 decays);
 	se->avg.decay_count = 0;
 
 	return decays;
@@ -2451,12 +2453,18 @@ static inline void __update_task_entity_contrib(struct sched_entity *se)
 	contrib = se->avg.runnable_avg_sum * scale_load_down(se->load.weight);
 	contrib /= (se->avg.runnable_avg_period + 1);
 	se->avg.load_avg_contrib = scale_load(contrib);
+
+	contrib = se->avg.runnable_avg_sum * scale_load_down(NICE_0_LOAD);
+	contrib /= (se->avg.runnable_avg_period + 1);
+	se->avg.uw_load_avg_contrib = scale_load(contrib);
 }
 
 /* Compute the current contribution to load_avg by se, return any delta */
-static long __update_entity_load_avg_contrib(struct sched_entity *se)
+static long __update_entity_load_avg_contrib(struct sched_entity *se,
+					     long *uw_contrib_delta)
 {
 	long old_contrib = se->avg.load_avg_contrib;
+	long uw_old_contrib = se->avg.uw_load_avg_contrib;
 
 	if (entity_is_task(se)) {
 		__update_task_entity_contrib(se);
@@ -2465,6 +2473,10 @@ static long __update_entity_load_avg_contrib(struct sched_entity *se)
 		__update_group_entity_contrib(se);
 	}
 
+	if (uw_contrib_delta)
+		*uw_contrib_delta = se->avg.uw_load_avg_contrib -
+					uw_old_contrib;
+
 	return se->avg.load_avg_contrib - old_contrib;
 }
 
@@ -2484,7 +2496,7 @@ static inline void update_entity_load_avg(struct sched_entity *se,
 					  int update_cfs_rq)
 {
 	struct cfs_rq *cfs_rq = cfs_rq_of(se);
-	long contrib_delta;
+	long contrib_delta, uw_contrib_delta;
 	u64 now;
 
 	/*
@@ -2499,13 +2511,15 @@ static inline void update_entity_load_avg(struct sched_entity *se,
 	if (!__update_entity_runnable_avg(now, &se->avg, se->on_rq))
 		return;
 
-	contrib_delta = __update_entity_load_avg_contrib(se);
+	contrib_delta = __update_entity_load_avg_contrib(se, &uw_contrib_delta);
 
 	if (!update_cfs_rq)
 		return;
 
-	if (se->on_rq)
+	if (se->on_rq) {
 		cfs_rq->runnable_load_avg += contrib_delta;
+		cfs_rq->uw_runnable_load_avg += uw_contrib_delta;
+	}
 	else
 		subtract_blocked_load_contrib(cfs_rq, -contrib_delta);
 }
@@ -2582,6 +2596,8 @@ static inline void enqueue_entity_load_avg(struct cfs_rq *cfs_rq,
 	}
 
 	cfs_rq->runnable_load_avg += se->avg.load_avg_contrib;
+	cfs_rq->uw_runnable_load_avg += se->avg.uw_load_avg_contrib;
+
 	/* we force update consideration on load-balancer moves */
 	update_cfs_rq_blocked_load(cfs_rq, !wakeup);
 }
@@ -2600,6 +2616,8 @@ static inline void dequeue_entity_load_avg(struct cfs_rq *cfs_rq,
 	update_cfs_rq_blocked_load(cfs_rq, !sleep);
 
 	cfs_rq->runnable_load_avg -= se->avg.load_avg_contrib;
+	cfs_rq->uw_runnable_load_avg -= se->avg.uw_load_avg_contrib;
+
 	if (sleep) {
 		cfs_rq->blocked_load_avg += se->avg.load_avg_contrib;
 		se->avg.decay_count = atomic64_read(&cfs_rq->decay_counter);
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index c971359..46cb8bd 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -337,6 +337,7 @@ struct cfs_rq {
 	 * the FAIR_GROUP_SCHED case).
 	 */
 	unsigned long runnable_load_avg, blocked_load_avg;
+	unsigned long uw_runnable_load_avg;
 	atomic64_t decay_counter;
 	u64 last_decay;
 	atomic_long_t removed_load;
-- 
1.7.9.5


