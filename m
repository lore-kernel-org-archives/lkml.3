Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753121Ab3IJMvS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 08:51:18 -0400
Received: from mail-ea0-f173.google.com ([209.85.215.173]:54381 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751654Ab3IJMuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 08:50:23 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        jic23@cam.ac.uk
Cc: arnd@arndb.de, linus.walleij@linaro.org, denis.ciocca@st.com,
        linux-iio@vger.kernel.org, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 36/38] iio: magn-core: st: Clean up error handling in probe()
Date: Tue, 10 Sep 2013 13:49:37 +0100
Message-Id: <1378817379-8238-37-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1378817379-8238-1-git-send-email-lee.jones@linaro.org>
References: <1378817379-8238-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reduce the amount of those unnecessary goto calls, as in most cases
we can simply return immediately. We also only call for the IRQ number
once and use that value throughout.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/iio/magnetometer/st_magn_core.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/iio/magnetometer/st_magn_core.c b/drivers/iio/magnetometer/st_magn_core.c
index e8d2849..c252659 100644
--- a/drivers/iio/magnetometer/st_magn_core.c
+++ b/drivers/iio/magnetometer/st_magn_core.c
@@ -348,8 +348,9 @@ static const struct iio_info magn_info = {
 int st_magn_common_probe(struct iio_dev *indio_dev,
 					struct st_sensors_platform_data *pdata)
 {
-	int err;
 	struct st_sensor_data *mdata = iio_priv(indio_dev);
+	int irq = mdata->get_irq_data_ready(indio_dev);
+	int err;
 
 	indio_dev->modes = INDIO_DIRECT_MODE;
 	indio_dev->info = &magn_info;
@@ -357,7 +358,7 @@ int st_magn_common_probe(struct iio_dev *indio_dev,
 	err = st_sensors_check_device_support(indio_dev,
 				ARRAY_SIZE(st_magn_sensors), st_magn_sensors);
 	if (err < 0)
-		goto st_magn_common_probe_error;
+		return err;
 
 	mdata->num_data_channels = ST_MAGN_NUMBER_DATA_CHANNELS;
 	mdata->multiread_bit = mdata->sensor->multi_read_bit;
@@ -370,30 +371,28 @@ int st_magn_common_probe(struct iio_dev *indio_dev,
 
 	err = st_sensors_init_sensor(indio_dev, pdata);
 	if (err < 0)
-		goto st_magn_common_probe_error;
+		return err;
 
-	if (mdata->get_irq_data_ready(indio_dev) > 0) {
+	if (irq > 0) {
 		err = st_magn_allocate_ring(indio_dev);
 		if (err < 0)
-			goto st_magn_common_probe_error;
+			return err;
 		err = st_sensors_allocate_trigger(indio_dev, NULL);
 		if (err < 0)
 			goto st_magn_probe_trigger_error;
 	}
 
 	err = iio_device_register(indio_dev);
-	if (err)
+	if (err && irq > 0)
 		goto st_magn_device_register_error;
 
 	return err;
 
 st_magn_device_register_error:
-	if (mdata->get_irq_data_ready(indio_dev) > 0)
-		st_sensors_deallocate_trigger(indio_dev);
+	st_sensors_deallocate_trigger(indio_dev);
 st_magn_probe_trigger_error:
-	if (mdata->get_irq_data_ready(indio_dev) > 0)
-		st_magn_deallocate_ring(indio_dev);
-st_magn_common_probe_error:
+	st_magn_deallocate_ring(indio_dev);
+
 	return err;
 }
 EXPORT_SYMBOL(st_magn_common_probe);
-- 
1.8.1.2

