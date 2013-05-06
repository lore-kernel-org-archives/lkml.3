Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754031Ab3EFOae (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 10:30:34 -0400
Received: from www.linutronix.de ([62.245.132.108]:52283 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753790Ab3EFOab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 10:30:31 -0400
Message-Id: <20130506142539.523110430@linutronix.de>
User-Agent: quilt/0.48-1
Date: Mon, 06 May 2013 14:30:28 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Arnd Bergmann <arnd@arndb.de>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Jean-Francois Moine <moinejf@free.fr>,
        Gerlando Falauto <gerlando.falauto@keymile.com>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [patch 8/8] irqchip: sun4i: Convert to generic irq chip
References: <20130503212258.385818955@linutronix.de>
 <20130506142348.321859745@linutronix.de>
Content-Disposition: inline; filename=irqchip-convert-sun4i.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Proof of concept patch to demonstrate the new irqdomain support for
the generic irq chip. Untested !!

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/irqchip/irq-sun4i.c |  100 ++++++++++++--------------------------------
 1 file changed, 29 insertions(+), 71 deletions(-)

Index: linux-2.6/drivers/irqchip/irq-sun4i.c
===================================================================
--- linux-2.6.orig/drivers/irqchip/irq-sun4i.c
+++ linux-2.6/drivers/irqchip/irq-sun4i.c
@@ -32,70 +32,43 @@
 #define SUN4I_IRQ_FIQ_PENDING_REG(x)	(0x20 + 0x4 * x)
 #define SUN4I_IRQ_ENABLE_REG(x)		(0x40 + 0x4 * x)
 #define SUN4I_IRQ_MASK_REG(x)		(0x50 + 0x4 * x)
+#define SUN4I_NUM_CHIPS			3
+#define SUN4I_IRQS_PER_CHIP		32
 
 static void __iomem *sun4i_irq_base;
 static struct irq_domain *sun4i_irq_domain;
 
 static asmlinkage void __exception_irq_entry sun4i_handle_irq(struct pt_regs *regs);
 
-void sun4i_irq_ack(struct irq_data *irqd)
+static int __init sun4i_init_domain_chips(void)
 {
-	unsigned int irq = irqd_to_hwirq(irqd);
-	unsigned int irq_off = irq % 32;
-	int reg = irq / 32;
-	u32 val;
-
-	val = readl(sun4i_irq_base + SUN4I_IRQ_PENDING_REG(reg));
-	writel(val | (1 << irq_off),
-	       sun4i_irq_base + SUN4I_IRQ_PENDING_REG(reg));
-}
-
-static void sun4i_irq_mask(struct irq_data *irqd)
-{
-	unsigned int irq = irqd_to_hwirq(irqd);
-	unsigned int irq_off = irq % 32;
-	int reg = irq / 32;
-	u32 val;
-
-	val = readl(sun4i_irq_base + SUN4I_IRQ_ENABLE_REG(reg));
-	writel(val & ~(1 << irq_off),
-	       sun4i_irq_base + SUN4I_IRQ_ENABLE_REG(reg));
-}
-
-static void sun4i_irq_unmask(struct irq_data *irqd)
-{
-	unsigned int irq = irqd_to_hwirq(irqd);
-	unsigned int irq_off = irq % 32;
-	int reg = irq / 32;
-	u32 val;
-
-	val = readl(sun4i_irq_base + SUN4I_IRQ_ENABLE_REG(reg));
-	writel(val | (1 << irq_off),
-	       sun4i_irq_base + SUN4I_IRQ_ENABLE_REG(reg));
-}
-
-static struct irq_chip sun4i_irq_chip = {
-	.name		= "sun4i_irq",
-	.irq_ack	= sun4i_irq_ack,
-	.irq_mask	= sun4i_irq_mask,
-	.irq_unmask	= sun4i_irq_unmask,
-};
-
-static int sun4i_irq_map(struct irq_domain *d, unsigned int virq,
-			 irq_hw_number_t hw)
-{
-	irq_set_chip_and_handler(virq, &sun4i_irq_chip,
-				 handle_level_irq);
-	set_irq_flags(virq, IRQF_VALID | IRQF_PROBE);
-
+	unsigned int clr = IRQ_NOREQUEST | IRQ_NOPROBE | IRQ_NOAUTOEN;
+	struct irq_chip_generic *gc;
+	int i, ret, base = 0;
+
+	ret = irq_alloc_domain_generic_chips(d, SUN4I_IRQS_PER_CHIP, 1,
+					     "sun4i_irq", handle_level_irq,
+					     clr, 0, IRQ_GC_INIT_MASK_CACHE);
+	if (ret)
+		return ret;
+
+	for (i = 0; i < SUN4I_NUM_CHIPS; i++, base += SUN4I_IRQS_PER_CHIP) {
+		gc = irq_get_domain_generic_chip(sun4i_irq_domain, base);
+		gc->reg_base = sun4i_irq_base;
+		gc->chip_types[0].regs.mask = SUN4I_IRQ_ENABLE_REG(i);
+		gc->chip_types[0].regs.ack = SUN4I_IRQ_PENDING_REG(i);
+		gc->chip_types[0].chip.mask = irq_gc_mask_clr_bit;
+		gc->chip_types[0].chip.ack = irq_gc_ack_set_bit;
+		gc->chip_types[0].chip.unmask = irq_gc_mask_set_bit;
+
+		/* Disable, mask and clear all pending interrupts */
+		writel(0, sun4i_irq_base + SUN4I_IRQ_ENABLE_REG(i));
+		writel(0, sun4i_irq_base + SUN4I_IRQ_MASK_REG(i));
+		writel(0xffffffff, sun4i_irq_base + SUN4I_IRQ_PENDING_REG(i));
+	}
 	return 0;
 }
 
-static struct irq_domain_ops sun4i_irq_ops = {
-	.map = sun4i_irq_map,
-	.xlate = irq_domain_xlate_onecell,
-};
-
 static int __init sun4i_of_init(struct device_node *node,
 				struct device_node *parent)
 {
@@ -104,21 +77,6 @@ static int __init sun4i_of_init(struct d
 		panic("%s: unable to map IC registers\n",
 			node->full_name);
 
-	/* Disable all interrupts */
-	writel(0, sun4i_irq_base + SUN4I_IRQ_ENABLE_REG(0));
-	writel(0, sun4i_irq_base + SUN4I_IRQ_ENABLE_REG(1));
-	writel(0, sun4i_irq_base + SUN4I_IRQ_ENABLE_REG(2));
-
-	/* Mask all the interrupts */
-	writel(0, sun4i_irq_base + SUN4I_IRQ_MASK_REG(0));
-	writel(0, sun4i_irq_base + SUN4I_IRQ_MASK_REG(1));
-	writel(0, sun4i_irq_base + SUN4I_IRQ_MASK_REG(2));
-
-	/* Clear all the pending interrupts */
-	writel(0xffffffff, sun4i_irq_base + SUN4I_IRQ_PENDING_REG(0));
-	writel(0xffffffff, sun4i_irq_base + SUN4I_IRQ_PENDING_REG(1));
-	writel(0xffffffff, sun4i_irq_base + SUN4I_IRQ_PENDING_REG(2));
-
 	/* Enable protection mode */
 	writel(0x01, sun4i_irq_base + SUN4I_IRQ_PROTECTION_REG);
 
@@ -126,8 +84,8 @@ static int __init sun4i_of_init(struct d
 	writel(0x00, sun4i_irq_base + SUN4I_IRQ_NMI_CTRL_REG);
 
 	sun4i_irq_domain = irq_domain_add_linear(node, 3 * 32,
-						 &sun4i_irq_ops, NULL);
-	if (!sun4i_irq_domain)
+						 &irq_generic_chip_ops, NULL);
+	if (!sun4i_irq_domain || sun4i_init_domain_chips())
 		panic("%s: unable to create IRQ domain\n", node->full_name);
 
 	set_handle_irq(sun4i_handle_irq);


