Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752481AbaCDFdi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 00:33:38 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:11789 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065AbaCDFdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 00:33:37 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 108.39.110.144
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/YZgIBowVFVonS36PCWuip9z5OyhJjrMQ=
X-DKIM: OpenDKIM Filter v2.0.1 titan D703E5392B0
From: Jason Cooper <jason@lakedaemon.net>
To: Thomas Gleixner <tglx@linutronix.de>, Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@googlemail.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Jason Cooper <jason@lakedaemon.net>
Subject: [PATCH] Revert "irqchip: irq-dove: Add PMU interrupt controller."
Date: Tue,  4 Mar 2014 05:32:40 +0000
Message-Id: <1393911160-7688-1-git-send-email-jason@lakedaemon.net>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140304030838.GA1872@titan.lakedaemon.net>
References: <20140304030838.GA1872@titan.lakedaemon.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit 40b367d95fb3d60fc1edb9ba8f6ef52272e48936.

Russell King has raised the idea of creating a proper PMU driver for
this SoC that would incorporate the functionality currently in this
driver.  It would also cover the use case for the graphics subsystem on
this SoC.

To prevent having to maintain the devicetree ABI for this limited
interrupt-handler driver, we revert the driver before it hits a mainline
tagged release (eg v3.15).

Signed-off-by: Jason Cooper <jason@lakedaemon.net>
---
Thomas,

Well, this is embarrassing.  It took so long to get this driver on the road to
mainline, only to realize today that we were going to paint ourselves into a
corner wrt the devicetree ABI this creates.

So, rather let a bad ABI make it to mainline, we revert the driver.  We'll sit
down with Russell, who's most familiar with the graphics subsystem on this SoC,
and hammer out a better longterm solution.

You can pick this, or I can send you an incremental pull request.  Whichever is
easiest for you.  I've already removed the DT node from the mvebu tree, so this
won't be used by anything.

thx,

Jason.

 .../interrupt-controller/marvell,dove-pmu-intc.txt |  17 ---
 drivers/irqchip/Makefile                           |   1 -
 drivers/irqchip/irq-dove.c                         | 126 ---------------------
 3 files changed, 144 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/interrupt-controller/marvell,dove-pmu-intc.txt
 delete mode 100644 drivers/irqchip/irq-dove.c

diff --git a/Documentation/devicetree/bindings/interrupt-controller/marvell,dove-pmu-intc.txt b/Documentation/devicetree/bindings/interrupt-controller/marvell,dove-pmu-intc.txt
deleted file mode 100644
index 1feb5825d372..000000000000
--- a/Documentation/devicetree/bindings/interrupt-controller/marvell,dove-pmu-intc.txt
+++ /dev/null
@@ -1,17 +0,0 @@
-Marvell Dove Power Management Unit interrupt controller
-
-Required properties:
-- compatible: shall be "marvell,dove-pmu-intc"
-- reg: base address of PMU interrupt registers starting with CAUSE register
-- interrupts: PMU interrupt of the main interrupt controller
-- interrupt-controller: identifies the node as an interrupt controller
-- #interrupt-cells: number of cells to encode an interrupt source, shall be 1
-
-Example:
-	pmu_intc: pmu-interrupt-ctrl@d0050 {
-		compatible = "marvell,dove-pmu-intc";
-		interrupt-controller;
-		#interrupt-cells = <1>;
-		reg = <0xd0050 0x8>;
-		interrupts = <33>;
-	};
diff --git a/drivers/irqchip/Makefile b/drivers/irqchip/Makefile
index f743006ce7ad..c60b9010b152 100644
--- a/drivers/irqchip/Makefile
+++ b/drivers/irqchip/Makefile
@@ -1,7 +1,6 @@
 obj-$(CONFIG_IRQCHIP)			+= irqchip.o
 
 obj-$(CONFIG_ARCH_BCM2835)		+= irq-bcm2835.o
-obj-$(CONFIG_ARCH_DOVE)			+= irq-dove.o
 obj-$(CONFIG_ARCH_EXYNOS)		+= exynos-combiner.o
 obj-$(CONFIG_ARCH_MMP)			+= irq-mmp.o
 obj-$(CONFIG_ARCH_MVEBU)		+= irq-armada-370-xp.o
diff --git a/drivers/irqchip/irq-dove.c b/drivers/irqchip/irq-dove.c
deleted file mode 100644
index 788acd89848a..000000000000
--- a/drivers/irqchip/irq-dove.c
+++ /dev/null
@@ -1,126 +0,0 @@
-/*
- * Marvell Dove SoCs PMU IRQ chip driver.
- *
- * Andrew Lunn <andrew@lunn.ch>
- *
- * This file is licensed under the terms of the GNU General Public
- * License version 2.  This program is licensed "as is" without any
- * warranty of any kind, whether express or implied.
- */
-
-#include <linux/io.h>
-#include <linux/irq.h>
-#include <linux/of.h>
-#include <linux/of_address.h>
-#include <linux/of_irq.h>
-#include <asm/exception.h>
-#include <asm/mach/irq.h>
-
-#include "irqchip.h"
-
-#define DOVE_PMU_IRQ_CAUSE	0x00
-#define DOVE_PMU_IRQ_MASK	0x04
-
-static void dove_pmu_irq_handler(unsigned int irq, struct irq_desc *desc)
-{
-	struct irq_domain *d = irq_get_handler_data(irq);
-	struct irq_chip_generic *gc = irq_get_domain_generic_chip(d, 0);
-	u32 stat = readl_relaxed(gc->reg_base + DOVE_PMU_IRQ_CAUSE) &
-		   gc->mask_cache;
-
-	while (stat) {
-		u32 hwirq = ffs(stat) - 1;
-
-		generic_handle_irq(irq_find_mapping(d, gc->irq_base + hwirq));
-		stat &= ~(1 << hwirq);
-	}
-}
-
-static void pmu_irq_ack(struct irq_data *d)
-{
-	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
-	struct irq_chip_type *ct = irq_data_get_chip_type(d);
-	u32 mask = ~d->mask;
-
-	/*
-	 * The PMU mask register is not RW0C: it is RW.	 This means that
-	 * the bits take whatever value is written to them; if you write
-	 * a '1', you will set the interrupt.
-	 *
-	 * Unfortunately this means there is NO race free way to clear
-	 * these interrupts.
-	 *
-	 * So, let's structure the code so that the window is as small as
-	 * possible.
-	 */
-	irq_gc_lock(gc);
-	mask &= irq_reg_readl(gc->reg_base +  ct->regs.ack);
-	irq_reg_writel(mask, gc->reg_base +  ct->regs.ack);
-	irq_gc_unlock(gc);
-}
-
-static int __init dove_pmu_irq_init(struct device_node *np,
-				    struct device_node *parent)
-{
-	unsigned int clr = IRQ_NOREQUEST | IRQ_NOPROBE | IRQ_NOAUTOEN;
-	struct resource r;
-	struct irq_domain *domain;
-	struct irq_chip_generic *gc;
-	int ret, irq, nrirqs = 7;
-
-	domain = irq_domain_add_linear(np, nrirqs,
-				       &irq_generic_chip_ops, NULL);
-	if (!domain) {
-		pr_err("%s: unable to add irq domain\n", np->name);
-		return -ENOMEM;
-	}
-
-	ret = irq_alloc_domain_generic_chips(domain, nrirqs, 1, np->name,
-			     handle_level_irq, clr, 0, IRQ_GC_INIT_MASK_CACHE);
-	if (ret) {
-		pr_err("%s: unable to alloc irq domain gc\n", np->name);
-		return ret;
-	}
-
-	ret = of_address_to_resource(np, 0, &r);
-	if (ret) {
-		pr_err("%s: unable to get resource\n", np->name);
-		return ret;
-	}
-
-	if (!request_mem_region(r.start, resource_size(&r), np->name)) {
-		pr_err("%s: unable to request mem region\n", np->name);
-		return -ENOMEM;
-	}
-
-	/* Map the parent interrupt for the chained handler */
-	irq = irq_of_parse_and_map(np, 0);
-	if (irq <= 0) {
-		pr_err("%s: unable to parse irq\n", np->name);
-		return -EINVAL;
-	}
-
-	gc = irq_get_domain_generic_chip(domain, 0);
-	gc->reg_base = ioremap(r.start, resource_size(&r));
-	if (!gc->reg_base) {
-		pr_err("%s: unable to map resource\n", np->name);
-		return -ENOMEM;
-	}
-
-	gc->chip_types[0].regs.ack = DOVE_PMU_IRQ_CAUSE;
-	gc->chip_types[0].regs.mask = DOVE_PMU_IRQ_MASK;
-	gc->chip_types[0].chip.irq_ack = pmu_irq_ack;
-	gc->chip_types[0].chip.irq_mask = irq_gc_mask_clr_bit;
-	gc->chip_types[0].chip.irq_unmask = irq_gc_mask_set_bit;
-
-	/* mask and clear all interrupts */
-	writel(0, gc->reg_base + DOVE_PMU_IRQ_MASK);
-	writel(0, gc->reg_base + DOVE_PMU_IRQ_CAUSE);
-
-	irq_set_handler_data(irq, domain);
-	irq_set_chained_handler(irq, dove_pmu_irq_handler);
-
-	return 0;
-}
-IRQCHIP_DECLARE(dove_pmu_intc,
-		"marvell,dove-pmu-intc", dove_pmu_irq_init);
-- 
1.9.0

