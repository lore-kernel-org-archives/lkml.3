Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753343Ab3F1X0m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 19:26:42 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:60781 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753006Ab3F1X0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 19:26:38 -0400
From: Rohit Vaswani <rvaswani@codeaurora.org>
To: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>
Cc: Rohit Vaswani <rvaswani@codeaurora.org>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-arm-msm@vger.kernel.org
Subject: [PATCH 4/4] ARM: msm: Add support for 8974 SMP
Date: Fri, 28 Jun 2013 16:26:02 -0700
Message-Id: <1372461962-17197-5-git-send-email-rvaswani@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1372461962-17197-1-git-send-email-rvaswani@codeaurora.org>
References: <1372461962-17197-1-git-send-email-rvaswani@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the cpus bindings and the Kraitv2 release sequence
to make SMP work for 2 cores on MSM8974.

Signed-off-by: Rohit Vaswani <rvaswani@codeaurora.org>
---
 Documentation/devicetree/bindings/arm/cpus.txt |  1 +
 arch/arm/boot/dts/msm8974.dts                  | 23 ++++++++
 arch/arm/mach-msm/board-dt-8974.c              |  3 +
 arch/arm/mach-msm/platsmp.c                    | 79 ++++++++++++++++++++++++++
 4 files changed, 106 insertions(+)

diff --git a/Documentation/devicetree/bindings/arm/cpus.txt b/Documentation/devicetree/bindings/arm/cpus.txt
index 1132eac..7c3c677 100644
--- a/Documentation/devicetree/bindings/arm/cpus.txt
+++ b/Documentation/devicetree/bindings/arm/cpus.txt
@@ -52,6 +52,7 @@ For the ARM architecture every CPU node must contain the following properties:
 		 This should be one of:
 		 "qcom,scss"
 		 "qcom,kpssv1"
+		 "qcom,kpssv2"
 
 Example:
 
diff --git a/arch/arm/boot/dts/msm8974.dts b/arch/arm/boot/dts/msm8974.dts
index c31c097..ef35a9b 100644
--- a/arch/arm/boot/dts/msm8974.dts
+++ b/arch/arm/boot/dts/msm8974.dts
@@ -7,6 +7,22 @@
 	compatible = "qcom,msm8974";
 	interrupt-parent = <&intc>;
 
+	cpus {
+		#address-cells = <1>;
+		#size-cells = <0>;
+		compatible = "qcom,krait";
+		device_type = "cpu";
+		enable-method = "qcom,kpssv2";
+
+		cpu@0 {
+			reg = <0>;
+		};
+
+		cpu@1 {
+			reg = <1>;
+		};
+	};
+
 	intc: interrupt-controller@f9000000 {
 		compatible = "qcom,msm-qgic2";
 		interrupt-controller;
@@ -23,4 +39,11 @@
 			     <1 1 0xf08>;
 		clock-frequency = <19200000>;
 	};
+
+	kpss@f9012000 {
+		compatible = "qcom,kpss";
+		reg = <0xf9012000 0x1000>,
+		      <0xf9088000 0x1000>,
+		      <0xf9098000 0x1000>;
+	};
 };
diff --git a/arch/arm/mach-msm/board-dt-8974.c b/arch/arm/mach-msm/board-dt-8974.c
index d7f84f2..06119f9 100644
--- a/arch/arm/mach-msm/board-dt-8974.c
+++ b/arch/arm/mach-msm/board-dt-8974.c
@@ -13,11 +13,14 @@
 #include <linux/of_platform.h>
 #include <asm/mach/arch.h>
 
+#include "common.h"
+
 static const char * const msm8974_dt_match[] __initconst = {
 	"qcom,msm8974",
 	NULL
 };
 
 DT_MACHINE_START(MSM8974_DT, "Qualcomm MSM (Flattened Device Tree)")
+	.smp = smp_ops(msm_smp_ops),
 	.dt_compat = msm8974_dt_match,
 MACHINE_END
diff --git a/arch/arm/mach-msm/platsmp.c b/arch/arm/mach-msm/platsmp.c
index 82eb079..0fdae69 100644
--- a/arch/arm/mach-msm/platsmp.c
+++ b/arch/arm/mach-msm/platsmp.c
@@ -124,6 +124,80 @@ static int msm8960_release_secondary(unsigned int cpu)
 	return 0;
 }
 
+static int msm8974_release_secondary(unsigned int cpu)
+{
+	void __iomem *reg;
+	void __iomem *l2_saw_base;
+	struct device_node *dn = NULL;
+	unsigned apc_pwr_gate_ctl = 0x14;
+	unsigned reg_val;
+
+	if (cpu == 0 || cpu >= num_possible_cpus())
+		return -EINVAL;
+
+	dn = of_find_compatible_node(dn, NULL, "qcom,kpss");
+	if (!dn) {
+		pr_err("%s : Missing kpss node from device tree\n", __func__);
+		return -ENXIO;
+	}
+
+	reg = of_iomap(dn, cpu+1);
+	if (!reg)
+		return -ENOMEM;
+
+	pr_debug("Starting secondary CPU %d\n", cpu);
+
+	/* Turn on the BHS, turn off LDO Bypass and power down LDO */
+	reg_val =  0x403f0001;
+	writel_relaxed(reg_val, reg + apc_pwr_gate_ctl);
+
+	/* complete the above write before the delay */
+	mb();
+	/* wait for the bhs to settle */
+	udelay(1);
+
+	/* Turn on BHS segments */
+	reg_val |= 0x3f << 1;
+	writel_relaxed(reg_val, reg + apc_pwr_gate_ctl);
+
+	/* complete the above write before the delay */
+	mb();
+	 /* wait for the bhs to settle */
+	udelay(1);
+
+	/* Finally turn on the bypass so that BHS supplies power */
+	reg_val |= 0x3f << 8;
+	writel_relaxed(reg_val, reg + apc_pwr_gate_ctl);
+
+	/* enable max phases */
+	l2_saw_base = of_iomap(dn, 0);
+	if (!l2_saw_base) {
+		return -ENOMEM;
+	}
+	writel_relaxed(0x10003, l2_saw_base + 0x1c);
+	mb();
+	udelay(50);
+
+	iounmap(l2_saw_base);
+
+	writel_relaxed(0x021, reg+0x04);
+	mb();
+	udelay(2);
+
+	writel_relaxed(0x020, reg+0x04);
+	mb();
+	udelay(2);
+
+	writel_relaxed(0x000, reg+0x04);
+	mb();
+
+	writel_relaxed(0x080, reg+0x04);
+	mb();
+
+	iounmap(reg);
+	return 0;
+}
+
 static DEFINE_PER_CPU(int, cold_boot_done);
 
 static void boot_cold_cpu(unsigned int cpu)
@@ -151,6 +225,11 @@ static void boot_cold_cpu(unsigned int cpu)
 			msm8960_release_secondary(cpu);
 			per_cpu(cold_boot_done, cpu) = true;
 		}
+	} else if (!strcmp(enable_method, "qcom,kpssv2")) {
+		if (per_cpu(cold_boot_done, cpu) == false) {
+			msm8974_release_secondary(cpu);
+			per_cpu(cold_boot_done, cpu) = true;
+		}
 	} else {
 		pr_err("%s: Invalid enable-method property: %s\n",
 				__func__, enable_method);
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

