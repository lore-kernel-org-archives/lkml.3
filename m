Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751808AbaG1RxE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 13:53:04 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:51860 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751412AbaG1Rwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 13:52:47 -0400
From: Vincent Guittot <vincent.guittot@linaro.org>
To: peterz@infradead.org, mingo@kernel.org, linux-kernel@vger.kernel.org,
        preeti@linux.vnet.ibm.com, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org
Cc: riel@redhat.com, Morten.Rasmussen@arm.com, efault@gmx.de,
        nicolas.pitre@linaro.org, linaro-kernel@lists.linaro.org,
        daniel.lezcano@linaro.org, dietmar.eggemann@arm.com,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: [PATCH v4 04/12] sched: Allow all archs to set the capacity_orig
Date: Mon, 28 Jul 2014 19:51:38 +0200
Message-Id: <1406569906-9763-5-git-send-email-vincent.guittot@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406569906-9763-1-git-send-email-vincent.guittot@linaro.org>
References: <1406569906-9763-1-git-send-email-vincent.guittot@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

capacity_orig is only changed for system with a SMT sched_domain level in order
to reflect the lower capacity of CPUs. Heterogenous system also have to reflect an
original capacity that is different from the default value.

Create a more generic function arch_scale_cpu_capacity that can be also used by
non SMT platform to set capacity_orig.

The weak behavior of arch_scale_cpu_capacity is the previous SMT one in order to
keep backward compatibility in the use of capacity_orig.

arch_scale_smt_capacity and default_scale_smt_capacity have been removed as
they were not use elsewhere than in arch_scale_cpu_capacity.

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
---
 kernel/sched/fair.c | 25 ++++++-------------------
 1 file changed, 6 insertions(+), 19 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 647d0a6..00ff5f3 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5642,19 +5642,12 @@ unsigned long __weak arch_scale_freq_capacity(struct sched_domain *sd, int cpu)
 	return default_scale_capacity(sd, cpu);
 }
 
-static unsigned long default_scale_smt_capacity(struct sched_domain *sd, int cpu)
+unsigned long __weak arch_scale_cpu_capacity(struct sched_domain *sd, int cpu)
 {
-	unsigned long weight = sd->span_weight;
-	unsigned long smt_gain = sd->smt_gain;
+	if ((sd->flags & SD_SHARE_CPUCAPACITY) && (sd->span_weight > 1))
+		return sd->smt_gain / sd->span_weight;
 
-	smt_gain /= weight;
-
-	return smt_gain;
-}
-
-unsigned long __weak arch_scale_smt_capacity(struct sched_domain *sd, int cpu)
-{
-	return default_scale_smt_capacity(sd, cpu);
+	return SCHED_CAPACITY_SCALE;
 }
 
 static unsigned long scale_rt_capacity(int cpu)
@@ -5693,18 +5686,12 @@ static unsigned long scale_rt_capacity(int cpu)
 
 static void update_cpu_capacity(struct sched_domain *sd, int cpu)
 {
-	unsigned long weight = sd->span_weight;
 	unsigned long capacity = SCHED_CAPACITY_SCALE;
 	struct sched_group *sdg = sd->groups;
 
-	if ((sd->flags & SD_SHARE_CPUCAPACITY) && weight > 1) {
-		if (sched_feat(ARCH_CAPACITY))
-			capacity *= arch_scale_smt_capacity(sd, cpu);
-		else
-			capacity *= default_scale_smt_capacity(sd, cpu);
+	capacity *= arch_scale_cpu_capacity(sd, cpu);
 
-		capacity >>= SCHED_CAPACITY_SHIFT;
-	}
+	capacity >>= SCHED_CAPACITY_SHIFT;
 
 	sdg->sgc->capacity_orig = capacity;
 
-- 
1.9.1

