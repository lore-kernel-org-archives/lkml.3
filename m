Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754622AbaIVQYP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 12:24:15 -0400
Received: from service87.mimecast.com ([91.220.42.44]:60443 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754138AbaIVQYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 12:24:11 -0400
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: peterz@infradead.org, mingo@redhat.com
Cc: dietmar.eggemann@arm.com, pjt@google.com, bsegall@google.com,
        vincent.guittot@linaro.org, nicolas.pitre@linaro.org,
        mturquette@linaro.org, rjw@rjwysocki.net, linux-kernel@vger.kernel.org,
        Morten Rasmussen <morten.rasmussen@arm.com>
Subject: [PATCH 7/7] sched: Track sched_entity usage contributions
Date: Mon, 22 Sep 2014 17:24:07 +0100
Message-Id: <1411403047-32010-8-git-send-email-morten.rasmussen@arm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1411403047-32010-1-git-send-email-morten.rasmussen@arm.com>
References: <1411403047-32010-1-git-send-email-morten.rasmussen@arm.com>
X-OriginalArrivalTime: 22 Sep 2014 16:24:08.0612 (UTC) FILETIME=[A2B7E640:01CFD681]
X-MC-Unique: 114092217240911501
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id s8MGObWT029522

Adds usage contribution tracking for both task and group entities.
Maintains a non-priority scaled se->avg.usage_avg_contrib for each
sched_entity and cfs_rq.usage_util_avg sum of all entity contributions.
The latter provides a more accurate estimate of the true cpu utilization
than the existing cfs_rq.runnable_load_avg (+blocked_load_avg).

Unlike se->avg.load_avg_contrib, se->avg.usage_avg_contrib for group
entities is the sum of se->avg.usage_avg_contrib for all entities on the
group runqueue. It is _not_ influenced in any way by the task group
h_load. Hence it is representing the actual cpu usage of the group, not
its intended load contribution which may differ significantly from the
usage on lightly utilized systems.

The cpu usage tracking is available as cpu_rq(cpu)->cfs.usage_util_avg.
No tracking of blocked usage has been implemented.

cc: Paul Turner <pjt@google.com>
cc: Ben Segall <bsegall@google.com>

Signed-off-by: Morten Rasmussen <morten.rasmussen@arm.com>
---
 include/linux/sched.h |    2 +-
 kernel/sched/debug.c  |    4 ++++
 kernel/sched/fair.c   |   32 ++++++++++++++++++++++++++------
 kernel/sched/sched.h  |    2 +-
 4 files changed, 32 insertions(+), 8 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 0bcd8a7..509d5ce 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1079,7 +1079,7 @@ struct sched_avg {
 	u32 runnable_avg_sum, runnable_avg_period;
 	u64 last_runnable_update;
 	s64 decay_count;
-	unsigned long load_avg_contrib;
+	unsigned long load_avg_contrib, usage_avg_contrib;
 	u32 usage_avg_sum;
 };
 
diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index ed5a9ce..a655427 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -97,6 +97,7 @@ static void print_cfs_group_stats(struct seq_file *m, int cpu, struct task_group
 	P(se->avg.runnable_avg_period);
 	P(se->avg.usage_avg_sum);
 	P(se->avg.load_avg_contrib);
+	P(se->avg.usage_avg_contrib);
 	P(se->avg.decay_count);
 #endif
 #undef PN
@@ -214,6 +215,8 @@ void print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
 #ifdef CONFIG_SMP
 	SEQ_printf(m, "  .%-30s: %ld\n", "runnable_load_avg",
 			cfs_rq->runnable_load_avg);
+	SEQ_printf(m, "  .%-30s: %ld\n", "usage_util_avg",
+			cfs_rq->usage_util_avg);
 	SEQ_printf(m, "  .%-30s: %ld\n", "blocked_load_avg",
 			cfs_rq->blocked_load_avg);
 #ifdef CONFIG_FAIR_GROUP_SCHED
@@ -634,6 +637,7 @@ void proc_sched_show_task(struct task_struct *p, struct seq_file *m)
 	P(se.avg.runnable_avg_sum);
 	P(se.avg.runnable_avg_period);
 	P(se.avg.load_avg_contrib);
+	P(se.avg.usage_avg_contrib);
 	P(se.avg.decay_count);
 #endif
 	P(policy);
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index c7aa8c1..c374825 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -678,6 +678,7 @@ void init_task_runnable_average(struct task_struct *p)
 	p->se.avg.decay_count = 0;
 	slice = sched_slice(task_cfs_rq(p), &p->se) >> 10;
 	p->se.avg.runnable_avg_sum = slice;
+	p->se.avg.usage_avg_sum = slice;
 	p->se.avg.runnable_avg_period = slice;
 	__update_task_entity_contrib(&p->se);
 }
@@ -2395,6 +2396,8 @@ static inline u64 __synchronize_entity_decay(struct sched_entity *se)
 		return 0;
 
 	se->avg.load_avg_contrib = decay_load(se->avg.load_avg_contrib, decays);
+	se->avg.usage_avg_contrib = decay_load(se->avg.usage_avg_contrib,
+						decays);
 	se->avg.decay_count = 0;
 
 	return decays;
@@ -2480,6 +2483,8 @@ static inline void __update_group_entity_contrib(struct sched_entity *se)
 		se->avg.load_avg_contrib *= runnable_avg;
 		se->avg.load_avg_contrib >>= NICE_0_SHIFT;
 	}
+
+	se->avg.usage_avg_contrib = cfs_rq->usage_util_avg;
 }
 
 static inline void update_rq_runnable_avg(struct rq *rq, int runnable)
@@ -2499,18 +2504,24 @@ static inline void update_rq_runnable_avg(struct rq *rq, int runnable) {}
 
 static inline void __update_task_entity_contrib(struct sched_entity *se)
 {
-	u32 contrib;
+	u32 contrib, usage_contrib;
 
 	/* avoid overflowing a 32-bit type w/ SCHED_LOAD_SCALE */
 	contrib = se->avg.runnable_avg_sum * scale_load_down(se->load.weight);
 	contrib /= (se->avg.runnable_avg_period + 1);
 	se->avg.load_avg_contrib = scale_load(contrib);
+
+	usage_contrib = se->avg.usage_avg_sum * scale_load_down(NICE_0_LOAD);
+	usage_contrib /= (se->avg.runnable_avg_period + 1);
+	se->avg.usage_avg_contrib = scale_load(usage_contrib);
 }
 
 /* Compute the current contribution to load_avg by se, return any delta */
-static long __update_entity_load_avg_contrib(struct sched_entity *se)
+static long __update_entity_load_avg_contrib(struct sched_entity *se,
+						long *usage_contrib_delta)
 {
 	long old_contrib = se->avg.load_avg_contrib;
+	long old_usage_contrib = se->avg.usage_avg_contrib;
 
 	if (entity_is_task(se)) {
 		__update_task_entity_contrib(se);
@@ -2519,6 +2530,10 @@ static long __update_entity_load_avg_contrib(struct sched_entity *se)
 		__update_group_entity_contrib(se);
 	}
 
+	if (usage_contrib_delta)
+		*usage_contrib_delta = se->avg.usage_avg_contrib -
+					old_usage_contrib;
+
 	return se->avg.load_avg_contrib - old_contrib;
 }
 
@@ -2538,7 +2553,7 @@ static inline void update_entity_load_avg(struct sched_entity *se,
 					  int update_cfs_rq)
 {
 	struct cfs_rq *cfs_rq = cfs_rq_of(se);
-	long contrib_delta;
+	long contrib_delta, usage_delta;
 	int cpu = rq_of(cfs_rq)->cpu;
 	u64 now;
 
@@ -2555,14 +2570,15 @@ static inline void update_entity_load_avg(struct sched_entity *se,
 					  cfs_rq->curr == se))
 		return;
 
-	contrib_delta = __update_entity_load_avg_contrib(se);
+	contrib_delta = __update_entity_load_avg_contrib(se, &usage_delta);
 
 	if (!update_cfs_rq)
 		return;
 
-	if (se->on_rq)
+	if (se->on_rq) {
 		cfs_rq->runnable_load_avg += contrib_delta;
-	else
+		cfs_rq->usage_util_avg += usage_delta;
+	} else
 		subtract_blocked_load_contrib(cfs_rq, -contrib_delta);
 }
 
@@ -2638,6 +2654,8 @@ static inline void enqueue_entity_load_avg(struct cfs_rq *cfs_rq,
 	}
 
 	cfs_rq->runnable_load_avg += se->avg.load_avg_contrib;
+	cfs_rq->usage_util_avg += se->avg.usage_avg_contrib;
+
 	/* we force update consideration on load-balancer moves */
 	update_cfs_rq_blocked_load(cfs_rq, !wakeup);
 }
@@ -2656,6 +2674,8 @@ static inline void dequeue_entity_load_avg(struct cfs_rq *cfs_rq,
 	update_cfs_rq_blocked_load(cfs_rq, !sleep);
 
 	cfs_rq->runnable_load_avg -= se->avg.load_avg_contrib;
+	cfs_rq->usage_util_avg -= se->avg.usage_avg_contrib;
+
 	if (sleep) {
 		cfs_rq->blocked_load_avg += se->avg.load_avg_contrib;
 		se->avg.decay_count = atomic64_read(&cfs_rq->decay_counter);
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 1bc6aad..527ae12 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -340,7 +340,7 @@ struct cfs_rq {
 	 * This allows for the description of both thread and group usage (in
 	 * the FAIR_GROUP_SCHED case).
 	 */
-	unsigned long runnable_load_avg, blocked_load_avg;
+	unsigned long runnable_load_avg, blocked_load_avg, usage_util_avg;
 	atomic64_t decay_counter;
 	u64 last_decay;
 	atomic_long_t removed_load;
-- 
1.7.9.5


