Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422656Ab3CVRLs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 13:11:48 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:53199 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161092Ab3CVRLr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 13:11:47 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Soren Brinkmann <soren.brinkmann@xilinx.com>,
        Shawn Guo <shawn.guo@linaro.org>, Rajendra Nayak <rnayak@ti.com>,
        Andrew Lunn <andrew@lunn.ch>, James Hogan <james.hogan@imgtec.com>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <dbceb80f-0303-4ba0-acd8-336dd85444ae@DB8EHSMHS017.ehs.local>
Cc: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
References: <dbceb80f-0303-4ba0-acd8-336dd85444ae@DB8EHSMHS017.ehs.local>
Message-ID: <20130322171141.834.32801@quantum>
User-Agent: alot/0.3.3+
Subject: Re: [PATCH RFC] clk: divider: Tolerate 0 divider for one based dividers
Date: Fri, 22 Mar 2013 10:11:41 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Soren Brinkmann (2013-03-11 14:13:37)
> Handle a zero divider value as one/bypass for dividers which have the
> CLK_DIVIDER_ONE_BASED flag set.
> 
> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> ---
> In Zynq we have a lot of dividers which are one based, but at the same time
> zero is a valid value which is handled as one/bypass. Also, the reset value of
> some of these registers is zero, resulting in warnings when the clock framework
> encounters this.
> 
> So, my question here is: Are our dividers odd? Does it make sense to allow zero
> for all one based dividers, as shown in this patch? Or does this behavior
> qualify for another flag for the divider clocks (e.g. CLK_DIVIDER_ZERO_OKAY)?
> 

Everyone's dividers are odd ;)

For the case where a bitfield value of zero or one translates into
divide-by-one, then I think a flag can be introduced.

But handling bypass and reset is likely to not be as generic or common
across implementation, so you might need your own custom clk_hw_foo for
that.

The basic clk_divider type is meant to do exactly what the name says:
divide an incoming clock rate.  If your clock does more than that then
you might need to cook up your own clock type.

>         Thanks,
>         Sören
> 
>  drivers/clk/clk-divider.c    | 5 +++--
>  include/linux/clk-provider.h | 4 ++--
>  2 files changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/clk/clk-divider.c b/drivers/clk/clk-divider.c
> index 68b4021..6c2a431 100644
> --- a/drivers/clk/clk-divider.c
> +++ b/drivers/clk/clk-divider.c
> @@ -109,8 +109,9 @@ static unsigned long clk_divider_recalc_rate(struct clk_hw *hw,
>  
>         div = _get_div(divider, val);
>         if (!div) {
> -               WARN(1, "%s: Invalid divisor for clock %s\n", __func__,
> -                                               __clk_get_name(hw->clk));
> +               WARN(!(divider->flags & CLK_DIVIDER_ONE_BASED),
> +                               "%s: Invalid divisor for clock %s\n", __func__,
> +                               __clk_get_name(hw->clk));

div in this code is not the value programmed into the divider, but the
numerical divider applied to the parent clock rate.  Thus dividing by
zero never makes sense here.

Regards,
Mike

>                 return parent_rate;
>         }
>  
> diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
> index 7f197d7..5b19b13 100644
> --- a/include/linux/clk-provider.h
> +++ b/include/linux/clk-provider.h
> @@ -238,8 +238,8 @@ struct clk_div_table {
>   * Flags:
>   * CLK_DIVIDER_ONE_BASED - by default the divisor is the value read from the
>   *     register plus one.  If CLK_DIVIDER_ONE_BASED is set then the divider is
> - *     the raw value read from the register, with the value of zero considered
> - *     invalid
> + *     the raw value read from the register. A zero divider is considered to be
> + *     the same as the a value of one.
>   * CLK_DIVIDER_POWER_OF_TWO - clock divisor is 2 raised to the value read from
>   *     the hardware register
>   */
> -- 
> 1.8.1.5
