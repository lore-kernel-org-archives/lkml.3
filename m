Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753855AbaBQAx3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Feb 2014 19:53:29 -0500
Received: from terminus.zytor.com ([198.137.202.10]:51720 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752363AbaBQAx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Feb 2014 19:53:26 -0500
Date: Sun, 16 Feb 2014 16:53:03 -0800
From: tip-bot for Stefani Seibold <tipbot@zytor.com>
Message-ID: <tip-3b19f50facf0488e193ebae00b864fdaeeb25dbb@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        stefani@seibold.net, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        stefani@seibold.net, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1392587568-7325-5-git-send-email-stefani@seibold.net>
References: <1392587568-7325-5-git-send-email-stefani@seibold.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/vdso] x86, vdso:
  vclock_gettime.c __vdso_clock_gettime cleanup
Git-Commit-ID: 3b19f50facf0488e193ebae00b864fdaeeb25dbb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sun, 16 Feb 2014 16:53:09 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3b19f50facf0488e193ebae00b864fdaeeb25dbb
Gitweb:     http://git.kernel.org/tip/3b19f50facf0488e193ebae00b864fdaeeb25dbb
Author:     Stefani Seibold <stefani@seibold.net>
AuthorDate: Sun, 16 Feb 2014 22:52:42 +0100
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Sun, 16 Feb 2014 15:06:47 -0800

x86, vdso: vclock_gettime.c __vdso_clock_gettime cleanup

This patch is a small code cleanup for the __vdso_clock_gettime()
function.

It removes the unneeded return values from do_monotonic_coarse() and
do_realtime_coarse() and add a fallback label for doing the kernel
gettimeofday() system call.

Signed-off-by: Stefani Seibold <stefani@seibold.net>
Link: http://lkml.kernel.org/r/1392587568-7325-5-git-send-email-stefani@seibold.net
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
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
