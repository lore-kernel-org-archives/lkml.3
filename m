Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932141AbaFPK1K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 06:27:10 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:45185 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932101AbaFPK1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 06:27:05 -0400
From: Chander Kashyap <k.chander@samsung.com>
To: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, daniel.lezcano@linaro.org,
        lorenzo.pieralisi@arm.com, rjw@rjwysocki.net, kgene.kim@samsung.com,
        tomasz.figa@gmail.com, Chander Kashyap <chander.kashyap@linaro.org>,
        Chander Kashyap <k.chander@samsung.com>
Subject: [Patch v7 6/6] mcpm: exynos: populate suspend and powered_up callbacks
Date: Mon, 16 Jun 2014 15:56:23 +0530
Message-Id: <1402914383-20471-7-git-send-email-k.chander@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1402914383-20471-1-git-send-email-k.chander@samsung.com>
References: <1402914383-20471-1-git-send-email-k.chander@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chander Kashyap <chander.kashyap@linaro.org>

In order to support cpuidle through mcpm, suspend and powered-up
callbacks are required in mcpm platform code.
Hence populate the same callbacks.

Signed-off-by: Chander Kashyap <chander.kashyap@linaro.org>
Signed-off-by: Chander Kashyap <k.chander@samsung.com>
Reviewed-by: Tomasz Figa <t.figa@samsung.com>
---
Changes in v6: None
Changes in v5:
	1. Add comment to address cache access while c-bit is cleared in SCLTR
	2. Make exynos_powered_up static
Changes in v4: None
Changes in v3:
	1. Removed coherency enablement after suspend failure.
	2. Use generic function to poweron cpu.
changes in v2:
	1. Fixed typo: enynos_pmu_cpunr to exynos_pmu_cpunr
 arch/arm/mach-exynos/mcpm-exynos.c |   36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/arch/arm/mach-exynos/mcpm-exynos.c b/arch/arm/mach-exynos/mcpm-exynos.c
index 0498d0b..fc47e68 100644
--- a/arch/arm/mach-exynos/mcpm-exynos.c
+++ b/arch/arm/mach-exynos/mcpm-exynos.c
@@ -258,10 +258,46 @@ static int exynos_wait_for_powerdown(unsigned int cpu, unsigned int cluster)
 	return -ETIMEDOUT; /* timeout */
 }
 
+static void exynos_powered_up(void)
+{
+	unsigned int mpidr, cpu, cluster;
+
+	mpidr = read_cpuid_mpidr();
+	cpu = MPIDR_AFFINITY_LEVEL(mpidr, 0);
+	cluster = MPIDR_AFFINITY_LEVEL(mpidr, 1);
+
+	arch_spin_lock(&exynos_mcpm_lock);
+	if (cpu_use_count[cpu][cluster] == 0)
+		cpu_use_count[cpu][cluster] = 1;
+	arch_spin_unlock(&exynos_mcpm_lock);
+}
+
+static void exynos_suspend(u64 residency)
+{
+	unsigned int mpidr, cpunr;
+
+	exynos_power_down();
+
+	/*
+	 * Execution reaches here only if cpu did not power down.
+	 * Hence roll back the changes done in exynos_power_down function.
+	 *
+	 * CAUTION: "This function requires the stack data to be visible through
+	 * power down and can only be executed on processors like A15 and A7
+	 * that hit the cache with the C bit clear in the SCTLR register."
+	*/
+	mpidr = read_cpuid_mpidr();
+	cpunr = exynos_pmu_cpunr(mpidr);
+
+	exynos_cpu_power_up(cpunr);
+}
+
 static const struct mcpm_platform_ops exynos_power_ops = {
 	.power_up		= exynos_power_up,
 	.power_down		= exynos_power_down,
 	.wait_for_powerdown	= exynos_wait_for_powerdown,
+	.suspend		= exynos_suspend,
+	.powered_up		= exynos_powered_up,
 };
 
 static void __init exynos_mcpm_usage_count_init(void)
-- 
1.7.9.5

