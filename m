Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934843Ab3E1Qfp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 12:35:45 -0400
Received: from mail.abilis.ch ([195.70.19.74]:17337 "EHLO mail.abilis.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934600Ab3E1Qfn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 12:35:43 -0400
From: Christian Ruppert <christian.ruppert@abilis.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Christian Ruppert <christian.ruppert@abilis.com>,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>
Subject: [PATCH V2] irqchip: Add TB10x interrupt controller driver
Date: Tue, 28 May 2013 18:34:07 +0200
Message-Id: <1369758847-5642-1-git-send-email-christian.ruppert@abilis.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <alpine.LFD.2.02.1305271414270.4220@ionos>
References: <alpine.LFD.2.02.1305271414270.4220@ionos>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The SOC interrupt controller driver for the Abilis Systems TB10x series of
SOCs based on ARC700 CPUs.

Signed-off-by: Christian Ruppert <christian.ruppert@abilis.com>
Signed-off-by: Pierrick Hascoet <pierrick.hascoet@abilis.com>
---
 .../interrupt-controller/abilis,tb10x_ictl.txt     |   38 ++++
 arch/arc/boot/dts/abilis_tb100.dtsi                |   32 ++--
 arch/arc/boot/dts/abilis_tb101.dtsi                |   32 ++--
 arch/arc/boot/dts/abilis_tb10x.dtsi                |   30 ++--
 arch/arc/plat-tb10x/Kconfig                        |    1 +
 drivers/irqchip/Kconfig                            |    5 +
 drivers/irqchip/Makefile                           |    1 +
 drivers/irqchip/irq-tb10x.c                        |  205 ++++++++++++++++++++
 8 files changed, 291 insertions(+), 53 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/interrupt-controller/abilis,tb10x_ictl.txt
 create mode 100644 drivers/irqchip/irq-tb10x.c

diff --git a/Documentation/devicetree/bindings/interrupt-controller/abilis,tb10x_ictl.txt b/Documentation/devicetree/bindings/interrupt-controller/abilis,tb10x_ictl.txt
new file mode 100644
index 0000000..bc292cd
--- /dev/null
+++ b/Documentation/devicetree/bindings/interrupt-controller/abilis,tb10x_ictl.txt
@@ -0,0 +1,38 @@
+TB10x Top Level Interrupt Controller
+====================================
+
+The Abilis TB10x SOC contains a custom interrupt controller. It performs
+one-to-one mapping of external interrupt sources to CPU interrupts and
+provides support for reconfigurable trigger modes.
+
+Required properties
+-------------------
+
+- compatible: Should be "abilis,tb10x_ictl"
+- reg: specifies physical base address and size of register range.
+- interrupt-congroller: Identifies the node as an interrupt controller.
+- #interrupt cells: Specifies the number of cells used to encode an interrupt
+  source connected to this controller. The value shall be 2.
+- interrupt-parent: Specifies the parent interrupt controller.
+- interrupts: Specifies the list of interrupt lines which are handled by
+  the interrupt controller in the parent controller's notation. Interrupts
+  are mapped one-to-one to parent interrupts.
+
+Example
+-------
+
+intc: interrupt-controller {	/* Parent interrupt controller */
+	interrupt-controller;
+	#interrupt-cells = <1>;	/* For example below */
+	/* ... */
+};
+
+tb10x_ictl: pic@2000 {		/* TB10x interrupt controller */
+	compatible = "abilis,tb10x_ictl";
+	reg = <0x2000 0x20>;
+	interrupt-controller;
+	#interrupt-cells = <2>;
+	interrupt-parent = <&intc>;
+	interrupts = <5 6 7 8 9 10 11 12 13 14 15 16 17 18 19
+			20 21 22 23 24 25 26 27 28 29 30 31>;
+};
diff --git a/arch/arc/boot/dts/abilis_tb100.dtsi b/arch/arc/boot/dts/abilis_tb100.dtsi
index 941ad11..d9f8249 100644
--- a/arch/arc/boot/dts/abilis_tb100.dtsi
+++ b/arch/arc/boot/dts/abilis_tb100.dtsi
@@ -21,10 +21,6 @@
 
 /include/ "abilis_tb10x.dtsi"
 
-/* interrupt specifiers
- * --------------------
- * 0: rising, 1: low, 2: high, 3: falling,
- */
 
 / {
 	clock-frequency		= <500000000>;	/* 500 MHZ */
@@ -173,7 +169,7 @@
 			interrupt-controller;
 			#interrupt-cells = <1>;
 			interrupt-parent = <&tb10x_ictl>;
-			interrupts = <27 1>;
+			interrupts = <27 2>;
 			reg = <0xFF140000 0x1000>;
 			gpio-controller;
 			#gpio-cells = <1>;
@@ -185,7 +181,7 @@
 			interrupt-controller;
 			#interrupt-cells = <1>;
 			interrupt-parent = <&tb10x_ictl>;
-			interrupts = <27 1>;
+			interrupts = <27 2>;
 			reg = <0xFF141000 0x1000>;
 			gpio-controller;
 			#gpio-cells = <1>;
@@ -197,7 +193,7 @@
 			interrupt-controller;
 			#interrupt-cells = <1>;
 			interrupt-parent = <&tb10x_ictl>;
-			interrupts = <27 1>;
+			interrupts = <27 2>;
 			reg = <0xFF142000 0x1000>;
 			gpio-controller;
 			#gpio-cells = <1>;
@@ -209,7 +205,7 @@
 			interrupt-controller;
 			#interrupt-cells = <1>;
 			interrupt-parent = <&tb10x_ictl>;
-			interrupts = <27 1>;
+			interrupts = <27 2>;
 			reg = <0xFF143000 0x1000>;
 			gpio-controller;
 			#gpio-cells = <1>;
@@ -221,7 +217,7 @@
 			interrupt-controller;
 			#interrupt-cells = <1>;
 			interrupt-parent = <&tb10x_ictl>;
-			interrupts = <27 1>;
+			interrupts = <27 2>;
 			reg = <0xFF144000 0x1000>;
 			gpio-controller;
 			#gpio-cells = <1>;
@@ -233,7 +229,7 @@
 			interrupt-controller;
 			#interrupt-cells = <1>;
 			interrupt-parent = <&tb10x_ictl>;
-			interrupts = <27 1>;
+			interrupts = <27 2>;
 			reg = <0xFF145000 0x1000>;
 			gpio-controller;
 			#gpio-cells = <1>;
@@ -245,7 +241,7 @@
 			interrupt-controller;
 			#interrupt-cells = <1>;
 			interrupt-parent = <&tb10x_ictl>;
-			interrupts = <27 1>;
+			interrupts = <27 2>;
 			reg = <0xFF146000 0x1000>;
 			gpio-controller;
 			#gpio-cells = <1>;
@@ -257,7 +253,7 @@
 			interrupt-controller;
 			#interrupt-cells = <1>;
 			interrupt-parent = <&tb10x_ictl>;
-			interrupts = <27 1>;
+			interrupts = <27 2>;
 			reg = <0xFF147000 0x1000>;
 			gpio-controller;
 			#gpio-cells = <1>;
@@ -269,7 +265,7 @@
 			interrupt-controller;
 			#interrupt-cells = <1>;
 			interrupt-parent = <&tb10x_ictl>;
-			interrupts = <27 1>;
+			interrupts = <27 2>;
 			reg = <0xFF148000 0x1000>;
 			gpio-controller;
 			#gpio-cells = <1>;
@@ -281,7 +277,7 @@
 			interrupt-controller;
 			#interrupt-cells = <1>;
 			interrupt-parent = <&tb10x_ictl>;
-			interrupts = <27 1>;
+			interrupts = <27 2>;
 			reg = <0xFF149000 0x1000>;
 			gpio-controller;
 			#gpio-cells = <1>;
@@ -293,7 +289,7 @@
 			interrupt-controller;
 			#interrupt-cells = <1>;
 			interrupt-parent = <&tb10x_ictl>;
-			interrupts = <27 1>;
+			interrupts = <27 2>;
 			reg = <0xFF14A000 0x1000>;
 			gpio-controller;
 			#gpio-cells = <1>;
@@ -305,7 +301,7 @@
 			interrupt-controller;
 			#interrupt-cells = <1>;
 			interrupt-parent = <&tb10x_ictl>;
-			interrupts = <27 1>;
+			interrupts = <27 2>;
 			reg = <0xFF14B000 0x1000>;
 			gpio-controller;
 			#gpio-cells = <1>;
@@ -317,7 +313,7 @@
 			interrupt-controller;
 			#interrupt-cells = <1>;
 			interrupt-parent = <&tb10x_ictl>;
-			interrupts = <27 1>;
+			interrupts = <27 2>;
 			reg = <0xFF14C000 0x1000>;
 			gpio-controller;
 			#gpio-cells = <1>;
@@ -329,7 +325,7 @@
 			interrupt-controller;
 			#interrupt-cells = <1>;
 			interrupt-parent = <&tb10x_ictl>;
-			interrupts = <27 1>;
+			interrupts = <27 2>;
 			reg = <0xFF14D000 0x1000>;
 			gpio-controller;
 			#gpio-cells = <1>;
diff --git a/arch/arc/boot/dts/abilis_tb101.dtsi b/arch/arc/boot/dts/abilis_tb101.dtsi
index fd25c21..da8ca79 100644
--- a/arch/arc/boot/dts/abilis_tb101.dtsi
+++ b/arch/arc/boot/dts/abilis_tb101.dtsi
@@ -21,10 +21,6 @@
 
 /include/ "abilis_tb10x.dtsi"
 
-/* interrupt specifiers
- * --------------------
- * 0: rising, 1: low, 2: high, 3: falling,
- */
 
 / {
 	clock-frequency		= <500000000>;	/* 500 MHZ */
@@ -182,7 +178,7 @@
 			interrupt-controller;
 			#interrupt-cells = <1>;
 			interrupt-parent = <&tb10x_ictl>;
-			interrupts = <27 1>;
+			interrupts = <27 2>;
 			reg = <0xFF140000 0x1000>;
 			gpio-controller;
 			#gpio-cells = <1>;
@@ -194,7 +190,7 @@
 			interrupt-controller;
 			#interrupt-cells = <1>;
 			interrupt-parent = <&tb10x_ictl>;
-			interrupts = <27 1>;
+			interrupts = <27 2>;
 			reg = <0xFF141000 0x1000>;
 			gpio-controller;
 			#gpio-cells = <1>;
@@ -206,7 +202,7 @@
 			interrupt-controller;
 			#interrupt-cells = <1>;
 			interrupt-parent = <&tb10x_ictl>;
-			interrupts = <27 1>;
+			interrupts = <27 2>;
 			reg = <0xFF142000 0x1000>;
 			gpio-controller;
 			#gpio-cells = <1>;
@@ -218,7 +214,7 @@
 			interrupt-controller;
 			#interrupt-cells = <1>;
 			interrupt-parent = <&tb10x_ictl>;
-			interrupts = <27 1>;
+			interrupts = <27 2>;
 			reg = <0xFF143000 0x1000>;
 			gpio-controller;
 			#gpio-cells = <1>;
@@ -230,7 +226,7 @@
 			interrupt-controller;
 			#interrupt-cells = <1>;
 			interrupt-parent = <&tb10x_ictl>;
-			interrupts = <27 1>;
+			interrupts = <27 2>;
 			reg = <0xFF144000 0x1000>;
 			gpio-controller;
 			#gpio-cells = <1>;
@@ -242,7 +238,7 @@
 			interrupt-controller;
 			#interrupt-cells = <1>;
 			interrupt-parent = <&tb10x_ictl>;
-			interrupts = <27 1>;
+			interrupts = <27 2>;
 			reg = <0xFF145000 0x1000>;
 			gpio-controller;
 			#gpio-cells = <1>;
@@ -254,7 +250,7 @@
 			interrupt-controller;
 			#interrupt-cells = <1>;
 			interrupt-parent = <&tb10x_ictl>;
-			interrupts = <27 1>;
+			interrupts = <27 2>;
 			reg = <0xFF146000 0x1000>;
 			gpio-controller;
 			#gpio-cells = <1>;
@@ -266,7 +262,7 @@
 			interrupt-controller;
 			#interrupt-cells = <1>;
 			interrupt-parent = <&tb10x_ictl>;
-			interrupts = <27 1>;
+			interrupts = <27 2>;
 			reg = <0xFF147000 0x1000>;
 			gpio-controller;
 			#gpio-cells = <1>;
@@ -278,7 +274,7 @@
 			interrupt-controller;
 			#interrupt-cells = <1>;
 			interrupt-parent = <&tb10x_ictl>;
-			interrupts = <27 1>;
+			interrupts = <27 2>;
 			reg = <0xFF148000 0x1000>;
 			gpio-controller;
 			#gpio-cells = <1>;
@@ -290,7 +286,7 @@
 			interrupt-controller;
 			#interrupt-cells = <1>;
 			interrupt-parent = <&tb10x_ictl>;
-			interrupts = <27 1>;
+			interrupts = <27 2>;
 			reg = <0xFF149000 0x1000>;
 			gpio-controller;
 			#gpio-cells = <1>;
@@ -302,7 +298,7 @@
 			interrupt-controller;
 			#interrupt-cells = <1>;
 			interrupt-parent = <&tb10x_ictl>;
-			interrupts = <27 1>;
+			interrupts = <27 2>;
 			reg = <0xFF14A000 0x1000>;
 			gpio-controller;
 			#gpio-cells = <1>;
@@ -314,7 +310,7 @@
 			interrupt-controller;
 			#interrupt-cells = <1>;
 			interrupt-parent = <&tb10x_ictl>;
-			interrupts = <27 1>;
+			interrupts = <27 2>;
 			reg = <0xFF14B000 0x1000>;
 			gpio-controller;
 			#gpio-cells = <1>;
@@ -326,7 +322,7 @@
 			interrupt-controller;
 			#interrupt-cells = <1>;
 			interrupt-parent = <&tb10x_ictl>;
-			interrupts = <27 1>;
+			interrupts = <27 2>;
 			reg = <0xFF14C000 0x1000>;
 			gpio-controller;
 			#gpio-cells = <1>;
@@ -338,7 +334,7 @@
 			interrupt-controller;
 			#interrupt-cells = <1>;
 			interrupt-parent = <&tb10x_ictl>;
-			interrupts = <27 1>;
+			interrupts = <27 2>;
 			reg = <0xFF14D000 0x1000>;
 			gpio-controller;
 			#gpio-cells = <1>;
diff --git a/arch/arc/boot/dts/abilis_tb10x.dtsi b/arch/arc/boot/dts/abilis_tb10x.dtsi
index b97e305..f73e705 100644
--- a/arch/arc/boot/dts/abilis_tb10x.dtsi
+++ b/arch/arc/boot/dts/abilis_tb10x.dtsi
@@ -19,10 +19,6 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
  */
 
-/* interrupt specifiers
- * --------------------
- * 0: rising, 1: low, 2: high, 3: falling,
- */
 
 / {
 	compatible		= "abilis,arc-tb10x";
@@ -91,7 +87,7 @@
 			compatible = "snps,dw-apb-uart";
 			reg = <0xFF100000 0x100>;
 			clock-frequency = <166666666>;
-			interrupts = <25 1>;
+			interrupts = <25 8>;
 			reg-shift = <2>;
 			reg-io-width = <4>;
 			interrupt-parent = <&tb10x_ictl>;
@@ -100,7 +96,7 @@
 			compatible = "snps,dwmac-3.70a","snps,dwmac";
 			reg = <0xFE100000 0x1058>;
 			interrupt-parent = <&tb10x_ictl>;
-			interrupts = <6 1>;
+			interrupts = <6 8>;
 			interrupt-names = "macirq";
 			clocks = <&ahb_clk>;
 			clock-names = "stmmaceth";
@@ -109,7 +105,7 @@
 			compatible = "snps,dma-spear1340";
 			reg = <0xFE000000 0x400>;
 			interrupt-parent = <&tb10x_ictl>;
-			interrupts = <14 1>;
+			interrupts = <14 8>;
 			dma-channels = <6>;
 			dma-requests = <0>;
 			dma-masters = <1>;
@@ -128,7 +124,7 @@
 			compatible = "snps,designware-i2c";
 			reg = <0xFF120000 0x1000>;
 			interrupt-parent = <&tb10x_ictl>;
-			interrupts = <12 1>;
+			interrupts = <12 8>;
 			clocks = <&ahb_clk>;
 		};
 		i2c1: i2c@FF121000 {
@@ -137,7 +133,7 @@
 			compatible = "snps,designware-i2c";
 			reg = <0xFF121000 0x1000>;
 			interrupt-parent = <&tb10x_ictl>;
-			interrupts = <12 1>;
+			interrupts = <12 8>;
 			clocks = <&ahb_clk>;
 		};
 		i2c2: i2c@FF122000 {
@@ -146,7 +142,7 @@
 			compatible = "snps,designware-i2c";
 			reg = <0xFF122000 0x1000>;
 			interrupt-parent = <&tb10x_ictl>;
-			interrupts = <12 1>;
+			interrupts = <12 8>;
 			clocks = <&ahb_clk>;
 		};
 		i2c3: i2c@FF123000 {
@@ -155,7 +151,7 @@
 			compatible = "snps,designware-i2c";
 			reg = <0xFF123000 0x1000>;
 			interrupt-parent = <&tb10x_ictl>;
-			interrupts = <12 1>;
+			interrupts = <12 8>;
 			clocks = <&ahb_clk>;
 		};
 		i2c4: i2c@FF124000 {
@@ -164,7 +160,7 @@
 			compatible = "snps,designware-i2c";
 			reg = <0xFF124000 0x1000>;
 			interrupt-parent = <&tb10x_ictl>;
-			interrupts = <12 1>;
+			interrupts = <12 8>;
 			clocks = <&ahb_clk>;
 		};
 
@@ -176,7 +172,7 @@
 			num-cs = <1>;
 			reg = <0xFE010000 0x20>;
 			interrupt-parent = <&tb10x_ictl>;
-			interrupts = <26 1>;
+			interrupts = <26 8>;
 			clocks = <&ahb_clk>;
 		};
 		spi1: spi@0xFE011000 {
@@ -187,7 +183,7 @@
 			num-cs = <2>;
 			reg = <0xFE011000 0x20>;
 			interrupt-parent = <&tb10x_ictl>;
-			interrupts = <10 1>;
+			interrupts = <10 8>;
 			clocks = <&ahb_clk>;
 		};
 
@@ -195,7 +191,7 @@
 			compatible = "abilis,tb100-tsm";
 			reg = <0xff316000 0x400>;
 			interrupt-parent = <&tb10x_ictl>;
-			interrupts = <17 1>;
+			interrupts = <17 8>;
 			output-clkdiv = <4>;
 			global-packet-delay = <0x21>;
 			port-packet-delay = <0>;
@@ -213,7 +209,7 @@
 					"cpuctrl",
 					"a6it_int_force";
 			interrupt-parent = <&tb10x_ictl>;
-			interrupts = <20 1>, <19 1>;
+			interrupts = <20 2>, <19 2>;
 			interrupt-names = "cmd_irq", "event_irq";
 		};
 		tb10x_mdsc0: tb10x-mdscr@FF300000 {
@@ -239,7 +235,7 @@
 			compatible = "abilis,tb100-wfb";
 			reg = <0xff319000 0x1000>;
 			interrupt-parent = <&tb10x_ictl>;
-			interrupts = <16 1>;
+			interrupts = <16 8>;
 		};
 	};
 };
diff --git a/arch/arc/plat-tb10x/Kconfig b/arch/arc/plat-tb10x/Kconfig
index 1d34521..1ab386b 100644
--- a/arch/arc/plat-tb10x/Kconfig
+++ b/arch/arc/plat-tb10x/Kconfig
@@ -22,6 +22,7 @@ menuconfig ARC_PLAT_TB10X
 	select PINCTRL
 	select PINMUX
 	select ARCH_REQUIRE_GPIOLIB
+	select TB10X_IRQC
 	help
 	  Support for platforms based on the TB10x home media gateway SOC by
 	  Abilis Systems. TB10x is based on the ARC700 CPU architecture.
diff --git a/drivers/irqchip/Kconfig b/drivers/irqchip/Kconfig
index 4a33351..8843f21 100644
--- a/drivers/irqchip/Kconfig
+++ b/drivers/irqchip/Kconfig
@@ -33,6 +33,11 @@ config RENESAS_IRQC
 	bool
 	select IRQ_DOMAIN
 
+config TB10X_IRQC
+	bool
+	select IRQ_DOMAIN
+	select GENERIC_IRQ_CHIP
+
 config VERSATILE_FPGA_IRQ
 	bool
 	select IRQ_DOMAIN
diff --git a/drivers/irqchip/Makefile b/drivers/irqchip/Makefile
index cda4cb5..b45e4a4 100644
--- a/drivers/irqchip/Makefile
+++ b/drivers/irqchip/Makefile
@@ -9,6 +9,7 @@ obj-$(CONFIG_METAG)			+= irq-metag-ext.o
 obj-$(CONFIG_METAG_PERFCOUNTER_IRQS)	+= irq-metag.o
 obj-$(CONFIG_ARCH_SUNXI)		+= irq-sun4i.o
 obj-$(CONFIG_ARCH_SPEAR3XX)		+= spear-shirq.o
+obj-$(CONFIG_TB10X_IRQC)		+= irq-tb10x.o
 obj-$(CONFIG_ARM_GIC)			+= irq-gic.o
 obj-$(CONFIG_ARM_VIC)			+= irq-vic.o
 obj-$(CONFIG_SIRF_IRQ)			+= irq-sirfsoc.o
diff --git a/drivers/irqchip/irq-tb10x.c b/drivers/irqchip/irq-tb10x.c
new file mode 100644
index 0000000..06f7ce2
--- /dev/null
+++ b/drivers/irqchip/irq-tb10x.c
@@ -0,0 +1,205 @@
+/*
+ * Abilis Systems interrupt controller driver
+ *
+ * Copyright (C) Abilis Systems 2012
+ *
+ * Author: Christian Ruppert <christian.ruppert@abilis.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
+ */
+
+#include <linux/interrupt.h>
+#include <linux/irqdomain.h>
+#include <linux/irq.h>
+#include <linux/of_irq.h>
+#include <linux/of_address.h>
+#include <linux/of_platform.h>
+#include <linux/io.h>
+#include <linux/slab.h>
+#include <linux/bitops.h>
+#include "irqchip.h"
+
+#define AB_IRQCTL_INT_ENABLE   0x00
+#define AB_IRQCTL_INT_STATUS   0x04
+#define AB_IRQCTL_SRC_MODE     0x08
+#define AB_IRQCTL_SRC_POLARITY 0x0C
+#define AB_IRQCTL_INT_MODE     0x10
+#define AB_IRQCTL_INT_POLARITY 0x14
+#define AB_IRQCTL_INT_FORCE    0x18
+
+#define AB_IRQCTL_MAXIRQ       32
+#define TB10X_IRQCHIP_BASE     NR_CPU_IRQS
+
+static inline void ab_irqctl_writereg(struct irq_chip_generic *gc, u32 reg,
+	u32 val)
+{
+	irq_reg_writel(val, (u32 *)(gc->reg_base + reg));
+}
+
+static inline u32 ab_irqctl_readreg(struct irq_chip_generic *gc, u32 reg)
+{
+	return irq_reg_readl((u32 *)(gc->reg_base + reg));
+}
+
+static int tb10x_irq_set_type(struct irq_data *data, unsigned int flow_type)
+{
+	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(data);
+	unsigned int irq = data->irq;
+	unsigned int hwirq = irqd_to_hwirq(data);
+	uint32_t im, mod, pol;
+
+	im = BIT(hwirq);
+
+	irq_gc_lock(gc);
+
+	mod = ab_irqctl_readreg(gc, AB_IRQCTL_SRC_MODE) | im;
+	pol = ab_irqctl_readreg(gc, AB_IRQCTL_SRC_POLARITY) | im;
+
+	switch (flow_type & IRQF_TRIGGER_MASK) {
+	case IRQ_TYPE_EDGE_FALLING:
+		pol ^= im;
+		break;
+	case IRQ_TYPE_LEVEL_HIGH:
+		mod ^= im;
+		break;
+	case IRQ_TYPE_NONE:
+		flow_type = IRQ_TYPE_LEVEL_LOW;
+	case IRQ_TYPE_LEVEL_LOW:
+		mod ^= im;
+		pol ^= im;
+		break;
+	case IRQ_TYPE_EDGE_RISING:
+		break;
+	default:
+		irq_gc_unlock(gc);
+		pr_err("%s: Cannot assign multiple trigger modes to IRQ %d.\n",
+			__func__, irq);
+		return -EBADR;
+	}
+
+	irqd_set_trigger_type(data, flow_type);
+	irq_setup_alt_chip(data, flow_type);
+
+	ab_irqctl_writereg(gc, AB_IRQCTL_SRC_MODE, mod);
+	ab_irqctl_writereg(gc, AB_IRQCTL_SRC_POLARITY, pol);
+	ab_irqctl_writereg(gc, AB_IRQCTL_INT_STATUS, im);
+
+	irq_gc_unlock(gc);
+
+	return IRQ_SET_MASK_OK;
+}
+
+static struct irq_domain_ops irq_tb10x_domain_ops = {
+	.xlate	= irq_domain_xlate_twocell,
+};
+
+static void tb10x_irq_cascade(unsigned int irq, struct irq_desc *desc)
+{
+	struct irq_domain *domain = irq_desc_get_handler_data(desc);
+
+	generic_handle_irq(irq_find_mapping(domain, irq));
+}
+
+static int __init of_tb10x_init_irq(struct device_node *ictl,
+					struct device_node *parent)
+{
+	int i, ret, nrirqs = of_irq_count(ictl);
+	u32 mask = 0;
+	struct resource mem;
+	struct irq_chip_generic *gc;
+	struct irq_domain *domain;
+	void __iomem *reg_base;
+
+	if (of_address_to_resource(ictl, 0, &mem)) {
+		pr_err("%s: No registers declared in DeviceTree.\n",
+			ictl->name);
+		return -EINVAL;
+	}
+
+	if (!request_mem_region(mem.start, resource_size(&mem),
+		ictl->name)) {
+		pr_err("%s: Request mem region failed.\n", ictl->name);
+		return -EBUSY;
+	}
+
+	reg_base = ioremap(mem.start, resource_size(&mem));
+	if (!reg_base) {
+		ret = -EBUSY;
+		pr_err("%s: ioremap failed.\n", ictl->name);
+		goto ioremap_fail;
+	}
+
+	gc = irq_alloc_generic_chip(ictl->name, 2, TB10X_IRQCHIP_BASE,
+				reg_base, handle_level_irq);
+	if (!gc) {
+		ret = -ENOMEM;
+		pr_err("%s: Could not allocate generic interrupt chip.\n",
+			ictl->name);
+		goto gc_alloc_fail;
+	}
+
+	gc->chip_types[0].type               = IRQ_TYPE_LEVEL_MASK;
+	gc->chip_types[0].chip.irq_mask      = irq_gc_mask_clr_bit;
+	gc->chip_types[0].chip.irq_unmask    = irq_gc_mask_set_bit;
+	gc->chip_types[0].chip.irq_set_type  = tb10x_irq_set_type;
+	gc->chip_types[0].regs.mask          = AB_IRQCTL_INT_ENABLE;
+
+	gc->chip_types[1].type               = IRQ_TYPE_EDGE_BOTH;
+	gc->chip_types[1].chip.name          = gc->chip_types[0].chip.name;
+	gc->chip_types[1].chip.irq_ack       = irq_gc_ack_set_bit;
+	gc->chip_types[1].chip.irq_mask      = irq_gc_mask_clr_bit;
+	gc->chip_types[1].chip.irq_unmask    = irq_gc_mask_set_bit;
+	gc->chip_types[1].chip.irq_set_type  = tb10x_irq_set_type;
+	gc->chip_types[1].regs.ack           = AB_IRQCTL_INT_STATUS;
+	gc->chip_types[1].regs.mask          = AB_IRQCTL_INT_ENABLE;
+	gc->chip_types[1].handler            = handle_edge_irq;
+
+	domain = irq_domain_add_legacy(ictl, AB_IRQCTL_MAXIRQ,
+					TB10X_IRQCHIP_BASE, 0,
+					&irq_tb10x_domain_ops, gc);
+	if (!domain) {
+		ret = -ENOMEM;
+		pr_err("%s: Could not register interrupt domain.\n",
+			ictl->name);
+		goto irq_domain_add_fail;
+	}
+
+	for (i = 0; i < nrirqs; i++) {
+		unsigned int irq = irq_of_parse_and_map(ictl, i);
+
+		irq_set_handler_data(irq, domain);
+		irq_set_chained_handler(irq, tb10x_irq_cascade);
+
+		mask |= BIT(of_irq_to_resource(ictl, i, NULL));
+	}
+
+	ab_irqctl_writereg(gc, AB_IRQCTL_INT_ENABLE, 0);
+	ab_irqctl_writereg(gc, AB_IRQCTL_INT_MODE, 0);
+	ab_irqctl_writereg(gc, AB_IRQCTL_INT_POLARITY, 0);
+	ab_irqctl_writereg(gc, AB_IRQCTL_INT_STATUS, ~0UL);
+
+	irq_setup_generic_chip(gc, mask, IRQ_GC_INIT_MASK_CACHE,
+				IRQ_NOREQUEST, IRQ_NOPROBE);
+
+	return 0;
+
+irq_domain_add_fail:
+	kfree(gc);
+gc_alloc_fail:
+	iounmap(gc->reg_base);
+ioremap_fail:
+	release_mem_region(mem.start, resource_size(&mem));
+	return ret;
+}
+IRQCHIP_DECLARE(tb10x_intc, "abilis,tb10x_ictl", of_tb10x_init_irq);
-- 
1.7.1

