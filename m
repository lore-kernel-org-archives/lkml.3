Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751403AbaI2EjJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 00:39:09 -0400
Received: from mail-vc0-f175.google.com ([209.85.220.175]:59580 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037AbaI2EjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 00:39:07 -0400
MIME-Version: 1.0
In-Reply-To: <1411801888-3152-1-git-send-email-addy.ke@rock-chips.com>
References: <1411801888-3152-1-git-send-email-addy.ke@rock-chips.com>
Date: Sun, 28 Sep 2014 21:39:05 -0700
X-Google-Sender-Auth: 3wRxktCIQw8evCGVPXqtos8QGr8
Message-ID: <CAD=FV=XnM-2CuctP-L=-gj7TPyMXrkhsDS9Tmxeq+9Mx5p7PZA@mail.gmail.com>
Subject: Re: [PATCH v2] i2c: rk3x: adjust the LOW divison based on
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

On Sat, Sep 27, 2014 at 12:11 AM, Addy Ke <addy.ke@rock-chips.com> wrote:
> From: Addy <addy.ke@rock-chips.com>
>
> As show in I2C specification:
> - Standard-mode: the minimum HIGH period of the scl clock is 4.0us
>                  the minimum LOW period of the scl clock is 4.7us
> - Fast-mode: the minimum HIGH period of the scl clock is 0.6us
>              the minimum LOW period of the scl clock is 1.3us
>
> I have measured i2c SCL waveforms in fast-mode by oscilloscope
> on rk3288-pinky board. the LOW period of the scl clock is 1.3us.
> It is so critical that we must adjust LOW division to increase
> the LOW period of the scl clock.
>
> After put this patch, we can find that min_low_ns is about
> 5.4us in Standard-mode and 1.6us in Fast-mode.
>
> Thanks Doug for the suggestion about division formulas.
>
> Signed-off-by: Addy <addy.ke@rock-chips.com>
> ---
> Changes in v2:
> - remove Fast-mode plus and HS-mode
> - use new formulas suggested by Doug
>
>  drivers/i2c/busses/i2c-rk3x.c | 104 +++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 97 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/i2c/busses/i2c-rk3x.c b/drivers/i2c/busses/i2c-rk3x.c
> index e637c32..81672a8 100644
> --- a/drivers/i2c/busses/i2c-rk3x.c
> +++ b/drivers/i2c/busses/i2c-rk3x.c
> @@ -428,19 +428,109 @@ out:
>         return IRQ_HANDLED;
>  }
>
> +static void rk3x_i2c_get_min_ns(unsigned int scl_rate,
> +                               unsigned long *min_low_ns,
> +                               unsigned long *min_high_ns)
> +{
> +       WARN_ON(scl_rate > 400000);
> +
> +       /* As show in I2C specification:
> +        * - Standard-mode(100KHz):
> +        *   min_low_ns is 4700ns
> +        *   min_high_ns is 4000ns
> +        * - Fast-mode(400KHz):
> +        *   min_low_ns is 1300ns
> +        *   min_high_ns is 600ns
> +        *
> +        * (min_low_ns + min_high_ns) up to 10000ns in Standard-mode
> +        * and 2500ns in Fast-mode
> +        */
> +       if (scl_rate <= 100000) {
> +               *min_low_ns = 4700 + 650;
> +               *min_high_ns = 4000 + 650;
> +       } else {
> +               *min_low_ns = 1300 + 300;
> +               *min_high_ns = 600 + 300;

Wait, where did the extra 650 and 300 come from here?  Are you just
trying to balance things out?  That's not the right way to do things.
Please explain what you were trying to accomplish and we can figure
out a better way.

...maybe this helped make thins nicer in the clock rates you tried,
but I'd bet that I can find clock rates that this is broken for...


> +       }
> +}
> +
> +static void rk3x_i2c_calc_divs(unsigned long i2c_rate, unsigned long scl_rate,
> +                              unsigned long *div_low, unsigned long *div_high)
> +{
> +       unsigned long min_low_ns, min_high_ns, min_total_ns;
> +       unsigned long min_low_div, min_high_div;
> +       unsigned long min_total_div, min_div_for_hold;
> +       unsigned long extra_div, extra_low_div, ideal_low_div;
> +       unsigned long i2c_rate_khz, scl_rate_khz;
> +
> +       rk3x_i2c_get_min_ns(scl_rate, &min_low_ns, &min_high_ns);
> +       min_total_ns = min_low_ns + min_high_ns;
> +
> +       /* To avoid from overflow warning */
> +       i2c_rate_khz = i2c_rate / 1000;
> +       scl_rate_khz = scl_rate / 1000;

DIV_ROUND_UP?

> +
> +       /*We need the total div to be >= this number
> +        * so we don't clock too fast.
> +        */

Please match the commenting style in the rest of the file.  That's:

/*
 * A
 * B
 * C
 */

Not:

/* A
 * B
 * C
 */

> +       min_total_div = DIV_ROUND_UP(i2c_rate_khz, scl_rate_khz * 8);
> +
> +       /* These are the min dividers needed for hold times */
> +       min_low_div = DIV_ROUND_UP(i2c_rate_khz * min_low_ns, 8 * 1000000);
> +       min_high_div = DIV_ROUND_UP(i2c_rate_khz * min_high_ns, 8 * 1000000);
> +       min_div_for_hold = (min_low_div + min_high_div);
> +
> +       if (min_div_for_hold > min_total_div) {
> +               /* Time needed to meet hold requirements is important.
> +                * Just use that
> +                * */

Extra "*" in "* */"


> +               *div_low = min_low_div;
> +               *div_high = min_high_div;
> +       } else {
> +               /* We've got to distribute some time among the low and high
> +                * so we don't run too fast.
> +                */
> +               extra_div = min_total_div - min_div_for_hold;
> +               /* We'll try to split things up perfectly evenly,
> +                * biasing slightly towards having a higher div
> +                * for low (spend more time low).
> +                */

Last I remember you said that this wasn't going to work quite right
and you were just going to assign all of the "extra" to the high part.
What changed?


> +               ideal_low_div = DIV_ROUND_UP(i2c_rate_khz * min_low_ns,
> +                                            scl_rate_khz * 8 * min_total_ns);
> +               /* Handle when the ideal low div is going to take up
> +                * more than we have.
> +                */
> +               if (ideal_low_div > min_low_div + extra_div)
> +                       ideal_low_div = min_low_div + extra_div;
> +               /* Give low the "ideal" and give high whatever extra is left.*/
> +               extra_low_div = ideal_low_div - min_low_div;
> +               *div_low = ideal_low_div;
> +               *div_high
> +                       = min_high_div + (extra_div - extra_low_div);
> +       }
> +
> +       /* Adjust to the fact that the hardware has an implicit "+1".*/
> +       *div_low = *div_low - 1;
> +       *div_high = *div_high - 1;
> +}
> +
>  static void rk3x_i2c_set_scl_rate(struct rk3x_i2c *i2c, unsigned long scl_rate)
>  {
>         unsigned long i2c_rate = clk_get_rate(i2c->clk);
> -       unsigned int div;
> +       unsigned long div_low, div_high;
>
> -       /* SCL rate = (clk rate) / (8 * DIV) */
> -       div = DIV_ROUND_UP(i2c_rate, scl_rate * 8);

Strangely this now seems to be based upon an older version of the
file.  I had to revert (b4a7bd7 i2c: rk3x: fix divisor calculation for
SCL frequency) in order to apply v2.  Please submit your code against
the latest accepted code.


> +       /* The formulas in rk3x TRM:
> +        * - T_scl_high = T_clk * (divh + 1) * 8
> +        * - T_scl_low = T_clk * (divl + 1) * 8
> +        * */
> +       rk3x_i2c_calc_divs(i2c_rate, scl_rate, &div_low, &div_high);
>
> -       /* The lower and upper half of the CLKDIV reg describe the length of
> -        * SCL low & high periods. */
> -       div = DIV_ROUND_UP(div, 2);
> +       i2c_writel(i2c, (div_high << 16) | (div_low & 0xffff), REG_CLKDIV);
>
> -       i2c_writel(i2c, (div << 16) | (div & 0xffff), REG_CLKDIV);
> +       dev_dbg(i2c->dev, "scl_ns: %luns, scl_low_ns: %luns, scl_high_ns: %luns\n",
> +               1000000000/scl_rate,
> +               (1000000000 / i2c_rate) * (div_low + 1) * 8,
> +               (1000000000 / i2c_rate) * (div_high + 1) * 8);
>  }
>
>  /**
> --
> 1.8.3.2
>
>
