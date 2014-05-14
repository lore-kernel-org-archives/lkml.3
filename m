Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753345AbaENIEt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 04:04:49 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:45054 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752251AbaENIEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 04:04:43 -0400
From: Chander Kashyap <chander.kashyap@linaro.org>
To: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: daniel.lezcano@linaro.org, lorenzo.pieralisi@arm.com, rjw@rjwysocki.net,
        kgene.kim@samsung.com, Chander Kashyap <chander.kashyap@linaro.org>,
        Chander Kashyap <k.chander@samsung.com>
Subject: [PATCH v5 6/6] mcpm: exynos: populate suspend and powered_up callbacks
Date: Wed, 14 May 2014 13:33:57 +0530
Message-Id: <1400054637-21505-7-git-send-email-chander.kashyap@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1400054637-21505-1-git-send-email-chander.kashyap@linaro.org>
References: <ANuQgHGSPJ45tbrVppAVpOqF0OfHacPWfX=S5mOVxTPr66f7vg@mail.gmail.com>
 <1400054637-21505-1-git-send-email-chander.kashyap@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to support cpuidle through mcpm, suspend and powered-up
callbacks are required in mcpm platform code.
Hence populate the same callbacks.

Signed-off-by: Chander Kashyap <chander.kashyap@linaro.org>
Signed-off-by: Chander Kashyap <k.chander@samsung.com>
---
Changes in v5:
	1. Add comment to address cache access while c-bit is cleared in SCLTR
	2. Make exynos_powered_up static
Changes in v4: None
Changes in v3:
	1. Removed coherency enablement after suspend failure.
	2. Use generic function to poweron cpu.
changes in v2:
	1. Fixed typo: enynos_pmu_cpunr to exynos_pmu_cpunr
 arch/arm/mach-exynos/mcpm-exynos.c |   34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/arch/arm/mach-exynos/mcpm-exynos.c b/arch/arm/mach-exynos/mcpm-exynos.c
index c6bb3a4..623dfa7 100644
--- a/arch/arm/mach-exynos/mcpm-exynos.c
+++ b/arch/arm/mach-exynos/mcpm-exynos.c
@@ -253,10 +253,46 @@ static int exynos_power_down_finish(unsigned int cpu, unsigned int cluster)
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
 	.power_down_finish	= exynos_power_down_finish,
+	.suspend		= exynos_suspend,
+	.powered_up		= exynos_powered_up,
 };
 
 static void __init exynos_mcpm_usage_count_init(void)
-- 
1.7.9.5

