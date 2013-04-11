Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754858Ab3DKRL5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 13:11:57 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43139 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752898Ab3DKRLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 13:11:55 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Kukjin Kim <kgene.kim@samsung.com>, Sangbeom Kim <sbkim73@samsung.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2/2] mfd: wm8994: Add some OF properties
Date: Thu, 11 Apr 2013 18:11:51 +0100
Message-Id: <1365700312-7452-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1365700312-7452-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1365700312-7452-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add properties for some of the more important bits of platform data and
fill out the binding document.

Not all of the current platform data is suitable for the sort of fixed
configuration that is done using DT, some of it should have runtime
mechanisms added instead and some is unlikely to ever be used in practical
systems.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Tested-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
 Documentation/devicetree/bindings/sound/wm8994.txt |   58 +++++++++++++++-
 drivers/mfd/wm8994-core.c                          |   73 +++++++++++++++++++-
 2 files changed, 128 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/sound/wm8994.txt b/Documentation/devicetree/bindings/sound/wm8994.txt
index 7a7eb1e..f2f3e80 100644
--- a/Documentation/devicetree/bindings/sound/wm8994.txt
+++ b/Documentation/devicetree/bindings/sound/wm8994.txt
@@ -5,14 +5,70 @@ on the board).
 
 Required properties:
 
-  - compatible : "wlf,wm1811", "wlf,wm8994", "wlf,wm8958"
+  - compatible : One of "wlf,wm1811", "wlf,wm8994" or "wlf,wm8958".
 
   - reg : the I2C address of the device for I2C, the chip select
           number for SPI.
 
+  - gpio-controller : Indicates this device is a GPIO controller.
+  - #gpio-cells : Must be 2. The first cell is the pin number and the
+    second cell is used to specify optional parameters (currently unused).
+
+  - AVDD2-supply, DBVDD1-supply, DBVDD2-supply, DBVDD3-supply, CPVDD-supply,
+    SPKVDD1-supply, SPKVDD2-supply : power supplies for the device, as covered
+    in Documentation/devicetree/bindings/regulator/regulator.txt
+
+Optional properties:
+
+  - interrupts : The interrupt line the IRQ signal for the device is
+    connected to.  This is optional, if it is not connected then none
+    of the interrupt related properties should be specified.
+  - interrupt-controller : These devices contain interrupt controllers
+    and may provide interrupt services to other devices if they have an
+    interrupt line connected.
+  - interrupt-parent : The parent interrupt controller.
+  - #interrupt-cells: the number of cells to describe an IRQ, this should be 2.
+    The first cell is the IRQ number.
+    The second cell is the flags, encoded as the trigger masks from
+    Documentation/devicetree/bindings/interrupts.txt
+
+  - wlf,gpio-cfg : A list of GPIO configuration register values. If absent,
+    no configuration of these registers is performed. If any value is
+    over 0xffff then the register will be left as default. If present 11
+    values must be supplied.
+
+  - wlf,micbias-cfg : Two MICBIAS register values for WM1811 or
+    WM8958.  If absent the register defaults will be used.
+
+  - wlf,ldo1ena : GPIO specifier for control of LDO1ENA input to device.
+  - wlf,ldo2ena : GPIO specifier for control of LDO2ENA input to device.
+
+  - wlf,lineout1-se : If present LINEOUT1 is in single ended mode.
+  - wlf,lineout2-se : If present LINEOUT2 is in single ended mode.
+
+  - wlf,lineout1-feedback : If present LINEOUT1 has common mode feedback
+    connected.
+  - wlf,lineout2-feedback : If present LINEOUT2 has common mode feedback
+    connected.
+
+  - wlf,ldoena-always-driven : If present LDOENA is always driven.
+
 Example:
 
 codec: wm8994@1a {
 	compatible = "wlf,wm8994";
 	reg = <0x1a>;
+
+	gpio-controller;
+	#gpio-cells = <2>;
+
+	lineout1-se;
+
+	AVDD2-supply = <&regulator>;
+	CPVDD-supply = <&regulator>;
+	DBVDD1-supply = <&regulator>;
+	DBVDD2-supply = <&regulator>;
+	DBVDD3-supply = <&regulator>;
+	SPKVDD1-supply = <&regulator>;
+	SPKVDD2-supply = <&regulator>;
 };
diff --git a/drivers/mfd/wm8994-core.c b/drivers/mfd/wm8994-core.c
index 3f8d591..00e4fe2 100644
--- a/drivers/mfd/wm8994-core.c
+++ b/drivers/mfd/wm8994-core.c
@@ -19,6 +19,9 @@
 #include <linux/err.h>
 #include <linux/delay.h>
 #include <linux/mfd/core.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
+#include <linux/of_gpio.h>
 #include <linux/pm_runtime.h>
 #include <linux/regmap.h>
 #include <linux/regulator/consumer.h>
@@ -396,6 +399,60 @@ static const struct reg_default wm1811_reva_patch[] = {
 	{ 0x102, 0x0 },
 };
 
+#ifdef CONFIG_OF
+static int wm8994_set_pdata_from_of(struct wm8994 *wm8994)
+{
+	struct device_node *np = wm8994->dev->of_node;
+	struct wm8994_pdata *pdata = &wm8994->pdata;
+	int i;
+
+	if (!np)
+		return 0;
+
+	if (of_property_read_u32_array(np, "wlf,gpio-cfg", pdata->gpio_defaults,
+				       ARRAY_SIZE(pdata->gpio_defaults)) >= 0) {
+		for (i = 0; i < ARRAY_SIZE(pdata->gpio_defaults); i++) {
+			if (wm8994->pdata.gpio_defaults[i] == 0)
+				pdata->gpio_defaults[i]
+					= WM8994_CONFIGURE_GPIO;
+		}
+	}
+
+	of_property_read_u32_array(np, "wlf,micbias-cfg", pdata->micbias,
+				   ARRAY_SIZE(pdata->micbias));
+
+	pdata->lineout1_diff = true;
+	pdata->lineout2_diff = true;
+	if (of_find_property(np, "wlf,lineout1-se", NULL))
+		pdata->lineout1_diff = false;
+	if (of_find_property(np, "wlf,lineout2-se", NULL))
+		pdata->lineout2_diff = false;
+
+	if (of_find_property(np, "wlf,lineout1-feedback", NULL))
+		pdata->lineout1fb = true;
+	if (of_find_property(np, "wlf,lineout2-feedback", NULL))
+		pdata->lineout2fb = true;
+
+	if (of_find_property(np, "wlf,ldoena-always-driven", NULL))
+		pdata->lineout2fb = true;
+
+	pdata->ldo[0].enable = of_get_named_gpio(np, "wlf,ldo1ena", 0);
+	if (pdata->ldo[0].enable < 0)
+		pdata->ldo[0].enable = 0;
+
+	pdata->ldo[1].enable = of_get_named_gpio(np, "wlf,ldo2ena", 0);
+	if (pdata->ldo[1].enable < 0)
+		pdata->ldo[1].enable = 0;
+
+	return 0;
+}
+#else
+static int wm8994_set_pdata_from_of(struct wm8994 *wm8994)
+{
+	return 0;
+}
+#endif
+
 /*
  * Instantiate the generic non-control parts of the device.
  */
@@ -414,6 +471,10 @@ static int wm8994_device_init(struct wm8994 *wm8994, int irq)
 	}
 	pdata = &wm8994->pdata;
 
+	ret = wm8994_set_pdata_from_of(wm8994);
+	if (ret != 0)
+		return ret;
+
 	dev_set_drvdata(wm8994->dev, wm8994);
 
 	/* Add the on-chip regulators first for bootstrapping */
@@ -683,6 +744,7 @@ MODULE_DEVICE_TABLE(of, wm8994_of_match);
 static int wm8994_i2c_probe(struct i2c_client *i2c,
 				      const struct i2c_device_id *id)
 {
+	const struct of_device_id *of_id;
 	struct wm8994 *wm8994;
 	int ret;
 
@@ -693,7 +755,14 @@ static int wm8994_i2c_probe(struct i2c_client *i2c,
 	i2c_set_clientdata(i2c, wm8994);
 	wm8994->dev = &i2c->dev;
 	wm8994->irq = i2c->irq;
-	wm8994->type = id->driver_data;
+
+	if (i2c->dev.of_node) {
+		of_id = of_match_device(wm8994_of_match, &i2c->dev);
+		if (of_id)
+			wm8994->type = (int)of_id->data;
+	} else {
+		wm8994->type = id->driver_data;
+	}
 
 	wm8994->regmap = devm_regmap_init_i2c(i2c, &wm8994_base_regmap_config);
 	if (IS_ERR(wm8994->regmap)) {
@@ -733,7 +802,7 @@ static struct i2c_driver wm8994_i2c_driver = {
 		.name = "wm8994",
 		.owner = THIS_MODULE,
 		.pm = &wm8994_pm_ops,
-		.of_match_table = wm8994_of_match,
+		.of_match_table = of_match_ptr(wm8994_of_match),
 	},
 	.probe = wm8994_i2c_probe,
 	.remove = wm8994_i2c_remove,
-- 
1.7.10.4

