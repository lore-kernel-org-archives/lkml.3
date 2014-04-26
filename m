Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752223AbaDZPcd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2014 11:32:33 -0400
Received: from mail.active-venture.com ([67.228.131.205]:51937 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898AbaDZPca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2014 11:32:30 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <535BD18B.2070902@roeck-us.net>
Date: Sat, 26 Apr 2014 08:32:27 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Arnd Bergmann <arnd@arndb.de>, wim@iguana.be, dbaryshkov@gmail.com,
        dwmw2@infradead.org
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org, linux-sunxi@googlegroups.com
Subject: Re: [PATCH 2/5] power: reset: Add Allwinner A31 reset code
References: <1398265476-29373-1-git-send-email-maxime.ripard@free-electrons.com> <1398265476-29373-3-git-send-email-maxime.ripard@free-electrons.com>
In-Reply-To: <1398265476-29373-3-git-send-email-maxime.ripard@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23/2014 08:04 AM, Maxime Ripard wrote:
> That code used to be in the machine code, but it's more fit here with other
> restart hooks.
>
> That will allow to cleanup the machine directory, while waiting for a proper
> watchdog driver for the A31.
>
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>

I am a bit lost here. Why is this a separate driver, accessing watchdog registers,
while the other reset functions are being moved into the watchdog code ?

Any chance to handle all platforms the same ? Seems to me that would be less messy.

Guenter

> ---
>   drivers/power/reset/Kconfig        |  7 ++++
>   drivers/power/reset/Makefile       |  1 +
>   drivers/power/reset/sun6i-reboot.c | 85 ++++++++++++++++++++++++++++++++++++++
>   3 files changed, 93 insertions(+)
>   create mode 100644 drivers/power/reset/sun6i-reboot.c
>
> diff --git a/drivers/power/reset/Kconfig b/drivers/power/reset/Kconfig
> index fa0e4e057b99..67aeb6ec08f9 100644
> --- a/drivers/power/reset/Kconfig
> +++ b/drivers/power/reset/Kconfig
> @@ -43,6 +43,13 @@ config POWER_RESET_RESTART
>   	  Instead they restart, and u-boot holds the SoC until the
>   	  user presses a key. u-boot then boots into Linux.
>
> +config POWER_RESET_SUN6I
> +	bool "Allwinner A31 SoC reset driver"
> +	depends on ARCH_SUNXI
> +	depends on POWER_RESET
> +	help
> +	  Reboot support for the Allwinner A31 SoCs.
> +
>   config POWER_RESET_VEXPRESS
>   	bool "ARM Versatile Express power-off and reset driver"
>   	depends on ARM || ARM64
> diff --git a/drivers/power/reset/Makefile b/drivers/power/reset/Makefile
> index a5b4a77d1a41..950fdc011c7a 100644
> --- a/drivers/power/reset/Makefile
> +++ b/drivers/power/reset/Makefile
> @@ -3,5 +3,6 @@ obj-$(CONFIG_POWER_RESET_GPIO) += gpio-poweroff.o
>   obj-$(CONFIG_POWER_RESET_MSM) += msm-poweroff.o
>   obj-$(CONFIG_POWER_RESET_QNAP) += qnap-poweroff.o
>   obj-$(CONFIG_POWER_RESET_RESTART) += restart-poweroff.o
> +obj-$(CONFIG_POWER_RESET_SUN6I) += sun6i-reboot.o
>   obj-$(CONFIG_POWER_RESET_VEXPRESS) += vexpress-poweroff.o
>   obj-$(CONFIG_POWER_RESET_XGENE) += xgene-reboot.o
> diff --git a/drivers/power/reset/sun6i-reboot.c b/drivers/power/reset/sun6i-reboot.c
> new file mode 100644
> index 000000000000..af2cd7ff2fe8
> --- /dev/null
> +++ b/drivers/power/reset/sun6i-reboot.c
> @@ -0,0 +1,85 @@
> +/*
> + * Allwinner A31 SoCs reset code
> + *
> + * Copyright (C) 2012-2014 Maxime Ripard
> + *
> + * Maxime Ripard <maxime.ripard@free-electrons.com>
> + *
> + * This file is licensed under the terms of the GNU General Public
> + * License version 2.  This program is licensed "as is" without any
> + * warranty of any kind, whether express or implied.
> + */
> +
> +#include <linux/delay.h>
> +#include <linux/io.h>
> +#include <linux/module.h>
> +#include <linux/of_address.h>
> +#include <linux/platform_device.h>
> +#include <linux/reboot.h>
> +
> +#include <asm/system_misc.h>
> +
> +#define SUN6I_WATCHDOG1_IRQ_REG		0x00
> +#define SUN6I_WATCHDOG1_CTRL_REG	0x10
> +#define SUN6I_WATCHDOG1_CTRL_RESTART		BIT(0)
> +#define SUN6I_WATCHDOG1_CONFIG_REG	0x14
> +#define SUN6I_WATCHDOG1_CONFIG_RESTART		BIT(0)
> +#define SUN6I_WATCHDOG1_CONFIG_IRQ		BIT(1)
> +#define SUN6I_WATCHDOG1_MODE_REG	0x18
> +#define SUN6I_WATCHDOG1_MODE_ENABLE		BIT(0)
> +
> +static void __iomem *wdt_base;
> +
> +static void sun6i_wdt_restart(enum reboot_mode mode, const char *cmd)
> +{
> +	if (!wdt_base)
> +		return;
> +
> +	/* Disable interrupts */
> +	writel(0, wdt_base + SUN6I_WATCHDOG1_IRQ_REG);
> +
> +	/* We want to disable the IRQ and just reset the whole system */
> +	writel(SUN6I_WATCHDOG1_CONFIG_RESTART,
> +		wdt_base + SUN6I_WATCHDOG1_CONFIG_REG);
> +
> +	/* Enable timer. The default and lowest interval value is 0.5s */
> +	writel(SUN6I_WATCHDOG1_MODE_ENABLE,
> +		wdt_base + SUN6I_WATCHDOG1_MODE_REG);
> +
> +	/* Restart the watchdog. */
> +	writel(SUN6I_WATCHDOG1_CTRL_RESTART,
> +		wdt_base + SUN6I_WATCHDOG1_CTRL_REG);
> +
> +	while (1) {
> +		mdelay(5);
> +		writel(SUN6I_WATCHDOG1_MODE_ENABLE,
> +			wdt_base + SUN6I_WATCHDOG1_MODE_REG);
> +	}
> +}
> +
> +static int sun6i_reboot_probe(struct platform_device *pdev)
> +{
> +	wdt_base = of_iomap(pdev->dev.of_node, 0);
> +	if (!wdt_base) {
> +		WARN(1, "failed to map watchdog base address");
> +		return -ENODEV;
> +	}
> +
> +	arm_pm_restart = sun6i_wdt_restart;
> +
> +	return 0;
> +}
> +
> +static struct of_device_id sun6i_reboot_of_match[] = {
> +	{ .compatible = "allwinner,sun6i-a31-wdt" },
> +	{}
> +};
> +
> +static struct platform_driver sun6i_reboot_driver = {
> +	.probe = sun6i_reboot_probe,
> +	.driver = {
> +		.name = "sun6i-reboot",
> +		.of_match_table = sun6i_reboot_of_match,
> +	},
> +};
> +module_platform_driver(sun6i_reboot_driver);
>

