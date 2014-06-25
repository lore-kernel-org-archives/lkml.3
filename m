Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757044AbaFYOgi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 10:36:38 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:60443 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756294AbaFYOgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 10:36:35 -0400
Message-ID: <53AADE6B.2060005@collabora.co.uk>
Date: Wed, 25 Jun 2014 16:36:27 +0200
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
CC: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        Sjoerd Simons <sjoerd.simons@collabora.co.uk>,
        Daniel Stone <daniels@collabora.com>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 05/14] clk: Add generic driver for Maxim PMIC clocks
References: <1403202040-12641-1-git-send-email-javier.martinez@collabora.co.uk> <1403202040-12641-6-git-send-email-javier.martinez@collabora.co.uk> <1403705957.22107.22.camel@AMDC1943>
In-Reply-To: <1403705957.22107.22.camel@AMDC1943>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Krzysztof,

On 06/25/2014 04:19 PM, Krzysztof Kozlowski wrote:
> On czw, 2014-06-19 at 20:20 +0200, Javier Martinez Canillas wrote:
>> Maxim Integrated Power Management ICs are very similar with
>> regard to their clock outputs. Most of the clock drivers for
>> these chips are duplicating code and are simpler enough that
>> can be converted to use a generic driver to consolidate code
>> and avoid duplication.
>> 
>> Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
> 
> (...)
> 
>> diff --git a/drivers/clk/clk-max-gen.c b/drivers/clk/clk-max-gen.c
>> new file mode 100644
>> index 0000000..aa9ebbe
>> --- /dev/null
>> +++ b/drivers/clk/clk-max-gen.c
>> @@ -0,0 +1,197 @@
>> +/*
>> + * clk-max-gen.c - Generic clock driver for Maxim PMICs clocks
>> + *
>> + * Copyright (C) 2012 Samsung Electornics
>> + * Jonghwa Lee <jonghwa3.lee@samsung.com>
> 
> You copied this from original file but '2012' and author look a little
> strange since this piece of work is actually new stuff. Maybe consider
> adding current copyright?
> 

Sure, I'll add the current copyright as well on next version of the patch-set.

>> + *
>> + * This program is free software; you can redistribute  it and/or modify it
>> + * under  the terms of  the GNU General  Public License as published by the
>> + * Free Software Foundation;  either version 2 of the  License, or (at your
>> + * option) any later version.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + *
>> + * This driver is based on clk-max77686.c
>> + *
>> + */
>> +
>> +#include <linux/kernel.h>
>> +#include <linux/slab.h>
>> +#include <linux/err.h>
>> +#include <linux/regmap.h>
>> +#include <linux/platform_device.h>
>> +#include <linux/clk-provider.h>
>> +#include <linux/mutex.h>
>> +#include <linux/clkdev.h>
>> +
>> +struct max_gen_clk {
>> +	struct regmap *regmap;
>> +	u32 mask;
>> +	u32 reg;
>> +	struct clk_hw hw;
>> +	struct clk_lookup *lookup;
>> +};
>> +
>> +static struct max_gen_clk *to_max_gen_clk(struct clk_hw *hw)
>> +{
>> +	return container_of(hw, struct max_gen_clk, hw);
>> +}
>> +
>> +static int max_gen_clk_prepare(struct clk_hw *hw)
>> +{
>> +	struct max_gen_clk *max_gen = to_max_gen_clk(hw);
>> +
>> +	return regmap_update_bits(max_gen->regmap, max_gen->reg,
>> +				  max_gen->mask, max_gen->mask);
>> +}
>> +
>> +static void max_gen_clk_unprepare(struct clk_hw *hw)
>> +{
>> +	struct max_gen_clk *max_gen = to_max_gen_clk(hw);
>> +
>> +	regmap_update_bits(max_gen->regmap, max_gen->reg,
>> +			   max_gen->mask, ~max_gen->mask);
>> +}
>> +
>> +static int max_gen_clk_is_prepared(struct clk_hw *hw)
>> +{
>> +	struct max_gen_clk *max_gen = to_max_gen_clk(hw);
>> +	int ret;
>> +	u32 val;
>> +
>> +	ret = regmap_read(max_gen->regmap, max_gen->reg, &val);
>> +
>> +	if (ret < 0)
>> +		return -EINVAL;
>> +
>> +	return val & max_gen->mask;
>> +}
>> +
>> +static unsigned long max_gen_recalc_rate(struct clk_hw *hw,
>> +					 unsigned long parent_rate)
>> +{
>> +	return 32768;
>> +}
>> +
>> +struct clk_ops max_gen_clk_ops = {
>> +	.prepare	= max_gen_clk_prepare,
>> +	.unprepare	= max_gen_clk_unprepare,
>> +	.is_prepared	= max_gen_clk_is_prepared,
>> +	.recalc_rate	= max_gen_recalc_rate,
>> +};
>> +
>> +static struct clk *max_gen_clk_register(struct device *dev,
>> +					struct max_gen_clk *max_gen)
>> +{
>> +	struct clk *clk;
>> +	struct clk_hw *hw = &max_gen->hw;
>> +
>> +	clk = clk_register(dev, hw);
>> +	if (IS_ERR(clk))
>> +		return clk;
>> +
>> +	max_gen->lookup = kzalloc(sizeof(struct clk_lookup), GFP_KERNEL);
>> +	if (!max_gen->lookup)
>> +		return ERR_PTR(-ENOMEM);
>> +
>> +	max_gen->lookup->con_id = hw->init->name;
>> +	max_gen->lookup->clk = clk;
>> +
>> +	clkdev_add(max_gen->lookup);
>> +
>> +	return clk;
>> +}
>> +
>> +int max_gen_clk_probe(struct platform_device *pdev, struct regmap *regmap,
>> +		      u32 reg, struct clk_init_data *clks_init, int num_init)
>> +{
>> +	int i, ret;
>> +	struct max_gen_clk **max_gen_clks;
>> +	struct clk **clocks;
>> +	struct device *dev = &pdev->dev;
>> +
>> +	clocks = devm_kzalloc(dev, sizeof(struct clk *) * num_init, GFP_KERNEL);
>> +	if (!clocks)
>> +		return -ENOMEM;
>> +
>> +	max_gen_clks = devm_kzalloc(dev, sizeof(struct max_gen_clk *)
>> +				    * num_init, GFP_KERNEL);
>> +	if (!max_gen_clks)
>> +		return -ENOMEM;
>> +
>> +	for (i = 0; i < num_init; i++) {
>> +		max_gen_clks[i] = devm_kzalloc(dev, sizeof(struct max_gen_clk),
>> +					       GFP_KERNEL);
>> +		if (!max_gen_clks[i])
>> +			return -ENOMEM;
>> +	}
> 
> Why don't use only one devm_kzalloc() call for struct max_gen_clk?
> Something like:
> 	max_gen_clks = devm_kzalloc(dev, sizeof(struct max_gen_clk)
> 				    * num_init, GFP_KERNEL);
> 
> This will be shorter and still readable.
> 

Ok.

>> +
>> +	for (i = 0; i < num_init; i++) {
>> +		max_gen_clks[i]->regmap = regmap;
>> +		max_gen_clks[i]->mask = 1 << i;
>> +		max_gen_clks[i]->reg = reg;
>> +		max_gen_clks[i]->hw.init = &clks_init[i];
>> +
>> +		clocks[i] = max_gen_clk_register(dev, max_gen_clks[i]);
>> +		if (IS_ERR(clocks[i])) {
>> +			ret = PTR_ERR(clocks[i]);
>> +			dev_err(dev, "failed to register %s\n",
>> +				max_gen_clks[i]->hw.init->name);
>> +			goto err_clocks;
>> +		}
>> +	}
>> +
>> +	platform_set_drvdata(pdev, clocks);
>> +
>> +	if (dev->of_node) {
>> +		struct clk_onecell_data *of_data;
>> +
>> +		of_data = devm_kzalloc(dev, sizeof(*of_data), GFP_KERNEL);
>> +		if (!of_data) {
>> +			ret = -ENOMEM;
>> +			goto err_clocks;
>> +		}
>> +
>> +		of_data->clks = clocks;
>> +		of_data->clk_num = num_init;
>> +		ret = of_clk_add_provider(dev->of_node, of_clk_src_onecell_get,
>> +					  of_data);
>> +
>> +		if (ret) {
>> +			dev_err(dev, "failed to register OF clock provider\n");
>> +			goto err_clocks;
>> +		}
>> +	}
>> +
>> +	return 0;
>> +
>> +err_clocks:
>> +	for (--i; i >= 0; --i) {
>> +		clkdev_drop(max_gen_clks[i]->lookup);
>> +		clk_unregister(max_gen_clks[i]->hw.clk);
>> +	}
>> +
>> +	return ret;
>> +}
> 
> Since users of this function may be compiled as modules these should be
> exported (EXPORT_SYMBOL(_GPL)):
> ERROR: "max_gen_clk_ops" [drivers/clk/clk-max77802.ko] undefined!
> ERROR: "max_gen_clk_probe" [drivers/clk/clk-max77802.ko] undefined!
> ERROR: "max_gen_clk_remove" [drivers/clk/clk-max77802.ko] undefined!
> ERROR: "max_gen_clk_ops" [drivers/clk/clk-max77686.ko] undefined!
> ERROR: "max_gen_clk_probe" [drivers/clk/clk-max77686.ko] undefined!
> ERROR: "max_gen_clk_remove" [drivers/clk/clk-max77686.ko] undefined!
> 

Right, I forgot about it and missed since I was not building it as a module.

> Best regards,
> Krzysztof
> 

Thanks a lot for your feedback!

Best regards,
Javier
