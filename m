Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756760AbaGDKss (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 06:48:48 -0400
Received: from smtpfreer208.163vip.net ([61.135.158.115]:34064 "HELO
	smtp.tom.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752910AbaGDKsq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 06:48:46 -0400
Authentication-Results: bjzjm-antispam2 smtp.user=dudlx@tom.com; auth=pass (LOGIN)
From: "Dudley Du" <dudlx@tom.com>
To: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
Cc: "Alan Stern" <stern@rowland.harvard.edu>,
        "Benson Leung" <bleung@google.com>,
        "Patrik Fimml" <patrikf@google.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, <linux-input@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, "'Dudley Du'" <dudlx@outlook.com>
Subject: [PATCH v3 5/14] input: cyapa: add read firmware image and raw data interfaces in debugfs system
Date: Fri, 4 Jul 2014 18:48:43 +0800
Message-ID: <001d01cf9775$864fd3a0$92ef7ae0$@com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: Ac+XdYXc1ttdhbwBRkqe0xYJm5wGpA==
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add read_fw and raw_data debugfs interfaces for easier issues location
and collection when report by user.
TEST=test on Chromebooks.

Signed-off-by: Dudley Du <dudl@cypress.com>
---
 drivers/input/mouse/cyapa.c |  220 +++++++++++++++++++++++++++++++++++++++++++
 drivers/input/mouse/cyapa.h |   11 +++
 2 files changed, 231 insertions(+)

diff --git a/drivers/input/mouse/cyapa.c b/drivers/input/mouse/cyapa.c
index fb62de9..8c441cc 100644
--- a/drivers/input/mouse/cyapa.c
+++ b/drivers/input/mouse/cyapa.c
@@ -39,6 +39,9 @@
 
 const char unique_str[] = "CYTRA";
 
+/* global root node of the cyapa debugfs directory. */
+static struct dentry *cyapa_debugfs_root;
+
 
 void cyapa_enable_irq(struct cyapa *cyapa)
 {
@@ -545,6 +548,205 @@ done:
 }
 
 /*
+ **************************************************************
+ * debugfs interface
+ **************************************************************
+*/
+static int cyapa_debugfs_open(struct inode *inode, struct file *file)
+{
+	struct cyapa *cyapa = inode->i_private;
+	int ret;
+
+	if (!cyapa)
+		return -ENODEV;
+
+	ret = mutex_lock_interruptible(&cyapa->debugfs_mutex);
+	if (ret)
+		return ret;
+
+	if (!kobject_get(&cyapa->client->dev.kobj)) {
+		ret = -ENODEV;
+		goto out;
+	}
+
+	file->private_data = cyapa;
+
+	if (cyapa->fw_image) {
+		ret = 0;
+		goto out;
+	}
+
+	if (!cyapa_state_sync_enter(cyapa))
+		return -EBUSY;
+	/*
+	 * If firmware hasn't been read yet, read it all in one pass.
+	 * Subsequent opens will reuse the data in this same buffer.
+	 */
+	if (cyapa->ops->read_fw)
+		ret = cyapa->ops->read_fw(cyapa);
+	else
+		ret = -EPERM;
+	cyapa_state_sync_exit(cyapa);
+
+	/* redetect trackpad device states. */
+	cyapa_detect_async(cyapa, 0);
+
+out:
+	mutex_unlock(&cyapa->debugfs_mutex);
+	return ret;
+}
+
+static int cyapa_debugfs_release(struct inode *inode, struct file *file)
+{
+	struct cyapa *cyapa = file->private_data;
+	int ret;
+
+	if (!cyapa)
+		return 0;
+
+	ret = mutex_lock_interruptible(&cyapa->debugfs_mutex);
+	if (ret)
+		return ret;
+	file->private_data = NULL;
+	kobject_put(&cyapa->client->dev.kobj);
+	mutex_unlock(&cyapa->debugfs_mutex);
+
+	return 0;
+}
+
+/* Return some bytes from the buffered firmware image, starting from *ppos */
+static ssize_t cyapa_debugfs_read_fw(struct file *file, char __user *buffer,
+				     size_t count, loff_t *ppos)
+{
+	struct cyapa *cyapa = file->private_data;
+
+	if (!cyapa->fw_image)
+		return -EINVAL;
+
+	if (*ppos >= cyapa->fw_image_size)
+		return 0;
+
+	if (count + *ppos > cyapa->fw_image_size)
+		count = cyapa->fw_image_size - *ppos;
+
+	if (copy_to_user(buffer, &cyapa->fw_image[*ppos], count))
+		return -EFAULT;
+
+	*ppos += count;
+	return count;
+}
+
+static const struct file_operations cyapa_read_fw_fops = {
+	.open = cyapa_debugfs_open,
+	.release = cyapa_debugfs_release,
+	.read = cyapa_debugfs_read_fw
+};
+
+static int cyapa_debugfs_raw_data_open(struct inode *inode, struct file *file)
+{
+	struct cyapa *cyapa = inode->i_private;
+	int ret;
+
+	if (!cyapa)
+		return -ENODEV;
+
+	ret = mutex_lock_interruptible(&cyapa->debugfs_mutex);
+	if (ret)
+		return ret;
+
+	if (!kobject_get(&cyapa->client->dev.kobj)) {
+		ret = -ENODEV;
+		goto out;
+	}
+
+	file->private_data = cyapa;
+
+	if (!cyapa_state_sync_enter(cyapa)) {
+		ret = -EBUSY;
+		goto out;
+	}
+	if (cyapa->ops->read_raw_data)
+		ret = cyapa->ops->read_raw_data(cyapa);
+	else
+		ret = -EPERM;
+	cyapa_state_sync_exit(cyapa);
+out:
+	mutex_unlock(&cyapa->debugfs_mutex);
+	return ret;
+}
+
+static int cyapa_debugfs_raw_data_release(struct inode *inode,
+				struct file *file)
+{
+	struct cyapa *cyapa = file->private_data;
+	int ret;
+
+	if (!cyapa)
+		return 0;
+
+	ret = mutex_lock_interruptible(&cyapa->debugfs_mutex);
+	if (ret)
+		return ret;
+	file->private_data = NULL;
+	kobject_put(&cyapa->client->dev.kobj);
+	mutex_unlock(&cyapa->debugfs_mutex);
+
+	return 0;
+}
+
+/* Always return the sensors' latest raw data from trackpad device. */
+static ssize_t cyapa_debugfs_read_raw_data(struct file *file,
+				     char __user *buffer,
+				     size_t count, loff_t *ppos)
+{
+	struct cyapa *cyapa = file->private_data;
+
+	if (!cyapa->tp_raw_data)
+		return -EINVAL;
+
+	if (*ppos >= cyapa->tp_raw_data_size)
+		return 0;
+
+	if (count + *ppos > cyapa->tp_raw_data_size)
+		count = cyapa->tp_raw_data_size - *ppos;
+
+	if (copy_to_user(buffer, &cyapa->tp_raw_data[*ppos], count))
+		return -EFAULT;
+
+	*ppos += count;
+	return count;
+}
+
+static const struct file_operations cyapa_read_raw_data_fops = {
+	.open = cyapa_debugfs_raw_data_open,
+	.release = cyapa_debugfs_raw_data_release,
+	.read = cyapa_debugfs_read_raw_data
+};
+
+static int cyapa_debugfs_init(struct cyapa *cyapa)
+{
+	struct device *dev = &cyapa->client->dev;
+
+	if (!cyapa_debugfs_root)
+		return -ENODEV;
+
+	cyapa->dentry_dev = debugfs_create_dir(kobject_name(&dev->kobj),
+					       cyapa_debugfs_root);
+
+	if (!cyapa->dentry_dev)
+		return -ENODEV;
+
+	mutex_init(&cyapa->debugfs_mutex);
+
+	debugfs_create_file(CYAPA_DEBUGFS_READ_FW, S_IRUSR, cyapa->dentry_dev,
+			    cyapa, &cyapa_read_fw_fops);
+
+	debugfs_create_file(CYAPA_DEBUGFS_RAW_DATA, S_IRUSR, cyapa->dentry_dev,
+			    cyapa, &cyapa_read_raw_data_fops);
+	return 0;
+}
+
+/*
  * Sysfs Interface.
  */
 
@@ -978,6 +1180,13 @@ static int cyapa_probe(struct i2c_client *client,
 	if (sysfs_create_group(&client->dev.kobj, &cyapa_sysfs_group))
 		dev_warn(dev, "error creating sysfs entries.\n");
 
+	/* Create a global debugfs root for all cyapa devices */
+	cyapa_debugfs_root = debugfs_create_dir("cyapa", NULL);
+	if (cyapa_debugfs_root == ERR_PTR(-ENODEV))
+		cyapa_debugfs_root = NULL;
+	if (cyapa_debugfs_init(cyapa))
+		dev_warn(dev, "error creating debugfs entries.\n");
+
 #ifdef CONFIG_PM_SLEEP
 	if (device_can_wakeup(dev) &&
 	    sysfs_merge_group(&client->dev.kobj, &cyapa_power_wakeup_group))
@@ -1009,8 +1218,19 @@ static int cyapa_remove(struct i2c_client *client)
 #ifdef CONFIG_PM_RUNTIME
 	sysfs_unmerge_group(&client->dev.kobj, &cyapa_power_runtime_group);
 #endif
+
+	kfree(cyapa->fw_image);
+	cyapa->fw_image = NULL;
+	cyapa->fw_image_size = 0;
+	kfree(cyapa->tp_raw_data);
+	cyapa->tp_raw_data = NULL;
+	cyapa->tp_raw_data_size = 0;
 	free_irq(cyapa->irq, cyapa);
 
+	debugfs_remove_recursive(cyapa->dentry_dev);
+	debugfs_remove_recursive(cyapa_debugfs_root);
+	mutex_destroy(&cyapa->debugfs_mutex);
+
 	input_unregister_device(cyapa->input);
 	if (cyapa->ops->set_power_mode)
 		cyapa->ops->set_power_mode(cyapa, PWR_MODE_OFF, 0);
diff --git a/drivers/input/mouse/cyapa.h b/drivers/input/mouse/cyapa.h
index 5931a83..0ec76d9 100644
--- a/drivers/input/mouse/cyapa.h
+++ b/drivers/input/mouse/cyapa.h
@@ -258,6 +258,17 @@ struct cyapa {
 	bool irq_enabled;
 	bool prev_irq_enabled;
 
+	/* per-instance debugfs root */
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
1.7.9.5


