Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932907Ab3FQNCf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 09:02:35 -0400
Received: from na3sys009aog131.obsmtp.com ([74.125.149.247]:37750 "EHLO
	na3sys009aog131.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932727Ab3FQNCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 09:02:34 -0400
From: Lei Wen <leiwen@marvell.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        <mingo@redhat.com>, <leiwen@marvell.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] sched: scale the busy and this queue's per-task load before compare
Date: Mon, 17 Jun 2013 21:00:23 +0800
Message-ID: <1371474024-19787-3-git-send-email-leiwen@marvell.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1371474024-19787-1-git-send-email-leiwen@marvell.com>
References: <1371474024-19787-1-git-send-email-leiwen@marvell.com>
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
 kernel/sched/fair.c |   28 +++++++++++++++++++---------
 1 file changed, 19 insertions(+), 9 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 28052fa..77a149c 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4692,7 +4692,7 @@ void fix_small_imbalance(struct lb_env *env, struct sd_lb_stats *sds)
 {
 	unsigned long tmp, pwr_now = 0, pwr_move = 0;
 	unsigned int imbn = 2;
-	unsigned long scaled_busy_load_per_task;
+	unsigned long scaled_busy_load_per_task, scaled_this_load_per_task;
 
 	if (sds->this_nr_running) {
 		sds->this_load_per_task /= sds->this_nr_running;
@@ -4714,6 +4714,9 @@ void fix_small_imbalance(struct lb_env *env, struct sd_lb_stats *sds)
 		return;
 	}
 
+	scaled_this_load_per_task = sds->this_load_per_task
+					 * SCHED_POWER_SCALE;
+	scaled_this_load_per_task /= sds->this->sgp->power;
 	/*
 	 * OK, we don't have enough imbalance to justify moving tasks,
 	 * however we may be able to increase total CPU power used by
@@ -4721,28 +4724,35 @@ void fix_small_imbalance(struct lb_env *env, struct sd_lb_stats *sds)
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
+	 * sds->max_load is larger than scaled_busy_load_per_task, while,
+	 * scaled_this_load_per_task is larger than sds->this_load plus by
+	 * the scaled scaled_busy_load_per_task moved into this queue
+	 */
 	if (pwr_move > pwr_now)
 		env->imbalance = sds->busiest_load_per_task;
 }
-- 
1.7.10.4

