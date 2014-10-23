Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972AbaJWI1X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 04:27:23 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:5971 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752244AbaJWI1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 04:27:18 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 23 Oct 2014 01:23:16 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: <linux-gpio@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gnurou@gmail.com>, Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH] gpio: rename gpio_lock_as_irq to gpiochip_lock_as_irq
Date: Thu, 23 Oct 2014 17:27:07 +0900
Message-ID: <1414052827-21942-1-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 2.1.2
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function actually operates on a gpio_chip, so its prefix should
reflect that fact for consistency with other functions defined in
gpio/driver.h.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
Just a consistency change ; hopefully we can slip this under the GPIO
tree without getting acked-bys from each subsystem.

 Documentation/gpio/driver.txt            |  4 ++--
 drivers/gpio/gpio-bcm-kona.c             |  4 ++--
 drivers/gpio/gpio-dwapb.c                |  4 ++--
 drivers/gpio/gpio-em.c                   |  4 ++--
 drivers/gpio/gpio-mcp23s08.c             |  4 ++--
 drivers/gpio/gpio-omap.c                 |  2 +-
 drivers/gpio/gpio-tegra.c                |  4 ++--
 drivers/gpio/gpio-vr41xx.c               |  4 ++--
 drivers/gpio/gpiolib-acpi.c              |  6 +++---
 drivers/gpio/gpiolib-sysfs.c             |  4 ++--
 drivers/gpio/gpiolib.c                   | 16 ++++++++--------
 drivers/pinctrl/pinctrl-at91.c           |  4 ++--
 drivers/pinctrl/samsung/pinctrl-exynos.c |  4 ++--
 drivers/pinctrl/sunxi/pinctrl-sunxi.c    |  6 +++---
 include/linux/gpio.h                     |  7 ++++---
 include/linux/gpio/driver.h              |  4 ++--
 16 files changed, 41 insertions(+), 40 deletions(-)

diff --git a/Documentation/gpio/driver.txt b/Documentation/gpio/driver.txt
index 31e0b5db55d8..90d0f6aba7a6 100644
--- a/Documentation/gpio/driver.txt
+++ b/Documentation/gpio/driver.txt
@@ -158,12 +158,12 @@ Locking IRQ usage
 Input GPIOs can be used as IRQ signals. When this happens, a driver is requested
 to mark the GPIO as being used as an IRQ:
 
-	int gpio_lock_as_irq(struct gpio_chip *chip, unsigned int offset)
+	int gpiochip_lock_as_irq(struct gpio_chip *chip, unsigned int offset)
 
 This will prevent the use of non-irq related GPIO APIs until the GPIO IRQ lock
 is released:
 
-	void gpio_unlock_as_irq(struct gpio_chip *chip, unsigned int offset)
+	void gpiochip_unlock_as_irq(struct gpio_chip *chip, unsigned int offset)
 
 When implementing an irqchip inside a GPIO driver, these two functions should
 typically be called in the .startup() and .shutdown() callbacks from the
diff --git a/drivers/gpio/gpio-bcm-kona.c b/drivers/gpio/gpio-bcm-kona.c
index de0801e9767a..56fb5ce47aa1 100644
--- a/drivers/gpio/gpio-bcm-kona.c
+++ b/drivers/gpio/gpio-bcm-kona.c
@@ -470,7 +470,7 @@ static int bcm_kona_gpio_irq_reqres(struct irq_data *d)
 {
 	struct bcm_kona_gpio *kona_gpio = irq_data_get_irq_chip_data(d);
 
-	if (gpio_lock_as_irq(&kona_gpio->gpio_chip, d->hwirq)) {
+	if (gpiochip_lock_as_irq(&kona_gpio->gpio_chip, d->hwirq)) {
 		dev_err(kona_gpio->gpio_chip.dev,
 			"unable to lock HW IRQ %lu for IRQ\n",
 			d->hwirq);
@@ -483,7 +483,7 @@ static void bcm_kona_gpio_irq_relres(struct irq_data *d)
 {
 	struct bcm_kona_gpio *kona_gpio = irq_data_get_irq_chip_data(d);
 
-	gpio_unlock_as_irq(&kona_gpio->gpio_chip, d->hwirq);
+	gpiochip_unlock_as_irq(&kona_gpio->gpio_chip, d->hwirq);
 }
 
 static struct irq_chip bcm_gpio_irq_chip = {
diff --git a/drivers/gpio/gpio-dwapb.c b/drivers/gpio/gpio-dwapb.c
index b43cd84b61f1..4beb37839392 100644
--- a/drivers/gpio/gpio-dwapb.c
+++ b/drivers/gpio/gpio-dwapb.c
@@ -194,7 +194,7 @@ static int dwapb_irq_reqres(struct irq_data *d)
 	struct dwapb_gpio *gpio = igc->private;
 	struct bgpio_chip *bgc = &gpio->ports[0].bgc;
 
-	if (gpio_lock_as_irq(&bgc->gc, irqd_to_hwirq(d))) {
+	if (gpiochip_lock_as_irq(&bgc->gc, irqd_to_hwirq(d))) {
 		dev_err(gpio->dev, "unable to lock HW IRQ %lu for IRQ\n",
 			irqd_to_hwirq(d));
 		return -EINVAL;
@@ -208,7 +208,7 @@ static void dwapb_irq_relres(struct irq_data *d)
 	struct dwapb_gpio *gpio = igc->private;
 	struct bgpio_chip *bgc = &gpio->ports[0].bgc;
 
-	gpio_unlock_as_irq(&bgc->gc, irqd_to_hwirq(d));
+	gpiochip_unlock_as_irq(&bgc->gc, irqd_to_hwirq(d));
 }
 
 static int dwapb_irq_set_type(struct irq_data *d, u32 type)
diff --git a/drivers/gpio/gpio-em.c b/drivers/gpio/gpio-em.c
index fe49ec3cdb7d..21d34d4d473d 100644
--- a/drivers/gpio/gpio-em.c
+++ b/drivers/gpio/gpio-em.c
@@ -103,7 +103,7 @@ static int em_gio_irq_reqres(struct irq_data *d)
 {
 	struct em_gio_priv *p = irq_data_get_irq_chip_data(d);
 
-	if (gpio_lock_as_irq(&p->gpio_chip, irqd_to_hwirq(d))) {
+	if (gpiochip_lock_as_irq(&p->gpio_chip, irqd_to_hwirq(d))) {
 		dev_err(p->gpio_chip.dev,
 			"unable to lock HW IRQ %lu for IRQ\n",
 			irqd_to_hwirq(d));
@@ -116,7 +116,7 @@ static void em_gio_irq_relres(struct irq_data *d)
 {
 	struct em_gio_priv *p = irq_data_get_irq_chip_data(d);
 
-	gpio_unlock_as_irq(&p->gpio_chip, irqd_to_hwirq(d));
+	gpiochip_unlock_as_irq(&p->gpio_chip, irqd_to_hwirq(d));
 }
 
 
diff --git a/drivers/gpio/gpio-mcp23s08.c b/drivers/gpio/gpio-mcp23s08.c
index 8488e2fd307c..468d10d2ac1e 100644
--- a/drivers/gpio/gpio-mcp23s08.c
+++ b/drivers/gpio/gpio-mcp23s08.c
@@ -444,7 +444,7 @@ static int mcp23s08_irq_reqres(struct irq_data *data)
 {
 	struct mcp23s08 *mcp = irq_data_get_irq_chip_data(data);
 
-	if (gpio_lock_as_irq(&mcp->chip, data->hwirq)) {
+	if (gpiochip_lock_as_irq(&mcp->chip, data->hwirq)) {
 		dev_err(mcp->chip.dev,
 			"unable to lock HW IRQ %lu for IRQ usage\n",
 			data->hwirq);
@@ -458,7 +458,7 @@ static void mcp23s08_irq_relres(struct irq_data *data)
 {
 	struct mcp23s08 *mcp = irq_data_get_irq_chip_data(data);
 
-	gpio_unlock_as_irq(&mcp->chip, data->hwirq);
+	gpiochip_unlock_as_irq(&mcp->chip, data->hwirq);
 }
 
 static struct irq_chip mcp23s08_irq_chip = {
diff --git a/drivers/gpio/gpio-omap.c b/drivers/gpio/gpio-omap.c
index 415682f69214..a38686786e46 100644
--- a/drivers/gpio/gpio-omap.c
+++ b/drivers/gpio/gpio-omap.c
@@ -800,7 +800,7 @@ static void omap_gpio_irq_shutdown(struct irq_data *d)
 	unsigned offset = GPIO_INDEX(bank, gpio);
 
 	spin_lock_irqsave(&bank->lock, flags);
-	gpio_unlock_as_irq(&bank->chip, offset);
+	gpiochip_unlock_as_irq(&bank->chip, offset);
 	bank->irq_usage &= ~(BIT(offset));
 	omap_disable_gpio_module(bank, offset);
 	omap_reset_gpio(bank, gpio);
diff --git a/drivers/gpio/gpio-tegra.c b/drivers/gpio/gpio-tegra.c
index 4e8fb8261a87..61bcfa93606d 100644
--- a/drivers/gpio/gpio-tegra.c
+++ b/drivers/gpio/gpio-tegra.c
@@ -233,7 +233,7 @@ static int tegra_gpio_irq_set_type(struct irq_data *d, unsigned int type)
 		return -EINVAL;
 	}
 
-	ret = gpio_lock_as_irq(&tegra_gpio_chip, gpio);
+	ret = gpiochip_lock_as_irq(&tegra_gpio_chip, gpio);
 	if (ret) {
 		dev_err(dev, "unable to lock Tegra GPIO %d as IRQ\n", gpio);
 		return ret;
@@ -263,7 +263,7 @@ static void tegra_gpio_irq_shutdown(struct irq_data *d)
 {
 	int gpio = d->hwirq;
 
-	gpio_unlock_as_irq(&tegra_gpio_chip, gpio);
+	gpiochip_unlock_as_irq(&tegra_gpio_chip, gpio);
 }
 
 static void tegra_gpio_irq_handler(unsigned int irq, struct irq_desc *desc)
diff --git a/drivers/gpio/gpio-vr41xx.c b/drivers/gpio/gpio-vr41xx.c
index dbf28fa03f67..cec55226143d 100644
--- a/drivers/gpio/gpio-vr41xx.c
+++ b/drivers/gpio/gpio-vr41xx.c
@@ -138,7 +138,7 @@ static void unmask_giuint_low(struct irq_data *d)
 
 static unsigned int startup_giuint(struct irq_data *data)
 {
-	if (gpio_lock_as_irq(&vr41xx_gpio_chip, data->hwirq))
+	if (gpiochip_lock_as_irq(&vr41xx_gpio_chip, data->hwirq))
 		dev_err(vr41xx_gpio_chip.dev,
 			"unable to lock HW IRQ %lu for IRQ\n",
 			data->hwirq);
@@ -150,7 +150,7 @@ static unsigned int startup_giuint(struct irq_data *data)
 static void shutdown_giuint(struct irq_data *data)
 {
 	mask_giuint_low(data);
-	gpio_unlock_as_irq(&vr41xx_gpio_chip, data->hwirq);
+	gpiochip_unlock_as_irq(&vr41xx_gpio_chip, data->hwirq);
 }
 
 static struct irq_chip giuint_low_irq_chip = {
diff --git a/drivers/gpio/gpiolib-acpi.c b/drivers/gpio/gpiolib-acpi.c
index 05c6275da224..349a7552dd23 100644
--- a/drivers/gpio/gpiolib-acpi.c
+++ b/drivers/gpio/gpiolib-acpi.c
@@ -153,7 +153,7 @@ static acpi_status acpi_gpiochip_request_interrupt(struct acpi_resource *ares,
 
 	gpiod_direction_input(desc);
 
-	ret = gpio_lock_as_irq(chip, pin);
+	ret = gpiochip_lock_as_irq(chip, pin);
 	if (ret) {
 		dev_err(chip->dev, "Failed to lock GPIO as interrupt\n");
 		goto fail_free_desc;
@@ -209,7 +209,7 @@ static acpi_status acpi_gpiochip_request_interrupt(struct acpi_resource *ares,
 fail_free_event:
 	kfree(event);
 fail_unlock_irq:
-	gpio_unlock_as_irq(chip, pin);
+	gpiochip_unlock_as_irq(chip, pin);
 fail_free_desc:
 	gpiochip_free_own_desc(desc);
 
@@ -280,7 +280,7 @@ void acpi_gpiochip_free_interrupts(struct gpio_chip *chip)
 		desc = event->desc;
 		if (WARN_ON(IS_ERR(desc)))
 			continue;
-		gpio_unlock_as_irq(chip, event->pin);
+		gpiochip_unlock_as_irq(chip, event->pin);
 		gpiochip_free_own_desc(desc);
 		list_del(&event->node);
 		kfree(event);
diff --git a/drivers/gpio/gpiolib-sysfs.c b/drivers/gpio/gpiolib-sysfs.c
index 5f2150b619a7..781fbed00fc3 100644
--- a/drivers/gpio/gpiolib-sysfs.c
+++ b/drivers/gpio/gpiolib-sysfs.c
@@ -161,7 +161,7 @@ static int gpio_setup_irq(struct gpio_desc *desc, struct device *dev,
 	desc->flags &= ~GPIO_TRIGGER_MASK;
 
 	if (!gpio_flags) {
-		gpio_unlock_as_irq(desc->chip, gpio_chip_hwgpio(desc));
+		gpiochip_unlock_as_irq(desc->chip, gpio_chip_hwgpio(desc));
 		ret = 0;
 		goto free_id;
 	}
@@ -200,7 +200,7 @@ static int gpio_setup_irq(struct gpio_desc *desc, struct device *dev,
 	if (ret < 0)
 		goto free_id;
 
-	ret = gpio_lock_as_irq(desc->chip, gpio_chip_hwgpio(desc));
+	ret = gpiochip_lock_as_irq(desc->chip, gpio_chip_hwgpio(desc));
 	if (ret < 0) {
 		gpiod_warn(desc, "failed to flag the GPIO for IRQ\n");
 		goto free_id;
diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index e8e98ca25ec7..50e18a4b3a9f 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -495,7 +495,7 @@ static int gpiochip_irq_reqres(struct irq_data *d)
 {
 	struct gpio_chip *chip = irq_data_get_irq_chip_data(d);
 
-	if (gpio_lock_as_irq(chip, d->hwirq)) {
+	if (gpiochip_lock_as_irq(chip, d->hwirq)) {
 		chip_err(chip,
 			"unable to lock HW IRQ %lu for IRQ\n",
 			d->hwirq);
@@ -508,7 +508,7 @@ static void gpiochip_irq_relres(struct irq_data *d)
 {
 	struct gpio_chip *chip = irq_data_get_irq_chip_data(d);
 
-	gpio_unlock_as_irq(chip, d->hwirq);
+	gpiochip_unlock_as_irq(chip, d->hwirq);
 }
 
 static int gpiochip_to_irq(struct gpio_chip *chip, unsigned offset)
@@ -1332,14 +1332,14 @@ int gpiod_to_irq(const struct gpio_desc *desc)
 EXPORT_SYMBOL_GPL(gpiod_to_irq);
 
 /**
- * gpio_lock_as_irq() - lock a GPIO to be used as IRQ
+ * gpiochip_lock_as_irq() - lock a GPIO to be used as IRQ
  * @chip: the chip the GPIO to lock belongs to
  * @offset: the offset of the GPIO to lock as IRQ
  *
  * This is used directly by GPIO drivers that want to lock down
  * a certain GPIO line to be used for IRQs.
  */
-int gpio_lock_as_irq(struct gpio_chip *chip, unsigned int offset)
+int gpiochip_lock_as_irq(struct gpio_chip *chip, unsigned int offset)
 {
 	if (offset >= chip->ngpio)
 		return -EINVAL;
@@ -1354,24 +1354,24 @@ int gpio_lock_as_irq(struct gpio_chip *chip, unsigned int offset)
 	set_bit(FLAG_USED_AS_IRQ, &chip->desc[offset].flags);
 	return 0;
 }
-EXPORT_SYMBOL_GPL(gpio_lock_as_irq);
+EXPORT_SYMBOL_GPL(gpiochip_lock_as_irq);
 
 /**
- * gpio_unlock_as_irq() - unlock a GPIO used as IRQ
+ * gpiochip_unlock_as_irq() - unlock a GPIO used as IRQ
  * @chip: the chip the GPIO to lock belongs to
  * @offset: the offset of the GPIO to lock as IRQ
  *
  * This is used directly by GPIO drivers that want to indicate
  * that a certain GPIO is no longer used exclusively for IRQ.
  */
-void gpio_unlock_as_irq(struct gpio_chip *chip, unsigned int offset)
+void gpiochip_unlock_as_irq(struct gpio_chip *chip, unsigned int offset)
 {
 	if (offset >= chip->ngpio)
 		return;
 
 	clear_bit(FLAG_USED_AS_IRQ, &chip->desc[offset].flags);
 }
-EXPORT_SYMBOL_GPL(gpio_unlock_as_irq);
+EXPORT_SYMBOL_GPL(gpiochip_unlock_as_irq);
 
 /**
  * gpiod_get_raw_value_cansleep() - return a gpio's raw value
diff --git a/drivers/pinctrl/pinctrl-at91.c b/drivers/pinctrl/pinctrl-at91.c
index 354a81d40925..608671704522 100644
--- a/drivers/pinctrl/pinctrl-at91.c
+++ b/drivers/pinctrl/pinctrl-at91.c
@@ -1472,7 +1472,7 @@ static unsigned int gpio_irq_startup(struct irq_data *d)
 	unsigned	pin = d->hwirq;
 	int ret;
 
-	ret = gpio_lock_as_irq(&at91_gpio->chip, pin);
+	ret = gpiochip_lock_as_irq(&at91_gpio->chip, pin);
 	if (ret) {
 		dev_err(at91_gpio->chip.dev, "unable to lock pind %lu IRQ\n",
 			d->hwirq);
@@ -1488,7 +1488,7 @@ static void gpio_irq_shutdown(struct irq_data *d)
 	unsigned	pin = d->hwirq;
 
 	gpio_irq_mask(d);
-	gpio_unlock_as_irq(&at91_gpio->chip, pin);
+	gpiochip_unlock_as_irq(&at91_gpio->chip, pin);
 }
 
 #ifdef CONFIG_PM
diff --git a/drivers/pinctrl/samsung/pinctrl-exynos.c b/drivers/pinctrl/samsung/pinctrl-exynos.c
index d7154ed0b0eb..fa54a2d1c966 100644
--- a/drivers/pinctrl/samsung/pinctrl-exynos.c
+++ b/drivers/pinctrl/samsung/pinctrl-exynos.c
@@ -180,7 +180,7 @@ static int exynos_irq_request_resources(struct irq_data *irqd)
 	unsigned int con;
 	int ret;
 
-	ret = gpio_lock_as_irq(&bank->gpio_chip, irqd->hwirq);
+	ret = gpiochip_lock_as_irq(&bank->gpio_chip, irqd->hwirq);
 	if (ret) {
 		dev_err(bank->gpio_chip.dev, "unable to lock pin %s-%lu IRQ\n",
 			bank->name, irqd->hwirq);
@@ -233,7 +233,7 @@ static void exynos_irq_release_resources(struct irq_data *irqd)
 
 	spin_unlock_irqrestore(&bank->slock, flags);
 
-	gpio_unlock_as_irq(&bank->gpio_chip, irqd->hwirq);
+	gpiochip_unlock_as_irq(&bank->gpio_chip, irqd->hwirq);
 }
 
 /*
diff --git a/drivers/pinctrl/sunxi/pinctrl-sunxi.c b/drivers/pinctrl/sunxi/pinctrl-sunxi.c
index ef9d804e55de..3d0744337736 100644
--- a/drivers/pinctrl/sunxi/pinctrl-sunxi.c
+++ b/drivers/pinctrl/sunxi/pinctrl-sunxi.c
@@ -553,7 +553,7 @@ static int sunxi_pinctrl_irq_request_resources(struct irq_data *d)
 	if (!func)
 		return -EINVAL;
 
-	ret = gpio_lock_as_irq(pctl->chip,
+	ret = gpiochip_lock_as_irq(pctl->chip,
 			pctl->irq_array[d->hwirq] - pctl->desc->pin_base);
 	if (ret) {
 		dev_err(pctl->dev, "unable to lock HW IRQ %lu for IRQ\n",
@@ -571,8 +571,8 @@ static void sunxi_pinctrl_irq_release_resources(struct irq_data *d)
 {
 	struct sunxi_pinctrl *pctl = irq_data_get_irq_chip_data(d);
 
-	gpio_unlock_as_irq(pctl->chip,
-			   pctl->irq_array[d->hwirq] - pctl->desc->pin_base);
+	gpiochip_unlock_as_irq(pctl->chip,
+			      pctl->irq_array[d->hwirq] - pctl->desc->pin_base);
 }
 
 static int sunxi_pinctrl_irq_set_type(struct irq_data *d, unsigned int type)
diff --git a/include/linux/gpio.h b/include/linux/gpio.h
index 85aa5d0b9357..ab81339a8590 100644
--- a/include/linux/gpio.h
+++ b/include/linux/gpio.h
@@ -216,14 +216,15 @@ static inline int gpio_to_irq(unsigned gpio)
 	return -EINVAL;
 }
 
-static inline int gpio_lock_as_irq(struct gpio_chip *chip, unsigned int offset)
+static inline int gpiochip_lock_as_irq(struct gpio_chip *chip,
+				       unsigned int offset)
 {
 	WARN_ON(1);
 	return -EINVAL;
 }
 
-static inline void gpio_unlock_as_irq(struct gpio_chip *chip,
-				      unsigned int offset)
+static inline void gpiochip_unlock_as_irq(struct gpio_chip *chip,
+					  unsigned int offset)
 {
 	WARN_ON(1);
 }
diff --git a/include/linux/gpio/driver.h b/include/linux/gpio/driver.h
index 249db3057e4d..ff200a75501e 100644
--- a/include/linux/gpio/driver.h
+++ b/include/linux/gpio/driver.h
@@ -149,8 +149,8 @@ extern struct gpio_chip *gpiochip_find(void *data,
 			      int (*match)(struct gpio_chip *chip, void *data));
 
 /* lock/unlock as IRQ */
-int gpio_lock_as_irq(struct gpio_chip *chip, unsigned int offset);
-void gpio_unlock_as_irq(struct gpio_chip *chip, unsigned int offset);
+int gpiochip_lock_as_irq(struct gpio_chip *chip, unsigned int offset);
+void gpiochip_unlock_as_irq(struct gpio_chip *chip, unsigned int offset);
 
 struct gpio_chip *gpiod_to_chip(const struct gpio_desc *desc);
 
-- 
2.1.2

