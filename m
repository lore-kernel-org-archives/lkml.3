Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753257Ab3F1X0f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 19:26:35 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:60768 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753006Ab3F1X0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 19:26:32 -0400
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
Subject: [PATCH 3/4] ARM: msm: Add SMP support for 8960
Date: Fri, 28 Jun 2013 16:26:01 -0700
Message-Id: <1372461962-17197-4-git-send-email-rvaswani@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1372461962-17197-1-git-send-email-rvaswani@codeaurora.org>
References: <1372461962-17197-1-git-send-email-rvaswani@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the cpus bindings and the Krait release sequence
to make SMP work for MSM8960

Signed-off-by: Rohit Vaswani <rvaswani@codeaurora.org>
---
 Documentation/devicetree/bindings/arm/cpus.txt     |  2 +
 Documentation/devicetree/bindings/arm/msm/kpss.txt | 16 ++++++
 arch/arm/boot/dts/msm8960-cdp.dts                  | 22 +++++++++
 arch/arm/mach-msm/platsmp.c                        | 57 ++++++++++++++++++++++
 arch/arm/mach-msm/scm-boot.h                       |  8 +--
 5 files changed, 102 insertions(+), 3 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/msm/kpss.txt

diff --git a/Documentation/devicetree/bindings/arm/cpus.txt b/Documentation/devicetree/bindings/arm/cpus.txt
index 327aad2..1132eac 100644
--- a/Documentation/devicetree/bindings/arm/cpus.txt
+++ b/Documentation/devicetree/bindings/arm/cpus.txt
@@ -45,11 +45,13 @@ For the ARM architecture every CPU node must contain the following properties:
 		"marvell,xsc3"
 		"marvell,xscale"
 		"qcom,scorpion"
+		"qcom,krait"
 - enable-method: Specifies the method used to enable or take the secondary cores
 		 out of reset. This allows different reset sequence for
 		 different types of cpus.
 		 This should be one of:
 		 "qcom,scss"
+		 "qcom,kpssv1"
 
 Example:
 
diff --git a/Documentation/devicetree/bindings/arm/msm/kpss.txt b/Documentation/devicetree/bindings/arm/msm/kpss.txt
new file mode 100644
index 0000000..7272340
--- /dev/null
+++ b/Documentation/devicetree/bindings/arm/msm/kpss.txt
@@ -0,0 +1,16 @@
+* KPSS - Krait Processor Sub-system
+
+Properties
+
+- compatible : Should contain "qcom,kpss".
+
+- reg: Specifies the base address for the KPSS registers used for
+       booting up secondary cores.
+
+Example:
+
+	kpss@2088000 {
+		compatible = "qcom,kpss";
+		reg = <0x02088000 0x1000
+			0x02098000 0x2000>;
+	};
diff --git a/arch/arm/boot/dts/msm8960-cdp.dts b/arch/arm/boot/dts/msm8960-cdp.dts
index db2060c..8c82d5e 100644
--- a/arch/arm/boot/dts/msm8960-cdp.dts
+++ b/arch/arm/boot/dts/msm8960-cdp.dts
@@ -7,6 +7,22 @@
 	compatible = "qcom,msm8960-cdp", "qcom,msm8960";
 	interrupt-parent = <&intc>;
 
+	cpus {
+		#address-cells = <1>;
+		#size-cells = <0>;
+		compatible = "qcom,krait";
+		device_type = "cpu";
+		enable-method = "qcom,kpssv1";
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
 	intc: interrupt-controller@2000000 {
 		compatible = "qcom,msm-qgic2";
 		interrupt-controller;
@@ -37,6 +53,12 @@
 		reg = <0xfd510000 0x4000>;
 	};
 
+	kpss@2088000 {
+		compatible = "qcom,kpss";
+		reg = <0x02088000 0x1000
+			0x02098000 0x2000>;
+	};
+
 	serial@16440000 {
 		compatible = "qcom,msm-hsuart", "qcom,msm-uart";
 		reg = <0x16440000 0x1000>,
diff --git a/arch/arm/mach-msm/platsmp.c b/arch/arm/mach-msm/platsmp.c
index 17022e0..82eb079 100644
--- a/arch/arm/mach-msm/platsmp.c
+++ b/arch/arm/mach-msm/platsmp.c
@@ -74,6 +74,56 @@ static int scorpion_release_secondary(void)
 	return 0;
 }
 
+static int msm8960_release_secondary(unsigned int cpu)
+{
+	void __iomem *reg;
+	struct device_node *dn = NULL;
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
+	reg = of_iomap(dn, cpu);
+	if (!reg)
+		return -ENOMEM;
+
+	pr_debug("Starting secondary CPU %d\n", cpu);
+
+	/* Turn on CPU Rail */
+	writel_relaxed(0xA4, reg+0x1014);
+	mb();
+	udelay(512);
+
+	/* Krait bring-up sequence */
+	writel_relaxed(0x109, reg+0x04);
+	writel_relaxed(0x101, reg+0x04);
+	mb();
+	ndelay(300);
+
+	writel_relaxed(0x121, reg+0x04);
+	mb();
+	udelay(2);
+
+	writel_relaxed(0x120, reg+0x04);
+	mb();
+	udelay(2);
+
+	writel_relaxed(0x100, reg+0x04);
+	mb();
+	udelay(100);
+
+	writel_relaxed(0x180, reg+0x04);
+	mb();
+
+	iounmap(reg);
+	return 0;
+}
+
 static DEFINE_PER_CPU(int, cold_boot_done);
 
 static void boot_cold_cpu(unsigned int cpu)
@@ -96,6 +146,11 @@ static void boot_cold_cpu(unsigned int cpu)
 			scorpion_release_secondary();
 			per_cpu(cold_boot_done, cpu) = true;
 		}
+	} else if (!strcmp(enable_method, "qcom,kpssv1")) {
+		if (per_cpu(cold_boot_done, cpu) == false) {
+			msm8960_release_secondary(cpu);
+			per_cpu(cold_boot_done, cpu) = true;
+		}
 	} else {
 		pr_err("%s: Invalid enable-method property: %s\n",
 				__func__, enable_method);
@@ -151,6 +206,8 @@ static void __init msm_smp_init_cpus(void)
 static const int cold_boot_flags[] __initconst = {
 	0,
 	SCM_FLAG_COLDBOOT_CPU1,
+	SCM_FLAG_COLDBOOT_CPU2,
+	SCM_FLAG_COLDBOOT_CPU3,
 };
 
 static void __init msm_smp_prepare_cpus(unsigned int max_cpus)
diff --git a/arch/arm/mach-msm/scm-boot.h b/arch/arm/mach-msm/scm-boot.h
index 7be32ff..6aabb24 100644
--- a/arch/arm/mach-msm/scm-boot.h
+++ b/arch/arm/mach-msm/scm-boot.h
@@ -13,9 +13,11 @@
 #define __MACH_SCM_BOOT_H
 
 #define SCM_BOOT_ADDR			0x1
-#define SCM_FLAG_COLDBOOT_CPU1		0x1
-#define SCM_FLAG_WARMBOOT_CPU1		0x2
-#define SCM_FLAG_WARMBOOT_CPU0		0x4
+#define SCM_FLAG_COLDBOOT_CPU1		0x01
+#define SCM_FLAG_COLDBOOT_CPU2		0x08
+#define SCM_FLAG_COLDBOOT_CPU3		0x20
+#define SCM_FLAG_WARMBOOT_CPU0		0x04
+#define SCM_FLAG_WARMBOOT_CPU1		0x02
 
 int scm_set_boot_addr(phys_addr_t addr, int flags);
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

