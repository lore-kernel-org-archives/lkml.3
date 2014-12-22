Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755181AbaLVPZv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 10:25:51 -0500
Received: from mga11.intel.com ([192.55.52.93]:40383 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754842AbaLVPZt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 10:25:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,624,1413270000"; 
   d="scan'208";a="651674383"
Date: Mon, 22 Dec 2014 20:55:17 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Robin Murphy <robin.murphy@arm.com>, Will Deacon <will.deacon@arm.com>
Cc: dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, dan.j.williams@intel.com,
        lars@metafoo.de, liviu.dudau@arm.com, andrew.jackson@arm.com
Subject: Re: [PATCH] dma-mapping: tidy up dma_parms default handling
Message-ID: <20141222152517.GM16827@intel.com>
References: <ffdc5455d698d2525f2d126d0adabf9418fd76b1.1418990609.git.robin.murphy@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ffdc5455d698d2525f2d126d0adabf9418fd76b1.1418990609.git.robin.murphy@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 19, 2014 at 05:39:09PM +0000, Robin Murphy wrote:
> Many DMA controllers and other devices set max_segment_size to
> indicate their scatter-gather capability, but have no interest in
> segment_boundary_mask. However, the existence of a dma_parms structure
> precludes the use of any default value, leaving them as zeros (assuming
> a properly kzalloc'ed structure). If a well-behaved IOMMU (or SWIOTLB)
> then tries to respect this by ensuring a mapped segment does not cross
> a zero-byte boundary, hilarity ensues.
> 
> Since zero is a nonsensical value for either parameter, treat it as an
> indicator for "default", as might be expected. In the process, clean up
> a bit by replacing the bare constants with slightly more meaningful
> macros and removing the superfluous "else" statements.
> 
> Signed-off-by: Robin Murphy <robin.murphy@arm.com>
> ---
> 
> Hi Vinod, dmaengine folks,
> 
> This isn't strictly a dmaengine patch, but get_maintainer.pl pointed at you,
> and there do happen to be more dmaengine drivers potentially affected by this
> than anything else - the current PL330 driver blows up arm64's SWIOTLB when
> running dmatest on the Juno platform, which is what brought the underlying
> problem to light.
That's due to include/linux/dma*, I will fix that up.

I think arm folks should be able to help review this... Last few commit
point to Will Decon carrying these

-- 
~Vinod

> 
>  include/linux/dma-mapping.h | 17 ++++++++++-------
>  1 file changed, 10 insertions(+), 7 deletions(-)
> 
> diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
> index c3007cb..99ba736 100644
> --- a/include/linux/dma-mapping.h
> +++ b/include/linux/dma-mapping.h
> @@ -141,7 +141,9 @@ static inline void arch_teardown_dma_ops(struct device *dev) { }
>  
>  static inline unsigned int dma_get_max_seg_size(struct device *dev)
>  {
> -	return dev->dma_parms ? dev->dma_parms->max_segment_size : 65536;
> +	if (dev->dma_parms && dev->dma_parms->max_segment_size)
> +		return dev->dma_parms->max_segment_size;
> +	return SZ_64K;
>  }
>  
>  static inline unsigned int dma_set_max_seg_size(struct device *dev,
> @@ -150,14 +152,15 @@ static inline unsigned int dma_set_max_seg_size(struct device *dev,
>  	if (dev->dma_parms) {
>  		dev->dma_parms->max_segment_size = size;
>  		return 0;
> -	} else
> -		return -EIO;
> +	}
> +	return -EIO;
>  }
>  
>  static inline unsigned long dma_get_seg_boundary(struct device *dev)
>  {
> -	return dev->dma_parms ?
> -		dev->dma_parms->segment_boundary_mask : 0xffffffff;
> +	if (dev->dma_parms && dev->dma_parms->segment_boundary_mask)
> +		return dev->dma_parms->segment_boundary_mask;
> +	return DMA_BIT_MASK(32);
>  }
>  
>  static inline int dma_set_seg_boundary(struct device *dev, unsigned long mask)
> @@ -165,8 +168,8 @@ static inline int dma_set_seg_boundary(struct device *dev, unsigned long mask)
>  	if (dev->dma_parms) {
>  		dev->dma_parms->segment_boundary_mask = mask;
>  		return 0;
> -	} else
> -		return -EIO;
> +	}
> +	return -EIO;
>  }
>  
>  #ifndef dma_max_pfn
> -- 
> 1.9.1
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe dmaengine" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
