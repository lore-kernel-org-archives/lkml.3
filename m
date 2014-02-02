Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752386AbaBBQhe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Feb 2014 11:37:34 -0500
Received: from mail-vc0-f178.google.com ([209.85.220.178]:58573 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752173AbaBBQh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Feb 2014 11:37:28 -0500
MIME-Version: 1.0
In-Reply-To: <1391340435-5130-7-git-send-email-stefani@seibold.net>
References: <1391340435-5130-1-git-send-email-stefani@seibold.net> <1391340435-5130-7-git-send-email-stefani@seibold.net>
From: Andy Lutomirski <luto@amacapital.net>
Date: Sun, 2 Feb 2014 08:37:07 -0800
Message-ID: <CALCETrWsZ8Dmrxd=cW=q5OwwvcVXA=uBf9sBapHhyQ75QA1fqA@mail.gmail.com>
Subject: Re: [PATCH 6/8] cleanup __vdso_gettimeofday
To: Stefani Seibold <stefani@seibold.net>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Andi Kleen <ak@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        John Stultz <john.stultz@linaro.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        andriy.shevchenko@linux.intel.com, Martin.Runge@rohde-schwarz.com,
        Andreas.Brief@rohde-schwarz.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 2, 2014 at 3:27 AM,  <stefani@seibold.net> wrote:
> From: Stefani Seibold <stefani@seibold.net>
>
> This patch do a little cleanup for the __vdso_gettimeofday() function.
>
> It kick out an unneeded ret local variable and makes the code faster if
> only the timezone is needed.
>
> Signed-off-by: Stefani Seibold <stefani@seibold.net>

Acked-by: Andy Lutomirski <luto@amacapital.net>

> ---
>  arch/x86/vdso/vclock_gettime.c | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)
>
> diff --git a/arch/x86/vdso/vclock_gettime.c b/arch/x86/vdso/vclock_gettime.c
> index 743f277..bf969a0 100644
> --- a/arch/x86/vdso/vclock_gettime.c
> +++ b/arch/x86/vdso/vclock_gettime.c
> @@ -259,13 +259,12 @@ int clock_gettime(clockid_t, struct timespec *)
>
>  notrace int __vdso_gettimeofday(struct timeval *tv, struct timezone *tz)
>  {
> -       long ret = VCLOCK_NONE;
> -
>         if (likely(tv != NULL)) {
>                 BUILD_BUG_ON(offsetof(struct timeval, tv_usec) !=
>                              offsetof(struct timespec, tv_nsec) ||
>                              sizeof(*tv) != sizeof(struct timespec));
> -               ret = do_realtime((struct timespec *)tv);
> +               if (do_realtime((struct timespec *)tv) == VCLOCK_NONE)
> +                       return vdso_fallback_gtod(tv, tz);
>                 tv->tv_usec /= 1000;
>         }
>         if (unlikely(tz != NULL)) {
> @@ -274,8 +273,6 @@ notrace int __vdso_gettimeofday(struct timeval *tv, struct timezone *tz)
>                 tz->tz_dsttime = gtod->sys_tz.tz_dsttime;
>         }
>
> -       if (ret == VCLOCK_NONE)
> -               return vdso_fallback_gtod(tv, tz);
>         return 0;
>  }
>  int gettimeofday(struct timeval *, struct timezone *)
> --
> 1.8.5.3
>



-- 
Andy Lutomirski
AMA Capital Management, LLC
