Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752850Ab3IIKM6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 06:12:58 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:47993 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598Ab3IIKKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 06:10:31 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        jic23@cam.ac.uk
Cc: arnd@arndb.de, linus.walleij@linaro.org, denis.ciocca@st.com,
        linux-iio@vger.kernel.org, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 08/14] iio: pressure-core: st: Clean-up probe() function
Date: Mon,  9 Sep 2013 11:10:04 +0100
Message-Id: <1378721410-30937-9-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1378721410-30937-1-git-send-email-lee.jones@linaro.org>
References: <1378721410-30937-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch contains some pretty basic clean-ups in probe() pertaining to
the simplification of error handling and a couple of readability adaptions.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/iio/pressure/st_pressure_core.c | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/iio/pressure/st_pressure_core.c b/drivers/iio/pressure/st_pressure_core.c
index 93bff9b..d918e76 100644
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
@@ -260,32 +262,30 @@ int st_press_common_probe(struct iio_dev *indio_dev,
 
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
 
 	err = iio_device_register(indio_dev);
-	if (err)
+	if (err && irq > 0)
 		goto st_press_device_register_error;
 
 	return err;
 
 st_press_device_register_error:
-	if (pdata->get_irq_data_ready(indio_dev) > 0)
-		st_sensors_deallocate_trigger(indio_dev);
+	st_sensors_deallocate_trigger(indio_dev);
 st_press_probe_trigger_error:
-	if (pdata->get_irq_data_ready(indio_dev) > 0)
-		st_press_deallocate_ring(indio_dev);
-st_press_common_probe_error:
+	st_press_deallocate_ring(indio_dev);
+
 	return err;
 }
 EXPORT_SYMBOL(st_press_common_probe);
-- 
1.8.1.2

