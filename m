Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759759AbaGYGzq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 02:55:46 -0400
Received: from mga11.intel.com ([192.55.52.93]:15437 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759258AbaGYGzF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 02:55:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,729,1400050800"; 
   d="scan'208";a="575251927"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Alexandre Courbot <gnurou@gmail.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Zhu Lejun <lejun.zhu@linux.intel.com>, Yang Bin <bin.yang@intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] gpio: lynxpoint: Convert to use gpiolib irqchip
Date: Fri, 25 Jul 2014 09:54:46 +0300
Message-Id: <1406271288-15995-2-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <1406271288-15995-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1406271288-15995-1-git-send-email-mika.westerberg@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of open-coding irqchip handling in the driver we can take advantage
of the new irqchip helpers provided by the gpiolib core.

While doing this we also make sure that we call gpiochip_irqchip_add()
after the gpiochip itself is registered as required.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/gpio/Kconfig          |  2 +-
 drivers/gpio/gpio-lynxpoint.c | 93 ++++++++++++-------------------------------
 2 files changed, 26 insertions(+), 69 deletions(-)

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 4a1b5113e527..e70297c20487 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -423,7 +423,7 @@ config GPIO_GE_FPGA
 config GPIO_LYNXPOINT
 	tristate "Intel Lynxpoint GPIO support"
 	depends on ACPI && X86
-	select IRQ_DOMAIN
+	select GPIOLIB_IRQCHIP
 	help
 	  driver for GPIO functionality on Intel Lynxpoint PCH chipset
 	  Requires ACPI device enumeration code to set up a platform device.
diff --git a/drivers/gpio/gpio-lynxpoint.c b/drivers/gpio/gpio-lynxpoint.c
index 2bea89b72508..7e3305ae8ec6 100644
--- a/drivers/gpio/gpio-lynxpoint.c
+++ b/drivers/gpio/gpio-lynxpoint.c
@@ -25,9 +25,7 @@
 #include <linux/types.h>
 #include <linux/bitops.h>
 #include <linux/interrupt.h>
-#include <linux/irq.h>
 #include <linux/gpio.h>
-#include <linux/irqdomain.h>
 #include <linux/slab.h>
 #include <linux/acpi.h>
 #include <linux/platform_device.h>
@@ -62,7 +60,6 @@
 
 struct lp_gpio {
 	struct gpio_chip	chip;
-	struct irq_domain	*domain;
 	struct platform_device	*pdev;
 	spinlock_t		lock;
 	unsigned long		reg_base;
@@ -151,7 +148,8 @@ static void lp_gpio_free(struct gpio_chip *chip, unsigned offset)
 
 static int lp_irq_type(struct irq_data *d, unsigned type)
 {
-	struct lp_gpio *lg = irq_data_get_irq_chip_data(d);
+	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
+	struct lp_gpio *lg = container_of(gc, struct lp_gpio, chip);
 	u32 hwirq = irqd_to_hwirq(d);
 	unsigned long flags;
 	u32 value;
@@ -236,16 +234,11 @@ static int lp_gpio_direction_output(struct gpio_chip *chip,
 	return 0;
 }
 
-static int lp_gpio_to_irq(struct gpio_chip *chip, unsigned offset)
-{
-	struct lp_gpio *lg = container_of(chip, struct lp_gpio, chip);
-	return irq_create_mapping(lg->domain, offset);
-}
-
 static void lp_gpio_irq_handler(unsigned hwirq, struct irq_desc *desc)
 {
 	struct irq_data *data = irq_desc_get_irq_data(desc);
-	struct lp_gpio *lg = irq_data_get_irq_handler_data(data);
+	struct gpio_chip *gc = irq_desc_get_handler_data(desc);
+	struct lp_gpio *lg = container_of(gc, struct lp_gpio, chip);
 	struct irq_chip *chip = irq_data_get_irq_chip(data);
 	u32 base, pin, mask;
 	unsigned long reg, ena, pending;
@@ -262,7 +255,7 @@ static void lp_gpio_irq_handler(unsigned hwirq, struct irq_desc *desc)
 			mask = BIT(pin);
 			/* Clear before handling so we don't lose an edge */
 			outl(mask, reg);
-			irq = irq_find_mapping(lg->domain, base + pin);
+			irq = irq_find_mapping(lg->chip.irqdomain, base + pin);
 			generic_handle_irq(irq);
 		}
 	}
@@ -279,7 +272,8 @@ static void lp_irq_mask(struct irq_data *d)
 
 static void lp_irq_enable(struct irq_data *d)
 {
-	struct lp_gpio *lg = irq_data_get_irq_chip_data(d);
+	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
+	struct lp_gpio *lg = container_of(gc, struct lp_gpio, chip);
 	u32 hwirq = irqd_to_hwirq(d);
 	unsigned long reg = lp_gpio_reg(&lg->chip, hwirq, LP_INT_ENABLE);
 	unsigned long flags;
@@ -291,7 +285,8 @@ static void lp_irq_enable(struct irq_data *d)
 
 static void lp_irq_disable(struct irq_data *d)
 {
-	struct lp_gpio *lg = irq_data_get_irq_chip_data(d);
+	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
+	struct lp_gpio *lg = container_of(gc, struct lp_gpio, chip);
 	u32 hwirq = irqd_to_hwirq(d);
 	unsigned long reg = lp_gpio_reg(&lg->chip, hwirq, LP_INT_ENABLE);
 	unsigned long flags;
@@ -301,26 +296,6 @@ static void lp_irq_disable(struct irq_data *d)
 	spin_unlock_irqrestore(&lg->lock, flags);
 }
 
-static int lp_irq_reqres(struct irq_data *d)
-{
-	struct lp_gpio *lg = irq_data_get_irq_chip_data(d);
-
-	if (gpio_lock_as_irq(&lg->chip, irqd_to_hwirq(d))) {
-		dev_err(lg->chip.dev,
-			"unable to lock HW IRQ %lu for IRQ\n",
-			irqd_to_hwirq(d));
-		return -EINVAL;
-	}
-	return 0;
-}
-
-static void lp_irq_relres(struct irq_data *d)
-{
-	struct lp_gpio *lg = irq_data_get_irq_chip_data(d);
-
-	gpio_unlock_as_irq(&lg->chip, irqd_to_hwirq(d));
-}
-
 static struct irq_chip lp_irqchip = {
 	.name = "LP-GPIO",
 	.irq_mask = lp_irq_mask,
@@ -328,8 +303,6 @@ static struct irq_chip lp_irqchip = {
 	.irq_enable = lp_irq_enable,
 	.irq_disable = lp_irq_disable,
 	.irq_set_type = lp_irq_type,
-	.irq_request_resources = lp_irq_reqres,
-	.irq_release_resources = lp_irq_relres,
 	.flags = IRQCHIP_SKIP_SET_WAKE,
 };
 
@@ -348,22 +321,6 @@ static void lp_gpio_irq_init_hw(struct lp_gpio *lg)
 	}
 }
 
-static int lp_gpio_irq_map(struct irq_domain *d, unsigned int irq,
-			    irq_hw_number_t hwirq)
-{
-	struct lp_gpio *lg = d->host_data;
-
-	irq_set_chip_and_handler(irq, &lp_irqchip, handle_simple_irq);
-	irq_set_chip_data(irq, lg);
-	irq_set_irq_type(irq, IRQ_TYPE_NONE);
-
-	return 0;
-}
-
-static const struct irq_domain_ops lp_gpio_irq_ops = {
-	.map = lp_gpio_irq_map,
-};
-
 static int lp_gpio_probe(struct platform_device *pdev)
 {
 	struct lp_gpio *lg;
@@ -371,7 +328,6 @@ static int lp_gpio_probe(struct platform_device *pdev)
 	struct resource *io_rc, *irq_rc;
 	struct device *dev = &pdev->dev;
 	unsigned long reg_len;
-	unsigned hwirq;
 	int ret = -ENODEV;
 
 	lg = devm_kzalloc(dev, sizeof(struct lp_gpio), GFP_KERNEL);
@@ -414,27 +370,28 @@ static int lp_gpio_probe(struct platform_device *pdev)
 	gc->can_sleep = false;
 	gc->dev = dev;
 
+	ret = gpiochip_add(gc);
+	if (ret) {
+		dev_err(dev, "failed adding lp-gpio chip\n");
+		return ret;
+	}
+
 	/* set up interrupts  */
 	if (irq_rc && irq_rc->start) {
-		hwirq = irq_rc->start;
-		gc->to_irq = lp_gpio_to_irq;
-
-		lg->domain = irq_domain_add_linear(NULL, LP_NUM_GPIO,
-						   &lp_gpio_irq_ops, lg);
-		if (!lg->domain)
-			return -ENXIO;
-
 		lp_gpio_irq_init_hw(lg);
+		ret = gpiochip_irqchip_add(gc, &lp_irqchip, 0,
+					   handle_simple_irq, IRQ_TYPE_NONE);
+		if (ret) {
+			dev_err(dev, "failed to add irqchip\n");
+			gpiochip_remove(gc);
+			return ret;
+		}
 
-		irq_set_handler_data(hwirq, lg);
-		irq_set_chained_handler(hwirq, lp_gpio_irq_handler);
+		gpiochip_set_chained_irqchip(gc, &lp_irqchip,
+					     (unsigned)irq_rc->start,
+					     lp_gpio_irq_handler);
 	}
 
-	ret = gpiochip_add(gc);
-	if (ret) {
-		dev_err(dev, "failed adding lp-gpio chip\n");
-		return ret;
-	}
 	pm_runtime_enable(dev);
 
 	return 0;
-- 
2.0.1

