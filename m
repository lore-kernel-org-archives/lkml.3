Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757196Ab3DSG3U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 02:29:20 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:52045 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757007Ab3DSG26 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 02:28:58 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: "akpm@linux-foundation.org" <akpm@linux-foundation.org>
CC: Richard Purdie <rpurdie@rpsys.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/5] backlight: lp855x: move backlight mode platform data
Thread-Topic: [PATCH 2/5] backlight: lp855x: move backlight mode platform
 data
Thread-Index: Ac48xxzUF+qIvMRCSo+5scqGnzZThg==
Date: Fri, 19 Apr 2013 06:28:32 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F82E562A6@DQHE06.ent.ti.com>
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

The brightness of LP855x devices is controlled by I2C register or PWM input.
This mode was selected through the platform data, but it can be chosen by
the driver internally without platform data configuration.

How to decide the control mode:
  If the PWM period has specific value, the mode is PWM input.
  On the other hand, the mode is register-based.
  This mode selection is done on the _probe().

Move 'mode' from a header file to the driver private data structure, 'lp855x'.
And correlated code was replaced.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 Documentation/backlight/lp855x-driver.txt |    3 ---
 drivers/video/backlight/lp855x_bl.c       |   21 +++++++++++++++------
 include/linux/platform_data/lp855x.h      |    7 -------
 3 files changed, 15 insertions(+), 16 deletions(-)

diff --git a/Documentation/backlight/lp855x-driver.txt b/Documentation/backlight/lp855x-driver.txt
index 18b06ca..72e2a67 100644
--- a/Documentation/backlight/lp855x-driver.txt
+++ b/Documentation/backlight/lp855x-driver.txt
@@ -32,7 +32,6 @@ Platform data for lp855x
 For supporting platform specific data, the lp855x platform data can be used.
 
 * name : Backlight driver name. If it is not defined, default name is set.
-* mode : Brightness control mode. PWM or register based.
 * device_control : Value of DEVICE CONTROL register.
 * initial_brightness : Initial value of backlight brightness.
 * period_ns : Platform specific PWM period value. unit is nano.
@@ -54,7 +53,6 @@ static struct lp855x_rom_data lp8552_eeprom_arr[] = {
 
 static struct lp855x_platform_data lp8552_pdata = {
 	.name = "lcd-bl",
-	.mode = REGISTER_BASED,
 	.device_control = I2C_CONFIG(LP8552),
 	.initial_brightness = INITIAL_BRT,
 	.load_new_rom_data = 1,
@@ -65,7 +63,6 @@ static struct lp855x_platform_data lp8552_pdata = {
 example 2) lp8556 platform data : pwm input mode with default rom data
 
 static struct lp855x_platform_data lp8556_pdata = {
-	.mode = PWM_BASED,
 	.device_control = PWM_CONFIG(LP8556),
 	.initial_brightness = INITIAL_BRT,
 	.period_ns = 1000000,
diff --git a/drivers/video/backlight/lp855x_bl.c b/drivers/video/backlight/lp855x_bl.c
index df937ce..b94dc00 100644
--- a/drivers/video/backlight/lp855x_bl.c
+++ b/drivers/video/backlight/lp855x_bl.c
@@ -38,6 +38,11 @@
 #define DEFAULT_BL_NAME		"lcd-backlight"
 #define MAX_BRIGHTNESS		255
 
+enum lp855x_brightness_ctrl_mode {
+	PWM_BASED = 1,
+	REGISTER_BASED,
+};
+
 struct lp855x;
 
 /*
@@ -57,6 +62,7 @@ struct lp855x_device_config {
 struct lp855x {
 	const char *chipname;
 	enum lp855x_chip_id chip_id;
+	enum lp855x_brightness_ctrl_mode mode;
 	struct lp855x_device_config *cfg;
 	struct i2c_client *client;
 	struct backlight_device *bl;
@@ -238,18 +244,17 @@ static void lp855x_pwm_ctrl(struct lp855x *lp, int br, int max_br)
 static int lp855x_bl_update_status(struct backlight_device *bl)
 {
 	struct lp855x *lp = bl_get_data(bl);
-	enum lp855x_brightness_ctrl_mode mode = lp->pdata->mode;
 
 	if (bl->props.state & BL_CORE_SUSPENDED)
 		bl->props.brightness = 0;
 
-	if (mode == PWM_BASED) {
+	if (lp->mode == PWM_BASED) {
 		int br = bl->props.brightness;
 		int max_br = bl->props.max_brightness;
 
 		lp855x_pwm_ctrl(lp, br, max_br);
 
-	} else if (mode == REGISTER_BASED) {
+	} else if (lp->mode == REGISTER_BASED) {
 		u8 val = bl->props.brightness;
 		lp855x_write_byte(lp, lp->cfg->reg_brightness, val);
 	}
@@ -310,12 +315,11 @@ static ssize_t lp855x_get_bl_ctl_mode(struct device *dev,
 				     struct device_attribute *attr, char *buf)
 {
 	struct lp855x *lp = dev_get_drvdata(dev);
-	enum lp855x_brightness_ctrl_mode mode = lp->pdata->mode;
 	char *strmode = NULL;
 
-	if (mode == PWM_BASED)
+	if (lp->mode == PWM_BASED)
 		strmode = "pwm based";
-	else if (mode == REGISTER_BASED)
+	else if (lp->mode == REGISTER_BASED)
 		strmode = "register based";
 
 	return scnprintf(buf, PAGE_SIZE, "%s\n", strmode);
@@ -352,6 +356,11 @@ static int lp855x_probe(struct i2c_client *cl, const struct i2c_device_id *id)
 	if (!lp)
 		return -ENOMEM;
 
+	if (pdata->period_ns > 0)
+		lp->mode = PWM_BASED;
+	else
+		lp->mode = REGISTER_BASED;
+
 	lp->client = cl;
 	lp->dev = &cl->dev;
 	lp->pdata = pdata;
diff --git a/include/linux/platform_data/lp855x.h b/include/linux/platform_data/lp855x.h
index d135939..e0954df 100644
--- a/include/linux/platform_data/lp855x.h
+++ b/include/linux/platform_data/lp855x.h
@@ -69,11 +69,6 @@ enum lp855x_chip_id {
 	LP8557,
 };
 
-enum lp855x_brightness_ctrl_mode {
-	PWM_BASED = 1,
-	REGISTER_BASED,
-};
-
 enum lp8550_brighntess_source {
 	LP8550_PWM_ONLY,
 	LP8550_I2C_ONLY = 2,
@@ -116,7 +111,6 @@ struct lp855x_rom_data {
 /**
  * struct lp855x_platform_data
  * @name : Backlight driver name. If it is not defined, default name is set.
- * @mode : brightness control by pwm or lp855x register
  * @device_control : value of DEVICE CONTROL register
  * @initial_brightness : initial value of backlight brightness
  * @period_ns : platform specific pwm period value. unit is nano.
@@ -129,7 +123,6 @@ struct lp855x_rom_data {
  */
 struct lp855x_platform_data {
 	const char *name;
-	enum lp855x_brightness_ctrl_mode mode;
 	u8 device_control;
 	int initial_brightness;
 	unsigned int period_ns;
-- 
1.7.9.5


Best Regards,
Milo


