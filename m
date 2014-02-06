Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756654AbaBFSDx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 13:03:53 -0500
Received: from mail1.bemta14.messagelabs.com ([193.109.254.117]:41899 "EHLO
	mail1.bemta14.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754343AbaBFSDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 13:03:15 -0500
X-Env-Sender: Adam.Thomson.Opensource@diasemi.com
X-Msg-Ref: server-8.tower-193.messagelabs.com!1391709793!10876847!1
X-Originating-IP: [82.210.246.133]
X-StarScan-Received: 
X-StarScan-Version: 6.9.16; banners=-,-,-
X-VirusChecked: Checked
Message-ID: <46f41a14205ac39de3adb8c87d2a6dba557ad8d1.1391705989.git.Adam.Thomson.Opensource@diasemi.com>
In-Reply-To: <cover.1391705989.git.Adam.Thomson.Opensource@diasemi.com>
References: <cover.1391705989.git.Adam.Thomson.Opensource@diasemi.com>
From: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
Date: Thu, 6 Feb 2014 18:03:11 +0000
Subject: [PATCH v2 3/8] mfd: da9055: Add DT support for PMIC
To: Mark Brown <broonie@kernel.org>, Lee Jones <lee.jones@linaro.org>
CC: <alsa-devel@alsa-project.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Guenter Roeck <linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
---
 Documentation/devicetree/bindings/mfd/da9055.txt |   73 ++++++++++++++++++++++
 drivers/mfd/da9055-i2c.c                         |    8 +++
 2 files changed, 81 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mfd/da9055.txt

diff --git a/Documentation/devicetree/bindings/mfd/da9055.txt b/Documentation/devicetree/bindings/mfd/da9055.txt
new file mode 100644
index 0000000..f903c3f
--- /dev/null
+++ b/Documentation/devicetree/bindings/mfd/da9055.txt
@@ -0,0 +1,73 @@
+* Dialog DA9055 Power Management Integrated Circuit (PMIC)
+
+DA9055 consists of a large and varied group of sub-devices (I2C Only):
+
+Device			 Supply Names	 Description
+------			 ------------	 -----------
+da9055-gpio		:		: GPIOs
+da9055-regulator	:		: Regulators
+da9055-onkey		:		: On key
+da9055-rtc		:		: RTC
+da9055-hwmon		:		: ADC
+da9055-watchdog		:		: Watchdog
+
+The CODEC device in DA9055 has a separate, configurable I2C address and so
+is instantiated separately from the PMIC.
+
+For details on accompanying CODEC I2C device, see the following:
+Documentation/devicetree/bindings/sound/da9055.txt
+
+======
+
+Required properties:
+- compatible : Should be "dlg,da9055-pmic"
+- reg: Specifies the I2C slave address (defaults to 0x5a but can be modified)
+- interrupt-parent: Specifies the phandle of the interrupt controller to which
+  the IRQs from da9055 are delivered to.
+- interrupts: IRQ line info for da9055 chip.
+- interrupt-controller: da9055 has internal IRQs (has own IRQ domain).
+- #interrupt-cells: Should be 1, is the local IRQ number for da9055.
+
+Sub-nodes:
+- regulators : Contain the regulator nodes. The DA9055 regulators are
+  bound using their names as listed below:
+
+    buck1     : regulator BUCK1
+    buck2     : regulator BUCK2
+    ldo1      : regulator LDO1
+    ldo2      : regulator LDO2
+    ldo3      : regulator LDO3
+    ldo4      : regulator LDO4
+    ldo5      : regulator LDO5
+    ldo6      : regulator LDO6
+
+  The bindings details of individual regulator device can be found in:
+  Documentation/devicetree/bindings/regulator/regulator.txt
+
+
+Example:
+
+	pmic: da9055-pmic@5a {
+		compatible = "dlg,da9055-pmic";
+		reg = <0x5a>;
+		interrupt-parent = <&intc>;
+		interrupts = <5 0x8>;
+		interrupt-controller;
+		#interrupt-cells = <1>;
+
+		regulators {
+			buck1: BUCK1 {
+				regulator-min-microvolt = <725000>;
+				regulator-max-microvolt = <2075000>;
+			};
+
+			buck2: BUCK2 {
+				regulator-min-microvolt = <925000>;
+				regulator-max-microvolt = <2500000>;
+			};
+			ldo1: LDO1 {
+				regulator-min-microvolt = <900000>;
+				regulator-max-microvolt = <3300000>;
+			};
+		};
+	};
diff --git a/drivers/mfd/da9055-i2c.c b/drivers/mfd/da9055-i2c.c
index 8103e43..366a3e2 100644
--- a/drivers/mfd/da9055-i2c.c
+++ b/drivers/mfd/da9055-i2c.c
@@ -15,6 +15,8 @@
 #include <linux/device.h>
 #include <linux/i2c.h>
 #include <linux/err.h>
+#include <linux/of.h>
+#include <linux/of_device.h>

 #include <linux/mfd/da9055/core.h>

@@ -66,6 +68,11 @@ static struct i2c_device_id da9055_i2c_id[] = {
 };
 MODULE_DEVICE_TABLE(i2c, da9055_i2c_id);

+static const struct of_device_id da9055_of_match[] = {
+	{ .compatible = "dlg,da9055-pmic", .data = (void *)&da9055_i2c_id[0] },
+	{ }
+};
+
 static struct i2c_driver da9055_i2c_driver = {
 	.probe = da9055_i2c_probe,
 	.remove = da9055_i2c_remove,
@@ -73,6 +80,7 @@ static struct i2c_driver da9055_i2c_driver = {
 	.driver = {
 		.name = "da9055-pmic",
 		.owner = THIS_MODULE,
+		.of_match_table = of_match_ptr(da9055_of_match),
 	},
 };

--
1.7.0.4

