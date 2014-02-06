Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752058AbaBFGM5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 01:12:57 -0500
Received: from mail.active-venture.com ([67.228.131.205]:65236 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751619AbaBFGMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 01:12:54 -0500
X-Originating-IP: 108.223.40.66
Message-ID: <52F327E5.7070507@roeck-us.net>
Date: Wed, 05 Feb 2014 22:12:53 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Andrew Chew <achew@nvidia.com>, wim@iguana.be, rob@landley.net,
        swarren@wwwdotorg.org, thierry.reding@gmail.com,
        grant.likely@linaro.org, robh+dt@kernel.org, abrestic@chromium.org,
        dgreid@chromium.org, katierh@chromium.org
CC: linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-watchdog@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH v3 1/1] watchdog: Add tegra watchdog
References: <1391657913-28608-1-git-send-email-achew@nvidia.com>
In-Reply-To: <1391657913-28608-1-git-send-email-achew@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/05/2014 07:38 PM, Andrew Chew wrote:
> Add a driver for the hardware watchdogs in NVIDIA Tegra SoCs (Tegra30 and
> later).  This driver will configure one watchdog timer that will reset the
> system in the case of a watchdog timeout.
>
> This driver binds to the nvidia,tegra30-timer device node and gets its
> register base from there.
>
> Signed-off-by: Andrew Chew <achew@nvidia.com>
> ---
> Changes from V2:
>
> Applied all of Stephen Warren's comments.
> Modified suspend callback by only stopping the watchdog timer if it was
> currently active.
> Added some logging during suspend/resume.
>
>   Documentation/watchdog/watchdog-parameters.txt |   5 +
>   drivers/watchdog/Kconfig                       |  11 +
>   drivers/watchdog/Makefile                      |   1 +
>   drivers/watchdog/tegra_wdt.c                   | 371 +++++++++++++++++++++++++
>   4 files changed, 388 insertions(+)
>   create mode 100644 drivers/watchdog/tegra_wdt.c
>
> diff --git a/Documentation/watchdog/watchdog-parameters.txt b/Documentation/watchdog/watchdog-parameters.txt
> index f9492fe..b39f355 100644
> --- a/Documentation/watchdog/watchdog-parameters.txt
> +++ b/Documentation/watchdog/watchdog-parameters.txt
> @@ -325,6 +325,11 @@ soft_noboot: Softdog action, set to 1 to ignore reboots, 0 to reboot
>   stmp3xxx_wdt:
>   heartbeat: Watchdog heartbeat period in seconds from 1 to 4194304, default 19
>   -------------------------------------------------
> +tegra_wdt:
> +heartbeat: Watchdog heartbeats in seconds. (default = 120)
> +nowayout: Watchdog cannot be stopped once started
> +	(default=kernel config parameter)
> +-------------------------------------------------
>   ts72xx_wdt:
>   timeout: Watchdog timeout in seconds. (1 <= timeout <= 8, default=8)
>   nowayout: Disable watchdog shutdown on close
> diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
> index 4c4c566..3aae2da 100644
> --- a/drivers/watchdog/Kconfig
> +++ b/drivers/watchdog/Kconfig
> @@ -420,6 +420,17 @@ config SIRFSOC_WATCHDOG
>   	  Support for CSR SiRFprimaII and SiRFatlasVI watchdog. When
>   	  the watchdog triggers the system will be reset.
>
> +config TEGRA_WATCHDOG
> +	tristate "Tegra watchdog"
> +	depends on ARCH_TEGRA || COMPILE_TEST

Hope you tested this on a couple of platforms ?

> +	select WATCHDOG_CORE
> +	help
> +	  Say Y here to include support for the watchdog timer
> +	  embedded in NVIDIA Tegra SoCs.
> +
> +	  To compile this driver as a module, choose M here: the
> +	  module will be called tegra_wdt.
> +
>   # AVR32 Architecture
>
>   config AT32AP700X_WDT
> diff --git a/drivers/watchdog/Makefile b/drivers/watchdog/Makefile
> index 985a66c..1b5f3d5 100644
> --- a/drivers/watchdog/Makefile
> +++ b/drivers/watchdog/Makefile
> @@ -58,6 +58,7 @@ obj-$(CONFIG_BCM2835_WDT) += bcm2835_wdt.o
>   obj-$(CONFIG_MOXART_WDT) += moxart_wdt.o
>   obj-$(CONFIG_SIRFSOC_WATCHDOG) += sirfsoc_wdt.o
>   obj-$(CONFIG_BCM_KONA_WDT) += bcm_kona_wdt.o
> +obj-$(CONFIG_TEGRA_WATCHDOG) += tegra_wdt.o
>
>   # AVR32 Architecture
>   obj-$(CONFIG_AT32AP700X_WDT) += at32ap700x_wdt.o
> diff --git a/drivers/watchdog/tegra_wdt.c b/drivers/watchdog/tegra_wdt.c
> new file mode 100644
> index 0000000..1314475
> --- /dev/null
> +++ b/drivers/watchdog/tegra_wdt.c
> @@ -0,0 +1,371 @@
> +/*
> + * Copyright (c) 2013, NVIDIA CORPORATION.  All rights reserved.
> + *

2014 ?

> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms and conditions of the GNU General Public License,
> + * version 2, as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope it will be useful, but WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> + * more details.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/interrupt.h>
> +#include <linux/io.h>
> +#include <linux/of.h>
> +#include <linux/platform_device.h>
> +#include <linux/miscdevice.h>

Not needed - also see below.

> +#include <linux/watchdog.h>
> +
> +/* minimum and maximum watchdog trigger timeout, in seconds */
> +#define MIN_WDT_TIMEOUT			1
> +#define MAX_WDT_TIMEOUT			255
> +
> +/*
> + * Base of the WDT registers, from the timer base address.  There are
> + * actually 5 watchdogs that can be configured (by pairing with an available
> + * timer), at bases 0x100 + (WDT ID) * 0x20, where WDT ID is 0 through 4.
> + * This driver only configures the first watchdog (WDT ID 0).
> + */
> +#define WDT_BASE			0x100
> +#define WDT_ID				0
> +
> +/*
> + * Register base of the timer that's selected for pairing with the watchdog.
> + * This driver arbitrarily uses timer 5, which is currently unused by
> + * other drivers (in particular, the Tegra clocksource driver).  If this
> + * needs to change, take care that the new timer is not used by the
> + * clocksource driver.
> + */
> +#define WDT_TIMER_BASE			0x60
> +#define WDT_TIMER_ID			5
> +
> +/* WDT registers */
> +#define WDT_CFG				0x0
> +#define WDT_CFG_PERIOD_SHIFT		4
> +#define WDT_CFG_PERIOD_MASK		0xff
> +#define WDT_CFG_INT_EN			(1 << 12)
> +#define WDT_CFG_PMC2CAR_RST_EN		(1 << 15)
> +#define WDT_STS				0x4
> +#define WDT_STS_COUNT_SHIFT		4
> +#define WDT_STS_COUNT_MASK		0xff
> +#define WDT_STS_EXP_SHIFT		12
> +#define WDT_STS_EXP_MASK		0x3
> +#define WDT_CMD				0x8
> +#define WDT_CMD_START_COUNTER		(1 << 0)
> +#define WDT_CMD_DISABLE_COUNTER		(1 << 1)
> +#define WDT_UNLOCK			(0xc)
> +#define WDT_UNLOCK_PATTERN		(0xc45a << 0)
> +
> +/* Timer registers */
> +#define TIMER_PTV			0x0
> +#define TIMER_EN			(1 << 31)
> +#define TIMER_PERIODIC			(1 << 30)
> +
> +struct tegra_wdt {
> +	struct watchdog_device	wdd;
> +	struct kref		kref;
> +	void __iomem		*wdt_regs;
> +	void __iomem		*tmr_regs;
> +};
> +
> +#define WDT_HEARTBEAT 120
> +static int heartbeat = WDT_HEARTBEAT;
> +module_param(heartbeat, int, 0);
> +MODULE_PARM_DESC(heartbeat, "Watchdog heartbeats in seconds. "
> +	"(default = " __MODULE_STRING(WDT_HEARTBEAT) ")");

I'd suggest to split this such that the chackpatch warning goes away.

> +
> +static bool nowayout = WATCHDOG_NOWAYOUT;
> +module_param(nowayout, bool, 0);
> +MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started "
> +	"(default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");

Same here.

> +
> +static void tegra_wdt_release_resources(struct kref *r)
> +{
> +}
> +
> +static int tegra_wdt_start(struct watchdog_device *wdd)
> +{
> +	struct tegra_wdt *wdt = watchdog_get_drvdata(wdd);
> +	u32 val;
> +
> +	/* This thing has a fixed 1MHz clock.  Normally, we would set the

Multi-line comment coding style.

> +	 * period to 1 second by writing 1000000ul, but the watchdog system
> +	 * reset actually occurs on the 4th expiration of this counter,
> +	 * so we set the period to 1/4 of this amount.
> +	 */
> +	val = 1000000ul / 4;
> +	val |= (TIMER_EN | TIMER_PERIODIC);
> +	writel(val, wdt->tmr_regs + TIMER_PTV);
> +
> +	/*
> +	 * Set number of periods and start counter.
> +	 *
> +	 * Interrupt handler is not required for user space
> +	 * WDT accesses, since the caller is responsible to ping the
> +	 * WDT to reset the counter before expiration, through ioctls.
> +	 */
> +	val = WDT_TIMER_ID |
> +	      (wdd->timeout << WDT_CFG_PERIOD_SHIFT) |
> +	      WDT_CFG_PMC2CAR_RST_EN;
> +	writel(val, wdt->wdt_regs + WDT_CFG);
> +
> +	writel(WDT_CMD_START_COUNTER, wdt->wdt_regs + WDT_CMD);
> +
> +	return 0;
> +}
> +
> +static int tegra_wdt_stop(struct watchdog_device *wdd)
> +{
> +	struct tegra_wdt *wdt = watchdog_get_drvdata(wdd);
> +
> +	writel(WDT_UNLOCK_PATTERN, wdt->wdt_regs + WDT_UNLOCK);
> +	writel(WDT_CMD_DISABLE_COUNTER, wdt->wdt_regs + WDT_CMD);
> +	writel(0, wdt->tmr_regs + TIMER_PTV);
> +
> +	return 0;
> +}
> +
> +static int tegra_wdt_ping(struct watchdog_device *wdd)
> +{
> +	struct tegra_wdt *wdt = watchdog_get_drvdata(wdd);
> +
> +	writel(WDT_CMD_START_COUNTER, wdt->wdt_regs + WDT_CMD);
> +
> +	return 0;
> +}
> +
> +static int tegra_wdt_set_timeout(struct watchdog_device *wdd,
> +				 unsigned int timeout)
> +{
> +	int ret;
> +
> +	ret = tegra_wdt_stop(wdd);
> +	if (ret)
> +		return ret;

Unusual. Is it necessary to stop the wdt to change its timeout ?
If so, might be worth a comment.

> +
> +	wdd->timeout = clamp_t(int, timeout, MIN_WDT_TIMEOUT, MAX_WDT_TIMEOUT);
> +
This is checked by the infrastructure.

> +	if (watchdog_active(wdd))
> +		return tegra_wdt_start(wdd);
> +
> +	return 0;
> +}
> +
> +static unsigned int tegra_wdt_get_timeleft(struct watchdog_device *wdd)
> +{
> +	struct tegra_wdt *wdt = watchdog_get_drvdata(wdd);
> +	u32 val;
> +	int count;
> +	int exp;
> +
> +	val = readl(wdt->wdt_regs + WDT_STS);
> +
> +	/* Current countdown (from timeout) */
> +	count = (val >> WDT_STS_COUNT_SHIFT) & WDT_STS_COUNT_MASK;
> +
> +	/* Number of expirations (we are waiting for the 4th expiration) */
> +	exp = (val >> WDT_STS_EXP_SHIFT) & WDT_STS_EXP_MASK;
> +
> +	/*
> +	 * The entire thing is divided by 4 because we are ticking down 4 times
> +	 * faster due to needing to wait for the 4th expiration.
> +	 */
> +	return (((3 - exp) * wdd->timeout) + count) / 4;
> +}
> +
> +static void tegra_wdt_ref(struct watchdog_device *wdd)
> +{
> +	struct tegra_wdt *wdt = watchdog_get_drvdata(wdd);
> +
> +	kref_get(&wdt->kref);
> +}
> +
> +static void tegra_wdt_unref(struct watchdog_device *wdd)
> +{
> +	struct tegra_wdt *wdt = watchdog_get_drvdata(wdd);
> +
> +	kref_put(&wdt->kref, tegra_wdt_release_resources);
> +}
> +
> +static const struct watchdog_info tegra_wdt_info = {
> +	.options	= WDIOF_SETTIMEOUT |
> +			  WDIOF_MAGICCLOSE |
> +			  WDIOF_KEEPALIVEPING,
> +	.firmware_version = 0,
> +	.identity	= "Tegra Watchdog",
> +};
> +
> +static struct watchdog_ops tegra_wdt_ops = {
> +	.owner = THIS_MODULE,
> +	.start = tegra_wdt_start,
> +	.stop = tegra_wdt_stop,
> +	.ping = tegra_wdt_ping,
> +	.set_timeout = tegra_wdt_set_timeout,
> +	.get_timeleft = tegra_wdt_get_timeleft,
> +	.ref = tegra_wdt_ref,
> +	.ref = tegra_wdt_unref,

I am quite at loss what the reference counting is for, but I guess
I don't have to understand it ;-).

Anyway, assigning the unref function to the ref variable definitely
doesn't make much sense.

> +};
> +
> +static int tegra_wdt_probe(struct platform_device *pdev)
> +{
> +	struct watchdog_device *wdd;
> +	struct tegra_wdt *wdt;
> +	struct resource *res;
> +	void __iomem *regs;
> +	int ret;
> +
> +	/* This is the timer base. */
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (!res) {
> +		dev_err(&pdev->dev, "incorrect resources\n");
> +		return -ENOENT;

"No such file or directory" ? -ENODEV or -EINVAL seems more appropriate.

Besides, devm_ioremap_resource() creates that same error message and
returns -EINVAL.

> +	}
> +
> +	regs = devm_ioremap_resource(&pdev->dev, res);
> +	if (IS_ERR_OR_NULL(regs)) {

Does not return NULL on error.

> +		dev_err(&pdev->dev, "unable to map registers\n");

devm_ioremap_resource() already creates an error message.
No need to repeat it.

> +		return -ENOMEM;

	return PTR_ERR(regs);

> +	}
> +
> +	/*
> +	 * Allocate our watchdog driver data, which has the
> +	 * struct watchdog_device nested within it.
> +	 */
> +	wdt = devm_kzalloc(&pdev->dev, sizeof(*wdt), GFP_KERNEL);
> +	if (!wdt) {
> +		dev_err(&pdev->dev, "out of memory\n");

The memory allocation code already dumps an error message.
No need to repeat it.

> +		return -ENOMEM;
> +	}
> +
> +	/* Initialize struct tegra_wdt. */
> +	wdt->wdt_regs = regs + WDT_BASE;
> +	wdt->tmr_regs = regs + WDT_TIMER_BASE;
> +
> +	/* Initialize struct watchdog_device. */
> +	wdd = &wdt->wdd;
> +	wdd->timeout = heartbeat;
> +	wdd->info = &tegra_wdt_info;
> +	wdd->ops = &tegra_wdt_ops;
> +	wdd->min_timeout = MIN_WDT_TIMEOUT;
> +	wdd->max_timeout = MAX_WDT_TIMEOUT;
> +
> +	watchdog_set_drvdata(wdd, wdt);
> +
> +	kref_init(&wdt->kref);
> +
> +	ret = tegra_wdt_stop(wdd);

Sure you want to stop the watchdog if it is running ?
If that is the case, chances are that it is running on purpose,
eg if the watchdog is enabled in rommon/bios.

Besides, this really defeats nowayout. Just unload the driver,
load it again, and unload it again, and the watchdog is stopped.

> +	if (ret) {

tegra_wdt_stop() always returns 0. I don't think it makes much sense
to have dummy error checking code each time you call it,


> +		dev_err(&pdev->dev,
> +			"failed to stop watchdog device\n");

much less an error message which will never be displayed
and just takes space in the code.

> +		return ret;
> +	}
> +
> +	watchdog_set_nowayout(wdd, nowayout);
> +
> +	ret = watchdog_register_device(wdd);
> +	if (ret) {
> +		dev_err(&pdev->dev,
> +			"failed to register watchdog device\n");
> +		return ret;
> +	}
> +
> +	platform_set_drvdata(pdev, wdt);
> +
> +	dev_info(&pdev->dev,
> +		 "initialized wdt %d, using timer %d\n", WDT_ID, WDT_TIMER_ID);

I don't think writing those constants into the log provides much
if any value.

> +	dev_info(&pdev->dev,
> +		 "enabled wdt %d (heartbeat = %d sec, nowayout = %d)\n",
> +		 WDT_ID, heartbeat, nowayout);
> +
Seems to me you stopped the watchdog above. Sure, it is initialized, but
I don't think you can claim that it is enabled.

> +	return 0;
> +}
> +
> +static int tegra_wdt_remove(struct platform_device *pdev)
> +{
> +	struct tegra_wdt *wdt = platform_get_drvdata(pdev);
> +	int ret;
> +
> +	ret = tegra_wdt_stop(&wdt->wdd);
> +	if (ret) {
> +		dev_err(&pdev->dev, "failed to stop watchdog %d\n", WDT_ID);
> +		return ret;
> +	}
> +
> +	watchdog_unregister_device(&wdt->wdd);
> +
> +	kref_put(&wdt->kref, tegra_wdt_release_resources);
> +
> +	dev_info(&pdev->dev, "removed wdt %d\n", WDT_ID);
> +
Same as above - %d is always 0 and doesn't provide any value.
If anything it is confising as it suggests that there might be
a wdt 1 as well. Same applies everywhere else where you refer
to wdt 0.

> +	return 0;
> +}
> +
> +#ifdef CONFIG_PM_SLEEP
> +static int tegra_wdt_runtime_suspend(struct device *dev)
> +{
> +	struct tegra_wdt *wdt = dev_get_drvdata(dev);
> +	int ret;
> +
> +	if (watchdog_active(&wdt->wdd)) {
> +		dev_info(dev, "suspend, stopping watchdog timer\n");
> +

I don't think that is worth clogging the log for.

> +		ret = tegra_wdt_stop(&wdt->wdd);
> +		if (ret) {
> +			dev_err(dev, "failed to stop watchdog %d\n", WDT_ID);
> +			return ret;
> +		}

Same as above - this error checking and the message is really quite value-free.

> +	}
> +
> +	return 0;
> +}
> +
> +static int tegra_wdt_runtime_resume(struct device *dev)
> +{
> +	struct tegra_wdt *wdt = dev_get_drvdata(dev);
> +	int ret;
> +
> +	if (watchdog_active(&wdt->wdd)) {
> +		dev_info(dev, "resume, restarting watchdog timer\n");
> +
Same here.

> +		ret = tegra_wdt_start(&wdt->wdd);
> +		if (ret) {
> +			dev_err(dev, "failed to restart watchdog %d\n", WDT_ID);
> +			return ret;
> +		}

Same here. Never happens.

> +	}
> +
> +	return 0;
> +}
> +#endif
> +
> +static const struct of_device_id tegra_wdt_of_match[] = {
> +	{ .compatible = "nvidia,tegra30-timer", },
> +	{ },
> +};
> +MODULE_DEVICE_TABLE(of, tegra_wdt_of_match);
> +
> +static const struct dev_pm_ops tegra_wdt_pm_ops = {
> +	SET_SYSTEM_SLEEP_PM_OPS(tegra_wdt_runtime_suspend,
> +				tegra_wdt_runtime_resume)
> +};
> +
> +static struct platform_driver tegra_wdt_driver = {
> +	.probe		= tegra_wdt_probe,
> +	.remove		= tegra_wdt_remove,
> +	.driver		= {
> +		.owner	= THIS_MODULE,
> +		.name	= "tegra-wdt",
> +		.pm	= &tegra_wdt_pm_ops,
> +		.of_match_table = tegra_wdt_of_match,
> +	},
> +};
> +module_platform_driver(tegra_wdt_driver);
> +
> +MODULE_AUTHOR("NVIDIA Corporation");
> +MODULE_DESCRIPTION("Tegra Watchdog Driver");
> +MODULE_LICENSE("GPL");
> +MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
>
The MISCDEV alias is not needed. We just got rid of all those.
Please don't re-introduce it.

Thanks,
Guenter



