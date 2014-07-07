Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751258AbaGGTYn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 15:24:43 -0400
Received: from 2.mo5.mail-out.ovh.net ([178.33.109.111]:55108 "EHLO
	mo5.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750976AbaGGTYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 15:24:42 -0400
X-Greylist: delayed 2872 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 Jul 2014 15:24:41 EDT
Date: Mon, 7 Jul 2014 20:33:40 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/5] memory: add a driver for atmel ram controllers
Message-ID: <20140707183340.GG9558@ns203013.ovh.net>
References: <1404746355-19988-1-git-send-email-alexandre.belloni@free-electrons.com>
 <1404746355-19988-2-git-send-email-alexandre.belloni@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404746355-19988-2-git-send-email-alexandre.belloni@free-electrons.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Ovh-Tracer-Id: 16689214320941443987
X-Ovh-Remote: 91.121.171.124 (ns203013.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejfedrvddtucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejfedrvddtucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17:19 Mon 07 Jul     , Alexandre Belloni wrote:
> 
> Atmel SoCs have one or multiple RAM controllers that need one or multiple clocks
> to run.
> This driver handle those clocks.
> 
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> ---
>  .../devicetree/bindings/arm/atmel-at91.txt         |  1 +
>  drivers/memory/Kconfig                             |  8 ++
>  drivers/memory/Makefile                            |  1 +
>  drivers/memory/atmel-ramc.c                        | 96 ++++++++++++++++++++++
>  4 files changed, 106 insertions(+)
>  create mode 100644 drivers/memory/atmel-ramc.c
> 
> diff --git a/Documentation/devicetree/bindings/arm/atmel-at91.txt b/Documentation/devicetree/bindings/arm/atmel-at91.txt
> index 16f60b41c147..54dc3aefb12a 100644
> --- a/Documentation/devicetree/bindings/arm/atmel-at91.txt
> +++ b/Documentation/devicetree/bindings/arm/atmel-at91.txt
> @@ -61,6 +61,7 @@ RAMC SDRAM/DDR Controller required properties:
>  - compatible: Should be "atmel,at91rm9200-sdramc",
>  			"atmel,at91sam9260-sdramc",
>  			"atmel,at91sam9g45-ddramc",
> +			"atmel,sama5d3-mpddramc",
>  - reg: Should contain registers location and length
>    For at91sam9263 and at91sam9g45 you must specify 2 entries.
>  
> diff --git a/drivers/memory/Kconfig b/drivers/memory/Kconfig
> index c59e9c96e86d..e49b9caa1b30 100644
> --- a/drivers/memory/Kconfig
> +++ b/drivers/memory/Kconfig
> @@ -7,6 +7,14 @@ menuconfig MEMORY
>  
>  if MEMORY
>  
> +config ATMEL_RAMC
> +	bool "Atmel (Multi-port DDR-)SDRAM Controller"
> +	default y
> +	depends on ARCH_AT91 && OF
> +	help
> +	  This driver is for Atmel SDRAM Controller or Atmel Multi-port
> +	  DDR-SDRAM Controller available on Atmel AT91SAM9 and SAMA5 SoCs
> +
>  config TI_AEMIF
>  	tristate "Texas Instruments AEMIF driver"
>  	depends on (ARCH_DAVINCI || ARCH_KEYSTONE) && OF
> diff --git a/drivers/memory/Makefile b/drivers/memory/Makefile
> index 71160a2b7313..eb5d7716efa4 100644
> --- a/drivers/memory/Makefile
> +++ b/drivers/memory/Makefile
> @@ -5,6 +5,7 @@
>  ifeq ($(CONFIG_DDR),y)
>  obj-$(CONFIG_OF)		+= of_memory.o
>  endif
> +obj-$(CONFIG_ATMEL_RAMC)	+= atmel-ramc.o
>  obj-$(CONFIG_TI_AEMIF)		+= ti-aemif.o
>  obj-$(CONFIG_TI_EMIF)		+= emif.o
>  obj-$(CONFIG_FSL_IFC)		+= fsl_ifc.o
> diff --git a/drivers/memory/atmel-ramc.c b/drivers/memory/atmel-ramc.c
> new file mode 100644
> index 000000000000..1d12d3d01cbd
> --- /dev/null
> +++ b/drivers/memory/atmel-ramc.c
> @@ -0,0 +1,96 @@
> +/*
> + * Atmel (Multi-port DDR-)SDRAM Controller driver
> + *
> + * Copyright (C) 2014 Atmel
> + *
> + * This program is free software: you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation version 2 of the License.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program.  If not, see <http://www.gnu.org/licenses/>.
> + *
> + */
> +
> +#include <linux/clk.h>
> +#include <linux/err.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/of_platform.h>
> +#include <linux/platform_device.h>
> +
> +struct at91_ramc_caps {
> +	bool has_ddrck;
> +	bool has_mpddr_clk;
> +};
> +
> +static const struct at91_ramc_caps at91rm9200_caps = { };
> +
> +static const struct at91_ramc_caps at91sam9g45_caps = {
> +	.has_ddrck = 1,
> +	.has_mpddr_clk = 0,
> +};
> +
> +static const struct at91_ramc_caps sama5d3_caps = {
> +	.has_ddrck = 1,
> +	.has_mpddr_clk = 1,
> +};
> +
> +static const struct of_device_id atmel_ramc_of_match[] = {
> +	{ .compatible = "atmel,at91rm9200-sdramc", .data = &at91rm9200_caps, },
> +	{ .compatible = "atmel,at91sam9260-sdramc", .data = &at91rm9200_caps, },
> +	{ .compatible = "atmel,at91sam9g45-ddramc", .data = &at91sam9g45_caps, },
> +	{ .compatible = "atmel,sama5d3-mpddramc", .data = &sama5d3_caps, },
> +	{},
> +};
> +MODULE_DEVICE_TABLE(of, atmel_ramc_of_match);
> +
> +static int atmel_ramc_probe(struct platform_device *pdev)
> +{
> +	const struct of_device_id *match;
> +	const struct at91_ramc_caps *caps;
> +	struct clk *clk;
> +
> +	match = of_match_device(atmel_ramc_of_match, &pdev->dev);
> +	caps = match->data;
> +
> +	if (caps->has_ddrck) {
> +		clk = devm_clk_get(&pdev->dev, "ddrck");
> +		if (IS_ERR(clk))
> +			return PTR_ERR(clk);
> +		clk_prepare_enable(clk);
> +	}
> +
> +	if (caps->has_mpddr_clk) {
> +		clk = devm_clk_get(&pdev->dev, "mpddr");
> +		if (WARN_ON(IS_ERR(clk)))
> +			return 0;
		I don't like this warn_on this need to be an error
> +		clk_prepare_enable(clk);
> +	}
> +
> +	return 0;
> +}
> +
> +static struct platform_driver atmel_ramc_driver = {
> +	.probe		= atmel_ramc_probe,
> +	.driver		= {
> +		.name	= "atmel-ramc",
> +		.owner	= THIS_MODULE,
> +		.of_match_table = atmel_ramc_of_match,
> +	},
> +};
> +
> +static int __init atmel_ramc_init(void)
> +{
> +	return platform_driver_register(&atmel_ramc_driver);
> +}
> +module_init(atmel_ramc_init);
> +
> +MODULE_LICENSE("GPL v2");
> +MODULE_AUTHOR("Alexandre Belloni <alexandre.belloni@free-electrons.com>");
> +MODULE_DESCRIPTION("Atmel (Multi-port DDR-)SDRAM Controller");
> -- 
> 1.9.1
> 
