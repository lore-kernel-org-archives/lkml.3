Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751637Ab3JWODZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 10:03:25 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:42567 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936Ab3JWODY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 10:03:24 -0400
Date: Wed, 23 Oct 2013 10:01:50 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Ian.Campbell@citrix.com
Subject: Re: [PATCH v8 18/19] swiotlb-xen: no need to do execute two
 bus_to_phys translations in a row
Message-ID: <20131023140150.GB27771@phenom.dumpdata.com>
References: <alpine.DEB.2.02.1310171833520.26077@kaball.uk.xensource.com>
 <1382031814-8782-18-git-send-email-stefano.stabellini@eu.citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382031814-8782-18-git-send-email-stefano.stabellini@eu.citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 17, 2013 at 06:43:33PM +0100, Stefano Stabellini wrote:
> xen_unmap_single calls xen_bus_to_phys, then passes dev_addr to
> is_xen_swiotlb_buffer that calls xen_bus_to_phys again.

It does?

I see it call mfn_to_local_pfn which calls pfn_to_mfn and
get_phys_to_machine (which I presume is going to be a slow
operation on ARM).

> xen_bus_to_phys is potentially a slow operation that might involve
> walking a tree.
> We can avoid calling xen_bus_to_phys twice by removing the
> is_xen_swiotlb_buffer call and doing the check directly in
> xen_unmap_single using the physical address.
> 
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

Have you tested this with a PFN that is in a foreign domain?

I am bit uncomfortable with this - I recall when developing this
that I had hit some odd cases of doing DMA of a page to a guest
and it not always working. It was the case of not detecting whether
the pfn was foreign or not. Sadly I can't recall the details.

I would think that this problem would also be present with ARM?
But perhaps all the new changes in the pfn_to_mfn that had lately
been done have fixed this?

> ---
>  drivers/xen/swiotlb-xen.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/xen/swiotlb-xen.c b/drivers/xen/swiotlb-xen.c
> index 4d50058..6d9ca61 100644
> --- a/drivers/xen/swiotlb-xen.c
> +++ b/drivers/xen/swiotlb-xen.c
> @@ -426,8 +426,8 @@ static void xen_unmap_single(struct device *hwdev, dma_addr_t dev_addr,
>  
>  	xen_dma_unmap_page(hwdev, paddr, size, dir, attrs);
>  
> -	/* NOTE: We use dev_addr here, not paddr! */
> -	if (is_xen_swiotlb_buffer(dev_addr)) {
> +	if (paddr >= virt_to_phys(xen_io_tlb_start) &&
> +		paddr < virt_to_phys(xen_io_tlb_end)) {
>  		swiotlb_tbl_unmap_single(hwdev, paddr, size, dir);
>  		return;
>  	}
> -- 
> 1.7.2.5
> 
