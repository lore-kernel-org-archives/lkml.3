Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753107AbaEWPyS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 11:54:18 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:60245 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752856AbaEWPyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 11:54:13 -0400
From: Vincent Guittot <vincent.guittot@linaro.org>
To: peterz@infradead.org, mingo@kernel.org, linux-kernel@vger.kernel.org,
        linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org
Cc: preeti@linux.vnet.ibm.com, Morten.Rasmussen@arm.com, efault@gmx.de,
        nicolas.pitre@linaro.org, linaro-kernel@lists.linaro.org,
        daniel.lezcano@linaro.org,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: [PATCH v2 04/11] sched: Allow all archs to set the power_orig
Date: Fri, 23 May 2014 17:52:58 +0200
Message-Id: <1400860385-14555-5-git-send-email-vincent.guittot@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1400860385-14555-1-git-send-email-vincent.guittot@linaro.org>
References: <1400860385-14555-1-git-send-email-vincent.guittot@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

power_orig is only changed for system with a SMT sched_domain level in order to
reflect the lower capacity of CPUs. Heterogenous system also have to reflect an
original capacity that is different from the default value.

Create a more generic function arch_scale_cpu_power that can be also used by
non SMT platform to set power_orig.

The weak behavior of arch_scale_cpu_power is the previous SMT one in order to
keep backward compatibility in the use of power_orig.

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
---
 kernel/sched/fair.c | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 6a84114..6dc05f7 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5618,6 +5618,20 @@ unsigned long __weak arch_scale_smt_power(struct sched_domain *sd, int cpu)
 	return default_scale_smt_power(sd, cpu);
 }
 
+unsigned long __weak arch_scale_cpu_power(struct sched_domain *sd, int cpu)
+{
+	unsigned long weight = sd->span_weight;
+
+	if ((sd->flags & SD_SHARE_CPUPOWER) && weight > 1) {
+		if (sched_feat(ARCH_POWER))
+			return arch_scale_smt_power(sd, cpu);
+		else
+			return default_scale_smt_power(sd, cpu);
+	}
+
+	return SCHED_POWER_SCALE;
+}
+
 static unsigned long scale_rt_power(int cpu)
 {
 	struct rq *rq = cpu_rq(cpu);
@@ -5654,18 +5668,12 @@ static unsigned long scale_rt_power(int cpu)
 
 static void update_cpu_power(struct sched_domain *sd, int cpu)
 {
-	unsigned long weight = sd->span_weight;
 	unsigned long power = SCHED_POWER_SCALE;
 	struct sched_group *sdg = sd->groups;
 
-	if ((sd->flags & SD_SHARE_CPUPOWER) && weight > 1) {
-		if (sched_feat(ARCH_POWER))
-			power *= arch_scale_smt_power(sd, cpu);
-		else
-			power *= default_scale_smt_power(sd, cpu);
+	power *= arch_scale_cpu_power(sd, cpu);
 
-		power >>= SCHED_POWER_SHIFT;
-	}
+	power >>= SCHED_POWER_SHIFT;
 
 	sdg->sgp->power_orig = power;
 
-- 
1.9.1

