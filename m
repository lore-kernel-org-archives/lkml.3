Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752017AbaKGGpJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 01:45:09 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:42806 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751987AbaKGGpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 01:45:04 -0500
From: Kevin Cernekee <cernekee@gmail.com>
To: tglx@linutronix.de, jason@lakedaemon.net, linux-sh@vger.kernel.org
Cc: arnd@arndb.de, f.fainelli@gmail.com, ralf@linux-mips.org,
        sergei.shtylyov@cogentembedded.com, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, mbizon@freebox.fr, jogo@openwrt.org,
        linux-mips@linux-mips.org
Subject: [PATCH V4 02/14] genirq: Generic chip: Change irq_reg_{readl,writel} arguments
Date: Thu,  6 Nov 2014 22:44:17 -0800
Message-Id: <1415342669-30640-3-git-send-email-cernekee@gmail.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1415342669-30640-1-git-send-email-cernekee@gmail.com>
References: <1415342669-30640-1-git-send-email-cernekee@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pass in the irq_chip_generic struct so we can use different readl/writel
settings for each irqchip driver, when appropriate.  Compute
(gc->reg_base + reg_offset) in the helper function because this is pretty
much what all callers want to do anyway.

Compile-tested using the following configurations:

    at91_dt_defconfig (CONFIG_ATMEL_AIC_IRQ=y)
    sama5_defconfig (CONFIG_ATMEL_AIC5_IRQ=y)
    sunxi_defconfig (CONFIG_ARCH_SUNXI=y)

tb10x (ARC) is untested.

Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
---
 drivers/irqchip/irq-atmel-aic.c  | 40 ++++++++++++-------------
 drivers/irqchip/irq-atmel-aic5.c | 65 +++++++++++++++++++---------------------
 drivers/irqchip/irq-sunxi-nmi.c  |  4 +--
 drivers/irqchip/irq-tb10x.c      |  4 +--
 include/linux/irq.h              | 20 ++++++++-----
 kernel/irq/generic-chip.c        | 20 ++++++-------
 6 files changed, 78 insertions(+), 75 deletions(-)

diff --git a/drivers/irqchip/irq-atmel-aic.c b/drivers/irqchip/irq-atmel-aic.c
index 9a2cf3c..27fdd8c 100644
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
diff --git a/drivers/irqchip/irq-atmel-aic5.c b/drivers/irqchip/irq-atmel-aic5.c
index a11aae8..a2e8c3f 100644
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
diff --git a/drivers/irqchip/irq-sunxi-nmi.c b/drivers/irqchip/irq-sunxi-nmi.c
index 12f547a..4a9ce5b 100644
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
index 7c44c99..accc200 100644
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
index 03f48d9..ed1135d 100644
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
@@ -821,4 +815,16 @@ static inline void irq_gc_lock(struct irq_chip_generic *gc) { }
 static inline void irq_gc_unlock(struct irq_chip_generic *gc) { }
 #endif
 
+static inline void irq_reg_writel(struct irq_chip_generic *gc,
+				  u32 val, int reg_offset)
+{
+	writel(val, gc->reg_base + reg_offset);
+}
+
+static inline u32 irq_reg_readl(struct irq_chip_generic *gc,
+				int reg_offset)
+{
+	return readl(gc->reg_base + reg_offset);
+}
+
 #endif /* _LINUX_IRQ_H */
diff --git a/kernel/irq/generic-chip.c b/kernel/irq/generic-chip.c
index cf80e7b..db458c6 100644
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
 
@@ -245,7 +245,7 @@ irq_gc_init_mask_cache(struct irq_chip_generic *gc, enum irq_gc_flags flags)
 		}
 		ct[i].mask_cache = mskptr;
 		if (flags & IRQ_GC_INIT_MASK_CACHE)
-			*mskptr = irq_reg_readl(gc->reg_base + mskreg);
+			*mskptr = irq_reg_readl(gc, mskreg);
 	}
 }
 
-- 
2.1.1

