Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755753Ab3I3QC4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 12:02:56 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:47210 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754790Ab3I3QCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 12:02:55 -0400
Date: Mon, 30 Sep 2013 12:02:23 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Ian.Campbell@citrix.com
Subject: Re: [PATCH v6 15/19] swiotlb-xen: call dma_capable only if
 dev->dma_mask is allocated
Message-ID: <20130930160223.GU3106@phenom.dumpdata.com>
References: <alpine.DEB.2.02.1309271653420.5498@kaball.uk.xensource.com>
 <1380298207-29151-15-git-send-email-stefano.stabellini@eu.citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380298207-29151-15-git-send-email-stefano.stabellini@eu.citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 27, 2013 at 05:10:03PM +0100, Stefano Stabellini wrote:

Why? I am looking at X86 and IA64 and I see:

 79         if (!dev->dma_mask)                                                     
 80                 return 0;           


Why not port dma_capable over to ARM?

> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> ---
>  drivers/xen/swiotlb-xen.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/xen/swiotlb-xen.c b/drivers/xen/swiotlb-xen.c
> index 790c2eb..3011736 100644
> --- a/drivers/xen/swiotlb-xen.c
> +++ b/drivers/xen/swiotlb-xen.c
> @@ -512,7 +512,7 @@ dma_addr_t xen_swiotlb_map_page(struct device *dev, struct page *page,
>  	 * buffering it.
>  	 */
>  	if (!xen_feature(XENFEAT_auto_translated_physmap) &&
> -	    dma_capable(dev, dev_addr, size) &&
> +	    dev->dma_mask && dma_capable(dev, dev_addr, size) &&
>  	    !range_straddles_page_boundary(phys, size) && !swiotlb_force)
>  		return dev_addr;
>  
> @@ -532,7 +532,7 @@ dma_addr_t xen_swiotlb_map_page(struct device *dev, struct page *page,
>  	/*
>  	 * Ensure that the address returned is DMA'ble
>  	 */
> -	if (!dma_capable(dev, dev_addr, size)) {
> +	if (dev->dma_mask && !dma_capable(dev, dev_addr, size)) {
>  		swiotlb_tbl_unmap_single(dev, map, size, dir);
>  		dev_addr = 0;
>  	}
> @@ -660,7 +660,7 @@ xen_swiotlb_map_sg_attrs(struct device *hwdev, struct scatterlist *sgl,
>  
>  		if (swiotlb_force ||
>  		    xen_feature(XENFEAT_auto_translated_physmap) ||
> -		    !dma_capable(hwdev, dev_addr, sg->length) ||
> +		    (hwdev->dma_mask && !dma_capable(hwdev, dev_addr, sg->length)) ||
>  		    range_straddles_page_boundary(paddr, sg->length)) {
>  			/*
>  			 * Pass the dma_addr of the first slab in the iotlb buffer as
> -- 
> 1.7.2.5
> 
