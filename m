Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755533Ab3HEXXn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 19:23:43 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:44818 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755069Ab3HEXXl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 19:23:41 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Yadwinder Singh Brar <yadi.brar@samsung.com>, linux-kernel@vger.kernel.org
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1373197462-4033-2-git-send-email-yadi.brar@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org, sbkim73@samsung.com,
        sameo@linux.intel.com, lee.jones@linaro.org, broonie@kernel.org,
        yadi.brar01@gmail.com, Yadwinder Singh Brar <yadi.brar@samsung.com>
References: <1373197462-4033-1-git-send-email-yadi.brar@samsung.com>
 <1373197462-4033-2-git-send-email-yadi.brar@samsung.com>
Message-ID: <20130805232337.5348.79716@quantum>
User-Agent: alot/0.3.4
Subject: Re: [PATCH 1/3] clk: s2mps11: Add support for s2mps11
Date: Mon, 05 Aug 2013 16:23:37 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Yadwinder Singh Brar (2013-07-07 04:44:20)
> This patch adds support to register three(AP/CP/BT) buffered 32.768 KHz
> outputs of mfd-s2mps11 with common clock framework.
> 
> Signed-off-by: Yadwinder Singh Brar <yadi.brar@samsung.com>

Yadwinder,

Looks good to me with the exception of a binding description document.
Can you provide one and squash it into this commit?

Thanks,
Mike

> ---
>  drivers/clk/Kconfig       |    6 +
>  drivers/clk/Makefile      |    1 +
>  drivers/clk/clk-s2mps11.c |  273 +++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 280 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/clk/clk-s2mps11.c
> 
> diff --git a/drivers/clk/Kconfig b/drivers/clk/Kconfig
> index 0357ac4..3fdf10e 100644
> --- a/drivers/clk/Kconfig
> +++ b/drivers/clk/Kconfig
> @@ -65,6 +65,12 @@ config COMMON_CLK_SI5351
>           This driver supports Silicon Labs 5351A/B/C programmable clock
>           generators.
>  
> +config COMMON_CLK_S2MPS11
> +       tristate "Clock driver for S2MPS11 MFD"
> +       depends on MFD_SEC_CORE
> +       ---help---
> +         This driver supports S2MPS11 crystal oscillator clock.
> +
>  config CLK_TWL6040
>         tristate "External McPDM functional clock from twl6040"
>         depends on TWL6040_CORE
> diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
> index 137d3e7..5fd642d 100644
> --- a/drivers/clk/Makefile
> +++ b/drivers/clk/Makefile
> @@ -38,4 +38,5 @@ obj-$(CONFIG_COMMON_CLK_AXI_CLKGEN) += clk-axi-clkgen.o
>  obj-$(CONFIG_COMMON_CLK_WM831X) += clk-wm831x.o
>  obj-$(CONFIG_COMMON_CLK_MAX77686) += clk-max77686.o
>  obj-$(CONFIG_COMMON_CLK_SI5351) += clk-si5351.o
> +obj-$(CONFIG_COMMON_CLK_S2MPS11) += clk-s2mps11.o
>  obj-$(CONFIG_CLK_TWL6040)      += clk-twl6040.o
> diff --git a/drivers/clk/clk-s2mps11.c b/drivers/clk/clk-s2mps11.c
> new file mode 100644
> index 0000000..7be41e6
> --- /dev/null
> +++ b/drivers/clk/clk-s2mps11.c
> @@ -0,0 +1,273 @@
> +/*
> + * clk-s2mps11.c - Clock driver for S2MPS11.
> + *
> + * Copyright (C) 2013 Samsung Electornics
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
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
> + *
> + */
> +
> +#include <linux/module.h>
> +#include <linux/err.h>
> +#include <linux/of.h>
> +#include <linux/clkdev.h>
> +#include <linux/regmap.h>
> +#include <linux/clk-provider.h>
> +#include <linux/platform_device.h>
> +#include <linux/mfd/samsung/s2mps11.h>
> +#include <linux/mfd/samsung/core.h>
> +
> +#define s2mps11_name(a) (a->hw.init->name)
> +
> +static struct clk **clk_table;
> +static struct clk_onecell_data clk_data;
> +
> +enum {
> +       S2MPS11_CLK_AP = 0,
> +       S2MPS11_CLK_CP,
> +       S2MPS11_CLK_BT,
> +       S2MPS11_CLKS_NUM,
> +};
> +
> +struct s2mps11_clk {
> +       struct sec_pmic_dev *iodev;
> +       struct clk_hw hw;
> +       struct clk *clk;
> +       struct clk_lookup *lookup;
> +       u32 mask;
> +       bool enabled;
> +};
> +
> +static struct s2mps11_clk *to_s2mps11_clk(struct clk_hw *hw)
> +{
> +       return container_of(hw, struct s2mps11_clk, hw);
> +}
> +
> +static int s2mps11_clk_prepare(struct clk_hw *hw)
> +{
> +       struct s2mps11_clk *s2mps11 = to_s2mps11_clk(hw);
> +       int ret;
> +
> +       ret = regmap_update_bits(s2mps11->iodev->regmap,
> +                               S2MPS11_REG_RTC_CTRL,
> +                                s2mps11->mask, s2mps11->mask);
> +       if (!ret)
> +               s2mps11->enabled = true;
> +
> +       return ret;
> +}
> +
> +static void s2mps11_clk_unprepare(struct clk_hw *hw)
> +{
> +       struct s2mps11_clk *s2mps11 = to_s2mps11_clk(hw);
> +       int ret;
> +
> +       ret = regmap_update_bits(s2mps11->iodev->regmap, S2MPS11_REG_RTC_CTRL,
> +                          s2mps11->mask, ~s2mps11->mask);
> +
> +       if (!ret)
> +               s2mps11->enabled = false;
> +}
> +
> +static int s2mps11_clk_is_enabled(struct clk_hw *hw)
> +{
> +       struct s2mps11_clk *s2mps11 = to_s2mps11_clk(hw);
> +
> +       return s2mps11->enabled;
> +}
> +
> +static unsigned long s2mps11_clk_recalc_rate(struct clk_hw *hw,
> +                                            unsigned long parent_rate)
> +{
> +       struct s2mps11_clk *s2mps11 = to_s2mps11_clk(hw);
> +       if (s2mps11->enabled)
> +               return 32768;
> +       else
> +               return 0;
> +}
> +
> +static struct clk_ops s2mps11_clk_ops = {
> +       .prepare        = s2mps11_clk_prepare,
> +       .unprepare      = s2mps11_clk_unprepare,
> +       .is_enabled     = s2mps11_clk_is_enabled,
> +       .recalc_rate    = s2mps11_clk_recalc_rate,
> +};
> +
> +static struct clk_init_data s2mps11_clks_init[S2MPS11_CLKS_NUM] = {
> +       [S2MPS11_CLK_AP] = {
> +               .name = "s2mps11_ap",
> +               .ops = &s2mps11_clk_ops,
> +               .flags = CLK_IS_ROOT,
> +       },
> +       [S2MPS11_CLK_CP] = {
> +               .name = "s2mps11_cp",
> +               .ops = &s2mps11_clk_ops,
> +               .flags = CLK_IS_ROOT,
> +       },
> +       [S2MPS11_CLK_BT] = {
> +               .name = "s2mps11_bt",
> +               .ops = &s2mps11_clk_ops,
> +               .flags = CLK_IS_ROOT,
> +       },
> +};
> +
> +static struct device_node *s2mps11_clk_parse_dt(struct platform_device *pdev)
> +{
> +       struct sec_pmic_dev *iodev = dev_get_drvdata(pdev->dev.parent);
> +       struct device_node *clk_np;
> +       int i;
> +
> +       if (!iodev->dev->of_node)
> +               return NULL;
> +
> +       clk_np = of_find_node_by_name(iodev->dev->of_node, "clocks");
> +       if (!clk_np) {
> +               dev_err(&pdev->dev, "could not find clock sub-node\n");
> +               return ERR_PTR(-EINVAL);
> +       }
> +
> +       clk_table = devm_kzalloc(&pdev->dev, sizeof(struct clk *) *
> +                                S2MPS11_CLKS_NUM, GFP_KERNEL);
> +       if (!clk_table)
> +               return ERR_PTR(-ENOMEM);
> +
> +       for (i = 0; i < S2MPS11_CLKS_NUM; i++)
> +               of_property_read_string_index(clk_np, "clock-output-names", i,
> +                               &s2mps11_clks_init[i].name);
> +
> +       return clk_np;
> +}
> +
> +static int s2mps11_clk_probe(struct platform_device *pdev)
> +{
> +       struct sec_pmic_dev *iodev = dev_get_drvdata(pdev->dev.parent);
> +       struct s2mps11_clk *s2mps11_clks, *s2mps11_clk;
> +       struct device_node *clk_np = NULL;
> +       int i, ret = 0;
> +       u32 val;
> +
> +       s2mps11_clks = devm_kzalloc(&pdev->dev, sizeof(*s2mps11_clk) *
> +                                       S2MPS11_CLKS_NUM, GFP_KERNEL);
> +       if (!s2mps11_clks)
> +               return -ENOMEM;
> +
> +       s2mps11_clk = s2mps11_clks;
> +
> +       clk_np = s2mps11_clk_parse_dt(pdev);
> +       if (IS_ERR(clk_np))
> +               return PTR_ERR(clk_np);
> +
> +       for (i = 0; i < S2MPS11_CLKS_NUM; i++, s2mps11_clk++) {
> +               s2mps11_clk->iodev = iodev;
> +               s2mps11_clk->hw.init = &s2mps11_clks_init[i];
> +               s2mps11_clk->mask = 1 << i;
> +
> +               ret = regmap_read(s2mps11_clk->iodev->regmap,
> +                                 S2MPS11_REG_RTC_CTRL, &val);
> +               if (ret < 0)
> +                       goto err_reg;
> +
> +               s2mps11_clk->enabled = val & s2mps11_clk->mask;
> +
> +               s2mps11_clk->clk = devm_clk_register(&pdev->dev,
> +                                                       &s2mps11_clk->hw);
> +               if (IS_ERR(s2mps11_clk->clk)) {
> +                       dev_err(&pdev->dev, "Fail to register : %s\n",
> +                                               s2mps11_name(s2mps11_clk));
> +                       ret = PTR_ERR(s2mps11_clk->clk);
> +                       goto err_reg;
> +               }
> +
> +               s2mps11_clk->lookup = devm_kzalloc(&pdev->dev,
> +                                       sizeof(struct clk_lookup), GFP_KERNEL);
> +               if (!s2mps11_clk->lookup) {
> +                       ret = -ENOMEM;
> +                       goto err_lup;
> +               }
> +
> +               s2mps11_clk->lookup->con_id = s2mps11_name(s2mps11_clk);
> +               s2mps11_clk->lookup->clk = s2mps11_clk->clk;
> +
> +               clkdev_add(s2mps11_clk->lookup);
> +       }
> +
> +       if (clk_table) {
> +               for (i = 0; i < S2MPS11_CLKS_NUM; i++)
> +                       clk_table[i] = s2mps11_clks[i].clk;
> +
> +               clk_data.clks = clk_table;
> +               clk_data.clk_num = S2MPS11_CLKS_NUM;
> +               of_clk_add_provider(clk_np, of_clk_src_onecell_get, &clk_data);
> +       }
> +
> +       platform_set_drvdata(pdev, s2mps11_clks);
> +
> +       return ret;
> +err_lup:
> +       devm_clk_unregister(&pdev->dev, s2mps11_clk->clk);
> +err_reg:
> +       while (s2mps11_clk > s2mps11_clks) {
> +               if (s2mps11_clk->lookup) {
> +                       clkdev_drop(s2mps11_clk->lookup);
> +                       devm_clk_unregister(&pdev->dev, s2mps11_clk->clk);
> +               }
> +               s2mps11_clk--;
> +       }
> +
> +       return ret;
> +}
> +
> +static int s2mps11_clk_remove(struct platform_device *pdev)
> +{
> +       struct s2mps11_clk *s2mps11_clks = platform_get_drvdata(pdev);
> +       int i;
> +
> +       for (i = 0; i < S2MPS11_CLKS_NUM; i++)
> +               clkdev_drop(s2mps11_clks[i].lookup);
> +
> +       return 0;
> +}
> +
> +static const struct platform_device_id s2mps11_clk_id[] = {
> +       { "s2mps11-clk", 0},
> +       { },
> +};
> +MODULE_DEVICE_TABLE(platform, s2mps11_clk_id);
> +
> +static struct platform_driver s2mps11_clk_driver = {
> +       .driver = {
> +               .name  = "s2mps11-clk",
> +               .owner = THIS_MODULE,
> +       },
> +       .probe = s2mps11_clk_probe,
> +       .remove = s2mps11_clk_remove,
> +       .id_table = s2mps11_clk_id,
> +};
> +
> +static int __init s2mps11_clk_init(void)
> +{
> +       return platform_driver_register(&s2mps11_clk_driver);
> +}
> +subsys_initcall(s2mps11_clk_init);
> +
> +static void __init s2mps11_clk_cleanup(void)
> +{
> +       platform_driver_unregister(&s2mps11_clk_driver);
> +}
> +module_exit(s2mps11_clk_cleanup);
> +
> +MODULE_DESCRIPTION("S2MPS11 Clock Driver");
> +MODULE_AUTHOR("Yadwinder Singh Brar <yadi.brar@samsung.com>");
> +MODULE_LICENSE("GPL");
> -- 
> 1.7.0.4
