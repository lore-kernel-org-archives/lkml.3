Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934663AbaE3USN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 16:18:13 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:49979 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933825AbaE3UFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 16:05:10 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, joseph@codesourcery.com,
        john.stultz@linaro.org, hch@infradead.org, tglx@linutronix.de,
        geert@linux-m68k.org, lftan@altera.com, hpa@zytor.com,
        linux-fsdevel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [RFC 03/32] fs: introduce sys_utimens64at
Date: Fri, 30 May 2014 22:01:27 +0200
Message-Id: <1401480116-1973111-4-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1401480116-1973111-1-git-send-email-arnd@arndb.de>
References: <1401480116-1973111-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:bq2v9lRjMo4sAMbnlsxlPAeqNQCs7+/PO5Hq9dAHqty
 HX+AROmDOpGairt5bfI4MJjVrTFRYenOyS67Wgia70Pj2e9v52
 3TTZ/kytRHJvUKVrAWy8oGeNZuwrXeDZHCT4T5cLM6vI16RJjL
 WSZaPqIeC2H144unWW0Gsi4HxJal683lIAMQcSM60/FmRC0nnh
 LTbLOo1lWqHQbYMTkUqnZd9yNVGjstYtkBklUOPykUQRVeCYIT
 KwWGLwtex4f9ksyK1mW1lJLrto0emrODXJ8ezCQOMUNySPwXhY
 CAwnmaTAAAxULJlQM39DQH0IZcO7NXorTa3pG4sODbpHmA+4+o
 UOR//+pLMeenulH4J8eb32JIVRA8CjD+pkAPT9U4f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This introduces a new variant of the utime/utimes/futimesat/utimensat
system call (used by /usr/bin/touch), which fixes the 32-bit limitation
of time_t at the kernel/user boundary for 32-bit machines.

Each of the variants is a strict superset of the functionality of the
previous ones, so we only need to add one more and let the libc
emulate the other interfaces based on that.

This moves over the existing compat_sys_utimensat implementation
from fs/compat.c into fs/utimes.c and changes the data types so
we use __kernel_timespec64 for the new native code path and use
__kernel_timespec32 for the compatibility with existing 32-bit
code, independent of whether we run on 32 or 64-bit CPUs.

Other patches in this series take care of the in-kernel handling of
inode times, but the full solution will require many other patches
system calls passing time_t values, and of course a C library with
adaptations to use those.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/alpha/kernel/osf_sys.c |  2 +-
 fs/compat.c                 | 19 ++----------------
 fs/utimes.c                 | 47 ++++++++++++++++++++++++++++++++++++++-------
 include/linux/compat.h      |  2 +-
 include/linux/syscalls.h    |  9 ++++++++-
 include/linux/time.h        |  2 +-
 init/initramfs.c            |  2 +-
 7 files changed, 54 insertions(+), 29 deletions(-)

diff --git a/arch/alpha/kernel/osf_sys.c b/arch/alpha/kernel/osf_sys.c
index 1402fcc..96b4903 100644
--- a/arch/alpha/kernel/osf_sys.c
+++ b/arch/alpha/kernel/osf_sys.c
@@ -1070,7 +1070,7 @@ SYSCALL_DEFINE3(osf_setitimer, int, which, struct itimerval32 __user *, in,
 SYSCALL_DEFINE2(osf_utimes, const char __user *, filename,
 		struct timeval32 __user *, tvs)
 {
-	struct timespec tv[2];
+	struct __kernel_timespec64 tv[2];
 
 	if (tvs) {
 		struct timeval ktvs[2];
diff --git a/fs/compat.c b/fs/compat.c
index 66d3d3c..1e281f3 100644
--- a/fs/compat.c
+++ b/fs/compat.c
@@ -75,7 +75,7 @@ int compat_printk(const char *fmt, ...)
 COMPAT_SYSCALL_DEFINE2(utime, const char __user *, filename,
 		       struct compat_utimbuf __user *, t)
 {
-	struct timespec tv[2];
+	struct __kernel_timespec64 tv[2];
 
 	if (t) {
 		if (get_user(tv[0].tv_sec, &t->actime) ||
@@ -87,24 +87,9 @@ COMPAT_SYSCALL_DEFINE2(utime, const char __user *, filename,
 	return do_utimes(AT_FDCWD, filename, t ? tv : NULL, 0);
 }
 
-COMPAT_SYSCALL_DEFINE4(utimensat, unsigned int, dfd, const char __user *, filename, struct compat_timespec __user *, t, int, flags)
-{
-	struct timespec tv[2];
-
-	if  (t) {
-		if (compat_get_timespec(&tv[0], &t[0]) ||
-		    compat_get_timespec(&tv[1], &t[1]))
-			return -EFAULT;
-
-		if (tv[0].tv_nsec == UTIME_OMIT && tv[1].tv_nsec == UTIME_OMIT)
-			return 0;
-	}
-	return do_utimes(dfd, filename, t ? tv : NULL, flags);
-}
-
 COMPAT_SYSCALL_DEFINE3(futimesat, unsigned int, dfd, const char __user *, filename, struct compat_timeval __user *, t)
 {
-	struct timespec tv[2];
+	struct __kernel_timespec64 tv[2];
 
 	if (t) {
 		if (get_user(tv[0].tv_sec, &t[0].tv_sec) ||
diff --git a/fs/utimes.c b/fs/utimes.c
index aa138d6..89c23ce 100644
--- a/fs/utimes.c
+++ b/fs/utimes.c
@@ -26,7 +26,7 @@
  */
 SYSCALL_DEFINE2(utime, char __user *, filename, struct utimbuf __user *, times)
 {
-	struct timespec tv[2];
+	struct __kernel_timespec64 tv[2];
 
 	if (times) {
 		if (get_user(tv[0].tv_sec, &times->actime) ||
@@ -48,7 +48,7 @@ static bool nsec_valid(long nsec)
 	return nsec >= 0 && nsec <= 999999999;
 }
 
-static int utimes_common(struct path *path, struct timespec *times)
+static int utimes_common(struct path *path, struct __kernel_timespec64 *times)
 {
 	int error;
 	struct iattr newattrs;
@@ -133,8 +133,8 @@ out:
  * must be owner or have write permission.
  * Else, update from *times, must be owner or super user.
  */
-long do_utimes(int dfd, const char __user *filename, struct timespec *times,
-	       int flags)
+long do_utimes(int dfd, const char __user *filename,
+	       struct __kernel_timespec64 *times, int flags)
 {
 	int error = -EINVAL;
 
@@ -182,10 +182,15 @@ out:
 	return error;
 }
 
+#ifdef CONFIG_64BIT
 SYSCALL_DEFINE4(utimensat, int, dfd, const char __user *, filename,
-		struct timespec __user *, utimes, int, flags)
+		struct __kernel_timespec64 __user *, utimes, int, flags)
+#else
+SYSCALL_DEFINE4(utimens64at, int, dfd, const char __user *, filename,
+		struct __kernel_timespec64 __user *, utimes, int, flags)
+#endif
 {
-	struct timespec tstimes[2];
+	struct __kernel_timespec64 tstimes[2];
 
 	if (utimes) {
 		if (copy_from_user(&tstimes, utimes, sizeof(tstimes)))
@@ -200,11 +205,39 @@ SYSCALL_DEFINE4(utimensat, int, dfd, const char __user *, filename,
 	return do_utimes(dfd, filename, utimes ? tstimes : NULL, flags);
 }
 
+#ifdef CONFIG_64BIT
+COMPAT_SYSCALL_DEFINE4(utimensat, unsigned int, dfd, const char __user *, filename,
+		struct __kernel_timespec32 __user *, t, int, flags)
+#else
+SYSCALL_DEFINE4(utimensat, int, dfd, const char __user *, filename,
+		struct __kernel_timespec32 __user *, utimes, int, flags)
+#endif
+{
+	struct __kernel_timespec64 tstimes64[2];
+	struct __kernel_timespec32 tstimes[2];
+
+	if (utimes) {
+		if (copy_from_user(&tstimes, utimes, sizeof(tstimes)))
+			return -EFAULT;
+
+		/* Nothing to do, we must not even check the path.  */
+		if (tstimes[0].tv_nsec == UTIME_OMIT &&
+		    tstimes[1].tv_nsec == UTIME_OMIT)
+			return 0;
+		tstimes64[0].tv_sec = tstimes[0].tv_sec;
+		tstimes64[0].tv_nsec = tstimes[0].tv_nsec;
+		tstimes64[1].tv_sec = tstimes[1].tv_sec;
+		tstimes64[1].tv_nsec = tstimes[1].tv_nsec;
+	}
+
+	return do_utimes(dfd, filename, utimes ? tstimes64 : NULL, flags);
+}
+
 SYSCALL_DEFINE3(futimesat, int, dfd, const char __user *, filename,
 		struct timeval __user *, utimes)
 {
 	struct timeval times[2];
-	struct timespec tstimes[2];
+	struct __kernel_timespec64 tstimes[2];
 
 	if (utimes) {
 		if (copy_from_user(&times, utimes, sizeof(times)))
diff --git a/include/linux/compat.h b/include/linux/compat.h
index e649426..7fd34f9 100644
--- a/include/linux/compat.h
+++ b/include/linux/compat.h
@@ -453,7 +453,7 @@ asmlinkage long compat_sys_utime(const char __user *filename,
 				 struct compat_utimbuf __user *t);
 asmlinkage long compat_sys_utimensat(unsigned int dfd,
 				     const char __user *filename,
-				     struct compat_timespec __user *t,
+				     struct __kernel_timespec32 __user *t,
 				     int flags);
 
 asmlinkage long compat_sys_time(compat_time_t __user *tloc);
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index b0881a0..2332448 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -770,8 +770,15 @@ asmlinkage long sys_fstatat64(int dfd, const char __user *filename,
 			       struct stat64 __user *statbuf, int flag);
 asmlinkage long sys_readlinkat(int dfd, const char __user *path, char __user *buf,
 			       int bufsiz);
+#ifdef CONFIG_64BIT
 asmlinkage long sys_utimensat(int dfd, const char __user *filename,
-				struct timespec __user *utimes, int flags);
+				struct __kernel_timespec64 __user *utimes, int flags);
+#else
+asmlinkage long sys_utimens64at(int dfd, const char __user *filename,
+				struct __kernel_timespec64 __user *utimes, int flags);
+asmlinkage long sys_utimensat(int dfd, const char __user *filename,
+				struct __kernel_timespec32 __user *utimes, int flags);
+#endif
 asmlinkage long sys_unshare(unsigned long unshare_flags);
 
 asmlinkage long sys_splice(int fd_in, loff_t __user *off_in,
diff --git a/include/linux/time.h b/include/linux/time.h
index e2d5aa2..f431263 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -213,7 +213,7 @@ extern int do_settimeofday(const struct timespec *tv);
 extern int do_sys_settimeofday(const struct timespec *tv,
 			       const struct timezone *tz);
 #define do_posix_clock_monotonic_gettime(ts) ktime_get_ts(ts)
-extern long do_utimes(int dfd, const char __user *filename, struct timespec *times, int flags);
+extern long do_utimes(int dfd, const char __user *filename, struct __kernel_timespec64 *times, int flags);
 struct itimerval;
 extern int do_setitimer(int which, struct itimerval *value,
 			struct itimerval *ovalue);
diff --git a/init/initramfs.c b/init/initramfs.c
index a8497fa..5e89fb5 100644
--- a/init/initramfs.c
+++ b/init/initramfs.c
@@ -86,7 +86,7 @@ static void __init free_hash(void)
 
 static long __init do_utime(char *filename, time_t mtime)
 {
-	struct timespec t[2];
+	struct __kernel_timespec64 t[2];
 
 	t[0].tv_sec = mtime;
 	t[0].tv_nsec = 0;
-- 
1.8.3.2

