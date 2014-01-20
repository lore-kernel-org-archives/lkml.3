Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932079AbaAUN6W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 08:58:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28139 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754360AbaAUN6P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 08:58:15 -0500
From: Florian Weimer <fweimer@redhat.com>
Date: Mon, 20 Jan 2014 15:55:26 +0100
Subject: [PATCH 2/3] vfs: Implement fsetxattrat, fgetxattrat, flistxattrat,
 fremovexattrat
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk
Message-Id: <20140121135811.18E53401159C9@oldenburg.str.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The implementation closely mirrors the existing fchownat system call.

Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Florian Weimer <fweimer@redhat.com>
---
 fs/xattr.c | 122 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 122 insertions(+)

diff --git a/fs/xattr.c b/fs/xattr.c
index 9e44641..d626e42 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -434,6 +434,40 @@ SYSCALL_DEFINE5(fsetxattr, int, fd, const char __user *, name,
 	return error;
 }
 
+SYSCALL_DEFINE6(fsetxattrat, int, fd, const char __user *, pathname,
+		const char __user *, name, const char __user *, value,
+		size_t, size, int, flags)
+{
+	struct path path;
+	int error;
+	unsigned int lookup_flags = 0;
+
+	if (flags & ~(XATTR_SET_MASK | AT_SYMLINK_NOFOLLOW | AT_EMPTY_PATH))
+		return -EINVAL;
+
+	if (!(flags & AT_SYMLINK_NOFOLLOW))
+		lookup_flags |= LOOKUP_FOLLOW;
+	if (flags & AT_EMPTY_PATH)
+		lookup_flags |= LOOKUP_EMPTY;
+
+retry:
+	error = user_path_at(fd, pathname, lookup_flags, &path);
+	if (error)
+		return error;
+	error = mnt_want_write(path.mnt);
+	if (!error) {
+		error = setxattr(path.dentry, name, value, size,
+				 flags & XATTR_SET_MASK);
+		mnt_drop_write(path.mnt);
+	}
+	path_put(&path);
+	if (retry_estale(error, lookup_flags)) {
+		lookup_flags |= LOOKUP_REVAL;
+		goto retry;
+	}
+	return error;
+}
+
 /*
  * Extended attribute GET operations
  */
@@ -535,6 +569,35 @@ SYSCALL_DEFINE4(fgetxattr, int, fd, const char __user *, name,
 	return error;
 }
 
+SYSCALL_DEFINE6(fgetxattrat, int, fd, const char __user *, pathname,
+		const char __user *, name, void __user *, value, size_t, size,
+		int, flags)
+{
+	struct path path;
+	ssize_t error;
+	unsigned int lookup_flags = 0;
+
+	if (flags & ~(AT_SYMLINK_NOFOLLOW | AT_EMPTY_PATH))
+		return -EINVAL;
+
+	if (!(flags & AT_SYMLINK_NOFOLLOW))
+		lookup_flags |= LOOKUP_FOLLOW;
+	if (flags & AT_EMPTY_PATH)
+		lookup_flags |= LOOKUP_EMPTY;
+
+retry:
+	error = user_path_at(fd, pathname, lookup_flags, &path);
+	if (error)
+		return error;
+	error = getxattr(path.dentry, name, value, size);
+	path_put(&path);
+	if (retry_estale(error, lookup_flags)) {
+		lookup_flags |= LOOKUP_REVAL;
+		goto retry;
+	}
+	return error;
+}
+
 /*
  * Extended attribute LIST operations
  */
@@ -624,6 +687,34 @@ SYSCALL_DEFINE3(flistxattr, int, fd, char __user *, list, size_t, size)
 	return error;
 }
 
+SYSCALL_DEFINE5(flistxattrat, int, fd, const char __user *, pathname,
+		char __user *, list, size_t, size, int, flags)
+{
+	struct path path;
+	ssize_t error;
+	unsigned int lookup_flags = 0;
+
+	if (flags & ~(AT_SYMLINK_NOFOLLOW | AT_EMPTY_PATH))
+		return -EINVAL;
+
+	if (!(flags & AT_SYMLINK_NOFOLLOW))
+		lookup_flags |= LOOKUP_FOLLOW;
+	if (flags & AT_EMPTY_PATH)
+		lookup_flags |= LOOKUP_EMPTY;
+
+retry:
+	error = user_path_at(fd, pathname, lookup_flags, &path);
+	if (error)
+		return error;
+	error = listxattr(path.dentry, list, size);
+	path_put(&path);
+	if (retry_estale(error, lookup_flags)) {
+		lookup_flags |= LOOKUP_REVAL;
+		goto retry;
+	}
+	return error;
+}
+
 /*
  * Extended attribute REMOVE operations
  */
@@ -707,6 +798,37 @@ SYSCALL_DEFINE2(fremovexattr, int, fd, const char __user *, name)
 	return error;
 }
 
+SYSCALL_DEFINE4(fremovexattrat, int, fd, const char __user *, pathname,
+		const char __user *, name, int, flags)
+{
+	struct path path;
+	int error;
+	unsigned int lookup_flags = 0;
+
+	if (flags & ~(AT_SYMLINK_NOFOLLOW | AT_EMPTY_PATH))
+		return -EINVAL;
+
+	if (!(flags & AT_SYMLINK_NOFOLLOW))
+		lookup_flags |= LOOKUP_FOLLOW;
+	if (flags & AT_EMPTY_PATH)
+		lookup_flags |= LOOKUP_EMPTY;
+
+retry:
+	error = user_path_at(fd, pathname, lookup_flags, &path);
+	if (error)
+		return error;
+	error = mnt_want_write(path.mnt);
+	if (!error) {
+		error = removexattr(path.dentry, name);
+		mnt_drop_write(path.mnt);
+	}
+	path_put(&path);
+	if (retry_estale(error, lookup_flags)) {
+		lookup_flags |= LOOKUP_REVAL;
+		goto retry;
+	}
+	return error;
+}
 
 static const char *
 strcmp_prefix(const char *a, const char *a_prefix)
-- 
1.8.3.1

