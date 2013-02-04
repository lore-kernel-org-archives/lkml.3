Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752871Ab3BDHJO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 02:09:14 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:11410 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428Ab3BDHJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 02:09:13 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Sun, 03 Feb 2013 23:09:04 -0800
Message-ID: <510F5E87.90801@nvidia.com>
Date: Mon, 4 Feb 2013 12:38:55 +0530
From: Prashant Gaikwad <pgaikwad@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Russell King <linux@arm.linux.org.uk>, Simon Glass <sjg@chromium.org>,
        Mike Turquette <mturquette@linaro.org>, Joseph Lo <josephl@nvidia.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v5 09/10] clk: tegra: Implement clocks for Tegra114
References: <1359713962-16822-1-git-send-email-pdeschrijver@nvidia.com> <1359713962-16822-10-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1359713962-16822-10-git-send-email-pdeschrijver@nvidia.com>
X-NVConfidentiality: public
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 01 February 2013 03:48 PM, Peter De Schrijver wrote:
> Implement most clocks for Tegra114. The super clocks for the CPU complex
> are still missing and will be implemented in a future version.
>
> Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
> ---
>   drivers/clk/tegra/Makefile       |    1 +
>   drivers/clk/tegra/clk-tegra114.c | 2002 ++++++++++++++++++++++++++++++++++++++
>   2 files changed, 2003 insertions(+), 0 deletions(-)
>   create mode 100644 drivers/clk/tegra/clk-tegra114.c
>
> diff --git a/drivers/clk/tegra/Makefile b/drivers/clk/tegra/Makefile
> index 2b41b0f..f49fac2 100644
> --- a/drivers/clk/tegra/Makefile
> +++ b/drivers/clk/tegra/Makefile
> @@ -9,3 +9,4 @@ obj-y                                   += clk-super.o
>
>   obj-$(CONFIG_ARCH_TEGRA_2x_SOC)         += clk-tegra20.o
>   obj-$(CONFIG_ARCH_TEGRA_3x_SOC)         += clk-tegra30.o
> +obj-$(CONFIG_ARCH_TEGRA_114_SOC)       += clk-tegra114.o
> diff --git a/drivers/clk/tegra/clk-tegra114.c b/drivers/clk/tegra/clk-tegra114.c
> new file mode 100644
> index 0000000..f8165d2
> --- /dev/null
> +++ b/drivers/clk/tegra/clk-tegra114.c
> @@ -0,0 +1,2002 @@
> +/*
> + * Copyright (c) 2012, 2013, NVIDIA CORPORATION.  All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms and conditions of the GNU General Public License,
> + * version 2, as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope it will be useful, but WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> + * more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program.  If not, see <http://www.gnu.org/licenses/>.
> + */
> +
> +#include <linux/io.h>
> +#include <linux/clk.h>
> +#include <linux/clk-provider.h>
> +#include <linux/clkdev.h>
> +#include <linux/of.h>
> +#include <linux/of_address.h>
> +#include <linux/delay.h>
> +#include <linux/clk/tegra.h>
> +
> +#include "clk.h"
> +
> +#define RST_DEVICES_L                  0x004
> +#define RST_DEVICES_H                  0x008
> +#define RST_DEVICES_U                  0x00C
> +#define RST_DEVICES_V                  0x358
> +#define RST_DEVICES_W                  0x35C
> +#define RST_DEVICES_X                  0x28C
> +#define RST_DEVICES_SET_L              0x300
> +#define RST_DEVICES_CLR_L              0x304
> +#define RST_DEVICES_SET_H              0x308
> +#define RST_DEVICES_CLR_H              0x30c
> +#define RST_DEVICES_SET_U              0x310
> +#define RST_DEVICES_CLR_U              0x314
> +#define RST_DEVICES_SET_V              0x430
> +#define RST_DEVICES_CLR_V              0x434
> +#define RST_DEVICES_SET_W              0x438
> +#define RST_DEVICES_CLR_W              0x43c
> +#define RST_DEVICES_NUM                        5

RST_DEVICES_SET/CLR_X?

> +
> +#define CLK_OUT_ENB_L                  0x010
> +#define CLK_OUT_ENB_H                  0x014
> +#define CLK_OUT_ENB_U                  0x018
> +#define CLK_OUT_ENB_V                  0x360
> +#define CLK_OUT_ENB_W                  0x364
> +#define CLK_OUT_ENB_X                  0x280
> +#define CLK_OUT_ENB_SET_L              0x320
> +#define CLK_OUT_ENB_CLR_L              0x324
> +#define CLK_OUT_ENB_SET_H              0x328
> +#define CLK_OUT_ENB_CLR_H              0x32c
> +#define CLK_OUT_ENB_SET_U              0x330
> +#define CLK_OUT_ENB_CLR_U              0x334
> +#define CLK_OUT_ENB_SET_V              0x440
> +#define CLK_OUT_ENB_CLR_V              0x444
> +#define CLK_OUT_ENB_SET_W              0x448
> +#define CLK_OUT_ENB_CLR_W              0x44c
> +#define CLK_OUT_ENB_SET_X              0x284
> +#define CLK_OUT_ENB_CLR_X              0x288
> +#define CLK_OUT_ENB_NUM                        6

<snip>

> +
> +       /* dsia */
> +       clk = clk_register_mux(NULL, "dsia_mux", mux_plld_out0_plld2_out0,
> +                              ARRAY_SIZE(mux_plld_out0_plld2_out0), 0,
> +                              clk_base + PLLD_BASE, 25, 1, 0, &pll_d_lock);
> +       clks[dsia_mux] = clk;
> +       clk = tegra_clk_register_periph_gate("dsia", "dsia_mux", 0, clk_base,
> +                                   0, 48, &periph_h_regs,
> +                                   periph_clk_enb_refcnt);
> +       clk_register_clkdev(clk, "dsia", "tegradc.0");
> +       clks[dsia] = clk;
> +
> +       /* dsib */
> +       clk = clk_register_mux(NULL, "dsib_mux", mux_plld_out0_plld2_out0,
> +                              ARRAY_SIZE(mux_plld_out0_plld2_out0), 0,
> +                              clk_base + PLLD2_BASE, 25, 1, 0, &pll_d2_lock);
> +       clks[dsib_mux] = clk;
> +       clk = tegra_clk_register_periph_gate("dsib", "dsib_mux", 0, clk_base,
> +                                   0, 82, &periph_u_regs,
> +                                   periph_clk_enb_refcnt);
> +       clk_register_clkdev(clk, "dsib", "tegradc.1");
> +       clks[dsib] = clk;
> +

Can we use periph no div clock here for dsia and dsib?

> +       /* xusb_hs_src */
> +       val = readl(clk_base + CLK_SOURCE_XUSB_SS_SRC);
> +       val |= BIT(25); /* always select PLLU_60M */
> +       writel(val, clk_base + CLK_SOURCE_XUSB_SS_SRC);
> +
> +       clk = clk_register_fixed_factor(NULL, "xusb_hs_src", "pll_u_60M", 0,
> +                                       1, 1);
> +       clks[xusb_hs_src] = clk;
> +

With device tree we can directly use pll_u_60M, no need to register 
clock with fixed factor 1.
Same comment for dis1-fixed, dsi2-fixed and mipi-cal-fast clocks.

> +       /* xusb_host */
> +       clk = tegra_clk_register_periph_gate("xusb_host", "xusb_host_src", 0,
> +                                   clk_base, 0, 89, &periph_u_regs,
> +                                   periph_clk_enb_refcnt);
> +       clk_register_clkdev(clk, "tegra_xhci", "host");
> +       clks[xusb_host] = clk;
> +
> +       /* xusb_ss */
> +       clk = tegra_clk_register_periph_gate("xusb_ss", "xusb_ss_src", 0,
> +                                   clk_base, 0, 156, &periph_w_regs,
> +                                   periph_clk_enb_refcnt);
> +       clk_register_clkdev(clk, "tegra_xhci", "ss");
> +       clks[xusb_host] = clk;
> +
> +       /* xusb_dev */
> +       clk = tegra_clk_register_periph_gate("xusb_dev", "xusb_dev_src", 0,
> +                                   clk_base, 0, 95, &periph_u_regs,
> +                                   periph_clk_enb_refcnt);
> +       clk_register_clkdev(clk, "tegra_xhci", "dev");

clks[xusb_dev] = clk;

> +
> +       for (i = 0; i < ARRAY_SIZE(tegra_periph_clk_list); i++) {
> +               data = &tegra_periph_clk_list[i];
> +               clk = tegra_clk_register_periph(data->name, data->parent_names,
> +                               data->num_parents, &data->periph,
> +                               clk_base, data->offset, data->flags);
> +               clk_register_clkdev(clk, data->con_id, data->dev_id);
> +               clks[data->clk_id] = clk;
> +       }
> +
> +       for (i = 0; i < ARRAY_SIZE(tegra_periph_nodiv_clk_list); i++) {
> +               data = &tegra_periph_nodiv_clk_list[i];
> +               clk = tegra_clk_register_periph_nodiv(data->name,
> +                               data->parent_names, data->num_parents,
> +                               &data->periph, clk_base, data->offset);
> +               clk_register_clkdev(clk, data->con_id, data->dev_id);
> +               clks[data->clk_id] = clk;
> +       }
> +}
> +
> +static struct tegra_cpu_car_ops tegra114_cpu_car_ops;
> +
> +static const struct of_device_id pmc_match[] __initconst = {
> +       { .compatible = "nvidia,tegra114-pmc" },
> +       {},
> +};
> +
> +static __initdata struct tegra_clk_init_table init_table[] = {
> +       {uartd, pll_p, 408000000, 1},
> +       {clk_max, clk_max, 0, 0}, /* This MUST be the last entry. */
> +};
> +
> +void __init tegra114_clock_init(struct device_node *np)
> +{
> +       struct device_node *node;
> +       int i;
> +
> +       clk_base = of_iomap(np, 0);
> +       if (!clk_base) {
> +               pr_err("ioremap tegra114 CAR failed\n");
> +               return;
> +       }
> +
> +       node = of_find_matching_node(NULL, pmc_match);
> +       if (!node) {
> +               pr_err("Failed to find pmc node\n");
> +               WARN_ON(1);
> +               return;
> +       }
> +
> +       pmc_base = of_iomap(node, 0);
> +       if (!pmc_base) {
> +               pr_err("Can't map pmc registers\n");
> +               WARN_ON(1);
> +               return;
> +       }
> +
> +       if (tegra114_osc_clk_init(clk_base) < 0)
> +               return;
> +
> +       tegra114_fixed_clk_init(clk_base);
> +       tegra114_pll_init(clk_base, pmc_base);
> +       tegra114_periph_clk_init(clk_base);
> +       tegra114_audio_clk_init(clk_base);
> +       tegra114_pmc_clk_init(pmc_base);
> +
> +       for (i = 0; i < ARRAY_SIZE(clks); i++) {
> +               if (IS_ERR(clks[i])) {
> +                       pr_err
> +                           ("Tegra114 clk %d: register failed with %ld\n",
> +                            i, PTR_ERR(clks[i]));
> +               }
> +               if (!clks[i])
> +                       clks[i] = ERR_PTR(-EINVAL);
> +       }
> +
> +       clk_data.clks = clks;
> +       clk_data.clk_num = ARRAY_SIZE(clks);
> +       of_clk_add_provider(np, of_clk_src_onecell_get, &clk_data);
> +
> +       tegra_init_from_table(init_table, clks, clk_max);
> +
> +       tegra_cpu_car_ops = &tegra114_cpu_car_ops;
> +}
>

