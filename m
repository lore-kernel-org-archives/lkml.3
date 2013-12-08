Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754836Ab3LHEl0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Dec 2013 23:41:26 -0500
Received: from mail-oa0-f48.google.com ([209.85.219.48]:53765 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751844Ab3LHElY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Dec 2013 23:41:24 -0500
From: Chao Xu <caesarxuchao@gmail.com>
To: linux-omap@vger.kernel.org
Cc: santosh.shilimkar@ti.com, khilman@deeprootsystems.com,
        linus.walleij@linaro.org, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org, tony@atomide.com, balbi@ti.com,
        khilman@linaro.org, nm@ti.com, Chao Xu <caesarxuchao@gmail.com>
Subject: [RFC/RFT/PATCH V3] gpio: omap: refresh patch "be more aggressive with pm_runtime" against v3.12-rc5
Date: Sat,  7 Dec 2013 22:40:38 -0600
Message-Id: <1386477638-6331-1-git-send-email-caesarxuchao@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1385506004-14943-1-git-send-email-caesarxuchao@gmail.com>
References: <1385506004-14943-1-git-send-email-caesarxuchao@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Felipe Balbi <balbi@ti.com>

try to keep gpio block suspended as much as possible.

Tested with pandaboard and a sysfs exported gpio.

Signed-off-by: Felipe Balbi <balbi at ti.com>

[caesarxuchao@gmail.com : Refreshed against v3.12-rc5, and added
revision check to enable aggressive pm_runtime on OMAP4-only. Because
am33xx_gpio_sysc.idlemodes seems to be wrongly marked as
SIDLE_SMART_WKUP, which might cause missed interrupts with this patch.
Tested on Pandaboard rev A2.]
Signed-off-by: Chao Xu <caesarxuchao@gmail.com>
---
changes since v2:
*add wrapper function to avoid 'is_aggressive_pm' check everywhere, as
suggested by Santosh Shilimkar 
*fix format issue in commit log

 drivers/gpio/gpio-omap.c                |   90 +++++++++++++++++++++++++------
 include/linux/platform_data/gpio-omap.h |    1 +
 2 files changed, 74 insertions(+), 17 deletions(-)

diff --git a/drivers/gpio/gpio-omap.c b/drivers/gpio/gpio-omap.c
index 89675f8..fc5318b 100644
--- a/drivers/gpio/gpio-omap.c
+++ b/drivers/gpio/gpio-omap.c
@@ -76,6 +76,7 @@ struct gpio_bank {
 	int context_loss_count;
 	int power_mode;
 	bool workaround_enabled;
+	bool is_aggressive_pm;
 
 	void (*set_dataout)(struct gpio_bank *bank, int gpio, int enable);
 	int (*get_context_loss_count)(struct device *dev);
@@ -90,6 +91,18 @@ struct gpio_bank {
 #define BANK_USED(bank) (bank->mod_usage || bank->irq_usage)
 #define LINE_USED(line, offset) (line & (1 << offset))
 
+static void _aggressive_pm_runtime_get_sync(struct gpio_bank *bank)
+{
+	if (bank->is_aggressive_pm)
+		pm_runtime_get_sync(bank->dev);
+}
+
+static void _aggressive_pm_runtime_put(struct gpio_bank *bank)
+{
+	if (bank->is_aggressive_pm)
+		pm_runtime_put(bank->dev);
+}
+
 static int irq_to_gpio(struct gpio_bank *bank, unsigned int gpio_irq)
 {
 	return bank->chip.base + gpio_irq;
@@ -473,8 +486,13 @@ static void _disable_gpio_module(struct gpio_bank *bank, unsigned offset)
 static int gpio_is_input(struct gpio_bank *bank, int mask)
 {
 	void __iomem *reg = bank->base + bank->regs->direction;
+	u32 val;
 
-	return __raw_readl(reg) & mask;
+	_aggressive_pm_runtime_get_sync(bank);
+	val = __raw_readl(reg) & mask;
+	_aggressive_pm_runtime_put(bank);
+
+	return val;
 }
 
 static int gpio_irq_type(struct irq_data *d, unsigned type)
@@ -485,7 +503,7 @@ static int gpio_irq_type(struct irq_data *d, unsigned type)
 	unsigned long flags;
 	unsigned offset;
 
-	if (!BANK_USED(bank))
+	if (!BANK_USED(bank) && !bank->is_aggressive_pm)
 		pm_runtime_get_sync(bank->dev);
 
 #ifdef CONFIG_ARCH_OMAP1
@@ -503,6 +521,7 @@ static int gpio_irq_type(struct irq_data *d, unsigned type)
 		(type & (IRQ_TYPE_LEVEL_LOW|IRQ_TYPE_LEVEL_HIGH)))
 		return -EINVAL;
 
+	_aggressive_pm_runtime_get_sync(bank);
 	spin_lock_irqsave(&bank->lock, flags);
 	offset = GPIO_INDEX(bank, gpio);
 	retval = _set_gpio_triggering(bank, offset, type);
@@ -511,11 +530,13 @@ static int gpio_irq_type(struct irq_data *d, unsigned type)
 		_set_gpio_direction(bank, offset, 1);
 	} else if (!gpio_is_input(bank, 1 << offset)) {
 		spin_unlock_irqrestore(&bank->lock, flags);
+		_aggressive_pm_runtime_put(bank);
 		return -EINVAL;
 	}
 
 	bank->irq_usage |= 1 << GPIO_INDEX(bank, gpio);
 	spin_unlock_irqrestore(&bank->lock, flags);
+	_aggressive_pm_runtime_put(bank);
 
 	if (type & (IRQ_TYPE_LEVEL_LOW | IRQ_TYPE_LEVEL_HIGH))
 		__irq_set_handler_locked(d->irq, handle_level_irq);
@@ -668,10 +689,11 @@ static int omap_gpio_request(struct gpio_chip *chip, unsigned offset)
 	unsigned long flags;
 
 	/*
-	 * If this is the first gpio_request for the bank,
-	 * enable the bank module.
+	 * if aggressive runtime pm is supported, enable the bank module
+	 * for each gpio_request. Otherwise enable the bank module if this
+	 * is the first gpio_request for the bank.
 	 */
-	if (!BANK_USED(bank))
+	if (bank->is_aggressive_pm || !BANK_USED(bank))
 		pm_runtime_get_sync(bank->dev);
 
 	spin_lock_irqsave(&bank->lock, flags);
@@ -685,7 +707,7 @@ static int omap_gpio_request(struct gpio_chip *chip, unsigned offset)
 	}
 	bank->mod_usage |= 1 << offset;
 	spin_unlock_irqrestore(&bank->lock, flags);
-
+	_aggressive_pm_runtime_put(bank);
 	return 0;
 }
 
@@ -694,6 +716,8 @@ static void omap_gpio_free(struct gpio_chip *chip, unsigned offset)
 	struct gpio_bank *bank = container_of(chip, struct gpio_bank, chip);
 	unsigned long flags;
 
+	_aggressive_pm_runtime_get_sync(bank);
+
 	spin_lock_irqsave(&bank->lock, flags);
 	bank->mod_usage &= ~(1 << offset);
 	_disable_gpio_module(bank, offset);
@@ -701,10 +725,11 @@ static void omap_gpio_free(struct gpio_chip *chip, unsigned offset)
 	spin_unlock_irqrestore(&bank->lock, flags);
 
 	/*
-	 * If this is the last gpio to be freed in the bank,
-	 * disable the bank module.
+	 * if aggressive runtime pm is supported, disable the bank module
+	 * for each gpio_free. Otherwise disable the bank module if this
+	 * is the last gpio to be freed in the bank.
 	 */
-	if (!BANK_USED(bank))
+	if (bank->is_aggressive_pm || !BANK_USED(bank))
 		pm_runtime_put(bank->dev);
 }
 
@@ -796,17 +821,18 @@ static void gpio_irq_shutdown(struct irq_data *d)
 	unsigned long flags;
 	unsigned offset = GPIO_INDEX(bank, gpio);
 
+	_aggressive_pm_runtime_get_sync(bank);
 	spin_lock_irqsave(&bank->lock, flags);
 	bank->irq_usage &= ~(1 << offset);
 	_disable_gpio_module(bank, offset);
 	_reset_gpio(bank, gpio);
 	spin_unlock_irqrestore(&bank->lock, flags);
-
 	/*
-	 * If this is the last IRQ to be freed in the bank,
-	 * disable the bank module.
+	 * if aggressive runtime pm is supported, disable the bank module
+	 * for each irq_shutdown. Otherwise disable the bank module if this
+	 * is the last IRQ to be freed in the bank.
 	 */
-	if (!BANK_USED(bank))
+	if (bank->is_aggressive_pm || !BANK_USED(bank))
 		pm_runtime_put(bank->dev);
 }
 
@@ -815,7 +841,9 @@ static void gpio_ack_irq(struct irq_data *d)
 	struct gpio_bank *bank = irq_data_get_irq_chip_data(d);
 	unsigned int gpio = irq_to_gpio(bank, d->hwirq);
 
+	_aggressive_pm_runtime_get_sync(bank);
 	_clear_gpio_irqstatus(bank, gpio);
+	_aggressive_pm_runtime_put(bank);
 }
 
 static void gpio_mask_irq(struct irq_data *d)
@@ -824,10 +852,12 @@ static void gpio_mask_irq(struct irq_data *d)
 	unsigned int gpio = irq_to_gpio(bank, d->hwirq);
 	unsigned long flags;
 
+	_aggressive_pm_runtime_get_sync(bank);
 	spin_lock_irqsave(&bank->lock, flags);
 	_set_gpio_irqenable(bank, gpio, 0);
 	_set_gpio_triggering(bank, GPIO_INDEX(bank, gpio), IRQ_TYPE_NONE);
 	spin_unlock_irqrestore(&bank->lock, flags);
+	_aggressive_pm_runtime_put(bank);
 }
 
 static void gpio_unmask_irq(struct irq_data *d)
@@ -838,6 +868,7 @@ static void gpio_unmask_irq(struct irq_data *d)
 	u32 trigger = irqd_get_trigger_type(d);
 	unsigned long flags;
 
+	_aggressive_pm_runtime_get_sync(bank);
 	spin_lock_irqsave(&bank->lock, flags);
 	if (trigger)
 		_set_gpio_triggering(bank, GPIO_INDEX(bank, gpio), trigger);
@@ -851,6 +882,7 @@ static void gpio_unmask_irq(struct irq_data *d)
 
 	_set_gpio_irqenable(bank, gpio, 1);
 	spin_unlock_irqrestore(&bank->lock, flags);
+	_aggressive_pm_runtime_put(bank);
 }
 
 static struct irq_chip gpio_irq_chip = {
@@ -933,9 +965,13 @@ static int gpio_input(struct gpio_chip *chip, unsigned offset)
 	unsigned long flags;
 
 	bank = container_of(chip, struct gpio_bank, chip);
+
+	_aggressive_pm_runtime_get_sync(bank);
 	spin_lock_irqsave(&bank->lock, flags);
 	_set_gpio_direction(bank, offset, 1);
 	spin_unlock_irqrestore(&bank->lock, flags);
+	_aggressive_pm_runtime_put(bank);
+
 	return 0;
 }
 
@@ -944,13 +980,18 @@ static int gpio_get(struct gpio_chip *chip, unsigned offset)
 	struct gpio_bank *bank;
 	u32 mask;
 
+	int val;
 	bank = container_of(chip, struct gpio_bank, chip);
 	mask = (1 << offset);
 
+	_aggressive_pm_runtime_get_sync(bank);
 	if (gpio_is_input(bank, mask))
-		return _get_gpio_datain(bank, offset);
+		val = _get_gpio_datain(bank, offset);
 	else
-		return _get_gpio_dataout(bank, offset);
+		val = _get_gpio_dataout(bank, offset);
+	_aggressive_pm_runtime_put(bank);
+
+	return val;
 }
 
 static int gpio_output(struct gpio_chip *chip, unsigned offset, int value)
@@ -960,6 +1001,8 @@ static int gpio_output(struct gpio_chip *chip, unsigned offset, int value)
 	int retval = 0;
 
 	bank = container_of(chip, struct gpio_bank, chip);
+
+	_aggressive_pm_runtime_get_sync(bank);
 	spin_lock_irqsave(&bank->lock, flags);
 
 	if (LINE_USED(bank->irq_usage, offset)) {
@@ -972,6 +1015,8 @@ static int gpio_output(struct gpio_chip *chip, unsigned offset, int value)
 
 exit:
 	spin_unlock_irqrestore(&bank->lock, flags);
+	_aggressive_pm_runtime_put(bank);
+
 	return retval;
 }
 
@@ -983,9 +1028,11 @@ static int gpio_debounce(struct gpio_chip *chip, unsigned offset,
 
 	bank = container_of(chip, struct gpio_bank, chip);
 
+	_aggressive_pm_runtime_get_sync(bank);
 	spin_lock_irqsave(&bank->lock, flags);
 	_set_gpio_debounce(bank, offset, debounce);
 	spin_unlock_irqrestore(&bank->lock, flags);
+	_aggressive_pm_runtime_put(bank);
 
 	return 0;
 }
@@ -996,9 +1043,12 @@ static void gpio_set(struct gpio_chip *chip, unsigned offset, int value)
 	unsigned long flags;
 
 	bank = container_of(chip, struct gpio_bank, chip);
+
+	_aggressive_pm_runtime_get_sync(bank);
 	spin_lock_irqsave(&bank->lock, flags);
 	bank->set_dataout(bank, offset, value);
 	spin_unlock_irqrestore(&bank->lock, flags);
+	_aggressive_pm_runtime_put(bank);
 }
 
 /*---------------------------------------------------------------------*/
@@ -1168,6 +1218,7 @@ static int omap_gpio_probe(struct platform_device *pdev)
 	bank->is_mpuio = pdata->is_mpuio;
 	bank->non_wakeup_gpios = pdata->non_wakeup_gpios;
 	bank->regs = pdata->regs;
+	bank->is_aggressive_pm = pdata->is_aggressive_pm;
 #ifdef CONFIG_OF_GPIO
 	bank->chip.of_node = of_node_get(node);
 #endif
@@ -1449,7 +1500,8 @@ void omap2_gpio_prepare_for_idle(int pwr_mode)
 
 		bank->power_mode = pwr_mode;
 
-		pm_runtime_put_sync_suspend(bank->dev);
+		if (!pm_runtime_suspended(bank->dev))
+			pm_runtime_suspend(bank->dev);
 	}
 }
 
@@ -1461,7 +1513,8 @@ void omap2_gpio_resume_after_idle(void)
 		if (!BANK_USED(bank) || !bank->loses_context)
 			continue;
 
-		pm_runtime_get_sync(bank->dev);
+		if (pm_runtime_suspended(bank->dev))
+			pm_runtime_resume(bank->dev);
 	}
 }
 
@@ -1585,18 +1638,21 @@ static const struct omap_gpio_platform_data omap2_pdata = {
 	.regs = &omap2_gpio_regs,
 	.bank_width = 32,
 	.dbck_flag = false,
+	.is_aggressive_pm = false,
 };
 
 static const struct omap_gpio_platform_data omap3_pdata = {
 	.regs = &omap2_gpio_regs,
 	.bank_width = 32,
 	.dbck_flag = true,
+	.is_aggressive_pm = false,
 };
 
 static const struct omap_gpio_platform_data omap4_pdata = {
 	.regs = &omap4_gpio_regs,
 	.bank_width = 32,
 	.dbck_flag = true,
+	.is_aggressive_pm = true,
 };
 
 static const struct of_device_id omap_gpio_match[] = {
diff --git a/include/linux/platform_data/gpio-omap.h b/include/linux/platform_data/gpio-omap.h
index 5d50b25..bb033b1 100644
--- a/include/linux/platform_data/gpio-omap.h
+++ b/include/linux/platform_data/gpio-omap.h
@@ -200,6 +200,7 @@ struct omap_gpio_platform_data {
 	bool dbck_flag;		/* dbck required or not - True for OMAP3&4 */
 	bool loses_context;	/* whether the bank would ever lose context */
 	bool is_mpuio;		/* whether the bank is of type MPUIO */
+	bool is_aggressive_pm; /* whether aggressive runtime pm is supported*/
 	u32 non_wakeup_gpios;
 
 	struct omap_gpio_reg_offs *regs;
-- 
1.7.9.5

