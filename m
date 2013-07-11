Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753270Ab3GKQff (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 12:35:35 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:60068 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751999Ab3GKQfd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 12:35:33 -0400
Date: Thu, 11 Jul 2013 09:35:32 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Jonas Jensen <jonas.jensen@gmail.com>
Cc: linux-watchdog@vger.kernel.org, wim@iguana.be,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org
Subject: Re: [PATCH] watchdog: Add MOXA ART watchdog driver
Message-ID: <20130711163532.GA17310@roeck-us.net>
References: <1373545786-7151-1-git-send-email-jonas.jensen@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1373545786-7151-1-git-send-email-jonas.jensen@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 11, 2013 at 02:29:46PM +0200, Jonas Jensen wrote:
> Add watchdog driver for MOXA ART SoCs.
> 
> Signed-off-by: Jonas Jensen <jonas.jensen@gmail.com>
> ---
> 
> Notes:
>     Applies to next-20130711
> 
>  drivers/watchdog/Kconfig      |  10 +++
>  drivers/watchdog/Makefile     |   1 +
>  drivers/watchdog/moxart_wdt.c | 190 ++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 201 insertions(+)
>  create mode 100644 drivers/watchdog/moxart_wdt.c
> 
> diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
> index 362085d..6883aab 100644
> --- a/drivers/watchdog/Kconfig
> +++ b/drivers/watchdog/Kconfig
> @@ -382,6 +382,16 @@ config RETU_WATCHDOG
>  	  To compile this driver as a module, choose M here: the
>  	  module will be called retu_wdt.
>  
> +config MOXART_WDT
> +	tristate "MOXART watchdog"
> +	depends on ARCH_MOXART
> +	help
> +	  Say Y here to include Watchdog timer support for the watchdog
> +	  existing on the MOXA ART SoC series platforms.
> +
> +	  To compile this driver as a module, choose M here: the
> +	  module will be called moxart_wdt.
> +
>  # AVR32 Architecture
>  
>  config AT32AP700X_WDT
> diff --git a/drivers/watchdog/Makefile b/drivers/watchdog/Makefile
> index 2f26a0b..7cab53a 100644
> --- a/drivers/watchdog/Makefile
> +++ b/drivers/watchdog/Makefile
> @@ -54,6 +54,7 @@ obj-$(CONFIG_IMX2_WDT) += imx2_wdt.o
>  obj-$(CONFIG_UX500_WATCHDOG) += ux500_wdt.o
>  obj-$(CONFIG_RETU_WATCHDOG) += retu_wdt.o
>  obj-$(CONFIG_BCM2835_WDT) += bcm2835_wdt.o
> +obj-$(CONFIG_MOXART_WDT) += moxart_wdt.o
>  
>  # AVR32 Architecture
>  obj-$(CONFIG_AT32AP700X_WDT) += at32ap700x_wdt.o
> diff --git a/drivers/watchdog/moxart_wdt.c b/drivers/watchdog/moxart_wdt.c
> new file mode 100644
> index 0000000..c6c00bf
> --- /dev/null
> +++ b/drivers/watchdog/moxart_wdt.c
> @@ -0,0 +1,190 @@
> +/*
> + * MOXA ART SoCs watchdog driver.
> + *
> + * Copyright (C) 2013 Jonas Jensen
> + *
> + * Jonas Jensen <jonas.jensen@gmail.com>
> + *
> + * This file is licensed under the terms of the GNU General Public
> + * License version 2.  This program is licensed "as is" without any
> + * warranty of any kind, whether express or implied.
> + */
> +
> +#include <linux/clk.h>
> +#include <linux/err.h>
> +#include <linux/init.h>
> +#include <linux/io.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/moduleparam.h>
> +#include <linux/of.h>
> +#include <linux/of_address.h>
> +#include <linux/platform_device.h>
> +#include <linux/types.h>
> +#include <linux/watchdog.h>
> +
> +#include <asm/system_misc.h>
> +
> +#define REG_COUNT			0x4
> +#define REG_MODE			0x8
> +#define REG_ENABLE			0xC
> +
> +struct moxart_wdt_dev {
> +	struct watchdog_device wdt_dev;
> +	void __iomem *wdt_base;
> +};
> +
> +static struct moxart_wdt_dev *moxart_wdt;
> +static bool nowayout = WATCHDOG_NOWAYOUT;
> +static int heartbeat;
> +static unsigned int clock_frequency;
> +static unsigned int max_timeout;
> +
> +static void moxart_wdt_restart(enum reboot_mode reboot_mode, const char *cmd)
> +{
> +	writel(1, moxart_wdt->wdt_base + REG_COUNT);
> +	writel(0x5ab9, moxart_wdt->wdt_base + REG_MODE);
> +	writel(0x03, moxart_wdt->wdt_base + REG_ENABLE);
> +}
> +
> +static int moxart_wdt_stop(struct watchdog_device *wdt_dev)
> +{
> +	struct moxart_wdt_dev *moxart_wdt = watchdog_get_drvdata(wdt_dev);
> +	void __iomem *wdt_base = moxart_wdt->wdt_base;
> +
> +	writel(0, wdt_base + REG_ENABLE);
> +
> +	return 0;
> +}
> +
> +static int moxart_wdt_start(struct watchdog_device *wdt_dev)
> +{
> +	struct moxart_wdt_dev *moxart_wdt = watchdog_get_drvdata(wdt_dev);
> +	void __iomem *wdt_base = moxart_wdt->wdt_base;
> +
> +	writel(clock_frequency * moxart_wdt->wdt_dev.timeout,
> +	       wdt_base + REG_COUNT);
> +	writel(0x5ab9, wdt_base + REG_MODE);
> +	writel(0x03, wdt_base + REG_ENABLE);
> +
> +	return 0;
> +}
> +
> +static int moxart_wdt_ping(struct watchdog_device *wdt_dev)
> +{
> +	moxart_wdt_start(wdt_dev);
> +	return 0;
> +}

This function is unnecessary. If it is not there, the infrastructure code will
call the start function automatically.

> +
> +static int moxart_wdt_set_timeout(struct watchdog_device *wdt_dev,
> +				  unsigned int timeout)
> +{
> +	dev_dbg(wdt_dev->dev, "%s: timeout=%u\n", __func__, timeout);
> +
> +	if (timeout > max_timeout)
> +		return -EINVAL;

Unnecessary check; handled by infrastructure.

> +
> +	moxart_wdt->wdt_dev.timeout = timeout;
> +
> +	return 0;
> +}
> +
> +static const struct watchdog_info moxart_wdt_info = {
> +	.identity       = "moxart-wdt",
> +	.options        = WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING |
> +			  WDIOF_MAGICCLOSE,
> +};
> +
> +static const struct watchdog_ops moxart_wdt_ops = {
> +	.owner          = THIS_MODULE,
> +	.start          = moxart_wdt_start,
> +	.stop           = moxart_wdt_stop,
> +	.ping           = moxart_wdt_ping,
> +	.set_timeout    = moxart_wdt_set_timeout,
> +};
> +
> +static int moxart_wdt_probe(struct platform_device *pdev)
> +{
> +	struct device *dev = &pdev->dev;
> +	struct device_node *node = dev->of_node;
> +	struct resource *res;
> +	struct clk *clk;
> +	int err;
> +
> +	moxart_wdt = devm_kzalloc(&pdev->dev, sizeof(*moxart_wdt), GFP_KERNEL);
> +	if (!moxart_wdt)
> +		return -EINVAL;
> +
> +	platform_set_drvdata(pdev, moxart_wdt);
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	moxart_wdt->wdt_base = devm_ioremap_resource(dev, res);
> +	if (IS_ERR(moxart_wdt->wdt_base))
> +		return PTR_ERR(moxart_wdt->wdt_base);
> +
> +	arm_pm_restart = moxart_wdt_restart;

It is quite unusual that system restart code is implemented in a watchdog
driver (which may not even be compiled into an image, or not be loaded).

Also, I'd like to see what happens if the driver is built as module and
unloaded before the restart. Unless I am missing something, this should result
in a nice crash.

> +
> +	clk = of_clk_get(node, 0);
> +	if (IS_ERR(clk)) {
> +		pr_err("%s: of_clk_get failed\n", __func__);
> +		return PTR_ERR(clk);

.... even more so if it fails to load for any reason.

> +	}
> +
> +	clock_frequency = clk_get_rate(clk);
> +
> +	max_timeout = UINT_MAX / clock_frequency;
> +
> +	moxart_wdt->wdt_dev.info = &moxart_wdt_info;
> +	moxart_wdt->wdt_dev.ops = &moxart_wdt_ops;
> +	moxart_wdt->wdt_dev.timeout = max_timeout;
> +	moxart_wdt->wdt_dev.min_timeout = 1;
> +	moxart_wdt->wdt_dev.max_timeout = max_timeout;
> +	moxart_wdt->wdt_dev.parent = &pdev->dev;
> +
> +	watchdog_init_timeout(&moxart_wdt->wdt_dev, heartbeat, &pdev->dev);
> +	watchdog_set_nowayout(&moxart_wdt->wdt_dev, nowayout);
> +
> +	watchdog_set_drvdata(&moxart_wdt->wdt_dev, moxart_wdt);
> +
> +	err = watchdog_register_device(&moxart_wdt->wdt_dev);
> +	if (unlikely(err))
> +		return err;
> +
> +	dev_dbg(dev, "Watchdog enabled (heartbeat=%d sec, nowayout=%d)\n",
> +		 moxart_wdt->wdt_dev.timeout, nowayout);
> +
> +	return 0;
> +}
> +
> +static int moxart_wdt_remove(struct platform_device *pdev)
> +{
> +	struct moxart_wdt_dev *moxart_wdt = platform_get_drvdata(pdev);
> +
> +	watchdog_unregister_device(&moxart_wdt->wdt_dev);
> +	watchdog_set_drvdata(&moxart_wdt->wdt_dev, NULL);

This is unnecessary.

> +
> +	return 0;
> +}
> +
> +static const struct of_device_id moxart_watchdog_match[] = {
> +	{ .compatible = "moxa,moxart-watchdog" },
> +	{ },
> +};
> +
> +static struct platform_driver moxart_wdt_driver = {
> +	.probe      = moxart_wdt_probe,
> +	.remove     = moxart_wdt_remove,
> +	.driver     = {
> +		.name		= "moxart-watchdog",
> +		.owner		= THIS_MODULE,
> +		.of_match_table	= moxart_watchdog_match,
> +	},
> +};
> +module_platform_driver(moxart_wdt_driver);
> +
> +module_param(heartbeat, int, 0);
> +MODULE_PARM_DESC(heartbeat, "Watchdog heartbeat in seconds");
> +
> +MODULE_DESCRIPTION("MOXART watchdog driver");
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Jonas Jensen <jonas.jensen@gmail.com>");
> -- 
> 1.8.2.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-watchdog" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
