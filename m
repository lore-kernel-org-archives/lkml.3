Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752291AbaAPKof (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 05:44:35 -0500
Received: from atlantis.wh2.tu-dresden.de ([141.30.228.39]:42165 "EHLO
	atlantis.wh2.tu-dresden.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751435AbaAPKod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 05:44:33 -0500
From: Lars Poeschel <larsi@wh2.tu-dresden.de>
To: poeschel@lemonage.de, robh+dt@kernel.org, linus.walleij@linaro.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, rob@landley.net, galak@codeaurora.org,
        gnurou@gmail.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-gpio@vger.kernel.org
Subject: [PATCH v3] gpio: mcp23s08: Add irq functionality for i2c chips
Date: Thu, 16 Jan 2014 11:44:15 +0100
Message-Id: <1389869055-9467-1-git-send-email-larsi@wh2.tu-dresden.de>
X-Mailer: git-send-email 1.8.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Poeschel <poeschel@lemonage.de>

This adds interrupt functionality for i2c chips to the driver.
They can act as a interrupt-controller and generate interrupts, if
the inputs change.
This is tested with a mcp23017 chip on an arm based platform.

v3:
- be a bit more clear that the irq functionality is also available
  on spi versions of the chips, but the linux driver does not support
  this yet

v2:
- some more word about irq-mirror property in binding doc
- use of_read_bool instead of of_find_property for
  "interrupt-contrller" and "irq-mirror"
- cache the "interrupt-controller" for remove function
- do set the irq-mirror bit only if device is marked as
  interrupt-controller
- do create the irq mapping and setup of irq_desc of all possible
  interrupts in probe path instead of in gpio_to_irq
- mark gpios as in use as interrupts in irq in irq_startup and
  unlock it in irq_shutdown
- rename virq to child_irq
- remove dev argument from mcp23s08_irq_setup function
- move gpiochip_add before mcp23s08_irq_setup in probe path

Signed-off-by: Lars Poeschel <poeschel@lemonage.de>
---
 .../devicetree/bindings/gpio/gpio-mcp23s08.txt     |  28 ++-
 drivers/gpio/Kconfig                               |   1 +
 drivers/gpio/gpio-mcp23s08.c                       | 248 ++++++++++++++++++++-
 3 files changed, 271 insertions(+), 6 deletions(-)

diff --git a/Documentation/devicetree/bindings/gpio/gpio-mcp23s08.txt b/Documentation/devicetree/bindings/gpio/gpio-mcp23s08.txt
index daa3017..3ddc7cc 100644
--- a/Documentation/devicetree/bindings/gpio/gpio-mcp23s08.txt
+++ b/Documentation/devicetree/bindings/gpio/gpio-mcp23s08.txt
@@ -38,12 +38,38 @@ Required device specific properties (only for SPI chips):
     removed.
 - spi-max-frequency = The maximum frequency this chip is able to handle
 
-Example I2C:
+Optional properties:
+- #interrupt-cells : Should be two.
+  - first cell is the pin number
+  - second cell is used to specify flags.
+- interrupt-controller: Marks the device node as a interrupt controller.
+NOTE: The interrupt functionality is only supported for i2c versions of the
+chips. The spi chips can also do the interrupts, but this is not supported by
+the linux driver yet.
+
+Optional device specific properties:
+- microchip,irq-mirror: Sets the mirror flag in the IOCON register. Devices
+        with two interrupt outputs (these are the devices ending with 17 and
+        those that have 16 IOs) have two IO banks: IO 0-7 form bank 1 and
+        IO 8-15 are bank 2. These chips have two different interrupt outputs:
+        One for bank 1 and another for bank 2. If irq-mirror is set, both
+        interrupts are generated regardless of the bank that an input change
+        occured on. If it is not set, the interrupt are only generated for the
+        bank they belong to.
+        On devices with only one interrupt output this property is useless.
+
+Example I2C (with interrupt):
 gpiom1: gpio@20 {
         compatible = "microchip,mcp23017";
         gpio-controller;
         #gpio-cells = <2>;
         reg = <0x20>;
+
+        interrupt-parent = <&gpio1>;
+        interrupts = <17 IRQ_TYPE_LEVEL_LOW>;
+        interrupt-controller;
+        #interrupt-cells=<2>;
+        microchip,irq-mirror;
 };
 
 Example SPI:
diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 0f04444..9fe782a 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -697,6 +697,7 @@ config GPIO_MCP23S08
 	  SPI/I2C driver for Microchip MCP23S08/MCP23S17/MCP23008/MCP23017
 	  I/O expanders.
 	  This provides a GPIO interface supporting inputs and outputs.
+	  The I2C versions of the chips can be used as interrupt-controller.
 
 config GPIO_MC33880
 	tristate "Freescale MC33880 high-side/low-side switch"
diff --git a/drivers/gpio/gpio-mcp23s08.c b/drivers/gpio/gpio-mcp23s08.c
index 2deb0c5..e86f6a8 100644
--- a/drivers/gpio/gpio-mcp23s08.c
+++ b/drivers/gpio/gpio-mcp23s08.c
@@ -1,5 +1,13 @@
 /*
- * MCP23S08 SPI/GPIO gpio expander driver
+ * MCP23S08 SPI/I2C GPIO gpio expander driver
+ *
+ * The inputs and outputs of the mcp23s08, mcp23s17, mcp23008 and mcp23017 are
+ * supported.
+ * For the I2C versions of the chips (mcp23008 and mcp23017) generation of
+ * interrupts is also supported.
+ * The hardware of the SPI versions of the chips (mcp23s08 and mcp23s17) is
+ * also capable of generating interrupts, but the linux driver does not
+ * support that yet.
  */
 
 #include <linux/kernel.h>
@@ -12,7 +20,8 @@
 #include <linux/spi/mcp23s08.h>
 #include <linux/slab.h>
 #include <asm/byteorder.h>
-#include <linux/of.h>
+#include <linux/interrupt.h>
+#include <linux/of_irq.h>
 #include <linux/of_device.h>
 
 /**
@@ -34,6 +43,7 @@
 #define MCP_DEFVAL	0x03
 #define MCP_INTCON	0x04
 #define MCP_IOCON	0x05
+#	define IOCON_MIRROR	(1 << 6)
 #	define IOCON_SEQOP	(1 << 5)
 #	define IOCON_HAEN	(1 << 3)
 #	define IOCON_ODR	(1 << 2)
@@ -57,8 +67,14 @@ struct mcp23s08 {
 	u8			addr;
 
 	u16			cache[11];
+	u16			irq_rise;
+	u16			irq_fall;
+	int			irq;
+	bool			irq_controller;
 	/* lock protects the cached values */
 	struct mutex		lock;
+	struct mutex		irq_lock;
+	struct irq_domain	*irq_domain;
 
 	struct gpio_chip	chip;
 
@@ -77,6 +93,11 @@ struct mcp23s08_driver_data {
 	struct mcp23s08		chip[];
 };
 
+/* This lock class tells lockdep that GPIO irqs are in a different
+ * category than their parents, so it won't report false recursion.
+ */
+static struct lock_class_key gpio_lock_class;
+
 /*----------------------------------------------------------------------*/
 
 #if IS_ENABLED(CONFIG_I2C)
@@ -316,6 +337,195 @@ mcp23s08_direction_output(struct gpio_chip *chip, unsigned offset, int value)
 }
 
 /*----------------------------------------------------------------------*/
+static irqreturn_t mcp23s08_irq(int irq, void *data)
+{
+	struct mcp23s08 *mcp = data;
+	int intcap, intf, i;
+	unsigned int child_irq;
+
+	mutex_lock(&mcp->lock);
+	intf = mcp->ops->read(mcp, MCP_INTF);
+	if (intf < 0) {
+		mutex_unlock(&mcp->lock);
+		return IRQ_HANDLED;
+	}
+
+	mcp->cache[MCP_INTF] = intf;
+
+	intcap = mcp->ops->read(mcp, MCP_INTCAP);
+	if (intcap < 0) {
+		mutex_unlock(&mcp->lock);
+		return IRQ_HANDLED;
+	}
+
+	mcp->cache[MCP_INTCAP] = intcap;
+	mutex_unlock(&mcp->lock);
+
+
+	for (i = 0; i < mcp->chip.ngpio; i++) {
+		if ((BIT(i) & mcp->cache[MCP_INTF]) &&
+		    ((BIT(i) & intcap & mcp->irq_rise) ||
+		     (mcp->irq_fall & ~intcap & BIT(i)))) {
+			child_irq = irq_find_mapping(mcp->irq_domain, i);
+			handle_nested_irq(child_irq);
+		}
+	}
+
+	return IRQ_HANDLED;
+}
+
+static int mcp23s08_gpio_to_irq(struct gpio_chip *chip, unsigned offset)
+{
+	struct mcp23s08 *mcp = container_of(chip, struct mcp23s08, chip);
+
+	return irq_find_mapping(mcp->irq_domain, offset);
+}
+
+static void mcp23s08_irq_mask(struct irq_data *data)
+{
+	struct mcp23s08 *mcp = irq_data_get_irq_chip_data(data);
+	unsigned int pos = data->hwirq;
+
+	mcp->cache[MCP_GPINTEN] &= ~BIT(pos);
+}
+
+static void mcp23s08_irq_unmask(struct irq_data *data)
+{
+	struct mcp23s08 *mcp = irq_data_get_irq_chip_data(data);
+	unsigned int pos = data->hwirq;
+
+	mcp->cache[MCP_GPINTEN] |= BIT(pos);
+}
+
+static int mcp23s08_irq_set_type(struct irq_data *data, unsigned int type)
+{
+	struct mcp23s08 *mcp = irq_data_get_irq_chip_data(data);
+	unsigned int pos = data->hwirq;
+	int status = 0;
+
+	if ((type & IRQ_TYPE_EDGE_BOTH) == IRQ_TYPE_EDGE_BOTH) {
+		mcp->cache[MCP_INTCON] &= ~BIT(pos);
+		mcp->irq_rise |= BIT(pos);
+		mcp->irq_fall |= BIT(pos);
+	} else if (type & IRQ_TYPE_EDGE_RISING) {
+		mcp->cache[MCP_INTCON] &= ~BIT(pos);
+		mcp->irq_rise |= BIT(pos);
+		mcp->irq_fall &= ~BIT(pos);
+	} else if (type & IRQ_TYPE_EDGE_FALLING) {
+		mcp->cache[MCP_INTCON] &= ~BIT(pos);
+		mcp->irq_rise &= ~BIT(pos);
+		mcp->irq_fall |= BIT(pos);
+	} else
+		return -EINVAL;
+
+	return status;
+}
+
+static void mcp23s08_irq_bus_lock(struct irq_data *data)
+{
+	struct mcp23s08 *mcp = irq_data_get_irq_chip_data(data);
+
+	mutex_lock(&mcp->irq_lock);
+}
+
+static void mcp23s08_irq_bus_unlock(struct irq_data *data)
+{
+	struct mcp23s08 *mcp = irq_data_get_irq_chip_data(data);
+
+	mutex_lock(&mcp->lock);
+	mcp->ops->write(mcp, MCP_GPINTEN, mcp->cache[MCP_GPINTEN]);
+	mcp->ops->write(mcp, MCP_DEFVAL, mcp->cache[MCP_DEFVAL]);
+	mcp->ops->write(mcp, MCP_INTCON, mcp->cache[MCP_INTCON]);
+	mutex_unlock(&mcp->lock);
+	mutex_unlock(&mcp->irq_lock);
+}
+
+static unsigned int mcp23s08_irq_startup(struct irq_data *data)
+{
+	struct mcp23s08 *mcp = irq_data_get_irq_chip_data(data);
+
+	if (gpio_lock_as_irq(&mcp->chip, data->hwirq))
+		dev_err(mcp->chip.dev,
+			"unable to lock HW IRQ %lu for IRQ usage\n",
+			data->hwirq);
+
+	mcp23s08_irq_unmask(data);
+	return 0;
+}
+
+static void mcp23s08_irq_shutdown(struct irq_data *data)
+{
+	struct mcp23s08 *mcp = irq_data_get_irq_chip_data(data);
+
+	mcp23s08_irq_mask(data);
+	gpio_unlock_as_irq(&mcp->chip, data->hwirq);
+}
+
+static struct irq_chip mcp23s08_irq_chip = {
+	.name = "gpio-mcp23xxx",
+	.irq_mask = mcp23s08_irq_mask,
+	.irq_unmask = mcp23s08_irq_unmask,
+	.irq_set_type = mcp23s08_irq_set_type,
+	.irq_bus_lock = mcp23s08_irq_bus_lock,
+	.irq_bus_sync_unlock = mcp23s08_irq_bus_unlock,
+	.irq_startup = mcp23s08_irq_startup,
+	.irq_shutdown = mcp23s08_irq_shutdown,
+};
+
+static int mcp23s08_irq_setup(struct mcp23s08 *mcp)
+{
+	struct gpio_chip *chip = &mcp->chip;
+	int err, irq, j;
+
+	mutex_init(&mcp->irq_lock);
+
+	mcp->irq_domain = irq_domain_add_linear(chip->of_node, chip->ngpio,
+						&irq_domain_simple_ops, mcp);
+	if (!mcp->irq_domain)
+		return -ENODEV;
+
+	err = devm_request_threaded_irq(chip->dev, mcp->irq, NULL, mcp23s08_irq,
+					IRQF_TRIGGER_LOW | IRQF_ONESHOT,
+					dev_name(chip->dev), mcp);
+	if (err != 0) {
+		dev_err(chip->dev, "unable to request IRQ#%d: %d\n",
+			mcp->irq, err);
+		return err;
+	}
+
+	chip->to_irq = mcp23s08_gpio_to_irq;
+
+	for (j = 0; j < mcp->chip.ngpio; j++) {
+		irq = irq_create_mapping(mcp->irq_domain, j);
+		irq_set_lockdep_class(irq, &gpio_lock_class);
+		irq_set_chip_data(irq, mcp);
+		irq_set_chip(irq, &mcp23s08_irq_chip);
+		irq_set_nested_thread(irq, true);
+#ifdef CONFIG_ARM
+		set_irq_flags(irq, IRQF_VALID);
+#else
+		irq_set_noprobe(irq);
+#endif
+	}
+	return 0;
+}
+
+static void mcp23s08_irq_teardown(struct mcp23s08 *mcp)
+{
+	unsigned int irq, i;
+
+	free_irq(mcp->irq, mcp);
+
+	for (i = 0; i < mcp->chip.ngpio; i++) {
+		irq = irq_find_mapping(mcp->irq_domain, i);
+		if (irq > 0)
+			irq_dispose_mapping(irq);
+	}
+
+	irq_domain_remove(mcp->irq_domain);
+}
+
+/*----------------------------------------------------------------------*/
 
 #ifdef CONFIG_DEBUG_FS
 
@@ -370,10 +580,11 @@ done:
 /*----------------------------------------------------------------------*/
 
 static int mcp23s08_probe_one(struct mcp23s08 *mcp, struct device *dev,
-			      void *data, unsigned addr,
-			      unsigned type, unsigned base, unsigned pullups)
+			      void *data, unsigned addr, unsigned type,
+			      unsigned base, unsigned pullups)
 {
 	int status;
+	bool mirror = false;
 
 	mutex_init(&mcp->lock);
 
@@ -432,13 +643,25 @@ static int mcp23s08_probe_one(struct mcp23s08 *mcp, struct device *dev,
 	/* verify MCP_IOCON.SEQOP = 0, so sequential reads work,
 	 * and MCP_IOCON.HAEN = 1, so we work with all chips.
 	 */
+
 	status = mcp->ops->read(mcp, MCP_IOCON);
 	if (status < 0)
 		goto fail;
-	if ((status & IOCON_SEQOP) || !(status & IOCON_HAEN)) {
+
+	mcp->irq_controller = of_property_read_bool(mcp->chip.of_node,
+						"interrupt-controller");
+	if (mcp->irq && mcp->irq_controller && (type == MCP_TYPE_017))
+		mirror = of_property_read_bool(mcp->chip.of_node,
+						"microchip,irq-mirror");
+
+	if ((status & IOCON_SEQOP) || !(status & IOCON_HAEN) || mirror) {
 		/* mcp23s17 has IOCON twice, make sure they are in sync */
 		status &= ~(IOCON_SEQOP | (IOCON_SEQOP << 8));
 		status |= IOCON_HAEN | (IOCON_HAEN << 8);
+		status &= ~(IOCON_INTPOL | (IOCON_INTPOL << 8));
+		if (mirror)
+			status |= IOCON_MIRROR | (IOCON_MIRROR << 8);
+
 		status = mcp->ops->write(mcp, MCP_IOCON, status);
 		if (status < 0)
 			goto fail;
@@ -470,6 +693,16 @@ static int mcp23s08_probe_one(struct mcp23s08 *mcp, struct device *dev,
 	}
 
 	status = gpiochip_add(&mcp->chip);
+	if (status < 0)
+		goto fail;
+
+	if (mcp->irq && mcp->irq_controller) {
+		status = mcp23s08_irq_setup(mcp);
+		if (status) {
+			mcp23s08_irq_teardown(mcp);
+			goto fail;
+		}
+	}
 fail:
 	if (status < 0)
 		dev_dbg(dev, "can't setup chip %d, --> %d\n",
@@ -546,6 +779,7 @@ static int mcp230xx_probe(struct i2c_client *client,
 	if (match || !pdata) {
 		base = -1;
 		pullups = 0;
+		client->irq = irq_of_parse_and_map(client->dev.of_node, 0);
 	} else {
 		if (!gpio_is_valid(pdata->base)) {
 			dev_dbg(&client->dev, "invalid platform data\n");
@@ -559,6 +793,7 @@ static int mcp230xx_probe(struct i2c_client *client,
 	if (!mcp)
 		return -ENOMEM;
 
+	mcp->irq = client->irq;
 	status = mcp23s08_probe_one(mcp, &client->dev, client, client->addr,
 				    id->driver_data, base, pullups);
 	if (status)
@@ -579,6 +814,9 @@ static int mcp230xx_remove(struct i2c_client *client)
 	struct mcp23s08 *mcp = i2c_get_clientdata(client);
 	int status;
 
+	if (client->irq && mcp->irq_controller)
+		mcp23s08_irq_teardown(mcp);
+
 	status = gpiochip_remove(&mcp->chip);
 	if (status == 0)
 		kfree(mcp);
-- 
1.8.5.2

