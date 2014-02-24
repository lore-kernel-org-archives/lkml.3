Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752960AbaBXQ5S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 11:57:18 -0500
Received: from mail-qa0-f48.google.com ([209.85.216.48]:50899 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752240AbaBXQ5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 11:57:17 -0500
Date: Mon, 24 Feb 2014 11:57:14 -0500 (EST)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Tuukka Tikkanen <tuukka.tikkanen@linaro.org>
cc: linux-pm@vger.kernel.org, rjw@rjwysocki.net, daniel.lezcano@linaro.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/7] Cpuidle: Ensure menu coefficients stay within
 domain
In-Reply-To: <1393223377-5744-4-git-send-email-tuukka.tikkanen@linaro.org>
Message-ID: <alpine.LFD.2.11.1402241156440.17677@knanqh.ubzr>
References: <1393223377-5744-1-git-send-email-tuukka.tikkanen@linaro.org> <1393223377-5744-4-git-send-email-tuukka.tikkanen@linaro.org>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Feb 2014, Tuukka Tikkanen wrote:

> The menu governor uses coefficients as one method of actual idle
> period length estimation. The coefficients are, as detailed below,
> multipliers giving expected idle period length from time until next
> timer expiry. The multipliers are supposed to have domain of (0..1].
> 
> The coefficients are fractions where only the numerators are stored
> and denominators are a shared constant RESOLUTION*DECAY. Since the
> value of the coefficient should always be greater than 0 and less
> than or equal to 1, the numerator must have a value greater than
> 0 and less than or equal to RESOLUTION*DECAY.
> 
> If the coefficients are updated with measured idle durations exceeding
> timer length, the multiplier may reach values exceeding unity (i.e.
> the stored numerator exceeds RESOLUTION*DECAY). This patch ensures that
> the multipliers are updated with durations capped to timer length.
> 
> Signed-off-by: Tuukka Tikkanen <tuukka.tikkanen@linaro.org>
Acked-by: Nicolas Pitre <nico@linaro.org>


> ---
>  drivers/cpuidle/governors/menu.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/cpuidle/governors/menu.c b/drivers/cpuidle/governors/menu.c
> index 115386a..f0995dd 100644
> --- a/drivers/cpuidle/governors/menu.c
> +++ b/drivers/cpuidle/governors/menu.c
> @@ -410,6 +410,9 @@ static void menu_update(struct cpuidle_driver *drv, struct cpuidle_device *dev)
>  	if (measured_us > target->exit_latency)
>  		measured_us -= target->exit_latency;
>  
> +	/* Make sure our coefficients do not exceed unity */
> +	if (measured_us > data->next_timer_us)
> +		measured_us = data->next_timer_us;
>  
>  	/* Update our correction ratio */
>  	new_factor = data->correction_factor[data->bucket];
> -- 
> 1.7.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
