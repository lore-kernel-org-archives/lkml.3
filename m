Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751573Ab3HBLmh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 07:42:37 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:63629 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750848Ab3HBLmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 07:42:35 -0400
Date: Fri, 2 Aug 2013 12:41:59 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Jonas Jensen <jonas.jensen@gmail.com>
Cc: "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "wim@iguana.be" <wim@iguana.be>, "arm@kernel.org" <arm@kernel.org>,
        "linux@roeck-us.net" <linux@roeck-us.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v7] watchdog: Add MOXA ART watchdog driver
Message-ID: <20130802114159.GK2884@e106331-lin.cambridge.arm.com>
References: <1375098093-8975-1-git-send-email-jonas.jensen@gmail.com>
 <1375101228-10930-1-git-send-email-jonas.jensen@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375101228-10930-1-git-send-email-jonas.jensen@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 29, 2013 at 01:33:48PM +0100, Jonas Jensen wrote:
> Add watchdog driver for MOXA ART SoCs.
> 

It would be nice to have a fuller description here.

> Signed-off-by: Jonas Jensen <jonas.jensen@gmail.com>
> ---
> 
> Notes:
>     Changes since v6:
>     
>     1. use local struct device *dev pointer, replace "&pdev->dev" with "dev"
>     
>     Applies to next-20130729
> 
>  .../bindings/watchdog/moxa,moxart-watchdog.txt     |  15 ++
>  drivers/watchdog/Kconfig                           |  10 ++
>  drivers/watchdog/Makefile                          |   1 +
>  drivers/watchdog/moxart_wdt.c                      | 165 +++++++++++++++++++++
>  4 files changed, 191 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/watchdog/moxa,moxart-watchdog.txt
>  create mode 100644 drivers/watchdog/moxart_wdt.c
> 
> diff --git a/Documentation/devicetree/bindings/watchdog/moxa,moxart-watchdog.txt b/Documentation/devicetree/bindings/watchdog/moxa,moxart-watchdog.txt
> new file mode 100644
> index 0000000..1169857
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/watchdog/moxa,moxart-watchdog.txt
> @@ -0,0 +1,15 @@
> +MOXA ART Watchdog timer
> +
> +Required properties:
> +
> +- compatible : Must be "moxa,moxart-watchdog"
> +- reg : Should contain registers location and length
> +- clocks : Should contain phandle for the clock that drives the counter
> +
> +Example:
> +
> +	watchdog: watchdog@98500000 {
> +		compatible = "moxa,moxart-watchdog";
> +		reg = <0x98500000 0x10>;
> +		clocks = <&coreclk>;
> +	};

This seems sensible to me. I assume the watchdog is a standalone unit,
and not part of some larger piece of IP?

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
> index 0000000..48dc334
> --- /dev/null
> +++ b/drivers/watchdog/moxart_wdt.c
> @@ -0,0 +1,165 @@
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
> +#include <linux/err.h>
> +#include <linux/kernel.h>
> +#include <linux/platform_device.h>
> +#include <linux/watchdog.h>
> +#include <linux/moduleparam.h>
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
> +	writel(moxart_wdt->clock_frequency * wdt_dev->timeout,
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
> +	wdt_dev->timeout = timeout;
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
> +	moxart_wdt = devm_kzalloc(dev, sizeof(*moxart_wdt), GFP_KERNEL);
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
> +	moxart_wdt->dev.parent = dev;
> +
> +	watchdog_init_timeout(&moxart_wdt->dev, heartbeat, dev);
> +	watchdog_set_nowayout(&moxart_wdt->dev, nowayout);
> +
> +	watchdog_set_drvdata(&moxart_wdt->dev, moxart_wdt);
> +
> +	err = watchdog_register_device(&moxart_wdt->dev);
> +	if (unlikely(err))
> +		return err;

This is a probe path. Is the use of unlikely() really appropriate here?
I suspect it doesn't make any appreciable difference, and should go.

> +
> +	dev_dbg(dev, "Watchdog enabled (heartbeat=%d sec, nowayout=%d)\n",
> +		moxart_wdt->dev.timeout, nowayout);
> +
> +	return 0;
> +}

Thanks,
Mark.
