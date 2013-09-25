Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752399Ab3IYXQR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 19:16:17 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:45752 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825Ab3IYXQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 19:16:16 -0400
Message-ID: <52436EBE.9010002@codeaurora.org>
Date: Wed, 25 Sep 2013 16:16:14 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Maxime Ripard <maxime.ripard@free-electrons.com>
CC: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Emilio Lopez <emilio@elopez.com.ar>, linux-kernel@vger.kernel.org,
        kevin.z.m.zh@gmail.com, sunny@allwinnertech.com,
        shuge@allwinnertech.com, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/5] clocksource: Add Allwinner SoCs HS timers driver
References: <1380117790-19390-1-git-send-email-maxime.ripard@free-electrons.com> <1380117790-19390-3-git-send-email-maxime.ripard@free-electrons.com>
In-Reply-To: <1380117790-19390-3-git-send-email-maxime.ripard@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/25/13 07:03, Maxime Ripard wrote:
> diff --git a/Documentation/devicetree/bindings/timer/allwinner,sun5i-a13-hstimer.txt b/Documentation/devicetree/bindings/timer/allwinner,sun5i-a13-hstimer.txt
> new file mode 100644
> index 0000000..b1f81e9
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/timer/allwinner,sun5i-a13-hstimer.txt
> @@ -0,0 +1,22 @@
> +Allwinner SoCs High Speed Timer Controller
> +
> +Required properties:
> +
> +- compatible :	should be "allwinner,sun5i-a13-hstimer" or
> +		"allwinner,sun7i-a20-hstimer"
> +- reg : Specifies base physical address and size of the registers.
> +- interrupts :	The interrupts of these timers (2 for the sun5i IP, 4 for the sun7i
> +		one)
> +- clocks: phandle to the source clock (usually the AHB clock)
> +
> +Example:
> +
> +hstimer@01c60000 {

This should just be 'timer@1c60000'

> +	compatible = "allwinner,sun7i-a20-hstimer";
> +        reg = <0x01c60000 0x1000>;
> +        interrupts = <0 51 1>,
> +                     <0 52 1>,
> +                     <0 53 1>,
> +                     <0 54 1>;
> +        clocks = <&ahb1_gates 19>;
> +};

Weird mix of tabs and spaces here.

> +
> +static void __iomem *timer_base;
> +static u32 ticks_per_jiffy;
> +
> +/*
> + * When we disable a timer, we need to wait at least for 2 cycles of
> + * the timer source clock. We will use for that the clocksource timer
> + * that is already setup and runs at the same frequency than the other
> + * timers, and we never will be disabled.
> + */
> +static void sun5i_clkevt_sync(void)
> +{
> +	u32 old = readl(timer_base + TIMER_CNTVAL_LO_REG(1));
> +
> +	while ((old - readl(timer_base + TIMER_CNTVAL_LO_REG(1))) < 3)
> +		cpu_relax();
> +}
> +
[...]
> +
> +static int sun5i_clkevt_next_event(unsigned long evt,
> +				   struct clock_event_device *unused)
> +{
> +	sun5i_clkevt_time_stop(0);
> +	sun5i_clkevt_time_setup(0, evt);
> +	sun5i_clkevt_time_start(0, false);

I suppose the min delta wants to be 3 instead of 1 because if we program
an evt one tick in the future first we'll wait for two ticks (or is that
three?) while we stop the timer and then program the timer to fire one
tick after that. Perhaps we should subtract two ticks from the evt as
well when we program it here?

> +
> +	return 0;
> +}
> +
> +static struct clock_event_device sun5i_clockevent = {
> +	.name = "sun5i_tick",
> +	.rating = 350,
> +	.features = CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT,
> +	.set_mode = sun5i_clkevt_mode,
> +	.set_next_event = sun5i_clkevt_next_event,
> +};
> +
> +
> +static irqreturn_t sun5i_timer_interrupt(int irq, void *dev_id)
> +{
> +	struct clock_event_device *evt = (struct clock_event_device *)dev_id;
> +
> +	writel(0x1, timer_base + TIMER_IRQ_ST_REG);
> +	evt->event_handler(evt);
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static struct irqaction sun5i_timer_irq = {
> +	.name = "sun5i_timer0",
> +	.flags = IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,

IRQF_DISABLED is a no-op and can be dropped.

> +
> +static u32 sun5i_timer_sched_read(void)
> +{
> +	return ~readl(timer_base + TIMER_CNTVAL_LO_REG(1));
> +}
> +
> +static void __init sun5i_timer_init(struct device_node *node)
> +{
[...]
> +
> +	sun5i_clockevent.cpumask = cpumask_of(0);

Can this timer interrupt any CPU or is it hardwired to CPU0? If the
interrupt can go to any CPU this should be cpu_possible_mask instead.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

