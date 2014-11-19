Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754597AbaKSIkF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 03:40:05 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:50684 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754523AbaKSIkA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 03:40:00 -0500
From: Dudley Du <dudley.dulixin@gmail.com>
To: dmitry.torokhov@gmail.com, rydberg@euromail.se
Cc: Dudley Du <dudley.dulixin@gmail.com>, bleung@google.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v11 07/19] input: cyapa: add sysfs interfaces supported in the cyapa driver
Date: Wed, 19 Nov 2014 16:37:39 +0800
Message-Id: <1416386271-28167-8-git-send-email-dudley.dulixin@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1416386271-28167-1-git-send-email-dudley.dulixin@gmail.com>
References: <1416386271-28167-1-git-send-email-dudley.dulixin@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add device's basic control and features supported in cyapa driver through
sysfs file system interfaces. These interfaces are commonly used in
pre- and after production, for trackpad device state checking, managing
and firmware image updating.
These interfaces including mode, firmware_version and product_id interfaces
for reading firmware version and trackpad device product id values,
and including update_fw interface to command firmware image update
process. Also including baseline and calibrate interfaces for
reading and checking trackpad device's sensors states.
TEST=test on Chromebooks.

Signed-off-by: Dudley Du <dudley.dulixin@gmail.com>
---
 drivers/input/mouse/cyapa.c | 301 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 301 insertions(+)

diff --git a/drivers/input/mouse/cyapa.c b/drivers/input/mouse/cyapa.c
index 64bb067..305dffe 100644
--- a/drivers/input/mouse/cyapa.c
+++ b/drivers/input/mouse/cyapa.c
@@ -32,6 +32,8 @@
 #define CYAPA_ADAPTER_FUNC_SMBUS  2
 #define CYAPA_ADAPTER_FUNC_BOTH   3
 
+#define CYAPA_FW_NAME		"cyapa.bin"
+
 const char unique_str[] = "CYTRA";
 
 /* Returns 0 on success, else negative errno on failure. */
@@ -475,6 +477,25 @@ int cyapa_detect(struct cyapa *cyapa)
 	return 0;
 }
 
+static void cyapa_enable_irq_for_cmd(struct cyapa *cyapa)
+{
+	if (!cyapa->opened) {
+		if (cyapa->operational && cyapa->ops->set_power_mode)
+			cyapa->ops->set_power_mode(cyapa,
+				PWR_MODE_FULL_ACTIVE, 0);
+		enable_irq(cyapa->client->irq);
+	}
+}
+
+static void cyapa_disable_irq_for_cmd(struct cyapa *cyapa)
+{
+	if (!cyapa->opened) {
+		disable_irq(cyapa->client->irq);
+		if (cyapa->operational && cyapa->ops->set_power_mode)
+			cyapa->ops->set_power_mode(cyapa, PWR_MODE_OFF, 0);
+	}
+}
+
 /*
  * Sysfs Interface.
  */
@@ -704,6 +725,273 @@ static int cyapa_start_runtime(struct cyapa *cyapa)
 }
 #endif /* CONFIG_PM_RUNTIME */
 
+static ssize_t cyapa_show_fm_ver(struct device *dev,
+				 struct device_attribute *attr, char *buf)
+{
+	int error;
+	struct cyapa *cyapa = dev_get_drvdata(dev);
+
+	error = mutex_lock_interruptible(&cyapa->state_sync_lock);
+	if (error)
+		return error;
+	error = scnprintf(buf, PAGE_SIZE, "%d.%d\n", cyapa->fw_maj_ver,
+			 cyapa->fw_min_ver);
+	mutex_unlock(&cyapa->state_sync_lock);
+	return error;
+}
+
+static ssize_t cyapa_show_product_id(struct device *dev,
+				     struct device_attribute *attr, char *buf)
+{
+	struct cyapa *cyapa = dev_get_drvdata(dev);
+	int size;
+	int error;
+
+	error = mutex_lock_interruptible(&cyapa->state_sync_lock);
+	if (error)
+		return error;
+	size = scnprintf(buf, PAGE_SIZE, "%s\n", cyapa->product_id);
+	mutex_unlock(&cyapa->state_sync_lock);
+	return size;
+}
+
+static int cyapa_firmware(struct cyapa *cyapa, const char *fw_name)
+{
+	struct device *dev = &cyapa->client->dev;
+	const struct firmware *fw;
+	int error;
+
+	error = request_firmware(&fw, fw_name, dev);
+	if (error) {
+		dev_err(dev, "Could not load firmware from %s: %d\n",
+			fw_name, error);
+		return error;
+	}
+
+	if (cyapa->ops->check_fw) {
+		error = cyapa->ops->check_fw(cyapa, fw);
+		if (error) {
+			dev_err(dev, "Invalid CYAPA firmware image: %s\n",
+					fw_name);
+			goto done;
+		}
+	} else {
+		dev_err(dev, "No valid device ops->check_fw handler set.\n");
+		error = -ENODEV;
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
+		error = cyapa->ops->bl_enter(cyapa);
+		if (error)
+			goto err_detect;
+	}
+
+	if (cyapa->ops->bl_activate) {
+		error = cyapa->ops->bl_activate(cyapa);
+		if (error)
+			goto err_detect;
+	}
+
+	if (cyapa->ops->bl_initiate) {
+		error = cyapa->ops->bl_initiate(cyapa, fw);
+		if (error)
+			goto err_detect;
+	}
+
+	if (cyapa->ops->update_fw) {
+		error = cyapa->ops->update_fw(cyapa, fw);
+		if (error)
+			goto err_detect;
+	}
+
+	if (cyapa->ops->bl_verify_app_integrity) {
+		error = cyapa->ops->bl_verify_app_integrity(cyapa);
+		if (error)
+			goto err_detect;
+	}
+
+err_detect:
+	pm_runtime_put_noidle(dev);
+
+done:
+	release_firmware(fw);
+	return error;
+}
+
+static ssize_t cyapa_update_fw_store(struct device *dev,
+				     struct device_attribute *attr,
+				     const char *buf, size_t count)
+{
+	struct cyapa *cyapa = dev_get_drvdata(dev);
+	char fw_name[64];
+	int error;
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
+	error = mutex_lock_interruptible(&cyapa->state_sync_lock);
+	if (error)
+		return error;
+
+	/* Require IRQ support for firmware update commands. */
+	cyapa_enable_irq_for_cmd(cyapa);
+
+	if (cyapa->operational)
+		cyapa->operational = false;
+
+	error = cyapa_firmware(cyapa, fw_name);
+	if (error)
+		dev_err(dev, "firmware update failed: %d\n", error);
+	else
+		dev_dbg(dev, "firmware update successfully done.\n");
+
+	cyapa_disable_irq_for_cmd(cyapa);
+
+	/*
+	 * Redetect trackpad device states because firmware update process
+	 * will reset trackpad device into bootloader mode.
+	 */
+	cyapa_detect(cyapa);
+
+	mutex_unlock(&cyapa->state_sync_lock);
+
+	return error ? error : count;
+}
+
+static ssize_t cyapa_calibrate_store(struct device *dev,
+				     struct device_attribute *attr,
+				     const char *buf, size_t count)
+{
+	struct cyapa *cyapa = dev_get_drvdata(dev);
+	int error;
+
+	error = mutex_lock_interruptible(&cyapa->state_sync_lock);
+	if (error)
+		return error;
+
+	/* Require IRQ support for force calibrate commands. */
+	cyapa_enable_irq_for_cmd(cyapa);
+
+	if (!cyapa->ops->calibrate_store) {
+		dev_err(dev, "Calibrate operation not supported.\n");
+		error = -ENOTSUPP;
+	} else {
+		error = cyapa->ops->calibrate_store(dev, attr, buf, count);
+	}
+
+	cyapa_disable_irq_for_cmd(cyapa);
+
+	mutex_unlock(&cyapa->state_sync_lock);
+	return error < 0 ? error : count;
+}
+
+static ssize_t cyapa_show_baseline(struct device *dev,
+				   struct device_attribute *attr, char *buf)
+{
+	struct cyapa *cyapa = dev_get_drvdata(dev);
+	ssize_t error;
+
+	error = mutex_lock_interruptible(&cyapa->state_sync_lock);
+	if (error)
+		return error;
+
+	/* Require IRQ support for read baseline commands. */
+	cyapa_enable_irq_for_cmd(cyapa);
+
+	if (!cyapa->ops->show_baseline) {
+		dev_err(dev, "Calibrate operation not supported.\n");
+		error = -ENOTSUPP;
+	} else {
+		error = cyapa->ops->show_baseline(dev, attr, buf);
+	}
+
+	cyapa_disable_irq_for_cmd(cyapa);
+
+	mutex_unlock(&cyapa->state_sync_lock);
+	return error;
+}
+
+static char *cyapa_state_to_string(struct cyapa *cyapa)
+{
+	switch (cyapa->state) {
+	case CYAPA_STATE_BL_BUSY:
+		return "bootloader busy";
+	case CYAPA_STATE_BL_IDLE:
+		return "bootloader idle";
+	case CYAPA_STATE_BL_ACTIVE:
+		return "bootloader active";
+	case CYAPA_STATE_GEN5_BL:
+		return "bootloader";
+	case CYAPA_STATE_OP:
+	case CYAPA_STATE_GEN5_APP:
+		return "operational";
+	default:
+		return "invalid mode";
+	}
+}
+
+static ssize_t cyapa_show_mode(struct device *dev,
+				   struct device_attribute *attr, char *buf)
+{
+	struct cyapa *cyapa = dev_get_drvdata(dev);
+	int size;
+	int error;
+
+	error = mutex_lock_interruptible(&cyapa->state_sync_lock);
+	if (error)
+		return error;
+
+	size = scnprintf(buf, PAGE_SIZE, "gen%d %s\n",
+			cyapa->gen, cyapa_state_to_string(cyapa));
+
+	mutex_unlock(&cyapa->state_sync_lock);
+	return size;
+}
+
+static DEVICE_ATTR(firmware_version, S_IRUGO, cyapa_show_fm_ver, NULL);
+static DEVICE_ATTR(product_id, S_IRUGO, cyapa_show_product_id, NULL);
+static DEVICE_ATTR(update_fw, S_IWUSR, NULL, cyapa_update_fw_store);
+static DEVICE_ATTR(baseline, S_IRUGO, cyapa_show_baseline, NULL);
+static DEVICE_ATTR(calibrate, S_IWUSR, NULL, cyapa_calibrate_store);
+static DEVICE_ATTR(mode, S_IRUGO, cyapa_show_mode, NULL);
+
+static struct attribute *cyapa_sysfs_entries[] = {
+	&dev_attr_firmware_version.attr,
+	&dev_attr_product_id.attr,
+	&dev_attr_update_fw.attr,
+	&dev_attr_baseline.attr,
+	&dev_attr_calibrate.attr,
+	&dev_attr_mode.attr,
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
@@ -775,6 +1063,19 @@ static int cyapa_probe(struct i2c_client *client,
 		return error;
 	}
 
+	error = sysfs_create_group(&client->dev.kobj, &cyapa_sysfs_group);
+	if (error) {
+		dev_err(dev, "failed to create sysfs entries: %d\n", error);
+		return error;
+	}
+
+	error = devm_add_action(dev, cyapa_remove_sysfs_group, cyapa);
+	if (error) {
+		cyapa_remove_sysfs_group(cyapa);
+		dev_err(dev, "failed to add sysfs cleanup action: %d\n", error);
+		return error;
+	}
+
 #ifdef CONFIG_PM_SLEEP
 	if (device_can_wakeup(dev)) {
 		error = sysfs_merge_group(&client->dev.kobj,
-- 
1.9.1

