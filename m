Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755594AbaICJtU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 05:49:20 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:35048 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753226AbaICJtT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 05:49:19 -0400
Message-ID: <5406E41B.1040406@linaro.org>
Date: Wed, 03 Sep 2014 11:49:15 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: =?UTF-8?B?R2HDq2wgUE9SVEFZ?= <g.portay@overkiz.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-pwm@vger.kernel.org, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Thierry Reding <thierry.reding@gmail.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Subject: Re: [PATCHv2 4/4] clocksource: tcb_clksrc: unprepare clock in case
 of failure
References: <1409329003-17252-1-git-send-email-g.portay@overkiz.com> <1409329003-17252-5-git-send-email-g.portay@overkiz.com>
In-Reply-To: <1409329003-17252-5-git-send-email-g.portay@overkiz.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/29/2014 06:16 PM, Gaël PORTAY wrote:
> The clock is not unprepared in case of the request IRQ fails.
>
> Also update to request_irq.
>
> Signed-off-by: Gaël PORTAY <g.portay@overkiz.com>

Acked-by: Daniel Lezcano <daniel.lezcano@linaro.org>

> ---
>   drivers/clocksource/tcb_clksrc.c | 13 ++++---------
>   1 file changed, 4 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/clocksource/tcb_clksrc.c b/drivers/clocksource/tcb_clksrc.c
> index f922e81..8bdbc45 100644
> --- a/drivers/clocksource/tcb_clksrc.c
> +++ b/drivers/clocksource/tcb_clksrc.c
> @@ -178,12 +178,6 @@ static irqreturn_t ch2_irq(int irq, void *handle)
>   	return IRQ_NONE;
>   }
>
> -static struct irqaction tc_irqaction = {
> -	.name		= "tc_clkevt",
> -	.flags		= IRQF_TIMER,
> -	.handler	= ch2_irq,
> -};
> -
>   static int __init setup_clkevents(struct atmel_tc *tc, int clk32k_divisor_idx)
>   {
>   	int ret;
> @@ -198,15 +192,16 @@ static int __init setup_clkevents(struct atmel_tc *tc, int clk32k_divisor_idx)
>
>   	clkevt.regs = tc->regs;
>   	clkevt.clk = t2_clk;
> -	tc_irqaction.dev_id = &clkevt;
>
>   	timer_clock = clk32k_divisor_idx;
>
>   	clkevt.clkevt.cpumask = cpumask_of(0);
>
> -	ret = setup_irq(irq, &tc_irqaction);
> -	if (ret)
> +	ret = request_irq(irq, ch2_irq, IRQF_TIMER, "tc_clkevt", &clkevt);
> +	if (ret) {
> +		clk_disable_unprepare(t2_clk);
>   		return ret;
> +	}
>
>   	clockevents_config_and_register(&clkevt.clkevt, 32768, 1, 0xffff);
>
>


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

