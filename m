Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755952AbaDWJ0f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 05:26:35 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:55293 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755748AbaDWJ02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 05:26:28 -0400
From: Chander Kashyap <chander.kashyap@linaro.org>
To: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: lorenzo.pieralisi@arm.com, daniel.lezcano@linaro.org, rjw@rjwysocki.net,
        kgene.kim@samsung.com, Chander Kashyap <chander.kashyap@linaro.org>,
        Chander Kashyap <k.chander@samsung.com>
Subject: [Patch v2 4/4] mcpm: exynos: populate suspend and powered_up callbacks
Date: Wed, 23 Apr 2014 14:55:54 +0530
Message-Id: <1398245154-18771-5-git-send-email-chander.kashyap@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1398245154-18771-1-git-send-email-chander.kashyap@linaro.org>
References: <1398080958-21677-5-git-send-email-chander.kashyap@linaro.org>
 <1398245154-18771-1-git-send-email-chander.kashyap@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to support cpuidle through mcpm, suspend and powered-up
callbacks are required in mcpm platform code.
Hence populate the same callbacks.

Signed-off-by: Chander Kashyap <chander.kashyap@linaro.org>
Signed-off-by: Chander Kashyap <k.chander@samsung.com>
---
changes in v2:
	1. Fixed typo: enynos_pmu_cpunr to exynos_pmu_cpunr

 arch/arm/mach-exynos/mcpm-exynos.c |   53 ++++++++++++++++++++++++++++++++++++
 1 file changed, 53 insertions(+)

diff --git a/arch/arm/mach-exynos/mcpm-exynos.c b/arch/arm/mach-exynos/mcpm-exynos.c
index 6c74c82..d53f597 100644
--- a/arch/arm/mach-exynos/mcpm-exynos.c
+++ b/arch/arm/mach-exynos/mcpm-exynos.c
@@ -272,10 +272,63 @@ static int exynos_power_down_finish(unsigned int cpu, unsigned int cluster)
 	return 0; /* success: the CPU is halted */
 }
 
+static void enable_coherency(void)
+{
+	unsigned long v, u;
+
+	asm volatile(
+		"mrc	p15, 0, %0, c1, c0, 1\n"
+		"orr	%0, %0, %2\n"
+		"ldr	%1, [%3]\n"
+		"and	%1, %1, #0\n"
+		"orr	%0, %0, %1\n"
+		"mcr	p15, 0, %0, c1, c0, 1\n"
+		: "=&r" (v), "=&r" (u)
+		: "Ir" (0x40), "Ir" (S5P_INFORM0)
+		: "cc");
+}
+
+void exynos_powered_up(void)
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
+	mpidr = read_cpuid_mpidr();
+	cpunr = exynos_pmu_cpunr(mpidr);
+
+	__raw_writel(virt_to_phys(mcpm_entry_point), REG_ENTRY_ADDR);
+
+	exynos_power_down();
+
+	/*
+	 * Execution reaches here only if cpu did not power down.
+	 * Hence roll back the changes done in exynos_power_down function.
+	*/
+	__raw_writel(EXYNOS_CORE_LOCAL_PWR_EN,
+			EXYNOS_ARM_CORE_CONFIGURATION(cpunr));
+	set_cr(get_cr() | CR_C);
+	enable_coherency();
+}
+
 static const struct mcpm_platform_ops exynos_power_ops = {
 	.power_up		= exynos_power_up,
 	.power_down		= exynos_power_down,
 	.power_down_finish	= exynos_power_down_finish,
+	.suspend		= exynos_suspend,
+	.powered_up		= exynos_powered_up,
 };
 
 static void __init exynos_mcpm_usage_count_init(void)
-- 
1.7.9.5

