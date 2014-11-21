Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758443AbaKUJlr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 04:41:47 -0500
Received: from mail-la0-f73.google.com ([209.85.215.73]:38676 "EHLO
	mail-la0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758394AbaKUJln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 04:41:43 -0500
X-Greylist: delayed 144820 seconds by postgrey-1.27 at vger.kernel.org; Fri, 21 Nov 2014 04:41:42 EST
From: David Drysdale <drysdale@google.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>, Eric Paris <eparis@redhat.com>,
        David Miller <davem@davemloft.net>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org,
        David Drysdale <drysdale@google.com>
Subject: [PATCH] vfs: renumber FMODE_NONOTIFY and add to uniqueness check
Date: Fri, 21 Nov 2014 09:41:22 +0000
Message-Id: <1416562882-21190-1-git-send-email-drysdale@google.com>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Although FMODE_NONOTIFY is only used internally in the kernel it is in
the same numbering space as the other O_* flags, as indicated by the
comment at the top of include/uapi/asm-generic/fcntl.h (and its use
in fs/notify/fanotify/fanotify_user.c).  However, its current value
clashes with the value of O_PATH on sparc, so renumber it to avoid
the clash.

All of this has happened before (12ed2e36c98aec6c4155, "fanotify:
FMODE_NONOTIFY and __O_SYNC in sparc conflict"), and all of this
will happen again -- so update the uniqueness check in fcntl_init()
to include __FMODE_NONOTIFY.

Signed-off-by: David Drysdale <drysdale@google.com>
---
 fs/fcntl.c                       | 5 +++--
 include/linux/fs.h               | 4 ++--
 include/uapi/asm-generic/fcntl.h | 2 +-
 3 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/fcntl.c b/fs/fcntl.c
index 99d440a4a6ba..ee85cd4e136a 100644
--- a/fs/fcntl.c
+++ b/fs/fcntl.c
@@ -740,14 +740,15 @@ static int __init fcntl_init(void)
 	 * Exceptions: O_NONBLOCK is a two bit define on parisc; O_NDELAY
 	 * is defined as O_NONBLOCK on some platforms and not on others.
 	 */
-	BUILD_BUG_ON(20 - 1 /* for O_RDONLY being 0 */ != HWEIGHT32(
+	BUILD_BUG_ON(21 - 1 /* for O_RDONLY being 0 */ != HWEIGHT32(
 		O_RDONLY	| O_WRONLY	| O_RDWR	|
 		O_CREAT		| O_EXCL	| O_NOCTTY	|
 		O_TRUNC		| O_APPEND	| /* O_NONBLOCK	| */
 		__O_SYNC	| O_DSYNC	| FASYNC	|
 		O_DIRECT	| O_LARGEFILE	| O_DIRECTORY	|
 		O_NOFOLLOW	| O_NOATIME	| O_CLOEXEC	|
-		__FMODE_EXEC	| O_PATH	| __O_TMPFILE
+		__FMODE_EXEC	| O_PATH	| __O_TMPFILE	|
+		__FMODE_NONOTIFY
 		));
 
 	fasync_cache = kmem_cache_create("fasync_cache",
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 9ab779e8a63c..fd8611d423a0 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -80,7 +80,7 @@ typedef void (dio_iodone_t)(struct kiocb *iocb, loff_t offset,
 
 /*
  * flags in file.f_mode.  Note that FMODE_READ and FMODE_WRITE must correspond
- * to O_WRONLY and O_RDWR via the strange trick in __dentry_open()
+ * to O_WRONLY and O_RDWR via the strange trick in OPEN_FMODE() below.
  */
 
 /* file is open for reading */
@@ -134,7 +134,7 @@ typedef void (dio_iodone_t)(struct kiocb *iocb, loff_t offset,
 #define FMODE_CAN_WRITE         ((__force fmode_t)0x40000)
 
 /* File was opened by fanotify and shouldn't generate fanotify events */
-#define FMODE_NONOTIFY		((__force fmode_t)0x1000000)
+#define FMODE_NONOTIFY		((__force fmode_t)0x4000000)
 
 /*
  * Flag for rw_copy_check_uvector and compat_rw_copy_check_uvector
diff --git a/include/uapi/asm-generic/fcntl.h b/include/uapi/asm-generic/fcntl.h
index 7543b3e51331..e063effe0cc1 100644
--- a/include/uapi/asm-generic/fcntl.h
+++ b/include/uapi/asm-generic/fcntl.h
@@ -5,7 +5,7 @@
 
 /*
  * FMODE_EXEC is 0x20
- * FMODE_NONOTIFY is 0x1000000
+ * FMODE_NONOTIFY is 0x4000000
  * These cannot be used by userspace O_* until internal and external open
  * flags are split.
  * -Eric Paris
-- 
2.1.0.rc2.206.gedb03e5

