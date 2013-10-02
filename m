Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754136Ab3JBMrh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 08:47:37 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:22841 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753495Ab3JBMrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 08:47:35 -0400
Message-ID: <524C15E6.7070500@atmel.com>
Date: Wed, 2 Oct 2013 14:47:34 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Boris BREZILLON <b.brezillon@overkiz.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] ARM: at91/tc/clocksource: improve driver robustness
References: <1380717265-6497-1-git-send-email-b.brezillon@overkiz.com> <1380717341-6612-1-git-send-email-b.brezillon@overkiz.com>
In-Reply-To: <1380717341-6612-1-git-send-email-b.brezillon@overkiz.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/10/2013 14:35, Boris BREZILLON :
> Check function return values to avoid false positive driver init.
>
> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

> ---
>   drivers/clocksource/tcb_clksrc.c |   33 ++++++++++++++++++++++++++++-----
>   1 file changed, 28 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/clocksource/tcb_clksrc.c b/drivers/clocksource/tcb_clksrc.c
> index 0481562..10a5d9e 100644
> --- a/drivers/clocksource/tcb_clksrc.c
> +++ b/drivers/clocksource/tcb_clksrc.c
> @@ -184,11 +184,18 @@ static struct irqaction tc_irqaction = {
>   	.handler	= ch2_irq,
>   };
>
> -static void __init setup_clkevents(struct atmel_tc *tc, int clk32k_divisor_idx)
> +static int __init setup_clkevents(struct atmel_tc *tc, int clk32k_divisor_idx)
>   {
> +	int ret;
>   	struct clk *t2_clk = tc->clk[2];
>   	int irq = tc->irq[2];
>
> +	/* try to enable t2 clk to avoid future errors in mode change */
> +	ret = clk_prepare_enable(t2_clk);
> +	if (ret)
> +		return ret;
> +	clk_disable_unprepare(t2_clk);
> +
>   	clkevt.regs = tc->regs;
>   	clkevt.clk = t2_clk;
>   	tc_irqaction.dev_id = &clkevt;
> @@ -197,16 +204,21 @@ static void __init setup_clkevents(struct atmel_tc *tc, int clk32k_divisor_idx)
>
>   	clkevt.clkevt.cpumask = cpumask_of(0);
>
> +	ret = setup_irq(irq, &tc_irqaction);
> +	if (ret)
> +		return ret;
> +
>   	clockevents_config_and_register(&clkevt.clkevt, 32768, 1, 0xffff);
>
> -	setup_irq(irq, &tc_irqaction);
> +	return ret;
>   }
>
>   #else /* !CONFIG_GENERIC_CLOCKEVENTS */
>
> -static void __init setup_clkevents(struct atmel_tc *tc, int clk32k_divisor_idx)
> +static int __init setup_clkevents(struct atmel_tc *tc, int clk32k_divisor_idx)
>   {
>   	/* NOTHING */
> +	return 0;
>   }
>
>   #endif
> @@ -328,13 +340,24 @@ static int __init tcb_clksrc_init(void)
>   	}
>
>   	/* and away we go! */
> -	clocksource_register_hz(&clksrc, divided_rate);
> +	ret = clocksource_register_hz(&clksrc, divided_rate);
> +	if (ret)
> +		goto err_disable_t1;
>
>   	/* channel 2:  periodic and oneshot timer support */
> -	setup_clkevents(tc, clk32k_divisor_idx);
> +	ret = setup_clkevents(tc, clk32k_divisor_idx);
> +	if (ret)
> +		goto err_unregister_clksrc;
>
>   	return 0;
>
> +err_unregister_clksrc:
> +	clocksource_unregister(&clksrc);
> +
> +err_disable_t1:
> +	if (!tc->tcb_config || tc->tcb_config->counter_width != 32)
> +		clk_disable_unprepare(tc->clk[1]);
> +
>   err_disable_t0:
>   	clk_disable_unprepare(t0_clk);
>
>


-- 
Nicolas Ferre
