Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753861AbaGBNze (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 09:55:34 -0400
Received: from w-smtp-out-7.wedos.net ([46.28.106.5]:35521 "EHLO
	we2-f167.wedos.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753531AbaGBNzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 09:55:33 -0400
Date: Wed, 2 Jul 2014 15:53:28 +0200
From: Josef Gajdusek <atx@atalax.net>
To: linux-iio@vger.kernel.org
Cc: devel@driverdev.osuosl.org, gregkh@linuxfoundation.org, jic23@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] staging:iio:hmc5843: Add support for i2c hmc5983
Message-ID: <20140702135328.GE15493@dashie>
References: <20140702134840.GA15493@dashie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140702134840.GA15493@dashie>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for the hmc5983 i2c interface.
This chip is almost identical to the hmc5883. The difference being added
temperature compensation, additional available sample rate (220Hz) and an SPI
interface.

Signed-off-by: Josef Gajdusek <atx@atx.name>
---
 drivers/staging/iio/magnetometer/Kconfig        |  2 +-
 drivers/staging/iio/magnetometer/hmc5843.h      |  1 +
 drivers/staging/iio/magnetometer/hmc5843_core.c | 20 +++++++++++++++++---
 drivers/staging/iio/magnetometer/hmc5843_i2c.c  |  5 +++--
 4 files changed, 22 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/iio/magnetometer/Kconfig b/drivers/staging/iio/magnetometer/Kconfig
index 28c2612..32c69c0 100644
--- a/drivers/staging/iio/magnetometer/Kconfig
+++ b/drivers/staging/iio/magnetometer/Kconfig
@@ -16,7 +16,7 @@ config SENSORS_HMC5843
 	  This driver can also be compiled as a set of modules.
 	  If so, these modules will be created:
 	  - hmc5843_core (core functions)
-	  - hmc5843_i2c (support for HMC5843, HMC5883 and HMC5883L)
+	  - hmc5843_i2c (support for HMC5843, HMC5883, HMC5883L and HMC5983)
 
 config SENSORS_HMC5843_I2C
 	tristate
diff --git a/drivers/staging/iio/magnetometer/hmc5843.h b/drivers/staging/iio/magnetometer/hmc5843.h
index 4e3cce3..c36041a 100644
--- a/drivers/staging/iio/magnetometer/hmc5843.h
+++ b/drivers/staging/iio/magnetometer/hmc5843.h
@@ -29,6 +29,7 @@ enum hmc5843_ids {
 	HMC5843_ID,
 	HMC5883_ID,
 	HMC5883L_ID,
+	HMC5983_ID,
 };
 
 struct hmc5843_data {
diff --git a/drivers/staging/iio/magnetometer/hmc5843_core.c b/drivers/staging/iio/magnetometer/hmc5843_core.c
index b26ac9f..21f8efd 100644
--- a/drivers/staging/iio/magnetometer/hmc5843_core.c
+++ b/drivers/staging/iio/magnetometer/hmc5843_core.c
@@ -101,6 +101,11 @@ static const int hmc5883_regval_to_samp_freq[][2] = {
 	{75, 0}
 };
 
+static const int hmc5983_regval_to_samp_freq[][2] = {
+	{0, 750000}, {1, 500000}, {3, 0}, {7, 500000}, {15, 0}, {30, 0},
+	{75, 0}, {220, 0}
+};
+
 /* Describe chip variants */
 struct hmc5843_chip_info {
 	const struct iio_chan_spec *channels;
@@ -457,7 +462,7 @@ static const struct iio_chan_spec hmc5843_channels[] = {
 	IIO_CHAN_SOFT_TIMESTAMP(3),
 };
 
-/* Beware: Y and Z are exchanged on HMC5883 */
+/* Beware: Y and Z are exchanged on HMC5883 and 5983 */
 static const struct iio_chan_spec hmc5883_channels[] = {
 	HMC5843_CHANNEL(X, 0),
 	HMC5843_CHANNEL(Z, 1),
@@ -504,6 +509,15 @@ static const struct hmc5843_chip_info hmc5843_chip_info_tbl[] = {
 		.n_regval_to_nanoscale =
 				ARRAY_SIZE(hmc5883l_regval_to_nanoscale),
 	},
+	[HMC5983_ID] = {
+		.channels = hmc5883_channels,
+		.regval_to_samp_freq = hmc5983_regval_to_samp_freq,
+		.n_regval_to_samp_freq =
+				ARRAY_SIZE(hmc5983_regval_to_samp_freq),
+		.regval_to_nanoscale = hmc5883l_regval_to_nanoscale,
+		.n_regval_to_nanoscale =
+				ARRAY_SIZE(hmc5883l_regval_to_nanoscale),
+	}
 };
 
 static int hmc5843_init(struct hmc5843_data *data)
@@ -516,7 +530,7 @@ static int hmc5843_init(struct hmc5843_data *data)
 	if (ret < 0)
 		return ret;
 	if (id[0] != 'H' || id[1] != '4' || id[2] != '3') {
-		dev_err(data->dev, "no HMC5843/5883/5883L sensor\n");
+		dev_err(data->dev, "no HMC5843/5883/5883L/5983 sensor\n");
 		return -ENODEV;
 	}
 
@@ -606,5 +620,5 @@ int hmc5843_common_remove(struct iio_dev *indio_dev)
 EXPORT_SYMBOL(hmc5843_common_remove);
 
 MODULE_AUTHOR("Shubhrajyoti Datta <shubhrajyoti@ti.com>");
-MODULE_DESCRIPTION("HMC5843/5883/5883L core driver");
+MODULE_DESCRIPTION("HMC5843/5883/5883L/5983 core driver");
 MODULE_LICENSE("GPL");
diff --git a/drivers/staging/iio/magnetometer/hmc5843_i2c.c b/drivers/staging/iio/magnetometer/hmc5843_i2c.c
index b3c92d9..753c914 100644
--- a/drivers/staging/iio/magnetometer/hmc5843_i2c.c
+++ b/drivers/staging/iio/magnetometer/hmc5843_i2c.c
@@ -1,5 +1,5 @@
 /*
- * i2c driver for hmc5843/5843/5883/5883l
+ * i2c driver for hmc5843/5843/5883/5883l/5983
  *
  * Split from hmc5843.c
  * Copyright (C) Josef Gajdusek <atx@atx.name>
@@ -79,6 +79,7 @@ static const struct i2c_device_id hmc5843_id[] = {
 	{ "hmc5843", HMC5843_ID },
 	{ "hmc5883", HMC5883_ID },
 	{ "hmc5883l", HMC5883L_ID },
+	{ "hmc5983", HMC5983_ID },
 	{ }
 };
 MODULE_DEVICE_TABLE(i2c, hmc5843_id);
@@ -102,5 +103,5 @@ static struct i2c_driver hmc5843_driver = {
 module_i2c_driver(hmc5843_driver);
 
 MODULE_AUTHOR("Josef Gajdusek <atx@atx.name>");
-MODULE_DESCRIPTION("HMC5843/5883/5883L i2c driver");
+MODULE_DESCRIPTION("HMC5843/5883/5883L/5983 i2c driver");
 MODULE_LICENSE("GPL");
-- 
1.8.5.5

