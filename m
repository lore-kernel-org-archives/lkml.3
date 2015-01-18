Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752750AbbARLkj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 06:40:39 -0500
Received: from mail-lb0-f170.google.com ([209.85.217.170]:49222 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608AbbARLkA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 06:40:00 -0500
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Peter Korsgaard <jacmet@sunsite.dk>
Subject: [PATCH 8/8] gpio/mpc8xxx: Use of_mm_gpiochip_remove
Date: Sun, 18 Jan 2015 12:39:33 +0100
Message-Id: <1421581173-28416-9-git-send-email-ricardo.ribalda@gmail.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421581173-28416-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1421581173-28416-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since d621e8bae5ac9c67 (Create of_mm_gpiochip_remove), there is a
counterpart for of_mm_gpiochip_add.

This patch implements the remove function of the driver making use of
it.

Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Alexandre Courbot <gnurou@gmail.com>
Cc: Peter Korsgaard <jacmet@sunsite.dk>
Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/gpio/gpio-mpc8xxx.c | 28 +++++++++++++++++++++++-----
 1 file changed, 23 insertions(+), 5 deletions(-)

diff --git a/drivers/gpio/gpio-mpc8xxx.c b/drivers/gpio/gpio-mpc8xxx.c
index 57eb794..a6952ba3 100644
--- a/drivers/gpio/gpio-mpc8xxx.c
+++ b/drivers/gpio/gpio-mpc8xxx.c
@@ -40,6 +40,7 @@ struct mpc8xxx_gpio_chip {
 	 */
 	u32 data;
 	struct irq_domain *irq;
+	unsigned int irqn;
 	const void *of_dev_id_data;
 };
 
@@ -350,13 +351,14 @@ static int mpc8xxx_probe(struct platform_device *pdev)
 	struct of_mm_gpio_chip *mm_gc;
 	struct gpio_chip *gc;
 	const struct of_device_id *id;
-	unsigned hwirq;
 	int ret;
 
 	mpc8xxx_gc = devm_kzalloc(&pdev->dev, sizeof(*mpc8xxx_gc), GFP_KERNEL);
 	if (!mpc8xxx_gc)
 		return -ENOMEM;
 
+	platform_set_drvdata(pdev, mpc8xxx_gc);
+
 	spin_lock_init(&mpc8xxx_gc->lock);
 
 	mm_gc = &mpc8xxx_gc->mm_gc;
@@ -377,8 +379,8 @@ static int mpc8xxx_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
-	hwirq = irq_of_parse_and_map(np, 0);
-	if (hwirq == NO_IRQ)
+	mpc8xxx_gc->irqn = irq_of_parse_and_map(np, 0);
+	if (mpc8xxx_gc->irqn == NO_IRQ)
 		return 0;
 
 	mpc8xxx_gc->irq = irq_domain_add_linear(np, MPC8XXX_GPIO_PINS,
@@ -394,14 +396,30 @@ static int mpc8xxx_probe(struct platform_device *pdev)
 	out_be32(mm_gc->regs + GPIO_IER, 0xffffffff);
 	out_be32(mm_gc->regs + GPIO_IMR, 0);
 
-	irq_set_handler_data(hwirq, mpc8xxx_gc);
-	irq_set_chained_handler(hwirq, mpc8xxx_gpio_irq_cascade);
+	irq_set_handler_data(mpc8xxx_gc->irqn, mpc8xxx_gc);
+	irq_set_chained_handler(mpc8xxx_gc->irqn, mpc8xxx_gpio_irq_cascade);
+
+	return 0;
+}
+
+static int mpc8xxx_remove(struct platform_device *pdev)
+{
+	struct mpc8xxx_gpio_chip *mpc8xxx_gc = platform_get_drvdata(pdev);
+
+	if (mpc8xxx_gc->irq) {
+		irq_set_handler_data(mpc8xxx_gc->irqn, NULL);
+		irq_set_chained_handler(mpc8xxx_gc->irqn, NULL);
+		irq_domain_remove(mpc8xxx_gc->irq);
+	}
+
+	of_mm_gpiochip_remove(&mpc8xxx_gc->mm_gc);
 
 	return 0;
 }
 
 static struct platform_driver mpc8xxx_plat_driver = {
 	.probe		= mpc8xxx_probe,
+	.remove		= mpc8xxx_remove,
 	.driver		= {
 		.name = "gpio-mpc8xxx",
 		.of_match_table	= mpc8xxx_gpio_ids,
-- 
2.1.4

