Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753342Ab3JAVmm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 17:42:42 -0400
Received: from mail-qc0-f175.google.com ([209.85.216.175]:62210 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753257Ab3JAVmh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 17:42:37 -0400
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: kay@vrfy.org, linux-kernel@vger.kernel.org, ebiederm@xmission.com,
        bhelgaas@google.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 14/15] sysfs: prepare open path for unified regular / bin file handling
Date: Tue,  1 Oct 2013 17:42:08 -0400
Message-Id: <1380663729-18243-15-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1380663729-18243-1-git-send-email-tj@kernel.org>
References: <1380663729-18243-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sysfs bin file handling will be merged into the regular file support.
This patch prepares the open path.

This patch updates sysfs_open_file() such that it can handle both
regular and bin files.

This is a preparation and the new bin file path isn't used yet.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/sysfs/file.c | 58 ++++++++++++++++++++++++++++++++-------------------------
 1 file changed, 33 insertions(+), 25 deletions(-)

diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index 02797a1..417d005 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -610,38 +610,40 @@ static int sysfs_open_file(struct inode *inode, struct file *file)
 	struct sysfs_dirent *attr_sd = file->f_path.dentry->d_fsdata;
 	struct kobject *kobj = attr_sd->s_parent->s_dir.kobj;
 	struct sysfs_open_file *of;
-	const struct sysfs_ops *ops;
+	bool has_read, has_write;
 	int error = -EACCES;
 
 	/* need attr_sd for attr and ops, its parent for kobj */
 	if (!sysfs_get_active(attr_sd))
 		return -ENODEV;
 
-	/* every kobject with an attribute needs a ktype assigned */
-	ops = sysfs_file_ops(attr_sd);
-	if (WARN(!ops, KERN_ERR
-		 "missing sysfs attribute operations for kobject: %s\n",
-		 kobject_name(kobj)))
-		goto err_out;
+	if (sysfs_is_bin(attr_sd)) {
+		struct bin_attribute *battr = attr_sd->s_bin_attr.bin_attr;
 
-	/* File needs write support.
-	 * The inode's perms must say it's ok,
-	 * and we must have a store method.
-	 */
-	if (file->f_mode & FMODE_WRITE) {
-		if (!(inode->i_mode & S_IWUGO) || !ops->store)
-			goto err_out;
-	}
+		has_read = battr->read || battr->mmap;
+		has_write = battr->write || battr->mmap;
+	} else {
+		const struct sysfs_ops *ops = sysfs_file_ops(attr_sd);
 
-	/* File needs read support.
-	 * The inode's perms must say it's ok, and we there
-	 * must be a show method for it.
-	 */
-	if (file->f_mode & FMODE_READ) {
-		if (!(inode->i_mode & S_IRUGO) || !ops->show)
+		/* every kobject with an attribute needs a ktype assigned */
+		if (WARN(!ops, KERN_ERR
+			 "missing sysfs attribute operations for kobject: %s\n",
+			 kobject_name(kobj)))
 			goto err_out;
+
+		has_read = ops->show;
+		has_write = ops->store;
 	}
 
+	/* check perms and supported operations */
+	if ((file->f_mode & FMODE_WRITE) &&
+	    (!(inode->i_mode & S_IWUGO) || !has_write))
+		goto err_out;
+
+	if ((file->f_mode & FMODE_READ) &&
+	    (!(inode->i_mode & S_IRUGO) || !has_read))
+		goto err_out;
+
 	/* allocate a sysfs_open_file for the file */
 	error = -ENOMEM;
 	of = kzalloc(sizeof(struct sysfs_open_file), GFP_KERNEL);
@@ -653,11 +655,14 @@ static int sysfs_open_file(struct inode *inode, struct file *file)
 	of->file = file;
 
 	/*
-	 * Always instantiate seq_file even if read access is not
-	 * implemented or requested.  This unifies private data access and
-	 * most files are readable anyway.
+	 * Always instantiate seq_file even if read access doesn't use
+	 * seq_file or is not requested.  This unifies private data access
+	 * and readable regular files are the vast majority anyway.
 	 */
-	error = single_open(file, sysfs_seq_show, of);
+	if (sysfs_is_bin(attr_sd))
+		error = single_open(file, NULL, of);
+	else
+		error = single_open(file, sysfs_seq_show, of);
 	if (error)
 		goto err_free;
 
@@ -807,6 +812,9 @@ const struct file_operations sysfs_bin_operations = {
 	.write		= sysfs_write_file,
 	.llseek		= generic_file_llseek,
 	.mmap		= sysfs_bin_mmap,
+	.open		= sysfs_open_file,
+	.release	= sysfs_release,
+	.poll		= sysfs_poll,
 };
 
 int sysfs_add_file_mode_ns(struct sysfs_dirent *dir_sd,
-- 
1.8.3.1

