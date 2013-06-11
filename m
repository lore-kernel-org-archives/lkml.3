Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756939Ab3FKUGU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 16:06:20 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:40582 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756924Ab3FKUGQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 16:06:16 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: =?utf-8?q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <201306111331.31517.heiko@sntech.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        Jaehoon Chung <jh80.chung@samsung.com>, Chris Ball <cjb@laptop.org>,
        linux-mmc@vger.kernel.org, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        devicetree-discuss@lists.ozlabs.org,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>
References: <201306111328.52679.heiko@sntech.de> <201306111331.31517.heiko@sntech.de>
Message-ID: <20130611200610.8816.68285@quantum>
User-Agent: alot/0.3.4
Subject: Re: [PATCH v3 5/7] clk: add basic Rockchip rk3066a clock support
Date: Tue, 11 Jun 2013 13:06:10 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Heiko Stübner (2013-06-11 04:31:31)
> This adds basic support for clocks on Rockchip rk3066 SoCs.
> The clock handling thru small dt nodes is heavily inspired by the
> sunxi clk code.
> 
> The plls are currently read-only, as their setting needs more
> investigation. This also results in slow cpu speeds, as the apll starts
> at a default of 600mhz.
> 
> Signed-off-by: Heiko Stuebner <heiko@sntech.de>
> ---
>  arch/arm/boot/dts/rk3066a-clocks.dtsi   |  467 +++++++++++++++++++++++++++++++

It's best to separate the DT data changes from the clock driver.  The
new dtsi can be a separate patch.

Also the rockchip clock bindings need to be documented in
Documentation/devicetree/bindings/clock.

<snip>

> diff --git a/drivers/clk/rockchip/clk-rockchip-pll.c b/drivers/clk/rockchip/clk-rockchip-pll.c
> new file mode 100644
> index 0000000..4456445
> --- /dev/null
> +++ b/drivers/clk/rockchip/clk-rockchip-pll.c
> @@ -0,0 +1,131 @@
> +/*
> + * Copyright (c) 2013 MundoReader S.L.
> + * Author: Heiko Stuebner <heiko@sntech.de>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <asm/div64.h>
> +#include <linux/slab.h>
> +#include <linux/io.h>
> +#include <linux/clk.h>
> +#include <linux/clk-private.h>

NACK.  Please use clk-provider.h.  Do you really need something from
clk-private.h?

> +
> +#define RK3X_PLL_MODE_MASK             0x3
> +#define RK3X_PLL_MODE_SLOW             0x0
> +#define RK3X_PLL_MODE_NORM             0x1
> +#define RK3X_PLL_MODE_DEEP             0x2
> +
> +#define RK3X_PLLCON0_OD_MASK           0xf
> +#define RK3X_PLLCON0_OD_SHIFT          0
> +#define RK3X_PLLCON0_NR_MASK           0x3f
> +#define RK3X_PLLCON0_NR_SHIFT          8
> +
> +#define RK3X_PLLCON1_NF_MASK           0x1fff
> +#define RK3X_PLLCON1_NF_SHIFT          0
> +
> +#define RK3X_PLLCON3_REST              (1 << 5)
> +#define RK3X_PLLCON3_BYPASS            (1 << 0)
> +
> +struct rockchip_clk_pll {
> +       struct clk_hw           hw;
> +       void __iomem            *reg_base;
> +       void __iomem            *reg_mode;
> +       unsigned int            shift_mode;
> +       spinlock_t              *lock;
> +};
> +
> +#define to_clk_pll(_hw) container_of(_hw, struct rockchip_clk_pll, hw)
> +
> +static unsigned long rk3x_generic_pll_recalc_rate(struct clk_hw *hw,
> +                               unsigned long parent_rate)
> +{
> +       struct rockchip_clk_pll *pll = to_clk_pll(hw);
> +       u32 pll_con0 = readl_relaxed(pll->reg_base);
> +       u32 pll_con1 = readl_relaxed(pll->reg_base + 0x4);
> +       u32 pll_con3 = readl_relaxed(pll->reg_base + 0xc);
> +       u32 mode_con = readl_relaxed(pll->reg_mode) >> pll->shift_mode;
> +       u64 pll_nf;
> +       u64 pll_nr;
> +       u64 pll_no;
> +       u64 rate64;
> +
> +       if (pll_con3 & RK3X_PLLCON3_BYPASS) {
> +               pr_debug("%s: pll %s is bypassed\n", __func__,
> +                       __clk_get_name(hw->clk));
> +               return parent_rate;
> +       }
> +
> +       mode_con &= RK3X_PLL_MODE_MASK;
> +       if (mode_con != RK3X_PLL_MODE_NORM) {
> +               pr_debug("%s: pll %s not in normal mode: %d\n", __func__,
> +                       __clk_get_name(hw->clk), mode_con);
> +               return parent_rate;
> +       }
> +
> +       pll_nf = (pll_con1 >> RK3X_PLLCON1_NF_SHIFT);
> +       pll_nf &= RK3X_PLLCON1_NF_MASK;
> +       pll_nf++;
> +       rate64 = (u64)parent_rate * pll_nf;
> +
> +       pll_nr = (pll_con0 >> RK3X_PLLCON0_NR_SHIFT);
> +       pll_nr &= RK3X_PLLCON0_NR_MASK;
> +       pll_nr++;
> +       do_div(rate64, pll_nr);
> +
> +       pll_no = (pll_con0 >> RK3X_PLLCON0_OD_SHIFT);
> +       pll_no &= RK3X_PLLCON0_OD_MASK;
> +       pll_no++;
> +       do_div(rate64, pll_no);
> +
> +       return (unsigned long)rate64;
> +}
> +
> +static const struct clk_ops rk3x_generic_pll_clk_ops = {
> +       .recalc_rate = rk3x_generic_pll_recalc_rate,
> +};
> +
> +struct clk * __init rockchip_clk_register_rk3x_pll(const char *name,
> +                       const char *pname, void __iomem *reg_base,
> +                       void __iomem *reg_mode, unsigned int shift_mode,
> +                       spinlock_t *lock)
> +{
> +       struct rockchip_clk_pll *pll;
> +       struct clk *clk;
> +       struct clk_init_data init;
> +
> +       pll = kzalloc(sizeof(*pll), GFP_KERNEL);
> +       if (!pll) {
> +               pr_err("%s: could not allocate pll clk %s\n", __func__, name);
> +               return NULL;
> +       }
> +
> +       init.name = name;
> +       init.ops = &rk3x_generic_pll_clk_ops;
> +       init.flags = CLK_GET_RATE_NOCACHE;
> +       init.parent_names = &pname;
> +       init.num_parents = 1;
> +
> +       pll->hw.init = &init;
> +       pll->reg_base = reg_base;
> +       pll->reg_mode = reg_mode;
> +       pll->shift_mode = shift_mode;
> +       pll->lock = lock;
> +
> +       clk = clk_register(NULL, &pll->hw);
> +       if (IS_ERR(clk)) {
> +               pr_err("%s: failed to register pll clock %s\n", __func__,
> +                               name);
> +               kfree(pll);
> +       }
> +
> +       return clk;
> +}
> diff --git a/drivers/clk/rockchip/clk-rockchip-pll.h b/drivers/clk/rockchip/clk-rockchip-pll.h
> new file mode 100644
> index 0000000..a63288a
> --- /dev/null
> +++ b/drivers/clk/rockchip/clk-rockchip-pll.h
> @@ -0,0 +1,19 @@
> +/*
> + * Copyright (c) 2013 MundoReader S.L.
> + * Author: Heiko Stuebner <heiko@sntech.de>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +extern struct clk * __init rockchip_clk_register_rk3x_pll(const char *name,
> +                       const char *pname, const void __iomem *reg_base,
> +                       const void __iomem *reg_mode, unsigned int shift_mode,
> +                       spinlock_t *lock);
> diff --git a/drivers/clk/rockchip/clk-rockchip.c b/drivers/clk/rockchip/clk-rockchip.c
> new file mode 100644
> index 0000000..660b00f
> --- /dev/null
> +++ b/drivers/clk/rockchip/clk-rockchip.c
> @@ -0,0 +1,330 @@
> +/*
> + * Copyright (c) 2013 MundoReader S.L.
> + * Author: Heiko Stuebner <heiko@sntech.de>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <linux/clk-provider.h>
> +#include <linux/clkdev.h>
> +#include <linux/of.h>
> +#include <linux/of_address.h>
> +
> +#include "clk-rockchip-pll.h"
> +
> +static DEFINE_SPINLOCK(clk_lock);
> +
> +struct rockchip_pll_data {
> +       int mode_shift;
> +};
> +
> +struct rockchip_pll_data rk3066a_apll_data = {
> +       .mode_shift = 0,
> +};
> +
> +struct rockchip_pll_data rk3066a_dpll_data = {
> +       .mode_shift = 4,
> +};
> +
> +struct rockchip_pll_data rk3066a_cpll_data = {
> +       .mode_shift = 8,
> +};
> +
> +struct rockchip_pll_data rk3066a_gpll_data = {
> +       .mode_shift = 12,
> +};
> +
> +/* Matches for plls */
> +static const __initconst struct of_device_id clk_pll_match[] = {
> +       { .compatible = "rockchip,rk3066a-apll", .data = &rk3066a_apll_data },
> +       { .compatible = "rockchip,rk3066a-dpll", .data = &rk3066a_dpll_data },
> +       { .compatible = "rockchip,rk3066a-cpll", .data = &rk3066a_cpll_data },
> +       { .compatible = "rockchip,rk3066a-gpll", .data = &rk3066a_gpll_data },
> +       {}
> +};
> +
> +static void __init rockchip_pll_setup(struct device_node *node,
> +                                     struct rockchip_pll_data *data)
> +{
> +       struct clk *clk;
> +       const char *clk_name = node->name;
> +       const char *clk_parent;
> +       void __iomem *reg_base;
> +       void __iomem *reg_mode;
> +       u32 rate;
> +
> +       reg_base = of_iomap(node, 0);
> +       reg_mode = of_iomap(node, 1);
> +
> +       clk_parent = of_clk_get_parent_name(node, 0);
> +
> +       pr_debug("%s: adding %s as child of %s\n",
> +               __func__, clk_name, clk_parent);
> +
> +       clk = rockchip_clk_register_rk3x_pll(clk_name, clk_parent, reg_base,
> +                                            reg_mode, data->mode_shift,
> +                                            &clk_lock);
> +       if (clk) {
> +               of_clk_add_provider(node, of_clk_src_simple_get, clk);
> +
> +               /* optionally set a target frequency for the pll */
> +               if (!of_property_read_u32(node, "clock-frequency", &rate))
> +                       clk_set_rate(clk, rate);
> +       }
> +}
> +
> +/*
> + * Mux clocks
> + */
> +
> +struct rockchip_mux_data {
> +       int shift;
> +       int width;
> +};
> +
> +#define RK_MUX(n, s, w)                                        \
> +static const __initconst struct rockchip_mux_data n = {        \
> +       .shift = s,                                     \
> +       .width = w,                                     \
> +}
> +
> +RK_MUX(gpll_cpll_15_mux_data, 15, 1);
> +RK_MUX(uart_mux_data, 8, 2);
> +RK_MUX(cpu_mux_data, 8, 1);
> +
> +static const __initconst struct of_device_id clk_mux_match[] = {
> +       { .compatible = "rockchip,rk2928-gpll-cpll-bit15-mux",
> +               .data = &gpll_cpll_15_mux_data },
> +       { .compatible = "rockchip,rk2928-uart-mux",
> +               .data = &uart_mux_data },
> +       { .compatible = "rockchip,rk3066-cpu-mux",
> +               .data = &cpu_mux_data },
> +       {}
> +};
> +
> +static void __init rockchip_mux_clk_setup(struct device_node *node,
> +                                         struct rockchip_mux_data *data)
> +{
> +       struct clk *clk;
> +       const char *clk_name = node->name;
> +       void __iomem *reg;
> +       int max_parents = (1 << data->width);
> +       const char *parents[max_parents];
> +       int flags;
> +       int i = 0;
> +
> +       reg = of_iomap(node, 0);
> +
> +       while (i < max_parents &&
> +              (parents[i] = of_clk_get_parent_name(node, i)) != NULL)
> +               i++;
> +
> +       flags = CLK_MUX_HIWORD_MASK;
> +
> +       clk = clk_register_mux(NULL, clk_name, parents, i, 0,
> +                              reg, data->shift, data->width,
> +                              flags, &clk_lock);
> +       if (clk)
> +               of_clk_add_provider(node, of_clk_src_simple_get, clk);
> +}
> +
> +/*
> + * Divider clocks
> + */
> +
> +struct rockchip_div_data {
> +       int shift;
> +       int width;
> +       int flags;
> +       struct clk_div_table *table;
> +};
> +
> +#define RK_DIV(n, s, w, f, t)                          \
> +static const __initconst struct rockchip_div_data n = {        \
> +       .shift = s,                                     \
> +       .width = w,                                     \
> +       .flags = f,                                     \
> +       .table = t,                                     \
> +}
> +
> +RK_DIV(cpu_div_data, 0, 5, 0, NULL);
> +RK_DIV(aclk_periph_div_data, 0, 5, 0, NULL);
> +RK_DIV(aclk_cpu_div_data, 0, 3, 0, NULL);
> +RK_DIV(hclk_div_data, 8, 2, CLK_DIVIDER_POWER_OF_TWO, NULL);
> +RK_DIV(pclk_div_data, 12, 2, CLK_DIVIDER_POWER_OF_TWO, NULL);
> +RK_DIV(mmc_div_data, 0, 6, CLK_DIVIDER_EVEN, NULL);
> +RK_DIV(uart_div_data, 0, 7, 0, NULL);
> +
> +struct clk_div_table core_periph_table[] = {
> +       { 0, 2 },
> +       { 1, 4 },
> +       { 2, 8 },
> +       { 3, 16 },
> +       { 0, 0 },
> +};
> +RK_DIV(core_periph_div_data, 6, 2, 0, core_periph_table);
> +
> +static const __initconst struct of_device_id clk_divider_match[] = {
> +       { .compatible = "rockchip,rk3066a-cpu-divider",
> +               .data = &cpu_div_data },
> +       { .compatible = "rockchip,rk3066a-core-periph-divider",
> +               .data = &core_periph_div_data },
> +       { .compatible = "rockchip,rk2928-aclk-periph-divider",
> +               .data = &aclk_periph_div_data },
> +       { .compatible = "rockchip,rk3066a-aclk-cpu-divider",
> +               .data = &aclk_cpu_div_data },
> +       { .compatible = "rockchip,rk2928-hclk-divider",
> +               .data = &hclk_div_data },
> +       { .compatible = "rockchip,rk2928-pclk-divider",
> +               .data = &pclk_div_data },
> +       { .compatible = "rockchip,rk2928-mmc-divider",
> +               .data = &mmc_div_data },
> +       { .compatible = "rockchip,rk2928-uart-divider",
> +               .data = &uart_div_data },
> +       {}
> +};
> +
> +static void __init rockchip_divider_clk_setup(struct device_node *node,
> +                                             struct rockchip_div_data *data)
> +{
> +       struct clk *clk;
> +       const char *clk_name = node->name;
> +       const char *clk_parent;
> +       void __iomem *reg;
> +       int flags;
> +
> +       reg = of_iomap(node, 0);
> +
> +       clk_parent = of_clk_get_parent_name(node, 0);
> +
> +       flags = data->flags;
> +       flags |= CLK_DIVIDER_HIWORD_MASK;
> +
> +       if (data->table)
> +               clk = clk_register_divider_table(NULL, clk_name, clk_parent, 0,
> +                                               reg, data->shift, data->width,
> +                                               flags, data->table, &clk_lock);
> +       else
> +               clk = clk_register_divider(NULL, clk_name, clk_parent, 0,
> +                                               reg, data->shift, data->width,
> +                                               flags, &clk_lock);
> +       if (clk)
> +               of_clk_add_provider(node, of_clk_src_simple_get, clk);
> +}
> +
> +/*
> + * Gate clocks
> + */
> +
> +static void __init rockchip_gate_clk_setup(struct device_node *node,
> +                                           void *data)
> +{
> +       struct clk_onecell_data *clk_data;
> +       const char *clk_parent;
> +       const char *clk_name;
> +       void __iomem *reg;
> +       void __iomem *reg_idx;
> +       int flags;
> +       int qty;
> +       int reg_bit;
> +       int clkflags = CLK_SET_RATE_PARENT;
> +       int i;
> +
> +       qty = of_property_count_strings(node, "clock-output-names");
> +       if (qty < 0) {
> +               pr_err("%s: error in clock-output-names %d\n", __func__, qty);
> +               return;
> +       }
> +
> +       if (qty == 0) {
> +               pr_info("%s: nothing to do\n", __func__);
> +               return;
> +       }
> +
> +       reg = of_iomap(node, 0);
> +
> +       clk_data = kzalloc(sizeof(struct clk_onecell_data), GFP_KERNEL);
> +       if (!clk_data)
> +               return;
> +
> +       clk_data->clks = kzalloc(qty * sizeof(struct clk *), GFP_KERNEL);
> +       if (!clk_data->clks) {
> +               kfree(clk_data);
> +               return;
> +       }
> +
> +       flags = CLK_GATE_HIWORD_MASK | CLK_GATE_SET_TO_DISABLE;
> +
> +       for (i = 0; i < qty; i++) {
> +               of_property_read_string_index(node, "clock-output-names",
> +                                             i, &clk_name);
> +
> +               /* ignore empty slots */
> +               if (!strcmp("reserved", clk_name))
> +                       continue;
> +
> +               clk_parent = of_clk_get_parent_name(node, i);
> +
> +               /* keep all gates untouched for now */
> +               clkflags |= CLK_IGNORE_UNUSED;
> +
> +               reg_idx = reg + (4 * (i / 16));
> +               reg_bit = (i % 16);
> +
> +               clk_data->clks[i] = clk_register_gate(NULL, clk_name,
> +                                                     clk_parent, clkflags,
> +                                                     reg_idx, reg_bit,
> +                                                     flags,
> +                                                     &clk_lock);
> +               WARN_ON(IS_ERR(clk_data->clks[i]));
> +       }
> +
> +       clk_data->clk_num = qty;
> +
> +       of_clk_add_provider(node, of_clk_src_onecell_get, clk_data);
> +}
> +
> +static const __initconst struct of_device_id clk_gate_match[] = {
> +       { .compatible = "rockchip,rk2928-gate-clk" },
> +       {}
> +};
> +
> +void __init of_rockchip_clk_table_clock_setup(
> +                                       const struct of_device_id *clk_match,
> +                                       void *function)
> +{
> +       struct device_node *np;
> +       const struct div_data *data;
> +       const struct of_device_id *match;
> +       void (*setup_function)(struct device_node *, const void *) = function;
> +
> +       for_each_matching_node(np, clk_match) {
> +               match = of_match_node(clk_match, np);
> +               data = match->data;
> +               setup_function(np, data);
> +       }
> +}

Can you use of_clk_init instead of the above function?

Regards,
Mike

> +
> +void __init rockchip_init_clocks(struct device_node *node)
> +{
> +       of_rockchip_clk_table_clock_setup(clk_pll_match,
> +                                         rockchip_pll_setup);
> +
> +       of_rockchip_clk_table_clock_setup(clk_mux_match,
> +                                         rockchip_mux_clk_setup);
> +
> +       of_rockchip_clk_table_clock_setup(clk_gate_match,
> +                                         rockchip_gate_clk_setup);
> +
> +       of_rockchip_clk_table_clock_setup(clk_divider_match,
> +                                         rockchip_divider_clk_setup);
> +}
> +CLK_OF_DECLARE(rockchip_clocks, "rockchip,clocks", rockchip_init_clocks);
> -- 
> 1.7.2.3
