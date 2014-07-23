Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933661AbaGWVP6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 17:15:58 -0400
Received: from mail-qg0-f43.google.com ([209.85.192.43]:61697 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933281AbaGWVP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 17:15:56 -0400
MIME-Version: 1.0
In-Reply-To: <20140716205053.190013055@linutronix.de>
References: <20140716205018.175419210@linutronix.de>
	<20140716205053.190013055@linutronix.de>
Date: Wed, 23 Jul 2014 14:15:55 -0700
Message-ID: <CALAqxLX-mnLW5Ou-iwtRpRTbznhsBVzECHYPijifkvRsiHgv_Q@mail.gmail.com>
Subject: Re: [patch V2 12/64] timekeeper: Move tk_xtime to core code
From: John Stultz <john.stultz@linaro.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2014 at 2:04 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> Index: tip/kernel/time/timekeeping.c
> ===================================================================
> --- tip.orig/kernel/time/timekeeping.c
> +++ tip/kernel/time/timekeeping.c
> @@ -51,6 +51,15 @@ static inline void tk_normalize_xtime(st
>         }
>  }
>
> +static inline struct timespec64 tk_xtime(struct timekeeper *tk)
> +{
> +       struct timespec64 ts;
> +
> +       ts.tv_sec = tk->xtime_sec;
> +       ts.tv_nsec = (long)(tk->xtime_nsec >> tk->shift);
> +       return ts;
> +}
> +
>  static void tk_set_xtime(struct timekeeper *tk, const struct timespec64 *ts)
>  {
>         tk->xtime_sec = ts->tv_sec;
> @@ -199,6 +208,40 @@ static inline s64 timekeeping_get_ns_raw
>         return nsec + arch_gettimeoffset();
>  }
>
> +#ifdef CONFIG_GENERIC_TIME_VSYSCALL_OLD
> +
> +static inline void update_vsyscall(struct timekeeper *tk)
> +{
> +       struct timespec xt;
> +
> +       xt = tk_xtime(tk);
> +       update_vsyscall_old(&xt, &tk->wall_to_monotonic, tk->clock, tk->mult);
> +}

So one gotcha here, and I realized I missed this in my timekeeping
timespec64 conversion patch, is that here we're calling tk_xtime()
which returns a timespec64, and we stuff it into a timespec.

Now, the reason we didn't see the compiler gripe on this, was that the
only VSYSCALL_OLD implementations left are ia64 and ppc64.

I'll add a fixup patch to the queue to address this.

thanks
-john
