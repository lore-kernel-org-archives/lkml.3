Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753626Ab3JWMEL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 08:04:11 -0400
Received: from ring0.de ([91.143.88.219]:41252 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753261Ab3JWMEJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 08:04:09 -0400
X-Spam-Report: * -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
From: Sebastian Reichel <sre@debian.org>
To: Sebastian Reichel <sre@ring0.de>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Grant Likely <grant.likely@linaro.org>,
        Sebastian Reichel <sre@debian.org>,
        Bill Pemberton <wfp5p@virginia.edu>,
        Sachin Kamat <sachin.kamat@linaro.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org
Subject: [PATCH] ASoC: tpa6130a2: Add device tree support
Date: Wed, 23 Oct 2013 14:03:28 +0200
Message-Id: <1382529808-28440-1-git-send-email-sre@debian.org>
X-Mailer: git-send-email 1.8.4.rc3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add device tree support to tpa6130a2 driver and document the
bindings.

Signed-off-by: Sebastian Reichel <sre@debian.org>
---
 .../devicetree/bindings/sound/tpa6130a2.txt        | 27 ++++++++++++++++++
 sound/soc/codecs/tpa6130a2.c                       | 32 ++++++++++++++++------
 2 files changed, 50 insertions(+), 9 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/sound/tpa6130a2.txt

diff --git a/Documentation/devicetree/bindings/sound/tpa6130a2.txt b/Documentation/devicetree/bindings/sound/tpa6130a2.txt
new file mode 100644
index 0000000..6dfa740
--- /dev/null
+++ b/Documentation/devicetree/bindings/sound/tpa6130a2.txt
@@ -0,0 +1,27 @@
+Texas Instruments - tpa6130a2 Codec module
+
+The tpa6130a2 serial control bus communicates through I2C protocols
+
+Required properties:
+
+- compatible - "string" - One of:
+    "ti,tpa6130a2" - TPA6130A2
+    "ti,tpa6140a2" - TPA6140A2
+
+
+- reg - <int> -  I2C slave address
+
+- Vdd-supply - <phandle> - power supply regulator
+
+Optional properties:
+
+- power-gpio - gpio pin to power the device
+
+Example:
+
+tpa6130a2: tpa6130a2@60 {
+	compatible = "ti,tpa6130a2";
+	reg = <0x60>;
+	Vdd-supply = <&vmmc2>;
+	power-gpio = <&gpio4 2 GPIO_ACTIVE_HIGH>;
+};
diff --git a/sound/soc/codecs/tpa6130a2.c b/sound/soc/codecs/tpa6130a2.c
index c58bee8..998555f 100644
--- a/sound/soc/codecs/tpa6130a2.c
+++ b/sound/soc/codecs/tpa6130a2.c
@@ -30,6 +30,7 @@
 #include <sound/tpa6130a2-plat.h>
 #include <sound/soc.h>
 #include <sound/tlv.h>
+#include <linux/of_gpio.h>
 
 #include "tpa6130a2.h"
 
@@ -364,30 +365,33 @@ static int tpa6130a2_probe(struct i2c_client *client,
 {
 	struct device *dev;
 	struct tpa6130a2_data *data;
-	struct tpa6130a2_platform_data *pdata;
+	struct tpa6130a2_platform_data *pdata = client->dev.platform_data;
+	struct device_node *np = client->dev.of_node;
 	const char *regulator;
 	int ret;
 
 	dev = &client->dev;
 
-	if (client->dev.platform_data == NULL) {
-		dev_err(dev, "Platform data not set\n");
-		dump_stack();
-		return -ENODEV;
-	}
-
 	data = devm_kzalloc(&client->dev, sizeof(*data), GFP_KERNEL);
 	if (data == NULL) {
 		dev_err(dev, "Can not allocate memory\n");
 		return -ENOMEM;
 	}
 
+	if (pdata) {
+		data->power_gpio = pdata->power_gpio;
+	} else if (np) {
+		data->power_gpio = of_get_named_gpio(np, "power-gpio", 0);
+	} else {
+		dev_err(dev, "Platform data not set\n");
+		dump_stack();
+		return -ENODEV;
+	}
+
 	tpa6130a2_client = client;
 
 	i2c_set_clientdata(tpa6130a2_client, data);
 
-	pdata = client->dev.platform_data;
-	data->power_gpio = pdata->power_gpio;
 	data->id = id->driver_data;
 
 	mutex_init(&data->mutex);
@@ -466,10 +470,20 @@ static const struct i2c_device_id tpa6130a2_id[] = {
 };
 MODULE_DEVICE_TABLE(i2c, tpa6130a2_id);
 
+#if IS_ENABLED(CONFIG_OF)
+static const struct of_device_id tpa6130a2_of_match[] = {
+	{ .compatible = "ti,tpa6130a2", },
+	{ .compatible = "ti,tpa6140a2" },
+	{},
+};
+MODULE_DEVICE_TABLE(of, tpa6130a2_of_match);
+#endif
+
 static struct i2c_driver tpa6130a2_i2c_driver = {
 	.driver = {
 		.name = "tpa6130a2",
 		.owner = THIS_MODULE,
+		.of_match_table = of_match_ptr(tpa6130a2_of_match),
 	},
 	.probe = tpa6130a2_probe,
 	.remove = tpa6130a2_remove,
-- 
1.8.4.rc3

