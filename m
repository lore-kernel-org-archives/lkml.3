Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933765AbaLKNEc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 08:04:32 -0500
Received: from mga01.intel.com ([192.55.52.88]:51427 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750843AbaLKNE3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 08:04:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,557,1413270000"; 
   d="scan'208";a="636109363"
From: Octavian Purdila <octavian.purdila@intel.com>
To: linus.walleij@linaro.org, lee.jones@linaro.org
Cc: johan@kernel.org, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-gpio@vger.kernel.org,
        Octavian Purdila <octavian.purdila@intel.com>
Subject: [PATCH 1/3] gpio: dln2: fix issue when an IRQ is unmasked then enabled
Date: Thu, 11 Dec 2014 15:02:29 +0200
Message-Id: <1418302951-9309-2-git-send-email-octavian.purdila@intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1418302951-9309-1-git-send-email-octavian.purdila@intel.com>
References: <1418302951-9309-1-git-send-email-octavian.purdila@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As noticed during suspend/resume operations, the IRQ can be unmasked
then disabled in suspend and eventually enabled in resume, but without
being unmasked.

The current implementation does not take into account interactions
between mask/unmask and enable/disable interrupts, and thus in the
above scenarios the IRQs remain unactive.

To fix this we removed the enable/disable operations as they fallback
to mask/unmask anyway.

We also remove the pending bitmaks as it is already done in irq_data
(i.e. IRQS_PENDING).

Signed-off-by: Octavian Purdila <octavian.purdila@intel.com>
---
 drivers/gpio/gpio-dln2.c | 53 +++++++-----------------------------------------
 1 file changed, 7 insertions(+), 46 deletions(-)

diff --git a/drivers/gpio/gpio-dln2.c b/drivers/gpio/gpio-dln2.c
index 978b51e..28a62c4 100644
--- a/drivers/gpio/gpio-dln2.c
+++ b/drivers/gpio/gpio-dln2.c
@@ -64,9 +64,8 @@ struct dln2_gpio {
 	 */
 	DECLARE_BITMAP(output_enabled, DLN2_GPIO_MAX_PINS);
 
-	DECLARE_BITMAP(irqs_masked, DLN2_GPIO_MAX_PINS);
-	DECLARE_BITMAP(irqs_enabled, DLN2_GPIO_MAX_PINS);
-	DECLARE_BITMAP(irqs_pending, DLN2_GPIO_MAX_PINS);
+	/* active IRQs - not synced to hardware */
+	DECLARE_BITMAP(unmasked_irqs, DLN2_GPIO_MAX_PINS);
 	struct dln2_irq_work *irq_work;
 };
 
@@ -303,29 +302,19 @@ static void dln2_irq_work(struct work_struct *w)
 	struct dln2_gpio *dln2 = iw->dln2;
 	u8 type = iw->type & DLN2_GPIO_EVENT_MASK;
 
-	if (test_bit(iw->pin, dln2->irqs_enabled))
+	if (test_bit(iw->pin, dln2->unmasked_irqs))
 		dln2_gpio_set_event_cfg(dln2, iw->pin, type, 0);
 	else
 		dln2_gpio_set_event_cfg(dln2, iw->pin, DLN2_GPIO_EVENT_NONE, 0);
 }
 
-static void dln2_irq_enable(struct irq_data *irqd)
-{
-	struct gpio_chip *gc = irq_data_get_irq_chip_data(irqd);
-	struct dln2_gpio *dln2 = container_of(gc, struct dln2_gpio, gpio);
-	int pin = irqd_to_hwirq(irqd);
-
-	set_bit(pin, dln2->irqs_enabled);
-	schedule_work(&dln2->irq_work[pin].work);
-}
-
-static void dln2_irq_disable(struct irq_data *irqd)
+static void dln2_irq_unmask(struct irq_data *irqd)
 {
 	struct gpio_chip *gc = irq_data_get_irq_chip_data(irqd);
 	struct dln2_gpio *dln2 = container_of(gc, struct dln2_gpio, gpio);
 	int pin = irqd_to_hwirq(irqd);
 
-	clear_bit(pin, dln2->irqs_enabled);
+	set_bit(pin, dln2->unmasked_irqs);
 	schedule_work(&dln2->irq_work[pin].work);
 }
 
@@ -335,27 +324,8 @@ static void dln2_irq_mask(struct irq_data *irqd)
 	struct dln2_gpio *dln2 = container_of(gc, struct dln2_gpio, gpio);
 	int pin = irqd_to_hwirq(irqd);
 
-	set_bit(pin, dln2->irqs_masked);
-}
-
-static void dln2_irq_unmask(struct irq_data *irqd)
-{
-	struct gpio_chip *gc = irq_data_get_irq_chip_data(irqd);
-	struct dln2_gpio *dln2 = container_of(gc, struct dln2_gpio, gpio);
-	struct device *dev = dln2->gpio.dev;
-	int pin = irqd_to_hwirq(irqd);
-
-	if (test_and_clear_bit(pin, dln2->irqs_pending)) {
-		int irq;
-
-		irq = irq_find_mapping(dln2->gpio.irqdomain, pin);
-		if (!irq) {
-			dev_err(dev, "pin %d not mapped to IRQ\n", pin);
-			return;
-		}
-
-		generic_handle_irq(irq);
-	}
+	clear_bit(pin, dln2->unmasked_irqs);
+	schedule_work(&dln2->irq_work[pin].work);
 }
 
 static int dln2_irq_set_type(struct irq_data *irqd, unsigned type)
@@ -389,8 +359,6 @@ static int dln2_irq_set_type(struct irq_data *irqd, unsigned type)
 
 static struct irq_chip dln2_gpio_irqchip = {
 	.name = "dln2-irq",
-	.irq_enable = dln2_irq_enable,
-	.irq_disable = dln2_irq_disable,
 	.irq_mask = dln2_irq_mask,
 	.irq_unmask = dln2_irq_unmask,
 	.irq_set_type = dln2_irq_set_type,
@@ -425,13 +393,6 @@ static void dln2_gpio_event(struct platform_device *pdev, u16 echo,
 		return;
 	}
 
-	if (!test_bit(pin, dln2->irqs_enabled))
-		return;
-	if (test_bit(pin, dln2->irqs_masked)) {
-		set_bit(pin, dln2->irqs_pending);
-		return;
-	}
-
 	switch (dln2->irq_work[pin].type) {
 	case DLN2_GPIO_EVENT_CHANGE_RISING:
 		if (event->value)
-- 
1.9.1

