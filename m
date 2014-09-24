Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510AbaIXP7D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 11:59:03 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:44805 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753401AbaIXP67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 11:58:59 -0400
Date: Wed, 24 Sep 2014 08:58:54 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Josh Cartwright <joshc@codeaurora.org>
Cc: Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Kumar Gala <galak@codeaurora.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v2 1/3] watchdog: qcom: add support for KPSS WDT
Message-ID: <20140924155854.GA12620@roeck-us.net>
References: <cover.1411513109.git.joshc@codeaurora.org>
 <8f4be0230a7fea8c299a0e878d0eb826eaba6099.1411513109.git.joshc@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8f4be0230a7fea8c299a0e878d0eb826eaba6099.1411513109.git.joshc@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 06:04:36PM -0500, Josh Cartwright wrote:
> Add a driver for the watchdog timer block found in the Krait Processor
> Subsystem (KPSS) on the MSM8960, APQ8064, and IPQ8064.
> 
> Signed-off-by: Josh Cartwright <joshc@codeaurora.org>

Hi Josh,

looks much better. Couple of comments inline.

Thanks,
Guenter

> ---
>  drivers/watchdog/Kconfig    |  13 ++++
>  drivers/watchdog/Makefile   |   1 +
>  drivers/watchdog/qcom-wdt.c | 176 ++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 190 insertions(+)
>  create mode 100644 drivers/watchdog/qcom-wdt.c
> 
> diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
> index 1d1330a..0479e3f 100644
> --- a/drivers/watchdog/Kconfig
> +++ b/drivers/watchdog/Kconfig
> @@ -443,6 +443,19 @@ config TEGRA_WATCHDOG
>  	  To compile this driver as a module, choose M here: the
>  	  module will be called tegra_wdt.
>  
> +config QCOM_WDT
> +	tristate "QCOM watchdog"
> +	depends on HAS_IOMEM
> +	depends on ARCH_QCOM
> +	select WATCHDOG_CORE
> +	help
> +	  Say Y here to include Watchdog timer support for the watchdog found
> +	  on QCOM chipsets.  Currently supported targets are the MSM8960,
> +	  APQ8064, and IPQ8064.
> +
> +	  To compile this driver as a module, choose M here: the
> +	  module will be called qcom_wdt.
> +
>  # AVR32 Architecture
>  
>  config AT32AP700X_WDT
> diff --git a/drivers/watchdog/Makefile b/drivers/watchdog/Makefile
> index 468c320..d645448 100644
> --- a/drivers/watchdog/Makefile
> +++ b/drivers/watchdog/Makefile
> @@ -57,6 +57,7 @@ obj-$(CONFIG_RETU_WATCHDOG) += retu_wdt.o
>  obj-$(CONFIG_BCM2835_WDT) += bcm2835_wdt.o
>  obj-$(CONFIG_MOXART_WDT) += moxart_wdt.o
>  obj-$(CONFIG_SIRFSOC_WATCHDOG) += sirfsoc_wdt.o
> +obj-$(CONFIG_QCOM_WDT) += qcom-wdt.o
>  obj-$(CONFIG_BCM_KONA_WDT) += bcm_kona_wdt.o
>  obj-$(CONFIG_TEGRA_WATCHDOG) += tegra_wdt.o
>  
> diff --git a/drivers/watchdog/qcom-wdt.c b/drivers/watchdog/qcom-wdt.c
> new file mode 100644
> index 0000000..d5e46e2
> --- /dev/null
> +++ b/drivers/watchdog/qcom-wdt.c
> @@ -0,0 +1,176 @@
> +/* Copyright (c) 2014, The Linux Foundation. All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 and
> + * only version 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + */
> +#include <linux/clk.h>
> +#include <linux/io.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/platform_device.h>
> +#include <linux/watchdog.h>
> +
> +#define WDT_RST		0x0
> +#define WDT_EN		0x8
> +#define WDT_BITE_TIME	0x24
> +
> +struct qcom_wdt {
> +	struct watchdog_device	wdd;
> +	struct clk		*clk;
> +	void __iomem		*base;
> +};
> +
> +static inline
> +struct qcom_wdt *to_qcom_wdt(struct watchdog_device *wdd)
> +{
> +	return container_of(wdd, struct qcom_wdt, wdd);
> +}
> +
> +static int qcom_wdt_start(struct watchdog_device *wdd)
> +{
> +	struct qcom_wdt *wdt = to_qcom_wdt(wdd);
> +	unsigned long bite_time;
> +
> +	bite_time = wdd->timeout * clk_get_rate(wdt->clk);
> +
> +	writel(0, wdt->base + WDT_EN);
> +	writel(1, wdt->base + WDT_RST);
> +	writel(bite_time, wdt->base + WDT_BITE_TIME);
> +	writel(1, wdt->base + WDT_EN);
> +	return 0;
> +}
> +
> +static int qcom_wdt_stop(struct watchdog_device *wdd)
> +{
> +	struct qcom_wdt *wdt = to_qcom_wdt(wdd);
> +
> +	writel(0, wdt->base + WDT_EN);
> +	return 0;
> +}
> +
> +static int qcom_wdt_ping(struct watchdog_device *wdd)
> +{
> +	struct qcom_wdt *wdt = to_qcom_wdt(wdd);
> +
> +	writel(1, wdt->base + WDT_RST);
> +	return 0;
> +}
> +
> +static int qcom_wdt_set_timeout(struct watchdog_device *wdd,
> +				unsigned int timeout)
> +{
> +	wdd->timeout = timeout;
> +	return qcom_wdt_start(wdd);
> +}
> +
> +static const struct watchdog_ops qcom_wdt_ops = {
> +	.start		= qcom_wdt_start,
> +	.stop		= qcom_wdt_stop,
> +	.ping		= qcom_wdt_ping,
> +	.set_timeout	= qcom_wdt_set_timeout,
> +	.owner		= THIS_MODULE,
> +};
> +
> +static const struct watchdog_info qcom_wdt_info = {
> +	.options	= WDIOF_KEEPALIVEPING
> +			| WDIOF_MAGICCLOSE
> +			| WDIOF_SETTIMEOUT,
> +	.identity	= KBUILD_MODNAME,
> +};
> +
> +static int qcom_wdt_probe(struct platform_device *pdev)
> +{
> +	struct qcom_wdt *wdt;
> +	struct resource *res;
> +	unsigned long freq;
> +	int ret;
> +
> +	wdt = devm_kzalloc(&pdev->dev, sizeof(*wdt), GFP_KERNEL);
> +	if (!wdt)
> +		return -ENOMEM;
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	wdt->base = devm_ioremap_resource(&pdev->dev, res);
> +	if (IS_ERR(wdt->base))
> +		return PTR_ERR(wdt->base);
> +
> +	wdt->clk = devm_clk_get(&pdev->dev, NULL);
> +	if (IS_ERR(wdt->clk))
> +		return PTR_ERR(wdt->clk);
> +
> +	ret = clk_prepare_enable(wdt->clk);
> +	if (ret) {
> +		dev_err(&pdev->dev, "failed to setup clock\n");
> +		return ret;
> +	}
> +
> +	/*
> +	 * We use the clock rate to calculate the max timeout, so ensure it's
> +	 * not zero to avoid a divide-by-zero exception.
> +	 */
> +	freq = clk_get_rate(wdt->clk);
> +	if (freq == 0) {
> +		dev_err(&pdev->dev, "invalid clock rate\n");
> +		return -EINVAL;
> +	}

This will need clk_disable_unprepare().

Since you are reading the frequency here, it might make sense to store it
in struct qcom_wdt so you don't have to call clk_get_rate() again in the
start function.

> +
> +	wdt->wdd.dev = &pdev->dev;
> +	wdt->wdd.info = &qcom_wdt_info;
> +	wdt->wdd.ops = &qcom_wdt_ops;
> +	wdt->wdd.min_timeout = 1;
> +	wdt->wdd.max_timeout = 0x10000000U / freq;

What if the frequency turns out to be larger than 8947848 Hz ?
Then your maximum timeout is below the default timeout.
And if the frequency is larger than 268435456 Hz, the maximum
timeout would be 0.

> +
> +	/*
> +	 * If 'timeout-sec' unspecified in devicetree, assume a 30 second
> +	 * default.
> +	 */
> +	if (watchdog_init_timeout(&wdt->wdd, 0, &pdev->dev))
> +		wdt->wdd.timeout = 30;

You can just initialize timeout above with 30 seconds. Saves you the if
statement here.

> +
> +	ret = watchdog_register_device(&wdt->wdd);
> +	if (ret) {
> +		dev_err(&pdev->dev, "failed to register watchdog\n");

This will need a clk_disable_unprepare().

Given that this is needed twice, you might want to consider using
error exit code below, as suggested in CodingStyle.

> +		return ret;
> +	}
> +
> +	platform_set_drvdata(pdev, wdt);
> +	return 0;
> +}
> +
> +static int qcom_wdt_remove(struct platform_device *pdev)
> +{
> +	struct qcom_wdt *wdt = platform_get_drvdata(pdev);
> +
> +	watchdog_unregister_device(&wdt->wdd);
> +	clk_disable_unprepare(wdt->clk);
> +	return 0;
> +}
> +
> +static const struct of_device_id qcom_wdt_of_table[] = {
> +	{ .compatible = "qcom,kpss-wdt-msm8960", },
> +	{ .compatible = "qcom,kpss-wdt-apq8064", },
> +	{ .compatible = "qcom,kpss-wdt-ipq8064", },
> +	{ },
> +};
> +MODULE_DEVICE_TABLE(of, qcom_wdt_of_table);
> +
> +static struct platform_driver qcom_watchdog_driver = {
> +	.probe	= qcom_wdt_probe,
> +	.remove	= qcom_wdt_remove,
> +	.driver	= {
> +		.name		= KBUILD_MODNAME,
> +		.of_match_table	= qcom_wdt_of_table,
> +	},
> +};
> +module_platform_driver(qcom_watchdog_driver);
> +
> +MODULE_DESCRIPTION("QCOM KPSS Watchdog Driver");
> +MODULE_LICENSE("GPL v2");
> -- 
> Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
> hosted by The Linux Foundation
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-watchdog" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
