Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752043AbaBRUv1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 15:51:27 -0500
Received: from www.linutronix.de ([62.245.132.108]:45770 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871AbaBRUvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 15:51:25 -0500
Date: Tue, 18 Feb 2014 21:51:31 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jason Cooper <jason@lakedaemon.net>
cc: Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@googlemail.com>,
        linux-kernel@vger.kernel.org,
        Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: [GIT PULL] irqchip: dove: drivers for v3.14
In-Reply-To: <20140217193230.GW7862@titan.lakedaemon.net>
Message-ID: <alpine.DEB.2.02.1402182124480.4468@ionos.tec.linutronix.de>
References: <20131201172914.GV2879@titan.lakedaemon.net> <20131211175037.GY10053@titan.lakedaemon.net> <20140110183430.GO19878@titan.lakedaemon.net> <20140128173531.GT29184@titan.lakedaemon.net> <alpine.DEB.2.02.1402041959110.24986@ionos.tec.linutronix.de>
 <20140204211219.GK8533@titan.lakedaemon.net> <alpine.DEB.2.02.1402042230230.24986@ionos.tec.linutronix.de> <20140207180836.GE8533@titan.lakedaemon.net> <20140217193230.GW7862@titan.lakedaemon.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Feb 2014, Jason Cooper wrote:
> On Fri, Feb 07, 2014 at 01:08:36PM -0500, Jason Cooper wrote:
> > On Tue, Feb 04, 2014 at 10:30:53PM +0100, Thomas Gleixner wrote:
> > > On Tue, 4 Feb 2014, Jason Cooper wrote:
> > > 
> > > > On Tue, Feb 04, 2014 at 07:59:58PM +0100, Thomas Gleixner wrote:
> > > > > On Tue, 28 Jan 2014, Jason Cooper wrote:
> > > > > > I see you pulled in mvebu/irqchip-fixes.  Thanks for that.  It's getting
> > > > > > near to the end of the merge window and there's been no activity on this
> > > > > > pull request.
> > > > > > 
> > > > > > Please let us know if there's anything we can do to assist.
> > > > > 
> > > > > Nah. I simply forgot about it. About to send a pull request to Linus.
> > > > 
> > > > hmmm.  I see the pull request contains the patches from
> > > > mvebu/irqchip-fixes (armada), but not the patches from mvebu/irqchip
> > > > (dove):
> > > > 
> > > >   40b367d95fb3 irqchip: irq-dove: Add PMU interrupt controller.
> > > > 
> > > > which is what this thread was originally a pull request for.
> > > > 
> > > > 
> > > > Are you planning to send a second pull request to Linus?
> > > 
> > > Duh. I'll pick that up tomorrow
> > 
> > Ping?
> 
> I think it's safe to say that the Dove PMU interrupt controller isn't
> going to make it in to v3.14.  I've posted a patch to remove the DT node
> for v3.14.

Yes, sorry. I messed that one up.
 
> If you don't mind, I'll go ahead and take this pull request through the
> mvebu tree for v3.15.  So that way it's off your plate and you don't
> have to worry about it.

I pushed it out to tip/irq/core now.
 
> There's more mvebu irqchip stuff on the way :)

You have an entry in my mail filter rules now, so you'll end up in the
priority queue with your pull requests :)

Btw, I just looked at that dove driver and if you look at the other
drivers/irqchip variants which use the generic irq domain/chip stuff,
then the code in the init functions +/- some minimalistic fixes is
just the same boiler plate except for quirks or a few register writes.

This the diff of the relevant code for orion and dove.

--- drivers/irqchip/irq-orion.c	2014-02-18 21:27:35.655468837 +0100
+++ drivers/irqchip/irq-dove.c	2014-02-18 21:27:57.099469874 +0100
@@ -1,14 +1,10 @@
+#define DOVE_PMU_IRQ_CAUSE	0x00
+#define DOVE_PMU_IRQ_MASK	0x04
-/*
- * Orion SoC bridge interrupt controller
- */
-#define ORION_BRIDGE_IRQ_CAUSE	0x00
-#define ORION_BRIDGE_IRQ_MASK	0x04
-
-static void orion_bridge_irq_handler(unsigned int irq, struct irq_desc *desc)
+static void dove_pmu_irq_handler(unsigned int irq, struct irq_desc *desc)
 {
 	struct irq_domain *d = irq_get_handler_data(irq);
-	struct irq_chip_generic *gc = irq_get_domain_generic_chip(d, irq);
-	u32 stat = readl_relaxed(gc->reg_base + ORION_BRIDGE_IRQ_CAUSE) &
+	struct irq_chip_generic *gc = irq_get_domain_generic_chip(d, 0);
+	u32 stat = readl_relaxed(gc->reg_base + DOVE_PMU_IRQ_CAUSE) &
 		   gc->mask_cache;

Identical except for the register constants, which are identical as well.
 
 	while (stat) {
@@ -123,17 +36,14 @@
 	}
 }
 
-static int __init orion_bridge_irq_init(struct device_node *np,
-					struct device_node *parent)
+static int __init dove_pmu_irq_init(struct device_node *np,
+				    struct device_node *parent)
 {
 	unsigned int clr = IRQ_NOREQUEST | IRQ_NOPROBE | IRQ_NOAUTOEN;
 	struct resource r;
 	struct irq_domain *domain;
 	struct irq_chip_generic *gc;
-	int ret, irq, nrirqs = 32;
-
-	/* get optional number of interrupts provided */
-	of_property_read_u32(np, "marvell,#interrupts", &nrirqs);
+	int ret, irq, nrirqs = 7;

So the difference here is nrirqs
 
 	domain = irq_domain_add_linear(np, nrirqs,
 				       &irq_generic_chip_ops, NULL);
@@ -174,19 +107,20 @@
 		return -ENOMEM;
 	}
 
-	gc->chip_types[0].regs.ack = ORION_BRIDGE_IRQ_CAUSE;
-	gc->chip_types[0].regs.mask = ORION_BRIDGE_IRQ_MASK;
-	gc->chip_types[0].chip.irq_ack = irq_gc_ack_clr_bit;
+	gc->chip_types[0].regs.ack = DOVE_PMU_IRQ_CAUSE;
+	gc->chip_types[0].regs.mask = DOVE_PMU_IRQ_MASK;
+	gc->chip_types[0].chip.irq_ack = pmu_irq_ack;
 	gc->chip_types[0].chip.irq_mask = irq_gc_mask_clr_bit;
 	gc->chip_types[0].chip.irq_unmask = irq_gc_mask_set_bit;
 


-	/* mask all interrupts */
-	writel(0, gc->reg_base + ORION_BRIDGE_IRQ_MASK);
+	/* mask and clear all interrupts */
+	writel(0, gc->reg_base + DOVE_PMU_IRQ_MASK);
+	writel(0, gc->reg_base + DOVE_PMU_IRQ_CAUSE);
 
 	irq_set_handler_data(irq, domain);
-	irq_set_chained_handler(irq, orion_bridge_irq_handler);
+	irq_set_chained_handler(irq, dove_pmu_irq_handler);
 
 	return 0;
 }
-IRQCHIP_DECLARE(orion_bridge_intc,
-		"marvell,orion-bridge-intc", orion_bridge_irq_init);
+IRQCHIP_DECLARE(dove_pmu_intc,
+		"marvell,dove-pmu-intc", dove_pmu_irq_init);

I omitted the second variant in irq-orion.c which is the same
boilerplate with a few minimal changes.

It'd be really nice if someone would sit down and make one or two
general irqchip init function which gets rid of this copied code and
reduces the init functions to the bare minimum. That's not only true
for the orion/dove case it's the same for lot of irq-*.c variants plus
minus the individual extras and of course bugs.

Thanks,

	tglx
