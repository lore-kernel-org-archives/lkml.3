Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752262AbaJAVYs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 17:24:48 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:56976 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722AbaJAVYq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 17:24:46 -0400
Date: Wed, 1 Oct 2014 23:24:39 +0200
From: Henrik Austad <henrik@austad.us>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>
Subject: Re: [PATCH] tile: add clock_gettime support to vDSO
Message-ID: <20141001212439.GA12974@sisyphus.home.austad.us>
References: <201409301938.s8UJcfY4018093@lab-40.internal.tilera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201409301938.s8UJcfY4018093@lab-40.internal.tilera.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 30, 2014 at 03:29:45PM -0400, Chris Metcalf wrote:
> This change adds support for clock_gettime with CLOCK_REALTIME
> and CLOCK_MONOTONIC using vDSO.  In addition, with this change
> we switch to use seqlocks instead of integer counters.
> 
> We also support the *_COARSE clockid_t, for apps that want speed
> but aren't concerned about fine-grained timestamps; this saves
> about 20 cycles per call (see http://lwn.net/Articles/342018/).
> 
> Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>

What rev is this based on? When I apply it to Linus latest (aad7fb916), it 
fails in arch/tile/kernel/time.c and arch/tile/kernel/vdso/vgettimeofday.c 
(see below)

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
> -	__u64 tz_update_count;  /* Timezone atomicity ctr             */
> -	__u64 tb_update_count;  /* Timebase atomicity ctr             */
> +	seqcount_t tz_seq;	/* Timezone seqlock                   */
> +	seqcount_t tb_seq;	/* Timebase seqlock                   */
>  	__u64 xtime_tod_stamp;  /* TOD clock for xtime                */
>  	__u64 xtime_clock_sec;  /* Kernel time second                 */
>  	__u64 xtime_clock_nsec; /* Kernel time nanosecond             */
> @@ -37,6 +38,10 @@ struct vdso_data {
>  	__u32 shift;            /* Cycle to nanosecond divisor (power of two) */
>  	__u32 tz_minuteswest;   /* Minutes west of Greenwich          */
>  	__u32 tz_dsttime;       /* Type of dst correction             */
> +	__u64 xtime_clock_coarse_sec;	/* Coarse kernel time         */
> +	__u64 xtime_clock_coarse_nsec;
> +	__u64 wtom_clock_coarse_sec;    /* Coarse wall to monotonic time */
> +	__u64 wtom_clock_coarse_nsec;
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
> -	/* Userspace gettimeofday will spin while this value is odd. */
> -	++vdso_data->tz_update_count;
> -	smp_wmb();
> +	write_seqcount_begin(&vdso_data->tz_seq);
>  	vdso_data->tz_minuteswest = sys_tz.tz_minuteswest;
>  	vdso_data->tz_dsttime = sys_tz.tz_dsttime;
> -	smp_wmb();
> -	++vdso_data->tz_update_count;
> +	write_seqcount_end(&vdso_data->tz_seq);
>  }
>  
>  void update_vsyscall(struct timekeeper *tk)
> @@ -263,20 +260,30 @@ void update_vsyscall(struct timekeeper *tk)
>  	struct timespec wall_time = tk_xtime(tk);

wall_time was removed by dc01c9fa ("tile: Convert VDSO timekeeping to the 
precise mechanism"). This causes hunk to fail.

>  	struct timespec *wtm = &tk->wall_to_monotonic;
>  	struct clocksource *clock = tk->clock;
> +	struct timespec ts;
>  
>  	if (clock != &cycle_counter_cs)
>  		return;
>  
> -	/* Userspace gettimeofday will spin while this value is odd. */
> -	++vdso_data->tb_update_count;
> -	smp_wmb();
> +	write_seqcount_begin(&vdso_data->tb_seq);
> +
>  	vdso_data->xtime_tod_stamp = clock->cycle_last;
>  	vdso_data->xtime_clock_sec = wall_time.tv_sec;
>  	vdso_data->xtime_clock_nsec = wall_time.tv_nsec;
> -	vdso_data->wtom_clock_sec = wtm->tv_sec;
> -	vdso_data->wtom_clock_nsec = wtm->tv_nsec;
> +
> +	ts = timespec_add(wall_time, *wtm);

could you do something like

     ts = timespec_add(&tk->wall_to_monotonic, wtm);

instead?

> +	vdso_data->wtom_clock_sec = ts.tv_sec;
> +	vdso_data->wtom_clock_nsec = ts.tv_nsec;
> +
>  	vdso_data->mult = clock->mult;
>  	vdso_data->shift = clock->shift;
> -	smp_wmb();
> -	++vdso_data->tb_update_count;
> +
> +	ts = __current_kernel_time();
> +	vdso_data->xtime_clock_coarse_sec = ts.tv_sec;
> +	vdso_data->xtime_clock_coarse_nsec = ts.tv_nsec;
> +	ts = timespec_add(ts, *wtm);
> +	vdso_data->wtom_clock_coarse_sec = ts.tv_sec;
> +	vdso_data->wtom_clock_coarse_nsec = ts.tv_nsec;
> +
> +	write_seqcount_end(&vdso_data->tb_seq);
>  }
> diff --git a/arch/tile/kernel/vdso/vdso.lds.S b/arch/tile/kernel/vdso/vdso.lds.S
> index 041cd6c39c83..731529f3f06f 100644
> --- a/arch/tile/kernel/vdso/vdso.lds.S
> +++ b/arch/tile/kernel/vdso/vdso.lds.S
> @@ -82,6 +82,8 @@ VERSION
>  		__vdso_rt_sigreturn;
>  		__vdso_gettimeofday;
>  		gettimeofday;
> +		__vdso_clock_gettime;
> +		clock_gettime;
>  	local:*;
>  	};
>  }
> diff --git a/arch/tile/kernel/vdso/vgettimeofday.c b/arch/tile/kernel/vdso/vgettimeofday.c
> index 51ec8e46f5f9..a09043492d1e 100644
> --- a/arch/tile/kernel/vdso/vgettimeofday.c
> +++ b/arch/tile/kernel/vdso/vgettimeofday.c
> @@ -15,8 +15,14 @@
>  #define VDSO_BUILD  /* avoid some shift warnings for -m32 in <asm/page.h> */
>  #include <linux/time.h>
>  #include <asm/timex.h>
> +#include <asm/unistd.h>
>  #include <asm/vdso.h>
>  
> +struct syscall_return_value {
> +	long value;
> +	long error;
> +};
> +
>  #if CHIP_HAS_SPLIT_CYCLE()
>  static inline cycles_t get_cycles_inline(void)
>  {
> @@ -50,58 +56,136 @@ inline unsigned long get_datapage(void)
>  	return ret;
>  }
>  
> -int __vdso_gettimeofday(struct timeval *tv, struct timezone *tz)
> +static inline int do_realtime(struct vdso_data *vdso, struct timespec *ts)
> +{
> +	int count;
> +	cycles_t cycles;
> +	unsigned long ns;
> +
> +	do {
> +		count = read_seqcount_begin(&vdso->tb_seq);
> +		cycles = get_cycles() - vdso->xtime_tod_stamp;
> +		ns = (cycles * vdso->mult) >> vdso->shift;
> +		ts->tv_sec = vdso->xtime_clock_sec;
> +		ts->tv_nsec = vdso->xtime_clock_nsec;
> +	} while (unlikely(read_seqcount_retry(&vdso->tb_seq, count)));
> +
> +	timespec_add_ns(ts, ns);
> +	return 0;
> +}
> +
> +static inline int do_monotonic(struct vdso_data *vdso, struct timespec *ts)
>  {
> +	int count;
>  	cycles_t cycles;
> -	unsigned long count, sec, ns;
> -	volatile struct vdso_data *vdso_data;
> +	unsigned long ns;
> +
> +	do {
> +		count = read_seqcount_begin(&vdso->tb_seq);
> +		cycles = get_cycles() - vdso->xtime_tod_stamp;
> +		ns = (cycles * vdso->mult) >> vdso->shift;
> +		ts->tv_sec = vdso->wtom_clock_sec;
> +		ts->tv_nsec = vdso->wtom_clock_nsec;
> +	} while (unlikely(read_seqcount_retry(&vdso->tb_seq, count)));
> +
> +	timespec_add_ns(ts, ns);
> +	return 0;
> +}
> +
> +static inline int do_realtime_coarse(struct vdso_data *vdso,
> +				     struct timespec *ts)
> +{
> +	unsigned long count;
> +
> +	do {
> +		count = read_seqcount_begin(&vdso->tb_seq);
> +		ts->tv_sec = vdso->xtime_clock_coarse_sec;
> +		ts->tv_nsec = vdso->xtime_clock_coarse_nsec;
> +	} while (unlikely(read_seqcount_retry(&vdso->tb_seq, count)));
> +
> +	return 0;
> +}
> +
> +static inline int do_monotonic_coarse(struct vdso_data *vdso,
> +				      struct timespec *ts)
> +{
> +	unsigned long count;
> +
> +	do {
> +		count = read_seqcount_begin(&vdso->tb_seq);
> +		ts->tv_sec = vdso->wtom_clock_coarse_sec;
> +		ts->tv_nsec = vdso->wtom_clock_coarse_nsec;
> +	} while (unlikely(read_seqcount_retry(&vdso->tb_seq, count)));
> +
> +	return 0;
> +}
> +
> +struct syscall_return_value __vdso_gettimeofday(struct timeval *tv,
> +						struct timezone *tz)
> +{
> +	struct syscall_return_value ret = { 0, 0 };
> +	unsigned long count;
> +	struct vdso_data *vdso = (struct vdso_data *)get_datapage();
>  
> -	vdso_data = (struct vdso_data *)get_datapage();
>  	/* The use of the timezone is obsolete, normally tz is NULL. */
>  	if (unlikely(tz != NULL)) {
> -		while (1) {
> -			/* Spin until the update finish. */
> -			count = vdso_data->tz_update_count;
> -			if (count & 1)
> -				continue;
> -
> -			tz->tz_minuteswest = vdso_data->tz_minuteswest;
> -			tz->tz_dsttime = vdso_data->tz_dsttime;
> -
> -			/* Check whether updated, read again if so. */
> -			if (count == vdso_data->tz_update_count)
> -				break;
> -		}
> +		do {
> +			count = read_seqcount_begin(&vdso->tz_seq);
> +			tz->tz_minuteswest = vdso->tz_minuteswest;
> +			tz->tz_dsttime = vdso->tz_dsttime;
> +		} while (unlikely(read_seqcount_retry(&vdso->tz_seq, count)));
>  	}
>  
>  	if (unlikely(tv == NULL))
> -		return 0;
> -
> -	while (1) {
> -		/* Spin until the update finish. */
> -		count = vdso_data->tb_update_count;
> -		if (count & 1)
> -			continue;
> -
> -		cycles = (get_cycles() - vdso_data->xtime_tod_stamp);
> -		ns = (cycles * vdso_data->mult) >> vdso_data->shift;
> -		sec = vdso_data->xtime_clock_sec;
> -		ns += vdso_data->xtime_clock_nsec;
> -		if (ns >= NSEC_PER_SEC) {
> -			ns -= NSEC_PER_SEC;
> -			sec += 1;
> -		}
> -
> -		/* Check whether updated, read again if so. */
> -		if (count == vdso_data->tb_update_count)
> -			break;
> -	}
> +		return ret;
>  
> -	tv->tv_sec = sec;
> -	tv->tv_usec = ns / 1000;
> +	do_realtime(vdso, (struct timespec *)tv);
> +	tv->tv_usec /= 1000;
>  
> -	return 0;
> +	return ret;
>  }
>  
>  int gettimeofday(struct timeval *tv, struct timezone *tz)
>  	__attribute__((weak, alias("__vdso_gettimeofday")));
> +
> +static struct syscall_return_value vdso_fallback_gettime(long clock,
> +							 struct timespec *ts)
> +{
> +	struct syscall_return_value ret;
> +	__asm__ __volatile__ (
> +		"swint1"
> +		: "=R00" (ret.value), "=R01" (ret.error)
> +		: "R10" (__NR_clock_gettime), "R00" (clock), "R01" (ts)
> +		: "r2", "r3", "r4", "r5", "r6", "r7",
> +		"r8",  "r9", "r11", "r12", "r13", "r14", "r15",
> +		"r16", "r17", "r18", "r19", "r20", "r21", "r22", "r23",
> +		"r24", "r25", "r26", "r27", "r28", "r29", "memory");
> +	return ret;
> +}
> +
> +struct syscall_return_value __vdso_clock_gettime(clockid_t clock,
> +						 struct timespec *ts)
> +{
> +	struct vdso_data *vdso = (struct vdso_data *)get_datapage();
> +	struct syscall_return_value ret = { 0, 0 };
> +
> +	switch (clock) {
> +	case CLOCK_REALTIME:
> +		do_realtime(vdso, ts);
> +		return ret;
> +	case CLOCK_MONOTONIC:
> +		do_monotonic(vdso, ts);
> +		return ret;
> +	case CLOCK_REALTIME_COARSE:
> +		do_realtime_coarse(vdso, ts);
> +		return ret;
> +	case CLOCK_MONOTONIC_COARSE:
> +		do_monotonic_coarse(vdso, ts);
> +		return ret;
> +	default:
> +		return vdso_fallback_gettime(clock, ts);
> +	}
> +}
> +
> +int clock_gettime(clockid_t clock, struct timespec *ts)
> +	__attribute__((weak, alias("__vdso_clock_gettime")));
> -- 
> 1.8.3.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Henrik Austad
