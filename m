Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752956AbbARLl4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 06:41:56 -0500
Received: from mail-la0-f44.google.com ([209.85.215.44]:38612 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751580AbbARLjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 06:39:52 -0500
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH 1/8] gpio/mpc5200: Use of_mm_gpiochip_remove
Date: Sun, 18 Jan 2015 12:39:26 +0100
Message-Id: <1421581173-28416-2-git-send-email-ricardo.ribalda@gmail.com>
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
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/gpio/gpio-mpc5200.c | 23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/drivers/gpio/gpio-mpc5200.c b/drivers/gpio/gpio-mpc5200.c
index 8ce6c95..4c54215 100644
--- a/drivers/gpio/gpio-mpc5200.c
+++ b/drivers/gpio/gpio-mpc5200.c
@@ -155,10 +155,12 @@ static int mpc52xx_wkup_gpiochip_probe(struct platform_device *ofdev)
 	struct gpio_chip *gc;
 	int ret;
 
-	chip = kzalloc(sizeof(*chip), GFP_KERNEL);
+	chip = devm_kzalloc(&ofdev->dev, sizeof(*chip), GFP_KERNEL);
 	if (!chip)
 		return -ENOMEM;
 
+	platform_set_drvdata(ofdev, chip);
+
 	gc = &chip->mmchip.gc;
 
 	gc->ngpio            = 8;
@@ -181,7 +183,11 @@ static int mpc52xx_wkup_gpiochip_probe(struct platform_device *ofdev)
 
 static int mpc52xx_gpiochip_remove(struct platform_device *ofdev)
 {
-	return -EBUSY;
+	struct mpc52xx_gpiochip *chip = platform_get_drvdata(ofdev);
+
+	of_mm_gpiochip_remove(&chip->mmchip);
+
+	return 0;
 }
 
 static const struct of_device_id mpc52xx_wkup_gpiochip_match[] = {
@@ -314,10 +320,12 @@ static int mpc52xx_simple_gpiochip_probe(struct platform_device *ofdev)
 	struct mpc52xx_gpio __iomem *regs;
 	int ret;
 
-	chip = kzalloc(sizeof(*chip), GFP_KERNEL);
+	chip = devm_kzalloc(&ofdev->dev, sizeof(*chip), GFP_KERNEL);
 	if (!chip)
 		return -ENOMEM;
 
+	platform_set_drvdata(ofdev, chip);
+
 	gc = &chip->mmchip.gc;
 
 	gc->ngpio            = 32;
@@ -363,11 +371,16 @@ static int __init mpc52xx_gpio_init(void)
 	return 0;
 }
 
-
 /* Make sure we get initialised before anyone else tries to use us */
 subsys_initcall(mpc52xx_gpio_init);
 
-/* No exit call at the moment as we cannot unregister of gpio chips */
+static void __exit mpc52xx_gpio_exit(void)
+{
+	platform_driver_unregister(&mpc52xx_wkup_gpiochip_driver);
+
+	platform_driver_unregister(&mpc52xx_simple_gpiochip_driver);
+}
+module_exit(mpc52xx_gpio_exit);
 
 MODULE_DESCRIPTION("Freescale MPC52xx gpio driver");
 MODULE_AUTHOR("Sascha Hauer <s.hauer@pengutronix.de");
-- 
2.1.4

