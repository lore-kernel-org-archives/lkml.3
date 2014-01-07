Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752492AbaAGOGP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 09:06:15 -0500
Received: from atlantis.wh2.tu-dresden.de ([141.30.228.39]:47725 "EHLO
	atlantis.wh2.tu-dresden.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751403AbaAGOGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 09:06:04 -0500
From: Lars Poeschel <larsi@wh2.tu-dresden.de>
To: poeschel@lemonage.de, rob.herring@calxeda.com, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, rob@landley.net, linus.walleij@linaro.org,
        gnurou@gmail.com, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-gpio@vger.kernel.org
Subject: [PATCH] gpio: mcp23s08: Add irq functionality for i2c chips
Date: Tue,  7 Jan 2014 15:05:48 +0100
Message-Id: <1389103548-23458-1-git-send-email-larsi@wh2.tu-dresden.de>
X-Mailer: git-send-email 1.8.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Poeschel <poeschel@lemonage.de>

This adds interrupt functionality for i2c chips to the driver.
They can act as a interrupt-controller and generate interrupts, if
the inputs change.
This is tested on a mcp23017 chip.

Signed-off-by: Lars Poeschel <poeschel@lemonage.de>
---
 .../devicetree/bindings/gpio/gpio-mcp23s08.txt     |  21 +-
 drivers/gpio/Kconfig                               |   1 +
 drivers/gpio/gpio-mcp23s08.c                       | 220 ++++++++++++++++++++-
 3 files changed, 236 insertions(+), 6 deletions(-)

diff --git a/Documentation/devicetree/bindings/gpio/gpio-mcp23s08.txt b/Documentation/devicetree/bindings/gpio/gpio-mcp23s08.txt
index daa3017..b8376f3 100644
--- a/Documentation/devicetree/bindings/gpio/gpio-mcp23s08.txt
+++ b/Documentation/devicetree/bindings/gpio/gpio-mcp23s08.txt
@@ -38,12 +38,31 @@ Required device specific properties (only for SPI chips):
     removed.
 - spi-max-frequency = The maximum frequency this chip is able to handle
 
-Example I2C:
+Optional properties:
+- #interrupt-cells : Should be two.
+  - first cell is the pin number
+  - second cell is used to specify flags.
+- interrupt-controller: Marks the device node as a interrupt controller.
+NOTE: The interrupt functionality is only supported for i2c versions of the
+chips yet.
+
+Optional device specific properties:
+- microchip,irq-mirror: Sets the mirror flag in the IOCON register. This causes
+        devices with two interrupt outputs to always trigger both interrupt
+        outputs regardless where the interrupt happened.
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
index 2deb0c5..df32b90 100644
--- a/drivers/gpio/gpio-mcp23s08.c
+++ b/drivers/gpio/gpio-mcp23s08.c
@@ -1,5 +1,10 @@
 /*
- * MCP23S08 SPI/GPIO gpio expander driver
+ * MCP23S08 SPI/I2C GPIO gpio expander driver
+ *
+ * The inputs and outputs of the mcp23s08, mcp23s17, mcp23008 and mcp23017 are
+ * supported.
+ * For the I2C versions of the chips (mcp23008 and mcp23017) generation of
+ * interrupts is also supported.
  */
 
 #include <linux/kernel.h>
@@ -12,7 +17,8 @@
 #include <linux/spi/mcp23s08.h>
 #include <linux/slab.h>
 #include <asm/byteorder.h>
-#include <linux/of.h>
+#include <linux/interrupt.h>
+#include <linux/of_irq.h>
 #include <linux/of_device.h>
 
 /**
@@ -34,6 +40,7 @@
 #define MCP_DEFVAL	0x03
 #define MCP_INTCON	0x04
 #define MCP_IOCON	0x05
+#	define IOCON_MIRROR	(1 << 6)
 #	define IOCON_SEQOP	(1 << 5)
 #	define IOCON_HAEN	(1 << 3)
 #	define IOCON_ODR	(1 << 2)
@@ -57,8 +64,13 @@ struct mcp23s08 {
 	u8			addr;
 
 	u16			cache[11];
+	u16			irq_rise;
+	u16			irq_fall;
+	int			irq;
 	/* lock protects the cached values */
 	struct mutex		lock;
+	struct mutex		irq_lock;
+	struct irq_domain	*irq_domain;
 
 	struct gpio_chip	chip;
 
@@ -316,6 +328,179 @@ mcp23s08_direction_output(struct gpio_chip *chip, unsigned offset, int value)
 }
 
 /*----------------------------------------------------------------------*/
+static irqreturn_t mcp23s08_irq(int irq, void *data)
+{
+	struct mcp23s08 *mcp = data;
+	int intcap, intf, i;
+	unsigned int virq;
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
+			virq = irq_find_mapping(mcp->irq_domain, i);
+			handle_nested_irq(virq);
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
+	return irq_create_mapping(mcp->irq_domain, offset);
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
+static struct irq_chip mcp23s08_irq_chip = {
+	.name = "gpio-mcp23xxx",
+	.irq_mask = mcp23s08_irq_mask,
+	.irq_unmask = mcp23s08_irq_unmask,
+	.irq_set_type = mcp23s08_irq_set_type,
+	.irq_bus_lock = mcp23s08_irq_bus_lock,
+	.irq_bus_sync_unlock = mcp23s08_irq_bus_unlock,
+};
+
+static int mcp23s08_irq_map(struct irq_domain *domain, unsigned int irq,
+			    irq_hw_number_t hwirq)
+{
+	irq_set_chip_data(irq, domain->host_data);
+	irq_set_chip(irq, &mcp23s08_irq_chip);
+	irq_set_nested_thread(irq, true);
+
+#ifdef CONFIG_ARM
+	set_irq_flags(irq, IRQF_VALID);
+#else
+	irq_set_noprobe(irq);
+#endif
+	return 0;
+}
+
+static const struct irq_domain_ops mcp23s08_irq_domain_ops = {
+	.map = mcp23s08_irq_map,
+	.xlate = irq_domain_xlate_twocell,
+};
+
+static int mcp23s08_irq_setup(struct mcp23s08 *mcp, struct device *dev)
+{
+	struct gpio_chip *chip = &mcp->chip;
+	int err;
+
+	mutex_init(&mcp->irq_lock);
+
+	mcp->irq_domain = irq_domain_add_linear(chip->of_node, chip->ngpio,
+						&mcp23s08_irq_domain_ops, mcp);
+	if (!mcp->irq_domain)
+		return -ENODEV;
+
+	err = devm_request_threaded_irq(dev, mcp->irq, NULL, mcp23s08_irq,
+					IRQF_TRIGGER_LOW | IRQF_ONESHOT,
+					dev_name(chip->dev), mcp);
+	if (err != 0) {
+		dev_err(chip->dev, "unable to request IRQ#%d: %d\n",
+			mcp->irq, err);
+		return err;
+	}
+
+	chip->to_irq = mcp23s08_gpio_to_irq;
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
 
@@ -370,10 +555,11 @@ done:
 /*----------------------------------------------------------------------*/
 
 static int mcp23s08_probe_one(struct mcp23s08 *mcp, struct device *dev,
-			      void *data, unsigned addr,
-			      unsigned type, unsigned base, unsigned pullups)
+			      void *data, unsigned addr, unsigned type,
+			      unsigned base, unsigned pullups)
 {
 	int status;
+	struct property *mirror;
 
 	mutex_init(&mcp->lock);
 
@@ -432,13 +618,21 @@ static int mcp23s08_probe_one(struct mcp23s08 *mcp, struct device *dev,
 	/* verify MCP_IOCON.SEQOP = 0, so sequential reads work,
 	 * and MCP_IOCON.HAEN = 1, so we work with all chips.
 	 */
+
 	status = mcp->ops->read(mcp, MCP_IOCON);
 	if (status < 0)
 		goto fail;
-	if ((status & IOCON_SEQOP) || !(status & IOCON_HAEN)) {
+
+	mirror = of_find_property(mcp->chip.of_node,
+				  "microchip,irq-mirror", NULL);
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
@@ -469,7 +663,17 @@ static int mcp23s08_probe_one(struct mcp23s08 *mcp, struct device *dev,
 			goto fail;
 	}
 
+	if (mcp->irq &&
+	    of_find_property(mcp->chip.of_node, "interrupt-controller", NULL)) {
+		status = mcp23s08_irq_setup(mcp, dev);
+		if (status) {
+			mcp23s08_irq_teardown(mcp);
+			goto fail;
+		}
+	}
+
 	status = gpiochip_add(&mcp->chip);
+
 fail:
 	if (status < 0)
 		dev_dbg(dev, "can't setup chip %d, --> %d\n",
@@ -546,6 +750,7 @@ static int mcp230xx_probe(struct i2c_client *client,
 	if (match || !pdata) {
 		base = -1;
 		pullups = 0;
+		client->irq = irq_of_parse_and_map(client->dev.of_node, 0);
 	} else {
 		if (!gpio_is_valid(pdata->base)) {
 			dev_dbg(&client->dev, "invalid platform data\n");
@@ -559,6 +764,7 @@ static int mcp230xx_probe(struct i2c_client *client,
 	if (!mcp)
 		return -ENOMEM;
 
+	mcp->irq = client->irq;
 	status = mcp23s08_probe_one(mcp, &client->dev, client, client->addr,
 				    id->driver_data, base, pullups);
 	if (status)
@@ -583,6 +789,10 @@ static int mcp230xx_remove(struct i2c_client *client)
 	if (status == 0)
 		kfree(mcp);
 
+	if (client->irq &&
+	    of_find_property(mcp->chip.of_node, "interrupt-controller", NULL))
+		mcp23s08_irq_teardown(mcp);
+
 	return status;
 }
 
-- 
1.8.5.2

