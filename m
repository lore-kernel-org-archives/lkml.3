Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752501Ab3CEG1n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 01:27:43 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:59726 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751974Ab3CEG1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 01:27:42 -0500
Message-ID: <51359056.60506@linaro.org>
Date: Tue, 05 Mar 2013 14:27:34 +0800
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Feng Tang <feng.tang@intel.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@linux.intel.com>, x86@kernel.org,
        Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-kernel@vger.kernel.org, gong.chen@linux.intel.com
Subject: Re: [RFC PATCH v2 4/4] timekeeping: utilize the suspend-nonstop clocksource
 to count suspended time
References: <1362450426-4232-1-git-send-email-feng.tang@intel.com> <1362450426-4232-5-git-send-email-feng.tang@intel.com>
In-Reply-To: <1362450426-4232-5-git-send-email-feng.tang@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/05/2013 10:27 AM, Feng Tang wrote:
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

Thanks for sending out another iteration of this code. Jason's feedback 
has been good, but I think this is starting to shape up nicely.

More below

> Signed-off-by: Feng Tang <feng.tang@intel.com>
> ---
>   kernel/time/timekeeping.c |   57 ++++++++++++++++++++++++++++++++++++++------
>   1 files changed, 49 insertions(+), 8 deletions(-)
>
> diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
> index 9a0bc98..15cc086 100644
> --- a/kernel/time/timekeeping.c
> +++ b/kernel/time/timekeeping.c
> @@ -788,22 +788,63 @@ void timekeeping_inject_sleeptime(struct timespec *delta)
>   static void timekeeping_resume(void)
>   {
>   	struct timekeeper *tk = &timekeeper;
> +	struct clocksource *clock = tk->clock;
>   	unsigned long flags;
> -	struct timespec ts;
> +	struct timespec ts_new, ts_delta;
> +	cycle_t cycle_now, cycle_delta;
> +	s64 nsec;
>   
> -	read_persistent_clock(&ts);
> +	ts_delta.tv_sec = 0;
> +	read_persistent_clock(&ts_new);
>   
>   	clockevents_resume();
>   	clocksource_resume();
>   
>   	write_seqlock_irqsave(&tk->lock, flags);
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
> +	 *	suspend-nonstop clocksource > persistent clock > rtc
> +	 * The less preferred source will only be tried if there is no better
> +	 * usable source. The rtc part is handled separately in rtc core code.
> +	 */
> +	cycle_now = clock->read(clock);

So this might be ok for an initial implementation, as on the 
non-stop-tsc hardware, the TSC is the best clocksource available. One 
concern long term is that there may be cases where the non-stop 
clocksource is not the most performant clocksource on a system. In that 
case, we may want to use a non-stop clocksource that is not the current 
timekeeping clocksource. So that may require some extra clocksource core 
interfaces to access the non-stop clocksource instead of using the 
timekeeper's clocksource, also we'll have to be sure to use something 
other then cycle_last in that case, since we'll need to read the nonstop 
clocksource at suspend, rather then trusting that forward_now updates 
cycle_last as is done here.

thanks
-john

