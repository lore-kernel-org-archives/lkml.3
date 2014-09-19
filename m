Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756622AbaISBqw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 21:46:52 -0400
Received: from bay004-omc1s22.hotmail.com ([65.54.190.33]:59039 "EHLO
	BAY004-OMC1S22.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756460AbaISBqu convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 21:46:50 -0400
X-TMN: [4FqPw/+gfEBziTF/14VQae69pO4/2A3y]
X-Originating-Email: [dudlx@outlook.com]
Message-ID: <BAY176-DS1E46A1A154573233FC5AFBDB40@phx.gbl>
From: Dudley Du <dudlx@outlook.com>
To: <dmitry.torokhov@gmail.com>, <rydberg@euromail.se>
CC: <bleung@google.com>, <patrikf@google.com>, <linux-input@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v7 05/13] input: cyapa: add read firmware image and raw data interfaces in debugfs system
Date: Fri, 19 Sep 2014 09:46:49 +0800
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: Ac/Tq5QxAgTn4plgQK6qJMTNdDwOXw==
Content-Language: zh-cn
X-OriginalArrivalTime: 19 Sep 2014 01:46:50.0102 (UTC) FILETIME=[947B7160:01CFD3AB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add read_fw and raw_data debugfs interfaces for easier issues location
and collection when report by user.
TEST=test on Chromebooks.

Signed-off-by: Dudley Du <dudl@cypress.com>
---
 drivers/input/mouse/cyapa.c | 221 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 221 insertions(+)

diff --git a/drivers/input/mouse/cyapa.c b/drivers/input/mouse/cyapa.c
index dd78e89..5e48309 100644
--- a/drivers/input/mouse/cyapa.c
+++ b/drivers/input/mouse/cyapa.c
@@ -39,6 +39,8 @@
 
 const char unique_str[] = "CYTRA";
 
+/* Global root node of the cyapa debugfs directory. */
+static struct dentry *cyapa_debugfs_root;
 
 
 ssize_t cyapa_i2c_reg_read_block(struct cyapa *cyapa, u8 reg, size_t len,
@@ -470,6 +472,205 @@ done:
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
+	mutex_lock(&cyapa->state_sync_lock);
+	/*
+	 * If firmware hasn't been read yet, read it all in one pass.
+	 * Subsequent opens will reuse the data in this same buffer.
+	 */
+	if (cyapa->ops->read_fw)
+		ret = cyapa->ops->read_fw(cyapa);
+	else
+		ret = -EPERM;
+	mutex_unlock(&cyapa->state_sync_lock);
+
+	/* Redetect trackpad device states. */
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
+	mutex_lock(&cyapa->state_sync_lock);
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
+	debugfs_create_file(CYAPA_DEBUGFS_RAW_DATA, S_IRUSR, cyapa->dentry_dev,
+			    cyapa, &cyapa_read_raw_data_fops);
+	return 0;
+}
+
+/*
  * Sysfs Interface.
  */
 
@@ -887,6 +1088,9 @@ static int cyapa_probe(struct i2c_client *client,
 	if (sysfs_create_group(&client->dev.kobj, &cyapa_sysfs_group))
 		dev_warn(dev, "error creating sysfs entries.\n");
 
+	if (cyapa_debugfs_init(cyapa))
+		dev_warn(dev, "error creating debugfs entries.\n");
+
 #ifdef CONFIG_PM_SLEEP
 	if (device_can_wakeup(dev) &&
 	    sysfs_merge_group(&client->dev.kobj, &cyapa_power_wakeup_group))
@@ -928,6 +1132,16 @@ static int cyapa_remove(struct i2c_client *client)
 
 	free_irq(cyapa->irq, cyapa);
 
+	debugfs_remove_recursive(cyapa->dentry_dev);
+	mutex_destroy(&cyapa->debugfs_mutex);
+
+	kfree(cyapa->fw_image);
+	cyapa->fw_image = NULL;
+	cyapa->fw_image_size = 0;
+	kfree(cyapa->tp_raw_data);
+	cyapa->tp_raw_data = NULL;
+	cyapa->tp_raw_data_size = 0;
+
 	input_unregister_device(cyapa->input);
 	if (cyapa->ops->set_power_mode)
 		cyapa->ops->set_power_mode(cyapa, PWR_MODE_OFF, 0);
@@ -1064,6 +1278,11 @@ static int __init cyapa_init(void)
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
@@ -1075,6 +1294,8 @@ static int __init cyapa_init(void)
 
 static void __exit cyapa_exit(void)
 {
+	debugfs_remove_recursive(cyapa_debugfs_root);
+
 	i2c_del_driver(&cyapa_driver);
 }
 
-- 
1.9.1


