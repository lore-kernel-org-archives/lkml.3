Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755469AbaISCl2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 22:41:28 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:52472 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895AbaISCl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 22:41:26 -0400
Message-ID: <541B97CD.60400@roeck-us.net>
Date: Thu, 18 Sep 2014 19:41:17 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Josh Cartwright <joshc@codeaurora.org>, Wim Van Sebroeck <wim@iguana.be>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>
CC: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Kumar Gala <galak@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH 1/3] watchdog: qcom: add support for KPSS WDT
References: <cover.1411078425.git.joshc@codeaurora.org> <32d17907ad1dfdcafe4e76f33adc2ff22631cd28.1411078425.git.joshc@codeaurora.org>
In-Reply-To: <32d17907ad1dfdcafe4e76f33adc2ff22631cd28.1411078425.git.joshc@codeaurora.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-0.7
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020202.541B97D5.009A,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.000
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: 
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 3
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/18/2014 03:26 PM, Josh Cartwright wrote:
> Add a driver for the watchdog timer block found in the Krait Processor
> Subsystem (KPSS) on the MSM8960, APQ8064, and IPQ8064.
>
> Signed-off-by: Josh Cartwright <joshc@codeaurora.org>

Hi Josh,

comments inline.

Thanks,
Guenter

> ---
>   drivers/watchdog/Kconfig    |  10 +++
>   drivers/watchdog/Makefile   |   1 +
>   drivers/watchdog/qcom-wdt.c | 145 ++++++++++++++++++++++++++++++++++++++++++++
>   3 files changed, 156 insertions(+)
>   create mode 100644 drivers/watchdog/qcom-wdt.c
>
> diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
> index 1d1330a..5ccb963 100644
> --- a/drivers/watchdog/Kconfig
> +++ b/drivers/watchdog/Kconfig
> @@ -443,6 +443,16 @@ config TEGRA_WATCHDOG
>   	  To compile this driver as a module, choose M here: the
>   	  module will be called tegra_wdt.
>
> +config QCOM_WDT
> +	bool "QCOM watchdog"
> +	depends on HAS_IOMEM
> +	depends on ARCH_QCOM
> +	select WATCHDOG_CORE
> +	help
> +	  Say Y here to include Watchdog timer support for the watchdog found
> +	  on QCOM chipsets.  Currently supported targets are the MSM8960,
> +	  APQ8064, and IPQ8064.
> +
>   # AVR32 Architecture
>
>   config AT32AP700X_WDT
> diff --git a/drivers/watchdog/Makefile b/drivers/watchdog/Makefile
> index 468c320..d645448 100644
> --- a/drivers/watchdog/Makefile
> +++ b/drivers/watchdog/Makefile
> @@ -57,6 +57,7 @@ obj-$(CONFIG_RETU_WATCHDOG) += retu_wdt.o
>   obj-$(CONFIG_BCM2835_WDT) += bcm2835_wdt.o
>   obj-$(CONFIG_MOXART_WDT) += moxart_wdt.o
>   obj-$(CONFIG_SIRFSOC_WATCHDOG) += sirfsoc_wdt.o
> +obj-$(CONFIG_QCOM_WDT) += qcom-wdt.o
>   obj-$(CONFIG_BCM_KONA_WDT) += bcm_kona_wdt.o
>   obj-$(CONFIG_TEGRA_WATCHDOG) += tegra_wdt.o
>
> diff --git a/drivers/watchdog/qcom-wdt.c b/drivers/watchdog/qcom-wdt.c
> new file mode 100644
> index 0000000..e9409f5
> --- /dev/null
> +++ b/drivers/watchdog/qcom-wdt.c
> @@ -0,0 +1,145 @@
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
> +	unsigned long		freq;
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
> +
> +	writel(0, wdt->base + WDT_EN);
> +	writel(1, wdt->base + WDT_RST);
> +	writel(wdd->timeout * wdt->freq, wdt->base + WDT_BITE_TIME);
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
> +static int qcom_watchdog_probe(struct platform_device *pdev)
> +{
> +	struct qcom_wdt *wdt;
> +	struct resource *res;
> +	u32 tmp;
> +	int ret;
> +
> +	wdt = devm_kzalloc(&pdev->dev, sizeof(*wdt), GFP_KERNEL);
> +	if (!wdt)
> +		return -ENOMEM;
> +
> +	platform_set_drvdata(pdev, wdt);
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	wdt->base = devm_ioremap_resource(&pdev->dev, res);
> +	if (IS_ERR(wdt->base))
> +		return PTR_ERR(wdt->base);
> +
> +	ret = of_property_read_u32(pdev->dev.of_node, "clock-frequency", &tmp);
> +	if (ret) {
> +		dev_err(&pdev->dev, "unable to get clock-frequency\n");
> +		return ret;
> +	}
> +

You might want to use a clock property here, and the complete sequence of
	devm_clk_get
	clk_prepare_enable
	clk_disable_unprepare
	clk_get_rate

> +	wdt->freq = tmp;
> +
> +	wdt->wdd.dev = &pdev->dev;
> +	wdt->wdd.info = &qcom_wdt_info;
> +	wdt->wdd.ops = &qcom_wdt_ops;
> +	wdt->wdd.min_timeout = 1;
> +	wdt->wdd.max_timeout = 0x10000000U / wdt->freq;

As written, wdt->freq can be 0, which results in a nice division by zero here.

> +	watchdog_init_timeout(&wdt->wdd, 0, &pdev->dev);

That leaves you with no default timeout if timeout-sec is not set in devicetree,
which if I understand the code correctly might result in an immediate reset.
Is this really what you want to happen ?

> +
> +	ret = watchdog_register_device(&wdt->wdd);
> +	if (ret) {
> +		dev_err(&pdev->dev, "failed to register watchdog\n");
> +		return ret;
> +	}
> +
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
> +	.probe	= qcom_watchdog_probe,

No remove function ?

Yes, you don't need it, because the driver can only be built into the kernel,
but there is a practical impact: It means the driver must always be built
into the kernel even if the image is supposed to be used on different systems,
some of which may not support this specific watchdog.

Sure, you might say that you don't care about images supporting more than one
hardware, but the tendency seems to be multi-target images nowadays.

> +	.driver	= {
> +		.name		= KBUILD_MODNAME,
> +		.of_match_table	= qcom_wdt_of_table,
> +	},
> +};
> +module_platform_driver(qcom_watchdog_driver);
> +
> +MODULE_DESCRIPTION("QCOM KPSS Watchdog Driver");
> +MODULE_LICENSE("GPL v2");
>

