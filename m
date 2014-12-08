Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755884AbaLHPJP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 10:09:15 -0500
Received: from mail-lb0-f179.google.com ([209.85.217.179]:48388 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755572AbaLHPID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 10:08:03 -0500
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Michal Simek <michal.simek@xilinx.com>,
        =?UTF-8?q?S=C3=B6ren=20Brinkmann?= <soren.brinkmann@xilinx.com>,
        linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH 2/4] gpio/xilinx: Convert the driver to platform device interface
Date: Mon,  8 Dec 2014 16:07:54 +0100
Message-Id: <1418051276-5476-3-git-send-email-ricardo.ribalda@gmail.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418051276-5476-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1418051276-5476-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This way we do not need to transverse the device tree manually and we
support hot plugged devices.

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/gpio/gpio-xilinx.c | 27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

diff --git a/drivers/gpio/gpio-xilinx.c b/drivers/gpio/gpio-xilinx.c
index 9483950..1199a31 100644
--- a/drivers/gpio/gpio-xilinx.c
+++ b/drivers/gpio/gpio-xilinx.c
@@ -174,16 +174,16 @@ static void xgpio_save_regs(struct of_mm_gpio_chip *mm_gc)
 
 /**
  * xgpio_of_probe - Probe method for the GPIO device.
- * @np: pointer to device tree node
  *
  * This function probes the GPIO device in the device tree. It initializes the
  * driver data structure. It returns 0, if the driver is bound to the GPIO
  * device, or a negative value if there is an error.
  */
-static int xgpio_of_probe(struct device_node *np)
+static int xgpio_probe(struct platform_device *pdev)
 {
 	struct xgpio_instance *chip;
 	int status = 0;
+	struct device_node *np = pdev->dev.of_node;
 	const u32 *tree_info;
 	u32 ngpio;
 
@@ -210,6 +210,7 @@ static int xgpio_of_probe(struct device_node *np)
 
 	spin_lock_init(&chip->gpio_lock);
 
+	chip->mmchip.gc.dev = &pdev->dev;
 	chip->mmchip.gc.direction_input = xgpio_dir_in;
 	chip->mmchip.gc.direction_output = xgpio_dir_out;
 	chip->mmchip.gc.get = xgpio_get;
@@ -255,6 +256,7 @@ static int xgpio_of_probe(struct device_node *np)
 
 		spin_lock_init(&chip->gpio_lock);
 
+		chip->mmchip.gc.dev = &pdev->dev;
 		chip->mmchip.gc.direction_input = xgpio_dir_in;
 		chip->mmchip.gc.direction_output = xgpio_dir_out;
 		chip->mmchip.gc.get = xgpio_get;
@@ -286,19 +288,18 @@ static const struct of_device_id xgpio_of_match[] = {
 	{ /* end of list */ },
 };
 
-static int __init xgpio_init(void)
-{
-	struct device_node *np;
-
-	for_each_matching_node(np, xgpio_of_match)
-		xgpio_of_probe(np);
+MODULE_DEVICE_TABLE(of, xgpio_of_match);
 
-	return 0;
-}
+static struct platform_driver xgpio_plat_driver = {
+	.probe		= xgpio_probe,
+	.driver		= {
+			.name = "gpio-xilinx",
+			.owner = THIS_MODULE,
+			.of_match_table	= xgpio_of_match,
+	},
+};
 
-/* Make sure we get initialized before anyone else tries to use us */
-subsys_initcall(xgpio_init);
-/* No exit call at the moment as we cannot unregister of GPIO chips */
+module_platform_driver(xgpio_plat_driver);
 
 MODULE_AUTHOR("Xilinx, Inc.");
 MODULE_DESCRIPTION("Xilinx GPIO driver");
-- 
2.1.3

