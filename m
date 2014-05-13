Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760674AbaEMN6o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 09:58:44 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:48041 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754161AbaEMN6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 09:58:42 -0400
Date: Tue, 13 May 2014 15:58:37 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH] hostfs: support rename flags
Message-ID: <20140513135837.GC17233@tucsk.piliscsaba.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
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
 fs/hostfs/hostfs.h      |    1 +
 fs/hostfs/hostfs_kern.c |   35 ++++++++++++++++++++++++++---------
 fs/hostfs/hostfs_user.c |   28 ++++++++++++++++++++++++++++
 3 files changed, 55 insertions(+), 9 deletions(-)

--- a/fs/hostfs/hostfs.h
+++ b/fs/hostfs/hostfs.h
@@ -89,6 +89,7 @@ extern int do_mknod(const char *file, in
 extern int link_file(const char *from, const char *to);
 extern int hostfs_do_readlink(char *file, char *buf, int size);
 extern int rename_file(char *from, char *to);
+extern int rename2_file(char *from, char *to, unsigned int flags);
 extern int do_statfs(char *root, long *bsize_out, long long *blocks_out,
 		     long long *bfree_out, long long *bavail_out,
 		     long long *files_out, long long *ffree_out,
--- a/fs/hostfs/hostfs_kern.c
+++ b/fs/hostfs/hostfs_kern.c
@@ -741,24 +741,40 @@ static int hostfs_mknod(struct inode *di
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
 
+static int hostfs_rename(struct inode *old_dir, struct dentry *old_dentry,
+			 struct inode *new_dir, struct dentry *new_dentry)
+{
+	return hostfs_rename2(old_dir, old_dentry, new_dir, new_dentry, 0);
+}
+
 static int hostfs_permission(struct inode *ino, int desired)
 {
 	char *name;
@@ -868,6 +884,7 @@ static const struct inode_operations hos
 	.rmdir		= hostfs_rmdir,
 	.mknod		= hostfs_mknod,
 	.rename		= hostfs_rename,
+	.rename2	= hostfs_rename2,
 	.permission	= hostfs_permission,
 	.setattr	= hostfs_setattr,
 };
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
