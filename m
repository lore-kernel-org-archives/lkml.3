Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753001AbbAMNt5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 08:49:57 -0500
Received: from exprod5og111.obsmtp.com ([64.18.0.22]:32894 "EHLO
	exprod5og111.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608AbbAMNtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 08:49:55 -0500
From: Semen Protsenko <semen.protsenko@globallogic.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>
Cc: Grant Likely <grant.likely@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Marc Zyngier <maz@misterjones.org>,
        Grygorii Strashko <grygorii.strashko@globallogic.com>,
        Illia Smyrnov <illia.smyrnov@globallogic.com>
Subject: [PATCH 2/4] gpio: max732x: Rewrite IRQ code to use irq_domain API
Date: Tue, 13 Jan 2015 15:41:43 +0200
Message-Id: <1421156505-16600-3-git-send-email-semen.protsenko@globallogic.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1421156505-16600-1-git-send-email-semen.protsenko@globallogic.com>
References: <1421156505-16600-1-git-send-email-semen.protsenko@globallogic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Semen Protsenko <semen.protsenko@globallogic.com>
---
 drivers/gpio/Kconfig        |    1 +
 drivers/gpio/gpio-max732x.c |  100 ++++++++++++++++++++++++++++---------------
 2 files changed, 66 insertions(+), 35 deletions(-)

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 633ec21..d81d441 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -519,6 +519,7 @@ config GPIO_MAX7300
 config GPIO_MAX732X
 	tristate "MAX7319, MAX7320-7327 I2C Port Expanders"
 	depends on I2C
+	select IRQ_DOMAIN
 	help
 	  Say yes here to support the MAX7319, MAX7320-7327 series of I2C
 	  Port Expanders. Each IO port on these chips has a fixed role of
diff --git a/drivers/gpio/gpio-max732x.c b/drivers/gpio/gpio-max732x.c
index a642f78..f8f3e80 100644
--- a/drivers/gpio/gpio-max732x.c
+++ b/drivers/gpio/gpio-max732x.c
@@ -19,6 +19,7 @@
 #include <linux/gpio.h>
 #include <linux/interrupt.h>
 #include <linux/irq.h>
+#include <linux/irqdomain.h>
 #include <linux/i2c.h>
 #include <linux/i2c/max732x.h>
 #include <linux/of.h>
@@ -149,13 +150,14 @@ struct max732x_chip {
 	uint8_t		reg_out[2];
 
 #ifdef CONFIG_GPIO_MAX732X_IRQ
-	struct mutex	irq_lock;
-	int		irq_base;
-	uint8_t		irq_mask;
-	uint8_t		irq_mask_cur;
-	uint8_t		irq_trig_raise;
-	uint8_t		irq_trig_fall;
-	uint8_t		irq_features;
+	struct irq_domain	*irq_domain;
+	struct mutex		irq_lock;
+	int			irq_base;
+	uint8_t			irq_mask;
+	uint8_t			irq_mask_cur;
+	uint8_t			irq_trig_raise;
+	uint8_t			irq_trig_fall;
+	uint8_t			irq_features;
 #endif
 };
 
@@ -341,21 +343,27 @@ static int max732x_gpio_to_irq(struct gpio_chip *gc, unsigned off)
 	struct max732x_chip *chip;
 
 	chip = container_of(gc, struct max732x_chip, gpio_chip);
-	return chip->irq_base + off;
+
+	if (chip->irq_domain) {
+		return irq_create_mapping(chip->irq_domain,
+				chip->irq_base + off);
+	} else {
+		return -ENXIO;
+	}
 }
 
 static void max732x_irq_mask(struct irq_data *d)
 {
 	struct max732x_chip *chip = irq_data_get_irq_chip_data(d);
 
-	chip->irq_mask_cur &= ~(1 << (d->irq - chip->irq_base));
+	chip->irq_mask_cur &= ~(1 << d->hwirq);
 }
 
 static void max732x_irq_unmask(struct irq_data *d)
 {
 	struct max732x_chip *chip = irq_data_get_irq_chip_data(d);
 
-	chip->irq_mask_cur |= 1 << (d->irq - chip->irq_base);
+	chip->irq_mask_cur |= 1 << d->hwirq;
 }
 
 static void max732x_irq_bus_lock(struct irq_data *d)
@@ -377,7 +385,7 @@ static void max732x_irq_bus_sync_unlock(struct irq_data *d)
 static int max732x_irq_set_type(struct irq_data *d, unsigned int type)
 {
 	struct max732x_chip *chip = irq_data_get_irq_chip_data(d);
-	uint16_t off = d->irq - chip->irq_base;
+	uint16_t off = d->hwirq;
 	uint16_t mask = 1 << off;
 
 	if (!(mask & chip->dir_input)) {
@@ -458,7 +466,7 @@ static irqreturn_t max732x_irq_handler(int irq, void *devid)
 
 	do {
 		level = __ffs(pending);
-		handle_nested_irq(level + chip->irq_base);
+		handle_nested_irq(irq_find_mapping(chip->irq_domain, level));
 
 		pending &= ~(1 << level);
 	} while (pending);
@@ -466,6 +474,44 @@ static irqreturn_t max732x_irq_handler(int irq, void *devid)
 	return IRQ_HANDLED;
 }
 
+static int max732x_irq_map(struct irq_domain *h, unsigned int virq,
+		irq_hw_number_t hw)
+{
+	struct max732x_chip *chip = h->host_data;
+
+	if (!(chip->dir_input & (1 << hw))) {
+		dev_err(&chip->client->dev,
+				"Attempt to map output line as IRQ line: %lu\n",
+				hw);
+		return -EPERM;
+	}
+
+	irq_set_chip_data(virq, chip);
+	irq_set_chip_and_handler(virq, &max732x_irq_chip,
+			handle_edge_irq);
+	irq_set_nested_thread(virq, 1);
+#ifdef CONFIG_ARM
+	/* ARM needs us to explicitly flag the IRQ as valid
+	 * and will set them noprobe when we do so. */
+	set_irq_flags(virq, IRQF_VALID);
+#else
+	irq_set_noprobe(virq);
+#endif
+
+	return 0;
+}
+
+static struct irq_domain_ops max732x_irq_domain_ops = {
+	.map	= max732x_irq_map,
+	.xlate	= irq_domain_xlate_twocell,
+};
+
+static void max732x_irq_teardown(struct max732x_chip *chip)
+{
+	if (chip->client->irq && chip->irq_domain)
+		irq_domain_remove(chip->irq_domain);
+}
+
 static int max732x_irq_setup(struct max732x_chip *chip,
 			     const struct i2c_device_id *id)
 {
@@ -476,28 +522,17 @@ static int max732x_irq_setup(struct max732x_chip *chip,
 
 	if (((pdata && pdata->irq_base) || client->irq)
 			&& has_irq != INT_NONE) {
-		int lvl;
-
 		if (pdata)
 			chip->irq_base = pdata->irq_base;
 		chip->irq_features = has_irq;
 		mutex_init(&chip->irq_lock);
 
-		for (lvl = 0; lvl < chip->gpio_chip.ngpio; lvl++) {
-			int irq = lvl + chip->irq_base;
-
-			if (!(chip->dir_input & (1 << lvl)))
-				continue;
-
-			irq_set_chip_data(irq, chip);
-			irq_set_chip_and_handler(irq, &max732x_irq_chip,
-						 handle_edge_irq);
-			irq_set_nested_thread(irq, 1);
-#ifdef CONFIG_ARM
-			set_irq_flags(irq, IRQF_VALID);
-#else
-			irq_set_noprobe(irq);
-#endif
+		chip->irq_domain = irq_domain_add_simple(client->dev.of_node,
+				chip->gpio_chip.ngpio, chip->irq_base,
+				&max732x_irq_domain_ops, chip);
+		if (!chip->irq_domain) {
+			dev_err(&client->dev, "Failed to create IRQ domain\n");
+			return -ENOMEM;
 		}
 
 		ret = request_threaded_irq(client->irq,
@@ -517,15 +552,10 @@ static int max732x_irq_setup(struct max732x_chip *chip,
 	return 0;
 
 out_failed:
-	chip->irq_base = 0;
+	max732x_irq_teardown(chip);
 	return ret;
 }
 
-static void max732x_irq_teardown(struct max732x_chip *chip)
-{
-	if (chip->irq_base)
-		free_irq(chip->client->irq, chip);
-}
 #else /* CONFIG_GPIO_MAX732X_IRQ */
 static int max732x_irq_setup(struct max732x_chip *chip,
 			     const struct i2c_device_id *id)
-- 
1.7.9.5

