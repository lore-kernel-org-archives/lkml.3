Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753166AbaHIASO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 20:18:14 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:53728 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752989AbaHIASL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 20:18:11 -0400
Message-ID: <53E56311.5010302@codeaurora.org>
Date: Fri, 08 Aug 2014 16:53:53 -0700
From: Laura Abbott <lauraa@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Marek Szyprowski <m.szyprowski@samsung.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linaro-mm-sig@lists.linaro.org, devicetree@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Michal Nazarewicz <mina86@mina86.com>,
        Grant Likely <grant.likely@linaro.org>,
        Tomasz Figa <t.figa@samsung.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Nishanth Peethambaran <nishanth.p@gmail.com>,
        Marc <marc.ceeeee@gmail.com>, Josh Cartwright <joshc@codeaurora.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Paul Mackerras <paulus@samba.org>,
        Jon Medhurst <tixy@linaro.org>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        "Aneesh Kumar K.V." <aneesh.kumar@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2 4/4] drivers: dma-contiguous: add initialization from
 device tree
References: <1405321966-28184-1-git-send-email-m.szyprowski@samsung.com> <1405321966-28184-5-git-send-email-m.szyprowski@samsung.com>
In-Reply-To: <1405321966-28184-5-git-send-email-m.szyprowski@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/14/2014 12:12 AM, Marek Szyprowski wrote:
> Add a function to create CMA region from previously reserved memory
> and add support for handling 'shared-dma-pool' reserved-memory device
> tree nodes.
> 
> Based on previous code provided by Josh Cartwright <joshc@codeaurora.org>
> 
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> ---
>  drivers/base/dma-contiguous.c | 60 +++++++++++++++++++++++++++++++++++++++++
>  include/linux/cma.h           |  3 +++
>  mm/cma.c                      | 62 +++++++++++++++++++++++++++++++++++--------
>  3 files changed, 114 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/base/dma-contiguous.c b/drivers/base/dma-contiguous.c
> index 6606abdf880c..0e480146fe05 100644
> --- a/drivers/base/dma-contiguous.c
> +++ b/drivers/base/dma-contiguous.c
> @@ -211,3 +211,63 @@ bool dma_release_from_contiguous(struct device *dev, struct page *pages,
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
> +static const struct reserved_mem_ops rmem_cma_ops = {
> +	.device_init	= rmem_cma_device_init,
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


Rejecting the base/size right out if the alignment isn't correct is difficult
to work with. There's no guarantee that a dynamically placed region will end
up with the correct alignment or that the size was specified properly. This
means the best option is manually rounding up the sizes and specifying the
alignment in devicetree. But the alignment will also change if you boot
with or without CONFIG_ARM64_64K_PAGES for example so there is no way to
guarantee what is specified in devicetree will work. Perhaps this is a
limitation of how the devicetree is setup but it seems like a big pain to get
correct and prone to breakage if the kernel changes.

Thanks,
Laura

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
