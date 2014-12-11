Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964788AbaLKNFA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 08:05:00 -0500
Received: from mga01.intel.com ([192.55.52.88]:51427 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932470AbaLKNEa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 08:04:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,557,1413270000"; 
   d="scan'208";a="636109388"
From: Octavian Purdila <octavian.purdila@intel.com>
To: linus.walleij@linaro.org, lee.jones@linaro.org
Cc: johan@kernel.org, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-gpio@vger.kernel.org,
        Octavian Purdila <octavian.purdila@intel.com>
Subject: [PATCH 2/3] gpio: dln2: use bus_sync_unlock instead of scheduling work
Date: Thu, 11 Dec 2014 15:02:30 +0200
Message-Id: <1418302951-9309-3-git-send-email-octavian.purdila@intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1418302951-9309-1-git-send-email-octavian.purdila@intel.com>
References: <1418302951-9309-1-git-send-email-octavian.purdila@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the irq_chip bus_sync_unlock method to update hardware registers
instead of scheduling work from the mask/unmask methods. This simplifies
a bit the driver and make it more uniform with the other GPIO IRQ
drivers.

Signed-off-by: Octavian Purdila <octavian.purdila@intel.com>
---
 drivers/gpio/gpio-dln2.c | 92 +++++++++++++++++++++++++++---------------------
 1 file changed, 51 insertions(+), 41 deletions(-)

diff --git a/drivers/gpio/gpio-dln2.c b/drivers/gpio/gpio-dln2.c
index 28a62c4..2fdb138 100644
--- a/drivers/gpio/gpio-dln2.c
+++ b/drivers/gpio/gpio-dln2.c
@@ -47,13 +47,6 @@
 
 #define DLN2_GPIO_MAX_PINS 32
 
-struct dln2_irq_work {
-	struct work_struct work;
-	struct dln2_gpio *dln2;
-	int pin;
-	int type;
-};
-
 struct dln2_gpio {
 	struct platform_device *pdev;
 	struct gpio_chip gpio;
@@ -66,7 +59,10 @@ struct dln2_gpio {
 
 	/* active IRQs - not synced to hardware */
 	DECLARE_BITMAP(unmasked_irqs, DLN2_GPIO_MAX_PINS);
-	struct dln2_irq_work *irq_work;
+	/* active IRQS - synced to hardware */
+	DECLARE_BITMAP(enabled_irqs, DLN2_GPIO_MAX_PINS);
+	int irq_type[DLN2_GPIO_MAX_PINS];
+	struct mutex irq_lock;
 };
 
 struct dln2_gpio_pin {
@@ -296,18 +292,6 @@ static int dln2_gpio_set_event_cfg(struct dln2_gpio *dln2, unsigned pin,
 				&req, sizeof(req));
 }
 
-static void dln2_irq_work(struct work_struct *w)
-{
-	struct dln2_irq_work *iw = container_of(w, struct dln2_irq_work, work);
-	struct dln2_gpio *dln2 = iw->dln2;
-	u8 type = iw->type & DLN2_GPIO_EVENT_MASK;
-
-	if (test_bit(iw->pin, dln2->unmasked_irqs))
-		dln2_gpio_set_event_cfg(dln2, iw->pin, type, 0);
-	else
-		dln2_gpio_set_event_cfg(dln2, iw->pin, DLN2_GPIO_EVENT_NONE, 0);
-}
-
 static void dln2_irq_unmask(struct irq_data *irqd)
 {
 	struct gpio_chip *gc = irq_data_get_irq_chip_data(irqd);
@@ -315,7 +299,6 @@ static void dln2_irq_unmask(struct irq_data *irqd)
 	int pin = irqd_to_hwirq(irqd);
 
 	set_bit(pin, dln2->unmasked_irqs);
-	schedule_work(&dln2->irq_work[pin].work);
 }
 
 static void dln2_irq_mask(struct irq_data *irqd)
@@ -325,7 +308,6 @@ static void dln2_irq_mask(struct irq_data *irqd)
 	int pin = irqd_to_hwirq(irqd);
 
 	clear_bit(pin, dln2->unmasked_irqs);
-	schedule_work(&dln2->irq_work[pin].work);
 }
 
 static int dln2_irq_set_type(struct irq_data *irqd, unsigned type)
@@ -336,19 +318,19 @@ static int dln2_irq_set_type(struct irq_data *irqd, unsigned type)
 
 	switch (type) {
 	case IRQ_TYPE_LEVEL_HIGH:
-		dln2->irq_work[pin].type = DLN2_GPIO_EVENT_LVL_HIGH;
+		dln2->irq_type[pin] = DLN2_GPIO_EVENT_LVL_HIGH;
 		break;
 	case IRQ_TYPE_LEVEL_LOW:
-		dln2->irq_work[pin].type = DLN2_GPIO_EVENT_LVL_LOW;
+		dln2->irq_type[pin] = DLN2_GPIO_EVENT_LVL_LOW;
 		break;
 	case IRQ_TYPE_EDGE_BOTH:
-		dln2->irq_work[pin].type = DLN2_GPIO_EVENT_CHANGE;
+		dln2->irq_type[pin] = DLN2_GPIO_EVENT_CHANGE;
 		break;
 	case IRQ_TYPE_EDGE_RISING:
-		dln2->irq_work[pin].type = DLN2_GPIO_EVENT_CHANGE_RISING;
+		dln2->irq_type[pin] = DLN2_GPIO_EVENT_CHANGE_RISING;
 		break;
 	case IRQ_TYPE_EDGE_FALLING:
-		dln2->irq_work[pin].type = DLN2_GPIO_EVENT_CHANGE_FALLING;
+		dln2->irq_type[pin] = DLN2_GPIO_EVENT_CHANGE_FALLING;
 		break;
 	default:
 		return -EINVAL;
@@ -357,11 +339,50 @@ static int dln2_irq_set_type(struct irq_data *irqd, unsigned type)
 	return 0;
 }
 
+static void dln2_irq_bus_lock(struct irq_data *irqd)
+{
+	struct gpio_chip *gc = irq_data_get_irq_chip_data(irqd);
+	struct dln2_gpio *dln2 = container_of(gc, struct dln2_gpio, gpio);
+
+	mutex_lock(&dln2->irq_lock);
+}
+
+static void dln2_irq_bus_unlock(struct irq_data *irqd)
+{
+	struct gpio_chip *gc = irq_data_get_irq_chip_data(irqd);
+	struct dln2_gpio *dln2 = container_of(gc, struct dln2_gpio, gpio);
+	int pin = irqd_to_hwirq(irqd);
+	int enabled, unmasked;
+	unsigned type;
+	int ret;
+
+	enabled = test_bit(pin, dln2->enabled_irqs);
+	unmasked = test_bit(pin, dln2->unmasked_irqs);
+
+	if (enabled != unmasked) {
+		if (unmasked) {
+			type = dln2->irq_type[pin] & DLN2_GPIO_EVENT_MASK;
+			set_bit(pin, dln2->enabled_irqs);
+		} else {
+			type = DLN2_GPIO_EVENT_NONE;
+			clear_bit(pin, dln2->enabled_irqs);
+		}
+
+		ret = dln2_gpio_set_event_cfg(dln2, pin, type, 0);
+		if (ret)
+			dev_err(dln2->gpio.dev, "failed to set event\n");
+	}
+
+	mutex_unlock(&dln2->irq_lock);
+}
+
 static struct irq_chip dln2_gpio_irqchip = {
 	.name = "dln2-irq",
 	.irq_mask = dln2_irq_mask,
 	.irq_unmask = dln2_irq_unmask,
 	.irq_set_type = dln2_irq_set_type,
+	.irq_bus_lock = dln2_irq_bus_lock,
+	.irq_bus_sync_unlock = dln2_irq_bus_unlock,
 };
 
 static void dln2_gpio_event(struct platform_device *pdev, u16 echo,
@@ -393,7 +414,7 @@ static void dln2_gpio_event(struct platform_device *pdev, u16 echo,
 		return;
 	}
 
-	switch (dln2->irq_work[pin].type) {
+	switch (dln2->irq_type[pin]) {
 	case DLN2_GPIO_EVENT_CHANGE_RISING:
 		if (event->value)
 			generic_handle_irq(irq);
@@ -412,7 +433,7 @@ static int dln2_gpio_probe(struct platform_device *pdev)
 	struct dln2_gpio *dln2;
 	struct device *dev = &pdev->dev;
 	int pins;
-	int i, ret;
+	int ret;
 
 	pins = dln2_gpio_get_pin_count(pdev);
 	if (pins < 0) {
@@ -428,15 +449,7 @@ static int dln2_gpio_probe(struct platform_device *pdev)
 	if (!dln2)
 		return -ENOMEM;
 
-	dln2->irq_work = devm_kcalloc(&pdev->dev, pins,
-				      sizeof(struct dln2_irq_work), GFP_KERNEL);
-	if (!dln2->irq_work)
-		return -ENOMEM;
-	for (i = 0; i < pins; i++) {
-		INIT_WORK(&dln2->irq_work[i].work, dln2_irq_work);
-		dln2->irq_work[i].pin = i;
-		dln2->irq_work[i].dln2 = dln2;
-	}
+	mutex_init(&dln2->irq_lock);
 
 	dln2->pdev = pdev;
 
@@ -490,11 +503,8 @@ out:
 static int dln2_gpio_remove(struct platform_device *pdev)
 {
 	struct dln2_gpio *dln2 = platform_get_drvdata(pdev);
-	int i;
 
 	dln2_unregister_event_cb(pdev, DLN2_GPIO_CONDITION_MET_EV);
-	for (i = 0; i < dln2->gpio.ngpio; i++)
-		flush_work(&dln2->irq_work[i].work);
 	gpiochip_remove(&dln2->gpio);
 
 	return 0;
-- 
1.9.1

