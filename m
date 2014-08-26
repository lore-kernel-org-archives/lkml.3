Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934781AbaHZKFw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 06:05:52 -0400
Received: from mail-oa0-f52.google.com ([209.85.219.52]:63719 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934765AbaHZKFs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 06:05:48 -0400
MIME-Version: 1.0
X-Originating-IP: [217.156.156.35]
In-Reply-To: <1407800431-21566-4-git-send-email-lauraa@codeaurora.org>
References: <1407800431-21566-1-git-send-email-lauraa@codeaurora.org>
	<1407800431-21566-4-git-send-email-lauraa@codeaurora.org>
Date: Tue, 26 Aug 2014 11:05:47 +0100
X-Google-Sender-Auth: xNmh30-MxC0wun0jmm3SpN_uCng
Message-ID: <CAAG0J99=wrz4+c49HeDvL0W9rDZKk2HNLdVtHv4ZJxU4-OjewA@mail.gmail.com>
Subject: Re: [PATCHv7 3/5] common: dma-mapping: Introduce common remapping functions
From: James Hogan <james.hogan@imgtec.com>
To: Laura Abbott <lauraa@codeaurora.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Will Deacon <will.deacon@arm.com>, Russell King <linux@arm.linux.org.uk>,
        David Riley <davidriley@chromium.org>,
        ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Ritesh Harjain <ritesh.harjani@gmail.com>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-next@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 August 2014 00:40, Laura Abbott <lauraa@codeaurora.org> wrote:
>
> For architectures without coherent DMA, memory for DMA may
> need to be remapped with coherent attributes. Factor out
> the the remapping code from arm and put it in a
> common location to reduce code duplication.
>
> As part of this, the arm APIs are now migrated away from
> ioremap_page_range to the common APIs which use map_vm_area for remapping.
> This should be an equivalent change and using map_vm_area is more
> correct as ioremap_page_range is intended to bring in io addresses
> into the cpu space and not regular kernel managed memory.
>
> Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
> Signed-off-by: Laura Abbott <lauraa@codeaurora.org>

This commit in linux-next () breaks the build for metag:

drivers/base/dma-mapping.c: In function ‘dma_common_contiguous_remap’:
drivers/base/dma-mapping.c:294: error: implicit declaration of
function ‘dma_common_pages_remap’
drivers/base/dma-mapping.c:294: warning: assignment makes pointer from
integer without a cast
drivers/base/dma-mapping.c: At top level:
drivers/base/dma-mapping.c:308: error: conflicting types for
‘dma_common_pages_remap’
drivers/base/dma-mapping.c:294: error: previous implicit declaration
of ‘dma_common_pages_remap’ was here

Looks like metag isn't alone either:

$ git grep -L dma-mapping-common arch/*/include/asm/dma-mapping.h
arch/arc/include/asm/dma-mapping.h
arch/avr32/include/asm/dma-mapping.h
arch/blackfin/include/asm/dma-mapping.h
arch/c6x/include/asm/dma-mapping.h
arch/cris/include/asm/dma-mapping.h
arch/frv/include/asm/dma-mapping.h
arch/m68k/include/asm/dma-mapping.h
arch/metag/include/asm/dma-mapping.h
arch/mn10300/include/asm/dma-mapping.h
arch/parisc/include/asm/dma-mapping.h
arch/xtensa/include/asm/dma-mapping.h

I've checked a couple of these arches (blackfin, xtensa) which don't
include dma-mapping-common.h and their builds seem to be broken too.

Cheers
James

> ---
>  arch/arm/mm/dma-mapping.c                | 57 +++++---------------------
>  drivers/base/dma-mapping.c               | 68 ++++++++++++++++++++++++++++++++
>  include/asm-generic/dma-mapping-common.h |  9 +++++
>  3 files changed, 86 insertions(+), 48 deletions(-)
>
> diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
> index 4c88935..f5190ac 100644
> --- a/arch/arm/mm/dma-mapping.c
> +++ b/arch/arm/mm/dma-mapping.c
> @@ -297,37 +297,19 @@ static void *
>  __dma_alloc_remap(struct page *page, size_t size, gfp_t gfp, pgprot_t prot,
>         const void *caller)
>  {
> -       struct vm_struct *area;
> -       unsigned long addr;
> -
>         /*
>          * DMA allocation can be mapped to user space, so lets
>          * set VM_USERMAP flags too.
>          */
> -       area = get_vm_area_caller(size, VM_ARM_DMA_CONSISTENT | VM_USERMAP,
> -                                 caller);
> -       if (!area)
> -               return NULL;
> -       addr = (unsigned long)area->addr;
> -       area->phys_addr = __pfn_to_phys(page_to_pfn(page));
> -
> -       if (ioremap_page_range(addr, addr + size, area->phys_addr, prot)) {
> -               vunmap((void *)addr);
> -               return NULL;
> -       }
> -       return (void *)addr;
> +       return dma_common_contiguous_remap(page, size,
> +                       VM_ARM_DMA_CONSISTENT | VM_USERMAP,
> +                       prot, caller);
>  }
>
>  static void __dma_free_remap(void *cpu_addr, size_t size)
>  {
> -       unsigned int flags = VM_ARM_DMA_CONSISTENT | VM_USERMAP;
> -       struct vm_struct *area = find_vm_area(cpu_addr);
> -       if (!area || (area->flags & flags) != flags) {
> -               WARN(1, "trying to free invalid coherent area: %p\n", cpu_addr);
> -               return;
> -       }
> -       unmap_kernel_range((unsigned long)cpu_addr, size);
> -       vunmap(cpu_addr);
> +       dma_common_free_remap(cpu_addr, size,
> +                       VM_ARM_DMA_CONSISTENT | VM_USERMAP);
>  }
>
>  #define DEFAULT_DMA_COHERENT_POOL_SIZE SZ_256K
> @@ -1261,29 +1243,8 @@ static void *
>  __iommu_alloc_remap(struct page **pages, size_t size, gfp_t gfp, pgprot_t prot,
>                     const void *caller)
>  {
> -       unsigned int i, nr_pages = PAGE_ALIGN(size) >> PAGE_SHIFT;
> -       struct vm_struct *area;
> -       unsigned long p;
> -
> -       area = get_vm_area_caller(size, VM_ARM_DMA_CONSISTENT | VM_USERMAP,
> -                                 caller);
> -       if (!area)
> -               return NULL;
> -
> -       area->pages = pages;
> -       area->nr_pages = nr_pages;
> -       p = (unsigned long)area->addr;
> -
> -       for (i = 0; i < nr_pages; i++) {
> -               phys_addr_t phys = __pfn_to_phys(page_to_pfn(pages[i]));
> -               if (ioremap_page_range(p, p + PAGE_SIZE, phys, prot))
> -                       goto err;
> -               p += PAGE_SIZE;
> -       }
> -       return area->addr;
> -err:
> -       unmap_kernel_range((unsigned long)area->addr, size);
> -       vunmap(area->addr);
> +       return dma_common_pages_remap(pages, size,
> +                       VM_ARM_DMA_CONSISTENT | VM_USERMAP, prot, caller);
>         return NULL;
>  }
>
> @@ -1491,8 +1452,8 @@ void arm_iommu_free_attrs(struct device *dev, size_t size, void *cpu_addr,
>         }
>
>         if (!dma_get_attr(DMA_ATTR_NO_KERNEL_MAPPING, attrs)) {
> -               unmap_kernel_range((unsigned long)cpu_addr, size);
> -               vunmap(cpu_addr);
> +               dma_common_free_remap(cpu_addr, size,
> +                       VM_ARM_DMA_CONSISTENT | VM_USERMAP);
>         }
>
>         __iommu_remove_mapping(dev, handle, size);
> diff --git a/drivers/base/dma-mapping.c b/drivers/base/dma-mapping.c
> index 6cd08e1..1bc46df 100644
> --- a/drivers/base/dma-mapping.c
> +++ b/drivers/base/dma-mapping.c
> @@ -10,6 +10,8 @@
>  #include <linux/dma-mapping.h>
>  #include <linux/export.h>
>  #include <linux/gfp.h>
> +#include <linux/slab.h>
> +#include <linux/vmalloc.h>
>  #include <asm-generic/dma-coherent.h>
>
>  /*
> @@ -267,3 +269,69 @@ int dma_common_mmap(struct device *dev, struct vm_area_struct *vma,
>         return ret;
>  }
>  EXPORT_SYMBOL(dma_common_mmap);
> +
> +/*
> + * remaps an allocated contiguous region into another vm_area.
> + * Cannot be used in non-sleeping contexts
> + */
> +
> +void *dma_common_contiguous_remap(struct page *page, size_t size,
> +                       unsigned long vm_flags,
> +                       pgprot_t prot, const void *caller)
> +{
> +       int i;
> +       struct page **pages;
> +       void *ptr;
> +       unsigned long pfn;
> +
> +       pages = kmalloc(sizeof(struct page *) << get_order(size), GFP_KERNEL);
> +       if (!pages)
> +               return NULL;
> +
> +       for (i = 0, pfn = page_to_pfn(page); i < (size >> PAGE_SHIFT); i++)
> +               pages[i] = pfn_to_page(pfn + i);
> +
> +       ptr = dma_common_pages_remap(pages, size, vm_flags, prot, caller);
> +
> +       kfree(pages);
> +
> +       return ptr;
> +}
> +
> +/*
> + * remaps an array of PAGE_SIZE pages into another vm_area
> + * Cannot be used in non-sleeping contexts
> + */
> +void *dma_common_pages_remap(struct page **pages, size_t size,
> +                       unsigned long vm_flags, pgprot_t prot,
> +                       const void *caller)
> +{
> +       struct vm_struct *area;
> +
> +       area = get_vm_area_caller(size, vm_flags, caller);
> +       if (!area)
> +               return NULL;
> +
> +       if (map_vm_area(area, prot, pages)) {
> +               vunmap(area->addr);
> +               return NULL;
> +       }
> +
> +       return area->addr;
> +}
> +
> +/*
> + * unmaps a range previously mapped by dma_common_*_remap
> + */
> +void dma_common_free_remap(void *cpu_addr, size_t size, unsigned long vm_flags)
> +{
> +       struct vm_struct *area = find_vm_area(cpu_addr);
> +
> +       if (!area || (area->flags & vm_flags) != vm_flags) {
> +               WARN(1, "trying to free invalid coherent area: %p\n", cpu_addr);
> +               return;
> +       }
> +
> +       unmap_kernel_range((unsigned long)cpu_addr, size);
> +       vunmap(cpu_addr);
> +}
> diff --git a/include/asm-generic/dma-mapping-common.h b/include/asm-generic/dma-mapping-common.h
> index de8bf89..a9fd248 100644
> --- a/include/asm-generic/dma-mapping-common.h
> +++ b/include/asm-generic/dma-mapping-common.h
> @@ -179,6 +179,15 @@ dma_sync_sg_for_device(struct device *dev, struct scatterlist *sg,
>  extern int dma_common_mmap(struct device *dev, struct vm_area_struct *vma,
>                            void *cpu_addr, dma_addr_t dma_addr, size_t size);
>
> +void *dma_common_contiguous_remap(struct page *page, size_t size,
> +                       unsigned long vm_flags,
> +                       pgprot_t prot, const void *caller);
> +
> +void *dma_common_pages_remap(struct page **pages, size_t size,
> +                       unsigned long vm_flags, pgprot_t prot,
> +                       const void *caller);
> +void dma_common_free_remap(void *cpu_addr, size_t size, unsigned long vm_flags);
> +
>  /**
>   * dma_mmap_attrs - map a coherent DMA allocation into user space
>   * @dev: valid struct device pointer, or NULL for ISA and EISA-like devices
> --
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> hosted by The Linux Foundation
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
