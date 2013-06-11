Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756046Ab3FKXpZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 19:45:25 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:45098 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753011Ab3FKXpX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 19:45:23 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Peter De Schrijver <pdeschrijver@nvidia.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1370437007-25596-1-git-send-email-pdeschrijver@nvidia.com>
Cc: <linux-arm-kernel@lists.infradead.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Prashant Gaikwad <pgaikwad@nvidia.com>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <1370437007-25596-1-git-send-email-pdeschrijver@nvidia.com>
Message-ID: <20130611234519.8816.35380@quantum>
User-Agent: alot/0.3.4
Subject: Re: [PATCH] clk: tegra: pllc and pllxc should use pdiv_map
Date: Tue, 11 Jun 2013 16:45:19 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Peter De Schrijver (2013-06-05 05:56:41)
> The pllc and pllxc code weren't always using the correct pdiv_map to
> map between the post divider value and the hw p field. This could result
> in illegal values being programmed in the hw.
> 
> Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>

Taken into clk-next.

Regards,
Mike

> ---
>  drivers/clk/tegra/clk-pll.c |  162 ++++++++++++++++++++++---------------------
>  1 files changed, 82 insertions(+), 80 deletions(-)
> 
> diff --git a/drivers/clk/tegra/clk-pll.c b/drivers/clk/tegra/clk-pll.c
> index 17c2cc0..85bec1d 100644
> --- a/drivers/clk/tegra/clk-pll.c
> +++ b/drivers/clk/tegra/clk-pll.c
> @@ -143,24 +143,6 @@
>  #define divn_max(p) (divn_mask(p))
>  #define divp_max(p) (1 << (divp_mask(p)))
>  
> -
> -#ifdef CONFIG_ARCH_TEGRA_114_SOC
> -/* PLLXC has 4-bit PDIV, but entry 15 is not allowed in h/w */
> -#define PLLXC_PDIV_MAX                 14
> -
> -/* non-monotonic mapping below is not a typo */
> -static u8 pllxc_p[PLLXC_PDIV_MAX + 1] = {
> -       /* PDIV: 0, 1, 2, 3, 4, 5, 6,  7,  8,  9, 10, 11, 12, 13, 14 */
> -       /* p: */ 1, 2, 3, 4, 5, 6, 8, 10, 12, 16, 12, 16, 20, 24, 32
> -};
> -
> -#define PLLCX_PDIV_MAX 7
> -static u8 pllcx_p[PLLCX_PDIV_MAX + 1] = {
> -       /* PDIV: 0, 1, 2, 3, 4, 5,  6,  7 */
> -       /* p: */ 1, 2, 3, 4, 6, 8, 12, 16
> -};
> -#endif
> -
>  static void clk_pll_enable_lock(struct tegra_clk_pll *pll)
>  {
>         u32 val;
> @@ -297,6 +279,39 @@ static void clk_pll_disable(struct clk_hw *hw)
>                 spin_unlock_irqrestore(pll->lock, flags);
>  }
>  
> +static int _p_div_to_hw(struct clk_hw *hw, u8 p_div)
> +{
> +       struct tegra_clk_pll *pll = to_clk_pll(hw);
> +       struct pdiv_map *p_tohw = pll->params->pdiv_tohw;
> +
> +       if (p_tohw) {
> +               while (p_tohw->pdiv) {
> +                       if (p_div <= p_tohw->pdiv)
> +                               return p_tohw->hw_val;
> +                       p_tohw++;
> +               }
> +               return -EINVAL;
> +       }
> +       return -EINVAL;
> +}
> +
> +static int _hw_to_p_div(struct clk_hw *hw, u8 p_div_hw)
> +{
> +       struct tegra_clk_pll *pll = to_clk_pll(hw);
> +       struct pdiv_map *p_tohw = pll->params->pdiv_tohw;
> +
> +       if (p_tohw) {
> +               while (p_tohw->pdiv) {
> +                       if (p_div_hw == p_tohw->hw_val)
> +                               return p_tohw->pdiv;
> +                       p_tohw++;
> +               }
> +               return -EINVAL;
> +       }
> +
> +       return 1 << p_div_hw;
> +}
> +
>  static int _get_table_rate(struct clk_hw *hw,
>                            struct tegra_clk_pll_freq_table *cfg,
>                            unsigned long rate, unsigned long parent_rate)
> @@ -326,9 +341,9 @@ static int _calc_rate(struct clk_hw *hw, struct tegra_clk_pll_freq_table *cfg,
>                       unsigned long rate, unsigned long parent_rate)
>  {
>         struct tegra_clk_pll *pll = to_clk_pll(hw);
> -       struct pdiv_map *p_tohw = pll->params->pdiv_tohw;
>         unsigned long cfreq;
>         u32 p_div = 0;
> +       int ret;
>  
>         switch (parent_rate) {
>         case 12000000:
> @@ -369,20 +384,16 @@ static int _calc_rate(struct clk_hw *hw, struct tegra_clk_pll_freq_table *cfg,
>             || cfg->output_rate > pll->params->vco_max) {
>                 pr_err("%s: Failed to set %s rate %lu\n",
>                        __func__, __clk_get_name(hw->clk), rate);
> +               WARN_ON(1);
>                 return -EINVAL;
>         }
>  
> -       if (p_tohw) {
> -               p_div = 1 << p_div;
> -               while (p_tohw->pdiv) {
> -                       if (p_div <= p_tohw->pdiv) {
> -                               cfg->p = p_tohw->hw_val;
> -                               break;
> -                       }
> -                       p_tohw++;
> -               }
> -               if (!p_tohw->pdiv)
> -                       return -EINVAL;
> +       if (pll->params->pdiv_tohw) {
> +               ret = _p_div_to_hw(hw, 1 << p_div);
> +               if (ret < 0)
> +                       return ret;
> +               else
> +                       cfg->p = ret;
>         } else
>                 cfg->p = p_div;
>  
> @@ -485,9 +496,10 @@ static int clk_pll_set_rate(struct clk_hw *hw, unsigned long rate,
>         }
>  
>         if (_get_table_rate(hw, &cfg, rate, parent_rate) &&
> -           _calc_rate(hw, &cfg, rate, parent_rate))
> +           _calc_rate(hw, &cfg, rate, parent_rate)) {
> +               WARN_ON(1);
>                 return -EINVAL;
> -
> +       }
>         if (pll->lock)
>                 spin_lock_irqsave(pll->lock, flags);
>  
> @@ -507,7 +519,6 @@ static long clk_pll_round_rate(struct clk_hw *hw, unsigned long rate,
>  {
>         struct tegra_clk_pll *pll = to_clk_pll(hw);
>         struct tegra_clk_pll_freq_table cfg;
> -       u64 output_rate = *prate;
>  
>         if (pll->flags & TEGRA_PLL_FIXED)
>                 return pll->fixed_rate;
> @@ -517,13 +528,12 @@ static long clk_pll_round_rate(struct clk_hw *hw, unsigned long rate,
>                 return __clk_get_rate(hw->clk);
>  
>         if (_get_table_rate(hw, &cfg, rate, *prate) &&
> -           _calc_rate(hw, &cfg, rate, *prate))
> +           _calc_rate(hw, &cfg, rate, *prate)) {
> +               WARN_ON(1);
>                 return -EINVAL;
> +       }
>  
> -       output_rate *= cfg.n;
> -       do_div(output_rate, cfg.m * (1 << cfg.p));
> -
> -       return output_rate;
> +       return cfg.output_rate;
>  }
>  
>  static unsigned long clk_pll_recalc_rate(struct clk_hw *hw,
> @@ -531,7 +541,6 @@ static unsigned long clk_pll_recalc_rate(struct clk_hw *hw,
>  {
>         struct tegra_clk_pll *pll = to_clk_pll(hw);
>         struct tegra_clk_pll_freq_table cfg;
> -       struct pdiv_map *p_tohw = pll->params->pdiv_tohw;
>         u32 val;
>         u64 rate = parent_rate;
>         int pdiv;
> @@ -553,21 +562,11 @@ static unsigned long clk_pll_recalc_rate(struct clk_hw *hw,
>  
>         _get_pll_mnp(pll, &cfg);
>  
> -       if (p_tohw) {
> -               while (p_tohw->pdiv) {
> -                       if (cfg.p == p_tohw->hw_val) {
> -                               pdiv = p_tohw->pdiv;
> -                               break;
> -                       }
> -                       p_tohw++;
> -               }
> -
> -               if (!p_tohw->pdiv) {
> -                       WARN_ON(1);
> -                       pdiv = 1;
> -               }
> -       } else
> -               pdiv = 1 << cfg.p;
> +       pdiv = _hw_to_p_div(hw, cfg.p);
> +       if (pdiv < 0) {
> +               WARN_ON(1);
> +               pdiv = 1;
> +       }
>  
>         cfg.m *= pdiv;
>  
> @@ -769,16 +768,22 @@ static int _calc_dynamic_ramp_rate(struct clk_hw *hw,
>  {
>         struct tegra_clk_pll *pll = to_clk_pll(hw);
>         unsigned int p;
> +       int p_div;
>  
>         if (!rate)
>                 return -EINVAL;
>  
>         p = DIV_ROUND_UP(pll->params->vco_min, rate);
>         cfg->m = _pll_fixed_mdiv(pll->params, parent_rate);
> -       cfg->p = p;
> -       cfg->output_rate = rate * cfg->p;
> +       cfg->output_rate = rate * p;
>         cfg->n = cfg->output_rate * cfg->m / parent_rate;
>  
> +       p_div = _p_div_to_hw(hw, p);
> +       if (p_div < 0)
> +               return p_div;
> +       else
> +               cfg->p = p_div;
> +
>         if (cfg->n > divn_max(pll) || cfg->output_rate > pll->params->vco_max)
>                 return -EINVAL;
>  
> @@ -790,18 +795,25 @@ static int _pll_ramp_calc_pll(struct clk_hw *hw,
>                               unsigned long rate, unsigned long parent_rate)
>  {
>         struct tegra_clk_pll *pll = to_clk_pll(hw);
> -       int err = 0;
> +       int err = 0, p_div;
>  
>         err = _get_table_rate(hw, cfg, rate, parent_rate);
>         if (err < 0)
>                 err = _calc_dynamic_ramp_rate(hw, cfg, rate, parent_rate);
> -       else if (cfg->m != _pll_fixed_mdiv(pll->params, parent_rate)) {
> +       else {
> +               if (cfg->m != _pll_fixed_mdiv(pll->params, parent_rate)) {
>                         WARN_ON(1);
>                         err = -EINVAL;
>                         goto out;
> +               }
> +               p_div = _p_div_to_hw(hw, cfg->p);
> +               if (p_div < 0)
> +                       return p_div;
> +               else
> +                       cfg->p = p_div;
>         }
>  
> -       if (!cfg->p || (cfg->p >  pll->params->max_p))
> +       if (cfg->p >  pll->params->max_p)
>                 err = -EINVAL;
>  
>  out:
> @@ -815,7 +827,6 @@ static int clk_pllxc_set_rate(struct clk_hw *hw, unsigned long rate,
>         struct tegra_clk_pll_freq_table cfg, old_cfg;
>         unsigned long flags = 0;
>         int ret = 0;
> -       u8 old_p;
>  
>         ret = _pll_ramp_calc_pll(hw, &cfg, rate, parent_rate);
>         if (ret < 0)
> @@ -826,11 +837,8 @@ static int clk_pllxc_set_rate(struct clk_hw *hw, unsigned long rate,
>  
>         _get_pll_mnp(pll, &old_cfg);
>  
> -       old_p = pllxc_p[old_cfg.p];
> -       if (old_cfg.m != cfg.m || old_cfg.n != cfg.n || old_p != cfg.p) {
> -               cfg.p -= 1;
> +       if (old_cfg.m != cfg.m || old_cfg.n != cfg.n || old_cfg.p != cfg.p)
>                 ret = _program_pll(hw, &cfg, rate);
> -       }
>  
>         if (pll->lock)
>                 spin_unlock_irqrestore(pll->lock, flags);
> @@ -842,15 +850,19 @@ static long clk_pll_ramp_round_rate(struct clk_hw *hw, unsigned long rate,
>                                 unsigned long *prate)
>  {
>         struct tegra_clk_pll_freq_table cfg;
> -       int ret = 0;
> +       int ret = 0, p_div;
>         u64 output_rate = *prate;
>  
>         ret = _pll_ramp_calc_pll(hw, &cfg, rate, *prate);
>         if (ret < 0)
>                 return ret;
>  
> +       p_div = _hw_to_p_div(hw, cfg.p);
> +       if (p_div < 0)
> +               return p_div;
> +
>         output_rate *= cfg.n;
> -       do_div(output_rate, cfg.m * cfg.p);
> +       do_div(output_rate, cfg.m * p_div);
>  
>         return output_rate;
>  }
> @@ -881,8 +893,6 @@ static int clk_pllm_set_rate(struct clk_hw *hw, unsigned long rate,
>         if (ret < 0)
>                 goto out;
>  
> -       cfg.p -= 1;
> -
>         val = readl_relaxed(pll->pmc + PMC_PLLM_WB0_OVERRIDE);
>         if (val & PMC_PLLP_WB0_OVERRIDE_PLLM_OVERRIDE) {
>                 val = readl_relaxed(pll->pmc + PMC_PLLM_WB0_OVERRIDE_2);
> @@ -1010,13 +1020,10 @@ static int _pllcx_update_dynamic_coef(struct tegra_clk_pll *pll,
>  static int clk_pllc_set_rate(struct clk_hw *hw, unsigned long rate,
>                                 unsigned long parent_rate)
>  {
> -       struct tegra_clk_pll_freq_table cfg;
> +       struct tegra_clk_pll_freq_table cfg, old_cfg;
>         struct tegra_clk_pll *pll = to_clk_pll(hw);
>         unsigned long flags = 0;
>         int state, ret = 0;
> -       u32 val;
> -       u16 old_m, old_n;
> -       u8 old_p;
>  
>         if (pll->lock)
>                 spin_lock_irqsave(pll->lock, flags);
> @@ -1025,21 +1032,16 @@ static int clk_pllc_set_rate(struct clk_hw *hw, unsigned long rate,
>         if (ret < 0)
>                 goto out;
>  
> -       val = pll_readl_base(pll);
> -       old_m = (val >> pll->divm_shift) & (divm_mask(pll));
> -       old_n = (val >> pll->divn_shift) & (divn_mask(pll));
> -       old_p = pllcx_p[(val >> pll->divp_shift) & (divp_mask(pll))];
> +       _get_pll_mnp(pll, &old_cfg);
>  
> -       if (cfg.m != old_m) {
> +       if (cfg.m != old_cfg.m) {
>                 WARN_ON(1);
>                 goto out;
>         }
>  
> -       if (old_n == cfg.n && old_p == cfg.p)
> +       if (old_cfg.n == cfg.n && old_cfg.p == cfg.p)
>                 goto out;
>  
> -       cfg.p -= 1;
> -
>         state = clk_pll_is_enabled(hw);
>         if (state)
>                 _clk_pllc_disable(hw);
> -- 
> 1.7.7.rc0.72.g4b5ea.dirty
