Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752935AbaKQVMK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 16:12:10 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:63185 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751966AbaKQVMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 16:12:08 -0500
Message-ID: <546A64A4.7060705@linaro.org>
Date: Mon, 17 Nov 2014 22:12:04 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Gregory Clement <gregory.clement@free-electrons.com>
CC: linux-arm-kernel@lists.infradead.org, Tawfik Bayouk <tawfik@marvell.com>,
        Nadav Haklai <nadavh@marvell.com>, Lior Amsalem <alior@marvell.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        devicetree@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 04/16] clocksource: time-armada-370-xp: add suspend/resume
 support
References: <1415978496-9334-1-git-send-email-thomas.petazzoni@free-electrons.com> <1415978496-9334-5-git-send-email-thomas.petazzoni@free-electrons.com>
In-Reply-To: <1415978496-9334-5-git-send-email-thomas.petazzoni@free-electrons.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/14/2014 04:21 PM, Thomas Petazzoni wrote:
> This commit adds a set of suspend/resume syscore_ops to respectively
> save and restore a number of timer registers, in order to make sure
> the clockevent and clocksource devices continue to work properly
> across a suspend/resume cycle.
>
> Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
> Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: linux-kernel@vger.kernel.org

Acked-by: Daniel Lezcano <daniel.lezcano@linaro.org>


> ---
>   drivers/clocksource/time-armada-370-xp.c | 25 +++++++++++++++++++++++++
>   1 file changed, 25 insertions(+)
>
> diff --git a/drivers/clocksource/time-armada-370-xp.c b/drivers/clocksource/time-armada-370-xp.c
> index 0451e62..ff37d3a 100644
> --- a/drivers/clocksource/time-armada-370-xp.c
> +++ b/drivers/clocksource/time-armada-370-xp.c
> @@ -43,6 +43,7 @@
>   #include <linux/module.h>
>   #include <linux/sched_clock.h>
>   #include <linux/percpu.h>
> +#include <linux/syscore_ops.h>
>
>   /*
>    * Timer block registers.
> @@ -223,6 +224,28 @@ static struct notifier_block armada_370_xp_timer_cpu_nb = {
>   	.notifier_call = armada_370_xp_timer_cpu_notify,
>   };
>
> +static u32 timer0_ctrl_reg, timer0_local_ctrl_reg;
> +
> +static int armada_370_xp_timer_suspend(void)
> +{
> +	timer0_ctrl_reg = readl(timer_base + TIMER_CTRL_OFF);
> +	timer0_local_ctrl_reg = readl(local_base + TIMER_CTRL_OFF);
> +	return 0;
> +}
> +
> +static void armada_370_xp_timer_resume(void)
> +{
> +	writel(0xffffffff, timer_base + TIMER0_VAL_OFF);
> +	writel(0xffffffff, timer_base + TIMER0_RELOAD_OFF);
> +	writel(timer0_ctrl_reg, timer_base + TIMER_CTRL_OFF);
> +	writel(timer0_local_ctrl_reg, local_base + TIMER_CTRL_OFF);
> +}
> +
> +struct syscore_ops armada_370_xp_timer_syscore_ops = {
> +	.suspend	= armada_370_xp_timer_suspend,
> +	.resume		= armada_370_xp_timer_resume,
> +};
> +
>   static void __init armada_370_xp_timer_common_init(struct device_node *np)
>   {
>   	u32 clr = 0, set = 0;
> @@ -285,6 +308,8 @@ static void __init armada_370_xp_timer_common_init(struct device_node *np)
>   	/* Immediately configure the timer on the boot CPU */
>   	if (!res)
>   		armada_370_xp_timer_setup(this_cpu_ptr(armada_370_xp_evt));
> +
> +	register_syscore_ops(&armada_370_xp_timer_syscore_ops);
>   }
>
>   static void __init armada_xp_timer_init(struct device_node *np)
>


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

