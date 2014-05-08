Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755476AbaEHUay (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 16:30:54 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:61453 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755214AbaEHUav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 16:30:51 -0400
Date: Thu, 8 May 2014 14:30:53 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-doc@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joerg Roedel <joro@8bytes.org>, Randy Dunlap <rdunlap@infradead.org>,
        Liviu Dudau <Liviu.Dudau@arm.com>, linux-kernel@vger.kernel.org,
        James Bottomley <jbottomley@parallels.com>, linux-pci@vger.kernel.org,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH v2 4/5] iommu: Use dma_addr_t for IOVA arguments
Message-ID: <20140508203053.GA14448@google.com>
References: <20140506223250.17968.27054.stgit@bhelgaas-glaptop.roam.corp.google.com>
 <45161364.3Gyo1xJJLV@wuerfel>
 <20140508001814.GB4951@google.com>
 <15249748.Q2CaU9aBE9@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <15249748.Q2CaU9aBE9@wuerfel>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 08, 2014 at 12:44:12PM +0200, Arnd Bergmann wrote:
> On Wednesday 07 May 2014 18:18:14 Bjorn Helgaas wrote:
> > On Wed, May 07, 2014 at 09:58:58AM +0200, Arnd Bergmann wrote:
> > > On Tuesday 06 May 2014 16:48:40 Bjorn Helgaas wrote:
> > > > Convert the "iova" arguments of iommu_map(), iommu_unmap(), etc., from
> > > > "unsigned long" to dma_addr_t.
> > > > 
> > > > bb5547acfcd8 ("iommu/fsl: Make iova dma_addr_t in the iommu_iova_to_phys
> > > > API") did this for iommu_iova_to_phys(), but didn't fix the rest of the
> > > > IOMMU API.
> > > 
> > > This patch looks 100% correct, but I'm not convinced it's a good idea:
> > > On 32-bit platforms (i.e. most of the ones you change), doing 64-bit
> > > arithmetic has a noticeable overhead. I am not aware of an IOMMU that
> > > actually uses 64-bit DMA addresses on its slave side, usually they
> > > are used to translate addresses from 32-bit masters into 64-bit
> > > memory addresses, so using 'unsigned long' seems better from a practical
> > > point of view as opposed to the strict type correctness.
> > 
> > The current x86 IOMMUs support DMA addresses larger than 32 bits, but
> > obviously those platforms usually run 64-bit kernels so "unsigned
> > long" is already 64 bits.
> > 
> > I guess you're thinking about cases where "unsigned long" is 32 bits,
> > the IOMMU only supports 32 bit DMA addresses, and dma_addr_t is 64
> > bits.  If the IOMMU only supports 32-bit DMA addresses, is there any
> > value in having a 64-bit dma_addr_t?
> 
> Two cases:
> 
> a) You can have a system with some DMA masters that are 64-bit capable,
>    and other masters that can only do 32-bit DMA and for this reason
>    use an IOMMU. I expect to see more of these in the future.
> 
> b) We build kernels that run on a multitude of ARM32 platforms these
>    days. We have some that require a 32-bit dma_addr_t and some that
>    don't (because they always use swiotlb or an IOMMU).

Those both make sense (I assume you meant some ARM32 platforms require
a *64-bit* dma_addr_t, i.e., you might want to build an ILP32 kernel
with a 64-bit dma_addr_t).

I doubt there would be a noticeable performance effect since these are
relatively low-frequency interfaces (map, unmap, report_fault), but I
don't have any numbers, so I'll drop this for now.

Bjorn
