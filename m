Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751844AbaBBPny (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Feb 2014 10:43:54 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45022 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751483AbaBBPnx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Feb 2014 10:43:53 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <1391340435-5130-7-git-send-email-stefani@seibold.net>
References: <1391340435-5130-1-git-send-email-stefani@seibold.net> <1391340435-5130-7-git-send-email-stefani@seibold.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [PATCH 6/8] cleanup __vdso_gettimeofday
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Sun, 02 Feb 2014 07:43:05 -0800
To: stefani@seibold.net, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, x86@kernel.org, tglx@linutronix.de,
        mingo@redhat.com, ak@linux.intel.com, aarcange@redhat.com,
        john.stultz@linaro.org, luto@amacapital.net, xemul@parallels.com,
        gorcunov@openvz.org, andriy.shevchenko@linux.intel.com
CC: Martin.Runge@rohde-schwarz.com, Andreas.Brief@rohde-schwarz.com
Message-ID: <f57bdfaa-3b88-4e27-adf0-21033448c1c6@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Even reading the timezone via gettimeofday is the uncommon case... never mind only the timezome.  Whatever you do please don't slow down the common case.

On February 2, 2014 3:27:13 AM PST, stefani@seibold.net wrote:
>From: Stefani Seibold <stefani@seibold.net>
>
>This patch do a little cleanup for the __vdso_gettimeofday() function.
>
>It kick out an unneeded ret local variable and makes the code faster if
>only the timezone is needed.
>
>Signed-off-by: Stefani Seibold <stefani@seibold.net>
>---
> arch/x86/vdso/vclock_gettime.c | 7 ++-----
> 1 file changed, 2 insertions(+), 5 deletions(-)
>
>diff --git a/arch/x86/vdso/vclock_gettime.c
>b/arch/x86/vdso/vclock_gettime.c
>index 743f277..bf969a0 100644
>--- a/arch/x86/vdso/vclock_gettime.c
>+++ b/arch/x86/vdso/vclock_gettime.c
>@@ -259,13 +259,12 @@ int clock_gettime(clockid_t, struct timespec *)
> 
>notrace int __vdso_gettimeofday(struct timeval *tv, struct timezone
>*tz)
> {
>-	long ret = VCLOCK_NONE;
>-
> 	if (likely(tv != NULL)) {
> 		BUILD_BUG_ON(offsetof(struct timeval, tv_usec) !=
> 			     offsetof(struct timespec, tv_nsec) ||
> 			     sizeof(*tv) != sizeof(struct timespec));
>-		ret = do_realtime((struct timespec *)tv);
>+		if (do_realtime((struct timespec *)tv) == VCLOCK_NONE)
>+			return vdso_fallback_gtod(tv, tz);
> 		tv->tv_usec /= 1000;
> 	}
> 	if (unlikely(tz != NULL)) {
>@@ -274,8 +273,6 @@ notrace int __vdso_gettimeofday(struct timeval *tv,
>struct timezone *tz)
> 		tz->tz_dsttime = gtod->sys_tz.tz_dsttime;
> 	}
> 
>-	if (ret == VCLOCK_NONE)
>-		return vdso_fallback_gtod(tv, tz);
> 	return 0;
> }
> int gettimeofday(struct timeval *, struct timezone *)

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
