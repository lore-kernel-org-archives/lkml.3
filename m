Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754043Ab3FRDVA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 23:21:00 -0400
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:60281 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753803Ab3FRDU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 23:20:59 -0400
From: Lei Wen <leiwen@marvell.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        <mingo@redhat.com>, <leiwen@marvell.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 2/3] sched: scale the busy and this queue's per-task load before compare
Date: Tue, 18 Jun 2013 11:18:05 +0800
Message-ID: <1371525486-11270-3-git-send-email-leiwen@marvell.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1371525486-11270-1-git-send-email-leiwen@marvell.com>
References: <1371525486-11270-1-git-send-email-leiwen@marvell.com>
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
 kernel/sched/fair.c |   38 +++++++++++++++++++++++++-------------
 1 file changed, 25 insertions(+), 13 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 28052fa..6173095 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4692,10 +4692,14 @@ void fix_small_imbalance(struct lb_env *env, struct sd_lb_stats *sds)
 {
 	unsigned long tmp, pwr_now = 0, pwr_move = 0;
 	unsigned int imbn = 2;
-	unsigned long scaled_busy_load_per_task;
 
 	if (sds->this_nr_running) {
 		sds->this_load_per_task /= sds->this_nr_running;
+
+		/* Scale this_load_per_task to local power not related */
+		sds->this_load_per_task <<= SCHED_POWER_SHIFT;
+		sds->this_load_per_task /= sds->this->sgp->power;
+
 		if (sds->busiest_load_per_task >
 				sds->this_load_per_task)
 			imbn = 1;
@@ -4704,12 +4708,8 @@ void fix_small_imbalance(struct lb_env *env, struct sd_lb_stats *sds)
 			cpu_avg_load_per_task(env->dst_cpu);
 	}
 
-	scaled_busy_load_per_task = sds->busiest_load_per_task
-					 * SCHED_POWER_SCALE;
-	scaled_busy_load_per_task /= sds->busiest->sgp->power;
-
-	if (sds->max_load - sds->this_load + scaled_busy_load_per_task >=
-			(scaled_busy_load_per_task * imbn)) {
+	if (sds->max_load - sds->this_load + sds->busiest_load_per_task >=
+			(sds->busiest_load_per_task * imbn)) {
 		env->imbalance = sds->busiest_load_per_task;
 		return;
 	}
@@ -4727,22 +4727,29 @@ void fix_small_imbalance(struct lb_env *env, struct sd_lb_stats *sds)
 	pwr_now /= SCHED_POWER_SCALE;
 
 	/* Amount of load we'd subtract */
-	if (sds->max_load > scaled_busy_load_per_task) {
+	if (sds->max_load > sds->busiest_load_per_task) {
 		pwr_move += sds->busiest->sgp->power *
 			min(sds->busiest_load_per_task,
-				sds->max_load - scaled_busy_load_per_task);
-		tmp = (sds->busiest_load_per_task * SCHED_POWER_SCALE) /
-			sds->this->sgp->power;
+				sds->max_load - sds->busiest_load_per_task);
+		tmp = sds->busiest_load_per_task;
 	} else
-		tmp = (sds->max_load * sds->busiest->sgp->power) /
-			sds->this->sgp->power;
+		tmp = sds->max_load;
 
+	/* Scale to this queue from busiest queue */
+	tmp = (tmp * sds->busiest->sgp->power) /
+		sds->this->sgp->power;
 	/* Amount of load we'd add */
 	pwr_move += sds->this->sgp->power *
 			min(sds->this_load_per_task, sds->this_load + tmp);
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
@@ -4758,6 +4765,11 @@ static inline void calculate_imbalance(struct lb_env *env, struct sd_lb_stats *s
 	unsigned long max_pull, load_above_capacity = ~0UL;
 
 	sds->busiest_load_per_task /= sds->busiest_nr_running;
+
+	/* Scale busiest_load_per_task to local power not related */
+	sds->busiest_load_per_task <<= SCHED_POWER_SHIFT;
+	sds->busiest_load_per_task /= sds->busiest->sgp->power;
+
 	if (sds->group_imb) {
 		sds->busiest_load_per_task =
 			min(sds->busiest_load_per_task, sds->avg_load);
-- 
1.7.10.4

