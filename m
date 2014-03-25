Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753337AbaCYMwq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 08:52:46 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:39786 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753253AbaCYMwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 08:52:42 -0400
From: Linus Walleij <linus.walleij@linaro.org>
To: linux-gpio@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Cc: Alexandre Courbot <acourbot@nvidia.com>, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 2/4] gpio: pl061: convert driver to use gpiolib irqchip
Date: Tue, 25 Mar 2014 13:51:32 +0100
Message-Id: <1395751894-7110-3-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1395751894-7110-1-git-send-email-linus.walleij@linaro.org>
References: <1395751894-7110-1-git-send-email-linus.walleij@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This converts the PL061 driver to register its chained irq
handler and irqchip using the helpers in the gpiolib core.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/gpio/Kconfig      |  1 +
 drivers/gpio/gpio-pl061.c | 80 +++++++++++------------------------------------
 2 files changed, 19 insertions(+), 62 deletions(-)

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 51c782532687..92d8e9a064b4 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -247,6 +247,7 @@ config GPIO_PL061
 	bool "PrimeCell PL061 GPIO support"
 	depends on ARM_AMBA
 	select IRQ_DOMAIN
+	select GPIOLIB_IRQCHIP
 	help
 	  Say yes here to support the PrimeCell PL061 GPIO device
 
diff --git a/drivers/gpio/gpio-pl061.c b/drivers/gpio/gpio-pl061.c
index d2a0ad5fc752..b0f475243cef 100644
--- a/drivers/gpio/gpio-pl061.c
+++ b/drivers/gpio/gpio-pl061.c
@@ -15,7 +15,6 @@
 #include <linux/io.h>
 #include <linux/ioport.h>
 #include <linux/irq.h>
-#include <linux/irqdomain.h>
 #include <linux/irqchip/chained_irq.h>
 #include <linux/bitops.h>
 #include <linux/workqueue.h>
@@ -53,7 +52,6 @@ struct pl061_gpio {
 	spinlock_t		lock;
 
 	void __iomem		*base;
-	struct irq_domain	*domain;
 	struct gpio_chip	gc;
 
 #ifdef CONFIG_PM
@@ -137,16 +135,10 @@ static void pl061_set_value(struct gpio_chip *gc, unsigned offset, int value)
 	writeb(!!value << offset, chip->base + (1 << (offset + 2)));
 }
 
-static int pl061_to_irq(struct gpio_chip *gc, unsigned offset)
-{
-	struct pl061_gpio *chip = container_of(gc, struct pl061_gpio, gc);
-
-	return irq_create_mapping(chip->domain, offset);
-}
-
 static int pl061_irq_type(struct irq_data *d, unsigned trigger)
 {
-	struct pl061_gpio *chip = irq_data_get_irq_chip_data(d);
+	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
+	struct pl061_gpio *chip = container_of(gc, struct pl061_gpio, gc);
 	int offset = irqd_to_hwirq(d);
 	unsigned long flags;
 	u8 gpiois, gpioibe, gpioiev;
@@ -194,7 +186,8 @@ static void pl061_irq_handler(unsigned irq, struct irq_desc *desc)
 {
 	unsigned long pending;
 	int offset;
-	struct pl061_gpio *chip = irq_desc_get_handler_data(desc);
+	struct gpio_chip *gc = irq_desc_get_handler_data(desc);
+	struct pl061_gpio *chip = container_of(gc, struct pl061_gpio, gc);
 	struct irq_chip *irqchip = irq_desc_get_chip(desc);
 
 	chained_irq_enter(irqchip, desc);
@@ -203,7 +196,8 @@ static void pl061_irq_handler(unsigned irq, struct irq_desc *desc)
 	writeb(pending, chip->base + GPIOIC);
 	if (pending) {
 		for_each_set_bit(offset, &pending, PL061_GPIO_NR)
-			generic_handle_irq(pl061_to_irq(&chip->gc, offset));
+			generic_handle_irq(irq_find_mapping(gc->irqdomain,
+							    offset));
 	}
 
 	chained_irq_exit(irqchip, desc);
@@ -211,7 +205,8 @@ static void pl061_irq_handler(unsigned irq, struct irq_desc *desc)
 
 static void pl061_irq_mask(struct irq_data *d)
 {
-	struct pl061_gpio *chip = irq_data_get_irq_chip_data(d);
+	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
+	struct pl061_gpio *chip = container_of(gc, struct pl061_gpio, gc);
 	u8 mask = 1 << (irqd_to_hwirq(d) % PL061_GPIO_NR);
 	u8 gpioie;
 
@@ -223,7 +218,8 @@ static void pl061_irq_mask(struct irq_data *d)
 
 static void pl061_irq_unmask(struct irq_data *d)
 {
-	struct pl061_gpio *chip = irq_data_get_irq_chip_data(d);
+	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
+	struct pl061_gpio *chip = container_of(gc, struct pl061_gpio, gc);
 	u8 mask = 1 << (irqd_to_hwirq(d) % PL061_GPIO_NR);
 	u8 gpioie;
 
@@ -233,50 +229,11 @@ static void pl061_irq_unmask(struct irq_data *d)
 	spin_unlock(&chip->lock);
 }
 
-static int pl061_irq_reqres(struct irq_data *d)
-{
-	struct pl061_gpio *chip = irq_data_get_irq_chip_data(d);
-
-	if (gpio_lock_as_irq(&chip->gc, irqd_to_hwirq(d))) {
-		dev_err(chip->gc.dev,
-			"unable to lock HW IRQ %lu for IRQ\n",
-			irqd_to_hwirq(d));
-		return -EINVAL;
-	}
-	return 0;
-}
-
-static void pl061_irq_relres(struct irq_data *d)
-{
-	struct pl061_gpio *chip = irq_data_get_irq_chip_data(d);
-
-	gpio_unlock_as_irq(&chip->gc, irqd_to_hwirq(d));
-}
-
 static struct irq_chip pl061_irqchip = {
 	.name		= "pl061",
 	.irq_mask	= pl061_irq_mask,
 	.irq_unmask	= pl061_irq_unmask,
 	.irq_set_type	= pl061_irq_type,
-	.irq_request_resources = pl061_irq_reqres,
-	.irq_release_resources = pl061_irq_relres,
-};
-
-static int pl061_irq_map(struct irq_domain *d, unsigned int irq,
-			 irq_hw_number_t hwirq)
-{
-	struct pl061_gpio *chip = d->host_data;
-
-	irq_set_chip_and_handler(irq, &pl061_irqchip, handle_simple_irq);
-	irq_set_chip_data(irq, chip);
-	irq_set_irq_type(irq, IRQ_TYPE_NONE);
-
-	return 0;
-}
-
-static const struct irq_domain_ops pl061_domain_ops = {
-	.map	= pl061_irq_map,
-	.xlate	= irq_domain_xlate_twocell,
 };
 
 static int pl061_probe(struct amba_device *adev, const struct amba_id *id)
@@ -314,7 +271,6 @@ static int pl061_probe(struct amba_device *adev, const struct amba_id *id)
 	chip->gc.direction_output = pl061_direction_output;
 	chip->gc.get = pl061_get_value;
 	chip->gc.set = pl061_set_value;
-	chip->gc.to_irq = pl061_to_irq;
 	chip->gc.ngpio = PL061_GPIO_NR;
 	chip->gc.label = dev_name(dev);
 	chip->gc.dev = dev;
@@ -334,15 +290,15 @@ static int pl061_probe(struct amba_device *adev, const struct amba_id *id)
 		return -ENODEV;
 	}
 
-	irq_set_chained_handler(irq, pl061_irq_handler);
-	irq_set_handler_data(irq, chip);
-
-	chip->domain = irq_domain_add_simple(adev->dev.of_node, PL061_GPIO_NR,
-					     irq_base, &pl061_domain_ops, chip);
-	if (!chip->domain) {
-		dev_err(&adev->dev, "no irq domain\n");
-		return -ENODEV;
+	ret = gpiochip_irqchip_add(&chip->gc, &pl061_irqchip,
+				   irq_base, handle_simple_irq,
+				   IRQ_TYPE_NONE);
+	if (ret) {
+		dev_info(&adev->dev, "could not add irqchip\n");
+		return ret;
 	}
+	gpiochip_set_chained_irqchip(&chip->gc, &pl061_irqchip,
+				     irq, pl061_irq_handler);
 
 	for (i = 0; i < PL061_GPIO_NR; i++) {
 		if (pdata) {
-- 
1.8.5.3

