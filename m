Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753426AbaAUTGc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 14:06:32 -0500
Received: from alcazar.beanwood.com ([70.85.129.230]:37881 "EHLO
	alcazar.beanwood.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860AbaAUTG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 14:06:29 -0500
From: Andrew Ayer <agwa@andrewayer.name>
To: viro@zeniv.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        fweimer@redhat.com
Subject: [PATCH] vfs: Add version of fchmodat with flag argument
Date: Tue, 21 Jan 2014 10:58:32 -0800
Message-Id: <1390330712-32430-1-git-send-email-agwa@andrewayer.name>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <20140121105735.56cc4ec41a6f20719a70d19e@andrewayer.name>
References: <20140121105735.56cc4ec41a6f20719a70d19e@andrewayer.name>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds a 4 argument version of fchmodat (fchmodat4) that
supports a flag argument, as specified by POSIX.  It supports
the same two flags as fchownat: AT_SYMLINK_NOFOLLOW and AT_EMPTY_PATH.

Signed-off-by: Andrew Ayer <agwa@andrewayer.name>
---
 fs/open.c                |   23 ++++++++++++++++++++---
 include/linux/syscalls.h |    2 ++
 2 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index 4b3e1ed..6f661f9 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -469,6 +469,9 @@ static int chmod_common(struct path *path, umode_t mode)
 	struct iattr newattrs;
 	int error;
 
+	if (S_ISLNK(inode->i_mode))
+		return -EOPNOTSUPP;
+
 	error = mnt_want_write(path->mnt);
 	if (error)
 		return error;
@@ -506,9 +509,22 @@ SYSCALL_DEFINE2(fchmod, unsigned int, fd, umode_t, mode)
 
 SYSCALL_DEFINE3(fchmodat, int, dfd, const char __user *, filename, umode_t, mode)
 {
+	return sys_fchmodat4(dfd, filename, mode, 0);
+}
+
+SYSCALL_DEFINE4(fchmodat4, int, dfd, const char __user *, filename,
+		umode_t, mode, int, flag)
+{
 	struct path path;
-	int error;
-	unsigned int lookup_flags = LOOKUP_FOLLOW;
+	int error = -EINVAL;
+	unsigned int lookup_flags;
+
+	if ((flag & ~(AT_SYMLINK_NOFOLLOW | AT_EMPTY_PATH)) != 0)
+		goto out;
+
+	lookup_flags = (flag & AT_SYMLINK_NOFOLLOW) ? 0 : LOOKUP_FOLLOW;
+	if (flag & AT_EMPTY_PATH)
+		lookup_flags |= LOOKUP_EMPTY;
 retry:
 	error = user_path_at(dfd, filename, lookup_flags, &path);
 	if (!error) {
@@ -519,12 +535,13 @@ retry:
 			goto retry;
 		}
 	}
+out:
 	return error;
 }
 
 SYSCALL_DEFINE2(chmod, const char __user *, filename, umode_t, mode)
 {
-	return sys_fchmodat(AT_FDCWD, filename, mode);
+	return sys_fchmodat4(AT_FDCWD, filename, mode, 0);
 }
 
 static int chown_common(struct path *path, uid_t user, gid_t group)
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 40ed9e9..32811df 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -747,6 +747,8 @@ asmlinkage long sys_futimesat(int dfd, const char __user *filename,
 asmlinkage long sys_faccessat(int dfd, const char __user *filename, int mode);
 asmlinkage long sys_fchmodat(int dfd, const char __user * filename,
 			     umode_t mode);
+asmlinkage long sys_fchmodat4(int dfd, const char __user *filename,
+			     umode_t mode, int flag);
 asmlinkage long sys_fchownat(int dfd, const char __user *filename, uid_t user,
 			     gid_t group, int flag);
 asmlinkage long sys_openat(int dfd, const char __user *filename, int flags,
-- 
1.7.10.4

