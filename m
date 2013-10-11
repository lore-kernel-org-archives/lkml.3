Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759417Ab3JKUES (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 16:04:18 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46237 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932547Ab3JKTla (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 15:41:30 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>,
        George Cherian <george.cherian@ti.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Lars Poeschel <poeschel@lemonage.de>,
        Kevin Hilman <khilman@linaro.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [ 054/135] gpio/omap: auto-setup a GPIO when used as an IRQ
Date: Fri, 11 Oct 2013 12:38:55 -0700
Message-Id: <20131011193951.151559616@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131011193945.181603934@linuxfoundation.org>
References: <20131011193945.181603934@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>

commit fac7fa162a19100298d5d91359960037dc5bfca9 upstream.

The OMAP GPIO controller HW requires a pin to be configured in GPIO
input mode in order to operate as an interrupt input. Since drivers
should not be aware of whether an interrupt pin is also a GPIO or not,
the HW should be fully configured/enabled as an IRQ if a driver solely
uses IRQ APIs such as request_irq(), and never calls any GPIO-related
APIs. As such, add the missing HW setup to the OMAP GPIO controller's
irq_chip driver.

Since this bypasses the GPIO subsystem we have to ensure that another
driver won't be able to request the same GPIO pin that is used as an
IRQ and set its direction as output. Requesting the GPIO and setting
its direction as input is allowed though.

This fixes smsc911x ethernet support for tobi and igep OMAP3 boards
and OMAP4 SDP SPI based ethernet that use a GPIO as an interrupt line.

Acked-by: Stephen Warren <swarren@nvidia.com>
Tested-by: George Cherian <george.cherian@ti.com>
Tested-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Tested-by: Lars Poeschel <poeschel@lemonage.de>
Reviewed-by: Kevin Hilman <khilman@linaro.org>
Tested-by: Kevin Hilman <khilman@linaro.org>
Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Acked-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpio/gpio-omap.c |  129 ++++++++++++++++++++++++++++++-----------------
 1 file changed, 83 insertions(+), 46 deletions(-)

--- a/drivers/gpio/gpio-omap.c
+++ b/drivers/gpio/gpio-omap.c
@@ -424,6 +424,52 @@ static int _set_gpio_triggering(struct g
 	return 0;
 }
 
+static void _enable_gpio_module(struct gpio_bank *bank, unsigned offset)
+{
+	if (bank->regs->pinctrl) {
+		void __iomem *reg = bank->base + bank->regs->pinctrl;
+
+		/* Claim the pin for MPU */
+		__raw_writel(__raw_readl(reg) | (1 << offset), reg);
+	}
+
+	if (bank->regs->ctrl && !BANK_USED(bank)) {
+		void __iomem *reg = bank->base + bank->regs->ctrl;
+		u32 ctrl;
+
+		ctrl = __raw_readl(reg);
+		/* Module is enabled, clocks are not gated */
+		ctrl &= ~GPIO_MOD_CTRL_BIT;
+		__raw_writel(ctrl, reg);
+		bank->context.ctrl = ctrl;
+	}
+}
+
+static void _disable_gpio_module(struct gpio_bank *bank, unsigned offset)
+{
+	void __iomem *base = bank->base;
+
+	if (bank->regs->wkup_en &&
+	    !LINE_USED(bank->mod_usage, offset) &&
+	    !LINE_USED(bank->irq_usage, offset)) {
+		/* Disable wake-up during idle for dynamic tick */
+		_gpio_rmw(base, bank->regs->wkup_en, 1 << offset, 0);
+		bank->context.wake_en =
+			__raw_readl(bank->base + bank->regs->wkup_en);
+	}
+
+	if (bank->regs->ctrl && !BANK_USED(bank)) {
+		void __iomem *reg = bank->base + bank->regs->ctrl;
+		u32 ctrl;
+
+		ctrl = __raw_readl(reg);
+		/* Module is disabled, clocks are gated */
+		ctrl |= GPIO_MOD_CTRL_BIT;
+		__raw_writel(ctrl, reg);
+		bank->context.ctrl = ctrl;
+	}
+}
+
 static int gpio_is_input(struct gpio_bank *bank, int mask)
 {
 	void __iomem *reg = bank->base + bank->regs->direction;
@@ -437,9 +483,10 @@ static int gpio_irq_type(struct irq_data
 	unsigned gpio = 0;
 	int retval;
 	unsigned long flags;
+	unsigned offset;
 
-	if (WARN_ON(!BANK_USED(bank)))
-		return -EINVAL;
+	if (!BANK_USED(bank))
+		pm_runtime_get_sync(bank->dev);
 
 #ifdef CONFIG_ARCH_OMAP1
 	if (d->irq > IH_MPUIO_BASE)
@@ -457,7 +504,16 @@ static int gpio_irq_type(struct irq_data
 		return -EINVAL;
 
 	spin_lock_irqsave(&bank->lock, flags);
-	retval = _set_gpio_triggering(bank, GPIO_INDEX(bank, gpio), type);
+	offset = GPIO_INDEX(bank, gpio);
+	retval = _set_gpio_triggering(bank, offset, type);
+	if (!LINE_USED(bank->mod_usage, offset)) {
+		_enable_gpio_module(bank, offset);
+		_set_gpio_direction(bank, offset, 1);
+	} else if (!gpio_is_input(bank, 1 << offset)) {
+		spin_unlock_irqrestore(&bank->lock, flags);
+		return -EINVAL;
+	}
+
 	bank->irq_usage |= 1 << GPIO_INDEX(bank, gpio);
 	spin_unlock_irqrestore(&bank->lock, flags);
 
@@ -620,30 +676,14 @@ static int omap_gpio_request(struct gpio
 
 	spin_lock_irqsave(&bank->lock, flags);
 	/* Set trigger to none. You need to enable the desired trigger with
-	 * request_irq() or set_irq_type().
+	 * request_irq() or set_irq_type(). Only do this if the IRQ line has
+	 * not already been requested.
 	 */
-	_set_gpio_triggering(bank, offset, IRQ_TYPE_NONE);
-
-	if (bank->regs->pinctrl) {
-		void __iomem *reg = bank->base + bank->regs->pinctrl;
-
-		/* Claim the pin for MPU */
-		__raw_writel(__raw_readl(reg) | (1 << offset), reg);
+	if (!LINE_USED(bank->irq_usage, offset)) {
+		_set_gpio_triggering(bank, offset, IRQ_TYPE_NONE);
+		_enable_gpio_module(bank, offset);
 	}
-
-	if (bank->regs->ctrl && !BANK_USED(bank)) {
-		void __iomem *reg = bank->base + bank->regs->ctrl;
-		u32 ctrl;
-
-		ctrl = __raw_readl(reg);
-		/* Module is enabled, clocks are not gated */
-		ctrl &= ~GPIO_MOD_CTRL_BIT;
-		__raw_writel(ctrl, reg);
-		bank->context.ctrl = ctrl;
-	}
-
 	bank->mod_usage |= 1 << offset;
-
 	spin_unlock_irqrestore(&bank->lock, flags);
 
 	return 0;
@@ -652,31 +692,11 @@ static int omap_gpio_request(struct gpio
 static void omap_gpio_free(struct gpio_chip *chip, unsigned offset)
 {
 	struct gpio_bank *bank = container_of(chip, struct gpio_bank, chip);
-	void __iomem *base = bank->base;
 	unsigned long flags;
 
 	spin_lock_irqsave(&bank->lock, flags);
-
-	if (bank->regs->wkup_en) {
-		/* Disable wake-up during idle for dynamic tick */
-		_gpio_rmw(base, bank->regs->wkup_en, 1 << offset, 0);
-		bank->context.wake_en =
-			__raw_readl(bank->base + bank->regs->wkup_en);
-	}
-
 	bank->mod_usage &= ~(1 << offset);
-
-	if (bank->regs->ctrl && !BANK_USED(bank)) {
-		void __iomem *reg = bank->base + bank->regs->ctrl;
-		u32 ctrl;
-
-		ctrl = __raw_readl(reg);
-		/* Module is disabled, clocks are gated */
-		ctrl |= GPIO_MOD_CTRL_BIT;
-		__raw_writel(ctrl, reg);
-		bank->context.ctrl = ctrl;
-	}
-
+	_disable_gpio_module(bank, offset);
 	_reset_gpio(bank, bank->chip.base + offset);
 	spin_unlock_irqrestore(&bank->lock, flags);
 
@@ -778,8 +798,16 @@ static void gpio_irq_shutdown(struct irq
 
 	spin_lock_irqsave(&bank->lock, flags);
 	bank->irq_usage &= ~(1 << offset);
+	_disable_gpio_module(bank, offset);
 	_reset_gpio(bank, gpio);
 	spin_unlock_irqrestore(&bank->lock, flags);
+
+	/*
+	 * If this is the last IRQ to be freed in the bank,
+	 * disable the bank module.
+	 */
+	if (!BANK_USED(bank))
+		pm_runtime_put(bank->dev);
 }
 
 static void gpio_ack_irq(struct irq_data *d)
@@ -929,13 +957,22 @@ static int gpio_output(struct gpio_chip
 {
 	struct gpio_bank *bank;
 	unsigned long flags;
+	int retval = 0;
 
 	bank = container_of(chip, struct gpio_bank, chip);
 	spin_lock_irqsave(&bank->lock, flags);
+
+	if (LINE_USED(bank->irq_usage, offset)) {
+			retval = -EINVAL;
+			goto exit;
+	}
+
 	bank->set_dataout(bank, offset, value);
 	_set_gpio_direction(bank, offset, 0);
+
+exit:
 	spin_unlock_irqrestore(&bank->lock, flags);
-	return 0;
+	return retval;
 }
 
 static int gpio_debounce(struct gpio_chip *chip, unsigned offset,


