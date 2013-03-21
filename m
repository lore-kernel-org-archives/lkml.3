Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753483Ab3CUVXO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 17:23:14 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:43116 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753427Ab3CUVXL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 17:23:11 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Ian Lartey <ian@slimlogic.co.uk>, linux-kernel@vger.kernel.org
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1362662276-20792-12-git-send-email-ian@slimlogic.co.uk>
Cc: linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-leds@vger.kernel.org, linux-watchdog@vger.kernel.org,
        swarren@wwwdotorg.org, grant.likely@secretlab.ca,
        broonie@opensource.wolfsonmicro.com, rob.herring@calxeda.com,
        rob@landley.net, linus.walleij@linaro.org, cooloney@gmail.com,
        rpurdie@rpsys.net, sameo@linux.intel.com, wim@iguana.be,
        lgirdwood@gmail.com, gg@slimlogic.co.uk, j-keerthy@ti.com,
        ldewangan@nvidia.com, t-kristo@ti.com,
        Ian Lartey <ian@slimlogic.co.uk>
References: <1362662276-20792-1-git-send-email-ian@slimlogic.co.uk>
 <1362662276-20792-12-git-send-email-ian@slimlogic.co.uk>
Message-ID: <20130321212304.834.58588@quantum>
User-Agent: alot/0.3.3+
Subject: Re: [PATCH v8 12/12] clk: add a clock driver for palmas
Date: Thu, 21 Mar 2013 14:23:04 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Ian Lartey (2013-03-07 05:17:56)
> Palmas has two clock generators in it, clk32kg and clk32kg audio. They
> are fixed frequency clocks that only have enable/disable functionality.
> 
> Signed-off-by: Graeme Gregory <gg@slimlogic.co.uk>
> Signed-off-by: J Keerthy <j-keerthy@ti.com>
> Signed-off-by: Ian Lartey <ian@slimlogic.co.uk>

My only complaint with this driver is that there are two sets of ops and
prepare/unprepare functions when there could be just one set.  If there
existed some struct palmas_clk_hw which included members "reg" and
"ctrl_mode" (or even "enable_bit") then a single set of ops would do
just fine, instead of hard-coding those values into the functions.

Either way it's a small thing and there are only two clocks per palmas
here.  Hopefully it will get cleaned up in an update some day.

Acked-by: Mike Turquette <mturquette@linaro.org>

> ---
>  drivers/clk/clk-palmas.c |  268 ++++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 268 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/clk/clk-palmas.c
> 
> diff --git a/drivers/clk/clk-palmas.c b/drivers/clk/clk-palmas.c
> new file mode 100644
> index 0000000..328eea4
> --- /dev/null
> +++ b/drivers/clk/clk-palmas.c
> @@ -0,0 +1,268 @@
> +/*
> + * PALMAS resource clock module driver
> + *
> + * Copyright (C) 2011-2013 Texas Instruments Inc.
> + * Graeme Gregory <gg@slimlogic.co.uk>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * version 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful, but
> + * WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + * General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
> + * 02110-1301 USA
> + *
> + */
> +
> +#include <linux/clk.h>
> +#include <linux/module.h>
> +#include <linux/slab.h>
> +#include <linux/platform_device.h>
> +#include <linux/mfd/palmas.h>
> +#include <linux/clk-provider.h>
> +#include <linux/of_platform.h>
> +
> +struct palmas_clk {
> +       struct palmas *palmas;
> +       struct device *dev;
> +       struct clk_hw clk32kg;
> +       struct clk_hw clk32kgaudio;
> +       int clk32kgaudio_mode_sleep;
> +       int clk32kg_mode_sleep;
> +};
> +
> +static int palmas_clock_setbits(struct palmas *palmas, unsigned int reg,
> +               unsigned int data)
> +{
> +       return palmas_update_bits(palmas, PALMAS_RESOURCE_BASE,
> +                       reg, data, data);
> +}
> +
> +static int palmas_clock_clrbits(struct palmas *palmas, unsigned int reg,
> +               unsigned int data)
> +{
> +       return palmas_update_bits(palmas, PALMAS_RESOURCE_BASE,
> +                       reg, data, 0);
> +}
> +
> +static int palmas_prepare_clk32kg(struct clk_hw *hw)
> +{
> +       struct palmas_clk *palmas_clk = container_of(hw, struct palmas_clk,
> +                       clk32kg);
> +       int ret;
> +
> +       ret = palmas_clock_setbits(palmas_clk->palmas,
> +                       PALMAS_CLK32KG_CTRL, PALMAS_CLK32KG_CTRL_MODE_ACTIVE);
> +       if (ret)
> +               dev_err(palmas_clk->dev, "Failed to enable clk32kg: %d\n", ret);
> +
> +       return ret;
> +}
> +
> +static void palmas_unprepare_clk32kg(struct clk_hw *hw)
> +{
> +       struct palmas_clk *palmas_clk = container_of(hw, struct palmas_clk,
> +                       clk32kg);
> +       int ret;
> +
> +       ret = palmas_clock_clrbits(palmas_clk->palmas,
> +                       PALMAS_CLK32KG_CTRL, PALMAS_CLK32KG_CTRL_MODE_ACTIVE);
> +       if (ret)
> +               dev_err(palmas_clk->dev, "Failed to enable clk32kg: %d\n", ret);
> +
> +       return;
> +}
> +
> +static const struct clk_ops palmas_clk32kg_ops = {
> +       .prepare = palmas_prepare_clk32kg,
> +       .unprepare = palmas_unprepare_clk32kg,
> +};
> +
> +static int palmas_prepare_clk32kgaudio(struct clk_hw *hw)
> +{
> +       struct palmas_clk *palmas_clk = container_of(hw, struct palmas_clk,
> +                       clk32kgaudio);
> +       int ret;
> +
> +       ret = palmas_clock_setbits(palmas_clk->palmas,
> +               PALMAS_CLK32KGAUDIO_CTRL, PALMAS_CLK32KGAUDIO_CTRL_MODE_ACTIVE);
> +       if (ret)
> +               dev_err(palmas_clk->dev,
> +                               "Failed to enable clk32kgaudio: %d\n", ret);
> +
> +       return ret;
> +}
> +
> +static void palmas_unprepare_clk32kgaudio(struct clk_hw *hw)
> +{
> +       struct palmas_clk *palmas_clk = container_of(hw, struct palmas_clk,
> +                       clk32kgaudio);
> +       int ret;
> +
> +       ret = palmas_clock_clrbits(palmas_clk->palmas,
> +               PALMAS_CLK32KGAUDIO_CTRL, PALMAS_CLK32KGAUDIO_CTRL_MODE_ACTIVE);
> +       if (ret)
> +               dev_err(palmas_clk->dev,
> +                               "Failed to enable clk32kgaudio: %d\n", ret);
> +
> +       return;
> +}
> +
> +static const struct clk_ops palmas_clk32kgaudio_ops = {
> +       .prepare = palmas_prepare_clk32kgaudio,
> +       .unprepare = palmas_unprepare_clk32kgaudio,
> +};
> +
> +static int palmas_initialise_clk(struct palmas_clk *palmas_clk)
> +{
> +       int ret;
> +
> +       if (palmas_clk->clk32kg_mode_sleep) {
> +               ret = palmas_clock_setbits(palmas_clk->palmas,
> +                       PALMAS_CLK32KG_CTRL, PALMAS_CLK32KG_CTRL_MODE_SLEEP);
> +               if (ret)
> +                       return ret;
> +       }
> +
> +       if (palmas_clk->clk32kgaudio_mode_sleep) {
> +               ret = palmas_clock_setbits(palmas_clk->palmas,
> +                       PALMAS_CLK32KGAUDIO_CTRL,
> +                       PALMAS_CLK32KGAUDIO_CTRL_MODE_SLEEP);
> +               if (ret)
> +                       return ret;
> +       }
> +
> +       return 0;
> +}
> +
> +static void palmas_dt_to_pdata(struct device_node *node,
> +               struct palmas_clk_platform_data *pdata)
> +{
> +       int ret;
> +       u32 prop;
> +
> +       ret = of_property_read_u32(node, "ti,clk32kg-mode-sleep", &prop);
> +       if (!ret)
> +               pdata->clk32kg_mode_sleep = prop;
> +
> +       ret = of_property_read_u32(node, "ti,clk32kgaudio-mode-sleep", &prop);
> +       if (!ret)
> +               pdata->clk32kgaudio_mode_sleep = prop;
> +}
> +
> +static int palmas_clk_probe(struct platform_device *pdev)
> +{
> +       struct palmas *palmas = dev_get_drvdata(pdev->dev.parent);
> +       struct palmas_clk_platform_data *pdata = pdev->dev.platform_data;
> +       struct device_node *node = pdev->dev.of_node;
> +       struct palmas_clk *palmas_clk;
> +       struct clk *clk;
> +       struct clk_init_data init_clk32g, init_clk32gaudio;
> +       int ret;
> +
> +       if (node && !pdata) {
> +               pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
> +
> +               if (!pdata)
> +                       return -ENOMEM;
> +
> +               palmas_dt_to_pdata(node, pdata);
> +       }
> +
> +       palmas_clk = devm_kzalloc(&pdev->dev, sizeof(*palmas_clk), GFP_KERNEL);
> +       if (!palmas_clk)
> +               return -ENOMEM;
> +
> +       palmas_clk->palmas = palmas;
> +       palmas_clk->dev = &pdev->dev;
> +
> +       init_clk32g.name = "clk32kg";
> +       init_clk32g.ops = &palmas_clk32kg_ops;
> +       init_clk32g.parent_names = NULL;
> +       init_clk32g.num_parents = 0;
> +       palmas_clk->clk32kg.init = &init_clk32g;
> +
> +       clk = clk_register(palmas_clk->dev, &palmas_clk->clk32kg);
> +       if (IS_ERR(clk)) {
> +               dev_dbg(&pdev->dev, "clk32kg clock register failed %ld\n",
> +                               PTR_ERR(clk));
> +               ret = PTR_ERR(clk);
> +               goto err_clk32kg;
> +       }
> +
> +       init_clk32gaudio.name = "clk32kgaudio";
> +       init_clk32gaudio.ops = &palmas_clk32kgaudio_ops;
> +       init_clk32gaudio.parent_names = NULL;
> +       init_clk32gaudio.num_parents = 0;
> +       palmas_clk->clk32kgaudio.init = &init_clk32gaudio;
> +
> +       clk = clk_register(palmas_clk->dev, &palmas_clk->clk32kgaudio);
> +       if (IS_ERR(clk)) {
> +               dev_dbg(&pdev->dev, "clk32kgaudio clock register failed %ld\n",
> +               PTR_ERR(clk));
> +               ret = PTR_ERR(clk);
> +               goto err_audio;
> +       }
> +
> +       ret = palmas_initialise_clk(palmas_clk);
> +       if (ret)
> +               goto err;
> +
> +       dev_set_drvdata(&pdev->dev, palmas_clk);
> +
> +       return 0;
> +
> +err:
> +       clk_unregister(palmas_clk->clk32kgaudio.clk);
> +err_audio:
> +       clk_unregister(palmas_clk->clk32kg.clk);
> +err_clk32kg:
> +
> +       return ret;
> +}
> +
> +static int palmas_clk_remove(struct platform_device *pdev)
> +{
> +       struct palmas_clk *palmas_clk = dev_get_drvdata(&pdev->dev);
> +
> +       clk_unregister(palmas_clk->clk32kgaudio.clk);
> +       clk_unregister(palmas_clk->clk32kg.clk);
> +
> +       return 0;
> +}
> +
> +static struct of_device_id of_palmas_match_tbl[] = {
> +       { .compatible = "ti,palmas-clk", },
> +       { .compatible = "ti,palmas-charger-clk", },
> +       { .compatible = "ti,twl6035-clk", },
> +       { .compatible = "ti,twl6036-clk", },
> +       { .compatible = "ti,twl6037-clk", },
> +       { .compatible = "ti,tps65913-clk", },
> +       { .compatible = "ti,tps65914-clk", },
> +       { .compatible = "ti,tps80036-clk", },
> +       { /* end */ }
> +};
> +MODULE_DEVICE_TABLE(of, of_palmas_match_tbl);
> +
> +static struct platform_driver palmas_clk_driver = {
> +       .probe = palmas_clk_probe,
> +       .remove = palmas_clk_remove,
> +       .driver = {
> +               .name = "palmas-clk",
> +               .of_match_table = of_palmas_match_tbl,
> +               .owner = THIS_MODULE,
> +       },
> +};
> +
> +module_platform_driver(palmas_clk_driver);
> +
> +MODULE_AUTHOR("Graeme Gregory <gg@slimlogic.co.uk>");
> +MODULE_DESCRIPTION("PALMAS clock driver");
> +MODULE_LICENSE("GPL");
> +MODULE_ALIAS("platform:palmas-clk");
> -- 
> 1.7.0.4
