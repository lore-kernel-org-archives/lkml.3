Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753062AbaKLOW0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 09:22:26 -0500
Received: from mail-wg0-f45.google.com ([74.125.82.45]:49884 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752748AbaKLOWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 09:22:24 -0500
Message-ID: <54636D17.9080008@linaro.org>
Date: Wed, 12 Nov 2014 14:22:15 +0000
From: Julien Grall <julien.grall@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Icedove/24.8.1
MIME-Version: 1.0
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        xen-devel@lists.xensource.com
CC: Ian Campbell <Ian.Campbell@citrix.com>, catalin.marinas@arm.com,
        linux-kernel@vger.kernel.org, David Vrabel <david.vrabel@citrix.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [Xen-devel] [PATCH v9 0/13] introduce GNTTABOP_cache_flush
References: <alpine.DEB.2.02.1411121130020.26318@kaball.uk.xensource.com>
In-Reply-To: <alpine.DEB.2.02.1411121130020.26318@kaball.uk.xensource.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 11/12/2014 11:39 AM, Stefano Stabellini wrote:
> Hi all,
> this patch series introduces support for GNTTABOP_cache_flush to perform
> cache maintenance operation on foreign pages and reverts the current
> code based on XENFEAT_grant_map_identity.
> 
> It also provides a very slow fallback by bouncing on the swiotlb buffer,
> in case the hypercall is not available.
> 
> v7 introduces a flag named dma_coherent in dev_archdata and an accessor
> function named is_device_dma_coherent in asm/dma-mapping.h under arm and
> arm64.

I've been tested this series on non-LPAE kernel and don't see crash anymore:

Tested-by: Julien Grall <julien.grall@linaro.org>

Regards,

> Changes in v9:
> - remove BUG_ON from the loop in dma_cache_maint;
> - add static inline for xen_dma_unmap_page, xen_dma_sync_single_for_cpu,
>   xen_dma_sync_single_for_device;
> - map_page is always present, don't check whether it's implemented;
> - use bool local for clarity;
> - add an in-code comment.
> 
> Changes in v8:
> - remove code duplication in mm32.c by moving the pfn_valid check in
> page-coherent.h;
> - add a dma_addr_t dev_addr argument to xen_dma_map_page;
> - use hypercall to flush caches in map_page;
> - pass dev_addr to xen_dma_unmap_page and xen_dma_sync_single_for_cpu;
> - remove BUG_ON in xen_bus_to_phys.
> 
> Changes in v7:
> - rebased on 3.18-rc1;
> - rename is_dma_coherent to is_device_dma_coherent and move it to
> asm/dma-mapping.h on arm and arm64;
> - introduce a dma_coherent flag on arm and arm64;
> - set the flags from set_arch_dma_coherent_ops.
> 
> Changes in v6:
> - rename xen_is_dma_coherent to is_dma_coherent;
> - use of_dma_is_coherent to detect the dma coherency of a device;
> - remove arch/arm64/include/asm/xen/page-coherent.h, include
> ../../arm/include/asm/xen/page-coherent.h instead;
> - fix indentation.
> 
> Changes in v5:
> - introduce xen_is_dma_coherent as a xen specific function;
> - call xen_is_dma_coherent instead of is_dma_coherent;
> - introduce xen_is_dma_coherent to
> arch/arm64/include/asm/xen/page-coherent.h;
> - do not remove arch/arm64/include/asm/xen/page-coherent.h, add
> the missing dma_ops calls from it;
> - fix indentation;
> - rename hypercall_flush to hypercall_cflush;
> - remove spurious change.
> 
> Changes in v4:
> - remove outer_*_range call;
> - introduce is_dma_coherent;
> - use is_dma_coherent in arch/arm/xen/mm32.c;
> - merge xen/mm32.c into xen/mm.c;
> - xen/arm/arm64: introduce xen_arch_need_swiotlb;
> - avoid bouncing dma map operations that involve foreign grants and
> non-coherent devices if GNTTABOP_cache_flush is provided by Xen.
> 
> Changes in v3:
> - fix the cache maintenance op call to match what Linux does natively;
> - update the hypercall interface to match Xen.
> 
> Changes in v2:
> - remove the definition of XENFEAT_grant_map_identity;
> - update the hypercall interface to match Xen;
> - call the interface on a single page at a time.
> 
> 
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/sstabellini/xen.git cache_flush_v9
> 
> Stefano Stabellini (13):
>       xen/arm: remove handling of XENFEAT_grant_map_identity
>       xen/arm: remove outer_*_range call
>       xen/arm: if(pfn_valid(pfn)) call native dma_ops
>       arm64: introduce is_device_dma_coherent
>       arm: introduce is_device_dma_coherent
>       xen/arm: use is_device_dma_coherent
>       xen: add a dma_addr_t dev_addr argument to xen_dma_map_page
>       xen/arm: use hypercall to flush caches in map_page
>       xen/arm/arm64: merge xen/mm32.c into xen/mm.c
>       xen/arm/arm64: introduce xen_arch_need_swiotlb
>       xen/arm: introduce GNTTABOP_cache_flush
>       swiotlb-xen: pass dev_addr to xen_dma_unmap_page and xen_dma_sync_single_for_cpu
>       swiotlb-xen: remove BUG_ON in xen_bus_to_phys
> 
>  arch/arm/include/asm/device.h              |    1 +
>  arch/arm/include/asm/dma-mapping.h         |    6 +
>  arch/arm/include/asm/xen/page-coherent.h   |   66 +++++++--
>  arch/arm/include/asm/xen/page.h            |    4 +
>  arch/arm/xen/Makefile                      |    2 +-
>  arch/arm/xen/enlighten.c                   |    5 -
>  arch/arm/xen/mm.c                          |  121 +++++++++++++++++
>  arch/arm/xen/mm32.c                        |  202 ----------------------------
>  arch/arm64/include/asm/device.h            |    1 +
>  arch/arm64/include/asm/dma-mapping.h       |    6 +
>  arch/arm64/include/asm/xen/page-coherent.h |   44 +-----
>  arch/x86/include/asm/xen/page-coherent.h   |    4 +-
>  arch/x86/include/asm/xen/page.h            |    7 +
>  drivers/xen/swiotlb-xen.c                  |   19 +--
>  include/xen/interface/features.h           |    3 -
>  include/xen/interface/grant_table.h        |   19 +++
>  16 files changed, 237 insertions(+), 273 deletions(-)
>  delete mode 100644 arch/arm/xen/mm32.c
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xen.org
> http://lists.xen.org/xen-devel
> 


-- 
Julien Grall
