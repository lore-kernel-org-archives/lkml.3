Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751930AbaBBQi6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Feb 2014 11:38:58 -0500
Received: from mail-vb0-f42.google.com ([209.85.212.42]:42346 "EHLO
	mail-vb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701AbaBBQi4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Feb 2014 11:38:56 -0500
MIME-Version: 1.0
In-Reply-To: <1391340435-5130-5-git-send-email-stefani@seibold.net>
References: <1391340435-5130-1-git-send-email-stefani@seibold.net> <1391340435-5130-5-git-send-email-stefani@seibold.net>
From: Andy Lutomirski <luto@amacapital.net>
Date: Sun, 2 Feb 2014 08:38:35 -0800
Message-ID: <CALCETrXTYuuRfbesegfHFQTZBtTvFawk_7NuUKpzJgYsNZkW+A@mail.gmail.com>
Subject: Re: [PATCH 4/8] vclock_gettime.c __vdso_clock_gettime cleanup
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
> This patch is a small code cleanup for the __vdso_clock_gettime() function.
>
> It removes the unneeded return values from do_monotonic_coarse() and
> do_realtime_coarse() and add a fallback label for doing the kernel
> gettimeofday() system call.
>

This is possibly worth benchmarking, but it looks harmless, and
possibly even beneficial, to me.  (If the optimizer is in a good mood,
it might do a nicer job with do_monotonic now.)

--Andy

> Signed-off-by: Stefani Seibold <stefani@seibold.net>
> ---
>  arch/x86/vdso/vclock_gettime.c | 27 ++++++++++++++-------------
>  1 file changed, 14 insertions(+), 13 deletions(-)
>
> diff --git a/arch/x86/vdso/vclock_gettime.c b/arch/x86/vdso/vclock_gettime.c
> index bbc8065..fd074dd 100644
> --- a/arch/x86/vdso/vclock_gettime.c
> +++ b/arch/x86/vdso/vclock_gettime.c
> @@ -209,7 +209,7 @@ notrace static int do_monotonic(struct timespec *ts)
>         return mode;
>  }
>
> -notrace static int do_realtime_coarse(struct timespec *ts)
> +notrace static void do_realtime_coarse(struct timespec *ts)
>  {
>         unsigned long seq;
>         do {
> @@ -217,10 +217,9 @@ notrace static int do_realtime_coarse(struct timespec *ts)
>                 ts->tv_sec = gtod->wall_time_coarse.tv_sec;
>                 ts->tv_nsec = gtod->wall_time_coarse.tv_nsec;
>         } while (unlikely(read_seqcount_retry(&gtod->seq, seq)));
> -       return 0;
>  }
>
> -notrace static int do_monotonic_coarse(struct timespec *ts)
> +notrace static void do_monotonic_coarse(struct timespec *ts)
>  {
>         unsigned long seq;
>         do {
> @@ -228,30 +227,32 @@ notrace static int do_monotonic_coarse(struct timespec *ts)
>                 ts->tv_sec = gtod->monotonic_time_coarse.tv_sec;
>                 ts->tv_nsec = gtod->monotonic_time_coarse.tv_nsec;
>         } while (unlikely(read_seqcount_retry(&gtod->seq, seq)));
> -
> -       return 0;
>  }
>
>  notrace int __vdso_clock_gettime(clockid_t clock, struct timespec *ts)
>  {
> -       int ret = VCLOCK_NONE;
> -
>         switch (clock) {
>         case CLOCK_REALTIME:
> -               ret = do_realtime(ts);
> +               if (do_realtime(ts) == VCLOCK_NONE)
> +                       goto fallback;
>                 break;
>         case CLOCK_MONOTONIC:
> -               ret = do_monotonic(ts);
> +               if (do_monotonic(ts) == VCLOCK_NONE)
> +                       goto fallback;
>                 break;
>         case CLOCK_REALTIME_COARSE:
> -               return do_realtime_coarse(ts);
> +               do_realtime_coarse(ts);
> +               break;
>         case CLOCK_MONOTONIC_COARSE:
> -               return do_monotonic_coarse(ts);
> +               do_monotonic_coarse(ts);
> +               break;
> +       default:
> +               goto fallback;
>         }
>
> -       if (ret == VCLOCK_NONE)
> -               return vdso_fallback_gettime(clock, ts);
>         return 0;
> +fallback:
> +       return vdso_fallback_gettime(clock, ts);
>  }
>  int clock_gettime(clockid_t, struct timespec *)
>         __attribute__((weak, alias("__vdso_clock_gettime")));
> --
> 1.8.5.3
>



-- 
Andy Lutomirski
AMA Capital Management, LLC
