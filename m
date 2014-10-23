Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754726AbaJWOEp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 10:04:45 -0400
Received: from e06smtp14.uk.ibm.com ([195.75.94.110]:54188 "EHLO
	e06smtp14.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751674AbaJWOEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 10:04:42 -0400
Date: Thu, 23 Oct 2014 16:04:37 +0200
From: Frank Blaschka <blaschka@linux.vnet.ibm.com>
To: Joerg Roedel <joro@8bytes.org>
Cc: schwidefsky@de.ibm.com, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, iommu@lists.linux-foundation.org,
        sebott@linux.vnet.ibm.com, gerald.schaefer@de.ibm.com
Subject: Re: [PATCH linux-next] iommu: add iommu for s390 platform
Message-ID: <20141023140437.GA31009@tuxmaker.boeblingen.de.ibm.com>
References: <1413892645-37657-1-git-send-email-blaschka@linux.vnet.ibm.com> <20141022141728.GG10074@8bytes.org> <20141022154320.GA42442@tuxmaker.boeblingen.de.ibm.com> <20141023124115.GB10053@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141023124115.GB10053@8bytes.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14102314-0017-0000-0000-000001910494
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2014 at 02:41:15PM +0200, Joerg Roedel wrote:
> On Wed, Oct 22, 2014 at 05:43:20PM +0200, Frank Blaschka wrote:
> > Basically there are no limitations. Depending on the s390 maschine
> > generation a device starts its IOVA at a specific address (announced by
> > the HW). But as I already told each device starts at the same address.
> > I think this prevents having multiple devices on the same IOMMU domain.
> 
> Why, each device has its own IOVA address space, so IOVA A could map to
> physical address X for one device and to Y for another, no? And if you
> point multiple devices to the same dma_table they share the mappings
> (and thus the address space). Or am I getting something wrong?
> 
> > yes, you are absolutely right. There is a per-device dma_table.
> > There is no general IOMMU device but each pci device has its own IOMMU
> > translation capability.
> 
> I see, in this way it is similar to ARM where there is often also one IOMMU
> per master device.
> 
> > Is there a possibility the IOMMU domain can support e.g. something like
> > 
> > VIOA 0x10000 -> pci device 1
> > VIOA 0x10000 -> pci device 2
> 
> A domain is basically an abstraction for a DMA page table (or a
> dma_table, as you call it on s390). So you can easily create similar
> mappings for more than one device with it.
>
ok, maybe I was too close to the existing s390 dma implementation or simply
wrong, maybe Sebastian or Gerald can give more background information.
Here is my understanding so far:

the clp instructions reports a start/end dma address for the pci device.
on my system all devices report:

sdma = 0x100000000;
edma = 0x1ffffffffffffff;

dma mappings are created for each device separately starting from 0x100000000
and filling the the VIOA space for this device (until 0x1ffffffffffffff)

If we would like to have more then one device per domain I think:

we would have to slice the IOVA address space (0x100000000 - 0x1ffffffffffffff)
of the domain and report only a slice to the pci device (clp)
The iommu code would have to find the device by the dma (VIOA) address
and then program the entry to the table of the particular device (and only this
device).

Is this understanding more appropriate?

Thx

Frank
 
> 
> 
> 	Joerg
> 

