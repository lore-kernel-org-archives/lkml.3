Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755034AbaKSJWE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 04:22:04 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:53197 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754947AbaKSJWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 04:22:00 -0500
Message-ID: <546C6135.90201@linaro.org>
Date: Wed, 19 Nov 2014 10:21:57 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Roman Byshko <rbyshko@gmail.com>, stable@vger.kernel.org
Subject: Re: [PATCH] clockevent: sun4i: Fix race condition in the probe code
References: <1416351573-5815-1-git-send-email-maxime.ripard@free-electrons.com>
In-Reply-To: <1416351573-5815-1-git-send-email-maxime.ripard@free-electrons.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2014 11:59 PM, Maxime Ripard wrote:
> The interrupts were activated and the handler registered before the clockevent
> was registered in the probe function.
>
> The interrupt handler, however, was making the assumption that the clockevent
> device was registered.
>
> That could cause a null pointer dereferenc if the timer interrupt was firing
> during this narrow window.
>
> Fix that by moving the clockevent registration before the interrupt is enabled.
>
> Reported-by: Roman Byshko <rbyshko@gmail.com>
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> Cc: stable@vger.kernel.org

Applied to my tree as 3.18 fix.

Thanks !

   -- Daniel

> ---
>   drivers/clocksource/sun4i_timer.c | 12 ++++++------
>   1 file changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/clocksource/sun4i_timer.c b/drivers/clocksource/sun4i_timer.c
> index efb17c3ee120..f4a9c0058b4d 100644
> --- a/drivers/clocksource/sun4i_timer.c
> +++ b/drivers/clocksource/sun4i_timer.c
> @@ -182,6 +182,12 @@ static void __init sun4i_timer_init(struct device_node *node)
>   	/* Make sure timer is stopped before playing with interrupts */
>   	sun4i_clkevt_time_stop(0);
>
> +	sun4i_clockevent.cpumask = cpu_possible_mask;
> +	sun4i_clockevent.irq = irq;
> +
> +	clockevents_config_and_register(&sun4i_clockevent, rate,
> +					TIMER_SYNC_TICKS, 0xffffffff);
> +
>   	ret = setup_irq(irq, &sun4i_timer_irq);
>   	if (ret)
>   		pr_warn("failed to setup irq %d\n", irq);
> @@ -189,12 +195,6 @@ static void __init sun4i_timer_init(struct device_node *node)
>   	/* Enable timer0 interrupt */
>   	val = readl(timer_base + TIMER_IRQ_EN_REG);
>   	writel(val | TIMER_IRQ_EN(0), timer_base + TIMER_IRQ_EN_REG);
> -
> -	sun4i_clockevent.cpumask = cpu_possible_mask;
> -	sun4i_clockevent.irq = irq;
> -
> -	clockevents_config_and_register(&sun4i_clockevent, rate,
> -					TIMER_SYNC_TICKS, 0xffffffff);
>   }
>   CLOCKSOURCE_OF_DECLARE(sun4i, "allwinner,sun4i-a10-timer",
>   		       sun4i_timer_init);
>


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

