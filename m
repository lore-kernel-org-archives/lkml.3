Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752804AbbARLkn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 06:40:43 -0500
Received: from mail-la0-f50.google.com ([209.85.215.50]:61208 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752561AbbARLkA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 06:40:00 -0500
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Peter Korsgaard <jacmet@sunsite.dk>,
        devicetree@vger.kernel.org
Subject: [PATCH 7/8] gpio/mpc8xxx: Convert to platform device interface.
Date: Sun, 18 Jan 2015 12:39:32 +0100
Message-Id: <1421581173-28416-8-git-send-email-ricardo.ribalda@gmail.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421581173-28416-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1421581173-28416-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This way we do not need to transverse the device tree manually.

Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Alexandre Courbot <gnurou@gmail.com>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Peter Korsgaard <jacmet@sunsite.dk>
Cc: devicetree@vger.kernel.org
Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/gpio/gpio-mpc8xxx.c | 48 +++++++++++++++++++++------------------------
 1 file changed, 22 insertions(+), 26 deletions(-)

diff --git a/drivers/gpio/gpio-mpc8xxx.c b/drivers/gpio/gpio-mpc8xxx.c
index d1ff879..57eb794 100644
--- a/drivers/gpio/gpio-mpc8xxx.c
+++ b/drivers/gpio/gpio-mpc8xxx.c
@@ -15,6 +15,7 @@
 #include <linux/of.h>
 #include <linux/of_gpio.h>
 #include <linux/of_irq.h>
+#include <linux/of_platform.h>
 #include <linux/gpio.h>
 #include <linux/slab.h>
 #include <linux/irq.h>
@@ -342,8 +343,9 @@ static struct of_device_id mpc8xxx_gpio_ids[] __initdata = {
 	{}
 };
 
-static void __init mpc8xxx_add_controller(struct device_node *np)
+static int mpc8xxx_probe(struct platform_device *pdev)
 {
+	struct device_node *np = pdev->dev.of_node;
 	struct mpc8xxx_gpio_chip *mpc8xxx_gc;
 	struct of_mm_gpio_chip *mm_gc;
 	struct gpio_chip *gc;
@@ -351,11 +353,9 @@ static void __init mpc8xxx_add_controller(struct device_node *np)
 	unsigned hwirq;
 	int ret;
 
-	mpc8xxx_gc = kzalloc(sizeof(*mpc8xxx_gc), GFP_KERNEL);
-	if (!mpc8xxx_gc) {
-		ret = -ENOMEM;
-		goto err;
-	}
+	mpc8xxx_gc = devm_kzalloc(&pdev->dev, sizeof(*mpc8xxx_gc), GFP_KERNEL);
+	if (!mpc8xxx_gc)
+		return -ENOMEM;
 
 	spin_lock_init(&mpc8xxx_gc->lock);
 
@@ -375,16 +375,16 @@ static void __init mpc8xxx_add_controller(struct device_node *np)
 
 	ret = of_mm_gpiochip_add(np, mm_gc);
 	if (ret)
-		goto err;
+		return ret;
 
 	hwirq = irq_of_parse_and_map(np, 0);
 	if (hwirq == NO_IRQ)
-		goto skip_irq;
+		return 0;
 
 	mpc8xxx_gc->irq = irq_domain_add_linear(np, MPC8XXX_GPIO_PINS,
 					&mpc8xxx_gpio_irq_ops, mpc8xxx_gc);
 	if (!mpc8xxx_gc->irq)
-		goto skip_irq;
+		return 0;
 
 	id = of_match_node(mpc8xxx_gpio_ids, np);
 	if (id)
@@ -397,24 +397,20 @@ static void __init mpc8xxx_add_controller(struct device_node *np)
 	irq_set_handler_data(hwirq, mpc8xxx_gc);
 	irq_set_chained_handler(hwirq, mpc8xxx_gpio_irq_cascade);
 
-skip_irq:
-	return;
-
-err:
-	pr_err("%s: registration failed with status %d\n",
-	       np->full_name, ret);
-	kfree(mpc8xxx_gc);
-
-	return;
+	return 0;
 }
 
-static int __init mpc8xxx_add_gpiochips(void)
-{
-	struct device_node *np;
-
-	for_each_matching_node(np, mpc8xxx_gpio_ids)
-		mpc8xxx_add_controller(np);
+static struct platform_driver mpc8xxx_plat_driver = {
+	.probe		= mpc8xxx_probe,
+	.driver		= {
+		.name = "gpio-mpc8xxx",
+		.of_match_table	= mpc8xxx_gpio_ids,
+	},
+};
 
-	return 0;
+static int __init mpc8xxx_init(void)
+{
+	return platform_driver_register(&mpc8xxx_plat_driver);
 }
-arch_initcall(mpc8xxx_add_gpiochips);
+
+arch_initcall(mpc8xxx_init);
-- 
2.1.4

