Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755039AbaJWQr2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 12:47:28 -0400
Received: from mail-yh0-f46.google.com ([209.85.213.46]:62797 "EHLO
	mail-yh0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751764AbaJWQr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 12:47:27 -0400
Date: Thu, 23 Oct 2014 12:47:23 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
cc: rjw@rjwysocki.net, linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        peterz@infradead.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org
Subject: Re: [PATCH V2 5/5] cpuidle: menu: Move the update function before
 its declaration
In-Reply-To: <1414054881-17713-5-git-send-email-daniel.lezcano@linaro.org>
Message-ID: <alpine.LFD.2.11.1410231246500.6969@knanqh.ubzr>
References: <1414054881-17713-1-git-send-email-daniel.lezcano@linaro.org> <1414054881-17713-5-git-send-email-daniel.lezcano@linaro.org>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Oct 2014, Daniel Lezcano wrote:

> In order to prevent a pointless forward declaration, just move the function
> at the beginning of the file.
> 
> This patch does not change the behavior of the governor, it is just code
> reordering.
> 
> Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>

Acked-by: Nicolas Pitre <nico@linaro.org>

> ---
>  drivers/cpuidle/governors/menu.c | 149 +++++++++++++++++++--------------------
>  1 file changed, 74 insertions(+), 75 deletions(-)
> 
> diff --git a/drivers/cpuidle/governors/menu.c b/drivers/cpuidle/governors/menu.c
> index 6ae8390..0ac76b1 100644
> --- a/drivers/cpuidle/governors/menu.c
> +++ b/drivers/cpuidle/governors/menu.c
> @@ -184,7 +184,6 @@ static inline int performance_multiplier(unsigned long nr_iowaiters, unsigned lo
>  
>  static DEFINE_PER_CPU(struct menu_device, menu_devices);
>  
> -static void menu_update(struct cpuidle_driver *drv, struct cpuidle_device *dev);
>  
>  /* This implements DIV_ROUND_CLOSEST but avoids 64 bit division */
>  static u64 div_round64(u64 dividend, u32 divisor)
> @@ -192,6 +191,80 @@ static u64 div_round64(u64 dividend, u32 divisor)
>  	return div_u64(dividend + (divisor / 2), divisor);
>  }
>  
> +/**
> + * menu_update - attempts to guess what happened after entry
> + * @drv: cpuidle driver containing state data
> + * @dev: the CPU
> + */
> +static void menu_update(struct cpuidle_driver *drv, struct cpuidle_device *dev)
> +{
> +	struct menu_device *data = &__get_cpu_var(menu_devices);
> +	int last_idx = data->last_state_idx;
> +	struct cpuidle_state *target = &drv->states[last_idx];
> +	unsigned int measured_us;
> +	unsigned int new_factor;
> +
> +	/*
> +	 * Try to figure out how much time passed between entry to low
> +	 * power state and occurrence of the wakeup event.
> +	 *
> +	 * If the entered idle state didn't support residency measurements,
> +	 * we are basically lost in the dark how much time passed.
> +	 * As a compromise, assume we slept for the whole expected time.
> +	 *
> +	 * Any measured amount of time will include the exit latency.
> +	 * Since we are interested in when the wakeup begun, not when it
> +	 * was completed, we must subtract the exit latency. However, if
> +	 * the measured amount of time is less than the exit latency,
> +	 * assume the state was never reached and the exit latency is 0.
> +	 */
> +	if (unlikely(!(target->flags & CPUIDLE_FLAG_TIME_VALID))) {
> +		/* Use timer value as is */
> +		measured_us = data->next_timer_us;
> +
> +	} else {
> +		/* Use measured value */
> +		measured_us = cpuidle_get_last_residency(dev);
> +
> +		/* Deduct exit latency */
> +		if (measured_us > target->exit_latency)
> +			measured_us -= target->exit_latency;
> +
> +		/* Make sure our coefficients do not exceed unity */
> +		if (measured_us > data->next_timer_us)
> +			measured_us = data->next_timer_us;
> +	}
> +
> +	/* Update our correction ratio */
> +	new_factor = data->correction_factor[data->bucket];
> +	new_factor -= new_factor / DECAY;
> +
> +	if (data->next_timer_us > 0 && measured_us < MAX_INTERESTING)
> +		new_factor += RESOLUTION * measured_us / data->next_timer_us;
> +	else
> +		/*
> +		 * we were idle so long that we count it as a perfect
> +		 * prediction
> +		 */
> +		new_factor += RESOLUTION;
> +
> +	/*
> +	 * We don't want 0 as factor; we always want at least
> +	 * a tiny bit of estimated time. Fortunately, due to rounding,
> +	 * new_factor will stay nonzero regardless of measured_us values
> +	 * and the compiler can eliminate this test as long as DECAY > 1.
> +	 */
> +	if (DECAY == 1 && unlikely(new_factor == 0))
> +		new_factor = 1;
> +
> +	data->correction_factor[data->bucket] = new_factor;
> +
> +	/* update the repeating-pattern data */
> +	data->intervals[data->interval_ptr++] = measured_us;
> +	if (data->interval_ptr >= INTERVALS)
> +		data->interval_ptr = 0;
> +}
> +
>  /*
>   * Try detecting repeating patterns by keeping track of the last 8
>   * intervals, and checking if the standard deviation of that set
> @@ -378,80 +451,6 @@ static void menu_reflect(struct cpuidle_device *dev, int index)
>  }
>  
>  /**
> - * menu_update - attempts to guess what happened after entry
> - * @drv: cpuidle driver containing state data
> - * @dev: the CPU
> - */
> -static void menu_update(struct cpuidle_driver *drv, struct cpuidle_device *dev)
> -{
> -	struct menu_device *data = &__get_cpu_var(menu_devices);
> -	int last_idx = data->last_state_idx;
> -	struct cpuidle_state *target = &drv->states[last_idx];
> -	unsigned int measured_us;
> -	unsigned int new_factor;
> -
> -	/*
> -	 * Try to figure out how much time passed between entry to low
> -	 * power state and occurrence of the wakeup event.
> -	 *
> -	 * If the entered idle state didn't support residency measurements,
> -	 * we are basically lost in the dark how much time passed.
> -	 * As a compromise, assume we slept for the whole expected time.
> -	 *
> -	 * Any measured amount of time will include the exit latency.
> -	 * Since we are interested in when the wakeup begun, not when it
> -	 * was completed, we must subtract the exit latency. However, if
> -	 * the measured amount of time is less than the exit latency,
> -	 * assume the state was never reached and the exit latency is 0.
> -	 */
> -	if (unlikely(!(target->flags & CPUIDLE_FLAG_TIME_VALID))) {
> -		/* Use timer value as is */
> -		measured_us = data->next_timer_us;
> -
> -	} else {
> -		/* Use measured value */
> -		measured_us = cpuidle_get_last_residency(dev);
> -
> -		/* Deduct exit latency */
> -		if (measured_us > target->exit_latency)
> -			measured_us -= target->exit_latency;
> -
> -		/* Make sure our coefficients do not exceed unity */
> -		if (measured_us > data->next_timer_us)
> -			measured_us = data->next_timer_us;
> -	}
> -
> -	/* Update our correction ratio */
> -	new_factor = data->correction_factor[data->bucket];
> -	new_factor -= new_factor / DECAY;
> -
> -	if (data->next_timer_us > 0 && measured_us < MAX_INTERESTING)
> -		new_factor += RESOLUTION * measured_us / data->next_timer_us;
> -	else
> -		/*
> -		 * we were idle so long that we count it as a perfect
> -		 * prediction
> -		 */
> -		new_factor += RESOLUTION;
> -
> -	/*
> -	 * We don't want 0 as factor; we always want at least
> -	 * a tiny bit of estimated time. Fortunately, due to rounding,
> -	 * new_factor will stay nonzero regardless of measured_us values
> -	 * and the compiler can eliminate this test as long as DECAY > 1.
> -	 */
> -	if (DECAY == 1 && unlikely(new_factor == 0))
> -		new_factor = 1;
> -
> -	data->correction_factor[data->bucket] = new_factor;
> -
> -	/* update the repeating-pattern data */
> -	data->intervals[data->interval_ptr++] = measured_us;
> -	if (data->interval_ptr >= INTERVALS)
> -		data->interval_ptr = 0;
> -}
> -
> -/**
>   * menu_enable_device - scans a CPU's states and does setup
>   * @drv: cpuidle driver
>   * @dev: the CPU
> -- 
> 1.9.1
> 
> 
