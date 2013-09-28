Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755318Ab3I1Vue (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 17:50:34 -0400
Received: from mail-qa0-f43.google.com ([209.85.216.43]:52924 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755184Ab3I1Vtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 17:49:55 -0400
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: kay@vrfy.org, linux-kernel@vger.kernel.org, ebiederm@xmission.com,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 06/14] sysfs: add sysfs_open_file->sd and ->file
Date: Sat, 28 Sep 2013 17:49:36 -0400
Message-Id: <1380404984-31858-7-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1380404984-31858-1-git-send-email-tj@kernel.org>
References: <1380404984-31858-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sysfs will be converted to use seq_file for read path, which will make
it difficult to pass around multiple pointers directly.  This patch
adds sysfs_open_file->sd and ->file so that we can reach all the
necessary data structures from sysfs_open_file.

flush_write_buffer() is updated to drop @dentry which was used to
discover the sysfs_dirent as it's now available through
sysfs_open_file->sd.

This patch doesn't cause any behavior difference.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/sysfs/file.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index 4b55bcf..af6e909 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -45,6 +45,8 @@ struct sysfs_open_dirent {
 };
 
 struct sysfs_open_file {
+	struct sysfs_dirent	*sd;
+	struct file		*file;
 	size_t			count;
 	char			*page;
 	struct mutex		mutex;
@@ -192,7 +194,6 @@ static int fill_write_buffer(struct sysfs_open_file *of,
 
 /**
  *	flush_write_buffer - push buffer to kobject.
- *	@dentry:	dentry to the attribute
  *	@of:		open file
  *	@count:		number of bytes
  *
@@ -200,22 +201,20 @@ static int fill_write_buffer(struct sysfs_open_file *of,
  *	dealing with, then call the store() method for the attribute,
  *	passing the buffer that we acquired in fill_write_buffer().
  */
-static int flush_write_buffer(struct dentry *dentry,
-			      struct sysfs_open_file *of, size_t count)
+static int flush_write_buffer(struct sysfs_open_file *of, size_t count)
 {
-	struct sysfs_dirent *attr_sd = dentry->d_fsdata;
-	struct kobject *kobj = attr_sd->s_parent->s_dir.kobj;
+	struct kobject *kobj = of->sd->s_parent->s_dir.kobj;
 	const struct sysfs_ops *ops;
 	int rc;
 
-	/* need attr_sd for attr and ops, its parent for kobj */
-	if (!sysfs_get_active(attr_sd))
+	/* need @of->sd for attr and ops, its parent for kobj */
+	if (!sysfs_get_active(of->sd))
 		return -ENODEV;
 
-	ops = sysfs_file_ops(attr_sd);
-	rc = ops->store(kobj, attr_sd->s_attr.attr, of->page, count);
+	ops = sysfs_file_ops(of->sd);
+	rc = ops->store(kobj, of->sd->s_attr.attr, of->page, count);
 
-	sysfs_put_active(attr_sd);
+	sysfs_put_active(of->sd);
 
 	return rc;
 }
@@ -245,7 +244,7 @@ static ssize_t sysfs_write_file(struct file *file, const char __user *buf,
 	mutex_lock(&of->mutex);
 	len = fill_write_buffer(of, buf, count);
 	if (len > 0)
-		len = flush_write_buffer(file->f_path.dentry, of, len);
+		len = flush_write_buffer(of, len);
 	if (len > 0)
 		*ppos += len;
 	mutex_unlock(&of->mutex);
@@ -385,6 +384,8 @@ static int sysfs_open_file(struct inode *inode, struct file *file)
 		goto err_out;
 
 	mutex_init(&of->mutex);
+	of->sd = attr_sd;
+	of->file = file;
 	file->private_data = of;
 
 	/* make sure we have open dirent struct */
-- 
1.8.3.1

