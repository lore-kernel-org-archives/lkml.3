Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754619Ab3ILM2l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 08:28:41 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:52789 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753447Ab3ILM2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 08:28:39 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-kernel@vger.kernel.org
Cc: Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org,
        Mark Brown <broonie@kernel.org>, devicetree@vger.kernel.org,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
Subject: [PATCH v2 2/2] regulator: da9210: add Device Tree support
Date: Thu, 12 Sep 2013 14:28:35 +0200
Message-Id: <1378988915-10539-3-git-send-email-g.liakhovetski@gmx.de>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1378988915-10539-1-git-send-email-g.liakhovetski@gmx.de>
References: <1378988915-10539-1-git-send-email-g.liakhovetski@gmx.de>
X-Provags-ID: V02:K0:WUli3QZmplKzJH3SuxL/06fYL3A1FnWzPb/UroOVsJP
 vt85kXvkC6ggdEDbs+TQksP4/uqiHuB/zQ+KIhN6xpiYostr9W
 MC9zVNxHS9ALk8EHanQAMOhJAUjPdTefrGYsaXa6DnQdGgVCKJ
 LarKBRqwjcamOLBNu2pHc49L7rrOSBr6Be+yAVAp/o4wE+nQ1H
 62aKB+2MwlGtCW+eY2XLOoBznKJ5yjKE0/oW7B5Ok5qN5qQ+h/
 iwR/41j3Vn2gt1brEsuCndoargAVlCZAc+CUaqLOmNJfxkz9h6
 Ytl2caa+ZfaGy5CrvC6/nwzUlkqyONnojnE3KcXYbOFfOUVlJs
 n+hFFwG84Al4RAsvFivHT7cBjRXhq8MbGP9WMq26YilomnkhHE
 rvae930Igod0Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds basic Device Tree support to the da9210 regulator driver -
with no special properties, since also driver's platform data only contains
standard regulator initialisation parameters.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
---

v2: add DT documentation

 .../devicetree/bindings/regulator/da9210.txt       |   21 ++++++++++++++++++++
 drivers/regulator/da9210-regulator.c               |    9 +++++--
 2 files changed, 27 insertions(+), 3 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/regulator/da9210.txt

diff --git a/Documentation/devicetree/bindings/regulator/da9210.txt b/Documentation/devicetree/bindings/regulator/da9210.txt
new file mode 100644
index 0000000..f120f22
--- /dev/null
+++ b/Documentation/devicetree/bindings/regulator/da9210.txt
@@ -0,0 +1,21 @@
+* Dialog Semiconductor DA9210 Voltage Regulator
+
+Required properties:
+
+- compatible:	must be "diasemi,da9210"
+- reg:		the i2c slave address of the regulator. It should be 0x68.
+
+Any standard regulator properties can be used to configure the single da9210
+DCDC.
+
+Example:
+
+	da9210@68 {
+		compatible = "diasemi,da9210";
+		reg = <0x68>;
+
+		regulator-min-microvolt = <900000>;
+		regulator-max-microvolt = <1000000>;
+		regulator-boot-on;
+		regulator-always-on;
+	};
diff --git a/drivers/regulator/da9210-regulator.c b/drivers/regulator/da9210-regulator.c
index f0fe54b..f7ccff14 100644
--- a/drivers/regulator/da9210-regulator.c
+++ b/drivers/regulator/da9210-regulator.c
@@ -25,6 +25,7 @@
 #include <linux/slab.h>
 #include <linux/regulator/driver.h>
 #include <linux/regulator/machine.h>
+#include <linux/regulator/of_regulator.h>
 #include <linux/regmap.h>
 
 #include "da9210-regulator.h"
@@ -126,7 +127,8 @@ static int da9210_i2c_probe(struct i2c_client *i2c,
 			    const struct i2c_device_id *id)
 {
 	struct da9210 *chip;
-	struct da9210_pdata *pdata = i2c->dev.platform_data;
+	struct device *dev = &i2c->dev;
+	struct da9210_pdata *pdata = dev_get_platdata(dev);
 	struct regulator_dev *rdev = NULL;
 	struct regulator_config config = { };
 	int error;
@@ -147,10 +149,11 @@ static int da9210_i2c_probe(struct i2c_client *i2c,
 	}
 
 	config.dev = &i2c->dev;
-	if (pdata)
-		config.init_data = &pdata->da9210_constraints;
+	config.init_data = pdata ? &pdata->da9210_constraints :
+		of_get_regulator_init_data(dev, dev->of_node);
 	config.driver_data = chip;
 	config.regmap = chip->regmap;
+	config.of_node = dev->of_node;
 
 	rdev = regulator_register(&da9210_reg, &config);
 	if (IS_ERR(rdev)) {
-- 
1.7.2.5

