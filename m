Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753894AbbAHI47 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 03:56:59 -0500
Received: from mout.kundenserver.de ([212.227.126.187]:49328 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753395AbbAHI45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 03:56:57 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Murali Karicheri <m-karicheri2@ti.com>
Cc: bhelgaas@google.com, linux-arm-kernel@lists.infradead.org, joro@8bytes.org,
        grant.likely@linaro.org, robh+dt@kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-pci@vger.kernel.org,
        will.deacon@arm.com, linux@arm.linux.org.uk
Subject: Re: [PATCH v3 0/4] PCI: get DMA configuration from parent device
Date: Thu, 08 Jan 2015 09:56:39 +0100
Message-ID: <1934001.D0JfDRp1gF@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <54ADBB89.8070503@ti.com>
References: <1420656594-8908-1-git-send-email-m-karicheri2@ti.com> <4057859.4ynbgz66iN@wuerfel> <54ADBB89.8070503@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:YlNso0D4nWMruzlJqWygyEYjLwIG33cznDqD8KMRnsSW5fskDDu
 jF2h56+iwd1e8y5/khqJ6XR07ya5tbKd0Otx5Td6lH5sQndbHeySak5rI5RTWk2eIZJRhho
 1MTfMkgo0rWdAzmZ8WQAFnfNhalzpI1ga7pBXQL/6qE1nZ+PKQQWPwmeuvn1NZwvoX0TW4f
 izpIP8aXD2O4BcLVuMhfA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 07 January 2015 18:04:41 Murali Karicheri wrote:
> On 01/07/2015 04:18 PM, Arnd Bergmann wrote:
> > On Wednesday 07 January 2015 13:49:50 Murali Karicheri wrote:
> >> PCI devices on Keystone doesn't have correct dma_pfn_offset set. This patch
> >> add capability to set the dma configuration such as dma-mask, dma_pfn_offset,
> >> and dma ops etc using the information from DT. The prior RFCs and discussions
> >> are available at [1] and [2] below.
> >>
> >> [2] : https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg790244.html
> >> [1] : http://www.gossamer-threads.com/lists/linux/kernel/2024591
> >
> > Looks all good to me in this version, I'm just unsure about one thing:
> >
> >>                 - Limit the of_iommu_configure to non pci devices
> >
> > My last recommendation was to pass the b/d/f number into
> > of_pci_dma_configure to handle this correctly. What was your
> > reason for not doing it in the end?
> Arnd,
> 
> I had responded to this already on the list and reproduced below your 
> remark and my response below from that thread.

Ah right, sorry for missing a reply on that.

> ---------------cut-------------------------------------------------------
>  > Actually regarding the bit I wrote above, it might be helpful to pass
>  > the PCI_DEVID() into both of_iommu_configure and of_dma_configure.
>  >
>  > While this may or may not be sufficient, I think there is no question
>  > about it being needed for the ARM SMMU with PCI, so we may as well add
>  > it at the point when you touch the same lines already. In the platform
>  > bus case, just pass zero here.
> 
> PCI_DEVID() is defined as
> 
> #define PCI_DEVID(bus, devfn)  ((((u16)(bus)) << 8) | (devfn))
> 
> So PCI_DEVID of 0 is a valid PCI DEVID.

I think that is ok: the idea would be that we always just list the
first ID of the range and then let the iommu driver add the offset
in the appropriate way.

> How about checking if the device is PCI in of_iommu_configure() using 
> dev_is_pci(dev) macro and return immediately for PCI? Need to include 
> pci.h in this file though.
> 
> Some of the iommu drivers already include this.

I guess you are right, but the driver can even handle the PCI
device correctly without the extra parameter:

	devid = 0;
	if (dev_is_pci(dev)) {
		struct pci_dev *pdev = to_pci_dev(dev);
		devid = PCI_DEVID(pdev->bus->number, pdev->devfn);
	}

	streamid += devid;

Other IOMMUs won't even care about the devid, so they will just work.

> This will allow us to re-visit this later for IOMMU support for PCI 
> without polluting the API.
>
> -----------------------cut-end---------------------------------------
> 
> I assumed you want to use value of zero for b/d/f to indicate it is for
> platform. Also use the non zero value to skip the DT attribute parsing 
> for IOMMU DT attribute in of_iommu_configure() for PCI.
> I did dev_is_pci() for skipping the processing for PCI. I thought it is 
> better to add the b/d/f argument later when this is re-visited later.

I'd say just keep the iommu setup for PCI now and let drivers handle
this under the covers.

There is another interesting case, which is a USB host controller or
something similar behind a PCI bus. These are quite common and also
need to be handled in some form. Let's do just PCI first for now, but
be aware that this will come next. Should we assume that the ID that
is required for a device is either known from the device node, or
that it comes from a PCI device? That means for the USB case, we will
likely need to have some custom logic. There seems to be an implicit
assumption all over the kernel that all devices have the same IOMMU
instance, but we can't really rely on that here.

	Arnd
