Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752486AbaGGKfM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 06:35:12 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:58745 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913AbaGGKfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 06:35:09 -0400
From: Linus Walleij <linus.walleij@linaro.org>
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        linux-kernel@vger.kernel.org
Cc: David Woodhouse <dwmw2@infradead.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH v2] power: poweroff: gpio: convert to use descriptors
Date: Mon,  7 Jul 2014 12:34:32 +0200
Message-Id: <1404729272-17873-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This switches the GPIO poweroff driver to use GPIO descriptors
rather than numeral GPIOs. We get rid of the specific inversion
handling as GPIO descriptors know if they are active low or
high and can assert the line properly, so we do not need to
check the flag OF_GPIO_ACTIVE_LOW returned from the old call
of_get_gpio_flags() anymore.

Also convert to use managed resources and use dev_* message
printing while we're at it.

Cc: Alexandre Courbot <acourbot@nvidia.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChangeLog v1->v2:
- Handled errors from devm_gpiod_get() properly with IS_ERR()
  and friends (Alexandre's review comment).
---
 drivers/power/reset/gpio-poweroff.c | 52 ++++++++++++++-----------------------
 1 file changed, 19 insertions(+), 33 deletions(-)

diff --git a/drivers/power/reset/gpio-poweroff.c b/drivers/power/reset/gpio-poweroff.c
index e290d48ddd99..ce849bc9b269 100644
--- a/drivers/power/reset/gpio-poweroff.c
+++ b/drivers/power/reset/gpio-poweroff.c
@@ -15,31 +15,29 @@
 #include <linux/init.h>
 #include <linux/delay.h>
 #include <linux/platform_device.h>
-#include <linux/gpio.h>
+#include <linux/gpio/consumer.h>
 #include <linux/of_platform.h>
-#include <linux/of_gpio.h>
 #include <linux/module.h>
 
 /*
  * Hold configuration here, cannot be more than one instance of the driver
  * since pm_power_off itself is global.
  */
-static int gpio_num = -1;
-static int gpio_active_low;
+static struct gpio_desc *reset_gpio;
 
 static void gpio_poweroff_do_poweroff(void)
 {
-	BUG_ON(!gpio_is_valid(gpio_num));
+	BUG_ON(!reset_gpio);
 
 	/* drive it active, also inactive->active edge */
-	gpio_direction_output(gpio_num, !gpio_active_low);
+	gpiod_direction_output(reset_gpio, 1);
 	mdelay(100);
 	/* drive inactive, also active->inactive edge */
-	gpio_set_value(gpio_num, gpio_active_low);
+	gpiod_set_value(reset_gpio, 0);
 	mdelay(100);
 
 	/* drive it active, also inactive->active edge */
-	gpio_set_value(gpio_num, !gpio_active_low);
+	gpiod_set_value(reset_gpio, 1);
 
 	/* give it some time */
 	mdelay(3000);
@@ -49,54 +47,42 @@ static void gpio_poweroff_do_poweroff(void)
 
 static int gpio_poweroff_probe(struct platform_device *pdev)
 {
-	enum of_gpio_flags flags;
 	bool input = false;
-	int ret;
 
 	/* If a pm_power_off function has already been added, leave it alone */
 	if (pm_power_off != NULL) {
-		pr_err("%s: pm_power_off function already registered",
+		dev_err(&pdev->dev,
+			"%s: pm_power_off function already registered",
 		       __func__);
 		return -EBUSY;
 	}
 
-	gpio_num = of_get_gpio_flags(pdev->dev.of_node, 0, &flags);
-	if (!gpio_is_valid(gpio_num))
-		return gpio_num;
-
-	gpio_active_low = flags & OF_GPIO_ACTIVE_LOW;
+	reset_gpio = devm_gpiod_get(&pdev->dev, NULL);
+	if (IS_ERR(reset_gpio))
+		return PTR_ERR(reset_gpio);
 
 	input = of_property_read_bool(pdev->dev.of_node, "input");
 
-	ret = gpio_request(gpio_num, "poweroff-gpio");
-	if (ret) {
-		pr_err("%s: Could not get GPIO %d", __func__, gpio_num);
-		return ret;
-	}
 	if (input) {
-		if (gpio_direction_input(gpio_num)) {
-			pr_err("Could not set direction of GPIO %d to input",
-			       gpio_num);
-			goto err;
+		if (gpiod_direction_input(reset_gpio)) {
+			dev_err(&pdev->dev,
+				"Could not set direction of reset GPIO to input\n");
+			return -ENODEV;
 		}
 	} else {
-		if (gpio_direction_output(gpio_num, gpio_active_low)) {
-			pr_err("Could not set direction of GPIO %d", gpio_num);
-			goto err;
+		if (gpiod_direction_output(reset_gpio, 0)) {
+			dev_err(&pdev->dev,
+				"Could not set direction of reset GPIO\n");
+			return -ENODEV;
 		}
 	}
 
 	pm_power_off = &gpio_poweroff_do_poweroff;
 	return 0;
-
-err:
-	gpio_free(gpio_num);
-	return -ENODEV;
 }
 
 static int gpio_poweroff_remove(struct platform_device *pdev)
 {
-	gpio_free(gpio_num);
 	if (pm_power_off == &gpio_poweroff_do_poweroff)
 		pm_power_off = NULL;
 
-- 
1.9.3

