Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757582Ab3JQQ1X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 12:27:23 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:60104 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755964Ab3JQQ1V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 12:27:21 -0400
Message-ID: <52600FE0.4090705@atmel.com>
Date: Thu, 17 Oct 2013 18:27:12 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Boris BREZILLON <b.brezillon@overkiz.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Andrew Victor <linux@maxim.org.za>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Russell King <linux@arm.linux.org.uk>,
        "Mike Turquette" <mturquette@linaro.org>, Felipe Balbi <balbi@ti.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@linaro.org>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Josh Wu <josh.wu@atmel.com>, Richard Genoud <richard.genoud@gmail.com>
CC: <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-usb@vger.kernel.org>
Subject: Re: [PATCH v4 14/17] clk: at91: add PMC smd clock
References: <1381477081-6041-1-git-send-email-b.brezillon@overkiz.com> <1381490826-14646-1-git-send-email-b.brezillon@overkiz.com>
In-Reply-To: <1381490826-14646-1-git-send-email-b.brezillon@overkiz.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10/2013 13:27, Boris BREZILLON :
> This patch adds at91 smd (Soft Modem) clock implementation using common clk
> framework.
>
> Not used by any driver right now.
>
> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

> ---
>   arch/arm/mach-at91/Kconfig |    5 ++
>   drivers/clk/at91/Makefile  |    1 +
>   drivers/clk/at91/clk-smd.c |  173 ++++++++++++++++++++++++++++++++++++++++++++
>   drivers/clk/at91/pmc.c     |    7 ++
>   drivers/clk/at91/pmc.h     |    5 ++
>   5 files changed, 191 insertions(+)
>   create mode 100644 drivers/clk/at91/clk-smd.c
>
> diff --git a/arch/arm/mach-at91/Kconfig b/arch/arm/mach-at91/Kconfig
> index b76dc4c..97033f7 100644
> --- a/arch/arm/mach-at91/Kconfig
> +++ b/arch/arm/mach-at91/Kconfig
> @@ -39,6 +39,9 @@ config AT91_SAM9G45_RESET
>   config AT91_SAM9_TIME
>   	bool
>
> +config HAVE_AT91_SMD
> +	bool
> +
>   config SOC_AT91SAM9
>   	bool
>   	select AT91_SAM9_TIME
> @@ -85,6 +88,7 @@ config SOC_SAMA5D3
>   	select HAVE_AT91_DBGU1
>   	select AT91_USE_OLD_CLK
>   	select HAVE_AT91_UTMI
> +	select HAVE_AT91_SMD
>   	select HAVE_AT91_USB_CLK
>   	help
>   	  Select this if you are using one of Atmel's SAMA5D3 family SoC.
> @@ -157,6 +161,7 @@ config SOC_AT91SAM9X5
>   	select SOC_AT91SAM9
>   	select AT91_USE_OLD_CLK
>   	select HAVE_AT91_UTMI
> +	select HAVE_AT91_SMD
>   	select HAVE_AT91_USB_CLK
>   	help
>   	  Select this if you are using one of Atmel's AT91SAM9x5 family SoC.
> diff --git a/drivers/clk/at91/Makefile b/drivers/clk/at91/Makefile
> index 61db058..0e92b71 100644
> --- a/drivers/clk/at91/Makefile
> +++ b/drivers/clk/at91/Makefile
> @@ -9,3 +9,4 @@ obj-y += clk-system.o clk-peripheral.o
>   obj-$(CONFIG_AT91_PROGRAMMABLE_CLOCKS)	+= clk-programmable.o
>   obj-$(CONFIG_HAVE_AT91_UTMI)		+= clk-utmi.o
>   obj-$(CONFIG_HAVE_AT91_USB_CLK)		+= clk-usb.o
> +obj-$(CONFIG_HAVE_AT91_SMD)		+= clk-smd.o
> diff --git a/drivers/clk/at91/clk-smd.c b/drivers/clk/at91/clk-smd.c
> new file mode 100644
> index 0000000..9f3fa39
> --- /dev/null
> +++ b/drivers/clk/at91/clk-smd.c
> @@ -0,0 +1,173 @@
> +/*
> + * drivers/clk/at91/clk-smd.c
> + *
> + *  Copyright (C) 2013 Boris BREZILLON <b.brezillon@overkiz.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + */
> +
> +#include <linux/clk-provider.h>
> +#include <linux/clkdev.h>
> +#include <linux/clk/at91_pmc.h>
> +#include <linux/of.h>
> +#include <linux/of_address.h>
> +#include <linux/io.h>
> +
> +#include "pmc.h"
> +
> +#define SMD_SOURCE_MAX		2
> +
> +#define SMD_DIV_SHIFT		8
> +#define SMD_MAX_DIV		0xf
> +
> +struct at91sam9x5_clk_smd {
> +	struct clk_hw hw;
> +	struct at91_pmc *pmc;
> +};
> +
> +#define to_at91sam9x5_clk_smd(hw) \
> +	container_of(hw, struct at91sam9x5_clk_smd, hw)
> +
> +static unsigned long at91sam9x5_clk_smd_recalc_rate(struct clk_hw *hw,
> +						    unsigned long parent_rate)
> +{
> +	u32 tmp;
> +	u8 smddiv;
> +	struct at91sam9x5_clk_smd *smd = to_at91sam9x5_clk_smd(hw);
> +	struct at91_pmc *pmc = smd->pmc;
> +
> +	tmp = pmc_read(pmc, AT91_PMC_SMD);
> +	smddiv = (tmp & AT91_PMC_SMD_DIV) >> SMD_DIV_SHIFT;
> +	return parent_rate / (smddiv + 1);
> +}
> +
> +static long at91sam9x5_clk_smd_round_rate(struct clk_hw *hw, unsigned long rate,
> +					  unsigned long *parent_rate)
> +{
> +	unsigned long div;
> +	unsigned long bestrate;
> +	unsigned long tmp;
> +
> +	if (rate >= *parent_rate)
> +		return *parent_rate;
> +
> +	div = *parent_rate / rate;
> +	if (div > SMD_MAX_DIV)
> +		return *parent_rate / (SMD_MAX_DIV + 1);
> +
> +	bestrate = *parent_rate / div;
> +	tmp = *parent_rate / (div + 1);
> +	if (bestrate - rate > rate - tmp)
> +		bestrate = tmp;
> +
> +	return bestrate;
> +}
> +
> +static int at91sam9x5_clk_smd_set_parent(struct clk_hw *hw, u8 index)
> +{
> +	u32 tmp;
> +	struct at91sam9x5_clk_smd *smd = to_at91sam9x5_clk_smd(hw);
> +	struct at91_pmc *pmc = smd->pmc;
> +
> +	if (index > 1)
> +		return -EINVAL;
> +	tmp = pmc_read(pmc, AT91_PMC_SMD) & ~AT91_PMC_SMDS;
> +	if (index)
> +		tmp |= AT91_PMC_SMDS;
> +	pmc_write(pmc, AT91_PMC_SMD, tmp);
> +	return 0;
> +}
> +
> +static u8 at91sam9x5_clk_smd_get_parent(struct clk_hw *hw)
> +{
> +	struct at91sam9x5_clk_smd *smd = to_at91sam9x5_clk_smd(hw);
> +	struct at91_pmc *pmc = smd->pmc;
> +
> +	return pmc_read(pmc, AT91_PMC_SMD) & AT91_PMC_SMDS;
> +}
> +
> +static int at91sam9x5_clk_smd_set_rate(struct clk_hw *hw, unsigned long rate,
> +				       unsigned long parent_rate)
> +{
> +	u32 tmp;
> +	struct at91sam9x5_clk_smd *smd = to_at91sam9x5_clk_smd(hw);
> +	struct at91_pmc *pmc = smd->pmc;
> +	unsigned long div = parent_rate / rate;
> +
> +	if (parent_rate % rate || div < 1 || div > (SMD_MAX_DIV + 1))
> +		return -EINVAL;
> +	tmp = pmc_read(pmc, AT91_PMC_SMD) & ~AT91_PMC_SMD_DIV;
> +	tmp |= (div - 1) << SMD_DIV_SHIFT;
> +	pmc_write(pmc, AT91_PMC_SMD, tmp);
> +
> +	return 0;
> +}
> +
> +static const struct clk_ops at91sam9x5_smd_ops = {
> +	.recalc_rate = at91sam9x5_clk_smd_recalc_rate,
> +	.round_rate = at91sam9x5_clk_smd_round_rate,
> +	.get_parent = at91sam9x5_clk_smd_get_parent,
> +	.set_parent = at91sam9x5_clk_smd_set_parent,
> +	.set_rate = at91sam9x5_clk_smd_set_rate,
> +};
> +
> +static struct clk * __init
> +at91sam9x5_clk_register_smd(struct at91_pmc *pmc, const char *name,
> +			    const char **parent_names, u8 num_parents)
> +{
> +	struct at91sam9x5_clk_smd *smd;
> +	struct clk *clk = NULL;
> +	struct clk_init_data init;
> +
> +	smd = kzalloc(sizeof(*smd), GFP_KERNEL);
> +	if (!smd)
> +		return ERR_PTR(-ENOMEM);
> +
> +	init.name = name;
> +	init.ops = &at91sam9x5_smd_ops;
> +	init.parent_names = parent_names;
> +	init.num_parents = num_parents;
> +	init.flags = CLK_SET_RATE_GATE | CLK_SET_PARENT_GATE;
> +
> +	smd->hw.init = &init;
> +	smd->pmc = pmc;
> +
> +	clk = clk_register(NULL, &smd->hw);
> +	if (IS_ERR(clk))
> +		kfree(smd);
> +
> +	return clk;
> +}
> +
> +void __init of_at91sam9x5_clk_smd_setup(struct device_node *np,
> +					struct at91_pmc *pmc)
> +{
> +	struct clk *clk;
> +	int i;
> +	int num_parents;
> +	const char *parent_names[SMD_SOURCE_MAX];
> +	const char *name = np->name;
> +
> +	num_parents = of_count_phandle_with_args(np, "clocks", "#clock-cells");
> +	if (num_parents <= 0 || num_parents >= SMD_SOURCE_MAX)
> +		return;
> +
> +	for (i = 0; i < num_parents; i++) {
> +		parent_names[i] = of_clk_get_parent_name(np, i);
> +		if (!parent_names[i])
> +			return;
> +	}
> +
> +	of_property_read_string(np, "clock-output-names", &name);
> +
> +	clk = at91sam9x5_clk_register_smd(pmc, name, parent_names,
> +					  num_parents);
> +	if (IS_ERR(clk))
> +		return;
> +
> +	of_clk_add_provider(np, of_clk_src_simple_get, clk);
> +}
> diff --git a/drivers/clk/at91/pmc.c b/drivers/clk/at91/pmc.c
> index dc0b1b6..00a4a51 100644
> --- a/drivers/clk/at91/pmc.c
> +++ b/drivers/clk/at91/pmc.c
> @@ -290,6 +290,13 @@ static const struct of_device_id pmc_clk_ids[] __initdata = {
>   		.data = of_at91sam9x5_clk_usb_setup,
>   	},
>   #endif
> +	/* SMD clock */
> +#if defined(CONFIG_HAVE_AT91_SMD)
> +	{
> +		.compatible = "atmel,at91sam9x5-clk-smd",
> +		.data = of_at91sam9x5_clk_smd_setup,
> +	},
> +#endif
>   	{ /*sentinel*/ }
>   };
>
> diff --git a/drivers/clk/at91/pmc.h b/drivers/clk/at91/pmc.h
> index eba7334..d0b8b38 100644
> --- a/drivers/clk/at91/pmc.h
> +++ b/drivers/clk/at91/pmc.h
> @@ -105,4 +105,9 @@ extern void __init of_at91sam9n12_clk_usb_setup(struct device_node *np,
>   						struct at91_pmc *pmc);
>   #endif
>
> +#if defined(CONFIG_HAVE_AT91_SMD)
> +extern void __init of_at91sam9x5_clk_smd_setup(struct device_node *np,
> +					       struct at91_pmc *pmc);
> +#endif
> +
>   #endif /* __PMC_H_ */
>


-- 
Nicolas Ferre
