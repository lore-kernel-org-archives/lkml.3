Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759713Ab3CZJNi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 05:13:38 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:51003 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759690Ab3CZJNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 05:13:34 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: linux-arm-kernel@lists.infradead.org
Cc: kevin@allwinnertech.com, sunny@allwinnertech.com, shuge@allwinnertech.com,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 07/10] irqchip: sunxi: Rename sunxi to sun4i
Date: Tue, 26 Mar 2013 10:13:14 +0100
Message-Id: <1364289198-11589-8-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1364289198-11589-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1364289198-11589-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During the introduction of the Allwinner SoC platforms, sunxi was
initially meant as a generic name for all the variants of the Allwinner
SoC.

It was ok at the time of the support of only the A10 and A13 that
looks pretty much the same, but it's beginning to be troublesome with
the future addition of the Allwinner A31 (sun6i) that is quite
different, and would introduce some weird logic, where sunxi would
actually mean in some case sun4i and sun5i but without sun6i...

Moreover, it makes the compatible strings naming scheme not consistent
with other architectures, where usually for this kind of compability, we
just use the oldest SoC name that has this IP, so let's do just this.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 ...lwinner,sunxi-ic.txt => allwinner,sun4i-ic.txt} |    4 +-
 drivers/irqchip/Makefile                           |    2 +-
 drivers/irqchip/{irq-sunxi.c => irq-sun4i.c}       |  102 ++++++++++----------
 3 files changed, 54 insertions(+), 54 deletions(-)
 rename Documentation/devicetree/bindings/interrupt-controller/{allwinner,sunxi-ic.txt => allwinner,sun4i-ic.txt} (94%)
 rename drivers/irqchip/{irq-sunxi.c => irq-sun4i.c} (41%)

diff --git a/Documentation/devicetree/bindings/interrupt-controller/allwinner,sunxi-ic.txt b/Documentation/devicetree/bindings/interrupt-controller/allwinner,sun4i-ic.txt
similarity index 94%
rename from Documentation/devicetree/bindings/interrupt-controller/allwinner,sunxi-ic.txt
rename to Documentation/devicetree/bindings/interrupt-controller/allwinner,sun4i-ic.txt
index 7f9fb85..e7f4dc1 100644
--- a/Documentation/devicetree/bindings/interrupt-controller/allwinner,sunxi-ic.txt
+++ b/Documentation/devicetree/bindings/interrupt-controller/allwinner,sun4i-ic.txt
@@ -2,7 +2,7 @@ Allwinner Sunxi Interrupt Controller
 
 Required properties:
 
-- compatible : should be "allwinner,sunxi-ic"
+- compatible : should be "allwinner,sun4i-ic"
 - reg : Specifies base physical address and size of the registers.
 - interrupt-controller : Identifies the node as an interrupt controller
 - #interrupt-cells : Specifies the number of cells needed to encode an
@@ -97,7 +97,7 @@ The interrupt sources are as follows:
 Example:
 
 intc: interrupt-controller {
-	compatible = "allwinner,sunxi-ic";
+	compatible = "allwinner,sun4i-ic";
 	reg = <0x01c20400 0x400>;
 	interrupt-controller;
 	#interrupt-cells = <2>;
diff --git a/drivers/irqchip/Makefile b/drivers/irqchip/Makefile
index 98e3b87..5416965 100644
--- a/drivers/irqchip/Makefile
+++ b/drivers/irqchip/Makefile
@@ -4,7 +4,7 @@ obj-$(CONFIG_ARCH_BCM2835)		+= irq-bcm2835.o
 obj-$(CONFIG_ARCH_EXYNOS)		+= exynos-combiner.o
 obj-$(CONFIG_METAG)			+= irq-metag-ext.o
 obj-$(CONFIG_METAG_PERFCOUNTER_IRQS)	+= irq-metag.o
-obj-$(CONFIG_ARCH_SUNXI)		+= irq-sunxi.o
+obj-$(CONFIG_ARCH_SUNXI)		+= irq-sun4i.o
 obj-$(CONFIG_ARCH_SPEAR3XX)		+= spear-shirq.o
 obj-$(CONFIG_ARM_GIC)			+= irq-gic.o
 obj-$(CONFIG_ARM_VIC)			+= irq-vic.o
diff --git a/drivers/irqchip/irq-sunxi.c b/drivers/irqchip/irq-sun4i.c
similarity index 41%
rename from drivers/irqchip/irq-sunxi.c
rename to drivers/irqchip/irq-sun4i.c
index 0fc49c5..b66d4ae 100644
--- a/drivers/irqchip/irq-sunxi.c
+++ b/drivers/irqchip/irq-sun4i.c
@@ -25,125 +25,125 @@
 
 #include "irqchip.h"
 
-#define SUNXI_IRQ_VECTOR_REG		0x00
-#define SUNXI_IRQ_PROTECTION_REG	0x08
-#define SUNXI_IRQ_NMI_CTRL_REG		0x0c
-#define SUNXI_IRQ_PENDING_REG(x)	(0x10 + 0x4 * x)
-#define SUNXI_IRQ_FIQ_PENDING_REG(x)	(0x20 + 0x4 * x)
-#define SUNXI_IRQ_ENABLE_REG(x)		(0x40 + 0x4 * x)
-#define SUNXI_IRQ_MASK_REG(x)		(0x50 + 0x4 * x)
+#define SUN4I_IRQ_VECTOR_REG		0x00
+#define SUN4I_IRQ_PROTECTION_REG	0x08
+#define SUN4I_IRQ_NMI_CTRL_REG		0x0c
+#define SUN4I_IRQ_PENDING_REG(x)	(0x10 + 0x4 * x)
+#define SUN4I_IRQ_FIQ_PENDING_REG(x)	(0x20 + 0x4 * x)
+#define SUN4I_IRQ_ENABLE_REG(x)		(0x40 + 0x4 * x)
+#define SUN4I_IRQ_MASK_REG(x)		(0x50 + 0x4 * x)
 
-static void __iomem *sunxi_irq_base;
-static struct irq_domain *sunxi_irq_domain;
+static void __iomem *sun4i_irq_base;
+static struct irq_domain *sun4i_irq_domain;
 
-static asmlinkage void __exception_irq_entry sunxi_handle_irq(struct pt_regs *regs);
+static asmlinkage void __exception_irq_entry sun4i_handle_irq(struct pt_regs *regs);
 
-void sunxi_irq_ack(struct irq_data *irqd)
+void sun4i_irq_ack(struct irq_data *irqd)
 {
 	unsigned int irq = irqd_to_hwirq(irqd);
 	unsigned int irq_off = irq % 32;
 	int reg = irq / 32;
 	u32 val;
 
-	val = readl(sunxi_irq_base + SUNXI_IRQ_PENDING_REG(reg));
+	val = readl(sun4i_irq_base + SUN4I_IRQ_PENDING_REG(reg));
 	writel(val | (1 << irq_off),
-	       sunxi_irq_base + SUNXI_IRQ_PENDING_REG(reg));
+	       sun4i_irq_base + SUN4I_IRQ_PENDING_REG(reg));
 }
 
-static void sunxi_irq_mask(struct irq_data *irqd)
+static void sun4i_irq_mask(struct irq_data *irqd)
 {
 	unsigned int irq = irqd_to_hwirq(irqd);
 	unsigned int irq_off = irq % 32;
 	int reg = irq / 32;
 	u32 val;
 
-	val = readl(sunxi_irq_base + SUNXI_IRQ_ENABLE_REG(reg));
+	val = readl(sun4i_irq_base + SUN4I_IRQ_ENABLE_REG(reg));
 	writel(val & ~(1 << irq_off),
-	       sunxi_irq_base + SUNXI_IRQ_ENABLE_REG(reg));
+	       sun4i_irq_base + SUN4I_IRQ_ENABLE_REG(reg));
 }
 
-static void sunxi_irq_unmask(struct irq_data *irqd)
+static void sun4i_irq_unmask(struct irq_data *irqd)
 {
 	unsigned int irq = irqd_to_hwirq(irqd);
 	unsigned int irq_off = irq % 32;
 	int reg = irq / 32;
 	u32 val;
 
-	val = readl(sunxi_irq_base + SUNXI_IRQ_ENABLE_REG(reg));
+	val = readl(sun4i_irq_base + SUN4I_IRQ_ENABLE_REG(reg));
 	writel(val | (1 << irq_off),
-	       sunxi_irq_base + SUNXI_IRQ_ENABLE_REG(reg));
+	       sun4i_irq_base + SUN4I_IRQ_ENABLE_REG(reg));
 }
 
-static struct irq_chip sunxi_irq_chip = {
-	.name		= "sunxi_irq",
-	.irq_ack	= sunxi_irq_ack,
-	.irq_mask	= sunxi_irq_mask,
-	.irq_unmask	= sunxi_irq_unmask,
+static struct irq_chip sun4i_irq_chip = {
+	.name		= "sun4i_irq",
+	.irq_ack	= sun4i_irq_ack,
+	.irq_mask	= sun4i_irq_mask,
+	.irq_unmask	= sun4i_irq_unmask,
 };
 
-static int sunxi_irq_map(struct irq_domain *d, unsigned int virq,
+static int sun4i_irq_map(struct irq_domain *d, unsigned int virq,
 			 irq_hw_number_t hw)
 {
-	irq_set_chip_and_handler(virq, &sunxi_irq_chip,
+	irq_set_chip_and_handler(virq, &sun4i_irq_chip,
 				 handle_level_irq);
 	set_irq_flags(virq, IRQF_VALID | IRQF_PROBE);
 
 	return 0;
 }
 
-static struct irq_domain_ops sunxi_irq_ops = {
-	.map = sunxi_irq_map,
+static struct irq_domain_ops sun4i_irq_ops = {
+	.map = sun4i_irq_map,
 	.xlate = irq_domain_xlate_onecell,
 };
 
-static int __init sunxi_of_init(struct device_node *node,
+static int __init sun4i_of_init(struct device_node *node,
 				struct device_node *parent)
 {
-	sunxi_irq_base = of_iomap(node, 0);
-	if (!sunxi_irq_base)
+	sun4i_irq_base = of_iomap(node, 0);
+	if (!sun4i_irq_base)
 		panic("%s: unable to map IC registers\n",
 			node->full_name);
 
 	/* Disable all interrupts */
-	writel(0, sunxi_irq_base + SUNXI_IRQ_ENABLE_REG(0));
-	writel(0, sunxi_irq_base + SUNXI_IRQ_ENABLE_REG(1));
-	writel(0, sunxi_irq_base + SUNXI_IRQ_ENABLE_REG(2));
+	writel(0, sun4i_irq_base + SUN4I_IRQ_ENABLE_REG(0));
+	writel(0, sun4i_irq_base + SUN4I_IRQ_ENABLE_REG(1));
+	writel(0, sun4i_irq_base + SUN4I_IRQ_ENABLE_REG(2));
 
 	/* Mask all the interrupts */
-	writel(0, sunxi_irq_base + SUNXI_IRQ_MASK_REG(0));
-	writel(0, sunxi_irq_base + SUNXI_IRQ_MASK_REG(1));
-	writel(0, sunxi_irq_base + SUNXI_IRQ_MASK_REG(2));
+	writel(0, sun4i_irq_base + SUN4I_IRQ_MASK_REG(0));
+	writel(0, sun4i_irq_base + SUN4I_IRQ_MASK_REG(1));
+	writel(0, sun4i_irq_base + SUN4I_IRQ_MASK_REG(2));
 
 	/* Clear all the pending interrupts */
-	writel(0xffffffff, sunxi_irq_base + SUNXI_IRQ_PENDING_REG(0));
-	writel(0xffffffff, sunxi_irq_base + SUNXI_IRQ_PENDING_REG(1));
-	writel(0xffffffff, sunxi_irq_base + SUNXI_IRQ_PENDING_REG(2));
+	writel(0xffffffff, sun4i_irq_base + SUN4I_IRQ_PENDING_REG(0));
+	writel(0xffffffff, sun4i_irq_base + SUN4I_IRQ_PENDING_REG(1));
+	writel(0xffffffff, sun4i_irq_base + SUN4I_IRQ_PENDING_REG(2));
 
 	/* Enable protection mode */
-	writel(0x01, sunxi_irq_base + SUNXI_IRQ_PROTECTION_REG);
+	writel(0x01, sun4i_irq_base + SUN4I_IRQ_PROTECTION_REG);
 
 	/* Configure the external interrupt source type */
-	writel(0x00, sunxi_irq_base + SUNXI_IRQ_NMI_CTRL_REG);
+	writel(0x00, sun4i_irq_base + SUN4I_IRQ_NMI_CTRL_REG);
 
-	sunxi_irq_domain = irq_domain_add_linear(node, 3 * 32,
-						 &sunxi_irq_ops, NULL);
-	if (!sunxi_irq_domain)
+	sun4i_irq_domain = irq_domain_add_linear(node, 3 * 32,
+						 &sun4i_irq_ops, NULL);
+	if (!sun4i_irq_domain)
 		panic("%s: unable to create IRQ domain\n", node->full_name);
 
-	set_handle_irq(sunxi_handle_irq);
+	set_handle_irq(sun4i_handle_irq);
 
 	return 0;
 }
-IRQCHIP_DECLARE(allwinner_sunxi_ic, "allwinner,sunxi-ic", sunxi_of_init);
+IRQCHIP_DECLARE(allwinner_sun4i_ic, "allwinner,sun4i-ic", sun4i_of_init);
 
-static asmlinkage void __exception_irq_entry sunxi_handle_irq(struct pt_regs *regs)
+static asmlinkage void __exception_irq_entry sun4i_handle_irq(struct pt_regs *regs)
 {
 	u32 irq, hwirq;
 
-	hwirq = readl(sunxi_irq_base + SUNXI_IRQ_VECTOR_REG) >> 2;
+	hwirq = readl(sun4i_irq_base + SUN4I_IRQ_VECTOR_REG) >> 2;
 	while (hwirq != 0) {
-		irq = irq_find_mapping(sunxi_irq_domain, hwirq);
+		irq = irq_find_mapping(sun4i_irq_domain, hwirq);
 		handle_IRQ(irq, regs);
-		hwirq = readl(sunxi_irq_base + SUNXI_IRQ_VECTOR_REG) >> 2;
+		hwirq = readl(sun4i_irq_base + SUN4I_IRQ_VECTOR_REG) >> 2;
 	}
 }
-- 
1.7.10.4

