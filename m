Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751186Ab3FDTWv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 15:22:51 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:43060 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791Ab3FDTWt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 15:22:49 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Matt Sealey <neko@bakuhatsu.net>, Stephen Boyd <sboyd@codeaurora.org>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <CAHCPf3tZAbdVZPuKOjxJbCOAE76Pa6wMVHjnBRPhSpj0aMBMHg@mail.gmail.com>
Cc: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org
References: <1370281990-15090-1-git-send-email-mturquette@linaro.org>
 <1370281990-15090-4-git-send-email-mturquette@linaro.org>
 <51AE1FBB.1070806@codeaurora.org>
 <CAHCPf3tZAbdVZPuKOjxJbCOAE76Pa6wMVHjnBRPhSpj0aMBMHg@mail.gmail.com>
Message-ID: <20130604192243.10233.76496@quantum>
User-Agent: alot/0.3.4
Subject: Re: [PATCH RFC 3/3] clk: dt: binding for basic divider clock
Date: Tue, 04 Jun 2013 12:22:43 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Matt Sealey (2013-06-04 10:39:53)
> On Tue, Jun 4, 2013 at 12:11 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:
> > On 06/03/13 10:53, Mike Turquette wrote:
> >> +Required properties:
> >> +- compatible : shall be "divider-clock".
> >> +- #clock-cells : from common clock binding; shall be set to 0.
> >> +- clocks : link to phandle of parent clock
> >> +- reg : base address for register controlling adjustable divider
> >> +- mask : arbitrary bitmask for programming the adjustable divider
> >> +
> >> +Optional properties:
> >> +- clock-output-names : From common clock binding.
> >> +- table : array of integer pairs defining divisors & bitfield values
> >> +- shift : number of bits to shift the mask, defaults to 0 if not present
> >> +- index_one : valid divisor programming starts at 1, not zero
> >> +- index_power_of_two : valid divisor programming must be a power of two
> >> +- allow_zero : implies index_one, and programming zero results in
> >> +  divide-by-one
> >
> > It's preferred that property names have dashes instead of underscores.
> 
> I think I have a suggestion or two here..
> 
> I mailed one to Mike earlier, I have had some mailing list problems
> which I think are solved now..
> 
> If you provide a mask for programming the divider, surely the "shift"
> property is therefore redundant. Unless some device has a completely
> strange way of doing things and uses two seperated bitfields for
> programming in the same register, the shift value is simply a function
> of ffs() on the mask, isn't it? It is nice to put the information
> specifically in the device tree, but where a shift is not specified
> it'd probably be a good idea to go about deriving that value that way
> anyway, right, and if we're doing that.. why specify it?
> 

Shift is optional.  Also I think the integer values in a DTS are
32-bits, so if some day someone had a clock driver that needed to write
to a 64-bit register then shift might be useful there, combined with a
32-bit mask.  Or perhaps dtc will have a 64-bit value for that case?  I
don't know.

I certainly do see your point about only using the mask, and the
original clock basic types did this a while back before the shift+width
style came into vogue.

If other reviewers also want to use a pure 32-bit mask and no shift then
I'll drop it in the next round.

> Also it may be much simpler to simply define the default clock setup
> as being an integer divider that follows the form 2^n - I am not sure
> I can think off the top of my head of any clock dividers doing the
> rounds that have divide-by-non-power-of-two and if they exist out
> there (please correct me) they would be the rare ones. I think
> properties that modify behavior should err on the side of being rarely
> used and to define unusual behavior, not confirm the status quo.
> 

Please review the current use of CLK_DIVIDER_POWER_OF_TWO in the kernel.
The only platform using this flag for power-of-two dividers is OMAP2430.
Based on usage of clk_register_divider I think the common case is a
clock divider that divides by any integer value programmed into it, up
to the limit of the bitfield width.

Perhaps your platform is the corner case, in which case power-of-two is
the property you should use.

> Just to be sure, though, someone would need to go visit a bunch of
> current clock handlers already implemented or read a lot of docs to
> see how they're expecting their dividers. Maybe some of the Samsung,
> Qualcomm, TI, Freescale guys can comment on what is the most common
> case inside their SoCs.
> 

The following platforms use the basic divider without the power-of-two
flag:

imx6, loongson1B, mmp2, pxa168, pxa190, spearX, sunxi, tegra2/3/114,
omap2+.

> In any case, once you figure out that, rather than specifying a full
> table of <0 1>, <1 2>, <2, 4> and creating a big list, you could just
> give the lower and upper limits and let the driver figure out what is
> in between with two values. If there were gaps, a full table would be
> necessary. The allow zero property might be better served by the very
> same range property.
> 

You have described how it already works.  The table is only there for
when a common formula fails to capture the possible divisor
combinations.  For the default the driver starts the index at 0 and goes
up to mask/width, for index_one the driver does the same but starts at
1, not 0, for power of two ... well you get the picture.  The table is
only of use when these common divider schemes are insufficient to
determine the divisors.

> I would also say.. bit-mask rather than mask, divider-table rather
> than table, divider-range (modifying the idea above). While we're
> inside a particular namespace in the binding I think naming properties
> with their intent (i.e. what table is it?) is good behavior.
> 

I'll make the properties more verbose in the next patch.

Thanks for the review,
Mike

> --
> Matt Sealey <matt@genesi-usa.com>
