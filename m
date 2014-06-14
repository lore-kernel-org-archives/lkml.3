Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754646AbaFNKGD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 06:06:03 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:46216 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754602AbaFNKF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 06:05:58 -0400
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
Subject: Re: [PATCH v2 07/10] PPC, KVM, CMA: use general CMA reserved area management framework
In-Reply-To: <1402543307-29800-8-git-send-email-iamjoonsoo.kim@lge.com>
References: <1402543307-29800-1-git-send-email-iamjoonsoo.kim@lge.com> <1402543307-29800-8-git-send-email-iamjoonsoo.kim@lge.com>
User-Agent: Notmuch/0.18~rc0+2~gbc64cdc (http://notmuchmail.org) Emacs/24.3.91.1 (x86_64-unknown-linux-gnu)
Date: Sat, 14 Jun 2014 15:35:33 +0530
Message-ID: <87k38jg61e.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14061410-1618-0000-0000-0000006699BA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joonsoo Kim <iamjoonsoo.kim@lge.com> writes:

> Now, we have general CMA reserved area management framework,
> so use it for future maintainabilty. There is no functional change.
>
> Acked-by: Michal Nazarewicz <mina86@mina86.com>
> Acked-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
>
> diff --git a/arch/powerpc/kvm/book3s_hv_builtin.c b/arch/powerpc/kvm/book3s_hv_builtin.c
> index 7cde8a6..28ec226 100644
> --- a/arch/powerpc/kvm/book3s_hv_builtin.c
> +++ b/arch/powerpc/kvm/book3s_hv_builtin.c
> @@ -16,12 +16,14 @@
>  #include <linux/init.h>
>  #include <linux/memblock.h>
>  #include <linux/sizes.h>
> +#include <linux/cma.h>
>
>  #include <asm/cputable.h>
>  #include <asm/kvm_ppc.h>
>  #include <asm/kvm_book3s.h>
>
> -#include "book3s_hv_cma.h"
> +#define KVM_CMA_CHUNK_ORDER	18
> +
>  /*
>   * Hash page table alignment on newer cpus(CPU_FTR_ARCH_206)
>   * should be power of 2.
> @@ -43,6 +45,8 @@ static unsigned long kvm_cma_resv_ratio = 5;
>  unsigned long kvm_rma_pages = (1 << 27) >> PAGE_SHIFT;	/* 128MB */
>  EXPORT_SYMBOL_GPL(kvm_rma_pages);
>
> +static struct cma *kvm_cma;
> +
>  /* Work out RMLS (real mode limit selector) field value for a given RMA size.
>     Assumes POWER7 or PPC970. */
>  static inline int lpcr_rmls(unsigned long rma_size)
> @@ -97,7 +101,7 @@ struct kvm_rma_info *kvm_alloc_rma()
>  	ri = kmalloc(sizeof(struct kvm_rma_info), GFP_KERNEL);
>  	if (!ri)
>  		return NULL;
> -	page = kvm_alloc_cma(kvm_rma_pages, kvm_rma_pages);
> +	page = cma_alloc(kvm_cma, kvm_rma_pages, get_order(kvm_rma_pages));
>  	if (!page)
>  		goto err_out;
>  	atomic_set(&ri->use_count, 1);
> @@ -112,7 +116,7 @@ EXPORT_SYMBOL_GPL(kvm_alloc_rma);
>  void kvm_release_rma(struct kvm_rma_info *ri)
>  {
>  	if (atomic_dec_and_test(&ri->use_count)) {
> -		kvm_release_cma(pfn_to_page(ri->base_pfn), kvm_rma_pages);
> +		cma_release(kvm_cma, pfn_to_page(ri->base_pfn), kvm_rma_pages);
>  		kfree(ri);
>  	}
>  }
> @@ -134,13 +138,13 @@ struct page *kvm_alloc_hpt(unsigned long nr_pages)
>  	/* Old CPUs require HPT aligned on a multiple of its size */
>  	if (!cpu_has_feature(CPU_FTR_ARCH_206))
>  		align_pages = nr_pages;
> -	return kvm_alloc_cma(nr_pages, align_pages);
> +	return cma_alloc(kvm_cma, nr_pages, get_order(align_pages));
>  }
>  EXPORT_SYMBOL_GPL(kvm_alloc_hpt);
>
>  void kvm_release_hpt(struct page *page, unsigned long nr_pages)
>  {
> -	kvm_release_cma(page, nr_pages);
> +	cma_release(kvm_cma, page, nr_pages);
>  }
>  EXPORT_SYMBOL_GPL(kvm_release_hpt);
>
> @@ -179,7 +183,8 @@ void __init kvm_cma_reserve(void)
>  			align_size = HPT_ALIGN_PAGES << PAGE_SHIFT;
>
>  		align_size = max(kvm_rma_pages << PAGE_SHIFT, align_size);
> -		kvm_cma_declare_contiguous(selected_size, align_size);
> +		cma_declare_contiguous(selected_size, 0, 0, align_size,
> +			KVM_CMA_CHUNK_ORDER - PAGE_SHIFT, &kvm_cma, false);
>  	}
>  }
>
> diff --git a/arch/powerpc/kvm/book3s_hv_cma.c b/arch/powerpc/kvm/book3s_hv_cma.c
> deleted file mode 100644
> index d9d3d85..0000000
> --- a/arch/powerpc/kvm/book3s_hv_cma.c
> +++ /dev/null
> @@ -1,240 +0,0 @@
> -/*
> - * Contiguous Memory Allocator for ppc KVM hash pagetable  based on CMA
> - * for DMA mapping framework
> - *
> - * Copyright IBM Corporation, 2013
> - * Author Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation; either version 2 of the
> - * License or (at your optional) any later version of the license.
> - *
> - */
> -#define pr_fmt(fmt) "kvm_cma: " fmt
> -
> -#ifdef CONFIG_CMA_DEBUG
> -#ifndef DEBUG
> -#  define DEBUG
> -#endif
> -#endif
> -
> -#include <linux/memblock.h>
> -#include <linux/mutex.h>
> -#include <linux/sizes.h>
> -#include <linux/slab.h>
> -
> -#include "book3s_hv_cma.h"
> -
> -struct kvm_cma {
> -	unsigned long	base_pfn;
> -	unsigned long	count;
> -	unsigned long	*bitmap;
> -};
> -
> -static DEFINE_MUTEX(kvm_cma_mutex);
> -static struct kvm_cma kvm_cma_area;
> -
> -/**
> - * kvm_cma_declare_contiguous() - reserve area for contiguous memory handling
> - *			          for kvm hash pagetable
> - * @size:  Size of the reserved memory.
> - * @alignment:  Alignment for the contiguous memory area
> - *
> - * This function reserves memory for kvm cma area. It should be
> - * called by arch code when early allocator (memblock or bootmem)
> - * is still activate.
> - */
> -long __init kvm_cma_declare_contiguous(phys_addr_t size, phys_addr_t alignment)
> -{
> -	long base_pfn;
> -	phys_addr_t addr;
> -	struct kvm_cma *cma = &kvm_cma_area;
> -
> -	pr_debug("%s(size %lx)\n", __func__, (unsigned long)size);
> -
> -	if (!size)
> -		return -EINVAL;
> -	/*
> -	 * Sanitise input arguments.
> -	 * We should be pageblock aligned for CMA.
> -	 */
> -	alignment = max(alignment, (phys_addr_t)(PAGE_SIZE << pageblock_order));
> -	size = ALIGN(size, alignment);
> -	/*
> -	 * Reserve memory
> -	 * Use __memblock_alloc_base() since
> -	 * memblock_alloc_base() panic()s.
> -	 */
> -	addr = __memblock_alloc_base(size, alignment, 0);
> -	if (!addr) {
> -		base_pfn = -ENOMEM;
> -		goto err;
> -	} else
> -		base_pfn = PFN_DOWN(addr);
> -
> -	/*
> -	 * Each reserved area must be initialised later, when more kernel
> -	 * subsystems (like slab allocator) are available.
> -	 */
> -	cma->base_pfn = base_pfn;
> -	cma->count    = size >> PAGE_SHIFT;
> -	pr_info("CMA: reserved %ld MiB\n", (unsigned long)size / SZ_1M);
> -	return 0;
> -err:
> -	pr_err("CMA: failed to reserve %ld MiB\n", (unsigned long)size / SZ_1M);
> -	return base_pfn;
> -}
> -
> -/**
> - * kvm_alloc_cma() - allocate pages from contiguous area
> - * @nr_pages: Requested number of pages.
> - * @align_pages: Requested alignment in number of pages
> - *
> - * This function allocates memory buffer for hash pagetable.
> - */
> -struct page *kvm_alloc_cma(unsigned long nr_pages, unsigned long align_pages)
> -{
> -	int ret;
> -	struct page *page = NULL;
> -	struct kvm_cma *cma = &kvm_cma_area;
> -	unsigned long chunk_count, nr_chunk;
> -	unsigned long mask, pfn, pageno, start = 0;
> -
> -
> -	if (!cma || !cma->count)
> -		return NULL;
> -
> -	pr_debug("%s(cma %p, count %lu, align pages %lu)\n", __func__,
> -		 (void *)cma, nr_pages, align_pages);
> -
> -	if (!nr_pages)
> -		return NULL;
> -	/*
> -	 * align mask with chunk size. The bit tracks pages in chunk size
> -	 */
> -	VM_BUG_ON(!is_power_of_2(align_pages));
> -	mask = (align_pages >> (KVM_CMA_CHUNK_ORDER - PAGE_SHIFT)) - 1;
> -	BUILD_BUG_ON(PAGE_SHIFT > KVM_CMA_CHUNK_ORDER);
> -
> -	chunk_count = cma->count >>  (KVM_CMA_CHUNK_ORDER - PAGE_SHIFT);
> -	nr_chunk = nr_pages >> (KVM_CMA_CHUNK_ORDER - PAGE_SHIFT);
> -
> -	mutex_lock(&kvm_cma_mutex);
> -	for (;;) {
> -		pageno = bitmap_find_next_zero_area(cma->bitmap, chunk_count,
> -						    start, nr_chunk, mask);
> -		if (pageno >= chunk_count)
> -			break;
> -
> -		pfn = cma->base_pfn + (pageno << (KVM_CMA_CHUNK_ORDER - PAGE_SHIFT));
> -		ret = alloc_contig_range(pfn, pfn + nr_pages, MIGRATE_CMA);
> -		if (ret == 0) {
> -			bitmap_set(cma->bitmap, pageno, nr_chunk);
> -			page = pfn_to_page(pfn);
> -			memset(pfn_to_kaddr(pfn), 0, nr_pages <<
> PAGE_SHIFT);


The above memset is missing in the generic code. May be

diff --git a/arch/powerpc/kvm/book3s_64_mmu_hv.c b/arch/powerpc/kvm/book3s_64_mmu_hv.c
index 6f13ee6..8740b4c 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_hv.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_hv.c
@@ -75,6 +75,7 @@ long kvmppc_alloc_hpt(struct kvm *kvm, u32 *htab_orderp)
                page = kvm_alloc_hpt(1 << (order - PAGE_SHIFT));
                if (page) {
                        hpt = (unsigned long)pfn_to_kaddr(page_to_pfn(page));
+                       memset((void *)hpt, 0, (1 << order));
                        kvm->arch.hpt_cma_alloc = 1;
                } else
                        --order;



With that

Tested-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

-aneesh

