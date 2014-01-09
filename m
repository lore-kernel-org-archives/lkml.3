Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756279AbaAIOW1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 09:22:27 -0500
Received: from mail-qc0-f176.google.com ([209.85.216.176]:47514 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755417AbaAIOUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 09:20:17 -0500
From: Jeff Layton <jlayton@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: nfs-ganesha-devel@lists.sourceforge.net, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v5 14/14] locks: add new fcntl cmd values for handling file private locks
Date: Thu,  9 Jan 2014 09:19:47 -0500
Message-Id: <1389277187-18211-15-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1389277187-18211-1-git-send-email-jlayton@redhat.com>
References: <1389277187-18211-1-git-send-email-jlayton@redhat.com>
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

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 arch/arm/kernel/sys_oabi-compat.c    |  6 +++++
 arch/arm64/include/asm/compat.h      |  3 +++
 arch/mips/include/asm/compat.h       |  3 +++
 arch/mips/include/uapi/asm/fcntl.h   |  3 +++
 arch/parisc/include/uapi/asm/fcntl.h |  3 +++
 arch/powerpc/include/asm/compat.h    |  3 +++
 arch/s390/include/asm/compat.h       |  9 ++++---
 arch/sparc/include/asm/compat.h      |  3 +++
 arch/tile/include/asm/compat.h       |  3 +++
 arch/x86/include/asm/compat.h        |  3 +++
 fs/compat.c                          | 48 ++++++++++++++++++++++++++++-----
 fs/fcntl.c                           | 28 +++++++++++--------
 fs/locks.c                           | 52 +++++++++++++++++++++++++++++++++---
 include/uapi/asm-generic/fcntl.h     | 24 +++++++++++++++++
 security/selinux/hooks.c             |  6 +++++
 15 files changed, 174 insertions(+), 23 deletions(-)

diff --git a/arch/arm/kernel/sys_oabi-compat.c b/arch/arm/kernel/sys_oabi-compat.c
index 3e94811..2fdda97 100644
--- a/arch/arm/kernel/sys_oabi-compat.c
+++ b/arch/arm/kernel/sys_oabi-compat.c
@@ -206,6 +206,9 @@ asmlinkage long sys_oabi_fcntl64(unsigned int fd, unsigned int cmd,
 	case F_GETLK64:
 	case F_SETLK64:
 	case F_SETLKW64:
+	case F_GETLKP64:
+	case F_SETLKP64:
+	case F_SETLKPW64:
 		if (copy_from_user(&user, (struct oabi_flock64 __user *)arg,
 				   sizeof(user)))
 			return -EFAULT;
@@ -223,6 +226,7 @@ asmlinkage long sys_oabi_fcntl64(unsigned int fd, unsigned int cmd,
 
 	switch (cmd) {
 	case F_GETLK64:
+	case F_GETLKP64:
 		if (!ret) {
 			user.l_type	= kernel.l_type;
 			user.l_whence	= kernel.l_whence;
@@ -235,6 +239,8 @@ asmlinkage long sys_oabi_fcntl64(unsigned int fd, unsigned int cmd,
 		}
 	case F_SETLK64:
 	case F_SETLKW64:
+	case F_SETLKP64:
+	case F_SETLKPW64:
 		set_fs(fs);
 	}
 
diff --git a/arch/arm64/include/asm/compat.h b/arch/arm64/include/asm/compat.h
index fda2704..ee46cc4 100644
--- a/arch/arm64/include/asm/compat.h
+++ b/arch/arm64/include/asm/compat.h
@@ -117,6 +117,9 @@ struct compat_flock {
 #define F_GETLK64	12	/*  using 'struct flock64' */
 #define F_SETLK64	13
 #define F_SETLKW64	14
+#define F_GETLKP64	39
+#define F_SETLKP64	40
+#define F_SETLKPW64	41
 
 struct compat_flock64 {
 	short		l_type;
diff --git a/arch/mips/include/asm/compat.h b/arch/mips/include/asm/compat.h
index c4bd54a..9cd8c3c 100644
--- a/arch/mips/include/asm/compat.h
+++ b/arch/mips/include/asm/compat.h
@@ -92,6 +92,9 @@ struct compat_flock {
 #define F_GETLK64	33
 #define F_SETLK64	34
 #define F_SETLKW64	35
+#define F_GETLKP64	39
+#define F_SETLKP64	40
+#define F_SETLKPW64	41
 
 struct compat_flock64 {
 	short		l_type;
diff --git a/arch/mips/include/uapi/asm/fcntl.h b/arch/mips/include/uapi/asm/fcntl.h
index 6ca432f..ce6f5e3 100644
--- a/arch/mips/include/uapi/asm/fcntl.h
+++ b/arch/mips/include/uapi/asm/fcntl.h
@@ -47,6 +47,9 @@
 #define F_GETLK64	33	/*  using 'struct flock64' */
 #define F_SETLK64	34
 #define F_SETLKW64	35
+#define F_GETLKP64	39
+#define F_SETLKP64	40
+#define F_SETLKPW64	41
 #endif
 
 /*
diff --git a/arch/parisc/include/uapi/asm/fcntl.h b/arch/parisc/include/uapi/asm/fcntl.h
index 34a46cb..9289e88 100644
--- a/arch/parisc/include/uapi/asm/fcntl.h
+++ b/arch/parisc/include/uapi/asm/fcntl.h
@@ -25,6 +25,9 @@
 #define F_GETLK64	8
 #define F_SETLK64	9
 #define F_SETLKW64	10
+#define F_GETLKP64	39
+#define F_SETLKP64	40
+#define F_SETLKPW64	41
 
 #define F_GETOWN	11	/*  for sockets. */
 #define F_SETOWN	12	/*  for sockets. */
diff --git a/arch/powerpc/include/asm/compat.h b/arch/powerpc/include/asm/compat.h
index 84fdf68..ccc1ae2 100644
--- a/arch/powerpc/include/asm/compat.h
+++ b/arch/powerpc/include/asm/compat.h
@@ -81,6 +81,9 @@ struct compat_flock {
 #define F_GETLK64	12	/*  using 'struct flock64' */
 #define F_SETLK64	13
 #define F_SETLKW64	14
+#define F_GETLKP64	39
+#define F_SETLKP64	40
+#define F_SETLKPW64	41
 
 struct compat_flock64 {
 	short		l_type;
diff --git a/arch/s390/include/asm/compat.h b/arch/s390/include/asm/compat.h
index 4bf9da0..f18c209 100644
--- a/arch/s390/include/asm/compat.h
+++ b/arch/s390/include/asm/compat.h
@@ -130,9 +130,12 @@ struct compat_flock {
 	compat_pid_t	l_pid;
 };
 
-#define F_GETLK64       12
-#define F_SETLK64       13
-#define F_SETLKW64      14    
+#define F_GETLK64	12
+#define F_SETLK64	13
+#define F_SETLKW64	14
+#define F_GETLKP64	39
+#define F_SETLKP64	40
+#define F_SETLKPW64	41
 
 struct compat_flock64 {
 	short		l_type;
diff --git a/arch/sparc/include/asm/compat.h b/arch/sparc/include/asm/compat.h
index 830502fe..8af1898 100644
--- a/arch/sparc/include/asm/compat.h
+++ b/arch/sparc/include/asm/compat.h
@@ -114,6 +114,9 @@ struct compat_flock {
 #define F_GETLK64	12
 #define F_SETLK64	13
 #define F_SETLKW64	14
+#define F_GETLKP64	39
+#define F_SETLKP64	40
+#define F_SETLKPW64	41
 
 struct compat_flock64 {
 	short		l_type;
diff --git a/arch/tile/include/asm/compat.h b/arch/tile/include/asm/compat.h
index 78f1f2d..8ca0ccb 100644
--- a/arch/tile/include/asm/compat.h
+++ b/arch/tile/include/asm/compat.h
@@ -94,6 +94,9 @@ struct compat_flock {
 #define F_GETLK64	12	/*  using 'struct flock64' */
 #define F_SETLK64	13
 #define F_SETLKW64	14
+#define F_GETLKP64	39
+#define F_SETLKP64	40
+#define F_SETLKPW64	41
 
 struct compat_flock64 {
 	short		l_type;
diff --git a/arch/x86/include/asm/compat.h b/arch/x86/include/asm/compat.h
index 59c6c40..08a448b 100644
--- a/arch/x86/include/asm/compat.h
+++ b/arch/x86/include/asm/compat.h
@@ -87,6 +87,9 @@ struct compat_flock {
 #define F_GETLK64	12	/*  using 'struct flock64' */
 #define F_SETLK64	13
 #define F_SETLKW64	14
+#define F_GETLKP64	39
+#define F_SETLKP64	40
+#define F_SETLKPW64	41
 
 /*
  * IA32 uses 4 byte alignment for 64 bit quantities,
diff --git a/fs/compat.c b/fs/compat.c
index 6af20de..43a0973 100644
--- a/fs/compat.c
+++ b/fs/compat.c
@@ -399,17 +399,44 @@ static int put_compat_flock64(struct flock *kfl, struct compat_flock64 __user *u
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
+	case F_GETLKP64:
+		return F_GETLKP;
+	case F_SETLKP64:
+		return F_SETLKP;
+	case F_SETLKPW64:
+		return F_SETLKPW;
+	}
+
+	/* Should never happen! */
+	WARN(1, "%s: cmd=%u\n", __func__, cmd);
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
+	case F_GETLKP:
 	case F_SETLK:
+	case F_SETLKP:
 	case F_SETLKW:
+	case F_SETLKPW:
 		ret = get_compat_flock(&f, compat_ptr(arg));
 		if (ret != 0)
 			break;
@@ -417,7 +444,7 @@ asmlinkage long compat_sys_fcntl64(unsigned int fd, unsigned int cmd,
 		set_fs(KERNEL_DS);
 		ret = sys_fcntl(fd, cmd, (unsigned long)&f);
 		set_fs(old_fs);
-		if (cmd == F_GETLK && ret == 0) {
+		if ((cmd == F_GETLK || cmd == F_GETLKP) && ret == 0) {
 			/* GETLK was successful and we need to return the data...
 			 * but it needs to fit in the compat structure.
 			 * l_start shouldn't be too big, unless the original
@@ -441,16 +468,18 @@ asmlinkage long compat_sys_fcntl64(unsigned int fd, unsigned int cmd,
 	case F_GETLK64:
 	case F_SETLK64:
 	case F_SETLKW64:
+	case F_GETLKP64:
+	case F_SETLKP64:
+	case F_SETLKPW64:
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
@@ -471,8 +500,15 @@ asmlinkage long compat_sys_fcntl64(unsigned int fd, unsigned int cmd,
 asmlinkage long compat_sys_fcntl(unsigned int fd, unsigned int cmd,
 		unsigned long arg)
 {
-	if ((cmd == F_GETLK64) || (cmd == F_SETLK64) || (cmd == F_SETLKW64))
+	switch (cmd) {
+	case F_GETLK64:
+	case F_SETLK64:
+	case F_SETLKW64:
+	case F_GETLKP64:
+	case F_SETLKP64:
+	case F_SETLKPW64:
 		return -EINVAL;
+	}
 	return compat_sys_fcntl64(fd, cmd, arg);
 }
 
diff --git a/fs/fcntl.c b/fs/fcntl.c
index 7ef7f2d..886817f 100644
--- a/fs/fcntl.c
+++ b/fs/fcntl.c
@@ -273,10 +273,13 @@ static long do_fcntl(int fd, unsigned int cmd, unsigned long arg,
 		err = setfl(fd, filp, arg);
 		break;
 	case F_GETLK:
+	case F_GETLKP:
 		err = fcntl_getlk(filp, cmd, (struct flock __user *) arg);
 		break;
 	case F_SETLK:
 	case F_SETLKW:
+	case F_SETLKP:
+	case F_SETLKPW:
 		err = fcntl_setlk(fd, filp, cmd, (struct flock __user *) arg);
 		break;
 	case F_GETOWN:
@@ -388,17 +391,20 @@ SYSCALL_DEFINE3(fcntl64, unsigned int, fd, unsigned int, cmd,
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
+	case F_GETLKP64:
+		err = fcntl_getlk64(f.file, cmd, (struct flock64 __user *) arg);
+		break;
+	case F_SETLK64:
+	case F_SETLKW64:
+	case F_SETLKP64:
+	case F_SETLKPW64:
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
index 94bcca6..23c9d16 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -1923,6 +1923,12 @@ int fcntl_getlk(struct file *filp, unsigned int cmd, struct flock __user *l)
 	if (error)
 		goto out;
 
+	if (cmd == F_GETLKP) {
+		cmd = F_GETLK;
+		file_lock.fl_owner = (fl_owner_t)filp;
+		file_lock.fl_flags |= FL_FILE_PVT;
+	}
+
 	error = vfs_test_lock(filp, &file_lock);
 	if (error)
 		goto out;
@@ -2042,10 +2048,26 @@ again:
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
@@ -2091,6 +2113,12 @@ int fcntl_getlk64(struct file *filp, unsigned int cmd, struct flock64 __user *l)
 	if (error)
 		goto out;
 
+	if (cmd == F_GETLKP64) {
+		cmd = F_GETLK64;
+		file_lock.fl_owner = (fl_owner_t)filp;
+		file_lock.fl_flags |= FL_FILE_PVT;
+	}
+
 	error = vfs_test_lock(filp, &file_lock);
 	if (error)
 		goto out;
@@ -2143,7 +2171,23 @@ again:
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
+	case F_SETLKP64:
+		cmd = F_SETLK64;
+		file_lock->fl_flags |= FL_FILE_PVT;
+		file_lock->fl_owner = (fl_owner_t)filp;
+		break;
+	case F_SETLKPW64:
+		cmd = F_SETLKW64;
+		file_lock->fl_flags |= FL_FILE_PVT;
+		file_lock->fl_owner = (fl_owner_t)filp;
+		/* Fallthrough */
+	case F_SETLKW64:
 		file_lock->fl_flags |= FL_SLEEP;
 	}
 	
@@ -2214,6 +2258,8 @@ void locks_remove_file(struct file *filp)
 	if (!inode->i_flock)
 		return;
 
+	locks_remove_posix(filp, (fl_owner_t)filp);
+
 	if (filp->f_op->flock) {
 		struct file_lock fl = {
 			.fl_pid = current->tgid,
diff --git a/include/uapi/asm-generic/fcntl.h b/include/uapi/asm-generic/fcntl.h
index 36025f7..952e26b 100644
--- a/include/uapi/asm-generic/fcntl.h
+++ b/include/uapi/asm-generic/fcntl.h
@@ -132,6 +132,30 @@
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
+#ifndef CONFIG_64BIT
+#ifndef F_GETLK64
+#define F_GETLKP64	39
+#define F_SETLKP64	40
+#define F_SETLKPW64	41
+#endif
+#endif
+
 #define F_OWNER_TID	0
 #define F_OWNER_PID	1
 #define F_OWNER_PGRP	2
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 6625699..488d449 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -3287,10 +3287,16 @@ static int selinux_file_fcntl(struct file *file, unsigned int cmd,
 	case F_GETLK:
 	case F_SETLK:
 	case F_SETLKW:
+	case F_GETLKP:
+	case F_SETLKP:
+	case F_SETLKPW:
 #if BITS_PER_LONG == 32
 	case F_GETLK64:
 	case F_SETLK64:
 	case F_SETLKW64:
+	case F_GETLKP64:
+	case F_SETLKP64:
+	case F_SETLKPW64:
 #endif
 		err = file_has_perm(cred, file, FILE__LOCK);
 		break;
-- 
1.8.4.2

