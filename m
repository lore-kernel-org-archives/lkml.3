Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756324Ab3HQAWL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 20:22:11 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:38819 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752343Ab3HQAWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 20:22:08 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: linux-kernel@vger.kernel.org
Cc: linux-ext4@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Dave Hansen <dave.hansen@linux.intel.com>, xfs@oss.sgi.com,
        Jan Kara <jack@suse.cz>, Tim Chen <tim.c.chen@linux.intel.com>,
        Christoph Hellwig <hch@infradead.org>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH v3 2/5] fs: Add inode_update_time_writable
Date: Fri, 16 Aug 2013 16:22:09 -0700
Message-Id: <a27accc2d9460b7ef194a203f305a18dafe926e8.1376679411.git.luto@amacapital.net>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <cover.1376679411.git.luto@amacapital.net>
References: <cover.1376679411.git.luto@amacapital.net>
In-Reply-To: <cover.1376679411.git.luto@amacapital.net>
References: <cover.1376679411.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is like file_update_time, except that it acts on a struct inode *
instead of a struct file *.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 fs/inode.c         | 72 ++++++++++++++++++++++++++++++++++++++++++------------
 include/linux/fs.h |  1 +
 2 files changed, 58 insertions(+), 15 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index d6dfb09..bc90c12 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -1637,6 +1637,34 @@ int file_remove_suid(struct file *file)
 }
 EXPORT_SYMBOL(file_remove_suid);
 
+/*
+ * This does the work that's common to file_update_time and
+ * inode_update_time.
+ */
+static int prepare_update_cmtime(struct inode *inode, struct timespec *now)
+{
+	int sync_it;
+
+	/* First try to exhaust all avenues to not sync */
+	if (IS_NOCMTIME(inode))
+		return 0;
+
+	*now = current_fs_time(inode->i_sb);
+	if (!timespec_equal(&inode->i_mtime, now))
+		sync_it = S_MTIME;
+
+	if (!timespec_equal(&inode->i_ctime, now))
+		sync_it |= S_CTIME;
+
+	if (IS_I_VERSION(inode))
+		sync_it |= S_VERSION;
+
+	if (!sync_it)
+		return 0;
+
+	return sync_it;
+}
+
 /**
  *	file_update_time	-	update mtime and ctime time
  *	@file: file accessed
@@ -1654,23 +1682,9 @@ int file_update_time(struct file *file)
 {
 	struct inode *inode = file_inode(file);
 	struct timespec now;
-	int sync_it = 0;
+	int sync_it = prepare_update_cmtime(inode, &now);
 	int ret;
 
-	/* First try to exhaust all avenues to not sync */
-	if (IS_NOCMTIME(inode))
-		return 0;
-
-	now = current_fs_time(inode->i_sb);
-	if (!timespec_equal(&inode->i_mtime, &now))
-		sync_it = S_MTIME;
-
-	if (!timespec_equal(&inode->i_ctime, &now))
-		sync_it |= S_CTIME;
-
-	if (IS_I_VERSION(inode))
-		sync_it |= S_VERSION;
-
 	if (!sync_it)
 		return 0;
 
@@ -1685,6 +1699,34 @@ int file_update_time(struct file *file)
 }
 EXPORT_SYMBOL(file_update_time);
 
+/**
+ *	inode_update_time_writable	-	update mtime and ctime time
+ *	@inode: inode accessed
+ *
+ *	This is like file_update_time, but it assumes the mnt is writable
+ *	and takes an inode parameter instead.  (We need to assume the mnt
+ *	was writable because inodes aren't associated with any particular
+ *	mnt.
+ */
+
+int inode_update_time_writable(struct inode *inode)
+{
+	struct timespec now;
+	int sync_it = prepare_update_cmtime(inode, &now);
+	int ret;
+
+	if (!sync_it)
+		return 0;
+
+	/* sb_start_pagefault and update_time can both sleep. */
+	sb_start_pagefault(inode->i_sb);
+	ret = update_time(inode, &now, sync_it);
+	sb_end_pagefault(inode->i_sb);
+
+	return ret;
+}
+EXPORT_SYMBOL(inode_update_time_writable);
+
 int inode_needs_sync(struct inode *inode)
 {
 	if (IS_SYNC(inode))
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 9818747..86cf0a4 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2590,6 +2590,7 @@ extern int inode_newsize_ok(const struct inode *, loff_t offset);
 extern void setattr_copy(struct inode *inode, const struct iattr *attr);
 
 extern int file_update_time(struct file *file);
+extern int inode_update_time_writable(struct inode *inode);
 
 extern int generic_show_options(struct seq_file *m, struct dentry *root);
 extern void save_mount_options(struct super_block *sb, char *options);
-- 
1.8.3.1

