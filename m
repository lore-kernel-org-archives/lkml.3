Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755939AbbAHOWG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 09:22:06 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:46668 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754164AbbAHOWC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 09:22:02 -0500
Message-ID: <54AE9286.1090800@linaro.org>
Date: Thu, 08 Jan 2015 15:21:58 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Paul Walmsley <paul@pwsan.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
CC: linux-tegra@vger.kernel.org, Allen Martin <amartin@nvidia.com>,
        Stephen Warren <swarren@nvidia.com>,
        Thierry Reding <treding@nvidia.com>,
        Alexandre Courbot <gnurou@gmail.com>
Subject: Re: [PATCH] clocksource: tegra: wrap arch/arm-specific sections in
 CONFIG_ARM
References: <alpine.DEB.2.02.1412092201200.31750@utopia.booyaka.com>
In-Reply-To: <alpine.DEB.2.02.1412092201200.31750@utopia.booyaka.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/2014 11:07 PM, Paul Walmsley wrote:
>
> Like several of the other files in drivers/clocksource,
> tegra20_timer.c contains code that can only compile when CONFIG_ARM is
> enabled.  This causes obvious problems when trying to compile this
> code for NVIDIA ARM64-based SoCs, such as Tegra132.  The same timer IP
> blocks exist, so it seems appropriate to provide support for them.
>
> So until we figure out a better way to partition this code, wrap the
> delay_timer and persistent_clock support code with preprocessor tests
> for CONFIG_ARM.  (The delay_timer code should not be needed at all on
> ARM64 due to the presence of the ARMv8 architected timer.  The
> persistent_clock support code could become important once power
> management modes are implemented that turn off the CPU complex.)

Well actually putting #ifdef macros in the C code should be avoided if 
possible.

May be you can replace those macros by:

if (IS_ENABLED(CONFIG_ARM64)) {
	...
}

?



> Signed-off-by: Paul Walmsley <paul@pwsan.com>
> Signed-off-by: Paul Walmsley <pwalmsley@nvidia.com>
> Cc: Allen Martin <amartin@nvidia.com>
> Cc: Stephen Warren <swarren@nvidia.com>
> Cc: Thierry Reding <treding@nvidia.com>
> Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Alexandre Courbot <gnurou@gmail.com>
> ---
> Applies against next-20141209.
> Intended for v3.20.
> Boot-tested on Tegra124 Jetson TK1 on next-20141209.
> Also boot-tested on Tegra132 Norrin FFD on next-20141209 + extra,
> unrelated patches.
>
>   drivers/clocksource/tegra20_timer.c | 11 +++++++++++
>   1 file changed, 11 insertions(+)
>
> diff --git a/drivers/clocksource/tegra20_timer.c b/drivers/clocksource/tegra20_timer.c
> index d2616ef16770..83a8f5c9e139 100644
> --- a/drivers/clocksource/tegra20_timer.c
> +++ b/drivers/clocksource/tegra20_timer.c
> @@ -29,8 +29,10 @@
>   #include <linux/sched_clock.h>
>   #include <linux/delay.h>
>
> +#ifdef CONFIG_ARM
>   #include <asm/mach/time.h>
>   #include <asm/smp_twd.h>
> +#endif
>
>   #define RTC_SECONDS            0x08
>   #define RTC_SHADOW_SECONDS     0x0c
> @@ -49,12 +51,14 @@
>   #define TIMER_PCR 0x4
>
>   static void __iomem *timer_reg_base;
> +#ifdef CONFIG_ARM
>   static void __iomem *rtc_base;
>
>   static struct timespec persistent_ts;
>   static u64 persistent_ms, last_persistent_ms;
>
>   static struct delay_timer tegra_delay_timer;
> +#endif
>
>   #define timer_writel(value, reg) \
>   	__raw_writel(value, timer_reg_base + (reg))
> @@ -106,6 +110,7 @@ static u64 notrace tegra_read_sched_clock(void)
>   	return timer_readl(TIMERUS_CNTR_1US);
>   }
>
> +#ifdef CONFIG_ARM
>   /*
>    * tegra_rtc_read - Reads the Tegra RTC registers
>    * Care must be taken that this funciton is not called while the
> @@ -146,6 +151,8 @@ static unsigned long tegra_delay_timer_read_counter_long(void)
>   {
>   	return readl(timer_reg_base + TIMERUS_CNTR_1US);
>   }
> +#endif /* CONFIG_ARM */
> +
>
>   static irqreturn_t tegra_timer_interrupt(int irq, void *dev_id)
>   {
> @@ -214,10 +221,12 @@ static void __init tegra20_init_timer(struct device_node *np)
>   		BUG();
>   	}
>
> +#ifdef CONFIG_ARM
>   	tegra_delay_timer.read_current_timer =
>   			tegra_delay_timer_read_counter_long;
>   	tegra_delay_timer.freq = 1000000;
>   	register_current_timer_delay(&tegra_delay_timer);
> +#endif
>
>   	ret = setup_irq(tegra_timer_irq.irq, &tegra_timer_irq);
>   	if (ret) {
> @@ -232,6 +241,7 @@ static void __init tegra20_init_timer(struct device_node *np)
>   }
>   CLOCKSOURCE_OF_DECLARE(tegra20_timer, "nvidia,tegra20-timer", tegra20_init_timer);
>
> +#ifdef CONFIG_ARM
>   static void __init tegra20_init_rtc(struct device_node *np)
>   {
>   	struct clk *clk;
> @@ -255,6 +265,7 @@ static void __init tegra20_init_rtc(struct device_node *np)
>   	register_persistent_clock(NULL, tegra_read_persistent_clock);
>   }
>   CLOCKSOURCE_OF_DECLARE(tegra20_rtc, "nvidia,tegra20-rtc", tegra20_init_rtc);
> +#endif /* CONFIG_ARM */
>
>   #ifdef CONFIG_PM
>   static u32 usec_config;
>


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

