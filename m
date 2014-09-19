Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756347AbaISBqn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 21:46:43 -0400
Received: from bay004-omc1s10.hotmail.com ([65.54.190.21]:52185 "EHLO
	BAY004-OMC1S10.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756068AbaISBqk convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 21:46:40 -0400
X-TMN: [rKngYdIr62vI0J6nskNblJbzX1fw+IaR]
X-Originating-Email: [dudlx@outlook.com]
Message-ID: <BAY176-DS1265F014F9F8A1C1FAF53BDB40@phx.gbl>
From: Dudley Du <dudlx@outlook.com>
To: <dmitry.torokhov@gmail.com>, <rydberg@euromail.se>
CC: <bleung@google.com>, <patrikf@google.com>, <linux-input@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v7 04/13] input: cyapa: add cyapa key function interfaces in sysfs system
Date: Fri, 19 Sep 2014 09:46:39 +0800
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: Ac/Tq45SBWN8nwojTSiIgOsW4bejlw==
Content-Language: zh-cn
X-OriginalArrivalTime: 19 Sep 2014 01:46:40.0419 (UTC) FILETIME=[8EB5EF30:01CFD3AB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 6e5124fcaaa449e3731e58a85e1d45f46df65166 Mon Sep 17 00:00:00 2001
From: Dudley Du <dudl@cypress.com>
Date: Thu, 18 Sep 2014 18:11:37 +0800
Subject: [PATCH 04/13] input: cyapa: add cyapa key function interfaces in
 sysfs system
To: dmitry.torokhov@gmail.com,
    rydberg@euromail.se
Cc: bleung@google.com,
    patrikf@google.com,
    linux-input@vger.kernel.org,
    linux-kernel@vger.kernel.org

Add key basic function interfaces in cyapa driver in sysfs system,
these interfaces are commonly used in pre- and after production, and
for trackpad device state checking, manage and firmware image updating.
These interfaces including firmware_version and product_id interfaces
for reading firmware version and trackpad device product id values,
and including update_fw interface to command firmware image update
process. Also including baseline and calibrate interfaces, so can
read and check the trackpad device states. If the baseline values are
invalid, then can use calibrate interface to recover it.
TEST=test on Chromebooks.

Signed-off-by: Dudley Du <dudl@cypress.com>
---
 drivers/input/mouse/cyapa.c | 192 ++++++++++++++++++++++++++++++++++++++++++++
 drivers/input/mouse/cyapa.h |  27 +++++++
 2 files changed, 219 insertions(+)

diff --git a/drivers/input/mouse/cyapa.c b/drivers/input/mouse/cyapa.c
index ea8c661..dd78e89 100644
--- a/drivers/input/mouse/cyapa.c
+++ b/drivers/input/mouse/cyapa.c
@@ -397,6 +397,78 @@ static void cyapa_detect(struct cyapa *cyapa)
 	}
 }
 
+static int cyapa_firmware(struct cyapa *cyapa, const char *fw_name)
+{
+	struct device *dev = &cyapa->client->dev;
+	int ret;
+	const struct firmware *fw;
+
+	ret = request_firmware(&fw, fw_name, dev);
+	if (ret) {
+		dev_err(dev, "Could not load firmware from %s, %d\n",
+			fw_name, ret);
+		return ret;
+	}
+
+	if (cyapa->ops->check_fw) {
+		ret = cyapa->ops->check_fw(cyapa, fw);
+		if (ret) {
+			dev_err(dev, "Invalid CYAPA firmware image: %s\n",
+					fw_name);
+			goto done;
+		}
+	} else {
+		dev_err(dev, "Unknown status, operation forbidden, gen=%d\n",
+			cyapa->gen);
+		ret = -EINVAL;
+		goto done;
+	}
+
+	/*
+	 * Resume the potentially suspended device because doing FW
+	 * update on a device not in the FULL mode has a chance to
+	 * fail.
+	 */
+	pm_runtime_get_sync(dev);
+
+	if (cyapa->ops->bl_enter) {
+		ret = cyapa->ops->bl_enter(cyapa);
+		if (ret)
+			goto err_detect;
+	}
+
+	if (cyapa->ops->bl_activate) {
+		ret = cyapa->ops->bl_activate(cyapa);
+		if (ret)
+			goto err_detect;
+	}
+
+	if (cyapa->ops->bl_initiate) {
+		ret = cyapa->ops->bl_initiate(cyapa, fw);
+		if (ret)
+			goto err_detect;
+	}
+
+	if (cyapa->ops->update_fw) {
+		ret = cyapa->ops->update_fw(cyapa, fw);
+		if (ret)
+			goto err_detect;
+	}
+
+	if (cyapa->ops->bl_verify_app_integrity) {
+		ret = cyapa->ops->bl_verify_app_integrity(cyapa);
+		if (ret)
+			goto err_detect;
+	}
+
+err_detect:
+	pm_runtime_put_noidle(dev);
+
+done:
+	release_firmware(fw);
+	return ret;
+}
+
 /*
  * Sysfs Interface.
  */
@@ -598,6 +670,122 @@ static void cyapa_start_runtime(struct cyapa *cyapa)
 static void cyapa_start_runtime(struct cyapa *cyapa) {}
 #endif /* CONFIG_PM_RUNTIME */
 
+static ssize_t cyapa_show_fm_ver(struct device *dev,
+				 struct device_attribute *attr, char *buf)
+{
+	int ret;
+	struct cyapa *cyapa = dev_get_drvdata(dev);
+
+	mutex_lock(&cyapa->state_sync_lock);
+	ret = scnprintf(buf, PAGE_SIZE, "%d.%d\n", cyapa->fw_maj_ver,
+			 cyapa->fw_min_ver);
+	mutex_unlock(&cyapa->state_sync_lock);
+	return ret;
+}
+
+static ssize_t cyapa_show_product_id(struct device *dev,
+				     struct device_attribute *attr, char *buf)
+{
+	int ret;
+	struct cyapa *cyapa = dev_get_drvdata(dev);
+
+	mutex_lock(&cyapa->state_sync_lock);
+	ret = scnprintf(buf, PAGE_SIZE, "%s\n", cyapa->product_id);
+	mutex_unlock(&cyapa->state_sync_lock);
+	return ret;
+}
+
+static ssize_t cyapa_update_fw_store(struct device *dev,
+				     struct device_attribute *attr,
+				     const char *buf, size_t count)
+{
+	struct cyapa *cyapa = dev_get_drvdata(dev);
+	char fw_name[64];
+	int ret;
+
+	if (count > 64) {
+		dev_err(dev, "File name too long\n");
+		return -EINVAL;
+	}
+
+	memcpy(fw_name, buf, count);
+	if (fw_name[count - 1] == '\n')
+		fw_name[count - 1] = '\0';
+	else
+		fw_name[count] = '\0';
+
+	mutex_lock(&cyapa->state_sync_lock);
+
+	ret = cyapa_firmware(cyapa, fw_name);
+	if (ret)
+		dev_err(dev, "firmware update failed, %d\n", ret);
+	else
+		dev_dbg(dev, "firmware update succeeded\n");
+
+	mutex_unlock(&cyapa->state_sync_lock);
+
+	/* Redetect trackpad device states. */
+	cyapa_detect_async(cyapa, 0);
+
+	return ret ? ret : count;
+}
+
+static ssize_t cyapa_calibrate_store(struct device *dev,
+				     struct device_attribute *attr,
+				     const char *buf, size_t count)
+{
+	struct cyapa *cyapa = dev_get_drvdata(dev);
+	int ret;
+
+	mutex_lock(&cyapa->state_sync_lock);
+
+	if (!cyapa->ops->calibrate_store) {
+		dev_err(dev, "Calibrate operation not supported.\n");
+		ret = -ENOTSUPP;
+	} else
+		ret = cyapa->ops->calibrate_store(dev, attr, buf, count);
+
+	mutex_unlock(&cyapa->state_sync_lock);
+	return ret < 0 ? ret : count;
+}
+
+static ssize_t cyapa_show_baseline(struct device *dev,
+				   struct device_attribute *attr, char *buf)
+{
+	struct cyapa *cyapa = dev_get_drvdata(dev);
+	ssize_t ret;
+
+	mutex_lock(&cyapa->state_sync_lock);
+
+	if (!cyapa->ops->show_baseline) {
+		dev_err(dev, "Calibrate operation not supported.\n");
+		ret = -ENOTSUPP;
+	} else
+		ret = cyapa->ops->show_baseline(dev, attr, buf);
+
+	mutex_unlock(&cyapa->state_sync_lock);
+	return ret;
+}
+
+static DEVICE_ATTR(firmware_version, S_IRUGO, cyapa_show_fm_ver, NULL);
+static DEVICE_ATTR(product_id, S_IRUGO, cyapa_show_product_id, NULL);
+static DEVICE_ATTR(update_fw, S_IWUSR, NULL, cyapa_update_fw_store);
+static DEVICE_ATTR(baseline, S_IRUGO, cyapa_show_baseline, NULL);
+static DEVICE_ATTR(calibrate, S_IWUSR, NULL, cyapa_calibrate_store);
+
+static struct attribute *cyapa_sysfs_entries[] = {
+	&dev_attr_firmware_version.attr,
+	&dev_attr_product_id.attr,
+	&dev_attr_update_fw.attr,
+	&dev_attr_baseline.attr,
+	&dev_attr_calibrate.attr,
+	NULL,
+};
+
+static const struct attribute_group cyapa_sysfs_group = {
+	.attrs = cyapa_sysfs_entries,
+};
+
 void cyapa_detect_async(void *data, async_cookie_t cookie)
 {
 	struct cyapa *cyapa = (struct cyapa *)data;
@@ -696,6 +884,9 @@ static int cyapa_probe(struct i2c_client *client,
 		goto err_uninit_tp_modules;
 	}
 
+	if (sysfs_create_group(&client->dev.kobj, &cyapa_sysfs_group))
+		dev_warn(dev, "error creating sysfs entries.\n");
+
 #ifdef CONFIG_PM_SLEEP
 	if (device_can_wakeup(dev) &&
 	    sysfs_merge_group(&client->dev.kobj, &cyapa_power_wakeup_group))
@@ -725,6 +916,7 @@ static int cyapa_remove(struct i2c_client *client)
 	mutex_unlock(&cyapa->state_sync_lock);
 
 	pm_runtime_disable(&client->dev);
+	sysfs_remove_group(&client->dev.kobj, &cyapa_sysfs_group);
 
 #ifdef CONFIG_PM_SLEEP
 	sysfs_unmerge_group(&client->dev.kobj, &cyapa_power_wakeup_group);
diff --git a/drivers/input/mouse/cyapa.h b/drivers/input/mouse/cyapa.h
index 636fea9..b61a71b 100644
--- a/drivers/input/mouse/cyapa.h
+++ b/drivers/input/mouse/cyapa.h
@@ -171,6 +171,22 @@ struct cyapa;
 typedef bool (*cb_sort)(struct cyapa *, u8 *, int);
 
 struct cyapa_dev_ops {
+	int (*check_fw)(struct cyapa *, const struct firmware *);
+	int (*bl_enter)(struct cyapa *);
+	int (*bl_activate)(struct cyapa *);
+	int (*bl_initiate)(struct cyapa *, const struct firmware *);
+	int (*update_fw)(struct cyapa *, const struct firmware *);
+	int (*bl_verify_app_integrity)(struct cyapa *);
+	int (*bl_deactivate)(struct cyapa *);
+
+	ssize_t (*show_baseline)(struct device *,
+			struct device_attribute *, char *);
+	ssize_t (*calibrate_store)(struct device *,
+			struct device_attribute *, const char *, size_t);
+
+	int (*read_fw)(struct cyapa *);
+	int (*read_raw_data)(struct cyapa *);
+
 	int (*initialize)(struct cyapa *cyapa);
 	int (*uninitialize)(struct cyapa *cyapa);
 
@@ -244,6 +260,17 @@ struct cyapa {
 	struct mutex state_sync_lock;
 	bool removed;
 
+	/* Per-instance debugfs root */
+	struct dentry *dentry_dev;
+
+	/* Buffer to store firmware read using debugfs */
+	struct mutex debugfs_mutex;
+	u8 *fw_image;
+	size_t fw_image_size;
+	/* Buffer to store sensors' raw data */
+	u8 *tp_raw_data;
+	size_t tp_raw_data_size;
+
 	const struct cyapa_dev_ops *ops;
 };
 
-- 
1.9.1


