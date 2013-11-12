Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755981Ab3KLOuN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 09:50:13 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:51132 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755565Ab3KLOuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 09:50:09 -0500
Date: Tue, 12 Nov 2013 09:48:32 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: xen-devel@lists.xensource.com, konrad@kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [Xen-devel] [PATCH 2/2] swiotlb-xen: xen_swiotlb_map_page: do
 not error out if dma_capable fails
Message-ID: <20131112144832.GC9435@phenom.dumpdata.com>
References: <alpine.DEB.2.02.1311121404590.26077@kaball.uk.xensource.com>
 <1384265520-6833-2-git-send-email-stefano.stabellini@eu.citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384265520-6833-2-git-send-email-stefano.stabellini@eu.citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 12, 2013 at 02:12:00PM +0000, Stefano Stabellini wrote:
> Many ARM devices do not set the dma_mask correctly today.
> As a consequence dma_capable fails for them regardless of the address
> passed to it.

Wouldn't the DMA API debug warn of bad usage.

> In xen_swiotlb_map_page we currently use dma_capable to check if the
> address returned by the swiotlb is good for dma for the device.

Right..
> However the check would often fail even if the address is correct.

 .. and they will fail b/c the device hasn't set its dma mask so
we use the platform default right? What is the platform default?

> Considering that we know that the swiotlb buffer has a low address,
> skip the check.

I am not following that sentence. Could you please explain to me
how the SWIOTLB buffer low address guarantees that we don't need
the check?
> 
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

What are the drivers that are busted. Does DMA API debug flag them?

Thanks!
> ---
>  drivers/xen/swiotlb-xen.c |    7 -------
>  1 files changed, 0 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/xen/swiotlb-xen.c b/drivers/xen/swiotlb-xen.c
> index 1eac073..543e30b 100644
> --- a/drivers/xen/swiotlb-xen.c
> +++ b/drivers/xen/swiotlb-xen.c
> @@ -402,13 +402,6 @@ dma_addr_t xen_swiotlb_map_page(struct device *dev, struct page *page,
>  					map & ~PAGE_MASK, size, dir, attrs);
>  	dev_addr = xen_phys_to_bus(map);
>  
> -	/*
> -	 * Ensure that the address returned is DMA'ble
> -	 */
> -	if (!dma_capable(dev, dev_addr, size)) {
> -		swiotlb_tbl_unmap_single(dev, map, size, dir);
> -		dev_addr = 0;
> -	}
>  	return dev_addr;
>  }
>  EXPORT_SYMBOL_GPL(xen_swiotlb_map_page);
> -- 
> 1.7.2.5
> 
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xen.org
> http://lists.xen.org/xen-devel
