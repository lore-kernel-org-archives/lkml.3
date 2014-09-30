Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753101AbaI3Wab (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 18:30:31 -0400
Received: from mail-vc0-f173.google.com ([209.85.220.173]:36651 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752163AbaI3Wa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 18:30:28 -0400
MIME-Version: 1.0
In-Reply-To: <201409301938.s8UJcfY4018093@lab-40.internal.tilera.com>
References: <201409301938.s8UJcfY4018093@lab-40.internal.tilera.com>
Date: Tue, 30 Sep 2014 15:30:28 -0700
Message-ID: <CALAqxLWHhmyDp-CeGzs6Jqzcrk-KDX_T4UQpTU79VDTL3oHdJw@mail.gmail.com>
Subject: Re: [PATCH] tile: add clock_gettime support to vDSO
From: John Stultz <john.stultz@linaro.org>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Henrik Austad <henrik@austad.us>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 30, 2014 at 12:29 PM, Chris Metcalf <cmetcalf@tilera.com> wrote:
> This change adds support for clock_gettime with CLOCK_REALTIME
> and CLOCK_MONOTONIC using vDSO.  In addition, with this change
> we switch to use seqlocks instead of integer counters.
>
> We also support the *_COARSE clockid_t, for apps that want speed
> but aren't concerned about fine-grained timestamps; this saves
> about 20 cycles per call (see http://lwn.net/Articles/342018/).
>
> Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
> ---
>  arch/tile/include/asm/vdso.h          |   9 +-
>  arch/tile/kernel/time.c               |  31 ++++---
>  arch/tile/kernel/vdso/vdso.lds.S      |   2 +
>  arch/tile/kernel/vdso/vgettimeofday.c | 166 +++++++++++++++++++++++++---------
>  4 files changed, 153 insertions(+), 55 deletions(-)
>
> diff --git a/arch/tile/include/asm/vdso.h b/arch/tile/include/asm/vdso.h
> index 9f6a78d665fa..4527701fcead 100644
> --- a/arch/tile/include/asm/vdso.h
> +++ b/arch/tile/include/asm/vdso.h
> @@ -15,6 +15,7 @@
>  #ifndef __TILE_VDSO_H__
>  #define __TILE_VDSO_H__
>
> +#include <linux/seqlock.h>
>  #include <linux/types.h>
>
>  /*
> @@ -26,8 +27,8 @@
>   */
>
>  struct vdso_data {
> -       __u64 tz_update_count;  /* Timezone atomicity ctr             */
> -       __u64 tb_update_count;  /* Timebase atomicity ctr             */
> +       seqcount_t tz_seq;      /* Timezone seqlock                   */
> +       seqcount_t tb_seq;      /* Timebase seqlock                   */
>         __u64 xtime_tod_stamp;  /* TOD clock for xtime                */
>         __u64 xtime_clock_sec;  /* Kernel time second                 */
>         __u64 xtime_clock_nsec; /* Kernel time nanosecond             */
> @@ -37,6 +38,10 @@ struct vdso_data {
>         __u32 shift;            /* Cycle to nanosecond divisor (power of two) */
>         __u32 tz_minuteswest;   /* Minutes west of Greenwich          */
>         __u32 tz_dsttime;       /* Type of dst correction             */
> +       __u64 xtime_clock_coarse_sec;   /* Coarse kernel time         */
> +       __u64 xtime_clock_coarse_nsec;
> +       __u64 wtom_clock_coarse_sec;    /* Coarse wall to monotonic time */
> +       __u64 wtom_clock_coarse_nsec;
>  };
>
>  extern struct vdso_data *vdso_data;
> diff --git a/arch/tile/kernel/time.c b/arch/tile/kernel/time.c
> index 462dcd0c1700..77624b38bdb9 100644
> --- a/arch/tile/kernel/time.c
> +++ b/arch/tile/kernel/time.c
> @@ -249,13 +249,10 @@ cycles_t ns2cycles(unsigned long nsecs)
>
>  void update_vsyscall_tz(void)
>  {
> -       /* Userspace gettimeofday will spin while this value is odd. */
> -       ++vdso_data->tz_update_count;
> -       smp_wmb();
> +       write_seqcount_begin(&vdso_data->tz_seq);
>         vdso_data->tz_minuteswest = sys_tz.tz_minuteswest;
>         vdso_data->tz_dsttime = sys_tz.tz_dsttime;
> -       smp_wmb();
> -       ++vdso_data->tz_update_count;
> +       write_seqcount_end(&vdso_data->tz_seq);
>  }
>
>  void update_vsyscall(struct timekeeper *tk)
> @@ -263,20 +260,30 @@ void update_vsyscall(struct timekeeper *tk)
>         struct timespec wall_time = tk_xtime(tk);

So this looks like a pre-existing issue, but here the sub-ns stored
value in the timekeeper is being truncated to nanoseconds. You
probably want to preserve that all the way into the do_realtime()/etc
calculation, otherwise the time could seem to jump backwards by 1ns
after the update.

I'd take a look at what the core timekeeping logic does or the x86
implementation to get a sense of what you ought to do there to
preserve the logic. It basically comes down to changing it from:
     nsec + (mult *cycle_delta) >> shift
to:
     (snsec + (mult *cycle_delta)) >> shift


thanks
-john
