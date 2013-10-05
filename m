Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751521Ab3JEIVU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Oct 2013 04:21:20 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:47213 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751302Ab3JEIVR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Oct 2013 04:21:17 -0400
Date: Sat, 5 Oct 2013 10:21:11 +0200
Message-Id: <201310050821.r958LBqP012933@localhost.localdomain>
From: Christophe Leroy <christophe.leroy@c-s.fr>
To: Jonathan Cameron <jic23@cam.ac.uk>
CC: linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        patrick.vasseur@c-s.fr
Subject: [PATCH] IIO AD7923 iio_consumer support
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for iio_consumer to Analog Devices AD7923 ADC driver.

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
Verified-by: Patrick Vasseur <patrick.vasseur@c-s.fr>

diff -urN a/drivers/iio/adc/ad7923.c b/drivers/iio/adc/ad7923.c
--- a/drivers/iio/adc/ad7923.c	1970-01-01 01:00:00.000000000 +0100
+++ b/drivers/iio/adc/ad7923.c	2013-02-12 15:16:29.000000000 +0100
@@ -19,11 +19,15 @@
 #include <linux/interrupt.h>
 
 #include <linux/iio/iio.h>
+#include <linux/iio/driver.h>
+#include <linux/iio/machine.h>
 #include <linux/iio/sysfs.h>
 #include <linux/iio/buffer.h>
 #include <linux/iio/trigger_consumer.h>
 #include <linux/iio/triggered_buffer.h>
 
+#define AD7923_NAME	"ad7923"
+
 #define AD7923_WRITE_CR		(1 << 11)	/* write control register */
 #define AD7923_RANGE		(1 << 1)	/* range to REFin */
 #define AD7923_CODING		(1 << 0)	/* coding is straight binary */
@@ -96,6 +100,7 @@
 			.storagebits = 16,				\
 			.endianness = IIO_BE,				\
 		},							\
+		.datasheet_name = #index,				\
 	}
 
 #define DECLARE_AD7923_CHANNELS(name, bits) \
@@ -195,6 +200,31 @@
 	return IRQ_HANDLED;
 }
 
+/* default maps used by iio consumer */
+static struct iio_map ad7923_default_iio_maps[] = {
+	{
+		.consumer_dev_name = AD7923_NAME,
+		.consumer_channel = "channel_0",
+		.adc_channel_label = "0",
+	},
+	{
+		.consumer_dev_name = AD7923_NAME,
+		.consumer_channel = "channel_1",
+		.adc_channel_label = "1",
+	},
+	{
+		.consumer_dev_name = AD7923_NAME,
+		.consumer_channel = "channel_2",
+		.adc_channel_label = "2",
+	},
+	{
+		.consumer_dev_name = AD7923_NAME,
+		.consumer_channel = "channel_3",
+		.adc_channel_label = "3",
+	},
+	{ }
+};
+
 static int ad7923_scan_direct(struct ad7923_state *st, unsigned ch)
 {
 	int ret, cmd;
@@ -325,12 +355,18 @@
 	if (ret)
 		goto error_disable_reg;
 
-	ret = iio_device_register(indio_dev);
+	ret = iio_map_array_register(indio_dev, ad7923_default_iio_maps);
 	if (ret)
 		goto error_cleanup_ring;
 
+	ret = iio_device_register(indio_dev);
+	if (ret)
+		goto error_unmap;
+
 	return 0;
 
+error_unmap:
+	iio_map_array_unregister(indio_dev);
 error_cleanup_ring:
 	iio_triggered_buffer_cleanup(indio_dev);
 error_disable_reg:
@@ -349,6 +385,7 @@
 	struct ad7923_state *st = iio_priv(indio_dev);
 
 	iio_device_unregister(indio_dev);
+	iio_map_array_unregister(indio_dev);
 	iio_triggered_buffer_cleanup(indio_dev);
 	regulator_disable(st->reg);
 	regulator_put(st->reg);
@@ -368,7 +405,7 @@
 
 static struct spi_driver ad7923_driver = {
 	.driver = {
-		.name	= "ad7923",
+		.name	= AD7923_NAME,
 		.owner	= THIS_MODULE,
 	},
 	.probe		= ad7923_probe,
