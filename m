Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754490Ab3HBVby (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 17:31:54 -0400
Received: from mail-qa0-f47.google.com ([209.85.216.47]:60706 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752907Ab3HBVbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 17:31:42 -0400
MIME-Version: 1.0
In-Reply-To: <20130802081315.GA7656@atomide.com>
References: <20130731073802.GT7656@atomide.com>
	<20130731152131.GW2296@suse.de>
	<20130802081315.GA7656@atomide.com>
Date: Fri, 2 Aug 2013 16:31:41 -0500
Message-ID: <CAHCPf3v75tJyUGzxcrPfWW7V+bVxPCJupnDV4UbDQsrsXBXTrQ@mail.gmail.com>
Subject: Re: [Ksummit-2013-discuss] [ATTEND] [ARM ATTEND] kernel data bloat
 and how to avoid it
From: Matt Sealey <neko@bakuhatsu.net>
To: Tony Lindgren <tony@atomide.com>
Cc: Mel Gorman <mgorman@suse.de>,
        "ksummit-2013-discuss@lists.linuxfoundation.org" 
	<ksummit-2013-discuss@lists.linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 2, 2013 at 3:13 AM, Tony Lindgren <tony@atomide.com> wrote:
> * Mel Gorman <mgorman@suse.de> [130731 08:28]:
>> On Wed, Jul 31, 2013 at 12:38:03AM -0700, Tony Lindgren wrote:
>> > Hi all,
>> >
>> > Probably the biggest kernel data bloat issue is in the ARM land, but
>> > it also seems that it's becoming a Linux generic issue too, so I
>> > guess it could be discussed in either context.
>> >
>>
>> Would scripts/bloat-o-meter highlight where the growth problems are?
>
> Well to some extent yes, the board/SoC/driver specific options are
> often behind Kconfig options. So if you want to limit the set of
> supported SoCs and drivers for the kernel you can optimize it out.
>
> The bloat-o-meter won't help for things like checking that a device
> tree binding really describes the hardware, and is not just pointing
> to a table of defined registers in the device driver.

Specifically naming and shaming, like arch/arm/mach-imx/clk-*.c kind
of bloat where names of clocks, their bit definitions etc. are
extremely specific to the chip but also can change per-board and
should be in the device tree? It would be possible to list and parse
all these clocks in about 1/3rd of the code of one of those files and
have it work on every one of the SoCs they cover, if they're
adequately described in the device tree (which gives an opportunity to
stop changing the clock binding for each SoC to add new "numbers" for
"clocks we forgot" and also allow registration of ONLY the
board-specific clocks, on a per-board basis (if you don't use the TVE
or SATA, why define a clock for it just to turn it off?).

There's not a lot else going on with regards to "too much data in the
kernel that shouldn't be in the kernel" to my mind that won't
eventually get taken out once bindings in the DT. Most other platforms
are pretty sane in this regard - what is left is legacy stuff for
boards that don't have DTs and methods are in place to boot similar
boards with DT-only. As above, Mike Turquette and the OMAP guys are
doing something very similar here.

What you'd suggest/need is a review by maintainers of each platform
they support for any static data they are maintaining that can either
be excised by moving it to the device tree as boot
configuration/description data, if that data is not basically constant
anyway, or just by getting rid of rare and unused boards. The PowerPC
guys had a great cull when they moved from arch-ppc to arch-powerpc
and decided no non-DT boards allowed. Anything that didn't get ported
got deleted when arch-ppc went away. The arm arch kernel tree doesn't
have the luxury of a hard expiration in place..

~

BTW Mike, the solution is big device trees with clock data. The kernel
*should* be pure logic, not description and data tables (data tables
are exactly why Device Trees exist!) except where they are a
fundamental constant. Clock trees are a *PER BOARD WORLD* even if they
use the same SoC.

I would - and have since the dawn of time - advocate doing it the way
you're doing it (250 clocks in the tree!!! GANBATTE!!!) simply because
the "logic" behind mapping clocks to numbers is obtuse and needs to be
reproduced in very limited ways - adding a clock that was previously
undefined but of a common, already-used structure (like a gate or mux
that had no previous driver to use it) means modifying the kernel AND
the device tree (and update the binding!). In this case, they are
doing it wrong and I keep seeing patches to add 2 or 3 new clocks per
merge window, and absolutely NONE of them are the JTAG clock, I keep
having to add that in to every kernel I test. It shouldn't be a
compile-time thing to boot, it should be a "which DT do I pick, the
one with JTAG or the one without?" issue. We should ONLY have to
change the device tree - individual clock type bindings would be
fixed, boards would have to define their clocks. Since any external
clocks and peripherals have to be validated by board designers anyway
(for stability), everyone will know exactly what every board will need
per peripheral and be able to define their own clock trees with fixed
parents if need be. Vendors can provide suitable reference trees that
match the full, clumsy configuration of an entire SoC for board
bringup and we should be enabling (as in DT status="okay" property)
the clocks that make sense on that board.

There's a major advantage as above - if you do not use the clock on
your board, you do not have to specify it. It may be left on by the
bootloader and drain power and cause noise and screw parenting for
muxes, but then that's an issue for the bootloader dev guys to
resolve.

The reason consensus doesn't flow that way is because "it is a lot of
work to do this in device tree" but someone wrote out those 5 or 6
board files already and so far the clock subsystem has been rewritten
like 4 times in the meantime. None of Freescale's BSPs (for example)
use the same clock subsystem as they update to new kernels.

I *will* change the i.MX stuff one day if I ever find the time. I
started already but I need to forward port it to a modern version and
get one of my boards fixed..

--
Matt
