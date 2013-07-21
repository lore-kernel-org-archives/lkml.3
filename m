Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753637Ab3GUHdb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jul 2013 03:33:31 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:44434 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753420Ab3GUHd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jul 2013 03:33:29 -0400
Date: Sun, 21 Jul 2013 00:33:36 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Jonas Jensen <jonas.jensen@gmail.com>
Cc: linux-watchdog@vger.kernel.org, wim@iguana.be,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org
Subject: Re: [PATCH v4] watchdog: Add MOXA ART watchdog driver
Message-ID: <20130721073336.GA26485@roeck-us.net>
References: <1374053091-5907-1-git-send-email-jonas.jensen@gmail.com>
 <1374229402-20432-1-git-send-email-jonas.jensen@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374229402-20432-1-git-send-email-jonas.jensen@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 19, 2013 at 12:23:22PM +0200, Jonas Jensen wrote:
> Add watchdog driver for MOXA ART SoCs.
> 
> Signed-off-by: Jonas Jensen <jonas.jensen@gmail.com>
> ---
> 
> Notes:
>     v4 should fix remaining issues pointed out by Guenter.
>     
>     Changes since v3:
>     
>     1. remove unnecessary header includes:
>        linux/of.h
>        linux/of_address.h
>        linux/err.h
>        linux/init.h
>        linux/kernel.h,
>        linux/moduleparam.h
>        linux/types.h
>        asm/system_misc.h

Seems you removed too many, but I'll need to have a closer look.
General guideline: If a definition from an include file is used, it must be
included. You can not depend on an include file being included from another
include file.

Thanks,
Guenter

>     2. move clock_frequency to moxart_wdt_dev
>     3. remove local pointer "void __iomem *wdt_base" use moxart_wdt->base instead
>     4. get clock_frequency from watchdog_get_drvdata
>     5. move max_timeout variable to moxart_wdt_probe
>     6. check for division by zero moxart_wdt->clock_frequency
>     7. if devm_kzalloc fails, return -ENOMEM instead of -EINVAL
>     
>     Applies to next-20130716
> 
>  .../bindings/watchdog/moxa,moxart-watchdog.txt     |  15 ++
>  drivers/watchdog/Kconfig                           |  10 ++
>  drivers/watchdog/Makefile                          |   1 +
>  drivers/watchdog/moxart_wdt.c                      | 166 +++++++++++++++++++++
>  4 files changed, 192 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/watchdog/moxa,moxart-watchdog.txt
>  create mode 100644 drivers/watchdog/moxart_wdt.c
> 
> diff --git a/Documentation/devicetree/bindings/watchdog/moxa,moxart-watchdog.txt b/Documentation/devicetree/bindings/watchdog/moxa,moxart-watchdog.txt
> new file mode 100644
> index 0000000..5507f2b
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/watchdog/moxa,moxart-watchdog.txt
> @@ -0,0 +1,15 @@
> +MOXA ART Watchdog timer
> +
> +Required properties:
> +
> +- compatible : Should be "moxa,moxart-watchdog"
> +- reg : Should contain registers location and length
> +- clocks : Should contain phandle for the MOXA ART core clock "coreclk"
> +
> +Example:
> +
> +	watchdog: watchdog@98500000 {
> +		compatible = "moxa,moxart-watchdog";
> +		reg = <0x98500000 0x10>;
> +		clocks = <&coreclk>;
> +	};
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
> index 0000000..9a59c3d
> --- /dev/null
> +++ b/drivers/watchdog/moxart_wdt.c
> @@ -0,0 +1,166 @@
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
> +#include <linux/io.h>
> +#include <linux/module.h>
> +#include <linux/platform_device.h>
> +#include <linux/watchdog.h>
> +
> +#define REG_COUNT			0x4
> +#define REG_MODE			0x8
> +#define REG_ENABLE			0xC
> +
> +struct moxart_wdt_dev {
> +	struct watchdog_device dev;
> +	void __iomem *base;
> +	unsigned int clock_frequency;
> +};
> +
> +static int heartbeat;
> +
> +static int moxart_wdt_stop(struct watchdog_device *wdt_dev)
> +{
> +	struct moxart_wdt_dev *moxart_wdt = watchdog_get_drvdata(wdt_dev);
> +
> +	writel(0, moxart_wdt->base + REG_ENABLE);
> +
> +	return 0;
> +}
> +
> +static int moxart_wdt_start(struct watchdog_device *wdt_dev)
> +{
> +	struct moxart_wdt_dev *moxart_wdt = watchdog_get_drvdata(wdt_dev);
> +
> +	writel(moxart_wdt->clock_frequency * moxart_wdt->dev.timeout,
> +	       moxart_wdt->base + REG_COUNT);
> +	writel(0x5ab9, moxart_wdt->base + REG_MODE);
> +	writel(0x03, moxart_wdt->base + REG_ENABLE);
> +
> +	return 0;
> +}
> +
> +static int moxart_wdt_set_timeout(struct watchdog_device *wdt_dev,
> +				  unsigned int timeout)
> +{
> +	struct moxart_wdt_dev *moxart_wdt = watchdog_get_drvdata(wdt_dev);
> +
> +	dev_dbg(wdt_dev->dev, "%s: timeout=%u\n", __func__, timeout);
> +
> +	moxart_wdt->dev.timeout = timeout;
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
> +	.set_timeout    = moxart_wdt_set_timeout,
> +};
> +
> +static int moxart_wdt_probe(struct platform_device *pdev)
> +{
> +	struct moxart_wdt_dev *moxart_wdt;
> +	struct device *dev = &pdev->dev;
> +	struct device_node *node = dev->of_node;
> +	struct resource *res;
> +	struct clk *clk;
> +	int err;
> +	unsigned int max_timeout;
> +	bool nowayout = WATCHDOG_NOWAYOUT;
> +
> +	moxart_wdt = devm_kzalloc(&pdev->dev, sizeof(*moxart_wdt), GFP_KERNEL);
> +	if (!moxart_wdt)
> +		return -ENOMEM;
> +
> +	platform_set_drvdata(pdev, moxart_wdt);
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	moxart_wdt->base = devm_ioremap_resource(dev, res);
> +	if (IS_ERR(moxart_wdt->base))
> +		return PTR_ERR(moxart_wdt->base);
> +
> +	clk = of_clk_get(node, 0);
> +	if (IS_ERR(clk)) {
> +		pr_err("%s: of_clk_get failed\n", __func__);
> +		return PTR_ERR(clk);
> +	}
> +
> +	moxart_wdt->clock_frequency = clk_get_rate(clk);
> +	if (moxart_wdt->clock_frequency == 0) {
> +		pr_err("%s: incorrect clock frequency\n", __func__);
> +		return -EINVAL;
> +	}
> +
> +	max_timeout = UINT_MAX / moxart_wdt->clock_frequency;
> +
> +	moxart_wdt->dev.info = &moxart_wdt_info;
> +	moxart_wdt->dev.ops = &moxart_wdt_ops;
> +	moxart_wdt->dev.timeout = max_timeout;
> +	moxart_wdt->dev.min_timeout = 1;
> +	moxart_wdt->dev.max_timeout = max_timeout;
> +	moxart_wdt->dev.parent = &pdev->dev;
> +
> +	watchdog_init_timeout(&moxart_wdt->dev, heartbeat, &pdev->dev);
> +	watchdog_set_nowayout(&moxart_wdt->dev, nowayout);
> +
> +	watchdog_set_drvdata(&moxart_wdt->dev, moxart_wdt);
> +
> +	err = watchdog_register_device(&moxart_wdt->dev);
> +	if (unlikely(err))
> +		return err;
> +
> +	dev_dbg(dev, "Watchdog enabled (heartbeat=%d sec, nowayout=%d)\n",
> +		moxart_wdt->dev.timeout, nowayout);
> +
> +	return 0;
> +}
> +
> +static int moxart_wdt_remove(struct platform_device *pdev)
> +{
> +	struct moxart_wdt_dev *moxart_wdt = platform_get_drvdata(pdev);
> +
> +	moxart_wdt_stop(&moxart_wdt->dev);
> +	watchdog_unregister_device(&moxart_wdt->dev);
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
> 
