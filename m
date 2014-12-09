Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757141AbaLIN0a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 08:26:30 -0500
Received: from www.linutronix.de ([62.245.132.108]:48472 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757096AbaLIN01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 08:26:27 -0500
Date: Tue, 9 Dec 2014 14:26:20 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [GIT pull] irq core updates for 3.19
Message-ID: <alpine.DEB.2.11.1412091421470.16275@nanos>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull the latest irq-core-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git irq-core-for-linus

This is the first (boring) part of irq updates:
  - Support for big endian I/O accessors in the generic irq chip
  - Cleanup of brcmstb/bcm7120 drivers so they can be reused for non
    ARM SoCs
  - The usual pile of fixes and updates for the various ARM irq chips

Thanks,

	tglx

------------------>
Boris BREZILLON (5):
      irqchip: atmel-aic: Add irq fixup for RTT block
      irqchip: atmel-aic: Add irq fixups for at91sam926x SoCs
      irqchip: atmel-aic: Add specific irq fixup function for sam9g45 and sam9rl
      irqchip: atmel-aic: Rename at91sam9_aic_irq_fixup for naming consistency
      irqchip: atmel-aic: Add missing entry for rm9200 irq fixups

Gregory CLEMENT (1):
      ARM: orion: convert the irq_reg_{readl,writel} calls to the new API

Jisheng Zhang (4):
      irqchip: dw-apb-ictl: Select GENERIC_IRQ_CHIP
      irqchip: dw-apb-ictl: Always use use {readl|writel}_relaxed
      irqchip: dw-apb-ictl: Enable IRQ_GC_MASK_CACHE_PER_TYPE
      irqchip: dw-apb-ictl: Add PM support

Kevin Cernekee (13):
      genirq: Generic chip: Change irq_reg_{readl,writel} arguments
      genirq: Generic chip: Allow irqchip drivers to override irq_reg_{readl,writel}
      genirq: Generic chip: Add big endian I/O accessors
      irqchip: brcmstb-l2: Eliminate dependency on ARM code
      irqchip: bcm7120-l2: Eliminate bad IRQ check
      irqchip: bcm7120-l2, brcmstb-l2: Remove ARM Kconfig dependency
      irqchip: bcm7120-l2: Make sure all register accesses use base+offset
      irqchip: bcm7120-l2: Fix missing nibble in gc->unused mask
      irqchip: bcm7120-l2: Use gc->mask_cache to simplify suspend/resume functions
      irqchip: bcm7120-l2: Extend driver to support 64+ bit controllers
      irqchip: bcm7120-l2: Decouple driver from brcmstb-l2
      irqchip: bcm7120-l2: Convert driver to use irq_reg_{readl,writel}
      irqchip: brcmstb-l2: Convert driver to use irq_reg_{readl,writel}

Marc Zyngier (1):
      irqchip: hip04: Convert to handle_domain_irq

Thomas Petazzoni (1):
      irqchip: irq-armada-370-xp: Use proper return value for ->set_affinity()


 .../interrupt-controller/brcm,bcm7120-l2-intc.txt  |  26 ++-
 arch/arm/mach-bcm/Kconfig                          |   1 +
 arch/arm/plat-orion/gpio.c                         |   8 +-
 drivers/irqchip/Kconfig                            |   7 +-
 drivers/irqchip/Makefile                           |   4 +-
 drivers/irqchip/irq-armada-370-xp.c                |   2 +-
 drivers/irqchip/irq-atmel-aic-common.c             |  26 +++
 drivers/irqchip/irq-atmel-aic-common.h             |   2 +
 drivers/irqchip/irq-atmel-aic.c                    |  66 +++++---
 drivers/irqchip/irq-atmel-aic5.c                   |  65 ++++----
 drivers/irqchip/irq-bcm7120-l2.c                   | 174 +++++++++++++--------
 drivers/irqchip/irq-brcmstb-l2.c                   |  41 +++--
 drivers/irqchip/irq-dw-apb-ictl.c                  |  32 +++-
 drivers/irqchip/irq-hip04.c                        |   3 +-
 drivers/irqchip/irq-sunxi-nmi.c                    |   4 +-
 drivers/irqchip/irq-tb10x.c                        |   4 +-
 include/linux/irq.h                                |  32 +++-
 kernel/irq/generic-chip.c                          |  36 +++--
 18 files changed, 345 insertions(+), 188 deletions(-)

diff --git a/Documentation/devicetree/bindings/interrupt-controller/brcm,bcm7120-l2-intc.txt b/Documentation/devicetree/bindings/interrupt-controller/brcm,bcm7120-l2-intc.txt
index ff812a8a82bc..bae1f2187226 100644
--- a/Documentation/devicetree/bindings/interrupt-controller/brcm,bcm7120-l2-intc.txt
+++ b/Documentation/devicetree/bindings/interrupt-controller/brcm,bcm7120-l2-intc.txt
@@ -13,7 +13,12 @@ Such an interrupt controller has the following hardware design:
   or if they will output an interrupt signal at this 2nd level interrupt
   controller, in particular for UARTs
 
-- not all 32-bits within the interrupt controller actually map to an interrupt
+- typically has one 32-bit enable word and one 32-bit status word, but on
+  some hardware may have more than one enable/status pair
+
+- no atomic set/clear operations
+
+- not all bits within the interrupt controller actually map to an interrupt
 
 The typical hardware layout for this controller is represented below:
 
@@ -48,7 +53,9 @@ The typical hardware layout for this controller is represented below:
 Required properties:
 
 - compatible: should be "brcm,bcm7120-l2-intc"
-- reg: specifies the base physical address and size of the registers
+- reg: specifies the base physical address and size of the registers;
+  multiple pairs may be specified, with the first pair handling IRQ offsets
+  0..31 and the second pair handling 32..63
 - interrupt-controller: identifies the node as an interrupt controller
 - #interrupt-cells: specifies the number of cells needed to encode an interrupt
   source, should be 1.
@@ -59,18 +66,21 @@ Required properties:
 - brcm,int-map-mask: 32-bits bit mask describing how many and which interrupts
   are wired to this 2nd level interrupt controller, and how they match their
   respective interrupt parents. Should match exactly the number of interrupts
-  specified in the 'interrupts' property.
+  specified in the 'interrupts' property, multiplied by the number of
+  enable/status register pairs implemented by this controller.  For
+  multiple parent IRQs with multiple enable/status words, this looks like:
+  <irq0_w0 irq0_w1 irq1_w0 irq1_w1 ...>
 
 Optional properties:
 
 - brcm,irq-can-wake: if present, this means the L2 controller can be used as a
   wakeup source for system suspend/resume.
 
-- brcm,int-fwd-mask: if present, a 32-bits bit mask to configure for the
-  interrupts which have a mux gate, typically UARTs. Setting these bits will
-  make their respective interrupts outputs bypass this 2nd level interrupt
-  controller completely, it completely transparent for the interrupt controller
-  parent
+- brcm,int-fwd-mask: if present, a bit mask to configure the interrupts which
+  have a mux gate, typically UARTs. Setting these bits will make their
+  respective interrupt outputs bypass this 2nd level interrupt controller
+  completely; it is completely transparent for the interrupt controller
+  parent. This should have one 32-bit word per enable/status pair.
 
 Example:
 
diff --git a/arch/arm/mach-bcm/Kconfig b/arch/arm/mach-bcm/Kconfig
index 2abad742516d..bf47eb09ff7d 100644
--- a/arch/arm/mach-bcm/Kconfig
+++ b/arch/arm/mach-bcm/Kconfig
@@ -125,6 +125,7 @@ config ARCH_BRCMSTB
 	select HAVE_ARM_ARCH_TIMER
 	select BRCMSTB_GISB_ARB
 	select BRCMSTB_L2_IRQ
+	select BCM7120_L2_IRQ
 	help
 	  Say Y if you intend to run the kernel on a Broadcom ARM-based STB
 	  chipset.
diff --git a/arch/arm/plat-orion/gpio.c b/arch/arm/plat-orion/gpio.c
index e048f6198d68..14f6e647c739 100644
--- a/arch/arm/plat-orion/gpio.c
+++ b/arch/arm/plat-orion/gpio.c
@@ -505,9 +505,9 @@ static void orion_gpio_unmask_irq(struct irq_data *d)
 	u32 mask = d->mask;
 
 	irq_gc_lock(gc);
-	reg_val = irq_reg_readl(gc->reg_base + ct->regs.mask);
+	reg_val = irq_reg_readl(gc, ct->regs.mask);
 	reg_val |= mask;
-	irq_reg_writel(reg_val, gc->reg_base + ct->regs.mask);
+	irq_reg_writel(gc, reg_val, ct->regs.mask);
 	irq_gc_unlock(gc);
 }
 
@@ -519,9 +519,9 @@ static void orion_gpio_mask_irq(struct irq_data *d)
 	u32 reg_val;
 
 	irq_gc_lock(gc);
-	reg_val = irq_reg_readl(gc->reg_base + ct->regs.mask);
+	reg_val = irq_reg_readl(gc, ct->regs.mask);
 	reg_val &= ~mask;
-	irq_reg_writel(reg_val, gc->reg_base + ct->regs.mask);
+	irq_reg_writel(gc, reg_val, ct->regs.mask);
 	irq_gc_unlock(gc);
 }
 
diff --git a/drivers/irqchip/Kconfig b/drivers/irqchip/Kconfig
index b21f12f1766d..9efe5f10f97b 100644
--- a/drivers/irqchip/Kconfig
+++ b/drivers/irqchip/Kconfig
@@ -48,14 +48,19 @@ config ATMEL_AIC5_IRQ
 	select MULTI_IRQ_HANDLER
 	select SPARSE_IRQ
 
+config BCM7120_L2_IRQ
+	bool
+	select GENERIC_IRQ_CHIP
+	select IRQ_DOMAIN
+
 config BRCMSTB_L2_IRQ
 	bool
-	depends on ARM
 	select GENERIC_IRQ_CHIP
 	select IRQ_DOMAIN
 
 config DW_APB_ICTL
 	bool
+	select GENERIC_IRQ_CHIP
 	select IRQ_DOMAIN
 
 config IMGPDC_IRQ
diff --git a/drivers/irqchip/Makefile b/drivers/irqchip/Makefile
index 173bb5fa2cc9..f0909d05eae3 100644
--- a/drivers/irqchip/Makefile
+++ b/drivers/irqchip/Makefile
@@ -35,6 +35,6 @@ obj-$(CONFIG_TB10X_IRQC)		+= irq-tb10x.o
 obj-$(CONFIG_XTENSA)			+= irq-xtensa-pic.o
 obj-$(CONFIG_XTENSA_MX)			+= irq-xtensa-mx.o
 obj-$(CONFIG_IRQ_CROSSBAR)		+= irq-crossbar.o
-obj-$(CONFIG_BRCMSTB_L2_IRQ)		+= irq-brcmstb-l2.o \
-					   irq-bcm7120-l2.o
+obj-$(CONFIG_BCM7120_L2_IRQ)		+= irq-bcm7120-l2.o
+obj-$(CONFIG_BRCMSTB_L2_IRQ)		+= irq-brcmstb-l2.o
 obj-$(CONFIG_KEYSTONE_IRQ)		+= irq-keystone.o
diff --git a/drivers/irqchip/irq-armada-370-xp.c b/drivers/irqchip/irq-armada-370-xp.c
index 3e238cd049e6..9e630f29ac6b 100644
--- a/drivers/irqchip/irq-armada-370-xp.c
+++ b/drivers/irqchip/irq-armada-370-xp.c
@@ -265,7 +265,7 @@ static int armada_xp_set_affinity(struct irq_data *d,
 	writel(reg, main_int_base + ARMADA_370_XP_INT_SOURCE_CTL(hwirq));
 	raw_spin_unlock(&irq_controller_lock);
 
-	return 0;
+	return IRQ_SET_MASK_OK;
 }
 #endif
 
diff --git a/drivers/irqchip/irq-atmel-aic-common.c b/drivers/irqchip/irq-atmel-aic-common.c
index 6ae3cdee0681..656cfe336837 100644
--- a/drivers/irqchip/irq-atmel-aic-common.c
+++ b/drivers/irqchip/irq-atmel-aic-common.c
@@ -167,6 +167,32 @@ void __init aic_common_rtc_irq_fixup(struct device_node *root)
 	iounmap(regs);
 }
 
+#define AT91_RTT_MR		0x00			/* Real-time Mode Register */
+#define AT91_RTT_ALMIEN		(1 << 16)		/* Alarm Interrupt Enable */
+#define AT91_RTT_RTTINCIEN	(1 << 17)		/* Real Time Timer Increment Interrupt Enable */
+
+void __init aic_common_rtt_irq_fixup(struct device_node *root)
+{
+	struct device_node *np;
+	void __iomem *regs;
+
+	/*
+	 * The at91sam9263 SoC has 2 instances of the RTT block, hence we
+	 * iterate over the DT to find each occurrence.
+	 */
+	for_each_compatible_node(np, NULL, "atmel,at91sam9260-rtt") {
+		regs = of_iomap(np, 0);
+		if (!regs)
+			continue;
+
+		writel(readl(regs + AT91_RTT_MR) &
+		       ~(AT91_RTT_ALMIEN | AT91_RTT_RTTINCIEN),
+		       regs + AT91_RTT_MR);
+
+		iounmap(regs);
+	}
+}
+
 void __init aic_common_irq_fixup(const struct of_device_id *matches)
 {
 	struct device_node *root = of_find_node_by_path("/");
diff --git a/drivers/irqchip/irq-atmel-aic-common.h b/drivers/irqchip/irq-atmel-aic-common.h
index 90aa00e918d6..603f0a9d5411 100644
--- a/drivers/irqchip/irq-atmel-aic-common.h
+++ b/drivers/irqchip/irq-atmel-aic-common.h
@@ -34,6 +34,8 @@ struct irq_domain *__init aic_common_of_init(struct device_node *node,
 
 void __init aic_common_rtc_irq_fixup(struct device_node *root);
 
+void __init aic_common_rtt_irq_fixup(struct device_node *root);
+
 void __init aic_common_irq_fixup(const struct of_device_id *matches);
 
 #endif /* __IRQ_ATMEL_AIC_COMMON_H */
diff --git a/drivers/irqchip/irq-atmel-aic.c b/drivers/irqchip/irq-atmel-aic.c
index 9a2cf3c1a3a5..dae3604b32a9 100644
--- a/drivers/irqchip/irq-atmel-aic.c
+++ b/drivers/irqchip/irq-atmel-aic.c
@@ -65,11 +65,11 @@ aic_handle(struct pt_regs *regs)
 	u32 irqnr;
 	u32 irqstat;
 
-	irqnr = irq_reg_readl(gc->reg_base + AT91_AIC_IVR);
-	irqstat = irq_reg_readl(gc->reg_base + AT91_AIC_ISR);
+	irqnr = irq_reg_readl(gc, AT91_AIC_IVR);
+	irqstat = irq_reg_readl(gc, AT91_AIC_ISR);
 
 	if (!irqstat)
-		irq_reg_writel(0, gc->reg_base + AT91_AIC_EOICR);
+		irq_reg_writel(gc, 0, AT91_AIC_EOICR);
 	else
 		handle_domain_irq(aic_domain, irqnr, regs);
 }
@@ -80,7 +80,7 @@ static int aic_retrigger(struct irq_data *d)
 
 	/* Enable interrupt on AIC5 */
 	irq_gc_lock(gc);
-	irq_reg_writel(d->mask, gc->reg_base + AT91_AIC_ISCR);
+	irq_reg_writel(gc, d->mask, AT91_AIC_ISCR);
 	irq_gc_unlock(gc);
 
 	return 0;
@@ -92,12 +92,12 @@ static int aic_set_type(struct irq_data *d, unsigned type)
 	unsigned int smr;
 	int ret;
 
-	smr = irq_reg_readl(gc->reg_base + AT91_AIC_SMR(d->hwirq));
+	smr = irq_reg_readl(gc, AT91_AIC_SMR(d->hwirq));
 	ret = aic_common_set_type(d, type, &smr);
 	if (ret)
 		return ret;
 
-	irq_reg_writel(smr, gc->reg_base + AT91_AIC_SMR(d->hwirq));
+	irq_reg_writel(gc, smr, AT91_AIC_SMR(d->hwirq));
 
 	return 0;
 }
@@ -108,8 +108,8 @@ static void aic_suspend(struct irq_data *d)
 	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
 
 	irq_gc_lock(gc);
-	irq_reg_writel(gc->mask_cache, gc->reg_base + AT91_AIC_IDCR);
-	irq_reg_writel(gc->wake_active, gc->reg_base + AT91_AIC_IECR);
+	irq_reg_writel(gc, gc->mask_cache, AT91_AIC_IDCR);
+	irq_reg_writel(gc, gc->wake_active, AT91_AIC_IECR);
 	irq_gc_unlock(gc);
 }
 
@@ -118,8 +118,8 @@ static void aic_resume(struct irq_data *d)
 	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
 
 	irq_gc_lock(gc);
-	irq_reg_writel(gc->wake_active, gc->reg_base + AT91_AIC_IDCR);
-	irq_reg_writel(gc->mask_cache, gc->reg_base + AT91_AIC_IECR);
+	irq_reg_writel(gc, gc->wake_active, AT91_AIC_IDCR);
+	irq_reg_writel(gc, gc->mask_cache, AT91_AIC_IECR);
 	irq_gc_unlock(gc);
 }
 
@@ -128,8 +128,8 @@ static void aic_pm_shutdown(struct irq_data *d)
 	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
 
 	irq_gc_lock(gc);
-	irq_reg_writel(0xffffffff, gc->reg_base + AT91_AIC_IDCR);
-	irq_reg_writel(0xffffffff, gc->reg_base + AT91_AIC_ICCR);
+	irq_reg_writel(gc, 0xffffffff, AT91_AIC_IDCR);
+	irq_reg_writel(gc, 0xffffffff, AT91_AIC_ICCR);
 	irq_gc_unlock(gc);
 }
 #else
@@ -148,24 +148,24 @@ static void __init aic_hw_init(struct irq_domain *domain)
 	 * will not Lock out nIRQ
 	 */
 	for (i = 0; i < 8; i++)
-		irq_reg_writel(0, gc->reg_base + AT91_AIC_EOICR);
+		irq_reg_writel(gc, 0, AT91_AIC_EOICR);
 
 	/*
 	 * Spurious Interrupt ID in Spurious Vector Register.
 	 * When there is no current interrupt, the IRQ Vector Register
 	 * reads the value stored in AIC_SPU
 	 */
-	irq_reg_writel(0xffffffff, gc->reg_base + AT91_AIC_SPU);
+	irq_reg_writel(gc, 0xffffffff, AT91_AIC_SPU);
 
 	/* No debugging in AIC: Debug (Protect) Control Register */
-	irq_reg_writel(0, gc->reg_base + AT91_AIC_DCR);
+	irq_reg_writel(gc, 0, AT91_AIC_DCR);
 
 	/* Disable and clear all interrupts initially */
-	irq_reg_writel(0xffffffff, gc->reg_base + AT91_AIC_IDCR);
-	irq_reg_writel(0xffffffff, gc->reg_base + AT91_AIC_ICCR);
+	irq_reg_writel(gc, 0xffffffff, AT91_AIC_IDCR);
+	irq_reg_writel(gc, 0xffffffff, AT91_AIC_ICCR);
 
 	for (i = 0; i < 32; i++)
-		irq_reg_writel(i, gc->reg_base + AT91_AIC_SVR(i));
+		irq_reg_writel(gc, i, AT91_AIC_SVR(i));
 }
 
 static int aic_irq_domain_xlate(struct irq_domain *d,
@@ -195,10 +195,10 @@ static int aic_irq_domain_xlate(struct irq_domain *d,
 	gc = dgc->gc[idx];
 
 	irq_gc_lock(gc);
-	smr = irq_reg_readl(gc->reg_base + AT91_AIC_SMR(*out_hwirq));
+	smr = irq_reg_readl(gc, AT91_AIC_SMR(*out_hwirq));
 	ret = aic_common_set_priority(intspec[2], &smr);
 	if (!ret)
-		irq_reg_writel(smr, gc->reg_base + AT91_AIC_SMR(*out_hwirq));
+		irq_reg_writel(gc, smr, AT91_AIC_SMR(*out_hwirq));
 	irq_gc_unlock(gc);
 
 	return ret;
@@ -209,16 +209,32 @@ static const struct irq_domain_ops aic_irq_ops = {
 	.xlate	= aic_irq_domain_xlate,
 };
 
-static void __init at91sam9_aic_irq_fixup(struct device_node *root)
+static void __init at91rm9200_aic_irq_fixup(struct device_node *root)
 {
 	aic_common_rtc_irq_fixup(root);
 }
 
+static void __init at91sam9260_aic_irq_fixup(struct device_node *root)
+{
+	aic_common_rtt_irq_fixup(root);
+}
+
+static void __init at91sam9g45_aic_irq_fixup(struct device_node *root)
+{
+	aic_common_rtc_irq_fixup(root);
+	aic_common_rtt_irq_fixup(root);
+}
+
 static const struct of_device_id __initdata aic_irq_fixups[] = {
-	{ .compatible = "atmel,at91sam9g45", .data = at91sam9_aic_irq_fixup },
-	{ .compatible = "atmel,at91sam9n12", .data = at91sam9_aic_irq_fixup },
-	{ .compatible = "atmel,at91sam9rl", .data = at91sam9_aic_irq_fixup },
-	{ .compatible = "atmel,at91sam9x5", .data = at91sam9_aic_irq_fixup },
+	{ .compatible = "atmel,at91rm9200", .data = at91rm9200_aic_irq_fixup },
+	{ .compatible = "atmel,at91sam9g45", .data = at91sam9g45_aic_irq_fixup },
+	{ .compatible = "atmel,at91sam9n12", .data = at91rm9200_aic_irq_fixup },
+	{ .compatible = "atmel,at91sam9rl", .data = at91sam9g45_aic_irq_fixup },
+	{ .compatible = "atmel,at91sam9x5", .data = at91rm9200_aic_irq_fixup },
+	{ .compatible = "atmel,at91sam9260", .data = at91sam9260_aic_irq_fixup },
+	{ .compatible = "atmel,at91sam9261", .data = at91sam9260_aic_irq_fixup },
+	{ .compatible = "atmel,at91sam9263", .data = at91sam9260_aic_irq_fixup },
+	{ .compatible = "atmel,at91sam9g20", .data = at91sam9260_aic_irq_fixup },
 	{ /* sentinel */ },
 };
 
diff --git a/drivers/irqchip/irq-atmel-aic5.c b/drivers/irqchip/irq-atmel-aic5.c
index a11aae8fb006..a2e8c3f876cb 100644
--- a/drivers/irqchip/irq-atmel-aic5.c
+++ b/drivers/irqchip/irq-atmel-aic5.c
@@ -75,11 +75,11 @@ aic5_handle(struct pt_regs *regs)
 	u32 irqnr;
 	u32 irqstat;
 
-	irqnr = irq_reg_readl(gc->reg_base + AT91_AIC5_IVR);
-	irqstat = irq_reg_readl(gc->reg_base + AT91_AIC5_ISR);
+	irqnr = irq_reg_readl(gc, AT91_AIC5_IVR);
+	irqstat = irq_reg_readl(gc, AT91_AIC5_ISR);
 
 	if (!irqstat)
-		irq_reg_writel(0, gc->reg_base + AT91_AIC5_EOICR);
+		irq_reg_writel(gc, 0, AT91_AIC5_EOICR);
 	else
 		handle_domain_irq(aic5_domain, irqnr, regs);
 }
@@ -92,8 +92,8 @@ static void aic5_mask(struct irq_data *d)
 
 	/* Disable interrupt on AIC5 */
 	irq_gc_lock(gc);
-	irq_reg_writel(d->hwirq, gc->reg_base + AT91_AIC5_SSR);
-	irq_reg_writel(1, gc->reg_base + AT91_AIC5_IDCR);
+	irq_reg_writel(gc, d->hwirq, AT91_AIC5_SSR);
+	irq_reg_writel(gc, 1, AT91_AIC5_IDCR);
 	gc->mask_cache &= ~d->mask;
 	irq_gc_unlock(gc);
 }
@@ -106,8 +106,8 @@ static void aic5_unmask(struct irq_data *d)
 
 	/* Enable interrupt on AIC5 */
 	irq_gc_lock(gc);
-	irq_reg_writel(d->hwirq, gc->reg_base + AT91_AIC5_SSR);
-	irq_reg_writel(1, gc->reg_base + AT91_AIC5_IECR);
+	irq_reg_writel(gc, d->hwirq, AT91_AIC5_SSR);
+	irq_reg_writel(gc, 1, AT91_AIC5_IECR);
 	gc->mask_cache |= d->mask;
 	irq_gc_unlock(gc);
 }
@@ -120,8 +120,8 @@ static int aic5_retrigger(struct irq_data *d)
 
 	/* Enable interrupt on AIC5 */
 	irq_gc_lock(gc);
-	irq_reg_writel(d->hwirq, gc->reg_base + AT91_AIC5_SSR);
-	irq_reg_writel(1, gc->reg_base + AT91_AIC5_ISCR);
+	irq_reg_writel(gc, d->hwirq, AT91_AIC5_SSR);
+	irq_reg_writel(gc, 1, AT91_AIC5_ISCR);
 	irq_gc_unlock(gc);
 
 	return 0;
@@ -136,11 +136,11 @@ static int aic5_set_type(struct irq_data *d, unsigned type)
 	int ret;
 
 	irq_gc_lock(gc);
-	irq_reg_writel(d->hwirq, gc->reg_base + AT91_AIC5_SSR);
-	smr = irq_reg_readl(gc->reg_base + AT91_AIC5_SMR);
+	irq_reg_writel(gc, d->hwirq, AT91_AIC5_SSR);
+	smr = irq_reg_readl(gc, AT91_AIC5_SMR);
 	ret = aic_common_set_type(d, type, &smr);
 	if (!ret)
-		irq_reg_writel(smr, gc->reg_base + AT91_AIC5_SMR);
+		irq_reg_writel(gc, smr, AT91_AIC5_SMR);
 	irq_gc_unlock(gc);
 
 	return ret;
@@ -162,12 +162,11 @@ static void aic5_suspend(struct irq_data *d)
 		if ((mask & gc->mask_cache) == (mask & gc->wake_active))
 			continue;
 
-		irq_reg_writel(i + gc->irq_base,
-			       bgc->reg_base + AT91_AIC5_SSR);
+		irq_reg_writel(bgc, i + gc->irq_base, AT91_AIC5_SSR);
 		if (mask & gc->wake_active)
-			irq_reg_writel(1, bgc->reg_base + AT91_AIC5_IECR);
+			irq_reg_writel(bgc, 1, AT91_AIC5_IECR);
 		else
-			irq_reg_writel(1, bgc->reg_base + AT91_AIC5_IDCR);
+			irq_reg_writel(bgc, 1, AT91_AIC5_IDCR);
 	}
 	irq_gc_unlock(bgc);
 }
@@ -187,12 +186,11 @@ static void aic5_resume(struct irq_data *d)
 		if ((mask & gc->mask_cache) == (mask & gc->wake_active))
 			continue;
 
-		irq_reg_writel(i + gc->irq_base,
-			       bgc->reg_base + AT91_AIC5_SSR);
+		irq_reg_writel(bgc, i + gc->irq_base, AT91_AIC5_SSR);
 		if (mask & gc->mask_cache)
-			irq_reg_writel(1, bgc->reg_base + AT91_AIC5_IECR);
+			irq_reg_writel(bgc, 1, AT91_AIC5_IECR);
 		else
-			irq_reg_writel(1, bgc->reg_base + AT91_AIC5_IDCR);
+			irq_reg_writel(bgc, 1, AT91_AIC5_IDCR);
 	}
 	irq_gc_unlock(bgc);
 }
@@ -207,10 +205,9 @@ static void aic5_pm_shutdown(struct irq_data *d)
 
 	irq_gc_lock(bgc);
 	for (i = 0; i < dgc->irqs_per_chip; i++) {
-		irq_reg_writel(i + gc->irq_base,
-			       bgc->reg_base + AT91_AIC5_SSR);
-		irq_reg_writel(1, bgc->reg_base + AT91_AIC5_IDCR);
-		irq_reg_writel(1, bgc->reg_base + AT91_AIC5_ICCR);
+		irq_reg_writel(bgc, i + gc->irq_base, AT91_AIC5_SSR);
+		irq_reg_writel(bgc, 1, AT91_AIC5_IDCR);
+		irq_reg_writel(bgc, 1, AT91_AIC5_ICCR);
 	}
 	irq_gc_unlock(bgc);
 }
@@ -230,24 +227,24 @@ static void __init aic5_hw_init(struct irq_domain *domain)
 	 * will not Lock out nIRQ
 	 */
 	for (i = 0; i < 8; i++)
-		irq_reg_writel(0, gc->reg_base + AT91_AIC5_EOICR);
+		irq_reg_writel(gc, 0, AT91_AIC5_EOICR);
 
 	/*
 	 * Spurious Interrupt ID in Spurious Vector Register.
 	 * When there is no current interrupt, the IRQ Vector Register
 	 * reads the value stored in AIC_SPU
 	 */
-	irq_reg_writel(0xffffffff, gc->reg_base + AT91_AIC5_SPU);
+	irq_reg_writel(gc, 0xffffffff, AT91_AIC5_SPU);
 
 	/* No debugging in AIC: Debug (Protect) Control Register */
-	irq_reg_writel(0, gc->reg_base + AT91_AIC5_DCR);
+	irq_reg_writel(gc, 0, AT91_AIC5_DCR);
 
 	/* Disable and clear all interrupts initially */
 	for (i = 0; i < domain->revmap_size; i++) {
-		irq_reg_writel(i, gc->reg_base + AT91_AIC5_SSR);
-		irq_reg_writel(i, gc->reg_base + AT91_AIC5_SVR);
-		irq_reg_writel(1, gc->reg_base + AT91_AIC5_IDCR);
-		irq_reg_writel(1, gc->reg_base + AT91_AIC5_ICCR);
+		irq_reg_writel(gc, i, AT91_AIC5_SSR);
+		irq_reg_writel(gc, i, AT91_AIC5_SVR);
+		irq_reg_writel(gc, 1, AT91_AIC5_IDCR);
+		irq_reg_writel(gc, 1, AT91_AIC5_ICCR);
 	}
 }
 
@@ -273,11 +270,11 @@ static int aic5_irq_domain_xlate(struct irq_domain *d,
 	gc = dgc->gc[0];
 
 	irq_gc_lock(gc);
-	irq_reg_writel(*out_hwirq, gc->reg_base + AT91_AIC5_SSR);
-	smr = irq_reg_readl(gc->reg_base + AT91_AIC5_SMR);
+	irq_reg_writel(gc, *out_hwirq, AT91_AIC5_SSR);
+	smr = irq_reg_readl(gc, AT91_AIC5_SMR);
 	ret = aic_common_set_priority(intspec[2], &smr);
 	if (!ret)
-		irq_reg_writel(intspec[2] | smr, gc->reg_base + AT91_AIC5_SMR);
+		irq_reg_writel(gc, intspec[2] | smr, AT91_AIC5_SMR);
 	irq_gc_unlock(gc);
 
 	return ret;
diff --git a/drivers/irqchip/irq-bcm7120-l2.c b/drivers/irqchip/irq-bcm7120-l2.c
index b9f4fb808e49..e7c6155b23b8 100644
--- a/drivers/irqchip/irq-bcm7120-l2.c
+++ b/drivers/irqchip/irq-bcm7120-l2.c
@@ -13,6 +13,7 @@
 #include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/module.h>
+#include <linux/kconfig.h>
 #include <linux/platform_device.h>
 #include <linux/of.h>
 #include <linux/of_irq.h>
@@ -23,47 +24,52 @@
 #include <linux/io.h>
 #include <linux/irqdomain.h>
 #include <linux/reboot.h>
+#include <linux/bitops.h>
 #include <linux/irqchip/chained_irq.h>
 
 #include "irqchip.h"
 
-#include <asm/mach/irq.h>
-
 /* Register offset in the L2 interrupt controller */
 #define IRQEN		0x00
 #define IRQSTAT		0x04
 
+#define MAX_WORDS	4
+#define IRQS_PER_WORD	32
+
 struct bcm7120_l2_intc_data {
-	void __iomem *base;
+	unsigned int n_words;
+	void __iomem *base[MAX_WORDS];
 	struct irq_domain *domain;
 	bool can_wake;
-	u32 irq_fwd_mask;
-	u32 irq_map_mask;
-	u32 saved_mask;
+	u32 irq_fwd_mask[MAX_WORDS];
+	u32 irq_map_mask[MAX_WORDS];
 };
 
 static void bcm7120_l2_intc_irq_handle(unsigned int irq, struct irq_desc *desc)
 {
 	struct bcm7120_l2_intc_data *b = irq_desc_get_handler_data(desc);
 	struct irq_chip *chip = irq_desc_get_chip(desc);
-	u32 status;
+	unsigned int idx;
 
 	chained_irq_enter(chip, desc);
 
-	status = __raw_readl(b->base + IRQSTAT);
-
-	if (status == 0) {
-		do_bad_IRQ(irq, desc);
-		goto out;
+	for (idx = 0; idx < b->n_words; idx++) {
+		int base = idx * IRQS_PER_WORD;
+		struct irq_chip_generic *gc =
+			irq_get_domain_generic_chip(b->domain, base);
+		unsigned long pending;
+		int hwirq;
+
+		irq_gc_lock(gc);
+		pending = irq_reg_readl(gc, IRQSTAT) & gc->mask_cache;
+		irq_gc_unlock(gc);
+
+		for_each_set_bit(hwirq, &pending, IRQS_PER_WORD) {
+			generic_handle_irq(irq_find_mapping(b->domain,
+					   base + hwirq));
+		}
 	}
 
-	do {
-		irq = ffs(status) - 1;
-		status &= ~(1 << irq);
-		generic_handle_irq(irq_find_mapping(b->domain, irq));
-	} while (status);
-
-out:
 	chained_irq_exit(chip, desc);
 }
 
@@ -71,26 +77,20 @@ static void bcm7120_l2_intc_suspend(struct irq_data *d)
 {
 	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
 	struct bcm7120_l2_intc_data *b = gc->private;
-	u32 reg;
 
 	irq_gc_lock(gc);
-	/* Save the current mask and the interrupt forward mask */
-	b->saved_mask = __raw_readl(b->base) | b->irq_fwd_mask;
-	if (b->can_wake) {
-		reg = b->saved_mask | gc->wake_active;
-		__raw_writel(reg, b->base);
-	}
+	if (b->can_wake)
+		irq_reg_writel(gc, gc->mask_cache | gc->wake_active, IRQEN);
 	irq_gc_unlock(gc);
 }
 
 static void bcm7120_l2_intc_resume(struct irq_data *d)
 {
 	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
-	struct bcm7120_l2_intc_data *b = gc->private;
 
 	/* Restore the saved mask */
 	irq_gc_lock(gc);
-	__raw_writel(b->saved_mask, b->base);
+	irq_reg_writel(gc, gc->mask_cache, IRQEN);
 	irq_gc_unlock(gc);
 }
 
@@ -99,6 +99,7 @@ static int bcm7120_l2_intc_init_one(struct device_node *dn,
 					int irq, const __be32 *map_mask)
 {
 	int parent_irq;
+	unsigned int idx;
 
 	parent_irq = irq_of_parse_and_map(dn, irq);
 	if (parent_irq < 0) {
@@ -106,7 +107,12 @@ static int bcm7120_l2_intc_init_one(struct device_node *dn,
 		return parent_irq;
 	}
 
-	data->irq_map_mask |= be32_to_cpup(map_mask + irq);
+	/* For multiple parent IRQs with multiple words, this looks like:
+	 * <irq0_w0 irq0_w1 irq1_w0 irq1_w1 ...>
+	 */
+	for (idx = 0; idx < data->n_words; idx++)
+		data->irq_map_mask[idx] |=
+			be32_to_cpup(map_mask + irq * data->n_words + idx);
 
 	irq_set_handler_data(parent_irq, data);
 	irq_set_chained_handler(parent_irq, bcm7120_l2_intc_irq_handle);
@@ -123,26 +129,41 @@ int __init bcm7120_l2_intc_of_init(struct device_node *dn,
 	struct irq_chip_type *ct;
 	const __be32 *map_mask;
 	int num_parent_irqs;
-	int ret = 0, len, irq;
+	int ret = 0, len;
+	unsigned int idx, irq, flags;
 
 	data = kzalloc(sizeof(*data), GFP_KERNEL);
 	if (!data)
 		return -ENOMEM;
 
-	data->base = of_iomap(dn, 0);
-	if (!data->base) {
+	for (idx = 0; idx < MAX_WORDS; idx++) {
+		data->base[idx] = of_iomap(dn, idx);
+		if (!data->base[idx])
+			break;
+		data->n_words = idx + 1;
+	}
+	if (!data->n_words) {
 		pr_err("failed to remap intc L2 registers\n");
 		ret = -ENOMEM;
-		goto out_free;
+		goto out_unmap;
 	}
 
-	if (of_property_read_u32(dn, "brcm,int-fwd-mask", &data->irq_fwd_mask))
-		data->irq_fwd_mask = 0;
-
-	/* Enable all interrupt specified in the interrupt forward mask and have
-	 * the other disabled
+	/* Enable all interrupts specified in the interrupt forward mask;
+	 * disable all others.  If the property doesn't exist (-EINVAL),
+	 * assume all zeroes.
 	 */
-	__raw_writel(data->irq_fwd_mask, data->base + IRQEN);
+	ret = of_property_read_u32_array(dn, "brcm,int-fwd-mask",
+					 data->irq_fwd_mask, data->n_words);
+	if (ret == 0 || ret == -EINVAL) {
+		for (idx = 0; idx < data->n_words; idx++)
+			__raw_writel(data->irq_fwd_mask[idx],
+				     data->base[idx] + IRQEN);
+	} else {
+		/* property exists but has the wrong number of words */
+		pr_err("invalid int-fwd-mask property\n");
+		ret = -EINVAL;
+		goto out_unmap;
+	}
 
 	num_parent_irqs = of_irq_count(dn);
 	if (num_parent_irqs <= 0) {
@@ -152,7 +173,8 @@ int __init bcm7120_l2_intc_of_init(struct device_node *dn,
 	}
 
 	map_mask = of_get_property(dn, "brcm,int-map-mask", &len);
-	if (!map_mask || (len != (sizeof(*map_mask) * num_parent_irqs))) {
+	if (!map_mask ||
+	    (len != (sizeof(*map_mask) * num_parent_irqs * data->n_words))) {
 		pr_err("invalid brcm,int-map-mask property\n");
 		ret = -EINVAL;
 		goto out_unmap;
@@ -164,56 +186,70 @@ int __init bcm7120_l2_intc_of_init(struct device_node *dn,
 			goto out_unmap;
 	}
 
-	data->domain = irq_domain_add_linear(dn, 32,
-					&irq_generic_chip_ops, NULL);
+	data->domain = irq_domain_add_linear(dn, IRQS_PER_WORD * data->n_words,
+					     &irq_generic_chip_ops, NULL);
 	if (!data->domain) {
 		ret = -ENOMEM;
 		goto out_unmap;
 	}
 
-	ret = irq_alloc_domain_generic_chips(data->domain, 32, 1,
-				dn->full_name, handle_level_irq, clr, 0,
-				IRQ_GC_INIT_MASK_CACHE);
+	/* MIPS chips strapped for BE will automagically configure the
+	 * peripheral registers for CPU-native byte order.
+	 */
+	flags = IRQ_GC_INIT_MASK_CACHE;
+	if (IS_ENABLED(CONFIG_MIPS) && IS_ENABLED(CONFIG_CPU_BIG_ENDIAN))
+		flags |= IRQ_GC_BE_IO;
+
+	ret = irq_alloc_domain_generic_chips(data->domain, IRQS_PER_WORD, 1,
+				dn->full_name, handle_level_irq, clr, 0, flags);
 	if (ret) {
 		pr_err("failed to allocate generic irq chip\n");
 		goto out_free_domain;
 	}
 
-	gc = irq_get_domain_generic_chip(data->domain, 0);
-	gc->unused = 0xfffffff & ~data->irq_map_mask;
-	gc->reg_base = data->base;
-	gc->private = data;
-	ct = gc->chip_types;
-
-	ct->regs.mask = IRQEN;
-	ct->chip.irq_mask = irq_gc_mask_clr_bit;
-	ct->chip.irq_unmask = irq_gc_mask_set_bit;
-	ct->chip.irq_ack = irq_gc_noop;
-	ct->chip.irq_suspend = bcm7120_l2_intc_suspend;
-	ct->chip.irq_resume = bcm7120_l2_intc_resume;
-
-	if (of_property_read_bool(dn, "brcm,irq-can-wake")) {
+	if (of_property_read_bool(dn, "brcm,irq-can-wake"))
 		data->can_wake = true;
-		/* This IRQ chip can wake the system, set all relevant child
-		 * interupts in wake_enabled mask
-		 */
-		gc->wake_enabled = 0xffffffff;
-		gc->wake_enabled &= ~gc->unused;
-		ct->chip.irq_set_wake = irq_gc_set_wake;
+
+	for (idx = 0; idx < data->n_words; idx++) {
+		irq = idx * IRQS_PER_WORD;
+		gc = irq_get_domain_generic_chip(data->domain, irq);
+
+		gc->unused = 0xffffffff & ~data->irq_map_mask[idx];
+		gc->reg_base = data->base[idx];
+		gc->private = data;
+		ct = gc->chip_types;
+
+		ct->regs.mask = IRQEN;
+		ct->chip.irq_mask = irq_gc_mask_clr_bit;
+		ct->chip.irq_unmask = irq_gc_mask_set_bit;
+		ct->chip.irq_ack = irq_gc_noop;
+		ct->chip.irq_suspend = bcm7120_l2_intc_suspend;
+		ct->chip.irq_resume = bcm7120_l2_intc_resume;
+
+		if (data->can_wake) {
+			/* This IRQ chip can wake the system, set all
+			 * relevant child interupts in wake_enabled mask
+			 */
+			gc->wake_enabled = 0xffffffff;
+			gc->wake_enabled &= ~gc->unused;
+			ct->chip.irq_set_wake = irq_gc_set_wake;
+		}
 	}
 
 	pr_info("registered BCM7120 L2 intc (mem: 0x%p, parent IRQ(s): %d)\n",
-			data->base, num_parent_irqs);
+			data->base[0], num_parent_irqs);
 
 	return 0;
 
 out_free_domain:
 	irq_domain_remove(data->domain);
 out_unmap:
-	iounmap(data->base);
-out_free:
+	for (idx = 0; idx < MAX_WORDS; idx++) {
+		if (data->base[idx])
+			iounmap(data->base[idx]);
+	}
 	kfree(data);
 	return ret;
 }
-IRQCHIP_DECLARE(brcmstb_l2_intc, "brcm,bcm7120-l2-intc",
+IRQCHIP_DECLARE(bcm7120_l2_intc, "brcm,bcm7120-l2-intc",
 		bcm7120_l2_intc_of_init);
diff --git a/drivers/irqchip/irq-brcmstb-l2.c b/drivers/irqchip/irq-brcmstb-l2.c
index c15c840987d2..4aa653a0ac72 100644
--- a/drivers/irqchip/irq-brcmstb-l2.c
+++ b/drivers/irqchip/irq-brcmstb-l2.c
@@ -18,7 +18,9 @@
 #include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/module.h>
+#include <linux/kconfig.h>
 #include <linux/platform_device.h>
+#include <linux/spinlock.h>
 #include <linux/of.h>
 #include <linux/of_irq.h>
 #include <linux/of_address.h>
@@ -30,8 +32,6 @@
 #include <linux/irqchip.h>
 #include <linux/irqchip/chained_irq.h>
 
-#include <asm/mach/irq.h>
-
 #include "irqchip.h"
 
 /* Register offsets in the L2 interrupt controller */
@@ -54,23 +54,26 @@ struct brcmstb_l2_intc_data {
 static void brcmstb_l2_intc_irq_handle(unsigned int irq, struct irq_desc *desc)
 {
 	struct brcmstb_l2_intc_data *b = irq_desc_get_handler_data(desc);
+	struct irq_chip_generic *gc = irq_get_domain_generic_chip(b->domain, 0);
 	struct irq_chip *chip = irq_desc_get_chip(desc);
 	u32 status;
 
 	chained_irq_enter(chip, desc);
 
-	status = __raw_readl(b->base + CPU_STATUS) &
-		~(__raw_readl(b->base + CPU_MASK_STATUS));
+	status = irq_reg_readl(gc, CPU_STATUS) &
+		~(irq_reg_readl(gc, CPU_MASK_STATUS));
 
 	if (status == 0) {
-		do_bad_IRQ(irq, desc);
+		raw_spin_lock(&desc->lock);
+		handle_bad_irq(irq, desc);
+		raw_spin_unlock(&desc->lock);
 		goto out;
 	}
 
 	do {
 		irq = ffs(status) - 1;
 		/* ack at our level */
-		__raw_writel(1 << irq, b->base + CPU_CLEAR);
+		irq_reg_writel(gc, 1 << irq, CPU_CLEAR);
 		status &= ~(1 << irq);
 		generic_handle_irq(irq_find_mapping(b->domain, irq));
 	} while (status);
@@ -85,12 +88,12 @@ static void brcmstb_l2_intc_suspend(struct irq_data *d)
 
 	irq_gc_lock(gc);
 	/* Save the current mask */
-	b->saved_mask = __raw_readl(b->base + CPU_MASK_STATUS);
+	b->saved_mask = irq_reg_readl(gc, CPU_MASK_STATUS);
 
 	if (b->can_wake) {
 		/* Program the wakeup mask */
-		__raw_writel(~gc->wake_active, b->base + CPU_MASK_SET);
-		__raw_writel(gc->wake_active, b->base + CPU_MASK_CLEAR);
+		irq_reg_writel(gc, ~gc->wake_active, CPU_MASK_SET);
+		irq_reg_writel(gc, gc->wake_active, CPU_MASK_CLEAR);
 	}
 	irq_gc_unlock(gc);
 }
@@ -102,11 +105,11 @@ static void brcmstb_l2_intc_resume(struct irq_data *d)
 
 	irq_gc_lock(gc);
 	/* Clear unmasked non-wakeup interrupts */
-	__raw_writel(~b->saved_mask & ~gc->wake_active, b->base + CPU_CLEAR);
+	irq_reg_writel(gc, ~b->saved_mask & ~gc->wake_active, CPU_CLEAR);
 
 	/* Restore the saved mask */
-	__raw_writel(b->saved_mask, b->base + CPU_MASK_SET);
-	__raw_writel(~b->saved_mask, b->base + CPU_MASK_CLEAR);
+	irq_reg_writel(gc, b->saved_mask, CPU_MASK_SET);
+	irq_reg_writel(gc, ~b->saved_mask, CPU_MASK_CLEAR);
 	irq_gc_unlock(gc);
 }
 
@@ -118,6 +121,7 @@ int __init brcmstb_l2_intc_of_init(struct device_node *np,
 	struct irq_chip_generic *gc;
 	struct irq_chip_type *ct;
 	int ret;
+	unsigned int flags;
 
 	data = kzalloc(sizeof(*data), GFP_KERNEL);
 	if (!data)
@@ -131,8 +135,8 @@ int __init brcmstb_l2_intc_of_init(struct device_node *np,
 	}
 
 	/* Disable all interrupts by default */
-	__raw_writel(0xffffffff, data->base + CPU_MASK_SET);
-	__raw_writel(0xffffffff, data->base + CPU_CLEAR);
+	writel(0xffffffff, data->base + CPU_MASK_SET);
+	writel(0xffffffff, data->base + CPU_CLEAR);
 
 	data->parent_irq = irq_of_parse_and_map(np, 0);
 	if (data->parent_irq < 0) {
@@ -148,9 +152,16 @@ int __init brcmstb_l2_intc_of_init(struct device_node *np,
 		goto out_unmap;
 	}
 
+	/* MIPS chips strapped for BE will automagically configure the
+	 * peripheral registers for CPU-native byte order.
+	 */
+	flags = 0;
+	if (IS_ENABLED(CONFIG_MIPS) && IS_ENABLED(CONFIG_CPU_BIG_ENDIAN))
+		flags |= IRQ_GC_BE_IO;
+
 	/* Allocate a single Generic IRQ chip for this node */
 	ret = irq_alloc_domain_generic_chips(data->domain, 32, 1,
-				np->full_name, handle_edge_irq, clr, 0, 0);
+				np->full_name, handle_edge_irq, clr, 0, flags);
 	if (ret) {
 		pr_err("failed to allocate generic irq chip\n");
 		goto out_free_domain;
diff --git a/drivers/irqchip/irq-dw-apb-ictl.c b/drivers/irqchip/irq-dw-apb-ictl.c
index 31e231e1f566..53bb7326a60a 100644
--- a/drivers/irqchip/irq-dw-apb-ictl.c
+++ b/drivers/irqchip/irq-dw-apb-ictl.c
@@ -50,6 +50,21 @@ static void dw_apb_ictl_handler(unsigned int irq, struct irq_desc *desc)
 	chained_irq_exit(chip, desc);
 }
 
+#ifdef CONFIG_PM
+static void dw_apb_ictl_resume(struct irq_data *d)
+{
+	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
+	struct irq_chip_type *ct = irq_data_get_chip_type(d);
+
+	irq_gc_lock(gc);
+	writel_relaxed(~0, gc->reg_base + ct->regs.enable);
+	writel_relaxed(*ct->mask_cache, gc->reg_base + ct->regs.mask);
+	irq_gc_unlock(gc);
+}
+#else
+#define dw_apb_ictl_resume	NULL
+#endif /* CONFIG_PM */
+
 static int __init dw_apb_ictl_init(struct device_node *np,
 				   struct device_node *parent)
 {
@@ -94,16 +109,16 @@ static int __init dw_apb_ictl_init(struct device_node *np,
 	 */
 
 	/* mask and enable all interrupts */
-	writel(~0, iobase + APB_INT_MASK_L);
-	writel(~0, iobase + APB_INT_MASK_H);
-	writel(~0, iobase + APB_INT_ENABLE_L);
-	writel(~0, iobase + APB_INT_ENABLE_H);
+	writel_relaxed(~0, iobase + APB_INT_MASK_L);
+	writel_relaxed(~0, iobase + APB_INT_MASK_H);
+	writel_relaxed(~0, iobase + APB_INT_ENABLE_L);
+	writel_relaxed(~0, iobase + APB_INT_ENABLE_H);
 
-	reg = readl(iobase + APB_INT_ENABLE_H);
+	reg = readl_relaxed(iobase + APB_INT_ENABLE_H);
 	if (reg)
 		nrirqs = 32 + fls(reg);
 	else
-		nrirqs = fls(readl(iobase + APB_INT_ENABLE_L));
+		nrirqs = fls(readl_relaxed(iobase + APB_INT_ENABLE_L));
 
 	domain = irq_domain_add_linear(np, nrirqs,
 				       &irq_generic_chip_ops, NULL);
@@ -115,6 +130,7 @@ static int __init dw_apb_ictl_init(struct device_node *np,
 
 	ret = irq_alloc_domain_generic_chips(domain, 32, (nrirqs > 32) ? 2 : 1,
 					     np->name, handle_level_irq, clr, 0,
+					     IRQ_GC_MASK_CACHE_PER_TYPE |
 					     IRQ_GC_INIT_MASK_CACHE);
 	if (ret) {
 		pr_err("%s: unable to alloc irq domain gc\n", np->full_name);
@@ -126,13 +142,17 @@ static int __init dw_apb_ictl_init(struct device_node *np,
 	gc->reg_base = iobase;
 
 	gc->chip_types[0].regs.mask = APB_INT_MASK_L;
+	gc->chip_types[0].regs.enable = APB_INT_ENABLE_L;
 	gc->chip_types[0].chip.irq_mask = irq_gc_mask_set_bit;
 	gc->chip_types[0].chip.irq_unmask = irq_gc_mask_clr_bit;
+	gc->chip_types[0].chip.irq_resume = dw_apb_ictl_resume;
 
 	if (nrirqs > 32) {
 		gc->chip_types[1].regs.mask = APB_INT_MASK_H;
+		gc->chip_types[1].regs.enable = APB_INT_ENABLE_H;
 		gc->chip_types[1].chip.irq_mask = irq_gc_mask_set_bit;
 		gc->chip_types[1].chip.irq_unmask = irq_gc_mask_clr_bit;
+		gc->chip_types[1].chip.irq_resume = dw_apb_ictl_resume;
 	}
 
 	irq_set_handler_data(irq, gc);
diff --git a/drivers/irqchip/irq-hip04.c b/drivers/irqchip/irq-hip04.c
index 9c8f833522e6..29b8f21b74d0 100644
--- a/drivers/irqchip/irq-hip04.c
+++ b/drivers/irqchip/irq-hip04.c
@@ -176,8 +176,7 @@ static void __exception_irq_entry hip04_handle_irq(struct pt_regs *regs)
 		irqnr = irqstat & GICC_IAR_INT_ID_MASK;
 
 		if (likely(irqnr > 15 && irqnr <= HIP04_MAX_IRQS)) {
-			irqnr = irq_find_mapping(hip04_data.domain, irqnr);
-			handle_IRQ(irqnr, regs);
+			handle_domain_irq(hip04_data.domain, irqnr, regs);
 			continue;
 		}
 		if (irqnr < 16) {
diff --git a/drivers/irqchip/irq-sunxi-nmi.c b/drivers/irqchip/irq-sunxi-nmi.c
index 12f547a44ae4..4a9ce5b50c5b 100644
--- a/drivers/irqchip/irq-sunxi-nmi.c
+++ b/drivers/irqchip/irq-sunxi-nmi.c
@@ -50,12 +50,12 @@ static struct sunxi_sc_nmi_reg_offs sun6i_reg_offs = {
 static inline void sunxi_sc_nmi_write(struct irq_chip_generic *gc, u32 off,
 				      u32 val)
 {
-	irq_reg_writel(val, gc->reg_base + off);
+	irq_reg_writel(gc, val, off);
 }
 
 static inline u32 sunxi_sc_nmi_read(struct irq_chip_generic *gc, u32 off)
 {
-	return irq_reg_readl(gc->reg_base + off);
+	return irq_reg_readl(gc, off);
 }
 
 static void sunxi_sc_nmi_handle_irq(unsigned int irq, struct irq_desc *desc)
diff --git a/drivers/irqchip/irq-tb10x.c b/drivers/irqchip/irq-tb10x.c
index 7c44c99bf1f2..accc20036a3c 100644
--- a/drivers/irqchip/irq-tb10x.c
+++ b/drivers/irqchip/irq-tb10x.c
@@ -43,12 +43,12 @@
 static inline void ab_irqctl_writereg(struct irq_chip_generic *gc, u32 reg,
 	u32 val)
 {
-	irq_reg_writel(val, gc->reg_base + reg);
+	irq_reg_writel(gc, val, reg);
 }
 
 static inline u32 ab_irqctl_readreg(struct irq_chip_generic *gc, u32 reg)
 {
-	return irq_reg_readl(gc->reg_base + reg);
+	return irq_reg_readl(gc, reg);
 }
 
 static int tb10x_irq_set_type(struct irq_data *data, unsigned int flow_type)
diff --git a/include/linux/irq.h b/include/linux/irq.h
index 03f48d936f66..8588e5efe577 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -20,6 +20,7 @@
 #include <linux/errno.h>
 #include <linux/topology.h>
 #include <linux/wait.h>
+#include <linux/io.h>
 
 #include <asm/irq.h>
 #include <asm/ptrace.h>
@@ -639,13 +640,6 @@ void arch_teardown_hwirq(unsigned int irq);
 void irq_init_desc(unsigned int irq);
 #endif
 
-#ifndef irq_reg_writel
-# define irq_reg_writel(val, addr)	writel(val, addr)
-#endif
-#ifndef irq_reg_readl
-# define irq_reg_readl(addr)		readl(addr)
-#endif
-
 /**
  * struct irq_chip_regs - register offsets for struct irq_gci
  * @enable:	Enable register offset to reg_base
@@ -692,6 +686,8 @@ struct irq_chip_type {
  * struct irq_chip_generic - Generic irq chip data structure
  * @lock:		Lock to protect register and cache data access
  * @reg_base:		Register base address (virtual)
+ * @reg_readl:		Alternate I/O accessor (defaults to readl if NULL)
+ * @reg_writel:		Alternate I/O accessor (defaults to writel if NULL)
  * @irq_base:		Interrupt base nr for this chip
  * @irq_cnt:		Number of interrupts handled by this chip
  * @mask_cache:		Cached mask register shared between all chip types
@@ -716,6 +712,8 @@ struct irq_chip_type {
 struct irq_chip_generic {
 	raw_spinlock_t		lock;
 	void __iomem		*reg_base;
+	u32			(*reg_readl)(void __iomem *addr);
+	void			(*reg_writel)(u32 val, void __iomem *addr);
 	unsigned int		irq_base;
 	unsigned int		irq_cnt;
 	u32			mask_cache;
@@ -740,12 +738,14 @@ struct irq_chip_generic {
  *				the parent irq. Usually GPIO implementations
  * @IRQ_GC_MASK_CACHE_PER_TYPE:	Mask cache is chip type private
  * @IRQ_GC_NO_MASK:		Do not calculate irq_data->mask
+ * @IRQ_GC_BE_IO:		Use big-endian register accesses (default: LE)
  */
 enum irq_gc_flags {
 	IRQ_GC_INIT_MASK_CACHE		= 1 << 0,
 	IRQ_GC_INIT_NESTED_LOCK		= 1 << 1,
 	IRQ_GC_MASK_CACHE_PER_TYPE	= 1 << 2,
 	IRQ_GC_NO_MASK			= 1 << 3,
+	IRQ_GC_BE_IO			= 1 << 4,
 };
 
 /*
@@ -821,4 +821,22 @@ static inline void irq_gc_lock(struct irq_chip_generic *gc) { }
 static inline void irq_gc_unlock(struct irq_chip_generic *gc) { }
 #endif
 
+static inline void irq_reg_writel(struct irq_chip_generic *gc,
+				  u32 val, int reg_offset)
+{
+	if (gc->reg_writel)
+		gc->reg_writel(val, gc->reg_base + reg_offset);
+	else
+		writel(val, gc->reg_base + reg_offset);
+}
+
+static inline u32 irq_reg_readl(struct irq_chip_generic *gc,
+				int reg_offset)
+{
+	if (gc->reg_readl)
+		return gc->reg_readl(gc->reg_base + reg_offset);
+	else
+		return readl(gc->reg_base + reg_offset);
+}
+
 #endif /* _LINUX_IRQ_H */
diff --git a/kernel/irq/generic-chip.c b/kernel/irq/generic-chip.c
index cf80e7b0ddab..61024e8abdef 100644
--- a/kernel/irq/generic-chip.c
+++ b/kernel/irq/generic-chip.c
@@ -39,7 +39,7 @@ void irq_gc_mask_disable_reg(struct irq_data *d)
 	u32 mask = d->mask;
 
 	irq_gc_lock(gc);
-	irq_reg_writel(mask, gc->reg_base + ct->regs.disable);
+	irq_reg_writel(gc, mask, ct->regs.disable);
 	*ct->mask_cache &= ~mask;
 	irq_gc_unlock(gc);
 }
@@ -59,7 +59,7 @@ void irq_gc_mask_set_bit(struct irq_data *d)
 
 	irq_gc_lock(gc);
 	*ct->mask_cache |= mask;
-	irq_reg_writel(*ct->mask_cache, gc->reg_base + ct->regs.mask);
+	irq_reg_writel(gc, *ct->mask_cache, ct->regs.mask);
 	irq_gc_unlock(gc);
 }
 EXPORT_SYMBOL_GPL(irq_gc_mask_set_bit);
@@ -79,7 +79,7 @@ void irq_gc_mask_clr_bit(struct irq_data *d)
 
 	irq_gc_lock(gc);
 	*ct->mask_cache &= ~mask;
-	irq_reg_writel(*ct->mask_cache, gc->reg_base + ct->regs.mask);
+	irq_reg_writel(gc, *ct->mask_cache, ct->regs.mask);
 	irq_gc_unlock(gc);
 }
 EXPORT_SYMBOL_GPL(irq_gc_mask_clr_bit);
@@ -98,7 +98,7 @@ void irq_gc_unmask_enable_reg(struct irq_data *d)
 	u32 mask = d->mask;
 
 	irq_gc_lock(gc);
-	irq_reg_writel(mask, gc->reg_base + ct->regs.enable);
+	irq_reg_writel(gc, mask, ct->regs.enable);
 	*ct->mask_cache |= mask;
 	irq_gc_unlock(gc);
 }
@@ -114,7 +114,7 @@ void irq_gc_ack_set_bit(struct irq_data *d)
 	u32 mask = d->mask;
 
 	irq_gc_lock(gc);
-	irq_reg_writel(mask, gc->reg_base + ct->regs.ack);
+	irq_reg_writel(gc, mask, ct->regs.ack);
 	irq_gc_unlock(gc);
 }
 EXPORT_SYMBOL_GPL(irq_gc_ack_set_bit);
@@ -130,7 +130,7 @@ void irq_gc_ack_clr_bit(struct irq_data *d)
 	u32 mask = ~d->mask;
 
 	irq_gc_lock(gc);
-	irq_reg_writel(mask, gc->reg_base + ct->regs.ack);
+	irq_reg_writel(gc, mask, ct->regs.ack);
 	irq_gc_unlock(gc);
 }
 
@@ -145,8 +145,8 @@ void irq_gc_mask_disable_reg_and_ack(struct irq_data *d)
 	u32 mask = d->mask;
 
 	irq_gc_lock(gc);
-	irq_reg_writel(mask, gc->reg_base + ct->regs.mask);
-	irq_reg_writel(mask, gc->reg_base + ct->regs.ack);
+	irq_reg_writel(gc, mask, ct->regs.mask);
+	irq_reg_writel(gc, mask, ct->regs.ack);
 	irq_gc_unlock(gc);
 }
 
@@ -161,7 +161,7 @@ void irq_gc_eoi(struct irq_data *d)
 	u32 mask = d->mask;
 
 	irq_gc_lock(gc);
-	irq_reg_writel(mask, gc->reg_base + ct->regs.eoi);
+	irq_reg_writel(gc, mask, ct->regs.eoi);
 	irq_gc_unlock(gc);
 }
 
@@ -191,6 +191,16 @@ int irq_gc_set_wake(struct irq_data *d, unsigned int on)
 	return 0;
 }
 
+static u32 irq_readl_be(void __iomem *addr)
+{
+	return ioread32be(addr);
+}
+
+static void irq_writel_be(u32 val, void __iomem *addr)
+{
+	iowrite32be(val, addr);
+}
+
 static void
 irq_init_generic_chip(struct irq_chip_generic *gc, const char *name,
 		      int num_ct, unsigned int irq_base,
@@ -245,7 +255,7 @@ irq_gc_init_mask_cache(struct irq_chip_generic *gc, enum irq_gc_flags flags)
 		}
 		ct[i].mask_cache = mskptr;
 		if (flags & IRQ_GC_INIT_MASK_CACHE)
-			*mskptr = irq_reg_readl(gc->reg_base + mskreg);
+			*mskptr = irq_reg_readl(gc, mskreg);
 	}
 }
 
@@ -300,7 +310,13 @@ int irq_alloc_domain_generic_chips(struct irq_domain *d, int irqs_per_chip,
 		dgc->gc[i] = gc = tmp;
 		irq_init_generic_chip(gc, name, num_ct, i * irqs_per_chip,
 				      NULL, handler);
+
 		gc->domain = d;
+		if (gcflags & IRQ_GC_BE_IO) {
+			gc->reg_readl = &irq_readl_be;
+			gc->reg_writel = &irq_writel_be;
+		}
+
 		raw_spin_lock_irqsave(&gc_lock, flags);
 		list_add_tail(&gc->list, &gc_list);
 		raw_spin_unlock_irqrestore(&gc_lock, flags);
