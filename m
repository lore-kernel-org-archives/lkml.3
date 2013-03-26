Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753514Ab3CZVDk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 17:03:40 -0400
Received: from mail.active-venture.com ([67.228.131.205]:64333 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751303Ab3CZVDi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 17:03:38 -0400
X-Originating-IP: 108.223.40.66
Date: Tue, 26 Mar 2013 14:03:48 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Lubomir Rintel <lkundrak@v3.sk>
Cc: linux-kernel@vger.kernel.org, Stephen Warren <swarren@wwwdotorg.org>,
        Wim Van Sebroeck <wim@iguana.be>, linux-rpi-kernel@lists.infradead.org,
        linux-watchdog@vger.kernel.org
Subject: Re: [PATCH v3] watchdog: Add Broadcom BCM2835 watchdog timer driver
Message-ID: <20130326210348.GA23436@roeck-us.net>
References: <1364135137-26691-1-git-send-email-lkundrak@v3.sk>
 <1364320200-23569-1-git-send-email-lkundrak@v3.sk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364320200-23569-1-git-send-email-lkundrak@v3.sk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 26, 2013 at 06:50:00PM +0100, Lubomir Rintel wrote:
> This adds a driver for watchdog timer hardware present on Broadcom BCM2835 SoC,
> used in Raspberry Pi and Roku 2 devices.
> 
> Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
> Cc: Stephen Warren <swarren@wwwdotorg.org>
> Cc: Wim Van Sebroeck <wim@iguana.be>
> Cc: Guenter Roeck <linux@roeck-us.net>
> Cc: linux-rpi-kernel@lists.infradead.org
> Cc: linux-watchdog@vger.kernel.org
> ---
> Changes for v2:
>     - Use per-device structure instead of global variables for lock and memory base
>     - Fix default timeout setting
>     - Do not leak memory if probe fails
>     - Style fixes
>     - Split out defconfig into a separate commit
>     - Meaningful commit message with credit
> 
> Changes for v3:
>     - Add proper copyright notice to header
>     - Drop status constants, we don't use them
>     - Fix heartbeat parameter's type
>     - Log driver initialization message once the device is probed
> 
>  .../bindings/watchdog/brcm,bcm2835-pm-wdog.txt     |    5 +
>  drivers/watchdog/Kconfig                           |   11 ++
>  drivers/watchdog/Makefile                          |    1 +
>  drivers/watchdog/bcm2835_wdt.c                     |  190 ++++++++++++++++++++
>  4 files changed, 207 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/watchdog/bcm2835_wdt.c
> 
> diff --git a/Documentation/devicetree/bindings/watchdog/brcm,bcm2835-pm-wdog.txt b/Documentation/devicetree/bindings/watchdog/brcm,bcm2835-pm-wdog.txt
> index d209366..f801d71 100644
> --- a/Documentation/devicetree/bindings/watchdog/brcm,bcm2835-pm-wdog.txt
> +++ b/Documentation/devicetree/bindings/watchdog/brcm,bcm2835-pm-wdog.txt
> @@ -5,9 +5,14 @@ Required properties:
>  - compatible : should be "brcm,bcm2835-pm-wdt"
>  - reg : Specifies base physical address and size of the registers.
>  
> +Optional properties:
> +
> +- timeout-sec   : Contains the watchdog timeout in seconds
> +
>  Example:
>  
>  watchdog {
>  	compatible = "brcm,bcm2835-pm-wdt";
>  	reg = <0x7e100000 0x28>;
> +	timeout-sec = <10>;
>  };
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
> index 0000000..13a8c00
> --- /dev/null
> +++ b/drivers/watchdog/bcm2835_wdt.c
> @@ -0,0 +1,190 @@
> +/*
> + * Watchdog driver for Broadcom BCM2835
> + *
> + * Interface to the Broadcom BCM2835 watchdog timer hardware is based on
> + * "bcm2708_wdog" driver written by Luke Diamand that was obtained from branch
> + * "rpi-3.6.y" of git://github.com/raspberrypi/linux.git
> + *
> + * (c) Copyright 2010 Broadcom Europe Ltd
> + * Copyright (C) 2013 Lubomir Rintel <lkundrak@v3.sk>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * as published by the Free Software Foundation; either version
> + * 2 of the License, or (at your option) any later version.
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
> +#define PM_WDOG				0x24
> +
> +#define PM_PASSWORD			0x5a000000
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
> +struct bcm2835_wdt {
> +	void __iomem		*base;
> +	spinlock_t		lock;
> +};
> +
> +static unsigned int heartbeat = 0;

checkpatch.pl says:

ERROR: do not initialise statics to 0 or NULL
#178: FILE: drivers/watchdog/bcm2835_wdt.c:44:
+static unsigned int heartbeat = 0;

> +static bool nowayout = WATCHDOG_NOWAYOUT;
> +
> +static int bcm2835_wdt_start(struct watchdog_device *wdog)
> +{
> +	struct bcm2835_wdt *wdt = watchdog_get_drvdata(wdog);
> +	uint32_t cur;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&wdt->lock, flags);
> +
> +	writel_relaxed(PM_PASSWORD | (SECS_TO_WDOG_TICKS(wdog->timeout) &
> +				PM_WDOG_TIME_SET), wdt->base + PM_WDOG);
> +	cur = readl_relaxed(wdt->base + PM_RSTC);
> +	writel_relaxed(PM_PASSWORD | (cur & PM_RSTC_WRCFG_CLR) |
> +		  PM_RSTC_WRCFG_FULL_RESET, wdt->base + PM_RSTC);
> +
> +	spin_unlock_irqrestore(&wdt->lock, flags);
> +
> +	return 0;
> +}
> +
> +static int bcm2835_wdt_stop(struct watchdog_device *wdog)
> +{
> +	struct bcm2835_wdt *wdt = watchdog_get_drvdata(wdog);
> +
> +	writel_relaxed(PM_PASSWORD | PM_RSTC_RESET, wdt->base + PM_RSTC);
> +	dev_info(wdog->dev, "Watchdog timer stopped");
> +	return 0;
> +}
> +
> +static int bcm2835_wdt_set_timeout(struct watchdog_device *wdog, unsigned int t)
> +{
> +	wdog->timeout = t;
> +	return 0;
> +}
> +
> +static unsigned int bcm2835_wdt_get_timeleft(struct watchdog_device *wdog)
> +{
> +	struct bcm2835_wdt *wdt = watchdog_get_drvdata(wdog);
> +
> +	uint32_t ret = readl_relaxed(wdt->base + PM_WDOG);
> +	return WDOG_TICKS_TO_SECS(ret & PM_WDOG_TIME_SET);
> +}
> +
> +static struct watchdog_ops bcm2835_wdt_ops = {
> +	.owner =	THIS_MODULE,
> +	.start =	bcm2835_wdt_start,
> +	.stop =		bcm2835_wdt_stop,
> +	.set_timeout =	bcm2835_wdt_set_timeout,
> +	.get_timeleft =	bcm2835_wdt_get_timeleft,
> +};
> +
> +static struct watchdog_info bcm2835_wdt_info = {
> +	.options =	WDIOF_SETTIMEOUT | WDIOF_MAGICCLOSE |
> +			WDIOF_KEEPALIVEPING,
> +	.identity =	"Broadcom BCM2835 Watchdog timer",
> +};
> +
> +static struct watchdog_device bcm2835_wdt_wdd = {
> +	.info =		&bcm2835_wdt_info,
> +	.ops =		&bcm2835_wdt_ops,
> +	.min_timeout =	1,
> +	.max_timeout =	WDOG_TICKS_TO_SECS(PM_WDOG_TIME_SET),
> +	.timeout =	WDOG_TICKS_TO_SECS(PM_WDOG_TIME_SET),
> +};
> +
> +static int bcm2835_wdt_probe(struct platform_device *pdev)
> +{
> +	struct device *dev = &pdev->dev;
> +	struct device_node *np = dev->of_node;
> +	struct bcm2835_wdt *wdt;
> +	int err;
> +
> +	wdt = devm_kzalloc(dev, sizeof(struct bcm2835_wdt), GFP_KERNEL);
> +	if (!wdt) {
> +		dev_err(dev, "Failed to allocate memory for watchdog device");
> +		return -ENOMEM;
> +	}
> +
> +	spin_lock_init(&wdt->lock);
> +
> +	wdt->base = of_iomap(np, 0);
> +	if (!wdt->base) {
> +		dev_err(dev, "Failed to remap watchdog regs");
> +		return -ENODEV;
> +	}
> +
> +	platform_set_drvdata(pdev, wdt);
> +	watchdog_set_drvdata(&bcm2835_wdt_wdd, wdt);
> +	watchdog_init_timeout(&bcm2835_wdt_wdd, heartbeat, dev);
> +	watchdog_set_nowayout(&bcm2835_wdt_wdd, nowayout);
> +	err = watchdog_register_device(&bcm2835_wdt_wdd);
> +	if (err) {
> +		dev_err(dev, "Failed to register watchdog device");
> +		iounmap(wdt->base);
> +	}
> +	dev_info(dev, "Broadcom BCM2835 watchdog timer");
> +
Hmm .. that means you'll get the info message even in the error case.
Is that intentional ? It is inconsistent with the remap error message
above, which does not result in the info message.

> +	return err;
> +}
> +
> +static int bcm2835_wdt_remove(struct platform_device *pdev)
> +{
> +	struct bcm2835_wdt *wdt = platform_get_drvdata(pdev);
> +
> +	platform_set_drvdata(pdev, NULL);

Still unnecessary.

Thanks,
Guenter
