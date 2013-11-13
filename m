Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757947Ab3KMFud (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 00:50:33 -0500
Received: from smtp-66.nebula.fi ([83.145.220.66]:46021 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751047Ab3KMFuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 00:50:25 -0500
Date: Wed, 13 Nov 2013 07:50:14 +0200
From: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
To: linux-kernel@vger.kernel.org
Cc: mturquette@linaro.org
Subject: Re: [PATCH] clk: add generic driver for fixed rate clock
Message-ID: <20131113055013.GA25452@chokladfabriken.org>
References: <1378010420-20031-1-git-send-email-stefan.kristiansson@saunalahti.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378010420-20031-1-git-send-email-stefan.kristiansson@saunalahti.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping and adding Mike Turquette to CC

On Sun, Sep 01, 2013 at 07:40:20AM +0300, Stefan Kristiansson wrote:
> This adds a simple driver with the only purpose to initialise
> the fixed rate clock.
> This is useful for systems that do not wish to use seperate init
> code for the fixed rate clock init, but rather only rely on a
> device tree description of it.
> 
> Signed-off-by: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
> ---
>  drivers/clk/Kconfig             |  8 ++++++
>  drivers/clk/Makefile            |  1 +
>  drivers/clk/clk-generic-fixed.c | 59 +++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 68 insertions(+)
>  create mode 100644 drivers/clk/clk-generic-fixed.c
> 
> diff --git a/drivers/clk/Kconfig b/drivers/clk/Kconfig
> index 51380d6..7c8ea78 100644
> --- a/drivers/clk/Kconfig
> +++ b/drivers/clk/Kconfig
> @@ -87,6 +87,14 @@ config CLK_PPC_CORENET
>  	  This adds the clock driver support for Freescale PowerPC corenet
>  	  platforms using common clock framework.
>  
> +config COMMON_CLK_GENERIC_FIXED
> +	tristate "Generic fixed rate clock driver"
> +	depends on OF
> +	---help---
> +	  Driver for systems that do not want to register their fixed rate
> +	  clocks through init code, but rather through the device tree
> +	  description.
> +
>  endmenu
>  
>  source "drivers/clk/mvebu/Kconfig"
> diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
> index 4038c2b..2d46647 100644
> --- a/drivers/clk/Makefile
> +++ b/drivers/clk/Makefile
> @@ -8,6 +8,7 @@ obj-$(CONFIG_COMMON_CLK)	+= clk-fixed-rate.o
>  obj-$(CONFIG_COMMON_CLK)	+= clk-gate.o
>  obj-$(CONFIG_COMMON_CLK)	+= clk-mux.o
>  obj-$(CONFIG_COMMON_CLK)	+= clk-composite.o
> +obj-$(CONFIG_COMMON_CLK_GENERIC_FIXED) += clk-generic-fixed.o
>  
>  # SoCs specific
>  obj-$(CONFIG_ARCH_BCM2835)	+= clk-bcm2835.o
> diff --git a/drivers/clk/clk-generic-fixed.c b/drivers/clk/clk-generic-fixed.c
> new file mode 100644
> index 0000000..85df8a8
> --- /dev/null
> +++ b/drivers/clk/clk-generic-fixed.c
> @@ -0,0 +1,59 @@
> +/*
> + * Copyright 2013 Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * Generic driver for fixed rate clock
> + */
> +#include <linux/platform_device.h>
> +#include <linux/clk-provider.h>
> +#include <linux/clk.h>
> +#include <linux/of.h>
> +#include <linux/module.h>
> +
> +static const struct of_device_id generic_fixed_clk_match[] __initconst = {
> +	{ .compatible = "fixed-clock",},
> +	{}
> +};
> +
> +static int generic_fixed_clk_probe(struct platform_device *pdev)
> +{
> +	of_fixed_clk_setup(pdev->dev.of_node);
> +
> +	return 0;
> +}
> +
> +static int generic_fixed_clk_remove(struct platform_device *pdev)
> +{
> +	of_clk_del_provider(pdev->dev.of_node);
> +
> +	return 0;
> +}
> +
> +static struct platform_driver generic_fixed_clk_driver = {
> +	.driver = {
> +		.name = "generic-fixed-clk",
> +		.owner = THIS_MODULE,
> +		.of_match_table = generic_fixed_clk_match,
> +	},
> +	.probe	= generic_fixed_clk_probe,
> +	.remove	= generic_fixed_clk_remove,
> +};
> +
> +static int __init generic_fixed_clk_init(void)
> +{
> +	return platform_driver_register(&generic_fixed_clk_driver);
> +}
> +subsys_initcall(generic_fixed_clk_init);
> +
> +static void __exit generic_fixed_exit(void)
> +{
> +	platform_driver_unregister(&generic_fixed_clk_driver);
> +}
> +module_exit(generic_fixed_exit);
> +
> +MODULE_AUTHOR("Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>");
> +MODULE_DESCRIPTION("Generic driver for fixed rate clock");
> +MODULE_LICENSE("GPL v2");
> -- 
> 1.8.1.2
> 
