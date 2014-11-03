Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752370AbaKCIhZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 03:37:25 -0500
Received: from mail-pd0-f173.google.com ([209.85.192.173]:58825 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892AbaKCIhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 03:37:20 -0500
From: Dudley Du <dudley.dulixin@gmail.com>
X-Google-Original-From: Dudley Du <dudl@cypress.com>
To: dmitry.torokhov@gmail.com, rydberg@euromail.se
Cc: Dudley Du <dudl@cypress.com>, bleung@google.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v9 17/18] input: cyapa: add read sensors raw data debugfs interface support
Date: Mon,  3 Nov 2014 16:33:09 +0800
Message-Id: <1415003590-30485-18-git-send-email-dudl@cypress.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415003590-30485-1-git-send-email-dudl@cypress.com>
References: <1415003590-30485-1-git-send-email-dudl@cypress.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add read sensors' raw data from trackpad device interface supported in cyapa
driver through debugfs raw_data interface.
Through this interface, user can read difference count map of each sensors
directly from trackpad device (some customers want). And it's useful to help
users to find out the root cause when there is performance gap happened.
TEST=test on Chromebooks.

Signed-off-by: Dudley Du <dudl@cypress.com>
---
 drivers/input/mouse/cyapa.c | 89 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/input/mouse/cyapa.h |  4 ++
 2 files changed, 93 insertions(+)

diff --git a/drivers/input/mouse/cyapa.c b/drivers/input/mouse/cyapa.c
index bc1d75a..e200beb 100644
--- a/drivers/input/mouse/cyapa.c
+++ b/drivers/input/mouse/cyapa.c
@@ -577,6 +577,91 @@ static const struct file_operations cyapa_read_fw_fops = {
 	.read = cyapa_debugfs_read_fw
 };
 
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
+	int ret;
+	struct cyapa *cyapa = file->private_data;
+
+	ret = mutex_lock_interruptible(&cyapa->state_sync_lock);
+	if (ret)
+		return ret;
+
+	if (cyapa->ops->read_raw_data)
+		ret = cyapa->ops->read_raw_data(cyapa);
+	else
+		ret = -EPERM;
+	mutex_unlock(&cyapa->state_sync_lock);
+	if (ret)
+		return ret;
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
 static int cyapa_debugfs_init(struct cyapa *cyapa)
 {
 	struct device *dev = &cyapa->client->dev;
@@ -595,6 +680,10 @@ static int cyapa_debugfs_init(struct cyapa *cyapa)
 	debugfs_create_file(CYAPA_DEBUGFS_READ_FW, S_IRUSR, cyapa->dentry_dev,
 			    cyapa, &cyapa_read_fw_fops);
 
+	if (cyapa->gen >= CYAPA_GEN5)
+		debugfs_create_file(CYAPA_DEBUGFS_RAW_DATA, S_IRUSR,
+			cyapa->dentry_dev, cyapa, &cyapa_read_raw_data_fops);
+
 	return 0;
 }
 
diff --git a/drivers/input/mouse/cyapa.h b/drivers/input/mouse/cyapa.h
index 288c7de..75b0c33 100644
--- a/drivers/input/mouse/cyapa.h
+++ b/drivers/input/mouse/cyapa.h
@@ -190,6 +190,7 @@ struct cyapa_dev_ops {
 			struct device_attribute *, const char *, size_t);
 
 	int (*read_fw)(struct cyapa *);
+	int (*read_raw_data)(struct cyapa *);
 
 	int (*initialize)(struct cyapa *cyapa);
 
@@ -298,6 +299,9 @@ struct cyapa {
 	struct cyapa_tsg_bin_image_head fw_img_head;
 	u8 *fw_image;
 	size_t fw_image_size;
+	/* Buffer to store sensors' raw data */
+	u8 *tp_raw_data;
+	size_t tp_raw_data_size;
 
 	const struct cyapa_dev_ops *ops;
 
-- 
1.9.1

