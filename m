Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754610Ab3AKLsg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 06:48:36 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:14642 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753757Ab3AKLse convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 06:48:34 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 11 Jan 2013 03:48:23 -0800
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: Prashant Gaikwad <pgaikwad@nvidia.com>
CC: "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "mturquette@linaro.org" <mturquette@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 11 Jan 2013 12:48:20 +0100
Subject: Re: [PATCH v4 2/9] clk: tegra: Add tegra specific clocks
Thread-Topic: [PATCH v4 2/9] clk: tegra: Add tegra specific clocks
Thread-Index: Ac3v8ZMJAHRgim6tTlqL4iHrkohw+w==
Message-ID: <20130111.134820.1392079432650652356.hdoyu@nvidia.com>
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

Hi Prahant,

Some nit-pick/cosmetic comments inlined...

Prashant Gaikwad <pgaikwad@nvidia.com> wrote @ Fri, 11 Jan 2013 08:46:20 +0100:

> Add tegra specific clocks, pll, pll_out, peripheral,
> frac_divider, super.
>
> Signed-off-by: Prashant Gaikwad <pgaikwad@nvidia.com>
> ---
>  drivers/clk/Makefile                |    1 +
>  drivers/clk/tegra/Makefile          |    8 +
>  drivers/clk/tegra/clk-audio-sync.c  |   89 +++++
>  drivers/clk/tegra/clk-divider.c     |  188 ++++++++++
>  drivers/clk/tegra/clk-periph-gate.c |  182 ++++++++++
>  drivers/clk/tegra/clk-periph.c      |  190 ++++++++++
>  drivers/clk/tegra/clk-pll-out.c     |  124 +++++++
>  drivers/clk/tegra/clk-pll.c         |  676 +++++++++++++++++++++++++++++++++++
>  drivers/clk/tegra/clk-super.c       |  154 ++++++++
>  drivers/clk/tegra/clk.c             |   69 ++++
>  drivers/clk/tegra/clk.h             |  476 ++++++++++++++++++++++++
>  11 files changed, 2157 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/clk/tegra/Makefile
>  create mode 100644 drivers/clk/tegra/clk-audio-sync.c
>  create mode 100644 drivers/clk/tegra/clk-divider.c
>  create mode 100644 drivers/clk/tegra/clk-periph-gate.c
>  create mode 100644 drivers/clk/tegra/clk-periph.c
>  create mode 100644 drivers/clk/tegra/clk-pll-out.c
>  create mode 100644 drivers/clk/tegra/clk-pll.c
>  create mode 100644 drivers/clk/tegra/clk-super.c
>  create mode 100644 drivers/clk/tegra/clk.c
>  create mode 100644 drivers/clk/tegra/clk.h
>
> diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
> index ee90e87..f0b269a 100644
> --- a/drivers/clk/Makefile
> +++ b/drivers/clk/Makefile
> @@ -22,6 +22,7 @@ obj-$(CONFIG_ARCH_U8500)      += ux500/
>  obj-$(CONFIG_ARCH_VT8500)      += clk-vt8500.o
>  obj-$(CONFIG_ARCH_SUNXI)       += clk-sunxi.o
>  obj-$(CONFIG_ARCH_ZYNQ)                += clk-zynq.o
> +obj-$(CONFIG_ARCH_TEGRA)       += tegra/
>
>  # Chip specific
>  obj-$(CONFIG_COMMON_CLK_WM831X) += clk-wm831x.o
> diff --git a/drivers/clk/tegra/Makefile b/drivers/clk/tegra/Makefile
> new file mode 100644
> index 0000000..68bd353
> --- /dev/null
> +++ b/drivers/clk/tegra/Makefile
> @@ -0,0 +1,8 @@
> +obj-y                                  += clk.o
> +obj-y                                  += clk-audio-sync.o
> +obj-y                                  += clk-divider.o
> +obj-y                                  += clk-periph.o
> +obj-y                                  += clk-periph-gate.o
> +obj-y                                  += clk-pll.o
> +obj-y                                  += clk-pll-out.o
> +obj-y                                  += clk-super.o
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
> +                                      unsigned long *prate)
> +{
> +       struct tegra_clk_sync_source *sync = to_clk_sync_source(hw);
> +
> +       if (rate > sync->max_rate)
> +               return -EINVAL;
> +       else
> +               return rate;
> +}
> +
> +static int clk_sync_source_set_rate(struct clk_hw *hw, unsigned long rate,
> +                                   unsigned long parent_rate)
> +{
> +       struct tegra_clk_sync_source *sync = to_clk_sync_source(hw);
> +
> +       sync->rate = rate;
> +       return 0;
> +}
> +
> +const struct clk_ops tegra_clk_sync_source_ops = {
> +       .round_rate = clk_sync_source_round_rate,
> +       .set_rate = clk_sync_source_set_rate,
> +       .recalc_rate = clk_sync_source_recalc_rate,
> +};
> +
> +struct clk *tegra_clk_sync_source(const char *name, unsigned long rate,
> +                                 unsigned long max_rate)
> +{
> +       struct tegra_clk_sync_source *sync;
> +       struct clk_init_data init;
> +       struct clk *clk;
> +
> +       sync = kzalloc(sizeof(struct tegra_clk_sync_source), GFP_KERNEL);
> +       if (!sync) {
> +               pr_err("%s: could not allocate sync source clk\n", __func__);
> +               return ERR_PTR(-ENOMEM);
> +       }
> +
> +       sync->rate = rate;
> +       sync->max_rate = max_rate;
> +
> +       init.ops = &tegra_clk_sync_source_ops;
> +       init.name = name;
> +       init.flags = CLK_IS_ROOT;
> +       init.parent_names = NULL;
> +       init.num_parents = 0;
> +
> +       sync->hw.init = &init;
> +
> +       clk = clk_register(NULL, &sync->hw);

The above usage of "init" from stack may be a bit
unfamilier. I can guess that its content is copied in clk_register()
but it's originally defined in stack. So I just prefer to writing this
as below. It may be somewhat explict that we know init is from stack.

struct clk *tegra_clk_sync_source(const char *name, unsigned long rate,
                                 unsigned long max_rate)
{
        struct tegra_clk_sync_source *sync;
        struct clk_init_data init = {
                .ops = &tegra_clk_sync_source_ops;
                .name = name;
                .flags = CLK_IS_ROOT;
                .parent_names = NULL;
                .num_parents = 0;
        };
        struct clk *clk;

        sync = kzalloc(sizeof(*sync), GFP_KERNEL);
        if (!sync) {
                pr_err("%s: could not allocate sync source clk\n", __func__);
                return ERR_PTR(-ENOMEM);
        }

        sync->rate = rate;
        sync->max_rate = max_rate;
        sync->hw.init = &init;

        clk = clk_register(NULL, &sync->hw);

Maybe other init as well?

> +       if (IS_ERR(clk))
> +               kfree(sync);
> +
> +       return clk;
> +}
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
> +       if (!(flags & TEGRA_DIVIDER_INT))
> +               divider_ux1 *= mul;
> +
> +       if (flags & TEGRA_DIVIDER_ROUND_UP)
> +               divider_ux1 += rate - 1;
> +
> +       do_div(divider_ux1, rate);
> +
> +       if (flags & TEGRA_DIVIDER_INT)
> +               divider_ux1 *= mul;
> +
> +       divider_ux1 -= mul;
> +
> +       if (divider_ux1 < 0)
> +               return 0;
> +
> +       if (divider_ux1 > get_max_div(divider))
> +               return -EINVAL;
> +
> +       return divider_ux1;
> +}
> +
> +static unsigned long clk_frac_div_recalc_rate(struct clk_hw *hw,
> +                                            unsigned long parent_rate)
> +{
> +       struct tegra_clk_frac_div *divider = to_clk_frac_div(hw);
> +       u32 reg;
> +       int div, mul;
> +       u64 rate = parent_rate;
> +
> +       reg = readl_relaxed(divider->reg) >> divider->shift;
> +       div = reg & div_mask(divider);
> +
> +       mul = get_mul(divider);
> +       div += mul;
> +
> +       rate *= mul;
> +       rate += div - 1;
> +       do_div(rate, div);
> +
> +       return rate;
> +}
> +
> +static long clk_frac_div_round_rate(struct clk_hw *hw, unsigned long rate,
> +                                  unsigned long *prate)
> +{
> +       struct tegra_clk_frac_div *divider = to_clk_frac_div(hw);
> +       int div, mul;
> +       unsigned long output_rate = *prate;
> +
> +       if (!rate)
> +               return output_rate;
> +
> +       div = get_div(divider, rate, output_rate);
> +       if (div < 0)
> +               return *prate;
> +
> +       mul = get_mul(divider);
> +
> +       return DIV_ROUND_UP(output_rate * mul, div + mul);
> +}
> +
> +static int clk_frac_div_set_rate(struct clk_hw *hw, unsigned long rate,
> +                               unsigned long parent_rate)
> +{
> +       struct tegra_clk_frac_div *divider = to_clk_frac_div(hw);
> +       int div;
> +       unsigned long flags = 0;
> +       u32 val;
> +
> +       div = get_div(divider, rate, parent_rate);
> +       if (div < 0)
> +               return div;
> +
> +       if (divider->lock)
> +               spin_lock_irqsave(divider->lock, flags);
> +
> +       val = readl_relaxed(divider->reg);
> +       val &= ~(div_mask(divider) << divider->shift);
> +       val |= div << divider->shift;
> +
> +       if (divider->flags & TEGRA_DIVIDER_UART) {
> +               if (div)
> +                       val |= PERIPH_CLK_UART_DIV_ENB;
> +               else
> +                       val &= ~PERIPH_CLK_UART_DIV_ENB;
> +       }
> +
> +       if (divider->flags & TEGRA_DIVIDER_FIXED)
> +               val |= pll_out_override(divider);
> +
> +       writel_relaxed(val, divider->reg);
> +
> +       if (divider->lock)
> +               spin_unlock_irqrestore(divider->lock, flags);
> +
> +       return 0;
> +}
> +
> +const struct clk_ops tegra_clk_frac_div_ops = {
> +       .recalc_rate = clk_frac_div_recalc_rate,
> +       .set_rate = clk_frac_div_set_rate,
> +       .round_rate = clk_frac_div_round_rate,
> +};
> +
> +struct clk *tegra_clk_divider(const char *name, const char *parent_name,
> +                             void __iomem *reg, unsigned long flags,
> +                             u8 clk_divider_flags, u8 shift, u8 width,
> +                             u8 frac_width, spinlock_t *lock)
> +{
> +       struct tegra_clk_frac_div *divider;
> +       struct clk *clk;
> +       struct clk_init_data init;
> +
> +       divider = kzalloc(sizeof(struct tegra_clk_frac_div), GFP_KERNEL);

        divider = kzalloc(sizeof(*divider), GFP_KERNEL);

Maybe other *alloc() as well?

> +       if (!divider) {
> +               pr_err("%s: could not allocate fractional divider clk\n",
> +                      __func__);
> +               return ERR_PTR(-ENOMEM);
> +       }
> +
> +       init.name = name;
> +       init.ops = &tegra_clk_frac_div_ops;
> +       init.flags = flags;
> +       init.parent_names = parent_name ? &parent_name : NULL;
> +       init.num_parents = parent_name ? 1 : 0;
> +
> +       divider->reg = reg;
> +       divider->shift = shift;
> +       divider->width = width;
> +       divider->frac_width = frac_width;
> +       divider->lock = lock;
> +       divider->flags = clk_divider_flags;
> +
> +       divider->hw.init = &init;
> +
> +       clk = clk_register(NULL, &divider->hw);
> +       if (IS_ERR(clk))
> +               kfree(divider);
> +
> +       return clk;
> +}
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
> +
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

       gate = kzalloc(sizeof(*gate), GFP_KERNEL);

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
> +static unsigned long clk_periph_recalc_rate(struct clk_hw *hw,
> +                                           unsigned long parent_rate)
> +{
> +       struct tegra_clk_periph *periph = to_clk_periph(hw);
> +       const struct clk_ops *div_ops = periph->div_ops;
> +       struct clk_hw *div_hw = &periph->divider.hw;
> +
> +       div_hw->clk = hw->clk;
> +
> +       return div_ops->recalc_rate(div_hw, parent_rate);
> +}
> +
> +static long clk_periph_round_rate(struct clk_hw *hw, unsigned long rate,
> +                                 unsigned long *prate)
> +{
> +       struct tegra_clk_periph *periph = to_clk_periph(hw);
> +       const struct clk_ops *div_ops = periph->div_ops;
> +       struct clk_hw *div_hw = &periph->divider.hw;
> +
> +       div_hw->clk = hw->clk;
> +
> +       return div_ops->round_rate(div_hw, rate, prate);
> +}
> +
> +static int clk_periph_set_rate(struct clk_hw *hw, unsigned long rate,
> +                              unsigned long parent_rate)
> +{
> +       struct tegra_clk_periph *periph = to_clk_periph(hw);
> +       const struct clk_ops *div_ops = periph->div_ops;
> +       struct clk_hw *div_hw = &periph->divider.hw;
> +
> +       div_hw->clk = hw->clk;
> +
> +       return div_ops->set_rate(div_hw, rate, parent_rate);
> +}
> +
> +static int clk_periph_is_enabled(struct clk_hw *hw)
> +{
> +       struct tegra_clk_periph *periph = to_clk_periph(hw);
> +       const struct clk_ops *gate_ops = periph->gate_ops;
> +       struct clk_hw *gate_hw = &periph->gate.hw;
> +
> +       gate_hw->clk = hw->clk;
> +
> +       return gate_ops->is_enabled(gate_hw);
> +}
> +
> +static int clk_periph_enable(struct clk_hw *hw)
> +{
> +       struct tegra_clk_periph *periph = to_clk_periph(hw);
> +       const struct clk_ops *gate_ops = periph->gate_ops;
> +       struct clk_hw *gate_hw = &periph->gate.hw;
> +
> +       gate_hw->clk = hw->clk;
> +
> +       return gate_ops->enable(gate_hw);
> +}
> +
> +static void clk_periph_disable(struct clk_hw *hw)
> +{
> +       struct tegra_clk_periph *periph = to_clk_periph(hw);
> +       const struct clk_ops *gate_ops = periph->gate_ops;
> +       struct clk_hw *gate_hw = &periph->gate.hw;
> +
> +       gate_ops->disable(gate_hw);
> +}
> +
> +const struct clk_ops tegra_clk_periph_ops = {
> +       .get_parent = clk_periph_get_parent,
> +       .set_parent = clk_periph_set_parent,
> +       .recalc_rate = clk_periph_recalc_rate,
> +       .round_rate = clk_periph_round_rate,
> +       .set_rate = clk_periph_set_rate,
> +       .is_enabled = clk_periph_is_enabled,
> +       .enable = clk_periph_enable,
> +       .disable = clk_periph_disable,
> +};
> +
> +const struct clk_ops tegra_clk_periph_nodiv_ops = {
> +       .get_parent = clk_periph_get_parent,
> +       .set_parent = clk_periph_set_parent,
> +       .is_enabled = clk_periph_is_enabled,
> +       .enable = clk_periph_enable,
> +       .disable = clk_periph_disable,
> +};
> +
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
> +       init.parent_names = parent_names;
> +       init.num_parents = num_parents;
> +
> +       periph->hw.init = &init;
> +       periph->magic = TEGRA_CLK_PERIPH_MAGIC;
> +       periph->mux.reg = clk_base + offset;
> +       periph->divider.reg = clk_base + offset;
> +       periph->gate.clk_base = clk_base;
> +
> +       clk = clk_register(NULL, &periph->hw);
> +       if (IS_ERR(clk))
> +               return clk;
> +
> +       periph->mux.hw.clk = clk;
> +       periph->divider.hw.clk = clk;
> +       periph->gate.hw.clk = clk;
> +
> +       return clk;
> +}
> +
> +struct clk *tegra_clk_periph_nodiv(const char *name, const char **parent_names,
> +                             int num_parents, struct tegra_clk_periph *periph,
> +                             void __iomem *clk_base, u32 offset)
> +{
> +       struct clk *clk;
> +       struct clk_init_data init;
> +
> +       init.name = name;
> +       init.ops = &tegra_clk_periph_nodiv_ops;
> +       init.flags = CLK_SET_RATE_PARENT;
> +       init.parent_names = parent_names;
> +       init.num_parents = num_parents;
> +
> +       periph->hw.init = &init;
> +       periph->magic = TEGRA_CLK_PERIPH_MAGIC;
> +       periph->mux.reg = clk_base + offset;
> +       periph->gate.clk_base = clk_base;
> +
> +       clk = clk_register(NULL, &periph->hw);
> +       if (IS_ERR(clk))
> +               return clk;
> +
> +       periph->mux.hw.clk = clk;
> +       periph->gate.hw.clk = clk;
> +
> +       return clk;
> +}
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
> +
> +#define pll_out_enb(p) (BIT(p->enb_bit_idx))
> +#define pll_out_rst(p) (BIT(p->rst_bit_idx))
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
> +       u32 val;
> +
> +       if (pll_out->lock)
> +               spin_lock_irqsave(pll_out->lock, flags);
> +
> +       val = readl_relaxed(pll_out->reg);
> +
> +       val |= (pll_out_enb(pll_out) | pll_out_rst(pll_out));
> +
> +       writel_relaxed(val, pll_out->reg);
> +       udelay(2);
> +
> +       if (pll_out->lock)
> +               spin_unlock_irqrestore(pll_out->lock, flags);
> +
> +       return 0;
> +}
> +
> +static void clk_pll_out_disable(struct clk_hw *hw)
> +{
> +       struct tegra_clk_pll_out *pll_out = to_clk_pll_out(hw);
> +       unsigned long flags = 0;
> +       u32 val;
> +
> +       if (pll_out->lock)
> +               spin_lock_irqsave(pll_out->lock, flags);
> +
> +       val = readl_relaxed(pll_out->reg);
> +
> +       val &= ~(pll_out_enb(pll_out) | pll_out_rst(pll_out));
> +
> +       writel_relaxed(val, pll_out->reg);
> +       udelay(2);
> +
> +       if (pll_out->lock)
> +               spin_unlock_irqrestore(pll_out->lock, flags);
> +}
> +
> +const struct clk_ops tegra_clk_pll_out_ops = {
> +       .is_enabled = clk_pll_out_is_enabled,
> +       .enable = clk_pll_out_enable,
> +       .disable = clk_pll_out_disable,
> +};
> +
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
> @@ -0,0 +1,676 @@
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
> +#include <linux/slab.h>
> +#include <linux/io.h>
> +#include <linux/delay.h>
> +#include <linux/err.h>
> +#include <linux/clk-provider.h>
> +#include <linux/clk.h>
> +
> +#include "clk.h"
> +
> +#define PLL_BASE_BYPASS BIT(31)
> +#define PLL_BASE_ENABLE BIT(30)
> +#define PLL_BASE_REF_ENABLE BIT(29)
> +#define PLL_BASE_OVERRIDE BIT(28)
> +
> +#define PLL_BASE_DIVP_SHIFT 20
> +#define PLL_BASE_DIVP_WIDTH 3
> +#define PLL_BASE_DIVN_SHIFT 8
> +#define PLL_BASE_DIVN_WIDTH 10
> +#define PLL_BASE_DIVM_SHIFT 0
> +#define PLL_BASE_DIVM_WIDTH 5
> +#define PLLU_POST_DIVP_MASK 0x1
> +
> +#define PLL_MISC_DCCON_SHIFT 20
> +#define PLL_MISC_CPCON_SHIFT 8
> +#define PLL_MISC_CPCON_WIDTH 4
> +#define PLL_MISC_CPCON_MASK ((1 << PLL_MISC_CPCON_WIDTH) - 1)
> +#define PLL_MISC_LFCON_SHIFT 4
> +#define PLL_MISC_LFCON_WIDTH 4
> +#define PLL_MISC_LFCON_MASK ((1 << PLL_MISC_LFCON_WIDTH) - 1)
> +#define PLL_MISC_VCOCON_SHIFT 0
> +#define PLL_MISC_VCOCON_WIDTH 4
> +#define PLL_MISC_VCOCON_MASK ((1 << PLL_MISC_VCOCON_WIDTH) - 1)
> +
> +#define OUT_OF_TABLE_CPCON 8
> +
> +#define PMC_PLLP_WB0_OVERRIDE 0xf8
> +#define PMC_PLLP_WB0_OVERRIDE_PLLM_ENABLE BIT(12)
> +#define PMC_PLLP_WB0_OVERRIDE_PLLM_OVERRIDE BIT(11)
> +
> +#define PLL_POST_LOCK_DELAY 50
> +
> +#define PLLDU_LFCON_SET_DIVN 600
> +
> +#define PLLE_BASE_DIVCML_SHIFT 24
> +#define PLLE_BASE_DIVCML_WIDTH 4
> +#define PLLE_BASE_DIVP_SHIFT 16
> +#define PLLE_BASE_DIVP_WIDTH 7
> +#define PLLE_BASE_DIVN_SHIFT 8
> +#define PLLE_BASE_DIVN_WIDTH 8
> +#define PLLE_BASE_DIVM_SHIFT 0
> +#define PLLE_BASE_DIVM_WIDTH 8
> +
> +#define PLLE_MISC_SETUP_BASE_SHIFT 16
> +#define PLLE_MISC_SETUP_BASE_MASK (0xffff << PLLE_MISC_SETUP_BASE_SHIFT)
> +#define PLLE_MISC_LOCK_ENABLE BIT(9)
> +#define PLLE_MISC_READY BIT(15)
> +#define PLLE_MISC_SETUP_EX_SHIFT 2
> +#define PLLE_MISC_SETUP_EX_MASK (3 << PLLE_MISC_SETUP_EX_SHIFT)
> +#define PLLE_MISC_SETUP_MASK (PLLE_MISC_SETUP_BASE_MASK |      \
> +                             PLLE_MISC_SETUP_EX_MASK)
> +#define PLLE_MISC_SETUP_VALUE (7 << PLLE_MISC_SETUP_BASE_SHIFT)
> +
> +#define PLLE_SS_CTRL 0x68
> +#define PLLE_SS_DISABLE (7 << 10)
> +
> +#define PMC_SATA_PWRGT 0x1ac
> +#define PMC_SATA_PWRGT_PLLE_IDDQ_VALUE BIT(5)
> +#define PMC_SATA_PWRGT_PLLE_IDDQ_SWCTL BIT(4)
> +
> +#define to_clk_pll(_hw)        container_of(_hw, struct tegra_clk_pll, hw)
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
> +       u32 divp, val, old_base;
> +       int state;
> +
> +       divp = __ffs(cfg->p);
> +
> +       if (pll->flags & TEGRA_PLLU)
> +               divp ^= 1;
> +
> +       if (pll->lock)
> +               spin_lock_irqsave(pll->lock, flags);
> +
> +       old_base = val = pll_readl_base(pll);
> +       val &= ~((divm_mask(pll) << pll->divm_shift) |
> +                (divn_mask(pll) << pll->divn_shift) |
> +                (divp_mask(pll) << pll->divp_shift));
> +       val |= ((cfg->m << pll->divm_shift) |
> +               (cfg->n << pll->divn_shift) |
> +               (divp << pll->divp_shift));
> +       if (val == old_base) {
> +               if (pll->lock)
> +                       spin_unlock_irqrestore(pll->lock, flags);
> +               return 0;
> +       }
> +
> +       state = clk_pll_is_enabled(hw);
> +
> +       if (state) {
> +               if (pll->lock)
> +                       spin_unlock_irqrestore(pll->lock, flags);
> +
> +               clk_pll_disable(hw);
> +               val &= ~(PLL_BASE_BYPASS | PLL_BASE_ENABLE);
> +
> +               if (pll->lock)
> +                       spin_lock_irqsave(pll->lock, flags);
> +       }
> +       pll_writel_base(val, pll);
> +
> +       if (pll->flags & TEGRA_PLL_HAS_CPCON) {
> +               val = pll_readl_misc(pll);
> +               val &= ~(PLL_MISC_CPCON_MASK << PLL_MISC_CPCON_SHIFT);
> +               val |= cfg->cpcon << PLL_MISC_CPCON_SHIFT;
> +               if (pll->flags & TEGRA_PLL_SET_LFCON) {
> +                       val &= ~(PLL_MISC_LFCON_MASK << PLL_MISC_LFCON_SHIFT);
> +                       if (cfg->n >= PLLDU_LFCON_SET_DIVN)
> +                               val |= 0x1 << PLL_MISC_LFCON_SHIFT;
> +               } else if (pll->flags & TEGRA_PLL_SET_DCCON) {
> +                       val &= ~(0x1 << PLL_MISC_DCCON_SHIFT);
> +                       if (rate >= (pll->params->vco_max >> 1))
> +                               val |= 0x1 << PLL_MISC_DCCON_SHIFT;
> +               }
> +               pll_writel_misc(val, pll);
> +       }
> +
> +       if (pll->lock)
> +               spin_unlock_irqrestore(pll->lock, flags);
> +
> +       if (state)
> +               clk_pll_enable(hw);
> +
> +       return 0;
> +}
> +
> +static int clk_pll_set_rate(struct clk_hw *hw, unsigned long rate,
> +                       unsigned long parent_rate)
> +{
> +       struct tegra_clk_pll *pll = to_clk_pll(hw);
> +       struct tegra_clk_pll_freq_table cfg;
> +
> +       if (pll->flags & TEGRA_PLL_FIXED) {
> +               if (rate != pll->fixed_rate) {
> +                       pr_err("%s: Can not change %s fixed rate %lu to %lu\n",
> +                               __func__, __clk_get_name(hw->clk),
> +                               pll->fixed_rate, rate);
> +                       return -EINVAL;
> +               }
> +               return 0;
> +       }
> +
> +       if (_get_table_rate(hw, &cfg, rate, parent_rate) &&
> +           _calc_rate(hw, &cfg, rate, parent_rate))
> +               return -EINVAL;
> +
> +       return _program_pll(hw, &cfg, rate);
> +}
> +
> +static long clk_pll_round_rate(struct clk_hw *hw, unsigned long rate,
> +                       unsigned long *prate)
> +{
> +       struct tegra_clk_pll *pll = to_clk_pll(hw);
> +       struct tegra_clk_pll_freq_table cfg;
> +       u64 output_rate = *prate;
> +
> +       if (pll->flags & TEGRA_PLL_FIXED)
> +               return pll->fixed_rate;
> +
> +       /* PLLM is used for memory; we do not change rate */
> +       if (pll->flags & TEGRA_PLLM)
> +               return __clk_get_rate(hw->clk);
> +
> +       if (_get_table_rate(hw, &cfg, rate, *prate) &&
> +           _calc_rate(hw, &cfg, rate, *prate))
> +               return -EINVAL;
> +
> +       output_rate *= cfg.n;
> +       do_div(output_rate, cfg.m * cfg.p);
> +
> +       return output_rate;
> +}
> +
> +static unsigned long clk_pll_recalc_rate(struct clk_hw *hw,
> +                                        unsigned long parent_rate)
> +{
> +       struct tegra_clk_pll *pll = to_clk_pll(hw);
> +       u32 val = pll_readl_base(pll);
> +       u32 divn = 0, divm = 0, divp = 0;
> +       u64 rate = parent_rate;
> +
> +       if (val & PLL_BASE_BYPASS)
> +               return parent_rate;
> +
> +       if ((pll->flags & TEGRA_PLL_FIXED) && !(val & PLL_BASE_OVERRIDE)) {
> +               struct tegra_clk_pll_freq_table sel;
> +               if (_get_table_rate(hw, &sel, pll->fixed_rate, parent_rate)) {
> +                       pr_err("Clock %s has unknown fixed frequency\n",
> +                              __clk_get_name(hw->clk));
> +                       BUG();
> +               }
> +               return pll->fixed_rate;
> +       }
> +
> +       divp = (val >> pll->divp_shift) & (divp_mask(pll));
> +       if (pll->flags & TEGRA_PLLU)
> +               divp ^= 1;
> +
> +       divn = (val >> pll->divn_shift) & (divn_mask(pll));
> +       divm = (val >> pll->divm_shift) & (divm_mask(pll));
> +       divm *= (1 << divp);
> +
> +       rate *= divn;
> +       do_div(rate, divm);
> +       return rate;
> +}
> +
> +static int clk_plle_training(struct tegra_clk_pll *pll)
> +{
> +       u32 val;
> +       int timeout;
> +
> +       if (!pll->pmc)
> +               return -ENOSYS;
> +
> +       /*
> +        * PLLE is already disabled, and setup cleared;
> +        * create falling edge on PLLE IDDQ input.
> +        */
> +       val = readl(pll->pmc + PMC_SATA_PWRGT);
> +       val |= PMC_SATA_PWRGT_PLLE_IDDQ_VALUE;
> +       writel(val, pll->pmc + PMC_SATA_PWRGT);
> +
> +       val = readl(pll->pmc + PMC_SATA_PWRGT);
> +       val |= PMC_SATA_PWRGT_PLLE_IDDQ_SWCTL;
> +       writel(val, pll->pmc + PMC_SATA_PWRGT);
> +
> +       val = readl(pll->pmc + PMC_SATA_PWRGT);
> +       val &= ~PMC_SATA_PWRGT_PLLE_IDDQ_VALUE;
> +       writel(val, pll->pmc + PMC_SATA_PWRGT);
> +
> +       val = pll_readl_misc(pll);
> +
> +       timeout = 300;
> +       while (!(val & PLLE_MISC_READY)) {
> +               val = pll_readl_misc(pll);
> +               udelay(300);
> +               if (--timeout == 0) {
> +                       pr_err("%s: timeout waiting for PLLE\n", __func__);
> +                       return -EBUSY;
> +               }
> +       }

Can the above be written as below?

timeout = jiffies + msecs_to_jiffies(100);
while (1) {
        val = pll_readl_misc(pll);
        if (val & PLLE_MISC_READY)
                break;
        if (time_after(jiffies, timeout)) {
                pr_err("%s: timeout waiting for PLLE\n", __func__);
                return -EBUSY;
        }
        udelay(300);
}
