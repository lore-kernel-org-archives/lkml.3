Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752943AbaBXXtd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 18:49:33 -0500
Received: from mail-lb0-f171.google.com ([209.85.217.171]:42428 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752598AbaBXXta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 18:49:30 -0500
MIME-Version: 1.0
In-Reply-To: <201402241200.21944.arnd@arndb.de>
References: <201402241200.21944.arnd@arndb.de>
Date: Tue, 25 Feb 2014 08:49:28 +0900
Message-ID: <CANqRtoTLUfK7bjhmUbTdBi7r7OzrmwdAg_wnRbGHN7EUjGtouQ@mail.gmail.com>
Subject: Re: DMABOUNCE in pci-rcar
From: Magnus Damm <magnus.damm@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Magnus Damm <damm@opensource.se>, linux-pci@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Simon Horman <horms+renesas@verge.net.au>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        SH-Linux <linux-sh@vger.kernel.org>, Ben Dooks <ben-linux@fluff.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 24, 2014 at 8:00 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> Hi Magnus,
>
> I noticed during randconfig testing that you enabled DMABOUNCE for the
> pci-rcar-gen2 driver as posted in this patch https://lkml.org/lkml/2014/2/5/30

Hi Arnd,

The patch that you are referring to has been updated a few times, but
I believe your comments are still valid for the series
[PATCH v2 00/08] PCI: rcar: Recent driver patches from Ben Dooks and me (V2)

> I didn't see the original post unfortunately, but I fear we have to
> revert it and come up with a better solution, as your approach seems
> wrong on a number of levels:
>
> * We really don't want any new users of DMABOUNCE on ARM but instead leave
>   it to the PXA/IXP/SA1100 based platforms using it today.
>
> * If your SoCs have an IOMMU, you should really use it, as that would
>   give you much better performance than bounce buffers anyway
>
> * If the hardware is so screwed up that you have to use bounce buffers,
>   use the SWIOTLB code that is reasonably modern.

>From my point of view we need some kind of bounce buffer unless we
have IOMMU support. I understand that an IOMMU would be much better
than a software-based implementation. If it is possible to use an
IOMMU with these devices remain to be seen.

I didn't know about the SWIOTLB code, neither did I know that
DMABOUNCE was supposed to be avoided. Now I do!

I do realize that my following patches madly mix potential bus code
and actual device support, however..

[PATCH v2 06/08] PCI: rcar: Add DMABOUNCE support
[PATCH 07/08] PCI: rcar: Enable BOUNCE in case of HIGHMEM

.. without my patches the driver does not handle CONFIG_BOUNCE and
CONFIG_VMSPLIT_2G.

> * The window base and size in the driver should not be hardcoded, as
>   this is likely not a device specific property but rather an artifact of
>   how it's connected. Use the standard "dma-ranges" property.

I'm afraid that I may not understand your concern fully here. From my
view the existing driver (without my patch) is having hard coded
board-specific memory base and a hard coded size in it, and with my
patches I try to rework that. Do you have any existing example code to
recommend me?

Regarding what the device can do and/or how it is connected - here is
some hardware information:

1) 3 on-chip PCI bridges per SoC with USB EHCI/OHCI controllers on
each of them (PCI bridge code is also shared between multiple SoCs and
of course multiple boards).

2) The systems have 40-bit physical address space and the CPU can
address this when LPAE is enabled.

3) System RAM is available in two banks - one bank in the lowest
32-bits (top 8 bits set to 0) and another bank in higher space.

4) The PCI bridge has a 32-bit base address for the windows with
alignment requirement (needs to be evenly aligned based on size)

5) Each PCI bridge instance has two windows, but supported size
differs. One window supports up to 2 GiB, another 256MiB.

Without IOMMU available I came to the conclusion that I need both
BOUNCE and DMABOUNCE to support the above hardware.

> * You should not need your own dma_map_ops in the driver. What you
>   do there isn't really specific to your host but should live in some
>   place where it can be shared with other drivers.

I think this boils down to the less-than-32-bit bus master capability
and also the poor match to a DMA zone. Consider 24-bit ISA DMA address
space vs 31-bit DMA space on a 32-bit system. I may be wrong, but a
DMA zone in my mind is something suitable for the classic ISA DMA, not
so much for modern complex systems with multiple devices that come
with different bus master capabilities.

That said, of course it makes sense to share code whenever possible.
Can you explain a bit more what kind of code you would like to have
broken out?

> * The implementation of the dma_map_ops is wrong: at the very least,
>   you cannot use the dma_mask of the pci host when translating
>   calls from the device, since each pci device can have a different
>   dma mask that is set by the driver if it needs larger or smaller
>   than 32-bit DMA space.

The current version of the driver (with or without my patch) seems to
leave all dma mask handling left out. I understand that this is poor
programming practise and I would like to see that fixed. As you
noticed, I did not try to fix this issue in my patch.

It may be worth noticing that the PCI devices hanging off the PCI
bridge instances are all on-chip fixed to OHCI and EHCI and the
drivers for these USB host controllers do not seem to try to set the
dma mask as it is today. So we are talking about a fixed set of PCI
devices here and not external PCI bus with general purpose PCI
drivers. I'm not sure if that makes things much better though..

So yes, I'd like the PCI bridge driver to be fixed with proper dma
mask handling. The question is just what that mask is supposed to
represent on a system where we a) may have IOMMU (and if so we can
address 40 bits), and if not we b) are limited to 31 bits but we also
have a non-zero base address. I'm not sure how to represent that
information with a single dma mask. Any suggestions?

> * The block bounce code can't be enabled if CONFIG_BLOCK is disabled,
>   this is how I noticed your changes.

Do you mean that the following patch is causing some kind of build error?
[PATCH 07/08] PCI: rcar: Enable BOUNCE in case of HIGHMEM

If possible, can you please let me know which patches that you want me
to rework?

> * The block layer assumes that it will bounce any highmem pages,
>   but that isn't necessarily what you want here: if you have 2GB
>   of lowmem space (CONFIG_VMSPLIT_2G) or more, you will also have
>   lowmem pages that need bouncing.

Good to hear that you also came to the conclusion that the two cases
need to be handled separately. =)

The lowmem bounce case (CONFIG_VMSPLIT_2G) is implemented in:
[PATCH v2 06/08] PCI: rcar: Add DMABOUNCE support

The block layer bounce is also enabled in:
[PATCH 07/08] PCI: rcar: Enable BOUNCE in case of HIGHMEM

> * (completely unrelated, I noticed you set up a bogus I/O space
>   window. Don't do that, you will get get a panic if a device happens
>   to use it. Not providing an resource should work fine though)

Right. To be honest, I'm not sure why the original author implemented
this. Similar to the dma mask bits this is something that I would like
to fix, but it has been out of scope for my patches so far.

> On the bright side, your other changes in the same series all look
> good. Thanks especially for sorting out the probe() function, I was
> already wondering if we could change that the way you did.

Thanks. Ideally I'd like to support bind and unbind on the bridge too
(CARDBUS can hotplug PCI, so should we!), but I suppose that sorting
out the bounce bits is more important.

Also, the SWIOTLB code, are you aware of any existing ARM users? I
also wonder if the code can work with multiple devices - the bits in
lib/swiotlb.c looks like single instance with global system wide
support only - perhaps it needs rework to support 3 PCI bridges?

Thanks for your help, I appreciate your feedback.

Cheers,

/ magnus
