Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753772Ab3IJMyT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 08:54:19 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:38395 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752543Ab3IJMuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 08:50:12 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        jic23@cam.ac.uk
Cc: arnd@arndb.de, linus.walleij@linaro.org, denis.ciocca@st.com,
        linux-iio@vger.kernel.org, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 24/38] iio: pressure-core: st: Expand and rename LPS331AP's channel descriptor
Date: Tue, 10 Sep 2013 13:49:25 +0100
Message-Id: <1378817379-8238-25-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1378817379-8238-1-git-send-email-lee.jones@linaro.org>
References: <1378817379-8238-1-git-send-email-lee.jones@linaro.org>
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
index 2ee4bcd..60c2ee4 100644
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
 
 	if (pdata->sensor->fs.addr != 0)
 		pdata->current_fullscale = (struct st_sensor_fullscale_avl *)
-- 
1.8.1.2

