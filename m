Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753679Ab3LRJKy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 04:10:54 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:43695 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751588Ab3LRJKu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 04:10:50 -0500
From: Grygorii Strashko <grygorii.strashko@ti.com>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Linus Walleij <linus.walleij@linaro.org>, Sekhar Nori <nsekhar@ti.com>,
        Alexandre Courbot <gnurou@gmail.com>
CC: Rob Herring <rob.herring@calxeda.com>, <prabhakar.csengg@gmail.com>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-gpio@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH v2 1/2] gpio: davinci: don't create irq_domain in case of unbanked irqs
Date: Wed, 18 Dec 2013 12:07:51 +0200
Message-ID: <1387361272-20861-2-git-send-email-grygorii.strashko@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1387361272-20861-1-git-send-email-grygorii.strashko@ti.com>
References: <1387361272-20861-1-git-send-email-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The system may crash if:
- there are more then 1 bank
- unbanked irqs are enabled
- someone will call gpio_to_irq() for GPIO from bank2 or above

Hence, fix it by not creating irq_domain if unbanked irqs are enabled
and correct gpio_to_irq_banked() to handle this properly.

Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Alexandre Courbot <gnurou@gmail.com>
Cc: Sekhar Nori <nsekhar@ti.com>

Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 drivers/gpio/gpio-davinci.c |   34 +++++++++++++++++++---------------
 1 file changed, 19 insertions(+), 15 deletions(-)

diff --git a/drivers/gpio/gpio-davinci.c b/drivers/gpio/gpio-davinci.c
index 5d163c0..1b33806 100644
--- a/drivers/gpio/gpio-davinci.c
+++ b/drivers/gpio/gpio-davinci.c
@@ -351,7 +351,10 @@ static int gpio_to_irq_banked(struct gpio_chip *chip, unsigned offset)
 {
 	struct davinci_gpio_controller *d = chip2controller(chip);
 
-	return irq_create_mapping(d->irq_domain, d->chip.base + offset);
+	if (d->irq_domain)
+		return irq_create_mapping(d->irq_domain, d->chip.base + offset);
+	else
+		return -ENXIO;
 }
 
 static int gpio_to_irq_unbanked(struct gpio_chip *chip, unsigned offset)
@@ -429,7 +432,7 @@ static int davinci_gpio_irq_setup(struct platform_device *pdev)
 	struct davinci_gpio_controller *chips = platform_get_drvdata(pdev);
 	struct davinci_gpio_platform_data *pdata = dev->platform_data;
 	struct davinci_gpio_regs __iomem *g;
-	struct irq_domain	*irq_domain;
+	struct irq_domain	*irq_domain = NULL;
 
 	ngpio = pdata->ngpio;
 	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
@@ -453,18 +456,20 @@ static int davinci_gpio_irq_setup(struct platform_device *pdev)
 	}
 	clk_prepare_enable(clk);
 
-	irq = irq_alloc_descs(-1, 0, ngpio, 0);
-	if (irq < 0) {
-		dev_err(dev, "Couldn't allocate IRQ numbers\n");
-		return irq;
-	}
+	if (!pdata->gpio_unbanked) {
+		irq = irq_alloc_descs(-1, 0, ngpio, 0);
+		if (irq < 0) {
+			dev_err(dev, "Couldn't allocate IRQ numbers\n");
+			return -ENODEV;
+		}
 
-	irq_domain = irq_domain_add_legacy(NULL, ngpio, irq, 0,
-						&davinci_gpio_irq_ops,
-						chips);
-	if (!irq_domain) {
-		dev_err(dev, "Couldn't register an IRQ domain\n");
-		return -ENODEV;
+		irq_domain = irq_domain_add_legacy(NULL, ngpio, irq, 0,
+							&davinci_gpio_irq_ops,
+							chips);
+		if (!irq_domain) {
+			dev_err(dev, "Couldn't register an IRQ domain\n");
+			return -ENODEV;
+		}
 	}
 
 	/*
@@ -475,8 +480,7 @@ static int davinci_gpio_irq_setup(struct platform_device *pdev)
 	 */
 	for (gpio = 0, bank = 0; gpio < ngpio; bank++, gpio += 32) {
 		chips[bank].chip.to_irq = gpio_to_irq_banked;
-		if (!pdata->gpio_unbanked)
-			chips[bank].irq_domain = irq_domain;
+		chips[bank].irq_domain = irq_domain;
 	}
 
 	/*
-- 
1.7.9.5

