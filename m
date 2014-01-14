Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752087AbaANTJT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 14:09:19 -0500
Received: from mail-qa0-f43.google.com ([209.85.216.43]:65226 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751852AbaANTHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 14:07:23 -0500
From: Jeff Layton <jlayton@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: nfs-ganesha-devel@lists.sourceforge.net, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v6 12/14] locks: pass the cmd value to fcntl_getlk/getlk64
Date: Tue, 14 Jan 2014 14:06:52 -0500
Message-Id: <1389726414-30990-13-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1389726414-30990-1-git-send-email-jlayton@redhat.com>
References: <1389726414-30990-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Once we introduce file private locks, we'll need to know what cmd value
was used, as that affects the ownership and whether a conflict would
arise.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/fcntl.c         |  4 ++--
 fs/locks.c         |  4 ++--
 include/linux/fs.h | 10 ++++++----
 3 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/fs/fcntl.c b/fs/fcntl.c
index ef68665..7ef7f2d 100644
--- a/fs/fcntl.c
+++ b/fs/fcntl.c
@@ -273,7 +273,7 @@ static long do_fcntl(int fd, unsigned int cmd, unsigned long arg,
 		err = setfl(fd, filp, arg);
 		break;
 	case F_GETLK:
-		err = fcntl_getlk(filp, (struct flock __user *) arg);
+		err = fcntl_getlk(filp, cmd, (struct flock __user *) arg);
 		break;
 	case F_SETLK:
 	case F_SETLKW:
@@ -389,7 +389,7 @@ SYSCALL_DEFINE3(fcntl64, unsigned int, fd, unsigned int, cmd,
 	
 	switch (cmd) {
 		case F_GETLK64:
-			err = fcntl_getlk64(f.file, (struct flock64 __user *) arg);
+			err = fcntl_getlk64(f.file, cmd, (struct flock64 __user *) arg);
 			break;
 		case F_SETLK64:
 		case F_SETLKW64:
diff --git a/fs/locks.c b/fs/locks.c
index 5953b2c..f8cd6d7 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -1898,7 +1898,7 @@ static void posix_lock_to_flock64(struct flock64 *flock, struct file_lock *fl)
 /* Report the first existing lock that would conflict with l.
  * This implements the F_GETLK command of fcntl().
  */
-int fcntl_getlk(struct file *filp, struct flock __user *l)
+int fcntl_getlk(struct file *filp, unsigned int cmd, struct flock __user *l)
 {
 	struct file_lock file_lock;
 	struct flock flock;
@@ -2066,7 +2066,7 @@ out:
 /* Report the first existing lock that would conflict with l.
  * This implements the F_GETLK command of fcntl().
  */
-int fcntl_getlk64(struct file *filp, struct flock64 __user *l)
+int fcntl_getlk64(struct file *filp, unsigned int cmd, struct flock64 __user *l)
 {
 	struct file_lock file_lock;
 	struct flock64 flock;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 639a3b7..d9bc9b5 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -993,12 +993,12 @@ struct file_lock {
 extern void send_sigio(struct fown_struct *fown, int fd, int band);
 
 #ifdef CONFIG_FILE_LOCKING
-extern int fcntl_getlk(struct file *, struct flock __user *);
+extern int fcntl_getlk(struct file *, unsigned int, struct flock __user *);
 extern int fcntl_setlk(unsigned int, struct file *, unsigned int,
 			struct flock __user *);
 
 #if BITS_PER_LONG == 32
-extern int fcntl_getlk64(struct file *, struct flock64 __user *);
+extern int fcntl_getlk64(struct file *, unsigned int, struct flock64 __user *);
 extern int fcntl_setlk64(unsigned int, struct file *, unsigned int,
 			struct flock64 __user *);
 #endif
@@ -1031,7 +1031,8 @@ extern int lease_modify(struct file_lock **, int);
 extern int lock_may_read(struct inode *, loff_t start, unsigned long count);
 extern int lock_may_write(struct inode *, loff_t start, unsigned long count);
 #else /* !CONFIG_FILE_LOCKING */
-static inline int fcntl_getlk(struct file *file, struct flock __user *user)
+static inline int fcntl_getlk(struct file *file, unsigned int cmd,
+			      struct flock __user *user)
 {
 	return -EINVAL;
 }
@@ -1043,7 +1044,8 @@ static inline int fcntl_setlk(unsigned int fd, struct file *file,
 }
 
 #if BITS_PER_LONG == 32
-static inline int fcntl_getlk64(struct file *file, struct flock64 __user *user)
+static inline int fcntl_getlk64(struct file *file, unsigned int cmd,
+				struct flock64 __user *user)
 {
 	return -EINVAL;
 }
-- 
1.8.4.2

