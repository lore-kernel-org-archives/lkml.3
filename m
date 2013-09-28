Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755255Ab3I1VuX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 17:50:23 -0400
Received: from mail-qe0-f48.google.com ([209.85.128.48]:63703 "EHLO
	mail-qe0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755175Ab3I1Vtv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 17:49:51 -0400
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: kay@vrfy.org, linux-kernel@vger.kernel.org, ebiederm@xmission.com,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 03/14] sysfs: remove sysfs_buffer->ops
Date: Sat, 28 Sep 2013 17:49:33 -0400
Message-Id: <1380404984-31858-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1380404984-31858-1-git-send-email-tj@kernel.org>
References: <1380404984-31858-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, sysfs_ops is fetched during sysfs_open_file() and cached in
sysfs_buffer->ops to be used while the file is open.  This patch
removes the caching and makes each operation directly fetch sysfs_ops.

This patch doesn't introduce any behavior difference and is to prepare
for merging regular and bin file supports.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/sysfs/file.c | 33 +++++++++++++++++++++------------
 1 file changed, 21 insertions(+), 12 deletions(-)

diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index e2fafc0..7dfcc33 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -45,12 +45,23 @@ struct sysfs_open_dirent {
 struct sysfs_buffer {
 	size_t			count;
 	char			*page;
-	const struct sysfs_ops	*ops;
 	struct mutex		mutex;
 	int			event;
 	struct list_head	list;
 };
 
+/*
+ * Determine ktype->sysfs_ops for the given sysfs_dirent.  This function
+ * must be called while holding an active reference.
+ */
+static const struct sysfs_ops *sysfs_file_ops(struct sysfs_dirent *sd)
+{
+	struct kobject *kobj = sd->s_parent->s_dir.kobj;
+
+	lockdep_assert_held(sd);
+	return kobj->ktype ? kobj->ktype->sysfs_ops : NULL;
+}
+
 /**
  *	fill_read_buffer - allocate and fill buffer from object.
  *	@dentry:	dentry pointer.
@@ -66,7 +77,7 @@ static int fill_read_buffer(struct dentry *dentry, struct sysfs_buffer *buffer)
 {
 	struct sysfs_dirent *attr_sd = dentry->d_fsdata;
 	struct kobject *kobj = attr_sd->s_parent->s_dir.kobj;
-	const struct sysfs_ops *ops = buffer->ops;
+	const struct sysfs_ops *ops;
 	int ret = 0;
 	ssize_t count;
 
@@ -80,6 +91,8 @@ static int fill_read_buffer(struct dentry *dentry, struct sysfs_buffer *buffer)
 		return -ENODEV;
 
 	buffer->event = atomic_read(&attr_sd->s_attr.open->event);
+
+	ops = sysfs_file_ops(attr_sd);
 	count = ops->show(kobj, attr_sd->s_attr.attr, buffer->page);
 
 	sysfs_put_active(attr_sd);
@@ -191,13 +204,14 @@ static int flush_write_buffer(struct dentry *dentry,
 {
 	struct sysfs_dirent *attr_sd = dentry->d_fsdata;
 	struct kobject *kobj = attr_sd->s_parent->s_dir.kobj;
-	const struct sysfs_ops *ops = buffer->ops;
+	const struct sysfs_ops *ops;
 	int rc;
 
 	/* need attr_sd for attr and ops, its parent for kobj */
 	if (!sysfs_get_active(attr_sd))
 		return -ENODEV;
 
+	ops = sysfs_file_ops(attr_sd);
 	rc = ops->store(kobj, attr_sd->s_attr.attr, buffer->page, count);
 
 	sysfs_put_active(attr_sd);
@@ -205,7 +219,6 @@ static int flush_write_buffer(struct dentry *dentry,
 	return rc;
 }
 
-
 /**
  *	sysfs_write_file - write an attribute.
  *	@file:	file pointer
@@ -334,14 +347,11 @@ static int sysfs_open_file(struct inode *inode, struct file *file)
 		return -ENODEV;
 
 	/* every kobject with an attribute needs a ktype assigned */
-	if (kobj->ktype && kobj->ktype->sysfs_ops)
-		ops = kobj->ktype->sysfs_ops;
-	else {
-		WARN(1, KERN_ERR
-		     "missing sysfs attribute operations for kobject: %s\n",
-		     kobject_name(kobj));
+	ops = sysfs_file_ops(attr_sd);
+	if (WARN(!ops, KERN_ERR
+		 "missing sysfs attribute operations for kobject: %s\n",
+		 kobject_name(kobj)))
 		goto err_out;
-	}
 
 	/* File needs write support.
 	 * The inode's perms must say it's ok,
@@ -370,7 +380,6 @@ static int sysfs_open_file(struct inode *inode, struct file *file)
 		goto err_out;
 
 	mutex_init(&buffer->mutex);
-	buffer->ops = ops;
 	file->private_data = buffer;
 
 	/* make sure we have open dirent struct */
-- 
1.8.3.1

