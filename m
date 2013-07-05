Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932904Ab3GENWe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 09:22:34 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:51754 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756718Ab3GENWd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 09:22:33 -0400
Message-ID: <1373030525.21065.172.camel@cumari.coelho.fi>
Subject: Re: [RFC] clk: add flags to distinguish xtal clocks
From: Luciano Coelho <coelho@ti.com>
To: James Hogan <james.hogan@imgtec.com>
CC: Mike Turquette <mturquette@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, <balbi@ti.com>
Date: Fri, 5 Jul 2013 16:22:05 +0300
In-Reply-To: <CAAG0J98UL5sLTmRx1o8XnbK8qWv_qNi9+zwuyPBbbYExPSbw8g@mail.gmail.com>
References: <1372971912-10877-1-git-send-email-coelho@ti.com>
	 <CAAG0J98UL5sLTmRx1o8XnbK8qWv_qNi9+zwuyPBbbYExPSbw8g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-07-05 at 14:12 +0100, James Hogan wrote:
> On 4 July 2013 22:05, Luciano Coelho <coelho@ti.com> wrote:
> > Add a flag that indicate whether the clock is a crystal or not.  Since
> > no clocks set this flag right now, include an additional flag that
> > indicates whether the type is set or not.  If the CLK_IS_TYPE_DEFINED
> > flag is not set, the value of the CLK_IS_TYPE_XTAL flag is undefined.
> > This ensures backwards compatibility.
> >
> > Additionally, parse a new device tree binding in clk-fixed-rate to set
> > this flag.
> >
> > Signed-off-by: Luciano Coelho <coelho@ti.com>
> > ---
> >
> > I'm not  familiar with the common clock framework and I'm not
> > entirely sure the flags can be used in such a way, but to me it looks
> > reasonable, since some clock consumers may need to know what type of
> > clock is being provided.
> >
> > Specifically, the wl12xx firmware needs to know if the clock is XTAL
> > or not to handle the stabilization and boosts properly.
> >
> > My main idea is that I need to pass this information in the device
> > tree definition of the clocks, so that the driver can pass this
> > information on to the firmware.
> >
> > Please let me know if this looks ok or not.  If not, please let me
> > know if you have any other ideas on how to solve my problem (of
> > knowing whether the clock attached to the WiLink chip is XTAL or not).
> 
> The TZ1090 SoC has something that sounds possibly similar, where some
> of the XTAL pads have a bypass bit, which according to the hardware
> engineer I asked should be enabled when you want to use the
> corresponding XTAL pads as a clock input pad rather than an
> oscillator.

Cool, good to know that I'm not alone here. ;)


>  I was considering extending clk-fixed-rate (via a wrapper
> driver) to parse a custom DT property and a register address / bit
> number and set the bypass bit as appropriate itself.

I thought about this too.  I actually have a "driver" for my clocks,
because normally they're not part of the main board, but part of the
module that contains the WiLink chip.  In those cases, I don't want my
clocks to be used as a generic clk-fixed-rate by the clock framework.
But the only difference in my "wrapper" is that it matches
"ti,wilink-clock" instead of "fixed-clock".


> So I was wondering, is there a particular reason you don't have a DT
> property on the node for the device that needs to know what type of
> clock it is, rather than the clock node itself? That way you're not
> depending directly on the generic common clock framework to be able to
> tell you such electrical details.

I think this is a detail of the clock itself, not of the user of the
clock.  Of course, the user of the clock needs to know what to do if the
clock is XTAL.  But the information of whether it is a XTAL or not
should be in the clock data.

I tried to make a generic solution that everyone could use.  For
instance, you. :) You could use the same bit that I implemented and, in
your driver, convert that bit into the action you need to take.


--
Luca.

