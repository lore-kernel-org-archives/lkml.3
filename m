Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752002AbaJ0R6k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 13:58:40 -0400
Received: from 8bytes.org ([81.169.241.247]:35153 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751912AbaJ0R6i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 13:58:38 -0400
Date: Mon, 27 Oct 2014 18:58:35 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Cc: Frank Blaschka <blaschka@linux.vnet.ibm.com>, schwidefsky@de.ibm.com,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        iommu@lists.linux-foundation.org, sebott@linux.vnet.ibm.com
Subject: Re: [PATCH linux-next] iommu: add iommu for s390 platform
Message-ID: <20141027175835.GC6202@8bytes.org>
References: <1413892645-37657-1-git-send-email-blaschka@linux.vnet.ibm.com>
 <20141022141728.GG10074@8bytes.org>
 <20141022154320.GA42442@tuxmaker.boeblingen.de.ibm.com>
 <20141023124115.GB10053@8bytes.org>
 <20141023140437.GA31009@tuxmaker.boeblingen.de.ibm.com>
 <20141027153201.517f4ff4@thinkpad>
 <20141027162502.GB6202@8bytes.org>
 <20141027180219.62b1ac4a@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141027180219.62b1ac4a@thinkpad>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 27, 2014 at 06:02:19PM +0100, Gerald Schaefer wrote:
> On Mon, 27 Oct 2014 17:25:02 +0100
> Joerg Roedel <joro@8bytes.org> wrote:
> > Is there some hardware reason for this or is that just an
> > implementation detail that can be changed. In other words, does the
> > hardware allow to use the same DMA table for multiple devices?
> 
> Yes, the HW would allow shared DMA tables, but the implementation would
> need some non-trivial changes. For example, we have a per-device spin_lock
> for DMA table manipulations and the code in arch/s390/pci/pci_dma.c knows
> nothing about IOMMU domains or shared DMA tables, it just implements a set
> of dma_map_ops.

I think it would make sense to move the DMA table handling code and the
dma_map_ops implementation to the IOMMU driver too. This is also how
some other IOMMU drivers implement it.

The plan is to consolidate the dma_ops implementations someday and have
a common implementation that works with all IOMMU drivers across
architectures. This would benefit s390 as well and obsoletes the driver
specific dma_ops implementation.

> Of course this would also go horribly wrong if a device was already
> in use (via the current dma_map_ops), but I guess using devices through
> the IOMMU_API prevents using them otherwise?

This is taken care of by the device drivers. A driver for a device
either uses the DMA-API or does its own management of DMA mappings using
the IOMMU-API. VFIO is an example for the later case.

> > I think it is much easier to use the same DMA table for all devices
> > in a domain, if the hardware allows that.
> 
> Yes, in this case, having one DMA table per domain and sharing it
> between all devices in that domain sounds like a good idea. However,
> I can't think of any use case for this, and Frank probably had a very
> special use case in mind where this scenario doesn't appear, hence the
> "one device per domain" restriction.

One usecase is device access from user-space via VFIO. A userspace
process might want to access multiple devices at the same time and VFIO
would implement this by assigning all of these devices to the same IOMMU
domain.

This requirement also comes also from the IOMMU-API itself. The
intention of the API is to make different IOMMUs look the same through
the API, and this is violated when drivers implement a 1-1
domain->device mapping.

> So, if having multiple devices per domain is a must, then we probably
> need a thorough rewrite of the arch/s390/pci/pci_dma.c code.

Yes, this is a requirement for new IOMMU drivers. We already have
drivers implementing the same 1-1 relation and we are about to fix them.
But I don't want to add new drivers doing the same.


	Joerg

