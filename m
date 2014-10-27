Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752170AbaJ0SSu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 14:18:50 -0400
Received: from e06smtp15.uk.ibm.com ([195.75.94.111]:36261 "EHLO
	e06smtp15.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500AbaJ0SSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 14:18:48 -0400
Date: Mon, 27 Oct 2014 19:18:40 +0100
From: Gerald Schaefer <gerald.schaefer@de.ibm.com>
To: Joerg Roedel <joro@8bytes.org>
Cc: Frank Blaschka <blaschka@linux.vnet.ibm.com>, schwidefsky@de.ibm.com,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        iommu@lists.linux-foundation.org, sebott@linux.vnet.ibm.com
Subject: Re: [PATCH linux-next] iommu: add iommu for s390 platform
Message-ID: <20141027191840.4c76e9ac@thinkpad>
In-Reply-To: <20141027175835.GC6202@8bytes.org>
References: <1413892645-37657-1-git-send-email-blaschka@linux.vnet.ibm.com>
	<20141022141728.GG10074@8bytes.org>
	<20141022154320.GA42442@tuxmaker.boeblingen.de.ibm.com>
	<20141023124115.GB10053@8bytes.org>
	<20141023140437.GA31009@tuxmaker.boeblingen.de.ibm.com>
	<20141027153201.517f4ff4@thinkpad>
	<20141027162502.GB6202@8bytes.org>
	<20141027180219.62b1ac4a@thinkpad>
	<20141027175835.GC6202@8bytes.org>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14102718-0021-0000-0000-0000018E91D4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Oct 2014 18:58:35 +0100
Joerg Roedel <joro@8bytes.org> wrote:

> On Mon, Oct 27, 2014 at 06:02:19PM +0100, Gerald Schaefer wrote:
> > On Mon, 27 Oct 2014 17:25:02 +0100
> > Joerg Roedel <joro@8bytes.org> wrote:
> > > Is there some hardware reason for this or is that just an
> > > implementation detail that can be changed. In other words, does
> > > the hardware allow to use the same DMA table for multiple devices?
> > 
> > Yes, the HW would allow shared DMA tables, but the implementation
> > would need some non-trivial changes. For example, we have a
> > per-device spin_lock for DMA table manipulations and the code in
> > arch/s390/pci/pci_dma.c knows nothing about IOMMU domains or shared
> > DMA tables, it just implements a set of dma_map_ops.
> 
> I think it would make sense to move the DMA table handling code and
> the dma_map_ops implementation to the IOMMU driver too. This is also
> how some other IOMMU drivers implement it.

Yes, I feared that this would come up, but I agree that it looks like the
best solution, at least if we really want/need the IOMMU API for s390 now.
I'll need to discuss this with Frank, he seems to be on vacation this week.

Thanks for your feedback and explanations!

> The plan is to consolidate the dma_ops implementations someday and
> have a common implementation that works with all IOMMU drivers across
> architectures. This would benefit s390 as well and obsoletes the
> driver specific dma_ops implementation.
> 
> > Of course this would also go horribly wrong if a device was already
> > in use (via the current dma_map_ops), but I guess using devices
> > through the IOMMU_API prevents using them otherwise?
> 
> This is taken care of by the device drivers. A driver for a device
> either uses the DMA-API or does its own management of DMA mappings
> using the IOMMU-API. VFIO is an example for the later case.
> 
> > > I think it is much easier to use the same DMA table for all
> > > devices in a domain, if the hardware allows that.
> > 
> > Yes, in this case, having one DMA table per domain and sharing it
> > between all devices in that domain sounds like a good idea. However,
> > I can't think of any use case for this, and Frank probably had a
> > very special use case in mind where this scenario doesn't appear,
> > hence the "one device per domain" restriction.
> 
> One usecase is device access from user-space via VFIO. A userspace
> process might want to access multiple devices at the same time and
> VFIO would implement this by assigning all of these devices to the
> same IOMMU domain.
> 
> This requirement also comes also from the IOMMU-API itself. The
> intention of the API is to make different IOMMUs look the same through
> the API, and this is violated when drivers implement a 1-1
> domain->device mapping.
> 
> > So, if having multiple devices per domain is a must, then we
> > probably need a thorough rewrite of the arch/s390/pci/pci_dma.c
> > code.
> 
> Yes, this is a requirement for new IOMMU drivers. We already have
> drivers implementing the same 1-1 relation and we are about to fix
> them. But I don't want to add new drivers doing the same.
> 
> 
> 	Joerg
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-s390"
> in the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

