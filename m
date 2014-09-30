Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755395AbaI3Ipm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 04:45:42 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:58396 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752308AbaI3IpN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 04:45:13 -0400
From: Linus Walleij <linus.walleij@linaro.org>
To: linux-kernel@vger.kernel.org, Barry Song <Baohua.Song@csr.com>,
        Barry Song <baohua@kernel.org>
Cc: linux-gpio@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] RESEND RFT: pinctrl: sirf: move sgpio lock into state container
Date: Tue, 30 Sep 2014 10:45:04 +0200
Message-Id: <1412066704-28633-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of referring to a global static variable for the sgpio
locking, use the state container to contain the lock.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
Barry, did you get around to testing this patch?
---
 drivers/pinctrl/sirf/pinctrl-sirf.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/pinctrl/sirf/pinctrl-sirf.c b/drivers/pinctrl/sirf/pinctrl-sirf.c
index 4c1d7c68666d..3ac7848a8551 100644
--- a/drivers/pinctrl/sirf/pinctrl-sirf.c
+++ b/drivers/pinctrl/sirf/pinctrl-sirf.c
@@ -40,10 +40,9 @@ struct sirfsoc_gpio_chip {
 	struct of_mm_gpio_chip chip;
 	bool is_marco; /* for marco, some registers are different with prima2 */
 	struct sirfsoc_gpio_bank sgpio_bank[SIRFSOC_GPIO_NO_OF_BANKS];
+	spinlock_t lock;
 };
 
-static DEFINE_SPINLOCK(sgpio_lock);
-
 static struct sirfsoc_pin_group *sirfsoc_pin_groups;
 static int sirfsoc_pingrp_cnt;
 
@@ -440,13 +439,13 @@ static void sirfsoc_gpio_irq_ack(struct irq_data *d)
 
 	offset = SIRFSOC_GPIO_CTRL(bank->id, idx);
 
-	spin_lock_irqsave(&sgpio_lock, flags);
+	spin_lock_irqsave(&sgpio->lock, flags);
 
 	val = readl(sgpio->chip.regs + offset);
 
 	writel(val, sgpio->chip.regs + offset);
 
-	spin_unlock_irqrestore(&sgpio_lock, flags);
+	spin_unlock_irqrestore(&sgpio->lock, flags);
 }
 
 static void __sirfsoc_gpio_irq_mask(struct sirfsoc_gpio_chip *sgpio,
@@ -458,14 +457,14 @@ static void __sirfsoc_gpio_irq_mask(struct sirfsoc_gpio_chip *sgpio,
 
 	offset = SIRFSOC_GPIO_CTRL(bank->id, idx);
 
-	spin_lock_irqsave(&sgpio_lock, flags);
+	spin_lock_irqsave(&sgpio->lock, flags);
 
 	val = readl(sgpio->chip.regs + offset);
 	val &= ~SIRFSOC_GPIO_CTL_INTR_EN_MASK;
 	val &= ~SIRFSOC_GPIO_CTL_INTR_STS_MASK;
 	writel(val, sgpio->chip.regs + offset);
 
-	spin_unlock_irqrestore(&sgpio_lock, flags);
+	spin_unlock_irqrestore(&sgpio->lock, flags);
 }
 
 static void sirfsoc_gpio_irq_mask(struct irq_data *d)
@@ -488,14 +487,14 @@ static void sirfsoc_gpio_irq_unmask(struct irq_data *d)
 
 	offset = SIRFSOC_GPIO_CTRL(bank->id, idx);
 
-	spin_lock_irqsave(&sgpio_lock, flags);
+	spin_lock_irqsave(&sgpio->lock, flags);
 
 	val = readl(sgpio->chip.regs + offset);
 	val &= ~SIRFSOC_GPIO_CTL_INTR_STS_MASK;
 	val |= SIRFSOC_GPIO_CTL_INTR_EN_MASK;
 	writel(val, sgpio->chip.regs + offset);
 
-	spin_unlock_irqrestore(&sgpio_lock, flags);
+	spin_unlock_irqrestore(&sgpio->lock, flags);
 }
 
 static int sirfsoc_gpio_irq_type(struct irq_data *d, unsigned type)
@@ -509,7 +508,7 @@ static int sirfsoc_gpio_irq_type(struct irq_data *d, unsigned type)
 
 	offset = SIRFSOC_GPIO_CTRL(bank->id, idx);
 
-	spin_lock_irqsave(&sgpio_lock, flags);
+	spin_lock_irqsave(&sgpio->lock, flags);
 
 	val = readl(sgpio->chip.regs + offset);
 	val &= ~(SIRFSOC_GPIO_CTL_INTR_STS_MASK | SIRFSOC_GPIO_CTL_OUT_EN_MASK);
@@ -541,7 +540,7 @@ static int sirfsoc_gpio_irq_type(struct irq_data *d, unsigned type)
 
 	writel(val, sgpio->chip.regs + offset);
 
-	spin_unlock_irqrestore(&sgpio_lock, flags);
+	spin_unlock_irqrestore(&sgpio->lock, flags);
 
 	return 0;
 }
@@ -704,11 +703,11 @@ static int sirfsoc_gpio_direction_output(struct gpio_chip *chip, unsigned gpio,
 
 	offset = SIRFSOC_GPIO_CTRL(bank->id, idx);
 
-	spin_lock_irqsave(&sgpio_lock, flags);
+	spin_lock_irqsave(&sgpio->lock, flags);
 
 	sirfsoc_gpio_set_output(sgpio, bank, offset, value);
 
-	spin_unlock_irqrestore(&sgpio_lock, flags);
+	spin_unlock_irqrestore(&sgpio->lock, flags);
 
 	return 0;
 }
@@ -801,6 +800,7 @@ static int sirfsoc_gpio_probe(struct device_node *np)
 	sgpio = devm_kzalloc(&pdev->dev, sizeof(*sgpio), GFP_KERNEL);
 	if (!sgpio)
 		return -ENOMEM;
+	spin_lock_init(&sgpio->lock);
 
 	regs = of_iomap(np, 0);
 	if (!regs)
-- 
1.9.3

