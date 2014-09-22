Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754602AbaIVQYN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 12:24:13 -0400
Received: from service87.mimecast.com ([91.220.42.44]:60503 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754578AbaIVQYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 12:24:11 -0400
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: peterz@infradead.org, mingo@redhat.com
Cc: dietmar.eggemann@arm.com, pjt@google.com, bsegall@google.com,
        vincent.guittot@linaro.org, nicolas.pitre@linaro.org,
        mturquette@linaro.org, rjw@rjwysocki.net, linux-kernel@vger.kernel.org,
        Morten Rasmussen <morten.rasmussen@arm.com>
Subject: [PATCH 5/7] sched: Implement usage tracking
Date: Mon, 22 Sep 2014 17:24:05 +0100
Message-Id: <1411403047-32010-6-git-send-email-morten.rasmussen@arm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1411403047-32010-1-git-send-email-morten.rasmussen@arm.com>
References: <1411403047-32010-1-git-send-email-morten.rasmussen@arm.com>
X-OriginalArrivalTime: 22 Sep 2014 16:24:07.0315 (UTC) FILETIME=[A1F1FE30:01CFD681]
X-MC-Unique: 114092217241012801
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id s8MGOn81029526

With the framework for runnable tracking now fully in place, per-entity
usage tracking is a simple and low-overhead addition.

This is a rebased and significantly cut down version of a patch
originally authored by Paul Turner <pjt@google.com>.

cc: Paul Turner <pjt@google.com>
cc: Ben Segall <bsegall@google.com>

Signed-off-by: Morten Rasmussen <morten.rasmussen@arm.com>
---
 include/linux/sched.h |    1 +
 kernel/sched/debug.c  |    1 +
 kernel/sched/fair.c   |   16 +++++++++++++---
 3 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 18f5262..0bcd8a7 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1080,6 +1080,7 @@ struct sched_avg {
 	u64 last_runnable_update;
 	s64 decay_count;
 	unsigned long load_avg_contrib;
+	u32 usage_avg_sum;
 };
 
 #ifdef CONFIG_SCHEDSTATS
diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index c7fe1ea0..ed5a9ce 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -95,6 +95,7 @@ static void print_cfs_group_stats(struct seq_file *m, int cpu, struct task_group
 #ifdef CONFIG_SMP
 	P(se->avg.runnable_avg_sum);
 	P(se->avg.runnable_avg_period);
+	P(se->avg.usage_avg_sum);
 	P(se->avg.load_avg_contrib);
 	P(se->avg.decay_count);
 #endif
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 52abb3e..d8a8c83 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2299,7 +2299,8 @@ unsigned long arch_scale_load_capacity(int cpu);
  */
 static __always_inline int __update_entity_runnable_avg(u64 now, int cpu,
 							struct sched_avg *sa,
-							int runnable)
+							int runnable,
+							int running)
 {
 	u64 delta, periods;
 	u32 runnable_contrib;
@@ -2341,6 +2342,8 @@ static __always_inline int __update_entity_runnable_avg(u64 now, int cpu,
 		if (runnable)
 			sa->runnable_avg_sum += (delta_w * scale_cap)
 					>> SCHED_CAPACITY_SHIFT;
+		if (running)
+			sa->usage_avg_sum += delta_w;
 		sa->runnable_avg_period += delta_w;
 
 		delta -= delta_w;
@@ -2353,6 +2356,7 @@ static __always_inline int __update_entity_runnable_avg(u64 now, int cpu,
 						  periods + 1);
 		sa->runnable_avg_period = decay_load(sa->runnable_avg_period,
 						     periods + 1);
+		sa->usage_avg_sum = decay_load(sa->usage_avg_sum, periods + 1);
 
 		/* Efficiently calculate \sum (1..n_period) 1024*y^i */
 		runnable_contrib = __compute_runnable_contrib(periods);
@@ -2360,6 +2364,8 @@ static __always_inline int __update_entity_runnable_avg(u64 now, int cpu,
 		if (runnable)
 			sa->runnable_avg_sum += (runnable_contrib * scale_cap)
 						>> SCHED_CAPACITY_SHIFT;
+		if (running)
+			sa->usage_avg_sum += runnable_contrib;
 		sa->runnable_avg_period += runnable_contrib;
 	}
 
@@ -2367,6 +2373,8 @@ static __always_inline int __update_entity_runnable_avg(u64 now, int cpu,
 	if (runnable)
 		sa->runnable_avg_sum += (delta * scale_cap)
 				>> SCHED_CAPACITY_SHIFT;
+	if (running)
+		sa->usage_avg_sum += delta;
 	sa->runnable_avg_period += delta;
 
 	return decayed;
@@ -2473,7 +2481,7 @@ static inline void __update_group_entity_contrib(struct sched_entity *se)
 static inline void update_rq_runnable_avg(struct rq *rq, int runnable)
 {
 	__update_entity_runnable_avg(rq_clock_task(rq), rq->cpu, &rq->avg,
-					runnable);
+					runnable, runnable);
 	__update_tg_runnable_avg(&rq->avg, &rq->cfs);
 }
 #else /* CONFIG_FAIR_GROUP_SCHED */
@@ -2539,7 +2547,8 @@ static inline void update_entity_load_avg(struct sched_entity *se,
 	else
 		now = cfs_rq_clock_task(group_cfs_rq(se));
 
-	if (!__update_entity_runnable_avg(now, cpu, &se->avg, se->on_rq))
+	if (!__update_entity_runnable_avg(now, cpu, &se->avg, se->on_rq,
+					  cfs_rq->curr == se))
 		return;
 
 	contrib_delta = __update_entity_load_avg_contrib(se);
@@ -2980,6 +2989,7 @@ set_next_entity(struct cfs_rq *cfs_rq, struct sched_entity *se)
 		 */
 		update_stats_wait_end(cfs_rq, se);
 		__dequeue_entity(cfs_rq, se);
+		update_entity_load_avg(se, 1);
 	}
 
 	update_stats_curr_start(cfs_rq, se);
-- 
1.7.9.5


