Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756651Ab3BEEoV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 23:44:21 -0500
Received: from mail-vb0-f50.google.com ([209.85.212.50]:55124 "EHLO
	mail-vb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756242Ab3BEEoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 23:44:19 -0500
Date: Mon, 4 Feb 2013 23:44:16 -0500 (EST)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Rob Herring <rob.herring@calxeda.com>
cc: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        js1304@gmail.com, Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v5 3/3] ARM: mm: use static_vm for managing static mapped
 areas
In-Reply-To: <1360024314-1895-4-git-send-email-iamjoonsoo.kim@lge.com>
Message-ID: <alpine.LFD.2.02.1302042308220.6300@xanadu.home>
References: <1360024314-1895-1-git-send-email-iamjoonsoo.kim@lge.com> <1360024314-1895-4-git-send-email-iamjoonsoo.kim@lge.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Feb 2013, Joonsoo Kim wrote:

> A static mapped area is ARM-specific, so it is better not to use
> generic vmalloc data structure, that is, vmlist and vmlist_lock
> for managing static mapped area. And it causes some needless overhead and
> reducing this overhead is better idea.
> 
> Now, we have newly introduced static_vm infrastructure.
> With it, we don't need to iterate all mapped areas. Instead, we just
> iterate static mapped areas. It helps to reduce an overhead of finding
> matched area. And architecture dependency on vmalloc layer is removed,
> so it will help to maintainability for vmalloc layer.
> 
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

Some comments below.

> diff --git a/arch/arm/mm/ioremap.c b/arch/arm/mm/ioremap.c
> index 904c15e..c7fef4b 100644
> --- a/arch/arm/mm/ioremap.c
> +++ b/arch/arm/mm/ioremap.c
> @@ -261,13 +261,14 @@ void __iomem * __arm_ioremap_pfn_caller(unsigned long pfn,
>  	const struct mem_type *type;
>  	int err;
>  	unsigned long addr;
> - 	struct vm_struct * area;
> +	struct vm_struct *area;
> +	phys_addr_t paddr = __pfn_to_phys(pfn);
>  
>  #ifndef CONFIG_ARM_LPAE
>  	/*
>  	 * High mappings must be supersection aligned
>  	 */
> -	if (pfn >= 0x100000 && (__pfn_to_phys(pfn) & ~SUPERSECTION_MASK))
> +	if (pfn >= 0x100000 && (paddr & ~SUPERSECTION_MASK))
>  		return NULL;
>  #endif
>  
> @@ -283,24 +284,16 @@ void __iomem * __arm_ioremap_pfn_caller(unsigned long pfn,
>  	/*
>  	 * Try to reuse one of the static mapping whenever possible.
>  	 */
> -	read_lock(&vmlist_lock);
> -	for (area = vmlist; area; area = area->next) {
> -		if (!size || (sizeof(phys_addr_t) == 4 && pfn >= 0x100000))
> -			break;
> -		if (!(area->flags & VM_ARM_STATIC_MAPPING))
> -			continue;
> -		if ((area->flags & VM_ARM_MTYPE_MASK) != VM_ARM_MTYPE(mtype))
> -			continue;
> -		if (__phys_to_pfn(area->phys_addr) > pfn ||
> -		    __pfn_to_phys(pfn) + size-1 > area->phys_addr + area->size-1)
> -			continue;
> -		/* we can drop the lock here as we know *area is static */
> -		read_unlock(&vmlist_lock);
> -		addr = (unsigned long)area->addr;
> -		addr += __pfn_to_phys(pfn) - area->phys_addr;
> -		return (void __iomem *) (offset + addr);
> +	if (size && !((sizeof(phys_addr_t) == 4 && pfn >= 0x100000))) {
                     ^                                             ^
You have a needless extra set of parents here.

[...]

> diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
> index ce328c7..b2c0356 100644
> --- a/arch/arm/mm/mmu.c
> +++ b/arch/arm/mm/mmu.c
> @@ -757,21 +757,24 @@ void __init iotable_init(struct map_desc *io_desc, int nr)
>  {
>  	struct map_desc *md;
>  	struct vm_struct *vm;
> +	struct static_vm *svm;
>  
>  	if (!nr)
>  		return;
>  
> -	vm = early_alloc_aligned(sizeof(*vm) * nr, __alignof__(*vm));
> +	svm = early_alloc_aligned(sizeof(*svm) * nr, __alignof__(*svm));
>  
>  	for (md = io_desc; nr; md++, nr--) {
>  		create_mapping(md);
> +
> +		vm = &svm->vm;
>  		vm->addr = (void *)(md->virtual & PAGE_MASK);
>  		vm->size = PAGE_ALIGN(md->length + (md->virtual & ~PAGE_MASK));
>  		vm->phys_addr = __pfn_to_phys(md->pfn);
>  		vm->flags = VM_IOREMAP | VM_ARM_STATIC_MAPPING;
>  		vm->flags |= VM_ARM_MTYPE(md->type);
>  		vm->caller = iotable_init;
> -		vm_area_add_early(vm++);
> +		add_static_vm_early(svm++);
>  	}
>  }
>  
> @@ -779,13 +782,16 @@ void __init vm_reserve_area_early(unsigned long addr, unsigned long size,
>  				  void *caller)
>  {
>  	struct vm_struct *vm;
> +	struct static_vm *svm;
> +
> +	svm = early_alloc_aligned(sizeof(*svm), __alignof__(*svm));
>  
> -	vm = early_alloc_aligned(sizeof(*vm), __alignof__(*vm));
> +	vm = &svm->vm;
>  	vm->addr = (void *)addr;
>  	vm->size = size;
>  	vm->flags = VM_IOREMAP | VM_ARM_EMPTY_MAPPING;
>  	vm->caller = caller;
> -	vm_area_add_early(vm);
> +	add_static_vm_early(svm);
>  }
>  
>  #ifndef CONFIG_ARM_LPAE
> @@ -810,14 +816,13 @@ static void __init pmd_empty_section_gap(unsigned long addr)
>  
>  static void __init fill_pmd_gaps(void)
>  {
> +	struct static_vm *svm;
>  	struct vm_struct *vm;
>  	unsigned long addr, next = 0;
>  	pmd_t *pmd;
>  
> -	/* we're still single threaded hence no lock needed here */
> -	for (vm = vmlist; vm; vm = vm->next) {
> -		if (!(vm->flags & (VM_ARM_STATIC_MAPPING | VM_ARM_EMPTY_MAPPING)))
> -			continue;
> +	list_for_each_entry(svm, &static_vmlist, list) {
> +		vm = &svm->vm;
>  		addr = (unsigned long)vm->addr;
>  		if (addr < next)
>  			continue;
> @@ -859,17 +864,12 @@ static void __init pci_reserve_io(void)
>  {
>  	struct vm_struct *vm;
>  	unsigned long addr;
> +	struct static_vm *svm;
>  
> -	/* we're still single threaded hence no lock needed here */
> -	for (vm = vmlist; vm; vm = vm->next) {
> -		if (!(vm->flags & VM_ARM_STATIC_MAPPING))
> -			continue;
> -		addr = (unsigned long)vm->addr;
> -		addr &= ~(SZ_2M - 1);
> -		if (addr == PCI_IO_VIRT_BASE)
> -			return;
> +	svm = find_static_vm_vaddr((void *)PCI_IO_VIRT_BASE);
> +	if (svm)
> +		return;
> 
> -	}
>  
>  	vm_reserve_area_early(PCI_IO_VIRT_BASE, SZ_2M, pci_reserve_io);
>  }

The replacement code is not equivalent.  I can't recall why the original 
is as it is, but it doesn't look right to me.  The 2MB round down 
certainly looks suspicious.

The replacement code should be better.  However I'd like you to get an 
ACK from Rob Herring as well for this patch.

Once that is sorted out, you can add

Reviewed-by: Nicolas Pitre <nico@linaro.org>


Nicolas
