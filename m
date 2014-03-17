Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932726AbaCQRgc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 13:36:32 -0400
Received: from kdh-gw.itdev.co.uk ([89.21.227.133]:1032 "EHLO
	hermes.kdh.itdev.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755455AbaCQRda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 13:33:30 -0400
From: Nick Dyer <nick.dyer@itdev.co.uk>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Yufeng Shen <miletus@google.com>, Daniel Kurtz <djkurtz@chromium.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Alan Bowens <Alan.Bowens@atmel.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Meerwald <pmeerw@pmeerw.net>,
        Benson Leung <bleung@chromium.org>,
        Olof Johansson <olofj@chromium.org>, Nick Dyer <nick.dyer@itdev.co.uk>
Subject: [PATCH 01/22] Input: atmel_mxt_ts - remove unnecessary platform data
Date: Mon, 17 Mar 2014 17:26:34 +0000
Message-Id: <1395077215-10922-2-git-send-email-nick.dyer@itdev.co.uk>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1395077215-10922-1-git-send-email-nick.dyer@itdev.co.uk>
References: <1395077215-10922-1-git-send-email-nick.dyer@itdev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is not necessary to download these values to the maXTouch chip on every
probe, since they are stored in NVRAM. It makes life difficult when tuning
the device to keep them in sync with the config array/file, and requires a
new kernel build for minor tweaks.

These parameters only represent a tiny subset of the available
configuration options, tracking all of these options in platform data would
be a endless task. In addition, different versions of maXTouch chips may
have these values in different places or may not even have them at all.

Having these values also makes life more complex for device tree and other
platforms where having to define a static configuration isn't helpful.

Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>
Acked-by: Benson Leung <bleung@chromium.org>
Acked-by: Yufeng Shen <miletus@chromium.org>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 arch/arm/mach-s5pv210/mach-goni.c         |  5 ----
 drivers/input/touchscreen/atmel_mxt_ts.c  | 50 -------------------------------
 drivers/platform/chrome/chromeos_laptop.c | 10 -------
 include/linux/i2c/atmel_mxt_ts.h          |  6 +---
 4 files changed, 1 insertion(+), 70 deletions(-)

diff --git a/arch/arm/mach-s5pv210/mach-goni.c b/arch/arm/mach-s5pv210/mach-goni.c
index e5cd9fb..05b1f5c 100644
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
index a704007..7eb515c 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -685,54 +685,6 @@ static int mxt_make_highchg(struct mxt_data *data)
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
@@ -840,8 +792,6 @@ static int mxt_initialize(struct mxt_data *data)
 	if (error)
 		goto err_free_object_table;
 
-	mxt_handle_pdata(data);
-
 	/* Backup to memory */
 	mxt_write_object(data, MXT_GEN_COMMAND_T6,
 			MXT_COMMAND_BACKUPNV,
diff --git a/drivers/platform/chrome/chromeos_laptop.c b/drivers/platform/chrome/chromeos_laptop.c
index 3e5b4497..78ed277 100644
--- a/drivers/platform/chrome/chromeos_laptop.c
+++ b/drivers/platform/chrome/chromeos_laptop.c
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
1.8.3.2

