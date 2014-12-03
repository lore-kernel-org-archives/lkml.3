Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752509AbaLCJdv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 04:33:51 -0500
Received: from mail-pd0-f170.google.com ([209.85.192.170]:43725 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751925AbaLCJdq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 04:33:46 -0500
From: Dudley Du <dudley.dulixin@gmail.com>
To: dmitry.torokhov@gmail.com, rydberg@euromail.se
Cc: Dudley Du <dudley.dulixin@gmail.com>, bleung@google.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v12 14/19] input: cyapa: add read firmware image debugfs interface support
Date: Wed,  3 Dec 2014 17:30:20 +0800
Message-Id: <1417599025-21681-15-git-send-email-dudley.dulixin@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417599025-21681-1-git-send-email-dudley.dulixin@gmail.com>
References: <1417599025-21681-1-git-send-email-dudley.dulixin@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add read firmware image from trackpad device interface supported in cyapa
driver through debugfs read_fw interface.
Through this interface user can read out, check and backup the firmware image
of the trackpad device before any firmware update, or can use the backed image
to do firmware image recovery.
TEST=test on Chromebooks.

Signed-off-by: Dudley Du <dudley.dulixin@gmail.com>
---
 drivers/input/mouse/cyapa.c | 182 +++++++++++++++++++++++++++++++++++++++++++-
 drivers/input/mouse/cyapa.h |  10 +++
 2 files changed, 191 insertions(+), 1 deletion(-)

diff --git a/drivers/input/mouse/cyapa.c b/drivers/input/mouse/cyapa.c
index 25b1a3e..d6eb3f2 100644
--- a/drivers/input/mouse/cyapa.c
+++ b/drivers/input/mouse/cyapa.c
@@ -14,6 +14,7 @@
  * more details.
  */
 
+#include <linux/debugfs.h>
 #include <linux/delay.h>
 #include <linux/i2c.h>
 #include <linux/input.h>
@@ -32,10 +33,14 @@
 #define CYAPA_ADAPTER_FUNC_SMBUS  2
 #define CYAPA_ADAPTER_FUNC_BOTH   3
 
+#define CYAPA_DEBUGFS_READ_FW	"read_fw"
 #define CYAPA_FW_NAME		"cyapa.bin"
 
 const char unique_str[] = "CYTRA";
 
+/* Global root node of the cyapa debugfs directory. */
+static struct dentry *cyapa_debugfs_root;
+
 static int cyapa_reinitialize(struct cyapa *cyapa);
 
 /* Returns 0 on success, else negative errno on failure. */
@@ -617,6 +622,141 @@ out:
 
 /*
  **************************************************************
+ * debugfs interface
+ **************************************************************
+*/
+static int cyapa_debugfs_open(struct inode *inode, struct file *file)
+{
+	struct cyapa *cyapa = inode->i_private;
+	struct device *dev = &cyapa->client->dev;
+	int ret, error;
+
+	if (!cyapa)
+		return -ENODEV;
+
+	error = mutex_lock_interruptible(&cyapa->debugfs_mutex);
+	if (error)
+		return error;
+
+	if (!get_device(dev)) {
+		error = -ENODEV;
+		goto out;
+	}
+
+	file->private_data = cyapa;
+
+	if (cyapa->fw_image && cyapa->fw_image_size) {
+		error = 0;
+		goto out;
+	}
+
+	error = mutex_lock_interruptible(&cyapa->state_sync_lock);
+	if (error)
+		goto out;
+
+	/*
+	 * If firmware hasn't been read yet, read it all in one pass.
+	 * Subsequent opens will reuse the data in this same buffer.
+	 */
+	if (cyapa->ops->read_fw) {
+		cyapa->operational = false;
+		cyapa_enable_irq_for_cmd(cyapa);
+		error = cyapa->ops->read_fw(cyapa);
+		cyapa_disable_irq_for_cmd(cyapa);
+
+		ret = cyapa_reinitialize(cyapa);
+		if (ret) {
+			dev_err(dev, "failed to redetect after read_fw: %d\n",
+					ret);
+			error = error ? error : ret;
+		}
+	} else {
+		ret = -EPERM;
+	}
+
+	mutex_unlock(&cyapa->state_sync_lock);
+out:
+	mutex_unlock(&cyapa->debugfs_mutex);
+	return error;
+}
+
+static int cyapa_debugfs_release(struct inode *inode, struct file *file)
+{
+	struct cyapa *cyapa = file->private_data;
+	int error;
+
+	if (!cyapa)
+		return 0;
+
+	error = mutex_lock_interruptible(&cyapa->debugfs_mutex);
+	if (error)
+		return error;
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
+ **************************************************************
  * sysfs interface
  **************************************************************
 */
@@ -1156,6 +1296,20 @@ static int cyapa_probe(struct i2c_client *client,
 		return error;
 	}
 
+	error = cyapa_debugfs_init(cyapa);
+	if (error) {
+		dev_err(dev, "failed to create debugfs entries: %d\n", error);
+		return error;
+	}
+
+	error = devm_add_action(dev, cyapa_remove_debugfs, cyapa);
+	if (error) {
+		cyapa_remove_debugfs(cyapa);
+		dev_err(dev, "failed to add debugfs cleanup action :%d\n",
+			error);
+		return error;
+	}
+
 #ifdef CONFIG_PM_SLEEP
 	if (device_can_wakeup(dev)) {
 		error = sysfs_merge_group(&client->dev.kobj,
@@ -1336,7 +1490,33 @@ static struct i2c_driver cyapa_driver = {
 	.id_table = cyapa_id_table,
 };
 
-module_i2c_driver(cyapa_driver);
+static int __init cyapa_init(void)
+{
+	int error;
+
+	/* Create a global debugfs root for all cyapa devices */
+	cyapa_debugfs_root = debugfs_create_dir("cyapa", NULL);
+	if (cyapa_debugfs_root == ERR_PTR(-ENODEV))
+		cyapa_debugfs_root = NULL;
+
+	error = i2c_add_driver(&cyapa_driver);
+	if (error) {
+		pr_err("cyapa driver register FAILED.\n");
+		return error;
+	}
+
+	return 0;
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
index 39e7941..f8eac6f 100644
--- a/drivers/input/mouse/cyapa.h
+++ b/drivers/input/mouse/cyapa.h
@@ -186,6 +186,8 @@ struct cyapa_dev_ops {
 	ssize_t (*calibrate_store)(struct device *,
 			struct device_attribute *, const char *, size_t);
 
+	int (*read_fw)(struct cyapa *);
+
 	int (*initialize)(struct cyapa *cyapa);
 
 	int (*state_parse)(struct cyapa *cyapa, u8 *reg_status, int len);
@@ -297,6 +299,14 @@ struct cyapa {
 	 */
 	struct mutex state_sync_lock;
 
+	/* Per-instance debugfs root */
+	struct dentry *dentry_dev;
+
+	/* Buffer to store firmware read using debugfs */
+	struct mutex debugfs_mutex;
+	u8 *fw_image;
+	size_t fw_image_size;
+
 	const struct cyapa_dev_ops *ops;
 
 	union cyapa_cmd_states cmd_states;
-- 
1.9.1

