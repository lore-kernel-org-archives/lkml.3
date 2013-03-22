Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422801Ab3CVSAZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 14:00:25 -0400
Received: from am1ehsobe005.messaging.microsoft.com ([213.199.154.208]:3985
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1422633Ab3CVSAY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 14:00:24 -0400
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -3
X-BigFish: VPS-3(zz98dIc89bh936eI1432I4015Izz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275bhz2fh95h668h839h93fhd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah906i1155h)
Date: Fri, 22 Mar 2013 11:00:15 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Mike Turquette <mturquette@linaro.org>
CC: Shawn Guo <shawn.guo@linaro.org>, Rajendra Nayak <rnayak@ti.com>,
        Andrew Lunn <andrew@lunn.ch>, James Hogan <james.hogan@imgtec.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC] clk: divider: Tolerate 0 divider for one based
 dividers
References: <dbceb80f-0303-4ba0-acd8-336dd85444ae@DB8EHSMHS017.ehs.local>
 <20130322171141.834.32801@quantum>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20130322171141.834.32801@quantum>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <c9f78c47-4926-4233-8cc3-51e0a4cc9c5e@AM1EHSMHS003.ehs.local>
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

On Fri, Mar 22, 2013 at 10:11:41AM -0700, Mike Turquette wrote:
> Quoting Soren Brinkmann (2013-03-11 14:13:37)
> > Handle a zero divider value as one/bypass for dividers which have the
> > CLK_DIVIDER_ONE_BASED flag set.
> > 
> > Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> > ---
> > In Zynq we have a lot of dividers which are one based, but at the same time
> > zero is a valid value which is handled as one/bypass. Also, the reset value of
> > some of these registers is zero, resulting in warnings when the clock framework
> > encounters this.
> > 
> > So, my question here is: Are our dividers odd? Does it make sense to allow zero
> > for all one based dividers, as shown in this patch? Or does this behavior
> > qualify for another flag for the divider clocks (e.g. CLK_DIVIDER_ZERO_OKAY)?
> > 
> 
> Everyone's dividers are odd ;)
> 
> For the case where a bitfield value of zero or one translates into
> divide-by-one, then I think a flag can be introduced.
> 
> But handling bypass and reset is likely to not be as generic or common
> across implementation, so you might need your own custom clk_hw_foo for
> that.
What I mean is that 0 corresponds to not modify the input frequency.
Whether hardware realizes this through bypass or divide by 1 is an irrelevant
implementation detail. I don't want to handle reset. Just avoid the warning
about a zero divider in case the CLK_DIVIDER_ONE_BASED flag is set.

> 
> The basic clk_divider type is meant to do exactly what the name says:
> divide an incoming clock rate.  If your clock does more than that then
> you might need to cook up your own clock type.
> 
> >         Thanks,
> >         Sören
> > 
> >  drivers/clk/clk-divider.c    | 5 +++--
> >  include/linux/clk-provider.h | 4 ++--
> >  2 files changed, 5 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/clk/clk-divider.c b/drivers/clk/clk-divider.c
> > index 68b4021..6c2a431 100644
> > --- a/drivers/clk/clk-divider.c
> > +++ b/drivers/clk/clk-divider.c
> > @@ -109,8 +109,9 @@ static unsigned long clk_divider_recalc_rate(struct clk_hw *hw,
> >  
> >         div = _get_div(divider, val);
> >         if (!div) {
> > -               WARN(1, "%s: Invalid divisor for clock %s\n", __func__,
> > -                                               __clk_get_name(hw->clk));
> > +               WARN(!(divider->flags & CLK_DIVIDER_ONE_BASED),
> > +                               "%s: Invalid divisor for clock %s\n", __func__,
> > +                               __clk_get_name(hw->clk));
> 
> div in this code is not the value programmed into the divider, but the
> numerical divider applied to the parent clock rate.  Thus dividing by
> zero never makes sense here.
Right, and for dividers which have the ONE_BASED flags set, this value
is just the register value read from HW. Our HW, allows the register
to be 0 and the resulting output frequency is its input frequency - just
as if it was set to 1.
Since some of our dividers have a reset value of 0, I see this warning
during boot up. My intention here is to get rid of the warning for clocks
which deem 0 a valid divider value.
I thought, reusing the ONE_BASED flag might be okay, since all such
dividers have this redundant 0 state and might handle it similar.
Otherwise a new flag might be required.

	Sören


