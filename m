Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759423Ab3BVSQw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 13:16:52 -0500
Received: from [89.21.227.133] ([89.21.227.133]:32129 "EHLO
	mail.kdh.itdev.co.uk" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759009Ab3BVSIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 13:08:32 -0500
From: Nick Dyer <nick.dyer@itdev.co.uk>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>, Alan.Bowens@atmel.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        pmeerw@pmeerw.net, bleung@chromium.org, olofj@chromium.org
Cc: Nick Dyer <nick.dyer@itdev.co.uk>
Subject: [PATCH 06/40] Input: atmel_mxt_ts - Remove unnecessary platform data
Date: Fri, 22 Feb 2013 17:57:53 +0000
Message-Id: <1361555907-19840-7-git-send-email-nick.dyer@itdev.co.uk>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1361555907-19840-1-git-send-email-nick.dyer@itdev.co.uk>
References: <1361555907-19840-1-git-send-email-nick.dyer@itdev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is not necessary to download these values to the chip on every probe, since
they are stored in non-volatile memory. They only represent a tiny subset of
the available configuration options, tracking all of these options in platform
data would be a sisyphean task. It makes platform data more complex and makes
device integration more error-prone because it duplicates information set
elsewhere. In addition, different versions of maXTouch chips may have these
values in different places or may not even have them at all.

Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>
---
 arch/arm/mach-exynos/mach-nuri.c           |    5 ---
 arch/arm/mach-exynos/mach-universal_c210.c |    5 ---
 arch/arm/mach-s5pv210/mach-goni.c          |    5 ---
 drivers/input/touchscreen/atmel_mxt_ts.c   |   50 ----------------------------
 include/linux/i2c/atmel_mxt_ts.h           |    6 +---
 5 files changed, 1 insertion(+), 70 deletions(-)

diff --git a/arch/arm/mach-exynos/mach-nuri.c b/arch/arm/mach-exynos/mach-nuri.c
index c05d7aa..770d314 100644
--- a/arch/arm/mach-exynos/mach-nuri.c
+++ b/arch/arm/mach-exynos/mach-nuri.c
@@ -335,13 +335,8 @@ static struct i2c_board_info i2c1_devs[] __initdata = {
 
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
index ebc9dd3..8de6e36 100644
--- a/arch/arm/mach-exynos/mach-universal_c210.c
+++ b/arch/arm/mach-exynos/mach-universal_c210.c
@@ -605,13 +605,8 @@ static struct i2c_board_info i2c5_devs[] __initdata = {
 
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
index 55e1dba..2743751 100644
--- a/arch/arm/mach-s5pv210/mach-goni.c
+++ b/arch/arm/mach-s5pv210/mach-goni.c
@@ -240,13 +240,8 @@ static void __init goni_radio_init(void)
 
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
index 9e734dc..fa294d1 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -737,54 +737,6 @@ static int mxt_make_highchg(struct mxt_data *data)
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
@@ -903,8 +855,6 @@ static int mxt_initialize(struct mxt_data *data)
 		return error;
 	}
 
-	mxt_handle_pdata(data);
-
 	error = mxt_t6_command(data, MXT_COMMAND_BACKUPNV, MXT_BACKUP_VALUE, false);
 	if (!error)
 		mxt_soft_reset(data, MXT_RESET_VALUE);
diff --git a/include/linux/i2c/atmel_mxt_ts.h b/include/linux/i2c/atmel_mxt_ts.h
index ef59c22..6a879a6 100644
--- a/include/linux/i2c/atmel_mxt_ts.h
+++ b/include/linux/i2c/atmel_mxt_ts.h
@@ -30,14 +30,10 @@ struct mxt_platform_data {
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
 	u8(*read_chg) (void);
 };
-- 
1.7.10.4

