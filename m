Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757150AbaGWNSG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 09:18:06 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:53511 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755572AbaGWNQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 09:16:01 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: linux-kernel@vger.kernel.org, hch@infradead.org, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org
Cc: Miklos Szeredi <mszeredi@suse.cz>, Richard Weinberger <richard@nod.at>
Subject: [PATCH 6/7] hostfs: support rename flags
Date: Wed, 23 Jul 2014 15:15:35 +0200
Message-Id: <1406121336-1379-7-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1406121336-1379-1-git-send-email-miklos@szeredi.hu>
References: <1406121336-1379-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Support RENAME_NOREPLACE and RENAME_EXCHANGE flags on hostfs if the
underlying filesystem supports it.

Since renameat2(2) is not yet in any libc, use syscall(2) to invoke the
renameat2 syscall.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Richard Weinberger <richard@nod.at>
---
 fs/hostfs/hostfs.h      |  1 +
 fs/hostfs/hostfs_kern.c | 30 ++++++++++++++++++++----------
 fs/hostfs/hostfs_user.c | 28 ++++++++++++++++++++++++++++
 3 files changed, 49 insertions(+), 10 deletions(-)

diff --git a/fs/hostfs/hostfs.h b/fs/hostfs/hostfs.h
index 9c88da0e855a..4fcd40d6f308 100644
--- a/fs/hostfs/hostfs.h
+++ b/fs/hostfs/hostfs.h
@@ -89,6 +89,7 @@ extern int do_mknod(const char *file, int mode, unsigned int major,
 extern int link_file(const char *from, const char *to);
 extern int hostfs_do_readlink(char *file, char *buf, int size);
 extern int rename_file(char *from, char *to);
+extern int rename2_file(char *from, char *to, unsigned int flags);
 extern int do_statfs(char *root, long *bsize_out, long long *blocks_out,
 		     long long *bfree_out, long long *bavail_out,
 		     long long *files_out, long long *ffree_out,
diff --git a/fs/hostfs/hostfs_kern.c b/fs/hostfs/hostfs_kern.c
index bb529f3b7f2b..fd62cae0fdcb 100644
--- a/fs/hostfs/hostfs_kern.c
+++ b/fs/hostfs/hostfs_kern.c
@@ -741,21 +741,31 @@ static int hostfs_mknod(struct inode *dir, struct dentry *dentry, umode_t mode,
 	return err;
 }
 
-static int hostfs_rename(struct inode *from_ino, struct dentry *from,
-			 struct inode *to_ino, struct dentry *to)
+static int hostfs_rename2(struct inode *old_dir, struct dentry *old_dentry,
+			  struct inode *new_dir, struct dentry *new_dentry,
+			  unsigned int flags)
 {
-	char *from_name, *to_name;
+	char *old_name, *new_name;
 	int err;
 
-	if ((from_name = dentry_name(from)) == NULL)
+	if (flags & ~(RENAME_NOREPLACE | RENAME_EXCHANGE))
+		return -EINVAL;
+
+	old_name = dentry_name(old_dentry);
+	if (old_name == NULL)
 		return -ENOMEM;
-	if ((to_name = dentry_name(to)) == NULL) {
-		__putname(from_name);
+	new_name = dentry_name(new_dentry);
+	if (new_name == NULL) {
+		__putname(old_name);
 		return -ENOMEM;
 	}
-	err = rename_file(from_name, to_name);
-	__putname(from_name);
-	__putname(to_name);
+	if (!flags)
+		err = rename_file(old_name, new_name);
+	else
+		err = rename2_file(old_name, new_name, flags);
+
+	__putname(old_name);
+	__putname(new_name);
 	return err;
 }
 
@@ -867,7 +877,7 @@ static const struct inode_operations hostfs_dir_iops = {
 	.mkdir		= hostfs_mkdir,
 	.rmdir		= hostfs_rmdir,
 	.mknod		= hostfs_mknod,
-	.rename		= hostfs_rename,
+	.rename2	= hostfs_rename2,
 	.permission	= hostfs_permission,
 	.setattr	= hostfs_setattr,
 };
diff --git a/fs/hostfs/hostfs_user.c b/fs/hostfs/hostfs_user.c
index 67838f3aa20a..9765dab95cbd 100644
--- a/fs/hostfs/hostfs_user.c
+++ b/fs/hostfs/hostfs_user.c
@@ -14,6 +14,7 @@
 #include <sys/time.h>
 #include <sys/types.h>
 #include <sys/vfs.h>
+#include <sys/syscall.h>
 #include "hostfs.h"
 #include <utime.h>
 
@@ -360,6 +361,33 @@ int rename_file(char *from, char *to)
 	return 0;
 }
 
+int rename2_file(char *from, char *to, unsigned int flags)
+{
+	int err;
+
+#ifndef SYS_renameat2
+#  ifdef __x86_64__
+#    define SYS_renameat2 316
+#  endif
+#  ifdef __i386__
+#    define SYS_renameat2 353
+#  endif
+#endif
+
+#ifdef SYS_renameat2
+	err = syscall(SYS_renameat2, AT_FDCWD, from, AT_FDCWD, to, flags);
+	if (err < 0) {
+		if (errno != ENOSYS)
+			return -errno;
+		else
+			return -EINVAL;
+	}
+	return 0;
+#else
+	return -EINVAL;
+#endif
+}
+
 int do_statfs(char *root, long *bsize_out, long long *blocks_out,
 	      long long *bfree_out, long long *bavail_out,
 	      long long *files_out, long long *ffree_out,
-- 
1.8.1.4

