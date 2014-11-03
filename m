Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752264AbaKCIg5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 03:36:57 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:52189 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751175AbaKCIgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 03:36:51 -0500
From: Dudley Du <dudley.dulixin@gmail.com>
X-Google-Original-From: Dudley Du <dudl@cypress.com>
To: dmitry.torokhov@gmail.com, rydberg@euromail.se
Cc: Dudley Du <dudl@cypress.com>, bleung@google.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v9 14/18] input: cyapa: add read firmware image debugfs interface support
Date: Mon,  3 Nov 2014 16:33:06 +0800
Message-Id: <1415003590-30485-15-git-send-email-dudl@cypress.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415003590-30485-1-git-send-email-dudl@cypress.com>
References: <1415003590-30485-1-git-send-email-dudl@cypress.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add read firmware image from trackpad device interface supported in cyapa
driver through debugfs read_fw interface.
Through this interface user can read out, check and backup the firmware image
of the trackpad device before any firmware update, or can use the backed image
to do firmware image recovery.
TEST=test on Chromebooks.

Signed-off-by: Dudley Du <dudl@cypress.com>
---
 drivers/input/mouse/cyapa.c | 174 +++++++++++++++++++++++++++++++++++++++++++-
 drivers/input/mouse/cyapa.h |  11 +++
 2 files changed, 184 insertions(+), 1 deletion(-)

diff --git a/drivers/input/mouse/cyapa.c b/drivers/input/mouse/cyapa.c
index 5f384ff..bc1d75a 100644
--- a/drivers/input/mouse/cyapa.c
+++ b/drivers/input/mouse/cyapa.c
@@ -14,6 +14,7 @@
  * more details.
  */
 
+#include <linux/debugfs.h>
 #include <linux/delay.h>
 #include <linux/i2c.h>
 #include <linux/input.h>
@@ -38,6 +39,9 @@
 
 const char unique_str[] = "CYTRA";
 
+/* Global root node of the cyapa debugfs directory. */
+static struct dentry *cyapa_debugfs_root;
+
 
 ssize_t cyapa_i2c_reg_read_block(struct cyapa *cyapa, u8 reg, size_t len,
 					u8 *values)
@@ -475,6 +479,134 @@ int cyapa_detect(struct cyapa *cyapa)
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
+	if (cyapa->fw_image && cyapa->fw_image_size) {
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
 
@@ -1012,6 +1144,20 @@ static int cyapa_probe(struct i2c_client *client,
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
@@ -1192,7 +1338,33 @@ static struct i2c_driver cyapa_driver = {
 	.id_table = cyapa_id_table,
 };
 
-module_i2c_driver(cyapa_driver);
+static int __init cyapa_init(void)
+{
+	int ret;
+
+	/* Create a global debugfs root for all cyapa devices */
+	cyapa_debugfs_root = debugfs_create_dir("cyapa", NULL);
+	if (cyapa_debugfs_root == ERR_PTR(-ENODEV))
+		cyapa_debugfs_root = NULL;
+
+	ret = i2c_add_driver(&cyapa_driver);
+	if (ret) {
+		pr_err("cyapa driver register FAILED.\n");
+		return ret;
+	}
+
+	return ret;
+}
+
+static void __exit cyapa_exit(void)
+{
+	debugfs_remove_recursive(cyapa_debugfs_root);
+
+	i2c_del_driver(&cyapa_driver);
+}
+
+module_init(cyapa_init);
+module_exit(cyapa_exit);
 
 MODULE_DESCRIPTION("Cypress APA I2C Trackpad Driver");
 MODULE_AUTHOR("Dudley Du <dudl@cypress.com>");
diff --git a/drivers/input/mouse/cyapa.h b/drivers/input/mouse/cyapa.h
index 060ac7d..288c7de 100644
--- a/drivers/input/mouse/cyapa.h
+++ b/drivers/input/mouse/cyapa.h
@@ -189,6 +189,8 @@ struct cyapa_dev_ops {
 	ssize_t (*calibrate_store)(struct device *,
 			struct device_attribute *, const char *, size_t);
 
+	int (*read_fw)(struct cyapa *);
+
 	int (*initialize)(struct cyapa *cyapa);
 
 	int (*state_parse)(struct cyapa *cyapa, u8 *reg_status, int len);
@@ -288,6 +290,15 @@ struct cyapa {
 	 */
 	struct mutex state_sync_lock;
 
+	/* Per-instance debugfs root */
+	struct dentry *dentry_dev;
+
+	/* Buffer to store firmware read using debugfs */
+	struct mutex debugfs_mutex;
+	struct cyapa_tsg_bin_image_head fw_img_head;
+	u8 *fw_image;
+	size_t fw_image_size;
+
 	const struct cyapa_dev_ops *ops;
 
 	union cyapa_cmd_states cmd_states;
-- 
1.9.1

