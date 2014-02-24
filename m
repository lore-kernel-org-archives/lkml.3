Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753131AbaBXQw3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 11:52:29 -0500
Received: from mail-qa0-f50.google.com ([209.85.216.50]:44187 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752655AbaBXQw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 11:52:26 -0500
Date: Mon, 24 Feb 2014 11:52:24 -0500 (EST)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Tuukka Tikkanen <tuukka.tikkanen@linaro.org>
cc: linux-pm@vger.kernel.org, rjw@rjwysocki.net, daniel.lezcano@linaro.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/7] Cpuidle: rename expected_us to next_timer_us in menu
 governor
In-Reply-To: <1393223377-5744-2-git-send-email-tuukka.tikkanen@linaro.org>
Message-ID: <alpine.LFD.2.11.1402241152060.17677@knanqh.ubzr>
References: <1393223377-5744-1-git-send-email-tuukka.tikkanen@linaro.org> <1393223377-5744-2-git-send-email-tuukka.tikkanen@linaro.org>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Feb 2014, Tuukka Tikkanen wrote:

> The field expected_us is used to store the time remaining until next
> timer expiry. The name is inaccurate, as we really do not expect all
> wakeups to be caused by timers. In addition, another field with a very
> similar name (predicted_us) is used to store the predicted time
> remaining until any wakeup source being active.
> 
> This patch renames expected_us to next_timer_us in order to better
> reflect the contained information.
> 
> Signed-off-by: Tuukka Tikkanen <tuukka.tikkanen@linaro.org>

Acked-by: Nicolas Pitre <nico@linaro.org>

> ---
>  drivers/cpuidle/governors/menu.c |   18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/cpuidle/governors/menu.c b/drivers/cpuidle/governors/menu.c
> index cf7f2f0..e9a2a27 100644
> --- a/drivers/cpuidle/governors/menu.c
> +++ b/drivers/cpuidle/governors/menu.c
> @@ -122,7 +122,7 @@ struct menu_device {
>  	int		last_state_idx;
>  	int             needs_update;
>  
> -	unsigned int	expected_us;
> +	unsigned int	next_timer_us;
>  	unsigned int	predicted_us;
>  	unsigned int	exit_us;
>  	unsigned int	bucket;
> @@ -257,7 +257,7 @@ again:
>  		stddev = int_sqrt(stddev);
>  		if (((avg > stddev * 6) && (divisor * 4 >= INTERVALS * 3))
>  							|| stddev <= 20) {
> -			if (data->expected_us > avg)
> +			if (data->next_timer_us > avg)
>  				data->predicted_us = avg;
>  			return;
>  		}
> @@ -306,11 +306,11 @@ static int menu_select(struct cpuidle_driver *drv, struct cpuidle_device *dev)
>  
>  	/* determine the expected residency time, round up */
>  	t = ktime_to_timespec(tick_nohz_get_sleep_length());
> -	data->expected_us =
> +	data->next_timer_us =
>  		t.tv_sec * USEC_PER_SEC + t.tv_nsec / NSEC_PER_USEC;
>  
>  
> -	data->bucket = which_bucket(data->expected_us);
> +	data->bucket = which_bucket(data->next_timer_us);
>  
>  	multiplier = performance_multiplier();
>  
> @@ -326,7 +326,7 @@ static int menu_select(struct cpuidle_driver *drv, struct cpuidle_device *dev)
>  	 * operands are 32 bits.
>  	 * Make sure to round up for half microseconds.
>  	 */
> -	data->predicted_us = div_round64((uint64_t)data->expected_us *
> +	data->predicted_us = div_round64((uint64_t)data->next_timer_us *
>  					 data->correction_factor[data->bucket],
>  					 RESOLUTION * DECAY);
>  
> @@ -336,7 +336,7 @@ static int menu_select(struct cpuidle_driver *drv, struct cpuidle_device *dev)
>  	 * We want to default to C1 (hlt), not to busy polling
>  	 * unless the timer is happening really really soon.
>  	 */
> -	if (data->expected_us > 5 &&
> +	if (data->next_timer_us > 5 &&
>  	    !drv->states[CPUIDLE_DRIVER_STATE_START].disabled &&
>  		dev->states_usage[CPUIDLE_DRIVER_STATE_START].disable == 0)
>  		data->last_state_idx = CPUIDLE_DRIVER_STATE_START;
> @@ -401,7 +401,7 @@ static void menu_update(struct cpuidle_driver *drv, struct cpuidle_device *dev)
>  	 * for the whole expected time.
>  	 */
>  	if (unlikely(!(target->flags & CPUIDLE_FLAG_TIME_VALID)))
> -		last_idle_us = data->expected_us;
> +		last_idle_us = data->next_timer_us;
>  
>  
>  	measured_us = last_idle_us;
> @@ -418,8 +418,8 @@ static void menu_update(struct cpuidle_driver *drv, struct cpuidle_device *dev)
>  	new_factor = data->correction_factor[data->bucket];
>  	new_factor -= new_factor / DECAY;
>  
> -	if (data->expected_us > 0 && measured_us < MAX_INTERESTING)
> -		new_factor += RESOLUTION * measured_us / data->expected_us;
> +	if (data->next_timer_us > 0 && measured_us < MAX_INTERESTING)
> +		new_factor += RESOLUTION * measured_us / data->next_timer_us;
>  	else
>  		/*
>  		 * we were idle so long that we count it as a perfect
> -- 
> 1.7.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
