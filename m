Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753171Ab3F1X0c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 19:26:32 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:60755 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752976Ab3F1X03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 19:26:29 -0400
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
Subject: [PATCH 2/4] ARM: msm: Re-organize platsmp to make it extensible
Date: Fri, 28 Jun 2013 16:26:00 -0700
Message-Id: <1372461962-17197-3-git-send-email-rvaswani@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1372461962-17197-1-git-send-email-rvaswani@codeaurora.org>
References: <1372461962-17197-1-git-send-email-rvaswani@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes it easy to add SMP support for new targets
by adding cpus property and the release sequence.
We add the enable-method property for the cpus property to
specify which release sequence to use.
While at it, add the 8660 cpus bindings to make SMP work.

Signed-off-by: Rohit Vaswani <rvaswani@codeaurora.org>
---
 Documentation/devicetree/bindings/arm/cpus.txt     |  6 ++
 Documentation/devicetree/bindings/arm/msm/scss.txt | 15 ++++
 arch/arm/boot/dts/msm8660-surf.dts                 | 23 +++++-
 arch/arm/mach-msm/platsmp.c                        | 96 ++++++++++++++++------
 4 files changed, 116 insertions(+), 24 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/msm/scss.txt

diff --git a/Documentation/devicetree/bindings/arm/cpus.txt b/Documentation/devicetree/bindings/arm/cpus.txt
index f32494d..327aad2 100644
--- a/Documentation/devicetree/bindings/arm/cpus.txt
+++ b/Documentation/devicetree/bindings/arm/cpus.txt
@@ -44,6 +44,12 @@ For the ARM architecture every CPU node must contain the following properties:
 		"marvell,mohawk"
 		"marvell,xsc3"
 		"marvell,xscale"
+		"qcom,scorpion"
+- enable-method: Specifies the method used to enable or take the secondary cores
+		 out of reset. This allows different reset sequence for
+		 different types of cpus.
+		 This should be one of:
+		 "qcom,scss"
 
 Example:
 
diff --git a/Documentation/devicetree/bindings/arm/msm/scss.txt b/Documentation/devicetree/bindings/arm/msm/scss.txt
new file mode 100644
index 0000000..21c3e26
--- /dev/null
+++ b/Documentation/devicetree/bindings/arm/msm/scss.txt
@@ -0,0 +1,15 @@
+* SCSS - Scorpion Sub-system
+
+Properties
+
+- compatible : Should contain "qcom,scss".
+
+- reg: Specifies the base address for the SCSS registers used for
+       booting up secondary cores.
+
+Example:
+
+	scss@902000 {
+		compatible = "qcom,scss";
+		reg = <0x00902000 0x2000>;
+	};
diff --git a/arch/arm/boot/dts/msm8660-surf.dts b/arch/arm/boot/dts/msm8660-surf.dts
index cdc010e..203e51a 100644
--- a/arch/arm/boot/dts/msm8660-surf.dts
+++ b/arch/arm/boot/dts/msm8660-surf.dts
@@ -7,6 +7,22 @@
 	compatible = "qcom,msm8660-surf", "qcom,msm8660";
 	interrupt-parent = <&intc>;
 
+	cpus {
+		#address-cells = <1>;
+		#size-cells = <0>;
+		compatible = "qcom,scorpion";
+		device_type = "cpu";
+		enable-method = "qcom,scss";
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
 	intc: interrupt-controller@2080000 {
 		compatible = "qcom,msm-8660-qgic";
 		interrupt-controller;
@@ -37,7 +53,12 @@
 		#interrupt-cells = <2>;
 	};
 
-	serial@19c40000 {
+	scss@902000 {
+		compatible = "qcom,scss";
+		reg = <0x00902000 0x2000>;
+	};
+
+	serial@19c400000 {
 		compatible = "qcom,msm-hsuart", "qcom,msm-uart";
 		reg = <0x19c40000 0x1000>,
 		      <0x19c00000 0x1000>;
diff --git a/arch/arm/mach-msm/platsmp.c b/arch/arm/mach-msm/platsmp.c
index 7d48759..17022e0 100644
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
 
@@ -38,7 +40,7 @@ static inline int get_core_count(void)
 	return ((read_cpuid_id() >> 4) & 3) + 1;
 }
 
-static void __cpuinit msm_secondary_init(unsigned int cpu)
+static void msm_secondary_init(unsigned int cpu)
 {
 	/*
 	 * Synchronise with the boot thread.
@@ -47,35 +49,63 @@ static void __cpuinit msm_secondary_init(unsigned int cpu)
 	spin_unlock(&boot_lock);
 }
 
-static __cpuinit void prepare_cold_cpu(unsigned int cpu)
+static int scorpion_release_secondary(void)
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
+	void __iomem *sc1_base_ptr;
+	struct device_node *dn = NULL;
+
+	dn = of_find_compatible_node(dn, NULL, "qcom,scss");
+	if (!dn) {
+		pr_err("%s: Missing scss node in device tree\n", __func__);
+		return -ENXIO;
+	}
+
+	sc1_base_ptr = of_iomap(dn, 0);
+	if (sc1_base_ptr) {
+		writel_relaxed(0, sc1_base_ptr + VDD_SC1_ARRAY_CLAMP_GFS_CTL);
+		writel_relaxed(0, sc1_base_ptr + SCSS_CPU1CORE_RESET);
+		writel_relaxed(3, sc1_base_ptr + SCSS_DBG_STATUS_CORE_PWRDUP);
+		mb();
+		iounmap(sc1_base_ptr);
+	} else {
+		return -ENOMEM;
+	}
+
+	return 0;
 }
 
-static int __cpuinit msm_boot_secondary(unsigned int cpu, struct task_struct *idle)
+static DEFINE_PER_CPU(int, cold_boot_done);
+
+static void boot_cold_cpu(unsigned int cpu)
 {
-	static int cold_boot_done;
+	const char *enable_method;
+	struct device_node *dn = NULL;
 
-	/* Only need to bring cpu out of reset this way once */
-	if (cold_boot_done == false) {
-		prepare_cold_cpu(cpu);
-		cold_boot_done = true;
+	dn = of_find_node_by_name(dn, "cpus");
+	if (!dn) {
+		pr_err("%s: Missing node cpus in device tree\n", __func__);
+		return;
 	}
 
+	enable_method = of_get_property(dn, "enable-method", NULL);
+	if (!enable_method) {
+			pr_err("%s: cpus node is missing enable-method property\n",
+					__func__);
+	} else if (!strcmp(enable_method, "qcom,scss")) {
+		if (per_cpu(cold_boot_done, cpu) == false) {
+			scorpion_release_secondary();
+			per_cpu(cold_boot_done, cpu) = true;
+		}
+	} else {
+		pr_err("%s: Invalid enable-method property: %s\n",
+				__func__, enable_method);
+	}
+}
+
+static int msm_boot_secondary(unsigned int cpu, struct task_struct *idle)
+{
+	boot_cold_cpu(cpu);
+
 	/*
 	 * set synchronisation state between this boot processor
 	 * and the secondary one
@@ -118,8 +148,28 @@ static void __init msm_smp_init_cpus(void)
 		set_cpu_possible(i, true);
 }
 
+static const int cold_boot_flags[] __initconst = {
+	0,
+	SCM_FLAG_COLDBOOT_CPU1,
+};
+
 static void __init msm_smp_prepare_cpus(unsigned int max_cpus)
 {
+	int cpu, map;
+	unsigned int flags = 0;
+
+	for_each_present_cpu(cpu) {
+		map = cpu_logical_map(cpu);
+		if (map > ARRAY_SIZE(cold_boot_flags)) {
+			set_cpu_present(cpu, false);
+			__WARN();
+			continue;
+		}
+		flags |= cold_boot_flags[map];
+	}
+
+	if (scm_set_boot_addr(virt_to_phys(secondary_startup), flags))
+		pr_warn("Failed to set CPU boot address\n");
 }
 
 struct smp_operations msm_smp_ops __initdata = {
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

