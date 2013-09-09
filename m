Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752592Ab3IIKKh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 06:10:37 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:46489 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752465Ab3IIKKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 06:10:33 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        jic23@cam.ac.uk
Cc: arnd@arndb.de, linus.walleij@linaro.org, denis.ciocca@st.com,
        linux-iio@vger.kernel.org, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 10/14] iio: pressure-core: st: Provide support for the Vdd power supply
Date: Mon,  9 Sep 2013 11:10:06 +0100
Message-Id: <1378721410-30937-11-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1378721410-30937-1-git-send-email-lee.jones@linaro.org>
References: <1378721410-30937-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The power to some of the sensors are controlled by regulators. In most
cases these are 'always on', but if not they will fail to work until
the regulator is enabled using the relevant APIs. This patch allows for
the Vdd power supply to be specified by either platform data or Device
Tree.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/iio/pressure/st_pressure_core.c | 28 ++++++++++++++++++++++++++++
 include/linux/iio/common/st_sensors.h   |  3 +++
 2 files changed, 31 insertions(+)

diff --git a/drivers/iio/pressure/st_pressure_core.c b/drivers/iio/pressure/st_pressure_core.c
index c5fe03f..f11cffc 100644
--- a/drivers/iio/pressure/st_pressure_core.c
+++ b/drivers/iio/pressure/st_pressure_core.c
@@ -23,6 +23,7 @@
 #include <linux/iio/sysfs.h>
 #include <linux/iio/trigger.h>
 #include <linux/iio/buffer.h>
+#include <linux/regulator/consumer.h>
 #include <asm/unaligned.h>
 
 #include <linux/iio/common/st_sensors.h>
@@ -313,6 +314,29 @@ static const struct iio_trigger_ops st_press_trigger_ops = {
 #define ST_PRESS_TRIGGER_OPS NULL
 #endif
 
+void st_press_power_enable(struct iio_dev *indio_dev)
+{
+	struct st_sensor_data *pdata = iio_priv(indio_dev);
+	int err;
+
+	/* Regulators not mandatory, but if requested we should enable it. */
+	pdata->vdd = devm_regulator_get_optional(&indio_dev->dev, "vdd");
+	if (!IS_ERR(pdata->vdd)) {
+		err = regulator_enable(pdata->vdd);
+		if (err != 0)
+			dev_warn(&indio_dev->dev,
+				 "Failed to enable specified Vdd supply\n");
+	}
+}
+
+void st_press_power_disable(struct iio_dev *indio_dev)
+{
+	struct st_sensor_data *pdata = iio_priv(indio_dev);
+
+	if (!IS_ERR(pdata->vdd))
+		regulator_disable(pdata->vdd);
+}
+
 int st_press_common_probe(struct iio_dev *indio_dev,
 				struct st_sensors_platform_data *plat_data)
 {
@@ -323,6 +347,8 @@ int st_press_common_probe(struct iio_dev *indio_dev,
 	indio_dev->modes = INDIO_DIRECT_MODE;
 	indio_dev->info = &press_info;
 
+	st_press_power_enable(indio_dev);
+
 	err = st_sensors_check_device_support(indio_dev,
 					      ARRAY_SIZE(st_press_sensors),
 					      st_press_sensors);
@@ -378,6 +404,8 @@ void st_press_common_remove(struct iio_dev *indio_dev)
 {
 	struct st_sensor_data *pdata = iio_priv(indio_dev);
 
+	st_press_power_disable(indio_dev);
+
 	iio_device_unregister(indio_dev);
 	if (pdata->get_irq_data_ready(indio_dev) > 0) {
 		st_sensors_deallocate_trigger(indio_dev);
diff --git a/include/linux/iio/common/st_sensors.h b/include/linux/iio/common/st_sensors.h
index e732fda..968b84e 100644
--- a/include/linux/iio/common/st_sensors.h
+++ b/include/linux/iio/common/st_sensors.h
@@ -16,6 +16,7 @@
 #include <linux/irqreturn.h>
 #include <linux/iio/trigger.h>
 #include <linux/bitops.h>
+#include <linux/regulator/consumer.h>
 
 #include <linux/platform_data/st_sensors_pdata.h>
 
@@ -201,6 +202,7 @@ struct st_sensors {
  * @trig: The trigger in use by the core driver.
  * @sensor: Pointer to the current sensor struct in use.
  * @current_fullscale: Maximum range of measure by the sensor.
+ * @vdd: Pointer to sensor's Vdd power supply
  * @enabled: Status of the sensor (false->off, true->on).
  * @multiread_bit: Use or not particular bit for [I2C/SPI] multiread.
  * @buffer_data: Data used by buffer part.
@@ -216,6 +218,7 @@ struct st_sensor_data {
 	struct iio_trigger *trig;
 	struct st_sensors *sensor;
 	struct st_sensor_fullscale_avl *current_fullscale;
+	struct regulator *vdd;
 
 	bool enabled;
 	bool multiread_bit;
-- 
1.8.1.2

