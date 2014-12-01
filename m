Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932759AbaLAWLR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 17:11:17 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:25991 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932595AbaLAWIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 17:08:36 -0500
Date: Mon, 1 Dec 2014 15:28:03 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Joerg Roedel <joro@8bytes.org>
Cc: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Joerg Roedel <jroedel@suse.de>
Subject: Re: [PATCH 1/3] swiotlb: Warn on allocation failure in
 swiotlb_alloc_coherent
Message-ID: <20141201202802.GC21626@laptop.dumpdata.com>
References: <1417174149-31210-1-git-send-email-joro@8bytes.org>
 <1417174149-31210-2-git-send-email-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417174149-31210-2-git-send-email-joro@8bytes.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 28, 2014 at 12:29:07PM +0100, Joerg Roedel wrote:
> From: Joerg Roedel <jroedel@suse.de>
> 
> Print a warning when all allocation tries have been failed
> and the function is about to return NULL. This prepares for
> calling the function with __GFP_NOWARN to suppress
> allocation failure warnings before all fall-backs have
> failed.

This can be quite noisy. Especially the dump-stack.

Perhaps have this trigger is the 'verbose' or 'debug' (new) parameter
would be added to the 'swiotlb' one?

> 
> Signed-off-by: Joerg Roedel <jroedel@suse.de>
> ---
>  lib/swiotlb.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/lib/swiotlb.c b/lib/swiotlb.c
> index 4abda07..e0e9212 100644
> --- a/lib/swiotlb.c
> +++ b/lib/swiotlb.c
> @@ -655,7 +655,7 @@ swiotlb_alloc_coherent(struct device *hwdev, size_t size,
>  		 */
>  		phys_addr_t paddr = map_single(hwdev, 0, size, DMA_FROM_DEVICE);
>  		if (paddr == SWIOTLB_MAP_ERROR)
> -			return NULL;
> +			goto err_warn;
>  
>  		ret = phys_to_virt(paddr);
>  		dev_addr = phys_to_dma(hwdev, paddr);
> @@ -669,7 +669,7 @@ swiotlb_alloc_coherent(struct device *hwdev, size_t size,
>  			/* DMA_TO_DEVICE to avoid memcpy in unmap_single */
>  			swiotlb_tbl_unmap_single(hwdev, paddr,
>  						 size, DMA_TO_DEVICE);
> -			return NULL;
> +			goto err_warn;
>  		}
>  	}
>  
> @@ -677,6 +677,13 @@ swiotlb_alloc_coherent(struct device *hwdev, size_t size,
>  	memset(ret, 0, size);
>  
>  	return ret;
> +
> +err_warn:
> +	pr_warn("swiotlb: coherent allocation failed for device %s size=%zu\n",
> +		dev_name(hwdev), size);
> +	dump_stack();
> +
> +	return NULL;
>  }
>  EXPORT_SYMBOL(swiotlb_alloc_coherent);
>  
> -- 
> 1.9.1
> 
