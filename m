Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754070Ab3HBQ0y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 12:26:54 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:23621 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753835Ab3HBQ0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 12:26:52 -0400
Date: Fri, 2 Aug 2013 12:26:39 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: EUNBONG SONG <eunb.song@samsung.com>, xen-devel@lists.xensource.com,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] swiotlb: Replace dma_length to sg_dma_len()  macro
Message-ID: <20130802162639.GA3690@phenom.dumpdata.com>
References: <25826040.283591366090672676.JavaMail.weblogic@epml15>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <25826040.283591366090672676.JavaMail.weblogic@epml15>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 16, 2013 at 05:37:52AM +0000, EUNBONG SONG wrote:
> 
> This patch replace dma_length in "lib/swiotlb.c" to sg_dma_len() macro, because the build error can occur
> if CONFIG_NEED_SG_DMA_LENGTH is not set, and CONFIG_SWIOTLB is set.
> I confirmed compile only. 

Stefano, This patch should fix the ARM issues, but when I tried to apply it
would go all wonky.

> 
> Singed-off-by: EunBong Song <eunb.song@samsung.com>
> 
> ---
>  lib/swiotlb.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/lib/swiotlb.c b/lib/swiotlb.c
> index bfe02b8..7b16f4a 100644
> --- a/lib/swiotlb.c
> +++ b/lib/swiotlb.c
> @@ -859,13 +859,13 @@ swiotlb_map_sg_attrs(struct device *hwdev, struct scatterlist *sgl, int nelems,
>  				swiotlb_full(hwdev, sg->length, dir, 0);
>  				swiotlb_unmap_sg_attrs(hwdev, sgl, i, dir,
>  						       attrs);
> -				sgl[0].dma_length = 0;
> +				sg_dma_len(sgl) = 0;
>  				return 0;
>  			}
>  			sg->dma_address = phys_to_dma(hwdev, map);
>  		} else
>  			sg->dma_address = dev_addr;
> -		sg->dma_length = sg->length;
> +		sg_dma_len(sg) = sg->length;
>  	}
>  	return nelems;
>  }
> @@ -893,7 +893,7 @@ swiotlb_unmap_sg_attrs(struct device *hwdev, struct scatterlist *sgl,
>  	BUG_ON(dir == DMA_NONE);
>  
>  	for_each_sg(sgl, sg, nelems, i)
> -		unmap_single(hwdev, sg->dma_address, sg->dma_length, dir);
> +		unmap_single(hwdev, sg->dma_address, sg_dma_len(sg), dir);
>  
>  }
>  EXPORT_SYMBOL(swiotlb_unmap_sg_attrs);
> @@ -923,7 +923,7 @@ swiotlb_sync_sg(struct device *hwdev, struct scatterlist *sgl,
>  
>  	for_each_sg(sgl, sg, nelems, i)
>  		swiotlb_sync_single(hwdev, sg->dma_address,
> -				    sg->dma_length, dir, target);
> +				    sg_dma_len(sg), dir, target);
>  }
>  
>  void
> -- 
> 1.7.0.4
