Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753432Ab3LZPhs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 10:37:48 -0500
Received: from mail-yh0-f52.google.com ([209.85.213.52]:52377 "EHLO
	mail-yh0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753355Ab3LZPhq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 10:37:46 -0500
Date: Thu, 26 Dec 2013 07:37:43 -0800
From: "H.J. Lu" <hjl.tools@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Use __kernel_long_t in struct timex
Message-ID: <20131226153743.GC23355@gmail.com>
References: <20131225002458.GA363@gmail.com>
 <20131226153509.GA23355@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="/NkBOFFp2J2Af1nK"
Content-Disposition: inline
In-Reply-To: <20131226153509.GA23355@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/NkBOFFp2J2Af1nK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Dec 26, 2013 at 07:35:09AM -0800, H.J. Lu wrote:
> On Tue, Dec 24, 2013 at 04:24:58PM -0800, H.J. Lu wrote:
> > X32 adjtimex system call is the same as x86-64 adjtimex system call,
> > which uses 64-bit integer for long in struct timex. But x32 long is
> > 32 bit.  This patch replaces long in struct timex with __kernel_long_t.
> > 
> 
> Here is the updated patch which uses __kernel_long_t only if
> __BITS_PER_LONG == 64.

Forgot to include the new patch.  Here it is.

H.J.

--/NkBOFFp2J2Af1nK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0001-Use-__kernel_long_t-in-struct-timex.patch"

>From fd1986128a354cf9fb3786b0138e7b84690d9835 Mon Sep 17 00:00:00 2001
From: "H.J. Lu" <hjl.tools@gmail.com>
Date: Tue, 24 Dec 2013 16:20:28 -0800
Subject: [PATCH] Use __kernel_long_t in struct timex

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


--/NkBOFFp2J2Af1nK--
