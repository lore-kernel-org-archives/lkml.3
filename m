Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752016AbaDYPbi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 11:31:38 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:47894 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751334AbaDYPbg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 11:31:36 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Maxime COQUELIN <maxime.coquelin@st.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1391012648-12481-2-git-send-email-maxime.coquelin@st.com>
Cc: kernel@stlinux.com, maxime.coquelin@st.com
References: <1391012648-12481-1-git-send-email-maxime.coquelin@st.com>
 <1391012648-12481-2-git-send-email-maxime.coquelin@st.com>
Message-ID: <20140425153126.23156.76868@quantum>
User-Agent: alot/0.3.5
Subject: Re: [PATCH 1/3] clk: divider: Fix best div calculation for power-of-two and
 table dividers
Date: Fri, 25 Apr 2014 08:31:26 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Maxime COQUELIN (2014-01-29 08:24:06)
> The divider returned by clk_divider_bestdiv() is likely to be invalid in case
> of power-of-two and table dividers when CLK_SET_RATE_PARENT flag isn't set.
> 
> Signed-off-by: Maxime Coquelin <maxime.coquelin@st.com>

I've taken this into clk-fixes for 3.15-rcX.

Thanks,
Mike

> ---
>  drivers/clk/clk-divider.c |   37 ++++++++++++++++++++++++++++++++++++-
>  1 file changed, 36 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/clk/clk-divider.c b/drivers/clk/clk-divider.c
> index 5543b7d..2137d58 100644
> --- a/drivers/clk/clk-divider.c
> +++ b/drivers/clk/clk-divider.c
> @@ -144,6 +144,37 @@ static bool _is_valid_div(struct clk_divider *divider, unsigned int div)
>         return true;
>  }
>  
> +static int _round_up_table(const struct clk_div_table *table, int div)
> +{
> +       const struct clk_div_table *clkt;
> +       int up = _get_table_maxdiv(table);
> +
> +       for (clkt = table; clkt->div; clkt++) {
> +               if (clkt->div == div)
> +                       return clkt->div;
> +               else if (clkt->div < div)
> +                       continue;
> +
> +               if ((clkt->div - div) < (up - div))
> +                       up = clkt->div;
> +       }
> +
> +       return up;
> +}
> +
> +static int _div_round_up(struct clk_divider *divider,
> +               unsigned long parent_rate, unsigned long rate)
> +{
> +       int div = DIV_ROUND_UP(parent_rate, rate);
> +
> +       if (divider->flags & CLK_DIVIDER_POWER_OF_TWO)
> +               div = __roundup_pow_of_two(div);
> +       if (divider->table)
> +               div = _round_up_table(divider->table, div);
> +
> +       return div;
> +}
> +
>  static int clk_divider_bestdiv(struct clk_hw *hw, unsigned long rate,
>                 unsigned long *best_parent_rate)
>  {
> @@ -159,7 +190,7 @@ static int clk_divider_bestdiv(struct clk_hw *hw, unsigned long rate,
>  
>         if (!(__clk_get_flags(hw->clk) & CLK_SET_RATE_PARENT)) {
>                 parent_rate = *best_parent_rate;
> -               bestdiv = DIV_ROUND_UP(parent_rate, rate);
> +               bestdiv = _div_round_up(divider, parent_rate, rate);
>                 bestdiv = bestdiv == 0 ? 1 : bestdiv;
>                 bestdiv = bestdiv > maxdiv ? maxdiv : bestdiv;
>                 return bestdiv;
> @@ -219,6 +250,10 @@ static int clk_divider_set_rate(struct clk_hw *hw, unsigned long rate,
>         u32 val;
>  
>         div = parent_rate / rate;
> +
> +       if (!_is_valid_div(divider, div))
> +               return -EINVAL;
> +
>         value = _get_val(divider, div);
>  
>         if (value > div_mask(divider))
> -- 
> 1.7.9.5
> 
