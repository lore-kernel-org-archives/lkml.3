Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751262AbaKFMW0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 07:22:26 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:19325 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905AbaKFMWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 07:22:23 -0500
X-IronPort-AV: E=Sophos;i="5.07,325,1413244800"; 
   d="scan'208";a="190141219"
Date: Thu, 6 Nov 2014 12:22:13 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Catalin Marinas <catalin.marinas@arm.com>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "Ian.Campbell@citrix.com" <Ian.Campbell@citrix.com>,
        "david.vrabel@citrix.com" <david.vrabel@citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v7 3/8] arm64: introduce is_device_dma_coherent
In-Reply-To: <20141106103337.GA19702@e104818-lin.cambridge.arm.com>
Message-ID: <alpine.DEB.2.02.1411061155200.22875@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1410261621200.22875@kaball.uk.xensource.com> <1414422568-19103-3-git-send-email-stefano.stabellini@eu.citrix.com> <alpine.DEB.2.02.1411031045340.22875@kaball.uk.xensource.com> <20141103105716.GC23162@arm.com>
 <alpine.DEB.2.02.1411031101400.22875@kaball.uk.xensource.com> <20141105165646.GN32700@e104818-lin.cambridge.arm.com> <alpine.DEB.2.02.1411051757140.22875@kaball.uk.xensource.com> <20141106103337.GA19702@e104818-lin.cambridge.arm.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Nov 2014, Catalin Marinas wrote:
> On Wed, Nov 05, 2014 at 06:15:38PM +0000, Stefano Stabellini wrote:
> > On Wed, 5 Nov 2014, Catalin Marinas wrote:
> > > On Mon, Nov 03, 2014 at 11:10:18AM +0000, Stefano Stabellini wrote:
> > > > On Mon, 3 Nov 2014, Will Deacon wrote:
> > > > > On Mon, Nov 03, 2014 at 10:46:03AM +0000, Stefano Stabellini wrote:
> > > > > > On Mon, 27 Oct 2014, Stefano Stabellini wrote:
> > > > > > > Introduce a boolean flag and an accessor function to check whether a
> > > > > > > device is dma_coherent. Set the flag from set_arch_dma_coherent_ops.
> > > > > > > 
> > > > > > > Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> > > > > > > Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> > > > > > > CC: will.deacon@arm.com
> > > > > > 
> > > > > > Will, Catalin,
> > > > > > are you OK with this patch?
> > > > > 
> > > > > It would be nicer if the dma_coherent flag didn't have to be duplicated by
> > > > > each architecture in dev_archdata. Is there any reason not to put it in the
> > > > > core code?
> > > > 
> > > > Yes, there is a reason for it: if I added a boolean dma_coherent flag in
> > > > struct device as Catalin initially suggested, what would be the default
> > > > for each architecture? Where would I set it for arch that don't use
> > > > device tree?
> > > 
> > > You don't need to. An architecture that has coherent DMA always doesn't
> > > need to do anything. One that has non-coherent DMA always only needs to
> > > select HAVE_DMA_NONCOHERENT. One that has a mix of both needs to find a
> > > way to set dev->dma_coherent. Since that's a new API you introduce, it
> > > doesn't break any existing architectures.
> > 
> > I am not sure that this is better than the current patch but I can see
> > that this approach is not too controversial, so I am happy to go with
> > whatever the maintainers prefer.
> 
> Functionally it is the same, but just less code duplication.
> 
> > > Note that if !is_device_dma_coherent(), it doesn't always mean that
> > > standard cache maintenance would be enough (but that's a Xen problem,
> > > not sure how to solve).
> > 
> > It is a thorny issue indeed.
> > Xen would need to know how to do non-standard cache maintenance
> > operations.
> 
> Is EL2 hyp or EL1 dom0 doing such maintenance? If the latter, you could
> just use the currently registered dma ops.

It is Xen, so El2 hypervisor.


> > Otherwise we would need to resurrect XENFEAT_grant_map_identity (that I
> > am reverting in this series) and be content with having CONFIG_XEN_DOM0
> > depend on CONFIG_ARM_LPAE.
> 
> So what does buy you? Is it just the hope that with LPAE you won't have
> weird system caches?

Let me explain a bit more and let's assume there is no SMMU.

The problem is not normal dma originating in dom0, currently mapped 1:1
(pseudo-physical == physical). The problem are dma operations that
involve foreign pages (pages belonging to other virtual machines)
currently mapped also in dom0 to do IO. It is common for the Xen PV
network and block frontends to grant access to one or more pages to the
network and block backends for IO. The backends, usually in dom0, map
the pages and perform the actual IO. Sometimes the IO is a dma operation
that involves one of the granted pages directly.

For these pages, the pseudo-physical address in dom0 is different from
the physical address. Dom0 keeps track of the pseudo-physical to
physical relationship (pfn_to_mfn in Xen terminology). The swiotlb-xen
driver makes sure to return the right mfn from map_page and map_sg.

However some of the dma_ops give you only a dma_addr_t handle
(unmap_page and unmap_sg), that is the physical address of the page.
Dom0 doesn't know how to find the pseudo-physical address corresponding
to it. Therefore it also doesn't know how to find the struct page for
it. This is not a trivial problem to solve as the same page can be
granted multiple times, therefore could have multiple pseudo-physical
addresses and multiple struct pages corresponding to one physical
address in dom0.

Fortunately these dma_ops don't actually need to do much. In fact they
only need to flush caches if the device is not dma-coherent. So the
current proposed solution is to issue an hypercall to ask Xen to do the
flushing, passing the physical address dom0 knows.

The older solution that this series is reverting, is based on
XENFEAT_grant_map_identity, that was a feature offered by Xen, already
reverted in the hypervisor. XENFEAT_grant_map_identity told dom0 that
the hypervisor mapped foreign pages at the address requested by dom0
*and* at pseudo-physical == physical address. That way Dom0 could always
find the page at pseudo-physical == physical address and do the flushing
there. However it only works if Dom0 is compiled with CONFIG_ARM_LPAE
(a non-LPAE kernel is not guaranteed to be able to reach the
pseudo-physical address in question) and we didn't want to introduce
that limitation so we changed approach.


> > > diff --git a/arch/Kconfig b/arch/Kconfig
> > > index 05d7a8a458d5..8462b2e7491b 100644
> > > --- a/arch/Kconfig
> > > +++ b/arch/Kconfig
> > > @@ -203,6 +203,9 @@ config HAVE_DMA_ATTRS
> > >  config HAVE_DMA_CONTIGUOUS
> > >  	bool
> > >  
> > > +config HAVE_DMA_NONCOHERENT
> > > +	bool
> > > +
> > >  config GENERIC_SMP_IDLE_THREAD
> > >         bool
> > >  
> > > diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> > > index 89c4b5ccc68d..fd7d5522764c 100644
> > > --- a/arch/arm/Kconfig
> > > +++ b/arch/arm/Kconfig
> > > @@ -40,6 +40,7 @@ config ARM
> > >  	select HAVE_DMA_API_DEBUG
> > >  	select HAVE_DMA_ATTRS
> > >  	select HAVE_DMA_CONTIGUOUS if MMU
> > > +	select HAVE_DMA_NONCOHERENT if OF
> > >  	select HAVE_DYNAMIC_FTRACE if (!XIP_KERNEL)
> > >  	select HAVE_EFFICIENT_UNALIGNED_ACCESS if (CPU_V6 || CPU_V6K || CPU_V7) && MMU
> > >  	select HAVE_FTRACE_MCOUNT_RECORD if (!XIP_KERNEL)
> > > diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> > > index 9532f8d5857e..eb7a5aa64e0e 100644
> > > --- a/arch/arm64/Kconfig
> > > +++ b/arch/arm64/Kconfig
> > > @@ -46,6 +46,7 @@ config ARM64
> > >  	select HAVE_DMA_API_DEBUG
> > >  	select HAVE_DMA_ATTRS
> > >  	select HAVE_DMA_CONTIGUOUS
> > > +	select HAVE_DMA_NONCOHERENT
> > >  	select HAVE_DYNAMIC_FTRACE
> > >  	select HAVE_EFFICIENT_UNALIGNED_ACCESS
> > >  	select HAVE_FTRACE_MCOUNT_RECORD
> > > diff --git a/drivers/of/platform.c b/drivers/of/platform.c
> > > index 3b64d0bf5bba..7e827726b702 100644
> > > --- a/drivers/of/platform.c
> > > +++ b/drivers/of/platform.c
> > > @@ -183,6 +183,7 @@ static void of_dma_configure(struct device *dev)
> > >  	 * dma coherent operations.
> > >  	 */
> > >  	if (of_dma_is_coherent(dev->of_node)) {
> > > +		dev->dma_coherent = true;
> > >  		set_arch_dma_coherent_ops(dev);
> > >  		dev_dbg(dev, "device is dma coherent\n");
> > >  	}
> > 
> > I think that this would need to be #ifdef'ed as it is possible to have
> > OF support but no HAVE_DMA_NONCOHERENT (PPC?).
> 
> The field is always there. But with !HAVE_DMA_NONCOHERENT,
> is_device_dma_coherent() would always return 1. You could avoid
> defining is_device_dma_coherent() entirely when !HAVE_DMA_NONCOHERENT,
> it wouldn't be worse than your patch in terms of an undefined function.
> 
> > > diff --git a/include/linux/device.h b/include/linux/device.h
> > > index ce1f21608b16..e00ca876db01 100644
> > > --- a/include/linux/device.h
> > > +++ b/include/linux/device.h
> > > @@ -796,6 +796,7 @@ struct device {
> > >  
> > >  	bool			offline_disabled:1;
> > >  	bool			offline:1;
> > > +	bool			dma_coherent:1;
> > >  };
> > 
> > I guess we would have to #ifdef CONFIG_HAVE_DMA_NONCOHERENT the
> > dma_coherent flag, right? Otherwise architecures that do not select
> > CONFIG_HAVE_DMA_NONCOHERENT (x86 for example) would end up with a flag
> > in struct device that doesn't reflect the properties of the device (dma
> > coherent devices with dev->dma_coherent == 0).
> 
> In my proposal you should not read this field directly but rather access
> it only via is_device_dma_coherent() (you can add a function for setting
> it as well).

This is the part that I don't like: on other architectures you now have a
field in struct device that is actually incorrect. It is true that one
should call the accessor function to read the property but still...

As I don't feel that strongly against it, I'll resend including this
patch (with you as the author of course).
