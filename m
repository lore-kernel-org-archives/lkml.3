Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752360AbaBVXtr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 18:49:47 -0500
Received: from www.linutronix.de ([62.245.132.108]:49226 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547AbaBVXtq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 18:49:46 -0500
Date: Sun, 23 Feb 2014 00:49:52 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [GIT pull] irq fixes for 3.14
Message-ID: <alpine.DEB.2.02.1402230046470.21251@ionos.tec.linutronix.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull the latest irq-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git irq-urgent-for-linus

We present you herewith:

 * Another four fixlets to tame the ARM orion irq chip

Thanks,

	tglx

------------------>
Andrew Lunn (1):
      irqchip: orion: Fix getting generic chip pointer.

Sebastian Hesselbarth (3):
      irqchip: orion: clear bridge cause register on init
      irqchip: orion: use handle_edge_irq on bridge irqs
      irqchip: orion: clear stale interrupts in irq_startup


 drivers/irqchip/irq-orion.c |   22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/drivers/irqchip/irq-orion.c b/drivers/irqchip/irq-orion.c
index e51d400..8e41be6 100644
--- a/drivers/irqchip/irq-orion.c
+++ b/drivers/irqchip/irq-orion.c
@@ -111,7 +111,8 @@ IRQCHIP_DECLARE(orion_intc, "marvell,orion-intc", orion_irq_init);
 static void orion_bridge_irq_handler(unsigned int irq, struct irq_desc *desc)
 {
 	struct irq_domain *d = irq_get_handler_data(irq);
-	struct irq_chip_generic *gc = irq_get_domain_generic_chip(d, irq);
+
+	struct irq_chip_generic *gc = irq_get_domain_generic_chip(d, 0);
 	u32 stat = readl_relaxed(gc->reg_base + ORION_BRIDGE_IRQ_CAUSE) &
 		   gc->mask_cache;
 
@@ -123,6 +124,19 @@ static void orion_bridge_irq_handler(unsigned int irq, struct irq_desc *desc)
 	}
 }
 
+/*
+ * Bridge IRQ_CAUSE is asserted regardless of IRQ_MASK register.
+ * To avoid interrupt events on stale irqs, we clear them before unmask.
+ */
+static unsigned int orion_bridge_irq_startup(struct irq_data *d)
+{
+	struct irq_chip_type *ct = irq_data_get_chip_type(d);
+
+	ct->chip.irq_ack(d);
+	ct->chip.irq_unmask(d);
+	return 0;
+}
+
 static int __init orion_bridge_irq_init(struct device_node *np,
 					struct device_node *parent)
 {
@@ -143,7 +157,7 @@ static int __init orion_bridge_irq_init(struct device_node *np,
 	}
 
 	ret = irq_alloc_domain_generic_chips(domain, nrirqs, 1, np->name,
-			     handle_level_irq, clr, 0, IRQ_GC_INIT_MASK_CACHE);
+			     handle_edge_irq, clr, 0, IRQ_GC_INIT_MASK_CACHE);
 	if (ret) {
 		pr_err("%s: unable to alloc irq domain gc\n", np->name);
 		return ret;
@@ -176,12 +190,14 @@ static int __init orion_bridge_irq_init(struct device_node *np,
 
 	gc->chip_types[0].regs.ack = ORION_BRIDGE_IRQ_CAUSE;
 	gc->chip_types[0].regs.mask = ORION_BRIDGE_IRQ_MASK;
+	gc->chip_types[0].chip.irq_startup = orion_bridge_irq_startup;
 	gc->chip_types[0].chip.irq_ack = irq_gc_ack_clr_bit;
 	gc->chip_types[0].chip.irq_mask = irq_gc_mask_clr_bit;
 	gc->chip_types[0].chip.irq_unmask = irq_gc_mask_set_bit;
 
-	/* mask all interrupts */
+	/* mask and clear all interrupts */
 	writel(0, gc->reg_base + ORION_BRIDGE_IRQ_MASK);
+	writel(0, gc->reg_base + ORION_BRIDGE_IRQ_CAUSE);
 
 	irq_set_handler_data(irq, domain);
 	irq_set_chained_handler(irq, orion_bridge_irq_handler);
