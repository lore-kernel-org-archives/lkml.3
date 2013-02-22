Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759202Ab3BVSJn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 13:09:43 -0500
Received: from [89.21.227.133] ([89.21.227.133]:44662 "EHLO
	mail.kdh.itdev.co.uk" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759081Ab3BVSIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 13:08:37 -0500
From: Nick Dyer <nick.dyer@itdev.co.uk>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>, Alan.Bowens@atmel.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        pmeerw@pmeerw.net, bleung@chromium.org, olofj@chromium.org
Cc: Nick Dyer <nick.dyer@itdev.co.uk>
Subject: [PATCH 12/40] Input: atmel_mxt_ts - Read screen config from chip
Date: Fri, 22 Feb 2013 17:57:59 +0000
Message-Id: <1361555907-19840-13-git-send-email-nick.dyer@itdev.co.uk>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1361555907-19840-1-git-send-email-nick.dyer@itdev.co.uk>
References: <1361555907-19840-1-git-send-email-nick.dyer@itdev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rather than having a separate configuration in platform data for screen size
and orientation, read it from the settings that the touchscreen controller is
using.

Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>
---
 arch/arm/mach-exynos/mach-nuri.c           |    3 -
 arch/arm/mach-exynos/mach-universal_c210.c |    3 -
 arch/arm/mach-s5pv210/mach-goni.c          |    3 -
 drivers/input/touchscreen/atmel_mxt_ts.c   |  144 ++++++++++++++--------------
 include/linux/i2c/atmel_mxt_ts.h           |   14 ---
 5 files changed, 70 insertions(+), 97 deletions(-)

diff --git a/arch/arm/mach-exynos/mach-nuri.c b/arch/arm/mach-exynos/mach-nuri.c
index 770d314..0c8dac8 100644
--- a/arch/arm/mach-exynos/mach-nuri.c
+++ b/arch/arm/mach-exynos/mach-nuri.c
@@ -335,9 +335,6 @@ static struct i2c_board_info i2c1_devs[] __initdata = {
 
 /* TSP */
 static struct mxt_platform_data mxt_platform_data = {
-	.x_size			= 1024,
-	.y_size			= 600,
-	.orient			= MXT_DIAGONAL_COUNTER,
 	.irqflags		= IRQF_TRIGGER_FALLING,
 };
 
diff --git a/arch/arm/mach-exynos/mach-universal_c210.c b/arch/arm/mach-exynos/mach-universal_c210.c
index 8de6e36..15aae25 100644
--- a/arch/arm/mach-exynos/mach-universal_c210.c
+++ b/arch/arm/mach-exynos/mach-universal_c210.c
@@ -605,9 +605,6 @@ static struct i2c_board_info i2c5_devs[] __initdata = {
 
 /* I2C3 (TSP) */
 static struct mxt_platform_data qt602240_platform_data = {
-	.x_size		= 800,
-	.y_size		= 480,
-	.orient		= MXT_DIAGONAL,
 	.irqflags	= IRQF_TRIGGER_FALLING,
 };
 
diff --git a/arch/arm/mach-s5pv210/mach-goni.c b/arch/arm/mach-s5pv210/mach-goni.c
index 2743751..7cc1387 100644
--- a/arch/arm/mach-s5pv210/mach-goni.c
+++ b/arch/arm/mach-s5pv210/mach-goni.c
@@ -240,9 +240,6 @@ static void __init goni_radio_init(void)
 
 /* TSP */
 static struct mxt_platform_data qt602240_platform_data = {
-	.x_size		= 800,
-	.y_size		= 480,
-	.orient		= MXT_DIAGONAL,
 	.irqflags	= IRQF_TRIGGER_FALLING,
 };
 
diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index 903ff54..e1f2bd3 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -102,33 +102,16 @@
 
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
@@ -211,11 +194,6 @@
 #define MXT_PRESS		(1 << 6)
 #define MXT_DETECT		(1 << 7)
 
-/* Touch orient bits */
-#define MXT_XY_SWITCH		(1 << 0)
-#define MXT_X_INVERT		(1 << 1)
-#define MXT_Y_INVERT		(1 << 2)
-
 /* Touchscreen absolute values */
 #define MXT_MAX_AREA		0xff
 
@@ -532,11 +510,6 @@ static int __mxt_read_reg(struct i2c_client *client,
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
@@ -1178,12 +1151,66 @@ static void mxt_free_object_table(struct mxt_data *data)
 
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
+	/* Update matrix size in info struct (may change after reset) */
+	error = mxt_get_info(data);
+	if (error)
+		return error;
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
+	dev_info(&client->dev,
+			"Matrix Size X%uY%u Touchscreen size X%uY%u\n",
+			data->info.matrix_xsize, data->info.matrix_ysize,
+			data->max_x, data->max_y);
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
 	if (error) {
@@ -1222,46 +1249,17 @@ static int mxt_initialize(struct mxt_data *data)
 		return error;
 	}
 
-	/* Update matrix size at info struct */
-	error = mxt_read_reg(client, MXT_MATRIX_X_SIZE, &val);
+	error = mxt_read_t9_resolution(data);
 	if (error)
-		goto err_free_object_table;
-	info->matrix_xsize = val;
-
-	error = mxt_read_reg(client, MXT_MATRIX_Y_SIZE, &val);
-	if (error)
-		goto err_free_object_table;
-	info->matrix_ysize = val;
+		dev_warn(&client->dev, "Failed to initialize T9 resolution\n");
 
 	dev_info(&client->dev,
-			"Family ID: %u Variant ID: %u Firmware V%u.%u.%02X\n",
+			"Family ID: %u Variant ID: %u Firmware V%u.%u.%02X "
+			" Object Num:%d\n",
 			info->family_id, info->variant_id, info->version >> 4,
-			info->version & 0xf, info->build);
-
-	dev_info(&client->dev,
-			"Matrix X Size: %u Matrix Y Size: %u Object Num: %u\n",
-			info->matrix_xsize, info->matrix_ysize,
-			info->object_num);
+			info->version & 0xf, info->build, info->object_num);
 
 	return 0;
-
-err_free_object_table:
-	mxt_free_object_table(data);
-	return error;
-}
-
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
 }
 
 /* Firmware Version is returned as Major.Minor.Build */
@@ -1650,8 +1648,6 @@ static int mxt_probe(struct i2c_client *client,
 	data->pdata = pdata;
 	data->irq = client->irq;
 
-	mxt_calc_resolution(data);
-
 	error = mxt_initialize(data);
 	if (error)
 		goto err_free_mem;
diff --git a/include/linux/i2c/atmel_mxt_ts.h b/include/linux/i2c/atmel_mxt_ts.h
index 1ebb8fd..e7bceee 100644
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
 	u8(*read_chg) (void);
 };
-- 
1.7.10.4

