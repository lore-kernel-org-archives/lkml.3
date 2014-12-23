Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932260AbaLWNV2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 08:21:28 -0500
Received: from mga14.intel.com ([192.55.52.115]:12998 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932209AbaLWNV0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 08:21:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,632,1413270000"; 
   d="scan'208";a="652169860"
From: Daniel Baluta <daniel.baluta@intel.com>
To: jic23@kernel.org, knaack.h@gmx.de
Cc: lars@metafoo.de, pmeerw@pmeerw.net, daniel.baluta@intel.com,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        srinivas.pandruvada@linux.intel.com
Subject: [PATCH 03/10] iio: imu: kmx61: Enhance error handling
Date: Tue, 23 Dec 2014 15:22:26 +0200
Message-Id: <1419340953-23161-4-git-send-email-daniel.baluta@intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1419340953-23161-1-git-send-email-daniel.baluta@intel.com>
References: <1419340953-23161-1-git-send-email-daniel.baluta@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes parts of kmx61 error handling to make code easier to read and to be
more consistent with IIO coding conventions:
	* prefer as single point for error handling instead of duplicating code
	for each function
	* directly return a value from a case branch instead of breaking
	* fix error message for writing REG_CTRL1

Also, add separate error paths for kmx61_trigger_setup/iio_triggered_buffer_setup
calls.

Signed-off-by: Daniel Baluta <daniel.baluta@intel.com>
---
 drivers/iio/imu/kmx61.c | 100 +++++++++++++++++++++---------------------------
 1 file changed, 43 insertions(+), 57 deletions(-)

diff --git a/drivers/iio/imu/kmx61.c b/drivers/iio/imu/kmx61.c
index e9cbd91..4fc4f63 100644
--- a/drivers/iio/imu/kmx61.c
+++ b/drivers/iio/imu/kmx61.c
@@ -656,11 +656,7 @@ static int kmx61_setup_new_data_interrupt(struct kmx61_data *data,
 		return ret;
 	}
 
-	ret = kmx61_set_mode(data, mode, KMX61_ACC | KMX61_MAG, true);
-	if (ret)
-		return ret;
-
-	return 0;
+	return kmx61_set_mode(data, mode, KMX61_ACC | KMX61_MAG, true);
 }
 
 static int kmx61_chip_update_thresholds(struct kmx61_data *data)
@@ -678,12 +674,10 @@ static int kmx61_chip_update_thresholds(struct kmx61_data *data)
 	ret = i2c_smbus_write_byte_data(data->client,
 					KMX61_REG_WUF_THRESH,
 					data->wake_thresh);
-	if (ret < 0) {
+	if (ret < 0)
 		dev_err(&data->client->dev, "Error writing reg_wuf_thresh\n");
-		return ret;
-	}
 
-	return 0;
+	return ret;
 }
 
 static int kmx61_setup_any_motion_interrupt(struct kmx61_data *data,
@@ -737,11 +731,7 @@ static int kmx61_setup_any_motion_interrupt(struct kmx61_data *data,
 		return ret;
 	}
 	mode |= KMX61_ACT_STBY_BIT;
-	ret = kmx61_set_mode(data, mode, KMX61_ACC | KMX61_MAG, true);
-	if (ret)
-		return ret;
-
-	return 0;
+	return kmx61_set_mode(data, mode, KMX61_ACC | KMX61_MAG, true);
 }
 
 /**
@@ -924,10 +914,10 @@ static int kmx61_read_event(struct iio_dev *indio_dev,
 	switch (info) {
 	case IIO_EV_INFO_VALUE:
 		*val = data->wake_thresh;
-		break;
+		return IIO_VAL_INT;
 	case IIO_EV_INFO_PERIOD:
 		*val = data->wake_duration;
-		break;
+		return IIO_VAL_INT;
 	default:
 		return -EINVAL;
 	}
@@ -950,10 +940,10 @@ static int kmx61_write_event(struct iio_dev *indio_dev,
 	switch (info) {
 	case IIO_EV_INFO_VALUE:
 		data->wake_thresh = val;
-		break;
+		return IIO_VAL_INT;
 	case IIO_EV_INFO_PERIOD:
 		data->wake_duration = val;
-		break;
+		return IIO_VAL_INT;
 	default:
 		return -EINVAL;
 	}
@@ -978,7 +968,7 @@ static int kmx61_write_event_config(struct iio_dev *indio_dev,
 				   int state)
 {
 	struct kmx61_data *data = kmx61_get_data(indio_dev);
-	int ret;
+	int ret = 0;
 
 	if (state && data->ev_enable_state)
 		return 0;
@@ -987,27 +977,25 @@ static int kmx61_write_event_config(struct iio_dev *indio_dev,
 
 	if (!state && data->motion_trig_on) {
 		data->ev_enable_state = 0;
-		mutex_unlock(&data->lock);
-		return 0;
+		goto err_unlock;
 	}
 
 	ret = kmx61_set_power_state(data, state, KMX61_ACC);
-	if (ret < 0) {
-		mutex_unlock(&data->lock);
-		return ret;
-	}
+	if (ret < 0)
+		goto err_unlock;
 
 	ret = kmx61_setup_any_motion_interrupt(data, state, KMX61_ACC);
 	if (ret < 0) {
 		kmx61_set_power_state(data, false, KMX61_ACC);
-		mutex_unlock(&data->lock);
-		return ret;
+		goto err_unlock;
 	}
 
 	data->ev_enable_state = state;
+
+err_unlock:
 	mutex_unlock(&data->lock);
 
-	return 0;
+	return ret;
 }
 
 static int kmx61_acc_validate_trigger(struct iio_dev *indio_dev,
@@ -1066,8 +1054,7 @@ static int kmx61_data_rdy_trigger_set_state(struct iio_trigger *trig,
 
 	if (!state && data->ev_enable_state && data->motion_trig_on) {
 		data->motion_trig_on = false;
-		mutex_unlock(&data->lock);
-		return 0;
+		goto err_unlock;
 	}
 
 
@@ -1077,10 +1064,8 @@ static int kmx61_data_rdy_trigger_set_state(struct iio_trigger *trig,
 		device = KMX61_MAG;
 
 	ret = kmx61_set_power_state(data, state, device);
-	if (ret < 0) {
-		mutex_unlock(&data->lock);
-		return ret;
-	}
+	if (ret < 0)
+		goto err_unlock;
 
 	if (data->acc_dready_trig == trig || data->mag_dready_trig == trig)
 		ret = kmx61_setup_new_data_interrupt(data, state, device);
@@ -1088,8 +1073,7 @@ static int kmx61_data_rdy_trigger_set_state(struct iio_trigger *trig,
 		ret = kmx61_setup_any_motion_interrupt(data, state, KMX61_ACC);
 	if (ret < 0) {
 		kmx61_set_power_state(data, false, device);
-		mutex_unlock(&data->lock);
-		return ret;
+		goto err_unlock;
 	}
 
 	if (data->acc_dready_trig == trig)
@@ -1098,10 +1082,10 @@ static int kmx61_data_rdy_trigger_set_state(struct iio_trigger *trig,
 		data->mag_dready_trig_on = state;
 	else
 		data->motion_trig_on = state;
-
+err_unlock:
 	mutex_unlock(&data->lock);
 
-	return 0;
+	return ret;
 }
 
 static int kmx61_trig_try_reenable(struct iio_trigger *trig)
@@ -1207,7 +1191,7 @@ ack_intr:
 	ret |= KMX61_REG_CTRL1_BIT_RES;
 	ret = i2c_smbus_write_byte_data(data->client, KMX61_REG_CTRL1, ret);
 	if (ret < 0)
-		dev_err(&data->client->dev, "Error reading reg_ctrl1\n");
+		dev_err(&data->client->dev, "Error writing reg_ctrl1\n");
 
 	ret = i2c_smbus_read_byte_data(data->client, KMX61_REG_INL);
 	if (ret < 0)
@@ -1409,15 +1393,17 @@ static int kmx61_probe(struct i2c_client *client,
 		data->acc_dready_trig =
 			kmx61_trigger_setup(data, data->acc_indio_dev,
 					    "dready");
-		if (IS_ERR(data->acc_dready_trig))
-			return PTR_ERR(data->acc_dready_trig);
+		if (IS_ERR(data->acc_dready_trig)) {
+			ret =  PTR_ERR(data->acc_dready_trig);
+			goto err_chip_uninit;
+		}
 
 		data->mag_dready_trig =
 			kmx61_trigger_setup(data, data->mag_indio_dev,
 					    "dready");
 		if (IS_ERR(data->mag_dready_trig)) {
 			ret = PTR_ERR(data->mag_dready_trig);
-			goto err_trigger_unregister;
+			goto err_trigger_unregister_acc_dready;
 		}
 
 		data->motion_trig =
@@ -1425,7 +1411,7 @@ static int kmx61_probe(struct i2c_client *client,
 					    "any-motion");
 		if (IS_ERR(data->motion_trig)) {
 			ret = PTR_ERR(data->motion_trig);
-			goto err_trigger_unregister;
+			goto err_trigger_unregister_mag_dready;
 		}
 
 		ret = iio_triggered_buffer_setup(data->acc_indio_dev,
@@ -1435,7 +1421,7 @@ static int kmx61_probe(struct i2c_client *client,
 		if (ret < 0) {
 			dev_err(&data->client->dev,
 				"Failed to setup acc triggered buffer\n");
-			goto err_trigger_unregister;
+			goto err_trigger_unregister_motion;
 		}
 
 		ret = iio_triggered_buffer_setup(data->mag_indio_dev,
@@ -1445,14 +1431,14 @@ static int kmx61_probe(struct i2c_client *client,
 		if (ret < 0) {
 			dev_err(&data->client->dev,
 				"Failed to setup mag triggered buffer\n");
-			goto err_trigger_unregister;
+			goto err_buffer_cleanup_acc;
 		}
 	}
 
 	ret = iio_device_register(data->acc_indio_dev);
 	if (ret < 0) {
 		dev_err(&client->dev, "Failed to register acc iio device\n");
-		goto err_buffer_cleanup;
+		goto err_buffer_cleanup_mag;
 	}
 
 	ret = iio_device_register(data->mag_indio_dev);
@@ -1475,18 +1461,18 @@ err_iio_unregister_mag:
 	iio_device_unregister(data->mag_indio_dev);
 err_iio_unregister_acc:
 	iio_device_unregister(data->acc_indio_dev);
-err_buffer_cleanup:
-	if (client->irq >= 0) {
-		iio_triggered_buffer_cleanup(data->acc_indio_dev);
+err_buffer_cleanup_mag:
+	if (client->irq >= 0)
 		iio_triggered_buffer_cleanup(data->mag_indio_dev);
-	}
-err_trigger_unregister:
-	if (data->acc_dready_trig)
-		iio_trigger_unregister(data->acc_dready_trig);
-	if (data->mag_dready_trig)
-		iio_trigger_unregister(data->mag_dready_trig);
-	if (data->motion_trig)
-		iio_trigger_unregister(data->motion_trig);
+err_buffer_cleanup_acc:
+	if (client->irq >= 0)
+		iio_triggered_buffer_cleanup(data->acc_indio_dev);
+err_trigger_unregister_motion:
+	iio_trigger_unregister(data->motion_trig);
+err_trigger_unregister_mag_dready:
+	iio_trigger_unregister(data->mag_dready_trig);
+err_trigger_unregister_acc_dready:
+	iio_trigger_unregister(data->acc_dready_trig);
 err_chip_uninit:
 	kmx61_set_mode(data, KMX61_ALL_STBY, KMX61_ACC | KMX61_MAG, true);
 	return ret;
-- 
1.9.1

