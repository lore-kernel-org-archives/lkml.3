Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754563AbaG2XjQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 19:39:16 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:36957 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754433AbaG2XjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 19:39:13 -0400
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH v2 RESEND 4/4] drivers: dma-contiguous: add
 initialization from device tree
To: Marek Szyprowski <m.szyprowski@samsung.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        linaro-mm-sig@lists.linaro.org, devicetree@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Michal Nazarewicz <mina86@mina86.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Laura Abbott <lauraa@codeaurora.org>,
        Nishanth Peethambaran <nishanth.p@gmail.com>,
        Marc <marc.ceeeee@gmail.com>, Josh Cartwright <joshc@codeaurora.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Paul Mackerras <paulus@samba.org>,
        Jon Medhurst <tixy@linaro.org>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        "Aneesh Kumar K.V." <aneesh.kumar@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1405326487-15346-5-git-send-email-m.szyprowski@samsung.com>
References: <1405326487-15346-1-git-send-email-m.szyprowski@samsung.com>
	<1405326487-15346-5-git-send-email-m.szyprowski@samsung.com>
Date: Tue, 29 Jul 2014 15:58:11 -0600
Message-Id: <20140729215811.BEB7BC408F6@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Jul 2014 10:28:07 +0200, Marek Szyprowski <m.szyprowski@samsung.com> wrote:
> Add a function to create CMA region from previously reserved memory
> and add support for handling 'shared-dma-pool' reserved-memory device
> tree nodes.
> 
> Based on previous code provided by Josh Cartwright <joshc@codeaurora.org>

I think this is okay too. Same questions apply as I sent on patch 3.

g.

> 
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> ---
>  drivers/base/dma-contiguous.c | 67 +++++++++++++++++++++++++++++++++++++++++++
>  include/linux/cma.h           |  3 ++
>  mm/cma.c                      | 62 ++++++++++++++++++++++++++++++++-------
>  3 files changed, 121 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/base/dma-contiguous.c b/drivers/base/dma-contiguous.c
> index 6606abdf880c..b77ea8bac176 100644
> --- a/drivers/base/dma-contiguous.c
> +++ b/drivers/base/dma-contiguous.c
> @@ -211,3 +211,70 @@ bool dma_release_from_contiguous(struct device *dev, struct page *pages,
>  {
>  	return cma_release(dev_get_cma_area(dev), pages, count);
>  }
> +
> +/*
> + * Support for reserved memory regions defined in device tree
> + */
> +#ifdef CONFIG_OF_RESERVED_MEM
> +#include <linux/of.h>
> +#include <linux/of_fdt.h>
> +#include <linux/of_reserved_mem.h>
> +
> +#undef pr_fmt
> +#define pr_fmt(fmt) fmt
> +
> +static void rmem_cma_device_init(struct reserved_mem *rmem, struct device *dev)
> +{
> +	struct cma *cma = rmem->priv;
> +	dev_set_cma_area(dev, cma);
> +}
> +
> +static void rmem_cma_device_release(struct reserved_mem *rmem,
> +				    struct device *dev)
> +{
> +	dev_set_cma_area(dev, NULL);
> +}
> +
> +static const struct reserved_mem_ops rmem_cma_ops = {
> +	.device_init	= rmem_cma_device_init,
> +	.device_release = rmem_cma_device_release,
> +};
> +
> +static int __init rmem_cma_setup(struct reserved_mem *rmem)
> +{
> +	phys_addr_t align = PAGE_SIZE << max(MAX_ORDER - 1, pageblock_order);
> +	phys_addr_t mask = align - 1;
> +	unsigned long node = rmem->fdt_node;
> +	struct cma *cma;
> +	int err;
> +
> +	if (!of_get_flat_dt_prop(node, "reusable", NULL) ||
> +	    of_get_flat_dt_prop(node, "no-map", NULL))
> +		return -EINVAL;
> +
> +	if ((rmem->base & mask) || (rmem->size & mask)) {
> +		pr_err("Reserved memory: incorrect alignment of CMA region\n");
> +		return -EINVAL;
> +	}
> +
> +	err = cma_init_reserved_mem(rmem->base, rmem->size, 0, &cma);
> +	if (err) {
> +		pr_err("Reserved memory: unable to setup CMA region\n");
> +		return err;
> +	}
> +	/* Architecture specific contiguous memory fixup. */
> +	dma_contiguous_early_fixup(rmem->base, rmem->size);
> +
> +	if (of_get_flat_dt_prop(node, "linux,cma-default", NULL))
> +		dma_contiguous_set_default(cma);
> +
> +	rmem->ops = &rmem_cma_ops;
> +	rmem->priv = cma;
> +
> +	pr_info("Reserved memory: created CMA memory pool at %pa, size %ld MiB\n",
> +		&rmem->base, (unsigned long)rmem->size / SZ_1M);
> +
> +	return 0;
> +}
> +RESERVEDMEM_OF_DECLARE(cma, "shared-dma-pool", rmem_cma_setup);
> +#endif
> diff --git a/include/linux/cma.h b/include/linux/cma.h
> index 32cab7a425f9..9a18a2b1934c 100644
> --- a/include/linux/cma.h
> +++ b/include/linux/cma.h
> @@ -16,6 +16,9 @@ extern int __init cma_declare_contiguous(phys_addr_t size,
>  			phys_addr_t base, phys_addr_t limit,
>  			phys_addr_t alignment, unsigned int order_per_bit,
>  			bool fixed, struct cma **res_cma);
> +extern int cma_init_reserved_mem(phys_addr_t size,
> +					phys_addr_t base, int order_per_bit,
> +					struct cma **res_cma);
>  extern struct page *cma_alloc(struct cma *cma, int count, unsigned int align);
>  extern bool cma_release(struct cma *cma, struct page *pages, int count);
>  #endif
> diff --git a/mm/cma.c b/mm/cma.c
> index 4b251b037e1b..b3d8b925ad34 100644
> --- a/mm/cma.c
> +++ b/mm/cma.c
> @@ -140,6 +140,54 @@ static int __init cma_init_reserved_areas(void)
>  core_initcall(cma_init_reserved_areas);
>  
>  /**
> + * cma_init_reserved_mem() - create custom contiguous area from reserved memory
> + * @base: Base address of the reserved area
> + * @size: Size of the reserved area (in bytes),
> + * @order_per_bit: Order of pages represented by one bit on bitmap.
> + * @res_cma: Pointer to store the created cma region.
> + *
> + * This function creates custom contiguous area from already reserved memory.
> + */
> +int __init cma_init_reserved_mem(phys_addr_t base, phys_addr_t size,
> +				 int order_per_bit, struct cma **res_cma)
> +{
> +	struct cma *cma;
> +	phys_addr_t alignment;
> +
> +	/* Sanity checks */
> +	if (cma_area_count == ARRAY_SIZE(cma_areas)) {
> +		pr_err("Not enough slots for CMA reserved regions!\n");
> +		return -ENOSPC;
> +	}
> +
> +	if (!size || !memblock_is_region_reserved(base, size))
> +		return -EINVAL;
> +
> +	/* ensure minimal alignment requied by mm core */
> +	alignment = PAGE_SIZE << max(MAX_ORDER - 1, pageblock_order);
> +
> +	/* alignment should be aligned with order_per_bit */
> +	if (!IS_ALIGNED(alignment >> PAGE_SHIFT, 1 << order_per_bit))
> +		return -EINVAL;
> +
> +	if (ALIGN(base, alignment) != base || ALIGN(size, alignment) != size)
> +		return -EINVAL;
> +
> +	/*
> +	 * Each reserved area must be initialised later, when more kernel
> +	 * subsystems (like slab allocator) are available.
> +	 */
> +	cma = &cma_areas[cma_area_count];
> +	cma->base_pfn = PFN_DOWN(base);
> +	cma->count = size >> PAGE_SHIFT;
> +	cma->order_per_bit = order_per_bit;
> +	*res_cma = cma;
> +	cma_area_count++;
> +
> +	return 0;
> +}
> +
> +/**
>   * cma_declare_contiguous() - reserve custom contiguous area
>   * @base: Base address of the reserved area optional, use 0 for any
>   * @size: Size of the reserved area (in bytes),
> @@ -162,7 +210,6 @@ int __init cma_declare_contiguous(phys_addr_t base,
>  			phys_addr_t alignment, unsigned int order_per_bit,
>  			bool fixed, struct cma **res_cma)
>  {
> -	struct cma *cma;
>  	int ret = 0;
>  
>  	pr_debug("%s(size %lx, base %08lx, limit %08lx alignment %08lx)\n",
> @@ -214,16 +261,9 @@ int __init cma_declare_contiguous(phys_addr_t base,
>  		}
>  	}
>  
> -	/*
> -	 * Each reserved area must be initialised later, when more kernel
> -	 * subsystems (like slab allocator) are available.
> -	 */
> -	cma = &cma_areas[cma_area_count];
> -	cma->base_pfn = PFN_DOWN(base);
> -	cma->count = size >> PAGE_SHIFT;
> -	cma->order_per_bit = order_per_bit;
> -	*res_cma = cma;
> -	cma_area_count++;
> +	ret = cma_init_reserved_mem(base, size, order_per_bit, res_cma);
> +	if (ret)
> +		goto err;
>  
>  	pr_info("Reserved %ld MiB at %08lx\n", (unsigned long)size / SZ_1M,
>  		(unsigned long)base);
> -- 
> 1.9.2
> 

