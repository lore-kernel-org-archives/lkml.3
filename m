Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758533Ab3CDQd6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 11:33:58 -0500
Received: from atlantis.wh2.tu-dresden.de ([141.30.228.39]:60537 "EHLO
	atlantis.wh2.tu-dresden.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758323Ab3CDQd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 11:33:56 -0500
From: Lars Poeschel <larsi@wh2.tu-dresden.de>
To: poeschel@lemonage.de, grant.likely@secretlab.ca, rob.herring@calxeda.com,
        rob@landley.net, linus.walleij@linaro.org,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net
Subject: [PATCH v3] gpio: mcp23s08: convert driver to DT
Date: Mon,  4 Mar 2013 17:34:33 +0100
Message-Id: <1362414873-17676-1-git-send-email-larsi@wh2.tu-dresden.de>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Poeschel <poeschel@lemonage.de>

This converts the mcp23s08 driver to be able to be used with device
tree.
There is a "spi-present-mask" device tree property, that allows to
use multiple of this spi chips on the same chipselect.

Signed-off-by: Lars Poeschel <poeschel@lemonage.de>
---
v3:
- removed mcp,chips device tree property in favour of a
    mcp,spi-present-mask and a flag for the pullup of every gpio
- seperated the match table. Now there is one for i2c and one for spi
- do the of reading stuff on stack of the probe function - no devm
    any more

v2:
- squashed booth patches together
- fixed build warning, when CONFIG_OF is not defined
- use of_match_ptr macro for of_match_table

 create mode 100644 Documentation/devicetree/bindings/gpio/gpio-mcp23s08.txt

diff --git a/Documentation/devicetree/bindings/gpio/gpio-mcp23s08.txt b/Documentation/devicetree/bindings/gpio/gpio-mcp23s08.txt
new file mode 100644
index 0000000..99a2985
--- /dev/null
+++ b/Documentation/devicetree/bindings/gpio/gpio-mcp23s08.txt
@@ -0,0 +1,43 @@
+Microchip MCP2308/MCP23S08/MCP23017/MCP23S17 driver for
+8-/16-bit I/O expander with serial interface (I2C/SPI)
+
+Required properties:
+- compatible : Should be
+    - "mcp,mcp23s08" for  8 GPIO SPI version
+    - "mcp,mcp23s17" for 16 GPIO SPI version
+    - "mcp,mcp23008" for  8 GPIO I2C version or
+    - "mcp,mcp23017" for 16 GPIO I2C version of the chip
+- #gpio-cells : Should be two.
+  - first cell is the pin number
+  - second cell is used to specify flags. Flags currently used:
+    bit0 : activate a ~100k pullup
+- gpio-controller : Marks the device node as a GPIO controller.
+- reg : For an address on its bus
+
+Required device specific properties (only for SPI chips):
+- mcp,spi-present-mask : This is a present flag, that makes only sense for SPI
+        chips - as the name suggests. Multiple chips can share the same
+        SPI chipselect. Set bit 0-7 in this mask to 1 if there is a chip
+        connected with this spi address. If you have a chip with address 3
+        connected, you have to set bit3 to 1, which is 0x08. mcp23s08 only
+        supports bits 0-3. It is not possible to mix mcp23s08 and mcp23s17
+        on the same chipselect. Set at least one bit to 1 for SPI chips.
+- spi-max-frequency = The maximum frequency this chip is able to handle
+
+Example I2C:
+gpiom1: gpio@20 {
+        compatible = "mcp,mcp23017";
+        gpio-controller;
+        #gpio-cells = <2>;
+        reg = <0x20>;
+};
+
+Example SPI:
+gpiom1: gpio@0 {
+        compatible = "mcp,mcp23s17";
+        gpio-controller;
+        #gpio-cells = <2>;
+        spi-present-mask = <0x01>;
+        reg = <0>;
+        spi-max-frequency = <1000000>;
+};
diff --git a/drivers/gpio/gpio-mcp23s08.c b/drivers/gpio/gpio-mcp23s08.c
index 3cea0ea..a8ca469 100644
--- a/drivers/gpio/gpio-mcp23s08.c
+++ b/drivers/gpio/gpio-mcp23s08.c
@@ -12,6 +12,8 @@
 #include <linux/spi/mcp23s08.h>
 #include <linux/slab.h>
 #include <asm/byteorder.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
 
 /**
  * MCP types supported by driver
@@ -21,6 +23,11 @@
 #define MCP_TYPE_008	2
 #define MCP_TYPE_017	3
 
+/**
+ * Flags used in device tree
+ */
+#define MCP_DT_FLAG_PULLUP 0x01
+
 /* Registers are all 8 bits wide.
  *
  * The mcp23s17 has twice as many bits, and can be configured to work
@@ -75,6 +82,25 @@ struct mcp23s08_driver_data {
 	struct mcp23s08		chip[];
 };
 
+#ifdef CONFIG_OF
+static int mcp23s08_of_xlate(struct gpio_chip *gc,
+			const struct of_phandle_args *gpiospec, u32 *flags);
+
+static int mcp23s08_set_pullup(struct mcp23s08 *mcp, unsigned offset)
+{
+	int status;
+	u16 value;
+
+	mutex_lock(&mcp->lock);
+	value = mcp->cache[MCP_GPPU] | (1 << offset);
+	status = mcp->ops->write(mcp, MCP_GPPU, value);
+	if (!status)
+		mcp->cache[MCP_GPPU] = value;
+	mutex_unlock(&mcp->lock);
+
+	return status;
+}
+#endif /* CONFIG_OF */
 /*----------------------------------------------------------------------*/
 
 #if IS_ENABLED(CONFIG_I2C)
@@ -383,6 +409,11 @@ static int mcp23s08_probe_one(struct mcp23s08 *mcp, struct device *dev,
 	mcp->chip.direction_output = mcp23s08_direction_output;
 	mcp->chip.set = mcp23s08_set;
 	mcp->chip.dbg_show = mcp23s08_dbg_show;
+#ifdef CONFIG_OF
+	mcp->chip.of_xlate = mcp23s08_of_xlate;
+	mcp->chip.of_gpio_n_cells = 2;
+	mcp->chip.of_node = dev->of_node;
+#endif
 
 	switch (type) {
 #ifdef CONFIG_SPI_MASTER
@@ -473,6 +504,50 @@ fail:
 
 /*----------------------------------------------------------------------*/
 
+#ifdef CONFIG_OF
+#ifdef CONFIG_SPI_MASTER
+static struct of_device_id mcp23s08_spi_of_match[] = {
+	{
+		.compatible = "mcp,mcp23s08", .data = (void *) MCP_TYPE_S08,
+	},
+	{
+		.compatible = "mcp,mcp23s17", .data = (void *) MCP_TYPE_S17,
+	},
+	{ },
+};
+MODULE_DEVICE_TABLE(of, mcp23s08_spi_of_match);
+#endif
+
+#if IS_ENABLED(CONFIG_I2C)
+static struct of_device_id mcp23s08_i2c_of_match[] = {
+	{
+		.compatible = "mcp,mcp23008", .data = (void *) MCP_TYPE_008,
+	},
+	{
+		.compatible = "mcp,mcp23017", .data = (void *) MCP_TYPE_017,
+	},
+	{ },
+};
+MODULE_DEVICE_TABLE(of, mcp23s08_i2c_of_match);
+#endif
+
+static int mcp23s08_of_xlate(struct gpio_chip *gc,
+			const struct of_phandle_args *gpiospec, u32 *flags)
+{
+	struct mcp23s08	*mcp = container_of(gc, struct mcp23s08, chip);
+
+	if (flags)
+		*flags = gpiospec->args[1];
+
+	if (gpiospec->args[1] & MCP_DT_FLAG_PULLUP)
+		mcp23s08_set_pullup(mcp, gpiospec->args[0]);
+
+	return gpiospec->args[0];
+}
+
+#endif /* CONFIG_OF */
+
+
 #if IS_ENABLED(CONFIG_I2C)
 
 static int mcp230xx_probe(struct i2c_client *client,
@@ -480,12 +555,23 @@ static int mcp230xx_probe(struct i2c_client *client,
 {
 	struct mcp23s08_platform_data *pdata;
 	struct mcp23s08 *mcp;
-	int status;
-
-	pdata = client->dev.platform_data;
-	if (!pdata || !gpio_is_valid(pdata->base)) {
-		dev_dbg(&client->dev, "invalid or missing platform data\n");
-		return -EINVAL;
+	int status, base, pullups;
+	const struct of_device_id *match;
+
+	match = of_match_device(of_match_ptr(mcp23s08_i2c_of_match),
+					&client->dev);
+	if (match) {
+		base = -1;
+		pullups = 0;
+	} else {
+		pdata = client->dev.platform_data;
+		if (!pdata || !gpio_is_valid(pdata->base)) {
+			dev_dbg(&client->dev,
+					"invalid or missing platform data\n");
+			return -EINVAL;
+		}
+		base = pdata->base;
+		pullups = pdata->chip[0].pullups;
 	}
 
 	mcp = kzalloc(sizeof *mcp, GFP_KERNEL);
@@ -493,8 +579,7 @@ static int mcp230xx_probe(struct i2c_client *client,
 		return -ENOMEM;
 
 	status = mcp23s08_probe_one(mcp, &client->dev, client, client->addr,
-				    id->driver_data, pdata->base,
-				    pdata->chip[0].pullups);
+				    id->driver_data, base, pullups);
 	if (status)
 		goto fail;
 
@@ -531,6 +616,7 @@ static struct i2c_driver mcp230xx_driver = {
 	.driver = {
 		.name	= "mcp230xx",
 		.owner	= THIS_MODULE,
+		.of_match_table = of_match_ptr(mcp23s08_i2c_of_match),
 	},
 	.probe		= mcp230xx_probe,
 	.remove		= mcp230xx_remove,
@@ -565,28 +651,55 @@ static int mcp23s08_probe(struct spi_device *spi)
 	unsigned			chips = 0;
 	struct mcp23s08_driver_data	*data;
 	int				status, type;
-	unsigned			base;
-
-	type = spi_get_device_id(spi)->driver_data;
-
-	pdata = spi->dev.platform_data;
-	if (!pdata || !gpio_is_valid(pdata->base)) {
-		dev_dbg(&spi->dev, "invalid or missing platform data\n");
-		return -EINVAL;
-	}
+	unsigned			base = -1,
+					ngpio = 0,
+					pullups[ARRAY_SIZE(pdata->chip)];
+	const struct			of_device_id *match;
+	u32				spi_present_mask = 0;
+
+	match = of_match_device(of_match_ptr(mcp23s08_spi_of_match), &spi->dev);
+	if (match) {
+		type = (int)match->data;
+		status = of_property_read_u32(spi->dev.of_node,
+				"mcp,spi-present-mask", &spi_present_mask);
+		if (status) {
+			dev_err(&spi->dev, "DT has no spi-present-mask\n");
+			return -ENODEV;
+		}
+		if ((spi_present_mask <= 0) || (spi_present_mask >= 256)) {
+			dev_err(&spi->dev, "invalid spi-present-mask\n");
+			return -ENODEV;
+		}
 
-	for (addr = 0; addr < ARRAY_SIZE(pdata->chip); addr++) {
-		if (!pdata->chip[addr].is_present)
-			continue;
-		chips++;
-		if ((type == MCP_TYPE_S08) && (addr > 3)) {
-			dev_err(&spi->dev,
-				"mcp23s08 only supports address 0..3\n");
+		for (addr = 0; addr < ARRAY_SIZE(pdata->chip); addr++)
+			pullups[addr] = 0;
+	} else {
+		type = spi_get_device_id(spi)->driver_data;
+		pdata = spi->dev.platform_data;
+		if (!pdata || !gpio_is_valid(pdata->base)) {
+			dev_dbg(&spi->dev,
+					"invalid or missing platform data\n");
 			return -EINVAL;
 		}
+
+		for (addr = 0; addr < ARRAY_SIZE(pdata->chip); addr++) {
+			if (!pdata->chip[addr].is_present)
+				continue;
+			chips++;
+			if ((type == MCP_TYPE_S08) && (addr > 3)) {
+				dev_err(&spi->dev,
+					"mcp23s08 only supports address 0..3\n");
+				return -EINVAL;
+			}
+			spi_present_mask |= 1 << addr;
+			pullups[addr] = pdata->chip[addr].pullups;
+		}
+
+		if (!chips)
+			return -ENODEV;
+
+		base = pdata->base;
 	}
-	if (!chips)
-		return -ENODEV;
 
 	data = kzalloc(sizeof *data + chips * sizeof(struct mcp23s08),
 			GFP_KERNEL);
@@ -594,21 +707,22 @@ static int mcp23s08_probe(struct spi_device *spi)
 		return -ENOMEM;
 	spi_set_drvdata(spi, data);
 
-	base = pdata->base;
 	for (addr = 0; addr < ARRAY_SIZE(pdata->chip); addr++) {
-		if (!pdata->chip[addr].is_present)
+		if (!(spi_present_mask & (1 << addr)))
 			continue;
 		chips--;
 		data->mcp[addr] = &data->chip[chips];
 		status = mcp23s08_probe_one(data->mcp[addr], &spi->dev, spi,
 					    0x40 | (addr << 1), type, base,
-					    pdata->chip[addr].pullups);
+					    pullups[addr]);
 		if (status < 0)
 			goto fail;
 
-		base += (type == MCP_TYPE_S17) ? 16 : 8;
+		if (base != -1)
+			base += (type == MCP_TYPE_S17) ? 16 : 8;
+		ngpio += (type == MCP_TYPE_S17) ? 16 : 8;
 	}
-	data->ngpio = base - pdata->base;
+	data->ngpio = ngpio;
 
 	/* NOTE:  these chips have a relatively sane IRQ framework, with
 	 * per-signal masking and level/edge triggering.  It's not yet
@@ -668,6 +782,7 @@ static struct spi_driver mcp23s08_driver = {
 	.driver = {
 		.name	= "mcp23s08",
 		.owner	= THIS_MODULE,
+		.of_match_table = of_match_ptr(mcp23s08_spi_of_match),
 	},
 };
 
-- 
1.7.10.4

