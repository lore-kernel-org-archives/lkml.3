Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752152Ab3F0GCq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 02:02:46 -0400
Received: from guitar.tcltek.co.il ([192.115.133.116]:43093 "EHLO
	sivan.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003Ab3F0GCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 02:02:45 -0400
Date: Thu, 27 Jun 2013 09:02:34 +0300
From: Baruch Siach <baruch@tkos.co.il>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Emilio Lopez <emilio@elopez.com.ar>, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com, sunny@allwinnertech.com,
        shuge@allwinnertech.com, kevin@allwinnertech.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/8] clocksource: sun4i: Add clocksource and sched clock
 drivers
Message-ID: <20130627060234.GD4824@tarshish>
References: <1372281421-2099-1-git-send-email-maxime.ripard@free-electrons.com>
 <1372281421-2099-3-git-send-email-maxime.ripard@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372281421-2099-3-git-send-email-maxime.ripard@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Maxime,

On Wed, Jun 26, 2013 at 11:16:55PM +0200, Maxime Ripard wrote:
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

In the tip.git tree (and -next) this header is moved to <linux/sched_clock.h> 
in  38ff87f77a (sched_clock: Make ARM's sched_clock generic for all 
architectures).

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

You commit message mentions "64 bits free running counter", but this one only 
returns 32 bit.

baruch

> +{
> +	u32 reg = readl(timer_base + TIMER_CNT64_CTL_REG);
> +	writel(reg | TIMER_CNT64_CTL_RL, timer_base + TIMER_CNT64_CTL_REG);
> +	while (readl(timer_base + TIMER_CNT64_CTL_REG) & TIMER_CNT64_CTL_REG);
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
     http://baruch.siach.name/blog/                  ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -
