Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751986Ab3IPQE3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 12:04:29 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:37902 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676Ab3IPQC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 12:02:57 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        jic23@cam.ac.uk
Cc: arnd@arndb.de, linus.walleij@linaro.org, denis.ciocca@st.com,
        linux-iio@vger.kernel.org, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 18/20] iio: accel-core: st: Clean up error handling in probe()
Date: Mon, 16 Sep 2013 17:02:24 +0100
Message-Id: <1379347346-823-19-git-send-email-lee.jones@linaro.org>
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
 drivers/iio/accel/st_accel_core.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/iio/accel/st_accel_core.c b/drivers/iio/accel/st_accel_core.c
index 1458343..97172dd 100644
--- a/drivers/iio/accel/st_accel_core.c
+++ b/drivers/iio/accel/st_accel_core.c
@@ -452,8 +452,9 @@ static const struct iio_trigger_ops st_accel_trigger_ops = {
 int st_accel_common_probe(struct iio_dev *indio_dev,
 				struct st_sensors_platform_data *plat_data)
 {
-	int err;
 	struct st_sensor_data *adata = iio_priv(indio_dev);
+	int irq = adata->get_irq_data_ready(indio_dev);
+	int err;
 
 	indio_dev->modes = INDIO_DIRECT_MODE;
 	indio_dev->info = &accel_info;
@@ -461,7 +462,7 @@ int st_accel_common_probe(struct iio_dev *indio_dev,
 	err = st_sensors_check_device_support(indio_dev,
 				ARRAY_SIZE(st_accel_sensors), st_accel_sensors);
 	if (err < 0)
-		goto st_accel_common_probe_error;
+		return err;
 
 	adata->num_data_channels = ST_ACCEL_NUMBER_DATA_CHANNELS;
 	adata->multiread_bit = adata->sensor->multi_read_bit;
@@ -478,12 +479,12 @@ int st_accel_common_probe(struct iio_dev *indio_dev,
 
 	err = st_sensors_init_sensor(indio_dev, plat_data);
 	if (err < 0)
-		goto st_accel_common_probe_error;
+		return err;
 
-	if (adata->get_irq_data_ready(indio_dev) > 0) {
+	if (irq > 0) {
 		err = st_accel_allocate_ring(indio_dev);
 		if (err < 0)
-			goto st_accel_common_probe_error;
+			return err;
 
 		err = st_sensors_allocate_trigger(indio_dev,
 						 ST_ACCEL_TRIGGER_OPS);
@@ -495,15 +496,15 @@ int st_accel_common_probe(struct iio_dev *indio_dev,
 	if (err)
 		goto st_accel_device_register_error;
 
-	return err;
+	return 0;
 
 st_accel_device_register_error:
-	if (adata->get_irq_data_ready(indio_dev) > 0)
+	if (irq > 0)
 		st_sensors_deallocate_trigger(indio_dev);
 st_accel_probe_trigger_error:
-	if (adata->get_irq_data_ready(indio_dev) > 0)
+	if (irq > 0)
 		st_accel_deallocate_ring(indio_dev);
-st_accel_common_probe_error:
+
 	return err;
 }
 EXPORT_SYMBOL(st_accel_common_probe);
-- 
1.8.1.2

