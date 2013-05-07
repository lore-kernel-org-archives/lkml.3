Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757782Ab3EGHPD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 03:15:03 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:49462 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756634Ab3EGHO7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 03:14:59 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Bryan Wu <cooloney@gmail.com>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Gabriel Fernandez <gabriel.fernandez@stericsson.com>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] leds: lp5562: support the device tree feature
Thread-Topic: [PATCH 2/2] leds: lp5562: support the device tree feature
Thread-Index: Ac5K8o+qWnfU+OESSj6yJ3iM9cKNCQ==
Date: Tue, 7 May 2013 07:14:49 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F82E5C8EB@DQHE06.ent.ti.com>
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

The LP55xx DT structure is applicable to the LP5562 device.
The driver and documentation are updated.

Compatible property of the DT
: LP5521 and LP5223 were manufactured by National Semiconductor.
  LP5562 is a new device from Texas Instruments.

Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Gabriel Fernandez <gabriel.fernandez@stericsson.com>
Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 .../devicetree/bindings/leds/leds-lp55xx.txt       |   37 ++++++++++++++++++--
 drivers/leds/leds-lp5562.c                         |   19 +++++++---
 2 files changed, 49 insertions(+), 7 deletions(-)

diff --git a/Documentation/devicetree/bindings/leds/leds-lp55xx.txt b/Documentation/devicetree/bindings/leds/leds-lp55xx.txt
index a454088..428dab9 100644
--- a/Documentation/devicetree/bindings/leds/leds-lp55xx.txt
+++ b/Documentation/devicetree/bindings/leds/leds-lp55xx.txt
@@ -1,7 +1,7 @@
-Binding for National Semiconductor LP55xx Led Drivers
+Binding for TI/National Semiconductor LP55xx Led Drivers
 
 Required properties:
-- compatible: "national,lp5521" or "national,lp5523"
+- compatible: "national,lp5521" or "national,lp5523" or "ti,lp5562"
 - reg: I2C slave address
 - clock-mode: Input clock mode, (0: automode, 1: internal, 2: external)
 
@@ -112,3 +112,36 @@ lp5523@32 {
 		max-cur = /bits/ 8 <0x20>;
 	};
 };
+
+example 3) LP5562
+4 channels are defined.
+
+lp5562@30 {
+	compatible = "ti,lp5562";
+	reg = <0x30>;
+	clock-mode = /bits/8 <2>;
+
+	chan0 {
+		chan-name = "R";
+		led-cur = /bits/ 8 <0x20>;
+		max-cur = /bits/ 8 <0x60>;
+	};
+
+	chan1 {
+		chan-name = "G";
+		led-cur = /bits/ 8 <0x20>;
+		max-cur = /bits/ 8 <0x60>;
+	};
+
+	chan2 {
+		chan-name = "B";
+		led-cur = /bits/ 8 <0x20>;
+		max-cur = /bits/ 8 <0x60>;
+	};
+
+	chan3 {
+		chan-name = "W";
+		led-cur = /bits/ 8 <0x20>;
+		max-cur = /bits/ 8 <0x60>;
+	};
+};
diff --git a/drivers/leds/leds-lp5562.c b/drivers/leds/leds-lp5562.c
index 513f239..e53bcb8 100644
--- a/drivers/leds/leds-lp5562.c
+++ b/drivers/leds/leds-lp5562.c
@@ -515,12 +515,20 @@ static int lp5562_probe(struct i2c_client *client,
 	int ret;
 	struct lp55xx_chip *chip;
 	struct lp55xx_led *led;
-	struct lp55xx_platform_data *pdata = client->dev.platform_data;
-
-	if (!pdata) {
-		dev_err(&client->dev, "no platform data\n");
-		return -EINVAL;
+	struct lp55xx_platform_data *pdata;
+	struct device_node *np = client->dev.of_node;
+
+	if (!client->dev.platform_data) {
+		if (np) {
+			ret = lp55xx_of_populate_pdata(&client->dev, np);
+			if (ret < 0)
+				return ret;
+		} else {
+			dev_err(&client->dev, "no platform data\n");
+			return -EINVAL;
+		}
 	}
+	pdata = client->dev.platform_data;
 
 	chip = devm_kzalloc(&client->dev, sizeof(*chip), GFP_KERNEL);
 	if (!chip)
@@ -579,6 +587,7 @@ static int lp5562_remove(struct i2c_client *client)
 
 static const struct i2c_device_id lp5562_id[] = {
 	{ "lp5562", 0 },
+	{ "ti,lp5562", 0 }, /* OF compatible */
 	{ }
 };
 MODULE_DEVICE_TABLE(i2c, lp5562_id);
-- 
1.7.9.5


Best Regards,
Milo


