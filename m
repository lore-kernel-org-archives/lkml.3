Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756920AbaFSBrt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 21:47:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18086 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752726AbaFSBrr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 21:47:47 -0400
Message-ID: <1403142438.3707.234.camel@ul30vt.home>
Subject: Re: [Intel-gfx] [PATCH v2] iommu/intel: Exclude devices using RMRRs
 from IOMMU API domains
From: Alex Williamson <alex.williamson@redhat.com>
To: Daniel Vetter <daniel@ffwll.ch>
Cc: David Woodhouse <dwmw2@infradead.org>, iommu@lists.linux-foundation.org,
        chegu_vinod@hp.com, linux-kernel@vger.kernel.org,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>
Date: Wed, 18 Jun 2014 19:47:18 -0600
In-Reply-To: <1403128088.3707.223.camel@ul30vt.home>
References: <20140613162901.4550.94476.stgit@bling.home>
	 <1402983303.3707.94.camel@ul30vt.home>
	 <1402988692.7595.106.camel@i7.infradead.org>
	 <1403007757.3707.100.camel@ul30vt.home>
	 <1403008864.7595.144.camel@i7.infradead.org>
	 <1403010982.3707.123.camel@ul30vt.home>
	 <20140617134408.GM5821@phenom.ffwll.local>
	 <1403128088.3707.223.camel@ul30vt.home>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-06-18 at 15:48 -0600, Alex Williamson wrote:
> On Tue, 2014-06-17 at 15:44 +0200, Daniel Vetter wrote:
> > On Tue, Jun 17, 2014 at 07:16:22AM -0600, Alex Williamson wrote:
> > > On Tue, 2014-06-17 at 13:41 +0100, David Woodhouse wrote:
> > > > On Tue, 2014-06-17 at 06:22 -0600, Alex Williamson wrote:
> > > > > On Tue, 2014-06-17 at 08:04 +0100, David Woodhouse wrote:
> > > > > > On Mon, 2014-06-16 at 23:35 -0600, Alex Williamson wrote:
> > > > > > > 
> > > > > > > Any idea what an off-the-shelf Asus motherboard would be doing with an
> > > > > > > RMRR on the Intel HD graphics?
> > > > > > > 
> > > > > > > dmar: RMRR base: 0x000000bb800000 end: 0x000000bf9fffff
> > > > > > > IOMMU: Setting identity map for device 0000:00:02.0 [0xbb800000 - 0xbf9fffff]
> > > > > > 
> > > > > > Hm, we should have thought of that sooner. That's quite normal — it's
> > > > > > for the 'stolen' memory used for the framebuffer. And maybe also the
> > > > > > GTT, and shadow GTT and other things; I forget precisely what, and it
> > > > > > varies from one setup to another.
> > > > > 
> > > > > Why exactly do these things need to be identity mapped through the
> > > > > IOMMU?  This sounds like something a normal device might do with a
> > > > > coherent mapping.
> > > > 
> > > > The BIOS (EFI or VESA) sets up a framebuffer in stolen main memory. It's
> > > > accessed by DMA, using the physical address. The RMRR exists because we
> > > > need it *not* to suddenly stop working the moment the OS turns on the
> > > > IOMMU.
> > > > 
> > > > The OS graphics driver, if any, is not loaded at this point.
> > > > 
> > > > And even later, the OS graphics driver may choose to make use of the
> > > > 'stolen' memory for various purposes. And since it was already stolen,
> > > > it doesn't go and set up *another* mapping for it; it knows that a
> > > > mapping already exists.
> > > > 
> > > > > > I'd expect fairly much all systems to have an RMRR for the integrated
> > > > > > graphics device if they have one, and your patch¹ is going to prevent
> > > > > > assignment of those to guests... as you've presumably noticed.
> > > > > > 
> > > > > > I'm not sure if the i915 driver is capable of fully reprogramming the
> > > > > > hardware to completely stop using that region, to allow assignment to a
> > > > > > guest with a 'pure' memory map and no stolen region. I suppose it must,
> > > > > > if assignment to guests was working correctly before?
> > > > > 
> > > > > IGD assignment has never worked with KVM.
> > > > 
> > > > Hm. It works with Xen though, doesn't it?
> > > 
> > > Apparently
> > > 
> > > > Are we content to say that it'll *never* work with KVM, and thus we can
> > > > live with the fact that your patch makes it harder to fix whatever was
> > > > wrong in the first place?
> > > 
> > > Probably not.  However, it seems like you're saying that this RMRR is
> > > used by and visible to OS level drivers, versus backchannel
> > > communication channels, invisible to the OS.  I think the latter is
> > > specifically what we want to prevent by excluding devices with RMRRs.
> > > This is a challenging use case, but it seems to be understood.  If when
> > > IGD is bound to vfio-pci we can be sure that access to the RMRR area
> > > ceases, then we can tear it down and re-establish it from
> > > userspace/QEMU, describe it to the guest in an e820 reserved region, and
> > > never consider hotplug of the device for guests.  If that's the case,
> > > maybe it's another exception, like USB.  I'll need to look through i915
> > > more to find how the region is discovered.  Thanks,
> > 
> > We have a bunch of register in the mmio bar set up by the bios that tells
> > us the address and size of the stolen range we can use. The address we
> > need for programming ptes, the size to know how much there is. We also
> > have an early boot pci quirk in x86 nowadays to make sure the pci layer
> > doesn't put random stuff in that range.
> > 
> > See drivers/gpu/drm/i915/i915_gem_gtt.c (search for stolen size)
> > i915_gem_stolen.c (look at stolen_to_phys) and the early quirks in
> > arch/x86/kernel/early-quirks.c for copies of the same code.
> 
> Ok, here's what I observe on my system for a few settings of iGPU memory
> size in the BIOS.  The device ID for this IGD is 0152, so I'm using the
> gen6_stolen_funcs stolen functions from early quirks for stolen
> base/size.  I also report the ASL Storage base, ie. the opregion since
> that also needs to be punched through if this device were to be
> assigned.
> 
> "1024M"
> [    0.628033] IOMMU: Setting identity map for device 0000:00:02.0 [0xbf800000 - 0xbf9fffff]
> [    0.000000] BIOS-e820: [mem 0x00000000bf800000-0x00000000bf9fffff] reserved
> 
> setpci -s 2.0 5c.l
> 7fa00001
> setpci -s 2.0 50.l
> 00000289
> 
> (289 >> 3) & 1f = 0x11, 17 * 32M = 544M
> 
> stolen memory range: 7fa00000-a1bfffff
> 
> setpci -s 2.0 fc.l
> 7ebb7018
> 
> So for the max iGPU memory option, our RMRR is 2M and it contains
> neither the stolen memory nor the opregion (it never contains the
> opregion apparently).  If the purpose of the RMRR is to maintain access
> to the framebuffer in stolen memory across VT-d enabling, how does it
> work here?  What's in the 2M RMRR and would it need to be mapped to a
> guest if we wanted to support IGD assignment?
> 
> "512M"
> [    0.627083] IOMMU: Setting identity map for device 0000:00:02.0 [0x9f800000 - 0xbf9fffff]
> [    0.000000] BIOS-e820: [mem 0x000000009f800000-0x00000000bf9fffff] reserved
> 
> setpci -s 2.0 5c.l
> 9fa00001
> setpci -s 2.0 50.l
> 00000281
> 
> (281 >> 3) & 1f = 0x10, 16 * 32M = 512M
> 
> stolen memory range: 9fa00000-bf9fffff
> 
> setpci -s 2.0 fc.l
> 9ebb7018
> 
> With 512M iGPU memory, we're at least now using the RMRR for stolen
> memory, but we still have an additional mystery 2M in the RMRR since
> it's actually a 514M range.
> 
> "256M"
> [    0.626030] IOMMU: Setting identity map for device 0000:00:02.0 [0xaf800000 - 0xbf9fffff]
> [    0.000000] BIOS-e820: [mem 0x00000000af800000-0x00000000bf9fffff] reserved
> 
> setpci -s 2.0 5c.l
> afa00001
> setpci -s 2.0 50.l
> 00000241
> 
> (241 >> 3) & 1f = 0x8, 8 * 32M = 256M
> 
> stolen memory range: afa00000-bf9fffff
> 
> setpci -s 2.0 fc.l
> aebb7018
> 
> The 256M setting is a repeat of 512M, the RMRR is 258M and 256M of it is
> stolen memory.
> 
> So we can say that sometimes the RMRR contains the stolen memory used as
> a framebuffer, but that stolen memory is not always mapped with an RMRR
> and there's an additional 2M in the RMRR that's still a mystery.  If we
> wanted to support assignment of IGD, we could map the stolen memory and
> the opregion, but what do we do that that extra RMRR space?  Ignore it?
> Map it?  How do we find it from the device?  Thanks,

Finding some more specs... the MGGC0 register (50h) seems to indicate
the GTT stolen memory size is 2M, which sounds suspiciously like the 2M
that the RMRR is reporting.  However, from the IvyBridge MMIO, Media
Registers & Programming Env manual:

        4.6.1 Changes to GTT
        
        The GTT is constrained to be located at the beginning of a
        special section of stolen memory called the GTT stolen memory
        (GSM). There is no longer an MMIO register containing the
        physical base address of the GTT as on prior devices. Instead of
        using the PGTBL_CTL register to specify the base address of the
        GTT, the GTT base is now defined to be at the bottom (offset 0)
        of GSM.
        
        Since the graphics device (including the driver) knows nothing
        about the location of GSM, it does not “know” where the GTT is
        located in memory. In fact, the CPU cannot directly access the
        GSM containing the GTT.

That seems to suggest we can't discover this region from the device, but
the device does need to maintain access to it... I don't know how to
resolve that without exposing the RMRR through the IOMMU API.

In any case, I don't know that any of this should block the original
patch.  All of this seems like "acceptable" use of RMRRs that we can
later add an exception to allow if we get to the point of understanding
it and being able to reproduce any required mappings in the guest.
Thanks,

Alex

