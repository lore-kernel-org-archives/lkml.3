Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934669Ab3IDJcU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 05:32:20 -0400
Received: from mail-ea0-f182.google.com ([209.85.215.182]:37698 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934651Ab3IDJcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 05:32:11 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        jic23@cam.ac.uk
Cc: arnd@arndb.de, linus.walleij@linaro.org, denis.ciocca@st.com,
        linux-iio@vger.kernel.org, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 11/11] iio: pressure-core: st: Provide correct regulator support
Date: Wed,  4 Sep 2013 10:31:43 +0100
Message-Id: <1378287103-21765-12-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1378287103-21765-1-git-send-email-lee.jones@linaro.org>
References: <1378287103-21765-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The power to some of the sensors are controlled by regulators. In most
cases these are 'always on', but if not they will fail to work until
the regulator is enabled using the relevant APIs.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/iio/pressure/st_pressure_core.c | 13 +++++++++++++
 include/linux/iio/common/st_sensors.h   |  3 +++
 2 files changed, 16 insertions(+)

diff --git a/drivers/iio/pressure/st_pressure_core.c b/drivers/iio/pressure/st_pressure_core.c
index f452417..7beed89 100644
--- a/drivers/iio/pressure/st_pressure_core.c
+++ b/drivers/iio/pressure/st_pressure_core.c
@@ -23,6 +23,7 @@
 #include <linux/iio/sysfs.h>
 #include <linux/iio/trigger.h>
 #include <linux/iio/buffer.h>
+#include <linux/regulator/consumer.h>
 #include <asm/unaligned.h>
 
 #include <linux/iio/common/st_sensors.h>
@@ -315,6 +316,15 @@ int st_press_common_probe(struct iio_dev *indio_dev)
 	indio_dev->modes = INDIO_DIRECT_MODE;
 	indio_dev->info = &press_info;
 
+	/* Regulator not mandatory, but if requested we should enable it. */
+	pdata->regulator = regulator_get(&indio_dev->dev, "vdd");
+	if (!IS_ERR_OR_NULL(pdata->regulator)) {
+		err = regulator_enable(pdata->regulator);
+		if (err != 0)
+			dev_warn(&indio_dev->dev,
+				 "Failed to enable specified vdd regulator\n");
+	}
+
 	err = st_sensors_check_device_support(indio_dev,
 					      ARRAY_SIZE(st_press_sensors),
 					      st_press_sensors);
@@ -363,6 +373,9 @@ void st_press_common_remove(struct iio_dev *indio_dev)
 {
 	struct st_sensor_data *pdata = iio_priv(indio_dev);
 
+	if (!IS_ERR_OR_NULL(pdata->regulator))
+		regulator_disable(pdata->regulator);
+
 	iio_device_unregister(indio_dev);
 	if (pdata->get_irq_data_ready(indio_dev) > 0) {
 		st_sensors_deallocate_trigger(indio_dev);
diff --git a/include/linux/iio/common/st_sensors.h b/include/linux/iio/common/st_sensors.h
index 4aef925..eb6ef3f 100644
--- a/include/linux/iio/common/st_sensors.h
+++ b/include/linux/iio/common/st_sensors.h
@@ -16,6 +16,7 @@
 #include <linux/irqreturn.h>
 #include <linux/iio/trigger.h>
 #include <linux/bitops.h>
+#include <linux/regulator/consumer.h>
 
 #define ST_SENSORS_TX_MAX_LENGTH		2
 #define ST_SENSORS_RX_MAX_LENGTH		6
@@ -197,6 +198,7 @@ struct st_sensors {
  * @trig: The trigger in use by the core driver.
  * @sensor: Pointer to the current sensor struct in use.
  * @current_fullscale: Maximum range of measure by the sensor.
+ * @regulator: Pointer to sensor's power supply
  * @enabled: Status of the sensor (false->off, true->on).
  * @multiread_bit: Use or not particular bit for [I2C/SPI] multiread.
  * @buffer_data: Data used by buffer part.
@@ -211,6 +213,7 @@ struct st_sensor_data {
 	struct iio_trigger *trig;
 	struct st_sensors *sensor;
 	struct st_sensor_fullscale_avl *current_fullscale;
+	struct regulator *regulator;
 
 	bool enabled;
 	bool multiread_bit;
-- 
1.8.1.2

