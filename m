Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752750AbaBXRFn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 12:05:43 -0500
Received: from mail-qa0-f47.google.com ([209.85.216.47]:48300 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752314AbaBXRFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 12:05:41 -0500
Date: Mon, 24 Feb 2014 12:05:39 -0500 (EST)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Tuukka Tikkanen <tuukka.tikkanen@linaro.org>
cc: linux-pm@vger.kernel.org, rjw@rjwysocki.net, daniel.lezcano@linaro.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/7] Cpuidle: Deal with timer expiring in the past
In-Reply-To: <1393223377-5744-7-git-send-email-tuukka.tikkanen@linaro.org>
Message-ID: <alpine.LFD.2.11.1402241201330.17677@knanqh.ubzr>
References: <1393223377-5744-1-git-send-email-tuukka.tikkanen@linaro.org> <1393223377-5744-7-git-send-email-tuukka.tikkanen@linaro.org>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Feb 2014, Tuukka Tikkanen wrote:

> Sometimes (fairly often) when the cpuidle menu governor is making a decision
> about idle state to enter the next timer for the cpu appears to expire in
> the past. The menu governor expects the expiry to always be in the future
> and in fact stores the time delta in an unsigned variable. However, when
> the expiry is in the past, the value returned by tick_nohz_get_sleep_length
> can be negative. This patch prevents using negative values, instead making
> the governor return immediately similar to having latency requirement set
> to 0.
> 
> Note: As with latency == 0, the return value is 0 with no check to see if
> the state 0 has been disabled or not.

In your cover letter you mention some occurrences of the negative result 
being observed on x86.  That information is worth capturing in the 
commit log as well to distinguish between theoretical problems from 
actual observations.

> 
> Signed-off-by: Tuukka Tikkanen <tuukka.tikkanen@linaro.org>
> ---
>  drivers/cpuidle/governors/menu.c |   10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/cpuidle/governors/menu.c b/drivers/cpuidle/governors/menu.c
> index 71b5232..c414468 100644
> --- a/drivers/cpuidle/governors/menu.c
> +++ b/drivers/cpuidle/governors/menu.c
> @@ -302,8 +302,16 @@ static int menu_select(struct cpuidle_driver *drv, struct cpuidle_device *dev)
>  	if (unlikely(latency_req == 0))
>  		return 0;
>  
> -	/* determine the expected residency time, round up */
> +	/*
> +	 * Determine the expected residency time. If the time is negative,
> +	 * a timer interrupt has probably just expired after disabling
> +	 * interrupts. Return as quickly as possible in the most shallow
> +	 * state possible. tv_nsec is always positive, so only check the
> +	 * seconds.
> +	 */
>  	t = ktime_to_timespec(tick_nohz_get_sleep_length());
> +	if (t.tv_sec < 0)
> +		return 0;
>  	data->next_timer_us =
>  		t.tv_sec * USEC_PER_SEC + t.tv_nsec / NSEC_PER_USEC;
>  
> -- 
> 1.7.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
