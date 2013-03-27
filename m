Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756312Ab3C0Dkx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 23:40:53 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:40231 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753413Ab3C0Dkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 23:40:51 -0400
Message-ID: <51526A41.5090703@wwwdotorg.org>
Date: Tue, 26 Mar 2013 21:40:49 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Lubomir Rintel <lkundrak@v3.sk>
CC: linux-kernel@vger.kernel.org, Wim Van Sebroeck <wim@iguana.be>,
        Guenter Roeck <linux@roeck-us.net>,
        linux-rpi-kernel@lists.infradead.org, linux-watchdog@vger.kernel.org
Subject: Re: [PATCH v3] watchdog: Add Broadcom BCM2835 watchdog timer driver
References: <1364135137-26691-1-git-send-email-lkundrak@v3.sk> <1364320200-23569-1-git-send-email-lkundrak@v3.sk>
In-Reply-To: <1364320200-23569-1-git-send-email-lkundrak@v3.sk>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/26/2013 11:50 AM, Lubomir Rintel wrote:
> This adds a driver for watchdog timer hardware present on Broadcom BCM2835 SoC,
> used in Raspberry Pi and Roku 2 devices.

Since this patch defines a new DT binding, you should send it to
devicetree-discuss@lists.ozlabs.org too.

> diff --git a/drivers/watchdog/bcm2835_wdt.c b/drivers/watchdog/bcm2835_wdt.c

> +/*
> + * Watchdog driver for Broadcom BCM2835
> + *
> + * Interface to the Broadcom BCM2835 watchdog timer hardware is based on
> + * "bcm2708_wdog" driver written by Luke Diamand that was obtained from branch
> + * "rpi-3.6.y" of git://github.com/raspberrypi/linux.git

I see that the patch isn't S-o-b Luke in the downstream kernel. However,
it is S-o-b Dom Cobley (popcornmix), and they both work for Broadcom, so
I think that's OK.

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

Do you really need both of those? I would have thought just one would
have been enough.

I'd be tempted to put the platform_set_drvdata() call right after the
devm_kzalloc() of wdt, but it's not a big deal either way.
