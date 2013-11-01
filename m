Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756689Ab3KAWJU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 18:09:20 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:48592 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756558Ab3KAWJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 18:09:05 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: linux-arm-kernel@lists.infradead.org
Cc: David Brown <davidb@codeaurora.org>,
        Rohit Vaswani <rvaswani@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: [PATCH 11/11] ARM: msm: Remove nr_cpus detection logic
Date: Fri,  1 Nov 2013 15:08:59 -0700
Message-Id: <1383343739-23080-12-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.4.2.564.g0d6cf24
In-Reply-To: <1383343739-23080-1-git-send-email-sboyd@codeaurora.org>
References: <1383343739-23080-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All the SMP supported MSM devices are using devicetree and they
have a cpus node in DT. Given this we know that arm generic code
detects the number of cpus from the cpus node so we can drop
support for detecting the number of CPUs from the mpidr register
here.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/mach-msm/platsmp.c | 27 ---------------------------
 1 file changed, 27 deletions(-)

diff --git a/arch/arm/mach-msm/platsmp.c b/arch/arm/mach-msm/platsmp.c
index 87e4fdc..36b2294 100644
--- a/arch/arm/mach-msm/platsmp.c
+++ b/arch/arm/mach-msm/platsmp.c
@@ -41,12 +41,6 @@ extern void secondary_startup(void);
 
 static DEFINE_SPINLOCK(boot_lock);
 
-static inline int get_core_count(void)
-{
-	/* 1 + the PART[1:0] field of MIDR */
-	return ((read_cpuid_id() >> 4) & 3) + 1;
-}
-
 static void msm_secondary_init(unsigned int cpu)
 {
 	/*
@@ -268,26 +262,6 @@ static int msm_boot_secondary(unsigned int cpu, struct task_struct *idle)
 	return 0;
 }
 
-/*
- * Initialise the CPU possible map early - this describes the CPUs
- * which may be present or become present in the system. The msm8x60
- * does not support the ARM SCU, so just set the possible cpu mask to
- * NR_CPUS.
- */
-static void __init msm_smp_init_cpus(void)
-{
-	unsigned int i, ncores = get_core_count();
-
-	if (ncores > nr_cpu_ids) {
-		pr_warn("SMP: %u cores greater than maximum (%u), clipping\n",
-			ncores, nr_cpu_ids);
-		ncores = nr_cpu_ids;
-	}
-
-	for (i = 0; i < ncores; i++)
-		set_cpu_possible(i, true);
-}
-
 static void __init msm_smp_prepare_cpus(unsigned int max_cpus)
 {
 	int cpu, map;
@@ -319,7 +293,6 @@ static void __init msm_smp_prepare_cpus(unsigned int max_cpus)
 }
 
 struct smp_operations msm_smp_ops __initdata = {
-	.smp_init_cpus		= msm_smp_init_cpus,
 	.smp_prepare_cpus	= msm_smp_prepare_cpus,
 	.smp_secondary_init	= msm_secondary_init,
 	.smp_boot_secondary	= msm_boot_secondary,
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

