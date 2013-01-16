Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756791Ab3APPMw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 10:12:52 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:2650 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756501Ab3APPMu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 10:12:50 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Wed, 16 Jan 2013 07:12:49 -0800
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        Prashant Gaikwad <pgaikwad@nvidia.com>
CC: "mturquette@linaro.org" <mturquette@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 16 Jan 2013 16:12:42 +0100
Subject: Re: [PATCH v4 2/9] clk: tegra: Add tegra specific clocks
Thread-Topic: [PATCH v4 2/9] clk: tegra: Add tegra specific clocks
Thread-Index: Ac3z++/jznBt8+qcT4i6PcUeZWmypw==
Message-ID: <20130116.171242.2189136612266237422.hdoyu@nvidia.com>
References: <1357890387-23245-1-git-send-email-pgaikwad@nvidia.com><1357890387-23245-3-git-send-email-pgaikwad@nvidia.com>
In-Reply-To: <1357890387-23245-3-git-send-email-pgaikwad@nvidia.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-nvconfidentiality: public
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prashant Gaikwad <pgaikwad@nvidia.com> wrote @ Fri, 11 Jan 2013 08:46:20 +0100:

....
> diff --git a/drivers/clk/tegra/clk-audio-sync.c b/drivers/clk/tegra/clk-audio-sync.c
> new file mode 100644
> index 0000000..bb2fe43
> --- /dev/null
> +++ b/drivers/clk/tegra/clk-audio-sync.c
> @@ -0,0 +1,89 @@
> +/*
> + * Copyright (c) 2012, NVIDIA CORPORATION.  All rights reserved.
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
> +#include <linux/clk-provider.h>
> +#include <linux/slab.h>
> +#include <linux/err.h>
> +
> +#include "clk.h"
> +
> +#define to_clk_sync_source(_hw)                                        \
> +       container_of(_hw, struct tegra_clk_sync_source, hw)

Can we define "struct tegra_clk_sync_source" here if there's no need
to expose this structure out?

> +
> +static unsigned long clk_sync_source_recalc_rate(struct clk_hw *hw,
> +                                                unsigned long parent_rate)
> +{
> +       struct tegra_clk_sync_source *sync = to_clk_sync_source(hw);
> +
> +       return sync->rate;
> +}
> +
> +static long clk_sync_source_round_rate(struct clk_hw *hw, unsigned long rate,
> +
                                    unsigned long *prate)
.....

> diff --git a/drivers/clk/tegra/clk-divider.c b/drivers/clk/tegra/clk-divider.c
> new file mode 100644
> index 0000000..fcd0123
> --- /dev/null
> +++ b/drivers/clk/tegra/clk-divider.c
> @@ -0,0 +1,188 @@
> +/*
> + * Copyright (c) 2012, NVIDIA CORPORATION.  All rights reserved.
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
> +#include <linux/kernel.h>
> +#include <linux/io.h>
> +#include <linux/err.h>
> +#include <linux/slab.h>
> +#include <linux/clk-provider.h>
> +#include <linux/clk.h>
> +
> +#include "clk.h"
> +
> +#define to_clk_frac_div(_hw) container_of(_hw, struct tegra_clk_frac_div, hw)
> +
> +#define pll_out_override(p) (BIT((p->shift - 6)))
> +#define div_mask(d) ((1 << (d->width)) - 1)
> +#define get_mul(d) (1 << d->frac_width)
> +#define get_max_div(d) div_mask(d)
> +
> +#define PERIPH_CLK_UART_DIV_ENB BIT(24)

Can we define "struct tegra_clk_frac_div" here too?

> +
> +static int get_div(struct tegra_clk_frac_div *divider, unsigned long rate,
> +                  unsigned long parent_rate)
> +{
> +       s64 divider_ux1 = parent_rate;
> +       u8 flags = divider->flags;
> +       int mul;
> +
> +       if (!rate)
> +               return 0;
> +
> +       mul = get_mul(divider);
> +
.....
> +static int clk_frac_div_set_rate(struct clk_hw *hw, unsigned long rate,
> +                               unsigned long parent_rate)
> +{
> +       struct tegra_clk_frac_div *divider = to_clk_frac_div(hw);
> +       int div;
> +       unsigned long flags = 0;

nit, is "flags" not needed to initialize here?

.......

> diff --git a/drivers/clk/tegra/clk-periph-gate.c b/drivers/clk/tegra/clk-periph-gate.c
> new file mode 100644
> index 0000000..5f0919d
> --- /dev/null
> +++ b/drivers/clk/tegra/clk-periph-gate.c
> @@ -0,0 +1,182 @@
> +/*
> + * Copyright (c) 2012, NVIDIA CORPORATION.  All rights reserved.
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
> +#include <linux/clk.h>
> +#include <linux/clk-provider.h>
> +#include <linux/slab.h>
> +#include <linux/io.h>
> +#include <linux/delay.h>
> +#include <linux/err.h>
> +#include <linux/tegra-soc.h>
> +
> +#include "clk.h"
> +
> +static DEFINE_SPINLOCK(periph_ref_lock);
> +
> +#define to_clk_periph_gate(_hw)                                        \
> +       container_of(_hw, struct tegra_clk_periph_gate, hw)

For consistency, put "to_clk_periph_gate(_hw)" in "clk.h", then this
can be used in clk-periph.c as well.

> +/* Macros to assist peripheral gate clock */
> +#define read_enb(gate) \
> +       readl_relaxed(gate->clk_base + (gate->regs->enb_reg))
> +#define write_enb_set(val, gate) \
> +       writel_relaxed(val, gate->clk_base + (gate->regs->enb_set_reg))
> +#define write_enb_clr(val, gate) \
> +       writel_relaxed(val, gate->clk_base + (gate->regs->enb_clr_reg))
> +
> +#define read_rst(gate) \
> +       readl_relaxed(gate->clk_base + (gate->regs->rst_reg))
> +#define write_rst_set(val, gate) \
> +       writel_relaxed(val, gate->clk_base + (gate->regs->rst_set_reg))
> +#define write_rst_clr(val, gate) \
> +       writel_relaxed(val, gate->clk_base + (gate->regs->rst_clr_reg))
> +
> +#define periph_clk_to_bit(periph) (1 << (gate->clk_num % 32))
> +
> +/* Peripheral gate clock ops */
> +static int clk_periph_is_enabled(struct clk_hw *hw)
> +{
> +       struct tegra_clk_periph_gate *gate = to_clk_periph_gate(hw);
> +       int state = 1;
> +
> +       if (!(read_enb(gate) & periph_clk_to_bit(gate)))
> +               state = 0;
> +
> +       if (!(gate->flags & TEGRA_PERIPH_NO_RESET))
> +               if (read_rst(gate) & periph_clk_to_bit(gate))
> +                       state = 0;
> +
> +       return state;
> +}
> +
> +static int clk_periph_enable(struct clk_hw *hw)
> +{
> +       struct tegra_clk_periph_gate *gate = to_clk_periph_gate(hw);
> +       unsigned long flags = 0;

nit, is "flags" not needed to initialize here?

> +
> +       spin_lock_irqsave(&periph_ref_lock, flags);
> +
> +       gate->enable_refcnt[gate->clk_num]++;
> +       if (gate->enable_refcnt[gate->clk_num] > 1) {
> +               spin_unlock_irqrestore(&periph_ref_lock, flags);
> +               return 0;
> +       }
> +
> +       write_enb_set(periph_clk_to_bit(gate), gate);
> +       udelay(2);
> +
> +       if (!(gate->flags & TEGRA_PERIPH_NO_RESET) &&
> +           !(gate->flags & TEGRA_PERIPH_MANUAL_RESET)) {
> +               if (read_rst(gate) & periph_clk_to_bit(gate)) {
> +                       udelay(5); /* reset propogation delay */
> +                       write_rst_clr(periph_clk_to_bit(gate), gate);
> +               }
> +       }
> +
> +       spin_unlock_irqrestore(&periph_ref_lock, flags);
> +
> +       return 0;
> +}
> +
> +static void clk_periph_disable(struct clk_hw *hw)
> +{
> +       struct tegra_clk_periph_gate *gate = to_clk_periph_gate(hw);
> +       unsigned long flags = 0;

nit, is "flags" not needed to initialize here?

> +
> +       spin_lock_irqsave(&periph_ref_lock, flags);
> +
> +       gate->enable_refcnt[gate->clk_num]--;
> +       if (gate->enable_refcnt[gate->clk_num] > 0) {
> +               spin_unlock_irqrestore(&periph_ref_lock, flags);
> +               return;
> +       }
> +
> +       /*
> +        * If peripheral is in the APB bus then read the APB bus to
> +        * flush the write operation in apb bus. This will avoid the
> +        * peripheral access after disabling clock
> +        */
> +       if (gate->flags & TEGRA_PERIPH_ON_APB)
> +               tegra_read_chipid();
> +
> +       write_enb_clr(periph_clk_to_bit(gate), gate);
> +
> +       spin_unlock_irqrestore(&periph_ref_lock, flags);
> +}
> +
> +void tegra_periph_reset(struct tegra_clk_periph_gate *gate, bool assert)
> +{
> +       if (gate->flags & TEGRA_PERIPH_NO_RESET)
> +               return;
> +
> +       if (assert) {
> +               /*
> +                * If peripheral is in the APB bus then read the APB bus to
> +                * flush the write operation in apb bus. This will avoid the
> +                * peripheral access after disabling clock
> +                */
> +               if (gate->flags & TEGRA_PERIPH_ON_APB)
> +                       tegra_read_chipid();
> +
> +               write_rst_set(periph_clk_to_bit(gate), gate);
> +       } else {
> +               write_rst_clr(periph_clk_to_bit(gate), gate);
> +       }
> +}
> +
> +const struct clk_ops tegra_clk_periph_gate_ops = {
> +       .is_enabled = clk_periph_is_enabled,
> +       .enable = clk_periph_enable,
> +       .disable = clk_periph_disable,
> +};
> +
> +struct clk *tegra_clk_periph_gate(const char *name, const char *parent_name,
> +                                 u8 gate_flags, void __iomem *clk_base,
> +                                 unsigned long flags, int clk_num,
> +                                 struct tegra_clk_periph_regs *pregs,
> +                                 int *enable_refcnt)
> +{
> +       struct tegra_clk_periph_gate *gate;
> +       struct clk *clk;
> +       struct clk_init_data init;
> +
> +       gate = kzalloc(sizeof(struct tegra_clk_periph_gate), GFP_KERNEL);

       gate = kzalloc(sizeof(*gate), GFP_KERNEL) ?

> +       if (!gate) {
> +               pr_err("%s: could not allocate periph gate clk\n", __func__);
> +               return ERR_PTR(-ENOMEM);
> +       }
> +
> +       init.name = name;
> +       init.flags = flags;
> +       init.parent_names = parent_name ? &parent_name : NULL;
> +       init.num_parents = parent_name ? 1 : 0;
> +       init.ops = &tegra_clk_periph_gate_ops;
> +
> +       gate->magic = TEGRA_CLK_PERIPH_GATE_MAGIC;
> +       gate->clk_base = clk_base;
> +       gate->clk_num = clk_num;
> +       gate->flags = gate_flags;
> +       gate->enable_refcnt = enable_refcnt;
> +       gate->regs = pregs;
> +
> +       gate->hw.init = &init;
> +
> +       clk = clk_register(NULL, &gate->hw);
> +       if (IS_ERR(clk))
> +               kfree(gate);
> +
> +       return clk;
> +}
> diff --git a/drivers/clk/tegra/clk-periph.c b/drivers/clk/tegra/clk-periph.c
> new file mode 100644
> index 0000000..ed0ded2
> --- /dev/null
> +++ b/drivers/clk/tegra/clk-periph.c
> @@ -0,0 +1,190 @@
> +/*
> + * Copyright (c) 2012, NVIDIA CORPORATION.  All rights reserved.
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
> +#include <linux/clk.h>
> +#include <linux/clk-provider.h>
> +#include <linux/slab.h>
> +#include <linux/err.h>
> +
> +#include "clk.h"
> +
> +#define to_clk_periph(_hw) container_of(_hw, struct tegra_clk_periph, hw)
> +

Can't "struct tegra_clk_periph" be defined in this file?

> +static u8 clk_periph_get_parent(struct clk_hw *hw)
> +{
> +       struct tegra_clk_periph *periph = to_clk_periph(hw);
> +       const struct clk_ops *mux_ops = periph->mux_ops;
> +       struct clk_hw *mux_hw = &periph->mux.hw;
> +
> +       mux_hw->clk = hw->clk;
> +
> +       return mux_ops->get_parent(mux_hw);
> +}
> +
> +static int clk_periph_set_parent(struct clk_hw *hw, u8 index)
> +{
> +       struct tegra_clk_periph *periph = to_clk_periph(hw);
> +       const struct clk_ops *mux_ops = periph->mux_ops;
> +       struct clk_hw *mux_hw = &periph->mux.hw;
> +
> +       mux_hw->clk = hw->clk;
> +
> +       return mux_ops->set_parent(mux_hw, index);
> +}
> +
....
> +struct clk *tegra_clk_periph(const char *name, const char **parent_names,
> +                            int num_parents, struct tegra_clk_periph *periph,
> +                            void __iomem *clk_base, u32 offset)
> +{
> +       struct clk *clk;
> +       struct clk_init_data init;
> +
> +       init.name = name;
> +       init.ops = &tegra_clk_periph_ops;
> +       init.flags = 0;

struct members in stack are expected to initialize 0.

> +       init.parent_names = parent_names;
> +       init.num_parents = num_parents;
.....
> diff --git a/drivers/clk/tegra/clk-pll-out.c b/drivers/clk/tegra/clk-pll-out.c
> new file mode 100644
> index 0000000..60a117b
> --- /dev/null
> +++ b/drivers/clk/tegra/clk-pll-out.c
> @@ -0,0 +1,124 @@
> +/*
> + * Copyright (c) 2012, NVIDIA CORPORATION.  All rights reserved.
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
> +#include <linux/kernel.h>
> +#include <linux/io.h>
> +#include <linux/err.h>
> +#include <linux/delay.h>
> +#include <linux/slab.h>
> +#include <linux/clk-provider.h>
> +#include <linux/clk.h>
> +
> +#include "clk.h"
> +
> +#define to_clk_pll_out(_hw) container_of(_hw, struct tegra_clk_pll_out, hw)

Can't "struct tegra_clk_pll_out" be defined in this file?

> +
> +#define pll_out_enb(p) (BIT(p->enb_bit_idx))
> +#define pll_out_rst(p) (BIT(p->rst_bit_idx))

I don't see much benefit from the above macros.

> +
> +static int clk_pll_out_is_enabled(struct clk_hw *hw)
> +{
> +       struct tegra_clk_pll_out *pll_out = to_clk_pll_out(hw);
> +       u32 val = readl_relaxed(pll_out->reg);
> +       int state;
> +
> +       state = (val & pll_out_enb(pll_out)) ? 1 : 0;
> +       if (!(val & (pll_out_rst(pll_out))))
> +               state = 0;
> +       return state;
> +}
> +
> +static int clk_pll_out_enable(struct clk_hw *hw)
> +{
> +       struct tegra_clk_pll_out *pll_out = to_clk_pll_out(hw);
> +       unsigned long flags = 0;

nit, is "flags" not needed to initialize here? other places as well.

....
> +struct clk *tegra_clk_pll_out(const char *name, const char *parent_name,
> +                             void __iomem *reg, u8 enb_bit_idx, u8 rst_bit_idx,
> +                             unsigned long flags, u8 pll_out_flags,
> +                             spinlock_t *lock)
> +{
> +       struct tegra_clk_pll_out *pll_out;
> +       struct clk *clk;
> +       struct clk_init_data init;
> +
> +       pll_out = kzalloc(sizeof(struct tegra_clk_pll_out), GFP_KERNEL);

       pll_out = kzalloc(sizeof(*pll_out), GFP_KERNEL) ?

> +       if (!pll_out)
> +               return ERR_PTR(-ENOMEM);
> +
> +       init.name = name;
> +       init.ops = &tegra_clk_pll_out_ops;
> +       init.parent_names = (parent_name ? &parent_name : NULL);
> +       init.num_parents = (parent_name ? 1 : 0);
> +       init.flags = flags;
> +
> +       pll_out->reg = reg;
> +       pll_out->enb_bit_idx = enb_bit_idx;
> +       pll_out->rst_bit_idx = rst_bit_idx;
> +       pll_out->flags = pll_out_flags;
> +       pll_out->lock = lock;
> +
> +       pll_out->hw.init = &init;
> +
> +       clk = clk_register(NULL, &pll_out->hw);
> +       if (IS_ERR(clk))
> +               kfree(pll_out);
> +
> +       return clk;
> +}
> diff --git a/drivers/clk/tegra/clk-pll.c b/drivers/clk/tegra/clk-pll.c
> new file mode 100644
> index 0000000..f8dc7c0
> --- /dev/null
> +++ b/drivers/clk/tegra/clk-pll.c

.....
> +
> +#define PMC_SATA_PWRGT 0x1ac
> +#define PMC_SATA_PWRGT_PLLE_IDDQ_VALUE BIT(5)
> +#define PMC_SATA_PWRGT_PLLE_IDDQ_SWCTL BIT(4)
> +
> +#define to_clk_pll(_hw)        container_of(_hw, struct tegra_clk_pll, hw)

Should define struct tegra_clk_pll here?

> +
> +#define pll_readl(offset, p) readl_relaxed(p->clk_base + offset)
> +#define pll_readl_base(p) pll_readl(p->params->base_reg, p)
> +#define pll_readl_misc(p) pll_readl(p->params->misc_reg, p)
> +
> +#define pll_writel(val, offset, p) writel_relaxed(val, p->clk_base + offset)
> +#define pll_writel_base(val, p) pll_writel(val, p->params->base_reg, p)
> +#define pll_writel_misc(val, p) pll_writel(val, p->params->misc_reg, p)
> +
> +#define mask(w) ((1 << (w)) - 1)
> +#define divm_mask(p) mask(p->divm_width)
> +#define divn_mask(p) mask(p->divn_width)
> +#define divp_mask(p) (p->flags & TEGRA_PLLU ? PLLU_POST_DIVP_MASK :    \
> +                     mask(p->divp_width))
> +
> +#define divm_max(p) (divm_mask(p))
> +#define divn_max(p) (divn_mask(p))
> +#define divp_max(p) (1 << (divp_mask(p)))
> +
> +static void clk_pll_enable_lock(struct tegra_clk_pll *pll)
> +{
> +       u32 val;
> +
> +       if (!(pll->flags & TEGRA_PLL_USE_LOCK))
> +               return;
> +
> +       val = pll_readl_misc(pll);
> +       val |= BIT(pll->params->lock_enable_bit_idx);
> +       pll_writel_misc(val, pll);
> +}
> +
> +static int clk_pll_wait_for_lock(struct tegra_clk_pll *pll,
> +                                void __iomem *lock_addr, u32 lock_bit_idx)
> +{
> +       int i;
> +       u32 val;
> +
> +       if (!(pll->flags & TEGRA_PLL_USE_LOCK)) {
> +               udelay(pll->params->lock_delay);
> +               return 0;
> +       }
> +
> +       for (i = 0; i < pll->params->lock_delay; i++) {
> +               val = readl_relaxed(lock_addr);
> +               if (val & BIT(lock_bit_idx)) {
> +                       udelay(PLL_POST_LOCK_DELAY);
> +                       return 0;
> +               }
> +               udelay(2); /* timeout = 2 * lock time */
> +       }
> +
> +       pr_err("%s: Timed out waiting for pll %s lock\n", __func__,
> +              __clk_get_name(pll->hw.clk));
> +
> +       return -1;
> +}
> +
> +static int clk_pll_is_enabled(struct clk_hw *hw)
> +{
> +       struct tegra_clk_pll *pll = to_clk_pll(hw);
> +       u32 val;
> +
> +       if (pll->flags & TEGRA_PLLM) {
> +               val = readl_relaxed(pll->pmc + PMC_PLLP_WB0_OVERRIDE);
> +               if (val & PMC_PLLP_WB0_OVERRIDE_PLLM_OVERRIDE)
> +                       return val & PMC_PLLP_WB0_OVERRIDE_PLLM_ENABLE ? 1 : 0;
> +       }
> +
> +       val = pll_readl_base(pll);
> +
> +       return val & PLL_BASE_ENABLE ? 1 : 0;
> +}
> +
> +static int _clk_pll_enable(struct clk_hw *hw)
> +{
> +       struct tegra_clk_pll *pll = to_clk_pll(hw);
> +       u32 val;
> +
> +       clk_pll_enable_lock(pll);
> +
> +       val = pll_readl_base(pll);
> +       val &= ~PLL_BASE_BYPASS;
> +       val |= PLL_BASE_ENABLE;
> +       pll_writel_base(val, pll);
> +
> +       if (pll->flags & TEGRA_PLLM) {
> +               val = readl_relaxed(pll->pmc + PMC_PLLP_WB0_OVERRIDE);
> +               val |= PMC_PLLP_WB0_OVERRIDE_PLLM_ENABLE;
> +               writel_relaxed(val, pll->pmc + PMC_PLLP_WB0_OVERRIDE);
> +       }
> +
> +       clk_pll_wait_for_lock(pll, pll->clk_base + pll->params->base_reg,
> +                             pll->params->lock_bit_idx);
> +
> +       return 0;
> +}
> +
> +static void _clk_pll_disable(struct clk_hw *hw)
> +{
> +       struct tegra_clk_pll *pll = to_clk_pll(hw);
> +       u32 val;
> +
> +       val = pll_readl_base(pll);
> +       val &= ~(PLL_BASE_BYPASS | PLL_BASE_ENABLE);
> +       pll_writel_base(val, pll);
> +
> +       if (pll->flags & TEGRA_PLLM) {
> +               val = readl_relaxed(pll->pmc + PMC_PLLP_WB0_OVERRIDE);
> +               val &= ~PMC_PLLP_WB0_OVERRIDE_PLLM_ENABLE;
> +               writel_relaxed(val, pll->pmc + PMC_PLLP_WB0_OVERRIDE);
> +       }
> +}
> +
> +static int clk_pll_enable(struct clk_hw *hw)
> +{
> +       struct tegra_clk_pll *pll = to_clk_pll(hw);
> +       unsigned long flags = 0;

nit, is "flags" not needed to initialize here?

> +       int ret;
> +
> +       if (pll->lock)
> +               spin_lock_irqsave(pll->lock, flags);
> +
> +       ret = _clk_pll_enable(hw);
> +
> +       if (pll->lock)
> +               spin_unlock_irqrestore(pll->lock, flags);
> +
> +       return ret;
> +}
> +
> +static void clk_pll_disable(struct clk_hw *hw)
> +{
> +       struct tegra_clk_pll *pll = to_clk_pll(hw);
> +       unsigned long flags = 0;

nit, is "flags" not needed to initialize here?

> +
> +       if (pll->lock)
> +               spin_lock_irqsave(pll->lock, flags);
> +
> +       _clk_pll_disable(hw);
> +
> +       if (pll->lock)
> +               spin_unlock_irqrestore(pll->lock, flags);
> +}
> +
> +static int _get_table_rate(struct clk_hw *hw,
> +                          struct tegra_clk_pll_freq_table *cfg,
> +                          unsigned long rate, unsigned long parent_rate)
> +{
> +       struct tegra_clk_pll *pll = to_clk_pll(hw);
> +       struct tegra_clk_pll_freq_table *sel;
> +
> +       for (sel = pll->freq_table; sel->input_rate != 0; sel++)
> +               if (sel->input_rate == parent_rate &&
> +                   sel->output_rate == rate)
> +                       break;
> +
> +       if (sel->input_rate == 0)
> +               return -EINVAL;
> +
> +       BUG_ON(sel->p < 1);
> +
> +       cfg->input_rate = sel->input_rate;
> +       cfg->output_rate = sel->output_rate;
> +       cfg->m = sel->m;
> +       cfg->n = sel->n;
> +       cfg->p = sel->p;
> +       cfg->cpcon = sel->cpcon;
> +
> +       return 0;
> +}
> +
> +static int _calc_rate(struct clk_hw *hw, struct tegra_clk_pll_freq_table *cfg,
> +                     unsigned long rate, unsigned long parent_rate)
> +{
> +       struct tegra_clk_pll *pll = to_clk_pll(hw);
> +       unsigned long cfreq;
> +       u32 p_div = 0;
> +
> +       switch (parent_rate) {
> +       case 12000000:
> +       case 26000000:
> +               cfreq = (rate <= 1000000 * 1000) ? 1000000 : 2000000;
> +               break;
> +       case 13000000:
> +               cfreq = (rate <= 1000000 * 1000) ? 1000000 : 2600000;
> +               break;
> +       case 16800000:
> +       case 19200000:
> +               cfreq = (rate <= 1200000 * 1000) ? 1200000 : 2400000;
> +               break;
> +       case 9600000:
> +       case 28800000:
> +               /*
> +                * PLL_P_OUT1 rate is not listed in PLLA table
> +                */
> +               cfreq = parent_rate/(parent_rate/1000000);
> +               break;
> +       default:
> +               pr_err("%s Unexpected reference rate %lu\n",
> +                      __func__, parent_rate);
> +               BUG();
> +       }
> +
> +       /* Raise VCO to guarantee 0.5% accuracy */
> +       for (cfg->output_rate = rate; cfg->output_rate < 200 * cfreq;
> +            cfg->output_rate <<= 1)
> +               p_div++;
> +
> +       cfg->p = 1 << p_div;
> +       cfg->m = parent_rate / cfreq;
> +       cfg->n = cfg->output_rate / cfreq;
> +       cfg->cpcon = OUT_OF_TABLE_CPCON;
> +
> +       if (cfg->m > divm_max(pll) || cfg->n > divn_max(pll) ||
> +           cfg->p > divp_max(pll) || cfg->output_rate > pll->params->vco_max) {
> +               pr_err("%s: Failed to set %s rate %lu\n",
> +                      __func__, __clk_get_name(hw->clk), rate);
> +               return -EINVAL;
> +       }
> +
> +       return 0;
> +}
> +
> +static int _program_pll(struct clk_hw *hw, struct tegra_clk_pll_freq_table *cfg,
> +                       unsigned long rate)
> +{
> +       struct tegra_clk_pll *pll = to_clk_pll(hw);
> +       unsigned long flags = 0;

nit, is "flags" not needed to initialize here?

....
> +
> +struct clk *tegra_clk_pll(const char *name, const char *parent_name,
> +                         void __iomem *clk_base, void __iomem *pmc,
> +                         unsigned long flags, unsigned long fixed_rate,
> +                         struct tegra_clk_pll_params *pll_params, u8 pll_flags,
> +                         struct tegra_clk_pll_freq_table *freq_table,
> +                         spinlock_t *lock)
> +{
> +       struct tegra_clk_pll *pll;
> +       struct clk *clk;
> +       struct clk_init_data init;
> +
> +       pll = kzalloc(sizeof(struct tegra_clk_pll), GFP_KERNEL);

       pll = kzalloc(sizeof(*pll), GFP_KERNEL);

> +       if (!pll)
> +               return ERR_PTR(-ENOMEM);
> +
> +       init.name = name;
> +       init.ops = &tegra_clk_pll_ops;
> +       init.flags = flags;
> +       init.parent_names = (parent_name ? &parent_name : NULL);
> +       init.num_parents = (parent_name ? 1 : 0);
> +
> +       pll->clk_base = clk_base;
> +       pll->pmc = pmc;
> +
> +       pll->freq_table = freq_table;
> +       pll->params = pll_params;
> +       pll->fixed_rate = fixed_rate;
> +       pll->flags = pll_flags;
> +       pll->lock = lock;
> +
> +       pll->divp_shift = PLL_BASE_DIVP_SHIFT;
> +       pll->divp_width = PLL_BASE_DIVP_WIDTH;
> +       pll->divn_shift = PLL_BASE_DIVN_SHIFT;
> +       pll->divn_width = PLL_BASE_DIVN_WIDTH;
> +       pll->divm_shift = PLL_BASE_DIVM_SHIFT;
> +       pll->divm_width = PLL_BASE_DIVM_WIDTH;
> +
> +       pll->hw.init = &init;
> +
> +       clk = clk_register(NULL, &pll->hw);
> +       if (IS_ERR(clk))
> +               kfree(pll);
> +
> +       return clk;
> +}
> +
> +struct clk *tegra_clk_plle(const char *name, const char *parent_name,
> +                         void __iomem *clk_base, void __iomem *pmc,
> +                         unsigned long flags, unsigned long fixed_rate,
> +                         struct tegra_clk_pll_params *pll_params, u8 pll_flags,
> +                         struct tegra_clk_pll_freq_table *freq_table,
> +                         spinlock_t *lock)
> +{
> +       struct tegra_clk_pll *pll;
> +       struct clk *clk;
> +       struct clk_init_data init;
> +
> +       pll = kzalloc(sizeof(struct tegra_clk_pll), GFP_KERNEL);

       pll = kzalloc(sizeof(*pll), GFP_KERNEL);

> +       if (!pll)
> +               return ERR_PTR(-ENOMEM);
> +
> +       init.name = name;
> +       init.ops = &tegra_clk_plle_ops;
> +       init.flags = flags;
> +       init.parent_names = (parent_name ? &parent_name : NULL);
> +       init.num_parents = (parent_name ? 1 : 0);
> +
> +       pll->clk_base = clk_base;
> +       pll->pmc = pmc;
> +
> +       pll->freq_table = freq_table;
> +       pll->params = pll_params;
> +       pll->fixed_rate = fixed_rate;
> +       pll->flags = pll_flags;
> +       pll->lock = lock;
> +
> +       pll->divp_shift = PLLE_BASE_DIVP_SHIFT;
> +       pll->divp_width = PLLE_BASE_DIVP_WIDTH;
> +       pll->divn_shift = PLLE_BASE_DIVN_SHIFT;
> +       pll->divn_width = PLLE_BASE_DIVN_WIDTH;
> +       pll->divm_shift = PLLE_BASE_DIVM_SHIFT;
> +       pll->divm_width = PLLE_BASE_DIVM_WIDTH;
> +
> +       pll->hw.init = &init;
> +
> +       clk = clk_register(NULL, &pll->hw);
> +       if (IS_ERR(clk))
> +               kfree(pll);
> +
> +       return clk;
> +}

Can tegra_clk_pll() and tegra_clk_plle() be static inline from the same func?

struct clk *__tegra_clk_pll(const char *name, const char *parent_name,
                         void __iomem *clk_base, void __iomem *pmc,
                         unsigned long flags, unsigned long fixed_rate,
                         struct tegra_clk_pll_params *pll_params, u8 pll_flags,
                         struct tegra_clk_pll_freq_table *freq_table,
                         spinlock_t *lock, int e)
{
        ....
}

clk.h:

static inline struct clk *tegra_clk_pll(const char *name, const char *parent_name,
                         void __iomem *clk_base, void __iomem *pmc,
                         unsigned long flags, unsigned long fixed_rate,
                         struct tegra_clk_pll_params *pll_params, u8 pll_flags,
                         struct tegra_clk_pll_freq_table *freq_table,
                         spinlock_t *lock, int e)
{
        return __tegra_clk_pll(name, parent_name, clk_base, pmc, flags, fixed_rate, pll_params,
                                     pll_flags, freq_table, lock, 0);
}

static inline struct clk *tegra_clk_plle(const char *name, const char *parent_name,
                         void __iomem *clk_base, void __iomem *pmc,
                         unsigned long flags, unsigned long fixed_rate,
                         struct tegra_clk_pll_params *pll_params, u8 pll_flags,
                         struct tegra_clk_pll_freq_table *freq_table,
                         spinlock_t *lock, int e)
{
        return __tegra_clk_pll(name, parent_name, clk_base, pmc, flags, fixed_rate, pll_params,
                                     pll_flags, freq_table, lock, 1);
}




> diff --git a/drivers/clk/tegra/clk-super.c b/drivers/clk/tegra/clk-super.c
> new file mode 100644
> index 0000000..1604f12
> --- /dev/null
> +++ b/drivers/clk/tegra/clk-super.c
> @@ -0,0 +1,154 @@
> +/*
> + * Copyright (c) 2012, NVIDIA CORPORATION.  All rights reserved.
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
> +#include <linux/kernel.h>
> +#include <linux/io.h>
> +#include <linux/delay.h>
> +#include <linux/err.h>
> +#include <linux/slab.h>
> +#include <linux/clk-provider.h>
> +#include <linux/clk.h>
> +
> +#include "clk.h"
> +
> +#define to_clk_super_mux(_hw) container_of(_hw, struct tegra_clk_super_mux, hw)

Can "struct tegra_clk_super_mux" be private in this file?

> +
> +#define SUPER_STATE_IDLE 0
> +#define SUPER_STATE_RUN 1
> +#define SUPER_STATE_IRQ 2
> +#define SUPER_STATE_FIQ 3
> +
> +#define SUPER_STATE_SHIFT 28
> +#define SUPER_STATE_MASK ((BIT(SUPER_STATE_IDLE) | BIT(SUPER_STATE_RUN) | \
> +                          BIT(SUPER_STATE_IRQ) | BIT(SUPER_STATE_FIQ)) \
> +                         << SUPER_STATE_SHIFT)
> +
> +#define SUPER_LP_DIV2_BYPASS (1 << 16)
> +
> +#define super_state(s) (BIT(s) << SUPER_STATE_SHIFT)
> +#define super_state_to_src_shift(m, s) ((m->width * s))
> +#define super_state_to_src_mask(m) (((1 << m->width) - 1))
> +
> +static u8 clk_super_get_parent(struct clk_hw *hw)
> +{
> +       struct tegra_clk_super_mux *mux = to_clk_super_mux(hw);
> +       u32 val, state;
> +       u8 source, shift;
> +
> +       val = readl_relaxed(mux->reg);
> +
> +       state = val & SUPER_STATE_MASK;
> +
> +       BUG_ON((state != super_state(SUPER_STATE_RUN)) &&
> +              (state != super_state(SUPER_STATE_IDLE)));
> +       shift = (state == super_state(SUPER_STATE_IDLE)) ?
> +               super_state_to_src_shift(mux, SUPER_STATE_IDLE) :
> +               super_state_to_src_shift(mux, SUPER_STATE_RUN);
> +
> +       source = (val >> shift) & super_state_to_src_mask(mux);
> +
> +       /*
> +        * If LP_DIV2_BYPASS is not set and PLLX is current parent then
> +        * PLLX/2 is the input source to CCLKLP.
> +        */
> +       if ((mux->flags & TEGRA_DIVIDER_2) && !(val & SUPER_LP_DIV2_BYPASS) &&
> +           (source == mux->pllx_index))
> +               source = mux->div2_index;
> +
> +       return source;
> +}
> +
> +static int clk_super_set_parent(struct clk_hw *hw, u8 index)
> +{
> +       struct tegra_clk_super_mux *mux = to_clk_super_mux(hw);
> +       u32 val, state;
> +       u8 parent_index, shift;
> +
> +       val = readl_relaxed(mux->reg);
> +       state = val & SUPER_STATE_MASK;
> +       BUG_ON((state != super_state(SUPER_STATE_RUN)) &&
> +              (state != super_state(SUPER_STATE_IDLE)));
> +       shift = (state == super_state(SUPER_STATE_IDLE)) ?
> +               super_state_to_src_shift(mux, SUPER_STATE_IDLE) :
> +               super_state_to_src_shift(mux, SUPER_STATE_RUN);
> +
> +       /*
> +        * For LP mode super-clock switch between PLLX direct
> +        * and divided-by-2 outputs is allowed only when other
> +        * than PLLX clock source is current parent.
> +        */
> +       if ((mux->flags & TEGRA_DIVIDER_2) && ((index == mux->div2_index) ||
> +                                              (index == mux->pllx_index))) {
> +               parent_index = clk_super_get_parent(hw);
> +               if ((parent_index == mux->div2_index) ||
> +                   (parent_index == mux->pllx_index))
> +                       return -EINVAL;
> +
> +               val ^= SUPER_LP_DIV2_BYPASS;
> +               writel_relaxed(val, mux->reg);
> +               udelay(2);
> +
> +               if (index == mux->div2_index)
> +                       index = mux->pllx_index;
> +       }
> +       val &= ~((super_state_to_src_mask(mux)) << shift);
> +       val |= (index & (super_state_to_src_mask(mux))) << shift;
> +
> +       writel_relaxed(val, mux->reg);
> +       udelay(2);
> +       return 0;
> +}
> +
> +const struct clk_ops tegra_clk_super_ops = {
> +       .get_parent = clk_super_get_parent,
> +       .set_parent = clk_super_set_parent,
> +};
> +
> +struct clk *tegra_clk_super_mux(const char *name, const char **parent_names,
> +                               u8 num_parents, unsigned long flags,
> +                               void __iomem *reg, u8 clk_super_flags, u8 width,
> +                               u8 pllx_index, u8 div2_index, spinlock_t *lock)
> +{
> +       struct tegra_clk_super_mux *super;
> +       struct clk *clk;
> +       struct clk_init_data init;
> +
> +       super = kzalloc(sizeof(struct tegra_clk_super_mux), GFP_KERNEL);

       super = kzalloc(sizeof(*super), GFP_KERNEL);

> +       if (!super) {
> +               pr_err("%s: could not allocate super clk\n", __func__);
> +               return ERR_PTR(-ENOMEM);
> +       }
> +
> +       init.name = name;
> +       init.ops = &tegra_clk_super_ops;
> +       init.flags = flags;
> +       init.parent_names = parent_names;
> +       init.num_parents = num_parents;
> +
> +       super->reg = reg;
> +       super->pllx_index = pllx_index;
> +       super->div2_index = div2_index;
> +       super->lock = lock;
> +       super->width = width;
> +       super->flags = clk_super_flags;
> +       super->hw.init = &init;
> +
> +       clk = clk_register(NULL, &super->hw);
> +       if (IS_ERR(clk))
> +               kfree(super);
> +
> +       return clk;
> +}
> diff --git a/drivers/clk/tegra/clk.c b/drivers/clk/tegra/clk.c
> new file mode 100644
> index 0000000..cf023a9
> --- /dev/null
> +++ b/drivers/clk/tegra/clk.c
> @@ -0,0 +1,69 @@
> +/*
> + * Copyright (c) 2012, NVIDIA CORPORATION.  All rights reserved.
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
> +#include <linux/clk.h>
> +#include <linux/clk-provider.h>
> +
> +#include "clk.h"
> +
> +void __init tegra_init_dup_clks(struct tegra_clk_duplicate *dup_list,
> +                               struct clk *clks[], int clk_max)
> +{
> +       struct clk *clk;
> +
> +       for (; dup_list->clk_id < clk_max; dup_list++) {
> +               clk = clks[dup_list->clk_id];
> +               dup_list->lookup.clk = clk;
> +               clkdev_add(&dup_list->lookup);
> +       }
> +}
> +
> +void __init tegra_init_from_table(struct tegra_clk_init_table *tbl,
> +                                 struct clk *clks[], int clk_max)
> +{
> +       struct clk *clk;
> +
> +       for (; tbl->clk_id < clk_max; tbl++) {
> +               clk = clks[tbl->clk_id];
> +               if (IS_ERR_OR_NULL(clk))
> +                       return;
> +
> +               if (tbl->parent_id < clk_max) {
> +                       struct clk *parent = clks[tbl->parent_id];
> +                       if (clk_set_parent(clk, parent)) {
> +                               pr_err("%s: Failed to set parent %s of %s\n",
> +                                      __func__, __clk_get_name(parent),
> +                                      __clk_get_name(clk));
> +                               WARN_ON(1);
> +                       }
> +               }
> +
> +               if (tbl->rate)
> +                       if (clk_set_rate(clk, tbl->rate)) {
> +                               pr_err("%s: Failed to set rate %lu of %s\n",
> +                                      __func__, tbl->rate,
> +                                      __clk_get_name(clk));
> +                               WARN_ON(1);
> +                       }
> +
> +               if (tbl->state)
> +                       if (clk_prepare_enable(clk)) {
> +                               pr_err("%s: Failed to enable %s\n", __func__,
> +                                      __clk_get_name(clk));
> +                               WARN_ON(1);
> +                       }
> +       }
> +}
> diff --git a/drivers/clk/tegra/clk.h b/drivers/clk/tegra/clk.h
> new file mode 100644
> index 0000000..ed9a510
> --- /dev/null
> +++ b/drivers/clk/tegra/clk.h
> @@ -0,0 +1,476 @@
> +/*
> + * Copyright (c) 2012, NVIDIA CORPORATION.  All rights reserved.
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
> +#ifndef __TEGRA_CLK_H
> +#define __TEGRA_CLK_H
> +
> +#include <linux/clk-provider.h>
> +#include <linux/clkdev.h>
> +
> +/**
> + * struct tegra_clk_sync_source - external clock source from codec
> + *
> + * @hw: handle between common and hardware-specific interfaces
> + * @rate: input frequency from source
> + * @max_rate: max rate allowed
> + */
> +struct tegra_clk_sync_source {
> +       struct          clk_hw hw;
> +       unsigned long   rate;
> +       unsigned long   max_rate;
> +};
> +
> +extern const struct clk_ops tegra_clk_sync_source_ops;
> +struct clk *tegra_clk_sync_source(const char *name, unsigned long fixed_rate,
> +                                 unsigned long max_rate);


Can the above move to "clk-audio-sync.c"?


> +/**
> + * struct tegra_clk_frac_div - fractional divider clock
> + *
> + * @hw:                handle between common and hardware-specific interfaces
> + * @reg:       register containing divider
> + * @flags:     hardware-specific flags
> + * @shift:     shift to the divider bit field
> + * @width:     width of the divider bit field
> + * @frac_width:        width of the fractional bit field
> + * @lock:      register lock
> + *
> + * Flags:
> + * TEGRA_DIVIDER_ROUND_UP - This flags indicates to round up the divider value.
> + * TEGRA_DIVIDER_FIXED - Fixed rate PLL dividers has addition override bit, this
> + *      flag indicates that this divider is for fixed rate PLL.
> + * TEGRA_DIVIDER_INT - Some modules can not cope with the duty cycle when
> + *      fraction bit is set. This flags indicates to calculate divider for which
> + *      fracton bit will be zero.
> + * TEGRA_DIVIDER_UART - UART module divider has additional enable bit which is
> + *      set when divider value is not 0. This flags indicates that the divider
> + *      is for UART module.
> + */
> +struct tegra_clk_frac_div {
> +       struct clk_hw   hw;
> +       void __iomem    *reg;
> +       u8              flags;
> +       u8              shift;
> +       u8              width;
> +       u8              frac_width;
> +       spinlock_t      *lock;
> +};
.....
> +extern const struct clk_ops tegra_clk_frac_div_ops;
> +struct clk *tegra_clk_divider(const char *name, const char *parent_name,
> +                             void __iomem *reg, unsigned long flags,
> +                             u8 clk_divider_flags, u8 shift, u8 width,
> +                             u8 frac_width, spinlock_t *lock);

Can the above move to "clk-divider.c"?


> +/*
> + * Tegra PLL:
> + *
> + * In general, there are 3 requirements for each PLL
> + * that SW needs to be comply with.
> + * (1) Input frequency range (REF).
> + * (2) Comparison frequency range (CF). CF = REF/DIVM.
> + * (3) VCO frequency range (VCO).  VCO = CF * DIVN.
> + *
> + * The final PLL output frequency (FO) = VCO >> DIVP.
> + */
> +
> +/**
> + * struct tegra_clk_pll_freq_table - PLL frequecy table
> + *
> + * @input_rate:                input rate from source
> + * @output_rate:       output rate from PLL for the input rate
> + * @n:                 feedback divider
> + * @m:                 input divider
> + * @p:                 post divider
> + * @cpcon:             charge pump current
> + */
> +struct tegra_clk_pll_freq_table {
> +       unsigned long   input_rate;
> +       unsigned long   output_rate;
> +       u16             n;
> +       u16             m;
> +       u8              p;
> +       u8              cpcon;
> +};
> +
> +/**
> + * struct clk_pll_params - PLL parameters
> + *
> + * @input_min:                 Minimum input frequency
> + * @input_max:                 Maximum input frequency
> + * @cf_min:                    Minimum comparison frequency
> + * @cf_max:                    Maximum comparison frequency
> + * @vco_min:                   Minimum VCO frequency
> + * @vco_max:                   Maximum VCO frequency
> + * @base_reg:                  PLL base reg offset
> + * @misc_reg:                  PLL misc reg offset
> + * @lock_reg:                  PLL lock reg offset
> + * @lock_bit_idx:              Bit index for PLL lock status
> + * @lock_enable_bit_idx:       Bit index to enable PLL lock
> + * @lock_delay:                        Delay in us if PLL lock is not used
> + */
> +struct tegra_clk_pll_params {
> +       unsigned long   input_min;
> +       unsigned long   input_max;
> +       unsigned long   cf_min;
> +       unsigned long   cf_max;
> +       unsigned long   vco_min;
> +       unsigned long   vco_max;
> +
> +       u32             base_reg;
> +       u32             misc_reg;
> +       u32             lock_reg;
> +       u32             lock_bit_idx;
> +       u32             lock_enable_bit_idx;
> +       int             lock_delay;
> +};
> +
> +/**
> + * struct tegra_clk_pll - Tegra PLL clock
> + *
> + * @hw:                handle between common and hardware-specifix interfaces
> + * @clk_base:  address of CAR controller
> + * @pmc:       address of PMC, required to read override bits
> + * @freq_table:        array of frequencies supported by PLL
> + * @params:    PLL parameters
> + * @flags:     PLL flags
> + * @fixed_rate:        PLL rate if it is fixed
> + * @lock:      register lock
> + * @divn_shift:        shift to the feedback divider bit field
> + * @divn_width:        width of the feedback divider bit field
> + * @divm_shift:        shift to the input divider bit field
> + * @divm_width:        width of the input divider bit field
> + * @divp_shift:        shift to the post divider bit field
> + * @divp_width:        width of the post divider bit field
> + *
> + * Flags:
> + * TEGRA_PLL_USE_LOCK - This flag indicated to use lock bits for
> + *     PLL locking. If not set it will use lock_delay value to wait.
> + * TEGRA_PLL_HAS_CPCON - This flag indicates that CPCON value needs
> + *     to be programmed to change output frequency of the PLL.
> + * TEGRA_PLL_SET_LFCON - This flag indicates that LFCON value needs
> + *     to be programmed to change output frequency of the PLL.
> + * TEGRA_PLL_SET_DCCON - This flag indicates that DCCON value needs
> + *     to be programmed to change output frequency of the PLL.
> + * TEGRA_PLLU - PLLU has inverted post divider. This flags indicated
> + *     that it is PLLU and invert post divider value.
> + * TEGRA_PLLM - PLLM has additional override settings in PMC. This
> + *     flag indicates that it is PLLM and use override settings.
> + * TEGRA_PLL_FIXED - We are not supposed to change output frequency
> + *     of some plls.
> + * TEGRA_PLLE_CONFIGURE - Configure PLLE when enabling.
> + */
> +struct tegra_clk_pll {
> +       struct clk_hw   hw;
> +       void __iomem    *clk_base;
> +       void __iomem    *pmc;
> +       u8              flags;
> +       unsigned long   fixed_rate;
> +       spinlock_t      *lock;
> +       u8              divn_shift;
> +       u8              divn_width;
> +       u8              divm_shift;
> +       u8              divm_width;
> +       u8              divp_shift;
> +       u8              divp_width;
> +       struct tegra_clk_pll_freq_table *freq_table;
> +       struct tegra_clk_pll_params     *params;
> +};
> +
> +#define TEGRA_PLL_USE_LOCK BIT(0)
> +#define TEGRA_PLL_HAS_CPCON BIT(1)
> +#define TEGRA_PLL_SET_LFCON BIT(2)
> +#define TEGRA_PLL_SET_DCCON BIT(3)
> +#define TEGRA_PLLU BIT(4)
> +#define TEGRA_PLLM BIT(5)
> +#define TEGRA_PLL_FIXED BIT(6)
> +#define TEGRA_PLLE_CONFIGURE BIT(7)
> +
> +extern const struct clk_ops tegra_clk_pll_ops;
> +extern const struct clk_ops tegra_clk_plle_ops;
> +struct clk *tegra_clk_pll(const char *name, const char *parent_name,
> +                         void __iomem *clk_base, void __iomem *pmc,
> +                         unsigned long flags, unsigned long fixed_rate,
> +                         struct tegra_clk_pll_params *pll_params, u8 pll_flags,
> +                         struct tegra_clk_pll_freq_table *freq_table,
> +                         spinlock_t *lock);

same name as struct tegra_clk_pll. tegra_clk_register_pll()?

> +struct clk *tegra_clk_plle(const char *name, const char *parent_name,
> +                         void __iomem *clk_base, void __iomem *pmc,
> +                         unsigned long flags, unsigned long fixed_rate,
> +                         struct tegra_clk_pll_params *pll_params, u8 pll_flags,
> +                         struct tegra_clk_pll_freq_table *freq_table,
> +                         spinlock_t *lock);
> +
> +/**
> + * struct tegra_clk_pll_out - PLL divider down clock
> + *
> + * @hw:                        handle between common and hardware-specific interfaces
> + * @reg:               register containing the PLL divider
> + * @enb_bit_idx:       bit to enable/disable PLL divider
> + * @rst_bit_idx:       bit to reset PLL divider
> + * @lock:              register lock
> + * @flags:             hardware-specific flags
> + */
> +struct tegra_clk_pll_out {
> +       struct clk_hw   hw;
> +       void __iomem    *reg;
> +       u8              enb_bit_idx;
> +       u8              rst_bit_idx;
> +       spinlock_t      *lock;
> +       u8              flags;
> +};

In clk-pll-out.c?

> +
> +extern const struct clk_ops tegra_clk_pll_out_ops;
> +struct clk *tegra_clk_pll_out(const char *name, const char *parent_name,
> +                             void __iomem *reg, u8 enb_bit_idx, u8 rst_bit_idx,
> +                             unsigned long flags, u8 pll_div_flags,
> +                             spinlock_t *lock);

same name as struct...

> +
> +/**
> + * struct tegra_clk_periph_regs -  Registers controlling peripheral clock
> + *
> + * @enb_reg:           read the enable status
> + * @enb_set_reg:       write 1 to enable clock
> + * @enb_clr_reg:       write 1 to disable clock
> + * @rst_reg:           read the reset status
> + * @rst_set_reg:       write 1 to assert the reset of peripheral
> + * @rst_clr_reg:       write 1 to deassert the reset of peripheral
> + */
> +struct tegra_clk_periph_regs {
> +       u32 enb_reg;
> +       u32 enb_set_reg;
> +       u32 enb_clr_reg;
> +       u32 rst_reg;
> +       u32 rst_set_reg;
> +       u32 rst_clr_reg;
> +};
> +
> +/**
> + * struct tegra_clk_periph_gate - peripheral gate clock
> + *
> + * @magic:             magic number to validate type
> + * @hw:                        handle between common and hardware-specific interfaces
> + * @clk_base:          address of CAR controller
> + * @regs:              Registers to control the peripheral
> + * @flags:             hardware-specific flags
> + * @clk_num:           Clock number
> + * @enable_refcnt:     array to maintain reference count of the clock
> + *
> + * Flags:
> + * TEGRA_PERIPH_NO_RESET - This flag indicates that reset is not allowed
> + *     for this module.
> + * TEGRA_PERIPH_MANUAL_RESET - This flag indicates not to reset module
> + *     after clock enable and driver for the module is responsible for
> + *     doing reset.
> + * TEGRA_PERIPH_ON_APB - If peripheral is in the APB bus then read the
> + *     bus to flush the write operation in apb bus. This flag indicates
> + *     that this peripheral is in apb bus.
> + */
> +struct tegra_clk_periph_gate {
> +       u32                     magic;
> +       struct clk_hw           hw;
> +       void __iomem            *clk_base;
> +       u8                      flags;
> +       int                     clk_num;
> +       int                     *enable_refcnt;
> +       struct tegra_clk_periph_regs    *regs;
> +};
> +
> +#define TEGRA_CLK_PERIPH_GATE_MAGIC 0x17760309
> +
> +#define TEGRA_PERIPH_NO_RESET BIT(0)
> +#define TEGRA_PERIPH_MANUAL_RESET BIT(1)
> +#define TEGRA_PERIPH_ON_APB BIT(2)
> +
> +void tegra_periph_reset(struct tegra_clk_periph_gate *gate, bool assert);
> +extern const struct clk_ops tegra_clk_periph_gate_ops;
> +struct clk *tegra_clk_periph_gate(const char *name, const char *parent_name,
> +                                 u8 gate_flags, void __iomem *clk_base,
> +                                 unsigned long flags, int clk_num,
> +                                 struct tegra_clk_periph_regs *pregs,
> +                                 int *enable_refcnt);
> +
> +/**
> + * struct clk-periph - peripheral clock
> + *
> + * @magic:     magic number to validate type
> + * @hw:                handle between common and hardware-specific interfaces
> + * @mux:       mux clock
> + * @divider:   divider clock
> + * @gate:      gate clock
> + * @mux_ops:   mux clock ops
> + * @div_ops:   divider clock ops
> + * @gate_ops:  gate clock ops
> + */
> +struct tegra_clk_periph {
> +       u32                     magic;
> +       struct clk_hw           hw;
> +       struct clk_mux          mux;
> +       struct tegra_clk_frac_div       divider;
> +       struct tegra_clk_periph_gate    gate;
> +
> +       const struct clk_ops    *mux_ops;
> +       const struct clk_ops    *div_ops;
> +       const struct clk_ops    *gate_ops;
> +};


Can be defined in clk-periph.c?

> +
> +#define TEGRA_CLK_PERIPH_MAGIC 0x18221223
> +
> +extern const struct clk_ops tegra_clk_periph_ops;
> +struct clk *tegra_clk_periph(const char *name, const char **parent_names,
> +                            int num_parents, struct tegra_clk_periph *periph,
> +                            void __iomem *clk_base, u32 offset);

Not so nice to have the same name as struct. Maybe tegra_clk_register_periph()?

> +struct clk *tegra_clk_periph_nodiv(const char *name, const char **parent_names,
> +                            int num_parents, struct tegra_clk_periph *periph,
> +                            void __iomem *clk_base, u32 offset);

Can be inlined func, pointed out in another mail?

> +
> +#define TEGRA_CLK_PERIPH(_mux_shift, _mux_width, _mux_flags,           \
> +                        _div_shift, _div_width, _div_frac_width,       \
> +                        _div_flags, _clk_num, _enb_refcnt, _regs,      \
> +                        _gate_flags)                                   \
> +       {                                                               \
> +               .mux = {                                                \
> +                       .flags = _mux_flags,                            \
> +                       .shift = _mux_shift,                            \
> +                       .width = _mux_width,                            \
> +               },                                                      \
> +               .divider = {                                            \
> +                       .flags = _div_flags,                            \
> +                       .shift = _div_shift,                            \
> +                       .width = _div_width,                            \
> +                       .frac_width = _div_frac_width,                  \
> +               },                                                      \
> +               .gate = {                                               \
> +                       .flags = _gate_flags,                           \
> +                       .clk_num = _clk_num,                            \
> +                       .enable_refcnt = _enb_refcnt,                   \
> +                       .regs = _regs,                                  \
> +               },                                                      \
> +               .mux_ops = &clk_mux_ops,                                \
> +               .div_ops = &tegra_clk_frac_div_ops,                     \
> +               .gate_ops = &tegra_clk_periph_gate_ops,                 \
> +       }
> +
.....
> +/**
> + * struct clk_super_mux - super clock
> + *
> + * @hw:                handle between common and hardware-specific interfaces
> + * @reg:       register controlling multiplexer
> + * @width:     width of the multiplexer bit field
> + * @flags:     hardware-specific flags
> + * @div2_index:        bit controlling divide-by-2
> + * @pllx_index:        PLLX index in the parent list
> + * @lock:      register lock
> + *
> + * Flags:
> + * TEGRA_DIVIDER_2 - LP cluster has additional divider. This flag indicates
> + *     that this is LP cluster clock.
> + */
> +struct tegra_clk_super_mux {
> +       struct clk_hw   hw;
> +       void __iomem    *reg;
> +       u8              width;
> +       u8              flags;
> +       u8              div2_index;
> +       u8              pllx_index;
> +       spinlock_t      *lock;
> +};
> +
> +#define TEGRA_DIVIDER_2 BIT(0)
> +
> +extern const struct clk_ops tegra_clk_super_ops;

Can be defined in clk-super.c?

> +struct clk *tegra_clk_super_mux(const char *name, const char **parent_names,
> +                               u8 num_parents, unsigned long flags,
> +                               void __iomem *reg, u8 clk_super_flags,
> +                               u8 width, u8 pllx_index, u8 div2_index,
> +                               spinlock_t *lock);

Better to have different name from struct, like "tegra_clk_register_super_mux()"?
