Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753843AbaBPVyX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Feb 2014 16:54:23 -0500
Received: from www84.your-server.de ([213.133.104.84]:36276 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752953AbaBPVwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Feb 2014 16:52:18 -0500
From: Stefani Seibold <stefani@seibold.net>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        ak@linux.intel.com, aarcange@redhat.com, john.stultz@linaro.org,
        luto@amacapital.net, xemul@parallels.com, gorcunov@openvz.org,
        andriy.shevchenko@linux.intel.com
Cc: Martin.Runge@rohde-schwarz.com, Andreas.Brief@rohde-schwarz.com,
        Stefani Seibold <stefani@seibold.net>
Subject: [PATCH v18 04/10] vclock_gettime.c __vdso_clock_gettime cleanup
Date: Sun, 16 Feb 2014 22:52:42 +0100
Message-Id: <1392587568-7325-5-git-send-email-stefani@seibold.net>
X-Mailer: git-send-email 1.8.5.5
In-Reply-To: <1392587568-7325-1-git-send-email-stefani@seibold.net>
References: <1392587568-7325-1-git-send-email-stefani@seibold.net>
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is a small code cleanup for the __vdso_clock_gettime() function.

It removes the unneeded return values from do_monotonic_coarse() and
do_realtime_coarse() and add a fallback label for doing the kernel
gettimeofday() system call.

Signed-off-by: Stefani Seibold <stefani@seibold.net>
---
 arch/x86/vdso/vclock_gettime.c | 27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

diff --git a/arch/x86/vdso/vclock_gettime.c b/arch/x86/vdso/vclock_gettime.c
index bbc8065..fd074dd 100644
--- a/arch/x86/vdso/vclock_gettime.c
+++ b/arch/x86/vdso/vclock_gettime.c
@@ -209,7 +209,7 @@ notrace static int do_monotonic(struct timespec *ts)
 	return mode;
 }
 
-notrace static int do_realtime_coarse(struct timespec *ts)
+notrace static void do_realtime_coarse(struct timespec *ts)
 {
 	unsigned long seq;
 	do {
@@ -217,10 +217,9 @@ notrace static int do_realtime_coarse(struct timespec *ts)
 		ts->tv_sec = gtod->wall_time_coarse.tv_sec;
 		ts->tv_nsec = gtod->wall_time_coarse.tv_nsec;
 	} while (unlikely(read_seqcount_retry(&gtod->seq, seq)));
-	return 0;
 }
 
-notrace static int do_monotonic_coarse(struct timespec *ts)
+notrace static void do_monotonic_coarse(struct timespec *ts)
 {
 	unsigned long seq;
 	do {
@@ -228,30 +227,32 @@ notrace static int do_monotonic_coarse(struct timespec *ts)
 		ts->tv_sec = gtod->monotonic_time_coarse.tv_sec;
 		ts->tv_nsec = gtod->monotonic_time_coarse.tv_nsec;
 	} while (unlikely(read_seqcount_retry(&gtod->seq, seq)));
-
-	return 0;
 }
 
 notrace int __vdso_clock_gettime(clockid_t clock, struct timespec *ts)
 {
-	int ret = VCLOCK_NONE;
-
 	switch (clock) {
 	case CLOCK_REALTIME:
-		ret = do_realtime(ts);
+		if (do_realtime(ts) == VCLOCK_NONE)
+			goto fallback;
 		break;
 	case CLOCK_MONOTONIC:
-		ret = do_monotonic(ts);
+		if (do_monotonic(ts) == VCLOCK_NONE)
+			goto fallback;
 		break;
 	case CLOCK_REALTIME_COARSE:
-		return do_realtime_coarse(ts);
+		do_realtime_coarse(ts);
+		break;
 	case CLOCK_MONOTONIC_COARSE:
-		return do_monotonic_coarse(ts);
+		do_monotonic_coarse(ts);
+		break;
+	default:
+		goto fallback;
 	}
 
-	if (ret == VCLOCK_NONE)
-		return vdso_fallback_gettime(clock, ts);
 	return 0;
+fallback:
+	return vdso_fallback_gettime(clock, ts);
 }
 int clock_gettime(clockid_t, struct timespec *)
 	__attribute__((weak, alias("__vdso_clock_gettime")));
-- 
1.8.5.5

