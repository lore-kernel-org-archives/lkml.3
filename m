Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755200Ab3KUSQJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 13:16:09 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:54034 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755096Ab3KUSQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 13:16:04 -0500
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: Sekhar Nori <nsekhar@ti.com>, Linus Walleij <linus.walleij@linaro.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LAK <linux-arm-kernel@lists.infradead.org>, linux-gpio@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        Prabhakar Lad <prabhakar.csengg@gmail.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Grant Likely <grant.likely@linaro.org>
Subject: [PATCH v6 2/6] This patch converts the davinci gpio driver to use irqdomain support.
Date: Thu, 21 Nov 2013 23:45:27 +0530
Message-Id: <1385057731-4348-3-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1385057731-4348-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1385057731-4348-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
[grygorii.strashko@ti.com:
 - switch to use one irq-domain per  all GPIO banks
 - keep irq_create_mapping() call in gpio_to_irq_banked() as it
   simply transformed to irq_find_mapping() if IRQ mapping exist
   already]
Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 drivers/gpio/gpio-davinci.c                |   80 ++++++++++++++++------------
 include/linux/platform_data/gpio-davinci.h |    2 +-
 2 files changed, 48 insertions(+), 34 deletions(-)

diff --git a/drivers/gpio/gpio-davinci.c b/drivers/gpio/gpio-davinci.c
index 1f33fcd..4d6adbc 100644
--- a/drivers/gpio/gpio-davinci.c
+++ b/drivers/gpio/gpio-davinci.c
@@ -16,6 +16,7 @@
 #include <linux/err.h>
 #include <linux/io.h>
 #include <linux/irq.h>
+#include <linux/irqdomain.h>
 #include <linux/platform_device.h>
 #include <linux/platform_data/gpio-davinci.h>
 
@@ -282,8 +283,7 @@ gpio_irq_handler(unsigned irq, struct irq_desc *desc)
 	desc->irq_data.chip->irq_ack(&desc->irq_data);
 	while (1) {
 		u32		status;
-		int		n;
-		int		res;
+		int		bit;
 
 		/* ack any irqs */
 		status = readl(&g->intstat) & mask;
@@ -292,17 +292,13 @@ gpio_irq_handler(unsigned irq, struct irq_desc *desc)
 		writel(status, &g->intstat);
 
 		/* now demux them to the right lowlevel handler */
-		n = d->irq_base;
-		if (irq & 1) {
-			n += 16;
-			status >>= 16;
-		}
 
 		while (status) {
-			res = ffs(status);
-			n += res;
-			generic_handle_irq(n - 1);
-			status >>= res;
+			bit = __ffs(status);
+			status &= ~BIT(bit);
+			generic_handle_irq(
+				irq_find_mapping(d->irq_domain,
+						 d->chip.base + bit));
 		}
 	}
 	desc->irq_data.chip->irq_unmask(&desc->irq_data);
@@ -313,10 +309,7 @@ static int gpio_to_irq_banked(struct gpio_chip *chip, unsigned offset)
 {
 	struct davinci_gpio_controller *d = chip2controller(chip);
 
-	if (d->irq_base >= 0)
-		return d->irq_base + offset;
-	else
-		return -ENODEV;
+	return irq_create_mapping(d->irq_domain, d->chip.base + offset);
 }
 
 static int gpio_to_irq_unbanked(struct gpio_chip *chip, unsigned offset)
@@ -354,6 +347,27 @@ static int gpio_irq_type_unbanked(struct irq_data *data, unsigned trigger)
 	return 0;
 }
 
+static int
+davinci_gpio_irq_map(struct irq_domain *d, unsigned int irq,
+		     irq_hw_number_t hw)
+{
+	struct davinci_gpio_regs __iomem *g = gpio2regs(hw);
+
+	irq_set_chip_and_handler_name(irq, &gpio_irqchip, handle_simple_irq,
+				"davinci_gpio");
+	irq_set_irq_type(irq, IRQ_TYPE_NONE);
+	irq_set_chip_data(irq, (__force void *)g);
+	irq_set_handler_data(irq, (void *)__gpio_mask(hw));
+	set_irq_flags(irq, IRQF_VALID);
+
+	return 0;
+}
+
+static const struct irq_domain_ops davinci_gpio_irq_ops = {
+	.map = davinci_gpio_irq_map,
+	.xlate = irq_domain_xlate_onetwocell,
+};
+
 /*
  * NOTE:  for suspend/resume, probably best to make a platform_device with
  * suspend_late/resume_resume calls hooking into results of the set_wake()
@@ -373,6 +387,7 @@ static int davinci_gpio_irq_setup(struct platform_device *pdev)
 	struct davinci_gpio_controller *chips = platform_get_drvdata(pdev);
 	struct davinci_gpio_platform_data *pdata = dev->platform_data;
 	struct davinci_gpio_regs __iomem *g;
+	struct irq_domain	*irq_domain;
 
 	ngpio = pdata->ngpio;
 	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
@@ -396,6 +411,20 @@ static int davinci_gpio_irq_setup(struct platform_device *pdev)
 	}
 	clk_prepare_enable(clk);
 
+	irq = irq_alloc_descs(-1, 0, ngpio, 0);
+	if (irq < 0) {
+		dev_err(dev, "Couldn't allocate IRQ numbers\n");
+		return -ENODEV;
+	}
+
+	irq_domain = irq_domain_add_legacy(NULL, ngpio, irq, 0,
+						&davinci_gpio_irq_ops,
+						chips);
+	if (!irq_domain) {
+		dev_err(dev, "Couldn't register an IRQ domain\n");
+		return -ENODEV;
+	}
+
 	/*
 	 * Arrange gpio_to_irq() support, handling either direct IRQs or
 	 * banked IRQs.  Having GPIOs in the first GPIO bank use direct
@@ -404,9 +433,8 @@ static int davinci_gpio_irq_setup(struct platform_device *pdev)
 	 */
 	for (gpio = 0, bank = 0; gpio < ngpio; bank++, gpio += 32) {
 		chips[bank].chip.to_irq = gpio_to_irq_banked;
-		chips[bank].irq_base = pdata->gpio_unbanked
-			? -EINVAL
-			: (pdata->intc_irq_num + gpio);
+		if (!pdata->gpio_unbanked)
+			chips[bank].irq_domain = irq_domain;
 	}
 
 	/*
@@ -449,11 +477,7 @@ static int davinci_gpio_irq_setup(struct platform_device *pdev)
 	 * Or, AINTC can handle IRQs for banks of 16 GPIO IRQs, which we
 	 * then chain through our own handler.
 	 */
-	for (gpio = 0, irq = gpio_to_irq(0), bank = 0;
-			gpio < ngpio;
-			bank++, bank_irq++) {
-		unsigned		i;
-
+	for (gpio = 0, bank = 0; gpio < ngpio; bank++, bank_irq++, gpio += 16) {
 		/* disabled by default, enabled only as needed */
 		g = gpio2regs(gpio);
 		writel(~0, &g->clr_falling);
@@ -469,14 +493,6 @@ static int davinci_gpio_irq_setup(struct platform_device *pdev)
 		 */
 		irq_set_handler_data(bank_irq, &chips[gpio / 32]);
 
-		for (i = 0; i < 16 && gpio < ngpio; i++, irq++, gpio++) {
-			irq_set_chip(irq, &gpio_irqchip);
-			irq_set_chip_data(irq, (__force void *)g);
-			irq_set_handler_data(irq, (void *)__gpio_mask(gpio));
-			irq_set_handler(irq, handle_simple_irq);
-			set_irq_flags(irq, IRQF_VALID);
-		}
-
 		binten |= BIT(bank);
 	}
 
@@ -487,8 +503,6 @@ done:
 	 */
 	writel(binten, gpio_base + BINTEN);
 
-	printk(KERN_INFO "DaVinci: %d gpio irqs\n", irq - gpio_to_irq(0));
-
 	return 0;
 }
 
diff --git a/include/linux/platform_data/gpio-davinci.h b/include/linux/platform_data/gpio-davinci.h
index 6efd202..0c3551b 100644
--- a/include/linux/platform_data/gpio-davinci.h
+++ b/include/linux/platform_data/gpio-davinci.h
@@ -34,7 +34,7 @@ struct davinci_gpio_platform_data {
 
 struct davinci_gpio_controller {
 	struct gpio_chip	chip;
-	int			irq_base;
+	struct irq_domain	*irq_domain;
 	/* Serialize access to GPIO registers */
 	spinlock_t		lock;
 	void __iomem		*regs;
-- 
1.7.9.5

