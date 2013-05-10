Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751929Ab3EJHR6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 03:17:58 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:56585 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751353Ab3EJHR4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 03:17:56 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Mark Brown <broonie@kernel.org>
CC: Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] regulator: lp872x: support the device tree feature
Thread-Topic: [PATCH v2] regulator: lp872x: support the device tree feature
Thread-Index: Ac5NTnj7T8q5sGTjRLa2tBPJWUP/NQ==
Date: Fri, 10 May 2013 07:17:48 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F82E5CF3D@DQHE06.ent.ti.com>
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

Change on the DVS initialization:
  When a DVS GPIO is invalid, use the default mode instead of returning error.

Patch v2.
  Move the opmode code of the device tree from 'of_regulator' to the lp872x
  because its mode depends on the device.
  Supported modes in LP8720/5 are 'fast' and 'normal'.

Patch v1.
  Initial patch

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 .../devicetree/bindings/regulator/lp872x.txt       |  160 ++++++++++++++++++++
 drivers/regulator/lp872x.c                         |   75 ++++++++-
 2 files changed, 233 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/regulator/lp872x.txt

diff --git a/Documentation/devicetree/bindings/regulator/lp872x.txt b/Documentation/devicetree/bindings/regulator/lp872x.txt
new file mode 100644
index 0000000..1f92ca4
--- /dev/null
+++ b/Documentation/devicetree/bindings/regulator/lp872x.txt
@@ -0,0 +1,160 @@
+Binding for TI/National Semiconductor LP872x Driver
+
+Required properties:
+- compatible: "ti,lp8720" or "ti,lp8725"
+- reg: I2C slave address
+
+Optional properties:
+- general-config: the value of LP872X_GENERAL_CFG register (u8)
+- update-config: define it when LP872X_GENERAL_CFG register should be updated
+- dvs-gpio: GPIO number for DVS control
+- dvs-vsel: DVS selector. 0 = SEL_V1, 1 = SEL_V2.
+- dvs-state: initial DVS pin state. 0 = DVS_LOG, 1 = DVS_HIGH.
+
+Child node
+- regulator-id: the value of enum lp872x_regulator_id. (u8)
+- regulator_init_data: please see the regulator device tree document.
+  (Documentation/devicetree/bindings/regulator/regulator.txt)
+- regulator-mode-fast: fast operating mode
+- regulator-mode-normal: normal operating mode
+
+Example 1) LP8720
+
+lp8720@7d {
+	compatible = "ti,lp8720";
+	reg = <0x7d>;
+
+	/* DVS pin, timestep = 25usec */
+	general-config = /bits/ 8 <0x03>;
+	update-config;
+
+	dvs-gpio = <&gpio5 6 0>;		/* GPIO 134 */
+	dvs-vsel = /bits/ 8 <1>;		/* SEL_V2 */
+	dvs-state = /bits/ 8 <1>;		/* DVS_HIGH */
+
+	vaf {
+		regulator-id = /bits/ 8 <0>;	/* LP8720_ID_LDO1 */
+		regulator-min-microvolt = <1200000>;
+		regulator-max-microvolt = <3300000>;
+		regulator-boot-on;
+	};
+
+	vmmc {
+		regulator-id = /bits/ 8 <1>;	/* LP8720_ID_LDO2 */
+		regulator-min-microvolt = <1200000>;
+		regulator-max-microvolt = <3300000>;
+		regulator-boot-on;
+	};
+
+	vcam_io {
+		regulator-id = /bits/ 8 <2>;	/* LP8720_ID_LDO3 */
+		regulator-min-microvolt = <1200000>;
+		regulator-max-microvolt = <3300000>;
+		regulator-boot-on;
+	};
+
+	vcam_core {
+		regulator-id = /bits/ 8 <3>;	/* LP8720_ID_LDO4 */
+		regulator-min-microvolt = <800000>;
+		regulator-max-microvolt = <2850000>;
+		regulator-boot-on;
+	};
+
+	vcam {
+		regulator-id = /bits/ 8 <4>;	/* LP8720_ID_LDO5 */
+		regulator-min-microvolt = <1200000>;
+		regulator-max-microvolt = <3300000>;
+		regulator-boot-on;
+	};
+
+	vcc {
+		regulator-id = /bits/ 8 <5>;	/* LP8720_ID_BUCK */
+		regulator-name = "VBUCK";
+		regulator-min-microvolt = <800000>;
+		regulator-max-microvolt = <2300000>;
+		regulator-mode-fast;
+		regulator-mode-normal;
+	};
+};
+
+Example 2) LP8725
+
+lp8725@7a {
+	compatible = "ti,lp8725";
+	reg = <0x7a>;
+
+	/* Enable BUCK1,2, no DVS, timestep = 256usec */
+	general-config = /bits/ 8 <0xdd>;
+	update-config;
+
+	vcam_io {
+		regulator-id = /bits/ 8 <6>;	/* LP8725_ID_LDO1 */
+		regulator-min-microvolt = <1200000>;
+		regulator-max-microvolt = <3300000>;
+		regulator-boot-on;
+	};
+
+	vcam_core {
+		regulator-id = /bits/ 8 <7>;	/* LP8725_ID_LDO2 */
+		regulator-min-microvolt = <1200000>;
+		regulator-max-microvolt = <3300000>;
+		regulator-boot-on;
+	};
+
+	vcam {
+		regulator-id = /bits/ 8 <8>;	/* LP8725_ID_LDO3 */
+		regulator-min-microvolt = <1200000>;
+		regulator-max-microvolt = <3300000>;
+		regulator-boot-on;
+	};
+
+	vcmmb_io {
+		regulator-id = /bits/ 8 <9>;	/* LP8725_ID_LDO4 */
+		regulator-min-microvolt = <1200000>;
+		regulator-max-microvolt = <3300000>;
+		regulator-boot-on;
+	};
+
+	vcmmb_core {
+		regulator-id = /bits/ 8 <10>;	/* LP8725_ID_LDO5 */
+		regulator-min-microvolt = <1200000>;
+		regulator-max-microvolt = <3300000>;
+		regulator-boot-on;
+	};
+
+	vaux1 {
+		regulator-id = /bits/ 8 <11>;	/* LP8725_ID_LILO1 */
+		regulator-name = "VAUX1";
+		regulator-min-microvolt = <800000>;
+		regulator-max-microvolt = <3300000>;
+	};
+
+	vaux2 {
+		regulator-id = /bits/ 8 <12>;	/* LP8725_ID_LILO2 */
+		regulator-name = "VAUX2";
+		regulator-min-microvolt = <800000>;
+		regulator-max-microvolt = <3300000>;
+	};
+
+	vcc1 {
+		regulator-id = /bits/ 8 <13>;	/* LP8725_ID_BUCK1 */
+		regulator-name = "VBUCK1";
+		regulator-min-microvolt = <800000>;
+		regulator-max-microvolt = <3000000>;
+		regulator-min-microamp  = <460000>;
+		regulator-max-microamp  = <1370000>;
+		regulator-mode-fast;
+		regulator-mode-normal;
+	};
+
+	vcc2 {
+		regulator-id = /bits/ 8 <14>;	/* LP8725_ID_BUCK2 */
+		regulator-name = "VBUCK2";
+		regulator-min-microvolt = <800000>;
+		regulator-max-microvolt = <3000000>;
+		regulator-min-microamp  = <460000>;
+		regulator-max-microamp  = <1370000>;
+		regulator-mode-fast;
+		regulator-mode-normal;
+	};
+};
diff --git a/drivers/regulator/lp872x.c b/drivers/regulator/lp872x.c
index f5fc4a1..041a8ad 100644
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
@@ -829,6 +832,63 @@ static const struct regmap_config lp872x_regmap_config = {
 	.max_register = MAX_REGISTERS,
 };
 
+#ifdef CONFIG_OF
+static struct lp872x_platform_data *lp872x_populate_from_dt(struct device *dev)
+{
+	struct device_node *np = dev->of_node;
+	struct lp872x_platform_data *pdata;
+	struct regulator_init_data *d;
+	struct device_node *child;
+	u8 dvs_state;
+	int i = 0;
+
+	pdata = devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
+	if (!pdata)
+		goto out;
+
+	of_property_read_u8(np, "general-config", &pdata->general_config);
+	if (of_find_property(np, "update-config", NULL))
+		pdata->update_config = true;
+
+	pdata->dvs = devm_kzalloc(dev, sizeof(struct lp872x_dvs), GFP_KERNEL);
+	if (!pdata->dvs)
+		goto out;
+
+	pdata->dvs->gpio = of_get_named_gpio(np, "dvs-gpio", 0);
+	of_property_read_u8(np, "dvs-vsel", (u8 *)&pdata->dvs->vsel);
+	of_property_read_u8(np, "dvs-state", &dvs_state);
+	pdata->dvs->init_state = dvs_state ? DVS_HIGH : DVS_LOW;
+
+	if (of_get_child_count(np) == 0)
+		goto out;
+
+	for_each_child_of_node(np, child) {
+		of_property_read_u8(child, "regulator-id",
+				(u8 *)&pdata->regulator_data[i].id);
+		pdata->regulator_data[i].init_data =
+				of_get_regulator_init_data(dev, child);
+
+		/* Operation mode configuration */
+		d = pdata->regulator_data[i].init_data;
+		if (of_find_property(child, "regulator-mode-fast", NULL))
+			d->constraints.valid_modes_mask |= REGULATOR_MODE_FAST;
+		if (of_find_property(child, "regulator-mode-normal", NULL))
+			d->constraints.valid_modes_mask |= REGULATOR_MODE_NORMAL;
+		if (d->constraints.valid_modes_mask)
+			d->constraints.valid_ops_mask |= REGULATOR_CHANGE_MODE;
+
+		i++;
+	}
+out:
+	return pdata;
+}
+#else
+static struct lp872x_platform_data *lp872x_populate_from_dt(struct device *dev)
+{
+	return NULL;
+}
+#endif
+
 static int lp872x_probe(struct i2c_client *cl, const struct i2c_device_id *id)
 {
 	struct lp872x *lp;
@@ -838,6 +898,9 @@ static int lp872x_probe(struct i2c_client *cl, const struct i2c_device_id *id)
 		[LP8725] = LP8725_NUM_REGULATORS,
 	};
 
+	if (cl->dev.of_node)
+		cl->dev.platform_data = lp872x_populate_from_dt(&cl->dev);
+
 	lp = devm_kzalloc(&cl->dev, sizeof(struct lp872x), GFP_KERNEL);
 	if (!lp)
 		goto err_mem;
@@ -882,6 +945,13 @@ static int lp872x_remove(struct i2c_client *cl)
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
@@ -893,6 +963,7 @@ static struct i2c_driver lp872x_driver = {
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


