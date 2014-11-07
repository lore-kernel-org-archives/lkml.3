Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751988AbaKGFfR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 00:35:17 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:41433 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847AbaKGFfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 00:35:15 -0500
MIME-Version: 1.0
In-Reply-To: <545B5E58.4040404@kapsi.fi>
References: <1414599796-30597-1-git-send-email-tomeu.vizoso@collabora.com>
 <1414599796-30597-12-git-send-email-tomeu.vizoso@collabora.com>
 <545B2B89.8010801@nvidia.com> <545B5E58.4040404@kapsi.fi>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Fri, 7 Nov 2014 14:34:54 +0900
Message-ID: <CAAVeFu+xVgqB3aRrLTmki7hoXkk3ZDo28DJexMn_2fWr162M9Q@mail.gmail.com>
Subject: Re: [PATCH v3 11/13] clk: tegra: Add EMC clock driver
To: Mikko Perttunen <mikko.perttunen@kapsi.fi>
Cc: Alexandre Courbot <acourbot@nvidia.com>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Mikko Perttunen <mperttunen@nvidia.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 6, 2014 at 8:41 PM, Mikko Perttunen
<mikko.perttunen@kapsi.fi> wrote:
> On 11/06/2014 10:04 AM, Alexandre Courbot wrote:
>>
>> On 10/30/2014 01:22 AM, Tomeu Vizoso wrote:
>>>
>>> From: Mikko Perttunen <mperttunen@nvidia.com>
>>>
>>> The driver is currently only tested on Tegra124 Jetson TK1, but should
>>> work with other Tegra124 boards, provided that correct EMC tables are
>>> provided through the device tree. Older chip models have differing
>>> timing change sequences, so they are not currently supported.
>>>
>>> Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
>>> Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>
>>>
>>> ---
>>>
>>> v3:    * Add some locking to protect the registers that are shared
>>> with the MC
>>>       clock
>>>
>>> v2:    * Make sure that the clock is properly registered
>>>     * Bail out early from attempts to set the same rate
>>> ---
>>>   drivers/clk/tegra/Makefile       |   2 +-
>>>   drivers/clk/tegra/clk-emc.c      | 470
>>> +++++++++++++++++++++++++++++++++++++++
>>>   drivers/clk/tegra/clk-tegra124.c |   4 +-
>>>   drivers/clk/tegra/clk.h          |   2 +
>>>   4 files changed, 476 insertions(+), 2 deletions(-)
>>>   create mode 100644 drivers/clk/tegra/clk-emc.c
>>>
>>> diff --git a/drivers/clk/tegra/Makefile b/drivers/clk/tegra/Makefile
>>> index f7dfb72..240e5b4 100644
>>> --- a/drivers/clk/tegra/Makefile
>>> +++ b/drivers/clk/tegra/Makefile
>>> @@ -14,4 +14,4 @@ obj-y                    += clk-tegra-super-gen4.o
>>>   obj-$(CONFIG_ARCH_TEGRA_2x_SOC)         += clk-tegra20.o
>>>   obj-$(CONFIG_ARCH_TEGRA_3x_SOC)         += clk-tegra30.o
>>>   obj-$(CONFIG_ARCH_TEGRA_114_SOC)    += clk-tegra114.o
>>> -obj-$(CONFIG_ARCH_TEGRA_124_SOC)    += clk-tegra124.o
>>> +obj-$(CONFIG_ARCH_TEGRA_124_SOC)    += clk-tegra124.o clk-emc.o
>>> diff --git a/drivers/clk/tegra/clk-emc.c b/drivers/clk/tegra/clk-emc.c
>>> new file mode 100644
>>> index 0000000..182a059
>>> --- /dev/null
>>> +++ b/drivers/clk/tegra/clk-emc.c
>>> @@ -0,0 +1,470 @@
>>> +/*
>>> + * drivers/clk/tegra/clk-emc.c
>>> + *
>>> + * Copyright (c) 2014, NVIDIA CORPORATION.  All rights reserved.
>>> + *
>>> + * Author:
>>> + *    Mikko Perttunen <mperttunen@nvidia.com>
>>> + *
>>> + * This software is licensed under the terms of the GNU General Public
>>> + * License version 2, as published by the Free Software Foundation, and
>>> + * may be copied, distributed, and modified under those terms.
>>> + *
>>> + * This program is distributed in the hope that it will be useful,
>>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>>> + * GNU General Public License for more details.
>>> + *
>>> + */
>>> +
>>> +#include <linux/clk-provider.h>
>>> +#include <linux/clk.h>
>>> +#include <linux/clkdev.h>
>>> +#include <linux/delay.h>
>>> +#include <linux/module.h>
>>> +#include <linux/of_address.h>
>>> +#include <linux/of_platform.h>
>>> +#include <linux/platform_device.h>
>>> +#include <linux/sort.h>
>>> +#include <linux/string.h>
>>> +
>>> +#include <soc/tegra/fuse.h>
>>> +#include <soc/tegra/memory.h>
>>> +
>>> +#define CLK_SOURCE_EMC 0x19c
>>> +
>>> +#define CLK_SOURCE_EMC_EMC_2X_CLK_DIVISOR_SHIFT 0
>>> +#define CLK_SOURCE_EMC_EMC_2X_CLK_DIVISOR_MASK 0xff
>>> +#define CLK_SOURCE_EMC_EMC_2X_CLK_DIVISOR(x) (((x) &
>>> CLK_SOURCE_EMC_EMC_2X_CLK_DIVISOR_MASK) << \
>>> +                          CLK_SOURCE_EMC_EMC_2X_CLK_DIVISOR_SHIFT)
>>> +
>>> +#define CLK_SOURCE_EMC_EMC_2X_CLK_SRC_SHIFT 29
>>> +#define CLK_SOURCE_EMC_EMC_2X_CLK_SRC_MASK 0x7
>>> +#define CLK_SOURCE_EMC_EMC_2X_CLK_SRC(x) (((x) &
>>> CLK_SOURCE_EMC_EMC_2X_CLK_SRC_MASK) << \
>>> +                      CLK_SOURCE_EMC_EMC_2X_CLK_SRC_SHIFT)
>>> +
>>> +const char *emc_parent_clk_names[] = {
>>> +    "pll_m", "pll_c", "pll_p", "clk_m", "pll_m_ud",
>>> +    "pll_c2", "pll_c3", "pll_c_ud"
>>> +};
>>> +
>>> +/* List of clock sources for various parents the EMC clock can have.
>>> + * When we change the timing to a timing with a parent that has the same
>>> + * clock source as the current parent, we must first change to a backup
>>> + * timing that has a different clock source.
>>> + */
>>
>>
>> Nit: comment style throughout this file.
>>
>>> +
>>> +#define EMC_SRC_PLL_M 0
>>> +#define EMC_SRC_PLL_C 1
>>> +#define EMC_SRC_PLL_P 2
>>> +#define EMC_SRC_CLK_M 3
>>> +#define EMC_SRC_PLL_C2 4
>>> +#define EMC_SRC_PLL_C3 5
>>> +const char emc_parent_clk_sources[] = {
>>> +    EMC_SRC_PLL_M, EMC_SRC_PLL_C, EMC_SRC_PLL_P, EMC_SRC_CLK_M,
>>> +    EMC_SRC_PLL_M, EMC_SRC_PLL_C2, EMC_SRC_PLL_C3, EMC_SRC_PLL_C
>>> +};
>>> +
>>> +struct emc_timing {
>>> +    unsigned long rate, parent_rate;
>>> +    u8 parent_index;
>>> +    struct clk *parent;
>>> +    u32 ram_code;
>>> +};
>>> +
>>> +struct tegra_emc {
>>> +    struct clk_hw hw;
>>> +    void __iomem *clk_regs;
>>> +    struct clk *prev_parent;
>>> +    bool changing_timing;
>>> +
>>> +    int num_timings;
>>> +    struct emc_timing *timings;
>>> +    spinlock_t *lock;
>>> +};
>>> +
>>> +/* * * * * * * * * * * * * * * * * * * * * * * * * *
>>> + * Common clock framework callback implementations *
>>> + * * * * * * * * * * * * * * * * * * * * * * * * * */
>>> +
>>> +unsigned long emc_recalc_rate(struct clk_hw *hw, unsigned long
>>> parent_rate)
>>
>>
>> Shouldn't this function be static? Also applies to other functions in
>> this file.
>>
>>> +{
>>> +    struct tegra_emc *tegra = container_of(hw, struct tegra_emc, hw);
>>> +    u32 val, div;
>>> +
>>> +    /* CCF wrongly assumes that the parent won't change during set_rate,
>>> +     * so get the parent rate explicitly.
>>> +     */
>>> +    parent_rate = __clk_get_rate(__clk_get_parent(hw->clk));
>>> +
>>> +    val = readl(tegra->clk_regs + CLK_SOURCE_EMC);
>>> +    div = val & CLK_SOURCE_EMC_EMC_2X_CLK_DIVISOR_MASK;
>>> +
>>> +    return parent_rate / (div + 2) * 2;
>>> +}
>>> +
>>> +/* Rounds up unless no higher rate exists, in which case down. This
>>> way is
>>> + * safer since things have EMC rate floors. Also don't touch parent_rate
>>> + * since we don't want the CCF to play with our parent clocks.
>>> + */
>>> +long emc_round_rate(struct clk_hw *hw, unsigned long rate,
>>> +            unsigned long *parent_rate)
>>> +{
>>> +    struct tegra_emc *tegra = container_of(hw, struct tegra_emc, hw);
>>> +    u8 ram_code = tegra_read_ram_code();
>>> +    struct emc_timing *timing;
>>> +    int i;
>>> +
>>> +    /* Returning the original rate will lead to a more sensible error
>>> +     * message when emc_set_rate fails.
>>> +     */
>>> +    if (tegra->num_timings == 0)
>>> +        return rate;
>>> +
>>> +    for (i = 0; i < tegra->num_timings; ++i) {
>>> +        timing = tegra->timings + i;
>>> +        if (timing->ram_code != ram_code)
>>> +            continue;
>>> +
>>> +        if (timing->rate >= rate)
>>> +            return timing->rate;
>>> +    }
>>> +
>>> +    return tegra->timings[tegra->num_timings - 1].rate;
>>> +}
>>> +
>>> +u8 emc_get_parent(struct clk_hw *hw)
>>> +{
>>> +    struct tegra_emc *tegra = container_of(hw, struct tegra_emc, hw);
>>> +    u32 val;
>>> +
>>> +    val = readl(tegra->clk_regs + CLK_SOURCE_EMC);
>>> +
>>> +    return (val >> CLK_SOURCE_EMC_EMC_2X_CLK_SRC_SHIFT)
>>> +        & CLK_SOURCE_EMC_EMC_2X_CLK_SRC_MASK;
>>> +}
>>> +
>>> +static int emc_set_timing(struct tegra_emc *tegra, struct emc_timing
>>> *timing)
>>> +{
>>> +    int err;
>>> +    u8 div;
>>> +    u32 car_value;
>>> +    unsigned long flags = 0;
>>> +
>>> +    pr_debug("going to rate %ld prate %ld p %s\n",
>>> +        timing->rate, timing->parent_rate,
>>> +        __clk_get_name(timing->parent));
>>> +
>>> +    if (emc_get_parent(&tegra->hw) == timing->parent_index &&
>>> +        clk_get_rate(timing->parent) != timing->parent_rate) {
>>> +        BUG();
>>> +        return -EINVAL;
>>> +    }
>>> +
>>> +    tegra->changing_timing = true;
>>> +
>>> +    err = clk_set_rate(timing->parent, timing->parent_rate);
>>> +    if (err) {
>>> +        pr_err("cannot change parent %s rate to %ld: %d\n",
>>> +               __clk_get_name(timing->parent),
>>> +               timing->parent_rate, err);
>>> +
>>> +        return err;
>>> +    }
>>> +
>>> +    err = clk_prepare_enable(timing->parent);
>>> +    if (err) {
>>> +        pr_err("cannot enable parent clock: %d\n", err);
>>> +        return err;
>>> +    }
>>> +
>>> +    div = timing->parent_rate / (timing->rate / 2) - 2;
>>> +
>>> +    tegra_emc_prepare_timing_change(timing->rate);
>>
>>
>> Since there is no locking whatsoever in the EMC driver, I wonder if this
>> function should be called after the spinlock is acquired to ensure it
>> cannot be called twice?
>
>
> This is the only place tegra_emc_{prepare,complete}_timing_change are
> called, and it is only called from emc_set_rate, so I would think CCF's
> locking should take care of that.

Ok, in that case I'm happy. Thanks for confirming.
