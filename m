Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932992Ab3LXAlm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 19:41:42 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:47608 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932856Ab3LXAkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 19:40:01 -0500
From: Stephen Boyd <sboyd@codeaurora.org>
To: linux-arm-kernel@lists.infradead.org
Cc: Rohit Vaswani <rvaswani@codeaurora.org>,
        David Brown <davidb@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, Kumar Gala <galak@codeaurora.org>,
        devicetree@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
        Arnd Bergmann <arnd@arndb.de>, Russell King <linux@arm.linux.org.uk>
Subject: [PATCH v2 6/9] ARM: msm: Re-organize platsmp to make it extensible
Date: Mon, 23 Dec 2013 16:39:50 -0800
Message-Id: <1387845593-10050-7-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <1387845593-10050-1-git-send-email-sboyd@codeaurora.org>
References: <1387845593-10050-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rohit Vaswani <rvaswani@codeaurora.org>

This makes it easy to add SMP support for new devices by keying
on a device node for the release sequence. We add the
enable-method property for the cpus property to specify that we
want to use the gcc-msm8660 release sequence (which is going to
look for the global clock controller device node to map some
Scorpion specific power and control registers). We also remove
the nr_cpus detection code as that is done generically in the DT
CPU detection code.

Signed-off-by: Rohit Vaswani <rvaswani@codeaurora.org>
[sboyd: Port to CPU_METHOD_OF_DECLARE]
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/mach-msm/board-dt.c |  14 ------
 arch/arm/mach-msm/common.h   |   1 -
 arch/arm/mach-msm/platsmp.c  | 117 ++++++++++++++++++++++++-------------------
 3 files changed, 65 insertions(+), 67 deletions(-)

diff --git a/arch/arm/mach-msm/board-dt.c b/arch/arm/mach-msm/board-dt.c
index 1f11d93..1e3af2b 100644
--- a/arch/arm/mach-msm/board-dt.c
+++ b/arch/arm/mach-msm/board-dt.c
@@ -11,31 +11,17 @@
  */
 
 #include <linux/init.h>
-#include <linux/of.h>
-#include <linux/of_platform.h>
 
 #include <asm/mach/arch.h>
-#include <asm/mach/map.h>
-
-#include "common.h"
 
 static const char * const msm_dt_match[] __initconst = {
 	"qcom,msm8660-fluid",
 	"qcom,msm8660-surf",
 	"qcom,msm8960-cdp",
-	NULL
-};
-
-static const char * const apq8074_dt_match[] __initconst = {
 	"qcom,apq8074-dragonboard",
 	NULL
 };
 
 DT_MACHINE_START(MSM_DT, "Qualcomm MSM (Flattened Device Tree)")
-	.smp = smp_ops(msm_smp_ops),
 	.dt_compat = msm_dt_match,
 MACHINE_END
-
-DT_MACHINE_START(APQ_DT, "Qualcomm MSM (Flattened Device Tree)")
-	.dt_compat = apq8074_dt_match,
-MACHINE_END
diff --git a/arch/arm/mach-msm/common.h b/arch/arm/mach-msm/common.h
index 33c7725..1513f2c 100644
--- a/arch/arm/mach-msm/common.h
+++ b/arch/arm/mach-msm/common.h
@@ -23,7 +23,6 @@ extern void msm_map_qsd8x50_io(void);
 extern void __iomem *__msm_ioremap_caller(phys_addr_t phys_addr, size_t size,
 					  unsigned int mtype, void *caller);
 
-extern struct smp_operations msm_smp_ops;
 extern void msm_cpu_die(unsigned int cpu);
 
 struct msm_mmc_platform_data;
diff --git a/arch/arm/mach-msm/platsmp.c b/arch/arm/mach-msm/platsmp.c
index 5b481db..11c6239 100644
--- a/arch/arm/mach-msm/platsmp.c
+++ b/arch/arm/mach-msm/platsmp.c
@@ -13,6 +13,8 @@
 #include <linux/delay.h>
 #include <linux/device.h>
 #include <linux/jiffies.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
 #include <linux/smp.h>
 #include <linux/io.h>
 
@@ -24,20 +26,14 @@
 #include "scm-boot.h"
 #include "common.h"
 
-#define VDD_SC1_ARRAY_CLAMP_GFS_CTL 0x15A0
-#define SCSS_CPU1CORE_RESET 0xD80
-#define SCSS_DBG_STATUS_CORE_PWRDUP 0xE64
+#define VDD_SC1_ARRAY_CLAMP_GFS_CTL	0x35a0
+#define SCSS_CPU1CORE_RESET		0x2d80
+#define SCSS_DBG_STATUS_CORE_PWRDUP	0x2e64
 
 extern void secondary_startup(void);
 
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
@@ -47,33 +43,41 @@ static void msm_secondary_init(unsigned int cpu)
 	spin_unlock(&boot_lock);
 }
 
-static void prepare_cold_cpu(unsigned int cpu)
+static int scss_release_secondary(unsigned int cpu)
 {
-	int ret;
-	ret = scm_set_boot_addr(virt_to_phys(secondary_startup),
-				SCM_FLAG_COLDBOOT_CPU1);
-	if (ret == 0) {
-		void __iomem *sc1_base_ptr;
-		sc1_base_ptr = ioremap_nocache(0x00902000, SZ_4K*2);
-		if (sc1_base_ptr) {
-			writel(0, sc1_base_ptr + VDD_SC1_ARRAY_CLAMP_GFS_CTL);
-			writel(0, sc1_base_ptr + SCSS_CPU1CORE_RESET);
-			writel(3, sc1_base_ptr + SCSS_DBG_STATUS_CORE_PWRDUP);
-			iounmap(sc1_base_ptr);
-		}
-	} else
-		printk(KERN_DEBUG "Failed to set secondary core boot "
-				  "address\n");
+	struct device_node *node;
+	void __iomem *base;
+
+	node = of_find_compatible_node(NULL, NULL, "qcom,gcc-msm8660");
+	if (!node) {
+		pr_err("%s: can't find node\n", __func__);
+		return -ENXIO;
+	}
+
+	base = of_iomap(node, 0);
+	of_node_put(node);
+	if (!base)
+		return -ENOMEM;
+
+	writel_relaxed(0, base + VDD_SC1_ARRAY_CLAMP_GFS_CTL);
+	writel_relaxed(0, base + SCSS_CPU1CORE_RESET);
+	writel_relaxed(3, base + SCSS_DBG_STATUS_CORE_PWRDUP);
+	mb();
+	iounmap(base);
+
+	return 0;
 }
 
-static int msm_boot_secondary(unsigned int cpu, struct task_struct *idle)
+static DEFINE_PER_CPU(int, cold_boot_done);
+
+static int msm_boot_secondary(unsigned int cpu, int (*func)(unsigned int))
 {
-	static int cold_boot_done;
+	int ret = 0;
 
-	/* Only need to bring cpu out of reset this way once */
-	if (cold_boot_done == false) {
-		prepare_cold_cpu(cpu);
-		cold_boot_done = true;
+	if (!per_cpu(cold_boot_done, cpu)) {
+		ret = func(cpu);
+		if (!ret)
+			per_cpu(cold_boot_done, cpu) = true;
 	}
 
 	/*
@@ -95,39 +99,48 @@ static int msm_boot_secondary(unsigned int cpu, struct task_struct *idle)
 	 */
 	spin_unlock(&boot_lock);
 
-	return 0;
+	return ret;
 }
 
-/*
- * Initialise the CPU possible map early - this describes the CPUs
- * which may be present or become present in the system. The msm8x60
- * does not support the ARM SCU, so just set the possible cpu mask to
- * NR_CPUS.
- */
-static void __init msm_smp_init_cpus(void)
+static int msm8660_boot_secondary(unsigned int cpu, struct task_struct *idle)
 {
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
+	return msm_boot_secondary(cpu, scss_release_secondary);
 }
 
 static void __init msm_smp_prepare_cpus(unsigned int max_cpus)
 {
+	int cpu, map;
+	unsigned int flags = 0;
+	static const int cold_boot_flags[] = {
+		0,
+		SCM_FLAG_COLDBOOT_CPU1,
+	};
+
+	for_each_present_cpu(cpu) {
+		map = cpu_logical_map(cpu);
+		if (WARN_ON(map >= ARRAY_SIZE(cold_boot_flags))) {
+			set_cpu_present(cpu, false);
+			continue;
+		}
+		flags |= cold_boot_flags[map];
+	}
+
+	if (scm_set_boot_addr(virt_to_phys(secondary_startup), flags)) {
+		for_each_present_cpu(cpu) {
+			if (cpu == smp_processor_id())
+				continue;
+			set_cpu_present(cpu, false);
+		}
+		pr_warn("Failed to set CPU boot address, disabling SMP\n");
+	}
 }
 
-struct smp_operations msm_smp_ops __initdata = {
-	.smp_init_cpus		= msm_smp_init_cpus,
+static struct smp_operations msm_smp_8660_ops __initdata = {
 	.smp_prepare_cpus	= msm_smp_prepare_cpus,
 	.smp_secondary_init	= msm_secondary_init,
-	.smp_boot_secondary	= msm_boot_secondary,
+	.smp_boot_secondary	= msm8660_boot_secondary,
 #ifdef CONFIG_HOTPLUG_CPU
 	.cpu_die		= msm_cpu_die,
 #endif
 };
+CPU_METHOD_OF_DECLARE(msm_smp, "qcom,gcc-msm8660", &msm_smp_8660_ops);
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

