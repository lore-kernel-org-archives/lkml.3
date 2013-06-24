Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752446Ab3FXKuY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 06:50:24 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:58115 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751621Ab3FXKuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 06:50:22 -0400
Date: Mon, 24 Jun 2013 12:50:16 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: linux-kernel@vger.kernel.org
cc: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org
Subject: [PATCH v2 2/2] regulators: max8973: initial DT support
Message-ID: <Pine.LNX.4.64.1306241246580.19735@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:6j5rlEgYr52NQo4ITSyE5hx1cynJCIrU3/V7qpF8dFI
 VydtWX/mbz4imzUXKc6HeAVbFGMS/j+H7I0uyoY7PDi9FPOHXE
 C0BXqggL03ZjnEhkZxviNiF1r0TkQp7a0XuM/uQI1s+MR0/Jw1
 V7hWjDQjPrGjBTsDvfM2aeT8apsO+SIwBgxRIn7SSPcH4Y6KEV
 J4+N/FknORhz9iMw5+5Nj5VPBXQfUK0RvQQNH9F/TzuImXxqlN
 seRXyUs1rn98ddk6ZtrUrJ+/MoYnWugXhFWZWCOOSFkd59Jm/B
 B2EDvIn2JF3xkqCj5YqKXn1c5L2BpMnlCSQPYchUsqmedQ+8/a
 DFRWd5EUeEAIKTB6VzXjyFBPQJ4Qzucxj/2EZJu/LIBjHbL+0X
 EoLV/pGEX0KQQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds primitive DT support to the max8973 regulator driver. None
of the configuration parameters, supported in the platform data are yet
available in DT, therefore no configuration is performed if booting with
no platform data. This means, that DT instantiation can only be used on
boards, where no run-time configuration of the chip is required. In such
cases the driver can be used to scale its output voltage. In the future
support for configuration parameters should be added.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
---

v2: as suggested by Mark, regulator bindings are now directly under the 
main max8973 I2C device node.

 .../bindings/regulator/max8973-regulator.txt       |   21 +++++++++++
 drivers/regulator/max8973-regulator.c              |   37 +++++++++++++------
 2 files changed, 46 insertions(+), 12 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/regulator/max8973-regulator.txt

diff --git a/Documentation/devicetree/bindings/regulator/max8973-regulator.txt b/Documentation/devicetree/bindings/regulator/max8973-regulator.txt
new file mode 100644
index 0000000..8d38ab2
--- /dev/null
+++ b/Documentation/devicetree/bindings/regulator/max8973-regulator.txt
@@ -0,0 +1,21 @@
+* Maxim MAX8973 Voltage Regulator
+
+Required properties:
+
+- compatible:	must be "maxium,max8973"
+- reg:		the i2c slave address of the regulator. It should be 0x1b.
+
+Any standard regulator properties can be used to configure the single max8973
+DCDC.
+
+Example:
+
+	max8973@1b {
+		compatible = "maxium,max8973";
+		reg = <0x1b>;
+
+		regulator-min-microvolt = <935000>;
+		regulator-max-microvolt = <1200000>;
+		regulator-boot-on;
+		regulator-always-on;
+	};
diff --git a/drivers/regulator/max8973-regulator.c b/drivers/regulator/max8973-regulator.c
index b2dbdd7..0c5195a 100644
--- a/drivers/regulator/max8973-regulator.c
+++ b/drivers/regulator/max8973-regulator.c
@@ -26,10 +26,12 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/err.h>
+#include <linux/of.h>
 #include <linux/platform_device.h>
 #include <linux/regulator/driver.h>
 #include <linux/regulator/machine.h>
 #include <linux/regulator/max8973-regulator.h>
+#include <linux/regulator/of_regulator.h>
 #include <linux/gpio.h>
 #include <linux/i2c.h>
 #include <linux/slab.h>
@@ -370,7 +372,8 @@ static int max8973_probe(struct i2c_client *client,
 	int ret;
 
 	pdata = client->dev.platform_data;
-	if (!pdata) {
+
+	if (!pdata && !client->dev.of_node) {
 		dev_err(&client->dev, "No Platform data");
 		return -EIO;
 	}
@@ -400,7 +403,7 @@ static int max8973_probe(struct i2c_client *client,
 	max->desc.uV_step = MAX8973_VOLATGE_STEP;
 	max->desc.n_voltages = MAX8973_BUCK_N_VOLTAGE;
 
-	if (!pdata->enable_ext_control) {
+	if (!pdata || !pdata->enable_ext_control) {
 		max->desc.enable_reg = MAX8973_VOUT;
 		max->desc.enable_mask = MAX8973_VOUT_ENABLE;
 		max->ops.enable = regulator_enable_regmap;
@@ -408,12 +411,17 @@ static int max8973_probe(struct i2c_client *client,
 		max->ops.is_enabled = regulator_is_enabled_regmap;
 	}
 
-	max->enable_external_control = pdata->enable_ext_control;
-	max->dvs_gpio = pdata->dvs_gpio;
-	max->curr_gpio_val = pdata->dvs_def_state;
-	max->curr_vout_reg = MAX8973_VOUT + pdata->dvs_def_state;
+	if (pdata) {
+		max->dvs_gpio = pdata->dvs_gpio;
+		max->enable_external_control = pdata->enable_ext_control;
+		max->curr_gpio_val = pdata->dvs_def_state;
+		max->curr_vout_reg = MAX8973_VOUT + pdata->dvs_def_state;
+	} else {
+		max->dvs_gpio = -EINVAL;
+		max->curr_vout_reg = MAX8973_VOUT;
+	}
+
 	max->lru_index[0] = max->curr_vout_reg;
-	max->valid_dvs_gpio = false;
 
 	if (gpio_is_valid(max->dvs_gpio)) {
 		int gpio_flags;
@@ -439,16 +447,21 @@ static int max8973_probe(struct i2c_client *client,
 			max->lru_index[i] = i;
 		max->lru_index[0] = max->curr_vout_reg;
 		max->lru_index[max->curr_vout_reg] = 0;
+	} else {
+		max->valid_dvs_gpio = false;
 	}
 
-	ret = max8973_init_dcdc(max, pdata);
-	if (ret < 0) {
-		dev_err(max->dev, "Max8973 Init failed, err = %d\n", ret);
-		return ret;
+	if (pdata) {
+		ret = max8973_init_dcdc(max, pdata);
+		if (ret < 0) {
+			dev_err(max->dev, "Max8973 Init failed, err = %d\n", ret);
+			return ret;
+		}
 	}
 
 	config.dev = &client->dev;
-	config.init_data = pdata->reg_init_data;
+	config.init_data = pdata ? pdata->reg_init_data :
+		of_get_regulator_init_data(&client->dev, client->dev.of_node);
 	config.driver_data = max;
 	config.of_node = client->dev.of_node;
 	config.regmap = max->regmap;
-- 
1.7.2.5

