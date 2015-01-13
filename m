Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752111AbbAMLTR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 06:19:17 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:24194 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212AbbAMLTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 06:19:15 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-e6-54b4ff312f1c
Message-id: <54B4FF30.2030607@samsung.com>
Date: Tue, 13 Jan 2015 12:19:12 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101
 Thunderbird/31.3.0
MIME-version: 1.0
To: Robin Murphy <robin.murphy@arm.com>, will.deacon@arm.com, arnd@arndb.de,
        bhelgaas@google.com, joro@8bytes.org, gregkh@linuxfoundation.org
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH RESEND] dma-mapping: tidy up dma_parms default handling
References: <ffdc5455d698d2525f2d126d0adabf9418fd76b1.1418990609.git.robin.murphy@arm.com>
In-reply-to: <ffdc5455d698d2525f2d126d0adabf9418fd76b1.1418990609.git.robin.murphy@arm.com>
Content-type: text/plain; charset=utf-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCLMWRmVeSWpSXmKPExsVy+t/xq7qG/7eEGGx/Imzxd9IxdoslTRkW
	zYvXs1ks2G9t0Tl7A7vFpsfXWC0u75rDZnHwwxNWi5cfT7A4cHo8OTiPyWPNvDWMHr9/TWL0
	WLCp1GP/3DXsHpuX1HtMvrGc0ePzJrkAjigum5TUnMyy1CJ9uwSujMWTtjIVXJaomPLvFXMD
	43vhLkZODgkBE4kjTycyQthiEhfurWfrYuTiEBJYyihxYOt0VgjnE6PEg62L2UGqeAW0JH5f
	2cQKYrMIqErc/DmHCcRmEzCU6HrbxQZiiwrESCxeuJoZol5Q4sfkeywgg0QE+hklPj+7BTaI
	WSBL4kTfbLAiYQFvia9X9rCA2EJAzQ/m3AazOQViJTpPLoOqN5P48vIwK4QtL7F5zVvmCYwC
	s5DsmIWkbBaSsgWMzKsYRVNLkwuKk9JzDfWKE3OLS/PS9ZLzczcxQmLiyw7GxcesDjEKcDAq
	8fDuyN4SIsSaWFZcmXuIUYKDWUmEN/07UIg3JbGyKrUoP76oNCe1+BAjEwenVAOj866H7N6u
	f3d5CJf9eG0svCPyzLZ1ukJbJ0yuMqn+ffWAzP9kJXMJe+7O7qDyB1POsd3cWKL3g3f2TUut
	bM7K7bKJjmus5A8f376/l/19LvvnS/d7tP0e1N3p0H+rnBx4O3nBgxWFAnqXjrcWp8wKjp5S
	toFpU8ti2dca/Xwyf5+/Unrz/WyLEktxRqKhFnNRcSIAa05IjmcCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 2015-01-09 17:56, Robin Murphy wrote:
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

Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>

> ---
>
> Hi, various maintainers from Git logs ;)
>
> This one's a bit tricky to find a home for - I think technically it's
> probably an IOMMU patch, but then the long-underlying problem doesn't
> seem to have blown up anything until arm64, and my motivation is to
> make bits of Juno work, which seems to nudge it towards arm64/arm-soc
> territory. Could anyone suggest which tree is most appropriate?
>
> Thanks,
> Robin.
>
>   include/linux/dma-mapping.h | 17 ++++++++++-------
>   1 file changed, 10 insertions(+), 7 deletions(-)
>
> diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
> index c3007cb..99ba736 100644
> --- a/include/linux/dma-mapping.h
> +++ b/include/linux/dma-mapping.h
> @@ -141,7 +141,9 @@ static inline void arch_teardown_dma_ops(struct device *dev) { }
>   
>   static inline unsigned int dma_get_max_seg_size(struct device *dev)
>   {
> -	return dev->dma_parms ? dev->dma_parms->max_segment_size : 65536;
> +	if (dev->dma_parms && dev->dma_parms->max_segment_size)
> +		return dev->dma_parms->max_segment_size;
> +	return SZ_64K;
>   }
>   
>   static inline unsigned int dma_set_max_seg_size(struct device *dev,
> @@ -150,14 +152,15 @@ static inline unsigned int dma_set_max_seg_size(struct device *dev,
>   	if (dev->dma_parms) {
>   		dev->dma_parms->max_segment_size = size;
>   		return 0;
> -	} else
> -		return -EIO;
> +	}
> +	return -EIO;
>   }
>   
>   static inline unsigned long dma_get_seg_boundary(struct device *dev)
>   {
> -	return dev->dma_parms ?
> -		dev->dma_parms->segment_boundary_mask : 0xffffffff;
> +	if (dev->dma_parms && dev->dma_parms->segment_boundary_mask)
> +		return dev->dma_parms->segment_boundary_mask;
> +	return DMA_BIT_MASK(32);
>   }
>   
>   static inline int dma_set_seg_boundary(struct device *dev, unsigned long mask)
> @@ -165,8 +168,8 @@ static inline int dma_set_seg_boundary(struct device *dev, unsigned long mask)
>   	if (dev->dma_parms) {
>   		dev->dma_parms->segment_boundary_mask = mask;
>   		return 0;
> -	} else
> -		return -EIO;
> +	}
> +	return -EIO;
>   }
>   
>   #ifndef dma_max_pfn

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

