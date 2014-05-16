Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756108AbaEPNAx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 09:00:53 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:40499 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754167AbaEPNAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 09:00:51 -0400
Message-ID: <53760C0C.4070002@linaro.org>
Date: Fri, 16 May 2014 15:01:00 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Xiubo Li <Li.Xiubo@freescale.com>, tglx@linutronix.de,
        shawn.guo@linaro.org
CC: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        devicetree@vger.kernel.org, Jingchang Lu <b35083@freescale.com>
Subject: Re: [PATCHv3 3/3] clocksource: Add Freescale FlexTimer Module (FTM)
 timer support
References: <1398737939-5334-1-git-send-email-Li.Xiubo@freescale.com> <1398737939-5334-4-git-send-email-Li.Xiubo@freescale.com>
In-Reply-To: <1398737939-5334-4-git-send-email-Li.Xiubo@freescale.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/29/2014 04:18 AM, Xiubo Li wrote:
> The Freescale FlexTimer Module time reference is a 16-bit counter
> that can be used as an unsigned or signed increase counter.
>
> CNTIN defines the starting value of the count and MOD defines the
> final value of the count. The value of CNTIN is loaded into the FTM
> counter, and the counter increments until the value of MOD is reached,
> at which point the counter is reloaded with the value of CNTIN. That's
> also when an overflow interrupt will be generated.
>
> Here using the 'evt' prefix or postfix as clock event device and
> the 'src' as clock source device.
>
> Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
> Cc: Shawn Guo <shawn.guo@linaro.org>
> Cc: Jingchang Lu <b35083@freescale.com>
> ---
>   drivers/clocksource/Kconfig         |   5 +
>   drivers/clocksource/Makefile        |   1 +
>   drivers/clocksource/fsl_ftm_timer.c | 344 ++++++++++++++++++++++++++++++++++++
>   3 files changed, 350 insertions(+)
>   create mode 100644 drivers/clocksource/fsl_ftm_timer.c
>
> diff --git a/drivers/clocksource/Kconfig b/drivers/clocksource/Kconfig
> index cd6950f..28321c5 100644
> --- a/drivers/clocksource/Kconfig
> +++ b/drivers/clocksource/Kconfig
> @@ -136,6 +136,11 @@ config CLKSRC_SAMSUNG_PWM
>   	  for all devicetree enabled platforms. This driver will be
>   	  needed only on systems that do not have the Exynos MCT available.
>
> +config FSL_FTM_TIMER
> +	bool
> +	help
> +	  Support for Freescale FlexTimer Module (FTM) timer.
> +
>   config VF_PIT_TIMER
>   	bool
>   	help
> diff --git a/drivers/clocksource/Makefile b/drivers/clocksource/Makefile
> index c7ca50a..ce0a967 100644
> --- a/drivers/clocksource/Makefile
> +++ b/drivers/clocksource/Makefile
> @@ -31,6 +31,7 @@ obj-$(CONFIG_CADENCE_TTC_TIMER)	+= cadence_ttc_timer.o
>   obj-$(CONFIG_CLKSRC_EFM32)	+= time-efm32.o
>   obj-$(CONFIG_CLKSRC_EXYNOS_MCT)	+= exynos_mct.o
>   obj-$(CONFIG_CLKSRC_SAMSUNG_PWM)	+= samsung_pwm_timer.o
> +obj-$(CONFIG_FSL_FTM_TIMER)	+= fsl_ftm_timer.o
>   obj-$(CONFIG_VF_PIT_TIMER)	+= vf_pit_timer.o
>
>   obj-$(CONFIG_ARM_ARCH_TIMER)		+= arm_arch_timer.o
> diff --git a/drivers/clocksource/fsl_ftm_timer.c b/drivers/clocksource/fsl_ftm_timer.c
> new file mode 100644
> index 0000000..7f6246a
> --- /dev/null
> +++ b/drivers/clocksource/fsl_ftm_timer.c
> @@ -0,0 +1,344 @@
> +/*
> + * Freescale FlexTimer Module (FTM) timer driver.
> + *
> + * Copyright 2014 Freescale Semiconductor, Inc.
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * as published by the Free Software Foundation; either version 2
> + * of the License, or (at your option) any later version.
> + */
> +
> +#include <linux/clk.h>
> +#include <linux/clockchips.h>
> +#include <linux/clocksource.h>
> +#include <linux/err.h>
> +#include <linux/interrupt.h>
> +#include <linux/io.h>
> +#include <linux/of_address.h>
> +#include <linux/of_irq.h>
> +#include <linux/sched_clock.h>
> +
> +#define FTM_SC		0x00
> +#define FTM_SC_CLK_SHIFT	3
> +#define FTM_SC_CLK_MASK	(0x3 << FTM_SC_CLK_SHIFT)
> +#define FTM_SC_CLK(c)	((c) << FTM_SC_CLK_SHIFT)
> +#define FTM_SC_PS_MASK	0x7
> +#define FTM_SC_TOIE	BIT(6)
> +#define FTM_SC_TOF	BIT(7)
> +
> +#define FTM_CNT		0x04
> +#define FTM_MOD		0x08
> +#define FTM_CNTIN	0x4C
> +
> +static void __iomem *clksrc_base;
> +static void __iomem *clkevt_base;
> +static unsigned long peroidic_cyc;

peroidic_cyc ? Did you mean periodic_cyc ? :)



-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

