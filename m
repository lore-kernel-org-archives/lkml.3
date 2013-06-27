Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752593Ab3F0KRh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 06:17:37 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:65286 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751685Ab3F0KRg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 06:17:36 -0400
Date: Thu, 27 Jun 2013 13:17:29 +0300
From: Siarhei Siamashka <siarhei.siamashka@gmail.com>
To: linux-sunxi@googlegroups.com
Cc: maxime.ripard@free-electrons.com, John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Emilio Lopez <emilio@elopez.com.ar>, kevin@allwinnertech.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com
Subject: Re: [linux-sunxi] [PATCH 2/8] clocksource: sun4i: Add clocksource
 and sched clock drivers
Message-ID: <20130627131729.5fff8468@i7>
In-Reply-To: <1372281421-2099-3-git-send-email-maxime.ripard@free-electrons.com>
References: <1372281421-2099-1-git-send-email-maxime.ripard@free-electrons.com>
	<1372281421-2099-3-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.17; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Jun 2013 23:16:55 +0200
Maxime Ripard <maxime.ripard@free-electrons.com> wrote:

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

If we can be absolutely sure that nothing else may ever change
the TIMER_CNT64_CTL_REG, then its default value can be probably
cached instead of doing expensive read from the hardware register
each time?

The gettimeofday() abusers will feel a bit less pain. ARM does not
currently enjoy the VDSO optimized gettimeofday, so the software
which has been only tested on x86 may get a nasty surprise (an order
of magnitude higher gettimeofday overhead).

> +	writel(reg | TIMER_CNT64_CTL_RL, timer_base + TIMER_CNT64_CTL_REG);
> +	while (readl(timer_base + TIMER_CNT64_CTL_REG) & TIMER_CNT64_CTL_REG);

Some may think that this particular loop looks like a performance
bottleneck, but it is very rarely run for more than one iteration.
In fact, most of the time it just happens to be a single HW register
read.

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
>  	       timer_base + TIMER_INTVAL_REG(0));
>  



-- 
Best regards,
Siarhei Siamashka
