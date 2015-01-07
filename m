Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754664AbbAGRWO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 12:22:14 -0500
Received: from mail-lb0-f181.google.com ([209.85.217.181]:63618 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753642AbbAGRWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 12:22:08 -0500
MIME-Version: 1.0
In-Reply-To: <1420601123-25859-3-git-send-email-jamesjj.liao@mediatek.com>
References: <1420601123-25859-1-git-send-email-jamesjj.liao@mediatek.com>
	<1420601123-25859-3-git-send-email-jamesjj.liao@mediatek.com>
Date: Wed, 7 Jan 2015 18:22:06 +0100
Message-ID: <CABuKBeLQkTBYWkBWAYXjYudMAza+1zueRSqGFPd+480p1rYNwg@mail.gmail.com>
Subject: Re: [PATCH v3 2/4] clk: mediatek: Add initial common clock support
 for Mediatek SoCs.
From: Matthias Brugger <matthias.bgg@gmail.com>
To: James Liao <jamesjj.liao@mediatek.com>
Cc: Rob Herring <robh+dt@kernel.org>, Mike Turquette <mturquette@linaro.org>,
        srv_heupstream <srv_heupstream@mediatek.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        huang eddie <eddie.huang@mediatek.com>,
        HenryC Chen <henryc.chen@mediatek.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Vladimir Murzin <vladimir.murzin@arm.com>,
        Ashwin Chaugule <ashwin.chaugule@linaro.org>,
        "Joe.C" <yingjoe.chen@mediatek.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2015-01-07 4:25 GMT+01:00 James Liao <jamesjj.liao@mediatek.com>:
> This patch adds common clock support for Mediatek SoCs, including plls,
> muxes and clock gates.
>
> Change-Id: I19b5f02615610b8825fd7e028bc9b87133181bf0
> Signed-off-by: James Liao <jamesjj.liao@mediatek.com>
> ---
>  drivers/clk/mediatek/clk-gate.c | 150 ++++++++++++++++++++++++++++++++++++++++
>  drivers/clk/mediatek/clk-gate.h |  48 +++++++++++++
>  drivers/clk/mediatek/clk-mtk.c  |  89 ++++++++++++++++++++++++
>  drivers/clk/mediatek/clk-mtk.h  |  47 +++++++++++++
>  drivers/clk/mediatek/clk-pll.c  |  59 ++++++++++++++++
>  drivers/clk/mediatek/clk-pll.h  |  50 ++++++++++++++
>  6 files changed, 443 insertions(+)
>  create mode 100644 drivers/clk/mediatek/clk-gate.c
>  create mode 100644 drivers/clk/mediatek/clk-gate.h
>  create mode 100644 drivers/clk/mediatek/clk-mtk.c
>  create mode 100644 drivers/clk/mediatek/clk-mtk.h
>  create mode 100644 drivers/clk/mediatek/clk-pll.c
>  create mode 100644 drivers/clk/mediatek/clk-pll.h
>
> diff --git a/drivers/clk/mediatek/clk-gate.c b/drivers/clk/mediatek/clk-gate.c
> new file mode 100644
> index 0000000..2a694b1
> --- /dev/null
> +++ b/drivers/clk/mediatek/clk-gate.c
> @@ -0,0 +1,150 @@
> +/*
> + * Copyright (c) 2014 MediaTek Inc.
> + * Author: James Liao <jamesjj.liao@mediatek.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <linux/of.h>
> +#include <linux/of_address.h>
> +
> +#include <linux/io.h>
> +#include <linux/slab.h>
> +#include <linux/delay.h>
> +#include <linux/clkdev.h>
> +
> +#include "clk-mtk.h"
> +#include "clk-gate.h"
> +
> +static void cg_set_mask(struct mtk_clk_gate *cg, u32 mask)

Please add mtk_ prefix to all functions generic for the mediatek SoCs.

> +{
> +       u32 r;
> +
> +       if (cg->flags & CLK_GATE_NO_SETCLR_REG) {

Is the CLK_GATE_NO_SETCLR_REG ever used?
As far as I can see, in this patch set it is not.

> +               r = readl_relaxed(cg->sta_addr) | mask;
> +               writel_relaxed(r, cg->sta_addr);
> +       } else
> +               writel_relaxed(mask, cg->set_addr);
> +}
> +
> +static void cg_clr_mask(struct mtk_clk_gate *cg, u32 mask)
> +{
> +       u32 r;
> +
> +       if (cg->flags & CLK_GATE_NO_SETCLR_REG) {
> +               r = readl_relaxed(cg->sta_addr) & ~mask;
> +               writel_relaxed(r, cg->sta_addr);
> +       } else
> +               writel_relaxed(mask, cg->clr_addr);
> +}
> +
> +static int cg_enable(struct clk_hw *hw)
> +{
> +       unsigned long flags = 0;
> +       struct mtk_clk_gate *cg = to_clk_gate(hw);
> +       u32 mask = BIT(cg->bit);
> +
> +       pr_debug("%s(): %s, bit: %u\n",
> +               __func__, __clk_get_name(hw->clk), cg->bit);

We really need this?

> +
> +       mtk_clk_lock(flags);
> +
> +       if (cg->flags & CLK_GATE_INVERSE)
> +               cg_set_mask(cg, mask);
> +       else
> +               cg_clr_mask(cg, mask);
> +
> +       mtk_clk_unlock(flags);
> +
> +       return 0;
> +}

Actually we should use CLK_GATE_SET_TO_DISABLE instead of inventing a
new bit, right?

> +
> +static void cg_disable(struct clk_hw *hw)
> +{
> +       unsigned long flags = 0;
> +       struct mtk_clk_gate *cg = to_clk_gate(hw);
> +       u32 mask = BIT(cg->bit);
> +
> +       pr_debug("%s(): %s, bit: %u\n",
> +               __func__, __clk_get_name(hw->clk), cg->bit);

We really need this?

> +
> +       mtk_clk_lock(flags);
> +
> +       if (cg->flags & CLK_GATE_INVERSE)
> +               cg_clr_mask(cg, mask);
> +       else
> +               cg_set_mask(cg, mask);
> +
> +       mtk_clk_unlock(flags);
> +}
> +
> +static int cg_is_enabled(struct clk_hw *hw)
> +{
> +       struct mtk_clk_gate *cg = to_clk_gate(hw);
> +       u32 mask;
> +       u32 val;
> +       int r;
> +
> +       mask = BIT(cg->bit);
> +       val = mask & readl(cg->sta_addr);
> +
> +       r = (cg->flags & CLK_GATE_INVERSE) ? (val != 0) : (val == 0);
> +
> +       pr_debug("%s(): %d, %s, bit[%d]\n",
> +               __func__, r, __clk_get_name(hw->clk), (int)cg->bit);

Same here. Please review all debug messages.

> +
> +       return r;
> +}
> +
> +static const struct clk_ops mtk_clk_gate_ops = {
> +       .is_enabled     = cg_is_enabled,
> +       .enable         = cg_enable,
> +       .disable        = cg_disable,
> +};
> +
> +struct clk *mtk_clk_register_gate(
> +               const char *name,
> +               const char *parent_name,
> +               void __iomem *set_addr,
> +               void __iomem *clr_addr,
> +               void __iomem *sta_addr,
> +               u8 bit,
> +               u32 flags)
> +{
> +       struct mtk_clk_gate *cg;
> +       struct clk *clk;
> +       struct clk_init_data init;
> +
> +       pr_debug("%s(): name: %s, bit: %d\n", __func__, name, (int)bit);
> +
> +       cg = kzalloc(sizeof(*cg), GFP_KERNEL);
> +       if (!cg)
> +               return ERR_PTR(-ENOMEM);
> +
> +       init.name = name;
> +       init.flags = CLK_IGNORE_UNUSED;
> +       init.parent_names = parent_name ? &parent_name : NULL;
> +       init.num_parents = parent_name ? 1 : 0;
> +       init.ops = &mtk_clk_gate_ops;
> +
> +       cg->set_addr = set_addr;
> +       cg->clr_addr = clr_addr;
> +       cg->sta_addr = sta_addr;
> +       cg->bit = bit;
> +       cg->flags = flags;
> +
> +       cg->hw.init = &init;
> +
> +       clk = clk_register(NULL, &cg->hw);
> +       if (IS_ERR(clk))
> +               kfree(cg);
> +
> +       return clk;
> +}
> diff --git a/drivers/clk/mediatek/clk-gate.h b/drivers/clk/mediatek/clk-gate.h
> new file mode 100644
> index 0000000..0d71aad
> --- /dev/null
> +++ b/drivers/clk/mediatek/clk-gate.h
> @@ -0,0 +1,48 @@
> +/*
> + * Copyright (c) 2014 MediaTek Inc.
> + * Author: James Liao <jamesjj.liao@mediatek.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#ifndef __DRV_CLK_GATE_H
> +#define __DRV_CLK_GATE_H
> +
> +/*
> + * This is a private header file. DO NOT include it except clk-*.c.
> + */
> +
> +#include <linux/clk.h>
> +#include <linux/clk-provider.h>
> +
> +struct mtk_clk_gate {
> +       struct clk_hw   hw;
> +       void __iomem    *set_addr;
> +       void __iomem    *clr_addr;
> +       void __iomem    *sta_addr;
> +       u8              bit;
> +       u32             flags;
> +};
> +
> +#define to_clk_gate(_hw) container_of(_hw, struct mtk_clk_gate, hw)
> +
> +#define CLK_GATE_INVERSE       BIT(0)
> +#define CLK_GATE_NO_SETCLR_REG BIT(1)
> +
> +struct clk *mtk_clk_register_gate(
> +               const char *name,
> +               const char *parent_name,
> +               void __iomem *set_addr,
> +               void __iomem *clr_addr,
> +               void __iomem *sta_addr,
> +               u8 bit,
> +               u32 flags);
> +
> +#endif /* __DRV_CLK_GATE_H */
> diff --git a/drivers/clk/mediatek/clk-mtk.c b/drivers/clk/mediatek/clk-mtk.c
> new file mode 100644
> index 0000000..b137ca9
> --- /dev/null
> +++ b/drivers/clk/mediatek/clk-mtk.c
> @@ -0,0 +1,89 @@
> +/*
> + * Copyright (c) 2014 MediaTek Inc.
> + * Author: James Liao <jamesjj.liao@mediatek.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <linux/of.h>
> +#include <linux/of_address.h>
> +
> +#include <linux/io.h>
> +#include <linux/slab.h>
> +#include <linux/delay.h>
> +#include <linux/clkdev.h>
> +
> +#include "clk-mtk.h"
> +
> +static DEFINE_SPINLOCK(clk_ops_lock);
> +
> +spinlock_t *get_mtk_clk_lock(void)
> +{
> +       return &clk_ops_lock;
> +}
> +
> +struct clk *mtk_clk_register_mux(
> +               const char *name,
> +               const char **parent_names,
> +               u8 num_parents,
> +               void __iomem *base_addr,
> +               u8 shift,
> +               u8 width,
> +               u8 gate_bit)
> +{
> +       struct clk *clk;
> +       struct clk_mux *mux;
> +       struct clk_gate *gate = NULL;
> +       struct clk_hw *gate_hw = NULL;
> +       const struct clk_ops *gate_ops = NULL;
> +       u32 mask = BIT(width) - 1;
> +
> +       pr_debug("%s(): name: %s, num_parents: %d, gate_bit: %d\n",
> +               __func__, name, (int)num_parents, (int)gate_bit);
> +
> +       mux = kzalloc(sizeof(struct clk_mux), GFP_KERNEL);
> +       if (!mux)
> +               return ERR_PTR(-ENOMEM);
> +
> +       mux->reg = base_addr;
> +       mux->mask = mask;
> +       mux->shift = shift;
> +       mux->flags = 0;
> +       mux->lock = &clk_ops_lock;
> +
> +       if (gate_bit <= MAX_MUX_GATE_BIT) {
> +               gate = kzalloc(sizeof(struct clk_gate), GFP_KERNEL);
> +               if (!gate) {
> +                       kfree(mux);
> +                       return ERR_PTR(-ENOMEM);
> +               }
> +
> +               gate->reg = base_addr;
> +               gate->bit_idx = gate_bit;
> +               gate->flags = CLK_GATE_SET_TO_DISABLE;
> +               gate->lock = &clk_ops_lock;
> +
> +               gate_hw = &gate->hw;
> +               gate_ops = &clk_gate_ops;
> +       }
> +
> +       clk = clk_register_composite(NULL, name, parent_names, num_parents,
> +               &mux->hw, &clk_mux_ops,
> +               NULL, NULL,
> +               gate_hw, gate_ops,
> +               CLK_IGNORE_UNUSED);
> +
> +       if (IS_ERR(clk)) {
> +               kfree(gate);
> +               kfree(mux);
> +       }
> +
> +       return clk;
> +}
> diff --git a/drivers/clk/mediatek/clk-mtk.h b/drivers/clk/mediatek/clk-mtk.h
> new file mode 100644
> index 0000000..b69245d
> --- /dev/null
> +++ b/drivers/clk/mediatek/clk-mtk.h
> @@ -0,0 +1,47 @@
> +/*
> + * Copyright (c) 2014 MediaTek Inc.
> + * Author: James Liao <jamesjj.liao@mediatek.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#ifndef __DRV_CLK_MTK_H
> +#define __DRV_CLK_MTK_H
> +
> +/*
> + * This is a private header file. DO NOT include it except clk-*.c.
> + */
> +
> +#include <linux/bitops.h>
> +#include <linux/clk.h>
> +#include <linux/clk-provider.h>
> +
> +#define CLK_DEBUG              0
> +#define DUMMY_REG_TEST         0

This defines are not used, delete them.

> +
> +extern spinlock_t *get_mtk_clk_lock(void);
> +
> +#define mtk_clk_lock(flags)    spin_lock_irqsave(get_mtk_clk_lock(), flags)
> +#define mtk_clk_unlock(flags)  \
> +       spin_unlock_irqrestore(get_mtk_clk_lock(), flags)

Please use the spinlock directly without this akward defines.

> +
> +#define MAX_MUX_GATE_BIT       31
> +#define INVALID_MUX_GATE_BIT   (MAX_MUX_GATE_BIT + 1)
> +
> +struct clk *mtk_clk_register_mux(
> +               const char *name,
> +               const char **parent_names,
> +               u8 num_parents,
> +               void __iomem *base_addr,
> +               u8 shift,
> +               u8 width,
> +               u8 gate_bit);
> +
> +#endif /* __DRV_CLK_MTK_H */
> diff --git a/drivers/clk/mediatek/clk-pll.c b/drivers/clk/mediatek/clk-pll.c
> new file mode 100644
> index 0000000..c48630b
> --- /dev/null
> +++ b/drivers/clk/mediatek/clk-pll.c
> @@ -0,0 +1,59 @@
> +/*
> + * Copyright (c) 2014 MediaTek Inc.
> + * Author: James Liao <jamesjj.liao@mediatek.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <linux/io.h>
> +#include <linux/slab.h>
> +#include <linux/clkdev.h>
> +
> +#include "clk-mtk.h"
> +#include "clk-pll.h"
> +
> +struct clk *mtk_clk_register_pll(
> +               const char *name,
> +               const char *parent_name,
> +               u32 *base_addr,
> +               u32 *pwr_addr,
> +               u32 en_mask,
> +               u32 flags,
> +               const struct clk_ops *ops)
> +{
> +       struct mtk_clk_pll *pll;
> +       struct clk_init_data init;
> +       struct clk *clk;
> +
> +       pr_debug("%s(): name: %s\n", __func__, name);
> +
> +       pll = kzalloc(sizeof(*pll), GFP_KERNEL);
> +       if (!pll)
> +               return ERR_PTR(-ENOMEM);
> +
> +       pll->base_addr = base_addr;
> +       pll->pwr_addr = pwr_addr;
> +       pll->en_mask = en_mask;
> +       pll->flags = flags;
> +       pll->hw.init = &init;
> +
> +       init.name = name;
> +       init.ops = ops;
> +       init.flags = CLK_IGNORE_UNUSED;
> +       init.parent_names = &parent_name;
> +       init.num_parents = 1;
> +
> +       clk = clk_register(NULL, &pll->hw);
> +
> +       if (IS_ERR(clk))
> +               kfree(pll);
> +
> +       return clk;
> +}
> diff --git a/drivers/clk/mediatek/clk-pll.h b/drivers/clk/mediatek/clk-pll.h
> new file mode 100644
> index 0000000..cb7f335
> --- /dev/null
> +++ b/drivers/clk/mediatek/clk-pll.h
> @@ -0,0 +1,50 @@
> +/*
> + * Copyright (c) 2014 MediaTek Inc.
> + * Author: James Liao <jamesjj.liao@mediatek.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#ifndef __DRV_CLK_PLL_H
> +#define __DRV_CLK_PLL_H
> +
> +/*
> + * This is a private header file. DO NOT include it except clk-*.c.
> + */
> +
> +#include <linux/bitops.h>
> +#include <linux/clk.h>
> +#include <linux/clk-provider.h>
> +
> +struct mtk_clk_pll {
> +       struct clk_hw   hw;
> +       void __iomem    *base_addr;
> +       void __iomem    *pwr_addr;
> +       u32             en_mask;
> +       u32             flags;
> +};
> +
> +#define to_mtk_clk_pll(_hw) container_of(_hw, struct mtk_clk_pll, hw)
> +
> +#define HAVE_RST_BAR   BIT(0)
> +#define HAVE_PLL_HP    BIT(1)
> +#define HAVE_FIX_FRQ   BIT(2)
> +#define PLL_AO         BIT(3)
> +
> +struct clk *mtk_clk_register_pll(
> +               const char *name,
> +               const char *parent_name,
> +               u32 *base_addr,
> +               u32 *pwr_addr,
> +               u32 en_mask,
> +               u32 flags,
> +               const struct clk_ops *ops);
> +
> +#endif /* __DRV_CLK_PLL_H */
> --
> 1.8.1.1.dirty
>



-- 
motzblog.wordpress.com
