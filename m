Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756166Ab3ETMgW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 08:36:22 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:53580 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755466Ab3ETMgU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 08:36:20 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Mark Brown <broonie@kernel.org>
CC: Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v3] regulator: lp872x: support the device tree feature
Thread-Topic: [PATCH v3] regulator: lp872x: support the device tree feature
Thread-Index: Ac5VVph+EhaG3dSITvu2iVARtCGhHA==
Date: Mon, 20 May 2013 12:36:07 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F82E5F679@DQHE06.ent.ti.com>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.34.32]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables the DT structure of the LP8720 and LP8725 device.
The LP872x platform data is generated when the device tree is configured.
Even if the platform data is NULL, it is no issue at all because the driver is
configured with the default mode.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
Patch v3.
  Use of_regulator_match() for getting multiple regulator init data.
  Rename properties for custom features such like 'ti,general-config'.
  Add more detailed descriptions in the LP872x binding.

Patch v2.
  Move opmode code of the device tree from 'of_regulator' to the lp872x
  because its mode depends on the device.
  Change on the DVS initialization:
  When a DVS GPIO is invalid, use the default mode instead of returning error.

Patch v1.
  Initial patch

 .../devicetree/bindings/regulator/lp872x.txt       |  160 ++++++++++++++++++++
 drivers/regulator/lp872x.c                         |  116 +++++++++++++-
 2 files changed, 274 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/regulator/lp872x.txt

diff --git a/Documentation/devicetree/bindings/regulator/lp872x.txt b/Documentation/devicetree/bindings/regulator/lp872x.txt
new file mode 100644
index 0000000..7818318
--- /dev/null
+++ b/Documentation/devicetree/bindings/regulator/lp872x.txt
@@ -0,0 +1,160 @@
+Binding for TI/National Semiconductor LP872x Driver
+
+Required properties:
+  - compatible: "ti,lp8720" or "ti,lp8725"
+  - reg: I2C slave address. 0x7d = LP8720, 0x7a = LP8725
+
+Optional properties:
+  - ti,general-config: the value of LP872X_GENERAL_CFG register (u8)
+    (LP8720)
+    bit[2]: BUCK output voltage control by external DVS pin or register
+            1 = external pin, 0 = bit7 of register 08h
+    bit[1]: sleep control by external DVS pin or register
+            1 = external pin, 0 = bit6 of register 08h
+    bit[0]: time step unit(usec). 1 = 25, 0 = 50
+
+    (LP8725)
+    bit[7:6]: time step unit(usec). 00 = 32, 01 = 64, 10 = 128, 11 = 256
+    bit[4]:   BUCK2 enable control. 1 = enable, 0 = disable
+    bit[3]:   BUCK2 output voltage register address. 1 = 0Ah, 0 = 0Bh
+    bit[2]:   BUCK1 output voltage control by external DVS pin or register
+              1 = register 08h, 0 = DVS
+    bit[1]:   LDO sleep control. 1 = sleep mode, 0 = normal
+    bit[0]:   BUCK1 enable control, 1 = enable, 0 = disable
+
+    For more details, please see the datasheet.
+
+  - ti,update-config: define it when LP872X_GENERAL_CFG register should be set
+  - ti,dvs-gpio: GPIO specifier for external DVS pin control of LP872x devices.
+  - ti,dvs-vsel: DVS selector. 0 = SEL_V1, 1 = SEL_V2.
+  - ti,dvs-state: initial DVS pin state. 0 = DVS_LOW, 1 = DVS_HIGH.
+
+  Sub nodes for regulator_init_data
+    LP8720 has maximum 6 nodes. (child name: ldo1 ~ 5 and buck)
+    LP8725 has maximum 9 nodes. (child name: ldo1 ~ 5, lilo1,2 and buck1,2)
+    For more details, please see the following binding document.
+    (Documentation/devicetree/bindings/regulator/regulator.txt)
+
+Datasheet
+  - LP8720: http://www.ti.com/lit/ds/symlink/lp8720.pdf
+  - LP8725: http://www.ti.com/lit/ds/symlink/lp8725.pdf
+
+Example 1) LP8720
+
+lp8720@7d {
+	compatible = "ti,lp8720";
+	reg = <0x7d>;
+
+	/* external DVS pin used, timestep is 25usec */
+	ti,general-config = /bits/ 8 <0x03>;
+	ti,update-config;
+
+	/*
+	 * The dvs-gpio depends on the processor environment.
+	 * For example, following GPIO specifier means GPIO134 in OMAP4.
+	 */
+	ti,dvs-gpio = <&gpio5 6 0>;
+	ti,dvs-vsel = /bits/ 8 <1>;		/* SEL_V2 */
+	ti,dvs-state = /bits/ 8 <1>;		/* DVS_HIGH */
+
+	vaf: ldo1 {
+		regulator-min-microvolt = <1200000>;
+		regulator-max-microvolt = <3300000>;
+	};
+
+	vmmc: ldo2 {
+		regulator-min-microvolt = <1200000>;
+		regulator-max-microvolt = <3300000>;
+	};
+
+	vcam_io: ldo3 {
+		regulator-min-microvolt = <1200000>;
+		regulator-max-microvolt = <3300000>;
+		regulator-boot-on;
+	};
+
+	vcam_core: ldo4 {
+		regulator-min-microvolt = <800000>;
+		regulator-max-microvolt = <2850000>;
+		regulator-boot-on;
+	};
+
+	vcam: ldo5 {
+		regulator-min-microvolt = <1200000>;
+		regulator-max-microvolt = <3300000>;
+	};
+
+	vcc: buck {
+		regulator-name = "VBUCK";
+		regulator-min-microvolt = <800000>;
+		regulator-max-microvolt = <2300000>;
+	};
+};
+
+Example 2) LP8725
+
+lp8725@7a {
+	compatible = "ti,lp8725";
+	reg = <0x7a>;
+
+	/* Enable BUCK1,2, no DVS, normal LDO mode, timestep is 256usec */
+	ti,general-config = /bits/ 8 <0xdd>;
+	ti,update-config;
+
+	vcam_io: ldo1 {
+		regulator-min-microvolt = <1200000>;
+		regulator-max-microvolt = <3300000>;
+	};
+
+	vcam_core: ldo2 {
+		regulator-min-microvolt = <1200000>;
+		regulator-max-microvolt = <3300000>;
+	};
+
+	vcam: ldo3 {
+		regulator-min-microvolt = <1200000>;
+		regulator-max-microvolt = <3300000>;
+	};
+
+	vcmmb_io: ldo4 {
+		regulator-min-microvolt = <1200000>;
+		regulator-max-microvolt = <3300000>;
+		regulator-boot-on;
+	};
+
+	vcmmb_core: ldo5 {
+		regulator-min-microvolt = <1200000>;
+		regulator-max-microvolt = <3300000>;
+		regulator-boot-on;
+	};
+
+	vaux1: lilo1 {
+		regulator-name = "VAUX1";
+		regulator-min-microvolt = <800000>;
+		regulator-max-microvolt = <3300000>;
+	};
+
+	vaux2: lilo2 {
+		regulator-name = "VAUX2";
+		regulator-min-microvolt = <800000>;
+		regulator-max-microvolt = <3300000>;
+	};
+
+	vcc1: buck1 {
+		regulator-name = "VBUCK1";
+		regulator-min-microvolt = <800000>;
+		regulator-max-microvolt = <3000000>;
+		regulator-min-microamp  = <460000>;
+		regulator-max-microamp  = <1370000>;
+		regulator-boot-on;
+	};
+
+	vcc2: buck2 {
+		regulator-name = "VBUCK2";
+		regulator-min-microvolt = <800000>;
+		regulator-max-microvolt = <3000000>;
+		regulator-min-microamp  = <460000>;
+		regulator-max-microamp  = <1370000>;
+		regulator-boot-on;
+	};
+};
diff --git a/drivers/regulator/lp872x.c b/drivers/regulator/lp872x.c
index f5fc4a1..b16336b 100644
--- a/drivers/regulator/lp872x.c
+++ b/drivers/regulator/lp872x.c
@@ -18,6 +18,9 @@
 #include <linux/regulator/lp872x.h>
 #include <linux/regulator/driver.h>
 #include <linux/platform_device.h>
+#include <linux/of.h>
+#include <linux/of_gpio.h>
+#include <linux/regulator/of_regulator.h>
 
 /* Registers : LP8720/8725 shared */
 #define LP872X_GENERAL_CFG		0x00
@@ -723,8 +726,8 @@ static int lp872x_init_dvs(struct lp872x *lp)
 
 	gpio = dvs->gpio;
 	if (!gpio_is_valid(gpio)) {
-		dev_err(lp->dev, "invalid gpio: %d\n", gpio);
-		return -EINVAL;
+		dev_warn(lp->dev, "invalid gpio: %d\n", gpio);
+		goto set_default_dvs_mode;
 	}
 
 	pinstate = dvs->init_state;
@@ -829,6 +832,103 @@ static const struct regmap_config lp872x_regmap_config = {
 	.max_register = MAX_REGISTERS,
 };
 
+#ifdef CONFIG_OF
+
+#define LP872X_VALID_OPMODE	(REGULATOR_MODE_FAST | REGULATOR_MODE_NORMAL)
+
+static struct of_regulator_match lp8720_matches[] = {
+	{ .name = "ldo1", .driver_data = (void *)LP8720_ID_LDO1, },
+	{ .name = "ldo2", .driver_data = (void *)LP8720_ID_LDO2, },
+	{ .name = "ldo3", .driver_data = (void *)LP8720_ID_LDO3, },
+	{ .name = "ldo4", .driver_data = (void *)LP8720_ID_LDO4, },
+	{ .name = "ldo5", .driver_data = (void *)LP8720_ID_LDO5, },
+	{ .name = "buck", .driver_data = (void *)LP8720_ID_BUCK, },
+};
+
+static struct of_regulator_match lp8725_matches[] = {
+	{ .name = "ldo1", .driver_data = (void *)LP8725_ID_LDO1, },
+	{ .name = "ldo2", .driver_data = (void *)LP8725_ID_LDO2, },
+	{ .name = "ldo3", .driver_data = (void *)LP8725_ID_LDO3, },
+	{ .name = "ldo4", .driver_data = (void *)LP8725_ID_LDO4, },
+	{ .name = "ldo5", .driver_data = (void *)LP8725_ID_LDO5, },
+	{ .name = "lilo1", .driver_data = (void *)LP8725_ID_LILO1, },
+	{ .name = "lilo2", .driver_data = (void *)LP8725_ID_LILO2, },
+	{ .name = "buck1", .driver_data = (void *)LP8725_ID_BUCK1, },
+	{ .name = "buck2", .driver_data = (void *)LP8725_ID_BUCK2, },
+};
+
+static struct lp872x_platform_data
+*lp872x_populate_pdata_from_dt(struct device *dev, enum lp872x_id which)
+{
+	struct device_node *np = dev->of_node;
+	struct lp872x_platform_data *pdata;
+	struct of_regulator_match *match;
+	struct regulator_init_data *d;
+	int num_matches;
+	int count;
+	int i;
+	u8 dvs_state;
+
+	pdata = devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
+	if (!pdata)
+		goto out;
+
+	of_property_read_u8(np, "ti,general-config", &pdata->general_config);
+	if (of_find_property(np, "ti,update-config", NULL))
+		pdata->update_config = true;
+
+	pdata->dvs = devm_kzalloc(dev, sizeof(struct lp872x_dvs), GFP_KERNEL);
+	if (!pdata->dvs)
+		goto out;
+
+	pdata->dvs->gpio = of_get_named_gpio(np, "ti,dvs-gpio", 0);
+	of_property_read_u8(np, "ti,dvs-vsel", (u8 *)&pdata->dvs->vsel);
+	of_property_read_u8(np, "ti,dvs-state", &dvs_state);
+	pdata->dvs->init_state = dvs_state ? DVS_HIGH : DVS_LOW;
+
+	if (of_get_child_count(np) == 0)
+		goto out;
+
+	switch (which) {
+	case LP8720:
+		match = lp8720_matches;
+		num_matches = ARRAY_SIZE(lp8720_matches);
+		break;
+	case LP8725:
+		match = lp8725_matches;
+		num_matches = ARRAY_SIZE(lp8725_matches);
+		break;
+	default:
+		goto out;
+	}
+
+	count = of_regulator_match(dev, np, match, num_matches);
+	if (count <= 0)
+		goto out;
+
+	for (i = 0; i < num_matches; i++) {
+		pdata->regulator_data[i].id = (int)match[i].driver_data;
+		pdata->regulator_data[i].init_data = match[i].init_data;
+
+		/* Operation mode configuration for buck/buck1/buck2 */
+		if (strncmp(match[i].name, "buck", 4))
+			continue;
+
+		d = pdata->regulator_data[i].init_data;
+		d->constraints.valid_modes_mask |= LP872X_VALID_OPMODE;
+		d->constraints.valid_ops_mask |= REGULATOR_CHANGE_MODE;
+	}
+out:
+	return pdata;
+}
+#else
+static struct lp872x_platform_data
+*lp872x_populate_pdata_from_dt(struct device *dev, enum lp872x_id which)
+{
+	return NULL;
+}
+#endif
+
 static int lp872x_probe(struct i2c_client *cl, const struct i2c_device_id *id)
 {
 	struct lp872x *lp;
@@ -838,6 +938,10 @@ static int lp872x_probe(struct i2c_client *cl, const struct i2c_device_id *id)
 		[LP8725] = LP8725_NUM_REGULATORS,
 	};
 
+	if (cl->dev.of_node)
+		cl->dev.platform_data = lp872x_populate_pdata_from_dt(&cl->dev,
+					      (enum lp872x_id)id->driver_data);
+
 	lp = devm_kzalloc(&cl->dev, sizeof(struct lp872x), GFP_KERNEL);
 	if (!lp)
 		goto err_mem;
@@ -882,6 +986,13 @@ static int lp872x_remove(struct i2c_client *cl)
 	return 0;
 }
 
+static const struct of_device_id lp872x_dt_ids[] = {
+	{ .compatible = "ti,lp8720", },
+	{ .compatible = "ti,lp8725", },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, lp872x_dt_ids);
+
 static const struct i2c_device_id lp872x_ids[] = {
 	{"lp8720", LP8720},
 	{"lp8725", LP8725},
@@ -893,6 +1004,7 @@ static struct i2c_driver lp872x_driver = {
 	.driver = {
 		.name = "lp872x",
 		.owner = THIS_MODULE,
+		.of_match_table = of_match_ptr(lp872x_dt_ids),
 	},
 	.probe = lp872x_probe,
 	.remove = lp872x_remove,
-- 
1.7.9.5


Best Regards,
Milo

