Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751227AbaKCIft (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 03:35:49 -0500
Received: from mail-pd0-f175.google.com ([209.85.192.175]:39721 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256AbaKCIfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 03:35:44 -0500
From: Dudley Du <dudley.dulixin@gmail.com>
X-Google-Original-From: Dudley Du <dudl@cypress.com>
To: dmitry.torokhov@gmail.com, rydberg@euromail.se
Cc: Dudley Du <dudl@cypress.com>, bleung@google.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v9 07/18] input: cyapa: add sysfs interfaces supported in the cyapa driver
Date: Mon,  3 Nov 2014 16:32:59 +0800
Message-Id: <1415003590-30485-8-git-send-email-dudl@cypress.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415003590-30485-1-git-send-email-dudl@cypress.com>
References: <1415003590-30485-1-git-send-email-dudl@cypress.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add device's basic control and features supported in cyapa driver through
sysfs file system interfaces. These interfaces are commonly used in
pre- and after production, for trackpad device state checking, managing
and firmware image updating.
These interfaces including firmware_version and product_id interfaces
for reading firmware version and trackpad device product id values,
and including update_fw interface to command firmware image update
process. Also including baseline and calibrate interfaces for
reading and checking trackpad device's sensors states.
TEST=test on Chromebooks.

Signed-off-by: Dudley Du <dudl@cypress.com>
---
 drivers/input/mouse/cyapa.c | 220 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 220 insertions(+)

diff --git a/drivers/input/mouse/cyapa.c b/drivers/input/mouse/cyapa.c
index d4b7c42..5f384ff 100644
--- a/drivers/input/mouse/cyapa.c
+++ b/drivers/input/mouse/cyapa.c
@@ -709,6 +709,213 @@ static int cyapa_start_runtime(struct cyapa *cyapa)
 }
 #endif /* CONFIG_PM_RUNTIME */
 
+static ssize_t cyapa_show_fm_ver(struct device *dev,
+				 struct device_attribute *attr, char *buf)
+{
+	int ret;
+	struct cyapa *cyapa = dev_get_drvdata(dev);
+
+	ret = mutex_lock_interruptible(&cyapa->state_sync_lock);
+	if (ret)
+		return ret;
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
+	ret = mutex_lock_interruptible(&cyapa->state_sync_lock);
+	if (ret)
+		return ret;
+	ret = scnprintf(buf, PAGE_SIZE, "%s\n", cyapa->product_id);
+	mutex_unlock(&cyapa->state_sync_lock);
+	return ret;
+}
+
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
+		dev_err(dev, "No valid device ops->check_fw handler set.\n");
+		ret = -ENODEV;
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
+	ret = mutex_lock_interruptible(&cyapa->state_sync_lock);
+	if (ret)
+		return ret;
+
+	ret = cyapa_firmware(cyapa, fw_name);
+	if (ret)
+		dev_err(dev, "firmware update failed, %d\n", ret);
+	else
+		dev_dbg(dev, "firmware update successfully done.\n");
+
+	/*
+	 * Redetect trackpad device states because firmware update process
+	 * will reset trackpad device into bootloader mode.
+	 */
+	cyapa_detect(cyapa);
+
+	mutex_unlock(&cyapa->state_sync_lock);
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
+	ret = mutex_lock_interruptible(&cyapa->state_sync_lock);
+	if (ret)
+		return ret;
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
+	ret = mutex_lock_interruptible(&cyapa->state_sync_lock);
+	if (ret)
+		return ret;
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
+static void cyapa_remove_sysfs_group(void *data)
+{
+	struct cyapa *cyapa = data;
+
+	sysfs_remove_group(&cyapa->client->dev.kobj, &cyapa_sysfs_group);
+}
+
 /*
  * Returns:
  *   0    Driver and device initialization successfully done.
@@ -792,6 +999,19 @@ static int cyapa_probe(struct i2c_client *client,
 		return ret;
 	}
 
+	ret = sysfs_create_group(&client->dev.kobj, &cyapa_sysfs_group);
+	if (ret) {
+		dev_err(dev, "failed to create sysfs entries, (%d)\n", ret);
+		return ret;
+	}
+
+	ret = devm_add_action(dev, cyapa_remove_sysfs_group, cyapa);
+	if (ret) {
+		cyapa_remove_sysfs_group(cyapa);
+		dev_err(dev, "failed to add sysfs cleanup action, (%d)\n", ret);
+		return ret;
+	}
+
 #ifdef CONFIG_PM_SLEEP
 	if (device_can_wakeup(dev)) {
 		ret = sysfs_merge_group(&client->dev.kobj,
-- 
1.9.1

