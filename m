Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753359Ab3KOWCl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 17:02:41 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:32967 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751938Ab3KOWCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 17:02:33 -0500
MIME-Version: 1.0
In-Reply-To: <1384549081-9571-2-git-send-email-markus.mayer@linaro.org>
References: <1384549081-9571-1-git-send-email-markus.mayer@linaro.org>
	<1384549081-9571-2-git-send-email-markus.mayer@linaro.org>
Date: Fri, 15 Nov 2013 14:02:32 -0800
Message-ID: <CAPdLdq=4HGZmQRJywto=u9SWaChoWz77oALVcKgggMA-fdsg+w@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] watchdog: bcm281xx: Watchdog Driver
From: Markus Mayer <markus.mayer@linaro.org>
To: Wim Van Sebroeck <wim@iguana.be>, Guenter Roeck <linux@roeck-us.net>,
        Christian Daudt <bcm@fixthebug.org>
Cc: Linaro Patches <patches@linaro.org>, Matt Porter <matt.porter@linaro.org>,
        Linux Watchdog List <linux-watchdog@vger.kernel.org>,
        ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Markus Mayer <markus.mayer@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15 November 2013 12:58, Markus Mayer <markus.mayer@linaro.org> wrote:
> This commit adds support for the watchdog timer used on the BCM281xx
> family of SoCs.
>
> Signed-off-by: Markus Mayer <markus.mayer@linaro.org>
> Reviewed-by: Matt Porter <matt.porter@linaro.org>
> ---
>  drivers/watchdog/Kconfig        |   22 +++
>  drivers/watchdog/Makefile       |    1 +
>  drivers/watchdog/bcm_kona_wdt.c |  367 +++++++++++++++++++++++++++++++++++++++
>  3 files changed, 390 insertions(+)
>  create mode 100644 drivers/watchdog/bcm_kona_wdt.c
>
> diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
> index d1d53f3..fe8bd21 100644
> --- a/drivers/watchdog/Kconfig
> +++ b/drivers/watchdog/Kconfig
> @@ -1121,6 +1121,28 @@ config BCM2835_WDT
>           To compile this driver as a loadable module, choose M here.
>           The module will be called bcm2835_wdt.
>
> +config BCM_KONA_WDT
> +       tristate "BCM Kona Watchdog"
> +       depends on ARCH_BCM
> +       select WATCHDOG_CORE
> +       help
> +         Support for the watchdog timer on the following Broadcom BCM281xx
> +         family, which includes BCM11130, BCM11140, BCM11351, BCM28145 and
> +         BCM28155 variants.
> +
> +         Say 'Y' or 'M' here to enable the driver. The module will be called
> +         bcm_kona_wdt.
> +
> +config BCM_KONA_WDT_DEBUG
> +       bool "DEBUGFS support for BCM Kona Watchdog"
> +       depends on BCM_KONA_WDT
> +       help
> +         If enabled, adds /sys/kernel/debug/bcm-kona-wdt/info which provides
> +         access to the driver's internal data structures as well as watchdog
> +         timer hardware registres.
> +
> +         If in doubt, say 'N'.
> +
>  config LANTIQ_WDT
>         tristate "Lantiq SoC watchdog"
>         depends on LANTIQ
> diff --git a/drivers/watchdog/Makefile b/drivers/watchdog/Makefile
> index 6c5bb27..7c860ca 100644
> --- a/drivers/watchdog/Makefile
> +++ b/drivers/watchdog/Makefile
> @@ -55,6 +55,7 @@ obj-$(CONFIG_IMX2_WDT) += imx2_wdt.o
>  obj-$(CONFIG_UX500_WATCHDOG) += ux500_wdt.o
>  obj-$(CONFIG_RETU_WATCHDOG) += retu_wdt.o
>  obj-$(CONFIG_BCM2835_WDT) += bcm2835_wdt.o
> +obj-$(CONFIG_BCM_KONA_WDT) += bcm_kona_wdt.o
>
>  # AVR32 Architecture
>  obj-$(CONFIG_AT32AP700X_WDT) += at32ap700x_wdt.o
> diff --git a/drivers/watchdog/bcm_kona_wdt.c b/drivers/watchdog/bcm_kona_wdt.c
> new file mode 100644
> index 0000000..5a03d5a
> --- /dev/null
> +++ b/drivers/watchdog/bcm_kona_wdt.c
> @@ -0,0 +1,367 @@
> +/*
> + * Copyright (C) 2013 Broadcom Corporation
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License as
> + * published by the Free Software Foundation version 2.
> + *
> + * This program is distributed "as is" WITHOUT ANY WARRANTY of any
> + * kind, whether express or implied; without even the implied warranty
> + * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <linux/debugfs.h>
> +#include <linux/delay.h>
> +#include <linux/err.h>
> +#include <linux/io.h>
> +#include <linux/miscdevice.h>
> +#include <linux/module.h>
> +#include <linux/of_address.h>
> +#include <linux/platform_device.h>
> +#include <linux/watchdog.h>
> +
> +#define SECWDOG_CTRL_REG               0x00000000
> +#define SECWDOG_COUNT_REG              0x00000004
> +
> +#define SECWDOG_RESERVED_MASK          0x1dffffff
> +#define SECWDOG_WD_LOAD_FLAG           0x10000000
> +#define SECWDOG_EN_MASK                        0x08000000
> +#define SECWDOG_SRSTEN_MASK            0x04000000
> +#define SECWDOG_RES_MASK               0x00f00000
> +#define SECWDOG_COUNT_MASK             0x000fffff
> +
> +#define SECWDOG_MAX_COUNT              SECWDOG_COUNT_MASK
> +#define SECWDOG_CLKS_SHIFT             20
> +#define SECWDOG_MAX_RES                        15
> +#define SECWDOG_DEFAULT_RESOLUTION     4
> +#define SECWDOG_MAX_TRY                        1000
> +
> +#define SECS_TO_TICKS(x, w)            ((x) << (w)->resolution)
> +#define TICKS_TO_SECS(x, w)            ((x) >> (w)->resolution)
> +
> +#define BCM_KONA_WDT_NAME              "bcm-kona-wdt"

I just noticed that this should be "bcm_kona_wdt" instead.

-Markus
