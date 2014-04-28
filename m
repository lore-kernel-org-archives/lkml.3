Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933198AbaD1UIX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 16:08:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44098 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932181AbaD1UIW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 16:08:22 -0400
Message-ID: <1398715690.24318.321.camel@ul30vt.home>
Subject: Re: [RFC PATCH v5 03/11] VFIO_IOMMU_TYPE1 for platform bus devices
 on ARM
From: Alex Williamson <alex.williamson@redhat.com>
To: Will Deacon <will.deacon@arm.com>
Cc: Antonios Motakis <a.motakis@virtualopensystems.com>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "tech@virtualopensystems.com" <tech@virtualopensystems.com>,
        "a.rigo@virtualopensystems.com" <a.rigo@virtualopensystems.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>,
        "kim.phillips@freescale.com" <kim.phillips@freescale.com>,
        "stuart.yoder@freescale.com" <stuart.yoder@freescale.com>,
        open list <linux-kernel@vger.kernel.org>, marc.zyngier@arm.com
Date: Mon, 28 Apr 2014 14:08:10 -0600
In-Reply-To: <20140428191920.GC22135@arm.com>
References: <1398700371-20096-1-git-send-email-a.motakis@virtualopensystems.com>
	 <1398700371-20096-4-git-send-email-a.motakis@virtualopensystems.com>
	 <1398703421.24318.262.camel@ul30vt.home> <20140428191920.GC22135@arm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-04-28 at 20:19 +0100, Will Deacon wrote:
> Hi Alex,
> 
> On Mon, Apr 28, 2014 at 05:43:41PM +0100, Alex Williamson wrote:
> > On Mon, 2014-04-28 at 17:52 +0200, Antonios Motakis wrote:
> > > This allows to make use of the VFIO_IOMMU_TYPE1 driver with platform
> > > devices on ARM in addition to PCI. This is required in order to use the
> > > Exynos SMMU, or ARM SMMU driver with VFIO_IOMMU_TYPE1.
> 
> [...]
> 
> > > @@ -721,13 +722,15 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
> > >  	INIT_LIST_HEAD(&domain->group_list);
> > >  	list_add(&group->next, &domain->group_list);
> > >  
> > > -	if (!allow_unsafe_interrupts &&
> > > +#ifdef CONFIG_PCI
> > > +	if (bus == &pci_bus_type && !allow_unsafe_interrupts &&
> > >  	    !iommu_domain_has_cap(domain->domain, IOMMU_CAP_INTR_REMAP)) {
> > >  		pr_warn("%s: No interrupt remapping support.  Use the module param \"allow_unsafe_interrupts\" to enable VFIO IOMMU support on this platform\n",
> > >  		       __func__);
> > >  		ret = -EPERM;
> > >  		goto out_detach;
> > >  	}
> > > +#endif
> > >  
> > >  	if (iommu_domain_has_cap(domain->domain, IOMMU_CAP_CACHE_COHERENCY))
> > >  		domain->prot |= IOMMU_CACHE;
> > 
> > This is not a PCI specific requirement.  Anything that can support MSI
> > needs an IOMMU that can provide isolation for both DMA and interrupts.
> > I think the IOMMU should still be telling us that it has this feature.
> 
> Please excuse any ignorance on part here (I'm not at all familiar with the
> Intel IOMMU), but shouldn't this really be a property of the interrupt
> controller itself? On ARM with GICv3, there is a separate block called the
> ITS (interrupt translation service) which is part of the interrupt
> controller. The ITS provides a doorbell page which the SMMU can map into a
> guest operating system to provide MSI for passthrough devices, but this
> isn't something the SMMU is aware of -- it will just see the iommu_map
> request for a non-cacheable mapping.

Hi Will,

I don't know the history of why this is an IOMMU domain capability on
x86, it's sort of a paradox.  An MSI from a device is conceptually just
a DMA write and is therefore logically co-located in the IOMMU hardware,
but x86 doesn't allow it to be mapped via the IOMMU API interfaces.  For
compatibility, interrupt remapping support is buried deep in the
request_irq interface and effectively invisible other than having this
path to query it.  Therefore this flag is effectively just saying "MSI
isolation support is present and enabled".  IOW, the host is protected
from interrupt injection attacks from malicious devices.  If there is
some property of your platform that makes this always the case, then the
IOMMU driver can always export this capability as true.

With PCI, MSI is configured via spec defined configuration space
registers, so we emulate these registers and prevent user access to them
so that we don't need to allow the user a way to setup an interrupt
remapping entry.  It's done for them via request_irq.

IIRC, the Freescale devices have a limited number of MSI pages and can
therefore create some instances with isolation while others may require
sharing.  In that case I would expect this flag to indicate whether the
domain has an exclusive or shared page.

In any case, I suspect keying on the bus_type here is not the correct
way to go.  Thanks,

Alex

