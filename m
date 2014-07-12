Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752577AbaGLLt5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2014 07:49:57 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:60101 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752011AbaGLLty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2014 07:49:54 -0400
MIME-Version: 1.0
In-Reply-To: <1405108915-19234-1-git-send-email-sboyd@codeaurora.org>
References: <1405106207-26638-1-git-send-email-robdclark@gmail.com>
	<1405108915-19234-1-git-send-email-sboyd@codeaurora.org>
Date: Sat, 12 Jul 2014 07:49:53 -0400
Message-ID: <CAF6AEGsMcosDoXB4OE_Yfa4QM+fDxVm5rg02DVZ3Gg-30K31mw@mail.gmail.com>
Subject: Re: [PATCH] clk: qcom: Support bypass RCG configuration
From: Rob Clark <robdclark@gmail.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mike Turquette <mturquette@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2014 at 4:01 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:
> In the case of HDMI clocks, we want to bypass the RCG's ability
> to divide the output clock and pass through the parent HDMI PLL
> rate through. Add a simple set of clk_ops to configure the RCG to
> do this. This removes the need to keep adding more frequency
> entries to the tv_src clock whenever we want to support a new
> rate.
>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
>
> On 07/11, Rob Clark wrote:
>> It would probably be better to get rid of the fixed table, which
>> duplicates the set of fixed frequences in the hdmi pll clk (in
>> drm/msm/hdmi).  But I'll leave that as an exercise for someone
>> who knows the clk driver better than myself.  Until then, this
>> trivial fix is useful.
>
> Here's a quick attempt at that. Let me know if this works.

yup, this works :-)

Tested-by: Rob Clark <robdclark@gmail.com>

>  drivers/clk/qcom/clk-rcg.c      | 51 +++++++++++++++++++++++++++++++++++------
>  drivers/clk/qcom/clk-rcg.h      |  1 +
>  drivers/clk/qcom/mmcc-msm8960.c |  9 ++------
>  3 files changed, 47 insertions(+), 14 deletions(-)
>
> diff --git a/drivers/clk/qcom/clk-rcg.c b/drivers/clk/qcom/clk-rcg.c
> index abfc2b675aea..b638c5846dbf 100644
> --- a/drivers/clk/qcom/clk-rcg.c
> +++ b/drivers/clk/qcom/clk-rcg.c
> @@ -417,20 +417,25 @@ static long clk_dyn_rcg_determine_rate(struct clk_hw *hw, unsigned long rate,
>         return _freq_tbl_determine_rate(hw, rcg->freq_tbl, rate, p_rate, p);
>  }
>
> -static int clk_rcg_set_rate(struct clk_hw *hw, unsigned long rate,
> -                           unsigned long parent_rate)
> +static long clk_rcg_bypass_determine_rate(struct clk_hw *hw, unsigned long rate,
> +               unsigned long *p_rate, struct clk **p)
>  {
>         struct clk_rcg *rcg = to_clk_rcg(hw);
> -       const struct freq_tbl *f;
> +       const struct freq_tbl *f = rcg->freq_tbl;
> +
> +       *p = clk_get_parent_by_index(hw->clk, f->src);
> +       *p_rate = __clk_round_rate(*p, rate);
> +
> +       return *p_rate;
> +}
> +
> +static int __clk_rcg_set_rate(struct clk_rcg *rcg, const struct freq_tbl *f)
> +{
>         u32 ns, md, ctl;
>         struct mn *mn = &rcg->mn;
>         u32 mask = 0;
>         unsigned int reset_reg;
>
> -       f = find_freq(rcg->freq_tbl, rate);
> -       if (!f)
> -               return -EINVAL;
> -
>         if (rcg->mn.reset_in_cc)
>                 reset_reg = rcg->clkr.enable_reg;
>         else
> @@ -466,6 +471,27 @@ static int clk_rcg_set_rate(struct clk_hw *hw, unsigned long rate,
>         return 0;
>  }
>
> +static int clk_rcg_set_rate(struct clk_hw *hw, unsigned long rate,
> +                           unsigned long parent_rate)
> +{
> +       struct clk_rcg *rcg = to_clk_rcg(hw);
> +       const struct freq_tbl *f;
> +
> +       f = find_freq(rcg->freq_tbl, rate);
> +       if (!f)
> +               return -EINVAL;
> +
> +       return __clk_rcg_set_rate(rcg, f);
> +}
> +
> +static int clk_rcg_bypass_set_rate(struct clk_hw *hw, unsigned long rate,
> +                               unsigned long parent_rate)
> +{
> +       struct clk_rcg *rcg = to_clk_rcg(hw);
> +
> +       return __clk_rcg_set_rate(rcg, rcg->freq_tbl);
> +}
> +
>  static int __clk_dyn_rcg_set_rate(struct clk_hw *hw, unsigned long rate)
>  {
>         struct clk_dyn_rcg *rcg = to_clk_dyn_rcg(hw);
> @@ -503,6 +529,17 @@ const struct clk_ops clk_rcg_ops = {
>  };
>  EXPORT_SYMBOL_GPL(clk_rcg_ops);
>
> +const struct clk_ops clk_rcg_bypass_ops = {
> +       .enable = clk_enable_regmap,
> +       .disable = clk_disable_regmap,
> +       .get_parent = clk_rcg_get_parent,
> +       .set_parent = clk_rcg_set_parent,
> +       .recalc_rate = clk_rcg_recalc_rate,
> +       .determine_rate = clk_rcg_bypass_determine_rate,
> +       .set_rate = clk_rcg_bypass_set_rate,
> +};
> +EXPORT_SYMBOL_GPL(clk_rcg_bypass_ops);
> +
>  const struct clk_ops clk_dyn_rcg_ops = {
>         .enable = clk_enable_regmap,
>         .is_enabled = clk_is_enabled_regmap,
> diff --git a/drivers/clk/qcom/clk-rcg.h b/drivers/clk/qcom/clk-rcg.h
> index b9ec11dfd1b4..ba0523cefd2e 100644
> --- a/drivers/clk/qcom/clk-rcg.h
> +++ b/drivers/clk/qcom/clk-rcg.h
> @@ -95,6 +95,7 @@ struct clk_rcg {
>  };
>
>  extern const struct clk_ops clk_rcg_ops;
> +extern const struct clk_ops clk_rcg_bypass_ops;
>
>  #define to_clk_rcg(_hw) container_of(to_clk_regmap(_hw), struct clk_rcg, clkr)
>
> diff --git a/drivers/clk/qcom/mmcc-msm8960.c b/drivers/clk/qcom/mmcc-msm8960.c
> index 12f3c0b64fcd..14eeeba005f3 100644
> --- a/drivers/clk/qcom/mmcc-msm8960.c
> +++ b/drivers/clk/qcom/mmcc-msm8960.c
> @@ -1218,12 +1218,7 @@ static const char *mmcc_pxo_hdmi[] = {
>  };
>
>  static struct freq_tbl clk_tbl_tv[] = {
> -       {  25200000, P_HDMI_PLL, 1, 0, 0 },
> -       {  27000000, P_HDMI_PLL, 1, 0, 0 },
> -       {  27030000, P_HDMI_PLL, 1, 0, 0 },
> -       {  74250000, P_HDMI_PLL, 1, 0, 0 },
> -       { 108000000, P_HDMI_PLL, 1, 0, 0 },
> -       { 148500000, P_HDMI_PLL, 1, 0, 0 },
> +       {  .src = P_HDMI_PLL, .pre_div = 1 },
>         { }
>  };
>
> @@ -1254,7 +1249,7 @@ static struct clk_rcg tv_src = {
>                         .name = "tv_src",
>                         .parent_names = mmcc_pxo_hdmi,
>                         .num_parents = 2,
> -                       .ops = &clk_rcg_ops,
> +                       .ops = &clk_rcg_bypass_ops,
>                         .flags = CLK_SET_RATE_PARENT,
>                 },
>         },
> --
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> hosted by The Linux Foundation
>
