Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030450AbaE3UHA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 16:07:00 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:62950 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933084AbaE3UG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 16:06:57 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, joseph@codesourcery.com,
        john.stultz@linaro.org, hch@infradead.org, tglx@linutronix.de,
        geert@linux-m68k.org, lftan@altera.com, hpa@zytor.com,
        linux-fsdevel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [RFC 05/32] arch: hook up new stat and utimes syscalls
Date: Fri, 30 May 2014 22:01:29 +0200
Message-Id: <1401480116-1973111-6-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1401480116-1973111-1-git-send-email-arnd@arndb.de>
References: <1401480116-1973111-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:A8BmL/Vb/wXNa6u+K2JTkXEDUyZXGoX7v/Fu3xIjQ4K
 FxlzOPOI9/UsOyCgNN+u7CDPk2d/YpSw7J3DtO8c69nvdD7kss
 7YdHmWEtz3u9jia5xRVqx+z4+CUp0nCn0L22I+e5AadX0pvqC7
 rPJ8HH44HHS+FRo+LtMVnN3xyKMWoszNhF4vS0eS+uadpZZPQH
 J7Xb++pL/cGW2G9s57fp9XUUBMVjf4JoDUVYo8kpMOA2nm72Lg
 plbuAcSM03IR2wGoXf0kYGs5sby9ZGCAibXYnIPKW5AQqGeSlo
 X1lG9y6qpdgUyd9x79R9+NzOh/iDbHScNNjf8fcslD5HTLd/7k
 d6l5asRbOIUDne85W8AZo93kBykVtSqq/gCPKYln6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds the newly added system calls for newfstat64, newfstatat64
and utimens64at to x86, arm and all architectures using the generic
syscall ABI.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/include/asm/unistd.h      |  2 +-
 arch/arm/include/uapi/asm/stat.h   | 25 +++++++++++++++++++++++++
 arch/arm/include/uapi/asm/unistd.h |  3 +++
 arch/arm/kernel/calls.S            |  3 +++
 arch/arm64/include/asm/unistd32.h  |  5 ++++-
 arch/x86/include/uapi/asm/stat.h   | 28 ++++++++++++++++++++++++++++
 arch/x86/syscalls/syscall_32.tbl   |  3 +++
 include/uapi/asm-generic/stat.h    | 29 +++++++++++++++++++++++++++--
 include/uapi/asm-generic/unistd.h  |  8 +++++++-
 9 files changed, 101 insertions(+), 5 deletions(-)

diff --git a/arch/arm/include/asm/unistd.h b/arch/arm/include/asm/unistd.h
index 4387624..2ed963a 100644
--- a/arch/arm/include/asm/unistd.h
+++ b/arch/arm/include/asm/unistd.h
@@ -15,7 +15,7 @@
 
 #include <uapi/asm/unistd.h>
 
-#define __NR_syscalls  (384)
+#define __NR_syscalls  (388)
 #define __ARM_NR_cmpxchg		(__ARM_NR_BASE+0x00fff0)
 
 #define __ARCH_WANT_STAT64
diff --git a/arch/arm/include/uapi/asm/stat.h b/arch/arm/include/uapi/asm/stat.h
index 42c0c13..ee2ba23 100644
--- a/arch/arm/include/uapi/asm/stat.h
+++ b/arch/arm/include/uapi/asm/stat.h
@@ -48,6 +48,31 @@ struct stat {
 	unsigned long  __unused5;
 };
 
+/* this matches the arm64 'struct stat' to allow a simpler compat ABI */
+#define __ARCH_HAS_NEWSTAT64
+struct newstat64 {
+	unsigned long long	st_dev;		/* Device.  */
+	unsigned long long	st_ino;		/* File serial number.  */
+	unsigned int		st_mode;	/* File mode.  */
+	unsigned int		st_nlink;	/* Link count.  */
+	unsigned int		st_uid;		/* User ID of the file's owner.  */
+	unsigned int		st_gid;		/* Group ID of the file's group. */
+	unsigned long long	st_rdev;	/* Device number, if device.  */
+	unsigned long long	__pad1;
+	long long		st_size;	/* Size of file, in bytes.  */
+	int			st_blksize;	/* Optimal block size for I/O.  */
+	int			__pad2;
+	long long		st_blocks;	/* Number 512-byte blocks allocated. */
+	long long		st_atime;	/* Time of last access.  */
+	unsigned long long	st_atime_nsec;
+	long long		st_mtime;	/* Time of last modification.  */
+	unsigned long long	st_mtime_nsec;
+	long long		st_ctime;	/* Time of last status change.  */
+	unsigned long long	st_ctime_nsec;
+	unsigned int		__unused4;
+	unsigned int		__unused5;
+};
+
 /* This matches struct stat64 in glibc2.1, hence the absolutely
  * insane amounts of padding around dev_t's.
  * Note: The kernel zero's the padded region because glibc might read them
diff --git a/arch/arm/include/uapi/asm/unistd.h b/arch/arm/include/uapi/asm/unistd.h
index ba94446..371f8d6 100644
--- a/arch/arm/include/uapi/asm/unistd.h
+++ b/arch/arm/include/uapi/asm/unistd.h
@@ -409,6 +409,9 @@
 #define __NR_sched_setattr		(__NR_SYSCALL_BASE+380)
 #define __NR_sched_getattr		(__NR_SYSCALL_BASE+381)
 #define __NR_renameat2			(__NR_SYSCALL_BASE+382)
+#define __NR_newfstat64			(__NR_SYSCALL_BASE+383)
+#define __NR_newfstatat64		(__NR_SYSCALL_BASE+384)
+#define __NR_utimens64at		(__NR_SYSCALL_BASE+385)
 
 /*
  * This may need to be greater than __NR_last_syscall+1 in order to
diff --git a/arch/arm/kernel/calls.S b/arch/arm/kernel/calls.S
index 8f51bdc..a51a418 100644
--- a/arch/arm/kernel/calls.S
+++ b/arch/arm/kernel/calls.S
@@ -392,6 +392,9 @@
 /* 380 */	CALL(sys_sched_setattr)
 		CALL(sys_sched_getattr)
 		CALL(sys_renameat2)
+		CALL(sys_newfstat64)
+		CALL(sys_newfstatat64)
+/* 385 */	CALL(sys_utimens64at)
 #ifndef syscalls_counted
 .equ syscalls_padding, ((NR_syscalls + 3) & ~3) - NR_syscalls
 #define syscalls_counted
diff --git a/arch/arm64/include/asm/unistd32.h b/arch/arm64/include/asm/unistd32.h
index c8d8fc1..348c009 100644
--- a/arch/arm64/include/asm/unistd32.h
+++ b/arch/arm64/include/asm/unistd32.h
@@ -404,8 +404,11 @@ __SYSCALL(379, sys_finit_module)
 __SYSCALL(380, sys_sched_setattr)
 __SYSCALL(381, sys_sched_getattr)
 __SYSCALL(382, sys_renameat2)
+__SYSCALL(383, sys_newfstat)
+__SYSCALL(384, sys_newfstatat)
+__SYSCALL(385, sys_utimensat)
 
-#define __NR_compat_syscalls		383
+#define __NR_compat_syscalls		386
 
 /*
  * Compat syscall numbers used by the AArch64 kernel.
diff --git a/arch/x86/include/uapi/asm/stat.h b/arch/x86/include/uapi/asm/stat.h
index bc03eb5..43f7c4a 100644
--- a/arch/x86/include/uapi/asm/stat.h
+++ b/arch/x86/include/uapi/asm/stat.h
@@ -71,6 +71,34 @@ struct stat64 {
 	unsigned long long	st_ino;
 };
 
+/*
+ * This matches the native 'struct stat' on x86-64 and
+ * provides 64-bit timestamps on __i386__
+ */
+#define __ARCH_HAS_NEWSTAT64
+struct newstat64 {
+	unsigned long long	st_dev;
+	unsigned long long	st_ino;
+	unsigned long long	st_nlink;
+
+	unsigned int		st_mode;
+	unsigned int		st_uid;
+	unsigned int		st_gid;
+	unsigned int		__pad0;
+	unsigned long long	st_rdev;
+	long long		st_size;
+	long long		st_blksize;
+	long long		st_blocks;	/* Number 512-byte blocks allocated. */
+
+	unsigned long long	st_atime;
+	unsigned long long	st_atime_nsec;
+	unsigned long long	st_mtime;
+	unsigned long long	st_mtime_nsec;
+	unsigned long long	st_ctime;
+	unsigned long long	st_ctime_nsec;
+	long long		__unused[3];
+};
+
 /* We don't need to memset the whole thing just to initialize the padding */
 #define INIT_STRUCT_STAT64_PADDING(st) do {		\
 	memset(&st.__pad0, 0, sizeof(st.__pad0));	\
diff --git a/arch/x86/syscalls/syscall_32.tbl b/arch/x86/syscalls/syscall_32.tbl
index d6b8679..91b6a41 100644
--- a/arch/x86/syscalls/syscall_32.tbl
+++ b/arch/x86/syscalls/syscall_32.tbl
@@ -360,3 +360,6 @@
 351	i386	sched_setattr		sys_sched_setattr
 352	i386	sched_getattr		sys_sched_getattr
 353	i386	renameat2		sys_renameat2
+354	i386	newfstat64		sys_newfstat64			sys_newfstat
+355	i386	newfstatat64		sys_newfstatat64		sys_newfstatat
+356	i386	utimens64at		sys_utimens64at			sys_utimensat
diff --git a/include/uapi/asm-generic/stat.h b/include/uapi/asm-generic/stat.h
index bd8cad2..904e5dc 100644
--- a/include/uapi/asm-generic/stat.h
+++ b/include/uapi/asm-generic/stat.h
@@ -43,8 +43,33 @@ struct stat {
 	unsigned int	__unused5;
 };
 
-/* This matches struct stat64 in glibc2.1. Only used for 32 bit. */
-#if __BITS_PER_LONG != 64 || defined(__ARCH_WANT_STAT64)
+#if __BITS_PER_LONG != 64
+#define __ARCH_HAVE_NEWSTAT64
+struct newstat64 {
+	unsigned long long	st_dev;		/* Device.  */
+	unsigned long long	st_ino;		/* File serial number.  */
+	unsigned int		st_mode;	/* File mode.  */
+	unsigned int		st_nlink;	/* Link count.  */
+	unsigned int		st_uid;		/* User ID of the file's owner.  */
+	unsigned int		st_gid;		/* Group ID of the file's group. */
+	unsigned long long	st_rdev;	/* Device number, if device.  */
+	unsigned long long	__pad1;
+	long long		st_size;	/* Size of file, in bytes.  */
+	int			st_blksize;	/* Optimal block size for I/O.  */
+	int			__pad2;
+	long long		st_blocks;	/* Number 512-byte blocks allocated. */
+	long long		st_atime;	/* Time of last access.  */
+	unsigned long long	st_atime_nsec;
+	long long		st_mtime;	/* Time of last modification.  */
+	unsigned long long	st_mtime_nsec;
+	long long		st_ctime;	/* Time of last status change.  */
+	unsigned long long	st_ctime_nsec;
+	unsigned int		__unused4;
+	unsigned int		__unused5;
+};
+#endif
+
+#if __BITS_PER_LONG != 64 ||  defined(__ARCH_WANT_STAT64)
 struct stat64 {
 	unsigned long long st_dev;	/* Device.  */
 	unsigned long long st_ino;	/* File serial number.  */
diff --git a/include/uapi/asm-generic/unistd.h b/include/uapi/asm-generic/unistd.h
index 3336406..ddcbd42 100644
--- a/include/uapi/asm-generic/unistd.h
+++ b/include/uapi/asm-generic/unistd.h
@@ -699,9 +699,15 @@ __SYSCALL(__NR_sched_setattr, sys_sched_setattr)
 __SYSCALL(__NR_sched_getattr, sys_sched_getattr)
 #define __NR_renameat2 276
 __SYSCALL(__NR_renameat2, sys_renameat2)
+#define __NR_newfstat64 277
+__SC_COMP_3264(__NR_newfstat64, sys_newfstat64, sys_newfstat, sys_newfstat)
+#define __NR_newfstatat64 278
+__SC_COMP_3264(__NR_newfstatat64, sys_newfstatat64, sys_newfstatat, sys_newfstatat)
+#define __NR_utimensat64 279
+__SC_COMP_3264(__NR_utimens64at, sys_utimensat, sys_utimensat)
 
 #undef __NR_syscalls
-#define __NR_syscalls 277
+#define __NR_syscalls 280
 
 /*
  * All syscalls below here should go away really,
-- 
1.8.3.2

