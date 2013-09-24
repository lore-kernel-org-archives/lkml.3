Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750919Ab3IXH6s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 03:58:48 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:59970 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724Ab3IXH6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 03:58:46 -0400
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Kevin Hilman <khilman@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Lars Poeschel <larsi@wh2.tu-dresden.de>,
        Grant Likely <grant.likely@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Kumar Gala <galak@codeaurora.org>, Pawel Moll <pawel.moll@arm.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Enric Balletbo i Serra <eballetbo@gmail.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Balaji T K <balajitk@ti.com>, Tony Lindgren <tony@atomide.com>,
        Jon Hunter <jgchunter@gmail.com>, linux-gpio@vger.kernel.org,
        linux-omap@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, r.sricharan@ti.com, holler@ahsoftware.de,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [RFC v2] gpio/omap: auto-setup a GPIO when used as an IRQ
Date: Tue, 24 Sep 2013 09:58:00 +0200
Message-Id: <1380009480-4975-1-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 1.8.4.rc3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The OMAP GPIO controller HW requires a pin to be configured in GPIO
input mode in order to operate as an interrupt input. Since drivers
should not be aware of whether an interrupt pin is also a GPIO or not,
the HW should be fully configured/enabled as an IRQ if a driver solely
uses IRQ APIs such as request_irq(), and never calls any GPIO-related
APIs. As such, add the missing HW setup to the OMAP GPIO controller's
irq_chip driver.

Since this bypasses the GPIO subsystem we have to ensure that another
caller won't be able to request the same GPIO pin that is used as an
IRQ and set its direction as output. Requesting the GPIO and setting
its direction as input is allowed though.

Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
---

Tested on a OMAP3 DM3730 board with both legacy and DT based booting.

Changes since v1:
 - Simplify patch description as suggested by Stephen Warren.
 - Track IRQ and GPIO module usage separately.
 - Add clearing path for PM when free_irq() is called to not
   leave the bank unnecessary enabled as suggested by Tony Lindgren.
 - Check if the line is used as IRQ to not allow a second caller
   to set the GPIO direction as output as suggested by Linus Walleij.

 drivers/gpio/gpio-omap.c | 158 ++++++++++++++++++++++++++++++-----------------
 1 file changed, 101 insertions(+), 57 deletions(-)

diff --git a/drivers/gpio/gpio-omap.c b/drivers/gpio/gpio-omap.c
index 0ff4355..89675f8 100644
--- a/drivers/gpio/gpio-omap.c
+++ b/drivers/gpio/gpio-omap.c
@@ -63,6 +63,7 @@ struct gpio_bank {
 	struct gpio_chip chip;
 	struct clk *dbck;
 	u32 mod_usage;
+	u32 irq_usage;
 	u32 dbck_enable_mask;
 	bool dbck_enabled;
 	struct device *dev;
@@ -86,6 +87,9 @@ struct gpio_bank {
 #define GPIO_BIT(bank, gpio) (1 << GPIO_INDEX(bank, gpio))
 #define GPIO_MOD_CTRL_BIT	BIT(0)
 
+#define BANK_USED(bank) (bank->mod_usage || bank->irq_usage)
+#define LINE_USED(line, offset) (line & (1 << offset))
+
 static int irq_to_gpio(struct gpio_bank *bank, unsigned int gpio_irq)
 {
 	return bank->chip.base + gpio_irq;
@@ -420,15 +424,69 @@ static int _set_gpio_triggering(struct gpio_bank *bank, int gpio,
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
+static int gpio_is_input(struct gpio_bank *bank, int mask)
+{
+	void __iomem *reg = bank->base + bank->regs->direction;
+
+	return __raw_readl(reg) & mask;
+}
+
 static int gpio_irq_type(struct irq_data *d, unsigned type)
 {
 	struct gpio_bank *bank = irq_data_get_irq_chip_data(d);
 	unsigned gpio = 0;
 	int retval;
 	unsigned long flags;
+	unsigned offset;
 
-	if (WARN_ON(!bank->mod_usage))
-		return -EINVAL;
+	if (!BANK_USED(bank))
+		pm_runtime_get_sync(bank->dev);
 
 #ifdef CONFIG_ARCH_OMAP1
 	if (d->irq > IH_MPUIO_BASE)
@@ -446,7 +504,17 @@ static int gpio_irq_type(struct irq_data *d, unsigned type)
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
+	bank->irq_usage |= 1 << GPIO_INDEX(bank, gpio);
 	spin_unlock_irqrestore(&bank->lock, flags);
 
 	if (type & (IRQ_TYPE_LEVEL_LOW | IRQ_TYPE_LEVEL_HIGH))
@@ -603,35 +671,19 @@ static int omap_gpio_request(struct gpio_chip *chip, unsigned offset)
 	 * If this is the first gpio_request for the bank,
 	 * enable the bank module.
 	 */
-	if (!bank->mod_usage)
+	if (!BANK_USED(bank))
 		pm_runtime_get_sync(bank->dev);
 
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
-	}
-
-	if (bank->regs->ctrl && !bank->mod_usage) {
-		void __iomem *reg = bank->base + bank->regs->ctrl;
-		u32 ctrl;
-
-		ctrl = __raw_readl(reg);
-		/* Module is enabled, clocks are not gated */
-		ctrl &= ~GPIO_MOD_CTRL_BIT;
-		__raw_writel(ctrl, reg);
-		bank->context.ctrl = ctrl;
+	if (!LINE_USED(bank->irq_usage, offset)) {
+		_set_gpio_triggering(bank, offset, IRQ_TYPE_NONE);
+		_enable_gpio_module(bank, offset);
 	}
-
 	bank->mod_usage |= 1 << offset;
-
 	spin_unlock_irqrestore(&bank->lock, flags);
 
 	return 0;
@@ -640,31 +692,11 @@ static int omap_gpio_request(struct gpio_chip *chip, unsigned offset)
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
-	if (bank->regs->ctrl && !bank->mod_usage) {
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
 
@@ -672,7 +704,7 @@ static void omap_gpio_free(struct gpio_chip *chip, unsigned offset)
 	 * If this is the last gpio to be freed in the bank,
 	 * disable the bank module.
 	 */
-	if (!bank->mod_usage)
+	if (!BANK_USED(bank))
 		pm_runtime_put(bank->dev);
 }
 
@@ -762,10 +794,20 @@ static void gpio_irq_shutdown(struct irq_data *d)
 	struct gpio_bank *bank = irq_data_get_irq_chip_data(d);
 	unsigned int gpio = irq_to_gpio(bank, d->hwirq);
 	unsigned long flags;
+	unsigned offset = GPIO_INDEX(bank, gpio);
 
 	spin_lock_irqsave(&bank->lock, flags);
+	bank->irq_usage &= ~(1 << offset);
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
@@ -897,13 +939,6 @@ static int gpio_input(struct gpio_chip *chip, unsigned offset)
 	return 0;
 }
 
-static int gpio_is_input(struct gpio_bank *bank, int mask)
-{
-	void __iomem *reg = bank->base + bank->regs->direction;
-
-	return __raw_readl(reg) & mask;
-}
-
 static int gpio_get(struct gpio_chip *chip, unsigned offset)
 {
 	struct gpio_bank *bank;
@@ -922,13 +957,22 @@ static int gpio_output(struct gpio_chip *chip, unsigned offset, int value)
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
@@ -1400,7 +1444,7 @@ void omap2_gpio_prepare_for_idle(int pwr_mode)
 	struct gpio_bank *bank;
 
 	list_for_each_entry(bank, &omap_gpio_list, node) {
-		if (!bank->mod_usage || !bank->loses_context)
+		if (!BANK_USED(bank) || !bank->loses_context)
 			continue;
 
 		bank->power_mode = pwr_mode;
@@ -1414,7 +1458,7 @@ void omap2_gpio_resume_after_idle(void)
 	struct gpio_bank *bank;
 
 	list_for_each_entry(bank, &omap_gpio_list, node) {
-		if (!bank->mod_usage || !bank->loses_context)
+		if (!BANK_USED(bank) || !bank->loses_context)
 			continue;
 
 		pm_runtime_get_sync(bank->dev);
-- 
1.8.4.rc3

