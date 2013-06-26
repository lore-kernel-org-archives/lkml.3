Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753086Ab3FZV11 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 17:27:27 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:60546 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585Ab3FZV10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 17:27:26 -0400
Message-ID: <51CB5CC7.7000308@linaro.org>
Date: Wed, 26 Jun 2013 23:27:35 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Maxime Ripard <maxime.ripard@free-electrons.com>
CC: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Emilio Lopez <emilio@elopez.com.ar>, kevin@allwinnertech.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        linux-sunxi@googlegroups.com
Subject: Re: [PATCH 2/8] clocksource: sun4i: Add clocksource and sched clock
 drivers
References: <1372281421-2099-1-git-send-email-maxime.ripard@free-electrons.com> <1372281421-2099-3-git-send-email-maxime.ripard@free-electrons.com>
In-Reply-To: <1372281421-2099-3-git-send-email-maxime.ripard@free-electrons.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/26/2013 11:16 PM, Maxime Ripard wrote:
> The A10 and the A13 has a 64 bits free running counter that we can use
> as a clocksource and a sched clock, that were both not used yet on these
> platforms.
> 
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> ---
>  drivers/clocksource/sun4i_timer.c | 27 +++++++++++++++++++++++++++
>  1 file changed, 27 insertions(+)
> 
> diff --git a/drivers/clocksource/sun4i_timer.c b/drivers/clocksource/sun4i_timer.c
> index bdf34d9..1d2eaa0 100644
> --- a/drivers/clocksource/sun4i_timer.c
> +++ b/drivers/clocksource/sun4i_timer.c
> @@ -23,6 +23,8 @@
>  #include <linux/of_address.h>
>  #include <linux/of_irq.h>
>  
> +#include <asm/sched_clock.h>
> +
>  #define TIMER_IRQ_EN_REG	0x00
>  #define TIMER_IRQ_EN(val)		BIT(val)
>  #define TIMER_IRQ_ST_REG	0x04
> @@ -34,6 +36,11 @@
>  #define TIMER_CNTVAL_REG(val)	(0x10 * val + 0x18)
>  
>  #define TIMER_SCAL		16
> +#define TIMER_CNT64_CTL_REG	0xa0
> +#define TIMER_CNT64_CTL_CLR		BIT(0)
> +#define TIMER_CNT64_CTL_RL		BIT(1)
> +#define TIMER_CNT64_LOW_REG	0xa4
> +#define TIMER_CNT64_HIGH_REG	0xa8
>  
>  static void __iomem *timer_base;
>  
> @@ -96,6 +103,20 @@ static struct irqaction sun4i_timer_irq = {
>  	.dev_id = &sun4i_clockevent,
>  };
>  
> +static u32 sun4i_timer_sched_read(void)
> +{
> +	u32 reg = readl(timer_base + TIMER_CNT64_CTL_REG);
> +	writel(reg | TIMER_CNT64_CTL_RL, timer_base + TIMER_CNT64_CTL_REG);
> +	while (readl(timer_base + TIMER_CNT64_CTL_REG) & TIMER_CNT64_CTL_REG);

Isn't a cpu_relax missing here ?

> +
> +	return readl(timer_base + TIMER_CNT64_LOW_REG);
> +}
> +
> +static cycle_t sun4i_timer_clksrc_read(struct clocksource *c)
> +{
> +	return sun4i_timer_sched_read();
> +}
> +
>  static void __init sun4i_timer_init(struct device_node *node)
>  {
>  	unsigned long rate = 0;
> @@ -117,6 +138,12 @@ static void __init sun4i_timer_init(struct device_node *node)
>  
>  	rate = clk_get_rate(clk);
>  
> +	writel(TIMER_CNT64_CTL_CLR, timer_base + TIMER_CNT64_CTL_REG);
> +	setup_sched_clock(sun4i_timer_sched_read, 32, clk_get_rate(clk));
> +	clocksource_mmio_init(timer_base + TIMER_CNT64_LOW_REG, node->name,
> +			      clk_get_rate(clk), 300, 32,
> +			      sun4i_timer_clksrc_read);
> +
>  	writel(rate / (TIMER_SCAL * HZ),

DIV_ROUND_CLOSEST(rate, (TIMER_SCAL * HZ)), ?

>  	       timer_base + TIMER_INTVAL_REG(0));


-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

