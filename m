Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935036Ab3E2CLY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 22:11:24 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:54446 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935004Ab3E2CLF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 22:11:05 -0400
From: Grant Likely <grant.likely@linaro.org>
To: linux-kernel@vger.kernel.org, tglx@linutronix.de
Cc: Grant Likely <grant.likely@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 3/3] irqchip: Make versatile fpga irq driver a generic chip
Date: Wed, 29 May 2013 03:10:54 +0100
Message-Id: <1369793454-19197-4-git-send-email-grant.likely@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369793454-19197-1-git-send-email-grant.likely@linaro.org>
References: <1369793454-19197-1-git-send-email-grant.likely@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an RFC patch to convert the versatile FPGA irq controller driver
to use generic irq chip. It builds on the series that extends the
generic chip code to allow a linear irq domain to contain one or more
generic irq chips so that each interrupt controller doesn't need to hand
code the generic chip setup.

I've written this as a proof of concept to see if the new generic irq
code does what it needs to. I had to extend it slightly to properly
handle the valid mask used by the versatile FPGA driver.

Tested on QEMU, but not on real hardware.

Signed-off-by: Grant Likely <grant.likely@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/irqchip/Kconfig              |   1 +
 drivers/irqchip/irq-versatile-fpga.c | 104 +++++++++++++----------------------
 2 files changed, 39 insertions(+), 66 deletions(-)

diff --git a/drivers/irqchip/Kconfig b/drivers/irqchip/Kconfig
index 4a33351..8765502 100644
--- a/drivers/irqchip/Kconfig
+++ b/drivers/irqchip/Kconfig
@@ -14,6 +14,7 @@ config ARM_VIC
 	bool
 	select IRQ_DOMAIN
 	select MULTI_IRQ_HANDLER
+	select GENERIC_IRQ_CHIP
 
 config ARM_VIC_NR
 	int
diff --git a/drivers/irqchip/irq-versatile-fpga.c b/drivers/irqchip/irq-versatile-fpga.c
index 065b7a3..8c7097b 100644
--- a/drivers/irqchip/irq-versatile-fpga.c
+++ b/drivers/irqchip/irq-versatile-fpga.c
@@ -34,37 +34,18 @@
  * @used_irqs: number of active IRQs on this controller
  */
 struct fpga_irq_data {
-	void __iomem *base;
-	struct irq_chip chip;
-	u32 valid;
 	struct irq_domain *domain;
-	u8 used_irqs;
 };
 
 /* we cannot allocate memory when the controllers are initially registered */
 static struct fpga_irq_data fpga_irq_devices[CONFIG_VERSATILE_FPGA_IRQ_NR];
 static int fpga_irq_id;
 
-static void fpga_irq_mask(struct irq_data *d)
-{
-	struct fpga_irq_data *f = irq_data_get_irq_chip_data(d);
-	u32 mask = 1 << d->hwirq;
-
-	writel(mask, f->base + IRQ_ENABLE_CLEAR);
-}
-
-static void fpga_irq_unmask(struct irq_data *d)
-{
-	struct fpga_irq_data *f = irq_data_get_irq_chip_data(d);
-	u32 mask = 1 << d->hwirq;
-
-	writel(mask, f->base + IRQ_ENABLE_SET);
-}
-
 static void fpga_irq_handle(unsigned int irq, struct irq_desc *desc)
 {
-	struct fpga_irq_data *f = irq_desc_get_handler_data(desc);
-	u32 status = readl(f->base + IRQ_STATUS);
+	struct irq_domain *domain = irq_desc_get_handler_data(desc);
+	struct irq_chip_generic *gc = irq_get_domain_generic_chip(domain, 0);
+	u32 status = readl(gc->reg_base + IRQ_STATUS);
 
 	if (status == 0) {
 		do_bad_IRQ(irq, desc);
@@ -74,7 +55,7 @@ static void fpga_irq_handle(unsigned int irq, struct irq_desc *desc)
 	do {
 		irq = ffs(status) - 1;
 		status &= ~(1 << irq);
-		generic_handle_irq(irq_find_mapping(f->domain, irq));
+		generic_handle_irq(irq_find_mapping(domain, irq));
 	} while (status);
 }
 
@@ -85,11 +66,12 @@ static void fpga_irq_handle(unsigned int irq, struct irq_desc *desc)
  */
 static int handle_one_fpga(struct fpga_irq_data *f, struct pt_regs *regs)
 {
+	struct irq_chip_generic *gc = irq_get_domain_generic_chip(f->domain, 0);
 	int handled = 0;
 	int irq;
 	u32 status;
 
-	while ((status  = readl(f->base + IRQ_STATUS))) {
+	while ((status = readl(gc->reg_base + IRQ_STATUS))) {
 		irq = ffs(status) - 1;
 		handle_IRQ(irq_find_mapping(f->domain, irq), regs);
 		handled = 1;
@@ -112,63 +94,53 @@ asmlinkage void __exception_irq_entry fpga_handle_irq(struct pt_regs *regs)
 	} while (handled);
 }
 
-static int fpga_irqdomain_map(struct irq_domain *d, unsigned int irq,
-		irq_hw_number_t hwirq)
-{
-	struct fpga_irq_data *f = d->host_data;
-
-	/* Skip invalid IRQs, only register handlers for the real ones */
-	if (!(f->valid & BIT(hwirq)))
-		return -ENOTSUPP;
-	irq_set_chip_data(irq, f);
-	irq_set_chip_and_handler(irq, &f->chip,
-				handle_level_irq);
-	set_irq_flags(irq, IRQF_VALID | IRQF_PROBE);
-	return 0;
-}
-
-static struct irq_domain_ops fpga_irqdomain_ops = {
-	.map = fpga_irqdomain_map,
-	.xlate = irq_domain_xlate_onetwocell,
-};
-
 void __init fpga_irq_init(void __iomem *base, const char *name, int irq_start,
 			  int parent_irq, u32 valid, struct device_node *node)
 {
+	struct irq_chip_generic *gc;
 	struct fpga_irq_data *f;
-	int i;
+	int ret;
 
 	if (fpga_irq_id >= ARRAY_SIZE(fpga_irq_devices)) {
 		pr_err("%s: too few FPGA IRQ controllers, increase CONFIG_VERSATILE_FPGA_IRQ_NR\n", __func__);
 		return;
 	}
 	f = &fpga_irq_devices[fpga_irq_id];
-	f->base = base;
-	f->chip.name = name;
-	f->chip.irq_ack = fpga_irq_mask;
-	f->chip.irq_mask = fpga_irq_mask;
-	f->chip.irq_unmask = fpga_irq_unmask;
-	f->valid = valid;
+
+	/* This will also allocate irq descriptors */
+	f->domain = irq_domain_add_linear(node, fls(valid),
+					  &irq_generic_chip_ops, f);
+	if (!f->domain) {
+		pr_err("FPGA IRQ setup failed allocation domain\n");
+		return;
+	}
+
+	ret = irq_alloc_domain_generic_chips(f->domain, fls(valid), 1,
+			name, handle_level_irq,
+			IRQ_NOREQUEST | IRQ_NOPROBE | IRQ_NOAUTOEN, 0, 0);
+	if (ret) {
+		pr_err("FPGA IRQ setup failed allocating generic chip\n");
+		return;
+	}
+
+	gc = irq_get_domain_generic_chip(f->domain, 0);
+	gc->reg_base = base;
+	gc->unused = ~valid;
+	gc->chip_types[0].regs.enable = IRQ_ENABLE_SET;
+	gc->chip_types[0].regs.disable = IRQ_ENABLE_CLEAR;
+	gc->chip_types[0].chip.irq_ack = irq_gc_mask_disable_reg;
+	gc->chip_types[0].chip.irq_mask = irq_gc_mask_disable_reg;
+	gc->chip_types[0].chip.irq_unmask = irq_gc_unmask_enable_reg;
 
 	if (parent_irq != -1) {
-		irq_set_handler_data(parent_irq, f);
+		irq_set_handler_data(parent_irq, f->domain);
 		irq_set_chained_handler(parent_irq, fpga_irq_handle);
 	}
 
-	/* This will also allocate irq descriptors */
-	f->domain = irq_domain_add_simple(node, fls(valid), irq_start,
-					  &fpga_irqdomain_ops, f);
-
-	/* This will allocate all valid descriptors in the linear case */
-	for (i = 0; i < fls(valid); i++)
-		if (valid & BIT(i)) {
-			if (!irq_start)
-				irq_create_mapping(f->domain, i);
-			f->used_irqs++;
-		}
-
-	pr_info("FPGA IRQ chip %d \"%s\" @ %p, %u irqs\n",
-		fpga_irq_id, name, base, f->used_irqs);
+	if (irq_start)
+		irq_domain_associate_many(f->domain, irq_start, 0, fls(valid));
+
+	pr_info("FPGA IRQ chip %d \"%s\" @ %p\n", fpga_irq_id, name, base);
 
 	fpga_irq_id++;
 }
-- 
1.8.1.2

