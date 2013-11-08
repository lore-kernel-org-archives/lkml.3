Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757260Ab3KHKMm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 05:12:42 -0500
Received: from mail-pd0-f181.google.com ([209.85.192.181]:44970 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757203Ab3KHKMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 05:12:33 -0500
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
Subject: [PATCH v5 3/7] gpio: davinci: use irqdomain
Date: Fri,  8 Nov 2013 15:41:46 +0530
Message-Id: <1383905510-31760-4-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1383905510-31760-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1383905510-31760-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

This patch converts the davinci gpio driver to use irqdomain
support.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/gpio/gpio-davinci.c                |   74 +++++++++++++++-------------
 include/linux/platform_data/gpio-davinci.h |    2 +-
 2 files changed, 41 insertions(+), 35 deletions(-)

diff --git a/drivers/gpio/gpio-davinci.c b/drivers/gpio/gpio-davinci.c
index ca3d7fd..b149239 100644
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
@@ -292,17 +292,11 @@ gpio_irq_handler(unsigned irq, struct irq_desc *desc)
 		writel(status, &g->intstat);
 
 		/* now demux them to the right lowlevel handler */
-		n = d->irq_base;
-		if (irq & 1) {
-			n += 16;
-			status >>= 16;
-		}
-
 		while (status) {
-			res = ffs(status);
-			n += res;
-			generic_handle_irq(n - 1);
-			status >>= res;
+			bit = __ffs(status);
+			status &= ~(1 << bit);
+			generic_handle_irq(irq_find_mapping(d->irq_domain,
+							    bit));
 		}
 	}
 	desc->irq_data.chip->irq_unmask(&desc->irq_data);
@@ -313,10 +307,7 @@ static int gpio_to_irq_banked(struct gpio_chip *chip, unsigned offset)
 {
 	struct davinci_gpio_controller *d = chip2controller(chip);
 
-	if (d->irq_base >= 0)
-		return d->irq_base + offset;
-	else
-		return -ENODEV;
+	return irq_create_mapping(d->irq_domain, offset);
 }
 
 static int gpio_to_irq_unbanked(struct gpio_chip *chip, unsigned offset)
@@ -354,6 +345,28 @@ static int gpio_irq_type_unbanked(struct irq_data *data, unsigned trigger)
 	return 0;
 }
 
+static int davinci_gpio_irq_map(struct irq_domain *d, unsigned int irq,
+				irq_hw_number_t hw)
+{
+	struct davinci_gpio_controller *chip = d->host_data;
+	unsigned gpio = chip->chip.base + hw;
+	struct davinci_gpio_regs __iomem *g = gpio2regs(gpio);
+
+	irq_set_chip_and_handler_name(irq, &gpio_irqchip, handle_simple_irq,
+				"davinci_gpio");
+	irq_set_irq_type(irq, IRQ_TYPE_NONE);
+	irq_set_chip_data(irq, (__force void *)g);
+	irq_set_handler_data(irq, (void *)__gpio_mask(gpio));
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
@@ -402,9 +415,16 @@ static int davinci_gpio_irq_setup(struct platform_device *pdev)
 	 */
 	for (gpio = 0, bank = 0; gpio < ngpio; bank++, gpio += 32) {
 		chips[bank].chip.to_irq = gpio_to_irq_banked;
-		chips[bank].irq_base = pdata->gpio_unbanked
-			? -EINVAL
-			: (pdata->intc_irq_num + gpio);
+		if (!pdata->gpio_unbanked) {
+			chips[bank].irq_domain =
+				irq_domain_add_linear(NULL,
+						      chips[bank].chip.ngpio,
+						      &davinci_gpio_irq_ops,
+						      &chips[bank]);
+
+			if (!chips[bank].irq_domain)
+				return -ENOMEM;
+		}
 	}
 
 	/*
@@ -447,11 +467,7 @@ static int davinci_gpio_irq_setup(struct platform_device *pdev)
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
@@ -467,14 +483,6 @@ static int davinci_gpio_irq_setup(struct platform_device *pdev)
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
 
@@ -485,8 +493,6 @@ done:
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

