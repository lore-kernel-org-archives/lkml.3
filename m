Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754818Ab3L0R1T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 12:27:19 -0500
Received: from mail-gg0-f175.google.com ([209.85.161.175]:65466 "EHLO
	mail-gg0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754559Ab3L0RZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 12:25:30 -0500
From: "H.J. Lu" <hjl.tools@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Cc: "H.J. Lu" <hjl.tools@gmail.com>
Subject: [PATCH 2/8] Use __kernel_long_t/__kernel_ulong_t in <linux/resource.h>
Date: Fri, 27 Dec 2013 09:25:06 -0800
Message-Id: <1388165112-6545-3-git-send-email-hjl.tools@gmail.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1388165112-6545-1-git-send-email-hjl.tools@gmail.com>
References: <1388165112-6545-1-git-send-email-hjl.tools@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both x32 and x86-64 use the same struct rusage and struct rlimit for
system calls.  But x32 log is 32-bit.  This patch change uapi
<linux/resource.h> to use __kernel_long_t in struct rusage and
__kernel_ulong_t in and struct rlimit if __BITS_PER_LONG == 64.

Signed-off-by: H.J. Lu <hjl.tools@gmail.com>
---
 include/uapi/linux/resource.h | 26 ++++++++++++++++++++++++--
 1 file changed, 24 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/resource.h b/include/uapi/linux/resource.h
index e0ed284..87d2daa 100644
--- a/include/uapi/linux/resource.h
+++ b/include/uapi/linux/resource.h
@@ -23,6 +23,22 @@
 struct	rusage {
 	struct timeval ru_utime;	/* user time used */
 	struct timeval ru_stime;	/* system time used */
+#if __BITS_PER_LONG == 64
+	__kernel_long_t	ru_maxrss;	/* maximum resident set size */
+	__kernel_long_t	ru_ixrss;	/* integral shared memory size */
+	__kernel_long_t	ru_idrss;	/* integral unshared data size */
+	__kernel_long_t	ru_isrss;	/* integral unshared stack size */
+	__kernel_long_t	ru_minflt;	/* page reclaims */
+	__kernel_long_t	ru_majflt;	/* page faults */
+	__kernel_long_t	ru_nswap;	/* swaps */
+	__kernel_long_t	ru_inblock;	/* block input operations */
+	__kernel_long_t	ru_oublock;	/* block output operations */
+	__kernel_long_t	ru_msgsnd;	/* messages sent */
+	__kernel_long_t	ru_msgrcv;	/* messages received */
+	__kernel_long_t	ru_nsignals;	/* signals received */
+	__kernel_long_t	ru_nvcsw;	/* voluntary context switches */
+	__kernel_long_t	ru_nivcsw;	/* involuntary " */
+#else
 	long	ru_maxrss;		/* maximum resident set size */
 	long	ru_ixrss;		/* integral shared memory size */
 	long	ru_idrss;		/* integral unshared data size */
@@ -37,11 +53,17 @@ struct	rusage {
 	long	ru_nsignals;		/* signals received */
 	long	ru_nvcsw;		/* voluntary context switches */
 	long	ru_nivcsw;		/* involuntary " */
+#endif
 };
 
 struct rlimit {
-	unsigned long	rlim_cur;
-	unsigned long	rlim_max;
+#if __BITS_PER_LONG == 64
+	__kernel_ulong_t	rlim_cur;
+	__kernel_ulong_t	rlim_max;
+#else
+	unsigned long		rlim_cur;
+	unsigned long		rlim_max;
+#endif
 };
 
 #define RLIM64_INFINITY		(~0ULL)
-- 
1.8.4.2

