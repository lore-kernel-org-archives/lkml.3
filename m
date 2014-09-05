Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752023AbaIETxN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 15:53:13 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:50061 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750906AbaIETxJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 15:53:09 -0400
From: Nishanth Menon <nm@ti.com>
To: Alexandre Courbot <gnurou@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Javier Martinez Canillas <javier@dowhile0.org>
CC: <linux-kernel@vger.kernel.org>, <linux-gpio@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, Nishanth Menon <nm@ti.com>
Subject: [RESEND PATCH] gpio: omap: Fix interrupt names
Date: Fri, 5 Sep 2014 14:52:55 -0500
Message-ID: <1409946775-24076-1-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When viewing the /proc/interrupts, there is no information about which
GPIO bank a specific gpio interrupt is hooked on to. This is more than a
bit irritating as such information can esily be provided back to the
user and at times, can be crucial for debug.

So, instead of displaying something like:
31:	0	0  GPIO   0  palmas
32:	0	0  GPIO  27  mmc0

Display the following with appropriate device name:
31:	0	0  4ae10000.gpio   0  palmas
32:	0	0  4805d000.gpio  27  mmc0

This requires that we create irq_chip instance specific for each GPIO
bank which is trivial to achieve.

Signed-off-by: Nishanth Menon <nm@ti.com>
Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Acked-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Acked-by: Kevin Hilman <khilman@linaro.org>
---
Requested to be resend by Javier with linux-gpio maintainers in CC.

Original V1 of the patch: https://patchwork.kernel.org/patch/4757891/

Probably belongs to 3.18 kernel series at this point in time.

Changes since v1: just picked up Acks.

V1: https://patchwork.kernel.org/patch/4757891/

based on v3.17-rc1

 drivers/gpio/gpio-omap.c |   31 +++++++++++++++++--------------
 1 file changed, 17 insertions(+), 14 deletions(-)

diff --git a/drivers/gpio/gpio-omap.c b/drivers/gpio/gpio-omap.c
index 1749321..aee25fa 100644
--- a/drivers/gpio/gpio-omap.c
+++ b/drivers/gpio/gpio-omap.c
@@ -857,16 +857,6 @@ static void omap_gpio_unmask_irq(struct irq_data *d)
 	spin_unlock_irqrestore(&bank->lock, flags);
 }
 
-static struct irq_chip gpio_irq_chip = {
-	.name		= "GPIO",
-	.irq_shutdown	= omap_gpio_irq_shutdown,
-	.irq_ack	= omap_gpio_ack_irq,
-	.irq_mask	= omap_gpio_mask_irq,
-	.irq_unmask	= omap_gpio_unmask_irq,
-	.irq_set_type	= omap_gpio_irq_type,
-	.irq_set_wake	= omap_gpio_wake_enable,
-};
-
 /*---------------------------------------------------------------------*/
 
 static int omap_mpuio_suspend_noirq(struct device *dev)
@@ -1088,7 +1078,7 @@ omap_mpuio_alloc_gc(struct gpio_bank *bank, unsigned int irq_start,
 			       IRQ_NOREQUEST | IRQ_NOPROBE, 0);
 }
 
-static int omap_gpio_chip_init(struct gpio_bank *bank)
+static int omap_gpio_chip_init(struct gpio_bank *bank, struct irq_chip *irqc)
 {
 	int j;
 	static int gpio;
@@ -1137,7 +1127,7 @@ static int omap_gpio_chip_init(struct gpio_bank *bank)
 	}
 #endif
 
-	ret = gpiochip_irqchip_add(&bank->chip, &gpio_irq_chip,
+	ret = gpiochip_irqchip_add(&bank->chip, irqc,
 				   irq_base, omap_gpio_irq_handler,
 				   IRQ_TYPE_NONE);
 
@@ -1147,7 +1137,7 @@ static int omap_gpio_chip_init(struct gpio_bank *bank)
 		return -ENODEV;
 	}
 
-	gpiochip_set_chained_irqchip(&bank->chip, &gpio_irq_chip,
+	gpiochip_set_chained_irqchip(&bank->chip, irqc,
 				     bank->irq, omap_gpio_irq_handler);
 
 	for (j = 0; j < bank->width; j++) {
@@ -1172,6 +1162,7 @@ static int omap_gpio_probe(struct platform_device *pdev)
 	const struct omap_gpio_platform_data *pdata;
 	struct resource *res;
 	struct gpio_bank *bank;
+	struct irq_chip *irqc;
 	int ret;
 
 	match = of_match_device(of_match_ptr(omap_gpio_match), dev);
@@ -1186,6 +1177,18 @@ static int omap_gpio_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 
+	irqc = devm_kzalloc(dev, sizeof(*irqc), GFP_KERNEL);
+	if (!irqc)
+		return -ENOMEM;
+
+	irqc->irq_shutdown = omap_gpio_irq_shutdown,
+	irqc->irq_ack = omap_gpio_ack_irq,
+	irqc->irq_mask = omap_gpio_mask_irq,
+	irqc->irq_unmask = omap_gpio_unmask_irq,
+	irqc->irq_set_type = omap_gpio_irq_type,
+	irqc->irq_set_wake = omap_gpio_wake_enable,
+	irqc->name = dev_name(&pdev->dev);
+
 	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
 	if (unlikely(!res)) {
 		dev_err(dev, "Invalid IRQ resource\n");
@@ -1241,7 +1244,7 @@ static int omap_gpio_probe(struct platform_device *pdev)
 
 	omap_gpio_mod_init(bank);
 
-	ret = omap_gpio_chip_init(bank);
+	ret = omap_gpio_chip_init(bank, irqc);
 	if (ret)
 		return ret;
 
-- 
1.7.9.5

