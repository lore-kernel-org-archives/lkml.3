Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933961Ab3CVQQc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 12:16:32 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:62378 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933641Ab3CVQQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 12:16:27 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Magnus Damm <magnus.damm@gmail.com>, Simon Horman <horms@verge.net.au>,
        devicetree-discuss@lists.ozlabs.org,
        Samuel Ortiz <sameo@linux.intel.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        Andrew Morton <akpm@linux-foundation.org>, linux-fbdev@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
Subject: [PATCH v3 1/3] mfd: as3711: add OF support
Date: Fri, 22 Mar 2013 17:15:47 +0100
Message-Id: <1363968949-12151-2-git-send-email-g.liakhovetski@gmx.de>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1363968949-12151-1-git-send-email-g.liakhovetski@gmx.de>
References: <1363968949-12151-1-git-send-email-g.liakhovetski@gmx.de>
X-Provags-ID: V02:K0:p+upM8DZj0Tjuw7+5e2bl4C1060kqaf9R4oCzRVaCJS
 B+sYx/4Dzqy5ZKTO+RxrTbxfzos/S7gTl4wT8Wi4acAgTKfuXQ
 YRx1v56MMxwbogjQMQQKgkL9P4744yZKjetxVCSQteGWoeR+Rl
 3vdLqNPxOwYw1ArYAjr1YkcN9JnqxWGagyHHoTD7lQtlf/+dTW
 M/P6Oitf7/mf1wBzPhlKKkmA7630HSZpRusju1C980/Z8q6x9J
 RsW1QMelCfQVKgdHalf4oGu9jveO7tkomnflXwyCWUZ8wScmdB
 2hofw4SRJ6ak1AbhcejiISUvz1WMkhX6qDBXNFKdTDu5nZGWjd
 KJdd0sy/kNji5PcvONT10jm7WxdwcmqPyKNiDE7kv0q9xPX3MX
 evwkcSR6Tux7A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add Flat Device Tree support to the AS3711 MFD driver. This patch just
allows to bind the driver to I2C devices, instantiated from the DT.
DT support for AS3711 cell drivers will be added in separate drivers.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
Reviwed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 Documentation/devicetree/bindings/mfd/as3711.txt |   73 ++++++++++++++++++++++
 drivers/mfd/as3711.c                             |   27 +++++++-
 2 files changed, 96 insertions(+), 4 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mfd/as3711.txt

diff --git a/Documentation/devicetree/bindings/mfd/as3711.txt b/Documentation/devicetree/bindings/mfd/as3711.txt
new file mode 100644
index 0000000..d98cf18
--- /dev/null
+++ b/Documentation/devicetree/bindings/mfd/as3711.txt
@@ -0,0 +1,73 @@
+AS3711 is an I2C PMIC from Austria MicroSystems with multiple DCDC and LDO power
+supplies, a battery charger and an RTC. So far only bindings for the two stepup
+DCDC converters are defined. Other DCDC and LDO supplies are configured, using
+standard regulator properties, they must belong to a sub-node, called
+"regulators" and be called "sd1" to "sd4" and "ldo1" to "ldo8." Stepup converter
+configuration should be placed in a subnode, called "backlight."
+
+Compulsory properties:
+- compatible		: must be "ams,as3711"
+- reg			: specifies the I2C address
+
+To use the SU1 converter as a backlight source the following two properties must
+be provided:
+- su1-dev		: framebuffer phandle
+- su1-max-uA		: maximum current
+
+To use the SU2 converter as a backlight source the following two properties must
+be provided:
+- su2-dev		: framebuffer phandle
+- su1-max-uA		: maximum current
+
+Additionally one of these properties must be provided to select the type of
+feedback used:
+- su2-feedback-voltage	: voltage feedback is used
+- su2-feedback-curr1	: CURR1 input used for current feedback
+- su2-feedback-curr2	: CURR2 input used for current feedback
+- su2-feedback-curr3	: CURR3 input used for current feedback
+- su2-feedback-curr-auto: automatic current feedback selection
+
+and one of these to select the over-voltage protection pin
+- su2-fbprot-lx-sd4	: LX_SD4 is used for over-voltage protection
+- su2-fbprot-gpio2	: GPIO2 is used for over-voltage protection
+- su2-fbprot-gpio3	: GPIO3 is used for over-voltage protection
+- su2-fbprot-gpio4	: GPIO4 is used for over-voltage protection
+
+If "su2-feedback-curr-auto" is selected, one or more of the following properties
+have to be specified:
+- su2-auto-curr1	: use CURR1 input for current feedback
+- su2-auto-curr2	: use CURR2 input for current feedback
+- su2-auto-curr3	: use CURR3 input for current feedback
+
+Example:
+
+as3711@40 {
+	compatible = "ams,as3711";
+	reg = <0x40>;
+
+	regulators {
+		sd4 {
+			regulator-name = "1.215V";
+			regulator-min-microvolt = <1215000>;
+			regulator-max-microvolt = <1235000>;
+		};
+		ldo2 {
+			regulator-name = "2.8V CPU";
+			regulator-min-microvolt = <2800000>;
+			regulator-max-microvolt = <2800000>;
+			regulator-always-on;
+			regulator-boot-on;
+		};
+	};
+
+	backlight {
+		compatible = "ams,as3711-bl";
+		su2-dev = <&lcdc>;
+		su2-max-uA = <36000>;
+		su2-feedback-curr-auto;
+		su2-fbprot-gpio4;
+		su2-auto-curr1;
+		su2-auto-curr2;
+		su2-auto-curr3;
+	};
+};
diff --git a/drivers/mfd/as3711.c b/drivers/mfd/as3711.c
index e994c96..01e4141 100644
--- a/drivers/mfd/as3711.c
+++ b/drivers/mfd/as3711.c
@@ -112,16 +112,34 @@ static const struct regmap_config as3711_regmap_config = {
 	.cache_type = REGCACHE_RBTREE,
 };
 
+#ifdef CONFIG_OF
+static struct of_device_id as3711_of_match[] = {
+	{.compatible = "ams,as3711",},
+	{}
+};
+MODULE_DEVICE_TABLE(of, as3711_of_match);
+#endif
+
 static int as3711_i2c_probe(struct i2c_client *client,
 			    const struct i2c_device_id *id)
 {
 	struct as3711 *as3711;
-	struct as3711_platform_data *pdata = client->dev.platform_data;
+	struct as3711_platform_data *pdata;
 	unsigned int id1, id2;
 	int ret;
 
-	if (!pdata)
-		dev_dbg(&client->dev, "Platform data not found\n");
+	if (!client->dev.of_node) {
+		pdata = client->dev.platform_data;
+		if (!pdata)
+			dev_dbg(&client->dev, "Platform data not found\n");
+	} else {
+		pdata = devm_kzalloc(&client->dev,
+				     sizeof(*pdata), GFP_KERNEL);
+		if (!pdata) {
+			dev_err(&client->dev, "Failed to allocate pdata\n");
+			return -ENOMEM;
+		}
+	}
 
 	as3711 = devm_kzalloc(&client->dev, sizeof(struct as3711), GFP_KERNEL);
 	if (!as3711) {
@@ -193,7 +211,8 @@ static struct i2c_driver as3711_i2c_driver = {
 	.driver = {
 		   .name = "as3711",
 		   .owner = THIS_MODULE,
-		   },
+		   .of_match_table = of_match_ptr(as3711_of_match),
+	},
 	.probe = as3711_i2c_probe,
 	.remove = as3711_i2c_remove,
 	.id_table = as3711_i2c_id,
-- 
1.7.2.5

