Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749Ab3IIKLs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 06:11:48 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:40024 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752490Ab3IIKKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 06:10:33 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        jic23@cam.ac.uk
Cc: arnd@arndb.de, linus.walleij@linaro.org, denis.ciocca@st.com,
        linux-iio@vger.kernel.org, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 11/14] iio: pressure-core: st: Provide support for the Vdd_IO power supply
Date: Mon,  9 Sep 2013 11:10:07 +0100
Message-Id: <1378721410-30937-12-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1378721410-30937-1-git-send-email-lee.jones@linaro.org>
References: <1378721410-30937-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The power to some of the sensors are controlled by regulators. In most
cases these are 'always on', but if not they will fail to work until
the regulator is enabled using the relevant APIs. This patch allows for
the Vdd_IO power supply to be specified by either platform data or
Device Tree.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/iio/pressure/st_pressure_core.c | 13 ++++++++++++-
 include/linux/iio/common/st_sensors.h   |  2 ++
 2 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/pressure/st_pressure_core.c b/drivers/iio/pressure/st_pressure_core.c
index f11cffc..330701c 100644
--- a/drivers/iio/pressure/st_pressure_core.c
+++ b/drivers/iio/pressure/st_pressure_core.c
@@ -319,7 +319,7 @@ void st_press_power_enable(struct iio_dev *indio_dev)
 	struct st_sensor_data *pdata = iio_priv(indio_dev);
 	int err;
 
-	/* Regulators not mandatory, but if requested we should enable it. */
+	/* Regulators not mandatory, but if requested we should enable them. */
 	pdata->vdd = devm_regulator_get_optional(&indio_dev->dev, "vdd");
 	if (!IS_ERR(pdata->vdd)) {
 		err = regulator_enable(pdata->vdd);
@@ -327,6 +327,14 @@ void st_press_power_enable(struct iio_dev *indio_dev)
 			dev_warn(&indio_dev->dev,
 				 "Failed to enable specified Vdd supply\n");
 	}
+
+	pdata->vdd_io = devm_regulator_get_optional(&indio_dev->dev, "vddio");
+	if (!IS_ERR(pdata->vdd_io)) {
+		err = regulator_enable(pdata->vdd_io);
+		if (err != 0)
+			dev_warn(&indio_dev->dev,
+				 "Failed to enable specified Vdd_IO supply\n");
+	}
 }
 
 void st_press_power_disable(struct iio_dev *indio_dev)
@@ -335,6 +343,9 @@ void st_press_power_disable(struct iio_dev *indio_dev)
 
 	if (!IS_ERR(pdata->vdd))
 		regulator_disable(pdata->vdd);
+
+	if (!IS_ERR(pdata->vdd_io))
+		regulator_disable(pdata->vdd_io);
 }
 
 int st_press_common_probe(struct iio_dev *indio_dev,
diff --git a/include/linux/iio/common/st_sensors.h b/include/linux/iio/common/st_sensors.h
index 968b84e..3c005eb 100644
--- a/include/linux/iio/common/st_sensors.h
+++ b/include/linux/iio/common/st_sensors.h
@@ -203,6 +203,7 @@ struct st_sensors {
  * @sensor: Pointer to the current sensor struct in use.
  * @current_fullscale: Maximum range of measure by the sensor.
  * @vdd: Pointer to sensor's Vdd power supply
+ * @vdd_io: Pointer to sensor's Vdd-IO power supply
  * @enabled: Status of the sensor (false->off, true->on).
  * @multiread_bit: Use or not particular bit for [I2C/SPI] multiread.
  * @buffer_data: Data used by buffer part.
@@ -219,6 +220,7 @@ struct st_sensor_data {
 	struct st_sensors *sensor;
 	struct st_sensor_fullscale_avl *current_fullscale;
 	struct regulator *vdd;
+	struct regulator *vdd_io;
 
 	bool enabled;
 	bool multiread_bit;
-- 
1.8.1.2

