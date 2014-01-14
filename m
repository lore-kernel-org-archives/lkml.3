Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751329AbaANJP1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 04:15:27 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:20939 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777AbaANJPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 04:15:23 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-66-52d50028d724
Message-id: <52D50027.60207@samsung.com>
Date: Tue, 14 Jan 2014 10:15:19 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101
 Thunderbird/24.2.0
MIME-version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-mm-sig@lists.linaro.org
Subject: Re: [RFC] dma-mapping: Provide write-combine allocations
References: <1389621188-3094-1-git-send-email-treding@nvidia.com>
In-reply-to: <1389621188-3094-1-git-send-email-treding@nvidia.com>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDLMWRmVeSWpSXmKPExsVy+t/xK7oaDFeDDFbtM7H4O+kYu8WXKw+Z
	LDY9vsZqcXnXHDaLzR9esln83DWPxYHNo6W5h83j969JjB47Z91l99i8pN7j9r/HzB6fN8kF
	sEVx2aSk5mSWpRbp2yVwZdx+s4+1YItoxa9dOQ2M5wS7GDk5JARMJJadPc0IYYtJXLi3nq2L
	kYtDSGApo8SO/rvMEM4nRomJT3+yglTxCmhINN5awAZiswioSpx+cwUsziZgKNH1tgssLioQ
	KrHnI8RUXgFBiR+T77GA2CICVRK3fqwHizMLZEhMf7UbzBYWcJS4vqyLHcQWArIXv9kINpNT
	wElizcVPTBD1ZhKPWtYxQ9jyEpvXvGWewCgwC8mKWUjKZiEpW8DIvIpRNLU0uaA4KT3XUK84
	Mbe4NC9dLzk/dxMjJMS/7GBcfMzqEKMAB6MSD+9JxitBQqyJZcWVuYcYJTiYlUR4KxcAhXhT
	EiurUovy44tKc1KLDzEycXBKNTDGHV0298OZnsiA4uPFMYqVVuFXGfeElB6S/Zh/e8W/GZKe
	L2XyU+RKKprOuhlkWO1z3HB26/6NBrtmhR0SYDIzt5i039tRcO5715vWbWZ3vug1Wx/XmrOv
	2qa3zTX67Vrz4AsHD7AVCZz4s9ko6chz7nV3XtzWr7ui+rlklvizQ6tZI04FpHQrsRRnJBpq
	MRcVJwIAhqWmW08CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 2014-01-13 14:53, Thierry Reding wrote:
> Provide an implementation for dma_{alloc,free}_writecombine() when the
> architecture supports DMA attributes.
>
> Signed-off-by: Thierry Reding <treding@nvidia.com>
> ---
>   arch/arm/include/asm/dma-mapping.h | 16 ----------------
>   include/linux/dma-mapping.h        | 16 ++++++++++++++++
>   2 files changed, 16 insertions(+), 16 deletions(-)
>
> diff --git a/arch/arm/include/asm/dma-mapping.h b/arch/arm/include/asm/dma-mapping.h
> index e701a4d9aa59..96b7634a7edc 100644
> --- a/arch/arm/include/asm/dma-mapping.h
> +++ b/arch/arm/include/asm/dma-mapping.h
> @@ -242,22 +242,6 @@ extern int arm_dma_mmap(struct device *dev, struct vm_area_struct *vma,
>   			void *cpu_addr, dma_addr_t dma_addr, size_t size,
>   			struct dma_attrs *attrs);
>   
> -static inline void *dma_alloc_writecombine(struct device *dev, size_t size,
> -				       dma_addr_t *dma_handle, gfp_t flag)
> -{
> -	DEFINE_DMA_ATTRS(attrs);
> -	dma_set_attr(DMA_ATTR_WRITE_COMBINE, &attrs);
> -	return dma_alloc_attrs(dev, size, dma_handle, flag, &attrs);
> -}
> -
> -static inline void dma_free_writecombine(struct device *dev, size_t size,
> -				     void *cpu_addr, dma_addr_t dma_handle)
> -{
> -	DEFINE_DMA_ATTRS(attrs);
> -	dma_set_attr(DMA_ATTR_WRITE_COMBINE, &attrs);
> -	return dma_free_attrs(dev, size, cpu_addr, dma_handle, &attrs);
> -}
> -
>   /*
>    * This can be called during early boot to increase the size of the atomic
>    * coherent DMA pool above the default value of 256KiB. It must be called
> diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
> index fd4aee29ad10..8475e02b4bd1 100644
> --- a/include/linux/dma-mapping.h
> +++ b/include/linux/dma-mapping.h
> @@ -249,6 +249,22 @@ struct dma_attrs;
>   #define dma_unmap_sg_attrs(dev, sgl, nents, dir, attrs) \
>   	dma_unmap_sg(dev, sgl, nents, dir)
>   
> +#else
> +static inline void *dma_alloc_writecombine(struct device *dev, size_t size,
> +					   dma_addr_t *dma_addr, gfp_t gfp)
> +{
> +	DEFINE_DMA_ATTRS(attrs);
> +	dma_set_attr(DMA_ATTR_WRITE_COMBINE, &attrs);
> +	return dma_alloc_attrs(dev, size, dma_addr, gfp, &attrs);
> +}
> +
> +static inline void dma_free_writecombine(struct device *dev, size_t size,
> +					 void *cpu_addr, dma_addr_t dma_addr)
> +{
> +	DEFINE_DMA_ATTRS(attrs);
> +	dma_set_attr(DMA_ATTR_WRITE_COMBINE, &attrs);
> +	return dma_free_attrs(dev, size, cpu_addr, dma_addr, &attrs);
> +}
>   #endif /* CONFIG_HAVE_DMA_ATTRS */
>   
>   #ifdef CONFIG_NEED_DMA_MAP_STATE

I would also add dma_mmap_writecombine() to the above functions.

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

