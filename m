Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932599AbaLKMr1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 07:47:27 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:40140 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757338AbaLKMr0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 07:47:26 -0500
From: Ganesh Mahendran <opensource.ganesh@gmail.com>
To: gregkh@linuxfoundation.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Ganesh Mahendran <opensource.ganesh@gmail.com>
Subject: [PATCH] fs/debugfs: add get/set for atomic_long types
Date: Thu, 11 Dec 2014 20:47:10 +0800
Message-Id: <1418302030-11428-1-git-send-email-opensource.ganesh@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

debugfs currently can not create attributes that set/get
atomic_long_t values.

This patch adds support for this through a new
debugfs_create_atomic_long_t() function.

Signed-off-by: Ganesh Mahendran <opensource.ganesh@gmail.com>
---
 fs/debugfs/file.c       |   45 +++++++++++++++++++++++++++++++++++++++++++++
 include/linux/debugfs.h |    2 ++
 2 files changed, 47 insertions(+)

diff --git a/fs/debugfs/file.c b/fs/debugfs/file.c
index 76c08c2..65a1b53 100644
--- a/fs/debugfs/file.c
+++ b/fs/debugfs/file.c
@@ -446,6 +446,51 @@ struct dentry *debugfs_create_atomic_t(const char *name, umode_t mode,
 }
 EXPORT_SYMBOL_GPL(debugfs_create_atomic_t);
 
+static int debugfs_atomic_long_t_set(void *data, u64 val)
+{
+	atomic_long_set((atomic_long_t *)data, val);
+	return 0;
+}
+static int debugfs_atomic_long_t_get(void *data, u64 *val)
+{
+	*val = atomic_long_read((atomic_long_t *)data);
+	return 0;
+}
+DEFINE_SIMPLE_ATTRIBUTE(fops_atomic_long_t, debugfs_atomic_long_t_get,
+			debugfs_atomic_long_t_set, "%lld\n");
+DEFINE_SIMPLE_ATTRIBUTE(fops_atomic_long_t_ro, debugfs_atomic_long_t_get,
+			NULL, "%lld\n");
+DEFINE_SIMPLE_ATTRIBUTE(fops_atomic_long_t_wo, NULL, debugfs_atomic_long_t_set,
+			"%lld\n");
+
+/**
+ * debugfs_create_atomic_long_t - create a debugfs file that is used to read and
+ * write an atomic_long_t value
+ * @name: a pointer to a string containing the name of the file to create.
+ * @mode: the permission that the file should have
+ * @parent: a pointer to the parent dentry for this file.  This should be a
+ *          directory dentry if set.  If this parameter is %NULL, then the
+ *          file will be created in the root of the debugfs filesystem.
+ * @value: a pointer to the variable that the file should read to and write
+ *         from.
+ */
+struct dentry *debugfs_create_atomic_long_t(const char *name, umode_t mode,
+				 struct dentry *parent, atomic_long_t *value)
+{
+	/* if there are no write bits set, make read only */
+	if (!(mode & S_IWUGO))
+		return debugfs_create_file(name, mode, parent, value,
+					&fops_atomic_long_t_ro);
+	/* if there are no read bits set, make write only */
+	if (!(mode & S_IRUGO))
+		return debugfs_create_file(name, mode, parent, value,
+					&fops_atomic_long_t_wo);
+
+	return debugfs_create_file(name, mode, parent, value,
+					&fops_atomic_long_t);
+}
+EXPORT_SYMBOL_GPL(debugfs_create_atomic_long_t);
+
 static ssize_t read_file_bool(struct file *file, char __user *user_buf,
 			      size_t count, loff_t *ppos)
 {
diff --git a/include/linux/debugfs.h b/include/linux/debugfs.h
index 4d0b4d1..b759231 100644
--- a/include/linux/debugfs.h
+++ b/include/linux/debugfs.h
@@ -81,6 +81,8 @@ struct dentry *debugfs_create_size_t(const char *name, umode_t mode,
 				     struct dentry *parent, size_t *value);
 struct dentry *debugfs_create_atomic_t(const char *name, umode_t mode,
 				     struct dentry *parent, atomic_t *value);
+struct dentry *debugfs_create_atomic_long_t(const char *name, umode_t mode,
+				 struct dentry *parent, atomic_long_t *value);
 struct dentry *debugfs_create_bool(const char *name, umode_t mode,
 				  struct dentry *parent, u32 *value);
 
-- 
1.7.9.5

