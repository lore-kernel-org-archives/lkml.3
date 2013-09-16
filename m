Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751735Ab3IPQDF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 12:03:05 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:56824 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647Ab3IPQCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 12:02:51 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        jic23@cam.ac.uk
Cc: arnd@arndb.de, linus.walleij@linaro.org, denis.ciocca@st.com,
        linux-iio@vger.kernel.org, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 14/20] iio: pressure-core: st: Clean-up probe() function
Date: Mon, 16 Sep 2013 17:02:20 +0100
Message-Id: <1379347346-823-15-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1379347346-823-1-git-send-email-lee.jones@linaro.org>
References: <1379347346-823-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch contains some pretty basic clean-ups in probe() pertaining to
the simplification of error handling and a couple of readability adaptions.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/iio/pressure/st_pressure_core.c | 28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

diff --git a/drivers/iio/pressure/st_pressure_core.c b/drivers/iio/pressure/st_pressure_core.c
index 3abada2..4539953 100644
--- a/drivers/iio/pressure/st_pressure_core.c
+++ b/drivers/iio/pressure/st_pressure_core.c
@@ -232,21 +232,23 @@ static const struct iio_trigger_ops st_press_trigger_ops = {
 int st_press_common_probe(struct iio_dev *indio_dev,
 				struct st_sensors_platform_data *plat_data)
 {
-	int err;
 	struct st_sensor_data *pdata = iio_priv(indio_dev);
+	int irq = pdata->get_irq_data_ready(indio_dev);
+	int err;
 
 	indio_dev->modes = INDIO_DIRECT_MODE;
 	indio_dev->info = &press_info;
 
 	err = st_sensors_check_device_support(indio_dev,
-				ARRAY_SIZE(st_press_sensors), st_press_sensors);
+					      ARRAY_SIZE(st_press_sensors),
+					      st_press_sensors);
 	if (err < 0)
-		goto st_press_common_probe_error;
+		return err;
 
 	pdata->num_data_channels = ST_PRESS_NUMBER_DATA_CHANNELS;
-	pdata->multiread_bit = pdata->sensor->multi_read_bit;
-	indio_dev->channels = pdata->sensor->ch;
-	indio_dev->num_channels = pdata->sensor->num_ch;
+	pdata->multiread_bit     = pdata->sensor->multi_read_bit;
+	indio_dev->channels      = pdata->sensor->ch;
+	indio_dev->num_channels  = pdata->sensor->num_ch;
 
 	if (pdata->sensor->fs.addr != 0)
 		pdata->current_fullscale = (struct st_sensor_fullscale_avl *)
@@ -261,15 +263,15 @@ int st_press_common_probe(struct iio_dev *indio_dev,
 
 	err = st_sensors_init_sensor(indio_dev, plat_data);
 	if (err < 0)
-		goto st_press_common_probe_error;
+		return err;
 
-	if (pdata->get_irq_data_ready(indio_dev) > 0) {
+	if (irq > 0) {
 		err = st_press_allocate_ring(indio_dev);
 		if (err < 0)
-			goto st_press_common_probe_error;
+			return err;
 
 		err = st_sensors_allocate_trigger(indio_dev,
-							ST_PRESS_TRIGGER_OPS);
+						  ST_PRESS_TRIGGER_OPS);
 		if (err < 0)
 			goto st_press_probe_trigger_error;
 	}
@@ -281,12 +283,12 @@ int st_press_common_probe(struct iio_dev *indio_dev,
 	return err;
 
 st_press_device_register_error:
-	if (pdata->get_irq_data_ready(indio_dev) > 0)
+	if (irq > 0)
 		st_sensors_deallocate_trigger(indio_dev);
 st_press_probe_trigger_error:
-	if (pdata->get_irq_data_ready(indio_dev) > 0)
+	if (irq > 0)
 		st_press_deallocate_ring(indio_dev);
-st_press_common_probe_error:
+
 	return err;
 }
 EXPORT_SYMBOL(st_press_common_probe);
-- 
1.8.1.2

