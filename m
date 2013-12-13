Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753327Ab3LMUHV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 15:07:21 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:46986 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753079Ab3LMUHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 15:07:18 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 64.17.244.34
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/+KQowfU0CcNy8AC7qSVli
From: Tony Lindgren <tony@atomide.com>
To: Mark Brown <broonie@kernel.org>
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Tomasz Figa <t.figa@samsung.com>, Olof Johansson <olof@lixom.net>
Subject: [PATCH] regulator: Start using standard gpios property and deprecate some custom properties
Date: Fri, 13 Dec 2013 12:07:14 -0800
Message-Id: <1386965234-26461-1-git-send-email-tony@atomide.com>
X-Mailer: git-send-email 1.8.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can start moving regulators to using the standard gpios property instead
of various custom GPIO related properties. The reason for doing this is that
at least regulator-fixed can currently cause silent bugs if "gpios" property
is used instead of "gpio" property.

Fix the issue by trying to use "gpios" where possible in the drivers that
can already use it, and if that fails, then try to use the deprecated custom
property for getting the GPIO.

Cc: Tomasz Figa <t.figa@samsung.com>
Cc: Olof Johansson <olof@lixom.net>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 .../devicetree/bindings/regulator/fixed-regulator.txt     |  8 ++++++--
 Documentation/devicetree/bindings/regulator/lp872x.txt    |  9 ++++++---
 .../devicetree/bindings/regulator/max8997-regulator.txt   | 15 ++++++++++-----
 Documentation/devicetree/bindings/regulator/tps65090.txt  |  6 +++++-
 drivers/regulator/fixed.c                                 |  4 +++-
 drivers/regulator/lp872x.c                                |  4 +++-
 drivers/regulator/max8997.c                               |  4 +++-
 drivers/regulator/tps65090-regulator.c                    |  7 +++++--
 8 files changed, 41 insertions(+), 16 deletions(-)

diff --git a/Documentation/devicetree/bindings/regulator/fixed-regulator.txt b/Documentation/devicetree/bindings/regulator/fixed-regulator.txt
index 4fae41d..cabdb77 100644
--- a/Documentation/devicetree/bindings/regulator/fixed-regulator.txt
+++ b/Documentation/devicetree/bindings/regulator/fixed-regulator.txt
@@ -4,7 +4,7 @@ Required properties:
 - compatible: Must be "regulator-fixed";
 
 Optional properties:
-- gpio: gpio to use for enable control
+- gpios: gpio to use for enable control
 - startup-delay-us: startup time in microseconds
 - enable-active-high: Polarity of GPIO is Active high
 If this property is missing, the default assumed is Active low.
@@ -12,6 +12,10 @@ If this property is missing, the default assumed is Active low.
   If this property is missing then default assumption is false.
 -vin-supply: Input supply name.
 
+Deprecated properties:
+- gpio: Use the standard gpios property listed above instead of
+  this.
+
 Any property defined as part of the core regulator
 binding, defined in regulator.txt, can also be used.
 However a fixed voltage regulator is expected to have the
@@ -25,7 +29,7 @@ Example:
 		regulator-name = "fixed-supply";
 		regulator-min-microvolt = <1800000>;
 		regulator-max-microvolt = <1800000>;
-		gpio = <&gpio1 16 0>;
+		gpios = <&gpio1 16 0>;
 		startup-delay-us = <70000>;
 		enable-active-high;
 		regulator-boot-on;
diff --git a/Documentation/devicetree/bindings/regulator/lp872x.txt b/Documentation/devicetree/bindings/regulator/lp872x.txt
index 7818318..12a4268 100644
--- a/Documentation/devicetree/bindings/regulator/lp872x.txt
+++ b/Documentation/devicetree/bindings/regulator/lp872x.txt
@@ -25,7 +25,7 @@ Optional properties:
     For more details, please see the datasheet.
 
   - ti,update-config: define it when LP872X_GENERAL_CFG register should be set
-  - ti,dvs-gpio: GPIO specifier for external DVS pin control of LP872x devices.
+  - gpios: GPIO specifier for external DVS pin control of LP872x devices.
   - ti,dvs-vsel: DVS selector. 0 = SEL_V1, 1 = SEL_V2.
   - ti,dvs-state: initial DVS pin state. 0 = DVS_LOW, 1 = DVS_HIGH.
 
@@ -35,6 +35,9 @@ Optional properties:
     For more details, please see the following binding document.
     (Documentation/devicetree/bindings/regulator/regulator.txt)
 
+Deprecated properties:
+  - ti,dvs-gpio: Use the standard gpios property listed above instead of this.
+
 Datasheet
   - LP8720: http://www.ti.com/lit/ds/symlink/lp8720.pdf
   - LP8725: http://www.ti.com/lit/ds/symlink/lp8725.pdf
@@ -50,10 +53,10 @@ lp8720@7d {
 	ti,update-config;
 
 	/*
-	 * The dvs-gpio depends on the processor environment.
+	 * The gpios depends on the processor environment.
 	 * For example, following GPIO specifier means GPIO134 in OMAP4.
 	 */
-	ti,dvs-gpio = <&gpio5 6 0>;
+	gpios = <&gpio5 6 0>;
 	ti,dvs-vsel = /bits/ 8 <1>;		/* SEL_V2 */
 	ti,dvs-state = /bits/ 8 <1>;		/* DVS_HIGH */
 
diff --git a/Documentation/devicetree/bindings/regulator/max8997-regulator.txt b/Documentation/devicetree/bindings/regulator/max8997-regulator.txt
index 5c186a7..460eac8 100644
--- a/Documentation/devicetree/bindings/regulator/max8997-regulator.txt
+++ b/Documentation/devicetree/bindings/regulator/max8997-regulator.txt
@@ -37,6 +37,7 @@ Optional properties:
 - interrupts: Interrupt specifiers for two interrupt sources.
   - First interrupt specifier is for 'irq1' interrupt.
   - Second interrupt specifier is for 'alert' interrupt.
+- gpios: The gpio dvs to use for 'buck1', 'buck2' and 'buck5'.
 - max8997,pmic-buck1-uses-gpio-dvs: 'buck1' can be controlled by gpio dvs.
 - max8997,pmic-buck2-uses-gpio-dvs: 'buck2' can be controlled by gpio dvs.
 - max8997,pmic-buck5-uses-gpio-dvs: 'buck5' can be controlled by gpio dvs.
@@ -52,8 +53,12 @@ Additional properties required if either of the optional properties are used:
   property should be between 0 and 7. If not specified or if out of range, the
   default value of this property is set to 0.
 
-- max8997,pmic-buck125-dvs-gpios: GPIO specifiers for three host gpio's used
-  for dvs. The format of the gpio specifier depends in the gpio controller.
+- gpios: GPIO specifiers for three host gpio's used for dvs. The format of
+  the gpio specifier depends in the gpio controller.
+
+Deprecated properties:
+- max8997,pmic-buck125-dvs-gpios: Use the standard gpios property listed above
+  instead of this.
 
 Regulators: The regulators of max8997 that have to be instantiated should be
 included in a sub-node named 'regulators'. Regulator nodes included in this
@@ -102,9 +107,9 @@ Example:
 		max8997,pmic-ignore-gpiodvs-side-effect;
 		max8997,pmic-buck125-default-dvs-idx = <0>;
 
-		max8997,pmic-buck125-dvs-gpios = <&gpx0 0 1 0 0>, /* SET1 */
-						 <&gpx0 1 1 0 0>, /* SET2 */
-						 <&gpx0 2 1 0 0>; /* SET3 */
+		gpios = <&gpx0 0 1 0 0>, /* SET1 */
+			<&gpx0 1 1 0 0>, /* SET2 */
+			<&gpx0 2 1 0 0>; /* SET3 */
 
 		max8997,pmic-buck1-dvs-voltage = <1350000>, <1300000>,
 						 <1250000>, <1200000>,
diff --git a/Documentation/devicetree/bindings/regulator/tps65090.txt b/Documentation/devicetree/bindings/regulator/tps65090.txt
index 313a60b..05870a8 100644
--- a/Documentation/devicetree/bindings/regulator/tps65090.txt
+++ b/Documentation/devicetree/bindings/regulator/tps65090.txt
@@ -16,12 +16,16 @@ Required properties:
 Optional properties:
 - ti,enable-ext-control: This is applicable for DCDC1, DCDC2 and DCDC3.
   If DCDCs are externally controlled then this property should be there.
-- "dcdc-ext-control-gpios: This is applicable for DCDC1, DCDC2 and DCDC3.
+- gpios: This is applicable for DCDC1, DCDC2 and DCDC3.
   If DCDCs are externally controlled and if it is from GPIO then GPIO
   number should be provided. If it is externally controlled and no GPIO
   entry then driver will just configure this rails as external control
   and will not provide any enable/disable APIs.
 
+Deprecated properties:
+- dcdc-ext-control-gpios: Use the standard gpios property listed above
+  instead of this.
+
 Each regulator is defined using the standard binding for regulators.
 
 Example:
diff --git a/drivers/regulator/fixed.c b/drivers/regulator/fixed.c
index 5ea64b9..652adf7 100644
--- a/drivers/regulator/fixed.c
+++ b/drivers/regulator/fixed.c
@@ -77,7 +77,9 @@ of_get_fixed_voltage_config(struct device *dev)
 	if (init_data->constraints.boot_on)
 		config->enabled_at_boot = true;
 
-	config->gpio = of_get_named_gpio(np, "gpio", 0);
+	config->gpio = of_get_gpio(np, 0);
+	if (!gpio_is_valid(config->gpio))
+		config->gpio = of_get_named_gpio(np, "gpio", 0);
 	/*
 	 * of_get_named_gpio() currently returns ENODEV rather than
 	 * EPROBE_DEFER. This code attempts to be compatible with both
diff --git a/drivers/regulator/lp872x.c b/drivers/regulator/lp872x.c
index 2e4734f..29192f2 100644
--- a/drivers/regulator/lp872x.c
+++ b/drivers/regulator/lp872x.c
@@ -863,7 +863,9 @@ static struct lp872x_platform_data
 	if (!pdata->dvs)
 		goto out;
 
-	pdata->dvs->gpio = of_get_named_gpio(np, "ti,dvs-gpio", 0);
+	pdata->dvs->gpio = of_get_gpio(np, 0);
+	if (!gpio_is_valid(pdata->dvs->gpio))
+		pdata->dvs->gpio = of_get_named_gpio(np, "ti,dvs-gpio", 0);
 	of_property_read_u8(np, "ti,dvs-vsel", (u8 *)&pdata->dvs->vsel);
 	of_property_read_u8(np, "ti,dvs-state", &dvs_state);
 	pdata->dvs->init_state = dvs_state ? DVS_HIGH : DVS_LOW;
diff --git a/drivers/regulator/max8997.c b/drivers/regulator/max8997.c
index 2d618fc..0703066 100644
--- a/drivers/regulator/max8997.c
+++ b/drivers/regulator/max8997.c
@@ -899,7 +899,9 @@ static int max8997_pmic_dt_parse_dvs_gpio(struct platform_device *pdev,
 	int i, gpio;
 
 	for (i = 0; i < 3; i++) {
-		gpio = of_get_named_gpio(pmic_np,
+		gpio = of_get_gpio(pmic_np, i);
+		if (!gpio_is_valid(gpio))
+			gpio = of_get_named_gpio(pmic_np,
 					"max8997,pmic-buck125-dvs-gpios", i);
 		if (!gpio_is_valid(gpio)) {
 			dev_err(&pdev->dev, "invalid gpio[%d]: %d\n", i, gpio);
diff --git a/drivers/regulator/tps65090-regulator.c b/drivers/regulator/tps65090-regulator.c
index 676f755..e118ba4 100644
--- a/drivers/regulator/tps65090-regulator.c
+++ b/drivers/regulator/tps65090-regulator.c
@@ -208,9 +208,12 @@ static struct tps65090_platform_data *tps65090_parse_dt_reg_data(
 		rpdata->enable_ext_control = of_property_read_bool(
 					tps65090_matches[idx].of_node,
 					"ti,enable-ext-control");
-		if (rpdata->enable_ext_control)
-			rpdata->gpio = of_get_named_gpio(np,
+		if (rpdata->enable_ext_control) {
+			rpdata->gpio = of_get_gpio(np, 0);
+			if (!gpio_is_valid(rpdata->gpio))
+				rpdata->gpio = of_get_named_gpio(np,
 					"dcdc-ext-control-gpios", 0);
+		}
 
 		tps65090_pdata->reg_pdata[idx] = rpdata;
 	}
-- 
1.8.1.1

