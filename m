Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755150Ab3KUSQA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 13:16:00 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:56292 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755083Ab3KUSPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 13:15:55 -0500
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
Subject: [PATCH v6 1/6] gpio: davinci: use readl/writel instead of __raw_*
Date: Thu, 21 Nov 2013 23:45:26 +0530
Message-Id: <1385057731-4348-2-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1385057731-4348-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1385057731-4348-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

This patch replaces the __raw_readl/writel with
readl and writel, Altough the code runs on ARMv5
based SOCs, changing this will help copying the code
for other uses.

Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/gpio/gpio-davinci.c |   36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/gpio/gpio-davinci.c b/drivers/gpio/gpio-davinci.c
index 84be701..1f33fcd 100644
--- a/drivers/gpio/gpio-davinci.c
+++ b/drivers/gpio/gpio-davinci.c
@@ -82,14 +82,14 @@ static inline int __davinci_direction(struct gpio_chip *chip,
 	u32 mask = 1 << offset;
 
 	spin_lock_irqsave(&d->lock, flags);
-	temp = __raw_readl(&g->dir);
+	temp = readl(&g->dir);
 	if (out) {
 		temp &= ~mask;
-		__raw_writel(mask, value ? &g->set_data : &g->clr_data);
+		writel(mask, value ? &g->set_data : &g->clr_data);
 	} else {
 		temp |= mask;
 	}
-	__raw_writel(temp, &g->dir);
+	writel(temp, &g->dir);
 	spin_unlock_irqrestore(&d->lock, flags);
 
 	return 0;
@@ -118,7 +118,7 @@ static int davinci_gpio_get(struct gpio_chip *chip, unsigned offset)
 	struct davinci_gpio_controller *d = chip2controller(chip);
 	struct davinci_gpio_regs __iomem *g = d->regs;
 
-	return (1 << offset) & __raw_readl(&g->in_data);
+	return (1 << offset) & readl(&g->in_data);
 }
 
 /*
@@ -130,7 +130,7 @@ davinci_gpio_set(struct gpio_chip *chip, unsigned offset, int value)
 	struct davinci_gpio_controller *d = chip2controller(chip);
 	struct davinci_gpio_regs __iomem *g = d->regs;
 
-	__raw_writel((1 << offset), value ? &g->set_data : &g->clr_data);
+	writel((1 << offset), value ? &g->set_data : &g->clr_data);
 }
 
 static int davinci_gpio_probe(struct platform_device *pdev)
@@ -227,8 +227,8 @@ static void gpio_irq_disable(struct irq_data *d)
 	struct davinci_gpio_regs __iomem *g = irq2regs(d->irq);
 	u32 mask = (u32) irq_data_get_irq_handler_data(d);
 
-	__raw_writel(mask, &g->clr_falling);
-	__raw_writel(mask, &g->clr_rising);
+	writel(mask, &g->clr_falling);
+	writel(mask, &g->clr_rising);
 }
 
 static void gpio_irq_enable(struct irq_data *d)
@@ -242,9 +242,9 @@ static void gpio_irq_enable(struct irq_data *d)
 		status = IRQ_TYPE_EDGE_FALLING | IRQ_TYPE_EDGE_RISING;
 
 	if (status & IRQ_TYPE_EDGE_FALLING)
-		__raw_writel(mask, &g->set_falling);
+		writel(mask, &g->set_falling);
 	if (status & IRQ_TYPE_EDGE_RISING)
-		__raw_writel(mask, &g->set_rising);
+		writel(mask, &g->set_rising);
 }
 
 static int gpio_irq_type(struct irq_data *d, unsigned trigger)
@@ -286,10 +286,10 @@ gpio_irq_handler(unsigned irq, struct irq_desc *desc)
 		int		res;
 
 		/* ack any irqs */
-		status = __raw_readl(&g->intstat) & mask;
+		status = readl(&g->intstat) & mask;
 		if (!status)
 			break;
-		__raw_writel(status, &g->intstat);
+		writel(status, &g->intstat);
 
 		/* now demux them to the right lowlevel handler */
 		n = d->irq_base;
@@ -346,9 +346,9 @@ static int gpio_irq_type_unbanked(struct irq_data *data, unsigned trigger)
 	if (trigger & ~(IRQ_TYPE_EDGE_FALLING | IRQ_TYPE_EDGE_RISING))
 		return -EINVAL;
 
-	__raw_writel(mask, (trigger & IRQ_TYPE_EDGE_FALLING)
+	writel(mask, (trigger & IRQ_TYPE_EDGE_FALLING)
 		     ? &g->set_falling : &g->clr_falling);
-	__raw_writel(mask, (trigger & IRQ_TYPE_EDGE_RISING)
+	writel(mask, (trigger & IRQ_TYPE_EDGE_RISING)
 		     ? &g->set_rising : &g->clr_rising);
 
 	return 0;
@@ -432,8 +432,8 @@ static int davinci_gpio_irq_setup(struct platform_device *pdev)
 
 		/* default trigger: both edges */
 		g = gpio2regs(0);
-		__raw_writel(~0, &g->set_falling);
-		__raw_writel(~0, &g->set_rising);
+		writel(~0, &g->set_falling);
+		writel(~0, &g->set_rising);
 
 		/* set the direct IRQs up to use that irqchip */
 		for (gpio = 0; gpio < pdata->gpio_unbanked; gpio++, irq++) {
@@ -456,8 +456,8 @@ static int davinci_gpio_irq_setup(struct platform_device *pdev)
 
 		/* disabled by default, enabled only as needed */
 		g = gpio2regs(gpio);
-		__raw_writel(~0, &g->clr_falling);
-		__raw_writel(~0, &g->clr_rising);
+		writel(~0, &g->clr_falling);
+		writel(~0, &g->clr_rising);
 
 		/* set up all irqs in this bank */
 		irq_set_chained_handler(bank_irq, gpio_irq_handler);
@@ -485,7 +485,7 @@ done:
 	 * BINTEN -- per-bank interrupt enable. genirq would also let these
 	 * bits be set/cleared dynamically.
 	 */
-	__raw_writel(binten, gpio_base + BINTEN);
+	writel(binten, gpio_base + BINTEN);
 
 	printk(KERN_INFO "DaVinci: %d gpio irqs\n", irq - gpio_to_irq(0));
 
-- 
1.7.9.5

