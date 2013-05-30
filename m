Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933603Ab3E3POB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 11:14:01 -0400
Received: from mail-bk0-f54.google.com ([209.85.214.54]:45733 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933340Ab3E3PNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 11:13:54 -0400
Message-ID: <51A76CA9.6080607@linaro.org>
Date: Thu, 30 May 2013 17:13:45 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Daniel Tang <dt.tangr@gmail.com>
CC: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Add TI-Nspire timer support
References: <5F0F2B5B-F956-4F5A-A105-E60F73678882@gmail.com>
In-Reply-To: <5F0F2B5B-F956-4F5A-A105-E60F73678882@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/30/2013 01:11 PM, Daniel Tang wrote:
> Hi,
> 
> This patch adds a clocksource/clockevent driver for the TI-Nspire calculator series.

Please, can you write a better changelog ? What does this chip provide ?
What are the specificity of this chip ? Is there any trick in the code
related to this chip ? etc ...

> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Daniel Tang <dt.tangr@gmail.com>

Seconding Thomas feedbacks + some comments below.

[ ... ]

> +struct zevio_timer {
> +	void __iomem *base;
> +	void __iomem *timer1, *timer2;
> +	void __iomem *interrupt_regs;
> +
> +	int irqnr;

Why do you need to add this field for a value you need to store at init
time ? You can declare this variable in the function, no ?

> +
> +	struct clk *clk;
> +	struct clock_event_device clkevt;
> +	struct irqaction clkevt_irq;
> +
> +	char clocksource_name[64];
> +	char clockevent_name[64];
> +};
> +

[ ... ]

> +static int __init zevio_timer_add(struct device_node *node)
> +{
> +	struct zevio_timer *timer;
> +	struct resource res;
> +	int ret;
> +
> +	timer = kzalloc(sizeof(*timer), GFP_ATOMIC);
> +	if (!timer)
> +		return -ENOMEM;
> +
> +	timer->base = of_iomap(node, 0);
> +	if (!timer->base) {
> +		ret = -EINVAL;
> +		goto error_free;
> +	}
> +	timer->timer1 = timer->base + IO_TIMER1;
> +	timer->timer2 = timer->base + IO_TIMER2;
> +
> +	timer->clk = of_clk_get(node, 0);
> +	if (IS_ERR(timer->clk)) {
> +		ret = PTR_ERR(timer->clk);
> +		pr_err("Timer clock not found! (error %d)\n", ret);
> +		goto error_unmap;
> +	}
> +
> +	timer->interrupt_regs = of_iomap(node, 1);
> +	timer->irqnr = irq_of_parse_and_map(node, 0);
> +
> +	of_address_to_resource(node, 0, &res);
> +	scnprintf(timer->clocksource_name, sizeof(timer->clocksource_name),
> +			"%llx.%s_clocksource",
> +			(unsigned long long)res.start, node->name);
> +
> +	scnprintf(timer->clockevent_name, sizeof(timer->clockevent_name),
> +			"%llx.%s_clockevent",
> +			(unsigned long long)res.start, node->name);
> +
> +	if (timer->interrupt_regs && timer->irqnr) {
> +		timer->clkevt.name	= timer->clockevent_name;
> +		timer->clkevt.set_next_event = zevio_timer_set_event;
> +		timer->clkevt.set_mode	= zevio_timer_set_mode;
> +		timer->clkevt.rating	= 200;
> +		timer->clkevt.cpumask	= cpu_all_mask;
> +		timer->clkevt.features	=
> +			CLOCK_EVT_FEAT_ONESHOT;

		timer->clkevt.irq       = timer->irqnr;

> +
> +		writel(CNTL_STOP_TIMER, timer->timer1 + IO_CONTROL);
> +		writel(0, timer->timer1 + IO_DIVIDER);
> +

[ ... ]

Thanks
  -- Daniel



-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

