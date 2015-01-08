Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756748AbbAHPy2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 10:54:28 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:57933 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753948AbbAHPy0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 10:54:26 -0500
Date: Thu, 8 Jan 2015 15:54:16 +0000
From: Will Deacon <will.deacon@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Murali Karicheri <m-karicheri2@ti.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>
Subject: Re: [PATCH v3 0/4] PCI: get DMA configuration from parent device
Message-ID: <20150108155416.GM11583@arm.com>
References: <1420656594-8908-1-git-send-email-m-karicheri2@ti.com>
 <4057859.4ynbgz66iN@wuerfel>
 <54ADBB89.8070503@ti.com>
 <1934001.D0JfDRp1gF@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1934001.D0JfDRp1gF@wuerfel>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 08, 2015 at 08:56:39AM +0000, Arnd Bergmann wrote:
> On Wednesday 07 January 2015 18:04:41 Murali Karicheri wrote:
> > On 01/07/2015 04:18 PM, Arnd Bergmann wrote:
> > > On Wednesday 07 January 2015 13:49:50 Murali Karicheri wrote:
> > >> PCI devices on Keystone doesn't have correct dma_pfn_offset set. This patch
> > >> add capability to set the dma configuration such as dma-mask, dma_pfn_offset,
> > >> and dma ops etc using the information from DT. The prior RFCs and discussions
> > >> are available at [1] and [2] below.
> > >>
> > >> [2] : https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg790244.html
> > >> [1] : http://www.gossamer-threads.com/lists/linux/kernel/2024591
> > >
> > > Looks all good to me in this version, I'm just unsure about one thing:
> > >
> > >>                 - Limit the of_iommu_configure to non pci devices
> > >
> > > My last recommendation was to pass the b/d/f number into
> > > of_pci_dma_configure to handle this correctly. What was your
> > > reason for not doing it in the end?
> > Arnd,
> > 
> > I had responded to this already on the list and reproduced below your 
> > remark and my response below from that thread.
> 
> Ah right, sorry for missing a reply on that.
> 
> > ---------------cut-------------------------------------------------------
> >  > Actually regarding the bit I wrote above, it might be helpful to pass
> >  > the PCI_DEVID() into both of_iommu_configure and of_dma_configure.
> >  >
> >  > While this may or may not be sufficient, I think there is no question
> >  > about it being needed for the ARM SMMU with PCI, so we may as well add
> >  > it at the point when you touch the same lines already. In the platform
> >  > bus case, just pass zero here.
> > 
> > PCI_DEVID() is defined as
> > 
> > #define PCI_DEVID(bus, devfn)  ((((u16)(bus)) << 8) | (devfn))
> > 
> > So PCI_DEVID of 0 is a valid PCI DEVID.
> 
> I think that is ok: the idea would be that we always just list the
> first ID of the range and then let the iommu driver add the offset
> in the appropriate way.
> 
> > How about checking if the device is PCI in of_iommu_configure() using 
> > dev_is_pci(dev) macro and return immediately for PCI? Need to include 
> > pci.h in this file though.
> > 
> > Some of the iommu drivers already include this.
> 
> I guess you are right, but the driver can even handle the PCI
> device correctly without the extra parameter:
> 
> 	devid = 0;
> 	if (dev_is_pci(dev)) {
> 		struct pci_dev *pdev = to_pci_dev(dev);
> 		devid = PCI_DEVID(pdev->bus->number, pdev->devfn);
> 	}
> 
> 	streamid += devid;
> 
> Other IOMMUs won't even care about the devid, so they will just work.

I started looking at this in more depth for the ARM SMMU at the end of last
year and the PCI case ends up being remarkably similar to the DT case.

Although I initially thought we just needed the devid, actually we need to
walk the PCI topology to find the dma alias for the device. The current
code for doing that (iommu_group_get_for_pci_dev) only reports the resulting
IOMMu group, which can actually correspond to *multiple* DMA aliases due
to ACS restrictions.

I knocked up a couple of patches for dealing with this in the ARM SMMU
driver, but I'd really like that to be part of core code if possible :)

https://git.kernel.org/cgit/linux/kernel/git/will/linux.git/commit/?h=iommu/pgtbl&id=41dc7b9e0ff1a4d79d1dd76619056fc0cfa8b84f
https://git.kernel.org/cgit/linux/kernel/git/will/linux.git/commit/?h=iommu/pgtbl&id=5503996103138b41520d5eae90dda62abb65f04f

So, I think of_pci_dma_configure should determine the set of aliases for the
group. What isn't clear to me for the DT *or* the PCI cases is what we
actually do with the group at the dma-mapping level...

Will
