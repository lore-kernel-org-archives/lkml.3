Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752318AbaEUOB4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 10:01:56 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:60400 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254AbaEUOBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 10:01:55 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Dave Martin <Dave.Martin@arm.com>, linux-arm-kernel@lists.infradead.org,
        Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Grant Grundler <grundler@chromium.org>, Joerg Roedel <joro@8bytes.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, Marc Zyngier <marc.zyngier@arm.com>,
        iommu@lists.linux-foundation.org, Kumar Gala <galak@codeaurora.org>,
        linux-tegra@vger.kernel.org, Cho KyongHo <pullip.cho@samsung.com>
Subject: Re: [PATCH] devicetree: Add generic IOMMU device tree bindings
Date: Wed, 21 May 2014 16:01:41 +0200
Message-ID: <4994892.2gk6QRjAPD@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140521105034.GA2014@ulmo>
References: <1400242998-437-1-git-send-email-thierry.reding@gmail.com> <5371868.4QO1YJ0hU2@wuerfel> <20140521105034.GA2014@ulmo>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:U78BR3FLfkNjyxJUthcMef1XQR4xl2KgySiDSY9YtJ/
 NvbBpBpA3uNnujcEJhiDhcYqOgL7b/GlpzRN4OTz0FsfdeXT6Q
 6EVGWRXgVeB7Qg7N1zqFTeYfWulX5+YQgZs75Qa9bGtbzvEK6w
 Ll1tTsOh+1+JvB8uc47ZA6K1N9alP2NxK8UkepmwBi92YwqGBn
 EKpbGm2oChk1UVffc+j8uLLZvtqRNpWr4DWc8iKr7enC9XEAn6
 50427bs1MLuGDxFcZvLmfOqSUpFesg2XMqin00Hx44BMLw0mKs
 N9bB1ur9RfxJU7c/eEQnx+K570B1xGb1IxsAYOQbdDw7fD9uCq
 fhXphnuf5OEkowC1DZtM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 21 May 2014 12:50:38 Thierry Reding wrote:
> On Wed, May 21, 2014 at 11:36:32AM +0200, Arnd Bergmann wrote:
> > On Wednesday 21 May 2014 11:00:38 Thierry Reding wrote:
> > > On Wed, May 21, 2014 at 10:50:38AM +0200, Arnd Bergmann wrote:
> > > > On Wednesday 21 May 2014 10:26:11 Thierry Reding wrote:
> > 
> > > > > > > For determining dma masks, it is the output address that it
> > > > > > > important.  Santosh's code can probably be taught to handle this,
> > > > > > > if given an additional traversal rule for following "iommus"
> > > > > > > properties.  However, deploying an IOMMU whose output address size
> > > > > > > is smaller than the 
> > > > > > 
> > > > > > Something seems to be missing here. I don't think we want to handle
> > > > > > the case where the IOMMU output cannot the entire memory address
> > > > > > space. If necessary, that would mean using both an IOMMU driver
> > > > > > and swiotlb, but I think it's a reasonable assumption that hardware
> > > > > > isn't /that/ crazy.
> > > > > 
> > > > > Similarily, should the IOMMU not be treated like any other device here?
> > > > > Its DMA mask should determine what address range it can access.
> > > > 
> > > > Right. But for that we need a dma-ranges property in the parent of the
> > > > iommu, just so the mask can be set correctly and we don't have to
> > > > rely on the 32-bit fallback case.
> > > 
> > > Shouldn't the IOMMU driver be the one to set the DMA mask for the device
> > > in exactly the same way that other drivers override the 32-bit default?
> > 
> > The IOMMU driver could /ask/ for an appropriate mask based on its internal
> > design, but if you have an IOMMU with a 64-bit output address connected
> > to a 32-bit bus, that should fail.
> 
> Are there real use-cases where that really happens? I guess if we need
> that the correct thing would be to bitwise AND both the DMA mask of the
> IOMMU device (as set by the driver) with that derived from the IOMMU's
> parent bus' dma-ranges property.

It would be unusual for an IOMMU to need this, but it's how the DMA
mask is supposed to work for normal devices. As mentioned before, I
would probably just error out if we ever encounter such an IOMMU.

> > Note that it's not obvious what the IOMMU's DMA mask actually means.
> > It clearly has to be the mask that is used for allocating the IO page
> > tables, but it wouldn't normally be used in the path that allocates
> > pages on behalf of a DMA master attached to the IOMMU, because that
> > allocation is performed by the code that looks at the other device's
> > dma mask.
> 
> Interesting. If a DMA buffer is allocated using the master's DMA mask
> wouldn't that cause breakage if the IOMMU and master's DMA masks don't
> match. It seems to me like the right thing to do for buffer allocation
> is to use the IOMMU's DMA mask if a device uses the IOMMU for
> translation and use the device's DMA mask when determining to what I/O
> virtual address to map that buffer.

Unfortunately not all code agrees regarding how dma mask is actually
interpreted. The most important use is within the dma_map_ops, and
that is aware of the IOMMU. The dma_map_ops use that to decide what
IOVA (bus address) to generate that is usable for the device, normally
this would be a 32-bit range.

When driver code looks at the dma mask of the device itself to make
an allocation decision without taking the IOMMU or swiotlb into
account, things can indeed go wrong.

Russell has recently done a good cleanup of various issues around
dma masks, and I can't find any drivers that get this wrong.
However, there is an issue with the two or three subsystems using
"PCI_DMA_BUS_IS_PHYS" to decide how they should treat high buffers
coming from user space that get passed to hardware.

If the SCSI layer or the network layer find the horribly misnamed
PCI_DMA_BUS_IS_PHYS (which is hardcoded to "1" on ARM32), they
will create copy in low memory for any data that is above
the device dma_mask (SCSI) or above max_low_pfn (network).

This is not normally a bug, and won't hurt for the swiotlb case,
but will give us worse performance for the IOMMU case, and
we should probably change this code to calculate the boundary
per device by calling a function from dma_map_ops.

We also really need to implement swiotlb support on ARM32 to deal
with any other device (besides SCSI and network) that does not
have an IOMMU but wants to use the streaming DMA API on pages
outside of the dma_mask. We already have this case on shmobile.

> Obviously if we always assume that IOMMU hardware is sane and can always
> access at least the whole memory then this isn't an issue. But what if a
> device can do DMA to a 64-bit address space, but the IOMMU can only
> address 32 bits. If the device's DMA mask is used for allocations, then
> buffers could reside beyond the 4 GiB boundary that the IOMMU can
> address, so effectively the IOMMU wouldn't be able to write to those
> buffers.

The mask of the device is not even an issue here, it's more the general
case of passing a buffer outside of the IOMMU's upstream bus DMA mask
into a driver connected to the IOMMU.

	Arnd
