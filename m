Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751627AbaJOHUr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 03:20:47 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:58117 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581AbaJOHUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 03:20:43 -0400
From: Dudley Du <dudley.dulixin@gmail.com>
X-Google-Original-From: Dudley Du <dudl@cypress.com>
To: dmitry.torokhov@gmail.com, rydberg@euromail.se
Cc: Dudley Du <dudl@cypress.com>, bleung@google.com, patrikf@google.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 04/13] input: cyapa: add cyapa key function interfaces in sysfs system
Date: Wed, 15 Oct 2014 15:19:18 +0800
Message-Id: <1413357567-26177-5-git-send-email-dudl@cypress.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1413357567-26177-1-git-send-email-dudl@cypress.com>
References: <1413357567-26177-1-git-send-email-dudl@cypress.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
 drivers/input/mouse/cyapa.c | 253 ++++++++++++++++++++++++++++++++++++++++++--
 drivers/input/mouse/cyapa.h |  16 +++
 2 files changed, 258 insertions(+), 11 deletions(-)

diff --git a/drivers/input/mouse/cyapa.c b/drivers/input/mouse/cyapa.c
index 5b2233b..87f330b 100644
--- a/drivers/input/mouse/cyapa.c
+++ b/drivers/input/mouse/cyapa.c
@@ -300,6 +300,78 @@ out:
 	return IRQ_HANDLED;
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
  * Query device for its current operating state.
  */
@@ -360,18 +432,28 @@ static int cyapa_detect(struct cyapa *cyapa)
 			(cyapa->gen == CYAPA_GEN5 &&
 				cyapa->state == CYAPA_STATE_GEN5_BL))) {
 			dev_warn(dev, "device exist, but not operational.\n");
-			/*
-			 * Do not unload this driver, so users/apps can
-			 * recovery it manually by copy and manually
-			 * command the device to update with the copied
-			 * firmware image.
-			 */
-			return 1;
+			dev_warn(dev, "try to recover device with fw image.\n");
+			ret = cyapa_firmware(cyapa, CYAPA_FW_NAME);
+			if (!ret)
+				ret = cyapa_check_is_operational(cyapa);
+			if (ret) {
+				dev_err(dev,
+					"failed to recover the device, (%d)\n",
+					ret);
+				/*
+				 * Do not unload this driver, so users/apps can
+				 * recovery it manually by copy and manually
+				 * command the device to update with the copied
+				 * firmware image.
+				 */
+				return 1;
+			}
+			dev_warn(dev, "recover done successfully.\n");
+		} else {
+			dev_err(dev, "no device detected, (%d)\n", ret);
+			kobject_uevent_env(&dev->kobj, KOBJ_CHANGE, envp);
+			return ret;
 		}
-
-		dev_err(dev, "no device detected, (%d)\n", ret);
-		kobject_uevent_env(&dev->kobj, KOBJ_CHANGE, envp);
-		return ret;
 	}
 
 	if (!cyapa->input) {
@@ -666,6 +748,142 @@ static int cyapa_start_runtime(struct cyapa *cyapa) { return 0; }
 static void cyapa_remove_power_runtime_group(void *data) {}
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
+		dev_dbg(dev, "firmware update succeeded\n");
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
 void cyapa_sync_detect(void *data, async_cookie_t cookie)
 {
 	cyapa_detect_with_lock((struct cyapa *)data);
@@ -784,6 +1002,19 @@ static int cyapa_probe(struct i2c_client *client,
 	if (ret < 0)
 		return ret;
 
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
diff --git a/drivers/input/mouse/cyapa.h b/drivers/input/mouse/cyapa.h
index 946a229..eccb6da 100644
--- a/drivers/input/mouse/cyapa.h
+++ b/drivers/input/mouse/cyapa.h
@@ -176,6 +176,22 @@ struct cyapa;
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
 
 	int (*state_parse)(struct cyapa *cyapa, u8 *reg_status, int len);
-- 
1.9.1

