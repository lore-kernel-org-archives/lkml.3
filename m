Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752892AbaKQOnz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 09:43:55 -0500
Received: from smtp.citrix.com ([66.165.176.89]:2158 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752174AbaKQOnx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 09:43:53 -0500
X-IronPort-AV: E=Sophos;i="5.07,403,1413244800"; 
   d="scan'208";a="192058712"
Message-ID: <546A09A2.9090704@citrix.com>
Date: Mon, 17 Nov 2014 14:43:46 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        <gregkh@linuxfoundation.org>
CC: <linux-mips@linux-mips.org>, <airlied@linux.ie>,
        <dri-devel@lists.freedesktop.org>, <xen-devel@lists.xensource.com>,
        <linux@arm.linux.org.uk>, <vinod.koul@intel.com>, <deller@gmx.de>,
        <jejb@parisc-linux.org>, Ian Campbell <Ian.Campbell@citrix.com>,
        <alexander.deucher@amd.com>, <bhelgaas@google.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-parisc@vger.kernel.org>,
        <dwmw2@infradead.org>, <linux-kernel@vger.kernel.org>,
        <ralf@linux-mips.org>, <iommu@lists.linux-foundation.org>,
        David Vrabel <david.vrabel@citrix.com>, <dmaengine@vger.kernel.org>,
        <torvalds@linux-foundation.org>, <christian.koenig@amd.com>
Subject: Re: [Xen-devel] [RFC] add a struct page* parameter to dma_map_ops.unmap_page
References: <alpine.DEB.2.02.1411111644490.26318@kaball.uk.xensource.com>
In-Reply-To: <alpine.DEB.2.02.1411111644490.26318@kaball.uk.xensource.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/11/14 14:11, Stefano Stabellini wrote:
> Hi all,
> I am writing this email to ask for your advice.
> 
> On architectures where dma addresses are different from physical
> addresses, it can be difficult to retrieve the physical address of a
> page from its dma address.
> 
> Specifically this is the case for Xen on arm and arm64 but I think that
> other architectures might have the same issue.
> 
> Knowing the physical address is necessary to be able to issue any
> required cache maintenance operations when unmap_page,
> sync_single_for_cpu and sync_single_for_device are called.
> 
> Adding a struct page* parameter to unmap_page, sync_single_for_cpu and
> sync_single_for_device would make Linux dma handling on Xen on arm and
> arm64 much easier and quicker.

Using an opaque handle instead of struct page * would be more beneficial
for the Intel IOMMU driver.  e.g.,

typedef dma_addr_t dma_handle_t;

dma_handle_t dma_map_single(struct device *dev,
                            void *va, size_t size,
                            enum dma_data_direction dir);
void dma_unmap_single(struct device *dev,
                      dma_handle_t handle, size_t size,
                      enum dma_data_direction dir);

etc.

Drivers would then use:

dma_addr_t dma_addr(dma_handle_t handle);

To obtain the bus address from the handle.

> I think that other drivers have similar problems, such as the Intel
> IOMMU driver having to call find_iova and walking down an rbtree to get
> the physical address in its implementation of unmap_page.
> 
> Callers have the struct page* in their hands already from the previous
> map_page call so it shouldn't be an issue for them.  A problem does
> exist however: there are about 280 callers of dma_unmap_page and
> pci_unmap_page. We have even more callers of the dma_sync_single_for_*
> functions.

You will also need to fix dma_unmap_single() and pci_unmap_single()
(another 1000+ callers).

You may need to consider a parallel set of map/unmap API calls that
return/accept a handle, and then converting drivers one-by-one as
required, instead of trying to convert every single driver at once.

David
