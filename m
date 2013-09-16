Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751967Ab3IPQE1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 12:04:27 -0400
Received: from mail-ea0-f181.google.com ([209.85.215.181]:33423 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751680Ab3IPQC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 12:02:57 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        jic23@cam.ac.uk
Cc: arnd@arndb.de, linus.walleij@linaro.org, denis.ciocca@st.com,
        linux-iio@vger.kernel.org, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 19/20] iio: gyro-core: st: Clean up error handling in probe()
Date: Mon, 16 Sep 2013 17:02:25 +0100
Message-Id: <1379347346-823-20-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1379347346-823-1-git-send-email-lee.jones@linaro.org>
References: <1379347346-823-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reduce the amount of those unnecessary goto calls, as in most cases
we can simply return immediately. We also only call for the IRQ number
once and use that value throughout.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/iio/gyro/st_gyro_core.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/iio/gyro/st_gyro_core.c b/drivers/iio/gyro/st_gyro_core.c
index e13c2b0..9f80817 100644
--- a/drivers/iio/gyro/st_gyro_core.c
+++ b/drivers/iio/gyro/st_gyro_core.c
@@ -305,8 +305,9 @@ static const struct iio_trigger_ops st_gyro_trigger_ops = {
 int st_gyro_common_probe(struct iio_dev *indio_dev,
 					struct st_sensors_platform_data *pdata)
 {
-	int err;
 	struct st_sensor_data *gdata = iio_priv(indio_dev);
+	int irq = gdata->get_irq_data_ready(indio_dev);
+	int err;
 
 	indio_dev->modes = INDIO_DIRECT_MODE;
 	indio_dev->info = &gyro_info;
@@ -314,7 +315,7 @@ int st_gyro_common_probe(struct iio_dev *indio_dev,
 	err = st_sensors_check_device_support(indio_dev,
 				ARRAY_SIZE(st_gyro_sensors), st_gyro_sensors);
 	if (err < 0)
-		goto st_gyro_common_probe_error;
+		return err;
 
 	gdata->num_data_channels = ST_GYRO_NUMBER_DATA_CHANNELS;
 	gdata->multiread_bit = gdata->sensor->multi_read_bit;
@@ -327,12 +328,12 @@ int st_gyro_common_probe(struct iio_dev *indio_dev,
 
 	err = st_sensors_init_sensor(indio_dev, pdata);
 	if (err < 0)
-		goto st_gyro_common_probe_error;
+		return err;
 
-	if (gdata->get_irq_data_ready(indio_dev) > 0) {
+	if (irq > 0) {
 		err = st_gyro_allocate_ring(indio_dev);
 		if (err < 0)
-			goto st_gyro_common_probe_error;
+			return err;
 
 		err = st_sensors_allocate_trigger(indio_dev,
 						  ST_GYRO_TRIGGER_OPS);
@@ -344,15 +345,15 @@ int st_gyro_common_probe(struct iio_dev *indio_dev,
 	if (err)
 		goto st_gyro_device_register_error;
 
-	return err;
+	return 0;
 
 st_gyro_device_register_error:
-	if (gdata->get_irq_data_ready(indio_dev) > 0)
+	if (irq > 0)
 		st_sensors_deallocate_trigger(indio_dev);
 st_gyro_probe_trigger_error:
-	if (gdata->get_irq_data_ready(indio_dev) > 0)
+	if (irq > 0)
 		st_gyro_deallocate_ring(indio_dev);
-st_gyro_common_probe_error:
+
 	return err;
 }
 EXPORT_SYMBOL(st_gyro_common_probe);
-- 
1.8.1.2

