Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753053Ab3IJM5C (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 08:57:02 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:35466 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752413Ab3IJMuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 08:50:07 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        jic23@cam.ac.uk
Cc: arnd@arndb.de, linus.walleij@linaro.org, denis.ciocca@st.com,
        linux-iio@vger.kernel.org, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 19/38] iio: sensors-core: st: Support sensors which don't have a Data Ready pin
Date: Tue, 10 Sep 2013 13:49:20 +0100
Message-Id: <1378817379-8238-20-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1378817379-8238-1-git-send-email-lee.jones@linaro.org>
References: <1378817379-8238-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not all ST's sensors support data ready, so let's make the declaration
of one conditional.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/iio/common/st_sensors/st_sensors_core.c | 24 +++++++++++++++++++-----
 drivers/iio/pressure/st_pressure_core.c         |  3 ++-
 2 files changed, 21 insertions(+), 6 deletions(-)

diff --git a/drivers/iio/common/st_sensors/st_sensors_core.c b/drivers/iio/common/st_sensors/st_sensors_core.c
index eb261a5..b86cad2 100644
--- a/drivers/iio/common/st_sensors/st_sensors_core.c
+++ b/drivers/iio/common/st_sensors/st_sensors_core.c
@@ -198,14 +198,11 @@ int st_sensors_set_axis_enable(struct iio_dev *indio_dev, u8 axis_enable)
 }
 EXPORT_SYMBOL(st_sensors_set_axis_enable);
 
-int st_sensors_init_sensor(struct iio_dev *indio_dev,
-					struct st_sensors_platform_data *pdata)
+int st_sensors_set_drdy_int_pin(struct iio_dev *indio_dev,
+				struct st_sensors_platform_data *pdata)
 {
-	int err;
 	struct st_sensor_data *sdata = iio_priv(indio_dev);
 
-	mutex_init(&sdata->tb.buf_lock);
-
 	switch (pdata->drdy_int_pin) {
 	case 1:
 		if (sdata->sensor->drdy_irq.mask_int1 == 0) {
@@ -231,6 +228,20 @@ int st_sensors_init_sensor(struct iio_dev *indio_dev,
 		goto init_error;
 	}
 
+	return 0;
+}
+
+int st_sensors_init_sensor(struct iio_dev *indio_dev,
+					struct st_sensors_platform_data *pdata)
+{
+	int err = 0;
+	struct st_sensor_data *sdata = iio_priv(indio_dev);
+
+	mutex_init(&sdata->tb.buf_lock);
+
+	if (pdata)
+		err = st_sensors_set_drdy_int_pin(indio_dev, pdata);
+
 	err = st_sensors_set_enable(indio_dev, false);
 	if (err < 0)
 		goto init_error;
@@ -266,6 +277,9 @@ int st_sensors_set_dataready_irq(struct iio_dev *indio_dev, bool enable)
 	u8 drdy_mask;
 	struct st_sensor_data *sdata = iio_priv(indio_dev);
 
+	if (!sdata->sensor->drdy_irq.addr)
+		return 0;
+
 	/* Enable/Disable the interrupt generator 1. */
 	if (sdata->sensor->drdy_irq.ig1.en_addr > 0) {
 		err = st_sensors_write_data_with_mask(indio_dev,
diff --git a/drivers/iio/pressure/st_pressure_core.c b/drivers/iio/pressure/st_pressure_core.c
index 16cfbc5..279aafd 100644
--- a/drivers/iio/pressure/st_pressure_core.c
+++ b/drivers/iio/pressure/st_pressure_core.c
@@ -232,7 +232,8 @@ int st_press_common_probe(struct iio_dev *indio_dev,
 
 	pdata->odr = pdata->sensor->odr.odr_avl[0].hz;
 
-	if (!plat_data)
+	/* Some devices don't support a data ready pin. */
+	if (!plat_data && pdata->sensor->drdy_irq.addr)
 		plat_data =
 			(struct st_sensors_platform_data *)&default_press_pdata;
 
-- 
1.8.1.2

