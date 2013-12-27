Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754697Ab3L0RZc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 12:25:32 -0500
Received: from mail-gg0-f172.google.com ([209.85.161.172]:55759 "EHLO
	mail-gg0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754542Ab3L0RZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 12:25:29 -0500
From: "H.J. Lu" <hjl.tools@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Cc: "H.J. Lu" <hjl.tools@gmail.com>
Subject: [PATCH 1/8] Use __kernel_long_t in struct timex
Date: Fri, 27 Dec 2013 09:25:05 -0800
Message-Id: <1388165112-6545-2-git-send-email-hjl.tools@gmail.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1388165112-6545-1-git-send-email-hjl.tools@gmail.com>
References: <1388165112-6545-1-git-send-email-hjl.tools@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

X32 adjtimex system call is the same as x86-64 adjtimex system call,
which uses 64-bit integer for long in struct timex. But x32 long is
32 bit.  This patch replaces long in struct timex with __kernel_long_t
if __BITS_PER_LONG == 64.

Signed-off-by: H.J. Lu <hjl.tools@gmail.com>
---
 include/uapi/linux/timex.h | 46 ++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 38 insertions(+), 8 deletions(-)

diff --git a/include/uapi/linux/timex.h b/include/uapi/linux/timex.h
index a7ea81f..98314e9 100644
--- a/include/uapi/linux/timex.h
+++ b/include/uapi/linux/timex.h
@@ -63,28 +63,58 @@
  */
 struct timex {
 	unsigned int modes;	/* mode selector */
+#if __BITS_PER_LONG == 64
+	__kernel_long_t offset;	/* time offset (usec) */
+	__kernel_long_t freq;	/* frequency offset (scaled ppm) */
+	__kernel_long_t maxerror;/* maximum error (usec) */
+	__kernel_long_t esterror;/* estimated error (usec) */
+#else
 	long offset;		/* time offset (usec) */
 	long freq;		/* frequency offset (scaled ppm) */
 	long maxerror;		/* maximum error (usec) */
 	long esterror;		/* estimated error (usec) */
+#endif
 	int status;		/* clock command/status */
+#if __BITS_PER_LONG == 64
+	__kernel_long_t constant;/* pll time constant */
+	__kernel_long_t precision;/* clock precision (usec) (read only) */
+	__kernel_long_t tolerance;/* clock frequency tolerance (ppm)
+				   * (read only)
+				   */
+#else
 	long constant;		/* pll time constant */
 	long precision;		/* clock precision (usec) (read only) */
 	long tolerance;		/* clock frequency tolerance (ppm)
 				 * (read only)
 				 */
+#endif
 	struct timeval time;	/* (read only, except for ADJ_SETOFFSET) */
+#if __BITS_PER_LONG == 64
+	__kernel_long_t tick;	/* (modified) usecs between clock ticks */
+
+	__kernel_long_t ppsfreq;/* pps frequency (scaled ppm) (ro) */
+	__kernel_long_t jitter; /* pps jitter (us) (ro) */
+#else
 	long tick;		/* (modified) usecs between clock ticks */
 
-	long ppsfreq;           /* pps frequency (scaled ppm) (ro) */
-	long jitter;            /* pps jitter (us) (ro) */
+	long ppsfreq;		/* pps frequency (scaled ppm) (ro) */
+	long jitter;		/* pps jitter (us) (ro) */
+#endif
 	int shift;              /* interval duration (s) (shift) (ro) */
-	long stabil;            /* pps stability (scaled ppm) (ro) */
-	long jitcnt;            /* jitter limit exceeded (ro) */
-	long calcnt;            /* calibration intervals (ro) */
-	long errcnt;            /* calibration errors (ro) */
-	long stbcnt;            /* stability limit exceeded (ro) */
-
+#if __BITS_PER_LONG == 64
+	__kernel_long_t stabil; /* pps stability (scaled ppm) (ro) */
+	__kernel_long_t jitcnt; /* jitter limit exceeded (ro) */
+	__kernel_long_t calcnt; /* calibration intervals (ro) */
+	__kernel_long_t errcnt; /* calibration errors (ro) */
+	__kernel_long_t stbcnt; /* stability limit exceeded (ro) */
+
+#else
+	long stabil;		/* pps stability (scaled ppm) (ro) */
+	long jitcnt;		/* jitter limit exceeded (ro) */
+	long calcnt;		/* calibration intervals (ro) */
+	long errcnt;		/* calibration errors (ro) */
+	long stbcnt;		/* stability limit exceeded (ro) */
+#endif
 	int tai;		/* TAI offset (ro) */
 
 	int  :32; int  :32; int  :32; int  :32;
-- 
1.8.4.2

