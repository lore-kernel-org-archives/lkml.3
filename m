Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755586Ab3EUSN5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 14:13:57 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:46889 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755561Ab3EUSNz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 14:13:55 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Tue, 21 May 2013 13:13:19 -0500
Message-Id: <1369160001-4019-5-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1369160001-4019-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20130521181230.GF1627@sirena.org.uk>
 <1369160001-4019-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-SA-Exim-Connect-IP: 144.188.69.1
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [PATCH 5/7] mfd: Add device tree bindings for Arizona class devices
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 Documentation/devicetree/bindings/mfd/arizona.txt |   62 ++++++++++++++++++
 drivers/mfd/arizona-core.c                        |   69 +++++++++++++++++++++
 drivers/mfd/arizona-i2c.c                         |   10 ++-
 drivers/mfd/arizona-spi.c                         |   10 ++-
 drivers/mfd/arizona.h                             |   12 ++++
 5 files changed, 159 insertions(+), 4 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mfd/arizona.txt

diff --git a/Documentation/devicetree/bindings/mfd/arizona.txt b/Documentation/devicetree/bindings/mfd/arizona.txt
new file mode 100644
index 0000000..0e295c9
--- /dev/null
+++ b/Documentation/devicetree/bindings/mfd/arizona.txt
@@ -0,0 +1,62 @@
+Wolfson Arizona class audio SoCs
+
+These devices are audio SoCs with extensive digital capabilites and a range
+of analogue I/O.
+
+Required properties:
+
+  - compatible : one of the following chip-specific strings:
+	"wlf,wm5102"
+	"wlf,wm5110"
+  - reg : I2C slave address when connected using I2C, chip select number when
+    using SPI.
+
+  - interrupts : The interrupt line the /IRQ signal for the device is
+    connected to.
+  - interrupt-controller : Arizona class devices contain interrupt controllers
+    and may provide interrupt services to other devices.
+  - interrupt-parent : The parent interrupt controller.
+  - #interrupt-cells: the number of cells to describe an IRQ, this should be 2.
+    The first cell is the IRQ number.
+    The second cell is the flags, encoded as the trigger masks from
+    Documentation/devicetree/bindings/interrupts.txt
+
+  - gpio-controller : Indicates this device is a GPIO controller.
+  - #gpio-cells : Must be 2. The first cell is the pin number and the
+    second cell is used to specify optional parameters (currently unused).
+
+  - AVDD1-supply, DBVDD1-supply, DBVDD2-supply, DBVDD3-supply, CPVDD-supply,
+    SPKVDDL-supply, SPKVDDR-supply : power supplies for the device, as covered
+    in Documentation/devicetree/bindings/regulator/regulator.txt
+
+Optional properties:
+
+  - wlf,reset : GPIO specifier for the GPIO controlling /RESET
+  - wlf,ldoena : GPIO specifier for the GPIO controlling LDOENA
+
+  - wlf,gpio-defaults : A list of GPIO configuration register values. If
+    absent, no configuration of these registers is performed. If any
+    entry has a value that is out of range for a 16 bit register then
+    the chip default will be used.  If present exactly five values must
+    be specified.
+
+Example:
+
+codec: wm5102@1a {
+	compatible = "wlf,wm5102";
+	reg = <0x1a>;
+	interrupts = <347>;
+	#interrupt-cells = <2>;
+        interrupt-parent = <&gic>;
+
+	gpio-controller;
+	#gpio-cells = <2>;
+
+	wlf,gpio-defaults = <
+		0x00000000, /* AIF1TXLRCLK */
+		0xffffffff,
+		0xffffffff,
+		0xffffffff,
+		0xffffffff,
+	>;
+};
diff --git a/drivers/mfd/arizona-core.c b/drivers/mfd/arizona-core.c
index 549db0a..d8d30c0 100644
--- a/drivers/mfd/arizona-core.c
+++ b/drivers/mfd/arizona-core.c
@@ -16,6 +16,9 @@
 #include <linux/interrupt.h>
 #include <linux/mfd/core.h>
 #include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
+#include <linux/of_gpio.h>
 #include <linux/pm_runtime.h>
 #include <linux/regmap.h>
 #include <linux/regulator/consumer.h>
@@ -462,6 +465,70 @@ const struct dev_pm_ops arizona_pm_ops = {
 };
 EXPORT_SYMBOL_GPL(arizona_pm_ops);
 
+#ifdef CONFIG_OF
+int arizona_of_get_type(struct device *dev)
+{
+	const struct of_device_id *id = of_match_device(arizona_of_match, dev);
+
+	if (id)
+		return (int)id->data;
+	else
+		return 0;
+}
+EXPORT_SYMBOL_GPL(arizona_of_get_type);
+
+static int arizona_of_get_core_pdata(struct arizona *arizona)
+{
+	int ret, i;
+
+	arizona->pdata.reset = of_get_named_gpio(arizona->dev->of_node,
+						 "wlf,reset", 0);
+	if (arizona->pdata.reset < 0)
+		arizona->pdata.reset = 0;
+
+	arizona->pdata.ldoena = of_get_named_gpio(arizona->dev->of_node,
+						  "wlf,ldoena", 0);
+	if (arizona->pdata.ldoena < 0)
+		arizona->pdata.ldoena = 0;
+
+	ret = of_property_read_u32_array(arizona->dev->of_node,
+					 "wlf,gpio-defaults",
+					 arizona->pdata.gpio_defaults,
+					 ARRAY_SIZE(arizona->pdata.gpio_defaults));
+	if (ret >= 0) {
+		/*
+		 * All values are literal except out of range values
+		 * which are chip default, translate into platform
+		 * data which uses 0 as chip default and out of range
+		 * as zero.
+		 */
+		for (i = 0; i < ARRAY_SIZE(arizona->pdata.gpio_defaults); i++) {
+			if (arizona->pdata.gpio_defaults[i] > 0xffff)
+				arizona->pdata.gpio_defaults[i] = 0;
+			if (arizona->pdata.gpio_defaults[i] == 0)
+				arizona->pdata.gpio_defaults[i] = 0x10000;
+		}
+	} else {
+		dev_err(arizona->dev, "Failed to parse GPIO defaults: %d\n",
+			ret);
+	}
+
+	return 0;
+}
+
+const struct of_device_id arizona_of_match[] = {
+	{ .compatible = "wlf,wm5102", .data = (void *)WM5102 },
+	{ .compatible = "wlf,wm5110", .data = (void *)WM5110 },
+	{},
+};
+EXPORT_SYMBOL_GPL(arizona_of_match);
+#else
+static inline int arizona_of_get_core_pdata(struct arizona *arizona)
+{
+	return 0;
+}
+#endif
+
 static struct mfd_cell early_devs[] = {
 	{ .name = "arizona-ldo1" },
 };
@@ -495,6 +562,8 @@ int arizona_dev_init(struct arizona *arizona)
 	dev_set_drvdata(arizona->dev, arizona);
 	mutex_init(&arizona->clk_lock);
 
+	arizona_of_get_core_pdata(arizona);
+
 	if (dev_get_platdata(arizona->dev))
 		memcpy(&arizona->pdata, dev_get_platdata(arizona->dev),
 		       sizeof(arizona->pdata));
diff --git a/drivers/mfd/arizona-i2c.c b/drivers/mfd/arizona-i2c.c
index 44a1bb9..deb267e 100644
--- a/drivers/mfd/arizona-i2c.c
+++ b/drivers/mfd/arizona-i2c.c
@@ -27,9 +27,14 @@ static int arizona_i2c_probe(struct i2c_client *i2c,
 {
 	struct arizona *arizona;
 	const struct regmap_config *regmap_config;
-	int ret;
+	int ret, type;
 
-	switch (id->driver_data) {
+	if (i2c->dev.of_node)
+		type = arizona_of_get_type(&i2c->dev);
+	else
+		type = id->driver_data;
+
+	switch (type) {
 #ifdef CONFIG_MFD_WM5102
 	case WM5102:
 		regmap_config = &wm5102_i2c_regmap;
@@ -84,6 +89,7 @@ static struct i2c_driver arizona_i2c_driver = {
 		.name	= "arizona",
 		.owner	= THIS_MODULE,
 		.pm	= &arizona_pm_ops,
+		.of_match_table	= of_match_ptr(arizona_of_match),
 	},
 	.probe		= arizona_i2c_probe,
 	.remove		= arizona_i2c_remove,
diff --git a/drivers/mfd/arizona-spi.c b/drivers/mfd/arizona-spi.c
index b57e642..47be7b3 100644
--- a/drivers/mfd/arizona-spi.c
+++ b/drivers/mfd/arizona-spi.c
@@ -27,9 +27,14 @@ static int arizona_spi_probe(struct spi_device *spi)
 	const struct spi_device_id *id = spi_get_device_id(spi);
 	struct arizona *arizona;
 	const struct regmap_config *regmap_config;
-	int ret;
+	int ret, type;
 
-	switch (id->driver_data) {
+	if (spi->dev.of_node)
+		type = arizona_of_get_type(&spi->dev);
+	else
+		type = id->driver_data;
+
+	switch (type) {
 #ifdef CONFIG_MFD_WM5102
 	case WM5102:
 		regmap_config = &wm5102_spi_regmap;
@@ -84,6 +89,7 @@ static struct spi_driver arizona_spi_driver = {
 		.name	= "arizona",
 		.owner	= THIS_MODULE,
 		.pm	= &arizona_pm_ops,
+		.of_match_table	= of_match_ptr(arizona_of_match),
 	},
 	.probe		= arizona_spi_probe,
 	.remove		= arizona_spi_remove,
diff --git a/drivers/mfd/arizona.h b/drivers/mfd/arizona.h
index 9798ae5..db55d98 100644
--- a/drivers/mfd/arizona.h
+++ b/drivers/mfd/arizona.h
@@ -13,6 +13,7 @@
 #ifndef _WM5102_H
 #define _WM5102_H
 
+#include <linux/of.h>
 #include <linux/regmap.h>
 #include <linux/pm.h>
 
@@ -26,6 +27,8 @@ extern const struct regmap_config wm5110_spi_regmap;
 
 extern const struct dev_pm_ops arizona_pm_ops;
 
+extern const struct of_device_id arizona_of_match[];
+
 extern const struct regmap_irq_chip wm5102_aod;
 extern const struct regmap_irq_chip wm5102_irq;
 
@@ -37,4 +40,13 @@ int arizona_dev_exit(struct arizona *arizona);
 int arizona_irq_init(struct arizona *arizona);
 int arizona_irq_exit(struct arizona *arizona);
 
+#ifdef CONFIG_OF
+int arizona_of_get_type(struct device *dev);
+#else
+static inline int arizona_of_get_type(struct device *dev)
+{
+	return 0;
+}
+#endif
+
 #endif
-- 
1.7.10.4

