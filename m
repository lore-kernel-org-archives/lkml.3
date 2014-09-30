Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752659AbaI3WRa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 18:17:30 -0400
Received: from www.linutronix.de ([62.245.132.108]:33815 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883AbaI3WR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 18:17:28 -0400
Date: Wed, 1 Oct 2014 00:17:26 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Chris Metcalf <cmetcalf@tilera.com>
cc: linux-kernel@vger.kernel.org, John Stultz <john.stultz@linaro.org>,
        Henrik Austad <henrik@austad.us>
Subject: Re: [PATCH] tile: add clock_gettime support to vDSO
In-Reply-To: <201409301938.s8UJcfY4018093@lab-40.internal.tilera.com>
Message-ID: <alpine.DEB.2.11.1410010004560.4455@nanos>
References: <201409301938.s8UJcfY4018093@lab-40.internal.tilera.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Sep 2014, Chris Metcalf wrote:

> This change adds support for clock_gettime with CLOCK_REALTIME
> and CLOCK_MONOTONIC using vDSO.  In addition, with this change
> we switch to use seqlocks instead of integer counters.

I'd rather split that into two patches. One changing the code to use
the seqlock and the other to add the clock_gettime() stuff.

>  void update_vsyscall(struct timekeeper *tk)
> @@ -263,20 +260,30 @@ void update_vsyscall(struct timekeeper *tk)
>  	struct timespec wall_time = tk_xtime(tk);
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

I'm fine with the code, but you might think about doing the math and
preparation stuff outside of the seqcount protected region to a shadow
struct and then do a simple memcpy inside of the seqcount protected
region. Nothing significant, but it might be worthwhile as a follow
up or preparatory change.

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

I doubt that the unlikely makes any difference.

Otherwise this looks good.

Thanks,

	tglx
