Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754393AbbAXTPJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2015 14:15:09 -0500
Received: from www.linutronix.de ([62.245.132.108]:41056 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752473AbbAXTPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2015 14:15:05 -0500
Date: Sat, 24 Jan 2015 20:14:45 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Daniel Church <dchurch@andplus.com>
cc: linux-kernel@vger.kernel.org, libc-alpha@sourceware.org
Subject: Re: [PATCH v2 1/2] posix-timers: Prevents overrun counter overflow
In-Reply-To: <1422121737-3686-2-git-send-email-dchurch@andplus.com>
Message-ID: <alpine.DEB.2.11.1501242004430.5526@nanos>
References: <[PATCH 0/2] posix-timers: Prevents overrun counter overflow, adds DELAYTIMER_MAX> <1422121737-3686-1-git-send-email-dchurch@andplus.com> <1422121737-3686-2-git-send-email-dchurch@andplus.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 24 Jan 2015, Daniel Church wrote:
> +/*
> + * Updates a timer's overrun count while capping it to delaytimer_max
> + */
> +static void posix_timer_update_overrun_count(struct k_itimer *timer,
> +					     unsigned int overruns)
> +{
> +	const bool newOverrunsAboveMax = overruns >= delaytimer_max;
> +	const bool totalOverrunsAboveMax =
> +		timer->it_overrun >= 0 &&
> +		timer->it_overrun >= delaytimer_max - overruns;

No CaMelCaSe please. And the const here is pointless.

Aside of that in a function like this we really want short local
variables so we can avoid the horrible to read multi line code.

> +	if (newOverrunsAboveMax || totalOverrunsAboveMax) {
> +		timer->it_overrun = delaytimer_max;
> +	} else {
> +		timer->it_overrun += overruns;
> +	}
> +}
> +
>  /* Get clock_realtime */
>  static int posix_clock_realtime_get(clockid_t which_clock, struct timespec *tp)
>  {
> @@ -350,14 +370,17 @@ __initcall(init_posix_timers);
>  
>  static void schedule_next_timer(struct k_itimer *timr)
>  {
> +	unsigned int overruns;
>  	struct hrtimer *timer = &timr->it.real.timer;
>  
>  	if (timr->it.real.interval.tv64 == 0)
>  		return;
>  
> -	timr->it_overrun += (unsigned int) hrtimer_forward(timer,
> -						timer->base->get_time(),
> -						timr->it.real.interval);
> +	overruns = (unsigned int) hrtimer_forward(timer,
> +					timer->base->get_time(),
> +					timr->it.real.interval);

Why not:

  posix_timer_forward(struct hrtimer *hrt, struct k_itimer *tmr)      			     
			     
and doing the forward there as well? The now optimization in
common_timer_get is not that important and if we really want to keep
it, we can hand in a pointer and read the time in the function if the
pointer is NULL.

Thanks,

	tglx
