Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932810AbaESUMa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 16:12:30 -0400
Received: from smtp-69.nebula.fi ([83.145.220.69]:57924 "EHLO smtp.nebula.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754869AbaESUM1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 16:12:27 -0400
From: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
To: linux-kernel@vger.kernel.org, linux@openrisc.net, jonas@southpole.se
Cc: tglx@linutronix.de,
        Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
Subject: [PATCH v2] openrisc: irq: use irqchip framework
Date: Mon, 19 May 2014 23:11:43 +0300
Message-Id: <1400530303-29182-1-git-send-email-stefan.kristiansson@saunalahti.fi>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In addition to consolidating the or1k-pic with other interrupt
controllers, this makes OpenRISC less tied to its on-cpu
interrupt controller.

All or1k-pic specific parts are moved out of irq.c and into
drivers/irqchip/irq-or1k-pic.c

In that transition, a couple of changes have been done:
- The wrongly handled or1k_pic_mask_ack() for the non-or1200
  case have been fixed.
- The warnings for the non-or1200 case have been removed.
- A hook for registering a handle_arch_irq function have been
  added.

Signed-off-by: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
---
Changes in v2:
 - Move or1k-pic related code into irq-or1k-pic
 - Add documentation for device tree bindings
---
 .../interrupt-controller/opencores,or1k-pic.txt    |  16 +++
 arch/openrisc/Kconfig                              |   1 +
 arch/openrisc/include/asm/irq.h                    |   3 +
 arch/openrisc/kernel/irq.c                         | 146 ++-------------------
 drivers/irqchip/Kconfig                            |   4 +
 drivers/irqchip/Makefile                           |   1 +
 drivers/irqchip/irq-or1k-pic.c                     | 135 +++++++++++++++++++
 7 files changed, 173 insertions(+), 133 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/interrupt-controller/opencores,or1k-pic.txt
 create mode 100644 drivers/irqchip/irq-or1k-pic.c

diff --git a/Documentation/devicetree/bindings/interrupt-controller/opencores,or1k-pic.txt b/Documentation/devicetree/bindings/interrupt-controller/opencores,or1k-pic.txt
new file mode 100644
index 0000000..1da0b78
--- /dev/null
+++ b/Documentation/devicetree/bindings/interrupt-controller/opencores,or1k-pic.txt
@@ -0,0 +1,16 @@
+OpenRISC 1000 Programmable Interrupt Controller
+
+Required properties:
+
+- compatible : should be "opencores,o1k-pic"
+- interrupt-controller : Identifies the node as an interrupt controller
+- #interrupt-cells : Specifies the number of cells needed to encode an
+  interrupt source. The value shall be 1.
+
+Example:
+
+intc: interrupt-controller {
+	compatible = "opencores,or1k-pic";
+	interrupt-controller;
+	#interrupt-cells = <1>;
+};
diff --git a/arch/openrisc/Kconfig b/arch/openrisc/Kconfig
index 2ca7b91..8120fe2 100644
--- a/arch/openrisc/Kconfig
+++ b/arch/openrisc/Kconfig
@@ -23,6 +23,7 @@ config OPENRISC
 	select GENERIC_STRNLEN_USER
 	select MODULES_USE_ELF_RELA
 	select HAVE_DEBUG_STACKOVERFLOW
+	select OR1K_PIC
 
 config MMU
 	def_bool y
diff --git a/arch/openrisc/include/asm/irq.h b/arch/openrisc/include/asm/irq.h
index eb612b1..b84634c 100644
--- a/arch/openrisc/include/asm/irq.h
+++ b/arch/openrisc/include/asm/irq.h
@@ -24,4 +24,7 @@
 
 #define NO_IRQ		(-1)
 
+void handle_IRQ(unsigned int, struct pt_regs *);
+extern void set_handle_irq(void (*handle_irq)(struct pt_regs *));
+
 #endif /* __ASM_OPENRISC_IRQ_H__ */
diff --git a/arch/openrisc/kernel/irq.c b/arch/openrisc/kernel/irq.c
index 8ec77bc..967eb14 100644
--- a/arch/openrisc/kernel/irq.c
+++ b/arch/openrisc/kernel/irq.c
@@ -16,11 +16,10 @@
 
 #include <linux/interrupt.h>
 #include <linux/init.h>
-#include <linux/of.h>
 #include <linux/ftrace.h>
 #include <linux/irq.h>
+#include <linux/irqchip.h>
 #include <linux/export.h>
-#include <linux/irqdomain.h>
 #include <linux/irqflags.h>
 
 /* read interrupt enabled status */
@@ -37,150 +36,31 @@ void arch_local_irq_restore(unsigned long flags)
 }
 EXPORT_SYMBOL(arch_local_irq_restore);
 
-
-/* OR1K PIC implementation */
-
-/* We're a couple of cycles faster than the generic implementations with
- * these 'fast' versions.
- */
-
-static void or1k_pic_mask(struct irq_data *data)
-{
-	mtspr(SPR_PICMR, mfspr(SPR_PICMR) & ~(1UL << data->hwirq));
-}
-
-static void or1k_pic_unmask(struct irq_data *data)
-{
-	mtspr(SPR_PICMR, mfspr(SPR_PICMR) | (1UL << data->hwirq));
-}
-
-static void or1k_pic_ack(struct irq_data *data)
-{
-	/* EDGE-triggered interrupts need to be ack'ed in order to clear
-	 * the latch.
-	 * LEVEL-triggered interrupts do not need to be ack'ed; however,
-	 * ack'ing the interrupt has no ill-effect and is quicker than
-	 * trying to figure out what type it is...
-	 */
-
-	/* The OpenRISC 1000 spec says to write a 1 to the bit to ack the
-	 * interrupt, but the OR1200 does this backwards and requires a 0
-	 * to be written...
-	 */
-
-#ifdef CONFIG_OR1K_1200
-	/* There are two oddities with the OR1200 PIC implementation:
-	 * i)  LEVEL-triggered interrupts are latched and need to be cleared
-	 * ii) the interrupt latch is cleared by writing a 0 to the bit,
-	 *     as opposed to a 1 as mandated by the spec
-	 */
-
-	mtspr(SPR_PICSR, mfspr(SPR_PICSR) & ~(1UL << data->hwirq));
-#else
-	WARN(1, "Interrupt handling possibly broken\n");
-	mtspr(SPR_PICSR, (1UL << data->hwirq));
-#endif
-}
-
-static void or1k_pic_mask_ack(struct irq_data *data)
-{
-	/* Comments for pic_ack apply here, too */
-
-#ifdef CONFIG_OR1K_1200
-	mtspr(SPR_PICMR, mfspr(SPR_PICMR) & ~(1UL << data->hwirq));
-	mtspr(SPR_PICSR, mfspr(SPR_PICSR) & ~(1UL << data->hwirq));
-#else
-	WARN(1, "Interrupt handling possibly broken\n");
-	mtspr(SPR_PICMR, (1UL << data->hwirq));
-	mtspr(SPR_PICSR, (1UL << data->hwirq));
-#endif
-}
-
-#if 0
-static int or1k_pic_set_type(struct irq_data *data, unsigned int flow_type)
-{
-	/* There's nothing to do in the PIC configuration when changing
-	 * flow type.  Level and edge-triggered interrupts are both
-	 * supported, but it's PIC-implementation specific which type
-	 * is handled. */
-
-	return irq_setup_alt_chip(data, flow_type);
-}
-#endif
-
-static struct irq_chip or1k_dev = {
-	.name = "or1k-PIC",
-	.irq_unmask = or1k_pic_unmask,
-	.irq_mask = or1k_pic_mask,
-	.irq_ack = or1k_pic_ack,
-	.irq_mask_ack = or1k_pic_mask_ack,
-};
-
-static struct irq_domain *root_domain;
-
-static inline int pic_get_irq(int first)
-{
-	int hwirq;
-
-	hwirq = ffs(mfspr(SPR_PICSR) >> first);
-	if (!hwirq)
-		return NO_IRQ;
-	else
-		hwirq = hwirq + first -1;
-
-	return irq_find_mapping(root_domain, hwirq);
-}
-
-
-static int or1k_map(struct irq_domain *d, unsigned int irq, irq_hw_number_t hw)
+void __init init_IRQ(void)
 {
-	irq_set_chip_and_handler_name(irq, &or1k_dev,
-				      handle_level_irq, "level");
-	irq_set_status_flags(irq, IRQ_LEVEL | IRQ_NOPROBE);
-
-	return 0;
+	irqchip_init();
 }
 
-static const struct irq_domain_ops or1k_irq_domain_ops = {
-	.xlate = irq_domain_xlate_onecell,
-	.map = or1k_map,
-};
-
-/*
- * This sets up the IRQ domain for the PIC built in to the OpenRISC
- * 1000 CPU.  This is the "root" domain as these are the interrupts
- * that directly trigger an exception in the CPU.
- */
-static void __init or1k_irq_init(void)
-{
-	struct device_node *intc = NULL;
-
-	/* The interrupt controller device node is mandatory */
-	intc = of_find_compatible_node(NULL, NULL, "opencores,or1k-pic");
-	BUG_ON(!intc);
-
-	/* Disable all interrupts until explicitly requested */
-	mtspr(SPR_PICMR, (0UL));
-
-	root_domain = irq_domain_add_linear(intc, 32,
-					    &or1k_irq_domain_ops, NULL);
-}
+static void (*handle_arch_irq)(struct pt_regs *);
 
-void __init init_IRQ(void)
+void __init set_handle_irq(void (*handle_irq)(struct pt_regs *))
 {
-	or1k_irq_init();
+	handle_arch_irq = handle_irq;
 }
 
-void __irq_entry do_IRQ(struct pt_regs *regs)
+void handle_IRQ(unsigned int irq, struct pt_regs *regs)
 {
-	int irq = -1;
 	struct pt_regs *old_regs = set_irq_regs(regs);
 
 	irq_enter();
 
-	while ((irq = pic_get_irq(irq + 1)) != NO_IRQ)
-		generic_handle_irq(irq);
+	generic_handle_irq(irq);
 
 	irq_exit();
 	set_irq_regs(old_regs);
 }
+
+void __irq_entry do_IRQ(struct pt_regs *regs)
+{
+	handle_arch_irq(regs);
+}
diff --git a/drivers/irqchip/Kconfig b/drivers/irqchip/Kconfig
index 3792a1a..f657872 100644
--- a/drivers/irqchip/Kconfig
+++ b/drivers/irqchip/Kconfig
@@ -61,3 +61,7 @@ config VERSATILE_FPGA_IRQ_NR
        int
        default 4
        depends on VERSATILE_FPGA_IRQ
+
+config OR1K_PIC
+	bool
+	select IRQ_DOMAIN
diff --git a/drivers/irqchip/Makefile b/drivers/irqchip/Makefile
index c60b901..1ae2c103 100644
--- a/drivers/irqchip/Makefile
+++ b/drivers/irqchip/Makefile
@@ -22,3 +22,4 @@ obj-$(CONFIG_RENESAS_IRQC)		+= irq-renesas-irqc.o
 obj-$(CONFIG_VERSATILE_FPGA_IRQ)	+= irq-versatile-fpga.o
 obj-$(CONFIG_ARCH_VT8500)		+= irq-vt8500.o
 obj-$(CONFIG_TB10X_IRQC)		+= irq-tb10x.o
+obj-$(CONFIG_OR1K_PIC)			+= irq-or1k-pic.o
diff --git a/drivers/irqchip/irq-or1k-pic.c b/drivers/irqchip/irq-or1k-pic.c
new file mode 100644
index 0000000..989c055
--- /dev/null
+++ b/drivers/irqchip/irq-or1k-pic.c
@@ -0,0 +1,135 @@
+/*
+ * Copyright (C) 2010-2011 Jonas Bonn <jonas@southpole.se>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#include <linux/irq.h>
+#include <linux/of.h>
+#include <linux/of_irq.h>
+#include <linux/of_address.h>
+
+#include "irqchip.h"
+
+/* OR1K PIC implementation */
+
+/* We're a couple of cycles faster than the generic implementations with
+ * these 'fast' versions.
+ */
+
+static void or1k_pic_mask(struct irq_data *data)
+{
+	mtspr(SPR_PICMR, mfspr(SPR_PICMR) & ~(1UL << data->hwirq));
+}
+
+static void or1k_pic_unmask(struct irq_data *data)
+{
+	mtspr(SPR_PICMR, mfspr(SPR_PICMR) | (1UL << data->hwirq));
+}
+
+static void or1k_pic_ack(struct irq_data *data)
+{
+	/* EDGE-triggered interrupts need to be ack'ed in order to clear
+	 * the latch.
+	 * LEVEL-triggered interrupts do not need to be ack'ed; however,
+	 * ack'ing the interrupt has no ill-effect and is quicker than
+	 * trying to figure out what type it is...
+	 */
+
+	/* The OpenRISC 1000 spec says to write a 1 to the bit to ack the
+	 * interrupt, but the OR1200 does this backwards and requires a 0
+	 * to be written...
+	 */
+
+#ifdef CONFIG_OR1K_1200
+	/* There are two oddities with the OR1200 PIC implementation:
+	 * i)  LEVEL-triggered interrupts are latched and need to be cleared
+	 * ii) the interrupt latch is cleared by writing a 0 to the bit,
+	 *     as opposed to a 1 as mandated by the spec
+	 */
+
+	mtspr(SPR_PICSR, mfspr(SPR_PICSR) & ~(1UL << data->hwirq));
+#else
+	mtspr(SPR_PICSR, (1UL << data->hwirq));
+#endif
+}
+
+static void or1k_pic_mask_ack(struct irq_data *data)
+{
+	mtspr(SPR_PICMR, mfspr(SPR_PICMR) & ~(1UL << data->hwirq));
+
+	/* Comments for pic_ack apply here, too */
+#ifdef CONFIG_OR1K_1200
+	mtspr(SPR_PICSR, mfspr(SPR_PICSR) & ~(1UL << data->hwirq));
+#else
+	mtspr(SPR_PICSR, (1UL << data->hwirq));
+#endif
+}
+
+static struct irq_chip or1k_dev = {
+	.name = "or1k-PIC",
+	.irq_unmask = or1k_pic_unmask,
+	.irq_mask = or1k_pic_mask,
+	.irq_ack = or1k_pic_ack,
+	.irq_mask_ack = or1k_pic_mask_ack,
+};
+
+static struct irq_domain *root_domain;
+
+static inline int pic_get_irq(int first)
+{
+	int hwirq;
+
+	hwirq = ffs(mfspr(SPR_PICSR) >> first);
+	if (!hwirq)
+		return NO_IRQ;
+	else
+		hwirq = hwirq + first -1;
+
+	return irq_find_mapping(root_domain, hwirq);
+}
+
+static void or1k_pic_handle_irq(struct pt_regs *regs)
+{
+	int irq = -1;
+
+	while ((irq = pic_get_irq(irq + 1)) != NO_IRQ)
+		handle_IRQ(irq, regs);
+}
+
+static int or1k_map(struct irq_domain *d, unsigned int irq, irq_hw_number_t hw)
+{
+	irq_set_chip_and_handler_name(irq, &or1k_dev,
+				      handle_level_irq, "level");
+	irq_set_status_flags(irq, IRQ_LEVEL | IRQ_NOPROBE);
+
+	return 0;
+}
+
+static const struct irq_domain_ops or1k_irq_domain_ops = {
+	.xlate = irq_domain_xlate_onecell,
+	.map = or1k_map,
+};
+
+/*
+ * This sets up the IRQ domain for the PIC built in to the OpenRISC
+ * 1000 CPU.  This is the "root" domain as these are the interrupts
+ * that directly trigger an exception in the CPU.
+ */
+static int __init
+or1k_irq_init(struct device_node *intc,  struct device_node *parent)
+{
+	/* Disable all interrupts until explicitly requested */
+	mtspr(SPR_PICMR, (0UL));
+
+	root_domain = irq_domain_add_linear(intc, 32,
+					    &or1k_irq_domain_ops, NULL);
+
+	set_handle_irq(or1k_pic_handle_irq);
+
+	return 0;
+}
+IRQCHIP_DECLARE(or1k_pic, "opencores,or1k-pic", or1k_irq_init);
-- 
1.8.3.2

