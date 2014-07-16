Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761078AbaGPD3y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 23:29:54 -0400
Received: from mail-vc0-f180.google.com ([209.85.220.180]:43515 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752458AbaGPD3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 23:29:51 -0400
MIME-Version: 1.0
In-Reply-To: <20140711133706.426549845@linutronix.de>
References: <20140711133623.530368377@linutronix.de>
	<20140711133706.426549845@linutronix.de>
Date: Tue, 15 Jul 2014 20:29:50 -0700
Message-ID: <CALAqxLUPjqCidKaXQowDw5L2WQnyZsozpjhwO0QQcXvpXBt5fg@mail.gmail.com>
Subject: Re: [patch 14/55] timekeeping: Provide internal ktime_t based data
From: John Stultz <john.stultz@linaro.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2014 at 6:44 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> The ktime_t based interfaces are used a lot in performance critical
> code pathes. Add ktime_t based data so the interfaces don't have to
> convert from the xtime/timespec based data.
>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> ---
>  include/linux/timekeeper_internal.h |    3 +++
>  kernel/time/timekeeping.c           |   25 +++++++++++++++++++++++++
>  2 files changed, 28 insertions(+)
>
> Index: tip/include/linux/timekeeper_internal.h
> ===================================================================
> --- tip.orig/include/linux/timekeeper_internal.h
> +++ tip/include/linux/timekeeper_internal.h
> @@ -36,6 +36,9 @@ struct timekeeper {
>         /* Clock shifted nano seconds */
>         u64                     xtime_nsec;
>
> +       /* Monotonic base time */
> +       ktime_t                 base_mono;
> +
>         /* Current CLOCK_REALTIME time in seconds */
>         u64                     xtime_sec;
>         /* CLOCK_REALTIME to CLOCK_MONOTONIC offset */
> Index: tip/kernel/time/timekeeping.c
> ===================================================================
> --- tip.orig/kernel/time/timekeeping.c
> +++ tip/kernel/time/timekeeping.c
> @@ -50,12 +50,30 @@ int __read_mostly timekeeping_suspended;
>  /* Flag for if there is a persistent clock on this platform */
>  bool __read_mostly persistent_clock_exist = false;
>
> +/*
> + * The xtime based monotonic readout is:
> + *     nsec = (xtime_sec + wtm_sec) * 1e9 + wtm_nsec + now();
> + * The ktime based monotonic readout is:
> + *     nsec = base_mono + now();
> + * ==> base_mono = (xtime_sec + wtm_sec) * 1e9 + wtm_nsec
> + */
> +static inline void tk_update_ktime_base(struct timekeeper *tk)
> +{
> +       s64 nsec;
> +
> +       nsec = (s64)(tk->xtime_sec + tk->wall_to_monotonic.tv_sec);
> +       nsec *= NSEC_PER_SEC;
> +       nsec += tk->wall_to_monotonic.tv_nsec;
> +       tk->base_mono = ns_to_ktime(nsec);
> +}

Hrmm.. So I do understand why this is useful performance wise.
However, I'm really starting to feel that keeping all this duplicate
data is a real maintenance burden, as remembering to keep the values
in sync always is prone to error.

So I may have to just put up with it, but I'd like to start thinking
about how to reduce the duplicated data in the future. Arnd had an
interesting idea for something like storing fixed point seconds, which
could be cheaply converted to either ktime_t or timespec values.
However, I suspect that would be even more complex for folks to
understand, which I'd rather not do.

Overall, it might be best if we just kill the timespec
wall_to_monotonic/total_sleep_time/tai_offset values and keep the
timekeeper values almost all in timespecs. Then we can leave the
conversion process to basically cache the timespec values to the
vsyscall_update logic?

Or if we do want to maintain performance for non-vdso implementations,
maybe we can split the timespec functions out of the timekeeping core
and do a similar single shot update each tick to set the update the
tiemspec cached values. But that can be layered over the timekeeping
core and we can avoid the crazy updating 2 values any time we change
one logic we currently have.

thanks
-joh
