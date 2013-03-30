Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756929Ab3C3Okw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Mar 2013 10:40:52 -0400
Received: from mga14.intel.com ([143.182.124.37]:36513 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756143Ab3C3Of6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Mar 2013 10:35:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,378,1363158000"; 
   d="scan'208";a="220568239"
From: Alex Shi <alex.shi@intel.com>
To: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, bp@alien8.de,
        pjt@google.com, namhyung@kernel.org, efault@gmx.de
Cc: vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, alex.shi@intel.com
Subject: [patch v6 09/21] sched: scale_rt_power rename and meaning change
Date: Sat, 30 Mar 2013 22:34:56 +0800
Message-Id: <1364654108-16307-10-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1364654108-16307-1-git-send-email-alex.shi@intel.com>
References: <1364654108-16307-1-git-send-email-alex.shi@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The scale_rt_power() used to represent the left CPU utilization
after reduce rt utilization. so named it as scale_rt_power has a bit
inappropriate.

Since we need to use the rt utilization in some incoming patches, we
just change return value of this function to rt utilization, and
rename it as scale_rt_util(). Then, its usage is changed in
update_cpu_power() accordingly.

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 kernel/sched/fair.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 28bff43..ae87dab 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4277,10 +4277,10 @@ unsigned long __weak arch_scale_smt_power(struct sched_domain *sd, int cpu)
 	return default_scale_smt_power(sd, cpu);
 }
 
-unsigned long scale_rt_power(int cpu)
+unsigned long scale_rt_util(int cpu)
 {
 	struct rq *rq = cpu_rq(cpu);
-	u64 total, available, age_stamp, avg;
+	u64 total, age_stamp, avg;
 
 	/*
 	 * Since we're reading these variables without serialization make sure
@@ -4292,10 +4292,8 @@ unsigned long scale_rt_power(int cpu)
 	total = sched_avg_period() + (rq->clock - age_stamp);
 
 	if (unlikely(total < avg)) {
-		/* Ensures that power won't end up being negative */
-		available = 0;
-	} else {
-		available = total - avg;
+		/* Ensures rt utilization won't beyond full scaled value */
+		return SCHED_POWER_SCALE;
 	}
 
 	if (unlikely((s64)total < SCHED_POWER_SCALE))
@@ -4303,7 +4301,7 @@ unsigned long scale_rt_power(int cpu)
 
 	total >>= SCHED_POWER_SHIFT;
 
-	return div_u64(available, total);
+	return div_u64(avg, total);
 }
 
 static void update_cpu_power(struct sched_domain *sd, int cpu)
@@ -4330,7 +4328,7 @@ static void update_cpu_power(struct sched_domain *sd, int cpu)
 
 	power >>= SCHED_POWER_SHIFT;
 
-	power *= scale_rt_power(cpu);
+	power *= SCHED_POWER_SCALE - scale_rt_util(cpu);
 	power >>= SCHED_POWER_SHIFT;
 
 	if (!power)
-- 
1.7.12

