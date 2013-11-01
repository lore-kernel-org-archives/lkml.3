Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756611Ab3KAWJM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 18:09:12 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:48596 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756554Ab3KAWJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 18:09:05 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: linux-arm-kernel@lists.infradead.org
Cc: Rohit Vaswani <rvaswani@codeaurora.org>,
        David Brown <davidb@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: [PATCH 07/11] ARM: msm: Re-organize platsmp to make it extensible
Date: Fri,  1 Nov 2013 15:08:55 -0700
Message-Id: <1383343739-23080-8-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.4.2.564.g0d6cf24
In-Reply-To: <1383343739-23080-1-git-send-email-sboyd@codeaurora.org>
References: <1383343739-23080-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rohit Vaswani <rvaswani@codeaurora.org>

This makes it easy to add SMP support for new devices by keying
on a device node for the release sequence. We add the
enable-method property for the cpus property to specify that we
want to use the mmio release sequence (which is going to look for
a device node to map some Scorpion specific power and control
registers). While at it, add the 8660 cpus bindings to make SMP
work.

Signed-off-by: Rohit Vaswani <rvaswani@codeaurora.org>
[sboyd: Port to CPU_METHOD_OF_DECLARE, replace if/else with match
table method]
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/boot/dts/qcom-msm8660-surf.dts |  24 ++++++++
 arch/arm/mach-msm/board-dt.c            |  14 -----
 arch/arm/mach-msm/common.h              |   1 -
 arch/arm/mach-msm/platsmp.c             | 103 ++++++++++++++++++++++++--------
 4 files changed, 103 insertions(+), 39 deletions(-)

diff --git a/arch/arm/boot/dts/qcom-msm8660-surf.dts b/arch/arm/boot/dts/qcom-msm8660-surf.dts
index 386d428..ac5ea76 100644
--- a/arch/arm/boot/dts/qcom-msm8660-surf.dts
+++ b/arch/arm/boot/dts/qcom-msm8660-surf.dts
@@ -7,6 +7,23 @@
 	compatible = "qcom,msm8660-surf", "qcom,msm8660";
 	interrupt-parent = <&intc>;
 
+	cpus {
+		#address-cells = <1>;
+		#size-cells = <0>;
+		compatible = "qcom,scorpion";
+		enable-method = "qcom,mmio";
+
+		cpu@0 {
+			device_type = "cpu";
+			reg = <0>;
+		};
+
+		cpu@1 {
+			device_type = "cpu";
+			reg = <1>;
+		};
+	};
+
 	intc: interrupt-controller@2080000 {
 		compatible = "qcom,msm-8660-qgic";
 		interrupt-controller;
@@ -37,6 +54,13 @@
 		#interrupt-cells = <2>;
 	};
 
+	clock-controller@900000 {
+		compatible = "qcom,gcc-8660";
+		reg = <0x00900000 0x4000>;
+		#clock-cells = <1>;
+		#reset-cells = <1>;
+	};
+
 	serial@19c40000 {
 		compatible = "qcom,msm-uartdm-v1.3", "qcom,msm-uartdm";
 		reg = <0x19c40000 0x1000>,
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
index 5b481db..369d8f7 100644
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
 
@@ -24,9 +26,9 @@
 #include "scm-boot.h"
 #include "common.h"
 
-#define VDD_SC1_ARRAY_CLAMP_GFS_CTL 0x15A0
-#define SCSS_CPU1CORE_RESET 0xD80
-#define SCSS_DBG_STATUS_CORE_PWRDUP 0xE64
+#define VDD_SC1_ARRAY_CLAMP_GFS_CTL	0x35a0
+#define SCSS_CPU1CORE_RESET		0x2d80
+#define SCSS_DBG_STATUS_CORE_PWRDUP	0x2e64
 
 extern void secondary_startup(void);
 
@@ -47,34 +49,62 @@ static void msm_secondary_init(unsigned int cpu)
 	spin_unlock(&boot_lock);
 }
 
-static void prepare_cold_cpu(unsigned int cpu)
+static int scss_release_secondary(struct device_node *node, unsigned int cpu)
+{
+	void __iomem *base;
+
+	base = of_iomap(node, 0);
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
+}
+
+static DEFINE_PER_CPU(int, cold_boot_done);
+
+static int boot_cold_cpu(unsigned int cpu)
 {
 	int ret;
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
+	const struct of_device_id *match;
+	const int (*func)(struct device_node *, int);
+#define M(c, f) { .compatible = c, .data = f }
+	static const struct of_device_id match_table[] = {
+		M("qcom,gcc-8660", scss_release_secondary),
+	};
+#undef M
+
+	if (per_cpu(cold_boot_done, cpu))
+		return 0;
+
+	node = of_find_matching_node_and_match(NULL, match_table, &match);
+	if (!node) {
+		pr_err("%s: can't find subsystem node\n", __func__);
+		return -ENXIO;
+	}
+
+	func = match->data;
+	ret = func(node, cpu);
+	if (!ret)
+		per_cpu(cold_boot_done, cpu) = true;
+	of_node_put(node);
+
+	return ret;
 }
 
 static int msm_boot_secondary(unsigned int cpu, struct task_struct *idle)
 {
-	static int cold_boot_done;
+	int ret;
 
-	/* Only need to bring cpu out of reset this way once */
-	if (cold_boot_done == false) {
-		prepare_cold_cpu(cpu);
-		cold_boot_done = true;
-	}
+	ret = boot_cold_cpu(cpu);
+	if (ret)
+		return ret;
 
 	/*
 	 * set synchronisation state between this boot processor
@@ -120,6 +150,30 @@ static void __init msm_smp_init_cpus(void)
 
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
 
 struct smp_operations msm_smp_ops __initdata = {
@@ -131,3 +185,4 @@ struct smp_operations msm_smp_ops __initdata = {
 	.cpu_die		= msm_cpu_die,
 #endif
 };
+CPU_METHOD_OF_DECLARE(msm_smp, "qcom,mmio", &msm_smp_ops);
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

