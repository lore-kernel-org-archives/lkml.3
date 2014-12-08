Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753587AbaLHBiS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 20:38:18 -0500
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:63336 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039AbaLHBiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 20:38:16 -0500
X-IronPort-AV: E=Sophos;i="5.07,535,1413270000"; 
   d="scan'208";a="52652183"
Message-ID: <54850106.8060903@broadcom.com>
Date: Sun, 7 Dec 2014 17:38:14 -0800
From: Ray Jui <rjui@broadcom.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Tim Kryger <tim.kryger@gmail.com>
CC: Mike Turquette <mturquette@linaro.org>, Matt Porter <mporter@linaro.org>,
        Alex Elder <elder@linaro.org>, Tim Kryger <tim.kryger@linaro.org>,
        "Rob Herring" <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>, <devicetree@vger.kernel.org>,
        "Scott Branden" <sbranden@broadcom.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        <bcm-kernel-feedback-list@broadcom.com>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 2/4] clk: iproc: add initial common clock support
References: <rjui@broadcom.com>	<1417729408-30357-1-git-send-email-rjui@broadcom.com>	<1417729408-30357-3-git-send-email-rjui@broadcom.com> <CAD7vxxJmsUNcusvct_eLkjdApP0DuTXzxisO1k_ixhHt4d_pMA@mail.gmail.com>
In-Reply-To: <CAD7vxxJmsUNcusvct_eLkjdApP0DuTXzxisO1k_ixhHt4d_pMA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 12/6/2014 2:20 PM, Tim Kryger wrote:
> On Thu, Dec 4, 2014 at 1:43 PM, Ray Jui <rjui@broadcom.com> wrote:
>> This adds basic and generic support for various iProc PLLs and clocks
>> including the ARMPLL, GENPLL, LCPLL, MIPIPLL, and ASIU clocks.
>>
>> SoCs under the iProc architecture can define their specific register
>> offsets and clock parameters for their PLL and clock controllers. These
>> parameters can be passed as arugments into the generic iProc PLL and
>> clock setup functions
>>
>> Derived from code originally provided by Jonathan Richardson
>> <jonathar@broadcom.com>
>>
>> Signed-off-by: Ray Jui <rjui@broadcom.com>
>> Reviewed-by: Scott Branden <sbranden@broadcom.com>
>> ---
>>   drivers/clk/Makefile               |    2 +-
>>   drivers/clk/bcm/Kconfig            |    9 +
>>   drivers/clk/bcm/Makefile           |    1 +
>>   drivers/clk/bcm/clk-iproc-armpll.c |  286 +++++++++++++++++++++
>>   drivers/clk/bcm/clk-iproc-asiu.c   |  275 ++++++++++++++++++++
>>   drivers/clk/bcm/clk-iproc-clk.c    |  238 ++++++++++++++++++
>>   drivers/clk/bcm/clk-iproc-pll.c    |  483 ++++++++++++++++++++++++++++++++++++
>>   drivers/clk/bcm/clk-iproc.h        |  155 ++++++++++++
>>   8 files changed, 1448 insertions(+), 1 deletion(-)
>>   create mode 100644 drivers/clk/bcm/clk-iproc-armpll.c
>>   create mode 100644 drivers/clk/bcm/clk-iproc-asiu.c
>>   create mode 100644 drivers/clk/bcm/clk-iproc-clk.c
>>   create mode 100644 drivers/clk/bcm/clk-iproc-pll.c
>>   create mode 100644 drivers/clk/bcm/clk-iproc.h
>>
>> diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
>> index d5fba5b..eff0213 100644
>> --- a/drivers/clk/Makefile
>> +++ b/drivers/clk/Makefile
>> @@ -41,7 +41,7 @@ obj-$(CONFIG_ARCH_VT8500)             += clk-vt8500.o
>>   obj-$(CONFIG_COMMON_CLK_WM831X)                += clk-wm831x.o
>>   obj-$(CONFIG_COMMON_CLK_XGENE)         += clk-xgene.o
>>   obj-$(CONFIG_COMMON_CLK_AT91)          += at91/
>> -obj-$(CONFIG_ARCH_BCM_MOBILE)          += bcm/
>> +obj-$(CONFIG_ARCH_BCM)                 += bcm/
>>   obj-$(CONFIG_ARCH_BERLIN)              += berlin/
>>   obj-$(CONFIG_ARCH_HI3xxx)              += hisilicon/
>>   obj-$(CONFIG_ARCH_HIP04)               += hisilicon/
>
> It may be best to move the above change into its own commit.
>
Okay. Will make this change along with other changes if required. Still 
waiting for more code review comments at this point.

>> diff --git a/drivers/clk/bcm/Kconfig b/drivers/clk/bcm/Kconfig
>> index 75506e5..66b5b7f 100644
>> --- a/drivers/clk/bcm/Kconfig
>> +++ b/drivers/clk/bcm/Kconfig
>> @@ -7,3 +7,12 @@ config CLK_BCM_KONA
>>            Enable common clock framework support for Broadcom SoCs
>>            using "Kona" style clock control units, including those
>>            in the BCM281xx and BCM21664 families.
>> +
>> +config COMMON_CLK_IPROC
>> +       bool "Broadcom iProc clock support"
>> +       depends on ARCH_BCM_IPROC
>> +       depends on COMMON_CLK
>> +       default y
>> +       help
>> +         Enable common clock framework support for Broadcom SoCs
>> +         based on the "iProc" architecture
>> diff --git a/drivers/clk/bcm/Makefile b/drivers/clk/bcm/Makefile
>> index 6297d05..6926636 100644
>> --- a/drivers/clk/bcm/Makefile
>> +++ b/drivers/clk/bcm/Makefile
>> @@ -2,3 +2,4 @@ obj-$(CONFIG_CLK_BCM_KONA)      += clk-kona.o
>>   obj-$(CONFIG_CLK_BCM_KONA)     += clk-kona-setup.o
>>   obj-$(CONFIG_CLK_BCM_KONA)     += clk-bcm281xx.o
>>   obj-$(CONFIG_CLK_BCM_KONA)     += clk-bcm21664.o
>> +obj-$(CONFIG_COMMON_CLK_IPROC) += clk-iproc-armpll.o clk-iproc-pll.o clk-iproc-clk.o clk-iproc-asiu.o
>> diff --git a/drivers/clk/bcm/clk-iproc-armpll.c b/drivers/clk/bcm/clk-iproc-armpll.c
>> new file mode 100644
>> index 0000000..ec9b130
>> --- /dev/null
>> +++ b/drivers/clk/bcm/clk-iproc-armpll.c
>> @@ -0,0 +1,286 @@
>> +/*
>> + * Copyright (C) 2014 Broadcom Corporation
>> + *
>> + * This program is free software; you can redistribute it and/or
>> + * modify it under the terms of the GNU General Public License as
>> + * published by the Free Software Foundation version 2.
>> + *
>> + * This program is distributed "as is" WITHOUT ANY WARRANTY of any
>> + * kind, whether express or implied; without even the implied warranty
>> + * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + */
>> +
>> +#include <linux/kernel.h>
>> +#include <linux/slab.h>
>> +#include <linux/err.h>
>> +#include <linux/clk-provider.h>
>> +#include <linux/io.h>
>> +#include <linux/of.h>
>> +#include <linux/clkdev.h>
>> +#include <linux/of_address.h>
>> +
>> +#define IPROC_CLK_MAX_FREQ_POLICY                    0x3
>> +#define IPROC_CLK_POLICY_FREQ_OFFSET                 0x008
>> +#define IPROC_CLK_POLICY_FREQ_POLICY_FREQ_SHIFT      8
>> +#define IPROC_CLK_POLICY_FREQ_POLICY_FREQ_MASK       0x7
>> +
>> +#define IPROC_CLK_PLLARMA_OFFSET                     0xc00
>> +#define IPROC_CLK_PLLARMA_LOCK_SHIFT                 28
>> +#define IPROC_CLK_PLLARMA_PDIV_SHIFT                 24
>> +#define IPROC_CLK_PLLARMA_PDIV_MASK                  0xf
>> +#define IPROC_CLK_PLLARMA_NDIV_INT_SHIFT             8
>> +#define IPROC_CLK_PLLARMA_NDIV_INT_MASK              0x3ff
>> +
>> +#define IPROC_CLK_PLLARMB_OFFSET                     0xc04
>> +#define IPROC_CLK_PLLARMB_NDIV_FRAC_MASK             0xfffff
>> +
>> +#define IPROC_CLK_PLLARMC_OFFSET                     0xc08
>> +#define IPROC_CLK_PLLARMC_BYPCLK_EN_SHIFT            8
>> +#define IPROC_CLK_PLLARMC_MDIV_MASK                  0xff
>> +
>> +#define IPROC_CLK_PLLARMCTL5_OFFSET                  0xc20
>> +#define IPROC_CLK_PLLARMCTL5_H_MDIV_MASK             0xff
>> +
>> +#define IPROC_CLK_PLLARM_OFFSET_OFFSET               0xc24
>> +#define IPROC_CLK_PLLARM_SW_CTL_SHIFT                29
>> +#define IPROC_CLK_PLLARM_NDIV_INT_OFFSET_SHIFT       20
>> +#define IPROC_CLK_PLLARM_NDIV_INT_OFFSET_MASK        0xff
>> +#define IPROC_CLK_PLLARM_NDIV_FRAC_OFFSET_MASK       0xfffff
>> +
>> +#define IPROC_CLK_ARM_DIV_OFFSET                     0xe00
>> +#define IPROC_CLK_ARM_DIV_PLL_SELECT_OVERRIDE_SHIFT  4
>> +#define IPROC_CLK_ARM_DIV_ARM_PLL_SELECT_MASK        0xf
>> +
>> +#define IPROC_CLK_POLICY_DBG_OFFSET                  0xec0
>> +#define IPROC_CLK_POLICY_DBG_ACT_FREQ_SHIFT          12
>> +#define IPROC_CLK_POLICY_DBG_ACT_FREQ_MASK           0x7
>> +
>> +enum iproc_arm_pll_fid {
>> +       ARM_PLL_FID_CRYSTAL_CLK   = 0,
>> +       ARM_PLL_FID_SYS_CLK       = 2,
>> +       ARM_PLL_FID_CH0_SLOW_CLK  = 6,
>> +       ARM_PLL_FID_CH1_FAST_CLK  = 7
>> +};
>> +
>> +struct iproc_arm_pll {
>> +       struct clk_hw hw;
>> +       void __iomem *base;
>> +       struct clk_onecell_data clk_data;
>> +       unsigned long rate;
>> +};
>> +
>> +#define to_iproc_arm_pll(hw) container_of(hw, struct iproc_arm_pll, hw)
>> +
>> +static unsigned int __get_fid(struct iproc_arm_pll *pll)
>> +{
>> +       u32 val;
>> +       unsigned int policy, fid, active_fid;
>> +
>> +       val = readl(pll->base + IPROC_CLK_ARM_DIV_OFFSET);
>> +       if (val & (1 << IPROC_CLK_ARM_DIV_PLL_SELECT_OVERRIDE_SHIFT))
>> +               policy = val & IPROC_CLK_ARM_DIV_ARM_PLL_SELECT_MASK;
>> +       else
>> +               policy = 0;
>> +
>> +       /* something is seriously wrong */
>> +       BUG_ON(policy > IPROC_CLK_MAX_FREQ_POLICY);
>> +
>> +       val = readl(pll->base + IPROC_CLK_POLICY_FREQ_OFFSET);
>> +       fid = (val >> (IPROC_CLK_POLICY_FREQ_POLICY_FREQ_SHIFT * policy)) &
>> +               IPROC_CLK_POLICY_FREQ_POLICY_FREQ_MASK;
>> +
>> +       val = readl(pll->base + IPROC_CLK_POLICY_DBG_OFFSET);
>> +       active_fid = IPROC_CLK_POLICY_DBG_ACT_FREQ_MASK &
>> +               (val >> IPROC_CLK_POLICY_DBG_ACT_FREQ_SHIFT);
>> +       if (fid != active_fid) {
>> +               pr_debug("%s: fid override %u->%u\n", __func__, fid,
>> +                               active_fid);
>> +               fid = active_fid;
>> +       }
>> +
>> +       pr_debug("%s: active fid: %u\n", __func__, fid);
>> +
>> +       return fid;
>> +}
>> +
>> +/*
>> + * Determine the mdiv (post divider) based on the frequency ID being used.
>> + * There are 4 sources that can be used to derive the output clock rate:
>> + *    - 25 MHz Crystal
>> + *    - System clock
>> + *    - PLL channel 0 (slow clock)
>> + *    - PLL channel 1 (fast clock)
>> + */
>> +static int __get_mdiv(struct iproc_arm_pll *pll)
>> +{
>> +       unsigned int fid;
>> +       int mdiv;
>> +       u32 val;
>> +
>> +       fid = __get_fid(pll);
>> +
>> +       switch (fid) {
>> +       case ARM_PLL_FID_CRYSTAL_CLK:
>> +       case ARM_PLL_FID_SYS_CLK:
>> +               mdiv = 1;
>> +               break;
>> +
>> +       case ARM_PLL_FID_CH0_SLOW_CLK:
>> +               val = readl(pll->base + IPROC_CLK_PLLARMC_OFFSET);
>> +               mdiv = val & IPROC_CLK_PLLARMC_MDIV_MASK;
>> +               if (mdiv == 0)
>> +                       mdiv = 256;
>> +               break;
>> +
>> +       case ARM_PLL_FID_CH1_FAST_CLK:
>> +               val = readl(pll->base + IPROC_CLK_PLLARMCTL5_OFFSET);
>> +               mdiv = val & IPROC_CLK_PLLARMCTL5_H_MDIV_MASK;
>> +               if (mdiv == 0)
>> +                       mdiv = 256;
>> +               break;
>> +
>> +       default:
>> +               mdiv = -EFAULT;
>> +       }
>> +
>> +       return mdiv;
>> +}
>> +
>> +static unsigned int __get_ndiv(struct iproc_arm_pll *pll)
>> +{
>> +       u32 val;
>> +       unsigned int ndiv_int, ndiv_frac, ndiv;
>> +
>> +       val = readl(pll->base + IPROC_CLK_PLLARM_OFFSET_OFFSET);
>> +       if (val & (1 << IPROC_CLK_PLLARM_SW_CTL_SHIFT)) {
>> +               /*
>> +                * offset mode is active. Read the ndiv from the PLLARM OFFSET
>> +                * register
>> +                */
>> +               ndiv_int = (val >> IPROC_CLK_PLLARM_NDIV_INT_OFFSET_SHIFT) &
>> +                       IPROC_CLK_PLLARM_NDIV_INT_OFFSET_MASK;
>> +               if (ndiv_int == 0)
>> +                       ndiv_int = 256;
>> +
>> +               ndiv_frac = val & IPROC_CLK_PLLARM_NDIV_FRAC_OFFSET_MASK;
>> +       } else {
>> +               /* offset mode not active */
>> +               val = readl(pll->base + IPROC_CLK_PLLARMA_OFFSET);
>> +               ndiv_int = (val >> IPROC_CLK_PLLARMA_NDIV_INT_SHIFT) &
>> +                       IPROC_CLK_PLLARMA_NDIV_INT_MASK;
>> +               if (ndiv_int == 0)
>> +                       ndiv_int = 1024;
>> +
>> +               val = readl(pll->base + IPROC_CLK_PLLARMB_OFFSET);
>> +               ndiv_frac = val & IPROC_CLK_PLLARMB_NDIV_FRAC_MASK;
>> +       }
>> +
>> +       ndiv = (ndiv_int << 20) | ndiv_frac;
>> +
>> +       return ndiv;
>> +}
>> +
>> +/*
>> + * The output frequency of the ARM PLL is calculated based on the ARM PLL
>> + * divider values:
>> + *   pdiv = ARM PLL pre-divider
>> + *   ndiv = ARM PLL multiplier
>> + *   mdiv = ARM PLL post divider
>> + *
>> + * The frequency is calculated by:
>> + *   ((ndiv * parent clock rate) / pdiv) / mdiv
>> + */
>> +static unsigned long iproc_arm_pll_recalc_rate(struct clk_hw *hw,
>> +               unsigned long parent_rate)
>> +{
>> +       struct iproc_arm_pll *pll = to_iproc_arm_pll(hw);
>> +       u32 val;
>> +       int mdiv;
>> +       u64 ndiv;
>> +       unsigned int pdiv;
>> +
>> +       /* in bypass mode, use parent rate */
>> +       val = readl(pll->base + IPROC_CLK_PLLARMC_OFFSET);
>> +       if (val & (1 << IPROC_CLK_PLLARMC_BYPCLK_EN_SHIFT)) {
>> +               pll->rate = parent_rate;
>> +               return pll->rate;
>> +       }
>> +
>> +       /* PLL needs to be locked */
>> +       val = readl(pll->base + IPROC_CLK_PLLARMA_OFFSET);
>> +       if (!(val & (1 << IPROC_CLK_PLLARMA_LOCK_SHIFT))) {
>> +               pll->rate = 0;
>> +               return 0;
>> +       }
>> +
>> +       pdiv = (val >> IPROC_CLK_PLLARMA_PDIV_SHIFT) &
>> +               IPROC_CLK_PLLARMA_PDIV_MASK;
>> +       if (pdiv == 0)
>> +               pdiv = 16;
>> +
>> +       ndiv = __get_ndiv(pll);
>> +       mdiv = __get_mdiv(pll);
>> +       if (mdiv <= 0) {
>> +               pll->rate = 0;
>> +               return 0;
>> +       }
>> +       pll->rate = (ndiv * parent_rate) >> 20;
>> +       pll->rate = (pll->rate / pdiv) / mdiv;
>> +
>> +       pr_debug("%s: ARM PLL rate: %lu. parent rate: %lu\n", __func__,
>> +                       pll->rate, parent_rate);
>> +       pr_debug("%s: ndiv_int: %u, pdiv: %u, mdiv: %d\n", __func__,
>> +                       (unsigned int)(ndiv >> 20), pdiv, mdiv);
>> +
>> +       return pll->rate;
>> +}
>> +
>> +static const struct clk_ops iproc_arm_pll_ops = {
>> +       .recalc_rate = iproc_arm_pll_recalc_rate,
>> +};
>> +
>> +void __init iproc_armpll_setup(struct device_node *node)
>> +{
>> +       int ret;
>> +       struct clk *clk;
>> +       struct iproc_arm_pll *pll;
>> +       struct clk_init_data init;
>> +       const char *parent_name;
>> +
>> +       pll = kzalloc(sizeof(*pll), GFP_KERNEL);
>> +       if (WARN_ON(!pll))
>> +               return;
>> +
>> +       pll->base = of_iomap(node, 0);
>> +       if (WARN_ON(!pll->base))
>> +               goto err_free_pll;
>> +
>> +       init.name = node->name;
>> +       init.ops = &iproc_arm_pll_ops;
>> +       init.flags = 0;
>> +       parent_name = of_clk_get_parent_name(node, 0);
>> +       init.parent_names = (parent_name ? &parent_name : NULL);
>> +       init.num_parents = (parent_name ? 1 : 0);
>> +       pll->hw.init = &init;
>> +
>> +       clk = clk_register(NULL, &pll->hw);
>> +       if (WARN_ON(IS_ERR(clk)))
>> +               goto err_iounmap;
>> +
>> +       pll->clk_data.clk_num = 1;
>> +       pll->clk_data.clks = &clk;
>> +
>> +       ret = of_clk_add_provider(node, of_clk_src_onecell_get, &pll->clk_data);
>> +       if (WARN_ON(ret))
>> +               goto err_clk_unregister;
>> +
>> +       return;
>> +
>> +err_clk_unregister:
>> +       clk_unregister(clk);
>> +err_iounmap:
>> +       iounmap(pll->base);
>> +err_free_pll:
>> +       kfree(pll);
>> +}
>> diff --git a/drivers/clk/bcm/clk-iproc-asiu.c b/drivers/clk/bcm/clk-iproc-asiu.c
>> new file mode 100644
>> index 0000000..ab86b8c
>> --- /dev/null
>> +++ b/drivers/clk/bcm/clk-iproc-asiu.c
>> @@ -0,0 +1,275 @@
>> +/*
>> + * Copyright (C) 2014 Broadcom Corporation
>> + *
>> + * This program is free software; you can redistribute it and/or
>> + * modify it under the terms of the GNU General Public License as
>> + * published by the Free Software Foundation version 2.
>> + *
>> + * This program is distributed "as is" WITHOUT ANY WARRANTY of any
>> + * kind, whether express or implied; without even the implied warranty
>> + * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + */
>> +
>> +#include <linux/kernel.h>
>> +#include <linux/err.h>
>> +#include <linux/clk-provider.h>
>> +#include <linux/io.h>
>> +#include <linux/of.h>
>> +#include <linux/clkdev.h>
>> +#include <linux/of_address.h>
>> +#include <linux/delay.h>
>> +
>> +#include "clk-iproc.h"
>> +
>> +struct iproc_asiu;
>> +
>> +struct iproc_asiu_clk {
>> +       struct clk_hw hw;
>> +       const char *name;
>> +       struct iproc_asiu *asiu;
>> +       unsigned long rate;
>> +       struct iproc_asiu_div div;
>> +       struct iproc_asiu_gate gate;
>> +};
>> +
>> +struct iproc_asiu {
>> +       void __iomem *div_base;
>> +       void __iomem *gate_base;
>> +
>> +       struct clk_onecell_data clk_data;
>> +       struct iproc_asiu_clk *clks;
>> +};
>> +
>> +#define to_asiu_clk(hw) container_of(hw, struct iproc_asiu_clk, hw)
>> +
>> +static int iproc_asiu_clk_enable(struct clk_hw *hw)
>> +{
>> +       struct iproc_asiu_clk *clk = to_asiu_clk(hw);
>> +       struct iproc_asiu *asiu = clk->asiu;
>> +       u32 val;
>> +
>> +       /* some clocks at the ASIU level are always enabled */
>> +       if (clk->gate.offset == IPROC_CLK_INVALID_OFFSET)
>> +               return 0;
>> +
>> +       val = readl(asiu->gate_base + clk->gate.offset);
>> +       val |= (1 << clk->gate.en_shift);
>> +       writel(val, asiu->gate_base + clk->gate.offset);
>> +
>> +       return 0;
>> +}
>> +
>> +static void iproc_asiu_clk_disable(struct clk_hw *hw)
>> +{
>> +       struct iproc_asiu_clk *clk = to_asiu_clk(hw);
>> +       struct iproc_asiu *asiu = clk->asiu;
>> +       u32 val;
>> +
>> +       /* some clocks at the ASIU level are always enabled */
>> +       if (clk->gate.offset == IPROC_CLK_INVALID_OFFSET)
>> +               return;
>> +
>> +       val = readl(asiu->gate_base + clk->gate.offset);
>> +       val &= ~(1 << clk->gate.en_shift);
>> +       writel(val, asiu->gate_base + clk->gate.offset);
>> +}
>> +
>> +static unsigned long iproc_asiu_clk_recalc_rate(struct clk_hw *hw,
>> +               unsigned long parent_rate)
>> +{
>> +       struct iproc_asiu_clk *clk = to_asiu_clk(hw);
>> +       struct iproc_asiu *asiu = clk->asiu;
>> +       u32 val;
>> +       unsigned int div_h, div_l;
>> +
>> +       if (parent_rate == 0) {
>> +               clk->rate = 0;
>> +               return 0;
>> +       }
>> +
>> +       /* if clock divisor is not enabled, simply return parent rate */
>> +       val = readl(asiu->div_base + clk->div.offset);
>> +       if ((val & (1 << clk->div.en_shift)) == 0) {
>> +               clk->rate = parent_rate;
>> +               return parent_rate;
>> +       }
>> +
>> +       /* clock rate = parent rate / (high_div + 1) + (low_div + 1) */
>> +       div_h = (val >> clk->div.high_shift) & bit_mask(clk->div.high_width);
>> +       div_h++;
>> +       div_l = (val >> clk->div.low_shift) & bit_mask(clk->div.low_width);
>> +       div_l++;
>> +
>> +       clk->rate = parent_rate / (div_h + div_l);
>> +       pr_debug("%s: rate: %lu. parent rate: %lu div_h: %u div_l: %u\n",
>> +               __func__, clk->rate, parent_rate, div_h, div_l);
>> +
>> +       return clk->rate;
>> +}
>> +
>> +static long iproc_asiu_clk_round_rate(struct clk_hw *hw, unsigned long rate,
>> +               unsigned long *parent_rate)
>> +{
>> +       unsigned int div;
>> +
>> +       if (rate == 0 || *parent_rate == 0)
>> +               return -EINVAL;
>> +
>> +       if (rate == *parent_rate)
>> +               return *parent_rate;
>> +
>> +       div = DIV_ROUND_UP(*parent_rate, rate);
>> +       if (div < 2)
>> +               return *parent_rate;
>> +
>> +       return *parent_rate / div;
>> +}
>> +
>> +static int iproc_asiu_clk_set_rate(struct clk_hw *hw, unsigned long rate,
>> +               unsigned long parent_rate)
>> +{
>> +       struct iproc_asiu_clk *clk = to_asiu_clk(hw);
>> +       struct iproc_asiu *asiu = clk->asiu;
>> +       unsigned int div, div_h, div_l;
>> +       u32 val;
>> +
>> +       if (rate == 0 || parent_rate == 0)
>> +               return -EINVAL;
>> +
>> +       /* simply disable the divisor if one wants the same rate as parent */
>> +       if (rate == parent_rate) {
>> +               val = readl(asiu->div_base + clk->div.offset);
>> +               val &= ~(1 << clk->div.en_shift);
>> +               writel(val, asiu->div_base + clk->div.offset);
>> +               return 0;
>> +       }
>> +
>> +       div = DIV_ROUND_UP(parent_rate, rate);
>> +       if (div < 2)
>> +               return -EINVAL;
>> +
>> +       div_h = div_l = div >> 1;
>> +       div_h--;
>> +       div_l--;
>> +
>> +       val = readl(asiu->div_base + clk->div.offset);
>> +       val |= 1 << clk->div.en_shift;
>> +       if (div_h) {
>> +               val &= ~(bit_mask(clk->div.high_width)
>> +                               << clk->div.high_shift);
>> +               val |= div_h << clk->div.high_shift;
>> +       } else {
>> +               val &= ~(bit_mask(clk->div.high_width)
>> +                               << clk->div.high_shift);
>> +       }
>> +       if (div_l) {
>> +               val &= ~(bit_mask(clk->div.low_width) << clk->div.low_shift);
>> +               val |= div_l << clk->div.low_shift;
>> +       } else {
>> +               val &= ~(bit_mask(clk->div.low_width) << clk->div.low_shift);
>> +       }
>> +       writel(val, asiu->div_base + clk->div.offset);
>> +
>> +       return 0;
>> +}
>> +
>> +static const struct clk_ops iproc_asiu_ops = {
>> +       .enable = iproc_asiu_clk_enable,
>> +       .disable = iproc_asiu_clk_disable,
>> +       .recalc_rate = iproc_asiu_clk_recalc_rate,
>> +       .round_rate = iproc_asiu_clk_round_rate,
>> +       .set_rate = iproc_asiu_clk_set_rate,
>> +};
>> +
>> +void __init iproc_asiu_setup(struct device_node *node,
>> +               const struct iproc_asiu_div *div,
>> +               const struct iproc_asiu_gate *gate, unsigned int num_clks)
>> +{
>> +       int i, ret;
>> +       struct iproc_asiu *asiu;
>> +
>> +       if (WARN_ON(!gate || !div))
>> +               return;
>> +
>> +       asiu = kzalloc(sizeof(*asiu), GFP_KERNEL);
>> +       if (WARN_ON(!asiu))
>> +               return;
>> +
>> +       asiu->clk_data.clk_num = num_clks;
>> +       asiu->clk_data.clks = kcalloc(num_clks, sizeof(*asiu->clk_data.clks),
>> +                       GFP_KERNEL);
>> +       if (WARN_ON(!asiu->clk_data.clks))
>> +               goto err_clks;
>> +
>> +       asiu->clks = kcalloc(num_clks, sizeof(*asiu->clks), GFP_KERNEL);
>> +       if (WARN_ON(!asiu->clks))
>> +               goto err_asiu_clks;
>> +
>> +       asiu->div_base = of_iomap(node, 0);
>> +       if (WARN_ON(!asiu->div_base))
>> +               goto err_iomap_div;
>> +
>> +       asiu->gate_base = of_iomap(node, 1);
>> +       if (WARN_ON(!asiu->gate_base))
>> +               goto err_iomap_gate;
>> +
>> +       for (i = 0; i < num_clks; i++) {
>> +               struct clk_init_data init;
>> +               struct clk *clk;
>> +               const char *parent_name;
>> +               struct iproc_asiu_clk *asiu_clk;
>> +               const char *clk_name;
>> +
>> +               clk_name = kzalloc(IPROC_CLK_NAME_LEN, GFP_KERNEL);
>> +               if (WARN_ON(!clk_name))
>> +                       goto err_clk_register;
>> +
>> +               ret = of_property_read_string_index(node, "clock-output-names",
>> +                               i, &clk_name);
>> +               if (WARN_ON(ret))
>> +                       goto err_clk_register;
>> +
>> +               asiu_clk = &asiu->clks[i];
>> +               asiu_clk->name = clk_name;
>> +               asiu_clk->asiu = asiu;
>> +               asiu_clk->div = div[i];
>> +               asiu_clk->gate = gate[i];
>> +               init.name = clk_name;
>> +               init.ops = &iproc_asiu_ops;
>> +               init.flags = 0;
>> +               parent_name = of_clk_get_parent_name(node, 0);
>> +               init.parent_names = (parent_name ? &parent_name : NULL);
>> +               init.num_parents = (parent_name ? 1 : 0);
>> +               asiu_clk->hw.init = &init;
>> +
>> +               clk = clk_register(NULL, &asiu_clk->hw);
>> +               if (WARN_ON(IS_ERR(clk)))
>> +                       goto err_clk_register;
>> +               asiu->clk_data.clks[i] = clk;
>> +       }
>> +
>> +       ret = of_clk_add_provider(node, of_clk_src_onecell_get,
>> +                       &asiu->clk_data);
>> +       if (WARN_ON(ret))
>> +               goto err_clk_register;
>> +
>> +       return;
>> +
>> +err_clk_register:
>> +       for (i = 0; i < num_clks; i++)
>> +               kfree(asiu->clks[i].name);
>> +       iounmap(asiu->gate_base);
>> +
>> +err_iomap_gate:
>> +       iounmap(asiu->div_base);
>> +
>> +err_iomap_div:
>> +       kfree(asiu->clks);
>> +
>> +err_asiu_clks:
>> +       kfree(asiu->clk_data.clks);
>> +
>> +err_clks:
>> +       kfree(asiu);
>> +}
>> diff --git a/drivers/clk/bcm/clk-iproc-clk.c b/drivers/clk/bcm/clk-iproc-clk.c
>> new file mode 100644
>> index 0000000..be3c42c
>> --- /dev/null
>> +++ b/drivers/clk/bcm/clk-iproc-clk.c
>> @@ -0,0 +1,238 @@
>> +/*
>> + * Copyright (C) 2014 Broadcom Corporation
>> + *
>> + * This program is free software; you can redistribute it and/or
>> + * modify it under the terms of the GNU General Public License as
>> + * published by the Free Software Foundation version 2.
>> + *
>> + * This program is distributed "as is" WITHOUT ANY WARRANTY of any
>> + * kind, whether express or implied; without even the implied warranty
>> + * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + */
>> +
>> +#include <linux/kernel.h>
>> +#include <linux/err.h>
>> +#include <linux/clk-provider.h>
>> +#include <linux/io.h>
>> +#include <linux/of.h>
>> +#include <linux/clkdev.h>
>> +#include <linux/of_address.h>
>> +#include <linux/delay.h>
>> +
>> +#include "clk-iproc.h"
>> +
>> +struct iproc_pll;
>> +
>> +struct iproc_clk {
>> +       struct clk_hw hw;
>> +       const char *name;
>> +       struct iproc_pll *pll;
>> +       unsigned long rate;
>> +       const struct iproc_clk_ctrl *ctrl;
>> +};
>> +
>> +struct iproc_pll {
>> +       void __iomem *base;
>> +       struct clk_onecell_data clk_data;
>> +       struct iproc_clk *clks;
>> +};
>> +
>> +#define to_iproc_clk(hw) container_of(hw, struct iproc_clk, hw)
>> +
>> +static int iproc_clk_enable(struct clk_hw *hw)
>> +{
>> +       struct iproc_clk *clk = to_iproc_clk(hw);
>> +       const struct iproc_clk_ctrl *ctrl = clk->ctrl;
>> +       struct iproc_pll *pll = clk->pll;
>> +       u32 val;
>> +
>> +       /* channel enable is active low */
>> +       val = readl(pll->base + ctrl->enable.offset);
>> +       val &= ~(1 << ctrl->enable.enable_shift);
>> +       writel(val, pll->base + ctrl->enable.offset);
>> +
>> +       /* also make sure channel is not held */
>> +       val = readl(pll->base + ctrl->enable.offset);
>> +       val &= ~(1 << ctrl->enable.hold_shift);
>> +       writel(val, pll->base + ctrl->enable.offset);
>> +
>> +       return 0;
>> +}
>> +
>> +static void iproc_clk_disable(struct clk_hw *hw)
>> +{
>> +       struct iproc_clk *clk = to_iproc_clk(hw);
>> +       const struct iproc_clk_ctrl *ctrl = clk->ctrl;
>> +       struct iproc_pll *pll = clk->pll;
>> +       u32 val;
>> +
>> +       if (ctrl->flags & IPROC_CLK_AON)
>> +               return;
>> +
>> +       val = readl(pll->base + ctrl->enable.offset);
>> +       val |= 1 << ctrl->enable.enable_shift;
>> +       writel(val, pll->base + ctrl->enable.offset);
>> +}
>> +
>> +static unsigned long iproc_clk_recalc_rate(struct clk_hw *hw,
>> +               unsigned long parent_rate)
>> +{
>> +       struct iproc_clk *clk = to_iproc_clk(hw);
>> +       const struct iproc_clk_ctrl *ctrl = clk->ctrl;
>> +       struct iproc_pll *pll = clk->pll;
>> +       u32 val;
>> +       unsigned int mdiv;
>> +
>> +       if (parent_rate == 0)
>> +               return 0;
>> +
>> +       val = readl(pll->base + ctrl->mdiv.offset);
>> +       mdiv = (val >> ctrl->mdiv.shift) & bit_mask(ctrl->mdiv.width);
>> +       if (mdiv == 0)
>> +               mdiv = 256;
>> +
>> +       clk->rate = parent_rate / mdiv;
>> +
>> +       return clk->rate;
>> +}
>> +
>> +static long iproc_clk_round_rate(struct clk_hw *hw, unsigned long rate,
>> +               unsigned long *parent_rate)
>> +{
>> +       unsigned int div;
>> +
>> +       if (rate == 0 || *parent_rate == 0)
>> +               return -EINVAL;
>> +
>> +       if (rate == *parent_rate)
>> +               return *parent_rate;
>> +
>> +       div = DIV_ROUND_UP(*parent_rate, rate);
>> +       if (div < 2)
>> +               return *parent_rate;
>> +
>> +       if (div > 256)
>> +               div = 256;
>> +
>> +       return *parent_rate / div;
>> +}
>> +
>> +static int iproc_clk_set_rate(struct clk_hw *hw, unsigned long rate,
>> +               unsigned long parent_rate)
>> +{
>> +       struct iproc_clk *clk = to_iproc_clk(hw);
>> +       const struct iproc_clk_ctrl *ctrl = clk->ctrl;
>> +       struct iproc_pll *pll = clk->pll;
>> +       u32 val;
>> +       unsigned int div;
>> +
>> +       if (rate == 0 || parent_rate == 0)
>> +               return -EINVAL;
>> +
>> +       div = DIV_ROUND_UP(parent_rate, rate);
>> +       if (div > 256)
>> +               return -EINVAL;
>> +
>> +       val = readl(pll->base + ctrl->mdiv.offset);
>> +       if (div == 256) {
>> +               val &= ~(bit_mask(ctrl->mdiv.width) << ctrl->mdiv.shift);
>> +       } else {
>> +               val &= ~(bit_mask(ctrl->mdiv.width) << ctrl->mdiv.shift);
>> +               val |= div << ctrl->mdiv.shift;
>> +       }
>> +       writel(val, pll->base + ctrl->mdiv.offset);
>> +       clk->rate = parent_rate / div;
>> +
>> +       return 0;
>> +}
>> +
>> +static const struct clk_ops iproc_clk_ops = {
>> +       .enable = iproc_clk_enable,
>> +       .disable = iproc_clk_disable,
>> +       .recalc_rate = iproc_clk_recalc_rate,
>> +       .round_rate = iproc_clk_round_rate,
>> +       .set_rate = iproc_clk_set_rate,
>> +};
>> +
>> +void __init iproc_clk_setup(struct device_node *node,
>> +               const struct iproc_clk_ctrl *ctrl, unsigned int num_clks)
>> +{
>> +       int i, ret;
>> +       struct iproc_pll *pll;
>> +
>> +       if (WARN_ON(!ctrl))
>> +               return;
>> +
>> +       pll = kzalloc(sizeof(*pll), GFP_KERNEL);
>> +       if (WARN_ON(!pll))
>> +               return;
>> +
>> +       pll->clk_data.clk_num = num_clks;
>> +       pll->clk_data.clks = kcalloc(num_clks, sizeof(*pll->clk_data.clks),
>> +                       GFP_KERNEL);
>> +       if (WARN_ON(!pll->clk_data.clks))
>> +               goto err_clks;
>> +
>> +       pll->clks = kcalloc(num_clks, sizeof(*pll->clks), GFP_KERNEL);
>> +       if (WARN_ON(!pll->clks))
>> +               goto err_pll_clks;
>> +
>> +       pll->base = of_iomap(node, 0);
>> +       if (WARN_ON(!pll->base))
>> +               goto err_iomap;
>> +
>> +       for (i = 0; i < num_clks; i++) {
>> +               struct clk_init_data init;
>> +               struct clk *clk;
>> +               const char *parent_name;
>> +               struct iproc_clk *iclk;
>> +               const char *clk_name;
>> +
>> +               clk_name = kzalloc(IPROC_CLK_NAME_LEN, GFP_KERNEL);
>> +               if (WARN_ON(!clk_name))
>> +                       goto err_clk_register;
>> +
>> +               ret = of_property_read_string_index(node, "clock-output-names",
>> +                               i, &clk_name);
>> +               if (WARN_ON(ret))
>> +                       goto err_clk_register;
>> +
>> +               iclk = &pll->clks[i];
>> +               iclk->name = clk_name;
>> +               iclk->pll = pll;
>> +               iclk->ctrl = &ctrl[i];
>> +               init.name = clk_name;
>> +               init.ops = &iproc_clk_ops;
>> +               init.flags = 0;
>> +               parent_name = of_clk_get_parent_name(node, 0);
>> +               init.parent_names = (parent_name ? &parent_name : NULL);
>> +               init.num_parents = (parent_name ? 1 : 0);
>> +               iclk->hw.init = &init;
>> +
>> +               clk = clk_register(NULL, &iclk->hw);
>> +               if (WARN_ON(IS_ERR(clk)))
>> +                       goto err_clk_register;
>> +               pll->clk_data.clks[i] = clk;
>> +       }
>> +
>> +       ret = of_clk_add_provider(node, of_clk_src_onecell_get, &pll->clk_data);
>> +       if (WARN_ON(ret))
>> +               goto err_clk_register;
>> +
>> +       return;
>> +
>> +err_clk_register:
>> +       for (i = 0; i < num_clks; i++)
>> +               kfree(pll->clks[i].name);
>> +       iounmap(pll->base);
>> +
>> +err_iomap:
>> +       kfree(pll->clks);
>> +
>> +err_pll_clks:
>> +       kfree(pll->clk_data.clks);
>> +
>> +err_clks:
>> +       kfree(pll);
>> +}
>> diff --git a/drivers/clk/bcm/clk-iproc-pll.c b/drivers/clk/bcm/clk-iproc-pll.c
>> new file mode 100644
>> index 0000000..cd3bd38
>> --- /dev/null
>> +++ b/drivers/clk/bcm/clk-iproc-pll.c
>> @@ -0,0 +1,483 @@
>> +/*
>> + * Copyright (C) 2014 Broadcom Corporation
>> + *
>> + * This program is free software; you can redistribute it and/or
>> + * modify it under the terms of the GNU General Public License as
>> + * published by the Free Software Foundation version 2.
>> + *
>> + * This program is distributed "as is" WITHOUT ANY WARRANTY of any
>> + * kind, whether express or implied; without even the implied warranty
>> + * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + */
>> +
>> +#include <linux/kernel.h>
>> +#include <linux/err.h>
>> +#include <linux/clk-provider.h>
>> +#include <linux/io.h>
>> +#include <linux/of.h>
>> +#include <linux/clkdev.h>
>> +#include <linux/of_address.h>
>> +#include <linux/delay.h>
>> +
>> +#include "clk-iproc.h"
>> +
>> +#define PLL_VCO_HIGH_SHIFT 19
>> +#define PLL_VCO_LOW_SHIFT  30
>> +
>> +/* number of delay loops waiting for PLL to lock */
>> +#define LOCK_DELAY 100
>> +
>> +/* number of VCO frequency bands */
>> +#define NUM_FREQ_BANDS 8
>> +
>> +#define NUM_KP_BANDS 3
>> +enum kp_band {
>> +       KP_BAND_MID = 0,
>> +       KP_BAND_HIGH,
>> +       KP_BAND_HIGH_HIGH
>> +};
>> +
>> +static const unsigned int kp_table[NUM_KP_BANDS][NUM_FREQ_BANDS] = {
>> +       { 5, 6, 6, 7, 7, 8, 9, 10 },
>> +       { 4, 4, 5, 5, 6, 7, 8, 9  },
>> +       { 4, 5, 5, 6, 7, 8, 9, 10 },
>> +};
>> +
>> +static const unsigned long ref_freq_table[NUM_FREQ_BANDS][2] = {
>> +       { 10000000,  12500000  },
>> +       { 12500000,  15000000  },
>> +       { 15000000,  20000000  },
>> +       { 20000000,  25000000  },
>> +       { 25000000,  50000000  },
>> +       { 50000000,  75000000  },
>> +       { 75000000,  100000000 },
>> +       { 100000000, 125000000 },
>> +};
>> +
>> +enum vco_freq_range {
>> +       VCO_LOW       = 700000000U,
>> +       VCO_MID       = 1200000000U,
>> +       VCO_HIGH      = 2200000000U,
>> +       VCO_HIGH_HIGH = 3100000000U,
>> +       VCO_MAX       = 4000000000U,
>> +};
>> +
>> +struct iproc_pll {
>> +       struct clk_hw hw;
>> +       void __iomem *pll_base;
>> +       void __iomem *pwr_base;
>> +       void __iomem *asiu_base;
>> +       struct clk_onecell_data clk_data;
>> +       const char *name;
>> +       const struct iproc_pll_ctrl *ctrl;
>> +       const struct iproc_pll_vco_freq_param *vco_param;
>> +       unsigned int num_vco_entries;
>> +       unsigned long rate;
>> +};
>> +
>> +#define to_iproc_pll(hw) container_of(hw, struct iproc_pll, hw)
>> +
>> +/*
>> + * Get the clock rate based on name
>> + */
>> +static unsigned long __get_rate(const char *clk_name)
>> +{
>> +       struct clk *clk;
>> +
>> +       clk = __clk_lookup(clk_name);
>> +       if (!clk) {
>> +               pr_err("%s: unable to find clock by name: %s\n", __func__,
>> +                               clk_name);
>> +               return 0;
>> +       }
>> +
>> +       return clk_get_rate(clk);
>> +}
>> +
>> +/*
>> + * Based on the target frequency, find a match from the VCO frequency parameter
>> + * table and return its index
>> + */
>> +static int pll_get_rate_index(struct iproc_pll *pll, unsigned int target_rate)
>> +{
>> +       int i;
>> +
>> +       for (i = 0; i < pll->num_vco_entries; i++)
>> +               if (target_rate == pll->vco_param[i].rate)
>> +                       break;
>> +
>> +       if (i >= pll->num_vco_entries)
>> +               return -EINVAL;
>> +
>> +       return i;
>> +}
>> +
>> +static int get_kp(unsigned long ref_freq, enum kp_band kp_index)
>> +{
>> +       int i;
>> +
>> +       if (ref_freq < ref_freq_table[0][0])
>> +               return -EINVAL;
>> +
>> +       for (i = 0; i < NUM_FREQ_BANDS; i++) {
>> +               if (ref_freq >= ref_freq_table[i][0] &&
>> +                       ref_freq < ref_freq_table[i][1])
>> +                       return kp_table[kp_index][i];
>> +       }
>> +       return -EINVAL;
>> +}
>> +
>> +static int pll_wait_for_lock(struct iproc_pll *pll)
>> +{
>> +       int i;
>> +       const struct iproc_pll_ctrl *ctrl = pll->ctrl;
>> +
>> +       for (i = 0; i < LOCK_DELAY; i++) {
>> +               u32 val = readl(pll->pll_base + ctrl->status.offset);
>> +
>> +               if (val & (1 << ctrl->status.shift))
>> +                       return 0;
>> +               udelay(10);
>> +       }
>> +
>> +       return -EIO;
>> +}
>> +
>> +static void __pll_disable(struct iproc_pll *pll)
>> +{
>> +       const struct iproc_pll_ctrl *ctrl = pll->ctrl;
>> +       u32 val;
>> +
>> +       if (ctrl->flags & IPROC_CLK_PLL_ASIU) {
>> +               val = readl(pll->asiu_base + ctrl->asiu.offset);
>> +               val &= ~(1 << ctrl->asiu.en_shift);
>> +               writel(val, pll->asiu_base + ctrl->asiu.offset);
>> +       }
>> +
>> +       /* latch input value so core power can be shut down */
>> +       val = readl(pll->pwr_base + ctrl->aon.offset);
>> +       val |= (1 << ctrl->aon.iso_shift);
>> +       writel(val, pll->pwr_base + ctrl->aon.offset);
>> +
>> +       /* power down the core */
>> +       val &= ~(bit_mask(ctrl->aon.pwr_width) << ctrl->aon.pwr_shift);
>> +       writel(val, pll->pwr_base + ctrl->aon.offset);
>> +}
>> +
>> +static int __pll_enable(struct iproc_pll *pll)
>> +{
>> +       const struct iproc_pll_ctrl *ctrl = pll->ctrl;
>> +       u32 val;
>> +
>> +       /* power up the PLL and make sure it's not latched */
>> +       val = readl(pll->pwr_base + ctrl->aon.offset);
>> +       val |= bit_mask(ctrl->aon.pwr_width) << ctrl->aon.pwr_shift;
>> +       val &= ~(1 << ctrl->aon.iso_shift);
>> +       writel(val, pll->pwr_base + ctrl->aon.offset);
>> +
>> +       /* certain PLLs also need to be ungated from the ASIU top level */
>> +       if (ctrl->flags & IPROC_CLK_PLL_ASIU) {
>> +               val = readl(pll->asiu_base + ctrl->asiu.offset);
>> +               val |= (1 << ctrl->asiu.en_shift);
>> +               writel(val, pll->asiu_base + ctrl->asiu.offset);
>> +       }
>> +
>> +       return 0;
>> +}
>> +
>> +static void __pll_put_in_reset(struct iproc_pll *pll)
>> +{
>> +       u32 val;
>> +       const struct iproc_pll_ctrl *ctrl = pll->ctrl;
>> +       const struct iproc_pll_reset_ctrl *reset = &ctrl->reset;
>> +
>> +       val = readl(pll->pll_base + reset->offset);
>> +       val &= ~(1 << reset->reset_shift | 1 << reset->p_reset_shift);
>> +       writel(val, pll->pll_base + reset->offset);
>> +}
>> +
>> +static void __pll_bring_out_reset(struct iproc_pll *pll, unsigned int kp,
>> +               unsigned int ka, unsigned int ki)
>> +{
>> +       u32 val;
>> +       const struct iproc_pll_ctrl *ctrl = pll->ctrl;
>> +       const struct iproc_pll_reset_ctrl *reset = &ctrl->reset;
>> +
>> +       val = readl(pll->pll_base + reset->offset);
>> +       val &= ~(bit_mask(reset->ki_width) << reset->ki_shift |
>> +               bit_mask(reset->kp_width) << reset->kp_shift |
>> +               bit_mask(reset->ka_width) << reset->ka_shift);
>> +       val |=  ki << reset->ki_shift | kp << reset->kp_shift |
>> +               ka << reset->ka_shift;
>> +       val |= 1 << reset->reset_shift | 1 << reset->p_reset_shift;
>> +       writel(val, pll->pll_base + reset->offset);
>> +}
>> +
>> +static int pll_set_rate(struct iproc_pll *pll, unsigned int rate_index,
>> +               unsigned long parent_rate)
>> +{
>> +       const struct iproc_pll_vco_freq_param *vco =
>> +                               &pll->vco_param[rate_index];
>> +       const struct iproc_pll_ctrl *ctrl = pll->ctrl;
>> +       int ka = 0, ki, kp, ret;
>> +       unsigned long rate = vco->rate;
>> +       u32 val;
>> +       enum kp_band kp_index;
>> +       unsigned long ref_freq;
>> +
>> +       /*
>> +        * reference frequency = parent frequency / PDIV
>> +        * If PDIV = 0, then it becomes a multiplier (x2)
>> +        */
>> +       if (vco->pdiv == 0)
>> +               ref_freq = parent_rate * 2;
>> +       else
>> +               ref_freq = parent_rate / vco->pdiv;
>> +
>> +       /* determine Ki and Kp index based on target VCO frequency */
>> +       if (rate >= VCO_LOW && rate < VCO_HIGH) {
>> +               ki = 4;
>> +               kp_index = KP_BAND_MID;
>> +       } else if (rate >= VCO_HIGH && rate && rate < VCO_HIGH_HIGH) {
>> +               ki = 3;
>> +               kp_index = KP_BAND_HIGH;
>> +       } else if (rate >= VCO_HIGH_HIGH && rate < VCO_MAX) {
>> +               ki = 3;
>> +               kp_index = KP_BAND_HIGH_HIGH;
>> +       } else {
>> +               pr_err("%s: pll: %s has invalid rate: %lu\n", __func__,
>> +                               pll->name, rate);
>> +               return -EINVAL;
>> +       }
>> +
>> +       kp = get_kp(ref_freq, kp_index);
>> +       if (kp < 0) {
>> +               pr_err("%s: pll: %s has invalid kp\n", __func__, pll->name);
>> +               return kp;
>> +       }
>> +
>> +       ret = __pll_enable(pll);
>> +       if (ret) {
>> +               pr_err("%s: pll: %s fails to enable\n", __func__, pll->name);
>> +               return ret;
>> +       }
>> +
>> +       /* put PLL in reset */
>> +       __pll_put_in_reset(pll);
>> +
>> +       writel(0, pll->pll_base + ctrl->vco_ctrl.u_offset);
>> +       val = readl(pll->pll_base + ctrl->vco_ctrl.l_offset);
>> +
>> +       if (rate >= VCO_LOW && rate < VCO_MID)
>> +               val |= (1 << PLL_VCO_LOW_SHIFT);
>> +
>> +       if (rate < VCO_HIGH)
>> +               val &= ~(1 << PLL_VCO_HIGH_SHIFT);
>> +       else
>> +               val |= (1 << PLL_VCO_HIGH_SHIFT);
>> +
>> +       writel(val, pll->pll_base + ctrl->vco_ctrl.l_offset);
>> +
>> +       /* program integer part of NDIV */
>> +       val = readl(pll->pll_base + ctrl->ndiv_int.offset);
>> +       val &= ~(bit_mask(ctrl->ndiv_int.width) << ctrl->ndiv_int.shift);
>> +       val |= vco->ndiv_int << ctrl->ndiv_int.shift;
>> +       writel(val, pll->pll_base + ctrl->ndiv_int.offset);
>> +
>> +       /* program fractional part of NDIV */
>> +       if (ctrl->flags & IPROC_CLK_PLL_HAS_NDIV_FRAC) {
>> +               val = readl(pll->pll_base + ctrl->ndiv_frac.offset);
>> +               val &= ~(bit_mask(ctrl->ndiv_frac.width) <<
>> +                               ctrl->ndiv_frac.shift);
>> +               val |= vco->ndiv_frac << ctrl->ndiv_frac.shift;
>> +               writel(val, pll->pll_base + ctrl->ndiv_frac.offset);
>> +       }
>> +
>> +       /* program PDIV */
>> +       val = readl(pll->pll_base + ctrl->pdiv.offset);
>> +       val &= ~(bit_mask(ctrl->pdiv.width) << ctrl->pdiv.shift);
>> +       val |= vco->pdiv << ctrl->pdiv.shift;
>> +       writel(val, pll->pll_base + ctrl->pdiv.offset);
>> +
>> +       __pll_bring_out_reset(pll, kp, ka, ki);
>> +
>> +       ret = pll_wait_for_lock(pll);
>> +       if (ret < 0) {
>> +               pr_err("%s: pll: %s failed to lock\n", __func__, pll->name);
>> +               return ret;
>> +       }
>> +
>> +       return 0;
>> +}
>> +
>> +static int iproc_pll_enable(struct clk_hw *hw)
>> +{
>> +       struct iproc_pll *pll = to_iproc_pll(hw);
>> +
>> +       return __pll_enable(pll);
>> +}
>> +
>> +static void iproc_pll_disable(struct clk_hw *hw)
>> +{
>> +       struct iproc_pll *pll = to_iproc_pll(hw);
>> +       const struct iproc_pll_ctrl *ctrl = pll->ctrl;
>> +
>> +       if (ctrl->flags & IPROC_CLK_AON)
>> +               return;
>> +
>> +       __pll_disable(pll);
>> +}
>> +
>> +static unsigned long iproc_pll_recalc_rate(struct clk_hw *hw,
>> +       unsigned long parent_rate)
>> +{
>> +       struct iproc_pll *pll = to_iproc_pll(hw);
>> +       const struct iproc_pll_ctrl *ctrl = pll->ctrl;
>> +       u32 val;
>> +       u64 ndiv;
>> +       unsigned int ndiv_int, ndiv_frac, pdiv;
>> +
>> +       if (parent_rate == 0)
>> +               return 0;
>> +
>> +       /* PLL needs to be locked */
>> +       val = readl(pll->pll_base + ctrl->status.offset);
>> +       if ((val & (1 << ctrl->status.shift)) == 0) {
>> +               pll->rate = 0;
>> +               return 0;
>> +       }
>> +
>> +       /*
>> +        * PLL output frequency =
>> +        *
>> +        * ((ndiv_int + ndiv_frac / 2^20) * (parent clock rate / pdiv)
>> +        */
>> +       val = readl(pll->pll_base + ctrl->ndiv_int.offset);
>> +       ndiv_int = (val >> ctrl->ndiv_int.shift) &
>> +               bit_mask(ctrl->ndiv_int.width);
>> +       ndiv = ndiv_int << ctrl->ndiv_int.shift;
>> +
>> +       if (ctrl->flags & IPROC_CLK_PLL_HAS_NDIV_FRAC) {
>> +               val = readl(pll->pll_base + ctrl->ndiv_frac.offset);
>> +               ndiv_frac = (val >> ctrl->ndiv_frac.shift) &
>> +                       bit_mask(ctrl->ndiv_frac.width);
>> +
>> +               if (ndiv_frac != 0)
>> +                       ndiv = (ndiv_int << ctrl->ndiv_int.shift) | ndiv_frac;
>> +       }
>> +
>> +       val = readl(pll->pll_base + ctrl->pdiv.offset);
>> +       pdiv = (val >> ctrl->pdiv.shift) & bit_mask(ctrl->pdiv.width);
>> +
>> +       pll->rate = (ndiv * parent_rate) >> ctrl->ndiv_int.shift;
>> +
>> +       if (pdiv == 0)
>> +               pll->rate *= 2;
>> +       else
>> +               pll->rate /= pdiv;
>> +
>> +       return pll->rate;
>> +}
>> +
>> +static const struct clk_ops iproc_pll_ops = {
>> +       .enable = iproc_pll_enable,
>> +       .disable = iproc_pll_disable,
>> +       .recalc_rate = iproc_pll_recalc_rate,
>> +};
>> +
>> +void __init iproc_pll_setup(struct device_node *node,
>> +               const struct iproc_pll_ctrl *ctrl,
>> +               const struct iproc_pll_vco_freq_param *vco_param,
>> +               unsigned int num_vco_entries)
>> +{
>> +       int ret;
>> +       struct clk *clk;
>> +       struct iproc_pll *pll;
>> +       struct clk_init_data init;
>> +       const char *parent_name;
>> +       unsigned int rate;
>> +
>> +       if (WARN_ON(!ctrl))
>> +               return;
>> +
>> +       pll = kzalloc(sizeof(*pll), GFP_KERNEL);
>> +       if (WARN_ON(!pll))
>> +               return;
>> +
>> +       pll->pll_base = of_iomap(node, 0);
>> +       if (WARN_ON(!pll->pll_base))
>> +               goto err_pll_iomap;
>> +
>> +       pll->pwr_base = of_iomap(node, 1);
>> +       if (WARN_ON(!pll->pwr_base))
>> +               goto err_pwr_iomap;
>> +
>> +       /* some PLLs require gating control at the top ASIU level */
>> +       if (ctrl->flags & IPROC_CLK_PLL_ASIU) {
>> +               pll->asiu_base = of_iomap(node, 2);
>> +               if (WARN_ON(!pll->asiu_base))
>> +                       goto err_asiu_iomap;
>> +       }
>> +
>> +       pll->ctrl = ctrl;
>> +       pll->name = node->name;
>> +       init.name = node->name;
>> +       init.ops = &iproc_pll_ops;
>> +       init.flags = 0;
>> +       parent_name = of_clk_get_parent_name(node, 0);
>> +       init.parent_names = (parent_name ? &parent_name : NULL);
>> +       init.num_parents = (parent_name ? 1 : 0);
>> +       pll->hw.init = &init;
>> +
>> +       /* configure the PLL to the desired VCO frequency if specified */
>> +       ret = of_property_read_u32(node, "clock-frequency", &rate);
>> +       if (!ret) {
>> +               unsigned long parent_rate;
>> +               int rate_index;
>> +
>> +               if (WARN_ON(!vco_param))
>> +                       goto err_clk_register;
>> +
>> +               pll->num_vco_entries = num_vco_entries;
>> +               pll->vco_param = vco_param;
>> +
>> +               parent_rate = __get_rate(parent_name);
>> +               if (WARN_ON(!parent_rate))
>> +                       goto err_clk_register;
>> +
>> +               rate_index = pll_get_rate_index(pll, rate);
>> +               if (WARN_ON(rate_index < 0))
>> +                       goto err_clk_register;
>> +
>> +               ret = pll_set_rate(pll, rate_index, parent_rate);
>> +               if (WARN_ON(ret))
>> +                       goto err_clk_register;
>> +       }
>> +
>> +       clk = clk_register(NULL, &pll->hw);
>> +       if (WARN_ON(IS_ERR(clk)))
>> +               goto err_clk_register;
>> +
>> +       pll->clk_data.clk_num = 1;
>> +       pll->clk_data.clks = &clk;
>> +
>> +       ret = of_clk_add_provider(node, of_clk_src_onecell_get,
>> +                       &pll->clk_data);
>> +       if (WARN_ON(ret))
>> +               goto err_clk_add;
>> +
>> +       return;
>> +
>> +err_clk_add:
>> +       clk_unregister(clk);
>> +err_clk_register:
>> +       if (pll->asiu_base)
>> +               iounmap(pll->asiu_base);
>> +err_asiu_iomap:
>> +       iounmap(pll->pwr_base);
>> +err_pwr_iomap:
>> +       iounmap(pll->pll_base);
>> +err_pll_iomap:
>> +       kfree(pll);
>> +}
>> diff --git a/drivers/clk/bcm/clk-iproc.h b/drivers/clk/bcm/clk-iproc.h
>> new file mode 100644
>> index 0000000..4aa0479
>> --- /dev/null
>> +++ b/drivers/clk/bcm/clk-iproc.h
>> @@ -0,0 +1,155 @@
>> +/*
>> + * Copyright (C) 2014 Broadcom Corporation
>> + *
>> + * This program is free software; you can redistribute it and/or
>> + * modify it under the terms of the GNU General Public License as
>> + * published by the Free Software Foundation version 2.
>> + *
>> + * This program is distributed "as is" WITHOUT ANY WARRANTY of any
>> + * kind, whether express or implied; without even the implied warranty
>> + * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + */
>> +
>> +#ifndef _CLK_IPROC_H
>> +#define _CLK_IPROC_H
>> +
>> +#include <linux/kernel.h>
>> +#include <linux/list.h>
>> +#include <linux/spinlock.h>
>> +#include <linux/slab.h>
>> +#include <linux/device.h>
>> +#include <linux/of.h>
>> +#include <linux/clk-provider.h>
>> +
>> +#define IPROC_CLK_NAME_LEN 25
>> +#define IPROC_CLK_INVALID_OFFSET 0xffffffff
>> +#define bit_mask(width) ((1 << (width)) - 1)
>> +
>> +/* clock should not be disabled at runtime */
>> +#define IPROC_CLK_AON BIT(0)
>> +
>> +/* PLL requires gating through ASIU */
>> +#define IPROC_CLK_PLL_ASIU BIT(1)
>> +
>> +/* PLL has fractional part of the NDIV */
>> +#define IPROC_CLK_PLL_HAS_NDIV_FRAC BIT(2)
>> +
>> +/*
>> + * Parameters for VCO frequency configuration
>> + *
>> + * VCO frequency =
>> + * ((ndiv_int + ndiv_frac / 2^20) * (ref freqeuncy  / pdiv)
>> + */
>> +struct iproc_pll_vco_freq_param {
>> +       unsigned long rate;
>> +       unsigned int ndiv_int;
>> +       unsigned int ndiv_frac;
>> +       unsigned int pdiv;
>> +};
>> +
>> +struct iproc_clk_reg_op {
>> +       unsigned int offset;
>> +       unsigned int shift;
>> +       unsigned int width;
>> +};
>> +
>> +/*
>> + * Clock gating control at the top ASIU level
>> + */
>> +struct iproc_asiu_gate {
>> +       unsigned int offset;
>> +       unsigned int en_shift;
>> +};
>> +
>> +/*
>> + * Control of powering on/off of a PLL
>> + *
>> + * Before powering off a PLL, input isolation (ISO) needs to be enabled
>> + */
>> +struct iproc_pll_aon_pwr_ctrl {
>> +       unsigned int offset;
>> +       unsigned int pwr_width;
>> +       unsigned int pwr_shift;
>> +       unsigned int iso_shift;
>> +};
>> +
>> +/*
>> + * Control of the PLL reset, with Ki, Kp, and Ka parameters
>> + */
>> +struct iproc_pll_reset_ctrl {
>> +       unsigned int offset;
>> +       unsigned int reset_shift;
>> +       unsigned int p_reset_shift;
>> +       unsigned int ki_shift;
>> +       unsigned int ki_width;
>> +       unsigned int kp_shift;
>> +       unsigned int kp_width;
>> +       unsigned int ka_shift;
>> +       unsigned int ka_width;
>> +};
>> +
>> +struct iproc_pll_vco_ctrl {
>> +       unsigned int u_offset;
>> +       unsigned int l_offset;
>> +};
>> +
>> +/*
>> + * Main PLL control parameters
>> + */
>> +struct iproc_pll_ctrl {
>> +       unsigned long flags;
>> +       struct iproc_pll_aon_pwr_ctrl aon;
>> +       struct iproc_asiu_gate asiu;
>> +       struct iproc_pll_reset_ctrl reset;
>> +       struct iproc_clk_reg_op ndiv_int;
>> +       struct iproc_clk_reg_op ndiv_frac;
>> +       struct iproc_clk_reg_op pdiv;
>> +       struct iproc_pll_vco_ctrl vco_ctrl;
>> +       struct iproc_clk_reg_op status;
>> +};
>> +
>> +/*
>> + * Controls enabling/disabling a PLL derived clock
>> + */
>> +struct iproc_clk_enable_ctrl {
>> +       unsigned int offset;
>> +       unsigned int enable_shift;
>> +       unsigned int hold_shift;
>> +       unsigned int bypass_shift;
>> +};
>> +
>> +/*
>> + * Main clock control parameters for clocks derived from the PLLs
>> + */
>> +struct iproc_clk_ctrl {
>> +       unsigned int channel;
>> +       unsigned long flags;
>> +       struct iproc_clk_enable_ctrl enable;
>> +       struct iproc_clk_reg_op mdiv;
>> +};
>> +
>> +/*
>> + * Divisor of the ASIU clocks
>> + */
>> +struct iproc_asiu_div {
>> +       unsigned int offset;
>> +       unsigned int en_shift;
>> +       unsigned int high_shift;
>> +       unsigned int high_width;
>> +       unsigned int low_shift;
>> +       unsigned int low_width;
>> +};
>> +
>> +extern void __init iproc_armpll_setup(struct device_node *node);
>> +extern void __init iproc_pll_setup(struct device_node *node,
>> +               const struct iproc_pll_ctrl *ctrl,
>> +               const struct iproc_pll_vco_freq_param *vco_param,
>> +               unsigned int num_freqs);
>> +extern void __init iproc_clk_setup(struct device_node *node,
>> +               const struct iproc_clk_ctrl *ctrl, unsigned int num_clks);
>> +extern void __init iproc_asiu_setup(struct device_node *node,
>> +               const struct iproc_asiu_div *div,
>> +               const struct iproc_asiu_gate *gate, unsigned int num_clks);
>> +
>> +#endif /* _CLK_IPROC_H */
>> --
>> 1.7.9.5
>>
>>
>> _______________________________________________
>> linux-arm-kernel mailing list
>> linux-arm-kernel@lists.infradead.org
>> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
