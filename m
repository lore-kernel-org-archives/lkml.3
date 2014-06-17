Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965955AbaFQRAY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 13:00:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11565 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965072AbaFQRAV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 13:00:21 -0400
Message-ID: <1403024391.3707.139.camel@ul30vt.home>
Subject: Re: [Intel-gfx] [PATCH v2] iommu/intel: Exclude devices using RMRRs
 from IOMMU API domains
From: Alex Williamson <alex.williamson@redhat.com>
To: Daniel Vetter <daniel@ffwll.ch>
Cc: David Woodhouse <dwmw2@infradead.org>, iommu@lists.linux-foundation.org,
        chegu_vinod@hp.com, linux-kernel@vger.kernel.org,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>
Date: Tue, 17 Jun 2014 10:59:51 -0600
In-Reply-To: <20140617164531.GQ5821@phenom.ffwll.local>
References: <20140613162901.4550.94476.stgit@bling.home>
	 <1402983303.3707.94.camel@ul30vt.home>
	 <1402988692.7595.106.camel@i7.infradead.org>
	 <1403007757.3707.100.camel@ul30vt.home>
	 <1403008864.7595.144.camel@i7.infradead.org>
	 <1403010982.3707.123.camel@ul30vt.home>
	 <20140617134408.GM5821@phenom.ffwll.local>
	 <1403014547.3707.130.camel@ul30vt.home>
	 <20140617164531.GQ5821@phenom.ffwll.local>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-06-17 at 18:45 +0200, Daniel Vetter wrote:
> On Tue, Jun 17, 2014 at 08:15:47AM -0600, Alex Williamson wrote:
> > On Tue, 2014-06-17 at 15:44 +0200, Daniel Vetter wrote:
> > > On Tue, Jun 17, 2014 at 07:16:22AM -0600, Alex Williamson wrote:
> > > > On Tue, 2014-06-17 at 13:41 +0100, David Woodhouse wrote:
> > > > > On Tue, 2014-06-17 at 06:22 -0600, Alex Williamson wrote:
> > > > > > On Tue, 2014-06-17 at 08:04 +0100, David Woodhouse wrote:
> > > > > > > On Mon, 2014-06-16 at 23:35 -0600, Alex Williamson wrote:
> > > > > > > > 
> > > > > > > > Any idea what an off-the-shelf Asus motherboard would be doing with an
> > > > > > > > RMRR on the Intel HD graphics?
> > > > > > > > 
> > > > > > > > dmar: RMRR base: 0x000000bb800000 end: 0x000000bf9fffff
> > > > > > > > IOMMU: Setting identity map for device 0000:00:02.0 [0xbb800000 - 0xbf9fffff]
> > > > > > > 
> > > > > > > Hm, we should have thought of that sooner. That's quite normal — it's
> > > > > > > for the 'stolen' memory used for the framebuffer. And maybe also the
> > > > > > > GTT, and shadow GTT and other things; I forget precisely what, and it
> > > > > > > varies from one setup to another.
> > > > > > 
> > > > > > Why exactly do these things need to be identity mapped through the
> > > > > > IOMMU?  This sounds like something a normal device might do with a
> > > > > > coherent mapping.
> > > > > 
> > > > > The BIOS (EFI or VESA) sets up a framebuffer in stolen main memory. It's
> > > > > accessed by DMA, using the physical address. The RMRR exists because we
> > > > > need it *not* to suddenly stop working the moment the OS turns on the
> > > > > IOMMU.
> > > > > 
> > > > > The OS graphics driver, if any, is not loaded at this point.
> > > > > 
> > > > > And even later, the OS graphics driver may choose to make use of the
> > > > > 'stolen' memory for various purposes. And since it was already stolen,
> > > > > it doesn't go and set up *another* mapping for it; it knows that a
> > > > > mapping already exists.
> > > > > 
> > > > > > > I'd expect fairly much all systems to have an RMRR for the integrated
> > > > > > > graphics device if they have one, and your patch¹ is going to prevent
> > > > > > > assignment of those to guests... as you've presumably noticed.
> > > > > > > 
> > > > > > > I'm not sure if the i915 driver is capable of fully reprogramming the
> > > > > > > hardware to completely stop using that region, to allow assignment to a
> > > > > > > guest with a 'pure' memory map and no stolen region. I suppose it must,
> > > > > > > if assignment to guests was working correctly before?
> > > > > > 
> > > > > > IGD assignment has never worked with KVM.
> > > > > 
> > > > > Hm. It works with Xen though, doesn't it?
> > > > 
> > > > Apparently
> > > > 
> > > > > Are we content to say that it'll *never* work with KVM, and thus we can
> > > > > live with the fact that your patch makes it harder to fix whatever was
> > > > > wrong in the first place?
> > > > 
> > > > Probably not.  However, it seems like you're saying that this RMRR is
> > > > used by and visible to OS level drivers, versus backchannel
> > > > communication channels, invisible to the OS.  I think the latter is
> > > > specifically what we want to prevent by excluding devices with RMRRs.
> > > > This is a challenging use case, but it seems to be understood.  If when
> > > > IGD is bound to vfio-pci we can be sure that access to the RMRR area
> > > > ceases, then we can tear it down and re-establish it from
> > > > userspace/QEMU, describe it to the guest in an e820 reserved region, and
> > > > never consider hotplug of the device for guests.  If that's the case,
> > > > maybe it's another exception, like USB.  I'll need to look through i915
> > > > more to find how the region is discovered.  Thanks,
> > > 
> > > We have a bunch of register in the mmio bar set up by the bios that tells
> > > us the address and size of the stolen range we can use. The address we
> > > need for programming ptes, the size to know how much there is. We also
> > > have an early boot pci quirk in x86 nowadays to make sure the pci layer
> > > doesn't put random stuff in that range.
> > > 
> > > See drivers/gpu/drm/i915/i915_gem_gtt.c (search for stolen size)
> > > i915_gem_stolen.c (look at stolen_to_phys) and the early quirks in
> > > arch/x86/kernel/early-quirks.c for copies of the same code.
> > 
> > Thanks for the tips.  If the purpose of the RMRR is to maintain
> > consistency across the OS enabling VT-d, then there's really no reason
> > for this to be identity mapped in a guest (where VT-d is not exposed) is
> > there?  It may waste the memory that's already reserved on the platform
> > to not setup an identity map, but I could back stolen memory by
> > non-stolen user memory, couldn't I?  It might be nice to avoid adding an
> > identity mapping interface to the IOMMU API, even if it costs some
> > memory to do so.  Or maybe I could expose the RMRR area through the VFIO
> > device file descriptor, allow it to be mmap'd there, then allow that
> > mmap to be mapped through the IOMMU.  Thanks,
> 
> The stolen range is locked down at boot in the memory controller and at
> least on some platforms not cpu accessible. Also our gpu is famous for
> warts in the tlb and pte lookup hw, so I wouldn't be surprised at all if
> the stolen range couldn't be backed by normal memory. Our driver otoh will
> survive if you set the stolen size to 0 (with slight feature degration).

Do you know if the same is true of the Windows driver for stolen size?
We can easily set the guest physical address of stolen memory to match
the physical hardware, which would hopefully keep the GPU happy, but if
it's special at the memory controller level, it sounds like we'd really
need to identity map it.  Thanks,

Alex

