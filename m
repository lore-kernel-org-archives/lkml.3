Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754936Ab3IYWBS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 18:01:18 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:50512 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754635Ab3IYWBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 18:01:17 -0400
Message-ID: <52435D2A.1000907@linaro.org>
Date: Thu, 26 Sep 2013 00:01:14 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>, rjw@sisk.pl
CC: linaro-kernel@lists.linaro.org, patches@linaro.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/21] cpuidle: reduce code duplication inside cpuidle_idle_call()
References: <cover.1379779777.git.viresh.kumar@linaro.org> <5e4629515deb76208df205210a77b1e8a9984f79.1379779777.git.viresh.kumar@linaro.org>
In-Reply-To: <5e4629515deb76208df205210a77b1e8a9984f79.1379779777.git.viresh.kumar@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/22/2013 03:21 AM, Viresh Kumar wrote:
> We are doing this twice in cpuidle_idle_call() routine:
> 	drv->states[next_state].flags & CPUIDLE_FLAG_TIMER_STOP
> 
> Would be better if we actually store this in a local variable and use that. That
> would remove code duplication as well as make this piece of code run fast (in
> case compiler wasn't able to optimize it earlier)
> 
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

Acked-by: Daniel Lezcano <daniel.lezcano@linaro.org>

> ---
>  drivers/cpuidle/cpuidle.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
> index b8c63cb..ed67e3c 100644
> --- a/drivers/cpuidle/cpuidle.c
> +++ b/drivers/cpuidle/cpuidle.c
> @@ -118,6 +118,7 @@ int cpuidle_idle_call(void)
>  	struct cpuidle_device *dev = __this_cpu_read(cpuidle_devices);
>  	struct cpuidle_driver *drv;
>  	int next_state, entered_state;
> +	bool broadcast;
>  
>  	if (cpuidle_disabled() || !initialized)
>  		return -ENODEV;
> @@ -141,7 +142,9 @@ int cpuidle_idle_call(void)
>  
>  	trace_cpu_idle_rcuidle(next_state, dev->cpu);
>  
> -	if (drv->states[next_state].flags & CPUIDLE_FLAG_TIMER_STOP)
> +	broadcast = drv->states[next_state].flags & CPUIDLE_FLAG_TIMER_STOP;
> +
> +	if (broadcast)
>  		clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_ENTER,
>  				   &dev->cpu);
>  
> @@ -151,7 +154,7 @@ int cpuidle_idle_call(void)
>  	else
>  		entered_state = cpuidle_enter_state(dev, drv, next_state);
>  
> -	if (drv->states[next_state].flags & CPUIDLE_FLAG_TIMER_STOP)
> +	if (broadcast)
>  		clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_EXIT,
>  				   &dev->cpu);
>  
> 


-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

