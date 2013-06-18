Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932119Ab3FRNLo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 09:11:44 -0400
Received: from na3sys009aog131.obsmtp.com ([74.125.149.247]:59547 "EHLO
	na3sys009aog131.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752106Ab3FRNLm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 09:11:42 -0400
From: Lei Wen <leiwen@marvell.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        <mingo@redhat.com>, <leiwen@marvell.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v4 2/4] sched: scale the busy and this queue's per-task load before compare
Date: Tue, 18 Jun 2013 21:04:17 +0800
Message-ID: <1371560659-4686-3-git-send-email-leiwen@marvell.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1371560659-4686-1-git-send-email-leiwen@marvell.com>
References: <1371560659-4686-1-git-send-email-leiwen@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since for max_load and this_load, they are the value that already be
scaled. It is not reasonble to get a minimum value between the scaled
and non-scaled value, like below example.
	min(sds->busiest_load_per_task, sds->max_load);

Also add comment over in what condition, there would be cpu power gain
in move the load.

Signed-off-by: Lei Wen <leiwen@marvell.com>
---
 kernel/sched/fair.c |   55 +++++++++++++++++++++++++++++++++++----------------
 1 file changed, 38 insertions(+), 17 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 28052fa..fd9cbee 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4686,16 +4686,19 @@ static int check_asym_packing(struct lb_env *env, struct sd_lb_stats *sds)
  *			load balancing.
  * @env: The load balancing environment.
  * @sds: Statistics of the sched_domain whose imbalance is to be calculated.
+ * @scaled_busiest_load_per_task: per calculated busist queue average load
  */
 static inline
-void fix_small_imbalance(struct lb_env *env, struct sd_lb_stats *sds)
+void fix_small_imbalance(struct lb_env *env, struct sd_lb_stats *sds,
+		unsigned long scaled_busy_load_per_task)
 {
 	unsigned long tmp, pwr_now = 0, pwr_move = 0;
+	unsigned long scaled_this_load_per_task;
 	unsigned int imbn = 2;
-	unsigned long scaled_busy_load_per_task;
 
 	if (sds->this_nr_running) {
 		sds->this_load_per_task /= sds->this_nr_running;
+
 		if (sds->busiest_load_per_task >
 				sds->this_load_per_task)
 			imbn = 1;
@@ -4704,9 +4707,10 @@ void fix_small_imbalance(struct lb_env *env, struct sd_lb_stats *sds)
 			cpu_avg_load_per_task(env->dst_cpu);
 	}
 
-	scaled_busy_load_per_task = sds->busiest_load_per_task
-					 * SCHED_POWER_SCALE;
-	scaled_busy_load_per_task /= sds->busiest->sgp->power;
+	/* Scale this_load_per_task to local power not related */
+	scaled_this_load_per_task = sds->this_load_per_task
+					<< SCHED_POWER_SHIFT;
+	scaled_this_load_per_task /= sds->this->sgp->power;
 
 	if (sds->max_load - sds->this_load + scaled_busy_load_per_task >=
 			(scaled_busy_load_per_task * imbn)) {
@@ -4721,28 +4725,35 @@ void fix_small_imbalance(struct lb_env *env, struct sd_lb_stats *sds)
 	 */
 
 	pwr_now += sds->busiest->sgp->power *
-			min(sds->busiest_load_per_task, sds->max_load);
+			min(scaled_busy_load_per_task, sds->max_load);
 	pwr_now += sds->this->sgp->power *
-			min(sds->this_load_per_task, sds->this_load);
+			min(scaled_this_load_per_task, sds->this_load);
 	pwr_now /= SCHED_POWER_SCALE;
 
 	/* Amount of load we'd subtract */
 	if (sds->max_load > scaled_busy_load_per_task) {
 		pwr_move += sds->busiest->sgp->power *
-			min(sds->busiest_load_per_task,
+			min(scaled_busy_load_per_task,
 				sds->max_load - scaled_busy_load_per_task);
-		tmp = (sds->busiest_load_per_task * SCHED_POWER_SCALE) /
-			sds->this->sgp->power;
+		tmp = scaled_busy_load_per_task;
 	} else
-		tmp = (sds->max_load * sds->busiest->sgp->power) /
-			sds->this->sgp->power;
+		tmp = sds->max_load;
 
+	/* Scale to this queue from busiest queue */
+	tmp = (tmp * sds->busiest->sgp->power) /
+		sds->this->sgp->power;
 	/* Amount of load we'd add */
 	pwr_move += sds->this->sgp->power *
-			min(sds->this_load_per_task, sds->this_load + tmp);
+			min(scaled_this_load_per_task, sds->this_load + tmp);
 	pwr_move /= SCHED_POWER_SCALE;
 
 	/* Move if we gain throughput */
+	/*
+	 * The only possibilty for below statement be true, is:
+	 * sds->max_load is larger than sds->busiest_load_per_task, while,
+	 * sds->busiest_load_per_task is larger than sds->this_load plus by
+	 * the scaled sds->busiest_load_per_task moved into this queue
+	 */
 	if (pwr_move > pwr_now)
 		env->imbalance = sds->busiest_load_per_task;
 }
@@ -4756,11 +4767,21 @@ void fix_small_imbalance(struct lb_env *env, struct sd_lb_stats *sds)
 static inline void calculate_imbalance(struct lb_env *env, struct sd_lb_stats *sds)
 {
 	unsigned long max_pull, load_above_capacity = ~0UL;
+	unsigned long scaled_busy_load_per_task;
 
 	sds->busiest_load_per_task /= sds->busiest_nr_running;
+
+	/* Scale busiest_load_per_task to local power not related */
+	scaled_busy_load_per_task = sds->busiest_load_per_task
+					<<  SCHED_POWER_SHIFT;
+	scaled_busy_load_per_task /= sds->busiest->sgp->power;
+
 	if (sds->group_imb) {
-		sds->busiest_load_per_task =
-			min(sds->busiest_load_per_task, sds->avg_load);
+		scaled_busy_load_per_task =
+			min(scaled_busy_load_per_task, sds->avg_load);
+		sds->busiest_load_per_task = scaled_busy_load_per_task
+						* sds->busiest->sgp->power;
+		sds->busiest_load_per_task >>= SCHED_POWER_SHIFT;
 	}
 
 	/*
@@ -4770,7 +4791,7 @@ static inline void calculate_imbalance(struct lb_env *env, struct sd_lb_stats *s
 	 */
 	if (sds->max_load < sds->avg_load) {
 		env->imbalance = 0;
-		return fix_small_imbalance(env, sds);
+		return fix_small_imbalance(env, sds, scaled_busy_load_per_task);
 	}
 
 	if (!sds->group_imb) {
@@ -4809,7 +4830,7 @@ static inline void calculate_imbalance(struct lb_env *env, struct sd_lb_stats *s
 	 * moved
 	 */
 	if (env->imbalance < sds->busiest_load_per_task)
-		return fix_small_imbalance(env, sds);
+		return fix_small_imbalance(env, sds, scaled_busy_load_per_task);
 
 }
 
-- 
1.7.10.4

