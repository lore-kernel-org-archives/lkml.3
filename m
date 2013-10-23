Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751983Ab3JWOQk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 10:16:40 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:16727 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936Ab3JWOQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 10:16:39 -0400
Date: Wed, 23 Oct 2013 10:15:08 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Ian Campbell <Ian.Campbell@citrix.com>
Subject: Re: [PATCH v8 0/19] enable swiotlb-xen on arm and arm64
Message-ID: <20131023141508.GE27771@phenom.dumpdata.com>
References: <alpine.DEB.2.02.1310171833520.26077@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1310171833520.26077@kaball.uk.xensource.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 17, 2013 at 06:42:18PM +0100, Stefano Stabellini wrote:
> Hi all,
> this patch series enables xen-swiotlb on arm and arm64.
> 
> It has been heavily reworked compared to the previous versions in order
> to achieve better performances and to address review comments.
> 
> We are not using dma_mark_clean to ensure coherency anymore. We call the
> platform implementation of map_page and unmap_page.
> 
> We assume that dom0 has been mapped 1:1 (physical address ==
> machine address), that is what Xen on ARM currently does.
> As a consequence we only use the swiotlb to handle dma
> requests involving pages corresponding to grant refs. Obviously these
> pages cannot be part of the 1:1 because they belong to another domain.
> 
> To improve code readability this version of the series introduces a
> "p2m" for arm and arm64, implemented using two red-black trees.  The p2m
> tracks physical to machine and machine to physical mappings. Given that
> we assume a 1:1 mapping in dom0, the only entries in both trees are
> grant refs that have been mapped in dom0.
> 
> Another consequence of the new approach is that the hypercalls we were
> previously introducing (XENMEM_exchange_and_pin, XENMEM_pin,
> XENMEM_unpin) are not needed anymore.
> This latest version doesn't need any hypervisor changes anymore.

>From the Xen and SWIOTLB I am ok with the patch series, except
for these two patches:

swiotlb-xen: no need to do execute two bus_to_phys translations in a  ..
swiotlb-xen: use xen_dma_map/unmap_page, xen_dma_sync_single_for_cpu/device

which I think need a bit more of explanation. In worst case they can be

#ifdef CONFIG_ARM 
..
#endif

albeit that will need to be fixed in the future to remove the #ifdef I think.

> 
> Cheers,
> 
> Stefano
> 
> 
> Changes in v8:
> - use __phys_to_pfn and __pfn_to_phys in phys_to_dma and dma_to_phys;
> - cast 0 to dma_addr_t in the definition of DMA_ERROR_CODE;
> - move pfn_to_mfn and mfn_to_pfn to page.h as static inline functions;
> - no need to walk the two p2m trees if phys_to_mach.rb_node is NULL;
> - correctly handle multipage p2m entries;
> - substitute the p2m spin_lock with a rwlock;
> - assume dom0 is mapped 1:1, no need to call XENMEM_exchange in
> xen_create_contiguous_region;
> - add two simple performance improvements for swiotlb-xen.
> 
> Changes in v7:
> - dma_mark_clean: switch to an empty implementation (we are going to use
>   the platform map_page and unmap_page to ensure coherency);
> - dma_capable: use coherent_dma_mask if dma_mask hasn't been
>   allocated;
> - introduce a p2m for xen on arm and arm64;
> - call __set_phys_to_machine_multi from xen_create_contiguous_region to
>   update the p2m;
> - remove XENMEM_unpin and XENMEM_exchange_and_pin;
> - set nr_exchanged to 0 before calling the hypercall;
> - return xen_dma_ops only if we are the initial domain;
> - rename __get_dma_ops to __generic_dma_ops;
> - call __generic_dma_ops(hwdev)->alloc/free on arm64 too;
> - introduce xen_dma_map/unmap_page and xen_dma_sync_single_for_cpu/device;
> - use xen_dma_map/unmap_page, xen_dma_sync_single_for_cpu/device in
>   swiotlb-xen;
> - use dev_warn instead of pr_warn;
> - remove the extra autotranslate check in biomerge.c;
> - call set_phys_to_machine after mapping grant refs in gnttab_map_refs;
> - call set_phys_to_machine after unmapping grant refs in gnttab_unmap_refs;
> - allow __set_phys_to_machine to be called for autotranslate guests on
>   x86.
> 
> Changes in v6:
> - check for dev->dma_mask being NULL in dma_capable;
> - update the comments and the hypercalls structures;
> - add a xen_dma_info entry to the rbtree in xen_swiotlb_alloc_coherent
> to keep track of the new mapping. Free the entry in xen_swiotlb_free_coherent;
> - rename xen_dma_seg to dma_info in xen_swiotlb_alloc/free_coherent to
> avoid confusions;
> - introduce and export xen_dma_ops;
> - call xen_mm_init from as arch_initcall;
> - call __get_dma_ops to get the native dma_ops pointer on arm;
> - do not merge biovecs;
> - add single page optimization: pin the page rather than bouncing.
> 
> Changes in v5:
> - dropped the first two patches, already in the Xen tree;
> - implement dma_mark_clean using dmac_flush_range on arm;
> - add "arm64: define DMA_ERROR_CODE"
> - better comment for XENMEM_exchange_and_pin return codes;
> - fix xen_dma_add_entry error path;
> - remove the spin_lock: the red-black tree is not modified at run time;
> - add "swiotlb-xen: introduce xen_swiotlb_set_dma_mask";
> - add "xen: introduce xen_alloc/free_coherent_pages";
> - add "swiotlb-xen: use xen_alloc/free_coherent_pages";
> - add "swiotlb: don't assume that io_tlb_start-io_tlb_end is coherent".
> 
> Changes in v4:
> - rename XENMEM_get_dma_buf to XENMEM_exchange_and_pin;
> - rename XENMEM_put_dma_buf to XENMEM_unpin;
> - improve the documentation of the new hypercalls;
> - add a note about out.address_bits for XENMEM_exchange;
> - code style fixes;
> - add err_out label in xen_dma_add_entry;
> - remove INVALID_ADDRESS, use DMA_ERROR_CODE instead;
> - add in-code comments regarding the usage of xen_dma_seg[0].dma_addr.
> 
> Changes in v3:
> - add a patch to compile SWIOTLB without CONFIG_NEED_SG_DMA_LENGTH;
> - add a patch to compile SWIOTLB_XEN without CONFIG_NEED_SG_DMA_LENGTH;
> - arm/dma_capable: do not treat dma_mask as a limit;
> - arm/dmabounce: keep using arm_dma_ops;
> - add missing __init in xen_early_init declaration;
> - many code style and name changes in swiotlb-xen.c;
> - improve error checks in xen_dma_add_entry;
> - warn on XENMEM_put_dma_buf failures.
> 
> Changes in v2:
> - fixed a couple of errors in xen_bus_to_phys, xen_phys_to_bus and
> xen_swiotlb_fixup.
> 
> 
> 
> 
> Julien Grall (1):
>       ASoC: Samsung: Rename dma_ops by samsung_dma_ops
> 
> Stefano Stabellini (18):
>       arm: make SWIOTLB available
>       arm64: define DMA_ERROR_CODE
>       arm/xen,arm64/xen: introduce p2m
>       xen/x86: allow __set_phys_to_machine for autotranslate guests
>       xen: make xen_create_contiguous_region return the dma address
>       xen/arm,arm64: enable SWIOTLB_XEN
>       swiotlb-xen: introduce xen_swiotlb_set_dma_mask
>       arm/xen: get_dma_ops: return xen_dma_ops if we are running as xen_initial_domain
>       arm64/xen: get_dma_ops: return xen_dma_ops if we are running as xen_initial_domain
>       xen: introduce xen_alloc/free_coherent_pages
>       swiotlb-xen: use xen_alloc/free_coherent_pages
>       xen: introduce xen_dma_map/unmap_page and xen_dma_sync_single_for_cpu/device
>       swiotlb-xen: use xen_dma_map/unmap_page, xen_dma_sync_single_for_cpu/device
>       swiotlb: print a warning when the swiotlb is full
>       arm,arm64: do not always merge biovec if we are running on Xen
>       grant-table: call set_phys_to_machine after mapping grant refs
>       swiotlb-xen: no need to do execute two bus_to_phys translations in a row
>       swiotlb-xen: static inline xen_phys_to_bus, xen_bus_to_phys, xen_virt_to_bus and range_straddles_page_boundary
> 
>  arch/arm/Kconfig                           |    7 +
>  arch/arm/include/asm/dma-mapping.h         |   50 +++++++-
>  arch/arm/include/asm/io.h                  |    8 +
>  arch/arm/include/asm/xen/hypervisor.h      |    2 +
>  arch/arm/include/asm/xen/page-coherent.h   |   50 +++++++
>  arch/arm/include/asm/xen/page.h            |   50 ++++++-
>  arch/arm/xen/Makefile                      |    2 +-
>  arch/arm/xen/mm.c                          |   65 +++++++++
>  arch/arm/xen/p2m.c                         |  208 ++++++++++++++++++++++++++++
>  arch/arm64/Kconfig                         |    1 +
>  arch/arm64/include/asm/dma-mapping.h       |   14 ++-
>  arch/arm64/include/asm/io.h                |    9 ++
>  arch/arm64/include/asm/xen/page-coherent.h |   47 +++++++
>  arch/arm64/xen/Makefile                    |    2 +-
>  arch/ia64/include/asm/xen/page-coherent.h  |   38 +++++
>  arch/x86/include/asm/xen/page-coherent.h   |   38 +++++
>  arch/x86/xen/mmu.c                         |   11 +-
>  arch/x86/xen/p2m.c                         |    6 +-
>  drivers/xen/Kconfig                        |    1 -
>  drivers/xen/grant-table.c                  |   17 ++-
>  drivers/xen/swiotlb-xen.c                  |  116 ++++++++++++----
>  include/xen/swiotlb-xen.h                  |    2 +
>  include/xen/xen-ops.h                      |    7 +-
>  lib/swiotlb.c                              |    1 +
>  sound/soc/samsung/dma.c                    |    4 +-
>  25 files changed, 704 insertions(+), 52 deletions(-)
>  create mode 100644 arch/arm/include/asm/xen/page-coherent.h
>  create mode 100644 arch/arm/xen/mm.c
>  create mode 100644 arch/arm/xen/p2m.c
>  create mode 100644 arch/arm64/include/asm/xen/page-coherent.h
>  create mode 100644 arch/ia64/include/asm/xen/page-coherent.h
>  create mode 100644 arch/x86/include/asm/xen/page-coherent.h
> 
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/sstabellini/xen.git swiotlb-xen-8
