Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752303AbaEWJoI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 05:44:08 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:50123 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040AbaEWJoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 05:44:05 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk, torvalds@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, akpm@linux-foundation.org, apw@canonical.com,
        nbd@openwrt.org, neilb@suse.de, jordipujolp@gmail.com,
        ezk@fsl.cs.sunysb.edu, dhowells@redhat.com, sedat.dilek@gmail.com,
        hooanon05@yahoo.co.jp, mszeredi@suse.cz
Subject: [PATCH 06/13] vfs: add whiteout support
Date: Fri, 23 May 2014 11:43:36 +0200
Message-Id: <1400838223-30844-7-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1400838223-30844-1-git-send-email-miklos@szeredi.hu>
References: <1400838223-30844-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Whiteout isn't actually a new file type, but is represented as a char
device (Linus's idea) with 0/0 device number.

This has several advantages compared to introducing a new whiteout file
type:

 - no userspace API changes (e.g. trivial to make backups of upper layer
   filesystem, without losing whiteouts)

 - no fs image format changes (you can boot an old kernel/fsck without
   whiteout support and things won't break)

 - implementation is trivial

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/namei.c         | 14 ++++++++++++++
 include/linux/fs.h | 11 +++++++++++
 2 files changed, 25 insertions(+)

diff --git a/fs/namei.c b/fs/namei.c
index 1039eef0e22c..413d7c138e95 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -4323,6 +4323,20 @@ SYSCALL_DEFINE2(rename, const char __user *, oldname, const char __user *, newna
 	return sys_renameat2(AT_FDCWD, oldname, AT_FDCWD, newname, 0);
 }
 
+int vfs_whiteout(struct inode *dir, struct dentry *dentry)
+{
+	int error = may_create(dir, dentry);
+	if (error)
+		return error;
+
+	if (!dir->i_op->mknod)
+		return -EPERM;
+
+	return dir->i_op->mknod(dir, dentry,
+				S_IFCHR | WHITEOUT_MODE, WHITEOUT_DEV);
+}
+EXPORT_SYMBOL(vfs_whiteout);
+
 int readlink_copy(char __user *buffer, int buflen, const char *link)
 {
 	int len = PTR_ERR(link);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 9d821253379d..88ec7a2878bc 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -221,6 +221,13 @@ typedef void (dio_iodone_t)(struct kiocb *iocb, loff_t offset,
 #define ATTR_TIMES_SET	(1 << 16)
 
 /*
+ * Whiteout is represented by a char device.  The following constants define the
+ * mode and device number to use.
+ */
+#define WHITEOUT_MODE 0
+#define WHITEOUT_DEV 0
+
+/*
  * This is the Inode Attributes structure, used for notify_change().  It
  * uses the above definitions as flags, to know which values have changed.
  * Also, in this manner, a Filesystem can look at only the values it cares
@@ -1387,6 +1394,7 @@ extern int vfs_link(struct dentry *, struct inode *, struct dentry *, struct ino
 extern int vfs_rmdir(struct inode *, struct dentry *);
 extern int vfs_unlink(struct inode *, struct dentry *, struct inode **);
 extern int vfs_rename(struct inode *, struct dentry *, struct inode *, struct dentry *, struct inode **, unsigned int);
+extern int vfs_whiteout(struct inode *, struct dentry *);
 
 /*
  * VFS dentry helper functions.
@@ -1611,6 +1619,9 @@ struct super_operations {
 #define IS_AUTOMOUNT(inode)	((inode)->i_flags & S_AUTOMOUNT)
 #define IS_NOSEC(inode)		((inode)->i_flags & S_NOSEC)
 
+#define IS_WHITEOUT(inode)	(S_ISCHR(inode->i_mode) && \
+				 (inode)->i_rdev == WHITEOUT_DEV)
+
 /*
  * Inode state bits.  Protected by inode->i_lock
  *
-- 
1.8.1.4

