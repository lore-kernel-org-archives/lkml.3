Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965063AbaKNGHd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 01:07:33 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:62047 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754128AbaKNGH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 01:07:27 -0500
From: Dudley Du <dudley.dulixin@gmail.com>
X-Google-Original-From: Dudley Du <dudl@cypress.com>
To: dmitry.torokhov@gmail.com, rydberg@euromail.se
Cc: Dudley Du <dudl@cypress.com>, bleung@google.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v10 17/18] input: cyapa: add read sensors raw data debugfs interface support
Date: Fri, 14 Nov 2014 14:03:23 +0800
Message-Id: <1415945004-19868-18-git-send-email-dudl@cypress.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415945004-19868-1-git-send-email-dudl@cypress.com>
References: <1415945004-19868-1-git-send-email-dudl@cypress.com>
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
 drivers/input/mouse/cyapa.c | 90 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/input/mouse/cyapa.h |  4 ++
 2 files changed, 94 insertions(+)

diff --git a/drivers/input/mouse/cyapa.c b/drivers/input/mouse/cyapa.c
index 5c07ac0..8523f40 100644
--- a/drivers/input/mouse/cyapa.c
+++ b/drivers/input/mouse/cyapa.c
@@ -34,6 +34,7 @@
 #define CYAPA_ADAPTER_FUNC_BOTH   3
 
 #define CYAPA_DEBUGFS_READ_FW	"read_fw"
+#define CYAPA_DEBUGFS_RAW_DATA	"raw_data"
 #define CYAPA_FW_NAME		"cyapa.bin"
 
 const char unique_str[] = "CYTRA";
@@ -580,6 +581,91 @@ static const struct file_operations cyapa_read_fw_fops = {
 	.read = cyapa_debugfs_read_fw
 };
 
+static int cyapa_debugfs_raw_data_open(struct inode *inode, struct file *file)
+{
+	struct cyapa *cyapa = inode->i_private;
+	int error;
+
+	if (!cyapa)
+		return -ENODEV;
+
+	/* Start to be supported after Gen5 trackpad devices. */
+	if (cyapa->gen < CYAPA_GEN5)
+		return -ENOTSUPP;
+
+	error = mutex_lock_interruptible(&cyapa->debugfs_mutex);
+	if (error)
+		return error;
+
+	if (!get_device(&cyapa->client->dev)) {
+		error = -ENODEV;
+		goto out;
+	}
+
+	file->private_data = cyapa;
+out:
+	mutex_unlock(&cyapa->debugfs_mutex);
+	return error;
+}
+
+static int cyapa_debugfs_raw_data_release(struct inode *inode,
+				struct file *file)
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
+/* Always return the sensors' latest raw data from trackpad device. */
+static ssize_t cyapa_debugfs_read_raw_data(struct file *file,
+				     char __user *buffer,
+				     size_t count, loff_t *ppos)
+{
+	int error;
+	struct cyapa *cyapa = file->private_data;
+
+	error = mutex_lock_interruptible(&cyapa->state_sync_lock);
+	if (error)
+		return error;
+
+	if (cyapa->ops->read_raw_data)
+		error = cyapa->ops->read_raw_data(cyapa);
+	else
+		error = -EPERM;
+	mutex_unlock(&cyapa->state_sync_lock);
+	if (error)
+		return error;
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
@@ -598,6 +684,10 @@ static int cyapa_debugfs_init(struct cyapa *cyapa)
 	debugfs_create_file(CYAPA_DEBUGFS_READ_FW, S_IRUSR, cyapa->dentry_dev,
 			    cyapa, &cyapa_read_fw_fops);
 
+	if (cyapa->gen >= CYAPA_GEN5)
+		debugfs_create_file(CYAPA_DEBUGFS_RAW_DATA, S_IRUSR,
+			cyapa->dentry_dev, cyapa, &cyapa_read_raw_data_fops);
+
 	return 0;
 }
 
diff --git a/drivers/input/mouse/cyapa.h b/drivers/input/mouse/cyapa.h
index 6a18be3..4f22b38 100644
--- a/drivers/input/mouse/cyapa.h
+++ b/drivers/input/mouse/cyapa.h
@@ -187,6 +187,7 @@ struct cyapa_dev_ops {
 			struct device_attribute *, const char *, size_t);
 
 	int (*read_fw)(struct cyapa *);
+	int (*read_raw_data)(struct cyapa *);
 
 	int (*initialize)(struct cyapa *cyapa);
 
@@ -307,6 +308,9 @@ struct cyapa {
 	struct cyapa_tsg_bin_image_head fw_img_head;
 	u8 *fw_image;
 	size_t fw_image_size;
+	/* Buffer to store sensors' raw data */
+	u8 *tp_raw_data;
+	size_t tp_raw_data_size;
 
 	const struct cyapa_dev_ops *ops;
 
-- 
1.9.1

