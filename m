Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933578Ab3CLVJO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 17:09:14 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:56198 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933453Ab3CLVJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 17:09:13 -0400
Message-ID: <513F9974.8010909@linaro.org>
Date: Tue, 12 Mar 2013 14:09:08 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Feng Tang <feng.tang@intel.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, x86@kernel.org,
        Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-kernel@vger.kernel.org, gong.chen@linux.intel.com
Subject: Re: [PATCH v4 4/4] timekeeping: utilize the suspend-nonstop clocksource
 to count suspended time
References: <1363060608-22657-1-git-send-email-feng.tang@intel.com> <1363060608-22657-5-git-send-email-feng.tang@intel.com>
In-Reply-To: <1363060608-22657-5-git-send-email-feng.tang@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11/2013 08:56 PM, Feng Tang wrote:
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
> +		u64 num, max = ULLONG_MAX;
> +		u32 mult = clock->mult;
> +		u32 shift = clock->shift;
> +		s64 nsec = 0;
> +
> +		cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
> +
> +		/*
> +		 * "cycle_delta * mutl" may cause 64 bits overflow, if the
> +		 * suspended time is too long. In that case we need do the
> +		 * 64 bits math carefully
> +		 */
> +		do_div(max, mult);
> +		if (cycle_delta > max) {
> +			num = div64_u64(cycle_delta, max);
> +			nsec = (((u64) max * mult) >> shift) * num;
> +			cycle_delta -= num * max;
> +		}
> +		nsec += ((u64) cycle_delta * mult) >> shift;
> +
> +		ts_delta = ns_to_timespec(nsec);
> +		suspendtime_found = true;
> +	} else if (timespec_compare(&ts_new, &timekeeping_suspend_time) > 0) {
> +		ts_delta = timespec_sub(ts_new, timekeeping_suspend_time);
> +		suspendtime_found = true;
>   	}
> -	/* re-base the last cycle value */
> -	tk->clock->cycle_last = tk->clock->read(tk->clock);
> +
> +	if (suspendtime_found)
> +		__timekeeping_inject_sleeptime(tk, &ts_delta);
> +
> +	/* Re-base the last cycle value */
> +	clock->cycle_last = clock->read(clock);
It seems like since we unconditionally read the clock above, this last 
line could be reworked to be:
     clock->cycle_last = cycle_now;

Which would save re-reading the clocksource.

If you don't have any objections I'll fold that small change into your 
patch.

thanks
-john

