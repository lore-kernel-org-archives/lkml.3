Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755701AbaBEUO3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:14:29 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:39387 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755467AbaBEUO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:14:26 -0500
Message-ID: <52F29B9D.2090804@wwwdotorg.org>
Date: Wed, 05 Feb 2014 13:14:21 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Andrew Chew <achew@nvidia.com>, daniel.lezcano@linaro.org,
        tglx@linutronix.de, thierry.reding@gmail.com, rob@landley.net,
        grant.likely@linaro.org, robh+dt@kernel.org, abrestic@chromium.org,
        dgreid@chromium.org, katierh@chromium.org
CC: linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-watchdog@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH v2 3/3] watchdog: Add tegra watchdog
References: <1391473055-3158-1-git-send-email-achew@nvidia.com> <1391473055-3158-4-git-send-email-achew@nvidia.com>
In-Reply-To: <1391473055-3158-4-git-send-email-achew@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/03/2014 05:17 PM, Andrew Chew wrote:
> Add a driver for the hardware watchdogs in NVIDIA Tegra SoCs (tegra30 and

s/tegra30/Tegra30/

> later).  This driver will configure one watchdog timer that will reset the
> system in the case of a watchdog timeout.
> 
> This driver binds to the nvidia,tegra30-timer device node and gets its
> register base from there.

> diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig

> +config TEGRA_WATCHDOG
> +	tristate "Tegra watchdog"
> +	depends on ARCH_TEGRA

|| COMPILE_TEST ?

> diff --git a/drivers/watchdog/tegra_wdt.c b/drivers/watchdog/tegra_wdt.c

> +static int tegra_wdt_probe(struct platform_device *pdev)

> +	/* This is the timer base. */
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (!res) {
...
> +	mem = devm_request_mem_region(&pdev->dev, res->start,
> +				      resource_size(res),
> +				      pdev->name);
> +	if (!mem) {
...
> +	regs = devm_ioremap(&pdev->dev, mem->start,
> +			    resource_size(mem));
> +	if (!regs) {
...

I forget exactly which of those, but I think at least one/some of those
don't need to be error-checked, since the later functions will detect an
error input, and return an appropriate error code, so they can be
chained together while only error-checking the final result.

> +static int tegra_wdt_remove(struct platform_device *pdev)

> +	platform_set_drvdata(pdev, NULL);

There's no need to do that; the value of drvdata is irrelevant when the
device isn't probed, so there's no need for it to be NULL.

> +static struct platform_driver tegra_wdt_driver = {
> +	.probe		= tegra_wdt_probe,
> +	.remove		= tegra_wdt_remove,
> +#ifdef CONFIG_PM
> +	.suspend	= tegra_wdt_suspend,
> +	.resume		= tegra_wdt_resume,
> +#endif

I think for suspend/resume, you'd usually set it up like:

static const struct dev_pm_ops tegra20_i2s_pm_ops = {
        SET_RUNTIME_PM_OPS(tegra20_i2s_runtime_suspend,
                           tegra20_i2s_runtime_resume, NULL)
};

static struct platform_driver tegra20_i2s_driver = {
        .driver = {
...
               .pm = &tegra20_i2s_pm_ops,
        },
...
};

> +	.driver		= {
> +		.owner	= THIS_MODULE,
> +		.name	= "tegra-wdt",
> +		.of_match_table = tegra_wdt_of_match,
> +	},
> +};
> +
> +module_platform_driver(tegra_wdt_driver);

No need for the blank line before module_platform_driver().

> +MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
> +MODULE_ALIAS("platform:tegra-wdt");

You don't need at least that second alias; everything binds to the
MODULE_DEVICE_TABLE() now with DT.
