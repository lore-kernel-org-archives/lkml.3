Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754104Ab3KVJPk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 04:15:40 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:20072 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752567Ab3KVJPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 04:15:34 -0500
X-AuditID: cbfec7f5-b7fe66d00000432e-69-528f20b4fabf
Message-id: <528F20B3.70803@samsung.com>
Date: Fri, 22 Nov 2013 10:15:31 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101
 Thunderbird/24.1.1
MIME-version: 1.0
To: Akinobu Mita <akinobu.mita@gmail.com>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Subject: Re: [PATCH] x86: enable DMA CMA with swiotlb
References: <1384903939-3371-1-git-send-email-akinobu.mita@gmail.com>
In-reply-to: <1384903939-3371-1-git-send-email-akinobu.mita@gmail.com>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrALMWRmVeSWpSXmKPExsVy+t/xK7pbFPqDDO4+ZLd4daCD0WLO+jVs
	FtM2ilssW/yU0eLyrjlsFpcOLGCy2LxpKrPFjw2PWR04PHbOusvusWlVJ5vHu3Pn2D1OzPjN
	4vHx6S0Wj/f7rrJ5fN4k53Gi5QtrAEcUl01Kak5mWWqRvl0CV8abn7+YCu6YVVzYeJelgfGN
	ThcjJ4eEgInErTlXmSFsMYkL99azdTFycQgJLGWUuPqogQUkISTwiVFiWUsZiM0roCGx48QU
	RhCbRUBV4lbHf1YQm03AUKLrbRdQMweHqECoxPc7IRDlghI/Jt8DGyMikCLx//FsZpD5zALr
	GCXWbljLBJIQFjCV2DNtBjPELleJtuaTYDangJvE+luH2EFsZgEziUct65ghbHmJzWveMk9g
	FJiFZMcsJGWzkJQtYGRexSiaWppcUJyUnmukV5yYW1yal66XnJ+7iRESC193MC49ZnWIUYCD
	UYmHd4dlX5AQa2JZcWXuIUYJDmYlEd5qmf4gId6UxMqq1KL8+KLSnNTiQ4xMHJxSDYzt/5fb
	Wa0xP8Iy+xX3j/c7HVN3T45eZyKeFB2//HKCw/2/LbFOP7a92/Nslky7vcNtob11IV8ze69K
	MnbtersxRyFp49+5jl84mb/8rNs08fGdEyw5LP69bBLnNdZaLQ94svCSh+F2R/VD/+bpnUoU
	KuNgffxtg7loxSH1+gvCInGdVg/5LLWUWIozEg21mIuKEwGDG8S4YwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 2013-11-20 00:32, Akinobu Mita wrote:
> The DMA Contiguous Memory Allocator support on x86 is disabled when
> swiotlb config option is enabled.  So DMA CMA is always disabled on
> x86_64 because swiotlb is always enabled.  This attempts to support
> for DMA CMA with enabling swiotlb config option.
>
> The contiguous memory allocator on x86 is integrated in the function
> dma_generic_alloc_coherent() which is .alloc callback in nommu_dma_ops
> for dma_alloc_coherent().
>
> x86_swiotlb_alloc_coherent() which is .alloc callback in swiotlb_dma_ops
> tries to allocate with dma_generic_alloc_coherent() firstly and then
> swiotlb_alloc_coherent() is called as a fallback.
>
> The main part of supporting DMA CMA with swiotlb is that changing
> x86_swiotlb_free_coherent() which is .free callback in swiotlb_dma_ops
> for dma_free_coherent() so that it can distinguish memory allocated by
> dma_generic_alloc_coherent() from one allocated by swiotlb_alloc_coherent()
> and release it with dma_generic_free_coherent() which can handle contiguous
> memory.  This change requires making is_swiotlb_buffer() global function.
>
> This also needs to change .free callback in the dma_map_ops for amd_gart
> and sta2x11, because these dma_ops are also using
> dma_generic_alloc_coherent().
>
> Cc: Marek Szyprowski <m.szyprowski@samsung.com>
> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: x86@kernel.org
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>

Acked-by: Marek Szyprowski<m.szyprowski@samsung.com>

> ---
>   arch/x86/Kconfig               | 2 +-
>   arch/x86/include/asm/swiotlb.h | 7 +++++++
>   arch/x86/kernel/amd_gart_64.c  | 2 +-
>   arch/x86/kernel/pci-swiotlb.c  | 9 ++++++---
>   arch/x86/pci/sta2x11-fixup.c   | 6 ++----
>   include/linux/swiotlb.h        | 2 ++
>   lib/swiotlb.c                  | 2 +-
>   7 files changed, 20 insertions(+), 10 deletions(-)
>
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index e903c71..b15df8b 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -39,7 +39,7 @@ config X86
>   	select ARCH_WANT_OPTIONAL_GPIOLIB
>   	select ARCH_WANT_FRAME_POINTERS
>   	select HAVE_DMA_ATTRS
> -	select HAVE_DMA_CONTIGUOUS if !SWIOTLB
> +	select HAVE_DMA_CONTIGUOUS
>   	select HAVE_KRETPROBES
>   	select HAVE_OPTPROBES
>   	select HAVE_KPROBES_ON_FTRACE
> diff --git a/arch/x86/include/asm/swiotlb.h b/arch/x86/include/asm/swiotlb.h
> index 977f176..ab05d73 100644
> --- a/arch/x86/include/asm/swiotlb.h
> +++ b/arch/x86/include/asm/swiotlb.h
> @@ -29,4 +29,11 @@ static inline void pci_swiotlb_late_init(void)
>   
>   static inline void dma_mark_clean(void *addr, size_t size) {}
>   
> +extern void *x86_swiotlb_alloc_coherent(struct device *hwdev, size_t size,
> +					dma_addr_t *dma_handle, gfp_t flags,
> +					struct dma_attrs *attrs);
> +extern void x86_swiotlb_free_coherent(struct device *dev, size_t size,
> +					void *vaddr, dma_addr_t dma_addr,
> +					struct dma_attrs *attrs);
> +
>   #endif /* _ASM_X86_SWIOTLB_H */
> diff --git a/arch/x86/kernel/amd_gart_64.c b/arch/x86/kernel/amd_gart_64.c
> index b574b29..8e3842f 100644
> --- a/arch/x86/kernel/amd_gart_64.c
> +++ b/arch/x86/kernel/amd_gart_64.c
> @@ -512,7 +512,7 @@ gart_free_coherent(struct device *dev, size_t size, void *vaddr,
>   		   dma_addr_t dma_addr, struct dma_attrs *attrs)
>   {
>   	gart_unmap_page(dev, dma_addr, size, DMA_BIDIRECTIONAL, NULL);
> -	free_pages((unsigned long)vaddr, get_order(size));
> +	dma_generic_free_coherent(dev, size, vaddr, dma_addr, attrs);
>   }
>   
>   static int gart_mapping_error(struct device *dev, dma_addr_t dma_addr)
> diff --git a/arch/x86/kernel/pci-swiotlb.c b/arch/x86/kernel/pci-swiotlb.c
> index 6c483ba..77dd0ad 100644
> --- a/arch/x86/kernel/pci-swiotlb.c
> +++ b/arch/x86/kernel/pci-swiotlb.c
> @@ -14,7 +14,7 @@
>   #include <asm/iommu_table.h>
>   int swiotlb __read_mostly;
>   
> -static void *x86_swiotlb_alloc_coherent(struct device *hwdev, size_t size,
> +void *x86_swiotlb_alloc_coherent(struct device *hwdev, size_t size,
>   					dma_addr_t *dma_handle, gfp_t flags,
>   					struct dma_attrs *attrs)
>   {
> @@ -28,11 +28,14 @@ static void *x86_swiotlb_alloc_coherent(struct device *hwdev, size_t size,
>   	return swiotlb_alloc_coherent(hwdev, size, dma_handle, flags);
>   }
>   
> -static void x86_swiotlb_free_coherent(struct device *dev, size_t size,
> +void x86_swiotlb_free_coherent(struct device *dev, size_t size,
>   				      void *vaddr, dma_addr_t dma_addr,
>   				      struct dma_attrs *attrs)
>   {
> -	swiotlb_free_coherent(dev, size, vaddr, dma_addr);
> +	if (is_swiotlb_buffer(dma_to_phys(dev, dma_addr)))
> +		swiotlb_free_coherent(dev, size, vaddr, dma_addr);
> +	else
> +		dma_generic_free_coherent(dev, size, vaddr, dma_addr, attrs);
>   }
>   
>   static struct dma_map_ops swiotlb_dma_ops = {
> diff --git a/arch/x86/pci/sta2x11-fixup.c b/arch/x86/pci/sta2x11-fixup.c
> index 9d8a509..5ceda85 100644
> --- a/arch/x86/pci/sta2x11-fixup.c
> +++ b/arch/x86/pci/sta2x11-fixup.c
> @@ -173,9 +173,7 @@ static void *sta2x11_swiotlb_alloc_coherent(struct device *dev,
>   {
>   	void *vaddr;
>   
> -	vaddr = dma_generic_alloc_coherent(dev, size, dma_handle, flags, attrs);
> -	if (!vaddr)
> -		vaddr = swiotlb_alloc_coherent(dev, size, dma_handle, flags);
> +	vaddr = x86_swiotlb_alloc_coherent(dev, size, dma_handle, flags, attrs);
>   	*dma_handle = p2a(*dma_handle, to_pci_dev(dev));
>   	return vaddr;
>   }
> @@ -183,7 +181,7 @@ static void *sta2x11_swiotlb_alloc_coherent(struct device *dev,
>   /* We have our own dma_ops: the same as swiotlb but from alloc (above) */
>   static struct dma_map_ops sta2x11_dma_ops = {
>   	.alloc = sta2x11_swiotlb_alloc_coherent,
> -	.free = swiotlb_free_coherent,
> +	.free = x86_swiotlb_free_coherent,
>   	.map_page = swiotlb_map_page,
>   	.unmap_page = swiotlb_unmap_page,
>   	.map_sg = swiotlb_map_sg_attrs,
> diff --git a/include/linux/swiotlb.h b/include/linux/swiotlb.h
> index a5ffd32..e7a018e 100644
> --- a/include/linux/swiotlb.h
> +++ b/include/linux/swiotlb.h
> @@ -116,4 +116,6 @@ static inline void swiotlb_free(void) { }
>   #endif
>   
>   extern void swiotlb_print_info(void);
> +extern int is_swiotlb_buffer(phys_addr_t paddr);
> +
>   #endif /* __LINUX_SWIOTLB_H */
> diff --git a/lib/swiotlb.c b/lib/swiotlb.c
> index fe978e0..6e4a798 100644
> --- a/lib/swiotlb.c
> +++ b/lib/swiotlb.c
> @@ -369,7 +369,7 @@ void __init swiotlb_free(void)
>   	io_tlb_nslabs = 0;
>   }
>   
> -static int is_swiotlb_buffer(phys_addr_t paddr)
> +int is_swiotlb_buffer(phys_addr_t paddr)
>   {
>   	return paddr >= io_tlb_start && paddr < io_tlb_end;
>   }

Best regards
-- 
Marek Szyprowski
Samsung R&D Institute Poland

