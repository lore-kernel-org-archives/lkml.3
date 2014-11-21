Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758271AbaKULtC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 06:49:02 -0500
Received: from smtp.citrix.com ([66.165.176.89]:54824 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754592AbaKULs7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 06:48:59 -0500
X-IronPort-AV: E=Sophos;i="5.07,429,1413244800"; 
   d="scan'208";a="193667428"
Date: Fri, 21 Nov 2014 11:48:33 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: <gregkh@linuxfoundation.org>, David Vrabel <david.vrabel@citrix.com>,
        Ian Campbell <Ian.Campbell@citrix.com>, <konrad.wilk@oracle.com>,
        <linux-kernel@vger.kernel.org>, <xen-devel@lists.xensource.com>,
        <torvalds@linux-foundation.org>, <vinod.koul@intel.com>,
        <dmaengine@vger.kernel.org>, <bhelgaas@google.com>,
        <jejb@parisc-linux.org>, <deller@gmx.de>,
        <linux-parisc@vger.kernel.org>, <iommu@lists.linux-foundation.org>,
        <airlied@linux.ie>, <dri-devel@lists.freedesktop.org>,
        <alexander.deucher@amd.com>, <christian.koenig@amd.com>,
        <linux@arm.linux.org.uk>, <linux-mips@linux-mips.org>,
        <ralf@linux-mips.org>, <linux-arm-kernel@lists.infradead.org>,
        <dwmw2@infradead.org>
Subject: Re: [RFC] add a struct page* parameter to dma_map_ops.unmap_page
In-Reply-To: <alpine.DEB.2.02.1411111644490.26318@kaball.uk.xensource.com>
Message-ID: <alpine.DEB.2.02.1411211147450.12596@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1411111644490.26318@kaball.uk.xensource.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Nov 2014, Stefano Stabellini wrote:
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
> 
> I think that other drivers have similar problems, such as the Intel
> IOMMU driver having to call find_iova and walking down an rbtree to get
> the physical address in its implementation of unmap_page.
> 
> Callers have the struct page* in their hands already from the previous
> map_page call so it shouldn't be an issue for them.  A problem does
> exist however: there are about 280 callers of dma_unmap_page and
> pci_unmap_page. We have even more callers of the dma_sync_single_for_*
> functions.
> 
> 
> 
> Is such a change even conceivable? How would one go about it?
> 
> I think that Xen would not be the only one to gain from it, but I would
> like to have a confirmation from others: given the magnitude of the
> changes involved I would actually prefer to avoid them unless multiple
> drivers/archs/subsystems could really benefit from them.

Given the lack of interest from the community, I am going to drop this
idea.




> Cheers,
> 
> Stefano
> 
> 
> diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
> index d5d3881..158a765 100644
> --- a/include/linux/dma-mapping.h
> +++ b/include/linux/dma-mapping.h
> @@ -31,8 +31,9 @@ struct dma_map_ops {
>  			       unsigned long offset, size_t size,
>  			       enum dma_data_direction dir,
>  			       struct dma_attrs *attrs);
> -	void (*unmap_page)(struct device *dev, dma_addr_t dma_handle,
> -			   size_t size, enum dma_data_direction dir,
> +	void (*unmap_page)(struct device *dev, struct page *page,
> +			   dma_addr_t dma_handle, size_t size,
> +			   enum dma_data_direction dir,
>  			   struct dma_attrs *attrs);
>  	int (*map_sg)(struct device *dev, struct scatterlist *sg,
>  		      int nents, enum dma_data_direction dir,
> @@ -41,10 +42,10 @@ struct dma_map_ops {
>  			 struct scatterlist *sg, int nents,
>  			 enum dma_data_direction dir,
>  			 struct dma_attrs *attrs);
> -	void (*sync_single_for_cpu)(struct device *dev,
> +	void (*sync_single_for_cpu)(struct device *dev, struct page *page,
>  				    dma_addr_t dma_handle, size_t size,
>  				    enum dma_data_direction dir);
> -	void (*sync_single_for_device)(struct device *dev,
> +	void (*sync_single_for_device)(struct device *dev, struct page *page,
>  				       dma_addr_t dma_handle, size_t size,
>  				       enum dma_data_direction dir);
>  	void (*sync_sg_for_cpu)(struct device *dev,
> 
