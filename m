Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756162AbaD1TTj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 15:19:39 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:40218 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751437AbaD1TTd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 15:19:33 -0400
Date: Mon, 28 Apr 2014 20:19:20 +0100
From: Will Deacon <will.deacon@arm.com>
To: Alex Williamson <alex.williamson@redhat.com>
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
Subject: Re: [RFC PATCH v5 03/11] VFIO_IOMMU_TYPE1 for platform bus devices
 on ARM
Message-ID: <20140428191920.GC22135@arm.com>
References: <1398700371-20096-1-git-send-email-a.motakis@virtualopensystems.com>
 <1398700371-20096-4-git-send-email-a.motakis@virtualopensystems.com>
 <1398703421.24318.262.camel@ul30vt.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398703421.24318.262.camel@ul30vt.home>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alex,

On Mon, Apr 28, 2014 at 05:43:41PM +0100, Alex Williamson wrote:
> On Mon, 2014-04-28 at 17:52 +0200, Antonios Motakis wrote:
> > This allows to make use of the VFIO_IOMMU_TYPE1 driver with platform
> > devices on ARM in addition to PCI. This is required in order to use the
> > Exynos SMMU, or ARM SMMU driver with VFIO_IOMMU_TYPE1.

[...]

> > @@ -721,13 +722,15 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
> >  	INIT_LIST_HEAD(&domain->group_list);
> >  	list_add(&group->next, &domain->group_list);
> >  
> > -	if (!allow_unsafe_interrupts &&
> > +#ifdef CONFIG_PCI
> > +	if (bus == &pci_bus_type && !allow_unsafe_interrupts &&
> >  	    !iommu_domain_has_cap(domain->domain, IOMMU_CAP_INTR_REMAP)) {
> >  		pr_warn("%s: No interrupt remapping support.  Use the module param \"allow_unsafe_interrupts\" to enable VFIO IOMMU support on this platform\n",
> >  		       __func__);
> >  		ret = -EPERM;
> >  		goto out_detach;
> >  	}
> > +#endif
> >  
> >  	if (iommu_domain_has_cap(domain->domain, IOMMU_CAP_CACHE_COHERENCY))
> >  		domain->prot |= IOMMU_CACHE;
> 
> This is not a PCI specific requirement.  Anything that can support MSI
> needs an IOMMU that can provide isolation for both DMA and interrupts.
> I think the IOMMU should still be telling us that it has this feature.

Please excuse any ignorance on part here (I'm not at all familiar with the
Intel IOMMU), but shouldn't this really be a property of the interrupt
controller itself? On ARM with GICv3, there is a separate block called the
ITS (interrupt translation service) which is part of the interrupt
controller. The ITS provides a doorbell page which the SMMU can map into a
guest operating system to provide MSI for passthrough devices, but this
isn't something the SMMU is aware of -- it will just see the iommu_map
request for a non-cacheable mapping.

Will
