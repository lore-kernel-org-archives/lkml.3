Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756631AbaF3QJE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 12:09:04 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:36948 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755883AbaF3QG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 12:06:58 -0400
From: Vincent Guittot <vincent.guittot@linaro.org>
To: peterz@infradead.org, mingo@kernel.org, linux-kernel@vger.kernel.org,
        linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org
Cc: preeti@linux.vnet.ibm.com, Morten.Rasmussen@arm.com, efault@gmx.de,
        nicolas.pitre@linaro.org, linaro-kernel@lists.linaro.org,
        daniel.lezcano@linaro.org, dietmar.eggemann@arm.com,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: [PATCH v3 07/12] sched: test the cpu's capacity in wake affine
Date: Mon, 30 Jun 2014 18:05:38 +0200
Message-Id: <1404144343-18720-8-git-send-email-vincent.guittot@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404144343-18720-1-git-send-email-vincent.guittot@linaro.org>
References: <1404144343-18720-1-git-send-email-vincent.guittot@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the task always wakes affine on this_cpu if the latter is idle.
Before waking up the task on this_cpu, we check that this_cpu capacity is not
significantly reduced because of RT tasks or irq activity.

Use case where the number of irq and/or the time spent under irq is important
will take benefit of this because the task that is woken up by irq or softirq
will not use the same CPU than irq (and softirq) but a idle one which share
its cache.

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
---
 kernel/sched/fair.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 7dff578..a23c938 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4240,6 +4240,7 @@ static int wake_wide(struct task_struct *p)
 static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
 {
 	s64 this_load, load;
+	s64 this_eff_load, prev_eff_load;
 	int idx, this_cpu, prev_cpu;
 	struct task_group *tg;
 	unsigned long weight;
@@ -4283,21 +4284,23 @@ static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
 	 * Otherwise check if either cpus are near enough in load to allow this
 	 * task to be woken on this_cpu.
 	 */
-	if (this_load > 0) {
-		s64 this_eff_load, prev_eff_load;
+	this_eff_load = 100;
+	this_eff_load *= capacity_of(prev_cpu);
+
+	prev_eff_load = 100 + (sd->imbalance_pct - 100) / 2;
+	prev_eff_load *= capacity_of(this_cpu);
 
-		this_eff_load = 100;
-		this_eff_load *= capacity_of(prev_cpu);
+	if (this_load > 0) {
 		this_eff_load *= this_load +
 			effective_load(tg, this_cpu, weight, weight);
 
-		prev_eff_load = 100 + (sd->imbalance_pct - 100) / 2;
-		prev_eff_load *= capacity_of(this_cpu);
 		prev_eff_load *= load + effective_load(tg, prev_cpu, 0, weight);
+	} else if (!(sd->flags & SD_SHARE_PKG_RESOURCES)) {
+		this_eff_load = 0;
+	}
+
+	balanced = this_eff_load <= prev_eff_load;
 
-		balanced = this_eff_load <= prev_eff_load;
-	} else
-		balanced = true;
 	schedstat_inc(p, se.statistics.nr_wakeups_affine_attempts);
 
 	if (!balanced)
-- 
1.9.1

