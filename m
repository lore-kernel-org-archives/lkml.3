Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752128Ab3FFOGn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 10:06:43 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:40562 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750890Ab3FFOGl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 10:06:41 -0400
From: Archit Taneja <archit@ti.com>
To: <linus.walleij@linaro.org>
CC: <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, Archit Taneja <archit@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH] gpio: Enable pcf857x GPIO expander for Device Tree
Date: Thu, 6 Jun 2013 19:35:23 +0530
Message-ID: <1370527523-1030-1-git-send-email-archit@ti.com>
X-Mailer: git-send-email 1.8.1.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add code to parse the GPIO expander Device Tree node and extract platform data
out of it, and populate the struct 'pcf857x_platform_data' maintained by the
driver. This enables devices to reference the gpio expander from Device Tree.

Add DT binding info in Documentation.

CC: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Archit Taneja <archit@ti.com>
---
 .../devicetree/bindings/gpio/gpio-pcf857x.txt      | 44 +++++++++++++++++
 drivers/gpio/gpio-pcf857x.c                        | 57 ++++++++++++++++++++--
 2 files changed, 97 insertions(+), 4 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/gpio/gpio-pcf857x.txt

diff --git a/Documentation/devicetree/bindings/gpio/gpio-pcf857x.txt b/Documentation/devicetree/bindings/gpio/gpio-pcf857x.txt
new file mode 100644
index 0000000..0556512
--- /dev/null
+++ b/Documentation/devicetree/bindings/gpio/gpio-pcf857x.txt
@@ -0,0 +1,44 @@
+PCF857x I2C based GPIO controller bindings
+
+Required properties:
+- compatible:
+  - "nxp,pca9670" for NXP PCA9670 8 bit I/O expander
+  - "nxp,pca9672" for NXP PCA9672 8 bit I/O expander with interrupt
+  - "nxp,pca9674" for NXP PCA9672 8 bit I/O expander with interrupt
+  - "nxp,pca8574" for NXP PCA8574 8 bit I/O expander with interrupt
+  - "nxp,pca8575" for NXP PCA8575 16 bit I/O expander with interrupt
+  - "nxp,pca9671" for NXP PCA9671 16 bit I/O expander
+  - "nxp,pca9673" for NXP PCA9673 16 bit I/O expander with interrupt
+  - "nxp,pca9675" for NXP PCA9675 16 bit I/O expander with interrupt
+  - "ti,pcf8574"  for TI PCF8574 8 bit I/O expander with interrupt
+  - "ti,pcf8574a" for TI PCF8574A 8 bit I/O expander with interrupt
+  - "ti,pcf8575"  for TI PCF8575 16 bit I/O expander with interrupt
+  - "ti,tca9554"  for TI TCA9554 8 bit I/O expander with interrupt
+  - "maxim,max7328" for MAXIM MAX7328 8 bit I/O expander with interrupt
+  - "maxim,max7329" for MAXIM MAX7329 8 bit I/O expander with interrupt
+- gpio-controller : Marks the device node as a GPIO controller.
+- #gpio-cells : Should be two.
+  - first cell is the pin number.
+  - second cell is unused.
+- interrupt-controller: Mark the device node as an interrupt controller.
+- #interrupt-cells : Should be two.
+  - first cell is the GPIO number.
+  - second cell is unused.
+- reg: I2C address of the chip.
+
+Device speific properties:
+- n_latch:		optional bit-inverse of initial register value; if
+			you leave this initialized to zero the driver will act
+			like the chip was just reset.
+
+Example:
+
+pcf8575: pcf8575 {
+	compatible = "ti,pcf8575";
+	gpio-controller;
+	#gpio-cells = <2>;
+	interrupt-controller;
+	#interrupt-cells = <2>;
+	reg = <0x20>;
+	n_latch = <0x0>;
+};
diff --git a/drivers/gpio/gpio-pcf857x.c b/drivers/gpio/gpio-pcf857x.c
index e8faf53..3435790 100644
--- a/drivers/gpio/gpio-pcf857x.c
+++ b/drivers/gpio/gpio-pcf857x.c
@@ -21,6 +21,7 @@
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/gpio.h>
+#include <linux/of.h>
 #include <linux/i2c.h>
 #include <linux/i2c/pcf857x.h>
 #include <linux/interrupt.h>
@@ -255,17 +256,42 @@ fail:
 
 /*-------------------------------------------------------------------------*/
 
+static struct pcf857x_platform_data *of_gpio_pcf857x(struct device *dev)
+{
+	struct pcf857x_platform_data *pdata;
+	int r;
+
+	pdata = devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
+	if (!pdata)
+		return NULL;
+
+	pdata->gpio_base = -1;
+
+	r = of_property_read_u32(dev->of_node, "n_latch", &pdata->n_latch);
+	if (r) {
+		dev_dbg(dev, "couldn't find n-latch, use default\n");
+		pdata->n_latch = 0;
+	}
+
+	return pdata;
+}
+
 static int pcf857x_probe(struct i2c_client *client,
 			 const struct i2c_device_id *id)
 {
 	struct pcf857x_platform_data	*pdata;
+	struct device_node		*node;
 	struct pcf857x			*gpio;
 	int				status;
 
 	pdata = client->dev.platform_data;
-	if (!pdata) {
+	node = client->dev.of_node;
+
+	if (!pdata && node)
+		pdata = of_gpio_pcf857x(&client->dev);
+
+	if (!pdata)
 		dev_dbg(&client->dev, "no platform data\n");
-	}
 
 	/* Allocate, initialize, and register this gpio_chip. */
 	gpio = devm_kzalloc(&client->dev, sizeof(*gpio), GFP_KERNEL);
@@ -420,10 +446,33 @@ static int pcf857x_remove(struct i2c_client *client)
 	return status;
 }
 
+static const struct of_device_id pcf857x_dt_ids[] = {
+	{ .compatible = "nxp,pca9670", },
+	{ .compatible = "nxp,pca9672", },
+	{ .compatible = "nxp,pca9674", },
+	{ .compatible = "nxp,pca8574", },
+	{ .compatible = "nxp,pca8575", },
+	{ .compatible = "nxp,pca9671", },
+	{ .compatible = "nxp,pca9673", },
+	{ .compatible = "nxp,pca9675", },
+
+	{ .compatible = "ti,pcf8574", },
+	{ .compatible = "ti,pcf8574a", },
+	{ .compatible = "ti,pcf8575", },
+	{ .compatible = "ti,tca9554", },
+
+	{ .compatible = "maxim,max7328", },
+	{ .compatible = "maxim,max7329", },
+	{ }
+};
+
+MODULE_DEVICE_TABLE(of, pcf857x_dt_ids);
+
 static struct i2c_driver pcf857x_driver = {
 	.driver = {
-		.name	= "pcf857x",
-		.owner	= THIS_MODULE,
+		.name		= "pcf857x",
+		.owner		= THIS_MODULE,
+		.of_match_table	= pcf857x_dt_ids,
 	},
 	.probe	= pcf857x_probe,
 	.remove	= pcf857x_remove,
-- 
1.8.1.2

