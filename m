Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751989AbaBDHy6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 02:54:58 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:37938 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751234AbaBDHyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 02:54:52 -0500
Message-ID: <52F09CC8.80601@linaro.org>
Date: Tue, 04 Feb 2014 08:54:48 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Andrew Chew <achew@nvidia.com>, tglx@linutronix.de, swarren@wwwdotorg.org,
        thierry.reding@gmail.com, rob@landley.net, grant.likely@linaro.org,
        robh+dt@kernel.org, abrestic@chromium.org, dgreid@chromium.org,
        katierh@chromium.org
CC: linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-watchdog@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH v2 2/3] clocksource: tegra: Define timer bases in header
 file
References: <1391473055-3158-1-git-send-email-achew@nvidia.com> <1391473055-3158-3-git-send-email-achew@nvidia.com>
In-Reply-To: <1391473055-3158-3-git-send-email-achew@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/04/2014 01:17 AM, Andrew Chew wrote:
> Added timers that are present in tegra30 and later, that are NOT in tegra20.
>
> Also, some of these timer bases are needed in the tegra watchdog driver, so
> separate them out into a header file that both the clocksource driver and
> the watchdog driver can share them.
>
> Signed-off-by: Andrew Chew <achew@nvidia.com>

When reading the patch 3/3, I don't see any define reused from this 
header except TEGRA30_TIMER_WDT_BASE which is only used for the 
watchdog. May be I missed something but I don't see any definition 
shared and thus I don't see the point of creating this header file.

> ---
>   drivers/clocksource/tegra20_timer.c | 15 ++++++-------
>   include/clocksource/tegra_timer.h   | 43 +++++++++++++++++++++++++++++++++++++
>   2 files changed, 49 insertions(+), 9 deletions(-)
>   create mode 100644 include/clocksource/tegra_timer.h
>
> diff --git a/drivers/clocksource/tegra20_timer.c b/drivers/clocksource/tegra20_timer.c
> index 73cfa56..2c49643 100644
> --- a/drivers/clocksource/tegra20_timer.c
> +++ b/drivers/clocksource/tegra20_timer.c
> @@ -28,6 +28,8 @@
>   #include <linux/of_irq.h>
>   #include <linux/sched_clock.h>
>
> +#include <clocksource/tegra_timer.h>
> +
>   #include <asm/mach/time.h>
>   #include <asm/smp_twd.h>
>
> @@ -39,11 +41,6 @@
>   #define TIMERUS_USEC_CFG 0x14
>   #define TIMERUS_CNTR_FREEZE 0x4c
>
> -#define TIMER1_BASE 0x0
> -#define TIMER2_BASE 0x8
> -#define TIMER3_BASE 0x50
> -#define TIMER4_BASE 0x58
> -
>   #define TIMER_PTV 0x0
>   #define TIMER_PCR 0x4
>
> @@ -64,7 +61,7 @@ static int tegra_timer_set_next_event(unsigned long cycles,
>   	u32 reg;
>
>   	reg = 0x80000000 | ((cycles > 1) ? (cycles-1) : 0);
> -	timer_writel(reg, TIMER3_BASE + TIMER_PTV);
> +	timer_writel(reg, TEGRA20_TIMER3_BASE + TIMER_PTV);
>
>   	return 0;
>   }
> @@ -74,12 +71,12 @@ static void tegra_timer_set_mode(enum clock_event_mode mode,
>   {
>   	u32 reg;
>
> -	timer_writel(0, TIMER3_BASE + TIMER_PTV);
> +	timer_writel(0, TEGRA20_TIMER3_BASE + TIMER_PTV);
>
>   	switch (mode) {
>   	case CLOCK_EVT_MODE_PERIODIC:
>   		reg = 0xC0000000 | ((1000000/HZ)-1);
> -		timer_writel(reg, TIMER3_BASE + TIMER_PTV);
> +		timer_writel(reg, TEGRA20_TIMER3_BASE + TIMER_PTV);
>   		break;
>   	case CLOCK_EVT_MODE_ONESHOT:
>   		break;
> @@ -142,7 +139,7 @@ static void tegra_read_persistent_clock(struct timespec *ts)
>   static irqreturn_t tegra_timer_interrupt(int irq, void *dev_id)
>   {
>   	struct clock_event_device *evt = (struct clock_event_device *)dev_id;
> -	timer_writel(1<<30, TIMER3_BASE + TIMER_PCR);
> +	timer_writel(1<<30, TEGRA20_TIMER3_BASE + TIMER_PCR);
>   	evt->event_handler(evt);
>   	return IRQ_HANDLED;
>   }
> diff --git a/include/clocksource/tegra_timer.h b/include/clocksource/tegra_timer.h
> new file mode 100644
> index 0000000..ea0bc8b
> --- /dev/null
> +++ b/include/clocksource/tegra_timer.h
> @@ -0,0 +1,43 @@
> +/*
> + * Copyright (C) 2010 Google, Inc.
> + *
> + * Author:
> + *	Colin Cross <ccross@google.com>

          ^^^^^^^^^^^^^^^^^^
> + *
> + * This software is licensed under the terms of the GNU General Public
> + * License version 2, as published by the Free Software Foundation, and
> + * may be copied, distributed, and modified under those terms.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + */
> +
> +#ifndef __CLOCKSOURCE_TEGRA_TIMER_H
> +#define __CLOCKSOURCE_TEGRA_TIMER_H
> +
> +/* Tegra 20 timers */
> +#define TEGRA20_TIMER1_BASE	0x0
> +#define TEGRA20_TIMER2_BASE	0x8
> +#define TEGRA20_TIMER3_BASE	0x50
> +#define TEGRA20_TIMER4_BASE	0x58
> +
> +/* Tegra 30 timers */
> +#define TEGRA30_TIMER1_BASE	TEGRA20_TIMER1_BASE
> +#define TEGRA30_TIMER2_BASE	TEGRA20_TIMER2_BASE
> +#define TEGRA30_TIMER3_BASE	TEGRA20_TIMER3_BASE
> +#define TEGRA30_TIMER4_BASE	TEGRA20_TIMER4_BASE
> +#define TEGRA30_TIMER5_BASE	0x60
> +#define TEGRA30_TIMER6_BASE	0x68
> +#define TEGRA30_TIMER7_BASE	0x70
> +#define TEGRA30_TIMER8_BASE	0x78
> +#define TEGRA30_TIMER9_BASE	0x80
> +#define TEGRA30_TIMER0_BASE	0x88
> +
> +/* Used by the tegra watchdog timer */
> +#define TEGRA30_TIMER_WDT_BASE	TEGRA30_TIMER5_BASE
> +#define TEGRA30_TIMER_WDT_ID	5
> +
> +#endif /* __CLOCKSOURCE_TEGRA_TIMER_H */
>


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

