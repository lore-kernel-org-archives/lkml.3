Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753277Ab3GAItz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 04:49:55 -0400
Received: from mail-ea0-f172.google.com ([209.85.215.172]:62728 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752738Ab3GAItw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 04:49:52 -0400
Date: Mon, 1 Jul 2013 10:49:47 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] irq/core changes for v3.11
Message-ID: <20130701084947.GA14603@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest irq-core-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git irq-core-for-linus

   HEAD: d2e08473f2488d53a71c2f53455f934ec6c44c53 softirq: Use _RET_IP_

The main changes:

  - generic-irqchip driver additions, cleanups and fixes

  - 3 new irqchip drivers: ARMv7-M NVIC, TB10x and Marvell Orion SoCs

  - irq_get_trigger_type() simplification and cross-arch cleanup

  - various cleanups, simplifications

  - documentation updates

 Thanks,

	Ingo

------------------>
Andreas Fenkart (1):
      genirq: Add kerneldoc for irq_disable.

Ben Hutchings (1):
      genirq: Fix can_request_irq() for IRQs without an action

Christian Ruppert (1):
      irqchip: Add TB10x interrupt controller driver

Davidlohr Bueso (1):
      softirq: Use _RET_IP_

Fabio Estevam (1):
      genirq: generic-chip: Export some irq_gc_ functions

Gerlando Falauto (3):
      genirq: Generic chip: Remove the local cur_regs() function
      genirq: Generic chip: Add support for per chip type mask cache
      genirq: Generic chip: Handle separate mask registers

Grant Likely (1):
      genirq: irqchip: Add mask to block out invalid irqs

Ivo Sieben (1):
      genirq: Set irq thread to RT priority on creation

James Hogan (1):
      genirq: Irqchip: document gcflags arg of irq_alloc_domain_generic_chips

Javier Martinez Canillas (7):
      genirq: Add irq_get_trigger_type() to get IRQ flags
      gpio: mvebu: Use irq_get_trigger_type() to get IRQ flags
      mfd: twl4030-irq: Use irq_get_trigger_type() to get IRQ flags
      mfd: stmpe: use irq_get_trigger_type() to get IRQ flags
      arm: orion: Use irq_get_trigger_type() to get IRQ flags
      MIPS: octeon: Use irq_get_trigger_type() to get IRQ flags
      irqdomain: Use irq_get_trigger_type() to get IRQ flags

Sachin Kamat (1):
      irqchip: exynos-combiner: Staticize combiner_init

Sebastian Hesselbarth (1):
      irqchip: Add support for Marvell Orion SoCs

Thomas Gleixner (5):
      genirq: Generic chip: Cache per irq bit mask
      genirq: irqchip: Add a mask calculation function
      genirq: Generic chip: Split out code into separate functions
      genirq: Generic chip: Add linear irq domain support
      genirq: Add the generic chip to the genirq docbook

Uwe Kleine-König (1):
      irqchip: Add support for ARMv7-M NVIC


 Documentation/DocBook/genericirq.tmpl              |  13 +
 .../interrupt-controller/abilis,tb10x-ictl.txt     |  38 +++
 .../interrupt-controller/marvell,orion-intc.txt    |  48 ++++
 arch/arm/plat-orion/gpio.c                         |   2 +-
 arch/mips/cavium-octeon/octeon-irq.c               |   2 +-
 drivers/gpio/gpio-mvebu.c                          |   2 +-
 drivers/irqchip/Kconfig                            |  15 +
 drivers/irqchip/Makefile                           |   3 +
 drivers/irqchip/exynos-combiner.c                  |   8 +-
 drivers/irqchip/irq-nvic.c                         | 117 ++++++++
 drivers/irqchip/irq-orion.c                        | 192 +++++++++++++
 drivers/irqchip/irq-tb10x.c                        | 195 +++++++++++++
 drivers/mfd/stmpe.c                                |   3 +-
 drivers/mfd/twl4030-irq.c                          |   5 +-
 include/linux/irq.h                                |  53 +++-
 include/linux/irqdomain.h                          |  12 +
 kernel/irq/chip.c                                  |  13 +
 kernel/irq/generic-chip.c                          | 314 ++++++++++++++++++---
 kernel/irq/irqdomain.c                             |   8 +-
 kernel/irq/manage.c                                |  17 +-
 kernel/softirq.c                                   |  10 +-
 21 files changed, 988 insertions(+), 82 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/interrupt-controller/abilis,tb10x-ictl.txt
 create mode 100644 Documentation/devicetree/bindings/interrupt-controller/marvell,orion-intc.txt
 create mode 100644 drivers/irqchip/irq-nvic.c
 create mode 100644 drivers/irqchip/irq-orion.c
 create mode 100644 drivers/irqchip/irq-tb10x.c

diff --git a/Documentation/DocBook/genericirq.tmpl b/Documentation/DocBook/genericirq.tmpl
index b342234..d16d21b 100644
--- a/Documentation/DocBook/genericirq.tmpl
+++ b/Documentation/DocBook/genericirq.tmpl
@@ -464,6 +464,19 @@ if (desc->irq_data.chip->irq_eoi)
 	protected via desc->lock, by the generic layer.
      </para>
   </chapter>
+
+  <chapter id="genericchip">
+     <title>Generic interrupt chip</title>
+     <para>
+       To avoid copies of identical implementations of irq chips the
+       core provides a configurable generic interrupt chip
+       implementation. Developers should check carefuly whether the
+       generic chip fits their needs before implementing the same
+       functionality slightly different themself.
+     </para>
+!Ekernel/irq/generic-chip.c
+  </chapter>
+
   <chapter id="structs">
      <title>Structures</title>
      <para>
diff --git a/Documentation/devicetree/bindings/interrupt-controller/abilis,tb10x-ictl.txt b/Documentation/devicetree/bindings/interrupt-controller/abilis,tb10x-ictl.txt
new file mode 100644
index 0000000..9d52d5a
--- /dev/null
+++ b/Documentation/devicetree/bindings/interrupt-controller/abilis,tb10x-ictl.txt
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
+- compatible: Should be "abilis,tb10x-ictl"
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
+	compatible = "abilis,tb10x-ictl";
+	reg = <0x2000 0x20>;
+	interrupt-controller;
+	#interrupt-cells = <2>;
+	interrupt-parent = <&intc>;
+	interrupts = <5 6 7 8 9 10 11 12 13 14 15 16 17 18 19
+			20 21 22 23 24 25 26 27 28 29 30 31>;
+};
diff --git a/Documentation/devicetree/bindings/interrupt-controller/marvell,orion-intc.txt b/Documentation/devicetree/bindings/interrupt-controller/marvell,orion-intc.txt
new file mode 100644
index 0000000..2c11ac7
--- /dev/null
+++ b/Documentation/devicetree/bindings/interrupt-controller/marvell,orion-intc.txt
@@ -0,0 +1,48 @@
+Marvell Orion SoC interrupt controllers
+
+* Main interrupt controller
+
+Required properties:
+- compatible: shall be "marvell,orion-intc"
+- reg: base address(es) of interrupt registers starting with CAUSE register
+- interrupt-controller: identifies the node as an interrupt controller
+- #interrupt-cells: number of cells to encode an interrupt source, shall be 1
+
+The interrupt sources map to the corresponding bits in the interrupt
+registers, i.e.
+- 0 maps to bit 0 of first base address,
+- 1 maps to bit 1 of first base address,
+- 32 maps to bit 0 of second base address, and so on.
+
+Example:
+	intc: interrupt-controller {
+		compatible = "marvell,orion-intc";
+		interrupt-controller;
+		#interrupt-cells = <1>;
+		 /* Dove has 64 first level interrupts */
+		reg = <0x20200 0x10>, <0x20210 0x10>;
+	};
+
+* Bridge interrupt controller
+
+Required properties:
+- compatible: shall be "marvell,orion-bridge-intc"
+- reg: base address of bridge interrupt registers starting with CAUSE register
+- interrupts: bridge interrupt of the main interrupt controller
+- interrupt-controller: identifies the node as an interrupt controller
+- #interrupt-cells: number of cells to encode an interrupt source, shall be 1
+
+Optional properties:
+- marvell,#interrupts: number of interrupts provided by bridge interrupt
+      controller, defaults to 32 if not set
+
+Example:
+	bridge_intc: interrupt-controller {
+		compatible = "marvell,orion-bridge-intc";
+		interrupt-controller;
+		#interrupt-cells = <1>;
+		reg = <0x20110 0x8>;
+		interrupts = <0>;
+		/* Dove bridge provides 5 interrupts */
+		marvell,#interrupts = <5>;
+	};
diff --git a/arch/arm/plat-orion/gpio.c b/arch/arm/plat-orion/gpio.c
index 249fe63..6816192 100644
--- a/arch/arm/plat-orion/gpio.c
+++ b/arch/arm/plat-orion/gpio.c
@@ -426,7 +426,7 @@ static void gpio_irq_handler(unsigned irq, struct irq_desc *desc)
 		if (!(cause & (1 << i)))
 			continue;
 
-		type = irqd_get_trigger_type(irq_get_irq_data(irq));
+		type = irq_get_trigger_type(irq);
 		if ((type & IRQ_TYPE_SENSE_MASK) == IRQ_TYPE_EDGE_BOTH) {
 			/* Swap polarity (race with GPIO line) */
 			u32 polarity;
diff --git a/arch/mips/cavium-octeon/octeon-irq.c b/arch/mips/cavium-octeon/octeon-irq.c
index a22f06a..7181def 100644
--- a/arch/mips/cavium-octeon/octeon-irq.c
+++ b/arch/mips/cavium-octeon/octeon-irq.c
@@ -607,7 +607,7 @@ static void octeon_irq_ciu_gpio_ack(struct irq_data *data)
 
 static void octeon_irq_handle_gpio(unsigned int irq, struct irq_desc *desc)
 {
-	if (irqd_get_trigger_type(irq_desc_get_irq_data(desc)) & IRQ_TYPE_EDGE_BOTH)
+	if (irq_get_trigger_type(irq) & IRQ_TYPE_EDGE_BOTH)
 		handle_edge_irq(irq, desc);
 	else
 		handle_level_irq(irq, desc);
diff --git a/drivers/gpio/gpio-mvebu.c b/drivers/gpio/gpio-mvebu.c
index 3a4816a..80ad35e 100644
--- a/drivers/gpio/gpio-mvebu.c
+++ b/drivers/gpio/gpio-mvebu.c
@@ -457,7 +457,7 @@ static void mvebu_gpio_irq_handler(unsigned int irq, struct irq_desc *desc)
 		if (!(cause & (1 << i)))
 			continue;
 
-		type = irqd_get_trigger_type(irq_get_irq_data(irq));
+		type = irq_get_trigger_type(irq);
 		if ((type & IRQ_TYPE_SENSE_MASK) == IRQ_TYPE_EDGE_BOTH) {
 			/* Swap polarity (race with GPIO line) */
 			u32 polarity;
diff --git a/drivers/irqchip/Kconfig b/drivers/irqchip/Kconfig
index 4a33351..1fea003 100644
--- a/drivers/irqchip/Kconfig
+++ b/drivers/irqchip/Kconfig
@@ -10,6 +10,11 @@ config ARM_GIC
 config GIC_NON_BANKED
 	bool
 
+config ARM_NVIC
+	bool
+	select IRQ_DOMAIN
+	select GENERIC_IRQ_CHIP
+
 config ARM_VIC
 	bool
 	select IRQ_DOMAIN
@@ -25,6 +30,11 @@ config ARM_VIC_NR
 	  The maximum number of VICs available in the system, for
 	  power management.
 
+config ORION_IRQCHIP
+	bool
+	select IRQ_DOMAIN
+	select MULTI_IRQ_HANDLER
+
 config RENESAS_INTC_IRQPIN
 	bool
 	select IRQ_DOMAIN
@@ -33,6 +43,11 @@ config RENESAS_IRQC
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
index cda4cb5..2065ef6 100644
--- a/drivers/irqchip/Makefile
+++ b/drivers/irqchip/Makefile
@@ -7,12 +7,15 @@ obj-$(CONFIG_ARCH_MXS)			+= irq-mxs.o
 obj-$(CONFIG_ARCH_S3C24XX)		+= irq-s3c24xx.o
 obj-$(CONFIG_METAG)			+= irq-metag-ext.o
 obj-$(CONFIG_METAG_PERFCOUNTER_IRQS)	+= irq-metag.o
+obj-$(CONFIG_ORION_IRQCHIP)		+= irq-orion.o
 obj-$(CONFIG_ARCH_SUNXI)		+= irq-sun4i.o
 obj-$(CONFIG_ARCH_SPEAR3XX)		+= spear-shirq.o
 obj-$(CONFIG_ARM_GIC)			+= irq-gic.o
+obj-$(CONFIG_ARM_NVIC)			+= irq-nvic.o
 obj-$(CONFIG_ARM_VIC)			+= irq-vic.o
 obj-$(CONFIG_SIRF_IRQ)			+= irq-sirfsoc.o
 obj-$(CONFIG_RENESAS_INTC_IRQPIN)	+= irq-renesas-intc-irqpin.o
 obj-$(CONFIG_RENESAS_IRQC)		+= irq-renesas-irqc.o
 obj-$(CONFIG_VERSATILE_FPGA_IRQ)	+= irq-versatile-fpga.o
 obj-$(CONFIG_ARCH_VT8500)		+= irq-vt8500.o
+obj-$(CONFIG_TB10X_IRQC)		+= irq-tb10x.o
diff --git a/drivers/irqchip/exynos-combiner.c b/drivers/irqchip/exynos-combiner.c
index a9d2b2f..4c68265 100644
--- a/drivers/irqchip/exynos-combiner.c
+++ b/drivers/irqchip/exynos-combiner.c
@@ -204,10 +204,10 @@ static unsigned int combiner_lookup_irq(int group)
 	return 0;
 }
 
-void __init combiner_init(void __iomem *combiner_base,
-			  struct device_node *np,
-			  unsigned int max_nr,
-			  int irq_base)
+static void __init combiner_init(void __iomem *combiner_base,
+				 struct device_node *np,
+				 unsigned int max_nr,
+				 int irq_base)
 {
 	int i, irq;
 	unsigned int nr_irq;
diff --git a/drivers/irqchip/irq-nvic.c b/drivers/irqchip/irq-nvic.c
new file mode 100644
index 0000000..8d0c8b3
--- /dev/null
+++ b/drivers/irqchip/irq-nvic.c
@@ -0,0 +1,117 @@
+/*
+ * drivers/irq/irq-nvic.c
+ *
+ * Copyright (C) 2008 ARM Limited, All Rights Reserved.
+ * Copyright (C) 2013 Pengutronix
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Support for the Nested Vectored Interrupt Controller found on the
+ * ARMv7-M CPUs (Cortex-M3/M4)
+ */
+#define pr_fmt(fmt)	KBUILD_MODNAME ": " fmt
+
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/err.h>
+#include <linux/io.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/irq.h>
+#include <linux/irqdomain.h>
+
+#include <asm/v7m.h>
+#include <asm/exception.h>
+
+#include "irqchip.h"
+
+#define NVIC_ISER		0x000
+#define NVIC_ICER		0x080
+#define NVIC_IPR		0x300
+
+#define NVIC_MAX_BANKS		16
+/*
+ * Each bank handles 32 irqs. Only the 16th (= last) bank handles only
+ * 16 irqs.
+ */
+#define NVIC_MAX_IRQ		((NVIC_MAX_BANKS - 1) * 32 + 16)
+
+static struct irq_domain *nvic_irq_domain;
+
+asmlinkage void __exception_irq_entry
+nvic_handle_irq(irq_hw_number_t hwirq, struct pt_regs *regs)
+{
+	unsigned int irq = irq_linear_revmap(nvic_irq_domain, hwirq);
+
+	handle_IRQ(irq, regs);
+}
+
+static void nvic_eoi(struct irq_data *d)
+{
+	/*
+	 * This is a no-op as end of interrupt is signaled by the exception
+	 * return sequence.
+	 */
+}
+
+static int __init nvic_of_init(struct device_node *node,
+			       struct device_node *parent)
+{
+	unsigned int clr = IRQ_NOREQUEST | IRQ_NOPROBE | IRQ_NOAUTOEN;
+	unsigned int irqs, i, ret, numbanks;
+	void __iomem *nvic_base;
+
+	numbanks = (readl_relaxed(V7M_SCS_ICTR) &
+		    V7M_SCS_ICTR_INTLINESNUM_MASK) + 1;
+
+	nvic_base = of_iomap(node, 0);
+	if (!nvic_base) {
+		pr_warn("unable to map nvic registers\n");
+		return -ENOMEM;
+	}
+
+	irqs = numbanks * 32;
+	if (irqs > NVIC_MAX_IRQ)
+		irqs = NVIC_MAX_IRQ;
+
+	nvic_irq_domain =
+		irq_domain_add_linear(node, irqs, &irq_generic_chip_ops, NULL);
+	if (!nvic_irq_domain) {
+		pr_warn("Failed to allocate irq domain\n");
+		return -ENOMEM;
+	}
+
+	ret = irq_alloc_domain_generic_chips(nvic_irq_domain, 32, numbanks,
+					     "nvic_irq", handle_fasteoi_irq,
+					     clr, 0, IRQ_GC_INIT_MASK_CACHE);
+	if (ret) {
+		pr_warn("Failed to allocate irq chips\n");
+		irq_domain_remove(nvic_irq_domain);
+		return ret;
+	}
+
+	for (i = 0; i < numbanks; ++i) {
+		struct irq_chip_generic *gc;
+
+		gc = irq_get_domain_generic_chip(nvic_irq_domain, 32 * i);
+		gc->reg_base = nvic_base + 4 * i;
+		gc->chip_types[0].regs.enable = NVIC_ISER;
+		gc->chip_types[0].regs.disable = NVIC_ICER;
+		gc->chip_types[0].chip.irq_mask = irq_gc_mask_disable_reg;
+		gc->chip_types[0].chip.irq_unmask = irq_gc_unmask_enable_reg;
+		gc->chip_types[0].chip.irq_eoi = nvic_eoi;
+
+		/* disable interrupts */
+		writel_relaxed(~0, gc->reg_base + NVIC_ICER);
+	}
+
+	/* Set priority on all interrupts */
+	for (i = 0; i < irqs; i += 4)
+		writel_relaxed(0, nvic_base + NVIC_IPR + i);
+
+	return 0;
+}
+IRQCHIP_DECLARE(armv7m_nvic, "arm,armv7m-nvic", nvic_of_init);
diff --git a/drivers/irqchip/irq-orion.c b/drivers/irqchip/irq-orion.c
new file mode 100644
index 0000000..e51d400
--- /dev/null
+++ b/drivers/irqchip/irq-orion.c
@@ -0,0 +1,192 @@
+/*
+ * Marvell Orion SoCs IRQ chip driver.
+ *
+ * Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2.  This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#include <linux/io.h>
+#include <linux/irq.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/of_irq.h>
+#include <asm/exception.h>
+#include <asm/mach/irq.h>
+
+#include "irqchip.h"
+
+/*
+ * Orion SoC main interrupt controller
+ */
+#define ORION_IRQS_PER_CHIP		32
+
+#define ORION_IRQ_CAUSE			0x00
+#define ORION_IRQ_MASK			0x04
+#define ORION_IRQ_FIQ_MASK		0x08
+#define ORION_IRQ_ENDP_MASK		0x0c
+
+static struct irq_domain *orion_irq_domain;
+
+static asmlinkage void
+__exception_irq_entry orion_handle_irq(struct pt_regs *regs)
+{
+	struct irq_domain_chip_generic *dgc = orion_irq_domain->gc;
+	int n, base = 0;
+
+	for (n = 0; n < dgc->num_chips; n++, base += ORION_IRQS_PER_CHIP) {
+		struct irq_chip_generic *gc =
+			irq_get_domain_generic_chip(orion_irq_domain, base);
+		u32 stat = readl_relaxed(gc->reg_base + ORION_IRQ_CAUSE) &
+			gc->mask_cache;
+		while (stat) {
+			u32 hwirq = ffs(stat) - 1;
+			u32 irq = irq_find_mapping(orion_irq_domain,
+						   gc->irq_base + hwirq);
+			handle_IRQ(irq, regs);
+			stat &= ~(1 << hwirq);
+		}
+	}
+}
+
+static int __init orion_irq_init(struct device_node *np,
+				 struct device_node *parent)
+{
+	unsigned int clr = IRQ_NOREQUEST | IRQ_NOPROBE | IRQ_NOAUTOEN;
+	int n, ret, base, num_chips = 0;
+	struct resource r;
+
+	/* count number of irq chips by valid reg addresses */
+	while (of_address_to_resource(np, num_chips, &r) == 0)
+		num_chips++;
+
+	orion_irq_domain = irq_domain_add_linear(np,
+				num_chips * ORION_IRQS_PER_CHIP,
+				&irq_generic_chip_ops, NULL);
+	if (!orion_irq_domain)
+		panic("%s: unable to add irq domain\n", np->name);
+
+	ret = irq_alloc_domain_generic_chips(orion_irq_domain,
+				ORION_IRQS_PER_CHIP, 1, np->name,
+				handle_level_irq, clr, 0,
+				IRQ_GC_INIT_MASK_CACHE);
+	if (ret)
+		panic("%s: unable to alloc irq domain gc\n", np->name);
+
+	for (n = 0, base = 0; n < num_chips; n++, base += ORION_IRQS_PER_CHIP) {
+		struct irq_chip_generic *gc =
+			irq_get_domain_generic_chip(orion_irq_domain, base);
+
+		of_address_to_resource(np, n, &r);
+
+		if (!request_mem_region(r.start, resource_size(&r), np->name))
+			panic("%s: unable to request mem region %d",
+			      np->name, n);
+
+		gc->reg_base = ioremap(r.start, resource_size(&r));
+		if (!gc->reg_base)
+			panic("%s: unable to map resource %d", np->name, n);
+
+		gc->chip_types[0].regs.mask = ORION_IRQ_MASK;
+		gc->chip_types[0].chip.irq_mask = irq_gc_mask_clr_bit;
+		gc->chip_types[0].chip.irq_unmask = irq_gc_mask_set_bit;
+
+		/* mask all interrupts */
+		writel(0, gc->reg_base + ORION_IRQ_MASK);
+	}
+
+	set_handle_irq(orion_handle_irq);
+	return 0;
+}
+IRQCHIP_DECLARE(orion_intc, "marvell,orion-intc", orion_irq_init);
+
+/*
+ * Orion SoC bridge interrupt controller
+ */
+#define ORION_BRIDGE_IRQ_CAUSE	0x00
+#define ORION_BRIDGE_IRQ_MASK	0x04
+
+static void orion_bridge_irq_handler(unsigned int irq, struct irq_desc *desc)
+{
+	struct irq_domain *d = irq_get_handler_data(irq);
+	struct irq_chip_generic *gc = irq_get_domain_generic_chip(d, irq);
+	u32 stat = readl_relaxed(gc->reg_base + ORION_BRIDGE_IRQ_CAUSE) &
+		   gc->mask_cache;
+
+	while (stat) {
+		u32 hwirq = ffs(stat) - 1;
+
+		generic_handle_irq(irq_find_mapping(d, gc->irq_base + hwirq));
+		stat &= ~(1 << hwirq);
+	}
+}
+
+static int __init orion_bridge_irq_init(struct device_node *np,
+					struct device_node *parent)
+{
+	unsigned int clr = IRQ_NOREQUEST | IRQ_NOPROBE | IRQ_NOAUTOEN;
+	struct resource r;
+	struct irq_domain *domain;
+	struct irq_chip_generic *gc;
+	int ret, irq, nrirqs = 32;
+
+	/* get optional number of interrupts provided */
+	of_property_read_u32(np, "marvell,#interrupts", &nrirqs);
+
+	domain = irq_domain_add_linear(np, nrirqs,
+				       &irq_generic_chip_ops, NULL);
+	if (!domain) {
+		pr_err("%s: unable to add irq domain\n", np->name);
+		return -ENOMEM;
+	}
+
+	ret = irq_alloc_domain_generic_chips(domain, nrirqs, 1, np->name,
+			     handle_level_irq, clr, 0, IRQ_GC_INIT_MASK_CACHE);
+	if (ret) {
+		pr_err("%s: unable to alloc irq domain gc\n", np->name);
+		return ret;
+	}
+
+	ret = of_address_to_resource(np, 0, &r);
+	if (ret) {
+		pr_err("%s: unable to get resource\n", np->name);
+		return ret;
+	}
+
+	if (!request_mem_region(r.start, resource_size(&r), np->name)) {
+		pr_err("%s: unable to request mem region\n", np->name);
+		return -ENOMEM;
+	}
+
+	/* Map the parent interrupt for the chained handler */
+	irq = irq_of_parse_and_map(np, 0);
+	if (irq <= 0) {
+		pr_err("%s: unable to parse irq\n", np->name);
+		return -EINVAL;
+	}
+
+	gc = irq_get_domain_generic_chip(domain, 0);
+	gc->reg_base = ioremap(r.start, resource_size(&r));
+	if (!gc->reg_base) {
+		pr_err("%s: unable to map resource\n", np->name);
+		return -ENOMEM;
+	}
+
+	gc->chip_types[0].regs.ack = ORION_BRIDGE_IRQ_CAUSE;
+	gc->chip_types[0].regs.mask = ORION_BRIDGE_IRQ_MASK;
+	gc->chip_types[0].chip.irq_ack = irq_gc_ack_clr_bit;
+	gc->chip_types[0].chip.irq_mask = irq_gc_mask_clr_bit;
+	gc->chip_types[0].chip.irq_unmask = irq_gc_mask_set_bit;
+
+	/* mask all interrupts */
+	writel(0, gc->reg_base + ORION_BRIDGE_IRQ_MASK);
+
+	irq_set_handler_data(irq, domain);
+	irq_set_chained_handler(irq, orion_bridge_irq_handler);
+
+	return 0;
+}
+IRQCHIP_DECLARE(orion_bridge_intc,
+		"marvell,orion-bridge-intc", orion_bridge_irq_init);
diff --git a/drivers/irqchip/irq-tb10x.c b/drivers/irqchip/irq-tb10x.c
new file mode 100644
index 0000000..7c44c99
--- /dev/null
+++ b/drivers/irqchip/irq-tb10x.c
@@ -0,0 +1,195 @@
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
+
+static inline void ab_irqctl_writereg(struct irq_chip_generic *gc, u32 reg,
+	u32 val)
+{
+	irq_reg_writel(val, gc->reg_base + reg);
+}
+
+static inline u32 ab_irqctl_readreg(struct irq_chip_generic *gc, u32 reg)
+{
+	return irq_reg_readl(gc->reg_base + reg);
+}
+
+static int tb10x_irq_set_type(struct irq_data *data, unsigned int flow_type)
+{
+	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(data);
+	uint32_t im, mod, pol;
+
+	im = data->mask;
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
+			__func__, data->irq);
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
+	domain = irq_domain_add_linear(ictl, AB_IRQCTL_MAXIRQ,
+					&irq_generic_chip_ops, NULL);
+	if (!domain) {
+		ret = -ENOMEM;
+		pr_err("%s: Could not register interrupt domain.\n",
+			ictl->name);
+		goto irq_domain_add_fail;
+	}
+
+	ret = irq_alloc_domain_generic_chips(domain, AB_IRQCTL_MAXIRQ,
+				2, ictl->name, handle_level_irq,
+				IRQ_NOREQUEST, IRQ_NOPROBE,
+				IRQ_GC_INIT_MASK_CACHE);
+	if (ret) {
+		pr_err("%s: Could not allocate generic interrupt chip.\n",
+			ictl->name);
+		goto gc_alloc_fail;
+	}
+
+	gc = domain->gc->gc[0];
+	gc->reg_base                         = reg_base;
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
+	for (i = 0; i < nrirqs; i++) {
+		unsigned int irq = irq_of_parse_and_map(ictl, i);
+
+		irq_set_handler_data(irq, domain);
+		irq_set_chained_handler(irq, tb10x_irq_cascade);
+	}
+
+	ab_irqctl_writereg(gc, AB_IRQCTL_INT_ENABLE, 0);
+	ab_irqctl_writereg(gc, AB_IRQCTL_INT_MODE, 0);
+	ab_irqctl_writereg(gc, AB_IRQCTL_INT_POLARITY, 0);
+	ab_irqctl_writereg(gc, AB_IRQCTL_INT_STATUS, ~0UL);
+
+	return 0;
+
+gc_alloc_fail:
+	irq_domain_remove(domain);
+irq_domain_add_fail:
+	iounmap(reg_base);
+ioremap_fail:
+	release_mem_region(mem.start, resource_size(&mem));
+	return ret;
+}
+IRQCHIP_DECLARE(tb10x_intc, "abilis,tb10x-ictl", of_tb10x_init_irq);
diff --git a/drivers/mfd/stmpe.c b/drivers/mfd/stmpe.c
index bbccd51..5d5e6f9 100644
--- a/drivers/mfd/stmpe.c
+++ b/drivers/mfd/stmpe.c
@@ -1208,8 +1208,7 @@ int stmpe_probe(struct stmpe_client_info *ci, int partnum)
 		}
 		stmpe->variant = stmpe_noirq_variant_info[stmpe->partnum];
 	} else if (pdata->irq_trigger == IRQF_TRIGGER_NONE) {
-		pdata->irq_trigger =
-			irqd_get_trigger_type(irq_get_irq_data(stmpe->irq));
+		pdata->irq_trigger = irq_get_trigger_type(stmpe->irq);
 	}
 
 	ret = stmpe_chip_init(stmpe);
diff --git a/drivers/mfd/twl4030-irq.c b/drivers/mfd/twl4030-irq.c
index a5f9888..9d2d1ba 100644
--- a/drivers/mfd/twl4030-irq.c
+++ b/drivers/mfd/twl4030-irq.c
@@ -537,16 +537,13 @@ static void twl4030_sih_bus_sync_unlock(struct irq_data *data)
 		/* Modify only the bits we know must change */
 		while (edge_change) {
 			int		i = fls(edge_change) - 1;
-			struct irq_data	*idata;
 			int		byte = i >> 2;
 			int		off = (i & 0x3) * 2;
 			unsigned int	type;
 
-			idata = irq_get_irq_data(i + agent->irq_base);
-
 			bytes[byte] &= ~(0x03 << off);
 
-			type = irqd_get_trigger_type(idata);
+			type = irq_get_trigger_type(i + agent->irq_base);
 			if (type & IRQ_TYPE_EDGE_RISING)
 				bytes[byte] |= BIT(off + 1);
 			if (type & IRQ_TYPE_EDGE_FALLING)
diff --git a/include/linux/irq.h b/include/linux/irq.h
index bc4e066..f04d3ba 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -119,6 +119,7 @@ struct irq_domain;
 
 /**
  * struct irq_data - per irq and irq chip data passed down to chip functions
+ * @mask:		precomputed bitmask for accessing the chip registers
  * @irq:		interrupt number
  * @hwirq:		hardware interrupt number, local to the interrupt domain
  * @node:		node index useful for balancing
@@ -138,6 +139,7 @@ struct irq_domain;
  * irq_data.
  */
 struct irq_data {
+	u32			mask;
 	unsigned int		irq;
 	unsigned long		hwirq;
 	unsigned int		node;
@@ -294,6 +296,7 @@ static inline irq_hw_number_t irqd_to_hwirq(struct irq_data *d)
  * @irq_suspend:	function called from core code on suspend once per chip
  * @irq_resume:		function called from core code on resume once per chip
  * @irq_pm_shutdown:	function called from core code on shutdown once per chip
+ * @irq_calc_mask:	Optional function to set irq_data.mask for special cases
  * @irq_print_chip:	optional to print special chip info in show_interrupts
  * @flags:		chip specific flags
  */
@@ -325,6 +328,8 @@ struct irq_chip {
 	void		(*irq_resume)(struct irq_data *data);
 	void		(*irq_pm_shutdown)(struct irq_data *data);
 
+	void		(*irq_calc_mask)(struct irq_data *data);
+
 	void		(*irq_print_chip)(struct irq_data *data, struct seq_file *p);
 
 	unsigned long	flags;
@@ -579,6 +584,12 @@ static inline struct msi_desc *irq_data_get_msi(struct irq_data *d)
 	return d->msi_desc;
 }
 
+static inline u32 irq_get_trigger_type(unsigned int irq)
+{
+	struct irq_data *d = irq_get_irq_data(irq);
+	return d ? irqd_get_trigger_type(d) : 0;
+}
+
 int __irq_alloc_descs(int irq, unsigned int from, unsigned int cnt, int node,
 		struct module *owner);
 
@@ -644,6 +655,8 @@ struct irq_chip_regs {
  * @regs:		Register offsets for this chip
  * @handler:		Flow handler associated with this chip
  * @type:		Chip can handle these flow types
+ * @mask_cache_priv:	Cached mask register private to the chip type
+ * @mask_cache:		Pointer to cached mask register
  *
  * A irq_generic_chip can have several instances of irq_chip_type when
  * it requires different functions and register offsets for different
@@ -654,6 +667,8 @@ struct irq_chip_type {
 	struct irq_chip_regs	regs;
 	irq_flow_handler_t	handler;
 	u32			type;
+	u32			mask_cache_priv;
+	u32			*mask_cache;
 };
 
 /**
@@ -662,13 +677,16 @@ struct irq_chip_type {
  * @reg_base:		Register base address (virtual)
  * @irq_base:		Interrupt base nr for this chip
  * @irq_cnt:		Number of interrupts handled by this chip
- * @mask_cache:		Cached mask register
+ * @mask_cache:		Cached mask register shared between all chip types
  * @type_cache:		Cached type register
  * @polarity_cache:	Cached polarity register
  * @wake_enabled:	Interrupt can wakeup from suspend
  * @wake_active:	Interrupt is marked as an wakeup from suspend source
  * @num_ct:		Number of available irq_chip_type instances (usually 1)
  * @private:		Private data for non generic chip callbacks
+ * @installed:		bitfield to denote installed interrupts
+ * @unused:		bitfield to denote unused interrupts
+ * @domain:		irq domain pointer
  * @list:		List head for keeping track of instances
  * @chip_types:		Array of interrupt irq_chip_types
  *
@@ -690,6 +708,9 @@ struct irq_chip_generic {
 	u32			wake_active;
 	unsigned int		num_ct;
 	void			*private;
+	unsigned long		installed;
+	unsigned long		unused;
+	struct irq_domain	*domain;
 	struct list_head	list;
 	struct irq_chip_type	chip_types[0];
 };
@@ -700,10 +721,32 @@ struct irq_chip_generic {
  * @IRQ_GC_INIT_NESTED_LOCK:	Set the lock class of the irqs to nested for
  *				irq chips which need to call irq_set_wake() on
  *				the parent irq. Usually GPIO implementations
+ * @IRQ_GC_MASK_CACHE_PER_TYPE:	Mask cache is chip type private
+ * @IRQ_GC_NO_MASK:		Do not calculate irq_data->mask
  */
 enum irq_gc_flags {
 	IRQ_GC_INIT_MASK_CACHE		= 1 << 0,
 	IRQ_GC_INIT_NESTED_LOCK		= 1 << 1,
+	IRQ_GC_MASK_CACHE_PER_TYPE	= 1 << 2,
+	IRQ_GC_NO_MASK			= 1 << 3,
+};
+
+/*
+ * struct irq_domain_chip_generic - Generic irq chip data structure for irq domains
+ * @irqs_per_chip:	Number of interrupts per chip
+ * @num_chips:		Number of chips
+ * @irq_flags_to_set:	IRQ* flags to set on irq setup
+ * @irq_flags_to_clear:	IRQ* flags to clear on irq setup
+ * @gc_flags:		Generic chip specific setup flags
+ * @gc:			Array of pointers to generic interrupt chips
+ */
+struct irq_domain_chip_generic {
+	unsigned int		irqs_per_chip;
+	unsigned int		num_chips;
+	unsigned int		irq_flags_to_clear;
+	unsigned int		irq_flags_to_set;
+	enum irq_gc_flags	gc_flags;
+	struct irq_chip_generic	*gc[0];
 };
 
 /* Generic chip callback functions */
@@ -729,6 +772,14 @@ int irq_setup_alt_chip(struct irq_data *d, unsigned int type);
 void irq_remove_generic_chip(struct irq_chip_generic *gc, u32 msk,
 			     unsigned int clr, unsigned int set);
 
+struct irq_chip_generic *irq_get_domain_generic_chip(struct irq_domain *d, unsigned int hw_irq);
+int irq_alloc_domain_generic_chips(struct irq_domain *d, int irqs_per_chip,
+				   int num_ct, const char *name,
+				   irq_flow_handler_t handler,
+				   unsigned int clr, unsigned int set,
+				   enum irq_gc_flags flags);
+
+
 static inline struct irq_chip_type *irq_data_get_chip_type(struct irq_data *d)
 {
 	return container_of(d->chip, struct irq_chip_type, chip);
diff --git a/include/linux/irqdomain.h b/include/linux/irqdomain.h
index 0d5b17b..ba2c708 100644
--- a/include/linux/irqdomain.h
+++ b/include/linux/irqdomain.h
@@ -66,6 +66,10 @@ struct irq_domain_ops {
 		     unsigned long *out_hwirq, unsigned int *out_type);
 };
 
+extern struct irq_domain_ops irq_generic_chip_ops;
+
+struct irq_domain_chip_generic;
+
 /**
  * struct irq_domain - Hardware interrupt number translation object
  * @link: Element in global irq_domain list.
@@ -109,8 +113,16 @@ struct irq_domain {
 
 	/* Optional device node pointer */
 	struct device_node *of_node;
+	/* Optional pointer to generic interrupt chips */
+	struct irq_domain_chip_generic *gc;
 };
 
+#define IRQ_DOMAIN_MAP_LEGACY 0 /* driver allocated fixed range of irqs.
+				 * ie. legacy 8259, gets irqs 1..15 */
+#define IRQ_DOMAIN_MAP_NOMAP 1 /* no fast reverse mapping */
+#define IRQ_DOMAIN_MAP_LINEAR 2 /* linear map of interrupts */
+#define IRQ_DOMAIN_MAP_TREE 3 /* radix tree */
+
 #ifdef CONFIG_IRQ_DOMAIN
 struct irq_domain *irq_domain_add_simple(struct device_node *of_node,
 					 unsigned int size,
diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index cbd97ce..a3bb14f 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -213,6 +213,19 @@ void irq_enable(struct irq_desc *desc)
 	irq_state_clr_masked(desc);
 }
 
+/**
+ * irq_disable - Mark interupt disabled
+ * @desc:	irq descriptor which should be disabled
+ *
+ * If the chip does not implement the irq_disable callback, we
+ * use a lazy disable approach. That means we mark the interrupt
+ * disabled, but leave the hardware unmasked. That's an
+ * optimization because we avoid the hardware access for the
+ * common case where no interrupt happens after we marked it
+ * disabled. If an interrupt happens, then the interrupt flow
+ * handler masks the line at the hardware level and marks it
+ * pending.
+ */
 void irq_disable(struct irq_desc *desc)
 {
 	irq_state_set_disabled(desc);
diff --git a/kernel/irq/generic-chip.c b/kernel/irq/generic-chip.c
index c89295a..1c39ecc 100644
--- a/kernel/irq/generic-chip.c
+++ b/kernel/irq/generic-chip.c
@@ -7,6 +7,7 @@
 #include <linux/irq.h>
 #include <linux/slab.h>
 #include <linux/export.h>
+#include <linux/irqdomain.h>
 #include <linux/interrupt.h>
 #include <linux/kernel_stat.h>
 #include <linux/syscore_ops.h>
@@ -16,11 +17,6 @@
 static LIST_HEAD(gc_list);
 static DEFINE_RAW_SPINLOCK(gc_lock);
 
-static inline struct irq_chip_regs *cur_regs(struct irq_data *d)
-{
-	return &container_of(d->chip, struct irq_chip_type, chip)->regs;
-}
-
 /**
  * irq_gc_noop - NOOP function
  * @d: irq_data
@@ -39,16 +35,17 @@ void irq_gc_noop(struct irq_data *d)
 void irq_gc_mask_disable_reg(struct irq_data *d)
 {
 	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
-	u32 mask = 1 << (d->irq - gc->irq_base);
+	struct irq_chip_type *ct = irq_data_get_chip_type(d);
+	u32 mask = d->mask;
 
 	irq_gc_lock(gc);
-	irq_reg_writel(mask, gc->reg_base + cur_regs(d)->disable);
-	gc->mask_cache &= ~mask;
+	irq_reg_writel(mask, gc->reg_base + ct->regs.disable);
+	*ct->mask_cache &= ~mask;
 	irq_gc_unlock(gc);
 }
 
 /**
- * irq_gc_mask_set_mask_bit - Mask chip via setting bit in mask register
+ * irq_gc_mask_set_bit - Mask chip via setting bit in mask register
  * @d: irq_data
  *
  * Chip has a single mask register. Values of this register are cached
@@ -57,16 +54,18 @@ void irq_gc_mask_disable_reg(struct irq_data *d)
 void irq_gc_mask_set_bit(struct irq_data *d)
 {
 	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
-	u32 mask = 1 << (d->irq - gc->irq_base);
+	struct irq_chip_type *ct = irq_data_get_chip_type(d);
+	u32 mask = d->mask;
 
 	irq_gc_lock(gc);
-	gc->mask_cache |= mask;
-	irq_reg_writel(gc->mask_cache, gc->reg_base + cur_regs(d)->mask);
+	*ct->mask_cache |= mask;
+	irq_reg_writel(*ct->mask_cache, gc->reg_base + ct->regs.mask);
 	irq_gc_unlock(gc);
 }
+EXPORT_SYMBOL_GPL(irq_gc_mask_set_bit);
 
 /**
- * irq_gc_mask_set_mask_bit - Mask chip via clearing bit in mask register
+ * irq_gc_mask_clr_bit - Mask chip via clearing bit in mask register
  * @d: irq_data
  *
  * Chip has a single mask register. Values of this register are cached
@@ -75,13 +74,15 @@ void irq_gc_mask_set_bit(struct irq_data *d)
 void irq_gc_mask_clr_bit(struct irq_data *d)
 {
 	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
-	u32 mask = 1 << (d->irq - gc->irq_base);
+	struct irq_chip_type *ct = irq_data_get_chip_type(d);
+	u32 mask = d->mask;
 
 	irq_gc_lock(gc);
-	gc->mask_cache &= ~mask;
-	irq_reg_writel(gc->mask_cache, gc->reg_base + cur_regs(d)->mask);
+	*ct->mask_cache &= ~mask;
+	irq_reg_writel(*ct->mask_cache, gc->reg_base + ct->regs.mask);
 	irq_gc_unlock(gc);
 }
+EXPORT_SYMBOL_GPL(irq_gc_mask_clr_bit);
 
 /**
  * irq_gc_unmask_enable_reg - Unmask chip via enable register
@@ -93,11 +94,12 @@ void irq_gc_mask_clr_bit(struct irq_data *d)
 void irq_gc_unmask_enable_reg(struct irq_data *d)
 {
 	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
-	u32 mask = 1 << (d->irq - gc->irq_base);
+	struct irq_chip_type *ct = irq_data_get_chip_type(d);
+	u32 mask = d->mask;
 
 	irq_gc_lock(gc);
-	irq_reg_writel(mask, gc->reg_base + cur_regs(d)->enable);
-	gc->mask_cache |= mask;
+	irq_reg_writel(mask, gc->reg_base + ct->regs.enable);
+	*ct->mask_cache |= mask;
 	irq_gc_unlock(gc);
 }
 
@@ -108,12 +110,14 @@ void irq_gc_unmask_enable_reg(struct irq_data *d)
 void irq_gc_ack_set_bit(struct irq_data *d)
 {
 	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
-	u32 mask = 1 << (d->irq - gc->irq_base);
+	struct irq_chip_type *ct = irq_data_get_chip_type(d);
+	u32 mask = d->mask;
 
 	irq_gc_lock(gc);
-	irq_reg_writel(mask, gc->reg_base + cur_regs(d)->ack);
+	irq_reg_writel(mask, gc->reg_base + ct->regs.ack);
 	irq_gc_unlock(gc);
 }
+EXPORT_SYMBOL_GPL(irq_gc_ack_set_bit);
 
 /**
  * irq_gc_ack_clr_bit - Ack pending interrupt via clearing bit
@@ -122,10 +126,11 @@ void irq_gc_ack_set_bit(struct irq_data *d)
 void irq_gc_ack_clr_bit(struct irq_data *d)
 {
 	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
-	u32 mask = ~(1 << (d->irq - gc->irq_base));
+	struct irq_chip_type *ct = irq_data_get_chip_type(d);
+	u32 mask = ~d->mask;
 
 	irq_gc_lock(gc);
-	irq_reg_writel(mask, gc->reg_base + cur_regs(d)->ack);
+	irq_reg_writel(mask, gc->reg_base + ct->regs.ack);
 	irq_gc_unlock(gc);
 }
 
@@ -136,11 +141,12 @@ void irq_gc_ack_clr_bit(struct irq_data *d)
 void irq_gc_mask_disable_reg_and_ack(struct irq_data *d)
 {
 	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
-	u32 mask = 1 << (d->irq - gc->irq_base);
+	struct irq_chip_type *ct = irq_data_get_chip_type(d);
+	u32 mask = d->mask;
 
 	irq_gc_lock(gc);
-	irq_reg_writel(mask, gc->reg_base + cur_regs(d)->mask);
-	irq_reg_writel(mask, gc->reg_base + cur_regs(d)->ack);
+	irq_reg_writel(mask, gc->reg_base + ct->regs.mask);
+	irq_reg_writel(mask, gc->reg_base + ct->regs.ack);
 	irq_gc_unlock(gc);
 }
 
@@ -151,16 +157,18 @@ void irq_gc_mask_disable_reg_and_ack(struct irq_data *d)
 void irq_gc_eoi(struct irq_data *d)
 {
 	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
-	u32 mask = 1 << (d->irq - gc->irq_base);
+	struct irq_chip_type *ct = irq_data_get_chip_type(d);
+	u32 mask = d->mask;
 
 	irq_gc_lock(gc);
-	irq_reg_writel(mask, gc->reg_base + cur_regs(d)->eoi);
+	irq_reg_writel(mask, gc->reg_base + ct->regs.eoi);
 	irq_gc_unlock(gc);
 }
 
 /**
  * irq_gc_set_wake - Set/clr wake bit for an interrupt
- * @d: irq_data
+ * @d:  irq_data
+ * @on: Indicates whether the wake bit should be set or cleared
  *
  * For chips where the wake from suspend functionality is not
  * configured in a separate register and the wakeup active state is
@@ -169,7 +177,7 @@ void irq_gc_eoi(struct irq_data *d)
 int irq_gc_set_wake(struct irq_data *d, unsigned int on)
 {
 	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
-	u32 mask = 1 << (d->irq - gc->irq_base);
+	u32 mask = d->mask;
 
 	if (!(mask & gc->wake_enabled))
 		return -EINVAL;
@@ -183,6 +191,19 @@ int irq_gc_set_wake(struct irq_data *d, unsigned int on)
 	return 0;
 }
 
+static void
+irq_init_generic_chip(struct irq_chip_generic *gc, const char *name,
+		      int num_ct, unsigned int irq_base,
+		      void __iomem *reg_base, irq_flow_handler_t handler)
+{
+	raw_spin_lock_init(&gc->lock);
+	gc->num_ct = num_ct;
+	gc->irq_base = irq_base;
+	gc->reg_base = reg_base;
+	gc->chip_types->chip.name = name;
+	gc->chip_types->handler = handler;
+}
+
 /**
  * irq_alloc_generic_chip - Allocate a generic chip and initialize it
  * @name:	Name of the irq chip
@@ -203,23 +224,185 @@ irq_alloc_generic_chip(const char *name, int num_ct, unsigned int irq_base,
 
 	gc = kzalloc(sz, GFP_KERNEL);
 	if (gc) {
-		raw_spin_lock_init(&gc->lock);
-		gc->num_ct = num_ct;
-		gc->irq_base = irq_base;
-		gc->reg_base = reg_base;
-		gc->chip_types->chip.name = name;
-		gc->chip_types->handler = handler;
+		irq_init_generic_chip(gc, name, num_ct, irq_base, reg_base,
+				      handler);
 	}
 	return gc;
 }
 EXPORT_SYMBOL_GPL(irq_alloc_generic_chip);
 
+static void
+irq_gc_init_mask_cache(struct irq_chip_generic *gc, enum irq_gc_flags flags)
+{
+	struct irq_chip_type *ct = gc->chip_types;
+	u32 *mskptr = &gc->mask_cache, mskreg = ct->regs.mask;
+	int i;
+
+	for (i = 0; i < gc->num_ct; i++) {
+		if (flags & IRQ_GC_MASK_CACHE_PER_TYPE) {
+			mskptr = &ct[i].mask_cache_priv;
+			mskreg = ct[i].regs.mask;
+		}
+		ct[i].mask_cache = mskptr;
+		if (flags & IRQ_GC_INIT_MASK_CACHE)
+			*mskptr = irq_reg_readl(gc->reg_base + mskreg);
+	}
+}
+
+/**
+ * irq_alloc_domain_generic_chip - Allocate generic chips for an irq domain
+ * @d:			irq domain for which to allocate chips
+ * @irqs_per_chip:	Number of interrupts each chip handles
+ * @num_ct:		Number of irq_chip_type instances associated with this
+ * @name:		Name of the irq chip
+ * @handler:		Default flow handler associated with these chips
+ * @clr:		IRQ_* bits to clear in the mapping function
+ * @set:		IRQ_* bits to set in the mapping function
+ * @gcflags:		Generic chip specific setup flags
+ */
+int irq_alloc_domain_generic_chips(struct irq_domain *d, int irqs_per_chip,
+				   int num_ct, const char *name,
+				   irq_flow_handler_t handler,
+				   unsigned int clr, unsigned int set,
+				   enum irq_gc_flags gcflags)
+{
+	struct irq_domain_chip_generic *dgc;
+	struct irq_chip_generic *gc;
+	int numchips, sz, i;
+	unsigned long flags;
+	void *tmp;
+
+	if (d->gc)
+		return -EBUSY;
+
+	if (d->revmap_type != IRQ_DOMAIN_MAP_LINEAR)
+		return -EINVAL;
+
+	numchips = d->revmap_data.linear.size / irqs_per_chip;
+	if (!numchips)
+		return -EINVAL;
+
+	/* Allocate a pointer, generic chip and chiptypes for each chip */
+	sz = sizeof(*dgc) + numchips * sizeof(gc);
+	sz += numchips * (sizeof(*gc) + num_ct * sizeof(struct irq_chip_type));
+
+	tmp = dgc = kzalloc(sz, GFP_KERNEL);
+	if (!dgc)
+		return -ENOMEM;
+	dgc->irqs_per_chip = irqs_per_chip;
+	dgc->num_chips = numchips;
+	dgc->irq_flags_to_set = set;
+	dgc->irq_flags_to_clear = clr;
+	dgc->gc_flags = gcflags;
+	d->gc = dgc;
+
+	/* Calc pointer to the first generic chip */
+	tmp += sizeof(*dgc) + numchips * sizeof(gc);
+	for (i = 0; i < numchips; i++) {
+		/* Store the pointer to the generic chip */
+		dgc->gc[i] = gc = tmp;
+		irq_init_generic_chip(gc, name, num_ct, i * irqs_per_chip,
+				      NULL, handler);
+		gc->domain = d;
+		raw_spin_lock_irqsave(&gc_lock, flags);
+		list_add_tail(&gc->list, &gc_list);
+		raw_spin_unlock_irqrestore(&gc_lock, flags);
+		/* Calc pointer to the next generic chip */
+		tmp += sizeof(*gc) + num_ct * sizeof(struct irq_chip_type);
+	}
+	return 0;
+}
+EXPORT_SYMBOL_GPL(irq_alloc_domain_generic_chips);
+
+/**
+ * irq_get_domain_generic_chip - Get a pointer to the generic chip of a hw_irq
+ * @d:			irq domain pointer
+ * @hw_irq:		Hardware interrupt number
+ */
+struct irq_chip_generic *
+irq_get_domain_generic_chip(struct irq_domain *d, unsigned int hw_irq)
+{
+	struct irq_domain_chip_generic *dgc = d->gc;
+	int idx;
+
+	if (!dgc)
+		return NULL;
+	idx = hw_irq / dgc->irqs_per_chip;
+	if (idx >= dgc->num_chips)
+		return NULL;
+	return dgc->gc[idx];
+}
+EXPORT_SYMBOL_GPL(irq_get_domain_generic_chip);
+
 /*
  * Separate lockdep class for interrupt chip which can nest irq_desc
  * lock.
  */
 static struct lock_class_key irq_nested_lock_class;
 
+/*
+ * irq_map_generic_chip - Map a generic chip for an irq domain
+ */
+static int irq_map_generic_chip(struct irq_domain *d, unsigned int virq,
+				irq_hw_number_t hw_irq)
+{
+	struct irq_data *data = irq_get_irq_data(virq);
+	struct irq_domain_chip_generic *dgc = d->gc;
+	struct irq_chip_generic *gc;
+	struct irq_chip_type *ct;
+	struct irq_chip *chip;
+	unsigned long flags;
+	int idx;
+
+	if (!d->gc)
+		return -ENODEV;
+
+	idx = hw_irq / dgc->irqs_per_chip;
+	if (idx >= dgc->num_chips)
+		return -EINVAL;
+	gc = dgc->gc[idx];
+
+	idx = hw_irq % dgc->irqs_per_chip;
+
+	if (test_bit(idx, &gc->unused))
+		return -ENOTSUPP;
+
+	if (test_bit(idx, &gc->installed))
+		return -EBUSY;
+
+	ct = gc->chip_types;
+	chip = &ct->chip;
+
+	/* We only init the cache for the first mapping of a generic chip */
+	if (!gc->installed) {
+		raw_spin_lock_irqsave(&gc->lock, flags);
+		irq_gc_init_mask_cache(gc, dgc->gc_flags);
+		raw_spin_unlock_irqrestore(&gc->lock, flags);
+	}
+
+	/* Mark the interrupt as installed */
+	set_bit(idx, &gc->installed);
+
+	if (dgc->gc_flags & IRQ_GC_INIT_NESTED_LOCK)
+		irq_set_lockdep_class(virq, &irq_nested_lock_class);
+
+	if (chip->irq_calc_mask)
+		chip->irq_calc_mask(data);
+	else
+		data->mask = 1 << idx;
+
+	irq_set_chip_and_handler(virq, chip, ct->handler);
+	irq_set_chip_data(virq, gc);
+	irq_modify_status(virq, dgc->irq_flags_to_clear, dgc->irq_flags_to_set);
+	return 0;
+}
+
+struct irq_domain_ops irq_generic_chip_ops = {
+	.map	= irq_map_generic_chip,
+	.xlate	= irq_domain_xlate_onetwocell,
+};
+EXPORT_SYMBOL_GPL(irq_generic_chip_ops);
+
 /**
  * irq_setup_generic_chip - Setup a range of interrupts with a generic chip
  * @gc:		Generic irq chip holding all data
@@ -237,15 +420,14 @@ void irq_setup_generic_chip(struct irq_chip_generic *gc, u32 msk,
 			    unsigned int set)
 {
 	struct irq_chip_type *ct = gc->chip_types;
+	struct irq_chip *chip = &ct->chip;
 	unsigned int i;
 
 	raw_spin_lock(&gc_lock);
 	list_add_tail(&gc->list, &gc_list);
 	raw_spin_unlock(&gc_lock);
 
-	/* Init mask cache ? */
-	if (flags & IRQ_GC_INIT_MASK_CACHE)
-		gc->mask_cache = irq_reg_readl(gc->reg_base + ct->regs.mask);
+	irq_gc_init_mask_cache(gc, flags);
 
 	for (i = gc->irq_base; msk; msk >>= 1, i++) {
 		if (!(msk & 0x01))
@@ -254,7 +436,15 @@ void irq_setup_generic_chip(struct irq_chip_generic *gc, u32 msk,
 		if (flags & IRQ_GC_INIT_NESTED_LOCK)
 			irq_set_lockdep_class(i, &irq_nested_lock_class);
 
-		irq_set_chip_and_handler(i, &ct->chip, ct->handler);
+		if (!(flags & IRQ_GC_NO_MASK)) {
+			struct irq_data *d = irq_get_irq_data(i);
+
+			if (chip->irq_calc_mask)
+				chip->irq_calc_mask(d);
+			else
+				d->mask = 1 << (i - gc->irq_base);
+		}
+		irq_set_chip_and_handler(i, chip, ct->handler);
 		irq_set_chip_data(i, gc);
 		irq_modify_status(i, clr, set);
 	}
@@ -265,7 +455,7 @@ EXPORT_SYMBOL_GPL(irq_setup_generic_chip);
 /**
  * irq_setup_alt_chip - Switch to alternative chip
  * @d:		irq_data for this interrupt
- * @type	Flow type to be initialized
+ * @type:	Flow type to be initialized
  *
  * Only to be called from chip->irq_set_type() callbacks.
  */
@@ -317,6 +507,24 @@ void irq_remove_generic_chip(struct irq_chip_generic *gc, u32 msk,
 }
 EXPORT_SYMBOL_GPL(irq_remove_generic_chip);
 
+static struct irq_data *irq_gc_get_irq_data(struct irq_chip_generic *gc)
+{
+	unsigned int virq;
+
+	if (!gc->domain)
+		return irq_get_irq_data(gc->irq_base);
+
+	/*
+	 * We don't know which of the irqs has been actually
+	 * installed. Use the first one.
+	 */
+	if (!gc->installed)
+		return NULL;
+
+	virq = irq_find_mapping(gc->domain, gc->irq_base + __ffs(gc->installed));
+	return virq ? irq_get_irq_data(virq) : NULL;
+}
+
 #ifdef CONFIG_PM
 static int irq_gc_suspend(void)
 {
@@ -325,8 +533,12 @@ static int irq_gc_suspend(void)
 	list_for_each_entry(gc, &gc_list, list) {
 		struct irq_chip_type *ct = gc->chip_types;
 
-		if (ct->chip.irq_suspend)
-			ct->chip.irq_suspend(irq_get_irq_data(gc->irq_base));
+		if (ct->chip.irq_suspend) {
+			struct irq_data *data = irq_gc_get_irq_data(gc);
+
+			if (data)
+				ct->chip.irq_suspend(data);
+		}
 	}
 	return 0;
 }
@@ -338,8 +550,12 @@ static void irq_gc_resume(void)
 	list_for_each_entry(gc, &gc_list, list) {
 		struct irq_chip_type *ct = gc->chip_types;
 
-		if (ct->chip.irq_resume)
-			ct->chip.irq_resume(irq_get_irq_data(gc->irq_base));
+		if (ct->chip.irq_resume) {
+			struct irq_data *data = irq_gc_get_irq_data(gc);
+
+			if (data)
+				ct->chip.irq_resume(data);
+		}
 	}
 }
 #else
@@ -354,8 +570,12 @@ static void irq_gc_shutdown(void)
 	list_for_each_entry(gc, &gc_list, list) {
 		struct irq_chip_type *ct = gc->chip_types;
 
-		if (ct->chip.irq_pm_shutdown)
-			ct->chip.irq_pm_shutdown(irq_get_irq_data(gc->irq_base));
+		if (ct->chip.irq_pm_shutdown) {
+			struct irq_data *data = irq_gc_get_irq_data(gc);
+
+			if (data)
+				ct->chip.irq_pm_shutdown(data);
+		}
 	}
 }
 
diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index 5a83dde..489921e 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -16,12 +16,6 @@
 #include <linux/smp.h>
 #include <linux/fs.h>
 
-#define IRQ_DOMAIN_MAP_LEGACY 0 /* driver allocated fixed range of irqs.
-				 * ie. legacy 8259, gets irqs 1..15 */
-#define IRQ_DOMAIN_MAP_NOMAP 1 /* no fast reverse mapping */
-#define IRQ_DOMAIN_MAP_LINEAR 2 /* linear map of interrupts */
-#define IRQ_DOMAIN_MAP_TREE 3 /* radix tree */
-
 static LIST_HEAD(irq_domain_list);
 static DEFINE_MUTEX(irq_domain_mutex);
 
@@ -693,7 +687,7 @@ unsigned int irq_create_of_mapping(struct device_node *controller,
 
 	/* Set type if specified and different than the current one */
 	if (type != IRQ_TYPE_NONE &&
-	    type != (irqd_get_trigger_type(irq_get_irq_data(virq))))
+	    type != irq_get_trigger_type(virq))
 		irq_set_irq_type(virq, type);
 	return virq;
 }
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index fa17855..514bcfd 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -555,9 +555,9 @@ int can_request_irq(unsigned int irq, unsigned long irqflags)
 		return 0;
 
 	if (irq_settings_can_request(desc)) {
-		if (desc->action)
-			if (irqflags & desc->action->flags & IRQF_SHARED)
-				canrequest =1;
+		if (!desc->action ||
+		    irqflags & desc->action->flags & IRQF_SHARED)
+			canrequest = 1;
 	}
 	irq_put_desc_unlock(desc, flags);
 	return canrequest;
@@ -840,9 +840,6 @@ static void irq_thread_dtor(struct callback_head *unused)
 static int irq_thread(void *data)
 {
 	struct callback_head on_exit_work;
-	static const struct sched_param param = {
-		.sched_priority = MAX_USER_RT_PRIO/2,
-	};
 	struct irqaction *action = data;
 	struct irq_desc *desc = irq_to_desc(action->irq);
 	irqreturn_t (*handler_fn)(struct irq_desc *desc,
@@ -854,8 +851,6 @@ static int irq_thread(void *data)
 	else
 		handler_fn = irq_thread_fn;
 
-	sched_setscheduler(current, SCHED_FIFO, &param);
-
 	init_task_work(&on_exit_work, irq_thread_dtor);
 	task_work_add(current, &on_exit_work, false);
 
@@ -950,6 +945,9 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
 	 */
 	if (new->thread_fn && !nested) {
 		struct task_struct *t;
+		static const struct sched_param param = {
+			.sched_priority = MAX_USER_RT_PRIO/2,
+		};
 
 		t = kthread_create(irq_thread, new, "irq/%d-%s", irq,
 				   new->name);
@@ -957,6 +955,9 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
 			ret = PTR_ERR(t);
 			goto out_mput;
 		}
+
+		sched_setscheduler(t, SCHED_FIFO, &param);
+
 		/*
 		 * We keep the reference to the task struct even if
 		 * the thread dies to avoid that the interrupt code
diff --git a/kernel/softirq.c b/kernel/softirq.c
index b5197dc..a5f8836 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -127,8 +127,7 @@ static inline void __local_bh_disable(unsigned long ip, unsigned int cnt)
 
 void local_bh_disable(void)
 {
-	__local_bh_disable((unsigned long)__builtin_return_address(0),
-				SOFTIRQ_DISABLE_OFFSET);
+	__local_bh_disable(_RET_IP_, SOFTIRQ_DISABLE_OFFSET);
 }
 
 EXPORT_SYMBOL(local_bh_disable);
@@ -139,7 +138,7 @@ static void __local_bh_enable(unsigned int cnt)
 	WARN_ON_ONCE(!irqs_disabled());
 
 	if (softirq_count() == cnt)
-		trace_softirqs_on((unsigned long)__builtin_return_address(0));
+		trace_softirqs_on(_RET_IP_);
 	sub_preempt_count(cnt);
 }
 
@@ -184,7 +183,7 @@ static inline void _local_bh_enable_ip(unsigned long ip)
 
 void local_bh_enable(void)
 {
-	_local_bh_enable_ip((unsigned long)__builtin_return_address(0));
+	_local_bh_enable_ip(_RET_IP_);
 }
 EXPORT_SYMBOL(local_bh_enable);
 
@@ -223,8 +222,7 @@ asmlinkage void __do_softirq(void)
 	pending = local_softirq_pending();
 	account_irq_enter_time(current);
 
-	__local_bh_disable((unsigned long)__builtin_return_address(0),
-				SOFTIRQ_OFFSET);
+	__local_bh_disable(_RET_IP_, SOFTIRQ_OFFSET);
 	lockdep_softirq_enter();
 
 	cpu = smp_processor_id();
