Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758309Ab3CFOQG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 09:16:06 -0500
Received: from www.linutronix.de ([62.245.132.108]:43442 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758015Ab3CFOQD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 09:16:03 -0500
Date: Wed, 6 Mar 2013 15:15:49 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Feng Tang <feng.tang@intel.com>
cc: John Stultz <john.stultz@linaro.org>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, x86@kernel.org,
        Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-kernel@vger.kernel.org, gong.chen@linux.intel.com
Subject: Re: [PATCH v3 5/5] timekeeping: utilize the suspend-nonstop clocksource
 to count suspended time
In-Reply-To: <1362554271-22382-6-git-send-email-feng.tang@intel.com>
Message-ID: <alpine.LFD.2.02.1303061512110.22263@ionos>
References: <1362554271-22382-1-git-send-email-feng.tang@intel.com> <1362554271-22382-6-git-send-email-feng.tang@intel.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Mar 2013, Feng Tang wrote:

> There are some new processors whose TSC clocksource won't stop during
> suspend. Currently, after system resumes, kernel will use persistent
> clock or RTC to compensate the sleep time, but for those new types of
> clocksources, we could skip the special compensation from external
> sources, and just use current clocksource for time recounting.
> 
> This can solve some time drift bugs caused by some not-so-accurate or
> error-prone RTC devices.
> 
> The current way to count suspened time is first try to use the persistent
> clock, and then try the rtc if persistent clock can't be used. This
> patch will change the trying order to:
> 	suspend-nonstop clocksource -> persistent clock -> rtc
> 
> Signed-off-by: Feng Tang <feng.tang@intel.com>
> ---
>  kernel/time/timekeeping.c |   42 ++++++++++++++++++++++++++++++++++--------
>  1 file changed, 34 insertions(+), 8 deletions(-)
> 
> diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
> index 9a0bc98..bd7c27b 100644
> --- a/kernel/time/timekeeping.c
> +++ b/kernel/time/timekeeping.c
> @@ -788,22 +788,48 @@ void timekeeping_inject_sleeptime(struct timespec *delta)
>  static void timekeeping_resume(void)
>  {
>  	struct timekeeper *tk = &timekeeper;
> +	struct clocksource *clock = tk->clock;
>  	unsigned long flags;
> -	struct timespec ts;
> +	struct timespec ts_new, ts_delta;
> +	cycle_t cycle_now, cycle_delta;
> +	s64 nsec;
>  
> -	read_persistent_clock(&ts);
> +	ts_delta.tv_sec = 0;
> +	read_persistent_clock(&ts_new);
>  
>  	clockevents_resume();
>  	clocksource_resume();
>  
>  	write_seqlock_irqsave(&tk->lock, flags);
>  
> -	if (timespec_compare(&ts, &timekeeping_suspend_time) > 0) {
> -		ts = timespec_sub(ts, timekeeping_suspend_time);
> -		__timekeeping_inject_sleeptime(tk, &ts);
> -	}
> -	/* re-base the last cycle value */
> -	tk->clock->cycle_last = tk->clock->read(tk->clock);
> +	/*
> +	 * After system resumes, we need to calculate the suspended time and
> +	 * compensate it for the OS time. There are 3 sources that could be
> +	 * used: Nonstop clocksource during suspend, persistent clock and rtc
> +	 * device.
> +	 *
> +	 * One specific platform may have 1 or 2 or all of them, and the
> +	 * preference will be:
> +	 *	suspend-nonstop clocksource -> persistent clock -> rtc
> +	 * The less preferred source will only be tried if there is no better
> +	 * usable source. The rtc part is handled separately in rtc core code.
> +	 */
> +	cycle_now = clock->read(clock);
> +	if ((clock->flags & CLOCK_SOURCE_SUSPEND_NONSTOP) &&
> +		cycle_now > clock->cycle_last) {
> +
> +		cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
> +		nsec = clocksource_cyc2ns(cycle_delta, clock->mult,
> +							clock->shift);
> +		ts_delta = ns_to_timespec(nsec);
> +	} else if (timespec_compare(&ts_new, &timekeeping_suspend_time) > 0)
> +		ts_delta = timespec_sub(ts_new, timekeeping_suspend_time);
> +
> +	if (ts_delta.tv_sec >= 1)
> +		__timekeeping_inject_sleeptime(tk, &ts_delta);

If the suspend time measured by the nonstop clocksource is 0.999 sec
then we throw it away and then let the RTC code inject inaccurate
sleep time? Brilliant design, really.

Thanks,

	tglx
