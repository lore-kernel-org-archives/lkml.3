Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752162AbaCTD2J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 23:28:09 -0400
Received: from mail-ig0-f178.google.com ([209.85.213.178]:35063 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737AbaCTD2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 23:28:08 -0400
From: Eric Biggers <ebiggers3@gmail.com>
To: viro@zeniv.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH] vfs: Deduplicate code shared by xattr system calls operating on paths
Date: Wed, 19 Mar 2014 22:26:37 -0500
Message-Id: <1395285997-5106-1-git-send-email-ebiggers3@gmail.com>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following pairs of system calls dealing with extended attributes only
differ in their behavior on whether the symbolic link is followed (when
the named file is a symbolic link):

- setxattr() and lsetxattr()
- getxattr() and lgetxattr()
- listxattr() and llistxattr()
- removexattr() and lremovexattr()

Despite this, the implementations all had duplicated code, so this commit
redirects each of the above pairs of system calls to a corresponding
function to which different lookup flags (LOOKUP_FOLLOW or 0) are passed.

Signed-off-by: Eric Biggers <ebiggers3@gmail.com>
---
 fs/xattr.c | 116 +++++++++++++++++++++----------------------------------------
 1 file changed, 39 insertions(+), 77 deletions(-)

diff --git a/fs/xattr.c b/fs/xattr.c
index 3377dff..dcf053e 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -364,13 +364,12 @@ out:
 	return error;
 }
 
-SYSCALL_DEFINE5(setxattr, const char __user *, pathname,
-		const char __user *, name, const void __user *, value,
-		size_t, size, int, flags)
+static int path_setxattr(const char __user *pathname,
+			 const char __user *name, const void __user *value,
+			 size_t size, int flags, unsigned int lookup_flags)
 {
 	struct path path;
 	int error;
-	unsigned int lookup_flags = LOOKUP_FOLLOW;
 retry:
 	error = user_path_at(AT_FDCWD, pathname, lookup_flags, &path);
 	if (error)
@@ -388,28 +387,18 @@ retry:
 	return error;
 }
 
+SYSCALL_DEFINE5(setxattr, const char __user *, pathname,
+		const char __user *, name, const void __user *, value,
+		size_t, size, int, flags)
+{
+	return path_setxattr(pathname, name, value, size, flags, LOOKUP_FOLLOW);
+}
+
 SYSCALL_DEFINE5(lsetxattr, const char __user *, pathname,
 		const char __user *, name, const void __user *, value,
 		size_t, size, int, flags)
 {
-	struct path path;
-	int error;
-	unsigned int lookup_flags = 0;
-retry:
-	error = user_path_at(AT_FDCWD, pathname, lookup_flags, &path);
-	if (error)
-		return error;
-	error = mnt_want_write(path.mnt);
-	if (!error) {
-		error = setxattr(path.dentry, name, value, size, flags);
-		mnt_drop_write(path.mnt);
-	}
-	path_put(&path);
-	if (retry_estale(error, lookup_flags)) {
-		lookup_flags |= LOOKUP_REVAL;
-		goto retry;
-	}
-	return error;
+	return path_setxattr(pathname, name, value, size, flags, 0);
 }
 
 SYSCALL_DEFINE5(fsetxattr, int, fd, const char __user *, name,
@@ -481,12 +470,12 @@ getxattr(struct dentry *d, const char __user *name, void __user *value,
 	return error;
 }
 
-SYSCALL_DEFINE4(getxattr, const char __user *, pathname,
-		const char __user *, name, void __user *, value, size_t, size)
+static ssize_t path_getxattr(const char __user *pathname,
+			     const char __user *name, void __user *value,
+			     size_t size, unsigned int lookup_flags)
 {
 	struct path path;
 	ssize_t error;
-	unsigned int lookup_flags = LOOKUP_FOLLOW;
 retry:
 	error = user_path_at(AT_FDCWD, pathname, lookup_flags, &path);
 	if (error)
@@ -500,23 +489,16 @@ retry:
 	return error;
 }
 
+SYSCALL_DEFINE4(getxattr, const char __user *, pathname,
+		const char __user *, name, void __user *, value, size_t, size)
+{
+	return path_getxattr(pathname, name, value, size, LOOKUP_FOLLOW);
+}
+
 SYSCALL_DEFINE4(lgetxattr, const char __user *, pathname,
 		const char __user *, name, void __user *, value, size_t, size)
 {
-	struct path path;
-	ssize_t error;
-	unsigned int lookup_flags = 0;
-retry:
-	error = user_path_at(AT_FDCWD, pathname, lookup_flags, &path);
-	if (error)
-		return error;
-	error = getxattr(path.dentry, name, value, size);
-	path_put(&path);
-	if (retry_estale(error, lookup_flags)) {
-		lookup_flags |= LOOKUP_REVAL;
-		goto retry;
-	}
-	return error;
+	return path_getxattr(pathname, name, value, size, 0);
 }
 
 SYSCALL_DEFINE4(fgetxattr, int, fd, const char __user *, name,
@@ -571,12 +553,11 @@ listxattr(struct dentry *d, char __user *list, size_t size)
 	return error;
 }
 
-SYSCALL_DEFINE3(listxattr, const char __user *, pathname, char __user *, list,
-		size_t, size)
+static ssize_t path_listxattr(const char __user *pathname, char __user *list,
+			      size_t size, unsigned int lookup_flags)
 {
 	struct path path;
 	ssize_t error;
-	unsigned int lookup_flags = LOOKUP_FOLLOW;
 retry:
 	error = user_path_at(AT_FDCWD, pathname, lookup_flags, &path);
 	if (error)
@@ -590,23 +571,16 @@ retry:
 	return error;
 }
 
+SYSCALL_DEFINE3(listxattr, const char __user *, pathname, char __user *, list,
+		size_t, size)
+{
+	return path_listxattr(pathname, list, size, LOOKUP_FOLLOW);
+}
+
 SYSCALL_DEFINE3(llistxattr, const char __user *, pathname, char __user *, list,
 		size_t, size)
 {
-	struct path path;
-	ssize_t error;
-	unsigned int lookup_flags = 0;
-retry:
-	error = user_path_at(AT_FDCWD, pathname, lookup_flags, &path);
-	if (error)
-		return error;
-	error = listxattr(path.dentry, list, size);
-	path_put(&path);
-	if (retry_estale(error, lookup_flags)) {
-		lookup_flags |= LOOKUP_REVAL;
-		goto retry;
-	}
-	return error;
+	return path_listxattr(pathname, list, size, 0);
 }
 
 SYSCALL_DEFINE3(flistxattr, int, fd, char __user *, list, size_t, size)
@@ -640,12 +614,11 @@ removexattr(struct dentry *d, const char __user *name)
 	return vfs_removexattr(d, kname);
 }
 
-SYSCALL_DEFINE2(removexattr, const char __user *, pathname,
-		const char __user *, name)
+static int path_removexattr(const char __user *pathname,
+			    const char __user *name, unsigned int lookup_flags)
 {
 	struct path path;
 	int error;
-	unsigned int lookup_flags = LOOKUP_FOLLOW;
 retry:
 	error = user_path_at(AT_FDCWD, pathname, lookup_flags, &path);
 	if (error)
@@ -663,27 +636,16 @@ retry:
 	return error;
 }
 
+SYSCALL_DEFINE2(removexattr, const char __user *, pathname,
+		const char __user *, name)
+{
+	return path_removexattr(pathname, name, LOOKUP_FOLLOW);
+}
+
 SYSCALL_DEFINE2(lremovexattr, const char __user *, pathname,
 		const char __user *, name)
 {
-	struct path path;
-	int error;
-	unsigned int lookup_flags = 0;
-retry:
-	error = user_path_at(AT_FDCWD, pathname, lookup_flags, &path);
-	if (error)
-		return error;
-	error = mnt_want_write(path.mnt);
-	if (!error) {
-		error = removexattr(path.dentry, name);
-		mnt_drop_write(path.mnt);
-	}
-	path_put(&path);
-	if (retry_estale(error, lookup_flags)) {
-		lookup_flags |= LOOKUP_REVAL;
-		goto retry;
-	}
-	return error;
+	return path_removexattr(pathname, name, 0);
 }
 
 SYSCALL_DEFINE2(fremovexattr, int, fd, const char __user *, name)
-- 
1.9.0

