Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753695Ab3IJMxz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 08:53:55 -0400
Received: from mail-ea0-f178.google.com ([209.85.215.178]:39049 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752629Ab3IJMuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 08:50:16 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        jic23@cam.ac.uk
Cc: arnd@arndb.de, linus.walleij@linaro.org, denis.ciocca@st.com,
        linux-iio@vger.kernel.org, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 28/38] iio: pressure: st: Add support for new LPS001WP pressure sensor
Date: Tue, 10 Sep 2013 13:49:29 +0100
Message-Id: <1378817379-8238-29-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1378817379-8238-1-git-send-email-lee.jones@linaro.org>
References: <1378817379-8238-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here we use existing practices to introduce support for another
pressure/temperature sensor, the LPS001WP.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/iio/pressure/st_pressure.h      |  1 +
 drivers/iio/pressure/st_pressure_core.c | 84 +++++++++++++++++++++++++++++++++
 drivers/iio/pressure/st_pressure_i2c.c  |  1 +
 3 files changed, 86 insertions(+)

diff --git a/drivers/iio/pressure/st_pressure.h b/drivers/iio/pressure/st_pressure.h
index f1bebce..36b1cc6 100644
--- a/drivers/iio/pressure/st_pressure.h
+++ b/drivers/iio/pressure/st_pressure.h
@@ -15,6 +15,7 @@
 #include <linux/iio/common/st_sensors.h>
 
 #define LPS331AP_PRESS_DEV_NAME		"lps331ap_press"
+#define LPS001WP_PRESS_DEV_NAME		"lps001wp_press"
 
 /**
  * struct st_sensors_platform_data - default press platform data
diff --git a/drivers/iio/pressure/st_pressure_core.c b/drivers/iio/pressure/st_pressure_core.c
index 34b3fb1..b42614a 100644
--- a/drivers/iio/pressure/st_pressure_core.c
+++ b/drivers/iio/pressure/st_pressure_core.c
@@ -64,6 +64,21 @@
 #define ST_PRESS_LPS331AP_OUT_XL_ADDR		0x28
 #define ST_TEMP_LPS331AP_OUT_L_ADDR		0x2b
 
+/* CUSTOM VALUES FOR LPS001WP SENSOR */
+#define ST_PRESS_LPS001WP_WAI_EXP		0xba
+#define ST_PRESS_LPS001WP_ODR_ADDR		0x20
+#define ST_PRESS_LPS001WP_ODR_MASK		0x30
+#define ST_PRESS_LPS001WP_ODR_AVL_1HZ_VAL	0x01
+#define ST_PRESS_LPS001WP_ODR_AVL_7HZ_VAL	0x02
+#define ST_PRESS_LPS001WP_ODR_AVL_13HZ_VAL	0x03
+#define ST_PRESS_LPS001WP_PW_ADDR		0x20
+#define ST_PRESS_LPS001WP_PW_MASK		0x40
+#define ST_PRESS_LPS001WP_BDU_ADDR		0x20
+#define ST_PRESS_LPS001WP_BDU_MASK		0x04
+#define ST_PRESS_LPS001WP_MULTIREAD_BIT		true
+#define ST_PRESS_LPS001WP_OUT_L_ADDR		0x28
+#define ST_TEMP_LPS001WP_OUT_L_ADDR		0x2a
+
 static const struct iio_chan_spec st_press_lps331ap_channels[] = {
 	{
 		.type = IIO_PRESSURE,
@@ -100,6 +115,40 @@ static const struct iio_chan_spec st_press_lps331ap_channels[] = {
 	IIO_CHAN_SOFT_TIMESTAMP(1)
 };
 
+static const struct iio_chan_spec st_press_lps001wp_channels[] = {
+	{
+		.type = IIO_PRESSURE,
+		.channel2 = IIO_NO_MOD,
+		.address = ST_PRESS_LPS001WP_OUT_L_ADDR,
+		.scan_index = ST_SENSORS_SCAN_X,
+		.scan_type = {
+			.sign = 'u',
+			.realbits = 16,
+			.storagebits = 16,
+			.endianness = IIO_LE,
+		},
+		.info_mask_separate = BIT(IIO_CHAN_INFO_RAW),
+		.modified = 0,
+	},
+	{
+		.type = IIO_TEMP,
+		.channel2 = IIO_NO_MOD,
+		.address = ST_TEMP_LPS001WP_OUT_L_ADDR,
+		.scan_index = -1,
+		.scan_type = {
+			.sign = 'u',
+			.realbits = 16,
+			.storagebits = 16,
+			.endianness = IIO_LE,
+		},
+		.info_mask_separate =
+			BIT(IIO_CHAN_INFO_RAW) |
+			BIT(IIO_CHAN_INFO_OFFSET),
+		.modified = 0,
+	},
+	IIO_CHAN_SOFT_TIMESTAMP(1)
+};
+
 static const struct st_sensors st_press_sensors[] = {
 	{
 		.wai = ST_PRESS_LPS331AP_WAI_EXP,
@@ -148,6 +197,41 @@ static const struct st_sensors st_press_sensors[] = {
 		.multi_read_bit = ST_PRESS_LPS331AP_MULTIREAD_BIT,
 		.bootime = 2,
 	},
+	{
+		.wai = ST_PRESS_LPS001WP_WAI_EXP,
+		.sensors_supported = {
+			[0] = LPS001WP_PRESS_DEV_NAME,
+		},
+		.ch = (struct iio_chan_spec *)st_press_lps001wp_channels,
+		.num_ch = ARRAY_SIZE(st_press_lps001wp_channels),
+		.odr = {
+			.addr = ST_PRESS_LPS001WP_ODR_ADDR,
+			.mask = ST_PRESS_LPS001WP_ODR_MASK,
+			.odr_avl = {
+				{ 1, ST_PRESS_LPS001WP_ODR_AVL_1HZ_VAL, },
+				{ 7, ST_PRESS_LPS001WP_ODR_AVL_7HZ_VAL, },
+				{ 13, ST_PRESS_LPS001WP_ODR_AVL_13HZ_VAL, },
+			},
+		},
+		.pw = {
+			.addr = ST_PRESS_LPS001WP_PW_ADDR,
+			.mask = ST_PRESS_LPS001WP_PW_MASK,
+			.value_on = ST_SENSORS_DEFAULT_POWER_ON_VALUE,
+			.value_off = ST_SENSORS_DEFAULT_POWER_OFF_VALUE,
+		},
+		.fs = {
+			.addr = 0,
+		},
+		.bdu = {
+			.addr = ST_PRESS_LPS001WP_BDU_ADDR,
+			.mask = ST_PRESS_LPS001WP_BDU_MASK,
+		},
+		.drdy_irq = {
+			.addr = 0,
+		},
+		.multi_read_bit = ST_PRESS_LPS001WP_MULTIREAD_BIT,
+		.bootime = 2,
+	},
 };
 
 static int st_press_read_raw(struct iio_dev *indio_dev,
diff --git a/drivers/iio/pressure/st_pressure_i2c.c b/drivers/iio/pressure/st_pressure_i2c.c
index 08aac5e..ada5cbd 100644
--- a/drivers/iio/pressure/st_pressure_i2c.c
+++ b/drivers/iio/pressure/st_pressure_i2c.c
@@ -50,6 +50,7 @@ static int st_press_i2c_remove(struct i2c_client *client)
 
 static const struct i2c_device_id st_press_id_table[] = {
 	{ LPS331AP_PRESS_DEV_NAME },
+	{ LPS001WP_PRESS_DEV_NAME },
 	{},
 };
 MODULE_DEVICE_TABLE(i2c, st_press_id_table);
-- 
1.8.1.2

