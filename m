Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754019Ab3F0NIq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 09:08:46 -0400
Received: from kdh-gw.itdev.co.uk ([89.21.227.133]:4426 "EHLO
	hermes.kdh.itdev.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752647Ab3F0Mue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 08:50:34 -0400
From: Nick Dyer <nick.dyer@itdev.co.uk>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Daniel Kurtz <djkurtz@chromium.org>, Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Alan Bowens <Alan.Bowens@atmel.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Meerwald <pmeerw@pmeerw.net>,
        Benson Leung <bleung@chromium.org>,
        Olof Johansson <olofj@chromium.org>, Nick Dyer <nick.dyer@itdev.co.uk>
Subject: [PATCH 01/51] Input: atmel_mxt_ts - Remove unnecessary platform data
Date: Thu, 27 Jun 2013 13:48:36 +0100
Message-Id: <1372337366-9286-2-git-send-email-nick.dyer@itdev.co.uk>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1372337366-9286-1-git-send-email-nick.dyer@itdev.co.uk>
References: <1372337366-9286-1-git-send-email-nick.dyer@itdev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is not necessary to download these values to the maXTouch chip on every
probe, since they are stored in NVRAM. It makes life difficult when tuning the
device to keep them in sync with the config array/file, and requires a new
kernel build for minor tweaks.

These parameters only represent a tiny subset of the available configuration
options, tracking all of these options in platform data would be a endless
task. In addition, different versions of maXTouch chips may have these values
in different places or may not even have them at all.

Having these values also makes life more complex for device tree and other
platforms where having to define a static configuration isn't helpful.

Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>
Acked-by: Benson Leung <bleung@chromium.org>
---
 arch/arm/mach-exynos/mach-nuri.c           |    5 ---
 arch/arm/mach-exynos/mach-universal_c210.c |    5 ---
 arch/arm/mach-s5pv210/mach-goni.c          |    5 ---
 drivers/input/touchscreen/atmel_mxt_ts.c   |   50 ----------------------------
 drivers/platform/x86/chromeos_laptop.c     |   10 ------
 include/linux/i2c/atmel_mxt_ts.h           |    6 +---
 6 files changed, 1 insertion(+), 80 deletions(-)

diff --git a/arch/arm/mach-exynos/mach-nuri.c b/arch/arm/mach-exynos/mach-nuri.c
index 1ea7973..4516d26 100644
--- a/arch/arm/mach-exynos/mach-nuri.c
+++ b/arch/arm/mach-exynos/mach-nuri.c
@@ -333,13 +333,8 @@ static struct i2c_board_info i2c1_devs[] __initdata = {
 
 /* TSP */
 static struct mxt_platform_data mxt_platform_data = {
-	.x_line			= 18,
-	.y_line			= 11,
 	.x_size			= 1024,
 	.y_size			= 600,
-	.blen			= 0x1,
-	.threshold		= 0x28,
-	.voltage		= 2800000,		/* 2.8V */
 	.orient			= MXT_DIAGONAL_COUNTER,
 	.irqflags		= IRQF_TRIGGER_FALLING,
 };
diff --git a/arch/arm/mach-exynos/mach-universal_c210.c b/arch/arm/mach-exynos/mach-universal_c210.c
index 497fcb7..2461e60 100644
--- a/arch/arm/mach-exynos/mach-universal_c210.c
+++ b/arch/arm/mach-exynos/mach-universal_c210.c
@@ -604,13 +604,8 @@ static struct i2c_board_info i2c5_devs[] __initdata = {
 
 /* I2C3 (TSP) */
 static struct mxt_platform_data qt602240_platform_data = {
-	.x_line		= 19,
-	.y_line		= 11,
 	.x_size		= 800,
 	.y_size		= 480,
-	.blen		= 0x11,
-	.threshold	= 0x28,
-	.voltage	= 2800000,		/* 2.8V */
 	.orient		= MXT_DIAGONAL,
 	.irqflags	= IRQF_TRIGGER_FALLING,
 };
diff --git a/arch/arm/mach-s5pv210/mach-goni.c b/arch/arm/mach-s5pv210/mach-goni.c
index 3a38f7b..eca73af 100644
--- a/arch/arm/mach-s5pv210/mach-goni.c
+++ b/arch/arm/mach-s5pv210/mach-goni.c
@@ -239,13 +239,8 @@ static void __init goni_radio_init(void)
 
 /* TSP */
 static struct mxt_platform_data qt602240_platform_data = {
-	.x_line		= 17,
-	.y_line		= 11,
 	.x_size		= 800,
 	.y_size		= 480,
-	.blen		= 0x21,
-	.threshold	= 0x28,
-	.voltage	= 2800000,              /* 2.8V */
 	.orient		= MXT_DIAGONAL,
 	.irqflags	= IRQF_TRIGGER_FALLING,
 };
diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index 59aa240..e01a9ed 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -686,54 +686,6 @@ static int mxt_make_highchg(struct mxt_data *data)
 	return 0;
 }
 
-static void mxt_handle_pdata(struct mxt_data *data)
-{
-	const struct mxt_platform_data *pdata = data->pdata;
-	u8 voltage;
-
-	/* Set touchscreen lines */
-	mxt_write_object(data, MXT_TOUCH_MULTI_T9, MXT_TOUCH_XSIZE,
-			pdata->x_line);
-	mxt_write_object(data, MXT_TOUCH_MULTI_T9, MXT_TOUCH_YSIZE,
-			pdata->y_line);
-
-	/* Set touchscreen orient */
-	mxt_write_object(data, MXT_TOUCH_MULTI_T9, MXT_TOUCH_ORIENT,
-			pdata->orient);
-
-	/* Set touchscreen burst length */
-	mxt_write_object(data, MXT_TOUCH_MULTI_T9,
-			MXT_TOUCH_BLEN, pdata->blen);
-
-	/* Set touchscreen threshold */
-	mxt_write_object(data, MXT_TOUCH_MULTI_T9,
-			MXT_TOUCH_TCHTHR, pdata->threshold);
-
-	/* Set touchscreen resolution */
-	mxt_write_object(data, MXT_TOUCH_MULTI_T9,
-			MXT_TOUCH_XRANGE_LSB, (pdata->x_size - 1) & 0xff);
-	mxt_write_object(data, MXT_TOUCH_MULTI_T9,
-			MXT_TOUCH_XRANGE_MSB, (pdata->x_size - 1) >> 8);
-	mxt_write_object(data, MXT_TOUCH_MULTI_T9,
-			MXT_TOUCH_YRANGE_LSB, (pdata->y_size - 1) & 0xff);
-	mxt_write_object(data, MXT_TOUCH_MULTI_T9,
-			MXT_TOUCH_YRANGE_MSB, (pdata->y_size - 1) >> 8);
-
-	/* Set touchscreen voltage */
-	if (pdata->voltage) {
-		if (pdata->voltage < MXT_VOLTAGE_DEFAULT) {
-			voltage = (MXT_VOLTAGE_DEFAULT - pdata->voltage) /
-				MXT_VOLTAGE_STEP;
-			voltage = 0xff - voltage + 1;
-		} else
-			voltage = (pdata->voltage - MXT_VOLTAGE_DEFAULT) /
-				MXT_VOLTAGE_STEP;
-
-		mxt_write_object(data, MXT_SPT_CTECONFIG_T28,
-				MXT_CTE_VOLTAGE, voltage);
-	}
-}
-
 static int mxt_get_info(struct mxt_data *data)
 {
 	struct i2c_client *client = data->client;
@@ -841,8 +793,6 @@ static int mxt_initialize(struct mxt_data *data)
 	if (error)
 		goto err_free_object_table;
 
-	mxt_handle_pdata(data);
-
 	/* Backup to memory */
 	mxt_write_object(data, MXT_GEN_COMMAND_T6,
 			MXT_COMMAND_BACKUPNV,
diff --git a/drivers/platform/x86/chromeos_laptop.c b/drivers/platform/x86/chromeos_laptop.c
index 3e5b4497..78ed277 100644
--- a/drivers/platform/x86/chromeos_laptop.c
+++ b/drivers/platform/x86/chromeos_laptop.c
@@ -71,13 +71,8 @@ static struct i2c_board_info __initdata tsl2563_als_device = {
 };
 
 static struct mxt_platform_data atmel_224s_tp_platform_data = {
-	.x_line			= 18,
-	.y_line			= 12,
 	.x_size			= 102*20,
 	.y_size			= 68*20,
-	.blen			= 0x80,	/* Gain setting is in upper 4 bits */
-	.threshold		= 0x32,
-	.voltage		= 0,	/* 3.3V */
 	.orient			= MXT_VERTICAL_FLIP,
 	.irqflags		= IRQF_TRIGGER_FALLING,
 	.is_tp			= true,
@@ -96,13 +91,8 @@ static struct i2c_board_info __initdata atmel_224s_tp_device = {
 };
 
 static struct mxt_platform_data atmel_1664s_platform_data = {
-	.x_line			= 32,
-	.y_line			= 50,
 	.x_size			= 1700,
 	.y_size			= 2560,
-	.blen			= 0x89,	/* Gain setting is in upper 4 bits */
-	.threshold		= 0x28,
-	.voltage		= 0,	/* 3.3V */
 	.orient			= MXT_ROTATED_90_COUNTER,
 	.irqflags		= IRQF_TRIGGER_FALLING,
 	.is_tp			= false,
diff --git a/include/linux/i2c/atmel_mxt_ts.h b/include/linux/i2c/atmel_mxt_ts.h
index 99e379b..eff0cdc 100644
--- a/include/linux/i2c/atmel_mxt_ts.h
+++ b/include/linux/i2c/atmel_mxt_ts.h
@@ -33,14 +33,10 @@ struct mxt_platform_data {
 	const u8 *config;
 	size_t config_length;
 
-	unsigned int x_line;
-	unsigned int y_line;
 	unsigned int x_size;
 	unsigned int y_size;
-	unsigned int blen;
-	unsigned int threshold;
-	unsigned int voltage;
 	unsigned char orient;
+
 	unsigned long irqflags;
 	bool is_tp;
 	const unsigned int key_map[MXT_NUM_GPIO];
-- 
1.7.10.4

