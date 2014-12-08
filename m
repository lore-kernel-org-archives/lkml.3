Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755798AbaLHPIH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 10:08:07 -0500
Received: from mail-lb0-f170.google.com ([209.85.217.170]:47148 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755585AbaLHPIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 10:08:04 -0500
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Michal Simek <michal.simek@xilinx.com>,
        =?UTF-8?q?S=C3=B6ren=20Brinkmann?= <soren.brinkmann@xilinx.com>,
        linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH 3/4] gpio-xilinx: Implement remove callback
Date: Mon,  8 Dec 2014 16:07:55 +0100
Message-Id: <1418051276-5476-4-git-send-email-ricardo.ribalda@gmail.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418051276-5476-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1418051276-5476-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This way the driver can me unloaded.

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/gpio/gpio-xilinx.c | 52 +++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 45 insertions(+), 7 deletions(-)

diff --git a/drivers/gpio/gpio-xilinx.c b/drivers/gpio/gpio-xilinx.c
index 1199a31..f946d96 100644
--- a/drivers/gpio/gpio-xilinx.c
+++ b/drivers/gpio/gpio-xilinx.c
@@ -51,6 +51,11 @@ struct xgpio_instance {
 	u32 gpio_state;
 	u32 gpio_dir;
 	spinlock_t gpio_lock;
+	bool inited;
+};
+
+struct xgpio {
+	struct xgpio_instance port[2];
 };
 
 /**
@@ -173,7 +178,34 @@ static void xgpio_save_regs(struct of_mm_gpio_chip *mm_gc)
 }
 
 /**
+ * xgpio_remove - Remove method for the GPIO device.
+ * @pdev: pointer to the platform device
+ *
+ * This function remove gpiochips and frees all the allocated resources.
+ */
+static int xgpio_remove(struct platform_device *pdev)
+{
+	struct xgpio *xgpio = platform_get_drvdata(pdev);
+	int i;
+
+	for (i = 0; i < 2; i++) {
+		if (!xgpio->port[i].inited)
+			continue;
+		gpiochip_remove(&xgpio->port[i].mmchip.gc);
+
+		if (i == 1)
+			xgpio->port[i].mmchip.regs -= XGPIO_CHANNEL_OFFSET;
+
+		iounmap(xgpio->port[i].mmchip.regs);
+		kfree(xgpio->port[i].mmchip.gc.label);
+	}
+
+	return 0;
+}
+
+/**
  * xgpio_of_probe - Probe method for the GPIO device.
+ * @pdev: pointer to the platform device
  *
  * This function probes the GPIO device in the device tree. It initializes the
  * driver data structure. It returns 0, if the driver is bound to the GPIO
@@ -181,16 +213,22 @@ static void xgpio_save_regs(struct of_mm_gpio_chip *mm_gc)
  */
 static int xgpio_probe(struct platform_device *pdev)
 {
+	struct xgpio *xgpio;
 	struct xgpio_instance *chip;
 	int status = 0;
 	struct device_node *np = pdev->dev.of_node;
 	const u32 *tree_info;
 	u32 ngpio;
 
-	chip = kzalloc(sizeof(*chip), GFP_KERNEL);
-	if (!chip)
+	xgpio = (struct xgpio *) devm_kzalloc(&pdev->dev, sizeof(*xgpio),
+					      GFP_KERNEL);
+	if (!xgpio)
 		return -ENOMEM;
 
+	platform_set_drvdata(pdev, xgpio);
+
+	chip = &xgpio->port[0];
+
 	/* Update GPIO state shadow register with default value */
 	of_property_read_u32(np, "xlnx,dout-default", &chip->gpio_state);
 
@@ -221,20 +259,18 @@ static int xgpio_probe(struct platform_device *pdev)
 	/* Call the OF gpio helper to setup and register the GPIO device */
 	status = of_mm_gpiochip_add(np, &chip->mmchip);
 	if (status) {
-		kfree(chip);
 		pr_err("%s: error in probe function with status %d\n",
 		       np->full_name, status);
 		return status;
 	}
+	chip->inited = true;
 
 	pr_info("XGpio: %s: registered, base is %d\n", np->full_name,
 							chip->mmchip.gc.base);
 
 	tree_info = of_get_property(np, "xlnx,is-dual", NULL);
 	if (tree_info && be32_to_cpup(tree_info)) {
-		chip = kzalloc(sizeof(*chip), GFP_KERNEL);
-		if (!chip)
-			return -ENOMEM;
+		chip = &xgpio->port[1];
 
 		/* Update GPIO state shadow register with default value */
 		of_property_read_u32(np, "xlnx,dout-default-2",
@@ -267,7 +303,7 @@ static int xgpio_probe(struct platform_device *pdev)
 		/* Call the OF gpio helper to setup and register the GPIO dev */
 		status = of_mm_gpiochip_add(np, &chip->mmchip);
 		if (status) {
-			kfree(chip);
+			xgpio_remove(pdev);
 			pr_err("%s: error in probe function with status %d\n",
 			np->full_name, status);
 			return status;
@@ -275,6 +311,7 @@ static int xgpio_probe(struct platform_device *pdev)
 
 		/* Add dual channel offset */
 		chip->mmchip.regs += XGPIO_CHANNEL_OFFSET;
+		chip->inited = true;
 
 		pr_info("XGpio: %s: dual channel registered, base is %d\n",
 					np->full_name, chip->mmchip.gc.base);
@@ -292,6 +329,7 @@ MODULE_DEVICE_TABLE(of, xgpio_of_match);
 
 static struct platform_driver xgpio_plat_driver = {
 	.probe		= xgpio_probe,
+	.remove		= xgpio_remove,
 	.driver		= {
 			.name = "gpio-xilinx",
 			.owner = THIS_MODULE,
-- 
2.1.3

