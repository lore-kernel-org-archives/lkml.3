Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755448Ab3I1VvE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 17:51:04 -0400
Received: from mail-qa0-f45.google.com ([209.85.216.45]:63426 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755207Ab3I1VuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 17:50:04 -0400
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: kay@vrfy.org, linux-kernel@vger.kernel.org, ebiederm@xmission.com,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 13/14] sysfs: prepare open path for unified regular / bin file handling
Date: Sat, 28 Sep 2013 17:49:43 -0400
Message-Id: <1380404984-31858-14-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1380404984-31858-1-git-send-email-tj@kernel.org>
References: <1380404984-31858-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sysfs bin file handling will be merged into the regular file support.
All three access paths - read, write and mmap - can now handle both
regular and bin files.  This patch updates sysfs_open_file() and
sysfs_release() such that they can handle both regular and bin files.

This is a preparation and the new bin file path isn't used yet.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/sysfs/file.c | 61 ++++++++++++++++++++++++++++++++++-----------------------
 1 file changed, 37 insertions(+), 24 deletions(-)

diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index fe5c440..723f78c 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -638,38 +638,40 @@ static int sysfs_open_file(struct inode *inode, struct file *file)
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
@@ -685,10 +687,15 @@ static int sysfs_open_file(struct inode *inode, struct file *file)
 	 * implemented or requested.  This unifies private data access and
 	 * most files are readable anyway.
 	 */
-	error = single_open(file, sysfs_seq_show, of);
+	if (sysfs_is_bin(attr_sd))
+		error = seq_open(file, &sysfs_bin_seq_ops);
+	else
+		error = single_open(file, sysfs_seq_show, NULL);
 	if (error)
 		goto err_free;
 
+	((struct seq_file *)file->private_data)->private = of;
+
 	/* seq_file clears PWRITE unconditionally, restore it if WRITE */
 	if (file->f_mode & FMODE_WRITE)
 		file->f_mode |= FMODE_PWRITE;
@@ -703,7 +710,10 @@ static int sysfs_open_file(struct inode *inode, struct file *file)
 	return 0;
 
 err_close:
-	single_release(inode, file);
+	if (sysfs_is_bin(attr_sd))
+		seq_release(inode, file);
+	else
+		single_release(inode, file);
 err_free:
 	kfree(of);
 err_out:
@@ -717,7 +727,10 @@ static int sysfs_release(struct inode *inode, struct file *filp)
 	struct sysfs_open_file *of = sysfs_of(filp);
 
 	sysfs_put_open_dirent(sd, of);
-	single_release(inode, filp);
+	if (sysfs_is_bin(sd))
+		seq_release(inode, filp);
+	else
+		single_release(inode, filp);
 	kfree(of);
 
 	return 0;
-- 
1.8.3.1

