Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752356AbbASQxb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 11:53:31 -0500
Received: from mail-wg0-f45.google.com ([74.125.82.45]:35794 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752135AbbASQxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 11:53:11 -0500
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: arnd@arndb.de, olof@lixom.net, linux@arm.linux.org.uk
Cc: thomas.petazzoni@free-electrons.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] ARM: Factor out the smp_init_cpus function
Date: Mon, 19 Jan 2015 17:53:01 +0100
Message-Id: <1421686381-12397-3-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1421686381-12397-1-git-send-email-daniel.lezcano@linaro.org>
References: <1421686381-12397-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The set_cpu_possible loop and the ncores clipping is duplicated again and
again across the different platforms.

As the smp_init_cpus is returning the number of cores, use this information
to do the same thing than what does the duplicate code in the different
platforms.

Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 arch/arm/kernel/smp.c            | 16 ++++++++++++++--
 arch/arm/mach-exynos/platsmp.c   | 15 +--------------
 arch/arm/mach-omap2/omap-smp.c   | 10 ----------
 arch/arm/mach-realview/platsmp.c | 15 +--------------
 arch/arm/mach-socfpga/platsmp.c  | 19 +------------------
 arch/arm/mach-spear/platsmp.c    | 13 +------------
 arch/arm/mach-ux500/platsmp.c    | 15 +--------------
 arch/arm/mach-zynq/platsmp.c     |  9 +--------
 8 files changed, 20 insertions(+), 92 deletions(-)

diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
index 86ef244..ecf2993 100644
--- a/arch/arm/kernel/smp.c
+++ b/arch/arm/kernel/smp.c
@@ -141,8 +141,20 @@ int __cpu_up(unsigned int cpu, struct task_struct *idle)
 /* platform specific SMP operations */
 void __init smp_init_cpus(void)
 {
-	if (smp_ops.smp_init_cpus)
-		smp_ops.smp_init_cpus();
+	int i, ncores;
+
+	if (!smp_ops.smp_init_cpus)
+		return;
+
+	ncores = smp_ops.smp_init_cpus();
+	if (ncores > nr_cpu_ids) {
+		pr_warn("SMP: %u cores greater than maximum (%u), clipping\n",
+			ncores, nr_cpu_ids);
+		ncores = nr_cpu_ids;
+	}
+
+	for (i = 0; i < ncores; i++)
+		set_cpu_possible(i, true);
 }
 
 int platform_can_cpu_hotplug(void)
diff --git a/arch/arm/mach-exynos/platsmp.c b/arch/arm/mach-exynos/platsmp.c
index 686f42a..406cc8b 100644
--- a/arch/arm/mach-exynos/platsmp.c
+++ b/arch/arm/mach-exynos/platsmp.c
@@ -376,28 +376,15 @@ fail:
 static int __init exynos_smp_init_cpus(void)
 {
 	void __iomem *scu_base = scu_base_addr();
-	unsigned int i, ncores;
 
 	if (read_cpuid_part() == ARM_CPU_PART_CORTEX_A9)
-		ncores = scu_base ? scu_get_core_count(scu_base) : 1;
+		return scu_base ? scu_get_core_count(scu_base) : 1;
 	else
 		/*
 		 * CPU Nodes are passed thru DT and set_cpu_possible
 		 * is set by "arm_dt_init_cpu_maps".
 		 */
 		return 0;
-
-	/* sanity check */
-	if (ncores > nr_cpu_ids) {
-		pr_warn("SMP: %u cores greater than maximum (%u), clipping\n",
-			ncores, nr_cpu_ids);
-		ncores = nr_cpu_ids;
-	}
-
-	for (i = 0; i < ncores; i++)
-		set_cpu_possible(i, true);
-
-	return ncores;
 }
 
 static void __init exynos_smp_prepare_cpus(unsigned int max_cpus)
diff --git a/arch/arm/mach-omap2/omap-smp.c b/arch/arm/mach-omap2/omap-smp.c
index 4d31fea..2fa48bd 100644
--- a/arch/arm/mach-omap2/omap-smp.c
+++ b/arch/arm/mach-omap2/omap-smp.c
@@ -193,16 +193,6 @@ static int __init omap4_smp_init_cpus(void)
 		ncores = OMAP5_CORE_COUNT;
 	}
 
-	/* sanity check */
-	if (ncores > nr_cpu_ids) {
-		pr_warn("SMP: %u cores greater than maximum (%u), clipping\n",
-			ncores, nr_cpu_ids);
-		ncores = nr_cpu_ids;
-	}
-
-	for (i = 0; i < ncores; i++)
-		set_cpu_possible(i, true);
-
 	return ncores;
 }
 
diff --git a/arch/arm/mach-realview/platsmp.c b/arch/arm/mach-realview/platsmp.c
index 0612f2d..eb9885f 100644
--- a/arch/arm/mach-realview/platsmp.c
+++ b/arch/arm/mach-realview/platsmp.c
@@ -45,21 +45,8 @@ static void __iomem *scu_base_addr(void)
 static int __init realview_smp_init_cpus(void)
 {
 	void __iomem *scu_base = scu_base_addr();
-	unsigned int i, ncores;
 
-	ncores = scu_base ? scu_get_core_count(scu_base) : 1;
-
-	/* sanity check */
-	if (ncores > nr_cpu_ids) {
-		pr_warn("SMP: %u cores greater than maximum (%u), clipping\n",
-			ncores, nr_cpu_ids);
-		ncores = nr_cpu_ids;
-	}
-
-	for (i = 0; i < ncores; i++)
-		set_cpu_possible(i, true);
-
-	return ncores;
+	return scu_base ? scu_get_core_count(scu_base) : 1;
 }
 
 static void __init realview_smp_prepare_cpus(unsigned int max_cpus)
diff --git a/arch/arm/mach-socfpga/platsmp.c b/arch/arm/mach-socfpga/platsmp.c
index 45d4d87..de14efc 100644
--- a/arch/arm/mach-socfpga/platsmp.c
+++ b/arch/arm/mach-socfpga/platsmp.c
@@ -60,24 +60,7 @@ static int socfpga_boot_secondary(unsigned int cpu, struct task_struct *idle)
  */
 static int __init socfpga_smp_init_cpus(void)
 {
-	unsigned int i, ncores;
-
-	ncores = scu_get_core_count(socfpga_scu_base_addr);
-
-	for (i = 0; i < ncores; i++)
-		set_cpu_possible(i, true);
-
-	/* sanity check */
-	if (ncores > num_possible_cpus()) {
-		pr_warn("socfpga: no. of cores (%d) greater than configured"
-			"maximum of %d - clipping\n", ncores, num_possible_cpus());
-		ncores = num_possible_cpus();
-	}
-
-	for (i = 0; i < ncores; i++)
-		set_cpu_possible(i, true);
-
-	return ncores;
+	return scu_get_core_count(socfpga_scu_base_addr);
 }
 
 static void __init socfpga_smp_prepare_cpus(unsigned int max_cpus)
diff --git a/arch/arm/mach-spear/platsmp.c b/arch/arm/mach-spear/platsmp.c
index a6ef1ad..da4b4ac 100644
--- a/arch/arm/mach-spear/platsmp.c
+++ b/arch/arm/mach-spear/platsmp.c
@@ -95,18 +95,7 @@ static int spear13xx_boot_secondary(unsigned int cpu, struct task_struct *idle)
  */
 static int __init spear13xx_smp_init_cpus(void)
 {
-	unsigned int i, ncores = scu_get_core_count(scu_base);
-
-	if (ncores > nr_cpu_ids) {
-		pr_warn("SMP: %u cores greater than maximum (%u), clipping\n",
-			ncores, nr_cpu_ids);
-		ncores = nr_cpu_ids;
-	}
-
-	for (i = 0; i < ncores; i++)
-		set_cpu_possible(i, true);
-
-	return ncores;
+	return scu_get_core_count(scu_base);
 }
 
 static void __init spear13xx_smp_prepare_cpus(unsigned int max_cpus)
diff --git a/arch/arm/mach-ux500/platsmp.c b/arch/arm/mach-ux500/platsmp.c
index c8d8d4c..74485bc 100644
--- a/arch/arm/mach-ux500/platsmp.c
+++ b/arch/arm/mach-ux500/platsmp.c
@@ -136,21 +136,8 @@ static void __init wakeup_secondary(void)
 static int __init ux500_smp_init_cpus(void)
 {
 	void __iomem *scu_base = scu_base_addr();
-	unsigned int i, ncores;
 
-	ncores = scu_base ? scu_get_core_count(scu_base) : 1;
-
-	/* sanity check */
-	if (ncores > nr_cpu_ids) {
-		pr_warn("SMP: %u cores greater than maximum (%u), clipping\n",
-			ncores, nr_cpu_ids);
-		ncores = nr_cpu_ids;
-	}
-
-	for (i = 0; i < ncores; i++)
-		set_cpu_possible(i, true);
-
-	return ncores;
+	return scu_base ? scu_get_core_count(scu_base) : 1;
 }
 
 static void __init ux500_smp_prepare_cpus(unsigned int max_cpus)
diff --git a/arch/arm/mach-zynq/platsmp.c b/arch/arm/mach-zynq/platsmp.c
index 1ab85e7..6b9e101 100644
--- a/arch/arm/mach-zynq/platsmp.c
+++ b/arch/arm/mach-zynq/platsmp.c
@@ -99,14 +99,7 @@ static int zynq_boot_secondary(unsigned int cpu,
  */
 static int __init zynq_smp_init_cpus(void)
 {
-	int i;
-
-	ncores = scu_get_core_count(zynq_scu_base);
-
-	for (i = 0; i < ncores && i < CONFIG_NR_CPUS; i++)
-		set_cpu_possible(i, true);
-
-	return ncores;
+	return scu_get_core_count(zynq_scu_base);
 }
 
 static void __init zynq_smp_prepare_cpus(unsigned int max_cpus)
-- 
1.9.1

