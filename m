Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933318AbaHYR74 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 13:59:56 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:48758 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933043AbaHYR7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 13:59:52 -0400
MIME-Version: 1.0
In-Reply-To: <1408973962-23883-1-git-send-email-zyw@rock-chips.com>
References: <1408973962-23883-1-git-send-email-zyw@rock-chips.com>
Date: Mon, 25 Aug 2014 10:59:52 -0700
X-Google-Sender-Auth: 2yAb6IeRf_P9gw6KD_sttJkjf7w
Message-ID: <CAD=FV=U+AkhkebTGi7i06rzh=me3wcsu1S-wjdA8PbGT9xux+Q@mail.gmail.com>
Subject: Re: [PATCH v5 5/5] clk: RK808: Add clkout driver for RK808
From: Doug Anderson <dianders@chromium.org>
To: Chris Zhong <zyw@rock-chips.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Mike Turquette <mturquette@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        rtc-linux@googlegroups.com, Grant Likely <grant.likely@linaro.org>,
        Lin Huang <hl@rock-chips.com>, Tao Huang <huangtao@rock-chips.com>,
        Eddie Cai <cf@rock-chips.com>, zhangqing <zhangqing@rock-chips.com>,
        xxx <xxx@rock-chips.com>,
        =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        Olof Johansson <olof@lixom.net>, Sonny Rao <sonnyrao@chromium.org>,
        Dmitry Torokhov <dtor@chromium.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Kever Yang <kever.yang@rock-chips.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris,

On Mon, Aug 25, 2014 at 6:39 AM, Chris Zhong <zyw@rock-chips.com> wrote:
> Signed-off-by: Chris Zhong <zyw@rock-chips.com>
>
> ---
>
> Changes in v5:
> Advices by Mark Brown
> - add description about regulator valid name.
> - add a header file "rockchip,rk808".
>
> Changes in v4:
> Advices by Doug
> - add a "#clock-cells" propertiy
> - update the example
>
> Changes in v3: None
> Changes in v2: None
>
>  drivers/clk/Kconfig     |    9 +++
>  drivers/clk/Makefile    |    1 +
>  drivers/clk/clk-rk808.c |  164 +++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 174 insertions(+)
>  create mode 100644 drivers/clk/clk-rk808.c
>
> diff --git a/drivers/clk/Kconfig b/drivers/clk/Kconfig
> index cfd3af7..84e0590 100644
> --- a/drivers/clk/Kconfig
> +++ b/drivers/clk/Kconfig
> @@ -38,6 +38,15 @@ config COMMON_CLK_MAX77686
>         ---help---
>           This driver supports Maxim 77686 crystal oscillator clock.
>
> +config COMMON_CLK_RK808
> +       tristate "Clock driver for RK808"
> +       depends on MFD_RK808
> +       ---help---
> +         This driver supports RK808 crystal oscillator clock. These
> +         multi-function devices have two fixed-rate oscillators,
> +         clocked at 32KHz each. Clkout1 is always on, Clkout2 can off
> +         by control register.
> +
>  config COMMON_CLK_SI5351
>         tristate "Clock driver for SiLabs 5351A/B/C"
>         depends on I2C
> diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
> index f537a0b..99f53d5 100644
> --- a/drivers/clk/Makefile
> +++ b/drivers/clk/Makefile
> @@ -28,6 +28,7 @@ obj-$(CONFIG_ARCH_NOMADIK)            += clk-nomadik.o
>  obj-$(CONFIG_ARCH_NSPIRE)              += clk-nspire.o
>  obj-$(CONFIG_COMMON_CLK_PALMAS)                += clk-palmas.o
>  obj-$(CONFIG_CLK_PPC_CORENET)          += clk-ppc-corenet.o
> +obj-$(CONFIG_COMMON_CLK_RK808)         += clk-rk808.o
>  obj-$(CONFIG_COMMON_CLK_S2MPS11)       += clk-s2mps11.o
>  obj-$(CONFIG_COMMON_CLK_SI5351)                += clk-si5351.o
>  obj-$(CONFIG_COMMON_CLK_SI570)         += clk-si570.o
> diff --git a/drivers/clk/clk-rk808.c b/drivers/clk/clk-rk808.c
> new file mode 100644
> index 0000000..a8f8d81
> --- /dev/null
> +++ b/drivers/clk/clk-rk808.c
> @@ -0,0 +1,164 @@
> +/*
> + * Clkout driver for Rockchip RK808
> + *
> + * Copyright (c) 2014, Fuzhou Rockchip Electronics Co., Ltd
> + *
> + * Author: Chris Zhong <zyw@rock-chips.com>
> + * Author: Zhang Qing <zhangqing@rock-chips.com>
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms and conditions of the GNU General Public License,
> + * version 2, as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope it will be useful, but WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> + * more details.
> + */
> +
> +#include <linux/clk.h>
> +#include <linux/clk-provider.h>
> +#include <linux/module.h>
> +#include <linux/slab.h>
> +#include <linux/platform_device.h>
> +#include <linux/mfd/rk808.h>
> +#include <linux/i2c.h>
> +
> +struct rk808_clkout {
> +       struct rk808 *rk808;
> +       struct clk_onecell_data clk_data;
> +       struct clk_hw           clkout1_hw;
> +       struct clk_hw           clkout2_hw;
> +};
> +
> +static unsigned long rk808_clkout_recalc_rate(struct clk_hw *hw,
> +                                             unsigned long parent_rate)
> +{
> +       return 32768;
> +}
> +
> +static int rk808_clkout1_is_prepared(struct clk_hw *hw)
> +{
> +       return 1;
> +}
> +
> +static int rk808_clkout2_control(struct clk_hw *hw, bool enable)
> +{
> +       struct rk808_clkout *rk808_clkout = container_of(hw,
> +                                                        struct rk808_clkout,
> +                                                        clkout2_hw);
> +       struct rk808 *rk808 = rk808_clkout->rk808;
> +
> +       return regmap_update_bits(rk808->regmap, RK808_CLK32OUT_REG,
> +                                 CLK32KOUT2_EN, enable ? CLK32KOUT2_EN : 0);
> +}
> +
> +static int rk808_clkout2_prepare(struct clk_hw *hw)
> +{
> +       return rk808_clkout2_control(hw, 1);
> +}
> +
> +static void rk808_clkout2_unprepare(struct clk_hw *hw)
> +{
> +       rk808_clkout2_control(hw, 0);
> +}
> +
> +static int rk808_clkout2_is_prepared(struct clk_hw *hw)
> +{
> +       struct rk808_clkout *rk808_clkout = container_of(hw,
> +                                                        struct rk808_clkout,
> +                                                        clkout2_hw);
> +       struct rk808 *rk808 = rk808_clkout->rk808;
> +       uint32_t val;
> +
> +       int ret = regmap_read(rk808->regmap, RK808_CLK32OUT_REG, &val);
> +
> +       if (ret < 0)
> +               return ret;
> +
> +       return (val & CLK32KOUT2_EN) ? 1 : 0;
> +}
> +
> +static const struct clk_ops rk808_clkout1_ops = {
> +       .is_prepared = rk808_clkout1_is_prepared,
> +       .recalc_rate = rk808_clkout_recalc_rate,
> +};
> +
> +static const struct clk_ops rk808_clkout2_ops = {
> +       .prepare = rk808_clkout2_prepare,
> +       .unprepare = rk808_clkout2_unprepare,
> +       .is_prepared = rk808_clkout2_is_prepared,
> +       .recalc_rate = rk808_clkout_recalc_rate,
> +};
> +
> +static int rk808_clkout_probe(struct platform_device *pdev)
> +{
> +       struct rk808 *rk808 = dev_get_drvdata(pdev->dev.parent);
> +       struct i2c_client *client = rk808->i2c;
> +       struct device_node *node = client->dev.of_node;
> +       struct clk_init_data init = {};
> +       struct clk **clk_table;
> +       struct rk808_clkout *rk808_clkout;
> +
> +       rk808_clkout = devm_kzalloc(&client->dev,
> +                                   sizeof(*rk808_clkout), GFP_KERNEL);
> +       if (!rk808_clkout)
> +               return -ENOMEM;
> +
> +       rk808_clkout->rk808 = rk808;
> +
> +       clk_table = devm_kzalloc(&client->dev,
> +                                2*sizeof(struct clk *), GFP_KERNEL);
> +       if (!clk_table)
> +               return -ENOMEM;
> +
> +       init.flags = CLK_IS_ROOT;
> +       init.parent_names = NULL;
> +       init.num_parents = 0;
> +       init.name = "rk808-clkout1";
> +       init.ops = &rk808_clkout1_ops;
> +       rk808_clkout->clkout1_hw.init = &init;
> +
> +       /* optional override of the clockname */
> +       of_property_read_string_index(node, "clock-output-names",
> +                                     0, &init.name);
> +
> +       clk_table[0] = devm_clk_register(&client->dev,
> +                                        &rk808_clkout->clkout1_hw);
> +       if (IS_ERR(clk_table[0]))
> +               return PTR_ERR(clk_table[0]);
> +
> +       init.name = "rk808-clkout2";
> +       init.ops = &rk808_clkout2_ops;
> +       rk808_clkout->clkout2_hw.init = &init;
> +
> +       /* optional override of the clockname */
> +       of_property_read_string_index(node, "clock-output-names",
> +                                     1, &init.name);
> +
> +       clk_table[1] = devm_clk_register(&client->dev,
> +                                        &rk808_clkout->clkout2_hw);
> +       if (IS_ERR(clk_table[1]))
> +               return PTR_ERR(clk_table[1]);
> +
> +       rk808_clkout->clk_data.clks = clk_table;
> +       rk808_clkout->clk_data.clk_num = 2;
> +
> +       return of_clk_add_provider(node, of_clk_src_onecell_get, clk_table);

I'm about 99.9% certain that the above line should be:

       return of_clk_add_provider(node, of_clk_src_onecell_get,
                                  &rk808_clkout->clk_data);

The data for of_clk_src_onecell_get() should be of type "struct
clk_onecell_data *".


Otherwise this looks good to me and you can add my Reviewed-by tag
(and even my Tested-by tag).

-Doug
