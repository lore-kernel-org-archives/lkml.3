Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757284Ab3IYAhy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 20:37:54 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:60566 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757032Ab3IYAhu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 20:37:50 -0400
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Kevin Hilman <khilman@linaro.org>,
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
Subject: [PATCH 1/2] gpio/omap: maintain GPIO and IRQ usage separately
Date: Wed, 25 Sep 2013 02:36:52 +0200
Message-Id: <1380069414-2922-1-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 1.8.4.rc3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The GPIO OMAP controller pins can be used as IRQ and GPIO
independently so is necessary to keep track GPIO pins and
IRQ lines usage separately to make sure that the bank will
always be enabled while being used.

Also move gpio_is_input() definition in preparation for the
next patch that setups the controller's irq_chip driver when
a caller requests an interrupt line.

Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
---
 drivers/gpio/gpio-omap.c | 35 +++++++++++++++++++++--------------
 1 file changed, 21 insertions(+), 14 deletions(-)

diff --git a/drivers/gpio/gpio-omap.c b/drivers/gpio/gpio-omap.c
index 0ff4355..a4fe038 100644
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
@@ -420,6 +424,13 @@ static int _set_gpio_triggering(struct gpio_bank *bank, int gpio,
 	return 0;
 }
 
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
@@ -427,7 +438,7 @@ static int gpio_irq_type(struct irq_data *d, unsigned type)
 	int retval;
 	unsigned long flags;
 
-	if (WARN_ON(!bank->mod_usage))
+	if (WARN_ON(!BANK_USED(bank)))
 		return -EINVAL;
 
 #ifdef CONFIG_ARCH_OMAP1
@@ -447,6 +458,7 @@ static int gpio_irq_type(struct irq_data *d, unsigned type)
 
 	spin_lock_irqsave(&bank->lock, flags);
 	retval = _set_gpio_triggering(bank, GPIO_INDEX(bank, gpio), type);
+	bank->irq_usage |= 1 << GPIO_INDEX(bank, gpio);
 	spin_unlock_irqrestore(&bank->lock, flags);
 
 	if (type & (IRQ_TYPE_LEVEL_LOW | IRQ_TYPE_LEVEL_HIGH))
@@ -603,7 +615,7 @@ static int omap_gpio_request(struct gpio_chip *chip, unsigned offset)
 	 * If this is the first gpio_request for the bank,
 	 * enable the bank module.
 	 */
-	if (!bank->mod_usage)
+	if (!BANK_USED(bank))
 		pm_runtime_get_sync(bank->dev);
 
 	spin_lock_irqsave(&bank->lock, flags);
@@ -619,7 +631,7 @@ static int omap_gpio_request(struct gpio_chip *chip, unsigned offset)
 		__raw_writel(__raw_readl(reg) | (1 << offset), reg);
 	}
 
-	if (bank->regs->ctrl && !bank->mod_usage) {
+	if (bank->regs->ctrl && !BANK_USED(bank)) {
 		void __iomem *reg = bank->base + bank->regs->ctrl;
 		u32 ctrl;
 
@@ -654,7 +666,7 @@ static void omap_gpio_free(struct gpio_chip *chip, unsigned offset)
 
 	bank->mod_usage &= ~(1 << offset);
 
-	if (bank->regs->ctrl && !bank->mod_usage) {
+	if (bank->regs->ctrl && !BANK_USED(bank)) {
 		void __iomem *reg = bank->base + bank->regs->ctrl;
 		u32 ctrl;
 
@@ -672,7 +684,7 @@ static void omap_gpio_free(struct gpio_chip *chip, unsigned offset)
 	 * If this is the last gpio to be freed in the bank,
 	 * disable the bank module.
 	 */
-	if (!bank->mod_usage)
+	if (!BANK_USED(bank))
 		pm_runtime_put(bank->dev);
 }
 
@@ -762,8 +774,10 @@ static void gpio_irq_shutdown(struct irq_data *d)
 	struct gpio_bank *bank = irq_data_get_irq_chip_data(d);
 	unsigned int gpio = irq_to_gpio(bank, d->hwirq);
 	unsigned long flags;
+	unsigned offset = GPIO_INDEX(bank, gpio);
 
 	spin_lock_irqsave(&bank->lock, flags);
+	bank->irq_usage &= ~(1 << offset);
 	_reset_gpio(bank, gpio);
 	spin_unlock_irqrestore(&bank->lock, flags);
 }
@@ -897,13 +911,6 @@ static int gpio_input(struct gpio_chip *chip, unsigned offset)
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
@@ -1400,7 +1407,7 @@ void omap2_gpio_prepare_for_idle(int pwr_mode)
 	struct gpio_bank *bank;
 
 	list_for_each_entry(bank, &omap_gpio_list, node) {
-		if (!bank->mod_usage || !bank->loses_context)
+		if (!BANK_USED(bank) || !bank->loses_context)
 			continue;
 
 		bank->power_mode = pwr_mode;
@@ -1414,7 +1421,7 @@ void omap2_gpio_resume_after_idle(void)
 	struct gpio_bank *bank;
 
 	list_for_each_entry(bank, &omap_gpio_list, node) {
-		if (!bank->mod_usage || !bank->loses_context)
+		if (!BANK_USED(bank) || !bank->loses_context)
 			continue;
 
 		pm_runtime_get_sync(bank->dev);
-- 
1.8.4.rc3

