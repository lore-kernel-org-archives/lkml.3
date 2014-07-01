Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758307AbaGAR0d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 13:26:33 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:56341 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758098AbaGAR0a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 13:26:30 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Yadwinder Singh Brar <yadi.brar01@gmail.com>,
        "Javier Martinez Canillas" <javier.martinez@collabora.co.uk>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <CAKew6eU5X=WxhECtwUUwbXe_fCRU4bD6B7caWiA2dwcBfThd-g@mail.gmail.com>
Cc: "Lee Jones" <lee.jones@linaro.org>, "Samuel Ortiz" <sameo@linux.intel.com>,
        "Mark Brown" <broonie@kernel.org>,
        "Liam Girdwood" <lgirdwood@gmail.com>,
        "Alessandro Zummo" <a.zummo@towertech.it>,
        "Kukjin Kim" <kgene.kim@samsung.com>,
        "Doug Anderson" <dianders@chromium.org>,
        "Olof Johansson" <olof@lixom.net>,
        "Sjoerd Simons" <sjoerd.simons@collabora.co.uk>,
        "Daniel Stone" <daniels@collabora.com>,
        "Tomeu Vizoso" <tomeu.vizoso@collabora.com>,
        "Krzysztof Kozlowski" <k.kozlowski@samsung.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree" <devicetree@vger.kernel.org>,
        "linux-samsung-soc" <linux-samsung-soc@vger.kernel.org>,
        "linux-kernel" <linux-kernel@vger.kernel.org>
References: <1403806546-31122-1-git-send-email-javier.martinez@collabora.co.uk>
 <1403806546-31122-6-git-send-email-javier.martinez@collabora.co.uk>
 <CAKew6eU5X=WxhECtwUUwbXe_fCRU4bD6B7caWiA2dwcBfThd-g@mail.gmail.com>
Message-ID: <20140701172616.32686.44374@quantum>
User-Agent: alot/0.3.5
Subject: Re: [PATCH v5 05/14] clk: Add generic driver for Maxim PMIC clocks
Date: Tue, 01 Jul 2014 10:26:16 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Yadwinder Singh Brar (2014-06-29 21:01:36)
> Hi Javier,
> 
> On Thu, Jun 26, 2014 at 11:45 PM, Javier Martinez Canillas
> <javier.martinez@collabora.co.uk> wrote:
> > Maxim Integrated Power Management ICs are very similar with
> > regard to their clock outputs. Most of the clock drivers for
> > these chips are duplicating code and are simpler enough that
> > can be converted to use a generic driver to consolidate code
> > and avoid duplication.
> >
> > Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
> > Reviewed-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> > ---
> >
> > Changes since v4:
> >  - Return recalc 0 if clock isn't enabled in Suggested by Yadwinder Singh Brar.
> >
> 
> It seems you didn't implement or posted same patch again :) .
> 
> > Changes since v3:
> >  - Add current copyright information. Suggested by Krzysztof Kozlowski
> >  - Do a single allocation for struct max_gen_clk. Suggested by Krzysztof Kozlowski
> >  - Add EXPORT_SYMBOL() for exported symbols. Suggested by Krzysztof Kozlowski
> >
> >  drivers/clk/Kconfig       |   3 +
> >  drivers/clk/Makefile      |   1 +
> >  drivers/clk/clk-max-gen.c | 195 ++++++++++++++++++++++++++++++++++++++++++++++
> >  drivers/clk/clk-max-gen.h |  32 ++++++++
> >  4 files changed, 231 insertions(+)
> >  create mode 100644 drivers/clk/clk-max-gen.c
> >  create mode 100644 drivers/clk/clk-max-gen.h
> >
> 
> [ .. ]
> 
> > +
> > +static unsigned long max_gen_recalc_rate(struct clk_hw *hw,
> > +                                        unsigned long parent_rate)
> > +{
> > +       return 32768;
> > +}
> 
> Its still same here.

Changing this would be a new behavior. I do not know of any other clock
drivers that conditionally returns a rate of 0 based on whether or not
the clock is gated.

It is also buggy since calls to clk_enable and clk_disable do not invoke
.recalc_rate, so the rate of your clock would not be updated from the
framework's perspective until some later point where you call
clk_set_rate or something.

If your driver needs to know whether or not the clock is enabled then we
could introduce a new bool clk_is_enabled(struct clk *clk); to clk.h,
but I'd rather not do that. Instead if a driver needs a clock then it
calls clk_enable on it without any knowledge about the internal state of
the clock enable_count.

Regards,
Mike

> 
> > +
> > +struct clk_ops max_gen_clk_ops = {
> > +       .prepare        = max_gen_clk_prepare,
> > +       .unprepare      = max_gen_clk_unprepare,
> > +       .is_prepared    = max_gen_clk_is_prepared,
> > +       .recalc_rate    = max_gen_recalc_rate,
> > +};
> > +EXPORT_SYMBOL_GPL(max_gen_clk_ops);
> > +
> > +static struct clk *max_gen_clk_register(struct device *dev,
> > +                                       struct max_gen_clk *max_gen)
> > +{
> > +       struct clk *clk;
> > +       struct clk_hw *hw = &max_gen->hw;
> > +
> > +       clk = clk_register(dev, hw);
> > +       if (IS_ERR(clk))
> > +               return clk;
> > +
> > +       max_gen->lookup = kzalloc(sizeof(struct clk_lookup), GFP_KERNEL);
> 
> As I suggested in other patch[1] also, its better to use
> clkdev_alloc() instead of kzalloc() here.
> 
> > +       if (!max_gen->lookup)
> > +               return ERR_PTR(-ENOMEM);
> > +
> > +       max_gen->lookup->con_id = hw->init->name;
> 
> Also IMO,  init->name should be over-written if name is provided in DT,
> otherwise generic "clock-output-names" property will go futile,
> perhaps it should be done before clk_register.
> 
> Regards,
> Yadwinder
> 
> [1] : https://lkml.org/lkml/2014/6/27/197
> 
> > +       max_gen->lookup->clk = clk;
> > +
> > +       clkdev_add(max_gen->lookup);
> > +
> > +       return clk;
> > +}
> > +
> > +int max_gen_clk_probe(struct platform_device *pdev, struct regmap *regmap,
> > +                     u32 reg, struct clk_init_data *clks_init, int num_init)
> > +{
> > +       int i, ret;
> > +       struct max_gen_clk *max_gen_clks;
> > +       struct clk **clocks;
> > +       struct device *dev = &pdev->dev;
> > +
> > +       clocks = devm_kzalloc(dev, sizeof(struct clk *) * num_init, GFP_KERNEL);
> > +       if (!clocks)
> > +               return -ENOMEM;
> > +
> > +       max_gen_clks = devm_kzalloc(dev, sizeof(struct max_gen_clk)
> > +                                   * num_init, GFP_KERNEL);
> > +       if (!max_gen_clks)
> > +               return -ENOMEM;
> > +
> > +       for (i = 0; i < num_init; i++) {
> > +               max_gen_clks[i].regmap = regmap;
> > +               max_gen_clks[i].mask = 1 << i;
> > +               max_gen_clks[i].reg = reg;
> > +               max_gen_clks[i].hw.init = &clks_init[i];
> > +
> > +               clocks[i] = max_gen_clk_register(dev, &max_gen_clks[i]);
> > +               if (IS_ERR(clocks[i])) {
> > +                       ret = PTR_ERR(clocks[i]);
> > +                       dev_err(dev, "failed to register %s\n",
> > +                               max_gen_clks[i].hw.init->name);
> > +                       goto err_clocks;
> > +               }
> > +       }
> > +
> > +       platform_set_drvdata(pdev, clocks);
> > +
> > +       if (dev->of_node) {
> > +               struct clk_onecell_data *of_data;
> > +
> > +               of_data = devm_kzalloc(dev, sizeof(*of_data), GFP_KERNEL);
> > +               if (!of_data) {
> > +                       ret = -ENOMEM;
> > +                       goto err_clocks;
> > +               }
> > +
> > +               of_data->clks = clocks;
> > +               of_data->clk_num = num_init;
> > +               ret = of_clk_add_provider(dev->of_node, of_clk_src_onecell_get,
> > +                                         of_data);
> > +
> > +               if (ret) {
> > +                       dev_err(dev, "failed to register OF clock provider\n");
> > +                       goto err_clocks;
> > +               }
> > +       }
> > +
> > +       return 0;
> > +
> > +err_clocks:
> > +       for (--i; i >= 0; --i) {
> > +               clkdev_drop(max_gen_clks[i].lookup);
> > +               clk_unregister(max_gen_clks[i].hw.clk);
> > +       }
> > +
> > +       return ret;
> > +}
> > +EXPORT_SYMBOL_GPL(max_gen_clk_probe);
> > +
> > +int max_gen_clk_remove(struct platform_device *pdev, int num_init)
> > +{
> > +       struct clk **clocks = platform_get_drvdata(pdev);
> > +       struct device *dev = pdev->dev.parent;
> > +       int i;
> > +
> > +       if (dev->of_node)
> > +               of_clk_del_provider(dev->of_node);
> > +
> > +       for (i = 0; i < num_init; i++) {
> > +               struct clk_hw *hw = __clk_get_hw(clocks[i]);
> > +               struct max_gen_clk *max_gen = to_max_gen_clk(hw);
> > +
> > +               clkdev_drop(max_gen->lookup);
> > +               clk_unregister(clocks[i]);
> > +       }
> > +       return 0;
> > +}
> > +EXPORT_SYMBOL_GPL(max_gen_clk_remove);
> > diff --git a/drivers/clk/clk-max-gen.h b/drivers/clk/clk-max-gen.h
> > new file mode 100644
> > index 0000000..997e86f
> > --- /dev/null
> > +++ b/drivers/clk/clk-max-gen.h
> > @@ -0,0 +1,32 @@
> > +/*
> > + * clk-max-gen.h - Generic clock driver for Maxim PMICs clocks
> > + *
> > + * Copyright (C) 2014 Google, Inc
> > + *
> > + * This program is free software; you can redistribute  it and/or modify it
> > + * under  the terms of  the GNU General  Public License as published by the
> > + * Free Software Foundation;  either version 2 of the  License, or (at your
> > + * option) any later version.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + *
> > + */
> > +
> > +#ifndef __CLK_MAX_GEN_H__
> > +#define __CLK_MAX_GEN_H__
> > +
> > +#include <linux/types.h>
> > +#include <linux/device.h>
> > +#include <linux/clkdev.h>
> > +#include <linux/regmap.h>
> > +#include <linux/platform_device.h>
> > +
> > +int max_gen_clk_probe(struct platform_device *pdev, struct regmap *regmap,
> > +                     u32 reg, struct clk_init_data *clks_init, int num_init);
> > +int max_gen_clk_remove(struct platform_device *pdev, int num_init);
> > +extern struct clk_ops max_gen_clk_ops;
> > +
> > +#endif /* __CLK_MAX_GEN_H__ */
> > --
> > 2.0.0.rc2
> >
