Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758028AbaLJP01 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 10:26:27 -0500
Received: from mail-la0-f51.google.com ([209.85.215.51]:61852 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757941AbaLJPZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 10:25:07 -0500
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Michal Simek <michal.simek@xilinx.com>,
        =?UTF-8?q?S=C3=B6ren=20Brinkmann?= <soren.brinkmann@xilinx.com>,
        linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH v3 2/4] gpio/xilinx: Convert the driver to platform device interface
Date: Wed, 10 Dec 2014 16:24:58 +0100
Message-Id: <1418225100-2949-3-git-send-email-ricardo.ribalda@gmail.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418225100-2949-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1418225100-2949-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This way we do not need to transverse the device tree manually and we
support hot plugged devices.

Also Implement remove callback so the driver can be unloaded

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---

v3:
Add inited to kernel-doc
Keep the driver in susbys_initcall


 drivers/gpio/gpio-xilinx.c | 77 ++++++++++++++++++++++++++++++++++++----------
 1 file changed, 60 insertions(+), 17 deletions(-)

diff --git a/drivers/gpio/gpio-xilinx.c b/drivers/gpio/gpio-xilinx.c
index e668ec4..9a81c82 100644
--- a/drivers/gpio/gpio-xilinx.c
+++ b/drivers/gpio/gpio-xilinx.c
@@ -44,12 +44,18 @@
  * gpio_state: GPIO state shadow register
  * gpio_dir: GPIO direction shadow register
  * gpio_lock: Lock used for synchronization
+ * inited: True if the port has been inited
  */
 struct xgpio_instance {
 	struct of_mm_gpio_chip mmchip;
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
@@ -172,24 +178,56 @@ static void xgpio_save_regs(struct of_mm_gpio_chip *mm_gc)
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
- * @np: pointer to device tree node
+ * @pdev: pointer to the platform device
  *
  * This function probes the GPIO device in the device tree. It initializes the
  * driver data structure. It returns 0, if the driver is bound to the GPIO
  * device, or a negative value if there is an error.
  */
-static int xgpio_of_probe(struct device_node *np)
+static int xgpio_probe(struct platform_device *pdev)
 {
+	struct xgpio *xgpio;
 	struct xgpio_instance *chip;
 	int status = 0;
+	struct device_node *np = pdev->dev.of_node;
 	const u32 *tree_info;
 	u32 ngpio;
 
-	chip = kzalloc(sizeof(*chip), GFP_KERNEL);
-	if (!chip)
+	xgpio = devm_kzalloc(&pdev->dev, sizeof(*xgpio), GFP_KERNEL);
+	if (!xgpio)
 		return -ENOMEM;
 
+	platform_set_drvdata(pdev, xgpio);
+
+	chip = &xgpio->port[0];
+
 	/* Update GPIO state shadow register with default value */
 	of_property_read_u32(np, "xlnx,dout-default", &chip->gpio_state);
 
@@ -209,6 +247,7 @@ static int xgpio_of_probe(struct device_node *np)
 
 	spin_lock_init(&chip->gpio_lock);
 
+	chip->mmchip.gc.dev = &pdev->dev;
 	chip->mmchip.gc.direction_input = xgpio_dir_in;
 	chip->mmchip.gc.direction_output = xgpio_dir_out;
 	chip->mmchip.gc.get = xgpio_get;
@@ -219,20 +258,18 @@ static int xgpio_of_probe(struct device_node *np)
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
@@ -254,6 +291,7 @@ static int xgpio_of_probe(struct device_node *np)
 
 		spin_lock_init(&chip->gpio_lock);
 
+		chip->mmchip.gc.dev = &pdev->dev;
 		chip->mmchip.gc.direction_input = xgpio_dir_in;
 		chip->mmchip.gc.direction_output = xgpio_dir_out;
 		chip->mmchip.gc.get = xgpio_get;
@@ -264,7 +302,7 @@ static int xgpio_of_probe(struct device_node *np)
 		/* Call the OF gpio helper to setup and register the GPIO dev */
 		status = of_mm_gpiochip_add(np, &chip->mmchip);
 		if (status) {
-			kfree(chip);
+			xgpio_remove(pdev);
 			pr_err("%s: error in probe function with status %d\n",
 			np->full_name, status);
 			return status;
@@ -272,6 +310,7 @@ static int xgpio_of_probe(struct device_node *np)
 
 		/* Add dual channel offset */
 		chip->mmchip.regs += XGPIO_CHANNEL_OFFSET;
+		chip->inited = true;
 
 		pr_info("XGpio: %s: dual channel registered, base is %d\n",
 					np->full_name, chip->mmchip.gc.base);
@@ -285,19 +324,23 @@ static const struct of_device_id xgpio_of_match[] = {
 	{ /* end of list */ },
 };
 
-static int __init xgpio_init(void)
-{
-	struct device_node *np;
+MODULE_DEVICE_TABLE(of, xgpio_of_match);
 
-	for_each_matching_node(np, xgpio_of_match)
-		xgpio_of_probe(np);
+static struct platform_driver xgpio_plat_driver = {
+	.probe		= xgpio_probe,
+	.remove		= xgpio_remove,
+	.driver		= {
+			.name = "gpio-xilinx",
+			.of_match_table	= xgpio_of_match,
+	},
+};
 
-	return 0;
+static int __init xgpio_init(void)
+{
+	return platform_driver_register(&xgpio_plat_driver);
 }
 
-/* Make sure we get initialized before anyone else tries to use us */
 subsys_initcall(xgpio_init);
-/* No exit call at the moment as we cannot unregister of GPIO chips */
 
 MODULE_AUTHOR("Xilinx, Inc.");
 MODULE_DESCRIPTION("Xilinx GPIO driver");
-- 
2.1.3

