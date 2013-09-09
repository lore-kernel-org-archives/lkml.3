Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752892Ab3IIKM7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 06:12:59 -0400
Received: from mail-ea0-f181.google.com ([209.85.215.181]:55894 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752364Ab3IIKK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 06:10:28 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        jic23@cam.ac.uk
Cc: arnd@arndb.de, linus.walleij@linaro.org, denis.ciocca@st.com,
        linux-iio@vger.kernel.org, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 05/14] iio: pressure-core: st: Expand and rename LPS331AP's channel descriptor
Date: Mon,  9 Sep 2013 11:10:01 +0100
Message-Id: <1378721410-30937-6-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1378721410-30937-1-git-send-email-lee.jones@linaro.org>
References: <1378721410-30937-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Due to the MACRO used, the task of reading, understanding and maintaining
the LPS331AP's channel descriptor is substantially difficult. This patch
is based on the view that it's better to have easy to read, maintainable
code than to save a few lines here and there. For that reason we're
expanding the array so initialisation is completed in full.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/iio/pressure/st_pressure_core.c | 45 +++++++++++++++++++++++++--------
 1 file changed, 34 insertions(+), 11 deletions(-)

diff --git a/drivers/iio/pressure/st_pressure_core.c b/drivers/iio/pressure/st_pressure_core.c
index b9cf810..fd7e4d1 100644
--- a/drivers/iio/pressure/st_pressure_core.c
+++ b/drivers/iio/pressure/st_pressure_core.c
@@ -64,16 +64,39 @@
 #define ST_PRESS_LPS331AP_OUT_XL_ADDR		0x28
 #define ST_TEMP_LPS331AP_OUT_L_ADDR		0x2b
 
-static const struct iio_chan_spec st_press_channels[] = {
-	ST_SENSORS_LSM_CHANNELS(IIO_PRESSURE,
+static const struct iio_chan_spec st_press_lps331ap_channels[] = {
+	{
+		.type = IIO_PRESSURE,
+		.channel2 = IIO_NO_MOD,
+		.address = ST_PRESS_LPS331AP_OUT_XL_ADDR,
+		.scan_index = ST_SENSORS_SCAN_X,
+		.scan_type = {
+			.sign = 'u',
+			.realbits = 24,
+			.storagebits = 24,
+			.endianness = IIO_LE,
+		},
+		.info_mask_separate =
 			BIT(IIO_CHAN_INFO_RAW) | BIT(IIO_CHAN_INFO_SCALE),
-			ST_SENSORS_SCAN_X, 0, IIO_NO_MOD, 'u', IIO_LE, 24, 24,
-			ST_PRESS_LPS331AP_OUT_XL_ADDR),
-	ST_SENSORS_LSM_CHANNELS(IIO_TEMP,
-			BIT(IIO_CHAN_INFO_RAW) | BIT(IIO_CHAN_INFO_SCALE) |
-						BIT(IIO_CHAN_INFO_OFFSET),
-			-1, 0, IIO_NO_MOD, 's', IIO_LE, 16, 16,
-			ST_TEMP_LPS331AP_OUT_L_ADDR),
+		.modified = 0,
+	},
+	{
+		.type = IIO_TEMP,
+		.channel2 = IIO_NO_MOD,
+		.address = ST_TEMP_LPS331AP_OUT_L_ADDR,
+		.scan_index = -1,
+		.scan_type = {
+			.sign = 'u',
+			.realbits = 16,
+			.storagebits = 16,
+			.endianness = IIO_LE,
+		},
+		.info_mask_separate =
+			BIT(IIO_CHAN_INFO_RAW) |
+			BIT(IIO_CHAN_INFO_SCALE) |
+			BIT(IIO_CHAN_INFO_OFFSET),
+		.modified = 0,
+	},
 	IIO_CHAN_SOFT_TIMESTAMP(1)
 };
 
@@ -83,7 +106,7 @@ static const struct st_sensors st_press_sensors[] = {
 		.sensors_supported = {
 			[0] = LPS331AP_PRESS_DEV_NAME,
 		},
-		.ch = (struct iio_chan_spec *)st_press_channels,
+		.ch = (struct iio_chan_spec *)st_press_lps331ap_channels,
 		.odr = {
 			.addr = ST_PRESS_LPS331AP_ODR_ADDR,
 			.mask = ST_PRESS_LPS331AP_ODR_MASK,
@@ -222,7 +245,7 @@ int st_press_common_probe(struct iio_dev *indio_dev,
 	pdata->num_data_channels = ST_PRESS_NUMBER_DATA_CHANNELS;
 	pdata->multiread_bit = pdata->sensor->multi_read_bit;
 	indio_dev->channels = pdata->sensor->ch;
-	indio_dev->num_channels = ARRAY_SIZE(st_press_channels);
+	indio_dev->num_channels = ARRAY_SIZE(st_press_lps331ap_channels);
 
 	pdata->current_fullscale = (struct st_sensor_fullscale_avl *)
 						&pdata->sensor->fs.fs_avl[0];
-- 
1.8.1.2

