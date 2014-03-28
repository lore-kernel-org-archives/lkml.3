Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753920AbaC1SBp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 14:01:45 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:52766 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754265AbaC1R7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 13:59:41 -0400
From: Boris BREZILLON <b.brezillon.dev@gmail.com>
To: Rob Landley <rob@landley.net>, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Boris BREZILLON <b.brezillon.dev@gmail.com>
Subject: [RFC PATCH v2 08/10] ARM: at91: remove old irq material
Date: Fri, 28 Mar 2014 18:59:06 +0100
Message-Id: <1396029548-10928-9-git-send-email-b.brezillon.dev@gmail.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1396029548-10928-1-git-send-email-b.brezillon.dev@gmail.com>
References: <1396029548-10928-1-git-send-email-b.brezillon.dev@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove all the material related to AIC support on dt enabled SoCs.

This is now implemented within the new AIC driver
(drivers/irqchip/atmel-aic.c).

Signed-off-by: Boris BREZILLON <b.brezillon.dev@gmail.com>
---
 arch/arm/mach-at91/irq.c |  270 ++--------------------------------------------
 1 file changed, 6 insertions(+), 264 deletions(-)

diff --git a/arch/arm/mach-at91/irq.c b/arch/arm/mach-at91/irq.c
index 3d192c5..cdb3ec9 100644
--- a/arch/arm/mach-at91/irq.c
+++ b/arch/arm/mach-at91/irq.c
@@ -48,11 +48,6 @@ void __iomem *at91_aic_base;
 static struct irq_domain *at91_aic_domain;
 static struct device_node *at91_aic_np;
 static unsigned int n_irqs = NR_AIC_IRQS;
-static unsigned long at91_aic_caps = 0;
-
-/* AIC5 introduces a Source Select Register */
-#define AT91_AIC_CAP_AIC5	(1 << 0)
-#define has_aic5()		(at91_aic_caps & AT91_AIC_CAP_AIC5)
 
 #ifdef CONFIG_PM
 
@@ -92,50 +87,14 @@ static int at91_aic_set_wake(struct irq_data *d, unsigned value)
 
 void at91_irq_suspend(void)
 {
-	int bit = -1;
-
-	if (has_aic5()) {
-		/* disable enabled irqs */
-		while ((bit = find_next_bit(backups, n_irqs, bit + 1)) < n_irqs) {
-			at91_aic_write(AT91_AIC5_SSR,
-				       bit & AT91_AIC5_INTSEL_MSK);
-			at91_aic_write(AT91_AIC5_IDCR, 1);
-		}
-		/* enable wakeup irqs */
-		bit = -1;
-		while ((bit = find_next_bit(wakeups, n_irqs, bit + 1)) < n_irqs) {
-			at91_aic_write(AT91_AIC5_SSR,
-				       bit & AT91_AIC5_INTSEL_MSK);
-			at91_aic_write(AT91_AIC5_IECR, 1);
-		}
-	} else {
-		at91_aic_write(AT91_AIC_IDCR, *backups);
-		at91_aic_write(AT91_AIC_IECR, *wakeups);
-	}
+	at91_aic_write(AT91_AIC_IDCR, *backups);
+	at91_aic_write(AT91_AIC_IECR, *wakeups);
 }
 
 void at91_irq_resume(void)
 {
-	int bit = -1;
-
-	if (has_aic5()) {
-		/* disable wakeup irqs */
-		while ((bit = find_next_bit(wakeups, n_irqs, bit + 1)) < n_irqs) {
-			at91_aic_write(AT91_AIC5_SSR,
-				       bit & AT91_AIC5_INTSEL_MSK);
-			at91_aic_write(AT91_AIC5_IDCR, 1);
-		}
-		/* enable irqs disabled for suspend */
-		bit = -1;
-		while ((bit = find_next_bit(backups, n_irqs, bit + 1)) < n_irqs) {
-			at91_aic_write(AT91_AIC5_SSR,
-				       bit & AT91_AIC5_INTSEL_MSK);
-			at91_aic_write(AT91_AIC5_IECR, 1);
-		}
-	} else {
-		at91_aic_write(AT91_AIC_IDCR, *wakeups);
-		at91_aic_write(AT91_AIC_IECR, *backups);
-	}
+	at91_aic_write(AT91_AIC_IDCR, *wakeups);
+	at91_aic_write(AT91_AIC_IECR, *backups);
 }
 
 #else
@@ -169,21 +128,6 @@ at91_aic_handle_irq(struct pt_regs *regs)
 		handle_IRQ(irqnr, regs);
 }
 
-asmlinkage void __exception_irq_entry
-at91_aic5_handle_irq(struct pt_regs *regs)
-{
-	u32 irqnr;
-	u32 irqstat;
-
-	irqnr = at91_aic_read(AT91_AIC5_IVR);
-	irqstat = at91_aic_read(AT91_AIC5_ISR);
-
-	if (!irqstat)
-		at91_aic_write(AT91_AIC5_EOICR, 0);
-	else
-		handle_IRQ(irqnr, regs);
-}
-
 static void at91_aic_mask_irq(struct irq_data *d)
 {
 	/* Disable interrupt on AIC */
@@ -192,15 +136,6 @@ static void at91_aic_mask_irq(struct irq_data *d)
 	clear_backup(d->hwirq);
 }
 
-static void __maybe_unused at91_aic5_mask_irq(struct irq_data *d)
-{
-	/* Disable interrupt on AIC5 */
-	at91_aic_write(AT91_AIC5_SSR, d->hwirq & AT91_AIC5_INTSEL_MSK);
-	at91_aic_write(AT91_AIC5_IDCR, 1);
-	/* Update ISR cache */
-	clear_backup(d->hwirq);
-}
-
 static void at91_aic_unmask_irq(struct irq_data *d)
 {
 	/* Enable interrupt on AIC */
@@ -209,15 +144,6 @@ static void at91_aic_unmask_irq(struct irq_data *d)
 	set_backup(d->hwirq);
 }
 
-static void __maybe_unused at91_aic5_unmask_irq(struct irq_data *d)
-{
-	/* Enable interrupt on AIC5 */
-	at91_aic_write(AT91_AIC5_SSR, d->hwirq & AT91_AIC5_INTSEL_MSK);
-	at91_aic_write(AT91_AIC5_IECR, 1);
-	/* Update ISR cache */
-	set_backup(d->hwirq);
-}
-
 static void at91_aic_eoi(struct irq_data *d)
 {
 	/*
@@ -227,11 +153,6 @@ static void at91_aic_eoi(struct irq_data *d)
 	at91_aic_write(AT91_AIC_EOICR, 0);
 }
 
-static void __maybe_unused at91_aic5_eoi(struct irq_data *d)
-{
-	at91_aic_write(AT91_AIC5_EOICR, 0);
-}
-
 static unsigned long *at91_extern_irq;
 
 u32 at91_get_extern_irq(void)
@@ -282,16 +203,8 @@ static int at91_aic_set_type(struct irq_data *d, unsigned type)
 	if (srctype < 0)
 		return srctype;
 
-	if (has_aic5()) {
-		at91_aic_write(AT91_AIC5_SSR,
-			       d->hwirq & AT91_AIC5_INTSEL_MSK);
-		smr = at91_aic_read(AT91_AIC5_SMR) & ~AT91_AIC_SRCTYPE;
-		at91_aic_write(AT91_AIC5_SMR, smr | srctype);
-	} else {
-		smr = at91_aic_read(AT91_AIC_SMR(d->hwirq))
-		      & ~AT91_AIC_SRCTYPE;
-		at91_aic_write(AT91_AIC_SMR(d->hwirq), smr | srctype);
-	}
+	smr = at91_aic_read(AT91_AIC_SMR(d->hwirq)) & ~AT91_AIC_SRCTYPE;
+	at91_aic_write(AT91_AIC_SMR(d->hwirq), smr | srctype);
 
 	return 0;
 }
@@ -331,177 +244,6 @@ static void __init at91_aic_hw_init(unsigned int spu_vector)
 	at91_aic_write(AT91_AIC_ICCR, 0xFFFFFFFF);
 }
 
-static void __init __maybe_unused at91_aic5_hw_init(unsigned int spu_vector)
-{
-	int i;
-
-	/*
-	 * Perform 8 End Of Interrupt Command to make sure AIC
-	 * will not Lock out nIRQ
-	 */
-	for (i = 0; i < 8; i++)
-		at91_aic_write(AT91_AIC5_EOICR, 0);
-
-	/*
-	 * Spurious Interrupt ID in Spurious Vector Register.
-	 * When there is no current interrupt, the IRQ Vector Register
-	 * reads the value stored in AIC_SPU
-	 */
-	at91_aic_write(AT91_AIC5_SPU, spu_vector);
-
-	/* No debugging in AIC: Debug (Protect) Control Register */
-	at91_aic_write(AT91_AIC5_DCR, 0);
-
-	/* Disable and clear all interrupts initially */
-	for (i = 0; i < n_irqs; i++) {
-		at91_aic_write(AT91_AIC5_SSR, i & AT91_AIC5_INTSEL_MSK);
-		at91_aic_write(AT91_AIC5_IDCR, 1);
-		at91_aic_write(AT91_AIC5_ICCR, 1);
-	}
-}
-
-#if defined(CONFIG_OF)
-static unsigned int *at91_aic_irq_priorities;
-
-static int at91_aic_irq_map(struct irq_domain *h, unsigned int virq,
-							irq_hw_number_t hw)
-{
-	/* Put virq number in Source Vector Register */
-	at91_aic_write(AT91_AIC_SVR(hw), virq);
-
-	/* Active Low interrupt, with priority */
-	at91_aic_write(AT91_AIC_SMR(hw),
-		       AT91_AIC_SRCTYPE_LOW | at91_aic_irq_priorities[hw]);
-
-	irq_set_chip_and_handler(virq, &at91_aic_chip, handle_fasteoi_irq);
-	set_irq_flags(virq, IRQF_VALID | IRQF_PROBE);
-
-	return 0;
-}
-
-static int at91_aic5_irq_map(struct irq_domain *h, unsigned int virq,
-		irq_hw_number_t hw)
-{
-	at91_aic_write(AT91_AIC5_SSR, hw & AT91_AIC5_INTSEL_MSK);
-
-	/* Put virq number in Source Vector Register */
-	at91_aic_write(AT91_AIC5_SVR, virq);
-
-	/* Active Low interrupt, with priority */
-	at91_aic_write(AT91_AIC5_SMR,
-		       AT91_AIC_SRCTYPE_LOW | at91_aic_irq_priorities[hw]);
-
-	irq_set_chip_and_handler(virq, &at91_aic_chip, handle_fasteoi_irq);
-	set_irq_flags(virq, IRQF_VALID | IRQF_PROBE);
-
-	return 0;
-}
-
-static int at91_aic_irq_domain_xlate(struct irq_domain *d, struct device_node *ctrlr,
-				const u32 *intspec, unsigned int intsize,
-				irq_hw_number_t *out_hwirq, unsigned int *out_type)
-{
-	if (WARN_ON(intsize < 3))
-		return -EINVAL;
-	if (WARN_ON(intspec[0] >= n_irqs))
-		return -EINVAL;
-	if (WARN_ON((intspec[2] < AT91_AIC_IRQ_MIN_PRIORITY)
-		    || (intspec[2] > AT91_AIC_IRQ_MAX_PRIORITY)))
-		return -EINVAL;
-
-	*out_hwirq = intspec[0];
-	*out_type = intspec[1] & IRQ_TYPE_SENSE_MASK;
-	at91_aic_irq_priorities[*out_hwirq] = intspec[2];
-
-	return 0;
-}
-
-static struct irq_domain_ops at91_aic_irq_ops = {
-	.map	= at91_aic_irq_map,
-	.xlate	= at91_aic_irq_domain_xlate,
-};
-
-int __init at91_aic_of_common_init(struct device_node *node,
-				    struct device_node *parent)
-{
-	struct property *prop;
-	const __be32 *p;
-	u32 val;
-
-	at91_extern_irq = kzalloc(BITS_TO_LONGS(n_irqs)
-				  * sizeof(*at91_extern_irq), GFP_KERNEL);
-	if (!at91_extern_irq)
-		return -ENOMEM;
-
-	if (at91_aic_pm_init()) {
-		kfree(at91_extern_irq);
-		return -ENOMEM;
-	}
-
-	at91_aic_irq_priorities = kzalloc(n_irqs
-					  * sizeof(*at91_aic_irq_priorities),
-					  GFP_KERNEL);
-	if (!at91_aic_irq_priorities)
-		return -ENOMEM;
-
-	at91_aic_base = of_iomap(node, 0);
-	at91_aic_np = node;
-
-	at91_aic_domain = irq_domain_add_linear(at91_aic_np, n_irqs,
-						&at91_aic_irq_ops, NULL);
-	if (!at91_aic_domain)
-		panic("Unable to add AIC irq domain (DT)\n");
-
-	of_property_for_each_u32(node, "atmel,external-irqs", prop, p, val) {
-		if (val >= n_irqs)
-			pr_warn("AIC: external irq %d >= %d skip it\n",
-				val, n_irqs);
-		else
-			set_bit(val, at91_extern_irq);
-	}
-
-	irq_set_default_host(at91_aic_domain);
-
-	return 0;
-}
-
-int __init at91_aic_of_init(struct device_node *node,
-				     struct device_node *parent)
-{
-	int err;
-
-	err = at91_aic_of_common_init(node, parent);
-	if (err)
-		return err;
-
-	at91_aic_hw_init(n_irqs);
-
-	return 0;
-}
-
-int __init at91_aic5_of_init(struct device_node *node,
-				     struct device_node *parent)
-{
-	int err;
-
-	at91_aic_caps |= AT91_AIC_CAP_AIC5;
-	n_irqs = NR_AIC5_IRQS;
-	at91_aic_chip.irq_ack           = at91_aic5_mask_irq;
-	at91_aic_chip.irq_mask		= at91_aic5_mask_irq;
-	at91_aic_chip.irq_unmask	= at91_aic5_unmask_irq;
-	at91_aic_chip.irq_eoi		= at91_aic5_eoi;
-	at91_aic_irq_ops.map		= at91_aic5_irq_map;
-
-	err = at91_aic_of_common_init(node, parent);
-	if (err)
-		return err;
-
-	at91_aic5_hw_init(n_irqs);
-
-	return 0;
-}
-#endif
-
 /*
  * Initialize the AIC interrupt controller.
  */
-- 
1.7.9.5

