Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758534Ab3KOLK7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 06:10:59 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:36575 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757286Ab3KOLKv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 06:10:51 -0500
Message-ID: <52860135.3030409@atmel.com>
Date: Fri, 15 Nov 2013 12:10:45 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Johan Hovold <jhovold@gmail.com>
CC: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Andrew Victor <linux@maxim.org.za>,
        Alessandro Zummo <a.zummo@towertech.it>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <rtc-linux@googlegroups.com>
Subject: Re: [PATCH v3 2/3] ARM: at91: fix hanged boot due to early rtt-interrupt
References: <1363025279-17615-1-git-send-email-jhovold@gmail.com> <1381917376-21107-1-git-send-email-jhovold@gmail.com> <1381917376-21107-3-git-send-email-jhovold@gmail.com>
In-Reply-To: <1381917376-21107-3-git-send-email-jhovold@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/10/2013 11:56, Johan Hovold :
> Make sure the RTT-interrupts are masked at boot by adding a new helper
> function to be used at SOC-init.
>
> This fixes hanged boot on all AT91 SOCs with an RTT, for example, if an
> RTT-alarm goes off after a non-clean shutdown (e.g. when using RTC
> wakeup).
>
> The RTC and RTT-peripherals are powered by backup power (VDDBU) (on all
> AT91 SOCs but RM9200) and are not reset on wake-up, user, watchdog or
> software reset. This means that their interrupts may be enabled during
> early boot if, for example, they where not disabled during a previous
> shutdown (e.g. due to a buggy driver or a non-clean shutdown such as a
> user reset). Furthermore, an RTC or RTT-alarm may also be active.
>
> The RTC and RTT-interrupts use the shared system-interrupt line, which
> is also used by the PIT, and if an interrupt occurs before a handler
> (e.g. RTC-driver) has been installed this leads to the system interrupt
> being disabled and prevents the system from booting.
>
> Note that when boot hangs due to an early RTC or RTT-interrupt, the only
> way to get the system to start again is to remove the backup power (e.g.
> battery) or to disable the interrupt manually from the bootloader. In
> particular, a user reset is not sufficient.
>
> Signed-off-by: Johan Hovold <jhovold@gmail.com>

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

and added to the at91-3.13-fixes-non-critical branch with the "stable" tag:
Cc: stable@vger.kernel.org # 3.11.x

Thanks for your patience, bye,

> ---
>   arch/arm/mach-at91/at91sam9260.c |  2 ++
>   arch/arm/mach-at91/at91sam9261.c |  2 ++
>   arch/arm/mach-at91/at91sam9263.c |  3 +++
>   arch/arm/mach-at91/at91sam9g45.c |  1 +
>   arch/arm/mach-at91/at91sam9rl.c  |  1 +
>   arch/arm/mach-at91/generic.h     |  1 +
>   arch/arm/mach-at91/sysirq_mask.c | 24 ++++++++++++++++++++++++
>   7 files changed, 34 insertions(+)
>
> diff --git a/arch/arm/mach-at91/at91sam9260.c b/arch/arm/mach-at91/at91sam9260.c
> index 5de6074..ae10d14 100644
> --- a/arch/arm/mach-at91/at91sam9260.c
> +++ b/arch/arm/mach-at91/at91sam9260.c
> @@ -349,6 +349,8 @@ static void __init at91sam9260_initialize(void)
>   	arm_pm_idle = at91sam9_idle;
>   	arm_pm_restart = at91sam9_alt_restart;
>
> +	at91_sysirq_mask_rtt(AT91SAM9260_BASE_RTT);
> +
>   	/* Register GPIO subsystem */
>   	at91_gpio_init(at91sam9260_gpio, 3);
>   }
> diff --git a/arch/arm/mach-at91/at91sam9261.c b/arch/arm/mach-at91/at91sam9261.c
> index 0e07932..e761e74 100644
> --- a/arch/arm/mach-at91/at91sam9261.c
> +++ b/arch/arm/mach-at91/at91sam9261.c
> @@ -291,6 +291,8 @@ static void __init at91sam9261_initialize(void)
>   	arm_pm_idle = at91sam9_idle;
>   	arm_pm_restart = at91sam9_alt_restart;
>
> +	at91_sysirq_mask_rtt(AT91SAM9261_BASE_RTT);
> +
>   	/* Register GPIO subsystem */
>   	at91_gpio_init(at91sam9261_gpio, 3);
>   }
> diff --git a/arch/arm/mach-at91/at91sam9263.c b/arch/arm/mach-at91/at91sam9263.c
> index 962768b..ad02281 100644
> --- a/arch/arm/mach-at91/at91sam9263.c
> +++ b/arch/arm/mach-at91/at91sam9263.c
> @@ -330,6 +330,9 @@ static void __init at91sam9263_initialize(void)
>   	arm_pm_idle = at91sam9_idle;
>   	arm_pm_restart = at91sam9_alt_restart;
>
> +	at91_sysirq_mask_rtt(AT91SAM9263_BASE_RTT0);
> +	at91_sysirq_mask_rtt(AT91SAM9263_BASE_RTT1);
> +
>   	/* Register GPIO subsystem */
>   	at91_gpio_init(at91sam9263_gpio, 5);
>   }
> diff --git a/arch/arm/mach-at91/at91sam9g45.c b/arch/arm/mach-at91/at91sam9g45.c
> index 8d4da6d..88e6f7b 100644
> --- a/arch/arm/mach-at91/at91sam9g45.c
> +++ b/arch/arm/mach-at91/at91sam9g45.c
> @@ -380,6 +380,7 @@ static void __init at91sam9g45_initialize(void)
>   	arm_pm_restart = at91sam9g45_restart;
>
>   	at91_sysirq_mask_rtc(AT91SAM9G45_BASE_RTC);
> +	at91_sysirq_mask_rtt(AT91SAM9G45_BASE_RTT);
>
>   	/* Register GPIO subsystem */
>   	at91_gpio_init(at91sam9g45_gpio, 5);
> diff --git a/arch/arm/mach-at91/at91sam9rl.c b/arch/arm/mach-at91/at91sam9rl.c
> index b5a8c9d..301e172 100644
> --- a/arch/arm/mach-at91/at91sam9rl.c
> +++ b/arch/arm/mach-at91/at91sam9rl.c
> @@ -295,6 +295,7 @@ static void __init at91sam9rl_initialize(void)
>   	arm_pm_restart = at91sam9_alt_restart;
>
>   	at91_sysirq_mask_rtc(AT91SAM9RL_BASE_RTC);
> +	at91_sysirq_mask_rtt(AT91SAM9RL_BASE_RTT);
>
>   	/* Register GPIO subsystem */
>   	at91_gpio_init(at91sam9rl_gpio, 4);
> diff --git a/arch/arm/mach-at91/generic.h b/arch/arm/mach-at91/generic.h
> index 80269bd..26dee3c 100644
> --- a/arch/arm/mach-at91/generic.h
> +++ b/arch/arm/mach-at91/generic.h
> @@ -35,6 +35,7 @@ extern int  __init at91_aic_of_init(struct device_node *node,
>   extern int  __init at91_aic5_of_init(struct device_node *node,
>   				    struct device_node *parent);
>   extern void __init at91_sysirq_mask_rtc(u32 rtc_base);
> +extern void __init at91_sysirq_mask_rtt(u32 rtt_base);
>
>
>    /* Timer */
> diff --git a/arch/arm/mach-at91/sysirq_mask.c b/arch/arm/mach-at91/sysirq_mask.c
> index ee3e22c..2ba694f 100644
> --- a/arch/arm/mach-at91/sysirq_mask.c
> +++ b/arch/arm/mach-at91/sysirq_mask.c
> @@ -21,6 +21,7 @@
>    */
>
>   #include <linux/io.h>
> +#include <mach/at91_rtt.h>
>
>   #include "generic.h"
>
> @@ -45,3 +46,26 @@ void __init at91_sysirq_mask_rtc(u32 rtc_base)
>
>   	iounmap(base);
>   }
> +
> +void __init at91_sysirq_mask_rtt(u32 rtt_base)
> +{
> +	void __iomem *base;
> +	void __iomem *reg;
> +	u32 mode;
> +
> +	base = ioremap(rtt_base, 16);
> +	if (!base)
> +		return;
> +
> +	reg = base + AT91_RTT_MR;
> +
> +	mode = readl_relaxed(reg);
> +	if (mode & (AT91_RTT_ALMIEN | AT91_RTT_RTTINCIEN)) {
> +		pr_info("AT91: Disabling rtt irq\n");
> +		mode &= ~(AT91_RTT_ALMIEN | AT91_RTT_RTTINCIEN);
> +		writel_relaxed(mode, reg);
> +		(void)readl_relaxed(reg);			/* flush */
> +	}
> +
> +	iounmap(base);
> +}
>


-- 
Nicolas Ferre
