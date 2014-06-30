Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755529AbaF3QKo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 12:10:44 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:58326 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755947AbaF3QGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 12:06:48 -0400
From: Vincent Guittot <vincent.guittot@linaro.org>
To: peterz@infradead.org, mingo@kernel.org, linux-kernel@vger.kernel.org,
        linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org
Cc: preeti@linux.vnet.ibm.com, Morten.Rasmussen@arm.com, efault@gmx.de,
        nicolas.pitre@linaro.org, linaro-kernel@lists.linaro.org,
        daniel.lezcano@linaro.org, dietmar.eggemann@arm.com,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: [PATCH v3 02/12] sched: remove a wake_affine condition
Date: Mon, 30 Jun 2014 18:05:33 +0200
Message-Id: <1404144343-18720-3-git-send-email-vincent.guittot@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404144343-18720-1-git-send-email-vincent.guittot@linaro.org>
References: <1404144343-18720-1-git-send-email-vincent.guittot@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have tried to understand the meaning of the condition :
 (this_load <= load &&
  this_load + target_load(prev_cpu, idx) <= tl_per_task)
but i failed to find a use case that can take advantage of it and i haven't
found clear description in the previous commits' log.
Futhermore, the comment of the condition refers to the task_hot function that
was used before being replaced by the current condition:
/*
 * This domain has SD_WAKE_AFFINE and
 * p is cache cold in this domain, and
 * there is no bad imbalance.
 */

If we look more deeply the below condition
 this_load + target_load(prev_cpu, idx) <= tl_per_task

When sync is clear, we have :
 tl_per_task = runnable_load_avg / nr_running
 this_load = max(runnable_load_avg, cpuload[idx])
 target_load =  max(runnable_load_avg', cpuload'[idx])

It implies that runnable_load_avg' == 0 and nr_running <= 1 in order to match the
condition. This implies that runnable_load_avg == 0 too because of the
condition: this_load <= load
but if this _load is null, balanced is already set and the test is redundant.

If sync is set, it's not as straight forward as above (especially if cgroup
are involved) but the policy should be similar as we have removed a task that's
going to sleep in order to get a more accurate load and this_load values.

The current conclusion is that these additional condition don't give any benefit
so we can remove them.

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
---
 kernel/sched/fair.c | 30 ++++++------------------------
 1 file changed, 6 insertions(+), 24 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 0c48dff..c6dba48 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4241,7 +4241,6 @@ static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
 {
 	s64 this_load, load;
 	int idx, this_cpu, prev_cpu;
-	unsigned long tl_per_task;
 	struct task_group *tg;
 	unsigned long weight;
 	int balanced;
@@ -4299,32 +4298,15 @@ static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
 		balanced = this_eff_load <= prev_eff_load;
 	} else
 		balanced = true;
-
-	/*
-	 * If the currently running task will sleep within
-	 * a reasonable amount of time then attract this newly
-	 * woken task:
-	 */
-	if (sync && balanced)
-		return 1;
-
 	schedstat_inc(p, se.statistics.nr_wakeups_affine_attempts);
-	tl_per_task = cpu_avg_load_per_task(this_cpu);
 
-	if (balanced ||
-	    (this_load <= load &&
-	     this_load + target_load(prev_cpu, idx) <= tl_per_task)) {
-		/*
-		 * This domain has SD_WAKE_AFFINE and
-		 * p is cache cold in this domain, and
-		 * there is no bad imbalance.
-		 */
-		schedstat_inc(sd, ttwu_move_affine);
-		schedstat_inc(p, se.statistics.nr_wakeups_affine);
+	if (!balanced)
+		return 0;
 
-		return 1;
-	}
-	return 0;
+	schedstat_inc(sd, ttwu_move_affine);
+	schedstat_inc(p, se.statistics.nr_wakeups_affine);
+
+	return 1;
 }
 
 /*
-- 
1.9.1

