Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752584AbaG1VYV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 17:24:21 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:59243 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752282AbaG1VRp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 17:17:45 -0400
From: Felipe Balbi <balbi@ti.com>
To: Tony Lindgren <tony@atomide.com>
CC: Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        <bcousson@baylibre.com>, <linux@arm.linux.org.uk>,
        <khilman@deeprootsystems.com>, <tglx@linutronix.de>,
        <jason@lakedaemon.net>, <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>
Subject: [PATCH 29/35] arm: omap: intc: switch over to linear irq domain
Date: Mon, 28 Jul 2014 16:16:17 -0500
Message-ID: <1406582183-696-30-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 2.0.1.563.g66f467c
In-Reply-To: <1406582183-696-1-git-send-email-balbi@ti.com>
References: <1406582183-696-1-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

now that we don't need to support legacy board-files,
we can completely switch over to a linear irq domain
and make use of irq_alloc_domain_generic_chips() to
allocate all generic irq chips for us.

Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 arch/arm/mach-omap2/irq.c | 88 ++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 79 insertions(+), 9 deletions(-)

diff --git a/arch/arm/mach-omap2/irq.c b/arch/arm/mach-omap2/irq.c
index 43785ee..b2993e4 100644
--- a/arch/arm/mach-omap2/irq.c
+++ b/arch/arm/mach-omap2/irq.c
@@ -188,14 +188,51 @@ void omap3_intc_suspend(void)
 	omap_ack_irq(NULL);
 }
 
-static __init void
-omap_alloc_gc(void __iomem *base, unsigned int irq_start, unsigned int num)
+static int __init omap_alloc_gc_of(struct irq_domain *d, void __iomem *base)
+{
+	int ret;
+	int i;
+
+	ret = irq_alloc_domain_generic_chips(d, 32, 1, "INTC",
+			handle_level_irq, IRQ_NOREQUEST | IRQ_NOPROBE,
+			IRQ_LEVEL, 0);
+	if (ret) {
+		pr_warn("Failed to allocate irq chips\n");
+		return ret;
+	}
+
+	for (i = 0; i < omap_nr_pending; i++) {
+		struct irq_chip_generic *gc;
+		struct irq_chip_type *ct;
+
+		gc = irq_get_domain_generic_chip(d, 32 * i);
+		gc->reg_base = base;
+		ct = gc->chip_types;
+
+		ct->type = IRQ_TYPE_LEVEL_MASK;
+		ct->handler = handle_level_irq;
+
+		ct->chip.irq_ack = omap_mask_ack_irq;
+		ct->chip.irq_mask = irq_gc_mask_disable_reg;
+		ct->chip.irq_unmask = irq_gc_unmask_enable_reg;
+
+		ct->chip.flags |= IRQCHIP_SKIP_SET_WAKE;
+
+		ct->regs.enable = INTC_MIR_CLEAR0 + 32 * i;
+		ct->regs.disable = INTC_MIR_SET0 + 32 * i;
+	}
+
+	return 0;
+}
+
+static void __init omap_alloc_gc_legacy(void __iomem *base,
+		unsigned int irq_start, unsigned int num)
 {
 	struct irq_chip_generic *gc;
 	struct irq_chip_type *ct;
 
 	gc = irq_alloc_generic_chip("INTC", 1, irq_start, base,
-					handle_level_irq);
+			handle_level_irq);
 	ct = gc->chip_types;
 	ct->chip.irq_ack = omap_mask_ack_irq;
 	ct->chip.irq_mask = irq_gc_mask_disable_reg;
@@ -205,16 +242,36 @@ omap_alloc_gc(void __iomem *base, unsigned int irq_start, unsigned int num)
 	ct->regs.enable = INTC_MIR_CLEAR0;
 	ct->regs.disable = INTC_MIR_SET0;
 	irq_setup_generic_chip(gc, IRQ_MSK(num), IRQ_GC_INIT_MASK_CACHE,
-				IRQ_NOREQUEST | IRQ_NOPROBE, 0);
+			IRQ_NOREQUEST | IRQ_NOPROBE, 0);
 }
 
-static void __init omap_init_irq(u32 base, struct device_node *node)
+static int __init omap_init_irq_of(struct device_node *node)
+{
+	int ret;
+
+	omap_irq_base = of_iomap(node, 0);
+	if (WARN_ON(!omap_irq_base))
+		return -ENOMEM;
+
+	domain = irq_domain_add_linear(node, omap_nr_irqs,
+			&irq_generic_chip_ops, NULL);
+
+	omap_irq_soft_reset();
+
+	ret = omap_alloc_gc_of(domain, omap_irq_base);
+	if (ret < 0)
+		irq_domain_remove(domain);
+
+	return ret;
+}
+
+static int __init omap_init_irq_legacy(u32 base)
 {
 	int j, irq_base;
 
 	omap_irq_base = ioremap(base, SZ_4K);
 	if (WARN_ON(!omap_irq_base))
-		return;
+		return -ENOMEM;
 
 	irq_base = irq_alloc_descs(-1, 0, omap_nr_irqs, 0);
 	if (irq_base < 0) {
@@ -222,13 +279,23 @@ static void __init omap_init_irq(u32 base, struct device_node *node)
 		irq_base = 0;
 	}
 
-	domain = irq_domain_add_legacy(node, omap_nr_irqs, irq_base, 0,
+	domain = irq_domain_add_legacy(NULL, omap_nr_irqs, irq_base, 0,
 			&irq_domain_simple_ops, NULL);
 
 	omap_irq_soft_reset();
 
 	for (j = 0; j < omap_nr_irqs; j += 32)
-		omap_alloc_gc(omap_irq_base + j, j + irq_base, 32);
+		omap_alloc_gc_legacy(omap_irq_base + j, j + irq_base, 32);
+
+	return 0;
+}
+
+static int __init omap_init_irq(u32 base, struct device_node *node)
+{
+	if (node)
+		return omap_init_irq_of(node);
+	else
+		return omap_init_irq_legacy(base);
 }
 
 static asmlinkage void __exception_irq_entry
@@ -294,6 +361,7 @@ static int __init intc_of_init(struct device_node *node,
 			     struct device_node *parent)
 {
 	struct resource res;
+	int ret;
 
 	omap_nr_pending = 3;
 	omap_nr_irqs = 96;
@@ -311,7 +379,9 @@ static int __init intc_of_init(struct device_node *node,
 		omap_nr_pending = 4;
 	}
 
-	omap_init_irq(res.start, of_node_get(node));
+	ret = omap_init_irq(-1, of_node_get(node));
+	if (ret < 0)
+		return ret;
 
 	set_handle_irq(omap_intc_handle_irq);
 
-- 
2.0.1.563.g66f467c

