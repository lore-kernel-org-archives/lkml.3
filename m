Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756762Ab3JJPq5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 11:46:57 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52755 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756725Ab3JJPqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 11:46:54 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 094/104] gpio/omap: maintain GPIO and IRQ usage separately
Date: Thu, 10 Oct 2013 08:42:22 -0700
Message-Id: <1381419752-29733-95-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1381419752-29733-1-git-send-email-kamal@canonical.com>
References: <1381419752-29733-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>

commit fa365e4d729065b5e85165df3dc9699ed47489cc upstream.

The GPIO OMAP controller pins can be used as IRQ and GPIO
independently so is necessary to keep track GPIO pins and
IRQ lines usage separately to make sure that the bank will
always be enabled while being used.

Also move gpio_is_input() definition in preparation for the
next patch that setups the controller's irq_chip driver when
a caller requests an interrupt line.

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
[ kamal: backport to 3.8 (context) ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>

Conflicts:
	drivers/gpio/gpio-omap.c
---
 drivers/gpio/gpio-omap.c | 36 +++++++++++++++++++++++-------------
 1 file changed, 23 insertions(+), 13 deletions(-)

diff --git a/drivers/gpio/gpio-omap.c b/drivers/gpio/gpio-omap.c
index f1fbedb2..343fc2f 100644
--- a/drivers/gpio/gpio-omap.c
+++ b/drivers/gpio/gpio-omap.c
@@ -65,6 +65,7 @@ struct gpio_bank {
 	struct gpio_chip chip;
 	struct clk *dbck;
 	u32 mod_usage;
+	u32 irq_usage;
 	u32 dbck_enable_mask;
 	bool dbck_enabled;
 	struct device *dev;
@@ -87,6 +88,9 @@ struct gpio_bank {
 #define GPIO_BIT(bank, gpio) (1 << GPIO_INDEX(bank, gpio))
 #define GPIO_MOD_CTRL_BIT	BIT(0)
 
+#define BANK_USED(bank) (bank->mod_usage || bank->irq_usage)
+#define LINE_USED(line, offset) (line & (1 << offset))
+
 static int irq_to_gpio(struct gpio_bank *bank, unsigned int gpio_irq)
 {
 	return gpio_irq - bank->irq_base + bank->chip.base;
@@ -414,6 +418,13 @@ static int _set_gpio_triggering(struct gpio_bank *bank, int gpio,
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
@@ -421,6 +432,9 @@ static int gpio_irq_type(struct irq_data *d, unsigned type)
 	int retval;
 	unsigned long flags;
 
+	if (WARN_ON(!BANK_USED(bank)))
+		return -EINVAL;
+
 #ifdef CONFIG_ARCH_OMAP1
 	if (d->irq > IH_MPUIO_BASE)
 		gpio = OMAP_MPUIO(d->irq - IH_MPUIO_BASE);
@@ -438,6 +452,7 @@ static int gpio_irq_type(struct irq_data *d, unsigned type)
 
 	spin_lock_irqsave(&bank->lock, flags);
 	retval = _set_gpio_triggering(bank, GPIO_INDEX(bank, gpio), type);
+	bank->irq_usage |= 1 << GPIO_INDEX(bank, gpio);
 	spin_unlock_irqrestore(&bank->lock, flags);
 
 	if (type & (IRQ_TYPE_LEVEL_LOW | IRQ_TYPE_LEVEL_HIGH))
@@ -594,7 +609,7 @@ static int omap_gpio_request(struct gpio_chip *chip, unsigned offset)
 	 * If this is the first gpio_request for the bank,
 	 * enable the bank module.
 	 */
-	if (!bank->mod_usage)
+	if (!BANK_USED(bank))
 		pm_runtime_get_sync(bank->dev);
 
 	spin_lock_irqsave(&bank->lock, flags);
@@ -610,7 +625,7 @@ static int omap_gpio_request(struct gpio_chip *chip, unsigned offset)
 		__raw_writel(__raw_readl(reg) | (1 << offset), reg);
 	}
 
-	if (bank->regs->ctrl && !bank->mod_usage) {
+	if (bank->regs->ctrl && !BANK_USED(bank)) {
 		void __iomem *reg = bank->base + bank->regs->ctrl;
 		u32 ctrl;
 
@@ -645,7 +660,7 @@ static void omap_gpio_free(struct gpio_chip *chip, unsigned offset)
 
 	bank->mod_usage &= ~(1 << offset);
 
-	if (bank->regs->ctrl && !bank->mod_usage) {
+	if (bank->regs->ctrl && !BANK_USED(bank)) {
 		void __iomem *reg = bank->base + bank->regs->ctrl;
 		u32 ctrl;
 
@@ -663,7 +678,7 @@ static void omap_gpio_free(struct gpio_chip *chip, unsigned offset)
 	 * If this is the last gpio to be freed in the bank,
 	 * disable the bank module.
 	 */
-	if (!bank->mod_usage)
+	if (!BANK_USED(bank))
 		pm_runtime_put(bank->dev);
 }
 
@@ -758,8 +773,10 @@ static void gpio_irq_shutdown(struct irq_data *d)
 	struct gpio_bank *bank = irq_data_get_irq_chip_data(d);
 	unsigned int gpio = irq_to_gpio(bank, d->irq);
 	unsigned long flags;
+	unsigned offset = GPIO_INDEX(bank, gpio);
 
 	spin_lock_irqsave(&bank->lock, flags);
+	bank->irq_usage &= ~(1 << offset);
 	_reset_gpio(bank, gpio);
 	spin_unlock_irqrestore(&bank->lock, flags);
 }
@@ -893,13 +910,6 @@ static int gpio_input(struct gpio_chip *chip, unsigned offset)
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
@@ -1363,7 +1373,7 @@ void omap2_gpio_prepare_for_idle(int pwr_mode)
 	struct gpio_bank *bank;
 
 	list_for_each_entry(bank, &omap_gpio_list, node) {
-		if (!bank->mod_usage || !bank->loses_context)
+		if (!BANK_USED(bank) || !bank->loses_context)
 			continue;
 
 		bank->power_mode = pwr_mode;
@@ -1377,7 +1387,7 @@ void omap2_gpio_resume_after_idle(void)
 	struct gpio_bank *bank;
 
 	list_for_each_entry(bank, &omap_gpio_list, node) {
-		if (!bank->mod_usage || !bank->loses_context)
+		if (!BANK_USED(bank) || !bank->loses_context)
 			continue;
 
 		pm_runtime_get_sync(bank->dev);
-- 
1.8.1.2

