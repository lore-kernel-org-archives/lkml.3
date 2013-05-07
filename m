Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757584Ab3EGHPB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 03:15:01 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:49461 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754352Ab3EGHO7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 03:14:59 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Bryan Wu <cooloney@gmail.com>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Gabriel Fernandez <gabriel.fernandez@stericsson.com>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] leds: lp55xx: support dynamic channel settings in the
 device tree structure
Thread-Topic: [PATCH 1/2] leds: lp55xx: support dynamic channel settings in
 the device tree structure
Thread-Index: Ac5K8o6I26/3RMzsRcyajoQvvyN3lA==
Date: Tue, 7 May 2013 07:14:48 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F82E5C8E3@DQHE06.ent.ti.com>
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

Currently, the LP55xx DT structure supports max 3 channels.
However, LP5523 has max 9 channels and LP5562 has 4 channels.
To enhance this constraint, the DT structure has been changed.

 (a) Use the child node for various channel settings instead of fixed array
 (b) Remove 'num_channel' property.
     This value can be retrieved by counting the children node.
 (c) 'chan-name' property supported
 (d) Documentation updates for LP5521 and LP5523

Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Gabriel Fernandez <gabriel.fernandez@stericsson.com>
Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 .../devicetree/bindings/leds/leds-lp55xx.txt       |  107 ++++++++++++++++++--
 drivers/leds/leds-lp55xx-common.c                  |   61 +++++------
 2 files changed, 126 insertions(+), 42 deletions(-)

diff --git a/Documentation/devicetree/bindings/leds/leds-lp55xx.txt b/Documentation/devicetree/bindings/leds/leds-lp55xx.txt
index 348c88e..a454088 100644
--- a/Documentation/devicetree/bindings/leds/leds-lp55xx.txt
+++ b/Documentation/devicetree/bindings/leds/leds-lp55xx.txt
@@ -2,20 +2,113 @@ Binding for National Semiconductor LP55xx Led Drivers
 
 Required properties:
 - compatible: "national,lp5521" or "national,lp5523"
-- label: Used for naming LEDs
-- num-channel: Number of LED channels
+- reg: I2C slave address
+- clock-mode: Input clock mode, (0: automode, 1: internal, 2: external)
+
+Each child has own specific current settings
 - led-cur: Current setting at each led channel (mA x10, 0 if led is not connected)
 - max-cur: Maximun current at each led channel.
-- clock-mode: Input clock mode, (0: automode, 1: internal, 2: external)
 
-example:
+Optional properties:
+- label: Used for naming LEDs
+
+Alternatively, each child can have specific channel name
+- chan-name: Name of each channel name
+
+example 1) LP5521
+3 LED channels, external clock used. Channel names are 'lp5521_pri:channel0',
+'lp5521_pri:channel1' and 'lp5521_pri:channel2'
 
 lp5521@32 {
 	compatible = "national,lp5521";
 	reg = <0x32>;
 	label = "lp5521_pri";
-	num-channel = /bits/ 8 <3>;
-	led-cur = /bits/ 8 <0x2f 0x2f 0x2f>;
-	max-cur = /bits/ 8 <0x5f 0x5f 0x5f>;
 	clock-mode = /bits/8 <2>;
+
+	chan0 {
+		led-cur = /bits/ 8 <0x2f>;
+		max-cur = /bits/ 8 <0x5f>;
+	};
+
+	chan1 {
+		led-cur = /bits/ 8 <0x2f>;
+		max-cur = /bits/ 8 <0x5f>;
+	};
+
+	chan2 {
+		led-cur = /bits/ 8 <0x2f>;
+		max-cur = /bits/ 8 <0x5f>;
+	};
+};
+
+example 2) LP5523
+9 LED channels with specific name. Internal clock used.
+The I2C slave address is configurable with ASEL1 and ASEL0 pins.
+Available addresses are 32/33/34/35h.
+
+ASEL1    ASEL0    Address
+-------------------------
+ GND      GND       32h
+ GND      VEN       33h
+ VEN      GND       34h
+ VEN      VEN       35h
+
+lp5523@32 {
+	compatible = "national,lp5523";
+	reg = <0x32>;
+	clock-mode = /bits/ 8 <1>;
+
+	chan0 {
+		chan-name = "d1";
+		led-cur = /bits/ 8 <0x14>;
+		max-cur = /bits/ 8 <0x20>;
+	};
+
+	chan1 {
+		chan-name = "d2";
+		led-cur = /bits/ 8 <0x14>;
+		max-cur = /bits/ 8 <0x20>;
+	};
+
+	chan2 {
+		chan-name = "d3";
+		led-cur = /bits/ 8 <0x14>;
+		max-cur = /bits/ 8 <0x20>;
+	};
+
+	chan3 {
+		chan-name = "d4";
+		led-cur = /bits/ 8 <0x14>;
+		max-cur = /bits/ 8 <0x20>;
+	};
+
+	chan4 {
+		chan-name = "d5";
+		led-cur = /bits/ 8 <0x14>;
+		max-cur = /bits/ 8 <0x20>;
+	};
+
+	chan5 {
+		chan-name = "d6";
+		led-cur = /bits/ 8 <0x14>;
+		max-cur = /bits/ 8 <0x20>;
+	};
+
+	chan6 {
+		chan-name = "d7";
+		led-cur = /bits/ 8 <0x14>;
+		max-cur = /bits/ 8 <0x20>;
+	};
+
+	chan7 {
+		chan-name = "d8";
+		led-cur = /bits/ 8 <0x14>;
+		max-cur = /bits/ 8 <0x20>;
+	};
+
+	chan8 {
+		chan-name = "d9";
+		led-cur = /bits/ 8 <0x14>;
+		max-cur = /bits/ 8 <0x20>;
+	};
 };
diff --git a/drivers/leds/leds-lp55xx-common.c b/drivers/leds/leds-lp55xx-common.c
index a0d2bd2..c2fecd4 100644
--- a/drivers/leds/leds-lp55xx-common.c
+++ b/drivers/leds/leds-lp55xx-common.c
@@ -557,51 +557,42 @@ EXPORT_SYMBOL_GPL(lp55xx_unregister_sysfs);
 
 int lp55xx_of_populate_pdata(struct device *dev, struct device_node *np)
 {
+	struct device_node *child;
 	struct lp55xx_platform_data *pdata;
-	u8 led_cur[3];
-	u8 max_cur[3];
-	u8 clock_mode;
-	u8 num_channel;
-	const char *label;
-	struct lp55xx_led_config *led_config;
-	int ret;
-	int i;
+	struct lp55xx_led_config *cfg;
+	int num_channels;
+	int i = 0;
 
 	pdata = devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
 	if (!pdata)
 		return -ENOMEM;
 
-	ret = of_property_read_u8(np, "num-channel", &num_channel);
-	if (ret < 0)
-		return ret;
-	ret = of_property_read_u8_array(np, "led-cur", led_cur, num_channel);
-	if (ret < 0)
-		return ret;
-	ret = of_property_read_u8_array(np, "max-cur", max_cur, num_channel);
-	if (ret < 0)
-		return ret;
-	ret = of_property_read_string(np, "label", &label);
-	if (ret < 0)
-		return ret;
-	ret = of_property_read_u8_array(np, "clock-mode", &clock_mode, 1);
-	if (ret < 0)
-		return ret;
+	num_channels = of_get_child_count(np);
+	if (num_channels == 0) {
+		dev_err(dev, "no LED channels\n");
+		return -EINVAL;
+	}
 
-	led_config = devm_kzalloc(dev, sizeof(*led_config) * num_channel,
-				  GFP_KERNEL);
-	if (!led_config)
+	cfg = devm_kzalloc(dev, sizeof(*cfg) * num_channels, GFP_KERNEL);
+	if (!cfg)
 		return -ENOMEM;
 
-	for (i = 0; i < num_channel; i++) {
-		led_config[i].chan_nr = i;
-		led_config[i].led_current = led_cur[i];
-		led_config[i].max_current = max_cur[i];
+	pdata->led_config = &cfg[0];
+	pdata->num_channels = num_channels;
+
+	for_each_child_of_node(np, child) {
+		cfg[i].chan_nr = i;
+
+		of_property_read_string(child, "chan-name", &cfg[i].name);
+		of_property_read_u8(child, "led-cur", &cfg[i].led_current);
+		of_property_read_u8(child, "max-cur", &cfg[i].max_current);
+
+		i++;
 	}
-	pdata->label = kzalloc(sizeof(char) * 32, GFP_KERNEL);
-	strcpy((char *)pdata->label, (char *) label);
-	pdata->led_config = &led_config[0];
-	pdata->num_channels = num_channel;
-	pdata->clock_mode = clock_mode;
+
+	of_property_read_string(np, "label", &pdata->label);
+	of_property_read_u8(np, "clock-mode", &pdata->clock_mode);
+
 	dev->platform_data = pdata;
 
 	return 0;
-- 
1.7.9.5

Best Regards,
Milo

