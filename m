Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932364AbaBEITk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 03:19:40 -0500
Received: from www84.your-server.de ([213.133.104.84]:36020 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768AbaBEITd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 03:19:33 -0500
From: stefani@seibold.net
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        ak@linux.intel.com, aarcange@redhat.com, john.stultz@linaro.org,
        luto@amacapital.net, xemul@parallels.com, gorcunov@openvz.org,
        andriy.shevchenko@linux.intel.com
Cc: Martin.Runge@rohde-schwarz.com, Andreas.Brief@rohde-schwarz.com,
        Stefani Seibold <stefani@seibold.net>
Subject: [PATCH v12 6/9] cleanup __vdso_gettimeofday
Date: Wed,  5 Feb 2014 09:20:01 +0100
Message-Id: <1391588404-28147-7-git-send-email-stefani@seibold.net>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1391588404-28147-1-git-send-email-stefani@seibold.net>
References: <1391588404-28147-1-git-send-email-stefani@seibold.net>
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefani Seibold <stefani@seibold.net>

This patch do a little cleanup for the __vdso_gettimeofday() function.

It kick out an unneeded ret local variable and makes the code faster if
only the timezone is needed.

Signed-off-by: Stefani Seibold <stefani@seibold.net>
---
 arch/x86/vdso/vclock_gettime.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/arch/x86/vdso/vclock_gettime.c b/arch/x86/vdso/vclock_gettime.c
index 743f277..74e5c8e 100644
--- a/arch/x86/vdso/vclock_gettime.c
+++ b/arch/x86/vdso/vclock_gettime.c
@@ -259,13 +259,12 @@ int clock_gettime(clockid_t, struct timespec *)
 
 notrace int __vdso_gettimeofday(struct timeval *tv, struct timezone *tz)
 {
-	long ret = VCLOCK_NONE;
-
 	if (likely(tv != NULL)) {
 		BUILD_BUG_ON(offsetof(struct timeval, tv_usec) !=
 			     offsetof(struct timespec, tv_nsec) ||
 			     sizeof(*tv) != sizeof(struct timespec));
-		ret = do_realtime((struct timespec *)tv);
+		if (unlikely(do_realtime(&tmp) == VCLOCK_NONE))
+			return vdso_fallback_gtod(tv, tz);
 		tv->tv_usec /= 1000;
 	}
 	if (unlikely(tz != NULL)) {
@@ -274,8 +273,6 @@ notrace int __vdso_gettimeofday(struct timeval *tv, struct timezone *tz)
 		tz->tz_dsttime = gtod->sys_tz.tz_dsttime;
 	}
 
-	if (ret == VCLOCK_NONE)
-		return vdso_fallback_gtod(tv, tz);
 	return 0;
 }
 int gettimeofday(struct timeval *, struct timezone *)
-- 
1.8.5.3

