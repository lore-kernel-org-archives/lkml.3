Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758888Ab3FDAUu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 20:20:50 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:55993 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758642Ab3FDAUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 20:20:24 -0400
From: Rohit Vaswani <rvaswani@codeaurora.org>
To: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>
Cc: Rohit Vaswani <rvaswani@codeaurora.org>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: [PATCH 2/3] ARM: msm: Re-organize platsmp to make it extensible
Date: Mon,  3 Jun 2013 17:19:44 -0700
Message-Id: <1370305185-6450-3-git-send-email-rvaswani@codeaurora.org>
X-Mailer: git-send-email 1.7.8.3
In-Reply-To: <1370305185-6450-1-git-send-email-rvaswani@codeaurora.org>
References: <1370305185-6450-1-git-send-email-rvaswani@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes it easy to add SMP support for new targets.
This patch adds the 8660 cpus bindings to make SMP work.

Signed-off-by: Rohit Vaswani <rvaswani@codeaurora.org>
---
 Documentation/devicetree/bindings/arm/cpus.txt     |    6 ++
 Documentation/devicetree/bindings/arm/msm/scss.txt |   15 +++
 arch/arm/boot/dts/msm8660-surf.dts                 |   21 +++++
 arch/arm/mach-msm/platsmp.c                        |   93 +++++++++++++++-----
 4 files changed, 114 insertions(+), 21 deletions(-)
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
index 9bf49b3..0ede522 100644
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
@@ -26,6 +42,11 @@
 		cpu-offset = <0x40000>;
 	};
 
+	scss@902000 {
+		compatible = "qcom,scss";
+		reg = <0x00902000 0x2000>;
+	};
+
 	serial@19c400000 {
 		compatible = "qcom,msm-hsuart", "qcom,msm-uart";
 		reg = <0x19c40000 0x1000>,
diff --git a/arch/arm/mach-msm/platsmp.c b/arch/arm/mach-msm/platsmp.c
index 2028f3f..ccf4168 100644
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
 
@@ -61,35 +63,64 @@ static void __cpuinit msm_secondary_init(unsigned int cpu)
 	spin_unlock(&boot_lock);
 }
 
-static __cpuinit void prepare_cold_cpu(unsigned int cpu)
+static int __cpuinit scorpion_release_secondary(void)
 {
-	int ret;
-	ret = scm_set_boot_addr(virt_to_phys(msm_secondary_startup),
-				SCM_FLAG_COLDBOOT_CPU1);
-	if (ret == 0) {
-		void __iomem *sc1_base_ptr;
-		sc1_base_ptr = ioremap_nocache(0x00902000, SZ_4K*2);
-		if (sc1_base_ptr) {
-			writel(0, sc1_base_ptr + VDD_SC1_ARRAY_CLAMP_GFS_CTL);
-			writel(0, sc1_base_ptr + SCSS_CPU1CORE_RESET);
-			writel(3, sc1_base_ptr + SCSS_DBG_STATUS_CORE_PWRDUP);
-			iounmap(sc1_base_ptr);
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
+}
+
+static DEFINE_PER_CPU(int, cold_boot_done);
+
+static __cpuinit void boot_cold_cpu(unsigned int cpu)
+{
+	const char *enable_method;
+	struct device_node *dn = NULL;
+
+	dn = of_find_node_by_name(dn, "cpus");
+	if (!dn) {
+		pr_err("%s: Missing node cpus in device tree\n", __func__);
+		return;
+	}
+
+	enable_method = of_get_property(dn, "enable-method", NULL);
+	if (!enable_method) {
+			pr_err("%s: cpus node is missing enable-method property\n",
+					__func__);
+	} else if (!strcmp(enable_method, "qcom,scss")) {
+		if (per_cpu(cold_boot_done, cpu) == false) {
+			scorpion_release_secondary();
+			per_cpu(cold_boot_done, cpu) = true;
 		}
-	} else
-		printk(KERN_DEBUG "Failed to set secondary core boot "
-				  "address\n");
+	} else {
+		pr_err("%s: Invalid enable-method property: %s\n",
+				__func__, enable_method);
+	}
 }
 
 static int __cpuinit msm_boot_secondary(unsigned int cpu, struct task_struct *idle)
 {
 	unsigned long timeout;
-	static int cold_boot_done;
 
-	/* Only need to bring cpu out of reset this way once */
-	if (cold_boot_done == false) {
-		prepare_cold_cpu(cpu);
-		cold_boot_done = true;
-	}
+	boot_cold_cpu(cpu);
 
 	/*
 	 * set synchronisation state between this boot processor
@@ -152,8 +183,28 @@ static void __init msm_smp_init_cpus(void)
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
+	if (scm_set_boot_addr(virt_to_phys(msm_secondary_startup), flags))
+		pr_warn("Failed to set CPU boot address\n");
 }
 
 struct smp_operations msm_smp_ops __initdata = {
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

