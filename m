Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756795AbaHYXlA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 19:41:00 -0400
Received: from mail-oi0-f48.google.com ([209.85.218.48]:40358 "EHLO
	mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755334AbaHYXk6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 19:40:58 -0400
MIME-Version: 1.0
In-Reply-To: <20140821164705.GA1172@ulmo>
References: <1408381749-14156-1-git-send-email-dianders@chromium.org>
	<20140820153801.GB3427@ulmo>
	<CAD=FV=Xf4Hm5tCaaW3QG-ZSQGovh6RKH=1Og1K-yxj+jKyGsmA@mail.gmail.com>
	<2927513.T62GI7nq9T@phil>
	<20140821063637.GB4486@ulmo>
	<CAD=FV=XKr0T-mwma1WdTKQDVyS06rbj3=J4GwbAkc1KsXQspOw@mail.gmail.com>
	<20140821164705.GA1172@ulmo>
Date: Mon, 25 Aug 2014 16:40:57 -0700
X-Google-Sender-Auth: BsQGH_xuZkarWROt0xG7tFnu-Kk
Message-ID: <CAD=FV=U6S3idZds57G2itFw6mdb-fTVt41Lv_jpBuNuq0fimnA@mail.gmail.com>
Subject: Re: [PATCH 1/4] ARM: rockchip: rk3288: Switch to use the proper PWM IP
From: Doug Anderson <dianders@chromium.org>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        Caesar Wang <caesar.wang@rock-chips.com>,
        Sonny Rao <sonnyrao@chromium.org>, Olof Johansson <olof@lixom.net>,
        Eddie Cai <eddie.cai@rock-chips.com>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tomasz Figa <tomasz.figa@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thierry,

On Thu, Aug 21, 2014 at 9:47 AM, Thierry Reding
<thierry.reding@gmail.com> wrote:
> On Thu, Aug 21, 2014 at 08:38:57AM -0700, Doug Anderson wrote:
>> Thierry,
>>
>> On Wed, Aug 20, 2014 at 11:36 PM, Thierry Reding
>> <thierry.reding@gmail.com> wrote:
>> > On Wed, Aug 20, 2014 at 06:20:31PM +0200, Heiko Stübner wrote:
>> >> Am Mittwoch, 20. August 2014, 08:55:09 schrieb Doug Anderson:
>> >> > Thierry,
>> >> >
>> >> > On Wed, Aug 20, 2014 at 8:38 AM, Thierry Reding
>> >> >
>> >> > <thierry.reding@gmail.com> wrote:
>> >> > > On Wed, Aug 20, 2014 at 08:20:53AM -0700, Doug Anderson wrote:
>> >> > >> Thierry,
>> >> > >>
>> >> > >> On Tue, Aug 19, 2014 at 11:08 PM, Thierry Reding
>> >> > >>
>> >> > >> <thierry.reding@gmail.com> wrote:
>> >> > >> > On Tue, Aug 19, 2014 at 08:18:54AM -0700, Doug Anderson wrote:
>> >> > >> >> Thierry,
>> >> > >> >>
>> >> > >> >> On Tue, Aug 19, 2014 at 12:10 AM, Thierry Reding
>> >> > >> >>
>> >> > >> >> <thierry.reding@gmail.com> wrote:
>> >> > >> >> > On Mon, Aug 18, 2014 at 10:09:06AM -0700, Doug Anderson wrote:
>> >> > >> >> >> The rk3288 SoC has an option to switch all of the PWMs in the
>> >> > >> >> >> system
>> >> > >> >> >> between the old IP block and the new IP block.  The new IP block is
>> >> > >> >> >> working and tested and the suggested PWM to use, so setup the SoC
>> >> > >> >> >> to
>> >> > >> >> >> use it and then we can pretend that the other IP block doesn't
>> >> > >> >> >> exist.
>> >> > >> >
>> >> > >> > A few more questions as to how this actually works. Does it mean there
>> >> > >> > are two physically separate blocks (with different physical addresses)
>> >> > >> > to control the same PWM? And this register simply causes some of the
>> >> > >> > pins to be routed to one or another? As far as I recall there are a
>> >> > >> > number of instances of the PWM block, so the above would need to count
>> >> > >> > for all of them. Or are there separate bits for each of them?
>> >> > >>
>> >> > >> All I have is the TRM (technical reference manual) which doesn't give
>> >> > >> me much more info than I've provided you.  But I can answer some of
>> >> > >> your questoins:
>> >> > >>
>> >> > >> 1. If there are two physically separate blocks then the "old" block is
>> >> > >> not documented in my TRM.
>> >> > >>
>> >> > >> 1a) It's entirely possible it's located at some memory address that is
>> >> > >> marked "Reserved" in the TRM, but I have no idea.
>> >> > >>
>> >> > >> 1b) It's entirely possible that the old IP block and the new IP block
>> >> > >> are supposed to be "compatible" but that the old block is broken and
>> >> > >> thus isn't behaving properly.
>> >> > >>
>> >> > >> 1c) It's entirely possible that the old IP block and the new IP block
>> >> > >> are located at the same physical addresses but somehow work
>> >> > >> differently.  If so, the old IP block isn't documented.
>> >> > >>
>> >> > >>
>> >> > >> 2. As per the patch description, there is a single bit that controls
>> >> > >> all of the PWMs.  My guess is that there's actually a single IP block
>> >> > >> that implements all 4 PWMs.
>> >> > >
>> >> > > Looking at the register offsets in the device tree that seems likely. At
>> >> > > least PWMs 0 and 1 as well as 2 and 3 seem like they could be in the
>> >> > >
>> >> > > same IP block. Their placement in the register map is somewhat strange:
>> >> > >         pwm0: pwm@20030000 {
>> >> > >
>> >> > >                 ...
>> >> > >                 reg = <0x20030000 0x10>;
>> >> > >                 ...
>> >> > >                 clocks = <&cru PCLK_PWM01>;
>> >> > >                 ...
>> >> > >
>> >> > >         };
>> >> > >
>> >> > >         pwm1: pwm@20030010 {
>> >> > >
>> >> > >                 ...
>> >> > >                 reg = <0x20030010 0x10>;
>> >> > >                 ...
>> >> > >                 clocks = <&cru PCLK_PWM01>;
>> >> > >                 ...
>> >> > >
>> >> > >         };
>> >> > >
>> >> > >         ...
>> >> > >
>> >> > >         pwm2: pwm@20050020 {
>> >> > >
>> >> > >                 ...
>> >> > >                 reg = <0x20050020 0x10>;
>> >> > >                 ...
>> >> > >                 clocks = <&cru PCLK_PWM23>;
>> >> > >                 ...
>> >> > >
>> >> > >         };
>> >> > >
>> >> > >         pwm3: pwm@20050030 {
>> >> > >
>> >> > >                 ...
>> >> > >                 reg = <0x20050030 0x10>;
>> >> > >                 ...
>> >> > >                 clocks = <&cru PCLK_PWM23>;
>> >> > >                 ...
>> >> > >
>> >> > >         };
>> >> >
>> >> > Ah, you're looking at "rk3xxx.dtsi".  That doesn't apply to rk3288
>> >> > (the downsides of trying to guess ahead of time what SoC vendors will
>> >> > name new models).
>> >>
>> >> It did sound like a nice idea at the time to hold the common stuff of
>> >> rk3066/rk3188 and all their derivatives and I assumed a SoC that changed
>> >> dramatically (including the core) would be called 4xxx or so :-) .
>> >>
>> >> >
>> >> > In rk3288 they have the same clocks.  See patch #3 in this series.
>> >> >
>> >> > > The clocks would also indicate that there are actually two blocks. I
>> >> > > seem to remember a discussion about whether to handle them as a single
>> >> > > block or two/four, but I can't seem to find a reference to it. Maybe I'm
>> >> > > confusing it with another driver.
>> >> >
>> >> > At this point it seems like the choice has already been made to handle
>> >> > them as separate PWMs.  I can change this choice if you want...
>> >> >
>> >> > >> >> >> This code could go lots of other places, but we've put it here.
>> >> > >> >> >> Why?
>> >> > >> >> >> - Pushing it to the bootloader just makes the code harder to update
>> >> > >> >> >> in
>> >> > >> >> >>
>> >> > >> >> >>   the field.  If we later find a bug in the new IP block and want
>> >> > >> >> >>   to
>> >> > >> >> >>   change our mind about what to use we want it to be easy to
>> >> > >> >> >>   update.
>> >> > >> >
>> >> > >> > Depending on how this muxing works you won't be able to change your
>> >> > >> > mind
>> >> > >> > anyway. If the IP blocks are different then the device tree will
>> >> > >> > effectively make the decision for you. So if you really want to be safe
>> >> > >> > you'd need to have code in the kernel that parses the device tree and
>> >> > >> > checks that all PWM instances are of the new type, then set this
>> >> > >> > register accordingly.
>> >> > >>
>> >> > >> Since there is no documentation about how you would instantiate the
>> >> > >> "old" type in the TRM and no good reason I can think of why someone
>> >> > >> would want to do this, it doesn't seem super fruitful.
>> >> > >
>> >> > > Okay, so if it's not at all documented and never used then yes, we'd
>> >> > > better just ignore it.
>> >> >
>> >> > Heiko just pointed me at the base address for the other block.
>> >> > There's nothing in the rk3288 TRM about it, but we can see the base
>> >> > address.  We could probably guess that it behaves the same as the
>> >> > older PWM if we need to.  I'm still not convinced there's a good
>> >> > reason for someone to use it.
>> >>
>> >> From what I understood the old one was included as a fallback in case some
>> >> drastic problem appeared with the newly developed IP. Similarly for the I2C
>> >> the rk2928 and before contained the old IP, the rk3xxx SoCs did contain both
>> >> old and new i2c IP and now the rk3288 only contains the new one, as the new IP
>> >> seems to have proven stable.
>> >>
>> >> So there really is no incentive to use the old one if no drastic issue has
>> >> appeared with the new one until now.
>> >>
>> >>
>> >> > >> >> >> diff --git a/arch/arm/mach-rockchip/rockchip.c
>> >> > >> >> >> b/arch/arm/mach-rockchip/rockchip.c index 8ab9e0e..99133b9 100644
>> >> > >> >> >> --- a/arch/arm/mach-rockchip/rockchip.c
>> >> > >> >> >> +++ b/arch/arm/mach-rockchip/rockchip.c
>> >> > >> >> >> @@ -24,6 +24,24 @@
>> >> > >> >> >>
>> >> > >> >> >>  #include <asm/hardware/cache-l2x0.h>
>> >> > >> >> >>  #include "core.h"
>> >> > >> >> >>
>> >> > >> >> >> +static void __init rk3288_init_machine(void)
>> >> > >> >> >> +{
>> >> > >> >> >> +     void *grf = ioremap(0xff770000, 0x10000);
>> >> > >> >> >
>> >> > >> >> > This region of memory is part of the "grf" "syscon" device
>> >> > >> >> > (according to
>> >> > >> >> > arch/arm/boot/dts/rk3288.dtsi) so the register should be accessed
>> >> > >> >> > from
>> >> > >> >> > that driver. It looks as if no such driver currently exists, but
>> >> > >> >> > given
>> >> > >> >> > the existence of the device tree node it's fair to assume that one
>> >> > >> >> > will
>> >> > >> >> > eventually be merged.
>> >> > >> >>
>> >> > >> >> The "grf" syscon device is the "general register file".  It's a
>> >> > >> >> collection of totally random registers stuffed together in one address
>> >> > >> >> space.  Sometimes a single 32-bit register has things you need to
>> >> > >> >> tweak for completely different subsystems.
>> >> > >> >>
>> >> > >> >> Most drivers referene the syscon using this in dts:
>> >> > >> >>   rockchip,grf = <&grf>;
>> >> > >> >>
>> >> > >> >> Then the drivers do:
>> >> > >> >>   grf = syscon_regmap_lookup_by_phandle(np, "rockchip,grf");
>> >> > >> >>
>> >> > >> >> See the Rockchip i2c, pinctrl, or clock drivers for examples.
>> >> > >> >
>> >> > >> > That's one way to do it. But if it's really just a one-time thing, then
>> >> > >> > you could easily perform the register write from the syscon driver
>> >> > >> > where
>> >> > >> > the memory is already parsed from device tree and mapped. That way you
>> >> > >> > don't have to hardcode the physical address in some other random piece
>> >> > >> > of code and map the memory again.
>> >> > >>
>> >> > >> Well, except that we're using the general "syscon" driver.  I could
>> >> > >> create a whole new driver that "subclasses" this syscon driver I
>> >> > >> suppose.
>> >> > >
>> >> > > Ah, I wasn't aware that there was even something like a generic syscon
>> >> > > driver. But yes, subclassing it sounds like a reasonable thing to do.
>> >> >
>> >> > I will do that if need be, but it's not my favorite.  I will let
>> >> > others chime in.
>> >>
>> >> I guess personally I like the idea best of just setting the relevant bit in
>> >> _probe of the pwm driver, like the i2c driver does:
>> >>
>> >> if (of_device_is_compatible(np, "rockchip,rk3288-pwm") {
>> >>       /* get regmap and set bit */
>> >> }
>> >>
>> >> The downside would be that the bit would be written 4 times, but I guess this
>> >> shouldn't matter to much. And I don't think anybody will get the idea of
>> >> combining both ip variants in one dts anyway.
>> >> And of course in the next SoC the old IP will mostly have gone away and keep
>> >> this somewhat close to the driver and not scatter pwm settings into other
>> >> kernel parts.
>> >>
>> >> Hacking up the syscon driver feels bad to me, especially as it is meant to be
>> >> generic and export such shared registers to other drivers for just these stuff.
>> >
>> > I think using syscon in the first place is bad. In my opinion it would
>> > be far better to export an explicit API from drivers that are currently
>> > "implemented" as syscon. The thing is, nothing about syscon is truly
>> > generic. All it provides is a memory-mapped I/O region and lets drivers
>> > do to that memory region whatever they wants. But ioremap() can be used
>> > for that purpose already. Yet we have infrastructure to prevent drivers
>> > from doing that (request_resource() and friends) because it's usually a
>> > bad idea. All syscon really gives us is a ratified way of doing things
>> > that are otherwise frowned upon.
>>
>> Agreed that it's a bit awkward, but it's the generally accepted way of
>> doing things across multiple drivers as far as I can tell...
>
> But that's exactly what I've been saying. I consider it a very bad thing
> that this is a generally accepted way. Sure, it's a very easy solution,
> but it also means that all the details about how the syscon registers
> need to be programmed are moved into drivers. That makes them inherently
> non-portable. Consider for example if you have a driver for an IP block
> that's used in one device and needs some registers set in a "syscon"
> device to work on that device. Now somebody licenses the same IP block
> and instantiates it in a completely different design. Now with some luck
> it won't need a syscon's help in the second design, so you can make the
> syscon optional and ignore it. But what if you need to program some
> syscon in the second design as well but it has a different register
> layout?
>
> Admittedly this will also be a problem if you have an explicit API, but
> then it's still better to create the proper abstraction that can be made
> to work on both SoCs, or as in the case of this PWM block you move the
> code that needs to be executed only once into the syscon driver where it
> belongs. That way the driver becomes completely generic, no need to play
> tricks because you (or somebody else for that matter) chose the easy way
> out.
>
>> In exynos we were also doing this.  Another alternative (which I saw
>> used before syscon) was just to list a second address in the "reg =
>> <>".  The second address might only be 4 bytes big if only a single
>> 32-bit register was needed.  That started failing because sometimes
>> two drivers needed to access the same 32-bit register.
>
> That's /exactly/ what syscon does as well (albeit with a bunch of
> overhead).
>
>> At the moment I'm not planning to spin this patch.  If folks come up
>> with a solution that they definitely like better I'm happy to spin it,
>> but for now this seems to work and doesn't seem (to me) to be terribly
>> worse than the alternatives proposed so far.
>
> I still think having a separate syscon driver that does this one-time
> initialization is the proper thing to do.

You probably noticed that I reposted my patches without the offending
parts.  Maybe we could at least land those while we figure things out?

It turns out that right now "syscon" can't be subclassed.  Heiko
pointed me at some WIP patches from Tomasz that allow subclassing of
syscon, but they're not all done yet.

I was doing some thinking about what to do, then.  I wondered whether
the right thing to do is not to make a "rk3288 syscon" driver that
configures these bits, but rather to make a "rk3288" driver has access
to the syscon.  It could live in drivers/soc/rockchip/rk3288.c and we
could give it a handle to the syscon.  It could do the one-time
initialization.  It would also be a place to put special rk3288 APIs
in cases where other drivers need similar things.

What do you think?

-Doug
