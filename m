Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755950AbaIEEcA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 00:32:00 -0400
Received: from mail-vc0-f173.google.com ([209.85.220.173]:45296 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755900AbaIEEb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 00:31:57 -0400
MIME-Version: 1.0
In-Reply-To: <1409884333-3544-1-git-send-email-addy.ke@rock-chips.com>
References: <1409884333-3544-1-git-send-email-addy.ke@rock-chips.com>
Date: Thu, 4 Sep 2014 21:31:56 -0700
X-Google-Sender-Auth: 7rHyoIyO7BRStaZTxaKlvO6ymqw
Message-ID: <CAD=FV=W3JJM38v-X=pyLUjAzY3Ti88xUgWp9bMsX5dqp1gubpg@mail.gmail.com>
Subject: Re: [PATCH] i2c: rk3x: fix divisor calculation for SCL frequency
From: Doug Anderson <dianders@chromium.org>
To: Addy Ke <addy.ke@rock-chips.com>
Cc: Wolfram Sang <wsa@the-dreams.de>, max.schwarz@online.de,
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

On Thu, Sep 4, 2014 at 7:32 PM, Addy Ke <addy.ke@rock-chips.com> wrote:
> I2C_CLKDIV register descripted in the previous version of
> RK3x chip manual is incorrect. Plus 1 is required.
>
> The correct formula:
> - T(SCL_HIGH) = T(PCLK) * (CLKDIVH + 1) * 8
> - T(SCL_LOW) = T(PCLK) * (CLKDIVL + 1) * 8
> - (SCL Divsor) = 8 * ((CLKDIVL + 1) + (CLKDIVH + 1))
> - SCL = PCLK / (CLK Divsor)

I'll trust that you tested this with a scope


> It will be updated to the latest version of chip manual.
>
> Signed-off-by: Addy Ke <addy.ke@rock-chips.com>
> ---
>  drivers/i2c/busses/i2c-rk3x.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/i2c/busses/i2c-rk3x.c b/drivers/i2c/busses/i2c-rk3x.c
> index e637c32..76b6604 100644
> --- a/drivers/i2c/busses/i2c-rk3x.c
> +++ b/drivers/i2c/busses/i2c-rk3x.c
> @@ -433,8 +433,8 @@ static void rk3x_i2c_set_scl_rate(struct rk3x_i2c *i2c, unsigned long scl_rate)
>         unsigned long i2c_rate = clk_get_rate(i2c->clk);
>         unsigned int div;
>
> -       /* SCL rate = (clk rate) / (8 * DIV) */
> -       div = DIV_ROUND_UP(i2c_rate, scl_rate * 8);
> +       /* SCL rate = (clk rate) / (8 * (DIV + 2)) */
> +       div = DIV_ROUND_UP(i2c_rate, scl_rate * 8) - 2;

Given the bug I just fixed in the Rockchip SPI driver, I was a little
worried about div becoming -1 (and thus being a really large positive
number since div is unsigned).

However, it seems that you get saved by the next statement:
  div = DIV_ROUND_UP(div, 2);

In the testing I did with the Linux macros, that magically transformed
a div of 0xFFFFFFFF (-1) to 0, so it's not technically a bug.  ...but
it's very non-obvious.  Can you do something a little cleaner?

-Doug
