Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753801Ab3F0MvC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 08:51:02 -0400
Received: from kdh-gw.itdev.co.uk ([89.21.227.133]:12379 "EHLO
	hermes.kdh.itdev.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753680Ab3F0Mu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 08:50:56 -0400
From: Nick Dyer <nick.dyer@itdev.co.uk>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Daniel Kurtz <djkurtz@chromium.org>, Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Alan Bowens <Alan.Bowens@atmel.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Meerwald <pmeerw@pmeerw.net>,
        Benson Leung <bleung@chromium.org>,
        Olof Johansson <olofj@chromium.org>, Nick Dyer <nick.dyer@itdev.co.uk>
Subject: [PATCH 50/51] Input: atmel_mxt_ts - Handle cfg filename via pdata/sysfs
Date: Thu, 27 Jun 2013 13:49:25 +0100
Message-Id: <1372337366-9286-51-git-send-email-nick.dyer@itdev.co.uk>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1372337366-9286-1-git-send-email-nick.dyer@itdev.co.uk>
References: <1372337366-9286-1-git-send-email-nick.dyer@itdev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There may be multiple maXTouch chips on a single device which will require
different configuration files. Add a platform data value for the configuration
filename.

Add sysfs entry to write configuration file if the platform data is not set.

Split out the object initialisation code from mxt_initialize() into
mxt_configure_objects() to allow this.

Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>
---
 drivers/input/touchscreen/atmel_mxt_ts.c |  104 ++++++++++++++++++++++++------
 include/linux/i2c/atmel_mxt_ts.h         |    1 +
 2 files changed, 86 insertions(+), 19 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index 9aa3a26..9a5ac2c 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -28,7 +28,6 @@
 #include <linux/gpio.h>
 
 /* Configuration file */
-#define MXT_CFG_NAME		"maxtouch.cfg"
 #define MXT_CFG_MAGIC		"OBP_RAW V1"
 
 /* Registers */
@@ -246,6 +245,7 @@ struct mxt_data {
 	struct regulator *reg_vdd;
 	struct regulator *reg_avdd;
 	char *fw_name;
+	char *cfg_name;
 
 	/* Cached parameters from object table */
 	u16 T5_address;
@@ -1372,10 +1372,15 @@ static int mxt_check_reg_init(struct mxt_data *data)
 	u8 val;
 	u16 reg;
 
-	ret = request_firmware(&cfg, MXT_CFG_NAME, dev);
+	if (!data->cfg_name) {
+		dev_dbg(dev, "Skipping cfg download\n");
+		return 0;
+	}
+
+	ret = request_firmware(&cfg, data->cfg_name, dev);
 	if (ret < 0) {
 		dev_err(dev, "Failure to request config file %s\n",
-			MXT_CFG_NAME);
+			data->cfg_name);
 		return 0;
 	}
 
@@ -1673,6 +1678,14 @@ static int mxt_acquire_irq(struct mxt_data *data)
 	return 0;
 }
 
+static void mxt_free_input_device(struct mxt_data *data)
+{
+	if (data->input_dev) {
+		input_unregister_device(data->input_dev);
+		data->input_dev = NULL;
+	}
+}
+
 static void mxt_free_object_table(struct mxt_data *data)
 {
 	kfree(data->raw_info_block);
@@ -1682,10 +1695,7 @@ static void mxt_free_object_table(struct mxt_data *data)
 	kfree(data->msg_buf);
 	data->msg_buf = NULL;
 
-	if (data->input_dev) {
-		input_unregister_device(data->input_dev);
-		data->input_dev = NULL;
-	}
+	mxt_free_input_device(data);
 
 	data->enable_reporting = false;
 	data->T5_address = 0;
@@ -2181,6 +2191,7 @@ err_free_mem:
 }
 
 static int mxt_initialize_t9_input_device(struct mxt_data *data);
+static int mxt_configure_objects(struct mxt_data *data);
 
 static int mxt_initialize(struct mxt_data *data)
 {
@@ -2224,16 +2235,28 @@ retry_bootloader:
 
 	error = mxt_check_retrigen(data);
 	if (error)
-		goto err_free_object_table;
+		return error;
 
 	error = mxt_acquire_irq(data);
 	if (error)
-		goto err_free_object_table;
+		return error;
+
+	error = mxt_configure_objects(data);
+	if (error)
+		return error;
+
+	return 0;
+}
+
+static int mxt_configure_objects(struct mxt_data *data)
+{
+	struct i2c_client *client = data->client;
+	int error;
 
 	error = mxt_init_t7_power_cfg(data);
 	if (error) {
 		dev_err(&client->dev, "Failed to initialize power cfg\n");
-		goto err_free_object_table;
+		return error;
 	}
 
 	/* Check register init values */
@@ -2241,28 +2264,23 @@ retry_bootloader:
 	if (error) {
 		dev_err(&client->dev, "Error %d initialising configuration\n",
 			error);
-		goto err_free_object_table;
+		return error;
 	}
 
 	if (data->T9_reportid_min) {
 		error = mxt_initialize_t9_input_device(data);
 		if (error)
-			goto err_free_object_table;
+			return error;
 	} else if (data->T100_reportid_min) {
 		error = mxt_initialize_t100_input_device(data);
 		if (error)
-			goto err_free_object_table;
+			return error;
 	} else {
 		dev_warn(&client->dev, "No touch object detected\n");
 	}
 
 	data->enable_reporting = true;
-
 	return 0;
-
-err_free_object_table:
-	mxt_free_object_table(data);
-	return error;
 }
 
 /* Firmware Version is returned as Major.Minor.Build */
@@ -2550,16 +2568,57 @@ static ssize_t mxt_update_fw_store(struct device *dev,
 	return count;
 }
 
+static ssize_t mxt_update_cfg_store(struct device *dev,
+		struct device_attribute *attr,
+		const char *buf, size_t count)
+{
+	struct mxt_data *data = dev_get_drvdata(dev);
+	int ret;
+
+	if (data->in_bootloader) {
+		dev_err(dev, "Not in appmode\n");
+		return -EINVAL;
+	}
+
+	ret = mxt_update_file_name(dev, &data->cfg_name, buf, count);
+	if (ret)
+		return ret;
+
+	data->enable_reporting = false;
+	mxt_free_input_device(data);
+
+	if (data->suspended) {
+		if (data->use_regulator)
+			mxt_regulator_enable(data);
+		else
+			mxt_set_t7_power_cfg(data, MXT_POWER_CFG_RUN);
+
+		mxt_acquire_irq(data);
+
+		data->suspended = false;
+	}
+
+	ret = mxt_configure_objects(data);
+	if (ret)
+		goto out;
+
+	ret = count;
+out:
+	return ret;
+}
+
 static DEVICE_ATTR(fw_version, S_IRUGO, mxt_fw_version_show, NULL);
 static DEVICE_ATTR(hw_version, S_IRUGO, mxt_hw_version_show, NULL);
 static DEVICE_ATTR(object, S_IRUGO, mxt_object_show, NULL);
 static DEVICE_ATTR(update_fw, S_IWUSR, NULL, mxt_update_fw_store);
+static DEVICE_ATTR(update_cfg, S_IWUSR, NULL, mxt_update_cfg_store);
 
 static struct attribute *mxt_attrs[] = {
 	&dev_attr_fw_version.attr,
 	&dev_attr_hw_version.attr,
 	&dev_attr_object.attr,
 	&dev_attr_update_fw.attr,
+	&dev_attr_update_cfg.attr,
 	NULL
 };
 
@@ -2644,8 +2703,15 @@ static int mxt_handle_pdata(struct mxt_data *data)
 	data->pdata = dev_get_platdata(&data->client->dev);
 
 	/* Use provided platform data if present */
-	if (data->pdata)
+	if (data->pdata) {
+		if (data->pdata->cfg_name)
+			mxt_update_file_name(&data->client->dev,
+					     &data->cfg_name,
+					     data->pdata->cfg_name,
+					     strlen(data->pdata->cfg_name));
+
 		return 0;
+	}
 
 	data->pdata = kzalloc(sizeof(*data->pdata), GFP_KERNEL);
 	if (!data->pdata) {
diff --git a/include/linux/i2c/atmel_mxt_ts.h b/include/linux/i2c/atmel_mxt_ts.h
index a01f2e8..3422bd0 100644
--- a/include/linux/i2c/atmel_mxt_ts.h
+++ b/include/linux/i2c/atmel_mxt_ts.h
@@ -23,6 +23,7 @@ struct mxt_platform_data {
 	int t15_num_keys;
 	const unsigned int *t15_keymap;
 	unsigned long gpio_reset;
+	const char *cfg_name;
 };
 
 #endif /* __LINUX_ATMEL_MXT_TS_H */
-- 
1.7.10.4

