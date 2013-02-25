Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932093Ab3BYUyQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 15:54:16 -0500
Received: from mail.openrapids.net ([64.15.138.104]:33199 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759729Ab3BYUyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 15:54:13 -0500
Date: Mon, 25 Feb 2013 15:54:11 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Add leading underscores to filldir, fillonedir,
	compat_fillonedir, filldir64
Message-ID: <20130225205411.GB13157@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Editor: vi
X-Info: http://www.efficios.com
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document that these functions expect access_ok() to be performed on
dirent between reception from user-space and call to these functions.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: Al Viro <viro@ZenIV.linux.org.uk>
---
 fs/compat.c  |    4 ++--
 fs/readdir.c |   14 +++++++-------
 2 files changed, 9 insertions(+), 9 deletions(-)

Index: linux/fs/compat.c
===================================================================
--- linux.orig/fs/compat.c
+++ linux/fs/compat.c
@@ -834,7 +834,7 @@ struct compat_readdir_callback {
 	int result;
 };
 
-static int compat_fillonedir(void *__buf, const char *name, int namlen,
+static int __compat_fillonedir(void *__buf, const char *name, int namlen,
 			loff_t offset, u64 ino, unsigned int d_type)
 {
 	struct compat_readdir_callback *buf = __buf;
@@ -879,7 +879,7 @@ asmlinkage long compat_sys_old_readdir(u
 	buf.result = 0;
 	buf.dirent = dirent;
 
-	error = vfs_readdir(f.file, compat_fillonedir, &buf);
+	error = vfs_readdir(f.file, __compat_fillonedir, &buf);
 	if (buf.result)
 		error = buf.result;
 
Index: linux/fs/readdir.c
===================================================================
--- linux.orig/fs/readdir.c
+++ linux/fs/readdir.c
@@ -52,7 +52,7 @@ EXPORT_SYMBOL(vfs_readdir);
  *
  * "count=1" is a special case, meaning that the buffer is one
  * dirent-structure in size and that the code can't handle more
- * anyway. Thus the special "fillonedir()" function for that
+ * anyway. Thus the special "__fillonedir()" function for that
  * case (the low-level handlers don't need to care about this).
  */
 
@@ -70,7 +70,7 @@ struct readdir_callback {
 	int result;
 };
 
-static int fillonedir(void * __buf, const char * name, int namlen, loff_t offset,
+static int __fillonedir(void * __buf, const char * name, int namlen, loff_t offset,
 		      u64 ino, unsigned int d_type)
 {
 	struct readdir_callback * buf = (struct readdir_callback *) __buf;
@@ -115,7 +115,7 @@ SYSCALL_DEFINE3(old_readdir, unsigned in
 	buf.result = 0;
 	buf.dirent = dirent;
 
-	error = vfs_readdir(f.file, fillonedir, &buf);
+	error = vfs_readdir(f.file, __fillonedir, &buf);
 	if (buf.result)
 		error = buf.result;
 
@@ -143,7 +143,7 @@ struct getdents_callback {
 	int error;
 };
 
-static int filldir(void * __buf, const char * name, int namlen, loff_t offset,
+static int __filldir(void * __buf, const char * name, int namlen, loff_t offset,
 		   u64 ino, unsigned int d_type)
 {
 	struct linux_dirent __user * dirent;
@@ -206,7 +206,7 @@ SYSCALL_DEFINE3(getdents, unsigned int,
 	buf.count = count;
 	buf.error = 0;
 
-	error = vfs_readdir(f.file, filldir, &buf);
+	error = vfs_readdir(f.file, __filldir, &buf);
 	if (error >= 0)
 		error = buf.error;
 	lastdirent = buf.previous;
@@ -227,7 +227,7 @@ struct getdents_callback64 {
 	int error;
 };
 
-static int filldir64(void * __buf, const char * name, int namlen, loff_t offset,
+static int __filldir64(void * __buf, const char * name, int namlen, loff_t offset,
 		     u64 ino, unsigned int d_type)
 {
 	struct linux_dirent64 __user *dirent;
@@ -286,7 +286,7 @@ SYSCALL_DEFINE3(getdents64, unsigned int
 	buf.count = count;
 	buf.error = 0;
 
-	error = vfs_readdir(f.file, filldir64, &buf);
+	error = vfs_readdir(f.file, __filldir64, &buf);
 	if (error >= 0)
 		error = buf.error;
 	lastdirent = buf.previous;

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
