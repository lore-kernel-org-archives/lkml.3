Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751371AbaIXEKi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 00:10:38 -0400
Received: from mail-vc0-f176.google.com ([209.85.220.176]:59056 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028AbaIXEKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 00:10:37 -0400
MIME-Version: 1.0
In-Reply-To: <1411523743-3444-1-git-send-email-addy.ke@rock-chips.com>
References: <1411523743-3444-1-git-send-email-addy.ke@rock-chips.com>
Date: Tue, 23 Sep 2014 21:10:35 -0700
X-Google-Sender-Auth: n-ejzIHdXadXm88_RA5NpqDGDLQ
Message-ID: <CAD=FV=WiHR+KcTWHnma6TdPQcc3oc4wqAofj5kF=Sgec_5kGAQ@mail.gmail.com>
Subject: Re: [PATCH] i2c: rk3x: adjust the LOW divison based on
 characteristics of SCL
From: Doug Anderson <dianders@chromium.org>
To: Addy Ke <addy.ke@rock-chips.com>
Cc: Wolfram Sang <wsa@the-dreams.de>, Max Schwarz <max.schwarz@online.de>,
        =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        Olof Johansson <olof@lixom.net>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-rockchip@lists.infradead.org, Eddie Cai <cf@rock-chips.com>,
        Jianqun Xu <xjq@rock-chips.com>, Tao Huang <huangtao@rock-chips.com>,
        Chris <zyw@rock-chips.com>,
        =?UTF-8?B?5aea5pm65oOF?= <yzq@rock-chips.com>,
        han jiang <hj@rock-chips.com>, Kever Yang <kever.yang@rock-chips.com>,
        Lin Huang <hl@rock-chips.com>,
        =?UTF-8?B?5pmT6IW+546L?= <caesar.wang@rock-chips.com>,
        Shunqian Zheng <zhengsq@rock-chips.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Addy,

On Tue, Sep 23, 2014 at 6:55 PM, Addy Ke <addy.ke@rock-chips.com> wrote:
> As show in I2C specification:
> - Standard-mode:
>   the minimum HIGH period of the scl clock is 4.0us
>   the minimum LOW period of the scl clock is 4.7us
> - Fast-mode:
>   the minimum HIGH period of the scl clock is 0.6us
>   the minimum LOW period of the scl clock is 1.3us
> - Fast-mode plus:
>   the minimum HIGH period of the scl clock is 0.26us
>   the minimum LOW period of the scl clock is 0.5us
> - HS-mode(<1.7MHz):
>   the minimum HIGH period of the scl clock is 0.12us
>   the minimum LOW period of the scl clock is 0.32us
> - HS-mode(<3.4MHz):
>   the minimum HIGH period of the scl clock is 0.06us
>   the minimum LOW period of the scl clock is 0.16us
>
> I have measured i2c SCL waveforms in fast-mode by oscilloscope
> on rk3288-pinky board. the LOW period of the scl clock is 1.3us.
> It is so critical that we must adjust LOW division to increase
> the LOW period of the scl clock.
>
> Thanks Doug for the suggestion about division formula.
>
> Signed-off-by: Addy Ke <addy.ke@rock-chips.com>
> ---
>  drivers/i2c/busses/i2c-rk3x.c | 79 +++++++++++++++++++++++++++++++++++++++----
>  1 file changed, 72 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/i2c/busses/i2c-rk3x.c b/drivers/i2c/busses/i2c-rk3x.c
> index 93cfc83..49d67b7 100644
> --- a/drivers/i2c/busses/i2c-rk3x.c
> +++ b/drivers/i2c/busses/i2c-rk3x.c
> @@ -428,18 +428,83 @@ out:
>         return IRQ_HANDLED;
>  }
>
> +static void rk3x_i2c_get_ratios(unsigned long scl_rate,
> +                               unsigned long *high_ratio,
> +                               unsigned long *low_ratio)
> +{
> +       /* As show in I2C specification:
> +        * - Standard-mode:
> +        *   the minimum HIGH period of the scl clock is 4.0us
> +        *   the minimum LOW period of the scl clock is 4.7us
> +        * - Fast-mode:
> +        *   the minimum HIGH period of the scl clock is 0.6us
> +        *   the minimum LOW period of the scl clock is 1.3us
> +        * - Fast-mode plus:
> +        *   the minimum HIGH period of the scl clock is 0.26us
> +        *   the minimum LOW period of the scl clock is 0.5us
> +        * - HS-mode(<1.7MHz):
> +        *   the minimum HIGH period of the scl clock is 0.12us
> +        *   the minimum LOW period of the scl clock is 0.32us
> +        * - HS-mode(<3.4MHz):
> +        *   the minimum HIGH period of the scl clock is 0.06us
> +        *   the minimum LOW period of the scl clock is 0.16us

Is the rest of the driver ready for Fast-mode plus or HS mode?  If not
then maybe leave those off?  If nothing else the commit message should
indicate that this is just being forward thinking.

> +        */
> +       if (scl_rate <= 100000) {
> +               *high_ratio = 40;
> +               *low_ratio = 47;
> +       } else if (scl_rate <= 400000) {
> +               *high_ratio = 6;
> +               *low_ratio = 13;
> +       } else if (scl_rate <= 1000000) {
> +               *high_ratio = 26;
> +               *low_ratio = 50;
> +       } else if (scl_rate <= 1700000) {
> +               *high_ratio = 12;
> +               *low_ratio = 32;
> +       } else {
> +               *high_ratio = 6;
> +               *low_ratio = 16;

Since it's only the ratio of high to low that matters, you can combine
the last two.  12 : 32 == 6 : 16

> +       }
> +}
> +
> +static void rk3x_i2c_calc_divs(unsigned long i2c_rate, unsigned long scl_rate,
> +                              unsigned long *divh, unsigned long *divl)
> +{
> +       unsigned long high_ratio, low_ratio;
> +       unsigned long ratio_sum;
> +
> +       rk3x_i2c_get_ratios(scl_rate, &high_ratio, &low_ratio);
> +       ratio_sum = high_ratio + low_ratio;
> +
> +       /* T_high = T_clk * (divh + 1) * 8
> +        * T_low = T_clk * (divl + 1) * 8
> +        * T_scl = T_high + T_low
> +        * T_scl = 1 / scl_rate
> +        * T_clk = 1 / i2c_rate
> +        * T_high : T_low = high_ratio : low_ratio
> +        * ratio_sum = high_ratio + low_ratio
> +        *
> +        * so:
> +        * divh = (i2c_rate * high_ratio) / (scl_rate * ratio_sum * 8) - 1
> +        * divl = (i2c_rate * low_ratio) / (scl_rate * ratio_sum * 8) - 1
> +        */
> +       *divh = DIV_ROUND_UP(i2c_rate * high_ratio, scl_rate * ratio_sum * 8);
> +       if (*divh)
> +               *divh = *divh - 1;
> +
> +       *divl = DIV_ROUND_UP(i2c_rate * low_ratio, scl_rate * ratio_sum * 8);
> +       if (*divl)
> +               *divl = *divl - 1;

When I sent you the sample formulas I purposely did it differently
than this.  Any reason you changed from my formulas?

  div_low = DIV_ROUND_UP(clk_rate * low_ratio, scl_rate * 8 * ratio_sum)
  div_high = DIV_ROUND_UP(clk_rate, scl_rate * 8) - div_low

  div_low -= 1
  if div_high:
    div_high -= 1

Why did I do it that way?

* Assuming i2c_rate and the ratio is non-zero then you can assume that
DIV_ROUND_UP gives a value that is >= 1.  No need to test the result
against 0.

* (I think) you'll get a more accurate clock rate by subtracting.

Try running your formula vs. my formula with a ratio of 13 : 6, an i2c
rate of 12800000, and an scl rate of 400000

Mine will get:
  Req = 400000, act = 400000, 1.88 us low, 0.62 us high, low/high = 3.00

Yours will get:
  Req = 400000, act = 320000, 1.88 us low, 1.25 us high, low/high = 1.50


> +}
> +
>  static void rk3x_i2c_set_scl_rate(struct rk3x_i2c *i2c, unsigned long scl_rate)
>  {
>         unsigned long i2c_rate = clk_get_rate(i2c->clk);
> -       unsigned int div;
> +       unsigned long divh, divl;
>
> -       /* set DIV = DIVH = DIVL
> -        * SCL rate = (clk rate) / (8 * (DIVH + 1 + DIVL + 1))
> -        *          = (clk rate) / (16 * (DIV + 1))
> -        */
> -       div = DIV_ROUND_UP(i2c_rate, scl_rate * 16) - 1;
> +       rk3x_i2c_calc_divs(i2c_rate, scl_rate, &divh, &divl);
>
> -       i2c_writel(i2c, (div << 16) | (div & 0xffff), REG_CLKDIV);
> +       i2c_writel(i2c, (divh << 16) | (divl & 0xffff), REG_CLKDIV);
>  }
>
>  /**
> --
> 1.8.3.2
>
>
