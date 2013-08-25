Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756051Ab3HYAZk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Aug 2013 20:25:40 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:50234 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755955Ab3HYAZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Aug 2013 20:25:38 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-gpio@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Subject: [PATCH v3] gpio: pcf857x: Add OF support
Date: Sun, 25 Aug 2013 02:26:35 +0200
Message-Id: <1377390395-4328-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
X-Mailer: git-send-email 1.8.1.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add DT bindings for the pcf857x-compatible chips and parse the device
tree node in the driver.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 .../devicetree/bindings/gpio/gpio-pcf857x.txt      | 71 ++++++++++++++++++++++
 drivers/gpio/gpio-pcf857x.c                        | 57 ++++++++++++++---
 2 files changed, 119 insertions(+), 9 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/gpio/gpio-pcf857x.txt

Changes since v2

- Replace mention about interrupts software configuration in DT bindings
  documentation with an explanation of the hardware configuration.

diff --git a/Documentation/devicetree/bindings/gpio/gpio-pcf857x.txt b/Documentation/devicetree/bindings/gpio/gpio-pcf857x.txt
new file mode 100644
index 0000000..d0a3af4
--- /dev/null
+++ b/Documentation/devicetree/bindings/gpio/gpio-pcf857x.txt
@@ -0,0 +1,71 @@
+* PCF857x-compatible I/O expanders
+
+The PCF857x-compatible chips have "quasi-bidirectional" I/O pins that can be
+driven high by a pull-up current source or driven low to ground. This combines
+the direction and output level into a single bit per pin, which can't be read
+back. We can't actually know at initialization time whether a pin is configured
+(a) as output and driving the signal low/high, or (b) as input and reporting a
+low/high value, without knowing the last value written since the chip came out
+of reset (if any). The only reliable solution for setting up pin direction is
+thus to do it explicitly.
+
+Required Properties:
+
+  - compatible: should be one of the following.
+    - "maxim,max7328": For the Maxim MAX7378
+    - "maxim,max7329": For the Maxim MAX7329
+    - "nxp,pca8574": For the NXP PCA8574
+    - "nxp,pca8575": For the NXP PCA8575
+    - "nxp,pca9670": For the NXP PCA9670
+    - "nxp,pca9671": For the NXP PCA9671
+    - "nxp,pca9672": For the NXP PCA9672
+    - "nxp,pca9673": For the NXP PCA9673
+    - "nxp,pca9674": For the NXP PCA9674
+    - "nxp,pca9675": For the NXP PCA9675
+    - "nxp,pcf8574": For the NXP PCF8574
+    - "nxp,pcf8574a": For the NXP PCF8574A
+    - "nxp,pcf8575": For the NXP PCF8575
+    - "ti,tca9554": For the TI TCA9554
+
+  - reg: I2C slave address.
+
+  - gpio-controller: Marks the device node as a gpio controller.
+  - #gpio-cells: Should be 2. The first cell is the GPIO number and the second
+    cell specifies GPIO flags, as defined in <dt-bindings/gpio/gpio.h>. Only the
+    GPIO_ACTIVE_HIGH and GPIO_ACTIVE_LOW flags are supported.
+
+Optional Properties:
+
+  - pins-initial-state: Bitmask that specifies the initial state of each pin.
+  When a bit is set to zero, the corresponding pin will be initialized to the
+  input (pulled-up) state. When the  bit is set to one, the pin will be
+  initialized the the low-level output state. If the property is not specified
+  all pins will be initialized to the input state.
+
+  The I/O expander can detect input state changes, and thus optionally act as
+  an interrupt controller. When the expander interrupt pin is connected all the
+  following properties must be set. For more information please see the
+  interrupt controller device tree bindings documentation available at
+  Documentation/devicetree/bindings/interrupt-controller/interrupts.txt.
+
+  - interrupt-controller: Identifies the node as an interrupt controller.
+  - #interrupt-cells: Number of cells to encode an interrupt source, shall be 2.
+  - interrupt-parent: phandle of the parent interrupt controller.
+  - interrupts: Interrupt specifier for the controllers interrupt.
+
+
+Please refer to gpio.txt in this directory for details of the common GPIO
+bindings used by client devices.
+
+Example: PCF8575 I/O expander node
+
+	pcf8575: gpio@20 {
+		compatible = "nxp,pcf8575";
+		reg = <0x20>;
+		interrupt-parent = <&irqpin2>;
+		interrupts = <3 0>;
+		gpio-controller;
+		#gpio-cells = <2>;
+		interrupt-controller;
+		#interrupt-cells = <2>;
+	};
diff --git a/drivers/gpio/gpio-pcf857x.c b/drivers/gpio/gpio-pcf857x.c
index 9e61bb0..474f8ce 100644
--- a/drivers/gpio/gpio-pcf857x.c
+++ b/drivers/gpio/gpio-pcf857x.c
@@ -26,6 +26,8 @@
 #include <linux/irqdomain.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <linux/workqueue.h>
@@ -50,6 +52,27 @@ static const struct i2c_device_id pcf857x_id[] = {
 };
 MODULE_DEVICE_TABLE(i2c, pcf857x_id);
 
+#ifdef CONFIG_OF
+static const struct of_device_id pcf857x_of_table[] = {
+	{ .compatible = "nxp,pcf8574", .data = (void *)8 },
+	{ .compatible = "nxp,pcf8574a", .data = (void *)8 },
+	{ .compatible = "nxp,pca8574", .data = (void *)8 },
+	{ .compatible = "nxp,pca9670", .data = (void *)8 },
+	{ .compatible = "nxp,pca9672", .data = (void *)8 },
+	{ .compatible = "nxp,pca9674", .data = (void *)8 },
+	{ .compatible = "nxp,pcf8575", .data = (void *)16 },
+	{ .compatible = "nxp,pca8575", .data = (void *)16 },
+	{ .compatible = "nxp,pca9671", .data = (void *)16 },
+	{ .compatible = "nxp,pca9673", .data = (void *)16 },
+	{ .compatible = "nxp,pca9675", .data = (void *)16 },
+	{ .compatible = "maxim,max7328", .data = (void *)8 },
+	{ .compatible = "maxim,max7329", .data = (void *)8 },
+	{ .compatible = "ti,tca9554", .data = (void *)8 },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, pcf857x_of_table);
+#endif
+
 /*
  * The pcf857x, pca857x, and pca967x chips only expose one read and one
  * write register.  Writing a "one" bit (to match the reset state) lets
@@ -257,14 +280,29 @@ fail:
 static int pcf857x_probe(struct i2c_client *client,
 			 const struct i2c_device_id *id)
 {
-	struct pcf857x_platform_data	*pdata;
+	struct pcf857x_platform_data	*pdata = dev_get_platdata(&client->dev);
+	struct device_node		*np = client->dev.of_node;
 	struct pcf857x			*gpio;
+	unsigned int			n_latch = 0;
+	unsigned int			ngpio;
 	int				status;
 
-	pdata = dev_get_platdata(&client->dev);
-	if (!pdata) {
+#ifdef CONFIG_OF
+	if (np) {
+		const struct of_device_id *of_id;
+
+		of_id = of_match_device(pcf857x_of_table, &client->dev);
+		ngpio = (unsigned int)of_id->data;
+	} else
+#endif
+		ngpio = id->driver_data;
+
+	if (pdata)
+		n_latch = pdata->n_latch;
+	else if (IS_ENABLED(CONFIG_OF) && np)
+		of_property_read_u32(np, "pins-initial-state", &n_latch);
+	else
 		dev_dbg(&client->dev, "no platform data\n");
-	}
 
 	/* Allocate, initialize, and register this gpio_chip. */
 	gpio = devm_kzalloc(&client->dev, sizeof(*gpio), GFP_KERNEL);
@@ -282,7 +320,7 @@ static int pcf857x_probe(struct i2c_client *client,
 	gpio->chip.set			= pcf857x_set;
 	gpio->chip.direction_input	= pcf857x_input;
 	gpio->chip.direction_output	= pcf857x_output;
-	gpio->chip.ngpio		= id->driver_data;
+	gpio->chip.ngpio		= ngpio;
 
 	/* enable gpio_to_irq() if platform has settings */
 	if (client->irq) {
@@ -357,11 +395,11 @@ static int pcf857x_probe(struct i2c_client *client,
 	 * may cause transient glitching since it can't know the last value
 	 * written (some pins may need to be driven low).
 	 *
-	 * Using pdata->n_latch avoids that trouble.  When left initialized
-	 * to zero, our software copy of the "latch" then matches the chip's
-	 * all-ones reset state.  Otherwise it flags pins to be driven low.
+	 * Using n_latch avoids that trouble.  When left initialized to zero,
+	 * our software copy of the "latch" then matches the chip's all-ones
+	 * reset state.  Otherwise it flags pins to be driven low.
 	 */
-	gpio->out = pdata ? ~pdata->n_latch : ~0;
+	gpio->out = ~n_latch;
 	gpio->status = gpio->out;
 
 	status = gpiochip_add(&gpio->chip);
@@ -423,6 +461,7 @@ static struct i2c_driver pcf857x_driver = {
 	.driver = {
 		.name	= "pcf857x",
 		.owner	= THIS_MODULE,
+		.of_match_table = of_match_ptr(pcf857x_of_table),
 	},
 	.probe	= pcf857x_probe,
 	.remove	= pcf857x_remove,
-- 
Regards,

Laurent Pinchart

