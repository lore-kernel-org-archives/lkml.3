Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932354AbaCEWby (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 17:31:54 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37581 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932281AbaCEWbw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 17:31:52 -0500
Date: Wed, 5 Mar 2014 14:31:30 -0800
From: tip-bot for Stefani Seibold <tipbot@zytor.com>
Message-ID: <tip-6543ca6fee7d3b314bda69b83fd429ed3e336645@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, luto@amacapital.net, hpa@zytor.com,
        mingo@kernel.org, stefani@seibold.net, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, luto@amacapital.net,
        linux-kernel@vger.kernel.org, stefani@seibold.net, tglx@linutronix.de,
        hpa@linux.intel.com
In-Reply-To: <1393881143-3569-7-git-send-email-stefani@seibold.net>
References: <1393881143-3569-7-git-send-email-stefani@seibold.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/vdso] x86, vdso: Cleanup __vdso_gettimeofday()
Git-Commit-ID: 6543ca6fee7d3b314bda69b83fd429ed3e336645
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6543ca6fee7d3b314bda69b83fd429ed3e336645
Gitweb:     http://git.kernel.org/tip/6543ca6fee7d3b314bda69b83fd429ed3e336645
Author:     Stefani Seibold <stefani@seibold.net>
AuthorDate: Mon, 3 Mar 2014 22:12:17 +0100
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 5 Mar 2014 14:02:38 -0800

x86, vdso: Cleanup __vdso_gettimeofday()

This patch do a little cleanup for the __vdso_gettimeofday() function.

It kicks out an unneeded ret local variable and makes the code faster
if only the timezone is needed (an admittedly rare case.)

Reviewed-by: Andy Lutomirski <luto@amacapital.net>
Signed-off-by: Stefani Seibold <stefani@seibold.net>
Link: http://lkml.kernel.org/r/1393881143-3569-7-git-send-email-stefani@seibold.net
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
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
