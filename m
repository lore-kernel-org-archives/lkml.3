Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756943AbaCQRiK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 13:38:10 -0400
Received: from kdh-gw.itdev.co.uk ([89.21.227.133]:48813 "EHLO
	hermes.kdh.itdev.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752862AbaCQRd1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 13:33:27 -0400
From: Nick Dyer <nick.dyer@itdev.co.uk>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Yufeng Shen <miletus@google.com>, Daniel Kurtz <djkurtz@chromium.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Alan Bowens <Alan.Bowens@atmel.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Meerwald <pmeerw@pmeerw.net>,
        Benson Leung <bleung@chromium.org>,
        Olof Johansson <olofj@chromium.org>, Nick Dyer <nick.dyer@itdev.co.uk>
Subject: [PATCH 18/22] Input: atmel_mxt_ts - read screen config from chip
Date: Mon, 17 Mar 2014 17:26:51 +0000
Message-Id: <1395077215-10922-19-git-send-email-nick.dyer@itdev.co.uk>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1395077215-10922-1-git-send-email-nick.dyer@itdev.co.uk>
References: <1395077215-10922-1-git-send-email-nick.dyer@itdev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By reading the touchscreen configuration from the settings that the
maXTouch chip is actually using, we can remove some platform data.

The matrix size is not used for anything, and results in some rather
confusing code to re-read it because it may change when configuration
is downloaded, so don't print it out.

Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>
Acked-by: Benson Leung <bleung@chromium.org>
Acked-by: Yufeng Shen <miletus@chromium.org>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 arch/arm/mach-s5pv210/mach-goni.c         |   3 -
 drivers/input/touchscreen/atmel_mxt_ts.c  | 136 ++++++++++++++----------------
 drivers/platform/chrome/chromeos_laptop.c |   6 --
 include/linux/i2c/atmel_mxt_ts.h          |  14 ---
 4 files changed, 65 insertions(+), 94 deletions(-)

diff --git a/arch/arm/mach-s5pv210/mach-goni.c b/arch/arm/mach-s5pv210/mach-goni.c
index 05b1f5c..590a0b1 100644
--- a/arch/arm/mach-s5pv210/mach-goni.c
+++ b/arch/arm/mach-s5pv210/mach-goni.c
@@ -239,9 +239,6 @@ static void __init goni_radio_init(void)
 
 /* TSP */
 static struct mxt_platform_data qt602240_platform_data = {
-	.x_size		= 800,
-	.y_size		= 480,
-	.orient		= MXT_DIAGONAL,
 	.irqflags	= IRQF_TRIGGER_FALLING,
 };
 
diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index b5c3f8e..ce88ada 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -104,33 +104,16 @@
 
 /* MXT_TOUCH_MULTI_T9 field */
 #define MXT_TOUCH_CTRL		0
-#define MXT_TOUCH_XORIGIN	1
-#define MXT_TOUCH_YORIGIN	2
-#define MXT_TOUCH_XSIZE		3
-#define MXT_TOUCH_YSIZE		4
-#define MXT_TOUCH_BLEN		6
-#define MXT_TOUCH_TCHTHR	7
-#define MXT_TOUCH_TCHDI		8
-#define MXT_TOUCH_ORIENT	9
-#define MXT_TOUCH_MOVHYSTI	11
-#define MXT_TOUCH_MOVHYSTN	12
-#define MXT_TOUCH_NUMTOUCH	14
-#define MXT_TOUCH_MRGHYST	15
-#define MXT_TOUCH_MRGTHR	16
-#define MXT_TOUCH_AMPHYST	17
-#define MXT_TOUCH_XRANGE_LSB	18
-#define MXT_TOUCH_XRANGE_MSB	19
-#define MXT_TOUCH_YRANGE_LSB	20
-#define MXT_TOUCH_YRANGE_MSB	21
-#define MXT_TOUCH_XLOCLIP	22
-#define MXT_TOUCH_XHICLIP	23
-#define MXT_TOUCH_YLOCLIP	24
-#define MXT_TOUCH_YHICLIP	25
-#define MXT_TOUCH_XEDGECTRL	26
-#define MXT_TOUCH_XEDGEDIST	27
-#define MXT_TOUCH_YEDGECTRL	28
-#define MXT_TOUCH_YEDGEDIST	29
-#define MXT_TOUCH_JUMPLIMIT	30
+#define MXT_T9_ORIENT		9
+#define MXT_T9_RANGE		18
+
+struct t9_range {
+	u16 x;
+	u16 y;
+} __packed;
+
+/* Touch orient bits */
+#define MXT_XY_SWITCH		(1 << 0)
 
 /* MXT_PROCI_GRIPFACE_T20 field */
 #define MXT_GRIPFACE_CTRL	0
@@ -215,11 +198,6 @@
 #define MXT_PRESS		(1 << 6)
 #define MXT_DETECT		(1 << 7)
 
-/* Touch orient bits */
-#define MXT_XY_SWITCH		(1 << 0)
-#define MXT_X_INVERT		(1 << 1)
-#define MXT_Y_INVERT		(1 << 2)
-
 /* Touchscreen absolute values */
 #define MXT_MAX_AREA		0xff
 
@@ -556,11 +534,6 @@ static int __mxt_read_reg(struct i2c_client *client,
 	return ret;
 }
 
-static int mxt_read_reg(struct i2c_client *client, u16 reg, u8 *val)
-{
-	return __mxt_read_reg(client, reg, 1, val);
-}
-
 static int __mxt_write_reg(struct i2c_client *client, u16 reg, u16 len,
 			   const void *val)
 {
@@ -1269,12 +1242,59 @@ static void mxt_free_object_table(struct mxt_data *data)
 	data->T19_reportid = 0;
 }
 
+static int mxt_read_t9_resolution(struct mxt_data *data)
+{
+	struct i2c_client *client = data->client;
+	int error;
+	struct t9_range range;
+	unsigned char orient;
+	struct mxt_object *object;
+
+	object = mxt_get_object(data, MXT_TOUCH_MULTI_T9);
+	if (!object)
+		return -EINVAL;
+
+	error = __mxt_read_reg(client,
+			       object->start_address + MXT_T9_RANGE,
+			       sizeof(range), &range);
+	if (error)
+		return error;
+
+	le16_to_cpus(range.x);
+	le16_to_cpus(range.y);
+
+	error =  __mxt_read_reg(client,
+				object->start_address + MXT_T9_ORIENT,
+				1, &orient);
+	if (error)
+		return error;
+
+	/* Handle default values */
+	if (range.x == 0)
+		range.x = 1023;
+
+	if (range.y == 0)
+		range.y = 1023;
+
+	if (orient & MXT_XY_SWITCH) {
+		data->max_x = range.y;
+		data->max_y = range.x;
+	} else {
+		data->max_x = range.x;
+		data->max_y = range.y;
+	}
+
+	dev_dbg(&client->dev,
+		"Touchscreen size X%uY%u\n", data->max_x, data->max_y);
+
+	return 0;
+}
+
 static int mxt_initialize(struct mxt_data *data)
 {
 	struct i2c_client *client = data->client;
 	struct mxt_info *info = &data->info;
 	int error;
-	u8 val;
 
 	error = mxt_get_info(data);
 	if (error)
@@ -1303,26 +1323,16 @@ static int mxt_initialize(struct mxt_data *data)
 		goto err_free_object_table;
 	}
 
-	/* Update matrix size at info struct */
-	error = mxt_read_reg(client, MXT_MATRIX_X_SIZE, &val);
-	if (error)
-		goto err_free_object_table;
-	info->matrix_xsize = val;
-
-	error = mxt_read_reg(client, MXT_MATRIX_Y_SIZE, &val);
-	if (error)
+	error = mxt_read_t9_resolution(data);
+	if (error) {
+		dev_err(&client->dev, "Failed to initialize T9 resolution\n");
 		goto err_free_object_table;
-	info->matrix_ysize = val;
-
-	dev_info(&client->dev,
-			"Family: %u Variant: %u Firmware V%u.%u.%02X\n",
-			info->family_id, info->variant_id, info->version >> 4,
-			info->version & 0xf, info->build);
+	}
 
 	dev_info(&client->dev,
-			"Matrix X Size: %u Matrix Y Size: %u Objects: %u\n",
-			info->matrix_xsize, info->matrix_ysize,
-			info->object_num);
+		 "Family: %u Variant: %u Firmware V%u.%u.%02X Objects: %u\n",
+		 info->family_id, info->variant_id, info->version >> 4,
+		 info->version & 0xf, info->build, info->object_num);
 
 	return 0;
 
@@ -1331,20 +1341,6 @@ err_free_object_table:
 	return error;
 }
 
-static void mxt_calc_resolution(struct mxt_data *data)
-{
-	unsigned int max_x = data->pdata->x_size - 1;
-	unsigned int max_y = data->pdata->y_size - 1;
-
-	if (data->pdata->orient & MXT_XY_SWITCH) {
-		data->max_x = max_y;
-		data->max_y = max_x;
-	} else {
-		data->max_x = max_x;
-		data->max_y = max_y;
-	}
-}
-
 /* Firmware Version is returned as Major.Minor.Build */
 static ssize_t mxt_fw_version_show(struct device *dev,
 				   struct device_attribute *attr, char *buf)
@@ -1670,8 +1666,6 @@ static int mxt_probe(struct i2c_client *client,
 	init_completion(&data->reset_completion);
 	init_completion(&data->crc_completion);
 
-	mxt_calc_resolution(data);
-
 	error = mxt_initialize(data);
 	if (error)
 		goto err_free_mem;
diff --git a/drivers/platform/chrome/chromeos_laptop.c b/drivers/platform/chrome/chromeos_laptop.c
index 4f6f0b8..545a6d5 100644
--- a/drivers/platform/chrome/chromeos_laptop.c
+++ b/drivers/platform/chrome/chromeos_laptop.c
@@ -80,9 +80,6 @@ static int mxt_t19_keys[] = {
 };
 
 static struct mxt_platform_data atmel_224s_tp_platform_data = {
-	.x_size			= 102*20,
-	.y_size			= 68*20,
-	.orient			= MXT_VERTICAL_FLIP,
 	.irqflags		= IRQF_TRIGGER_FALLING,
 	.t19_num_keys		= ARRAY_SIZE(mxt_t19_keys),
 	.t19_keymap		= mxt_t19_keys,
@@ -95,9 +92,6 @@ static struct i2c_board_info __initdata atmel_224s_tp_device = {
 };
 
 static struct mxt_platform_data atmel_1664s_platform_data = {
-	.x_size			= 1700,
-	.y_size			= 2560,
-	.orient			= MXT_ROTATED_90_COUNTER,
 	.irqflags		= IRQF_TRIGGER_FALLING,
 };
 
diff --git a/include/linux/i2c/atmel_mxt_ts.h b/include/linux/i2c/atmel_mxt_ts.h
index b569bb8..02bf6ea 100644
--- a/include/linux/i2c/atmel_mxt_ts.h
+++ b/include/linux/i2c/atmel_mxt_ts.h
@@ -15,22 +15,8 @@
 
 #include <linux/types.h>
 
-/* Orient */
-#define MXT_NORMAL		0x0
-#define MXT_DIAGONAL		0x1
-#define MXT_HORIZONTAL_FLIP	0x2
-#define MXT_ROTATED_90_COUNTER	0x3
-#define MXT_VERTICAL_FLIP	0x4
-#define MXT_ROTATED_90		0x5
-#define MXT_ROTATED_180		0x6
-#define MXT_DIAGONAL_COUNTER	0x7
-
 /* The platform data for the Atmel maXTouch touchscreen driver */
 struct mxt_platform_data {
-	unsigned int x_size;
-	unsigned int y_size;
-	unsigned char orient;
-
 	unsigned long irqflags;
 	u8 t19_num_keys;
 	const unsigned int *t19_keymap;
-- 
1.8.3.2

