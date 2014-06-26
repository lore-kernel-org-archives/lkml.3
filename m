Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757222AbaFZLvd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 07:51:33 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:61493 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756280AbaFZLva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 07:51:30 -0400
MIME-Version: 1.0
In-Reply-To: <1403723019-6212-6-git-send-email-javier.martinez@collabora.co.uk>
References: <1403723019-6212-1-git-send-email-javier.martinez@collabora.co.uk>
	<1403723019-6212-6-git-send-email-javier.martinez@collabora.co.uk>
Date: Thu, 26 Jun 2014 17:21:29 +0530
Message-ID: <CAKew6eWt-0c4gxGX7C7KtRrxR=9h9BSUmN3a2aWQtuT40cva1w@mail.gmail.com>
Subject: Re: [PATCH v4 05/14] clk: Add generic driver for Maxim PMIC clocks
From: Yadwinder Singh Brar <yadi.brar01@gmail.com>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        Sjoerd Simons <sjoerd.simons@collabora.co.uk>,
        Daniel Stone <daniels@collabora.com>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        devicetree <devicetree@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Javier,

Sorry for jumping in late, but just one concern mentioned inline.

[ .. ]

> +
> +static unsigned long max_gen_recalc_rate(struct clk_hw *hw,
> +                                        unsigned long parent_rate)
> +{
> +       return 32768;
> +}

Isn't more safer(correct), if it check and return 0 when clk is
disabled(unprepared) ?

Regards,
Yadwinder

> +
> +struct clk_ops max_gen_clk_ops = {
> +       .prepare        = max_gen_clk_prepare,
> +       .unprepare      = max_gen_clk_unprepare,
> +       .is_prepared    = max_gen_clk_is_prepared,
> +       .recalc_rate    = max_gen_recalc_rate,
> +};
> +EXPORT_SYMBOL_GPL(max_gen_clk_ops);
> +
> +static struct clk *max_gen_clk_register(struct device *dev,
> +                                       struct max_gen_clk *max_gen)
> +{
> +       struct clk *clk;
> +       struct clk_hw *hw = &max_gen->hw;
> +
> +       clk = clk_register(dev, hw);
> +       if (IS_ERR(clk))
> +               return clk;
> +
> +       max_gen->lookup = kzalloc(sizeof(struct clk_lookup), GFP_KERNEL);
> +       if (!max_gen->lookup)
> +               return ERR_PTR(-ENOMEM);
> +
> +       max_gen->lookup->con_id = hw->init->name;
> +       max_gen->lookup->clk = clk;
> +
> +       clkdev_add(max_gen->lookup);
> +
> +       return clk;
> +}
> +
> +int max_gen_clk_probe(struct platform_device *pdev, struct regmap *regmap,
> +                     u32 reg, struct clk_init_data *clks_init, int num_init)
> +{
> +       int i, ret;
> +       struct max_gen_clk *max_gen_clks;
> +       struct clk **clocks;
> +       struct device *dev = &pdev->dev;
> +
> +       clocks = devm_kzalloc(dev, sizeof(struct clk *) * num_init, GFP_KERNEL);
> +       if (!clocks)
> +               return -ENOMEM;
> +
> +       max_gen_clks = devm_kzalloc(dev, sizeof(struct max_gen_clk)
> +                                   * num_init, GFP_KERNEL);
> +       if (!max_gen_clks)
> +               return -ENOMEM;
> +
> +       for (i = 0; i < num_init; i++) {
> +               max_gen_clks[i].regmap = regmap;
> +               max_gen_clks[i].mask = 1 << i;
> +               max_gen_clks[i].reg = reg;
> +               max_gen_clks[i].hw.init = &clks_init[i];
> +
> +               clocks[i] = max_gen_clk_register(dev, &max_gen_clks[i]);
> +               if (IS_ERR(clocks[i])) {
> +                       ret = PTR_ERR(clocks[i]);
> +                       dev_err(dev, "failed to register %s\n",
> +                               max_gen_clks[i].hw.init->name);
> +                       goto err_clocks;
> +               }
> +       }
> +
> +       platform_set_drvdata(pdev, clocks);
> +
> +       if (dev->of_node) {
> +               struct clk_onecell_data *of_data;
> +
> +               of_data = devm_kzalloc(dev, sizeof(*of_data), GFP_KERNEL);
> +               if (!of_data) {
> +                       ret = -ENOMEM;
> +                       goto err_clocks;
> +               }
> +
> +               of_data->clks = clocks;
> +               of_data->clk_num = num_init;
> +               ret = of_clk_add_provider(dev->of_node, of_clk_src_onecell_get,
> +                                         of_data);
> +
> +               if (ret) {
> +                       dev_err(dev, "failed to register OF clock provider\n");
> +                       goto err_clocks;
> +               }
> +       }
> +
> +       return 0;
> +
> +err_clocks:
> +       for (--i; i >= 0; --i) {
> +               clkdev_drop(max_gen_clks[i].lookup);
> +               clk_unregister(max_gen_clks[i].hw.clk);
> +       }
> +
> +       return ret;
> +}
> +EXPORT_SYMBOL_GPL(max_gen_clk_probe);
> +
> +int max_gen_clk_remove(struct platform_device *pdev, int num_init)
> +{
> +       struct clk **clocks = platform_get_drvdata(pdev);
> +       struct device *dev = pdev->dev.parent;
> +       int i;
> +
> +       if (dev->of_node)
> +               of_clk_del_provider(dev->of_node);
> +
> +       for (i = 0; i < num_init; i++) {
> +               struct clk_hw *hw = __clk_get_hw(clocks[i]);
> +               struct max_gen_clk *max_gen = to_max_gen_clk(hw);
> +
> +               clkdev_drop(max_gen->lookup);
> +               clk_unregister(clocks[i]);
> +       }
> +       return 0;
> +}
> +EXPORT_SYMBOL_GPL(max_gen_clk_remove);
> diff --git a/drivers/clk/clk-max-gen.h b/drivers/clk/clk-max-gen.h
> new file mode 100644
> index 0000000..997e86f
> --- /dev/null
> +++ b/drivers/clk/clk-max-gen.h
> @@ -0,0 +1,32 @@
> +/*
> + * clk-max-gen.h - Generic clock driver for Maxim PMICs clocks
> + *
> + * Copyright (C) 2014 Google, Inc
> + *
> + * This program is free software; you can redistribute  it and/or modify it
> + * under  the terms of  the GNU General  Public License as published by the
> + * Free Software Foundation;  either version 2 of the  License, or (at your
> + * option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + */
> +
> +#ifndef __CLK_MAX_GEN_H__
> +#define __CLK_MAX_GEN_H__
> +
> +#include <linux/types.h>
> +#include <linux/device.h>
> +#include <linux/clkdev.h>
> +#include <linux/regmap.h>
> +#include <linux/platform_device.h>
> +
> +int max_gen_clk_probe(struct platform_device *pdev, struct regmap *regmap,
> +                     u32 reg, struct clk_init_data *clks_init, int num_init);
> +int max_gen_clk_remove(struct platform_device *pdev, int num_init);
> +extern struct clk_ops max_gen_clk_ops;
> +
> +#endif /* __CLK_MAX_GEN_H__ */
> --
> 2.0.0.rc2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-samsung-soc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
