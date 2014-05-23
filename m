Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753262AbaEWPyZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 11:54:25 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:46436 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753196AbaEWPyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 11:54:22 -0400
From: Vincent Guittot <vincent.guittot@linaro.org>
To: peterz@infradead.org, mingo@kernel.org, linux-kernel@vger.kernel.org,
        linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org
Cc: preeti@linux.vnet.ibm.com, Morten.Rasmussen@arm.com, efault@gmx.de,
        nicolas.pitre@linaro.org, linaro-kernel@lists.linaro.org,
        daniel.lezcano@linaro.org,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: [PATCH v2 09/11] sched: test the cpu's capacity in wake affine
Date: Fri, 23 May 2014 17:53:03 +0200
Message-Id: <1400860385-14555-10-git-send-email-vincent.guittot@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1400860385-14555-1-git-send-email-vincent.guittot@linaro.org>
References: <1400860385-14555-1-git-send-email-vincent.guittot@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the task always wakes affine on this_cpu if the latter is idle.
Before waking up the task on this_cpu, we check that this_cpu capacity is not
significantly reduced because of RT tasks or irq activity.

Use case where the number of irq and the time spent under irq is important
will take benefit of this because the task that is woken up by irq or softirq
will not use the same CPU than irq (and softirq) but a idle one which share
its LLC.

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
---
 kernel/sched/fair.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index c01d8b6..e8a30f9 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4241,6 +4241,7 @@ static int wake_wide(struct task_struct *p)
 static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
 {
 	s64 this_load, load;
+	s64 this_eff_load, prev_eff_load;
 	int idx, this_cpu, prev_cpu;
 	struct task_group *tg;
 	unsigned long weight;
@@ -4284,21 +4285,21 @@ static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
 	 * Otherwise check if either cpus are near enough in load to allow this
 	 * task to be woken on this_cpu.
 	 */
-	if (this_load > 0) {
-		s64 this_eff_load, prev_eff_load;
+	this_eff_load = 100;
+	this_eff_load *= power_of(prev_cpu);
+
+	prev_eff_load = 100 + (sd->imbalance_pct - 100) / 2;
+	prev_eff_load *= power_of(this_cpu);
 
-		this_eff_load = 100;
-		this_eff_load *= power_of(prev_cpu);
+	if (this_load > 0) {
 		this_eff_load *= this_load +
 			effective_load(tg, this_cpu, weight, weight);
 
-		prev_eff_load = 100 + (sd->imbalance_pct - 100) / 2;
-		prev_eff_load *= power_of(this_cpu);
 		prev_eff_load *= load + effective_load(tg, prev_cpu, 0, weight);
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

