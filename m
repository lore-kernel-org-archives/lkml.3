Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754741AbbAZLW0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 06:22:26 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:64134 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754643AbbAZLWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 06:22:22 -0500
Message-ID: <54C62368.7050600@linaro.org>
Date: Mon, 26 Jan 2015 12:22:16 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 5/5] clocksource: sun5i: Add clock notifiers
References: <1422265856-27631-1-git-send-email-maxime.ripard@free-electrons.com> <1422265856-27631-6-git-send-email-maxime.ripard@free-electrons.com>
In-Reply-To: <1422265856-27631-6-git-send-email-maxime.ripard@free-electrons.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/26/2015 10:50 AM, Maxime Ripard wrote:
> The parent clock of the sun5i timer is the AHB clock, which rate might change
> because of other devices requirements.
>
> This is for example the case on the Allwinner A31, where the DMA controller
> needs a minimum rate higher than the default, that is enforced after the timer
> driver has probed.
>
> Add clock notifiers to make sure we reflect the clock rate changes in the timer
> rates.

Mmh, I am wondering if that shouldn't go to the time framework ...

Looking at the notifier callbacks that call generic time framework 
functions.

Can you have a look at commit b3e90722 ? and double check your changes ?

A couple of comments below.

> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> ---
>   drivers/clocksource/timer-sun5i.c | 72 +++++++++++++++++++++++++++++++++++++--
>   1 file changed, 70 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/clocksource/timer-sun5i.c b/drivers/clocksource/timer-sun5i.c
> index 377e50450781..5841a956f5f0 100644
> --- a/drivers/clocksource/timer-sun5i.c
> +++ b/drivers/clocksource/timer-sun5i.c
> @@ -41,9 +41,13 @@
>   struct sun5i_timer {
>   	void __iomem		*base;
>   	struct clk		*clk;
> +	struct notifier_block	clk_rate_cb;
>   	u32			ticks_per_jiffy;
>   };
>
> +#define to_sun5i_timer(x) \
> +	container_of(x, struct sun5i_timer, clk_rate_cb)
> +
>   struct sun5i_timer_clksrc {
>   	struct sun5i_timer	timer;
>   	struct clocksource	clksrc;
> @@ -152,6 +156,30 @@ static cycle_t sun5i_clksrc_read(struct clocksource *clksrc)
>   	return ~readl(cs->timer.base + TIMER_CNTVAL_LO_REG(1));
>   }
>
> +static int sun5i_rate_cb_clksrc(struct notifier_block *nb,
> +				unsigned long event, void *data)
> +{
> +	struct clk_notifier_data *ndata = data;
> +	struct sun5i_timer *timer = to_sun5i_timer(nb);
> +	struct sun5i_timer_clksrc *cs = container_of(timer,
> +						     struct sun5i_timer_clksrc, timer);
> +
> +	switch (event) {
> +	case PRE_RATE_CHANGE:
> +		clocksource_unregister(&cs->clksrc);
> +		break;
> +
> +	case POST_RATE_CHANGE:
> +		clocksource_register_hz(&cs->clksrc, ndata->new_rate);
> +		break;

Why clocksource_unregister couldn't be in the POST_RATE_CHANGE ?

> +	default:
> +		break;
> +	}
> +
> +	return NOTIFY_DONE;
> +}
> +
>   static int __init sun5i_setup_clocksource(struct device_node *node,
>   					  void __iomem *base,
>   					  struct clk *clk, int irq)
> @@ -174,6 +202,14 @@ static int __init sun5i_setup_clocksource(struct device_node *node,
>
>   	cs->timer.base = base;
>   	cs->timer.clk = clk;
> +	cs->timer.clk_rate_cb.notifier_call = sun5i_rate_cb_clksrc;
> +	cs->timer.clk_rate_cb.next = NULL;
> +
> +	ret = clk_notifier_register(clk, &cs->timer.clk_rate_cb);
> +	if (ret) {
> +		pr_err("Unable to register clock notifier.\n");
> +		goto err_disable_clk;
> +	}
>
>   	writel(~0, base + TIMER_INTVAL_LO_REG(1));
>   	writel(TIMER_CTL_ENABLE | TIMER_CTL_RELOAD,
> @@ -188,11 +224,13 @@ static int __init sun5i_setup_clocksource(struct device_node *node,
>   	ret = clocksource_register_hz(&cs->clksrc, rate);
>   	if (ret) {
>   		pr_err("Couldn't register clock source.\n");
> -		goto err_disable_clk;
> +		goto err_remove_notifier;
>   	}
>
>   	return 0;
>
> +err_remove_notifier:
> +	clk_notifier_unregister(clk, &cs->timer.clk_rate_cb);
>   err_disable_clk:
>   	clk_disable_unprepare(clk);
>   err_free:
> @@ -200,6 +238,26 @@ err_free:
>   	return ret;
>   }
>
> +static int sun5i_rate_cb_clkevt(struct notifier_block *nb,
> +				unsigned long event, void *data)
> +{
> +	struct clk_notifier_data *ndata = data;
> +	struct sun5i_timer *timer = to_sun5i_timer(nb);
> +	struct sun5i_timer_clkevt *ce = container_of(timer,
> +						     struct sun5i_timer_clkevt, timer);
> +	unsigned long flags;
> +
> +	if (event == POST_RATE_CHANGE) {
> +		local_irq_save(flags);
> +		clockevents_update_freq(&ce->clkevt, ndata->new_rate);
> +		local_irq_restore(flags);

local_irq_save and local_irq_restore are already in the 
clockevents_update_freq function.

> +		ce->timer.ticks_per_jiffy = DIV_ROUND_UP(ndata->new_rate, HZ);
> +	}
> +
> +	return NOTIFY_DONE;
> +}
> +
>   static int __init sun5i_setup_clockevent(struct device_node *node, void __iomem *base,
>   					 struct clk *clk, int irq)
>   {
> @@ -223,6 +281,14 @@ static int __init sun5i_setup_clockevent(struct device_node *node, void __iomem
>   	ce->timer.base = base;
>   	ce->timer.ticks_per_jiffy = DIV_ROUND_UP(rate, HZ);
>   	ce->timer.clk = clk;
> +	ce->timer.clk_rate_cb.notifier_call = sun5i_rate_cb_clkevt;
> +	ce->timer.clk_rate_cb.next = NULL;
> +
> +	ret = clk_notifier_register(clk, &ce->timer.clk_rate_cb);
> +	if (ret) {
> +		pr_err("Unable to register clock notifier.\n");
> +		goto err_disable_clk;
> +	}
>
>   	ce->clkevt.name = node->name;
>   	ce->clkevt.features = CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT;
> @@ -240,7 +306,7 @@ static int __init sun5i_setup_clockevent(struct device_node *node, void __iomem
>   			  "sun5i_timer0", ce);
>   	if (ret) {
>   		pr_err("Unable to register interrupt\n");
> -		goto err_disable_clk;
> +		goto err_remove_notifier;
>   	}
>
>   	clockevents_config_and_register(&ce->clkevt, rate,
> @@ -248,6 +314,8 @@ static int __init sun5i_setup_clockevent(struct device_node *node, void __iomem
>
>   	return 0;
>
> +err_remove_notifier:
> +	clk_notifier_unregister(clk, &ce->timer.clk_rate_cb);
>   err_disable_clk:
>   	clk_disable_unprepare(clk);
>   err_free:
>


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

