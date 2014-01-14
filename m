Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752018AbaANTIf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 14:08:35 -0500
Received: from mail-qe0-f42.google.com ([209.85.128.42]:44788 "EHLO
	mail-qe0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751887AbaANTHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 14:07:24 -0500
From: Jeff Layton <jlayton@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: nfs-ganesha-devel@lists.sourceforge.net, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v6 14/14] locks: add new fcntl cmd values for handling file private locks
Date: Tue, 14 Jan 2014 14:06:54 -0500
Message-Id: <1389726414-30990-15-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1389726414-30990-1-git-send-email-jlayton@redhat.com>
References: <1389726414-30990-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Due to some unfortunate history, POSIX locks have very strange and
unhelpful semantics. The thing that usually catches people by surprise
is that they are dropped whenever the process closes any file descriptor
associated with the inode.

This is extremely problematic for people developing file servers that
need to implement byte-range locks. Developers often need a "lock
management" facility to ensure that file descriptors are not closed
until all of the locks associated with the inode are finished.

Additionally, "classic" POSIX locks are owned by the process. Locks
taken between threads within the same process won't conflict with one
another, which renders them useless for synchronization between threads.

This patchset adds a new type of lock that attempts to address these
issues. These locks conflict with classic POSIX read/write locks, but
have semantics that are more like BSD locks with respect to inheritance
and behavior on close.

This is implemented primarily by changing how fl_owner field is set for
these locks. Instead of having them owned by the files_struct of the
process, they are instead owned by the filp on which they were acquired.
Thus, they are inherited across fork() and are only released when the
last reference to a filp is put.

These new semantics prevent them from being merged with classic POSIX
locks, even if they are acquired by the same process. These locks will
also conflict with classic POSIX locks even if they are acquired by
the same process or on the same file descriptor.

The new locks are managed using a new set of cmd values to the fcntl()
syscall. The initial implementation of this converts these values to
"classic" cmd values at a fairly high level, and the details are not
exposed to the underlying filesystem. We may eventually want to push
this handing out to the lower filesystem code but for now I don't
see any need for it.

Also, note that with this implementation the new cmd values are only
available via fcntl64() on 32-bit arches. There's little need to
add support for legacy apps on a new interface like this.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 arch/arm/kernel/sys_oabi-compat.c |  3 +++
 fs/compat.c                       | 35 ++++++++++++++++++++++----
 fs/fcntl.c                        | 35 +++++++++++++++++---------
 fs/locks.c                        | 52 ++++++++++++++++++++++++++++++++++++---
 include/uapi/asm-generic/fcntl.h  | 16 ++++++++++++
 security/selinux/hooks.c          |  3 +++
 6 files changed, 125 insertions(+), 19 deletions(-)

diff --git a/arch/arm/kernel/sys_oabi-compat.c b/arch/arm/kernel/sys_oabi-compat.c
index 3e94811..702bd32 100644
--- a/arch/arm/kernel/sys_oabi-compat.c
+++ b/arch/arm/kernel/sys_oabi-compat.c
@@ -203,6 +203,9 @@ asmlinkage long sys_oabi_fcntl64(unsigned int fd, unsigned int cmd,
 	int ret;
 
 	switch (cmd) {
+	case F_GETLKP:
+	case F_SETLKP:
+	case F_SETLKPW:
 	case F_GETLK64:
 	case F_SETLK64:
 	case F_SETLKW64:
diff --git a/fs/compat.c b/fs/compat.c
index 6af20de..f340dcf 100644
--- a/fs/compat.c
+++ b/fs/compat.c
@@ -399,12 +399,28 @@ static int put_compat_flock64(struct flock *kfl, struct compat_flock64 __user *u
 }
 #endif
 
+static unsigned int
+convert_fcntl_cmd(unsigned int cmd)
+{
+	switch (cmd) {
+	case F_GETLK64:
+		return F_GETLK;
+	case F_SETLK64:
+		return F_SETLK;
+	case F_SETLKW64:
+		return F_SETLKW;
+	}
+
+	return cmd;
+}
+
 asmlinkage long compat_sys_fcntl64(unsigned int fd, unsigned int cmd,
 		unsigned long arg)
 {
 	mm_segment_t old_fs;
 	struct flock f;
 	long ret;
+	unsigned int conv_cmd;
 
 	switch (cmd) {
 	case F_GETLK:
@@ -441,16 +457,18 @@ asmlinkage long compat_sys_fcntl64(unsigned int fd, unsigned int cmd,
 	case F_GETLK64:
 	case F_SETLK64:
 	case F_SETLKW64:
+	case F_GETLKP:
+	case F_SETLKP:
+	case F_SETLKPW:
 		ret = get_compat_flock64(&f, compat_ptr(arg));
 		if (ret != 0)
 			break;
 		old_fs = get_fs();
 		set_fs(KERNEL_DS);
-		ret = sys_fcntl(fd, (cmd == F_GETLK64) ? F_GETLK :
-				((cmd == F_SETLK64) ? F_SETLK : F_SETLKW),
-				(unsigned long)&f);
+		conv_cmd = convert_fcntl_cmd(cmd);
+		ret = sys_fcntl(fd, conv_cmd, (unsigned long)&f);
 		set_fs(old_fs);
-		if (cmd == F_GETLK64 && ret == 0) {
+		if ((conv_cmd == F_GETLK || conv_cmd == F_GETLKP) && ret == 0) {
 			/* need to return lock information - see above for commentary */
 			if (f.l_start > COMPAT_LOFF_T_MAX)
 				ret = -EOVERFLOW;
@@ -471,8 +489,15 @@ asmlinkage long compat_sys_fcntl64(unsigned int fd, unsigned int cmd,
 asmlinkage long compat_sys_fcntl(unsigned int fd, unsigned int cmd,
 		unsigned long arg)
 {
-	if ((cmd == F_GETLK64) || (cmd == F_SETLK64) || (cmd == F_SETLKW64))
+	switch (cmd) {
+	case F_GETLK64:
+	case F_SETLK64:
+	case F_SETLKW64:
+	case F_GETLKP:
+	case F_SETLKP:
+	case F_SETLKPW:
 		return -EINVAL;
+	}
 	return compat_sys_fcntl64(fd, cmd, arg);
 }
 
diff --git a/fs/fcntl.c b/fs/fcntl.c
index 7ef7f2d..9ead159 100644
--- a/fs/fcntl.c
+++ b/fs/fcntl.c
@@ -272,9 +272,19 @@ static long do_fcntl(int fd, unsigned int cmd, unsigned long arg,
 	case F_SETFL:
 		err = setfl(fd, filp, arg);
 		break;
+#if BITS_PER_LONG != 32
+	/* 32-bit arches must use fcntl64() */
+	case F_GETLKP:
+#endif
 	case F_GETLK:
 		err = fcntl_getlk(filp, cmd, (struct flock __user *) arg);
 		break;
+#if BITS_PER_LONG != 32
+	/* 32-bit arches must use fcntl64() */
+	case F_SETLKP:
+	case F_SETLKPW:
+#endif
+		/* Fallthrough */
 	case F_SETLK:
 	case F_SETLKW:
 		err = fcntl_setlk(fd, filp, cmd, (struct flock __user *) arg);
@@ -388,17 +398,20 @@ SYSCALL_DEFINE3(fcntl64, unsigned int, fd, unsigned int, cmd,
 		goto out1;
 	
 	switch (cmd) {
-		case F_GETLK64:
-			err = fcntl_getlk64(f.file, cmd, (struct flock64 __user *) arg);
-			break;
-		case F_SETLK64:
-		case F_SETLKW64:
-			err = fcntl_setlk64(fd, f.file, cmd,
-					(struct flock64 __user *) arg);
-			break;
-		default:
-			err = do_fcntl(fd, cmd, arg, f.file);
-			break;
+	case F_GETLK64:
+	case F_GETLKP:
+		err = fcntl_getlk64(f.file, cmd, (struct flock64 __user *) arg);
+		break;
+	case F_SETLK64:
+	case F_SETLKW64:
+	case F_SETLKP:
+	case F_SETLKPW:
+		err = fcntl_setlk64(fd, f.file, cmd,
+				(struct flock64 __user *) arg);
+		break;
+	default:
+		err = do_fcntl(fd, cmd, arg, f.file);
+		break;
 	}
 out1:
 	fdput(f);
diff --git a/fs/locks.c b/fs/locks.c
index 8c5bc07..ce93815 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -1930,6 +1930,12 @@ int fcntl_getlk(struct file *filp, unsigned int cmd, struct flock __user *l)
 	if (error)
 		goto out;
 
+	if (cmd == F_GETLKP) {
+		cmd = F_GETLK;
+		file_lock.fl_flags |= FL_FILE_PVT;
+		file_lock.fl_owner = (fl_owner_t)filp;
+	}
+
 	error = vfs_test_lock(filp, &file_lock);
 	if (error)
 		goto out;
@@ -2049,10 +2055,26 @@ again:
 	error = flock_to_posix_lock(filp, file_lock, &flock);
 	if (error)
 		goto out;
-	if (cmd == F_SETLKW) {
+
+	/*
+	 * If the cmd is requesting file-private locks, then set the
+	 * FL_FILE_PVT flag and override the owner.
+	 */
+	switch (cmd) {
+	case F_SETLKP:
+		cmd = F_SETLK;
+		file_lock->fl_flags |= FL_FILE_PVT;
+		file_lock->fl_owner = (fl_owner_t)filp;
+		break;
+	case F_SETLKPW:
+		cmd = F_SETLKW;
+		file_lock->fl_flags |= FL_FILE_PVT;
+		file_lock->fl_owner = (fl_owner_t)filp;
+		/* Fallthrough */
+	case F_SETLKW:
 		file_lock->fl_flags |= FL_SLEEP;
 	}
-	
+
 	error = do_lock_file_wait(filp, cmd, file_lock);
 
 	/*
@@ -2098,6 +2120,12 @@ int fcntl_getlk64(struct file *filp, unsigned int cmd, struct flock64 __user *l)
 	if (error)
 		goto out;
 
+	if (cmd == F_GETLKP) {
+		cmd = F_GETLK64;
+		file_lock.fl_flags |= FL_FILE_PVT;
+		file_lock.fl_owner = (fl_owner_t)filp;
+	}
+
 	error = vfs_test_lock(filp, &file_lock);
 	if (error)
 		goto out;
@@ -2150,7 +2178,23 @@ again:
 	error = flock64_to_posix_lock(filp, file_lock, &flock);
 	if (error)
 		goto out;
-	if (cmd == F_SETLKW64) {
+
+	/*
+	 * If the cmd is requesting file-private locks, then set the
+	 * FL_FILE_PVT flag and override the owner.
+	 */
+	switch (cmd) {
+	case F_SETLKP:
+		cmd = F_SETLK64;
+		file_lock->fl_flags |= FL_FILE_PVT;
+		file_lock->fl_owner = (fl_owner_t)filp;
+		break;
+	case F_SETLKPW:
+		cmd = F_SETLKW64;
+		file_lock->fl_flags |= FL_FILE_PVT;
+		file_lock->fl_owner = (fl_owner_t)filp;
+		/* Fallthrough */
+	case F_SETLKW64:
 		file_lock->fl_flags |= FL_SLEEP;
 	}
 	
@@ -2221,6 +2265,8 @@ void locks_remove_file(struct file *filp)
 	if (!inode->i_flock)
 		return;
 
+	locks_remove_posix(filp, (fl_owner_t)filp);
+
 	if (filp->f_op->flock) {
 		struct file_lock fl = {
 			.fl_pid = current->tgid,
diff --git a/include/uapi/asm-generic/fcntl.h b/include/uapi/asm-generic/fcntl.h
index 36025f7..a9b13f8 100644
--- a/include/uapi/asm-generic/fcntl.h
+++ b/include/uapi/asm-generic/fcntl.h
@@ -132,6 +132,22 @@
 #define F_GETOWNER_UIDS	17
 #endif
 
+/*
+ * fd "private" POSIX locks.
+ *
+ * Usually POSIX locks held by a process are released on *any* close and are
+ * not inherited across a fork().
+ *
+ * These cmd values will set locks that conflict with normal POSIX locks, but
+ * are "owned" by the opened file, not the process. This means that they are
+ * inherited across fork() like BSD (flock) locks, and they are only released
+ * automatically when the last reference to the the open file against which
+ * they were acquired is put.
+ */
+#define F_GETLKP	36
+#define F_SETLKP	37
+#define F_SETLKPW	38
+
 #define F_OWNER_TID	0
 #define F_OWNER_PID	1
 #define F_OWNER_PGRP	2
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 57b0b49..cadea7c 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -3303,6 +3303,9 @@ static int selinux_file_fcntl(struct file *file, unsigned int cmd,
 	case F_GETLK:
 	case F_SETLK:
 	case F_SETLKW:
+	case F_GETLKP:
+	case F_SETLKP:
+	case F_SETLKPW:
 #if BITS_PER_LONG == 32
 	case F_GETLK64:
 	case F_SETLK64:
-- 
1.8.4.2

