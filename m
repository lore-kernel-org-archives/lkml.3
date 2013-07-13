Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757740Ab3GMLMz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jul 2013 07:12:55 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:34282 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274Ab3GMLMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jul 2013 07:12:53 -0400
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>, LDOC <linux-doc@vger.kernel.org>,
        devicetree-discuss@lists.ozlabs.org,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH v2] media: i2c: adv7343: add OF support
Date: Sat, 13 Jul 2013 16:42:39 +0530
Message-Id: <1373713959-31066-1-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

add OF support for the adv7343 driver.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 Changes for v2:
 1: Fixed naming of properties.
 
 .../devicetree/bindings/media/i2c/adv7343.txt      |   54 ++++++++++++++++
 drivers/media/i2c/adv7343.c                        |   65 +++++++++++++++++++-
 2 files changed, 118 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/adv7343.txt

diff --git a/Documentation/devicetree/bindings/media/i2c/adv7343.txt b/Documentation/devicetree/bindings/media/i2c/adv7343.txt
new file mode 100644
index 0000000..1d2e854
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/i2c/adv7343.txt
@@ -0,0 +1,54 @@
+* Analog Devices adv7343 video encoder
+
+The ADV7343 are high speed, digital-to-analog video encoders in a 64-lead LQFP
+package. Six high speed, 3.3 V, 11-bit video DACs provide support for composite
+(CVBS), S-Video (Y-C), and component (YPrPb/RGB) analog outputs in standard
+definition (SD), enhanced definition (ED), or high definition (HD) video
+formats.
+
+Required Properties :
+- compatible: Must be "ad,adv7343"
+
+Optional Properties :
+- ad,adv7343-power-mode-sleep-mode: on enable the current consumption is
+				     reduced to micro ampere level. All DACs and
+				     the internal PLL circuit are disabled.
+- ad,adv7343-power-mode-pll-ctrl: PLL and oversampling control. This control
+				   allows internal PLL 1 circuit to be powered
+				   down and the oversampling to beswitched off.
+- ad,adv7343-power-mode-dac-1: power on/off DAC 1, 0 = OFF and 1 = ON.
+- ad,adv7343-power-mode-dac-2: power on/off DAC 2, 0 = OFF and 1 = ON.
+- ad,adv7343-power-mode-dac-3: power on/off DAC 3, 0 = OFF and 1 = ON.
+- ad,adv7343-power-mode-dac-4: power on/off DAC 4, 0 = OFF and 1 = ON.
+- ad,adv7343-power-mode-dac-5: power on/off DAC 5, 0 = OFF and 1 = ON.
+- ad,adv7343-power-mode-dac-6: power on/off DAC 6, 0 = OFF and 1 = ON.
+- ad,adv7343-sd-config-dac-out-1: Configure SD DAC Output 1.
+- ad,adv7343-sd-config-dac-out-2: Configure SD DAC Output 2.
+
+Example:
+
+i2c0@1c22000 {
+	...
+	...
+
+	adv7343@2a {
+		compatible = "ad,adv7343";
+		reg = <0x2a>;
+
+		port {
+			adv7343_1: endpoint {
+					ad,adv7343-power-mode-sleep-mode;
+					ad,adv7343-power-mode-pll-ctrl;
+					ad,adv7343-power-mode-dac-1;
+					ad,adv7343-power-mode-dac-2;
+					ad,adv7343-power-mode-dac-3;
+					ad,adv7343-power-mode-dac-4;
+					ad,adv7343-power-mode-dac-5;
+					ad,adv7343-power-mode-dac-6;
+					ad,adv7343-sd-config-dac-out-1;
+					ad,adv7343-sd-config-dac-out-2;
+			};
+		};
+	};
+	...
+};
diff --git a/drivers/media/i2c/adv7343.c b/drivers/media/i2c/adv7343.c
index 7606218..22ee6f4 100644
--- a/drivers/media/i2c/adv7343.c
+++ b/drivers/media/i2c/adv7343.c
@@ -29,6 +29,7 @@
 #include <media/adv7343.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ctrls.h>
+#include <media/v4l2-of.h>
 
 #include "adv7343_regs.h"
 
@@ -398,6 +399,59 @@ static int adv7343_initialize(struct v4l2_subdev *sd)
 	return err;
 }
 
+static struct adv7343_platform_data *
+adv7343_get_pdata(struct i2c_client *client)
+{
+	struct adv7343_platform_data *pdata;
+	struct device_node *np;
+
+	if (!IS_ENABLED(CONFIG_OF) || !client->dev.of_node)
+		return client->dev.platform_data;
+
+	np = v4l2_of_get_next_endpoint(client->dev.of_node, NULL);
+	if (!np)
+		return NULL;
+
+	pdata = devm_kzalloc(&client->dev, sizeof(struct adv7343_platform_data),
+			     GFP_KERNEL);
+	if (!pdata)
+		goto done;
+
+	pdata->mode_config.sleep_mode =
+		of_property_read_bool(np, "ad,adv7343-power-mode-sleep-mode");
+
+	pdata->mode_config.pll_control =
+		of_property_read_bool(np, "ad,adv7343-power-mode-pll-ctrl");
+
+	pdata->mode_config.dac_1 =
+		of_property_read_bool(np, "ad,adv7343-power-mode-dac-1");
+
+	pdata->mode_config.dac_2 =
+		of_property_read_bool(np, "ad,adv7343-power-mode-dac-2");
+
+	pdata->mode_config.dac_3 =
+		of_property_read_bool(np, "ad,adv7343-power-mode-dac-3");
+
+	pdata->mode_config.dac_4 =
+		of_property_read_bool(np, "ad,adv7343-power-mode-dac-4");
+
+	pdata->mode_config.dac_5 =
+		of_property_read_bool(np, "ad,adv7343-power-mode-dac-5");
+
+	pdata->mode_config.dac_6 =
+		of_property_read_bool(np, "ad,adv7343-power-mode-dac-6");
+
+	pdata->sd_config.sd_dac_out1 =
+		of_property_read_bool(np, "ad,adv7343-sd-config-dac-out-1");
+
+	pdata->sd_config.sd_dac_out2 =
+		of_property_read_bool(np, "ad,adv7343-sd-config-dac-out-2");
+
+done:
+	of_node_put(np);
+	return pdata;
+}
+
 static int adv7343_probe(struct i2c_client *client,
 				const struct i2c_device_id *id)
 {
@@ -416,7 +470,7 @@ static int adv7343_probe(struct i2c_client *client,
 		return -ENOMEM;
 
 	/* Copy board specific information here */
-	state->pdata = client->dev.platform_data;
+	state->pdata = adv7343_get_pdata(client);
 
 	state->reg00	= 0x80;
 	state->reg01	= 0x00;
@@ -476,8 +530,17 @@ static const struct i2c_device_id adv7343_id[] = {
 
 MODULE_DEVICE_TABLE(i2c, adv7343_id);
 
+#if IS_ENABLED(CONFIG_OF)
+static const struct of_device_id adv7343_of_match[] = {
+	{.compatible = "ad,adv7343", },
+	{ /* sentinel */ },
+};
+MODULE_DEVICE_TABLE(of, adv7343_of_match);
+#endif
+
 static struct i2c_driver adv7343_driver = {
 	.driver = {
+		.of_match_table = of_match_ptr(adv7343_of_match),
 		.owner	= THIS_MODULE,
 		.name	= "adv7343",
 	},
-- 
1.7.9.5

