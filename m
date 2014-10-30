Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933464AbaJ3CYJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 22:24:09 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:32928 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757684AbaJ3CTk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 22:19:40 -0400
From: Kevin Cernekee <cernekee@gmail.com>
To: arnd@arndb.de, f.fainelli@gmail.com, tglx@linutronix.de,
        jason@lakedaemon.net, ralf@linux-mips.org, lethal@linux-sh.org
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        mbizon@freebox.fr, jogo@openwrt.org, linux-mips@linux-mips.org
Subject: [PATCH V2 01/15] irqchip: Replace irq_reg_{readl,writel} with {readl,writel}
Date: Wed, 29 Oct 2014 19:17:54 -0700
Message-Id: <1414635488-14137-2-git-send-email-cernekee@gmail.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1414635488-14137-1-git-send-email-cernekee@gmail.com>
References: <1414635488-14137-1-git-send-email-cernekee@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nobody is overriding these definitions anyway, so get rid of the wrappers.

Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
---
 drivers/irqchip/irq-atmel-aic.c  | 40 ++++++++++++-------------
 drivers/irqchip/irq-atmel-aic5.c | 65 +++++++++++++++++++---------------------
 drivers/irqchip/irq-sunxi-nmi.c  |  4 +--
 drivers/irqchip/irq-tb10x.c      |  4 +--
 4 files changed, 55 insertions(+), 58 deletions(-)

diff --git a/drivers/irqchip/irq-atmel-aic.c b/drivers/irqchip/irq-atmel-aic.c
index 9a2cf3c..cfa65f13 100644
--- a/drivers/irqchip/irq-atmel-aic.c
+++ b/drivers/irqchip/irq-atmel-aic.c
@@ -65,11 +65,11 @@ aic_handle(struct pt_regs *regs)
 	u32 irqnr;
 	u32 irqstat;
 
-	irqnr = irq_reg_readl(gc->reg_base + AT91_AIC_IVR);
-	irqstat = irq_reg_readl(gc->reg_base + AT91_AIC_ISR);
+	irqnr = readl(gc->reg_base + AT91_AIC_IVR);
+	irqstat = readl(gc->reg_base + AT91_AIC_ISR);
 
 	if (!irqstat)
-		irq_reg_writel(0, gc->reg_base + AT91_AIC_EOICR);
+		writel(0, gc->reg_base + AT91_AIC_EOICR);
 	else
 		handle_domain_irq(aic_domain, irqnr, regs);
 }
@@ -80,7 +80,7 @@ static int aic_retrigger(struct irq_data *d)
 
 	/* Enable interrupt on AIC5 */
 	irq_gc_lock(gc);
-	irq_reg_writel(d->mask, gc->reg_base + AT91_AIC_ISCR);
+	writel(d->mask, gc->reg_base + AT91_AIC_ISCR);
 	irq_gc_unlock(gc);
 
 	return 0;
@@ -92,12 +92,12 @@ static int aic_set_type(struct irq_data *d, unsigned type)
 	unsigned int smr;
 	int ret;
 
-	smr = irq_reg_readl(gc->reg_base + AT91_AIC_SMR(d->hwirq));
+	smr = readl(gc->reg_base + AT91_AIC_SMR(d->hwirq));
 	ret = aic_common_set_type(d, type, &smr);
 	if (ret)
 		return ret;
 
-	irq_reg_writel(smr, gc->reg_base + AT91_AIC_SMR(d->hwirq));
+	writel(smr, gc->reg_base + AT91_AIC_SMR(d->hwirq));
 
 	return 0;
 }
@@ -108,8 +108,8 @@ static void aic_suspend(struct irq_data *d)
 	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
 
 	irq_gc_lock(gc);
-	irq_reg_writel(gc->mask_cache, gc->reg_base + AT91_AIC_IDCR);
-	irq_reg_writel(gc->wake_active, gc->reg_base + AT91_AIC_IECR);
+	writel(gc->mask_cache, gc->reg_base + AT91_AIC_IDCR);
+	writel(gc->wake_active, gc->reg_base + AT91_AIC_IECR);
 	irq_gc_unlock(gc);
 }
 
@@ -118,8 +118,8 @@ static void aic_resume(struct irq_data *d)
 	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
 
 	irq_gc_lock(gc);
-	irq_reg_writel(gc->wake_active, gc->reg_base + AT91_AIC_IDCR);
-	irq_reg_writel(gc->mask_cache, gc->reg_base + AT91_AIC_IECR);
+	writel(gc->wake_active, gc->reg_base + AT91_AIC_IDCR);
+	writel(gc->mask_cache, gc->reg_base + AT91_AIC_IECR);
 	irq_gc_unlock(gc);
 }
 
@@ -128,8 +128,8 @@ static void aic_pm_shutdown(struct irq_data *d)
 	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
 
 	irq_gc_lock(gc);
-	irq_reg_writel(0xffffffff, gc->reg_base + AT91_AIC_IDCR);
-	irq_reg_writel(0xffffffff, gc->reg_base + AT91_AIC_ICCR);
+	writel(0xffffffff, gc->reg_base + AT91_AIC_IDCR);
+	writel(0xffffffff, gc->reg_base + AT91_AIC_ICCR);
 	irq_gc_unlock(gc);
 }
 #else
@@ -148,24 +148,24 @@ static void __init aic_hw_init(struct irq_domain *domain)
 	 * will not Lock out nIRQ
 	 */
 	for (i = 0; i < 8; i++)
-		irq_reg_writel(0, gc->reg_base + AT91_AIC_EOICR);
+		writel(0, gc->reg_base + AT91_AIC_EOICR);
 
 	/*
 	 * Spurious Interrupt ID in Spurious Vector Register.
 	 * When there is no current interrupt, the IRQ Vector Register
 	 * reads the value stored in AIC_SPU
 	 */
-	irq_reg_writel(0xffffffff, gc->reg_base + AT91_AIC_SPU);
+	writel(0xffffffff, gc->reg_base + AT91_AIC_SPU);
 
 	/* No debugging in AIC: Debug (Protect) Control Register */
-	irq_reg_writel(0, gc->reg_base + AT91_AIC_DCR);
+	writel(0, gc->reg_base + AT91_AIC_DCR);
 
 	/* Disable and clear all interrupts initially */
-	irq_reg_writel(0xffffffff, gc->reg_base + AT91_AIC_IDCR);
-	irq_reg_writel(0xffffffff, gc->reg_base + AT91_AIC_ICCR);
+	writel(0xffffffff, gc->reg_base + AT91_AIC_IDCR);
+	writel(0xffffffff, gc->reg_base + AT91_AIC_ICCR);
 
 	for (i = 0; i < 32; i++)
-		irq_reg_writel(i, gc->reg_base + AT91_AIC_SVR(i));
+		writel(i, gc->reg_base + AT91_AIC_SVR(i));
 }
 
 static int aic_irq_domain_xlate(struct irq_domain *d,
@@ -195,10 +195,10 @@ static int aic_irq_domain_xlate(struct irq_domain *d,
 	gc = dgc->gc[idx];
 
 	irq_gc_lock(gc);
-	smr = irq_reg_readl(gc->reg_base + AT91_AIC_SMR(*out_hwirq));
+	smr = readl(gc->reg_base + AT91_AIC_SMR(*out_hwirq));
 	ret = aic_common_set_priority(intspec[2], &smr);
 	if (!ret)
-		irq_reg_writel(smr, gc->reg_base + AT91_AIC_SMR(*out_hwirq));
+		writel(smr, gc->reg_base + AT91_AIC_SMR(*out_hwirq));
 	irq_gc_unlock(gc);
 
 	return ret;
diff --git a/drivers/irqchip/irq-atmel-aic5.c b/drivers/irqchip/irq-atmel-aic5.c
index a11aae8..f6ef4da 100644
--- a/drivers/irqchip/irq-atmel-aic5.c
+++ b/drivers/irqchip/irq-atmel-aic5.c
@@ -75,11 +75,11 @@ aic5_handle(struct pt_regs *regs)
 	u32 irqnr;
 	u32 irqstat;
 
-	irqnr = irq_reg_readl(gc->reg_base + AT91_AIC5_IVR);
-	irqstat = irq_reg_readl(gc->reg_base + AT91_AIC5_ISR);
+	irqnr = readl(gc->reg_base + AT91_AIC5_IVR);
+	irqstat = readl(gc->reg_base + AT91_AIC5_ISR);
 
 	if (!irqstat)
-		irq_reg_writel(0, gc->reg_base + AT91_AIC5_EOICR);
+		writel(0, gc->reg_base + AT91_AIC5_EOICR);
 	else
 		handle_domain_irq(aic5_domain, irqnr, regs);
 }
@@ -92,8 +92,8 @@ static void aic5_mask(struct irq_data *d)
 
 	/* Disable interrupt on AIC5 */
 	irq_gc_lock(gc);
-	irq_reg_writel(d->hwirq, gc->reg_base + AT91_AIC5_SSR);
-	irq_reg_writel(1, gc->reg_base + AT91_AIC5_IDCR);
+	writel(d->hwirq, gc->reg_base + AT91_AIC5_SSR);
+	writel(1, gc->reg_base + AT91_AIC5_IDCR);
 	gc->mask_cache &= ~d->mask;
 	irq_gc_unlock(gc);
 }
@@ -106,8 +106,8 @@ static void aic5_unmask(struct irq_data *d)
 
 	/* Enable interrupt on AIC5 */
 	irq_gc_lock(gc);
-	irq_reg_writel(d->hwirq, gc->reg_base + AT91_AIC5_SSR);
-	irq_reg_writel(1, gc->reg_base + AT91_AIC5_IECR);
+	writel(d->hwirq, gc->reg_base + AT91_AIC5_SSR);
+	writel(1, gc->reg_base + AT91_AIC5_IECR);
 	gc->mask_cache |= d->mask;
 	irq_gc_unlock(gc);
 }
@@ -120,8 +120,8 @@ static int aic5_retrigger(struct irq_data *d)
 
 	/* Enable interrupt on AIC5 */
 	irq_gc_lock(gc);
-	irq_reg_writel(d->hwirq, gc->reg_base + AT91_AIC5_SSR);
-	irq_reg_writel(1, gc->reg_base + AT91_AIC5_ISCR);
+	writel(d->hwirq, gc->reg_base + AT91_AIC5_SSR);
+	writel(1, gc->reg_base + AT91_AIC5_ISCR);
 	irq_gc_unlock(gc);
 
 	return 0;
@@ -136,11 +136,11 @@ static int aic5_set_type(struct irq_data *d, unsigned type)
 	int ret;
 
 	irq_gc_lock(gc);
-	irq_reg_writel(d->hwirq, gc->reg_base + AT91_AIC5_SSR);
-	smr = irq_reg_readl(gc->reg_base + AT91_AIC5_SMR);
+	writel(d->hwirq, gc->reg_base + AT91_AIC5_SSR);
+	smr = readl(gc->reg_base + AT91_AIC5_SMR);
 	ret = aic_common_set_type(d, type, &smr);
 	if (!ret)
-		irq_reg_writel(smr, gc->reg_base + AT91_AIC5_SMR);
+		writel(smr, gc->reg_base + AT91_AIC5_SMR);
 	irq_gc_unlock(gc);
 
 	return ret;
@@ -162,12 +162,11 @@ static void aic5_suspend(struct irq_data *d)
 		if ((mask & gc->mask_cache) == (mask & gc->wake_active))
 			continue;
 
-		irq_reg_writel(i + gc->irq_base,
-			       bgc->reg_base + AT91_AIC5_SSR);
+		writel(i + gc->irq_base, bgc->reg_base + AT91_AIC5_SSR);
 		if (mask & gc->wake_active)
-			irq_reg_writel(1, bgc->reg_base + AT91_AIC5_IECR);
+			writel(1, bgc->reg_base + AT91_AIC5_IECR);
 		else
-			irq_reg_writel(1, bgc->reg_base + AT91_AIC5_IDCR);
+			writel(1, bgc->reg_base + AT91_AIC5_IDCR);
 	}
 	irq_gc_unlock(bgc);
 }
@@ -187,12 +186,11 @@ static void aic5_resume(struct irq_data *d)
 		if ((mask & gc->mask_cache) == (mask & gc->wake_active))
 			continue;
 
-		irq_reg_writel(i + gc->irq_base,
-			       bgc->reg_base + AT91_AIC5_SSR);
+		writel(i + gc->irq_base, bgc->reg_base + AT91_AIC5_SSR);
 		if (mask & gc->mask_cache)
-			irq_reg_writel(1, bgc->reg_base + AT91_AIC5_IECR);
+			writel(1, bgc->reg_base + AT91_AIC5_IECR);
 		else
-			irq_reg_writel(1, bgc->reg_base + AT91_AIC5_IDCR);
+			writel(1, bgc->reg_base + AT91_AIC5_IDCR);
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
+		writel(i + gc->irq_base, bgc->reg_base + AT91_AIC5_SSR);
+		writel(1, bgc->reg_base + AT91_AIC5_IDCR);
+		writel(1, bgc->reg_base + AT91_AIC5_ICCR);
 	}
 	irq_gc_unlock(bgc);
 }
@@ -230,24 +227,24 @@ static void __init aic5_hw_init(struct irq_domain *domain)
 	 * will not Lock out nIRQ
 	 */
 	for (i = 0; i < 8; i++)
-		irq_reg_writel(0, gc->reg_base + AT91_AIC5_EOICR);
+		writel(0, gc->reg_base + AT91_AIC5_EOICR);
 
 	/*
 	 * Spurious Interrupt ID in Spurious Vector Register.
 	 * When there is no current interrupt, the IRQ Vector Register
 	 * reads the value stored in AIC_SPU
 	 */
-	irq_reg_writel(0xffffffff, gc->reg_base + AT91_AIC5_SPU);
+	writel(0xffffffff, gc->reg_base + AT91_AIC5_SPU);
 
 	/* No debugging in AIC: Debug (Protect) Control Register */
-	irq_reg_writel(0, gc->reg_base + AT91_AIC5_DCR);
+	writel(0, gc->reg_base + AT91_AIC5_DCR);
 
 	/* Disable and clear all interrupts initially */
 	for (i = 0; i < domain->revmap_size; i++) {
-		irq_reg_writel(i, gc->reg_base + AT91_AIC5_SSR);
-		irq_reg_writel(i, gc->reg_base + AT91_AIC5_SVR);
-		irq_reg_writel(1, gc->reg_base + AT91_AIC5_IDCR);
-		irq_reg_writel(1, gc->reg_base + AT91_AIC5_ICCR);
+		writel(i, gc->reg_base + AT91_AIC5_SSR);
+		writel(i, gc->reg_base + AT91_AIC5_SVR);
+		writel(1, gc->reg_base + AT91_AIC5_IDCR);
+		writel(1, gc->reg_base + AT91_AIC5_ICCR);
 	}
 }
 
@@ -273,11 +270,11 @@ static int aic5_irq_domain_xlate(struct irq_domain *d,
 	gc = dgc->gc[0];
 
 	irq_gc_lock(gc);
-	irq_reg_writel(*out_hwirq, gc->reg_base + AT91_AIC5_SSR);
-	smr = irq_reg_readl(gc->reg_base + AT91_AIC5_SMR);
+	writel(*out_hwirq, gc->reg_base + AT91_AIC5_SSR);
+	smr = readl(gc->reg_base + AT91_AIC5_SMR);
 	ret = aic_common_set_priority(intspec[2], &smr);
 	if (!ret)
-		irq_reg_writel(intspec[2] | smr, gc->reg_base + AT91_AIC5_SMR);
+		writel(intspec[2] | smr, gc->reg_base + AT91_AIC5_SMR);
 	irq_gc_unlock(gc);
 
 	return ret;
diff --git a/drivers/irqchip/irq-sunxi-nmi.c b/drivers/irqchip/irq-sunxi-nmi.c
index 12f547a..776e3f0 100644
--- a/drivers/irqchip/irq-sunxi-nmi.c
+++ b/drivers/irqchip/irq-sunxi-nmi.c
@@ -50,12 +50,12 @@ static struct sunxi_sc_nmi_reg_offs sun6i_reg_offs = {
 static inline void sunxi_sc_nmi_write(struct irq_chip_generic *gc, u32 off,
 				      u32 val)
 {
-	irq_reg_writel(val, gc->reg_base + off);
+	writel(val, gc->reg_base + off);
 }
 
 static inline u32 sunxi_sc_nmi_read(struct irq_chip_generic *gc, u32 off)
 {
-	return irq_reg_readl(gc->reg_base + off);
+	return readl(gc->reg_base + off);
 }
 
 static void sunxi_sc_nmi_handle_irq(unsigned int irq, struct irq_desc *desc)
diff --git a/drivers/irqchip/irq-tb10x.c b/drivers/irqchip/irq-tb10x.c
index 7c44c99..8cd995d 100644
--- a/drivers/irqchip/irq-tb10x.c
+++ b/drivers/irqchip/irq-tb10x.c
@@ -43,12 +43,12 @@
 static inline void ab_irqctl_writereg(struct irq_chip_generic *gc, u32 reg,
 	u32 val)
 {
-	irq_reg_writel(val, gc->reg_base + reg);
+	writel(val, gc->reg_base + reg);
 }
 
 static inline u32 ab_irqctl_readreg(struct irq_chip_generic *gc, u32 reg)
 {
-	return irq_reg_readl(gc->reg_base + reg);
+	return readl(gc->reg_base + reg);
 }
 
 static int tb10x_irq_set_type(struct irq_data *data, unsigned int flow_type)
-- 
2.1.1

