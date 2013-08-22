Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753921Ab3HVQFS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 12:05:18 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:43734 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752976Ab3HVQFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 12:05:16 -0400
Date: Thu, 22 Aug 2013 17:04:43 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH 09/33] ARM: ux500: Supply the I2C clocks lookup to the
 DBX500 DT
Message-ID: <20130822160443.GG23152@e106331-lin.cambridge.arm.com>
References: <1370521041-32318-1-git-send-email-lee.jones@linaro.org>
 <1370521041-32318-10-git-send-email-lee.jones@linaro.org>
 <CACRpkdbE86HgPr+7LZD9BFU_OsDFFFWTaFHW_i2fNXivKZ-3Dw@mail.gmail.com>
 <20130820093034.GL31036@pengutronix.de>
 <20130822133730.GB23152@e106331-lin.cambridge.arm.com>
 <20130822141900.GB17154@lee--X1>
 <20130822151723.GE23152@e106331-lin.cambridge.arm.com>
 <20130822154116.GC17154@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130822154116.GC17154@lee--X1>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 22, 2013 at 04:41:16PM +0100, Lee Jones wrote:
> On Thu, 22 Aug 2013, Mark Rutland wrote:
> 
> > On Thu, Aug 22, 2013 at 03:19:00PM +0100, Lee Jones wrote:
> > > On Thu, 22 Aug 2013, Mark Rutland wrote:
> > > 
> > > > On Tue, Aug 20, 2013 at 10:30:34AM +0100, Sascha Hauer wrote:
> > > > > On Tue, Aug 20, 2013 at 11:11:19AM +0200, Linus Walleij wrote:
> > > > > > On Thu, Jun 6, 2013 at 2:16 PM, Lee Jones <lee.jones@linaro.org> wrote:
> > > > > > 
> > > > > > > +++ b/arch/arm/boot/dts/dbx5x0.dtsi
> > > > > > > @@ -572,6 +572,8 @@
> > > > > > >                         v-i2c-supply = <&db8500_vape_reg>;
> > > > > > >
> > > > > > >                         clock-frequency = <400000>;
> > > > > > > +                       clocks = <&prcc_kclk 3 3>, <&prcc_pclk 3 3>;
> > > > > > > +                       clock-names = "nmk-i2c.0", "apb_pclk";
> > > > > 
> > > > > Why do most clocks in this series have the instance number in the clock
> > > > > names? This looks very wrong to me.
> > > > 
> > > > +1. The clock names should be the input names to the unit, they
> > > > shouldn't vary per instance.
> > > 
> > > So I just had a quick look, and it looks like they each have their own
> > > clock:
> > > 
> > > 	clk = clk_reg_prcc_kclk("p1_i2c1_kclk", "i2cclk",
> > > 			clkrst1_base, BIT(2), CLK_SET_RATE_GATE);
> > > 	clk = clk_reg_prcc_kclk("p1_i2c2_kclk", "i2cclk",
> > > 			clkrst1_base, BIT(6), CLK_SET_RATE_GATE);
> > > 	clk = clk_reg_prcc_kclk("p2_i2c3_kclk", "i2cclk",
> > > 			clkrst2_base, BIT(0), CLK_SET_RATE_GATE);
> > > 	clk_register_clkdev(clk, NULL, "nmk-i2c.3");
> > >         
> > >         /* etc */
> > > 
> > > When using the names in Device Tree it doesn't actually matter what
> > > you call the first clock. You can call it "fred" if you wanted and it
> > > would still work, but in light of the naming conventions above and the
> > > fact that each clock can all be controlled independently, do we still
> > > want to use the name of the parent clock i.e. i2cclk?
> > 
> > Sorry, I don't follow.
> > 
> > 
> > The name should be the name of the clock _input_ on the block described,
> > as should be listed in documentation for the i2c block. The name should
> > not vary with instance, and the name should not (necessarily) match the
> > _output_ of the provider. Surely there's documentation for the i2c block
> > that gives a name for the clock input(s)?
> 
> It's okay, I've fixed the patches.

Ok.

> 
> Linus, branch fixed-up and pushed.
> 
> > On a related note, I see that this doesn't follow the primecell clock
> > bindings, which seem to rely on "apb_pclk" being first in the list. I
> > see that other primecell device bindings don't follow that in dts or
> > drivers, so I'm not sure how to fix that brokenness.
> 
> To which bindings do you refer? After taking a *quick* look, I see it
> being the other way around. Whenever the "apb_pclk" is requested, it
> is done so by name:
> 
>   drivers/amba/bus.c: struct clk *pclk = clk_get(&pcdev->dev, "apb_pclk");
> 
> So when clk_get() calls of_clk_get_by_name(), the clock-name index is
> returned correctly by of_property_match_string(), which then passes
> that index through of_clk_get() and does the right thing.
> 
> When most of the other clocks that we deal with are being requested,
> they rely on being index zero:
> 
>   drivers/i2c/busses/i2c-nomadik.c: dev->clk = clk_get(&adev->dev, NULL);
> 
> At the moment this works for us, so I don't think we need to go
> around populating the name params, but we might have to if this falls
> apart in some way (probably likely if you 'fixed' whatever brokenness
> you're wanting to fix ;-) )

The brokenness here is that the binding document states one thing, and
drivers do precisely the opposite.

Documentation/devicetree/bindings/arm/primecell.txt states:

- clocks : From common clock binding. First clock is phandle to clock for apb
	pclk. Additional clocks are optional and specific to those peripherals.
- clock-names : From common clock binding. Shall be "apb_pclk" for first clock.

Yet as you've pointed out above we don't care which index apb_pblk is,
but do for the other clock, which we get at index 0 (where the binding
doc states apb_pclk should be).

If all users are doing that currently, it's possible to fix up the
binding document. If not, then it's a mess that can't be corrected...

Thanks,
Mark.
