Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751362AbaANIQD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 03:16:03 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:41346 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750AbaANIP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 03:15:59 -0500
MIME-Version: 1.0
In-Reply-To: <1388986699-6470-1-git-send-email-21cnbao@gmail.com>
References: <1388986699-6470-1-git-send-email-21cnbao@gmail.com>
From: Barry Song <21cnbao@gmail.com>
Date: Tue, 14 Jan 2014 16:15:38 +0800
Message-ID: <CAGsJ_4wg1KNrwFG_4WEcVG3CNghOcb1RLs=aEaNoE9N3rHZ9Bw@mail.gmail.com>
Subject: Re: [PATCH v2] clk: sirf: re-arch to make the codes support both
 prima2 and atlas6
To: Mike Turquette <mturquette@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014/1/6 Barry Song <21cnbao@gmail.com>:
> From: Barry Song <Baohua.Song@csr.com>
>
> sirfprima2 and sirfatlas6 are two different SoCs in CSR SiRF series. for
> prima2 and atlas6, there are many shared clocks but there are still
> some different register layout and hardware clocks, then result in
> different clock table.
>
> here we re-arch the driver to
> 1. clk-common.c provides common clocks for prima2 and atlas6,
> 2. clk-prima2.h describles registers of prima2 and clk-prima2.c provides
> prima2 specific clocks and clock table.
> 3. clk-atlas6.h describles registers of atlas6 and clk-atlas6.c provides
> atlas6 specific clocks and clock table.
> 4. clk.h and clk.c expose external interfaces and provide uniform entry
> for both prima2 and atlas6.
>
> so both prima2 and atlas6 will get support by drivers/clk/sirf.
>
> Signed-off-by: Barry Song <Baohua.Song@csr.com>
> Signed-off-by: Rongjun Ying <Rongjun.Ying@csr.com>
> ---
>  -v2:
>  rebase to 3.13-rc;
>  use CLK_OF_DECLARE and make init function static
>
>  drivers/clk/Makefile                            |    2 +-
>  drivers/clk/sirf/atlas6.h                       |   31 +++
>  drivers/clk/sirf/clk-atlas6.c                   |  153 +++++++++++++
>  drivers/clk/{clk-prima2.c => sirf/clk-common.c} |  264 ++++++++---------------
>  drivers/clk/sirf/clk-prima2.c                   |  152 +++++++++++++
>  drivers/clk/sirf/prima2.h                       |   25 +++
>  6 files changed, 455 insertions(+), 172 deletions(-)
>  create mode 100644 drivers/clk/sirf/atlas6.h
>  create mode 100644 drivers/clk/sirf/clk-atlas6.c
>  rename drivers/clk/{clk-prima2.c => sirf/clk-common.c} (82%)
>  create mode 100644 drivers/clk/sirf/clk-prima2.c
>  create mode 100644 drivers/clk/sirf/prima2.h
>
> diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
> index 7a10bc9..aa2bd0f 100644
> --- a/drivers/clk/Makefile
> +++ b/drivers/clk/Makefile
> @@ -20,7 +20,6 @@ obj-$(CONFIG_ARCH_SOCFPGA)    += socfpga/
>  obj-$(CONFIG_PLAT_SPEAR)       += spear/
>  obj-$(CONFIG_ARCH_U300)                += clk-u300.o
>  obj-$(CONFIG_COMMON_CLK_VERSATILE) += versatile/
> -obj-$(CONFIG_ARCH_SIRF)                += clk-prima2.o
>  obj-$(CONFIG_PLAT_ORION)       += mvebu/
>  ifeq ($(CONFIG_COMMON_CLK), y)
>  obj-$(CONFIG_ARCH_MMP)         += mmp/
> @@ -30,6 +29,7 @@ obj-$(CONFIG_ARCH_ROCKCHIP)   += rockchip/
>  obj-$(CONFIG_ARCH_SUNXI)       += sunxi/
>  obj-$(CONFIG_ARCH_U8500)       += ux500/
>  obj-$(CONFIG_ARCH_VT8500)      += clk-vt8500.o
> +obj-$(CONFIG_ARCH_SIRF)                += sirf/
>  obj-$(CONFIG_ARCH_ZYNQ)                += zynq/
>  obj-$(CONFIG_ARCH_TEGRA)       += tegra/
>  obj-$(CONFIG_PLAT_SAMSUNG)     += samsung/
> diff --git a/drivers/clk/sirf/atlas6.h b/drivers/clk/sirf/atlas6.h
> new file mode 100644
> index 0000000..376217f
> --- /dev/null
> +++ b/drivers/clk/sirf/atlas6.h
> @@ -0,0 +1,31 @@
> +#define SIRFSOC_CLKC_CLK_EN0    0x0000
> +#define SIRFSOC_CLKC_CLK_EN1    0x0004
> +#define SIRFSOC_CLKC_REF_CFG    0x0020
> +#define SIRFSOC_CLKC_CPU_CFG    0x0024
> +#define SIRFSOC_CLKC_MEM_CFG    0x0028
> +#define SIRFSOC_CLKC_MEMDIV_CFG 0x002C
> +#define SIRFSOC_CLKC_SYS_CFG    0x0030
> +#define SIRFSOC_CLKC_IO_CFG     0x0034
> +#define SIRFSOC_CLKC_DSP_CFG    0x0038
> +#define SIRFSOC_CLKC_GFX_CFG    0x003c
> +#define SIRFSOC_CLKC_MM_CFG     0x0040
> +#define SIRFSOC_CLKC_GFX2D_CFG  0x0040
> +#define SIRFSOC_CLKC_LCD_CFG    0x0044
> +#define SIRFSOC_CLKC_MMC01_CFG  0x0048
> +#define SIRFSOC_CLKC_MMC23_CFG  0x004C
> +#define SIRFSOC_CLKC_MMC45_CFG  0x0050
> +#define SIRFSOC_CLKC_NAND_CFG  0x0054
> +#define SIRFSOC_CLKC_NANDDIV_CFG       0x0058
> +#define SIRFSOC_CLKC_PLL1_CFG0  0x0080
> +#define SIRFSOC_CLKC_PLL2_CFG0  0x0084
> +#define SIRFSOC_CLKC_PLL3_CFG0  0x0088
> +#define SIRFSOC_CLKC_PLL1_CFG1  0x008c
> +#define SIRFSOC_CLKC_PLL2_CFG1  0x0090
> +#define SIRFSOC_CLKC_PLL3_CFG1  0x0094
> +#define SIRFSOC_CLKC_PLL1_CFG2  0x0098
> +#define SIRFSOC_CLKC_PLL2_CFG2  0x009c
> +#define SIRFSOC_CLKC_PLL3_CFG2  0x00A0
> +#define SIRFSOC_USBPHY_PLL_CTRL 0x0008
> +#define SIRFSOC_USBPHY_PLL_POWERDOWN  BIT(1)
> +#define SIRFSOC_USBPHY_PLL_BYPASS     BIT(2)
> +#define SIRFSOC_USBPHY_PLL_LOCK       BIT(3)
> diff --git a/drivers/clk/sirf/clk-atlas6.c b/drivers/clk/sirf/clk-atlas6.c
> new file mode 100644
> index 0000000..21e776a
> --- /dev/null
> +++ b/drivers/clk/sirf/clk-atlas6.c
> @@ -0,0 +1,153 @@
> +/*
> + * Clock tree for CSR SiRFatlasVI
> + *
> + * Copyright (c) 2011 Cambridge Silicon Radio Limited, a CSR plc group company.
> + *
> + * Licensed under GPLv2 or later.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/bitops.h>
> +#include <linux/io.h>
> +#include <linux/clk.h>
> +#include <linux/clk-private.h>
> +#include <linux/clkdev.h>
> +#include <linux/clk-provider.h>
> +#include <linux/of_address.h>
> +#include <linux/syscore_ops.h>
> +
> +#include "atlas6.h"
> +#include "clk-common.c"
> +
> +static struct clk_dmn clk_mmc01 = {
> +       .regofs = SIRFSOC_CLKC_MMC01_CFG,
> +       .enable_bit = 59,
> +       .hw = {
> +               .init = &clk_mmc01_init,
> +       },
> +};
> +
> +static struct clk_dmn clk_mmc23 = {
> +       .regofs = SIRFSOC_CLKC_MMC23_CFG,
> +       .enable_bit = 60,
> +       .hw = {
> +               .init = &clk_mmc23_init,
> +       },
> +};
> +
> +static struct clk_dmn clk_mmc45 = {
> +       .regofs = SIRFSOC_CLKC_MMC45_CFG,
> +       .enable_bit = 61,
> +       .hw = {
> +               .init = &clk_mmc45_init,
> +       },
> +};
> +
> +static struct clk_init_data clk_nand_init = {
> +       .name = "nand",
> +       .ops = &dmn_ops,
> +       .parent_names = dmn_clk_parents,
> +       .num_parents = ARRAY_SIZE(dmn_clk_parents),
> +};
> +
> +static struct clk_dmn clk_nand = {
> +       .regofs = SIRFSOC_CLKC_NAND_CFG,
> +       .enable_bit = 34,
> +       .hw = {
> +               .init = &clk_nand_init,
> +       },
> +};
> +
> +enum atlas6_clk_index {
> +       /* 0    1     2      3      4      5      6       7         8      9 */
> +       rtc,    osc,   pll1,  pll2,  pll3,  mem,   sys,   security, dsp,   gps,
> +       mf,     io,    cpu,   uart0, uart1, uart2, tsc,   i2c0,     i2c1,  spi0,
> +       spi1,   pwmc,  efuse, pulse, dmac0, dmac1, nand,  audio,    usp0,  usp1,
> +       usp2,   vip,   gfx,   gfx2d,    lcd,   vpp,   mmc01, mmc23,    mmc45, usbpll,
> +       usb0,  usb1,   cphif, maxclk,
> +};
> +
> +static __initdata struct clk_hw *atlas6_clk_hw_array[maxclk] = {
> +       NULL, /* dummy */
> +       NULL,
> +       &clk_pll1.hw,
> +       &clk_pll2.hw,
> +       &clk_pll3.hw,
> +       &clk_mem.hw,
> +       &clk_sys.hw,
> +       &clk_security.hw,
> +       &clk_dsp.hw,
> +       &clk_gps.hw,
> +       &clk_mf.hw,
> +       &clk_io.hw,
> +       &clk_cpu.hw,
> +       &clk_uart0.hw,
> +       &clk_uart1.hw,
> +       &clk_uart2.hw,
> +       &clk_tsc.hw,
> +       &clk_i2c0.hw,
> +       &clk_i2c1.hw,
> +       &clk_spi0.hw,
> +       &clk_spi1.hw,
> +       &clk_pwmc.hw,
> +       &clk_efuse.hw,
> +       &clk_pulse.hw,
> +       &clk_dmac0.hw,
> +       &clk_dmac1.hw,
> +       &clk_nand.hw,
> +       &clk_audio.hw,
> +       &clk_usp0.hw,
> +       &clk_usp1.hw,
> +       &clk_usp2.hw,
> +       &clk_vip.hw,
> +       &clk_gfx.hw,
> +       &clk_gfx2d.hw,
> +       &clk_lcd.hw,
> +       &clk_vpp.hw,
> +       &clk_mmc01.hw,
> +       &clk_mmc23.hw,
> +       &clk_mmc45.hw,
> +       &usb_pll_clk_hw,
> +       &clk_usb0.hw,
> +       &clk_usb1.hw,
> +       &clk_cphif.hw,
> +};
> +
> +static struct clk *atlas6_clks[maxclk];
> +
> +static void __init atlas6_clk_init(struct device_node *np)
> +{
> +       struct device_node *rscnp;
> +       int i;
> +
> +       rscnp = of_find_compatible_node(NULL, NULL, "sirf,prima2-rsc");
> +       sirfsoc_rsc_vbase = of_iomap(rscnp, 0);
> +       if (!sirfsoc_rsc_vbase)
> +               panic("unable to map rsc registers\n");
> +       of_node_put(rscnp);
> +
> +       sirfsoc_clk_vbase = of_iomap(np, 0);
> +       if (!sirfsoc_clk_vbase)
> +               panic("unable to map clkc registers\n");
> +
> +       /* These are always available (RTC and 26MHz OSC)*/
> +       atlas6_clks[rtc] = clk_register_fixed_rate(NULL, "rtc", NULL,
> +               CLK_IS_ROOT, 32768);
> +       atlas6_clks[osc] = clk_register_fixed_rate(NULL, "osc", NULL,
> +               CLK_IS_ROOT, 26000000);
> +
> +       for (i = pll1; i < maxclk; i++) {
> +               atlas6_clks[i] = clk_register(NULL, atlas6_clk_hw_array[i]);
> +               BUG_ON(!atlas6_clks[i]);
> +       }
> +       clk_register_clkdev(atlas6_clks[cpu], NULL, "cpu");
> +       clk_register_clkdev(atlas6_clks[io],  NULL, "io");
> +       clk_register_clkdev(atlas6_clks[mem],  NULL, "mem");
> +       clk_register_clkdev(atlas6_clks[mem],  NULL, "osc");
> +
> +       clk_data.clks = atlas6_clks;
> +       clk_data.clk_num = maxclk;
> +
> +       of_clk_add_provider(np, of_clk_src_onecell_get, &clk_data);
> +}
> +CLK_OF_DECLARE(atlas6_clk, "sirf,atlas6-clkc", atlas6_clk_init);
> diff --git a/drivers/clk/clk-prima2.c b/drivers/clk/sirf/clk-common.c
> similarity index 82%
> rename from drivers/clk/clk-prima2.c
> rename to drivers/clk/sirf/clk-common.c
> index 6c15e33..88bc999 100644
> --- a/drivers/clk/clk-prima2.c
> +++ b/drivers/clk/sirf/clk-common.c
> @@ -1,51 +1,18 @@
>  /*
> - * Clock tree for CSR SiRFprimaII
> + * common clks module for all SiRF SoCs
>   *
>   * Copyright (c) 2011 Cambridge Silicon Radio Limited, a CSR plc group company.
>   *
>   * Licensed under GPLv2 or later.
>   */
>
> -#include <linux/module.h>
> -#include <linux/bitops.h>
> -#include <linux/io.h>
> -#include <linux/clk.h>
> -#include <linux/clkdev.h>
> -#include <linux/clk-provider.h>
> -#include <linux/of_address.h>
> -#include <linux/syscore_ops.h>
> -
> -#define SIRFSOC_CLKC_CLK_EN0    0x0000
> -#define SIRFSOC_CLKC_CLK_EN1    0x0004
> -#define SIRFSOC_CLKC_REF_CFG    0x0014
> -#define SIRFSOC_CLKC_CPU_CFG    0x0018
> -#define SIRFSOC_CLKC_MEM_CFG    0x001c
> -#define SIRFSOC_CLKC_SYS_CFG    0x0020
> -#define SIRFSOC_CLKC_IO_CFG     0x0024
> -#define SIRFSOC_CLKC_DSP_CFG    0x0028
> -#define SIRFSOC_CLKC_GFX_CFG    0x002c
> -#define SIRFSOC_CLKC_MM_CFG     0x0030
> -#define SIRFSOC_CLKC_LCD_CFG     0x0034
> -#define SIRFSOC_CLKC_MMC_CFG    0x0038
> -#define SIRFSOC_CLKC_PLL1_CFG0  0x0040
> -#define SIRFSOC_CLKC_PLL2_CFG0  0x0044
> -#define SIRFSOC_CLKC_PLL3_CFG0  0x0048
> -#define SIRFSOC_CLKC_PLL1_CFG1  0x004c
> -#define SIRFSOC_CLKC_PLL2_CFG1  0x0050
> -#define SIRFSOC_CLKC_PLL3_CFG1  0x0054
> -#define SIRFSOC_CLKC_PLL1_CFG2  0x0058
> -#define SIRFSOC_CLKC_PLL2_CFG2  0x005c
> -#define SIRFSOC_CLKC_PLL3_CFG2  0x0060
> -#define SIRFSOC_USBPHY_PLL_CTRL 0x0008
> -#define SIRFSOC_USBPHY_PLL_POWERDOWN  BIT(1)
> -#define SIRFSOC_USBPHY_PLL_BYPASS     BIT(2)
> -#define SIRFSOC_USBPHY_PLL_LOCK       BIT(3)
> -
> -static void *sirfsoc_clk_vbase, *sirfsoc_rsc_vbase;
> -
>  #define KHZ     1000
>  #define MHZ     (KHZ * KHZ)
>
> +static void *sirfsoc_clk_vbase;
> +static void *sirfsoc_rsc_vbase;
> +static struct clk_onecell_data clk_data;
> +
>  /*
>   * SiRFprimaII clock controller
>   * - 2 oscillators: osc-26MHz, rtc-32.768KHz
> @@ -127,6 +94,7 @@ static long pll_clk_round_rate(struct clk_hw *hw, unsigned long rate,
>         unsigned long *parent_rate)
>  {
>         unsigned long fin, nf, nr, od;
> +       u64 dividend;
>
>         /*
>          * fout = fin * nf / (nr * od);
> @@ -147,7 +115,10 @@ static long pll_clk_round_rate(struct clk_hw *hw, unsigned long rate,
>                 nr = BIT(6);
>         od = 1;
>
> -       return fin * nf / (nr * od);
> +       dividend = (u64)fin * nf;
> +       do_div(dividend, nr * od);
> +
> +       return (long)dividend;
>  }
>
>  static int pll_clk_set_rate(struct clk_hw *hw, unsigned long rate,
> @@ -186,6 +157,30 @@ static int pll_clk_set_rate(struct clk_hw *hw, unsigned long rate,
>         return 0;
>  }
>
> +static long cpu_clk_round_rate(struct clk_hw *hw, unsigned long rate,
> +       unsigned long *parent_rate)
> +{
> +       /*
> +        * SiRF SoC has not cpu clock control,
> +        * So bypass to it's parent pll.
> +        */
> +       struct clk *parent_clk = clk_get_parent(hw->clk);
> +       struct clk *pll_parent_clk = clk_get_parent(parent_clk);
> +       unsigned long pll_parent_rate = clk_get_rate(pll_parent_clk);
> +       return pll_clk_round_rate(parent_clk->hw, rate, &pll_parent_rate);
> +}
> +
> +static unsigned long cpu_clk_recalc_rate(struct clk_hw *hw,
> +       unsigned long parent_rate)
> +{
> +       /*
> +        * SiRF SoC has not cpu clock control,
> +        * So return the parent pll rate.
> +        */
> +       struct clk *parent_clk = clk_get_parent(hw->clk);
> +       return parent_clk->rate;
> +}
> +
>  static struct clk_ops std_pll_ops = {
>         .recalc_rate = pll_clk_recalc_rate,
>         .round_rate = pll_clk_round_rate,
> @@ -403,6 +398,42 @@ static int dmn_clk_set_rate(struct clk_hw *hw, unsigned long rate,
>         return 0;
>  }
>
> +static int cpu_clk_set_rate(struct clk_hw *hw, unsigned long rate,
> +               unsigned long parent_rate)
> +{
> +       int ret1, ret2;
> +       struct clk *cur_parent;
> +
> +       if (rate == clk_get_rate(clk_pll1.hw.clk)) {
> +               ret1 = clk_set_parent(hw->clk, clk_pll1.hw.clk);
> +               return ret1;
> +       }
> +
> +       if (rate == clk_get_rate(clk_pll2.hw.clk)) {
> +               ret1 = clk_set_parent(hw->clk, clk_pll2.hw.clk);
> +               return ret1;
> +       }
> +
> +       if (rate == clk_get_rate(clk_pll3.hw.clk)) {
> +               ret1 = clk_set_parent(hw->clk, clk_pll3.hw.clk);
> +               return ret1;
> +       }
> +
> +       cur_parent = clk_get_parent(hw->clk);
> +
> +       /* switch to tmp pll before setting parent clock's rate */
> +       if (cur_parent ==  clk_pll1.hw.clk) {
> +               ret1 = clk_set_parent(hw->clk, clk_pll2.hw.clk);
> +               BUG_ON(ret1);
> +       }
> +
> +       ret2 = clk_set_rate(clk_pll1.hw.clk, rate);
> +
> +       ret1 = clk_set_parent(hw->clk, clk_pll1.hw.clk);
> +
> +       return ret2 ? ret2 : ret1;
> +}
> +
>  static struct clk_ops msi_ops = {
>         .set_rate = dmn_clk_set_rate,
>         .round_rate = dmn_clk_round_rate,
> @@ -457,6 +488,9 @@ static struct clk_dmn clk_io = {
>  static struct clk_ops cpu_ops = {
>         .set_parent = dmn_clk_set_parent,
>         .get_parent = dmn_clk_get_parent,
> +       .set_rate = cpu_clk_set_rate,
> +       .round_rate = cpu_clk_round_rate,
> +       .recalc_rate = cpu_clk_recalc_rate,
>  };
>
>  static struct clk_init_data clk_cpu_init = {
> @@ -532,6 +566,11 @@ static struct clk_dmn clk_mm = {
>         },
>  };
>
> +/*
> + * for atlas6, gfx2d holds the bit of prima2's clk_mm
> + */
> +#define clk_gfx2d clk_mm
> +
>  static struct clk_init_data clk_lcd_init = {
>         .name = "lcd",
>         .ops = &dmn_ops,
> @@ -569,14 +608,6 @@ static struct clk_init_data clk_mmc01_init = {
>         .num_parents = ARRAY_SIZE(dmn_clk_parents),
>  };
>
> -static struct clk_dmn clk_mmc01 = {
> -       .regofs = SIRFSOC_CLKC_MMC_CFG,
> -       .enable_bit = 59,
> -       .hw = {
> -               .init = &clk_mmc01_init,
> -       },
> -};
> -
>  static struct clk_init_data clk_mmc23_init = {
>         .name = "mmc23",
>         .ops = &dmn_ops,
> @@ -584,14 +615,6 @@ static struct clk_init_data clk_mmc23_init = {
>         .num_parents = ARRAY_SIZE(dmn_clk_parents),
>  };
>
> -static struct clk_dmn clk_mmc23 = {
> -       .regofs = SIRFSOC_CLKC_MMC_CFG,
> -       .enable_bit = 60,
> -       .hw = {
> -               .init = &clk_mmc23_init,
> -       },
> -};
> -
>  static struct clk_init_data clk_mmc45_init = {
>         .name = "mmc45",
>         .ops = &dmn_ops,
> @@ -599,14 +622,6 @@ static struct clk_init_data clk_mmc45_init = {
>         .num_parents = ARRAY_SIZE(dmn_clk_parents),
>  };
>
> -static struct clk_dmn clk_mmc45 = {
> -       .regofs = SIRFSOC_CLKC_MMC_CFG,
> -       .enable_bit = 61,
> -       .hw = {
> -               .init = &clk_mmc45_init,
> -       },
> -};
> -
>  /*
>   * peripheral controllers in io domain
>   */
> @@ -667,6 +682,20 @@ static struct clk_ops ios_ops = {
>         .disable = std_clk_disable,
>  };
>
> +static struct clk_init_data clk_cphif_init = {
> +       .name = "cphif",
> +       .ops = &ios_ops,
> +       .parent_names = std_clk_io_parents,
> +       .num_parents = ARRAY_SIZE(std_clk_io_parents),
> +};
> +
> +static struct clk_std clk_cphif = {
> +       .enable_bit = 20,
> +       .hw = {
> +               .init = &clk_cphif_init,
> +       },
> +};
> +
>  static struct clk_init_data clk_dmac0_init = {
>         .name = "dmac0",
>         .ops = &ios_ops,
> @@ -695,20 +724,6 @@ static struct clk_std clk_dmac1 = {
>         },
>  };
>
> -static struct clk_init_data clk_nand_init = {
> -       .name = "nand",
> -       .ops = &ios_ops,
> -       .parent_names = std_clk_io_parents,
> -       .num_parents = ARRAY_SIZE(std_clk_io_parents),
> -};
> -
> -static struct clk_std clk_nand = {
> -       .enable_bit = 34,
> -       .hw = {
> -               .init = &clk_nand_init,
> -       },
> -};
> -
>  static struct clk_init_data clk_audio_init = {
>         .name = "audio",
>         .ops = &ios_ops,
> @@ -970,7 +985,7 @@ static const char *std_clk_sys_parents[] = {
>  };
>
>  static struct clk_init_data clk_security_init = {
> -       .name = "mf",
> +       .name = "security",
>         .ops = &ios_ops,
>         .parent_names = std_clk_sys_parents,
>         .num_parents = ARRAY_SIZE(std_clk_sys_parents),
> @@ -1014,96 +1029,3 @@ static struct clk_std clk_usb1 = {
>                 .init = &clk_usb1_init,
>         },
>  };
> -
> -enum prima2_clk_index {
> -       /* 0    1     2      3      4      5      6       7         8      9 */
> -       rtc,    osc,   pll1,  pll2,  pll3,  mem,   sys,   security, dsp,   gps,
> -       mf,     io,    cpu,   uart0, uart1, uart2, tsc,   i2c0,     i2c1,  spi0,
> -       spi1,   pwmc,  efuse, pulse, dmac0, dmac1, nand,  audio,    usp0,  usp1,
> -       usp2,   vip,   gfx,   mm,    lcd,   vpp,   mmc01, mmc23,    mmc45, usbpll,
> -       usb0,  usb1,  maxclk,
> -};
> -
> -static struct clk_hw *prima2_clk_hw_array[maxclk] __initdata = {
> -       NULL, /* dummy */
> -       NULL,
> -       &clk_pll1.hw,
> -       &clk_pll2.hw,
> -       &clk_pll3.hw,
> -       &clk_mem.hw,
> -       &clk_sys.hw,
> -       &clk_security.hw,
> -       &clk_dsp.hw,
> -       &clk_gps.hw,
> -       &clk_mf.hw,
> -       &clk_io.hw,
> -       &clk_cpu.hw,
> -       &clk_uart0.hw,
> -       &clk_uart1.hw,
> -       &clk_uart2.hw,
> -       &clk_tsc.hw,
> -       &clk_i2c0.hw,
> -       &clk_i2c1.hw,
> -       &clk_spi0.hw,
> -       &clk_spi1.hw,
> -       &clk_pwmc.hw,
> -       &clk_efuse.hw,
> -       &clk_pulse.hw,
> -       &clk_dmac0.hw,
> -       &clk_dmac1.hw,
> -       &clk_nand.hw,
> -       &clk_audio.hw,
> -       &clk_usp0.hw,
> -       &clk_usp1.hw,
> -       &clk_usp2.hw,
> -       &clk_vip.hw,
> -       &clk_gfx.hw,
> -       &clk_mm.hw,
> -       &clk_lcd.hw,
> -       &clk_vpp.hw,
> -       &clk_mmc01.hw,
> -       &clk_mmc23.hw,
> -       &clk_mmc45.hw,
> -       &usb_pll_clk_hw,
> -       &clk_usb0.hw,
> -       &clk_usb1.hw,
> -};
> -
> -static struct clk *prima2_clks[maxclk];
> -static struct clk_onecell_data clk_data;
> -
> -static void __init sirfsoc_clk_init(struct device_node *np)
> -{
> -       struct device_node *rscnp;
> -       int i;
> -
> -       rscnp = of_find_compatible_node(NULL, NULL, "sirf,prima2-rsc");
> -       sirfsoc_rsc_vbase = of_iomap(rscnp, 0);
> -       if (!sirfsoc_rsc_vbase)
> -               panic("unable to map rsc registers\n");
> -       of_node_put(rscnp);
> -
> -       sirfsoc_clk_vbase = of_iomap(np, 0);
> -       if (!sirfsoc_clk_vbase)
> -               panic("unable to map clkc registers\n");
> -
> -       /* These are always available (RTC and 26MHz OSC)*/
> -       prima2_clks[rtc] = clk_register_fixed_rate(NULL, "rtc", NULL,
> -               CLK_IS_ROOT, 32768);
> -       prima2_clks[osc]= clk_register_fixed_rate(NULL, "osc", NULL,
> -               CLK_IS_ROOT, 26000000);
> -
> -       for (i = pll1; i < maxclk; i++) {
> -               prima2_clks[i] = clk_register(NULL, prima2_clk_hw_array[i]);
> -               BUG_ON(IS_ERR(prima2_clks[i]));
> -       }
> -       clk_register_clkdev(prima2_clks[cpu], NULL, "cpu");
> -       clk_register_clkdev(prima2_clks[io],  NULL, "io");
> -       clk_register_clkdev(prima2_clks[mem],  NULL, "mem");
> -
> -       clk_data.clks = prima2_clks;
> -       clk_data.clk_num = maxclk;
> -
> -       of_clk_add_provider(np, of_clk_src_onecell_get, &clk_data);
> -}
> -CLK_OF_DECLARE(sirfsoc_clk, "sirf,prima2-clkc", sirfsoc_clk_init);
> diff --git a/drivers/clk/sirf/clk-prima2.c b/drivers/clk/sirf/clk-prima2.c
> new file mode 100644
> index 0000000..292c293
> --- /dev/null
> +++ b/drivers/clk/sirf/clk-prima2.c
> @@ -0,0 +1,152 @@
> +/*
> + * Clock tree for CSR SiRFprimaII
> + *
> + * Copyright (c) 2011 Cambridge Silicon Radio Limited, a CSR plc group company.
> + *
> + * Licensed under GPLv2 or later.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/bitops.h>
> +#include <linux/io.h>
> +#include <linux/clk.h>
> +#include <linux/clk-private.h>
> +#include <linux/clkdev.h>
> +#include <linux/clk-provider.h>
> +#include <linux/of_address.h>
> +#include <linux/syscore_ops.h>
> +
> +#include "prima2.h"
> +#include "clk-common.c"
> +
> +static struct clk_dmn clk_mmc01 = {
> +       .regofs = SIRFSOC_CLKC_MMC_CFG,
> +       .enable_bit = 59,
> +       .hw = {
> +               .init = &clk_mmc01_init,
> +       },
> +};
> +
> +static struct clk_dmn clk_mmc23 = {
> +       .regofs = SIRFSOC_CLKC_MMC_CFG,
> +       .enable_bit = 60,
> +       .hw = {
> +               .init = &clk_mmc23_init,
> +       },
> +};
> +
> +static struct clk_dmn clk_mmc45 = {
> +       .regofs = SIRFSOC_CLKC_MMC_CFG,
> +       .enable_bit = 61,
> +       .hw = {
> +               .init = &clk_mmc45_init,
> +       },
> +};
> +
> +static struct clk_init_data clk_nand_init = {
> +       .name = "nand",
> +       .ops = &ios_ops,
> +       .parent_names = std_clk_io_parents,
> +       .num_parents = ARRAY_SIZE(std_clk_io_parents),
> +};
> +
> +static struct clk_std clk_nand = {
> +       .enable_bit = 34,
> +       .hw = {
> +               .init = &clk_nand_init,
> +       },
> +};
> +
> +enum prima2_clk_index {
> +       /* 0    1     2      3      4      5      6       7         8      9 */
> +       rtc,    osc,   pll1,  pll2,  pll3,  mem,   sys,   security, dsp,   gps,
> +       mf,     io,    cpu,   uart0, uart1, uart2, tsc,   i2c0,     i2c1,  spi0,
> +       spi1,   pwmc,  efuse, pulse, dmac0, dmac1, nand,  audio,    usp0,  usp1,
> +       usp2,   vip,   gfx,   mm,    lcd,   vpp,   mmc01, mmc23,    mmc45, usbpll,
> +       usb0,  usb1,   cphif, maxclk,
> +};
> +
> +static __initdata struct clk_hw *prima2_clk_hw_array[maxclk] = {
> +       NULL, /* dummy */
> +       NULL,
> +       &clk_pll1.hw,
> +       &clk_pll2.hw,
> +       &clk_pll3.hw,
> +       &clk_mem.hw,
> +       &clk_sys.hw,
> +       &clk_security.hw,
> +       &clk_dsp.hw,
> +       &clk_gps.hw,
> +       &clk_mf.hw,
> +       &clk_io.hw,
> +       &clk_cpu.hw,
> +       &clk_uart0.hw,
> +       &clk_uart1.hw,
> +       &clk_uart2.hw,
> +       &clk_tsc.hw,
> +       &clk_i2c0.hw,
> +       &clk_i2c1.hw,
> +       &clk_spi0.hw,
> +       &clk_spi1.hw,
> +       &clk_pwmc.hw,
> +       &clk_efuse.hw,
> +       &clk_pulse.hw,
> +       &clk_dmac0.hw,
> +       &clk_dmac1.hw,
> +       &clk_nand.hw,
> +       &clk_audio.hw,
> +       &clk_usp0.hw,
> +       &clk_usp1.hw,
> +       &clk_usp2.hw,
> +       &clk_vip.hw,
> +       &clk_gfx.hw,
> +       &clk_mm.hw,
> +       &clk_lcd.hw,
> +       &clk_vpp.hw,
> +       &clk_mmc01.hw,
> +       &clk_mmc23.hw,
> +       &clk_mmc45.hw,
> +       &usb_pll_clk_hw,
> +       &clk_usb0.hw,
> +       &clk_usb1.hw,
> +       &clk_cphif.hw,
> +};
> +
> +static struct clk *prima2_clks[maxclk];
> +
> +static void __init prima2_clk_init(struct device_node *np)
> +{
> +       struct device_node *rscnp;
> +       int i;
> +
> +       rscnp = of_find_compatible_node(NULL, NULL, "sirf,prima2-rsc");
> +       sirfsoc_rsc_vbase = of_iomap(rscnp, 0);
> +       if (!sirfsoc_rsc_vbase)
> +               panic("unable to map rsc registers\n");
> +       of_node_put(rscnp);
> +
> +       sirfsoc_clk_vbase = of_iomap(np, 0);
> +       if (!sirfsoc_clk_vbase)
> +               panic("unable to map clkc registers\n");
> +
> +       /* These are always available (RTC and 26MHz OSC)*/
> +       prima2_clks[rtc] = clk_register_fixed_rate(NULL, "rtc", NULL,
> +               CLK_IS_ROOT, 32768);
> +       prima2_clks[osc] = clk_register_fixed_rate(NULL, "osc", NULL,
> +               CLK_IS_ROOT, 26000000);
> +
> +       for (i = pll1; i < maxclk; i++) {
> +               prima2_clks[i] = clk_register(NULL, prima2_clk_hw_array[i]);
> +               BUG_ON(!prima2_clks[i]);
> +       }
> +       clk_register_clkdev(prima2_clks[cpu], NULL, "cpu");
> +       clk_register_clkdev(prima2_clks[io],  NULL, "io");
> +       clk_register_clkdev(prima2_clks[mem],  NULL, "mem");
> +       clk_register_clkdev(prima2_clks[mem],  NULL, "osc");
> +
> +       clk_data.clks = prima2_clks;
> +       clk_data.clk_num = maxclk;
> +
> +       of_clk_add_provider(np, of_clk_src_onecell_get, &clk_data);
> +}
> +CLK_OF_DECLARE(prima2_clk, "sirf,prima2-clkc", prima2_clk_init);
> diff --git a/drivers/clk/sirf/prima2.h b/drivers/clk/sirf/prima2.h
> new file mode 100644
> index 0000000..01bc385
> --- /dev/null
> +++ b/drivers/clk/sirf/prima2.h
> @@ -0,0 +1,25 @@
> +#define SIRFSOC_CLKC_CLK_EN0    0x0000
> +#define SIRFSOC_CLKC_CLK_EN1    0x0004
> +#define SIRFSOC_CLKC_REF_CFG    0x0014
> +#define SIRFSOC_CLKC_CPU_CFG    0x0018
> +#define SIRFSOC_CLKC_MEM_CFG    0x001c
> +#define SIRFSOC_CLKC_SYS_CFG    0x0020
> +#define SIRFSOC_CLKC_IO_CFG     0x0024
> +#define SIRFSOC_CLKC_DSP_CFG    0x0028
> +#define SIRFSOC_CLKC_GFX_CFG    0x002c
> +#define SIRFSOC_CLKC_MM_CFG     0x0030
> +#define SIRFSOC_CLKC_LCD_CFG     0x0034
> +#define SIRFSOC_CLKC_MMC_CFG    0x0038
> +#define SIRFSOC_CLKC_PLL1_CFG0  0x0040
> +#define SIRFSOC_CLKC_PLL2_CFG0  0x0044
> +#define SIRFSOC_CLKC_PLL3_CFG0  0x0048
> +#define SIRFSOC_CLKC_PLL1_CFG1  0x004c
> +#define SIRFSOC_CLKC_PLL2_CFG1  0x0050
> +#define SIRFSOC_CLKC_PLL3_CFG1  0x0054
> +#define SIRFSOC_CLKC_PLL1_CFG2  0x0058
> +#define SIRFSOC_CLKC_PLL2_CFG2  0x005c
> +#define SIRFSOC_CLKC_PLL3_CFG2  0x0060
> +#define SIRFSOC_USBPHY_PLL_CTRL 0x0008
> +#define SIRFSOC_USBPHY_PLL_POWERDOWN  BIT(1)
> +#define SIRFSOC_USBPHY_PLL_BYPASS     BIT(2)
> +#define SIRFSOC_USBPHY_PLL_LOCK       BIT(3)
> --
> 1.7.5.4
>
