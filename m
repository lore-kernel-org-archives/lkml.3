Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933631Ab3CVPbp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 11:31:45 -0400
Received: from mail.active-venture.com ([67.228.131.205]:58874 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932548Ab3CVPbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 11:31:44 -0400
X-Originating-IP: 108.223.40.66
Date: Fri, 22 Mar 2013 06:56:01 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Lubomir Rintel <lkundrak@v3.sk>
Cc: linux-kernel@vger.kernel.org, Stephen Warren <swarren@wwwdotorg.org>,
        Wim Van Sebroeck <wim@iguana.be>, linux-rpi-kernel@lists.infradead.org,
        linux-watchdog@vger.kernel.org
Subject: Re: watchdog: Add Broadcom BCM2708 watchdog timer driver
Message-ID: <20130322135601.GA11264@roeck-us.net>
References: <1363956907-5644-1-git-send-email-lkundrak@v3.sk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363956907-5644-1-git-send-email-lkundrak@v3.sk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 22, 2013 at 12:55:07PM -0000, Lubomir Rintel wrote:
> Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
> Cc: Stephen Warren <swarren@wwwdotorg.org>
> Cc: Wim Van Sebroeck <wim@iguana.be>
> Cc: linux-rpi-kernel@lists.infradead.org
> Cc: linux-watchdog@vger.kernel.org
> 
> ---
> arch/arm/configs/bcm2835_defconfig |    4 +
>  drivers/watchdog/Kconfig           |   11 +++
>  drivers/watchdog/Makefile          |    1 +
>  drivers/watchdog/bcm2835_wdt.c     |  158 ++++++++++++++++++++++++++++++++++++
>  4 files changed, 174 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/watchdog/bcm2835_wdt.c
> 
> diff --git a/arch/arm/configs/bcm2835_defconfig b/arch/arm/configs/bcm2835_defconfig
> index 611bda2..8f1547a 100644
> --- a/arch/arm/configs/bcm2835_defconfig
> +++ b/arch/arm/configs/bcm2835_defconfig
> @@ -67,6 +67,10 @@ CONFIG_I2C_BCM2835=y
>  CONFIG_GPIO_SYSFS=y
>  # CONFIG_HWMON is not set
>  # CONFIG_USB_SUPPORT is not set
> +CONFIG_WATCHDOG=y
> +CONFIG_WATCHDOG_CORE=y
> +CONFIG_BCM2835_WDT=y
> +
>  CONFIG_MMC=y
>  CONFIG_MMC_SDHCI=y
>  CONFIG_MMC_SDHCI_PLTFM=y
> diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
> index 9fcc70c..f4e4a8e 100644
> --- a/drivers/watchdog/Kconfig
> +++ b/drivers/watchdog/Kconfig
> @@ -1098,6 +1098,17 @@ config BCM63XX_WDT
>  	  To compile this driver as a loadable module, choose M here.
>  	  The module will be called bcm63xx_wdt.
>  
> +config BCM2835_WDT
> +	tristate "Broadcom BCM2835 hardware watchdog"
> +	depends on ARCH_BCM2835
> +	select WATCHDOG_CORE
> +	help
> +	  Watchdog driver for the built in watchdog hardware in Broadcom
> +	  BCM2835 SoC.
> +
> +	  To compile this driver as a loadable module, choose M here.
> +	  The module will be called bcm2835_wdt.
> +
>  config LANTIQ_WDT
>  	tristate "Lantiq SoC watchdog"
>  	depends on LANTIQ
> diff --git a/drivers/watchdog/Makefile b/drivers/watchdog/Makefile
> index a300b94..1bf5675 100644
> --- a/drivers/watchdog/Makefile
> +++ b/drivers/watchdog/Makefile
> @@ -54,6 +54,7 @@ obj-$(CONFIG_TS72XX_WATCHDOG) += ts72xx_wdt.o
>  obj-$(CONFIG_IMX2_WDT) += imx2_wdt.o
>  obj-$(CONFIG_UX500_WATCHDOG) += ux500_wdt.o
>  obj-$(CONFIG_RETU_WATCHDOG) += retu_wdt.o
> +obj-$(CONFIG_BCM2835_WDT) += bcm2835_wdt.o
>  
>  # AVR32 Architecture
>  obj-$(CONFIG_AT32AP700X_WDT) += at32ap700x_wdt.o
> diff --git a/drivers/watchdog/bcm2835_wdt.c b/drivers/watchdog/bcm2835_wdt.c
> new file mode 100644
> index 0000000..834f201
> --- /dev/null
> +++ b/drivers/watchdog/bcm2835_wdt.c
> @@ -0,0 +1,158 @@
> +/*
> + *  Watchdog driver for Broadcom BCM2835
> + *
> + *  Copyright (C) 2013 Lubomir Rintel <lkundrak@v3.sk>
> + *
> + *  This program is free software; you can redistribute it and/or
> + *  modify it under the terms of the GNU General Public License
> + *  as published by the Free Software Foundation; either version
> + *  2 of the License, or (at your option) any later version.
> + */
> +
> +#include <linux/types.h>
> +#include <linux/module.h>
> +#include <linux/io.h>
> +#include <linux/watchdog.h>
> +#include <linux/platform_device.h>
> +#include <linux/of_address.h>
> +#include <linux/miscdevice.h>
> +
> +#define PM_RSTC				0x1c
> +#define PM_RSTS				0x20
> +#define PM_WDOG				0x24
> +
> +#define PM_PASSWORD			0x5a000000
> +#define PM_RSTC_WRCFG_MASK		0x00000030
> +#define PM_RSTC_WRCFG_FULL_RESET	0x00000020
> +#define PM_RSTS_HADWRH_SET		0x00000040
> +
> +#define PM_WDOG_TIME_SET		0x000fffff
> +#define PM_RSTC_WRCFG_CLR		0xffffffcf
> +#define PM_RSTC_WRCFG_SET		0x00000030
> +#define PM_RSTC_WRCFG_FULL_RESET	0x00000020
> +#define PM_RSTC_RESET			0x00000102
> +
> +#define SECS_TO_WDOG_TICKS(x) ((x) << 16)
> +#define WDOG_TICKS_TO_SECS(x) ((x) >> 16)
> +
> +static int heartbeat = -1;
> +static bool nowayout = WATCHDOG_NOWAYOUT;
> +static void __iomem *wdt_regs;
> +static DEFINE_SPINLOCK(wdog_lock);
> +
> +static int bcm2835_wdt_start(struct watchdog_device *wdog)
> +{
> +	uint32_t cur;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&wdog_lock, flags);
> +
> +	writel_relaxed(PM_PASSWORD | (SECS_TO_WDOG_TICKS(wdog->timeout) &
> +				PM_WDOG_TIME_SET), wdt_regs + PM_WDOG);
> +	cur = readl_relaxed(wdt_regs + PM_RSTC);
> +	writel_relaxed(PM_PASSWORD | (cur & PM_RSTC_WRCFG_CLR) |
> +		  PM_RSTC_WRCFG_FULL_RESET, wdt_regs + PM_RSTC);
> +
Nitpick - I prefer people to use the recommended continuation line style,
but that is really up to the maintainer to decide.

> +	spin_unlock_irqrestore(&wdog_lock, flags);
> +
> +	return 0;
> +}
> +
> +static int bcm2835_wdt_stop(struct watchdog_device *wdog)
> +{
> +	writel_relaxed(PM_PASSWORD | PM_RSTC_RESET, wdt_regs + PM_RSTC);
> +	dev_info(wdog->dev, "Watchdog timer stopped");
> +	return 0;
> +}
> +
> +static int bcm2835_wdt_set_timeout(struct watchdog_device *wdog, unsigned int t)
> +{
> +	wdog->timeout = t;

No need to update the actual chip timeout ?

> +	return 0;
> +}
> +
> +static unsigned int bcm2835_wdt_get_timeleft(struct watchdog_device *wdog)
> +{
> +	uint32_t ret = readl_relaxed(wdt_regs + PM_WDOG);
> +	return WDOG_TICKS_TO_SECS(ret & PM_WDOG_TIME_SET);
> +}
> +
> +static struct watchdog_ops bcm2835_wdt_ops = {
> +	.owner =	THIS_MODULE,
> +	.start =	bcm2835_wdt_start,
> +	.stop =		bcm2835_wdt_stop,
> +	.set_timeout =	bcm2835_wdt_set_timeout,
> +	.get_timeleft =	bcm2835_wdt_get_timeleft,

No separate ping function ?

> +};
> +
> +static struct watchdog_info bcm2835_wdt_info = {
> +	.options =	WDIOF_SETTIMEOUT | WDIOF_MAGICCLOSE |
> +			WDIOF_KEEPALIVEPING,
> +	.identity =	"Broacom BCM2835 Watchdog timer",
> +};
> +
> +static struct watchdog_device bcm2835_wdt_wdd = {
> +	.info =		&bcm2835_wdt_info,
> +	.ops =		&bcm2835_wdt_ops,
> +	.min_timeout =	1,
> +	.max_timeout =	WDOG_TICKS_TO_SECS(PM_WDOG_TIME_SET),
> +};
> +
> +static int bcm2835_wdt_probe(struct platform_device *op)
> +{
> +	struct device *dev = &op->dev;
> +	struct device_node *np = dev->of_node;
> +
> +	wdt_regs = of_iomap(np, 0);
> +	if (WARN(!wdt_regs, "failed to remap watchdog regs"))
> +		return -ENODEV;

WARN seems to be a bit extreme. Is this necessary ?

> +	dev_info(dev, "Broadcom BCM2835 watchdog timer");
> +
> +	watchdog_init_timeout(&bcm2835_wdt_wdd, heartbeat, dev);

Since heartbeat is by default set to -1, which is interpreted as unsigned
int, I would expect this call to return -EINVAL, leaving the default timeout
undefined. Is this really what you want ?

> +	watchdog_set_nowayout(&bcm2835_wdt_wdd, nowayout);
> +	return watchdog_register_device(&bcm2835_wdt_wdd);

Leaking iomap if this fails.

Would be nice to have something like devm_of_iomap ...

> +}
> +
> +static int bcm2835_wdt_remove(struct platform_device *op)
> +{
> +	watchdog_unregister_device(&bcm2835_wdt_wdd);
> +	iounmap(wdt_regs);
> +
> +	return 0;
> +}
> +
> +static void bcm2835_wdt_shutdown(struct platform_device *op)
> +{
> +	bcm2835_wdt_stop(&bcm2835_wdt_wdd);
> +}
> +
> +static const struct of_device_id bcm2835_wdt_of_match[] = {
> +	{ .compatible = "brcm,bcm2835-pm-wdt", },
> +	{},
> +};
> +MODULE_DEVICE_TABLE(of, bcm2835_wdt_of_match);
> +
> +static struct platform_driver bcm2835_wdt_driver = {
> +	.probe		= bcm2835_wdt_probe,
> +	.remove		= bcm2835_wdt_remove,
> +	.shutdown	= bcm2835_wdt_shutdown,
> +	.driver = {
> +		.name =		"bcm2835-wdt",
> +		.owner =	THIS_MODULE,
> +		.of_match_table = bcm2835_wdt_of_match,
> +	},
> +};
> +
> +module_platform_driver(bcm2835_wdt_driver);
> +
> +module_param(heartbeat, int, 0);
> +MODULE_PARM_DESC(heartbeat, "Initial watchdog heartbeat in seconds");
> +
> +module_param(nowayout, bool, 0);
> +MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default="
> +				__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
> +
> +MODULE_AUTHOR("Lubomir Rintel <lkundrak@v3.sk>");
> +MODULE_DESCRIPTION("Driver for Broadcom BCM2835 watchdog timer");
> +MODULE_LICENSE("GPL");
> +MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
