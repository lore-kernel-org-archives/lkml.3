Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423154Ab3CWCon (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 22:44:43 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:39490 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422859Ab3CWCom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 22:44:42 -0400
Message-ID: <514D1719.501@wwwdotorg.org>
Date: Fri, 22 Mar 2013 20:44:41 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Lubomir Rintel <lkundrak@v3.sk>
CC: linux-kernel@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
        linux-rpi-kernel@lists.infradead.org
Subject: Re: [PATCH] hw_random: Add Broadcom BCM2835 RNG Driver
References: <1363956930-5717-1-git-send-email-lkundrak@v3.sk>
In-Reply-To: <1363956930-5717-1-git-send-email-lkundrak@v3.sk>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/2013 06:55 AM, Lubomir Rintel wrote:
> Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>

A commit description would be useful.

>  arch/arm/boot/dts/bcm2835.dtsi       |    5 +
>  arch/arm/configs/bcm2835_defconfig   |    3 +-
>  drivers/char/hw_random/Kconfig       |   12 +++
>  drivers/char/hw_random/Makefile      |    1 +
>  drivers/char/hw_random/bcm2835-rng.c |  137 ++++++++++++++++++++++++++++++++++

This should be split into 3 separate patches: (1) The driver itself, (2)
the change to bcm2835.dtsi, and (3) the change to bcm2835_defconfig.

Since you're adding a new device to device tree for the first time, you
should write a binding document for it; most likely
Documentation/devicetree/bindings/rng/brcm,bcm2835.txt (or perhaps
/random/ rather than /rng/?)

Is this driver based on the downstream Raspberry Pi kernel's driver? If
so, some mention of that fact would be appropriate in the commit
description, or even the git author field. I note that in the downstream
kernel, the commit which adds the RNG driver isn't signed off at all.
This probably means you need to get Dom to add his signed-off-by line
for that commit before basing your work on it. See
Documentation/SubmittingPatches for more details.

> diff --git a/drivers/char/hw_random/bcm2835-rng.c b/drivers/char/hw_random/bcm2835-rng.c

> + * Redistribution and use in source and binary forms, with or without
...
> + * ALTERNATIVELY, this software may be distributed under the terms of the
> + * GNU General Public License ("GPL") version 2, as published by the Free
> + * Software Foundation.

I am not a lawyer, but I'd be tempted to exercise that right, and
distribute this patch solely under the terms of the GPLv2, and hence
remove the other license. It's not a big deal, but it'd simplify the
licensing in the upstream kernel.

> +static int bcm2835_rng_read(struct hwrng *rng, void *buf, size_t max,
> +			       bool wait)

> +	while ((__raw_readl(rng_base + RNG_STATUS)>>24) == 0) {

You'd usually put spaces around the >>.

> +static int bcm2835_rng_probe(struct platform_device *op)

"pdev" is a more typical name than "op".

> +{
> +	struct device *dev = &op->dev;
> +	struct device_node *np = dev->of_node;
> +	void __iomem *rng_base;
> +	int err;
> +
> +	/* map peripheral */
> +	rng_base = of_iomap(np, 0);
> +	if (WARN(!rng_base, "failed to remap rng regs"))
> +		return -ENODEV;

The WARN() doesn't seem necessary. dev_err() inside the if{} would be
more appropriate,

> +static struct platform_driver bcm2835_rng_driver = {
...
> +};
> +
> +module_platform_driver(bcm2835_rng_driver);

Typically, no blank line there.

> +MODULE_AUTHOR("Lubomir Rintel <lkundrak@v3.sk>");
> +MODULE_DESCRIPTION("BCM2835 Random Number Generator (RNG) driver");
> +MODULE_LICENSE("GPL and additional rights");

I think that should be "GPLv2 and ...".
