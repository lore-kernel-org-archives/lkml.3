Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757574Ab3FEUsa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 16:48:30 -0400
Received: from mail-lb0-f175.google.com ([209.85.217.175]:46428 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757276Ab3FEUs3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 16:48:29 -0400
MIME-Version: 1.0
In-Reply-To: <CAPweEDx3mAy40BZrzrKPRbvg7vKMj7KevDQ3m_v4p6Yo50eSGg@mail.gmail.com>
References: <CAPweEDx3mAy40BZrzrKPRbvg7vKMj7KevDQ3m_v4p6Yo50eSGg@mail.gmail.com>
Date: Wed, 5 Jun 2013 16:48:27 -0400
Message-ID: <CAKON4OyyRF4Z46RyJFDWUwo4L52Z8bgSH0CzDr2gDerw4iDwcw@mail.gmail.com>
Subject: Re: getting allwinner SoC support upstream (was Re: Uploading linux (3.9.4-1))
From: "jonsmirl@gmail.com" <jonsmirl@gmail.com>
To: Luke Kenneth Casson Leighton <lkcl@lkcl.net>
Cc: debian-kernel@lists.debian.org, debian-release@lists.debian.org,
        debian-arm@lists.debian.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux on small ARM machines 
	<arm-netbook@lists.phcomp.co.uk>,
        devicetree-discuss <devicetree-discuss@ozlabs.org>,
        ARM Linux Mailing List <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 5, 2013 at 3:46 PM, Luke Kenneth Casson Leighton
<lkcl@lkcl.net> wrote:
>
> On Fri, May 31, 2013 at 3:52 AM, Ben Hutchings <ben@decadent.org.uk> wrote:
>
> > The 3.8.y branch is over, so I think we have to move to 3.9, ready or
> > not.  I merged the work in progress from trunk to sid and am going
> > through the config changes at the moment.
> >
> > I'm rather disappointed that nothing at all has been committed by ARM
> > porters to either branch in the last month.
>
>  *sigh* i didn't want to leave this as it stood, ben, purely for the
> reason that i don't want to see you discouraged!  but, i also had to
> think a bit about what potentially to say.
>
>  the one SoC family that's going to become increasingly important to
> have both upstream and in debian is support for allwinner's
> processors.  with 40% world-wide tablet market share [*0], they must
> be doing something right, and it's basically getting a staggering
> price-performance value as well as having a set of interfaces and
> level of integration that is really second to none.
>
>  to begin to describe the problem in getting allwinner soc source code
> upstream is this: not only do we have the usual "let's get it out the
> door as fast as possible" learning curve of a very young, very new and
> bewilderingly-successful fabless SoC company, but we also have a
> completely new type of very successful and comprehensive
> device-tree-like dynamic configuration system to deal with, which
> allwinner have called "fex" [*1].
>
>  basically at the time when device-tree was being thought of,
> allwinner needed something that they could *right then* - not waiting
> for developers to finish device-tree - they needed to be able to
> reconfigure their customer's kernels *without* needing a recompile.
> so they invented the script.fex system, which is a simple config.ini
> file-format, compile it to binary, and get the bootloader to upload it
> to memory and read it.


Why don't you try converting the sunxi code over to device tree? I
don't think it will be as hard as you may think it is. Start off by
mapping the existing fex syntax into a DTS file. Send your DTS file to
devicetree-discuss to get help with the correct syntax. Once this DTS
template is constructed you can write a program to convert any fex
file into it.

Now boot with this DTB; that will get all of the existing info into
the kernel's internal FDT.  Then start converting your drivers over to
use the of_ support for accessing the FDT. You've already done all of
the hard work in making the drivers configurable at boot. As a
transition tool allow the kernel to boot with both fex and DT untill
you get all of the drivers converted.

BTW, device tree has been in the kernel since 2007 (or earlier).
About two years ago the ARM community decided to switch all new
development onto it in order to stop the proliferation of
platform/machine files. I believe the rule about no new non-DT ARM
platforms has been in place for over eighteen months.

If fex is add to the kernel every device driver will have to get two
bindings. One for when the chip is used on a fex machine, and another
when the chip is used with device tree. For example most of the I2C
device drivers have been converted to device tree and they now know
how to interpret device tree data for set up. And so on, and so on --
this problem exists for every bus based device. fex is simply a
re-implementation of device tree. We don't need too implementations of
this.

>
>
>  fex covers *eeeeeevvveeerryyyythiiiing* - right from flipping the
> multiplexing for all 3 SD/MMC cards so that you can pretend that SD0
> is SD2 and you can specify *different* GPIOs for each to say which is


You can do all of this in device tree too. If the exact syntax doesn't
exist you can use 'allwinner,' prefixes on the node names.
Also check out pinctrl so that it doesn't get reinvented.


>
> the detect line, which is the write-protect line, to setting the DRAM
> clock timings, saying which kernel driver must be loaded to support
> the touchscreen, enabling debugging, JTAG, naming the GPIOs for easy
> and convenient use in the kernel code: basically there isn't a single
> piece of hardware on the allwinner SoC family which *isn't*
> reconfigureable through script.fex... and they've even integrated it
> into u-boot *and* their low-level (early) bootloader as well [which


Device tree support has been integrated into uboot for about five years now.


>
> they've just properly complied with the GPL on, hooray! [*2]].
>
> what's the point of mentioning this?
>
> well, the point is: the expectation of the linux kernel developers is
> that Everyone Must Convert To DeviceTree.  implicitly behind that is,
> i believe, an expectation that if you *don't* convert to Device Tree,
> you can kiss upstream submission goodbye.  and, in allwinner's case,
> that's simply not going to happen.
>
> add to this the fact that they've already taken *five* near-identical
> copies of each version of their drivers (for sun3i up to sun7i) - if
> you do a recursive diff in the drivers/usb/sun7i_usb and
> drivers/usb/sun4i_usb directories, the discrepancies are negligeable
> (and are in many cases a regression, reintroducing known or new
> bugs!), you can start to see that they simply have no idea how to work
> with the free software community (they're too busy) and that they're
> not really about to start, either.
>
> ... and yet they're unbelievably successful, despite making a dog's
> dinner of things as far as upstream integration is concerned,
> precisely because they really really do only need to get one single
> kernel compiled (for *all* their multi-million-dollar clients) and
> err... that's it.  everything else goes into a per-client (per
> product) customized script.fex.


Device tree on ARM's goal is to achieve a single kernel across
vendors, not just a single kernel for a single vendor.

>
> so, i don't have all the answers, but i can clearly see that there
> needs to be some discussion and dialog - we can't have the world's
> most successful SoC vendor *not* supported upstream: that's just a
> ridiculous situation that is not helping any of the linux distros to
> be an easy install option on some of the world's highest
> price-performance ratio hardware.
>
> thoughts and discussion appreciated.
>
> l.
>
>
> [*0] http://hardware.slashdot.org/story/13/05/08/1636217/chinas-allwinner-outsold-intel-qualcomm-in-tablet-processors-in-2012
> [*1] - fex guide for SoCs up to but excluding the Allwinner A20
> http://linux-sunxi.org/Fex_Guide
> [*2] http://lists.phcomp.co.uk/pipermail/arm-netbook/2013-June/007619.html and
>       http://lists.phcomp.co.uk/pipermail/arm-netbook/2013-June/007611.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/




--
Jon Smirl
jonsmirl@gmail.com
