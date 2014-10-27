Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752329AbaJ0RC2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 13:02:28 -0400
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:46334 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565AbaJ0RC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 13:02:27 -0400
Date: Mon, 27 Oct 2014 18:02:19 +0100
From: Gerald Schaefer <gerald.schaefer@de.ibm.com>
To: Joerg Roedel <joro@8bytes.org>
Cc: Frank Blaschka <blaschka@linux.vnet.ibm.com>, schwidefsky@de.ibm.com,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        iommu@lists.linux-foundation.org, sebott@linux.vnet.ibm.com
Subject: Re: [PATCH linux-next] iommu: add iommu for s390 platform
Message-ID: <20141027180219.62b1ac4a@thinkpad>
In-Reply-To: <20141027162502.GB6202@8bytes.org>
References: <1413892645-37657-1-git-send-email-blaschka@linux.vnet.ibm.com>
	<20141022141728.GG10074@8bytes.org>
	<20141022154320.GA42442@tuxmaker.boeblingen.de.ibm.com>
	<20141023124115.GB10053@8bytes.org>
	<20141023140437.GA31009@tuxmaker.boeblingen.de.ibm.com>
	<20141027153201.517f4ff4@thinkpad>
	<20141027162502.GB6202@8bytes.org>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14102717-0041-0000-0000-000001D59DA0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Oct 2014 17:25:02 +0100
Joerg Roedel <joro@8bytes.org> wrote:

> On Mon, Oct 27, 2014 at 03:32:01PM +0100, Gerald Schaefer wrote:
> > Not sure if I understood the concept of IOMMU domains right. But if
> > this is about having multiple devices in the same domain, so that
> > iommu_ops->map will establish the _same_ DMA mapping on _all_
> > registered devices, then this should be possible.
> 
> Yes, this is what domains are about. A domain describes a set of DMA
> mappings which can be assigned to multiple devices in parallel.
> 
> > We cannot have shared DMA tables because each device gets its own
> > DMA table allocated during device initialization.
> 
> Is there some hardware reason for this or is that just an
> implementation detail that can be changed. In other words, does the
> hardware allow to use the same DMA table for multiple devices?

Yes, the HW would allow shared DMA tables, but the implementation would
need some non-trivial changes. For example, we have a per-device spin_lock
for DMA table manipulations and the code in arch/s390/pci/pci_dma.c knows
nothing about IOMMU domains or shared DMA tables, it just implements a set
of dma_map_ops.

Of course this would also go horribly wrong if a device was already
in use (via the current dma_map_ops), but I guess using devices through
the IOMMU_API prevents using them otherwise?

> 
> > But we could just keep all devices from one domain in a list and
> > then call dma_update_trans() for all devices during
> > iommu_ops->map/unmap.
> 
> This sounds complicated. Note that a device can be assigned to a
> domain that already has existing mappings. In this case you need to
> make sure that the new device inherits these mappings (and destroy
> all old mappings for the device that possibly exist).
> 
> I think it is much easier to use the same DMA table for all devices
> in a domain, if the hardware allows that.

Yes, in this case, having one DMA table per domain and sharing it
between all devices in that domain sounds like a good idea. However,
I can't think of any use case for this, and Frank probably had a very
special use case in mind where this scenario doesn't appear, hence the
"one device per domain" restriction.

So, if having multiple devices per domain is a must, then we probably
need a thorough rewrite of the arch/s390/pci/pci_dma.c code.

Gerald

