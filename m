Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751419Ab3FDUNl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 16:13:41 -0400
Received: from mail-qe0-f52.google.com ([209.85.128.52]:64580 "EHLO
	mail-qe0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085Ab3FDUNi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 16:13:38 -0400
MIME-Version: 1.0
In-Reply-To: <20130604192243.10233.76496@quantum>
References: <1370281990-15090-1-git-send-email-mturquette@linaro.org>
	<1370281990-15090-4-git-send-email-mturquette@linaro.org>
	<51AE1FBB.1070806@codeaurora.org>
	<CAHCPf3tZAbdVZPuKOjxJbCOAE76Pa6wMVHjnBRPhSpj0aMBMHg@mail.gmail.com>
	<20130604192243.10233.76496@quantum>
Date: Tue, 4 Jun 2013 15:13:37 -0500
Message-ID: <CAHCPf3t-oqsS0Kt84rOM02F3SDM4yG4Vaf94Ne0+14jLAZyirg@mail.gmail.com>
Subject: Re: [PATCH RFC 3/3] clk: dt: binding for basic divider clock
From: Matt Sealey <neko@bakuhatsu.net>
To: Mike Turquette <mturquette@linaro.org>
Cc: Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 4, 2013 at 2:22 PM, Mike Turquette <mturquette@linaro.org> wrote:
> Quoting Matt Sealey (2013-06-04 10:39:53)
>> On Tue, Jun 4, 2013 at 12:11 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:
>> > On 06/03/13 10:53, Mike Turquette wrote:
>> >> +Required properties:
>> >> +- compatible : shall be "divider-clock".
>> >> +- #clock-cells : from common clock binding; shall be set to 0.
>> >> +- clocks : link to phandle of parent clock
>> >> +- reg : base address for register controlling adjustable divider
>> >> +- mask : arbitrary bitmask for programming the adjustable divider
>> >> +
>> >> +Optional properties:
>> >> +- clock-output-names : From common clock binding.
>> >> +- table : array of integer pairs defining divisors & bitfield values
>> >> +- shift : number of bits to shift the mask, defaults to 0 if not present
>> >> +- index_one : valid divisor programming starts at 1, not zero
>> >> +- index_power_of_two : valid divisor programming must be a power of two
>> >> +- allow_zero : implies index_one, and programming zero results in
>> >> +  divide-by-one
>> >
>> > It's preferred that property names have dashes instead of underscores.
>>
>> I think I have a suggestion or two here..
>>
>> I mailed one to Mike earlier, I have had some mailing list problems
>> which I think are solved now..
>>
>> If you provide a mask for programming the divider, surely the "shift"
>> property is therefore redundant. Unless some device has a completely
>> strange way of doing things and uses two seperated bitfields for
>> programming in the same register, the shift value is simply a function
>> of ffs() on the mask, isn't it? It is nice to put the information
>> specifically in the device tree, but where a shift is not specified
>> it'd probably be a good idea to go about deriving that value that way
>> anyway, right, and if we're doing that.. why specify it?
>
> Shift is optional.  Also I think the integer values in a DTS are
> 32-bits, so if some day someone had a clock driver that needed to write
> to a 64-bit register then shift might be useful there, combined with a
> 32-bit mask.  Or perhaps dtc will have a 64-bit value for that case?  I
> don't know.
>
> I certainly do see your point about only using the mask, and the
> original clock basic types did this a while back before the shift+width
> style came into vogue.
>
> If other reviewers also want to use a pure 32-bit mask and no shift then
> I'll drop it in the next round.

Hmm.. that's a very good point...

You can't have a 64-bit OF property unless you're on a 64-bit platform
or do some really weird workarounds for it (multiple cells etc.).
That's how the OF spec was laid out, it sucks.. but it's the standard
and the DT seems to stay compatible with the general concept. A
supplemental binding to support clock dividers living in 64-bit
registers may be a better way.

You'd need a shift for the mask if you could only do a 32-bit property
(32-bit platform with a 4-byte cell size) and a shift for the bits
that would go into the mask as well as a width property for the
register size to bound the shift..  Too complicated for now. I would
say stick with 32-bit until this magical 64-bit divider register
appears, and then do something slightly different :)

>> Also it may be much simpler to simply define the default clock setup
>> as being an integer divider that follows the form 2^n - I am not sure
>> I can think off the top of my head of any clock dividers doing the
>> rounds that have divide-by-non-power-of-two and if they exist out
>> there (please correct me) they would be the rare ones. I think
>> properties that modify behavior should err on the side of being rarely
>> used and to define unusual behavior, not confirm the status quo.
>
> Please review the current use of CLK_DIVIDER_POWER_OF_TWO in the kernel.

You're right, I think I got it backwards or was actually thinking of
allow_zero (as in, 0x0 divider = divide by 1)? i.MX definitely has
more 0x0=div-by-1 than any other kind..

>> In any case, once you figure out that, rather than specifying a full
>> table of <0 1>, <1 2>, <2, 4> and creating a big list, you could just
>> give the lower and upper limits and let the driver figure out what is
>> in between with two values. If there were gaps, a full table would be
>> necessary. The allow zero property might be better served by the very
>> same range property.
>
> You have described how it already works.  The table is only there for
> when a common formula fails to capture the possible divisor
> combinations.  For the default the driver starts the index at 0 and goes
> up to mask/width, for index_one the driver does the same but starts at
> 1, not 0, for power of two ... well you get the picture.  The table is
> only of use when these common divider schemes are insufficient to
> determine the divisors.

Right, but in the case of index_one and allow_zero, one property for
ranges basically covers the case where a slight modification to the
formula used would be required, and allows specifying the first valid
divider and the last valid divider which might come in handy when you
have a mask of a certain size (say, 6 bits), but the actual divider is
only 4 bits wide. You may need to ensure that you clear reserved bits
within that masked region, but not use the mask itself to calculate
the full range.

I can't think of a good case but on i.MX53 the DVFSP load tracking
register 1 has a field that subdivides the ARM core clock by 1, 2 or 3
(using 0, 1 or 2 as the divider value) in a 6-bit field, where
000011-111111 are reserved. I would think the correct value for the
mask is the full 6-bit field, but the range should define that only
1-3 are valid (saving one entry). It isn't really something that would
end up using a clock framework divider though.

If there's a divider built for future expandability or somehow
restricted at the design level to only accept a few bits, or only
'restricted' at the documentation level (.. it's been done) then it
might be best to use the mask to mask off the register, and not to
define valid bits to set, unless you resolve to specify two masks..
but a range property would be better and cover every case, while not
having to force DT writers to list every divider in a big field
(imagine if it's 3 bits that's a 16 entry table.. there are some 5 and
6-bit clock dividers floating around), I think an opportunity to
consolidate two properties into one AND give an easy out to
oddly-ranged dividers (where low and high divider settings may be
'invalid' but between those values is a contiguous range of a
significant number of values (and here I would say, more than 2).

Since we shouldn't be guessing, divider-p-o-2 is still required but as
you corrected me.. rarer.

>> I would also say.. bit-mask rather than mask, divider-table rather
>> than table, divider-range (modifying the idea above). While we're
>> inside a particular namespace in the binding I think naming properties
>> with their intent (i.e. what table is it?) is good behavior.
>>
>
> I'll make the properties more verbose in the next patch.

Lovely :)

-- 
Matt Sealey <matt@genesi-usa.com>
