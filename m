Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753464Ab3JAVoC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 17:44:02 -0400
Received: from mail-qc0-f176.google.com ([209.85.216.176]:61143 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753205Ab3JAVma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 17:42:30 -0400
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: kay@vrfy.org, linux-kernel@vger.kernel.org, ebiederm@xmission.com,
        bhelgaas@google.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 10/15] sysfs: collapse fs/sysfs/bin.c::fill_read() into read()
Date: Tue,  1 Oct 2013 17:42:04 -0400
Message-Id: <1380663729-18243-11-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1380663729-18243-1-git-send-email-tj@kernel.org>
References: <1380663729-18243-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

read() is simple enough and fill_read() being in a separate function
doesn't add anything.  Let's collapse it into read().  This will make
merging bin file handling with regular file.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/sysfs/bin.c | 36 +++++++++++++++---------------------
 1 file changed, 15 insertions(+), 21 deletions(-)

diff --git a/fs/sysfs/bin.c b/fs/sysfs/bin.c
index d2142c0..60a4e78 100644
--- a/fs/sysfs/bin.c
+++ b/fs/sysfs/bin.c
@@ -44,30 +44,12 @@ struct bin_buffer {
 	struct hlist_node		list;
 };
 
-static int
-fill_read(struct file *file, char *buffer, loff_t off, size_t count)
+static ssize_t
+read(struct file *file, char __user *userbuf, size_t bytes, loff_t *off)
 {
 	struct sysfs_dirent *attr_sd = file->f_path.dentry->d_fsdata;
 	struct bin_attribute *attr = attr_sd->s_bin_attr.bin_attr;
 	struct kobject *kobj = attr_sd->s_parent->s_dir.kobj;
-	int rc;
-
-	/* need attr_sd for attr, its parent for kobj */
-	if (!sysfs_get_active(attr_sd))
-		return -ENODEV;
-
-	rc = -EIO;
-	if (attr->read)
-		rc = attr->read(file, kobj, attr, buffer, off, count);
-
-	sysfs_put_active(attr_sd);
-
-	return rc;
-}
-
-static ssize_t
-read(struct file *file, char __user *userbuf, size_t bytes, loff_t *off)
-{
 	struct bin_buffer *bb = file->private_data;
 	int size = file_inode(file)->i_size;
 	loff_t offs = *off;
@@ -88,8 +70,20 @@ read(struct file *file, char __user *userbuf, size_t bytes, loff_t *off)
 	if (!buf)
 		return -ENOMEM;
 
+	/* need attr_sd for attr, its parent for kobj */
 	mutex_lock(&bb->mutex);
-	count = fill_read(file, buf, offs, count);
+	if (!sysfs_get_active(attr_sd)) {
+		count = -ENODEV;
+		mutex_unlock(&bb->mutex);
+		goto out_free;
+	}
+
+	if (attr->read)
+		count = attr->read(file, kobj, attr, buf, offs, count);
+	else
+		count = -EIO;
+
+	sysfs_put_active(attr_sd);
 	mutex_unlock(&bb->mutex);
 
 	if (count < 0)
-- 
1.8.3.1

