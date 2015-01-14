Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753559AbbANPvY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 10:51:24 -0500
Received: from mail.kernel.org ([198.145.29.136]:47202 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750939AbbANPvW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 10:51:22 -0500
Message-ID: <54B69072.4080607@kernel.org>
Date: Thu, 15 Jan 2015 00:51:14 +0900
From: Kukjin Kim <kgene@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.16
MIME-Version: 1.0
To: Chanwoo Choi <cw00.choi@samsung.com>
CC: daniel.lezcano@linaro.org, tglx@linutronix.de, kgene@kernel.org,
        inki.dae@samsung.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Doug Anderson <dianders@chromium.org>,
        "'Olof Johansson'" <olof@lixom.net>
Subject: Re: [RESEND PATCH v3] clocksource: exynos_mct: Add the support for
 Exynos 64bit SoC
References: <1421213603-5020-1-git-send-email-cw00.choi@samsung.com>
In-Reply-To: <1421213603-5020-1-git-send-email-cw00.choi@samsung.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/15 14:33, Chanwoo Choi wrote:

Hi,

+ Doug, Olof

> This patch adds the support for Exynos 64bit SoC. The delay_timer is only used
> for Exynos 32bit SoC.
> 
Yes, the Exynos MCT(Multi-Core Timer) is 64bit timer and it is available
on 64bit exynos SoC such as exynos7. But basically ARMv8 architecture is
including ARM ARCH timer (ARM Generic Timer) and exynos7 also has
implemented it and additionally its access is faster than using memory
mapped register called SFR for MCT...so Doug submitted patch to use MCT
on 32bit exynos SoCs before.

I know using MCT on 64bit exynos is usefulness for Power Management and
I need to talk to relevant guys in office again. If anything, I'll let
you know.

Thanks,
Kukjin

> Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Kukjin Kim <kgene.kim@samsung.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> ---
> This patch set is tested on 64-bit Exynos SoC. I send only this patch from
> following patchst[1].
> [1] https://lkml.org/lkml/2014/12/2/134
> 
> Changes from v2:
> - None
> Changes from v1:
> - Use CONFIG_ARM instead of CONFIG_ARM64
> 
>  drivers/clocksource/Kconfig      | 1 -
>  drivers/clocksource/exynos_mct.c | 4 ++++
>  2 files changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/clocksource/Kconfig b/drivers/clocksource/Kconfig
> index fc01ec2..be38119 100644
> --- a/drivers/clocksource/Kconfig
> +++ b/drivers/clocksource/Kconfig
> @@ -135,7 +135,6 @@ config CLKSRC_METAG_GENERIC
>  
>  config CLKSRC_EXYNOS_MCT
>  	def_bool y if ARCH_EXYNOS
> -	depends on !ARM64
>  	help
>  	  Support for Multi Core Timer controller on Exynos SoCs.
>  
> diff --git a/drivers/clocksource/exynos_mct.c b/drivers/clocksource/exynos_mct.c
> index 9403061..b840ea1 100644
> --- a/drivers/clocksource/exynos_mct.c
> +++ b/drivers/clocksource/exynos_mct.c
> @@ -223,6 +223,7 @@ static u64 notrace exynos4_read_sched_clock(void)
>  	return exynos4_read_count_32();
>  }
>  
> +#if defined(CONFIG_ARM)
>  static struct delay_timer exynos4_delay_timer;
>  
>  static cycles_t exynos4_read_current_timer(void)
> @@ -231,14 +232,17 @@ static cycles_t exynos4_read_current_timer(void)
>  			 "cycles_t needs to move to 32-bit for ARM64 usage");
>  	return exynos4_read_count_32();
>  }
> +#endif
>  
>  static void __init exynos4_clocksource_init(void)
>  {
>  	exynos4_mct_frc_start();
>  
> +#if defined(CONFIG_ARM)
>  	exynos4_delay_timer.read_current_timer = &exynos4_read_current_timer;
>  	exynos4_delay_timer.freq = clk_rate;
>  	register_current_timer_delay(&exynos4_delay_timer);
> +#endif
>  
>  	if (clocksource_register_hz(&mct_frc, clk_rate))
>  		panic("%s: can't register clocksource\n", mct_frc.name);
