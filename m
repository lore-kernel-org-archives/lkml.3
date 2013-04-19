Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757103Ab3DSG3O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 02:29:14 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:33902 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756975Ab3DSG2v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 02:28:51 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: "akpm@linux-foundation.org" <akpm@linux-foundation.org>
CC: Richard Purdie <rpurdie@rpsys.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 5/5] backlight: lp855x: add a device tree structure
Thread-Topic: [PATCH 5/5] backlight: lp855x: add a device tree structure
Thread-Index: Ac48xyE+yn9ySMrCR3WOMavI6PkR4Q==
Date: Fri, 19 Apr 2013 06:28:40 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F82E562BE@DQHE06.ent.ti.com>
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

This patch enables supporting the DT structure of LP855x family devices.
If the platform data is NULL, the driver tries to parse a DT structure.
Then, the platform data is copied from the DT.
Documentation is added as well.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 .../devicetree/bindings/video/backlight/lp855x.txt |   41 +++++++++++
 drivers/video/backlight/lp855x_bl.c                |   73 +++++++++++++++++++-
 2 files changed, 112 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/video/backlight/lp855x.txt

diff --git a/Documentation/devicetree/bindings/video/backlight/lp855x.txt b/Documentation/devicetree/bindings/video/backlight/lp855x.txt
new file mode 100644
index 0000000..1482103
--- /dev/null
+++ b/Documentation/devicetree/bindings/video/backlight/lp855x.txt
@@ -0,0 +1,41 @@
+lp855x bindings
+
+Required properties:
+  - compatible: "ti,lp8550", "ti,lp8551", "ti,lp8552", "ti,lp8553",
+                "ti,lp8556", "ti,lp8557"
+  - reg: I2C slave address (u8)
+  - dev-ctrl: Value of DEVICE CONTROL register (u8). It depends on the device.
+
+Optional properties:
+  - bl-name: Backlight device name (string)
+  - init-brt: Initial value of backlight brightness (u8)
+  - pwm-period: PWM period value. Set only PWM input mode used (u32)
+  - rom-addr: Register address of ROM area to be updated (u8)
+  - rom-val: Register value to be updated (u8)
+
+Example:
+
+	/* LP8556 */
+	backlight@2c {
+		compatible = "ti,lp8556";
+		reg = <0x2c>;
+
+		bl-name = "lcd-bl";
+		dev-ctrl = /bits/ 8 <0x85>;
+		init-brt = /bits/ 8 <0x10>;
+	};
+
+	/* LP8557 */
+	backlight@2c {
+		compatible = "ti,lp8557";
+		reg = <0x2c>;
+
+		dev-ctrl = /bits/ 8 <0x41>;
+		init-brt = /bits/ 8 <0x0a>;
+
+		/* 4V OV, 4 output LED string enabled */
+		rom_14h {
+			rom-addr = /bits/ 8 <0x14>;
+			rom-val = /bits/ 8 <0xcf>;
+		};
+	};
diff --git a/drivers/video/backlight/lp855x_bl.c b/drivers/video/backlight/lp855x_bl.c
index f558f8f..a0e1e02 100644
--- a/drivers/video/backlight/lp855x_bl.c
+++ b/drivers/video/backlight/lp855x_bl.c
@@ -14,6 +14,7 @@
 #include <linux/i2c.h>
 #include <linux/backlight.h>
 #include <linux/err.h>
+#include <linux/of.h>
 #include <linux/platform_data/lp855x.h>
 #include <linux/pwm.h>
 
@@ -338,15 +339,71 @@ static const struct attribute_group lp855x_attr_group = {
 	.attrs = lp855x_attributes,
 };
 
+#ifdef CONFIG_OF
+static int lp855x_parse_dt(struct device *dev, struct device_node *node)
+{
+	struct lp855x_platform_data *pdata;
+	int rom_length;
+
+	if (!node) {
+		dev_err(dev, "no platform data\n");
+		return -EINVAL;
+	}
+
+	pdata = devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
+	if (!pdata)
+		return -ENOMEM;
+
+	of_property_read_string(node, "bl-name", &pdata->name);
+	of_property_read_u8(node, "dev-ctrl", &pdata->device_control);
+	of_property_read_u8(node, "init-brt", &pdata->initial_brightness);
+	of_property_read_u32(node, "pwm-period", &pdata->period_ns);
+
+	/* Fill ROM platform data if defined */
+	rom_length = of_get_child_count(node);
+	if (rom_length > 0) {
+		struct lp855x_rom_data *rom;
+		struct device_node *child;
+		int i = 0;
+
+		rom = devm_kzalloc(dev, sizeof(*rom) * rom_length, GFP_KERNEL);
+		if (!rom)
+			return -ENOMEM;
+
+		for_each_child_of_node(node, child) {
+			of_property_read_u8(child, "rom-addr", &rom[i].addr);
+			of_property_read_u8(child, "rom-val", &rom[i].val);
+			i++;
+		}
+
+		pdata->size_program = rom_length;
+		pdata->rom_data = &rom[0];
+	}
+
+	dev->platform_data = pdata;
+
+	return 0;
+}
+#else
+static int lp855x_parse_dt(struct device *dev, struct device_node *node)
+{
+	return -EINVAL;
+}
+#endif
+
 static int lp855x_probe(struct i2c_client *cl, const struct i2c_device_id *id)
 {
 	struct lp855x *lp;
 	struct lp855x_platform_data *pdata = cl->dev.platform_data;
+	struct device_node *node = cl->dev.of_node;
 	int ret;
 
 	if (!pdata) {
-		dev_err(&cl->dev, "no platform data supplied\n");
-		return -EINVAL;
+		ret = lp855x_parse_dt(&cl->dev, node);
+		if (ret < 0)
+			return ret;
+
+		pdata = cl->dev.platform_data;
 	}
 
 	if (!i2c_check_functionality(cl->adapter, I2C_FUNC_SMBUS_I2C_BLOCK))
@@ -408,6 +465,17 @@ static int lp855x_remove(struct i2c_client *cl)
 	return 0;
 }
 
+static const struct of_device_id lp855x_dt_ids[] = {
+	{ .compatible = "ti,lp8550", },
+	{ .compatible = "ti,lp8551", },
+	{ .compatible = "ti,lp8552", },
+	{ .compatible = "ti,lp8553", },
+	{ .compatible = "ti,lp8556", },
+	{ .compatible = "ti,lp8557", },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, lp855x_dt_ids);
+
 static const struct i2c_device_id lp855x_ids[] = {
 	{"lp8550", LP8550},
 	{"lp8551", LP8551},
@@ -422,6 +490,7 @@ MODULE_DEVICE_TABLE(i2c, lp855x_ids);
 static struct i2c_driver lp855x_driver = {
 	.driver = {
 		   .name = "lp855x",
+		   .of_match_table = of_match_ptr(lp855x_dt_ids),
 		   },
 	.probe = lp855x_probe,
 	.remove = lp855x_remove,
-- 
1.7.9.5


Best Regards,
Milo


