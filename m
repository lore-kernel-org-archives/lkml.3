Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755899Ab3JHPnR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 11:43:17 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:58110 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755105Ab3JHPnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 11:43:13 -0400
Message-ID: <5254280B.6050705@atmel.com>
Date: Tue, 8 Oct 2013 17:43:07 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Boris BREZILLON <b.brezillon@overkiz.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Andrew Victor <linux@maxim.org.za>,
        "Jean-Christophe Plagniol-Villard" <plagnioj@jcrosoft.com>,
        Russell King <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@linaro.org>, "Felipe Balbi" <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Josh Wu <josh.wu@atmel.com>, Richard Genoud <richard.genoud@gmail.com>
CC: <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 11/19] clk: at91: add PMC peripheral clocks
References: <1375937608-3773-1-git-send-email-b.brezillon@overkiz.com> <1375942611-9048-1-git-send-email-b.brezillon@overkiz.com>
In-Reply-To: <1375942611-9048-1-git-send-email-b.brezillon@overkiz.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/08/2013 08:16, Boris BREZILLON :
> This patch adds new at91 peripheral clock implementation using common clk
> framework.
>
> Almost all peripherals provided by at91 SoCs need a clock to work properly.
> This clock is enabled/disabled using PCER/PCDR resgisters.
>
> Each peripheral is given an id (see atmel's datasheets) which is used to
> define and reference peripheral clocks.
>
> Some new SoCs (at91sam9x5 and sama5d3) provide a new register (PCR) where you
> can configure the peripheral clock as a division of the master clock.
> This will help reducing the peripherals power comsumption.
>
> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
> ---
>   drivers/clk/at91/Makefile         |    2 +-
>   drivers/clk/at91/clk-peripheral.c |  401 +++++++++++++++++++++++++++++++++++++
>   drivers/clk/at91/pmc.c            |    9 +
>   drivers/clk/at91/pmc.h            |    5 +
>   4 files changed, 416 insertions(+), 1 deletion(-)
>   create mode 100644 drivers/clk/at91/clk-peripheral.c
>
> diff --git a/drivers/clk/at91/Makefile b/drivers/clk/at91/Makefile
> index c2b7068..04deba3 100644
> --- a/drivers/clk/at91/Makefile
> +++ b/drivers/clk/at91/Makefile
> @@ -4,4 +4,4 @@
>
>   obj-y += pmc.o
>   obj-y += clk-main.o clk-pll.o clk-plldiv.o clk-master.o
> -obj-y += clk-system.o
> +obj-y += clk-system.o clk-peripheral.o
> diff --git a/drivers/clk/at91/clk-peripheral.c b/drivers/clk/at91/clk-peripheral.c
> new file mode 100644
> index 0000000..1612739
> --- /dev/null
> +++ b/drivers/clk/at91/clk-peripheral.c
> @@ -0,0 +1,401 @@
> +/*
> + * drivers/clk/at91/clk-peripheral.c
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
> +#define PERIPHERAL_MAX		64
> +
> +#define PERIPHERAL_AT91RM9200	0
> +#define PERIPHERAL_AT91SAM9X5	1
> +
> +#define to_clk_peripheral(hw) container_of(hw, struct clk_peripheral, hw)
> +struct clk_peripheral {
> +	struct clk_hw hw;
> +	struct at91_pmc *pmc;
> +	u32 id;
> +};
> +
> +#define to_clk_sam9x5_peripheral(hw) \
> +	container_of(hw, struct clk_sam9x5_peripheral, hw)
> +struct clk_sam9x5_peripheral {
> +	struct clk_hw hw;
> +	struct at91_pmc *pmc;
> +	u32 id;
> +	u8 div;
> +	u8 have_div_support;
> +};
> +
> +static int clk_peripheral_enable(struct clk_hw *hw)
> +{
> +	struct clk_peripheral *periph = to_clk_peripheral(hw);
> +	struct at91_pmc *pmc = periph->pmc;
> +	int offset = AT91_PMC_PCER;
> +
> +	if (periph->id < 2)
> +		return 0;
> +	if (periph->id > 31)

define constants

> +		offset = AT91_PMC_PCER1;
> +	pmc_write(pmc, offset, 1 << (periph->id & 31));

A little macro here.

> +	return 0;
> +}
> +
> +static void clk_peripheral_disable(struct clk_hw *hw)
> +{
> +	struct clk_peripheral *periph = to_clk_peripheral(hw);
> +	struct at91_pmc *pmc = periph->pmc;
> +	int offset = AT91_PMC_PCDR;
> +
> +	if (periph->id < 2)
> +		return;
> +	if (periph->id > 31)
> +		offset = AT91_PMC_PCDR1;
> +	pmc_write(pmc, offset, 1 << (periph->id & 31));

Ditto

> +}
> +
> +static int clk_peripheral_is_enabled(struct clk_hw *hw)
> +{
> +	struct clk_peripheral *periph = to_clk_peripheral(hw);
> +	struct at91_pmc *pmc = periph->pmc;
> +	int offset = AT91_PMC_PCSR;
> +
> +	if (periph->id < 2)
> +		return 1;
> +	if (periph->id > 31)
> +		offset = AT91_PMC_PCSR1;
> +	return !!(pmc_read(pmc, offset) & (1 << (periph->id & 31)));

Ditto

> +}
> +
> +static const struct clk_ops peripheral_ops = {
> +	.enable = clk_peripheral_enable,
> +	.disable = clk_peripheral_disable,
> +	.is_enabled = clk_peripheral_is_enabled,
> +};
> +
> +static struct clk * __init
> +at91_clk_register_peripheral(struct at91_pmc *pmc, const char *name,
> +			     const char *parent_name, u32 id)
> +{
> +	struct clk_peripheral *periph;
> +	struct clk *clk = NULL;
> +	struct clk_init_data init;
> +
> +	if (!pmc || !name || !parent_name)
> +		return ERR_PTR(-EINVAL);
> +
> +	id &= 31;

Ditto

> +	periph = kzalloc(sizeof(*periph), GFP_KERNEL);
> +	if (!periph)
> +		return ERR_PTR(-ENOMEM);
> +
> +	init.name = name;
> +	init.ops = &peripheral_ops;
> +	init.parent_names = (parent_name ? &parent_name : NULL);
> +	init.num_parents = (parent_name ? 1 : 0);
> +	init.flags = 0;
> +
> +	periph->id = id;
> +	periph->hw.init = &init;
> +	periph->pmc = pmc;
> +
> +	clk = clk_register(NULL, &periph->hw);
> +	if (IS_ERR(clk))
> +		kfree(periph);
> +
> +	return clk;
> +}
> +
> +static int clk_sam9x5_peripheral_enable(struct clk_hw *hw)
> +{
> +	struct clk_sam9x5_peripheral *periph = to_clk_sam9x5_peripheral(hw);
> +	struct at91_pmc *pmc = periph->pmc;
> +
> +	if (periph->id < 2)
> +		return 0;
> +	pmc_write(pmc, AT91_PMC_PCR,
> +		       (periph->id & AT91_PMC_PCR_PID) |
> +		       AT91_PMC_PCR_CMD |
> +		       AT91_PMC_PCR_DIV(periph->div) |
> +		       AT91_PMC_PCR_EN);
> +	return 0;
> +}
> +
> +static void clk_sam9x5_peripheral_disable(struct clk_hw *hw)
> +{
> +	struct clk_sam9x5_peripheral *periph = to_clk_sam9x5_peripheral(hw);
> +	struct at91_pmc *pmc = periph->pmc;
> +
> +	if (periph->id < 2)
> +		return;
> +
> +	pmc_write(pmc, AT91_PMC_PCR,
> +		       (periph->id & AT91_PMC_PCR_PID) |
> +		       AT91_PMC_PCR_CMD);
> +}
> +
> +static int clk_sam9x5_peripheral_is_enabled(struct clk_hw *hw)
> +{
> +	struct clk_sam9x5_peripheral *periph = to_clk_sam9x5_peripheral(hw);
> +	struct at91_pmc *pmc = periph->pmc;
> +	int ret;
> +
> +	if (periph->id < 2)
> +		return 1;
> +	pmc_lock(pmc);
> +	pmc_write(pmc, AT91_PMC_PCR,
> +		  (periph->id & AT91_PMC_PCR_PID));
> +	ret = !!(pmc_read(pmc, AT91_PMC_PCR) & AT91_PMC_PCR_EN);
> +	pmc_unlock(pmc);
> +
> +	return ret;
> +}
> +
> +static unsigned long
> +clk_sam9x5_peripheral_recalc_rate(struct clk_hw *hw,
> +				  unsigned long parent_rate)
> +{
> +	struct clk_sam9x5_peripheral *periph = to_clk_sam9x5_peripheral(hw);
> +	struct at91_pmc *pmc = periph->pmc;
> +	u32 shift;
> +
> +	if (periph->id < 2 || !periph->have_div_support)
> +		return parent_rate;
> +	pmc_lock(pmc);
> +	pmc_write(pmc, AT91_PMC_PCR,
> +		       (periph->id & AT91_PMC_PCR_PID));
> +	shift = (pmc_read(pmc, AT91_PMC_PCR) >> 16) & 0x3;

define constants

> +	pmc_unlock(pmc);
> +	return parent_rate >> shift;
> +}
> +
> +static long clk_sam9x5_peripheral_round_rate(struct clk_hw *hw,
> +					     unsigned long rate,
> +					     unsigned long *parent_rate)
> +{
> +	int shift;
> +	unsigned long best_rate;
> +	unsigned long best_diff;
> +	unsigned long cur_rate;
> +	unsigned long cur_diff;
> +	struct clk_sam9x5_peripheral *periph = to_clk_sam9x5_peripheral(hw);
> +
> +	if (periph->id < 2 || !periph->have_div_support)
> +		return *parent_rate;
> +	if (rate >= *parent_rate)
> +		return rate;
> +	best_diff = *parent_rate - rate;
> +	best_rate = *parent_rate;
> +	for (shift = 1; shift < 4; shift++) {
> +		cur_rate = *parent_rate >> shift;
> +		if (cur_rate < rate)
> +			cur_diff = rate - cur_rate;
> +		else
> +			cur_diff = cur_rate - rate;
> +		if (cur_diff < best_diff) {
> +			best_diff = cur_diff;
> +			best_rate = cur_rate;
> +		}
> +		if (!best_diff || cur_rate < rate)
> +			break;
> +	}
> +	return best_rate;
> +}
> +
> +static int clk_sam9x5_peripheral_set_rate(struct clk_hw *hw,
> +					  unsigned long rate,
> +					  unsigned long parent_rate)
> +{
> +	int shift;
> +	struct clk_sam9x5_peripheral *periph = to_clk_sam9x5_peripheral(hw);
> +	if (periph->id < 2 || !periph->have_div_support) {
> +		if (parent_rate == rate)
> +			return 0;
> +		else
> +			return -EINVAL;
> +	}
> +
> +	for (shift = 0; shift < 4; shift++) {
> +		if (parent_rate >> shift == rate) {
> +			periph->div = shift;
> +			return 0;
> +		}
> +	}
> +
> +	return -EINVAL;
> +}
> +
> +static const struct clk_ops sam9x5_peripheral_ops = {
> +	.enable = clk_sam9x5_peripheral_enable,
> +	.disable = clk_sam9x5_peripheral_disable,
> +	.is_enabled = clk_sam9x5_peripheral_is_enabled,
> +	.recalc_rate = clk_sam9x5_peripheral_recalc_rate,
> +	.round_rate = clk_sam9x5_peripheral_round_rate,
> +	.set_rate = clk_sam9x5_peripheral_set_rate,
> +};
> +
> +static struct clk * __init
> +at91_clk_register_sam9x5_peripheral(struct at91_pmc *pmc, const char *name,
> +				    const char *parent_name, u32 id,
> +				    u32 default_div)
> +{
> +	struct clk_sam9x5_peripheral *periph;
> +	struct clk *clk = NULL;
> +	struct clk_init_data init;
> +
> +	if (!pmc || !name || !parent_name)
> +		return ERR_PTR(-EINVAL);
> +
> +	periph = kzalloc(sizeof(*periph), GFP_KERNEL);
> +	if (!periph)
> +		return ERR_PTR(-ENOMEM);
> +
> +	init.name = name;
> +	init.ops = &sam9x5_peripheral_ops;
> +	init.parent_names = (parent_name ? &parent_name : NULL);
> +	init.num_parents = (parent_name ? 1 : 0);
> +	init.flags = CLK_SET_RATE_GATE;
> +
> +	periph->id = id;
> +	periph->hw.init = &init;
> +	periph->div = default_div;
> +	periph->pmc = pmc;
> +
> +	clk = clk_register(NULL, &periph->hw);
> +

Ditto

> +	if (IS_ERR(clk))
> +		kfree(periph);
> +
> +	return clk;
> +}
> +
> +struct clk_periph_data {
> +	struct clk **clks;
> +	u8 *ids;
> +	unsigned int clk_num;
> +};
> +
> +static struct clk * __init
> +of_clk_src_periph_get(struct of_phandle_args *clkspec, void *data)
> +{
> +	struct clk_periph_data *clk_data = data;
> +	unsigned int id = clkspec->args[0];
> +	int i;
> +
> +	if (id >= PERIPHERAL_MAX)
> +		goto err;
> +
> +	for (i = 0; i < clk_data->clk_num; i++) {
> +		if (clk_data->ids[i] == id)
> +			return clk_data->clks[i];
> +	}
> +
> +err:
> +	pr_err("%s: invalid clock id %d\n", __func__, id);
> +	return ERR_PTR(-EINVAL);
> +}
> +
> +static void __init
> +of_at91_clk_periph_setup(struct device_node *np, struct at91_pmc *pmc, u8 type)
> +{
> +	int num;
> +	int i;
> +	u32 id;
> +	struct clk *clk;
> +	const char *parent_name;
> +	const char *name;
> +	u32 divisor;
> +	struct clk **clks;
> +	u8 *ids;
> +	struct clk_periph_data *clktab;
> +	struct device_node *periphclknp;
> +
> +	parent_name = of_clk_get_parent_name(np, 0);
> +	if (!parent_name)
> +		return;
> +
> +	num = of_get_child_count(np);
> +	if (!num || num > PERIPHERAL_MAX)
> +		return;
> +
> +	clktab = kzalloc(sizeof(*clktab), GFP_KERNEL);
> +	if (!clktab)
> +		return;
> +
> +	ids = kzalloc(num * sizeof(*ids), GFP_KERNEL);
> +	if (!ids)
> +		goto out_free_clktab;
> +
> +	clks = kzalloc(num * sizeof(*clks), GFP_KERNEL);
> +	if (!clks)
> +		goto out_free_ids;
> +
> +	i = 0;
> +	for_each_child_of_node(np, periphclknp) {
> +		name = periphclknp->name;
> +
> +		if (of_property_read_u32(periphclknp, "atmel,clk-id", &id))
> +			goto out_free_clks;
> +		if (id >= PERIPHERAL_MAX)
> +			goto out_free_clks;
> +
> +		if (type == PERIPHERAL_AT91RM9200) {
> +			clk = at91_clk_register_peripheral(pmc, name,
> +							   parent_name, id);
> +		} else {
> +			if (of_property_read_u32(periphclknp,
> +						 "atmel,clk-default-divisor",
> +						 &divisor))
> +				divisor = 0;
> +
> +			clk = at91_clk_register_sam9x5_peripheral(pmc, name,
> +								  parent_name,
> +								  id,
> +								  divisor);
> +		}
> +		if (IS_ERR(clk))
> +			goto out_free_clks;
> +
> +		clks[i] = clk;
> +		ids[i++] = id;
> +	}
> +
> +	clktab->clk_num = num;
> +	clktab->clks = clks;
> +	clktab->ids = ids;
> +	of_clk_add_provider(np, of_clk_src_periph_get, clktab);
> +	return;
> +
> +out_free_clks:
> +	kfree(clks);
> +out_free_ids:
> +	kfree(ids);
> +out_free_clktab:
> +	kfree(clktab);
> +}
> +
> +void __init of_at91rm9200_clk_periph_setup(struct device_node *np,
> +					   struct at91_pmc *pmc)
> +{
> +	of_at91_clk_periph_setup(np, pmc, PERIPHERAL_AT91RM9200);
> +}
> +
> +void __init of_at91sam9x5_clk_periph_setup(struct device_node *np,
> +					   struct at91_pmc *pmc)
> +{
> +	of_at91_clk_periph_setup(np, pmc, PERIPHERAL_AT91SAM9X5);
> +}
> diff --git a/drivers/clk/at91/pmc.c b/drivers/clk/at91/pmc.c
> index c674ef2..1a56f1c 100644
> --- a/drivers/clk/at91/pmc.c
> +++ b/drivers/clk/at91/pmc.c
> @@ -256,6 +256,15 @@ static const struct of_device_id pmc_clk_ids[] __initdata = {
>   		.compatible = "atmel,at91rm9200-clk-system",
>   		.data = of_at91rm9200_clk_sys_setup,
>   	},
> +	/* Peripheral clocks */
> +	{
> +		.compatible = "atmel,at91rm9200-clk-peripheral",
> +		.data = of_at91rm9200_clk_periph_setup,
> +	},
> +	{
> +		.compatible = "atmel,at91sam9x5-clk-peripheral",
> +		.data = of_at91sam9x5_clk_periph_setup,
> +	},
>   	{ /*sentinel*/ }
>   };
>
> diff --git a/drivers/clk/at91/pmc.h b/drivers/clk/at91/pmc.h
> index f88ef41..08c30fb 100644
> --- a/drivers/clk/at91/pmc.h
> +++ b/drivers/clk/at91/pmc.h
> @@ -77,4 +77,9 @@ extern void __init of_at91sam9x5_clk_master_setup(struct device_node *np,
>   extern void __init of_at91rm9200_clk_sys_setup(struct device_node *np,
>   					       struct at91_pmc *pmc);
>
> +extern void __init of_at91rm9200_clk_periph_setup(struct device_node *np,
> +						  struct at91_pmc *pmc);
> +extern void __init of_at91sam9x5_clk_periph_setup(struct device_node *np,
> +						  struct at91_pmc *pmc);
> +
>   #endif /* __PMC_H_ */
>


-- 
Nicolas Ferre
