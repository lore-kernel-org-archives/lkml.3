Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755590Ab3FRNHF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 09:07:05 -0400
Received: from na3sys009aog130.obsmtp.com ([74.125.149.143]:39787 "EHLO
	na3sys009aog130.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753312Ab3FRNHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 09:07:00 -0400
From: Lei Wen <leiwen@marvell.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        <mingo@redhat.com>, <leiwen@marvell.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v4 3/4] sched: scale cpu load for judgment of group imbalance
Date: Tue, 18 Jun 2013 21:04:18 +0800
Message-ID: <1371560659-4686-4-git-send-email-leiwen@marvell.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1371560659-4686-1-git-send-email-leiwen@marvell.com>
References: <1371560659-4686-1-git-send-email-leiwen@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We cannot compare two load directly from two cpus, since the cpu power
over two cpu may vary largely.

Suppose we meet such two kind of cpus.
CPU A:
	No real time work, and there are 3 task, with rq->load.weight
being 512.
CPU B:
	Has real time work, and it take 3/4 of the cpu power, which
makes CFS only take 1/4, that is 1024/4=256 cpu power. And over its CFS
runqueue, there is only one task with weight as 128.

Since both cpu's CFS task take for half of the CFS's cpu power, it
should be considered as balanced in such case.

But original judgment like:
        if ((max_cpu_load - min_cpu_load) >= avg_load_per_task &&
            (max_nr_running - min_nr_running) > 1)
It makes (512-128)>=((512+128)/4), and lead to imbalance conclusion...

Make the load as scaled, to avoid such case.

Signed-off-by: Lei Wen <leiwen@marvell.com>
---
 kernel/sched/fair.c |   19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index fd9cbee..c478022 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4434,7 +4434,7 @@ static inline void update_sg_lb_stats(struct lb_env *env,
 			int local_group, int *balance, struct sg_lb_stats *sgs)
 {
 	unsigned long nr_running, max_nr_running, min_nr_running;
-	unsigned long load, max_cpu_load, min_cpu_load;
+	unsigned long scaled_load, load, max_cpu_load, min_cpu_load;
 	unsigned int balance_cpu = -1, first_idle_cpu = 0;
 	unsigned long avg_load_per_task = 0;
 	int i;
@@ -4464,10 +4464,12 @@ static inline void update_sg_lb_stats(struct lb_env *env,
 			load = target_load(i, load_idx);
 		} else {
 			load = source_load(i, load_idx);
-			if (load > max_cpu_load)
-				max_cpu_load = load;
-			if (min_cpu_load > load)
-				min_cpu_load = load;
+			scaled_load = load * SCHED_POWER_SCALE
+					/ cpu_rq(i)->cpu_power;
+			if (scaled_load	> max_cpu_load)
+				max_cpu_load = scaled_load;
+			if (min_cpu_load > scaled_load)
+				min_cpu_load = scaled_load;
 
 			if (nr_running > max_nr_running)
 				max_nr_running = nr_running;
@@ -4511,8 +4513,11 @@ static inline void update_sg_lb_stats(struct lb_env *env,
 	 *      normalized nr_running number somewhere that negates
 	 *      the hierarchy?
 	 */
-	if (sgs->sum_nr_running)
-		avg_load_per_task = sgs->sum_weighted_load / sgs->sum_nr_running;
+	if (sgs->sum_nr_running) {
+		avg_load_per_task = sgs->sum_weighted_load * SCHED_POWER_SCALE
+					/ group->sgp->power;
+		avg_load_per_task /= sgs->sum_nr_running;
+	}
 
 	if ((max_cpu_load - min_cpu_load) >= avg_load_per_task &&
 	    (max_nr_running - min_nr_running) > 1)
-- 
1.7.10.4

