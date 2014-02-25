Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752607AbaBYMPt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 07:15:49 -0500
Received: from moutng.kundenserver.de ([212.227.126.131]:57986 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751463AbaBYMPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 07:15:47 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Magnus Damm <magnus.damm@gmail.com>
Subject: Re: DMABOUNCE in pci-rcar
Date: Tue, 25 Feb 2014 13:15:27 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Magnus Damm <damm@opensource.se>, linux-pci@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Simon Horman <horms+renesas@verge.net.au>,
        "linux-kernel" <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "SH-Linux" <linux-sh@vger.kernel.org>, Ben Dooks <ben-linux@fluff.org>
References: <201402241200.21944.arnd@arndb.de> <CANqRtoTLUfK7bjhmUbTdBi7r7OzrmwdAg_wnRbGHN7EUjGtouQ@mail.gmail.com>
In-Reply-To: <CANqRtoTLUfK7bjhmUbTdBi7r7OzrmwdAg_wnRbGHN7EUjGtouQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201402251315.27654.arnd@arndb.de>
X-Provags-ID: V02:K0:5i0gLC9HCi/lgeoM+Hpi6S/7i46kgXUtBc41Qm6PVCt
 4AG9v4LwOY1rM8qfptiEX2J00MuLIp6uXs1K/YGPR86GTyM3W1
 YGj+vYZjSLG9BYnaTLiJpXjO9l8GoQ6DWiFL5Jv9uoqvnU1PDQ
 pnyZD4sozhJbkLy7F1dubF6y3Lc34/IqYx2WvWMGauMB3qKxw6
 V8yHXxDiX43pJfEkZ/OHxIMPTY34Jk+GCwR73A9a/rt/Nxnbs4
 x585uVx3Op6gJtAEsodgIrWbrBefPSFqgttpsnanmq4mjJG4bj
 tSgdY2PFDRpYUlvA3WS0khOkc9oZ7zdrSfrGsp7/occFZC4gQX
 PRgzXQ/tLxF8m9TVSe6s=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 25 February 2014, Magnus Damm wrote:
> On Mon, Feb 24, 2014 at 8:00 PM, Arnd Bergmann <arnd@arndb.de> wrote:

> > * The window base and size in the driver should not be hardcoded, as
> >   this is likely not a device specific property but rather an artifact of
> >   how it's connected. Use the standard "dma-ranges" property.
> 
> I'm afraid that I may not understand your concern fully here. From my
> view the existing driver (without my patch) is having hard coded
> board-specific memory base and a hard coded size in it, and with my
> patches I try to rework that. Do you have any existing example code to
> recommend me?

You are right, this is a preexisting condition, and your patch someone
improves this, just not the way I was hoping for.

At the moment, "dma-ranges" is only used by powerpc platforms, but
we have discussed using it on ARM a couple of times when similar
problems came up. Just today, Santosh Shilimkar posted patches for
mach-keystone, and the PCI support patches that are under review for
arm64 x-gene have a related requirement.

There are two parts to this problem: smaller-than-4GB windows and
windows that are offset to the start of memory. The dma-ranges
approach should handle both. In theory it can also deal with
multiple windows, but we have so far not needed that.

> Regarding what the device can do and/or how it is connected - here is
> some hardware information:
> 
> 1) 3 on-chip PCI bridges per SoC with USB EHCI/OHCI controllers on
> each of them (PCI bridge code is also shared between multiple SoCs and
> of course multiple boards).
> 
> 2) The systems have 40-bit physical address space and the CPU can
> address this when LPAE is enabled.
> 
> 3) System RAM is available in two banks - one bank in the lowest
> 32-bits (top 8 bits set to 0) and another bank in higher space.
> 
> 4) The PCI bridge has a 32-bit base address for the windows with
> alignment requirement (needs to be evenly aligned based on size)
> 
> 5) Each PCI bridge instance has two windows, but supported size
> differs. One window supports up to 2 GiB, another 256MiB.

Thanks for the background. Now, the only real problem is the case where
the window doesn't span all of the RAM below the 4GiB boundary, but
this would be the case at least in the 256MiB window example.

For systems where you have e.g. 2GB of RAM visible below the 4GB
boundary, you shouldn't need any special code aside from refusing
to set a 64-bit dma mask from the driver.

> Without IOMMU available I came to the conclusion that I need both
> BOUNCE and DMABOUNCE to support the above hardware.

You definitely need either DMABOUNCE or SWIOTLB for this case, yes.
The reason for this is that the PCI code assumes that every DMA
master can access all memory below the 4GB boundary if the device
supports it.

I'm less sure about CONFIG_BOUNCE, and Russell already explained
a few things about it that I didn't know. Normally I would expect
the SWIOTLB code to kick in during dma_map_sg() for block devices
just like it does for network and other devices.

> > * You should not need your own dma_map_ops in the driver. What you
> >   do there isn't really specific to your host but should live in some
> >   place where it can be shared with other drivers.
> 
> I think this boils down to the less-than-32-bit bus master capability
> and also the poor match to a DMA zone. Consider 24-bit ISA DMA address
> space vs 31-bit DMA space on a 32-bit system. I may be wrong, but a
> DMA zone in my mind is something suitable for the classic ISA DMA, not
> so much for modern complex systems with multiple devices that come
> with different bus master capabilities.
> 
> That said, of course it makes sense to share code whenever possible.
> Can you explain a bit more what kind of code you would like to have
> broken out?

I was hoping that we can get to a point where we automatically check
the dma-ranges property for platform devices and set the swiotlb
dma_map_ops if necessary. For PCI device, I think each device should
inherit the map_ops from its parent.

> > * The implementation of the dma_map_ops is wrong: at the very least,
> >   you cannot use the dma_mask of the pci host when translating
> >   calls from the device, since each pci device can have a different
> >   dma mask that is set by the driver if it needs larger or smaller
> >   than 32-bit DMA space.
> 
> The current version of the driver (with or without my patch) seems to
> leave all dma mask handling left out. I understand that this is poor
> programming practise and I would like to see that fixed. As you
> noticed, I did not try to fix this issue in my patch.
> 
> It may be worth noticing that the PCI devices hanging off the PCI
> bridge instances are all on-chip fixed to OHCI and EHCI and the
> drivers for these USB host controllers do not seem to try to set the
> dma mask as it is today. So we are talking about a fixed set of PCI
> devices here and not external PCI bus with general purpose PCI
> drivers. I'm not sure if that makes things much better though..

You still have EHCI calling dma_set_mask(DMA_BIS_MASK(64)) to allow high
DMA, while OHCI doesn't allow it, so even with just two possible devices,
you have a conflict.

> So yes, I'd like the PCI bridge driver to be fixed with proper dma
> mask handling. The question is just what that mask is supposed to
> represent on a system where we a) may have IOMMU (and if so we can
> address 40 bits), and if not we b) are limited to 31 bits but we also
> have a non-zero base address. I'm not sure how to represent that
> information with a single dma mask. Any suggestions?

With nonzero base address, do you mean you have to add a number to
the bus address to get to the CPU address? That case is handled by the
patches that Santosh just posted.

Do you always have a 31-bit mask when there is no IOMMU, and have an
IOMMU when there is a smaller mask? That may somewhat simplify the
problem space.

> > * The block bounce code can't be enabled if CONFIG_BLOCK is disabled,
> >   this is how I noticed your changes.
> 
> Do you mean that the following patch is causing some kind of build error?
> [PATCH 07/08] PCI: rcar: Enable BOUNCE in case of HIGHMEM
> 
> If possible, can you please let me know which patches that you want me
> to rework?

The build error could be worked around by changing it to 

	select BOUNCE if BLOCK && MMU && HIGHMEM

but I really think you shouldn't need BOUNCE at all, so this needs more
investigation.

> > * The block layer assumes that it will bounce any highmem pages,
> >   but that isn't necessarily what you want here: if you have 2GB
> >   of lowmem space (CONFIG_VMSPLIT_2G) or more, you will also have
> >   lowmem pages that need bouncing.
> 
> Good to hear that you also came to the conclusion that the two cases
> need to be handled separately. =)
> 
> The lowmem bounce case (CONFIG_VMSPLIT_2G) is implemented in:
> [PATCH v2 06/08] PCI: rcar: Add DMABOUNCE support
> 
> The block layer bounce is also enabled in:
> [PATCH 07/08] PCI: rcar: Enable BOUNCE in case of HIGHMEM

But what do here is to only bounce highmem pages. My point is
that highmem is the wrong key here (as Russell also mentioned)
and that you may also have to bounce lowmem pages.

> > On the bright side, your other changes in the same series all look
> > good. Thanks especially for sorting out the probe() function, I was
> > already wondering if we could change that the way you did.
> 
> Thanks. Ideally I'd like to support bind and unbind on the bridge too
> (CARDBUS can hotplug PCI, so should we!), but I suppose that sorting
> out the bounce bits is more important.

Agreed.

> Also, the SWIOTLB code, are you aware of any existing ARM users? I
> also wonder if the code can work with multiple devices - the bits in
> lib/swiotlb.c looks like single instance with global system wide
> support only - perhaps it needs rework to support 3 PCI bridges?

I haven't looked at the code much, but Xen seems to use it. We can definitely
extend it if you see problems. For instance I think we may have to
wrap them to handle noncoherent buses, as the code was written for x86
and ia64 that are both cache-coherent.

	Arnd
