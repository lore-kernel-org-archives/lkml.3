Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755533Ab3KLQJU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 11:09:20 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:37177 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753656Ab3KLQJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 11:09:17 -0500
Message-ID: <52825283.7000905@ti.com>
Date: Tue, 12 Nov 2013 11:08:35 -0500
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "Khoronzhuk, Ivan" <ivan.khoronzhuk@ti.com>
CC: Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Kumar Gala <galak@kernel.crashing.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "Strashko, Grygorii" <grygorii.strashko@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 07/12] memory: davinci-aemif: introduce AEMIF driver
References: <1384187188-5776-1-git-send-email-ivan.khoronzhuk@ti.com>,<1384187188-5776-8-git-send-email-ivan.khoronzhuk@ti.com> <4F5844B3A985794BA902E12C070812375F8D2E@DNCE04.ent.ti.com>
In-Reply-To: <4F5844B3A985794BA902E12C070812375F8D2E@DNCE04.ent.ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+ Greg KH (drivers/memory/* patches goes through his queue)

On Monday 11 November 2013 12:06 PM, Khoronzhuk, Ivan wrote:
> Add new AEMIF driver for EMIF16 davinci controller. The EMIF16 module
> is intended to provide a glue-less interface to a variety of
> asynchronous memory devices like ASRA M, NOR and NAND memory. A total
> of 256M bytes of any of these memories can be accessed at any given
> time via four chip selects with 64M byte access per chip select.
> 
> Synchronous memories such as DDR1 SD RAM, SDR SDRAM and Mobile SDR
> are not supported.
> 
> See http://www.ti.com/lit/ug/sprugz3a/sprugz3a.pdf
> 
> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
> ---
>  drivers/memory/Kconfig         |   11 ++
>  drivers/memory/Makefile        |    1 +
>  drivers/memory/davinci-aemif.c |  415 ++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 427 insertions(+)
>  create mode 100644 drivers/memory/davinci-aemif.c
> 
> diff --git a/drivers/memory/Kconfig b/drivers/memory/Kconfig
> index 29a11db..010e75e 100644
> --- a/drivers/memory/Kconfig
> +++ b/drivers/memory/Kconfig
> @@ -7,6 +7,17 @@ menuconfig MEMORY
> 
>  if MEMORY
> 
> +config TI_DAVINCI_AEMIF
s/TI_DAVINCI_AEMIF/TI_AEMIF

> +       bool "Texas Instruments DaVinci AEMIF driver"
Drop DaVinci above since its used on more SOCs.
> +       depends on (ARCH_DAVINCI || ARCH_KEYSTONE) && OF
> +       help
> +         This driver is for the AEMIF module available in Texas Instruments
> +         SoCs. AEMIF stands for Asynchronous External Memory Interface and
> +         is intended to provide a glue-less interface to a variety of
> +         asynchronuous memory devices like ASRAM, NOR and NAND memory. A total
> +         of 256M bytes of any of these memories can be accessed at a given
> +         time via four chip selects with 64M byte access per chip select.
> +
>  config TI_EMIF
>         tristate "Texas Instruments EMIF driver"
>         depends on ARCH_OMAP2PLUS
> diff --git a/drivers/memory/Makefile b/drivers/memory/Makefile
> index 969d923..af14126 100644
> --- a/drivers/memory/Makefile
> +++ b/drivers/memory/Makefile
> @@ -5,6 +5,7 @@
>  ifeq ($(CONFIG_DDR),y)
>  obj-$(CONFIG_OF)               += of_memory.o
>  endif
> +obj-$(CONFIG_TI_DAVINCI_AEMIF) += davinci-aemif.o

Change this accordingly once the config is renamed.

>  obj-$(CONFIG_TI_EMIF)          += emif.o
>  obj-$(CONFIG_MVEBU_DEVBUS)     += mvebu-devbus.o
>  obj-$(CONFIG_TEGRA20_MC)       += tegra20-mc.o
> diff --git a/drivers/memory/davinci-aemif.c b/drivers/memory/davinci-aemif.c
> new file mode 100644
> index 0000000..e36b74b
> --- /dev/null
> +++ b/drivers/memory/davinci-aemif.c
> @@ -0,0 +1,415 @@
> +/*
> + * DaVinci/Keystone AEMIF driver
s/{DaVinci/Keystone}/TI
> + *
> + * Copyright (C) 2010 - 2013 Texas Instruments Incorporated. http://www.ti.com/
> + * Copyright (C) Heiko Schocher <hs@denx.de>
> + * Copyright (C) Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/clk.h>
> +#include <linux/err.h>
> +#include <linux/io.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/of_platform.h>
> +#include <linux/platform_device.h>
> +
> +#define TA_SHIFT       2
> +#define RHOLD_SHIFT    4
> +#define RSTROBE_SHIFT  7
> +#define RSETUP_SHIFT   13
> +#define WHOLD_SHIFT    17
> +#define WSTROBE_SHIFT  20
> +#define WSETUP_SHIFT   26
> +#define EW_SHIFT       30
> +#define SS_SHIFT       31
> +
> +#define TA(x)          ((x) << TA_SHIFT)
> +#define RHOLD(x)       ((x) << RHOLD_SHIFT)
> +#define RSTROBE(x)     ((x) << RSTROBE_SHIFT)
> +#define RSETUP(x)      ((x) << RSETUP_SHIFT)
> +#define WHOLD(x)       ((x) << WHOLD_SHIFT)
> +#define WSTROBE(x)     ((x) << WSTROBE_SHIFT)
> +#define WSETUP(x)      ((x) << WSETUP_SHIFT)
> +#define EW(x)          ((x) << EW_SHIFT)
> +#define SS(x)          ((x) << SS_SHIFT)
> +
> +#define ASIZE_MAX      0x1
> +#define TA_MAX         0x3
> +#define RHOLD_MAX      0x7
> +#define RSTROBE_MAX    0x3f
> +#define RSETUP_MAX     0xf
> +#define WHOLD_MAX      0x7
> +#define WSTROBE_MAX    0x3f
> +#define WSETUP_MAX     0xf
> +#define EW_MAX         0x1
> +#define SS_MAX         0x1
> +#define NUM_CS         4
> +
> +#define TA_VAL(x)      (((x) & TA(TA_MAX)) >> TA_SHIFT)
> +#define RHOLD_VAL(x)   (((x) & RHOLD(RHOLD_MAX)) >> RHOLD_SHIFT)
> +#define RSTROBE_VAL(x) (((x) & RSTROBE(RSTROBE_MAX)) >> RSTROBE_SHIFT)
> +#define RSETUP_VAL(x)  (((x) & RSETUP(RSETUP_MAX)) >> RSETUP_SHIFT)
> +#define WHOLD_VAL(x)   (((x) & WHOLD(WHOLD_MAX)) >> WHOLD_SHIFT)
> +#define WSTROBE_VAL(x) (((x) & WSTROBE(WSTROBE_MAX)) >> WSTROBE_SHIFT)
> +#define WSETUP_VAL(x)  (((x) & WSETUP(WSETUP_MAX)) >> WSETUP_SHIFT)
> +#define EW_VAL(x)      (((x) & EW(EW_MAX)) >> EW_SHIFT)
> +#define SS_VAL(x)      (((x) & SS(SS_MAX)) >> SS_SHIFT)
> +
> +#define NRCSR_OFFSET   0x00
> +#define AWCCR_OFFSET   0x04
> +#define A1CR_OFFSET    0x10
> +
> +#define ACR_ASIZE_MASK 0x3
> +#define ACR_EW_MASK    BIT(30)
> +#define ACR_SS_MASK    BIT(31)
> +#define ASIZE_16BIT    1
> +
> +#define CONFIG_MASK    (TA(TA_MAX) | \
> +                               RHOLD(RHOLD_MAX) | \
> +                               RSTROBE(RSTROBE_MAX) |  \
> +                               RSETUP(RSETUP_MAX) | \
> +                               WHOLD(WHOLD_MAX) | \
> +                               WSTROBE(WSTROBE_MAX) | \
> +                               WSETUP(WSETUP_MAX) | \
> +                               EW(EW_MAX) | SS(SS_MAX) | \
> +                               ASIZE_MAX)
> +
> +#define DRV_NAME       "davinci-aemif"
s/davinci-aemif/ti-aemif
> +
> +/**
> + * structure to hold cs parameters
> + * @cs: chip-select number
> + * @wstrobe: write strobe width, ns
> + * @rstrobe: read strobe width, ns
> + * @wsetup: write setup width, ns
> + * @whold: write hold width, ns
> + * @rsetup: read setup width, ns
> + * @rhold: read hold width, ns
> + * @ta: minimum turn around time, ns
> + * @enable_ss: enable/disable select strobe mode
> + * @enable_ew: enable/disable extended wait mode
> + * @asize: width of the asynchronous device's data bus
> + */
> +struct davinci_aemif_cs_data {
> +       u8      cs;
> +       u16     wstrobe;
> +       u16     rstrobe;
> +       u8      wsetup;
> +       u8      whold;
> +       u8      rsetup;
> +       u8      rhold;
> +       u8      ta;
> +       u8      enable_ss;
> +       u8      enable_ew;
> +       u8      asize;
> +};
> +
I suggest you drop davinci prefix throughout the
driver.

[..]

> +static const struct of_device_id davinci_aemif_of_match[] = {
> +       { .compatible = "ti,davinci-aemif", },
> +       { .compatible = "ti,keystone-aemif", },
> +       { .compatible = "ti,omap-L138-aemif", },
> +       {},
> +};
Do we need three seperate compatible or "ti,aemif" should
be enough ? Are there differences which we need to handled
based on compatibles ?

> +
> +static const struct of_device_id davinci_cs_of_match[] = {
> +       { .compatible = "ti,davinci-cs", },
> +       {},
> +};
> +
> +static int davinci_aemif_probe(struct platform_device *pdev)
> +{
> +       int ret  = -ENODEV, i;
> +       struct resource *res;
> +       struct device *dev = &pdev->dev;
> +       struct device_node *np = dev->of_node;
> +
> +       if (np == NULL)
> +               return 0;
> +
> +       if (aemif) {
> +               dev_err(dev, "davinci_aemif driver is in use currently\n");
> +               return -EBUSY;
> +       }
> +
> +       aemif = devm_kzalloc(dev, sizeof(*aemif), GFP_KERNEL);
> +
Drop this extra line.

> +       if (!aemif) {
> +               dev_err(dev, "cannot allocate memory for aemif\n");
> +               return -ENOMEM;
> +       }
> +
> +       aemif->clk = devm_clk_get(dev, "aemif");
> +       if (IS_ERR(aemif->clk)) {
> +               dev_err(dev, "cannot get clock 'aemif'\n");
> +               return PTR_ERR(aemif->clk);
> +       }
> +
> +       clk_prepare_enable(aemif->clk);
> +       aemif->clk_rate = clk_get_rate(aemif->clk) / 1000;
> +
1000 divider ? Define a marco and use it to be clear.

Other than above comments patch looks fine to me.

Regards,
Santosh

