Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754111AbaAVANb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 19:13:31 -0500
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:24305 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752191AbaAVAN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 19:13:28 -0500
X-IronPort-AV: E=Sophos;i="4.95,697,1384329600"; 
   d="scan'208";a="10335351"
From: Markus Mayer <markus.mayer@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
CC: Linaro Patches <patches@linaro.org>,
        Linux GPIO List <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Tim Kryger <tim.kryger@linaro.org>,
        Markus Mayer <markus.mayer@linaro.org>
Subject: [PATCH] gpio: bcm281xx: Centralize register locking
Date: Tue, 21 Jan 2014 16:10:41 -0800
Message-ID: <1390349441-23853-1-git-send-email-markus.mayer@linaro.org>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rather than unlock/re-lock for every write access, unlock a GPIO when
it is requested and re-lock it when it is freed. As a result, the GPIO
helper functions no longer have to deal with unlocking and re-locking
the register.

In addition, only unlock a specific GPIO rather than unlocking the
entire GPIO bank as before.

Signed-off-by: Markus Mayer <markus.mayer@linaro.org>
Reviewed-by: Tim Kryger <tim.kryger@linaro.org>
---
 drivers/gpio/gpio-bcm-kona.c |   82 +++++++++++++++++++++++++-----------------
 1 file changed, 49 insertions(+), 33 deletions(-)

diff --git a/drivers/gpio/gpio-bcm-kona.c b/drivers/gpio/gpio-bcm-kona.c
index 233d088..3e51b62 100644
--- a/drivers/gpio/gpio-bcm-kona.c
+++ b/drivers/gpio/gpio-bcm-kona.c
@@ -80,22 +80,43 @@ static inline struct bcm_kona_gpio *to_kona_gpio(struct gpio_chip *chip)
 	return container_of(chip, struct bcm_kona_gpio, gpio_chip);
 }
 
-static void bcm_kona_gpio_set_lockcode_bank(void __iomem *reg_base,
-					    int bank_id, int lockcode)
+static inline void bcm_kona_gpio_write_lock_regs(void __iomem *reg_base,
+						int bank_id, u32 lockcode)
 {
 	writel(BCM_GPIO_PASSWD, reg_base + GPIO_GPPWR_OFFSET);
 	writel(lockcode, reg_base + GPIO_PWD_STATUS(bank_id));
 }
 
-static inline void bcm_kona_gpio_lock_bank(void __iomem *reg_base, int bank_id)
+static void bcm_kona_gpio_lock_gpio(struct bcm_kona_gpio *kona_gpio,
+					unsigned gpio)
 {
-	bcm_kona_gpio_set_lockcode_bank(reg_base, bank_id, LOCK_CODE);
+	u32 val;
+	unsigned long flags;
+	int bank_id = GPIO_BANK(gpio);
+
+	spin_lock_irqsave(&kona_gpio->lock, flags);
+
+	val = readl(kona_gpio->reg_base + GPIO_PWD_STATUS(bank_id));
+	val |= BIT(gpio);
+	bcm_kona_gpio_write_lock_regs(kona_gpio->reg_base, bank_id, val);
+
+	spin_unlock_irqrestore(&kona_gpio->lock, flags);
 }
 
-static inline void bcm_kona_gpio_unlock_bank(void __iomem *reg_base,
-					     int bank_id)
+static void bcm_kona_gpio_unlock_gpio(struct bcm_kona_gpio *kona_gpio,
+					unsigned gpio)
 {
-	bcm_kona_gpio_set_lockcode_bank(reg_base, bank_id, UNLOCK_CODE);
+	u32 val;
+	unsigned long flags;
+	int bank_id = GPIO_BANK(gpio);
+
+	spin_lock_irqsave(&kona_gpio->lock, flags);
+
+	val = readl(kona_gpio->reg_base + GPIO_PWD_STATUS(bank_id));
+	val &= ~BIT(gpio);
+	bcm_kona_gpio_write_lock_regs(kona_gpio->reg_base, bank_id, val);
+
+	spin_unlock_irqrestore(&kona_gpio->lock, flags);
 }
 
 static void bcm_kona_gpio_set(struct gpio_chip *chip, unsigned gpio, int value)
@@ -110,7 +131,6 @@ static void bcm_kona_gpio_set(struct gpio_chip *chip, unsigned gpio, int value)
 	kona_gpio = to_kona_gpio(chip);
 	reg_base = kona_gpio->reg_base;
 	spin_lock_irqsave(&kona_gpio->lock, flags);
-	bcm_kona_gpio_unlock_bank(reg_base, bank_id);
 
 	/* determine the GPIO pin direction */
 	val = readl(reg_base + GPIO_CONTROL(gpio));
@@ -127,7 +147,6 @@ static void bcm_kona_gpio_set(struct gpio_chip *chip, unsigned gpio, int value)
 	writel(val, reg_base + reg_offset);
 
 out:
-	bcm_kona_gpio_lock_bank(reg_base, bank_id);
 	spin_unlock_irqrestore(&kona_gpio->lock, flags);
 }
 
@@ -143,7 +162,6 @@ static int bcm_kona_gpio_get(struct gpio_chip *chip, unsigned gpio)
 	kona_gpio = to_kona_gpio(chip);
 	reg_base = kona_gpio->reg_base;
 	spin_lock_irqsave(&kona_gpio->lock, flags);
-	bcm_kona_gpio_unlock_bank(reg_base, bank_id);
 
 	/* determine the GPIO pin direction */
 	val = readl(reg_base + GPIO_CONTROL(gpio));
@@ -154,32 +172,43 @@ static int bcm_kona_gpio_get(struct gpio_chip *chip, unsigned gpio)
 	    GPIO_IN_STATUS(bank_id) : GPIO_OUT_STATUS(bank_id);
 	val = readl(reg_base + reg_offset);
 
-	bcm_kona_gpio_lock_bank(reg_base, bank_id);
 	spin_unlock_irqrestore(&kona_gpio->lock, flags);
 
 	/* return the specified bit status */
 	return !!(val & BIT(bit));
 }
 
+static int bcm_kona_gpio_request(struct gpio_chip *chip, unsigned gpio)
+{
+	struct bcm_kona_gpio *kona_gpio = to_kona_gpio(chip);
+
+	bcm_kona_gpio_unlock_gpio(kona_gpio, gpio);
+	return 0;
+}
+
+static void bcm_kona_gpio_free(struct gpio_chip *chip, unsigned gpio)
+{
+	struct bcm_kona_gpio *kona_gpio = to_kona_gpio(chip);
+
+	bcm_kona_gpio_lock_gpio(kona_gpio, gpio);
+}
+
 static int bcm_kona_gpio_direction_input(struct gpio_chip *chip, unsigned gpio)
 {
 	struct bcm_kona_gpio *kona_gpio;
 	void __iomem *reg_base;
 	u32 val;
 	unsigned long flags;
-	int bank_id = GPIO_BANK(gpio);
 
 	kona_gpio = to_kona_gpio(chip);
 	reg_base = kona_gpio->reg_base;
 	spin_lock_irqsave(&kona_gpio->lock, flags);
-	bcm_kona_gpio_unlock_bank(reg_base, bank_id);
 
 	val = readl(reg_base + GPIO_CONTROL(gpio));
 	val &= ~GPIO_GPCTR0_IOTR_MASK;
 	val |= GPIO_GPCTR0_IOTR_CMD_INPUT;
 	writel(val, reg_base + GPIO_CONTROL(gpio));
 
-	bcm_kona_gpio_lock_bank(reg_base, bank_id);
 	spin_unlock_irqrestore(&kona_gpio->lock, flags);
 
 	return 0;
@@ -198,7 +227,6 @@ static int bcm_kona_gpio_direction_output(struct gpio_chip *chip,
 	kona_gpio = to_kona_gpio(chip);
 	reg_base = kona_gpio->reg_base;
 	spin_lock_irqsave(&kona_gpio->lock, flags);
-	bcm_kona_gpio_unlock_bank(reg_base, bank_id);
 
 	val = readl(reg_base + GPIO_CONTROL(gpio));
 	val &= ~GPIO_GPCTR0_IOTR_MASK;
@@ -210,7 +238,6 @@ static int bcm_kona_gpio_direction_output(struct gpio_chip *chip,
 	val |= BIT(bit);
 	writel(val, reg_base + reg_offset);
 
-	bcm_kona_gpio_lock_bank(reg_base, bank_id);
 	spin_unlock_irqrestore(&kona_gpio->lock, flags);
 
 	return 0;
@@ -233,7 +260,6 @@ static int bcm_kona_gpio_set_debounce(struct gpio_chip *chip, unsigned gpio,
 	void __iomem *reg_base;
 	u32 val, res;
 	unsigned long flags;
-	int bank_id = GPIO_BANK(gpio);
 
 	kona_gpio = to_kona_gpio(chip);
 	reg_base = kona_gpio->reg_base;
@@ -257,7 +283,6 @@ static int bcm_kona_gpio_set_debounce(struct gpio_chip *chip, unsigned gpio,
 
 	/* spin lock for read-modify-write of the GPIO register */
 	spin_lock_irqsave(&kona_gpio->lock, flags);
-	bcm_kona_gpio_unlock_bank(reg_base, bank_id);
 
 	val = readl(reg_base + GPIO_CONTROL(gpio));
 	val &= ~GPIO_GPCTR0_DBR_MASK;
@@ -272,7 +297,6 @@ static int bcm_kona_gpio_set_debounce(struct gpio_chip *chip, unsigned gpio,
 
 	writel(val, reg_base + GPIO_CONTROL(gpio));
 
-	bcm_kona_gpio_lock_bank(reg_base, bank_id);
 	spin_unlock_irqrestore(&kona_gpio->lock, flags);
 
 	return 0;
@@ -281,6 +305,8 @@ static int bcm_kona_gpio_set_debounce(struct gpio_chip *chip, unsigned gpio,
 static struct gpio_chip template_chip = {
 	.label = "bcm-kona-gpio",
 	.owner = THIS_MODULE,
+	.request = bcm_kona_gpio_request,
+	.free = bcm_kona_gpio_free,
 	.direction_input = bcm_kona_gpio_direction_input,
 	.get = bcm_kona_gpio_get,
 	.direction_output = bcm_kona_gpio_direction_output,
@@ -303,13 +329,11 @@ static void bcm_kona_gpio_irq_ack(struct irq_data *d)
 	kona_gpio = irq_data_get_irq_chip_data(d);
 	reg_base = kona_gpio->reg_base;
 	spin_lock_irqsave(&kona_gpio->lock, flags);
-	bcm_kona_gpio_unlock_bank(reg_base, bank_id);
 
 	val = readl(reg_base + GPIO_INT_STATUS(bank_id));
 	val |= BIT(bit);
 	writel(val, reg_base + GPIO_INT_STATUS(bank_id));
 
-	bcm_kona_gpio_lock_bank(reg_base, bank_id);
 	spin_unlock_irqrestore(&kona_gpio->lock, flags);
 }
 
@@ -326,13 +350,11 @@ static void bcm_kona_gpio_irq_mask(struct irq_data *d)
 	kona_gpio = irq_data_get_irq_chip_data(d);
 	reg_base = kona_gpio->reg_base;
 	spin_lock_irqsave(&kona_gpio->lock, flags);
-	bcm_kona_gpio_unlock_bank(reg_base, bank_id);
 
 	val = readl(reg_base + GPIO_INT_MASK(bank_id));
 	val |= BIT(bit);
 	writel(val, reg_base + GPIO_INT_MASK(bank_id));
 
-	bcm_kona_gpio_lock_bank(reg_base, bank_id);
 	spin_unlock_irqrestore(&kona_gpio->lock, flags);
 }
 
@@ -349,13 +371,11 @@ static void bcm_kona_gpio_irq_unmask(struct irq_data *d)
 	kona_gpio = irq_data_get_irq_chip_data(d);
 	reg_base = kona_gpio->reg_base;
 	spin_lock_irqsave(&kona_gpio->lock, flags);
-	bcm_kona_gpio_unlock_bank(reg_base, bank_id);
 
 	val = readl(reg_base + GPIO_INT_MSKCLR(bank_id));
 	val |= BIT(bit);
 	writel(val, reg_base + GPIO_INT_MSKCLR(bank_id));
 
-	bcm_kona_gpio_lock_bank(reg_base, bank_id);
 	spin_unlock_irqrestore(&kona_gpio->lock, flags);
 }
 
@@ -367,7 +387,6 @@ static int bcm_kona_gpio_irq_set_type(struct irq_data *d, unsigned int type)
 	u32 lvl_type;
 	u32 val;
 	unsigned long flags;
-	int bank_id = GPIO_BANK(gpio);
 
 	kona_gpio = irq_data_get_irq_chip_data(d);
 	reg_base = kona_gpio->reg_base;
@@ -394,14 +413,12 @@ static int bcm_kona_gpio_irq_set_type(struct irq_data *d, unsigned int type)
 	}
 
 	spin_lock_irqsave(&kona_gpio->lock, flags);
-	bcm_kona_gpio_unlock_bank(reg_base, bank_id);
 
 	val = readl(reg_base + GPIO_CONTROL(gpio));
 	val &= ~GPIO_GPCTR0_ITR_MASK;
 	val |= lvl_type << GPIO_GPCTR0_ITR_SHIFT;
 	writel(val, reg_base + GPIO_CONTROL(gpio));
 
-	bcm_kona_gpio_lock_bank(reg_base, bank_id);
 	spin_unlock_irqrestore(&kona_gpio->lock, flags);
 
 	return 0;
@@ -424,7 +441,6 @@ static void bcm_kona_gpio_irq_handler(unsigned int irq, struct irq_desc *desc)
 	 */
 	reg_base = bank->kona_gpio->reg_base;
 	bank_id = bank->id;
-	bcm_kona_gpio_unlock_bank(reg_base, bank_id);
 
 	while ((sta = readl(reg_base + GPIO_INT_STATUS(bank_id)) &
 		    (~(readl(reg_base + GPIO_INT_MASK(bank_id)))))) {
@@ -444,8 +460,6 @@ static void bcm_kona_gpio_irq_handler(unsigned int irq, struct irq_desc *desc)
 		}
 	}
 
-	bcm_kona_gpio_lock_bank(reg_base, bank_id);
-
 	chained_irq_exit(chip, desc);
 }
 
@@ -531,10 +545,12 @@ static void bcm_kona_gpio_reset(struct bcm_kona_gpio *kona_gpio)
 	reg_base = kona_gpio->reg_base;
 	/* disable interrupts and clear status */
 	for (i = 0; i < kona_gpio->num_bank; i++) {
-		bcm_kona_gpio_unlock_bank(reg_base, i);
+		/* Unlock the entire bank first */
+		bcm_kona_gpio_write_lock_regs(kona_gpio, i, UNLOCK_CODE);
 		writel(0xffffffff, reg_base + GPIO_INT_MASK(i));
 		writel(0xffffffff, reg_base + GPIO_INT_STATUS(i));
-		bcm_kona_gpio_lock_bank(reg_base, i);
+		/* Now re-lock the bank */
+		bcm_kona_gpio_write_lock_regs(kona_gpio, i, LOCK_CODE);
 	}
 }
 
-- 
1.7.9.5

