Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754859Ab3KZHWY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 02:22:24 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:45373 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754046Ab3KZHWW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 02:22:22 -0500
Message-ID: <52944BD3.90105@ti.com>
Date: Tue, 26 Nov 2013 12:50:51 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: "Khoronzhuk, Ivan" <ivan.khoronzhuk@ti.com>,
        "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>
CC: Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "Strashko, Grygorii" <grygorii.strashko@ti.com>,
        Pawel Moll <pawel.moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@kernel.crashing.org>,
        Rob Herring <rob.herring@calxeda.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 07/12] memory: davinci-aemif: introduce AEMIF driver
References: <1384187188-5776-1-git-send-email-ivan.khoronzhuk@ti.com>, <1384187188-5776-8-git-send-email-ivan.khoronzhuk@ti.com> <4F5844B3A985794BA902E12C070812375F8D2E@DNCE04.ent.ti.com>
In-Reply-To: <4F5844B3A985794BA902E12C070812375F8D2E@DNCE04.ent.ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 11 November 2013 10:36 PM, Khoronzhuk, Ivan wrote:
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
> +       bool "Texas Instruments DaVinci AEMIF driver"

This driver cannot be a module? If not, why not?

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
> + *
> + * Copyright (C) 2010 - 2013 Texas Instruments Incorporated. http://www.ti.com/
> + * Copyright (C) Heiko Schocher <hs@denx.de>
> + * Copyright (C) Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>

Just checking: You meant Author: ? Code is already copyrighted to TI by
line above.

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
> +/**
> + * structure to hold device data
> + * @base: base address of AEMIF registers
> + * @clk: source clock
> + * @clk_rate: clock's rate in kHz
> + * @num_cs: number of assigned chip-selects
> + * @cs_data: array of chip-select settings
> + */
> +struct davinci_aemif_device {
> +       struct device *dev;
> +       void __iomem *base;
> +       struct clk *clk;
> +       unsigned long clk_rate;
> +       u8 num_cs;
> +       int cs_offset;
> +       struct davinci_aemif_cs_data cs_data[NUM_CS];
> +};
> +
> +static struct davinci_aemif_device *aemif;
> +/**
> + * davinci_aemif_calc_rate - calculate timing data.
> + * @wanted: The cycle time needed in nanoseconds.
> + * @clk: The input clock rate in kHz.
> + * @max: The maximum divider value that can be programmed.
> + *
> + * On success, returns the calculated timing value minus 1 for easy
> + * programming into AEMIF timing registers, else negative errno.
> + */
> +static int davinci_aemif_calc_rate(int wanted, unsigned long clk, int max)
> +{
> +       int result;
> +
> +       result = DIV_ROUND_UP((wanted * clk), NSEC_PER_MSEC) - 1;
> +
> +       dev_dbg(aemif->dev, "%s: result %d from %ld, %d\n", __func__, result,
> +               clk, wanted);
> +
> +       /* It is generally OK to have a more relaxed timing than requested... */
> +       if (result < 0)
> +               result = 0;
> +
> +       /* ... But configuring tighter timings is not an option. */
> +       else if (result > max)
> +               result = -EINVAL;
> +
> +       return result;
> +}
> +
> +/**
> + * davinci_aemif_config_abus - configure async bus parameters
> + * @data: aemif chip select configuration
> + *
> + * This function programs the given timing values (in real clock) into the
> + * AEMIF registers taking the AEMIF clock into account.
> + *
> + * This function does not use any locking while programming the AEMIF
> + * because it is expected that there is only one user of a given
> + * chip-select.
> + *
> + * Returns 0 on success, else negative errno.
> + */
> +static int davinci_aemif_config_abus(struct davinci_aemif_cs_data *data)
> +{
> +       int ta, rhold, rstrobe, rsetup, whold, wstrobe, wsetup;
> +       unsigned offset;
> +       u32 set, val;
> +
> +       offset = A1CR_OFFSET + (data->cs - aemif->cs_offset) * 4;
> +
> +       ta      = davinci_aemif_calc_rate(data->ta, aemif->clk_rate, TA_MAX);
> +       rhold   = davinci_aemif_calc_rate(data->rhold, aemif->clk_rate,
> +                                         RHOLD_MAX);
> +       rstrobe = davinci_aemif_calc_rate(data->rstrobe, aemif->clk_rate,
> +                                         RSTROBE_MAX);
> +       rsetup  = davinci_aemif_calc_rate(data->rsetup, aemif->clk_rate,
> +                                         RSETUP_MAX);
> +       whold   = davinci_aemif_calc_rate(data->whold, aemif->clk_rate,
> +                                         WHOLD_MAX);
> +       wstrobe = davinci_aemif_calc_rate(data->wstrobe, aemif->clk_rate,
> +                                         WSTROBE_MAX);
> +       wsetup  = davinci_aemif_calc_rate(data->wsetup, aemif->clk_rate,
> +                                         WSETUP_MAX);
> +
> +       if (ta < 0 || rhold < 0 || rstrobe < 0 || rsetup < 0 ||
> +                       whold < 0 || wstrobe < 0 || wsetup < 0) {
> +               dev_err(aemif->dev, "%s: cannot get suitable timings\n",
> +                       __func__);
> +               return -EINVAL;
> +       }
> +
> +       set = TA(ta) | RHOLD(rhold) | RSTROBE(rstrobe) | RSETUP(rsetup) |
> +               WHOLD(whold) | WSTROBE(wstrobe) | WSETUP(wsetup);
> +
> +       set |= (data->asize & ACR_ASIZE_MASK);
> +       if (data->enable_ew)
> +               set |= ACR_EW_MASK;
> +       if (data->enable_ss)
> +               set |= ACR_SS_MASK;
> +
> +       val = readl(aemif->base + offset);
> +       val &= ~CONFIG_MASK;
> +       val |= set;
> +       writel(val, aemif->base + offset);
> +
> +       return 0;
> +}
> +
> +inline int davinci_aemif_cycles_to_nsec(int val)
> +{
> +       return ((val + 1) * NSEC_PER_MSEC) / aemif->clk_rate;
> +}
> +
> +/**
> + * davinci_aemif_get_hw_params - function to read hw register values
> + * @data: ptr to cs data
> + *
> + * This function reads the defaults from the registers and update
> + * the timing values. Required for get/set commands and also for
> + * the case when driver needs to use defaults in hardware.
> + */
> +static void davinci_aemif_get_hw_params(struct davinci_aemif_cs_data *data)
> +{
> +       u32 val, offset;
> +       offset = A1CR_OFFSET + (data->cs - aemif->cs_offset) * 4;
> +
> +       val = readl(aemif->base + offset);
> +       data->ta = davinci_aemif_cycles_to_nsec(TA_VAL(val));
> +       data->rhold = davinci_aemif_cycles_to_nsec(RHOLD_VAL(val));
> +       data->rstrobe = davinci_aemif_cycles_to_nsec(RSTROBE_VAL(val));
> +       data->rsetup = davinci_aemif_cycles_to_nsec(RSETUP_VAL(val));
> +       data->whold = davinci_aemif_cycles_to_nsec(WHOLD_VAL(val));
> +       data->wstrobe = davinci_aemif_cycles_to_nsec(WSTROBE_VAL(val));
> +       data->wsetup = davinci_aemif_cycles_to_nsec(WSETUP_VAL(val));
> +       data->enable_ew = EW_VAL(val);
> +       data->enable_ss = SS_VAL(val);
> +       data->asize = val & ASIZE_MAX;
> +}
> +
> +/**
> + * of_davinci_aemif_parse_abus_config - parse CS configuration from DT
> + * @np: device node ptr
> + *
> + * This function update the emif async bus configuration based on the values
> + * configured in a cs device binding node.
> + */
> +static int of_davinci_aemif_parse_abus_config(struct device_node *np)
> +{
> +       struct davinci_aemif_cs_data *data;
> +       unsigned long cs;
> +       u32 val;
> +
> +       if (kstrtoul(np->name + 2, 10, &cs) < 0) {
> +               dev_dbg(aemif->dev, "cs name is incorrect");
> +               return -EINVAL;
> +       }
> +
> +       if (cs - aemif->cs_offset >= NUM_CS || cs < aemif->cs_offset) {
> +               dev_dbg(aemif->dev, "cs number is incorrect %lu", cs);
> +               return -EINVAL;
> +       }
> +
> +       if (aemif->num_cs >= NUM_CS) {
> +               dev_dbg(aemif->dev, "cs count is more than %d", NUM_CS);
> +               return -EINVAL;
> +       }
> +
> +       data = &aemif->cs_data[aemif->num_cs++];
> +       data->cs = cs;
> +
> +       /* read the current value in the hw register */
> +       davinci_aemif_get_hw_params(data);
> +
> +       /* override the values from device node */
> +       of_property_read_u8(np, "ti,davinci-cs-ta", &data->ta);
> +       of_property_read_u8(np, "ti,davinci-cs-rhold", &data->rhold);
> +       of_property_read_u16(np, "ti,davinci-cs-rstrobe", &data->rstrobe);
> +       of_property_read_u8(np, "ti,davinci-cs-rsetup", &data->rsetup);
> +       of_property_read_u8(np, "ti,davinci-cs-whold", &data->whold);
> +       of_property_read_u16(np, "ti,davinci-cs-wstrobe", &data->wstrobe);
> +       of_property_read_u8(np, "ti,davinci-cs-wsetup", &data->wsetup);
> +       if (!of_property_read_u32(np, "ti,bus-width", &val))
> +               if (val == 16)
> +                       data->asize = 1;
> +       data->enable_ew = of_property_read_bool(np, "ti,davinci-cs-ew");
> +       data->enable_ss = of_property_read_bool(np, "ti,davinci-cs-ss");
> +       return 0;
> +}
> +
> +static const struct of_device_id davinci_aemif_of_match[] = {
> +       { .compatible = "ti,davinci-aemif", },
> +       { .compatible = "ti,keystone-aemif", },
> +       { .compatible = "ti,omap-L138-aemif", },

Please use ti,da850-aemif instead. We dont use the omap-like paper part
number for these devices in kernel to avoid confusion with real OMAP
devices.

> +       {},
> +};
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

Why expressly prevent multiple AEMIF devices? Its entirely conceivable
to have two memories like NAND and NOR flash connect to two different
AEMIF interfaces.

> +
> +       aemif = devm_kzalloc(dev, sizeof(*aemif), GFP_KERNEL);
> +
> +       if (!aemif) {
> +               dev_err(dev, "cannot allocate memory for aemif\n");
> +               return -ENOMEM;
> +       }
> +
> +       aemif->clk = devm_clk_get(dev, "aemif");

If this is the only clock you care about, you can use NULL for
connection id.

> +       if (IS_ERR(aemif->clk)) {
> +               dev_err(dev, "cannot get clock 'aemif'\n");
> +               return PTR_ERR(aemif->clk);
> +       }
> +
> +       clk_prepare_enable(aemif->clk);
> +       aemif->clk_rate = clk_get_rate(aemif->clk) / 1000;
> +
> +       aemif->dev = dev;
> +
> +       if (of_device_is_compatible(np, "ti,omap-L138-aemif"))
> +               aemif->cs_offset = 2;
> +
> +       res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +       aemif->base = devm_ioremap_resource(dev, res);
> +       if (IS_ERR(aemif->base)) {
> +               ret = PTR_ERR(aemif->base);
> +               goto error;
> +       }
> +
> +       /*
> +        * For every controller device node, there is a cs device node that
> +        * describe the bus configuration parameters. This functions iterate
> +        * over these nodes and update the cs data array.
> +        */
> +       for_each_matching_node(np, of_match_ptr(davinci_cs_of_match)) {
> +               ret = of_davinci_aemif_parse_abus_config(np);
> +               if (ret < 0)
> +                       goto error;
> +       }
> +
> +       for (i = 0; i < aemif->num_cs; i++) {
> +               ret = davinci_aemif_config_abus(&aemif->cs_data[i]);
> +               if (ret < 0) {
> +                       dev_err(dev, "Error configuring chip select %d\n",
> +                               aemif->cs_data[i].cs);
> +                       goto error;
> +               }
> +       }
> +
> +       /*
> +        * Create a child devices explicitly from here to
> +        * guarantee that the child will be probed after the AEMIF timing
> +        * parameters are set.
> +        */
> +       for_each_matching_node(np, of_match_ptr(davinci_cs_of_match)) {
> +               ret = of_platform_populate(np, NULL, NULL, dev);
> +               if (ret < 0)
> +                       goto error;
> +       }
> +
> +       return 0;
> +error:
> +       clk_disable_unprepare(aemif->clk);
> +       return ret;
> +}
> +
> +static int davinci_aemif_remove(struct platform_device *pdev)
> +{
> +       clk_disable_unprepare(aemif->clk);
> +       return 0;
> +}
> +
> +static struct platform_driver davinci_aemif_driver = {
> +       .probe = davinci_aemif_probe,
> +       .remove = davinci_aemif_remove,
> +       .driver = {
> +               .name = DRV_NAME,
> +               .owner = THIS_MODULE,
> +               .of_match_table = of_match_ptr(davinci_aemif_of_match),
> +       },
> +};
> +
> +module_platform_driver(davinci_aemif_driver);
> +
> +MODULE_AUTHOR("Murali Karicheri <m-karicheri2@ti.com>");

Is this correct? If yes, I would have expected him to sign-off on the
patch too. If not, please drop this.

Thanks,
Sekhar
