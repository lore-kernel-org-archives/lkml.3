Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755284AbaCCVOy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 16:14:54 -0500
Received: from www84.your-server.de ([213.133.104.84]:42168 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755005AbaCCVNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 16:13:16 -0500
From: Stefani Seibold <stefani@seibold.net>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        ak@linux.intel.com, aarcange@redhat.com, john.stultz@linaro.org,
        luto@amacapital.net, xemul@parallels.com, gorcunov@openvz.org,
        andriy.shevchenko@linux.intel.com
Cc: Martin.Runge@rohde-schwarz.com, Andreas.Brief@rohde-schwarz.com,
        Stefani Seibold <stefani@seibold.net>
Subject: [Patch v22 06/12] x86: cleanup __vdso_gettimeofday
Date: Mon,  3 Mar 2014 22:12:17 +0100
Message-Id: <1393881143-3569-7-git-send-email-stefani@seibold.net>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1393881143-3569-1-git-send-email-stefani@seibold.net>
References: <1393881143-3569-1-git-send-email-stefani@seibold.net>
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch do a little cleanup for the __vdso_gettimeofday() function.

It kick out an unneeded ret local variable and makes the code faster if
only the timezone is needed.

Reviewed-by: Andy Lutomirski <luto@amacapital.net>
Signed-off-by: Stefani Seibold <stefani@seibold.net>
---
 arch/x86/vdso/vclock_gettime.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/arch/x86/vdso/vclock_gettime.c b/arch/x86/vdso/vclock_gettime.c
index 743f277..09dae4a 100644
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
+		if (unlikely(do_realtime((struct timespec *)tv) == VCLOCK_NONE))
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
1.9.0

