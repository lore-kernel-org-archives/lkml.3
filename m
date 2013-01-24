Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752934Ab3AXK6k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 05:58:40 -0500
Received: from kiruna.synopsys.com ([198.182.44.80]:51286 "EHLO
	kiruna.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754341Ab3AXKzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 05:55:54 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <arnd@arndb.de>, Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH v3 34/71] ARC: [plat-arcfpga]: Enabling DeviceTree for Angel4 board
Date: Thu, 24 Jan 2013 16:20:30 +0530
Message-ID: <1359024639-21915-17-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1359024639-21915-1-git-send-email-vgupta@synopsys.com>
References: <1359024639-21915-1-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.197.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* arc-uart platform device now populated dynamically, using
  of_platform_populate() - applies to any other device whatsoever.

* uart in turn requires incore arc-intc to be also present in DT

* A irq-domain needs to be instantiated for IRQ requests by DT probed
  device (e.g. arc-uart)

TODO: switch over to linear irq domain once all devs have been
      transitioned to DT

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Arnd Bergmann <arnd@arndb.de>
---
 .../devicetree/bindings/arc/interrupts.txt         |   24 +++++
 arch/arc/boot/dts/Makefile                         |    2 +-
 arch/arc/boot/dts/angel4.dts                       |   55 +++++++++++
 arch/arc/boot/dts/skeleton.dtsi                    |   12 +++
 arch/arc/kernel/irq.c                              |   38 +++++++-
 arch/arc/plat-arcfpga/platform.c                   |   97 +++++++++----------
 6 files changed, 170 insertions(+), 58 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arc/interrupts.txt
 create mode 100644 arch/arc/boot/dts/angel4.dts

diff --git a/Documentation/devicetree/bindings/arc/interrupts.txt b/Documentation/devicetree/bindings/arc/interrupts.txt
new file mode 100644
index 0000000..9a5d562
--- /dev/null
+++ b/Documentation/devicetree/bindings/arc/interrupts.txt
@@ -0,0 +1,24 @@
+* ARC700 incore Interrupt Controller
+
+  The core interrupt controller provides 32 prioritised interrupts (2 levels)
+  to ARC700 core.
+
+Properties:
+
+- compatible: "snps,arc700-intc"
+- interrupt-controller: This is an interrupt controller.
+- #interrupt-cells: Must be <1>.
+
+  Single Cell "interrupts" property of a device specifies the IRQ number
+  between 0 to 31
+
+  intc accessed via the special ARC AUX register interface, hence "reg" property
+  is not specified.
+
+Example:
+
+	intc: interrupt-controller {
+		compatible = "snps,arc700-intc";
+		interrupt-controller;
+		#interrupt-cells = <1>;
+	};
diff --git a/arch/arc/boot/dts/Makefile b/arch/arc/boot/dts/Makefile
index 4a972a3..dfda14e 100644
--- a/arch/arc/boot/dts/Makefile
+++ b/arch/arc/boot/dts/Makefile
@@ -1,7 +1,7 @@
 ifeq ($(CONFIG_OF),y)
 
 # Built-in dtb
-builtindtb-y		:= skeleton
+builtindtb-y		:= angel4
 
 ifneq ($(CONFIG_ARC_BUILTIN_DTB_NAME),"")
 	builtindtb-y	:= $(CONFIG_ARC_BUILTIN_DTB_NAME)
diff --git a/arch/arc/boot/dts/angel4.dts b/arch/arc/boot/dts/angel4.dts
new file mode 100644
index 0000000..4c188d5
--- /dev/null
+++ b/arch/arc/boot/dts/angel4.dts
@@ -0,0 +1,55 @@
+/*
+ * Copyright (C) 2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+/dts-v1/;
+
+/include/ "skeleton.dtsi"
+
+/ {
+	compatible = "snps,arc-angel4";
+	clock-frequency = <80000000>;	/* 80 MHZ */
+	#address-cells = <1>;
+	#size-cells = <1>;
+	interrupt-parent = <&intc>;
+
+	chosen {
+		bootargs = "console=ttyARC0,115200n8";
+	};
+
+	aliases {
+		serial0 = &arcuart0;
+	};
+
+	memory {
+		device_type = "memory";
+		reg = <0x00000000 0x10000000>;	/* 256M */
+	};
+
+	fpga {
+		compatible = "simple-bus";
+		#address-cells = <1>;
+		#size-cells = <1>;
+
+		/* child and parent address space 1:1 mapped */
+		ranges;
+
+		intc: interrupt-controller {
+			compatible = "snps,arc700-intc";
+			interrupt-controller;
+			#interrupt-cells = <1>;
+		};
+
+		arcuart0: serial@c0fc1000 {
+			compatible = "snps,arc-uart";
+			reg = <0xc0fc1000 0x100>;
+			interrupts = <5>;
+			clock-frequency = <80000000>;
+			baud = <115200>;
+			status = "okay";
+		};
+	};
+};
diff --git a/arch/arc/boot/dts/skeleton.dtsi b/arch/arc/boot/dts/skeleton.dtsi
index eb8b773..a870bdd 100644
--- a/arch/arc/boot/dts/skeleton.dtsi
+++ b/arch/arc/boot/dts/skeleton.dtsi
@@ -18,6 +18,18 @@
 	#size-cells = <1>;
 	chosen { };
 	aliases { };
+
+	cpus {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		cpu@0 {
+			device_type = "cpu";
+			compatible = "snps,arc770d";
+			reg = <0>;
+		};
+	};
+
 	memory {
 		device_type = "memory";
 		reg = <0x00000000 0x10000000>;	/* 256M */
diff --git a/arch/arc/kernel/irq.c b/arch/arc/kernel/irq.c
index 2f399eb..3c18e66 100644
--- a/arch/arc/kernel/irq.c
+++ b/arch/arc/kernel/irq.c
@@ -9,6 +9,8 @@
 
 #include <linux/interrupt.h>
 #include <linux/module.h>
+#include <linux/of.h>
+#include <linux/irqdomain.h>
 #include <asm/sections.h>
 #include <asm/irq.h>
 
@@ -59,16 +61,40 @@ static struct irq_chip onchip_intc = {
 	.irq_unmask	= arc_unmask_irq,
 };
 
+static int arc_intc_domain_map(struct irq_domain *d, unsigned int irq,
+				irq_hw_number_t hw)
+{
+	if (irq == TIMER0_IRQ)
+		irq_set_chip_and_handler(irq, &onchip_intc, handle_percpu_irq);
+	else
+		irq_set_chip_and_handler(irq, &onchip_intc, handle_level_irq);
+
+	return 0;
+}
+
+static const struct irq_domain_ops arc_intc_domain_ops = {
+	.xlate = irq_domain_xlate_onecell,
+	.map = arc_intc_domain_map,
+};
+
+static struct irq_domain *root_domain;
+
 void __init init_onchip_IRQ(void)
 {
-	int i;
+	struct device_node *intc = NULL;
+
+	intc = of_find_compatible_node(NULL, NULL, "snps,arc700-intc");
+	if(!intc)
+		panic("DeviceTree Missing incore intc\n");
+
+	root_domain = irq_domain_add_legacy(intc, NR_IRQS, 0, 0,
+					    &arc_intc_domain_ops, NULL);
 
-	for (i = 0; i < NR_IRQS; i++)
-		irq_set_chip_and_handler(i, &onchip_intc, handle_level_irq);
+	if (!root_domain)
+		panic("root irq domain not avail\n");
 
-#ifdef CONFIG_SMP
-	irq_set_chip_and_handler(TIMER0_IRQ, &onchip_intc, handle_percpu_irq);
-#endif
+	/* with this we don't need to export root_domain */
+	irq_set_default_host(root_domain);
 }
 
 /*
diff --git a/arch/arc/plat-arcfpga/platform.c b/arch/arc/plat-arcfpga/platform.c
index 5388b31..33bcac8 100644
--- a/arch/arc/plat-arcfpga/platform.c
+++ b/arch/arc/plat-arcfpga/platform.c
@@ -13,6 +13,7 @@
 #include <linux/device.h>
 #include <linux/platform_device.h>
 #include <linux/console.h>
+#include <linux/of_platform.h>
 #include <asm/setup.h>
 #include <asm/irq.h>
 #include <asm/clk.h>
@@ -20,58 +21,56 @@
 
 /*----------------------- Platform Devices -----------------------------*/
 
-#if defined(CONFIG_SERIAL_ARC) || defined(CONFIG_SERIAL_ARC_MODULE)
-
 static unsigned long arc_uart_info[] = {
-	CONFIG_ARC_SERIAL_BAUD,	/* uart->baud */
-	-1,			/* uart->port.uartclk */
-	-1,			/* uart->is_emulated (runtime @running_on_hw) */
+	0,	/* uart->is_emulated (runtime @running_on_hw) */
+	0,	/* uart->port.uartclk */
+	0,	/* uart->baud */
 	0
 };
 
-#define ARC_UART_DEV(n)					\
-							\
-static struct resource arc_uart##n##_res[] = {		\
-	{						\
-		.start = UART##n##_BASE,			\
-		.end   = UART##n##_BASE + 0xFF,		\
-		.flags = IORESOURCE_MEM,		\
-	},						\
-	{						\
-		.start = UART##n##_IRQ,			\
-		.end   = UART##n##_IRQ,			\
-		.flags = IORESOURCE_IRQ,		\
-	},						\
-};							\
-							\
-static struct platform_device arc_uart##n##_dev = {	\
-	.name = "arc-uart",				\
-	.id = n,					\
-	.num_resources = ARRAY_SIZE(arc_uart##n##_res),	\
-	.resource = arc_uart##n##_res,			\
-	.dev = {					\
-		.platform_data = &arc_uart_info,	\
-	},						\
-}
+#if defined(CONFIG_SERIAL_ARC_CONSOLE)
+/*
+ * static platform data - but only for early serial
+ * TBD: derive this from a special DT node
+ */
+static struct resource arc_uart0_res[] = {
+	{
+		.start = UART0_BASE,
+		.end   = UART0_BASE + 0xFF,
+		.flags = IORESOURCE_MEM,
+	},
+	{
+		.start = UART0_IRQ,
+		.end   = UART0_IRQ,
+		.flags = IORESOURCE_IRQ,
+	},
+};
 
-ARC_UART_DEV(0);
-#if CONFIG_SERIAL_ARC_NR_PORTS > 1
-ARC_UART_DEV(1);
-#endif
+static struct platform_device arc_uart0_dev = {
+	.name = "arc-uart",
+	.id = 0,
+	.num_resources = ARRAY_SIZE(arc_uart0_res),
+	.resource = arc_uart0_res,
+	.dev = {
+		.platform_data = &arc_uart_info,
+	},
+};
 
 static struct platform_device *fpga_early_devs[] __initdata = {
-#if defined(CONFIG_SERIAL_ARC_CONSOLE)
 	&arc_uart0_dev,
-#endif
 };
+#endif
 
 static void arc_fpga_serial_init(void)
 {
+	/* To let driver workaround ISS bug: baudh Reg can't be set to 0 */
+	arc_uart_info[0] = !running_on_hw;
+
 	arc_uart_info[1] = arc_get_core_freq();
 
-	/* To let driver workaround ISS bug: baudh Reg can't be set to 0 */
-	arc_uart_info[2] = !running_on_hw;
+	arc_uart_info[2] = CONFIG_ARC_SERIAL_BAUD;
 
+#if defined(CONFIG_SERIAL_ARC_CONSOLE)
 	early_platform_add_devices(fpga_early_devs,
 				   ARRAY_SIZE(fpga_early_devs));
 
@@ -97,16 +96,9 @@ static void arc_fpga_serial_init(void)
 	 * otherwise the early console never gets a chance to run.
 	 */
 	add_preferred_console("ttyARC", 0, "115200");
+#endif
 }
 
-#else
-
-static void arc_fpga_serial_init(void)
-{
-}
-
-#endif	/* CONFIG_SERIAL_ARC */
-
 /*
  * Early Platform Initialization called from setup_arch()
  */
@@ -117,20 +109,23 @@ void __init arc_platform_early_init(void)
 	arc_fpga_serial_init();
 }
 
-static struct platform_device *fpga_devs[] __initdata = {
+static struct of_dev_auxdata plat_auxdata_lookup[] __initdata = {
 #if defined(CONFIG_SERIAL_ARC) || defined(CONFIG_SERIAL_ARC_MODULE)
-	&arc_uart0_dev,
-#if CONFIG_SERIAL_ARC_NR_PORTS > 1
-	&arc_uart1_dev,
-#endif
+	OF_DEV_AUXDATA("snps,arc-uart", UART0_BASE, "arc-uart", arc_uart_info),
 #endif
+	{}
 };
 
 int __init fpga_plat_init(void)
 {
 	pr_info("[plat-arcfpga]: registering device resources\n");
 
-	platform_add_devices(fpga_devs, ARRAY_SIZE(fpga_devs));
+	/*
+	 * Traverses flattened DeviceTree - registering platform devices
+	 * complete with their resources
+	 */
+	of_platform_populate(NULL, of_default_bus_match_table,
+			     plat_auxdata_lookup, NULL);
 
 	return 0;
 }
-- 
1.7.4.1

