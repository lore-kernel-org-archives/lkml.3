Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935172Ab3BTEkS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 23:40:18 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:33354 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933599Ab3BTEkP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 23:40:15 -0500
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: "rpurdie@rpsys.net" <rpurdie@rpsys.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] backlight: lp855x_bl: introduce device configuration
 flow
Thread-Topic: [PATCH 1/3] backlight: lp855x_bl: introduce device
 configuration flow
Thread-Index: Ac4PJFfm2B1TLOXmRkGqYRDrlAnehA==
Date: Wed, 20 Feb 2013 04:40:01 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F792735C5@DQHE02.ent.ti.com>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.87.185.62]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At this moment, LP855x device driver has fixed register configuration.
For example, fixed register addresses and values are set on the device
initialization.
But new device of LP855x family, LP8557 has different register map and
initialization sequence.
To support new device architecture, initialization process should be changed.

 Introduce new structure: lp855x_device_config
 ==============================================
 With lp855x_device_config, device specific features are configurable.
 Use configurable function calls and register addresses rather than fixed values.

 Change on device initialization
 ===============================
 In old LP855x driver architecture, the device initialization was simple.
 - Just update the brightness/device control register/ROM area(optional).
 In new LP855x driver architecture, two more works are added - pre_init and
 post_init.
 Those init functions are optional, used for new device LP8557.

 New device initialization flow: generic sequence
 =================================================
 1) pre_init_device()
 2) update the brightness register
 3) update the device control register
 4) update ROM area if need
 5) post_init_device()

 Name change
 ===========
 Use generic name 'lp855x_configure()' instead of 'lp855x_init_registers()'.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/video/backlight/lp855x_bl.c |   78 ++++++++++++++++++++++++++++++-----
 1 file changed, 68 insertions(+), 10 deletions(-)

diff --git a/drivers/video/backlight/lp855x_bl.c b/drivers/video/backlight/lp855x_bl.c
index 6e4db0c..050cfbb 100644
--- a/drivers/video/backlight/lp855x_bl.c
+++ b/drivers/video/backlight/lp855x_bl.c
@@ -29,9 +29,26 @@
 #define DEFAULT_BL_NAME		"lcd-backlight"
 #define MAX_BRIGHTNESS		255
 
+struct lp855x;
+
+/*
+ * struct lp855x_device_config
+ * @pre_init_device: init device function call before updating the brightness
+ * @reg_brightness: register address for brigthenss control
+ * @reg_devicectrl: register address for device control
+ * @post_init_device: late init device function call
+ */
+struct lp855x_device_config {
+	int (*pre_init_device)(struct lp855x *);
+	u8 reg_brightness;
+	u8 reg_devicectrl;
+	int (*post_init_device)(struct lp855x *);
+};
+
 struct lp855x {
 	const char *chipname;
 	enum lp855x_chip_id chip_id;
+	struct lp855x_device_config *cfg;
 	struct i2c_client *client;
 	struct backlight_device *bl;
 	struct device *dev;
@@ -81,21 +98,52 @@ static bool lp855x_is_valid_rom_area(struct lp855x *lp, u8 addr)
 	return (addr >= start && addr <= end);
 }
 
-static int lp855x_init_registers(struct lp855x *lp)
+static struct lp855x_device_config lp855x_dev_cfg = {
+	.reg_brightness = BRIGHTNESS_CTRL,
+	.reg_devicectrl = DEVICE_CTRL,
+};
+
+/*
+ * Device specific configuration flow
+ *
+ *    a) pre_init_device(optional)
+ *    b) update the brightness register
+ *    c) update device control register
+ *    d) update ROM area(optional)
+ *    e) post_init_device(optional)
+ *
+ */
+static int lp855x_configure(struct lp855x *lp)
 {
 	u8 val, addr;
 	int i, ret;
 	struct lp855x_platform_data *pd = lp->pdata;
 
+	switch (lp->chip_id) {
+	case LP8550 ... LP8556:
+		lp->cfg = &lp855x_dev_cfg;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	if (lp->cfg->pre_init_device) {
+		ret = lp->cfg->pre_init_device(lp);
+		if (ret) {
+			dev_err(lp->dev, "pre init device err: %d\n", ret);
+			goto err;
+		}
+	}
+
 	val = pd->initial_brightness;
-	ret = lp855x_write_byte(lp, BRIGHTNESS_CTRL, val);
+	ret = lp855x_write_byte(lp, lp->cfg->reg_brightness, val);
 	if (ret)
-		return ret;
+		goto err;
 
 	val = pd->device_control;
-	ret = lp855x_write_byte(lp, DEVICE_CTRL, val);
+	ret = lp855x_write_byte(lp, lp->cfg->reg_devicectrl, val);
 	if (ret)
-		return ret;
+		goto err;
 
 	if (pd->load_new_rom_data && pd->size_program) {
 		for (i = 0; i < pd->size_program; i++) {
@@ -106,10 +154,21 @@ static int lp855x_init_registers(struct lp855x *lp)
 
 			ret = lp855x_write_byte(lp, addr, val);
 			if (ret)
-				return ret;
+				goto err;
+		}
+	}
+
+	if (lp->cfg->post_init_device) {
+		ret = lp->cfg->post_init_device(lp);
+		if (ret) {
+			dev_err(lp->dev, "post init device err: %d\n", ret);
+			goto err;
 		}
 	}
 
+	return 0;
+
+err:
 	return ret;
 }
 
@@ -271,11 +330,10 @@ static int lp855x_probe(struct i2c_client *cl, const struct i2c_device_id *id)
 	lp->chip_id = id->driver_data;
 	i2c_set_clientdata(cl, lp);
 
-	ret = lp855x_init_registers(lp);
+	ret = lp855x_configure(lp);
 	if (ret) {
-		dev_err(lp->dev, "i2c communication err: %d", ret);
-		if (mode == REGISTER_BASED)
-			goto err_dev;
+		dev_err(lp->dev, "device config err: %d", ret);
+		goto err_dev;
 	}
 
 	ret = lp855x_backlight_register(lp);
-- 
1.7.9.5


Best Regards,
Milo


