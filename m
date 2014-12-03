Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752414AbaLCNgK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 08:36:10 -0500
Received: from mga09.intel.com ([134.134.136.24]:53712 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751194AbaLCNgH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 08:36:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,507,1413270000"; 
   d="scan'208";a="647549802"
From: Daniel Baluta <daniel.baluta@intel.com>
To: jic23@kernel.org, pmeerw@pmeerw.net, srinivas.pandruvada@linux.intel.com,
        knaack.h@gmx.de
Cc: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        daniel.baluta@intel.com
Subject: [PATCH v4 3/6] iio: imu: kmx61: Add PM runtime support
Date: Wed,  3 Dec 2014 15:31:50 +0200
Message-Id: <1417613513-28285-4-git-send-email-daniel.baluta@intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417613513-28285-1-git-send-email-daniel.baluta@intel.com>
References: <1417613513-28285-1-git-send-email-daniel.baluta@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By default both sensors are ACTIVE, in this way the driver
will work even if CONFIG_PM_RUNTIME is not selected.

Signed-off-by: Daniel Baluta <daniel.baluta@intel.com>
---
 drivers/iio/imu/kmx61.c | 114 +++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 112 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/imu/kmx61.c b/drivers/iio/imu/kmx61.c
index 893f7c8..7536043 100644
--- a/drivers/iio/imu/kmx61.c
+++ b/drivers/iio/imu/kmx61.c
@@ -15,6 +15,8 @@
 #include <linux/i2c.h>
 #include <linux/acpi.h>
 #include <linux/gpio/consumer.h>
+#include <linux/interrupt.h>
+#include <linux/pm_runtime.h>
 #include <linux/iio/iio.h>
 #include <linux/iio/sysfs.h>
 
@@ -69,6 +71,8 @@
 #define KMX61_ACC_ODR_MASK	0x0F
 #define KMX61_MAG_ODR_MASK	0xF0
 
+#define KMX61_SLEEP_DELAY_MS	2000
+
 #define KMX61_CHIP_ID		0x12
 
 /* KMX61 devices */
@@ -85,6 +89,10 @@ struct kmx61_data {
 	bool acc_stby;
 	bool mag_stby;
 
+	/* power state */
+	bool acc_ps;
+	bool mag_ps;
+
 	/* config bits */
 	u8 range;
 	u8 odr_bits;
@@ -457,6 +465,58 @@ static int kmx61_chip_init(struct kmx61_data *data)
 	return 0;
 }
 
+/**
+ * kmx61_set_power_state() - set power state for kmx61 @device
+ * @data - kmx61 device private pointer
+ * @on - power state to be set for @device
+ * @device - bitmask indicating device for which @on state needs to be set
+ *
+ * Notice that when ACC power state needs to be set to ON and MAG is in
+ * OPERATION then we know that kmx61_runtime_resume was already called
+ * so we must set ACC OPERATION mode here. The same happens when MAG power
+ * state needs to be set to ON and ACC is in OPERATION.
+ */
+static int kmx61_set_power_state(struct kmx61_data *data, bool on, u8 device)
+{
+#ifdef CONFIG_PM_RUNTIME
+	int ret;
+
+	if (device & KMX61_ACC) {
+		if (on && !data->acc_ps && !data->mag_stby) {
+			ret = kmx61_set_mode(data, 0, KMX61_ACC, true);
+			if (ret < 0)
+				return ret;
+		}
+		data->acc_ps = on;
+	}
+	if (device & KMX61_MAG) {
+		if (on && !data->mag_ps && !data->acc_stby) {
+			ret = kmx61_set_mode(data, 0, KMX61_MAG, true);
+			if (ret < 0)
+				return ret;
+		}
+		data->mag_ps = on;
+	}
+
+	if (on) {
+		ret = pm_runtime_get_sync(&data->client->dev);
+	} else {
+		pm_runtime_mark_last_busy(&data->client->dev);
+		ret = pm_runtime_put_autosuspend(&data->client->dev);
+	}
+	if (ret < 0) {
+		dev_err(&data->client->dev,
+			"Failed: kmx61_set_power_state for %d, ret %d\n",
+			on, ret);
+		if (on)
+			pm_runtime_put_noidle(&data->client->dev);
+
+		return ret;
+	}
+#endif
+	return 0;
+}
+
 static int kmx61_read_measurement(struct kmx61_data *data, u8 base, u8 offset)
 {
 	int ret;
@@ -491,13 +551,16 @@ static int kmx61_read_raw(struct iio_dev *indio_dev,
 		}
 		mutex_lock(&data->lock);
 
+		kmx61_set_power_state(data, true, chan->address);
 		ret = kmx61_read_measurement(data, base_reg, chan->scan_index);
 		if (ret < 0) {
+			kmx61_set_power_state(data, false, chan->address);
 			mutex_unlock(&data->lock);
 			return ret;
 		}
 		*val = sign_extend32(ret >> chan->scan_type.shift,
 				     chan->scan_type.realbits - 1);
+		kmx61_set_power_state(data, false, chan->address);
 
 		mutex_unlock(&data->lock);
 		return IIO_VAL_INT;
@@ -693,12 +756,22 @@ static int kmx61_probe(struct i2c_client *client,
 	ret = iio_device_register(data->mag_indio_dev);
 	if (ret < 0) {
 		dev_err(&client->dev, "Failed to register mag iio device\n");
-		goto err_iio_unregister;
+		goto err_iio_unregister_acc;
 	}
 
+	ret = pm_runtime_set_active(&client->dev);
+	if (ret < 0)
+		goto err_iio_unregister_mag;
+
+	pm_runtime_enable(&client->dev);
+	pm_runtime_set_autosuspend_delay(&client->dev, KMX61_SLEEP_DELAY_MS);
+	pm_runtime_use_autosuspend(&client->dev);
+
 	return 0;
 
-err_iio_unregister:
+err_iio_unregister_mag:
+	iio_device_unregister(data->mag_indio_dev);
+err_iio_unregister_acc:
 	iio_device_unregister(data->acc_indio_dev);
 err_chip_uninit:
 	kmx61_set_mode(data, KMX61_ALL_STBY, KMX61_ACC | KMX61_MAG, true);
@@ -709,6 +782,10 @@ static int kmx61_remove(struct i2c_client *client)
 {
 	struct kmx61_data *data = i2c_get_clientdata(client);
 
+	pm_runtime_disable(&client->dev);
+	pm_runtime_set_suspended(&client->dev);
+	pm_runtime_put_noidle(&client->dev);
+
 	iio_device_unregister(data->acc_indio_dev);
 	iio_device_unregister(data->mag_indio_dev);
 
@@ -719,6 +796,38 @@ static int kmx61_remove(struct i2c_client *client)
 	return 0;
 }
 
+
+#ifdef CONFIG_PM_RUNTIME
+static int kmx61_runtime_suspend(struct device *dev)
+{
+	struct kmx61_data *data = i2c_get_clientdata(to_i2c_client(dev));
+	int ret;
+
+	mutex_lock(&data->lock);
+	ret = kmx61_set_mode(data, KMX61_ALL_STBY, KMX61_ACC | KMX61_MAG, true);
+	mutex_unlock(&data->lock);
+
+	return ret;
+}
+
+static int kmx61_runtime_resume(struct device *dev)
+{
+	struct kmx61_data *data = i2c_get_clientdata(to_i2c_client(dev));
+	u8 stby = 0;
+
+	if (!data->acc_ps)
+		stby |= KMX61_ACC_STBY_BIT;
+	if (!data->mag_ps)
+		stby |= KMX61_MAG_STBY_BIT;
+
+	return kmx61_set_mode(data, stby, KMX61_ACC | KMX61_MAG, true);
+}
+#endif
+
+static const struct dev_pm_ops kmx61_pm_ops = {
+	SET_RUNTIME_PM_OPS(kmx61_runtime_suspend, kmx61_runtime_resume, NULL)
+};
+
 static const struct acpi_device_id kmx61_acpi_match[] = {
 	{"KMX61021", 0},
 	{}
@@ -737,6 +846,7 @@ static struct i2c_driver kmx61_driver = {
 	.driver = {
 		.name = KMX61_DRV_NAME,
 		.acpi_match_table = ACPI_PTR(kmx61_acpi_match),
+		.pm = &kmx61_pm_ops,
 	},
 	.probe		= kmx61_probe,
 	.remove		= kmx61_remove,
-- 
1.9.1

