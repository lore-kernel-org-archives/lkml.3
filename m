Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422701AbaE3UOT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 16:14:19 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:55103 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933857AbaE3UG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 16:06:59 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, joseph@codesourcery.com,
        john.stultz@linaro.org, hch@infradead.org, tglx@linutronix.de,
        geert@linux-m68k.org, lftan@altera.com, hpa@zytor.com,
        linux-fsdevel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [RFC 02/32] uapi: add struct __kernel_timespec{32,64}
Date: Fri, 30 May 2014 22:01:26 +0200
Message-Id: <1401480116-1973111-3-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1401480116-1973111-1-git-send-email-arnd@arndb.de>
References: <1401480116-1973111-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:HWFkjSNk+S98MDAvHfQO1+AhKonyIhPLwrjt/VuGQJ9
 KbaGlC8ja9iG8oPQpwnd0maxTZz6hain0CdiyiGExxPQw77yFl
 cfQgjZzT4X8p+U2ICV+R6Fl6GKCtSXjRzIL+WTJswcfAiS8eRR
 Gt01raITUrtT0P3Dsh3lw9Fklm4FxxcBvHf1vFnjUyWlCwdVRM
 8hBCT4JOlYS/TL+jOZ5DwN04rC35abZC+daf4gu5P64TcNRcrW
 a/12FgxJqHwzaTpsB4dkI6ej1uvSQoRzXzBBaqV/D0yTKnWk4o
 d+JV4p/gv4/GuB2Xn0odT3wG1n3qyaim/kLG/syn/UdB56nfig
 N+zIv52m6cEcf8Tj8Fe4YcN2fSd/oI+1WoRo4IRza
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We cannot use time_t or any derived structures beyond the year
2038 in interfaces between kernel and user space, on 32-bit
machines.

This is my suggestion for how to migrate syscall and ioctl
interfaces: We completely phase out time_t, timeval and timespec
from the uapi header files and replace them with types that are
either explicitly safe (__kernel_timespec64), or explicitly
unsafe (e.g. __kernel_timespec32). For each unsafe interface,
there needs to be a safe replacement interface.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 include/uapi/linux/time.h | 40 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 39 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/time.h b/include/uapi/linux/time.h
index e75e1b6..e2b56a3 100644
--- a/include/uapi/linux/time.h
+++ b/include/uapi/linux/time.h
@@ -3,7 +3,18 @@
 
 #include <linux/types.h>
 
-
+/*
+ * time_t, timespec and timeval are not safe to use beyond
+ * 2038 on 32-bit systems, and should be phased out for
+ * in-kernel uses as well as interfaces to user space.
+ *
+ * Inside of the kernel, we can use e.g. inode_time,
+ * ktime_t or timespec64, as appropriate.
+ *
+ * In the long run, we have to stop making these definitions
+ * visibile to user headers, so libc can define its own
+ * 64-bit types.
+ */
 #ifndef _STRUCT_TIMESPEC
 #define _STRUCT_TIMESPEC
 struct timespec {
@@ -17,6 +28,33 @@ struct timeval {
 	__kernel_suseconds_t	tv_usec;	/* microseconds */
 };
 
+/*
+ * __kernel_timespec64 is the general type to be used for
+ * new user space interfaces passing a time argument.
+ * 64-bit nanoseconds is a bit silly, but the advantage is
+ * that it is compatible with the native 'struct timespec'
+ * on 64-bit user space. This simplifies the compat code.
+ */
+struct __kernel_timespec64 {
+	long long tv_sec;
+	long long tv_nsec;
+};
+
+/*
+ * As interfaces get moved over from time_t, timeval and timespec
+ * to __kernel_timespec64, we have to provide backwards compatibility
+ * interfaces. These can use __kernel_timespec32. Other types will
+ * be needed as required.
+ * The compat syscalls and ioctls can also migrate from compat_timespec
+ * to __kernel_timespec32 in order to share the implementation with
+ * the native 32-bit legacy handlers.
+ */
+struct __kernel_timespec32 {
+	int	tv_sec;
+	int	tv_nsec;
+};
+
+/* timezone is safe for use beyond 2038 */
 struct timezone {
 	int	tz_minuteswest;	/* minutes west of Greenwich */
 	int	tz_dsttime;	/* type of dst correction */
-- 
1.8.3.2

