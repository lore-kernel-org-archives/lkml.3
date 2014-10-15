Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751674AbaJOHU6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 03:20:58 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:42941 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751644AbaJOHU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 03:20:56 -0400
From: Dudley Du <dudley.dulixin@gmail.com>
X-Google-Original-From: Dudley Du <dudl@cypress.com>
To: dmitry.torokhov@gmail.com, rydberg@euromail.se
Cc: Dudley Du <dudl@cypress.com>, bleung@google.com, patrikf@google.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 05/13] input: cyapa: add read firmware image and raw data interfaces in debugfs system
Date: Wed, 15 Oct 2014 15:19:19 +0800
Message-Id: <1413357567-26177-6-git-send-email-dudl@cypress.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1413357567-26177-1-git-send-email-dudl@cypress.com>
References: <1413357567-26177-1-git-send-email-dudl@cypress.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add read_fw and raw_data debugfs interfaces for easier issues location
and collection when report by user.
TEST=test on Chromebooks.

Signed-off-by: Dudley Du <dudl@cypress.com>
---
 drivers/input/mouse/cyapa.c | 239 ++++++++++++++++++++++++++++++++++++++++++++
 drivers/input/mouse/cyapa.h |  12 +++
 2 files changed, 251 insertions(+)

diff --git a/drivers/input/mouse/cyapa.c b/drivers/input/mouse/cyapa.c
index 87f330b..5c7f9eb 100644
--- a/drivers/input/mouse/cyapa.c
+++ b/drivers/input/mouse/cyapa.c
@@ -39,6 +39,8 @@
 
 const char unique_str[] = "CYTRA";
 
+/* Global root node of the cyapa debugfs directory. */
+static struct dentry *cyapa_debugfs_root;
 
 
 ssize_t cyapa_i2c_reg_read_block(struct cyapa *cyapa, u8 reg, size_t len,
@@ -511,6 +513,222 @@ static int cyapa_detect_with_lock(struct cyapa *cyapa)
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
+	if (!get_device(&cyapa->client->dev)) {
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
+	ret = mutex_lock_interruptible(&cyapa->state_sync_lock);
+	if (ret)
+		goto out;
+	/*
+	 * If firmware hasn't been read yet, read it all in one pass.
+	 * Subsequent opens will reuse the data in this same buffer.
+	 */
+	if (cyapa->ops->read_fw) {
+		ret = cyapa->ops->read_fw(cyapa);
+
+		/*
+		 * Redetect trackpad device states because read_fw will
+		 * reset trackpad device into bootloader mode.
+		 */
+		cyapa_detect(cyapa);
+	} else
+		ret = -EPERM;
+
+	mutex_unlock(&cyapa->state_sync_lock);
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
+	put_device(&cyapa->client->dev);
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
+	/* Start to be supported after Gen5 trackpad devices. */
+	if (cyapa->gen < CYAPA_GEN5)
+		return -ENOTSUPP;
+
+	ret = mutex_lock_interruptible(&cyapa->debugfs_mutex);
+	if (ret)
+		return ret;
+
+	if (!get_device(&cyapa->client->dev)) {
+		ret = -ENODEV;
+		goto out;
+	}
+
+	file->private_data = cyapa;
+
+	ret = mutex_lock_interruptible(&cyapa->state_sync_lock);
+	if (ret)
+		goto out;
+	if (cyapa->ops->read_raw_data)
+		ret = cyapa->ops->read_raw_data(cyapa);
+	else
+		ret = -EPERM;
+	mutex_unlock(&cyapa->state_sync_lock);
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
+	put_device(&cyapa->client->dev);
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
+	if (cyapa->gen >= CYAPA_GEN5)
+		debugfs_create_file(CYAPA_DEBUGFS_RAW_DATA, S_IRUSR,
+			cyapa->dentry_dev, cyapa, &cyapa_read_raw_data_fops);
+
+	return 0;
+}
+
+static void cyapa_remove_debugfs(void *data)
+{
+	struct cyapa *cyapa = data;
+
+	debugfs_remove_recursive(cyapa->dentry_dev);
+	mutex_destroy(&cyapa->debugfs_mutex);
+}
+
+/*
  * Sysfs Interface.
  */
 
@@ -1015,6 +1233,20 @@ static int cyapa_probe(struct i2c_client *client,
 		return ret;
 	}
 
+	ret = cyapa_debugfs_init(cyapa);
+	if (ret) {
+		dev_err(dev, "failed to create debugfs entries, (%d).\n", ret);
+		return ret;
+	}
+
+	ret = devm_add_action(dev, cyapa_remove_debugfs, cyapa);
+	if (ret) {
+		cyapa_remove_debugfs(cyapa);
+		dev_err(dev, "failed to add debugfs cleanup action, (%d)\n",
+			ret);
+		return ret;
+	}
+
 #ifdef CONFIG_PM_SLEEP
 	if (device_can_wakeup(dev)) {
 		ret = sysfs_merge_group(&client->dev.kobj,
@@ -1221,6 +1453,11 @@ static int __init cyapa_init(void)
 {
 	int ret;
 
+	/* Create a global debugfs root for all cyapa devices */
+	cyapa_debugfs_root = debugfs_create_dir("cyapa", NULL);
+	if (cyapa_debugfs_root == ERR_PTR(-ENODEV))
+		cyapa_debugfs_root = NULL;
+
 	ret = i2c_add_driver(&cyapa_driver);
 	if (ret) {
 		pr_err("cyapa driver register FAILED.\n");
@@ -1232,6 +1469,8 @@ static int __init cyapa_init(void)
 
 static void __exit cyapa_exit(void)
 {
+	debugfs_remove_recursive(cyapa_debugfs_root);
+
 	i2c_del_driver(&cyapa_driver);
 }
 
diff --git a/drivers/input/mouse/cyapa.h b/drivers/input/mouse/cyapa.h
index eccb6da..425f009 100644
--- a/drivers/input/mouse/cyapa.h
+++ b/drivers/input/mouse/cyapa.h
@@ -303,6 +303,18 @@ struct cyapa {
 	async_cookie_t async_thread_cookie;
 	enum cyapa_flag flags;
 
+	/* Per-instance debugfs root */
+	struct dentry *dentry_dev;
+
+	/* Buffer to store firmware read using debugfs */
+	struct mutex debugfs_mutex;
+	struct cyapa_tsg_bin_image_head fw_img_head;
+	u8 *fw_image;
+	size_t fw_image_size;
+	/* Buffer to store sensors' raw data */
+	u8 *tp_raw_data;
+	size_t tp_raw_data_size;
+
 	struct regulator *supply_regulator;
 
 	const struct cyapa_dev_ops *ops;
-- 
1.9.1

