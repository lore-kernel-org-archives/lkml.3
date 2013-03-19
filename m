Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934270Ab3CSVd0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 17:33:26 -0400
Received: from mail-da0-f49.google.com ([209.85.210.49]:35815 "EHLO
	mail-da0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933867Ab3CSVdY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 17:33:24 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Peter De Schrijver <pdeschrijver@nvidia.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1363113747-6572-1-git-send-email-pdeschrijver@nvidia.com>
Cc: <linux-tegra@vger.kernel.org>, Stephen Warren <swarren@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
References: <1363113747-6572-1-git-send-email-pdeschrijver@nvidia.com>
Message-ID: <20130319213309.8663.17375@quantum>
User-Agent: alot/0.3.3+
Subject: Re: [PATCH] clk: add table lookup to mux
Date: Tue, 19 Mar 2013 14:33:09 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Peter De Schrijver (2013-03-12 11:42:23)
> Add a table lookup feature to the mux clock. Also allow arbitrary masks
> instead of the width. This will be used by some clocks on Tegra114. Also
> adapt the tegra periph clk because it uses struct clk_mux directly.
> 
> Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>

Do you actually need arbitrary masks instead of a continuous bitfield?
Or does this change just make it easier for you to convert existing
data?

Thanks,
Mike

> 
> --
> Mike,
> 
> This is the same patch I posted before which implements a table lookup
> feature for the mux clock. I squashed both the changes to clk-mux.c and
> tegra/clk.h together in order to make the patch bisectable.
> 
> Thanks,
> 
> Peter.
> ---
>  drivers/clk/clk-mux.c        |   50 ++++++++++++++++++++++++++++++++----------
>  drivers/clk/tegra/clk.h      |   27 ++++++++++++++++-------
>  include/linux/clk-private.h  |    3 ++-
>  include/linux/clk-provider.h |    9 +++++++-
>  4 files changed, 68 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/clk/clk-mux.c b/drivers/clk/clk-mux.c
> index 508c032..25b1734 100644
> --- a/drivers/clk/clk-mux.c
> +++ b/drivers/clk/clk-mux.c
> @@ -32,6 +32,7 @@
>  static u8 clk_mux_get_parent(struct clk_hw *hw)
>  {
>         struct clk_mux *mux = to_clk_mux(hw);
> +       int num_parents = __clk_get_num_parents(hw->clk);
>         u32 val;
>  
>         /*
> @@ -42,7 +43,16 @@ static u8 clk_mux_get_parent(struct clk_hw *hw)
>          * val = 0x4 really means "bit 2, index starts at bit 0"
>          */
>         val = readl(mux->reg) >> mux->shift;
> -       val &= (1 << mux->width) - 1;
> +       val &= mux->mask;
> +
> +       if (mux->table) {
> +               int i;
> +
> +               for (i = 0; i < num_parents; i++)
> +                       if (mux->table[i] == val)
> +                               return i;
> +               return -EINVAL;
> +       }
>  
>         if (val && (mux->flags & CLK_MUX_INDEX_BIT))
>                 val = ffs(val) - 1;
> @@ -50,7 +60,7 @@ static u8 clk_mux_get_parent(struct clk_hw *hw)
>         if (val && (mux->flags & CLK_MUX_INDEX_ONE))
>                 val--;
>  
> -       if (val >= __clk_get_num_parents(hw->clk))
> +       if (val >= num_parents)
>                 return -EINVAL;
>  
>         return val;
> @@ -62,17 +72,22 @@ static int clk_mux_set_parent(struct clk_hw *hw, u8 index)
>         u32 val;
>         unsigned long flags = 0;
>  
> -       if (mux->flags & CLK_MUX_INDEX_BIT)
> -               index = (1 << ffs(index));
> +       if (mux->table)
> +               index = mux->table[index];
>  
> -       if (mux->flags & CLK_MUX_INDEX_ONE)
> -               index++;
> +       else {
> +               if (mux->flags & CLK_MUX_INDEX_BIT)
> +                       index = (1 << ffs(index));
> +
> +               if (mux->flags & CLK_MUX_INDEX_ONE)
> +                       index++;
> +       }
>  
>         if (mux->lock)
>                 spin_lock_irqsave(mux->lock, flags);
>  
>         val = readl(mux->reg);
> -       val &= ~(((1 << mux->width) - 1) << mux->shift);
> +       val &= ~(mux->mask << mux->shift);
>         val |= index << mux->shift;
>         writel(val, mux->reg);
>  
> @@ -88,10 +103,10 @@ const struct clk_ops clk_mux_ops = {
>  };
>  EXPORT_SYMBOL_GPL(clk_mux_ops);
>  
> -struct clk *clk_register_mux(struct device *dev, const char *name,
> +struct clk *clk_register_mux_table(struct device *dev, const char *name,
>                 const char **parent_names, u8 num_parents, unsigned long flags,
> -               void __iomem *reg, u8 shift, u8 width,
> -               u8 clk_mux_flags, spinlock_t *lock)
> +               void __iomem *reg, u8 shift, u32 mask,
> +               u8 clk_mux_flags, u32 *table, spinlock_t *lock)
>  {
>         struct clk_mux *mux;
>         struct clk *clk;
> @@ -113,9 +128,10 @@ struct clk *clk_register_mux(struct device *dev, const char *name,
>         /* struct clk_mux assignments */
>         mux->reg = reg;
>         mux->shift = shift;
> -       mux->width = width;
> +       mux->mask = mask;
>         mux->flags = clk_mux_flags;
>         mux->lock = lock;
> +       mux->table = table;
>         mux->hw.init = &init;
>  
>         clk = clk_register(dev, &mux->hw);
> @@ -125,3 +141,15 @@ struct clk *clk_register_mux(struct device *dev, const char *name,
>  
>         return clk;
>  }
> +
> +struct clk *clk_register_mux(struct device *dev, const char *name,
> +               const char **parent_names, u8 num_parents, unsigned long flags,
> +               void __iomem *reg, u8 shift, u8 width,
> +               u8 clk_mux_flags, spinlock_t *lock)
> +{
> +       u32 mask = BIT(width) - 1;
> +
> +       return clk_register_mux_table(dev, name, parent_names, num_parents,
> +                                     flags, reg, shift, mask, clk_mux_flags,
> +                                     NULL, lock);
> +}
> diff --git a/drivers/clk/tegra/clk.h b/drivers/clk/tegra/clk.h
> index 0744731..a09d7dc 100644
> --- a/drivers/clk/tegra/clk.h
> +++ b/drivers/clk/tegra/clk.h
> @@ -355,15 +355,16 @@ struct clk *tegra_clk_register_periph_nodiv(const char *name,
>                 struct tegra_clk_periph *periph, void __iomem *clk_base,
>                 u32 offset);
>  
> -#define TEGRA_CLK_PERIPH(_mux_shift, _mux_width, _mux_flags,           \
> +#define TEGRA_CLK_PERIPH(_mux_shift, _mux_mask, _mux_flags,            \
>                          _div_shift, _div_width, _div_frac_width,       \
>                          _div_flags, _clk_num, _enb_refcnt, _regs,      \
> -                        _gate_flags)                                   \
> +                        _gate_flags, _table)                           \
>         {                                                               \
>                 .mux = {                                                \
>                         .flags = _mux_flags,                            \
>                         .shift = _mux_shift,                            \
> -                       .width = _mux_width,                            \
> +                       .mask = _mux_mask,                              \
> +                       .table = _table,                                \
>                 },                                                      \
>                 .divider = {                                            \
>                         .flags = _div_flags,                            \
> @@ -393,26 +394,36 @@ struct tegra_periph_init_data {
>         const char *dev_id;
>  };
>  
> -#define TEGRA_INIT_DATA(_name, _con_id, _dev_id, _parent_names, _offset, \
> -                       _mux_shift, _mux_width, _mux_flags, _div_shift, \
> +#define TEGRA_INIT_DATA_TABLE(_name, _con_id, _dev_id, _parent_names, _offset,\
> +                       _mux_shift, _mux_mask, _mux_flags, _div_shift,  \
>                         _div_width, _div_frac_width, _div_flags, _regs, \
> -                       _clk_num, _enb_refcnt, _gate_flags, _clk_id)    \
> +                       _clk_num, _enb_refcnt, _gate_flags, _clk_id, _table) \
>         {                                                               \
>                 .name = _name,                                          \
>                 .clk_id = _clk_id,                                      \
>                 .parent_names = _parent_names,                          \
>                 .num_parents = ARRAY_SIZE(_parent_names),               \
> -               .periph = TEGRA_CLK_PERIPH(_mux_shift, _mux_width,      \
> +               .periph = TEGRA_CLK_PERIPH(_mux_shift, _mux_mask,       \
>                                            _mux_flags, _div_shift,      \
>                                            _div_width, _div_frac_width, \
>                                            _div_flags, _clk_num,        \
>                                            _enb_refcnt, _regs,          \
> -                                          _gate_flags),                \
> +                                          _gate_flags, _table),        \
>                 .offset = _offset,                                      \
>                 .con_id = _con_id,                                      \
>                 .dev_id = _dev_id,                                      \
>         }
>  
> +#define TEGRA_INIT_DATA(_name, _con_id, _dev_id, _parent_names, _offset,\
> +                       _mux_shift, _mux_width, _mux_flags, _div_shift, \
> +                       _div_width, _div_frac_width, _div_flags, _regs, \
> +                       _clk_num, _enb_refcnt, _gate_flags, _clk_id)    \
> +       TEGRA_INIT_DATA_TABLE(_name, _con_id, _dev_id, _parent_names, _offset,\
> +                       _mux_shift, BIT(_mux_width) - 1, _mux_flags,    \
> +                       _div_shift, _div_width, _div_frac_width, _div_flags, \
> +                       _regs, _clk_num, _enb_refcnt, _gate_flags, _clk_id,\
> +                       NULL)
> +
>  /**
>   * struct clk_super_mux - super clock
>   *
> diff --git a/include/linux/clk-private.h b/include/linux/clk-private.h
> index 9c7f580..53d39c2 100644
> --- a/include/linux/clk-private.h
> +++ b/include/linux/clk-private.h
> @@ -144,12 +144,13 @@ struct clk {
>  
>  #define DEFINE_CLK_MUX(_name, _parent_names, _parents, _flags, \
>                                 _reg, _shift, _width,           \
> -                               _mux_flags, _lock)              \
> +                               _mux_flags, _table, _lock)      \
>         static struct clk _name;                                \
>         static struct clk_mux _name##_hw = {                    \
>                 .hw = {                                         \
>                         .clk = &_name,                          \
>                 },                                              \
> +               .table = _table,                                \
>                 .reg = _reg,                                    \
>                 .shift = _shift,                                \
>                 .width = _width,                                \
> diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
> index 7f197d7..fc435bb 100644
> --- a/include/linux/clk-provider.h
> +++ b/include/linux/clk-provider.h
> @@ -287,8 +287,9 @@ struct clk *clk_register_divider_table(struct device *dev, const char *name,
>  struct clk_mux {
>         struct clk_hw   hw;
>         void __iomem    *reg;
> +       u32             *table;
> +       u32             mask;
>         u8              shift;
> -       u8              width;
>         u8              flags;
>         spinlock_t      *lock;
>  };
> @@ -297,11 +298,17 @@ struct clk_mux {
>  #define CLK_MUX_INDEX_BIT              BIT(1)
>  
>  extern const struct clk_ops clk_mux_ops;
> +
>  struct clk *clk_register_mux(struct device *dev, const char *name,
>                 const char **parent_names, u8 num_parents, unsigned long flags,
>                 void __iomem *reg, u8 shift, u8 width,
>                 u8 clk_mux_flags, spinlock_t *lock);
>  
> +struct clk *clk_register_mux_table(struct device *dev, const char *name,
> +               const char **parent_names, u8 num_parents, unsigned long flags,
> +               void __iomem *reg, u8 shift, u32 mask,
> +               u8 clk_mux_flags, u32 *table, spinlock_t *lock);
> +
>  /**
>   * struct clk_fixed_factor - fixed multiplier and divider clock
>   *
> -- 
> 1.7.10.4
