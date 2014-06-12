Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755411AbaFLEok (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 00:44:40 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:42573 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439AbaFLEoi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 00:44:38 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Michal Nazarewicz <mina86@mina86.com>
Cc: Minchan Kim <minchan@kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        Alexander Graf <agraf@suse.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: Re: [PATCH v2 03/10] DMA, CMA: separate core cma management codes from DMA APIs
In-Reply-To: <1402543307-29800-4-git-send-email-iamjoonsoo.kim@lge.com>
References: <1402543307-29800-1-git-send-email-iamjoonsoo.kim@lge.com> <1402543307-29800-4-git-send-email-iamjoonsoo.kim@lge.com>
User-Agent: Notmuch/0.18~rc0+2~gbc64cdc (http://notmuchmail.org) Emacs/24.3.91.1 (x86_64-unknown-linux-gnu)
Date: Thu, 12 Jun 2014 10:14:29 +0530
Message-ID: <87sinapwia.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14061204-4790-0000-0000-000002010829
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joonsoo Kim <iamjoonsoo.kim@lge.com> writes:

> To prepare future generalization work on cma area management code,
> we need to separate core cma management codes from DMA APIs.
> We will extend these core functions to cover requirements of
> ppc kvm's cma area management functionality in following patches.
> This separation helps us not to touch DMA APIs while extending
> core functions.
>
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

>
> diff --git a/drivers/base/dma-contiguous.c b/drivers/base/dma-contiguous.c
> index fb0cdce..8a44c82 100644
> --- a/drivers/base/dma-contiguous.c
> +++ b/drivers/base/dma-contiguous.c
> @@ -231,9 +231,9 @@ core_initcall(cma_init_reserved_areas);
>   * If @fixed is true, reserve contiguous area at exactly @base.  If false,
>   * reserve in range from @base to @limit.
>   */
> -int __init dma_contiguous_reserve_area(phys_addr_t size, phys_addr_t base,
> -				       phys_addr_t limit, struct cma **res_cma,
> -				       bool fixed)
> +static int __init __dma_contiguous_reserve_area(phys_addr_t size,
> +				phys_addr_t base, phys_addr_t limit,
> +				struct cma **res_cma, bool fixed)
>  {
>  	struct cma *cma = &cma_areas[cma_area_count];
>  	phys_addr_t alignment;
> @@ -288,16 +288,30 @@ int __init dma_contiguous_reserve_area(phys_addr_t size, phys_addr_t base,
>
>  	pr_info("%s(): reserved %ld MiB at %08lx\n",
>  		__func__, (unsigned long)size / SZ_1M, (unsigned long)base);
> -
> -	/* Architecture specific contiguous memory fixup. */
> -	dma_contiguous_early_fixup(base, size);
>  	return 0;
> +
>  err:
>  	pr_err("%s(): failed to reserve %ld MiB\n",
>  		__func__, (unsigned long)size / SZ_1M);
>  	return ret;
>  }
>
> +int __init dma_contiguous_reserve_area(phys_addr_t size, phys_addr_t base,
> +				       phys_addr_t limit, struct cma **res_cma,
> +				       bool fixed)
> +{
> +	int ret;
> +
> +	ret = __dma_contiguous_reserve_area(size, base, limit, res_cma, fixed);
> +	if (ret)
> +		return ret;
> +
> +	/* Architecture specific contiguous memory fixup. */
> +	dma_contiguous_early_fixup(base, size);
> +
> +	return 0;
> +}
> +
>  static void clear_cma_bitmap(struct cma *cma, unsigned long pfn, int count)
>  {
>  	mutex_lock(&cma->lock);
> @@ -316,20 +330,16 @@ static void clear_cma_bitmap(struct cma *cma, unsigned long pfn, int count)
>   * global one. Requires architecture specific dev_get_cma_area() helper
>   * function.
>   */
> -struct page *dma_alloc_from_contiguous(struct device *dev, int count,
> +static struct page *__dma_alloc_from_contiguous(struct cma *cma, int count,
>  				       unsigned int align)
>  {
>  	unsigned long mask, pfn, pageno, start = 0;
> -	struct cma *cma = dev_get_cma_area(dev);
>  	struct page *page = NULL;
>  	int ret;
>
>  	if (!cma || !cma->count)
>  		return NULL;
>
> -	if (align > CONFIG_CMA_ALIGNMENT)
> -		align = CONFIG_CMA_ALIGNMENT;
> -
>  	pr_debug("%s(cma %p, count %d, align %d)\n", __func__, (void *)cma,
>  		 count, align);
>
> @@ -377,6 +387,17 @@ struct page *dma_alloc_from_contiguous(struct device *dev, int count,
>  	return page;
>  }
>
> +struct page *dma_alloc_from_contiguous(struct device *dev, int count,
> +				       unsigned int align)
> +{
> +	struct cma *cma = dev_get_cma_area(dev);
> +
> +	if (align > CONFIG_CMA_ALIGNMENT)
> +		align = CONFIG_CMA_ALIGNMENT;
> +
> +	return __dma_alloc_from_contiguous(cma, count, align);
> +}
> +
>  /**
>   * dma_release_from_contiguous() - release allocated pages
>   * @dev:   Pointer to device for which the pages were allocated.
> @@ -387,10 +408,9 @@ struct page *dma_alloc_from_contiguous(struct device *dev, int count,
>   * It returns false when provided pages do not belong to contiguous area and
>   * true otherwise.
>   */
> -bool dma_release_from_contiguous(struct device *dev, struct page *pages,
> +static bool __dma_release_from_contiguous(struct cma *cma, struct page *pages,
>  				 int count)
>  {
> -	struct cma *cma = dev_get_cma_area(dev);
>  	unsigned long pfn;
>
>  	if (!cma || !pages)
> @@ -410,3 +430,11 @@ bool dma_release_from_contiguous(struct device *dev, struct page *pages,
>
>  	return true;
>  }
> +
> +bool dma_release_from_contiguous(struct device *dev, struct page *pages,
> +				 int count)
> +{
> +	struct cma *cma = dev_get_cma_area(dev);
> +
> +	return __dma_release_from_contiguous(cma, pages, count);
> +}
> -- 
> 1.7.9.5

