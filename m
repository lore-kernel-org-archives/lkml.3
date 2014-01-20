Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753955AbaATQVb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 11:21:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47981 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752818AbaATQVa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 11:21:30 -0500
Message-ID: <1390234886.8705.142.camel@bling.home>
Subject: Re: [RFC PATCH] vfio/iommu_type1: Multi-IOMMU domain support
From: Alex Williamson <alex.williamson@redhat.com>
To: Varun Sethi <Varun.Sethi@freescale.com>
Cc: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 20 Jan 2014 09:21:26 -0700
In-Reply-To: <4bc6dcb96df44b0e94152d9729958d60@BL2PR03MB468.namprd03.prod.outlook.com>
References: <20140117203126.11429.25235.stgit@gimli.home>
	 <4bc6dcb96df44b0e94152d9729958d60@BL2PR03MB468.namprd03.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-01-20 at 14:45 +0000, Varun Sethi wrote:
> 
> > -----Original Message-----
> > From: Alex Williamson [mailto:alex.williamson@redhat.com]
> > Sent: Saturday, January 18, 2014 2:06 AM
> > To: Sethi Varun-B16395
> > Cc: iommu@lists.linux-foundation.org; linux-kernel@vger.kernel.org
> > Subject: [RFC PATCH] vfio/iommu_type1: Multi-IOMMU domain support
> > 
> > RFC: This is not complete but I want to share with Varun the dirrection
> > I'm thinking about.  In particular, I'm really not sure if we want to
> > introduce a "v2" interface version with slightly different unmap
> > semantics.  QEMU doesn't care about the difference, but other users
> > might.  Be warned, I'm not even sure if this code works at the moment.
> > Thanks,
> > 
> > Alex
> > 
> > 
> > We currently have a problem that we cannot support advanced features of
> > an IOMMU domain (ex. IOMMU_CACHE), because we have no guarantee that
> > those features will be supported by all of the hardware units involved
> > with the domain over its lifetime.  For instance, the Intel VT-d
> > architecture does not require that all DRHDs support snoop control.  If
> > we create a domain based on a device behind a DRHD that does support
> > snoop control and enable SNP support via the IOMMU_CACHE mapping option,
> > we cannot then add a device behind a DRHD which does not support snoop
> > control or we'll get reserved bit faults from the SNP bit in the
> > pagetables.  To add to the complexity, we can't know the properties of a
> > domain until a device is attached.
> [Sethi Varun-B16395] Effectively, it's the same iommu and iommu_ops
> are common across all bus types. The hardware feature differences are
> abstracted by the driver.

That's a simplifying assumption that is not made anywhere else in the
code.  The IOMMU API allows entirely independent IOMMU drivers to
register per bus_type.  There is no guarantee that all devices are
backed by the same IOMMU hardware unit or make use of the same
iommu_ops.

> > We could pass this problem off to userspace and require that a separate
> > vfio container be used, but we don't know how to handle page accounting
> > in that case.  How do we know that a page pinned in one container is the
> > same page as a different container and avoid double billing the user for
> > the page.
> > 
> > The solution is therefore to support multiple IOMMU domains per
> > container.  In the majority of cases, only one domain will be required
> > since hardware is typically consistent within a system.  However, this
> > provides us the ability to validate compatibility of domains and support
> > mixed environments where page table flags can be different between
> > domains.
> > 
> > To do this, our DMA tracking needs to change.  We currently try to
> > coalesce user mappings into as few tracking entries as possible.  The
> > problem then becomes that we lose granularity of user mappings.  We've
> > never guaranteed that a user is able to unmap at a finer granularity than
> > the original mapping, but we must honor the granularity of the original
> > mapping.  This coalescing code is therefore removed, allowing only unmaps
> > covering complete maps.  The change in accounting is fairly small here, a
> > typical QEMU VM will start out with roughly a dozen entries, so it's
> > arguable if this coalescing was ever needed.
> > 
> > We also move IOMMU domain creation to the point where a group is attached
> > to the container.  An interesting side-effect of this is that we now have
> > access to the device at the time of domain creation and can probe the
> > devices within the group to determine the bus_type.
> > This finally makes vfio_iommu_type1 completely device/bus agnostic.
> > In fact, each IOMMU domain can host devices on different buses managed by
> > different physical IOMMUs, and present a single DMA mapping interface to
> > the user.  When a new domain is created, mappings are replayed to bring
> > the IOMMU pagetables up to the state of the current container.  And of
> > course, DMA mapping and unmapping automatically traverse all of the
> > configured IOMMU domains.
> > 
> [Sethi Varun-B16395] This code still checks to see that devices being
> attached to the domain are connected to the same bus type. If we
> intend to merge devices from different bus types but attached to
> compatible domains in to a single domain, why can't we avoid the bus
> check? Why can't we remove the bus dependency from domain allocation?

So if I were to test iommu_ops instead of bus_type (ie. assume that if a
if an IOMMU driver manages iommu_ops across bus_types that it can accept
the devices), would that satisfy your concern?

It may be possible to remove the bus_type dependency from domain
allocation, but the IOMMU API currently makes the assumption that
there's one IOMMU driver per bus_type.  Your fix to remove the bus_type
dependency from iommu_domain_alloc() adds an assumption that there is
only one IOMMU driver for all bus_types.  That may work on your
platform, but I don't think it's a valid assumption in the general case.
If you'd like to propose alternative ways to remove the bus_type
dependency, please do.  Thanks,

Alex

