Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756430Ab3AOSd2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 13:33:28 -0500
Received: from mail.savoirfairelinux.com ([209.172.62.77]:38524 "EHLO
	mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877Ab3AOSd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 13:33:26 -0500
From: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
To: lm-sensors@lm-sensors.org
Cc: Vivien Didelot <vivien.didelot@savoirfairelinux.com>,
        Guenter Roeck <linux@roeck-us.net>, Jean Delvare <khali@linux-fr.org>,
        linux-kernel@vger.kernel.org, kernel@savoirfairelinux.com
Subject: [PATCH v2] hwmon: (sht15) check GPIO directions
Date: Tue, 15 Jan 2013 13:33:06 -0500
Message-Id: <1358274786-30521-1-git-send-email-vivien.didelot@savoirfairelinux.com>
X-Mailer: git-send-email 1.8.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Without this patch, the SHT15 driver may fail silently with a
non-bidirectional data line and/or an input-only clock line.

This patch checks the return value of gpio_direction_* function calls
and returns the error code (if any) to the caller. If an error occurs in
the read work function (work_funct_t), we wake the queue up directly
without updating the data->state flag, to notice the waiter of the I/O
error.

The patch also makes minor cleanups: s/error_ret/unlock for some labels
and uses devm_gpio_request_one() for the clock line.

Signed-off-by: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
---
 drivers/hwmon/sht15.c | 135 ++++++++++++++++++++++++++++++++------------------
 1 file changed, 88 insertions(+), 47 deletions(-)

diff --git a/drivers/hwmon/sht15.c b/drivers/hwmon/sht15.c
index 9a594e6..bfe326e 100644
--- a/drivers/hwmon/sht15.c
+++ b/drivers/hwmon/sht15.c
@@ -212,11 +212,13 @@ static u8 sht15_crc8(struct sht15_data *data,
  *
  * This implements section 3.4 of the data sheet
  */
-static void sht15_connection_reset(struct sht15_data *data)
+static int sht15_connection_reset(struct sht15_data *data)
 {
-	int i;
+	int i, err;
 
-	gpio_direction_output(data->pdata->gpio_data, 1);
+	err = gpio_direction_output(data->pdata->gpio_data, 1);
+	if (err)
+		return err;
 	ndelay(SHT15_TSCKL);
 	gpio_set_value(data->pdata->gpio_sck, 0);
 	ndelay(SHT15_TSCKL);
@@ -226,6 +228,7 @@ static void sht15_connection_reset(struct sht15_data *data)
 		gpio_set_value(data->pdata->gpio_sck, 0);
 		ndelay(SHT15_TSCKL);
 	}
+	return 0;
 }
 
 /**
@@ -251,10 +254,14 @@ static inline void sht15_send_bit(struct sht15_data *data, int val)
  * conservative ones used in implementation. This implements
  * figure 12 on the data sheet.
  */
-static void sht15_transmission_start(struct sht15_data *data)
+static int sht15_transmission_start(struct sht15_data *data)
 {
+	int err;
+
 	/* ensure data is high and output */
-	gpio_direction_output(data->pdata->gpio_data, 1);
+	err = gpio_direction_output(data->pdata->gpio_data, 1);
+	if (err)
+		return err;
 	ndelay(SHT15_TSU);
 	gpio_set_value(data->pdata->gpio_sck, 0);
 	ndelay(SHT15_TSCKL);
@@ -270,6 +277,7 @@ static void sht15_transmission_start(struct sht15_data *data)
 	ndelay(SHT15_TSU);
 	gpio_set_value(data->pdata->gpio_sck, 0);
 	ndelay(SHT15_TSCKL);
+	return 0;
 }
 
 /**
@@ -293,13 +301,19 @@ static void sht15_send_byte(struct sht15_data *data, u8 byte)
  */
 static int sht15_wait_for_response(struct sht15_data *data)
 {
-	gpio_direction_input(data->pdata->gpio_data);
+	int err;
+
+	err = gpio_direction_input(data->pdata->gpio_data);
+	if (err)
+		return err;
 	gpio_set_value(data->pdata->gpio_sck, 1);
 	ndelay(SHT15_TSCKH);
 	if (gpio_get_value(data->pdata->gpio_data)) {
 		gpio_set_value(data->pdata->gpio_sck, 0);
 		dev_err(data->dev, "Command not acknowledged\n");
-		sht15_connection_reset(data);
+		err = sht15_connection_reset(data);
+		if (err)
+			return err;
 		return -EIO;
 	}
 	gpio_set_value(data->pdata->gpio_sck, 0);
@@ -317,12 +331,13 @@ static int sht15_wait_for_response(struct sht15_data *data)
  */
 static int sht15_send_cmd(struct sht15_data *data, u8 cmd)
 {
-	int ret = 0;
+	int err;
 
-	sht15_transmission_start(data);
+	err = sht15_transmission_start(data);
+	if (err)
+		return err;
 	sht15_send_byte(data, cmd);
-	ret = sht15_wait_for_response(data);
-	return ret;
+	return sht15_wait_for_response(data);
 }
 
 /**
@@ -352,9 +367,13 @@ static int sht15_soft_reset(struct sht15_data *data)
  * Each byte of data is acknowledged by pulling the data line
  * low for one clock pulse.
  */
-static void sht15_ack(struct sht15_data *data)
+static int sht15_ack(struct sht15_data *data)
 {
-	gpio_direction_output(data->pdata->gpio_data, 0);
+	int err;
+
+	err = gpio_direction_output(data->pdata->gpio_data, 0);
+	if (err)
+		return err;
 	ndelay(SHT15_TSU);
 	gpio_set_value(data->pdata->gpio_sck, 1);
 	ndelay(SHT15_TSU);
@@ -362,7 +381,7 @@ static void sht15_ack(struct sht15_data *data)
 	ndelay(SHT15_TSU);
 	gpio_set_value(data->pdata->gpio_data, 1);
 
-	gpio_direction_input(data->pdata->gpio_data);
+	return gpio_direction_input(data->pdata->gpio_data);
 }
 
 /**
@@ -371,14 +390,19 @@ static void sht15_ack(struct sht15_data *data)
  *
  * This is basically a NAK (single clock pulse, data high).
  */
-static void sht15_end_transmission(struct sht15_data *data)
+static int sht15_end_transmission(struct sht15_data *data)
 {
-	gpio_direction_output(data->pdata->gpio_data, 1);
+	int err;
+
+	err = gpio_direction_output(data->pdata->gpio_data, 1);
+	if (err)
+		return err;
 	ndelay(SHT15_TSU);
 	gpio_set_value(data->pdata->gpio_sck, 1);
 	ndelay(SHT15_TSCKH);
 	gpio_set_value(data->pdata->gpio_sck, 0);
 	ndelay(SHT15_TSCKL);
+	return 0;
 }
 
 /**
@@ -410,17 +434,19 @@ static u8 sht15_read_byte(struct sht15_data *data)
  */
 static int sht15_send_status(struct sht15_data *data, u8 status)
 {
-	int ret;
-
-	ret = sht15_send_cmd(data, SHT15_WRITE_STATUS);
-	if (ret)
-		return ret;
-	gpio_direction_output(data->pdata->gpio_data, 1);
+	int err;
+
+	err = sht15_send_cmd(data, SHT15_WRITE_STATUS);
+	if (err)
+		return err;
+	err = gpio_direction_output(data->pdata->gpio_data, 1);
+	if (err)
+		return err;
 	ndelay(SHT15_TSU);
 	sht15_send_byte(data, status);
-	ret = sht15_wait_for_response(data);
-	if (ret)
-		return ret;
+	err = sht15_wait_for_response(data);
+	if (err)
+		return err;
 
 	data->val_status = status;
 	return 0;
@@ -446,7 +472,7 @@ static int sht15_update_status(struct sht15_data *data)
 			|| !data->status_valid) {
 		ret = sht15_send_cmd(data, SHT15_READ_STATUS);
 		if (ret)
-			goto error_ret;
+			goto unlock;
 		status = sht15_read_byte(data);
 
 		if (data->checksumming) {
@@ -458,7 +484,9 @@ static int sht15_update_status(struct sht15_data *data)
 					== dev_checksum);
 		}
 
-		sht15_end_transmission(data);
+		ret = sht15_end_transmission(data);
+		if (ret)
+			goto unlock;
 
 		/*
 		 * Perform checksum validation on the received data.
@@ -469,27 +497,27 @@ static int sht15_update_status(struct sht15_data *data)
 			previous_config = data->val_status & 0x07;
 			ret = sht15_soft_reset(data);
 			if (ret)
-				goto error_ret;
+				goto unlock;
 			if (previous_config) {
 				ret = sht15_send_status(data, previous_config);
 				if (ret) {
 					dev_err(data->dev,
 						"CRC validation failed, unable "
 						"to restore device settings\n");
-					goto error_ret;
+					goto unlock;
 				}
 			}
 			ret = -EAGAIN;
-			goto error_ret;
+			goto unlock;
 		}
 
 		data->val_status = status;
 		data->status_valid = true;
 		data->last_status = jiffies;
 	}
-error_ret:
-	mutex_unlock(&data->read_lock);
 
+unlock:
+	mutex_unlock(&data->read_lock);
 	return ret;
 }
 
@@ -511,7 +539,9 @@ static int sht15_measurement(struct sht15_data *data,
 	if (ret)
 		return ret;
 
-	gpio_direction_input(data->pdata->gpio_data);
+	ret = gpio_direction_input(data->pdata->gpio_data);
+	if (ret)
+		return ret;
 	atomic_set(&data->interrupt_handled, 0);
 
 	enable_irq(gpio_to_irq(data->pdata->gpio_data));
@@ -524,9 +554,14 @@ static int sht15_measurement(struct sht15_data *data,
 	ret = wait_event_timeout(data->wait_queue,
 				 (data->state == SHT15_READING_NOTHING),
 				 msecs_to_jiffies(timeout_msecs));
-	if (ret == 0) {/* timeout occurred */
+	if (data->state != SHT15_READING_NOTHING) { /* I/O error occurred */
+		data->state = SHT15_READING_NOTHING;
+		return -EIO;
+	} else if (ret == 0) { /* timeout occurred */
 		disable_irq_nosync(gpio_to_irq(data->pdata->gpio_data));
-		sht15_connection_reset(data);
+		ret = sht15_connection_reset(data);
+		if (ret)
+			return ret;
 		return -ETIME;
 	}
 
@@ -570,17 +605,17 @@ static int sht15_update_measurements(struct sht15_data *data)
 		data->state = SHT15_READING_HUMID;
 		ret = sht15_measurement(data, SHT15_MEASURE_RH, 160);
 		if (ret)
-			goto error_ret;
+			goto unlock;
 		data->state = SHT15_READING_TEMP;
 		ret = sht15_measurement(data, SHT15_MEASURE_TEMP, 400);
 		if (ret)
-			goto error_ret;
+			goto unlock;
 		data->measurements_valid = true;
 		data->last_measurement = jiffies;
 	}
-error_ret:
-	mutex_unlock(&data->read_lock);
 
+unlock:
+	mutex_unlock(&data->read_lock);
 	return ret;
 }
 
@@ -818,7 +853,8 @@ static void sht15_bh_read_data(struct work_struct *work_s)
 	/* Read the data back from the device */
 	val = sht15_read_byte(data);
 	val <<= 8;
-	sht15_ack(data);
+	if (sht15_ack(data))
+		goto wakeup;
 	val |= sht15_read_byte(data);
 
 	if (data->checksumming) {
@@ -826,7 +862,8 @@ static void sht15_bh_read_data(struct work_struct *work_s)
 		 * Ask the device for a checksum and read it back.
 		 * Note: the device sends the checksum byte reversed.
 		 */
-		sht15_ack(data);
+		if (sht15_ack(data))
+			goto wakeup;
 		dev_checksum = sht15_reverse(sht15_read_byte(data));
 		checksum_vals[0] = (data->state == SHT15_READING_TEMP) ?
 			SHT15_MEASURE_TEMP : SHT15_MEASURE_RH;
@@ -837,7 +874,8 @@ static void sht15_bh_read_data(struct work_struct *work_s)
 	}
 
 	/* Tell the device we are done */
-	sht15_end_transmission(data);
+	if (sht15_end_transmission(data))
+		goto wakeup;
 
 	switch (data->state) {
 	case SHT15_READING_TEMP:
@@ -851,6 +889,7 @@ static void sht15_bh_read_data(struct work_struct *work_s)
 	}
 
 	data->state = SHT15_READING_NOTHING;
+wakeup:
 	wake_up(&data->wait_queue);
 }
 
@@ -942,17 +981,17 @@ static int sht15_probe(struct platform_device *pdev)
 	}
 
 	/* Try requesting the GPIOs */
-	ret = devm_gpio_request(&pdev->dev, data->pdata->gpio_sck, "SHT15 sck");
+	ret = devm_gpio_request_one(&pdev->dev, data->pdata->gpio_sck,
+			GPIOF_OUT_INIT_LOW, "SHT15 sck");
 	if (ret) {
-		dev_err(&pdev->dev, "gpio request failed\n");
+		dev_err(&pdev->dev, "clock line GPIO request failed\n");
 		goto err_release_reg;
 	}
-	gpio_direction_output(data->pdata->gpio_sck, 0);
 
 	ret = devm_gpio_request(&pdev->dev, data->pdata->gpio_data,
 				"SHT15 data");
 	if (ret) {
-		dev_err(&pdev->dev, "gpio request failed\n");
+		dev_err(&pdev->dev, "data line GPIO request failed\n");
 		goto err_release_reg;
 	}
 
@@ -966,7 +1005,9 @@ static int sht15_probe(struct platform_device *pdev)
 		goto err_release_reg;
 	}
 	disable_irq_nosync(gpio_to_irq(data->pdata->gpio_data));
-	sht15_connection_reset(data);
+	ret = sht15_connection_reset(data);
+	if (ret)
+		goto err_release_reg;
 	ret = sht15_soft_reset(data);
 	if (ret)
 		goto err_release_reg;
-- 
1.8.1.1

