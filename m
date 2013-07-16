Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932816Ab3GPNwc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 09:52:32 -0400
Received: from mail-bk0-f50.google.com ([209.85.214.50]:33005 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932280Ab3GPNwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 09:52:30 -0400
Message-ID: <51E5501A.6070403@linaro.org>
Date: Tue, 16 Jul 2013 15:52:26 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Jonas Jensen <jonas.jensen@gmail.com>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org, john.stultz@linaro.org, tglx@linutronix.de,
        u.kleine-koenig@pengutronix.de, tomasz.figa@gmail.com,
        linus.walleij@linaro.org, thomas.petazzoni@free-electrons.com,
        arnd@arndb.de
Subject: Re: [PATCH v7] ARM: clocksource: add support for MOXA ART SoCs
References: <1373018653-18421-1-git-send-email-jonas.jensen@gmail.com> <1373024773-24574-1-git-send-email-jonas.jensen@gmail.com>
In-Reply-To: <1373024773-24574-1-git-send-email-jonas.jensen@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/05/2013 01:46 PM, Jonas Jensen wrote:
> This patch adds an clocksource driver for the main timer(s)
> found on MOXA ART SoCs.
> 
> Signed-off-by: Jonas Jensen <jonas.jensen@gmail.com>
> ---
> 
> Notes:
>     Applies to next-20130703
>     
>     Changes since v6:
>     
>     1. remove TIMER_CR read back
>     2. set TIMER_CR from constants
> 

Except for the few comments below, it looks ok for me.

[ ... ]

> + */
> +#define TIMEREG_CR_1_ENABLE	(1 << 0)
> +#define TIMEREG_CR_1_CLOCK	(1 << 1)
> +#define TIMEREG_CR_1_INT	(1 << 2)
> +#define TIMEREG_CR_2_ENABLE	(1 << 3)
> +#define TIMEREG_CR_2_CLOCK	(1 << 4)
> +#define TIMEREG_CR_2_INT	(1 << 5)
> +#define TIMEREG_CR_3_ENABLE	(1 << 6)
> +#define TIMEREG_CR_3_CLOCK	(1 << 7)
> +#define TIMEREG_CR_3_INT	(1 << 8)
> +#define TIMEREG_CR_COUNT_UP	(1 << 9)
> +#define TIMEREG_CR_COUNT_DOWN	(0 << 9)

Could you replace this by the BIT macro ?

[ ... ]

> +
> +	irq = irq_of_parse_and_map(node, 0);
> +	if (irq <= 0)
> +		panic("%s: irq_of_parse_and_map failed\n", node->full_name);
> +
> +	ret = setup_irq(irq, &moxart_timer_irq);
> +	if (ret)
> +		panic("%s: setup_irq failed\n", node->full_name);
> +
> +	clk = of_clk_get(node, 0);
> +	if (IS_ERR(clk))
> +		panic("%s: of_clk_get failed\n", node->full_name);
> +
> +	pclk = clk_get_rate(clk);
> +
> +	if (clocksource_mmio_init(base + TIMER2_BASE + REG_COUNT,
> +				  "moxart_timer", pclk, 200, 32,
> +				  clocksource_mmio_readl_down))
> +		panic("%s: clocksource_mmio_init failed\n", node->full_name);
> +
> +	clock_count_per_tick = DIV_ROUND_CLOSEST(pclk, HZ);
> +
> +	writel(~0, base + TIMER2_BASE + REG_LOAD);
> +	writel(TIMEREG_CR_2_ENABLE, base + TIMER_CR);
> +
> +	moxart_clockevent.cpumask = cpumask_of(0);

	moxart_clockevent.irq = irq;

> +
> +	/*
> +	 * documentation is not publicly available:
> +	 * min_delta / max_delta obtained by trial-and-error,
> +	 * max_delta 0xfffffffe should be ok because count
> +	 * register size is u32
> +	 */
> +	clockevents_config_and_register(&moxart_clockevent, pclk,
> +					0x4, 0xfffffffe);
> +}
> +CLOCKSOURCE_OF_DECLARE(moxart, "moxa,moxart-timer", moxart_timer_init);


Thanks
  -- Daniel


-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

