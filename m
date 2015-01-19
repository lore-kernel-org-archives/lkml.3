Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752200AbbASQxO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 11:53:14 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:61783 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751474AbbASQxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 11:53:10 -0500
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: arnd@arndb.de, olof@lixom.net, linux@arm.linux.org.uk
Cc: thomas.petazzoni@free-electrons.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] ARM: Make smp_init_cpus to return the number of cores
Date: Mon, 19 Jan 2015 17:53:00 +0100
Message-Id: <1421686381-12397-2-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1421686381-12397-1-git-send-email-daniel.lezcano@linaro.org>
References: <1421686381-12397-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Return the number of cores the platform has.

Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 arch/arm/include/asm/smp.h       | 2 +-
 arch/arm/mach-exynos/platsmp.c   | 6 ++++--
 arch/arm/mach-imx/platsmp.c      | 4 +++-
 arch/arm/mach-omap2/omap-smp.c   | 4 +++-
 arch/arm/mach-realview/platsmp.c | 4 +++-
 arch/arm/mach-socfpga/platsmp.c  | 4 +++-
 arch/arm/mach-spear/platsmp.c    | 4 +++-
 arch/arm/mach-ux500/platsmp.c    | 4 +++-
 arch/arm/mach-zynq/platsmp.c     | 4 +++-
 9 files changed, 26 insertions(+), 10 deletions(-)

diff --git a/arch/arm/include/asm/smp.h b/arch/arm/include/asm/smp.h
index 18f5a55..5ce30ee 100644
--- a/arch/arm/include/asm/smp.h
+++ b/arch/arm/include/asm/smp.h
@@ -86,7 +86,7 @@ struct smp_operations {
 	/*
 	 * Setup the set of possible CPUs (via set_cpu_possible)
 	 */
-	void (*smp_init_cpus)(void);
+	int (*smp_init_cpus)(void);
 	/*
 	 * Initialize cpu_possible map, and enable coherency
 	 */
diff --git a/arch/arm/mach-exynos/platsmp.c b/arch/arm/mach-exynos/platsmp.c
index 7a1ebfe..686f42a 100644
--- a/arch/arm/mach-exynos/platsmp.c
+++ b/arch/arm/mach-exynos/platsmp.c
@@ -373,7 +373,7 @@ fail:
  * which may be present or become present in the system.
  */
 
-static void __init exynos_smp_init_cpus(void)
+static int __init exynos_smp_init_cpus(void)
 {
 	void __iomem *scu_base = scu_base_addr();
 	unsigned int i, ncores;
@@ -385,7 +385,7 @@ static void __init exynos_smp_init_cpus(void)
 		 * CPU Nodes are passed thru DT and set_cpu_possible
 		 * is set by "arm_dt_init_cpu_maps".
 		 */
-		return;
+		return 0;
 
 	/* sanity check */
 	if (ncores > nr_cpu_ids) {
@@ -396,6 +396,8 @@ static void __init exynos_smp_init_cpus(void)
 
 	for (i = 0; i < ncores; i++)
 		set_cpu_possible(i, true);
+
+	return ncores;
 }
 
 static void __init exynos_smp_prepare_cpus(unsigned int max_cpus)
diff --git a/arch/arm/mach-imx/platsmp.c b/arch/arm/mach-imx/platsmp.c
index 7f27001..70f0928 100644
--- a/arch/arm/mach-imx/platsmp.c
+++ b/arch/arm/mach-imx/platsmp.c
@@ -57,7 +57,7 @@ static int imx_boot_secondary(unsigned int cpu, struct task_struct *idle)
  * Initialise the CPU possible map early - this describes the CPUs
  * which may be present or become present in the system.
  */
-static void __init imx_smp_init_cpus(void)
+static int __init imx_smp_init_cpus(void)
 {
 	int i, ncores;
 
@@ -65,6 +65,8 @@ static void __init imx_smp_init_cpus(void)
 
 	for (i = ncores; i < NR_CPUS; i++)
 		set_cpu_possible(i, false);
+
+	return ncores;
 }
 
 void imx_smp_prepare(void)
diff --git a/arch/arm/mach-omap2/omap-smp.c b/arch/arm/mach-omap2/omap-smp.c
index 5305ec7..4d31fea 100644
--- a/arch/arm/mach-omap2/omap-smp.c
+++ b/arch/arm/mach-omap2/omap-smp.c
@@ -175,7 +175,7 @@ static int omap4_boot_secondary(unsigned int cpu, struct task_struct *idle)
  * Initialise the CPU possible map early - this describes the CPUs
  * which may be present or become present in the system.
  */
-static void __init omap4_smp_init_cpus(void)
+static int __init omap4_smp_init_cpus(void)
 {
 	unsigned int i = 0, ncores = 1, cpu_id;
 
@@ -202,6 +202,8 @@ static void __init omap4_smp_init_cpus(void)
 
 	for (i = 0; i < ncores; i++)
 		set_cpu_possible(i, true);
+
+	return ncores;
 }
 
 static void __init omap4_smp_prepare_cpus(unsigned int max_cpus)
diff --git a/arch/arm/mach-realview/platsmp.c b/arch/arm/mach-realview/platsmp.c
index 98e3052..0612f2d 100644
--- a/arch/arm/mach-realview/platsmp.c
+++ b/arch/arm/mach-realview/platsmp.c
@@ -42,7 +42,7 @@ static void __iomem *scu_base_addr(void)
  * Initialise the CPU possible map early - this describes the CPUs
  * which may be present or become present in the system.
  */
-static void __init realview_smp_init_cpus(void)
+static int __init realview_smp_init_cpus(void)
 {
 	void __iomem *scu_base = scu_base_addr();
 	unsigned int i, ncores;
@@ -58,6 +58,8 @@ static void __init realview_smp_init_cpus(void)
 
 	for (i = 0; i < ncores; i++)
 		set_cpu_possible(i, true);
+
+	return ncores;
 }
 
 static void __init realview_smp_prepare_cpus(unsigned int max_cpus)
diff --git a/arch/arm/mach-socfpga/platsmp.c b/arch/arm/mach-socfpga/platsmp.c
index c64d89b..45d4d87 100644
--- a/arch/arm/mach-socfpga/platsmp.c
+++ b/arch/arm/mach-socfpga/platsmp.c
@@ -58,7 +58,7 @@ static int socfpga_boot_secondary(unsigned int cpu, struct task_struct *idle)
  * Initialise the CPU possible map early - this describes the CPUs
  * which may be present or become present in the system.
  */
-static void __init socfpga_smp_init_cpus(void)
+static int __init socfpga_smp_init_cpus(void)
 {
 	unsigned int i, ncores;
 
@@ -76,6 +76,8 @@ static void __init socfpga_smp_init_cpus(void)
 
 	for (i = 0; i < ncores; i++)
 		set_cpu_possible(i, true);
+
+	return ncores;
 }
 
 static void __init socfpga_smp_prepare_cpus(unsigned int max_cpus)
diff --git a/arch/arm/mach-spear/platsmp.c b/arch/arm/mach-spear/platsmp.c
index fd42977..a6ef1ad 100644
--- a/arch/arm/mach-spear/platsmp.c
+++ b/arch/arm/mach-spear/platsmp.c
@@ -93,7 +93,7 @@ static int spear13xx_boot_secondary(unsigned int cpu, struct task_struct *idle)
  * Initialise the CPU possible map early - this describes the CPUs
  * which may be present or become present in the system.
  */
-static void __init spear13xx_smp_init_cpus(void)
+static int __init spear13xx_smp_init_cpus(void)
 {
 	unsigned int i, ncores = scu_get_core_count(scu_base);
 
@@ -105,6 +105,8 @@ static void __init spear13xx_smp_init_cpus(void)
 
 	for (i = 0; i < ncores; i++)
 		set_cpu_possible(i, true);
+
+	return ncores;
 }
 
 static void __init spear13xx_smp_prepare_cpus(unsigned int max_cpus)
diff --git a/arch/arm/mach-ux500/platsmp.c b/arch/arm/mach-ux500/platsmp.c
index a44967f..c8d8d4c 100644
--- a/arch/arm/mach-ux500/platsmp.c
+++ b/arch/arm/mach-ux500/platsmp.c
@@ -133,7 +133,7 @@ static void __init wakeup_secondary(void)
  * Initialise the CPU possible map early - this describes the CPUs
  * which may be present or become present in the system.
  */
-static void __init ux500_smp_init_cpus(void)
+static int __init ux500_smp_init_cpus(void)
 {
 	void __iomem *scu_base = scu_base_addr();
 	unsigned int i, ncores;
@@ -149,6 +149,8 @@ static void __init ux500_smp_init_cpus(void)
 
 	for (i = 0; i < ncores; i++)
 		set_cpu_possible(i, true);
+
+	return ncores;
 }
 
 static void __init ux500_smp_prepare_cpus(unsigned int max_cpus)
diff --git a/arch/arm/mach-zynq/platsmp.c b/arch/arm/mach-zynq/platsmp.c
index 52d768f..1ab85e7 100644
--- a/arch/arm/mach-zynq/platsmp.c
+++ b/arch/arm/mach-zynq/platsmp.c
@@ -97,7 +97,7 @@ static int zynq_boot_secondary(unsigned int cpu,
  * Initialise the CPU possible map early - this describes the CPUs
  * which may be present or become present in the system.
  */
-static void __init zynq_smp_init_cpus(void)
+static int __init zynq_smp_init_cpus(void)
 {
 	int i;
 
@@ -105,6 +105,8 @@ static void __init zynq_smp_init_cpus(void)
 
 	for (i = 0; i < ncores && i < CONFIG_NR_CPUS; i++)
 		set_cpu_possible(i, true);
+
+	return ncores;
 }
 
 static void __init zynq_smp_prepare_cpus(unsigned int max_cpus)
-- 
1.9.1

