Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751848Ab3FFPMr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 11:12:47 -0400
Received: from mail-bk0-f52.google.com ([209.85.214.52]:58269 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733Ab3FFPMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 11:12:45 -0400
Message-ID: <51B0A6E8.20909@linaro.org>
Date: Thu, 06 Jun 2013 17:12:40 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCHv7 01/11] clockevents: Prefer CPU local devices over global
 devices
References: <1370291642-13259-1-git-send-email-sboyd@codeaurora.org> <1370291642-13259-2-git-send-email-sboyd@codeaurora.org>
In-Reply-To: <1370291642-13259-2-git-send-email-sboyd@codeaurora.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/03/2013 10:33 PM, Stephen Boyd wrote:
> On an SMP system with only one global clockevent and a dummy
> clockevent per CPU we run into problems. We want the dummy
> clockevents to be registered as the per CPU tick devices, but
> we can only achieve that if we register the dummy clockevents
> before the global clockevent or if we artificially inflate the
> rating of the dummy clockevents to be higher than the rating
> of the global clockevent. Failure to do so leads to boot
> hangs when the dummy timers are registered on all other CPUs
> besides the CPU that accepted the global clockevent as its tick
> device and there is no broadcast timer to poke the dummy
> devices.
> 
> If we're registering multiple clockevents and one clockevent is
> global and the other is local to a particular CPU we should
> choose to use the local clockevent regardless of the rating of
> the device. This way, if the clockevent is a dummy it will take
> the tick device duty as long as there isn't a higher rated tick
> device and any global clockevent will be bumped out into
> broadcast mode, fixing the problem described above.

It is not clear the connection between the changelog, the patch and the
comment. Could you clarify a bit ?

Thanks
  -- Daniel



> Reported-by: Mark Rutland <mark.rutland@arm.com>
> Tested-by: Mark Rutland <mark.rutland@arm.com>
> Tested-by: Sören Brinkmann <soren.brinkmann@xilinx.com>
> Acked-by: Marc Zyngier <marc.zyngier@arm.com>,
> Cc: John Stultz <john.stultz@linaro.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
>  kernel/time/tick-common.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/time/tick-common.c b/kernel/time/tick-common.c
> index 5d3fb10..3da62de 100644
> --- a/kernel/time/tick-common.c
> +++ b/kernel/time/tick-common.c
> @@ -254,9 +254,10 @@ static int tick_check_new_device(struct clock_event_device *newdev)
>  		    !(newdev->features & CLOCK_EVT_FEAT_ONESHOT))
>  			goto out_bc;
>  		/*
> -		 * Check the rating
> +		 * Check the rating, but prefer CPU local devices
>  		 */
> -		if (curdev->rating >= newdev->rating)
> +		if (curdev->rating >= newdev->rating &&
> +		    cpumask_equal(curdev->cpumask, newdev->cpumask))
>  			goto out_bc;
>  	}
>  
> 


-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

