Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751689AbaLRVKJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 16:10:09 -0500
Received: from mail-qc0-f176.google.com ([209.85.216.176]:60939 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159AbaLRVKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 16:10:07 -0500
MIME-Version: 1.0
In-Reply-To: <1418820028-16335-1-git-send-email-nasa4836@gmail.com>
References: <1418820028-16335-1-git-send-email-nasa4836@gmail.com>
Date: Thu, 18 Dec 2014 13:10:05 -0800
Message-ID: <CALAqxLXtJARN9e9O4jod=A3qtQxnNOB=DVYAgbMLM1fmCFLy5A@mail.gmail.com>
Subject: Re: [PATCH] timekeeping: update raw_time with extra
 arch_gettimeoffset in timekeeping_forward_now
From: John Stultz <john.stultz@linaro.org>
To: Jianyu Zhan <nasa4836@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 17, 2014 at 4:40 AM, Jianyu Zhan <nasa4836@gmail.com> wrote:
> Currently, in timekeeping_forward_now, we just use delta nsecs from
> clocksource to update raw_time; however, in getnstime_raw_and_real,
> getrawmonotonic64, etc, raw_time has slightly diffrent meaning: it not
> only counts the raw monotonic raw time, but also with arch_gettimeoffset,
> by using the timekeeping_get_ns_raw helper.

Wait.. So I'm not sure I understand the issue here. The
arch_gettimeoffset() is really only used with tick-based architectures
that cannot support clocksources. Thus its used in combination with
the jiffies clocksource to provide the "time since the last tick".

timekeeping_forward_now() accumulates the clocksource based time since
the last update, and intentionally doesn't include the
arch_gettimeoffset(), since we cannot re-base that value.


> This patch unifies the meaning of raw_time. Also, it cleanups the
> timekeeping_get_ns_raw helper, to make timekeeping_get_ns and
> timekeeping_forward_now based on it.
>
> Signed-off-by: Jianyu Zhan <nasa4836@gmail.com>
> ---
>  kernel/time/timekeeping.c | 52 ++++++++++++++++-------------------------------
>  1 file changed, 17 insertions(+), 35 deletions(-)
>
> diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
> index 6a93185..1348c9c 100644
> --- a/kernel/time/timekeeping.c
> +++ b/kernel/time/timekeeping.c
> @@ -191,41 +191,32 @@ u32 (*arch_gettimeoffset)(void) = default_arch_gettimeoffset;
>  static inline u32 arch_gettimeoffset(void) { return 0; }
>  #endif
>
> -static inline s64 timekeeping_get_ns(struct tk_read_base *tkr)
> +static inline s64 timekeeping_get_ns_raw(struct tk_read_base *tkr,
> +                                       bool update_cycle)
>  {
> +       struct clocksource *clock = tkr->clock;
>         cycle_t cycle_now, delta;
>         s64 nsec;
>
>         /* read clocksource: */
> -       cycle_now = tkr->read(tkr->clock);
> +       cycle_now = tkr->read(clock);
>
>         /* calculate the delta since the last update_wall_time: */
>         delta = clocksource_delta(cycle_now, tkr->cycle_last, tkr->mask);
> +       if (update_cycle)
> +               tkr->cycle_last = cycle_now;
>


Hrm. I can't say I'm a fan of modifying a read helper to also do writing.


> -       nsec = delta * tkr->mult + tkr->xtime_nsec;
> -       nsec >>= tkr->shift;
> +       /* convert delta to nanoseconds. */
> +       nsec = clocksource_cyc2ns(delta, clock->mult, clock->shift);
>
> -       /* If arch requires, add in get_arch_timeoffset() */
> +       /* If arch requires, add in arch_gettimeoffset() */
>         return nsec + arch_gettimeoffset();
>  }
>
> -static inline s64 timekeeping_get_ns_raw(struct timekeeper *tk)
> +static inline s64 timekeeping_get_ns(struct tk_read_base *tkr)
>  {
> -       struct clocksource *clock = tk->tkr.clock;
> -       cycle_t cycle_now, delta;
> -       s64 nsec;
> -
> -       /* read clocksource: */
> -       cycle_now = tk->tkr.read(clock);
> -
> -       /* calculate the delta since the last update_wall_time: */
> -       delta = clocksource_delta(cycle_now, tk->tkr.cycle_last, tk->tkr.mask);
> -
> -       /* convert delta to nanoseconds. */
> -       nsec = clocksource_cyc2ns(delta, clock->mult, clock->shift);
> -
> -       /* If arch requires, add in get_arch_timeoffset() */
> -       return nsec + arch_gettimeoffset();
> +       return timekeeping_get_ns_raw(tkr, false) +
> +               (tkr->xtime_nsec >> tkr->shift);

This seems broken. The raw clock is not ntp addjusted, but here you're
trying to convert it to the system time by just adding the nsec
portion of xtime_nsec to it?

I think you've misunderstood the semantics of the raw clock, and why
its managed separately from the monotonic clock base other clockids
are based off of. It really is a separate time domain.

thanks
-john
