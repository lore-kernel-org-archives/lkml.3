Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752423AbaJKQCM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 12:02:12 -0400
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:60485 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196AbaJKQCL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 12:02:11 -0400
X-IronPort-AV: E=Sophos;i="5.04,698,1406617200"; 
   d="scan'208";a="47833987"
From: Arend van Spriel <arend@broadcom.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <linux-kernel@vger.kernel.org>, Arend van Spriel <arend@broadcom.com>
Subject: [PATCH] debugfs: add helper function to create device related seq_file
Date: Sat, 11 Oct 2014 18:01:55 +0200
Message-ID: <1413043315-22332-1-git-send-email-arend@broadcom.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a helper function that simplifies adding a
sequence file for device drivers. The calling device driver
needs to provide a read function and a device pointer. The
field struct seq_file::private will reference the device
pointer upon call to the read function so the driver can
obtain his data from it and do its seq_printf() calls.

Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 fs/debugfs/file.c       | 54 +++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/debugfs.h | 16 ++++++++++++++-
 2 files changed, 69 insertions(+), 1 deletion(-)

diff --git a/fs/debugfs/file.c b/fs/debugfs/file.c
index 76c08c2..088b3fc 100644
--- a/fs/debugfs/file.c
+++ b/fs/debugfs/file.c
@@ -22,6 +22,7 @@
 #include <linux/io.h>
 #include <linux/slab.h>
 #include <linux/atomic.h>
+#include <linux/device.h>
 
 static ssize_t default_read_file(struct file *file, char __user *buf,
 				 size_t count, loff_t *ppos)
@@ -761,3 +762,56 @@ struct dentry *debugfs_create_regset32(const char *name, umode_t mode,
 EXPORT_SYMBOL_GPL(debugfs_create_regset32);
 
 #endif /* CONFIG_HAS_IOMEM */
+
+struct debugfs_devm_entry {
+	int (*read)(struct seq_file *seq, void *data);
+	struct device *dev;
+};
+
+static int debugfs_devm_entry_open(struct inode *inode, struct file *f)
+{
+	struct debugfs_devm_entry *entry = inode->i_private;
+
+	return single_open(f, entry->read, entry->dev);
+}
+
+static const struct file_operations debugfs_devm_entry_ops = {
+	.owner = THIS_MODULE,
+	.open = debugfs_devm_entry_open,
+	.release = single_release,
+	.read = seq_read,
+	.llseek = seq_lseek
+};
+
+/**
+ * debugfs_create_devm_seqfile - create a debugfs file that is bound to device.
+ *
+ * @dev: device related to this debugfs file.
+ * @name: name of the debugfs file.
+ * @parent: a pointer to the parent dentry for this file.  This should be a
+ *	directory dentry if set.  If this parameter is %NULL, then the
+ *	file will be created in the root of the debugfs filesystem.
+ * @read_fn: function pointer called to print the seq_file content.
+ */
+struct dentry *debugfs_create_devm_seqfile(struct device *dev, const char *name,
+					   struct dentry *parent,
+					   int (*read_fn)(struct seq_file *s,
+					   	   	  void *data))
+{
+	struct debugfs_devm_entry *entry;
+
+	if (IS_ERR(parent))
+		return ERR_PTR(-ENOENT);
+
+	entry = devm_kzalloc(dev, sizeof(*entry), GFP_KERNEL);
+	if (!entry)
+		return ERR_PTR(-ENOMEM);
+
+	entry->read = read_fn;
+	entry->dev = dev;
+
+	return debugfs_create_file(name, S_IRUGO, parent, entry,
+				   &debugfs_devm_entry_ops);
+}
+EXPORT_SYMBOL_GPL(debugfs_create_devm_seqfile);
+
diff --git a/include/linux/debugfs.h b/include/linux/debugfs.h
index 4d0b4d1..f8c0db4 100644
--- a/include/linux/debugfs.h
+++ b/include/linux/debugfs.h
@@ -99,13 +99,18 @@ struct dentry *debugfs_create_u32_array(const char *name, umode_t mode,
 					struct dentry *parent,
 					u32 *array, u32 elements);
 
+struct dentry *debugfs_create_devm_seqfile(struct device *dev, const char *name,
+					   struct dentry *parent,
+					   int (*read_fn)(struct seq_file *s,
+					   	   	  void *data));
+
 bool debugfs_initialized(void);
 
 #else
 
 #include <linux/err.h>
 
-/* 
+/*
  * We do not return NULL from these functions if CONFIG_DEBUG_FS is not enabled
  * so users have a chance to detect if there was a real error or not.  We don't
  * want to duplicate the design decision mistakes of procfs and devfs again.
@@ -251,6 +256,15 @@ static inline struct dentry *debugfs_create_u32_array(const char *name, umode_t
 	return ERR_PTR(-ENODEV);
 }
 
+static inline struct dentry *debugfs_create_devm_seqfile(struct device *dev,
+							 const char *name,
+							 struct dentry *parent,
+					   int (*read_fn)(struct seq_file *s,
+					   	   	  void *data))
+{
+	return ERR_PTR(-ENODEV);
+}
+
 #endif
 
 #endif
-- 
1.9.1

