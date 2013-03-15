Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753921Ab3CODbp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 23:31:45 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:53357 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753729Ab3CODbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 23:31:42 -0400
X-IronPort-AV: E=Sophos;i="4.84,849,1355126400"; 
   d="scan'208";a="29647843"
From: Stephen Boyd <sboyd@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 2/3] ARM: msm: Rework timer binding to be more general
Date: Thu, 14 Mar 2013 20:31:38 -0700
Message-Id: <1363318299-10814-3-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.2.rc2.4.g7799588
In-Reply-To: <1363318299-10814-1-git-send-email-sboyd@codeaurora.org>
References: <1363318299-10814-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The msm timer binding I wrote is bad. First off, the clock
frequency in the binding for the dgt is wrong. Software divides
down the input rate by 4 to achieve the rate listed in the
binding. We also treat each individual timer as a separate
hardware component, when in reality there is one timer block
(that may be duplicated per cpu) with multiple timers within it.
Depending on the version of the hardware there can be one or two
general purpose timers, status and divider control registers, and
an entirely different register layout.

In the next patch we'll need to know about the different register
layouts so that we can properly check the status register after
clearing the count. The current binding makes this complicated
because the general purpose timer's reg property doesn't indicate
where that status register is, and in fact it is beyond the size
of the reg property.

Clean all this up by just having one node for the timer hardware,
and describe all the interrupts and clock frequencies supported
while having one reg property that covers the entire timer
register region. We'll use the compatible field in the future to
determine different register layouts and if we should read the
status registers, etc.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 .../devicetree/bindings/arm/msm/timer.txt          | 41 ++++++-----
 arch/arm/boot/dts/msm8660-surf.dts                 | 20 ++----
 arch/arm/boot/dts/msm8960-cdp.dts                  | 22 +++---
 arch/arm/mach-msm/timer.c                          | 79 +++++++++-------------
 4 files changed, 68 insertions(+), 94 deletions(-)

diff --git a/Documentation/devicetree/bindings/arm/msm/timer.txt b/Documentation/devicetree/bindings/arm/msm/timer.txt
index 8c5907b..c6ef8f1 100644
--- a/Documentation/devicetree/bindings/arm/msm/timer.txt
+++ b/Documentation/devicetree/bindings/arm/msm/timer.txt
@@ -3,36 +3,35 @@
 Properties:
 
 - compatible : Should at least contain "qcom,msm-timer". More specific
-  properties such as "qcom,msm-gpt" and "qcom,msm-dgt" specify a general
-  purpose timer and a debug timer respectively.
+               properties specify which subsystem the timers are paired with.
 
-- interrupts : Interrupt indicating a match event.
+               "qcom,kpss-timer" - krait subsystem
+               "qcom,scss-timer" - scorpion subsystem
 
-- reg : Specifies the base address of the timer registers. The second region
-  specifies an optional register used to configure the clock divider.
+- interrupts : Interrupts for the the debug timer, the first general purpose
+               timer, and optionally a second general purpose timer in that
+               order.
 
-- clock-frequency : The frequency of the timer in Hz.
+- reg : Specifies the base address of the timer registers.
+
+- clock-frequency : The frequency of the debug timer and the general purpose
+                    timer(s) in Hz in that order.
 
 Optional:
 
 - cpu-offset : per-cpu offset used when the timer is accessed without the
-  CPU remapping facilities. The offset is cpu-offset * cpu-nr.
+               CPU remapping facilities. The offset is
+               cpu-offset + (0x10000 * cpu-nr).
 
 Example:
 
-       timer@200a004 {
-               compatible = "qcom,msm-gpt", "qcom,msm-timer";
-               interrupts = <1 2 0x301>;
-               reg = <0x0200a004 0x10>;
-               clock-frequency = <32768>;
-               cpu-offset = <0x40000>;
-       };
-
-       timer@200a024 {
-               compatible = "qcom,msm-dgt", "qcom,msm-timer";
-               interrupts = <1 3 0x301>;
-               reg = <0x0200a024 0x10>,
-                     <0x0200a034 0x4>;
-               clock-frequency = <6750000>;
+       timer@200a000 {
+               compatible = "qcom,scss-timer", "qcom,msm-timer";
+               interrupts = <1 1 0x301>,
+                            <1 2 0x301>,
+                            <1 3 0x301>;
+               reg = <0x0200a000 0x100>;
+               clock-frequency = <19200000>,
+                                 <32768>;
                cpu-offset = <0x40000>;
        };
diff --git a/arch/arm/boot/dts/msm8660-surf.dts b/arch/arm/boot/dts/msm8660-surf.dts
index 31f2157..743ef42 100644
--- a/arch/arm/boot/dts/msm8660-surf.dts
+++ b/arch/arm/boot/dts/msm8660-surf.dts
@@ -16,19 +16,13 @@
 	};
 
 	timer@2000004 {
-		compatible = "qcom,msm-gpt", "qcom,msm-timer";
-		interrupts = <1 1 0x301>;
-		reg = <0x02000004 0x10>;
-		clock-frequency = <32768>;
-		cpu-offset = <0x40000>;
-	};
-
-	timer@2000024 {
-		compatible = "qcom,msm-dgt", "qcom,msm-timer";
-		interrupts = <1 0 0x301>;
-		reg = <0x02000024 0x10>,
-		      <0x02000034 0x4>;
-		clock-frequency = <6750000>;
+		compatible = "qcom,scss-timer", "qcom,msm-timer";
+		interrupts = <1 0 0x301>,
+			     <1 1 0x301>,
+			     <1 2 0x301>;
+		reg = <0x02000000 0x100>;
+		clock-frequency = <27000000>,
+				  <32768>;
 		cpu-offset = <0x40000>;
 	};
 
diff --git a/arch/arm/boot/dts/msm8960-cdp.dts b/arch/arm/boot/dts/msm8960-cdp.dts
index 9e621b5..3ae51fb 100644
--- a/arch/arm/boot/dts/msm8960-cdp.dts
+++ b/arch/arm/boot/dts/msm8960-cdp.dts
@@ -15,20 +15,14 @@
 		      < 0x02002000 0x1000 >;
 	};
 
-	timer@200a004 {
-		compatible = "qcom,msm-gpt", "qcom,msm-timer";
-		interrupts = <1 2 0x301>;
-		reg = <0x0200a004 0x10>;
-		clock-frequency = <32768>;
-		cpu-offset = <0x80000>;
-	};
-
-	timer@200a024 {
-		compatible = "qcom,msm-dgt", "qcom,msm-timer";
-		interrupts = <1 1 0x301>;
-		reg = <0x0200a024 0x10>,
-		      <0x0200a034 0x4>;
-		clock-frequency = <6750000>;
+	timer@200a000 {
+		compatible = "qcom,kpss-timer", "qcom,msm-timer";
+		interrupts = <1 1 0x301>,
+			     <1 2 0x301>,
+			     <1 3 0x301>;
+		reg = <0x0200a000 0x100>;
+		clock-frequency = <27000000>,
+				  <32768>;
 		cpu-offset = <0x80000>;
 	};
 
diff --git a/arch/arm/mach-msm/timer.c b/arch/arm/mach-msm/timer.c
index f9fd77e..9f033c3 100644
--- a/arch/arm/mach-msm/timer.c
+++ b/arch/arm/mach-msm/timer.c
@@ -36,6 +36,7 @@
 #define TIMER_ENABLE_CLR_ON_MATCH_EN    BIT(1)
 #define TIMER_ENABLE_EN                 BIT(0)
 #define TIMER_CLEAR             0x000C
+#define DGT_CLK_CTL		0x10
 #define DGT_CLK_CTL_DIV_4	0x3
 
 #define GPT_HZ 32768
@@ -217,13 +218,9 @@ err:
 }
 
 #ifdef CONFIG_OF
-static const struct of_device_id msm_dgt_match[] __initconst = {
-	{ .compatible = "qcom,msm-dgt" },
-	{ },
-};
-
-static const struct of_device_id msm_gpt_match[] __initconst = {
-	{ .compatible = "qcom,msm-gpt" },
+static const struct of_device_id msm_timer_match[] __initconst = {
+	{ .compatible = "qcom,kpss-timer" },
+	{ .compatible = "qcom,scss-timer" },
 	{ },
 };
 
@@ -234,33 +231,29 @@ void __init msm_dt_timer_init(void)
 	int irq;
 	struct resource res;
 	u32 percpu_offset;
-	void __iomem *dgt_clk_ctl;
+	void __iomem *base;
+	void __iomem *cpu0_base;
 
-	np = of_find_matching_node(NULL, msm_gpt_match);
+	np = of_find_matching_node(NULL, msm_timer_match);
 	if (!np) {
-		pr_err("Can't find GPT DT node\n");
+		pr_err("Can't find msm timer DT node\n");
 		return;
 	}
 
-	event_base = of_iomap(np, 0);
-	if (!event_base) {
+	base = of_iomap(np, 0);
+	if (!base) {
 		pr_err("Failed to map event base\n");
 		return;
 	}
 
-	irq = irq_of_parse_and_map(np, 0);
+	/* We use GPT0 for the clockevent */
+	irq = irq_of_parse_and_map(np, 1);
 	if (irq <= 0) {
 		pr_err("Can't get irq\n");
 		return;
 	}
-	of_node_put(np);
-
-	np = of_find_matching_node(NULL, msm_dgt_match);
-	if (!np) {
-		pr_err("Can't find DGT DT node\n");
-		return;
-	}
 
+	/* We use CPU0's DGT for the clocksource */
 	if (of_property_read_u32(np, "cpu-offset", &percpu_offset))
 		percpu_offset = 0;
 
@@ -269,45 +262,39 @@ void __init msm_dt_timer_init(void)
 		return;
 	}
 
-	source_base = ioremap(res.start + percpu_offset, resource_size(&res));
-	if (!source_base) {
+	cpu0_base = ioremap(res.start + percpu_offset, resource_size(&res));
+	if (!cpu0_base) {
 		pr_err("Failed to map source base\n");
 		return;
 	}
 
-	if (!of_address_to_resource(np, 1, &res)) {
-		dgt_clk_ctl = ioremap(res.start + percpu_offset,
-				      resource_size(&res));
-		if (!dgt_clk_ctl) {
-			pr_err("Failed to map DGT control base\n");
-			return;
-		}
-		writel_relaxed(DGT_CLK_CTL_DIV_4, dgt_clk_ctl);
-		iounmap(dgt_clk_ctl);
-	}
-
 	if (of_property_read_u32(np, "clock-frequency", &freq)) {
 		pr_err("Unknown frequency\n");
 		return;
 	}
 	of_node_put(np);
 
+	event_base = base + 0x4;
+	source_base = cpu0_base + 0x24;
+	freq /= 4;
+	writel_relaxed(DGT_CLK_CTL_DIV_4, source_base + DGT_CLK_CTL);
+
 	msm_timer_init(freq, 32, irq, !!percpu_offset);
 }
 #endif
 
-static int __init msm_timer_map(phys_addr_t event, phys_addr_t source)
+static int __init msm_timer_map(phys_addr_t addr, u32 event, u32 source)
 {
-	event_base = ioremap(event, SZ_64);
-	if (!event_base) {
-		pr_err("Failed to map event base\n");
-		return 1;
-	}
-	source_base = ioremap(source, SZ_64);
-	if (!source_base) {
-		pr_err("Failed to map source base\n");
-		return 1;
+	void __iomem *base;
+
+	base = ioremap(addr, SZ_256);
+	if (!base) {
+		pr_err("Failed to map timer base\n");
+		return -ENOMEM;
 	}
+	event_base = base + event;
+	source_base = base + source;
+
 	return 0;
 }
 
@@ -315,7 +302,7 @@ void __init msm7x01_timer_init(void)
 {
 	struct clocksource *cs = &msm_clocksource;
 
-	if (msm_timer_map(0xc0100000, 0xc0100010))
+	if (msm_timer_map(0xc0100000, 0x0, 0x10))
 		return;
 	cs->read = msm_read_timer_count_shift;
 	cs->mask = CLOCKSOURCE_MASK((32 - MSM_DGT_SHIFT));
@@ -326,14 +313,14 @@ void __init msm7x01_timer_init(void)
 
 void __init msm7x30_timer_init(void)
 {
-	if (msm_timer_map(0xc0100004, 0xc0100024))
+	if (msm_timer_map(0xc0100000, 0x4, 0x24))
 		return;
 	msm_timer_init(24576000 / 4, 32, 1, false);
 }
 
 void __init qsd8x50_timer_init(void)
 {
-	if (msm_timer_map(0xAC100000, 0xAC100010))
+	if (msm_timer_map(0xAC100000, 0x0, 0x10))
 		return;
 	msm_timer_init(19200000 / 4, 32, 7, false);
 }
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

