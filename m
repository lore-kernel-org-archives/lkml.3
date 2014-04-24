Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758265AbaDXPhx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 11:37:53 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:55921 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757903AbaDXPhv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 11:37:51 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Maxime COQUELIN <maxime.coquelin@st.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1391012648-12481-3-git-send-email-maxime.coquelin@st.com>
Cc: kernel@stlinux.com, maxime.coquelin@st.com
References: <1391012648-12481-1-git-send-email-maxime.coquelin@st.com>
 <1391012648-12481-3-git-send-email-maxime.coquelin@st.com>
Message-ID: <20140424153742.23156.29975@quantum>
User-Agent: alot/0.3.5
Subject: Re: [PATCH 2/3] clk: divider: Add round to closest divider
Date: Thu, 24 Apr 2014 08:37:42 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Maxime COQUELIN (2014-01-29 08:24:07)
> In some cases, we want to be able to round the divider to the closest one,
> instead than rounding up.
> 
> This patch adds a new CLK_DIVIDER_ROUND_CLOSEST flag to specify the divider
> has to round to closest div, keeping rounding up as de default behaviour.

I've taken patch #2 and #3 into clk-next for 3.16.

Thanks!
Mike

> 
> Signed-off-by: Maxime Coquelin <maxime.coquelin@st.com>
> ---
>  drivers/clk/clk-divider.c    |   69 ++++++++++++++++++++++++++++++++++++++++--
>  include/linux/clk-provider.h |    3 ++
>  2 files changed, 70 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/clk/clk-divider.c b/drivers/clk/clk-divider.c
> index 2137d58..1eaa5d8 100644
> --- a/drivers/clk/clk-divider.c
> +++ b/drivers/clk/clk-divider.c
> @@ -43,6 +43,17 @@ static unsigned int _get_table_maxdiv(const struct clk_div_table *table)
>         return maxdiv;
>  }
>  
> +static unsigned int _get_table_mindiv(const struct clk_div_table *table)
> +{
> +       unsigned int mindiv = UINT_MAX;
> +       const struct clk_div_table *clkt;
> +
> +       for (clkt = table; clkt->div; clkt++)
> +               if (clkt->div < mindiv)
> +                       mindiv = clkt->div;
> +       return mindiv;
> +}
> +
>  static unsigned int _get_maxdiv(struct clk_divider *divider)
>  {
>         if (divider->flags & CLK_DIVIDER_ONE_BASED)
> @@ -162,6 +173,24 @@ static int _round_up_table(const struct clk_div_table *table, int div)
>         return up;
>  }
>  
> +static int _round_down_table(const struct clk_div_table *table, int div)
> +{
> +       const struct clk_div_table *clkt;
> +       int down = _get_table_mindiv(table);
> +
> +       for (clkt = table; clkt->div; clkt++) {
> +               if (clkt->div == div)
> +                       return clkt->div;
> +               else if (clkt->div > div)
> +                       continue;
> +
> +               if ((div - clkt->div) < (div - down))
> +                       down = clkt->div;
> +       }
> +
> +       return down;
> +}
> +
>  static int _div_round_up(struct clk_divider *divider,
>                 unsigned long parent_rate, unsigned long rate)
>  {
> @@ -175,6 +204,42 @@ static int _div_round_up(struct clk_divider *divider,
>         return div;
>  }
>  
> +static int _div_round_closest(struct clk_divider *divider,
> +               unsigned long parent_rate, unsigned long rate)
> +{
> +       int up, down, div;
> +
> +       up = down = div = DIV_ROUND_CLOSEST(parent_rate, rate);
> +
> +       if (divider->flags & CLK_DIVIDER_POWER_OF_TWO) {
> +               up = __roundup_pow_of_two(div);
> +               down = __rounddown_pow_of_two(div);
> +       } else if (divider->table) {
> +               up = _round_up_table(divider->table, div);
> +               down = _round_down_table(divider->table, div);
> +       }
> +
> +       return (up - div) <= (div - down) ? up : down;
> +}
> +
> +static int _div_round(struct clk_divider *divider, unsigned long parent_rate,
> +               unsigned long rate)
> +{
> +       if (divider->flags & CLK_DIVIDER_ROUND_CLOSEST)
> +               return _div_round_closest(divider, parent_rate, rate);
> +
> +       return _div_round_up(divider, parent_rate, rate);
> +}
> +
> +static bool _is_best_div(struct clk_divider *divider,
> +               int rate, int now, int best)
> +{
> +       if (divider->flags & CLK_DIVIDER_ROUND_CLOSEST)
> +               return abs(rate - now) < abs(rate - best);
> +
> +       return now <= rate && now > best;
> +}
> +
>  static int clk_divider_bestdiv(struct clk_hw *hw, unsigned long rate,
>                 unsigned long *best_parent_rate)
>  {
> @@ -190,7 +255,7 @@ static int clk_divider_bestdiv(struct clk_hw *hw, unsigned long rate,
>  
>         if (!(__clk_get_flags(hw->clk) & CLK_SET_RATE_PARENT)) {
>                 parent_rate = *best_parent_rate;
> -               bestdiv = _div_round_up(divider, parent_rate, rate);
> +               bestdiv = _div_round(divider, parent_rate, rate);
>                 bestdiv = bestdiv == 0 ? 1 : bestdiv;
>                 bestdiv = bestdiv > maxdiv ? maxdiv : bestdiv;
>                 return bestdiv;
> @@ -217,7 +282,7 @@ static int clk_divider_bestdiv(struct clk_hw *hw, unsigned long rate,
>                 parent_rate = __clk_round_rate(__clk_get_parent(hw->clk),
>                                 MULT_ROUND_UP(rate, i));
>                 now = parent_rate / i;
> -               if (now <= rate && now > best) {
> +               if (_is_best_div(divider, rate, now, best)) {
>                         bestdiv = i;
>                         best = now;
>                         *best_parent_rate = parent_rate;
> diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
> index 7e59253..595f0ba 100644
> --- a/include/linux/clk-provider.h
> +++ b/include/linux/clk-provider.h
> @@ -275,6 +275,8 @@ struct clk_div_table {
>   *   of this register, and mask of divider bits are in higher 16-bit of this
>   *   register.  While setting the divider bits, higher 16-bit should also be
>   *   updated to indicate changing divider bits.
> + * CLK_DIVIDER_ROUND_CLOSEST - Makes the best calculated divider to be rounded
> + *     to the closest integer instead of the up one.
>   */
>  struct clk_divider {
>         struct clk_hw   hw;
> @@ -290,6 +292,7 @@ struct clk_divider {
>  #define CLK_DIVIDER_POWER_OF_TWO       BIT(1)
>  #define CLK_DIVIDER_ALLOW_ZERO         BIT(2)
>  #define CLK_DIVIDER_HIWORD_MASK                BIT(3)
> +#define CLK_DIVIDER_ROUND_CLOSEST      BIT(4)
>  
>  extern const struct clk_ops clk_divider_ops;
>  struct clk *clk_register_divider(struct device *dev, const char *name,
> -- 
> 1.7.9.5
> 
