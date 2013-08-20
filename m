Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752133Ab3HTU77 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 16:59:59 -0400
Received: from ns1.pc-advies.be ([83.149.101.17]:58354 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751575Ab3HTU7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 16:59:55 -0400
X-Greylist: delayed 1726 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 Aug 2013 16:59:54 EDT
Date: Tue, 20 Aug 2013 22:31:03 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Ian Lartey <ian@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-leds@vger.kernel.org,
        linux-watchdog@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        swarren@wwwdotorg.org, grant.likely@secretlab.ca,
        broonie@opensource.wolfsonmicro.com, rob.herring@calxeda.com,
        rob@landley.net, mturquette@linaro.org, linus.walleij@linaro.org,
        cooloney@gmail.com, sfr@canb.auug.org.au, rpurdie@rpsys.net,
        akpm@linux-foundation.org, sameo@linux.intel.com, lgirdwood@gmail.com,
        gg@slimlogic.co.uk, j-keerthy@ti.com, ldewangan@nvidia.com,
        t-kristo@ti.com
Subject: Re: [PATCH v10 04/12] watchdog: add Palmas Watchdog support
Message-ID: <20130820203103.GA20762@spo001.leaseweb.com>
References: <1363964122-19201-1-git-send-email-ian@slimlogic.co.uk> <1363964122-19201-5-git-send-email-ian@slimlogic.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363964122-19201-5-git-send-email-ian@slimlogic.co.uk>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ian,

> +static int palmas_wdt_set_timeout(struct watchdog_device *wdt, unsigned timeout)
> +{
> +	struct palmas_wdt *driver_data = watchdog_get_drvdata(wdt);
> +
> +	if (timeout < 1 || timeout > 128) {
> +		dev_warn(driver_data->dev,
> +			"Timeout can only be in the range [1-128] seconds");
> +		return -EINVAL;
> +	}
> +	driver_data->timer_margin = fls(timeout) - 1;
> +	return 0;
> +}

The core can test this also with the .min_timeout and .max_timeout fields of the watchdog_device.

> +
> +static const struct watchdog_info palmas_wdt_info = {
> +	.options = WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING | WDIOF_MAGICCLOSE,
> +	.identity = "Palmas Watchdog",
> +	.firmware_version = 0,
> +};
> +
> +static const struct watchdog_ops palmas_wdt_ops = {
> +	.owner = THIS_MODULE,
> +	.start = palmas_wdt_enable,
> +	.stop = palmas_wdt_disable,
> +	.ping = palmas_wdt_enable,

Since .ping is the same as .start you don't need to add .ping .

> +	.set_timeout = palmas_wdt_set_timeout,
> +};
> +
> +static int palmas_wdt_probe(struct platform_device *pdev)
> +{
> +	struct palmas *palmas = dev_get_drvdata(pdev->dev.parent);
> +	struct palmas_wdt *driver_data;
> +	struct watchdog_device *palmas_wdt;
> +	int ret = 0;
> +
> +	driver_data = devm_kzalloc(&pdev->dev, sizeof(*driver_data),
> +				   GFP_KERNEL);
> +	if (!driver_data) {
> +		dev_err(&pdev->dev, "Unable to alloacate watchdog device\n");
> +		ret = -ENOMEM;
> +		goto err;
> +	}
> +
> +	driver_data->palmas = palmas;
> +
> +	palmas_wdt = &driver_data->wdt;
> +
> +	palmas_wdt->info = &palmas_wdt_info;
> +	palmas_wdt->ops = &palmas_wdt_ops;
> +	watchdog_set_nowayout(palmas_wdt, nowayout);
> +	watchdog_set_drvdata(palmas_wdt, driver_data);


I think you want a watchdog_init_timeout(struct watchdog_device *wdd, unsigned int timeout_parm, struct device *dev); here.
And also make sure that the watchdog isn't running.

> +
> +	ret = watchdog_register_device(&driver_data->wdt);
> +	if (ret) {
> +		platform_set_drvdata(pdev, NULL);
> +		goto err;
> +	}
> +
> +	dev_set_drvdata(&pdev->dev, driver_data);
> +
> +	return 0;
> +err:
> +	return ret;
> +}
> +
> +static int palmas_wdt_remove(struct platform_device *pdev)
> +{
> +	struct palmas_wdt *driver_data = dev_get_drvdata(&pdev->dev);
> +
> +	watchdog_unregister_device(&driver_data->wdt);
> +
> +	return 0;
> +}
> +
> +static struct of_device_id of_palmas_match_tbl[] = {
> +	{ .compatible = "ti,palmas-wdt", },
> +	{ .compatible = "ti,twl6035-wdt", },
> +	{ .compatible = "ti,twl6036-wdt", },
> +	{ .compatible = "ti,twl6037-wdt", },
> +	{ .compatible = "ti,tps65913-wdt", },
> +	{ .compatible = "ti,tps65914-wdt", },
> +	{ .compatible = "ti,tps80036-wdt", },
> +	{ /* end */ }
> +};
> +
> +static struct platform_driver palmas_wdt_driver = {
> +	.probe = palmas_wdt_probe,
> +	.remove = palmas_wdt_remove,
> +	.driver = {
> +		.owner = THIS_MODULE,
> +		.of_match_table = of_palmas_match_tbl,
> +		.name = "palmas-wdt",
> +	},
> +};
> +
> +module_platform_driver(palmas_wdt_driver);
> +
> +MODULE_AUTHOR("Graeme Gregory <gg@slimlogic.co.uk>");
> +MODULE_LICENSE("GPL");
> +MODULE_ALIAS("platform:palmas-wdt");
> +MODULE_DEVICE_TABLE(of, of_palmas_match_tbl);
> -- 
> 1.7.0.4
> 

If you can add the devicetree bindings Documentation and the Kconfig patch together with the revised version of this patch into a single patch then we can complete the review.

Kind regards,
Wim.

