Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755294Ab3IYWiy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 18:38:54 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:33092 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752941Ab3IYWix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 18:38:53 -0400
Message-ID: <524365FA.4090108@linaro.org>
Date: Thu, 26 Sep 2013 00:38:50 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>, rjw@sisk.pl
CC: linaro-kernel@lists.linaro.org, patches@linaro.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 20/21] cpuidle: don't calculate time-diff if entered_state
 == 0
References: <cover.1379779777.git.viresh.kumar@linaro.org> <acd1cc837f969a50582d2b25a73c5e247f40f843.1379779777.git.viresh.kumar@linaro.org>
In-Reply-To: <acd1cc837f969a50582d2b25a73c5e247f40f843.1379779777.git.viresh.kumar@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/22/2013 03:21 AM, Viresh Kumar wrote:
> If entered_state == 0, we don't need to set dev->last_residency to 'diff' as we
> will be setting it to zero without using its new value.

I don't get it, can you elaborate. We can be a long time in this state
(eg. if the prediction is false).

> And so move calculation of diff also inside the "if" statement.
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
>  drivers/cpuidle/cpuidle.c | 17 +++++++++--------
>  1 file changed, 9 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
> index bf80236..cb81689 100644
> --- a/drivers/cpuidle/cpuidle.c
> +++ b/drivers/cpuidle/cpuidle.c
> @@ -77,23 +77,22 @@ int cpuidle_enter_state(struct cpuidle_device *dev, struct cpuidle_driver *drv,
>  
>  	struct cpuidle_state *target_state = &drv->states[index];
>  	ktime_t time_start, time_end;
> -	s64 diff;
>  
>  	time_start = ktime_get();
>  
>  	entered_state = target_state->enter(dev, drv, index);
>  
> -	time_end = ktime_get();
> +	if (entered_state >= 0) {
> +		s64 diff;
>  
> -	local_irq_enable();
> +		time_end = ktime_get();
> +		diff = ktime_to_us(ktime_sub(time_end, time_start));
>  
> -	diff = ktime_to_us(ktime_sub(time_end, time_start));
> -	if (diff > INT_MAX)
> -		diff = INT_MAX;
> +		if (diff > INT_MAX)
> +			diff = INT_MAX;
>  
> -	dev->last_residency = (int) diff;
> +		dev->last_residency = (int) diff;
>  
> -	if (entered_state >= 0) {
>  		/* Update cpuidle counters */
>  		/* This can be moved to within driver enter routine
>  		 * but that results in multiple copies of same code.
> @@ -104,6 +103,8 @@ int cpuidle_enter_state(struct cpuidle_device *dev, struct cpuidle_driver *drv,
>  		dev->last_residency = 0;
>  	}
>  
> +	local_irq_enable();
> +
>  	return entered_state;
>  }
>  
> 


-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

