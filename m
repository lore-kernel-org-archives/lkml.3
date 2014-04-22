Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932402AbaDVMXS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 08:23:18 -0400
Received: from mail-qg0-f50.google.com ([209.85.192.50]:48875 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755462AbaDVMXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 08:23:16 -0400
From: Jeff Layton <jlayton@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, samba-technical@lists.samba.org,
        Ganesha NFS List <nfs-ganesha-devel@lists.sourceforge.net>,
        libc-alpha <libc-alpha@sourceware.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Christoph Hellwig <hch@infradead.org>,
        "Carlos O'Donell" <carlos@redhat.com>,
        Stefan Metzmacher <metze@samba.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Frank Filz <ffilzlnx@mindspring.com>, "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH] locks: rename file-private locks to "open file description locks"
Date: Tue, 22 Apr 2014 08:23:03 -0400
Message-Id: <1398169383-10743-1-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

File-private locks have been merged into Linux for v3.15, and *now*
people are commenting that the name and macro definitions for the new
file-private locks suck.

...and I can't even disagree. The names and command macros do suck.

We're going to have to live with these for a long time, so it's
important that we be happy with the names before we're stuck with them.
The consensus on the lists so far is that they should be rechristened as
"open file description locks".

The name isn't a big deal for the kernel, but the command macros are not
visually distinct enough from the traditional POSIX lock macros. The
glibc and documentation folks are recommending that we change them to
look like F_OFD_{GETLK|SETLK|SETLKW}. That lessens the chance that a
programmer will typo one of the commands wrong, and also makes it easier
to spot this difference when reading code.

This patch makes the following changes that I think are necessary before
v3.15 ships:

1) rename the command macros to their new names. These end up in the uapi
   headers and so are part of the external-facing API. It turns out that
   glibc doesn't actually use the fcntl.h uapi header, but it's hard to
   be sure that something else won't. Changing it now is safest.

2) make the the /proc/locks output display these as type "OFDLCK"

The rest of the renaming can wait until v3.16, since everything else
isn't visible outside of the kernel.

Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Carlos O'Donell <carlos@redhat.com>
Cc: Stefan Metzmacher <metze@samba.org>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Frank Filz <ffilzlnx@mindspring.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 arch/arm/kernel/sys_oabi-compat.c |  6 +++---
 fs/compat.c                       | 14 +++++++-------
 fs/fcntl.c                        | 12 ++++++------
 fs/locks.c                        | 14 +++++++-------
 include/uapi/asm-generic/fcntl.h  | 20 ++++++++++----------
 security/selinux/hooks.c          |  6 +++---
 6 files changed, 36 insertions(+), 36 deletions(-)

diff --git a/arch/arm/kernel/sys_oabi-compat.c b/arch/arm/kernel/sys_oabi-compat.c
index 702bd329d9d0..e90a3148f385 100644
--- a/arch/arm/kernel/sys_oabi-compat.c
+++ b/arch/arm/kernel/sys_oabi-compat.c
@@ -203,9 +203,9 @@ asmlinkage long sys_oabi_fcntl64(unsigned int fd, unsigned int cmd,
 	int ret;
 
 	switch (cmd) {
-	case F_GETLKP:
-	case F_SETLKP:
-	case F_SETLKPW:
+	case F_OFD_GETLK:
+	case F_OFD_SETLK:
+	case F_OFD_SETLKW:
 	case F_GETLK64:
 	case F_SETLK64:
 	case F_SETLKW64:
diff --git a/fs/compat.c b/fs/compat.c
index ca926ad0430c..66d3d3c6b4b2 100644
--- a/fs/compat.c
+++ b/fs/compat.c
@@ -457,9 +457,9 @@ COMPAT_SYSCALL_DEFINE3(fcntl64, unsigned int, fd, unsigned int, cmd,
 	case F_GETLK64:
 	case F_SETLK64:
 	case F_SETLKW64:
-	case F_GETLKP:
-	case F_SETLKP:
-	case F_SETLKPW:
+	case F_OFD_GETLK:
+	case F_OFD_SETLK:
+	case F_OFD_SETLKW:
 		ret = get_compat_flock64(&f, compat_ptr(arg));
 		if (ret != 0)
 			break;
@@ -468,7 +468,7 @@ COMPAT_SYSCALL_DEFINE3(fcntl64, unsigned int, fd, unsigned int, cmd,
 		conv_cmd = convert_fcntl_cmd(cmd);
 		ret = sys_fcntl(fd, conv_cmd, (unsigned long)&f);
 		set_fs(old_fs);
-		if ((conv_cmd == F_GETLK || conv_cmd == F_GETLKP) && ret == 0) {
+		if ((conv_cmd == F_GETLK || conv_cmd == F_OFD_GETLK) && ret == 0) {
 			/* need to return lock information - see above for commentary */
 			if (f.l_start > COMPAT_LOFF_T_MAX)
 				ret = -EOVERFLOW;
@@ -493,9 +493,9 @@ COMPAT_SYSCALL_DEFINE3(fcntl, unsigned int, fd, unsigned int, cmd,
 	case F_GETLK64:
 	case F_SETLK64:
 	case F_SETLKW64:
-	case F_GETLKP:
-	case F_SETLKP:
-	case F_SETLKPW:
+	case F_OFD_GETLK:
+	case F_OFD_SETLK:
+	case F_OFD_SETLKW:
 		return -EINVAL;
 	}
 	return compat_sys_fcntl64(fd, cmd, arg);
diff --git a/fs/fcntl.c b/fs/fcntl.c
index 9ead1596399a..72c82f69b01b 100644
--- a/fs/fcntl.c
+++ b/fs/fcntl.c
@@ -274,15 +274,15 @@ static long do_fcntl(int fd, unsigned int cmd, unsigned long arg,
 		break;
 #if BITS_PER_LONG != 32
 	/* 32-bit arches must use fcntl64() */
-	case F_GETLKP:
+	case F_OFD_GETLK:
 #endif
 	case F_GETLK:
 		err = fcntl_getlk(filp, cmd, (struct flock __user *) arg);
 		break;
 #if BITS_PER_LONG != 32
 	/* 32-bit arches must use fcntl64() */
-	case F_SETLKP:
-	case F_SETLKPW:
+	case F_OFD_SETLK:
+	case F_OFD_SETLKW:
 #endif
 		/* Fallthrough */
 	case F_SETLK:
@@ -399,13 +399,13 @@ SYSCALL_DEFINE3(fcntl64, unsigned int, fd, unsigned int, cmd,
 	
 	switch (cmd) {
 	case F_GETLK64:
-	case F_GETLKP:
+	case F_OFD_GETLK:
 		err = fcntl_getlk64(f.file, cmd, (struct flock64 __user *) arg);
 		break;
 	case F_SETLK64:
 	case F_SETLKW64:
-	case F_SETLKP:
-	case F_SETLKPW:
+	case F_OFD_SETLK:
+	case F_OFD_SETLKW:
 		err = fcntl_setlk64(fd, f.file, cmd,
 				(struct flock64 __user *) arg);
 		break;
diff --git a/fs/locks.c b/fs/locks.c
index b380f5543614..e1023b504279 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -1941,7 +1941,7 @@ int fcntl_getlk(struct file *filp, unsigned int cmd, struct flock __user *l)
 	if (error)
 		goto out;
 
-	if (cmd == F_GETLKP) {
+	if (cmd == F_OFD_GETLK) {
 		error = -EINVAL;
 		if (flock.l_pid != 0)
 			goto out;
@@ -2076,7 +2076,7 @@ again:
 	 * FL_FILE_PVT flag and override the owner.
 	 */
 	switch (cmd) {
-	case F_SETLKP:
+	case F_OFD_SETLK:
 		error = -EINVAL;
 		if (flock.l_pid != 0)
 			goto out;
@@ -2085,7 +2085,7 @@ again:
 		file_lock->fl_flags |= FL_FILE_PVT;
 		file_lock->fl_owner = (fl_owner_t)filp;
 		break;
-	case F_SETLKPW:
+	case F_OFD_SETLKW:
 		error = -EINVAL;
 		if (flock.l_pid != 0)
 			goto out;
@@ -2143,7 +2143,7 @@ int fcntl_getlk64(struct file *filp, unsigned int cmd, struct flock64 __user *l)
 	if (error)
 		goto out;
 
-	if (cmd == F_GETLKP) {
+	if (cmd == F_OFD_GETLK) {
 		error = -EINVAL;
 		if (flock.l_pid != 0)
 			goto out;
@@ -2211,7 +2211,7 @@ again:
 	 * FL_FILE_PVT flag and override the owner.
 	 */
 	switch (cmd) {
-	case F_SETLKP:
+	case F_OFD_SETLK:
 		error = -EINVAL;
 		if (flock.l_pid != 0)
 			goto out;
@@ -2220,7 +2220,7 @@ again:
 		file_lock->fl_flags |= FL_FILE_PVT;
 		file_lock->fl_owner = (fl_owner_t)filp;
 		break;
-	case F_SETLKPW:
+	case F_OFD_SETLKW:
 		error = -EINVAL;
 		if (flock.l_pid != 0)
 			goto out;
@@ -2413,7 +2413,7 @@ static void lock_get_status(struct seq_file *f, struct file_lock *fl,
 		if (fl->fl_flags & FL_ACCESS)
 			seq_printf(f, "ACCESS");
 		else if (IS_FILE_PVT(fl))
-			seq_printf(f, "FLPVT ");
+			seq_printf(f, "OFDLCK");
 		else
 			seq_printf(f, "POSIX ");
 
diff --git a/include/uapi/asm-generic/fcntl.h b/include/uapi/asm-generic/fcntl.h
index a9b13f8b3595..7543b3e51331 100644
--- a/include/uapi/asm-generic/fcntl.h
+++ b/include/uapi/asm-generic/fcntl.h
@@ -133,20 +133,20 @@
 #endif
 
 /*
- * fd "private" POSIX locks.
+ * Open File Description Locks
  *
- * Usually POSIX locks held by a process are released on *any* close and are
+ * Usually record locks held by a process are released on *any* close and are
  * not inherited across a fork().
  *
- * These cmd values will set locks that conflict with normal POSIX locks, but
- * are "owned" by the opened file, not the process. This means that they are
- * inherited across fork() like BSD (flock) locks, and they are only released
- * automatically when the last reference to the the open file against which
- * they were acquired is put.
+ * These cmd values will set locks that conflict with process-associated
+ * record  locks, but are "owned" by the open file description, not the
+ * process. This means that they are inherited across fork() like BSD (flock)
+ * locks, and they are only released automatically when the last reference to
+ * the the open file against which they were acquired is put.
  */
-#define F_GETLKP	36
-#define F_SETLKP	37
-#define F_SETLKPW	38
+#define F_OFD_GETLK	36
+#define F_OFD_SETLK	37
+#define F_OFD_SETLKW	38
 
 #define F_OWNER_TID	0
 #define F_OWNER_PID	1
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index b4beb77967b1..2c7341dbc5d6 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -3317,9 +3317,9 @@ static int selinux_file_fcntl(struct file *file, unsigned int cmd,
 	case F_GETLK:
 	case F_SETLK:
 	case F_SETLKW:
-	case F_GETLKP:
-	case F_SETLKP:
-	case F_SETLKPW:
+	case F_OFD_GETLK:
+	case F_OFD_SETLK:
+	case F_OFD_SETLKW:
 #if BITS_PER_LONG == 32
 	case F_GETLK64:
 	case F_SETLK64:
-- 
1.9.0

