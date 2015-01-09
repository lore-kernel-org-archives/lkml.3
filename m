Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932480AbbAIQlW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 11:41:22 -0500
Received: from mail-we0-f175.google.com ([74.125.82.175]:34322 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752468AbbAIQlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 11:41:20 -0500
Date: Fri, 9 Jan 2015 16:41:15 +0000
From: Leif Lindholm <leif.lindholm@linaro.org>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: roy.franz@linaro.org, matt.fleming@intel.com, will.deacon@arm.com,
        catalin.marinas@arm.com, linux-arm-kernel@lists.infradead.org,
        linux-efi@vger.kernel.org, bp@alien8.de, msalter@redhat.com,
        geoff.levand@linaro.org, dyoung@redhat.com, mark.rutland@arm.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 6/8] arm64/efi: move SetVirtualAddressMap() to UEFI
 stub
Message-ID: <20150109164115.GT3827@bivouac.eciton.net>
References: <1420742914-2404-1-git-send-email-ard.biesheuvel@linaro.org>
 <1420742914-2404-7-git-send-email-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420742914-2404-7-git-send-email-ard.biesheuvel@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 08, 2015 at 06:48:32PM +0000, Ard Biesheuvel wrote:
> In order to support kexec, the kernel needs to be able to deal with the
> state of the UEFI firmware after SetVirtualAddressMap() has been called.
> To avoid having separate code paths for non-kexec and kexec, let's move
> the call to SetVirtualAddressMap() to the stub: this will guarantee us
> that it will only be called once (since the stub is not executed during
> kexec), and ensures that the UEFI state is identical between kexec and
> normal boot.
> 
> This implies that the layout of the virtual mapping needs to be created
> by the stub as well. All regions are rounded up to a naturally aligned
> multiple of 64 KB (for compatibility with 64k pages kernels) and recorded
> in the UEFI memory map. The kernel proper reads those values and installs
> the mappings in a dedicated set of page tables that are swapped in during
> UEFI Runtime Services calls.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>  arch/arm64/include/asm/efi.h            |  34 ++++-
>  arch/arm64/kernel/efi.c                 | 230 ++++++++++++++++++--------------
>  arch/arm64/kernel/setup.c               |   1 +
>  drivers/firmware/efi/libstub/arm-stub.c |  59 ++++++++
>  drivers/firmware/efi/libstub/efistub.h  |   4 +
>  drivers/firmware/efi/libstub/fdt.c      |  62 ++++++++-
>  6 files changed, 282 insertions(+), 108 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/efi.h b/arch/arm64/include/asm/efi.h
> index 71291253114f..effef3713c5a 100644
> --- a/arch/arm64/include/asm/efi.h
> +++ b/arch/arm64/include/asm/efi.h
> @@ -7,28 +7,36 @@
>  #ifdef CONFIG_EFI
>  extern void efi_init(void);
>  extern void efi_idmap_init(void);
> +extern void efi_virtmap_init(void);
>  #else
>  #define efi_init()
>  #define efi_idmap_init()
> +#define efi_virtmap_init()
>  #endif
>  
>  #define efi_call_virt(f, ...)						\
>  ({									\
> -	efi_##f##_t *__f = efi.systab->runtime->f;			\
> +	efi_##f##_t *__f;						\
>  	efi_status_t __s;						\
>  									\
>  	kernel_neon_begin();						\
> +	efi_virtmap_load();						\
> +	__f = efi.systab->runtime->f;					\
>  	__s = __f(__VA_ARGS__);						\
> +	efi_virtmap_unload();						\
>  	kernel_neon_end();						\
>  	__s;								\
>  })
>  
>  #define __efi_call_virt(f, ...)						\
>  ({									\
> -	efi_##f##_t *__f = efi.systab->runtime->f;			\
> +	efi_##f##_t *__f;						\
>  									\
>  	kernel_neon_begin();						\
> +	efi_virtmap_load();						\
> +	__f = efi.systab->runtime->f;					\
>  	__f(__VA_ARGS__);						\
> +	efi_virtmap_unload();						\
>  	kernel_neon_end();						\
>  })
>  
> @@ -46,4 +54,26 @@ extern void efi_idmap_init(void);
>  
>  #define EFI_ALLOC_ALIGN		SZ_64K
>  
> +/*
> + * On ARM systems, virtually remapped UEFI runtime services are set up in three
> + * distinct stages:
> + * - The stub retrieves the final version of the memory map from UEFI, populates
> + *   the virt_addr fields and calls the SetVirtualAddressMap() [SVAM] runtime
> + *   service to communicate the new mapping to the firmware (Note that the new
> + *   mapping is not live at this time)
> + * - During early boot, the page tables are allocated and populated based on the
> + *   virt_addr fields in the memory map, but only if all descriptors with the
> + *   EFI_MEMORY_RUNTIME attribute have a non-zero value for virt_addr. If this
> + *   succeeds, the EFI_VIRTMAP flag is set to indicate that the virtual mappings
> + *   have been installed successfully.
> + * - During an early initcall(), the UEFI Runtime Services are enabled and the
> + *   EFI_RUNTIME_SERVICES bit set if some conditions are met, i.e., we need a
> + *   non-early mapping of the UEFI system table, and we need to have the virtmap
> + *   installed.
> + */
> +#define EFI_VIRTMAP		EFI_ARCH_1
> +
> +void efi_virtmap_load(void);
> +void efi_virtmap_unload(void);
> +
>  #endif /* _ASM_EFI_H */
> diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
> index 2bb4347d0edf..755e545144ea 100644
> --- a/arch/arm64/kernel/efi.c
> +++ b/arch/arm64/kernel/efi.c
> @@ -11,25 +11,31 @@
>   *
>   */
>  
> +#include <linux/atomic.h>
>  #include <linux/dmi.h>
>  #include <linux/efi.h>
>  #include <linux/export.h>
>  #include <linux/memblock.h>
> +#include <linux/mm_types.h>
>  #include <linux/bootmem.h>
>  #include <linux/of.h>
>  #include <linux/of_fdt.h>
> +#include <linux/preempt.h>
> +#include <linux/rbtree.h>
> +#include <linux/rwsem.h>
>  #include <linux/sched.h>
>  #include <linux/slab.h>
> +#include <linux/spinlock.h>
>  
>  #include <asm/cacheflush.h>
>  #include <asm/efi.h>
>  #include <asm/tlbflush.h>
>  #include <asm/mmu_context.h>
> +#include <asm/mmu.h>
> +#include <asm/pgtable.h>
>  
>  struct efi_memory_map memmap;
>  
> -static efi_runtime_services_t *runtime;
> -
>  static u64 efi_system_table;
>  
>  static int uefi_debug __initdata;
> @@ -69,9 +75,33 @@ static void __init efi_setup_idmap(void)
>  	}
>  }
>  
> +/*
> + * Translate a EFI virtual address into a physical address: this is necessary,
> + * as some data members of the EFI system table are virtually remapped after
> + * SetVirtualAddressMap() has been called.
> + */
> +static phys_addr_t efi_to_phys(unsigned long addr)
> +{
> +	efi_memory_desc_t *md;
> +
> +	for_each_efi_memory_desc(&memmap, md) {
> +		if (!(md->attribute & EFI_MEMORY_RUNTIME))
> +			continue;
> +		if (md->virt_addr == 0)
> +			/* no virtual mapping has been installed by the stub */
> +			break;
> +		if (md->virt_addr <= addr &&
> +		    (addr - md->virt_addr) < (md->num_pages << EFI_PAGE_SHIFT))
> +			return md->phys_addr + addr - md->virt_addr;
> +	}
> +	return addr;
> +}
> +
>  static int __init uefi_init(void)
>  {
>  	efi_char16_t *c16;
> +	void *config_tables;
> +	u64 table_size;
>  	char vendor[100] = "unknown";
>  	int i, retval;
>  
> @@ -99,7 +129,7 @@ static int __init uefi_init(void)
>  			efi.systab->hdr.revision & 0xffff);
>  
>  	/* Show what we know for posterity */
> -	c16 = early_memremap(efi.systab->fw_vendor,
> +	c16 = early_memremap(efi_to_phys(efi.systab->fw_vendor),
>  			     sizeof(vendor));
>  	if (c16) {
>  		for (i = 0; i < (int) sizeof(vendor) - 1 && *c16; ++i)
> @@ -112,8 +142,14 @@ static int __init uefi_init(void)
>  		efi.systab->hdr.revision >> 16,
>  		efi.systab->hdr.revision & 0xffff, vendor);
>  
> -	retval = efi_config_init(NULL);
> +	table_size = sizeof(efi_config_table_64_t) * efi.systab->nr_tables;
> +	config_tables = early_memremap(efi_to_phys(efi.systab->tables),
> +				       table_size);
> +
> +	retval = efi_config_parse_tables(config_tables, efi.systab->nr_tables,
> +					 sizeof(efi_config_table_64_t), NULL);
>  
> +	early_memunmap(config_tables, table_size);
>  out:
>  	early_memunmap(efi.systab,  sizeof(efi_system_table_t));
>  	return retval;
> @@ -329,51 +365,14 @@ void __init efi_idmap_init(void)
>  	early_memunmap(memmap.map, memmap.map_end - memmap.map);
>  }
>  
> -static int __init remap_region(efi_memory_desc_t *md, void **new)
> -{
> -	u64 paddr, vaddr, npages, size;
> -
> -	paddr = md->phys_addr;
> -	npages = md->num_pages;
> -	memrange_efi_to_native(&paddr, &npages);
> -	size = npages << PAGE_SHIFT;
> -
> -	if (is_normal_ram(md))
> -		vaddr = (__force u64)ioremap_cache(paddr, size);
> -	else
> -		vaddr = (__force u64)ioremap(paddr, size);
> -
> -	if (!vaddr) {
> -		pr_err("Unable to remap 0x%llx pages @ %p\n",
> -		       npages, (void *)paddr);
> -		return 0;
> -	}
> -
> -	/* adjust for any rounding when EFI and system pagesize differs */
> -	md->virt_addr = vaddr + (md->phys_addr - paddr);
> -
> -	if (uefi_debug)
> -		pr_info("  EFI remap 0x%012llx => %p\n",
> -			md->phys_addr, (void *)md->virt_addr);
> -
> -	memcpy(*new, md, memmap.desc_size);
> -	*new += memmap.desc_size;
> -
> -	return 1;
> -}
> -
>  /*
> - * Switch UEFI from an identity map to a kernel virtual map
> + * Enable the UEFI Runtime Services if all prerequisites are in place, i.e.,
> + * non-early mapping of the UEFI system table and virtual mappings for all
> + * EFI_MEMORY_RUNTIME regions.
>   */
> -static int __init arm64_enter_virtual_mode(void)
> +static int __init arm64_enable_runtime_services(void)
>  {
> -	efi_memory_desc_t *md;
> -	phys_addr_t virtmap_phys;
> -	void *virtmap, *virt_md;
> -	efi_status_t status;
>  	u64 mapsize;
> -	int count = 0;
> -	unsigned long flags;
>  
>  	if (!efi_enabled(EFI_BOOT)) {
>  		pr_info("EFI services will not be available.\n");
> @@ -395,81 +394,30 @@ static int __init arm64_enter_virtual_mode(void)
>  
>  	efi.memmap = &memmap;
>  
> -	/* Map the runtime regions */
> -	virtmap = kmalloc(mapsize, GFP_KERNEL);
> -	if (!virtmap) {
> -		pr_err("Failed to allocate EFI virtual memmap\n");
> -		return -1;
> -	}
> -	virtmap_phys = virt_to_phys(virtmap);
> -	virt_md = virtmap;
> -
> -	for_each_efi_memory_desc(&memmap, md) {
> -		if (!(md->attribute & EFI_MEMORY_RUNTIME))
> -			continue;
> -		if (!remap_region(md, &virt_md))
> -			goto err_unmap;
> -		++count;
> -	}
> -
> -	efi.systab = (__force void *)efi_lookup_mapped_addr(efi_system_table);
> +	efi.systab = (__force void *)ioremap_cache(efi_system_table,
> +						   sizeof(efi_system_table_t));
>  	if (!efi.systab) {
> -		/*
> -		 * If we have no virtual mapping for the System Table at this
> -		 * point, the memory map doesn't cover the physical offset where
> -		 * it resides. This means the System Table will be inaccessible
> -		 * to Runtime Services themselves once the virtual mapping is
> -		 * installed.
> -		 */
> -		pr_err("Failed to remap EFI System Table -- buggy firmware?\n");
> -		goto err_unmap;
> +		pr_err("Failed to remap EFI System Table\n");
> +		return -1;
>  	}
>  	set_bit(EFI_SYSTEM_TABLES, &efi.flags);
>  
> -	local_irq_save(flags);
> -	cpu_switch_mm(idmap_pg_dir, &init_mm);
> -
> -	/* Call SetVirtualAddressMap with the physical address of the map */
> -	runtime = efi.systab->runtime;
> -	efi.set_virtual_address_map = runtime->set_virtual_address_map;
> -
> -	status = efi.set_virtual_address_map(count * memmap.desc_size,
> -					     memmap.desc_size,
> -					     memmap.desc_version,
> -					     (efi_memory_desc_t *)virtmap_phys);
> -	cpu_set_reserved_ttbr0();
> -	flush_tlb_all();
> -	local_irq_restore(flags);
> -
> -	kfree(virtmap);
> -
>  	free_boot_services();
>  
> -	if (status != EFI_SUCCESS) {
> -		pr_err("Failed to set EFI virtual address map! [%lx]\n",
> -			status);
> +	if (!efi_enabled(EFI_VIRTMAP)) {
> +		pr_err("No UEFI virtual mapping was installed -- runtime services will not be available\n");
>  		return -1;
>  	}
>  
>  	/* Set up runtime services function pointers */
> -	runtime = efi.systab->runtime;
>  	efi_native_runtime_setup();
>  	set_bit(EFI_RUNTIME_SERVICES, &efi.flags);
>  
>  	efi.runtime_version = efi.systab->hdr.revision;
>  
>  	return 0;
> -
> -err_unmap:
> -	/* unmap all mappings that succeeded: there are 'count' of those */
> -	for (virt_md = virtmap; count--; virt_md += memmap.desc_size) {
> -		md = virt_md;
> -		iounmap((__force void __iomem *)md->virt_addr);
> -	}
> -	kfree(virtmap);
> -	return -1;
>  }
> -early_initcall(arm64_enter_virtual_mode);
> +early_initcall(arm64_enable_runtime_services);
>  
>  static int __init arm64_dmi_init(void)
>  {
> @@ -484,3 +432,79 @@ static int __init arm64_dmi_init(void)
>  	return 0;
>  }
>  core_initcall(arm64_dmi_init);
> +
> +static pgd_t efi_pgd[PTRS_PER_PGD] __page_aligned_bss;
> +
> +static struct mm_struct efi_mm = {
> +	.mm_rb			= RB_ROOT,
> +	.pgd			= efi_pgd,
> +	.mm_users		= ATOMIC_INIT(2),
> +	.mm_count		= ATOMIC_INIT(1),
> +	.mmap_sem		= __RWSEM_INITIALIZER(efi_mm.mmap_sem),
> +	.page_table_lock	= __SPIN_LOCK_UNLOCKED(efi_mm.page_table_lock),
> +	.mmlist			= LIST_HEAD_INIT(efi_mm.mmlist),
> +	INIT_MM_CONTEXT(efi_mm)
> +};
> +
> +static void efi_set_pgd(struct mm_struct *mm)
> +{
> +	cpu_switch_mm(mm->pgd, mm);
> +	flush_tlb_all();
> +	if (icache_is_aivivt())
> +		__flush_icache_all();
> +}
> +
> +void efi_virtmap_load(void)
> +{
> +	preempt_disable();
> +	efi_set_pgd(&efi_mm);
> +}
> +
> +void efi_virtmap_unload(void)
> +{
> +	efi_set_pgd(current->active_mm);
> +	preempt_enable();
> +}
> +
> +void __init efi_virtmap_init(void)
> +{
> +	efi_memory_desc_t *md;
> +
> +	if (!efi_enabled(EFI_BOOT))
> +		return;
> +
> +	for_each_efi_memory_desc(&memmap, md) {
> +		u64 paddr, npages, size;
> +		pgprot_t prot;
> +
> +		if (!(md->attribute & EFI_MEMORY_RUNTIME))
> +			continue;
> +		if (WARN(md->virt_addr == 0,
> +			 "UEFI virtual mapping incomplete or missing -- no entry found for 0x%llx\n",
> +			 md->phys_addr))
> +			return;
> +
> +		paddr = md->phys_addr;
> +		npages = md->num_pages;
> +		memrange_efi_to_native(&paddr, &npages);
> +		size = npages << PAGE_SHIFT;
> +
> +		pr_info("  EFI remap 0x%016llx => %p\n",
> +			md->phys_addr, (void *)md->virt_addr);
> +
> +		/*
> +		 * Only regions of type EFI_RUNTIME_SERVICES_CODE need to be
> +		 * executable, everything else can be mapped with the XN bits
> +		 * set.
> +		 */
> +		if (!is_normal_ram(md))
> +			prot = __pgprot(PROT_DEVICE_nGnRE);
> +		else if (md->type == EFI_RUNTIME_SERVICES_CODE)
> +			prot = PAGE_KERNEL_EXEC;
> +		else
> +			prot = PAGE_KERNEL;
> +
> +		create_pgd_mapping(&efi_mm, paddr, md->virt_addr, size, prot);
> +	}
> +	set_bit(EFI_VIRTMAP, &efi.flags);
> +}
> diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
> index 20fe2932ad0c..beac8188fdbd 100644
> --- a/arch/arm64/kernel/setup.c
> +++ b/arch/arm64/kernel/setup.c
> @@ -401,6 +401,7 @@ void __init setup_arch(char **cmdline_p)
>  	paging_init();
>  	request_standard_resources();
>  
> +	efi_virtmap_init();
>  	efi_idmap_init();
>  	early_ioremap_reset();
>  
> diff --git a/drivers/firmware/efi/libstub/arm-stub.c b/drivers/firmware/efi/libstub/arm-stub.c
> index eb48a1a1a576..e2432b39b6df 100644
> --- a/drivers/firmware/efi/libstub/arm-stub.c
> +++ b/drivers/firmware/efi/libstub/arm-stub.c
> @@ -295,3 +295,62 @@ fail_free_image:
>  fail:
>  	return EFI_ERROR;
>  }
> +
> +/*
> + * This is the base address at which to start allocating virtual memory ranges
> + * for UEFI Runtime Services. This is in the low TTBR0 range so that we can use
> + * any allocation we choose, and eliminate the risk of a conflict after kexec.
> + * The value chosen is the largest non-zero power of 2 suitable for this purpose
> + * both on 32-bit and 64-bit ARM CPUs, to maximize the likelihood that it can
> + * be mapped efficiently.
> + */
> +#define EFI_RT_VIRTUAL_BASE	0x40000000
> +
> +/*
> + * efi_get_virtmap() - create a virtual mapping for the EFI memory map
> + *
> + * This function populates the virt_addr fields of all memory region descriptors
> + * in @memory_map whose EFI_MEMORY_RUNTIME attribute is set. Those descriptors
> + * are also copied to @runtime_map, and their total count is returned in @count.
> + */
> +void efi_get_virtmap(efi_memory_desc_t *memory_map, unsigned long map_size,
> +		     unsigned long desc_size, efi_memory_desc_t *runtime_map,
> +		     int *count)
> +{
> +	u64 efi_virt_base = EFI_RT_VIRTUAL_BASE;
> +	efi_memory_desc_t *out = runtime_map;
> +	int l;
> +
> +	for (l = 0; l < map_size; l += desc_size) {
> +		efi_memory_desc_t *in = (void *)memory_map + l;
> +		u64 paddr, size;
> +
> +		if (!(in->attribute & EFI_MEMORY_RUNTIME))
> +			continue;
> +
> +		/*
> +		 * Make the mapping compatible with 64k pages: this allows
> +		 * a 4k page size kernel to kexec a 64k page size kernel and
> +		 * vice versa.
> +		 */
> +		paddr = round_down(in->phys_addr, SZ_64K);
> +		size = round_up(in->num_pages * EFI_PAGE_SIZE +
> +				in->phys_addr - paddr, SZ_64K);
> +
> +		/*
> +		 * Avoid wasting memory on PTEs by choosing a virtual base that
> +		 * is compatible with section mappings if this region has the
> +		 * appropriate size and physical alignment. (Sections are 2 MB
> +		 * on 4k granule kernels)
> +		 */
> +		if (IS_ALIGNED(in->phys_addr, SZ_2M) && size >= SZ_2M)
> +			efi_virt_base = round_up(efi_virt_base, SZ_2M);
> +
> +		in->virt_addr = efi_virt_base + in->phys_addr - paddr;
> +		efi_virt_base += size;
> +
> +		memcpy(out, in, desc_size);
> +		out = (void *)out + desc_size;
> +		++*count;
> +	}
> +}
> diff --git a/drivers/firmware/efi/libstub/efistub.h b/drivers/firmware/efi/libstub/efistub.h
> index 304ab295ca1a..2be10984a67a 100644
> --- a/drivers/firmware/efi/libstub/efistub.h
> +++ b/drivers/firmware/efi/libstub/efistub.h
> @@ -39,4 +39,8 @@ efi_status_t allocate_new_fdt_and_exit_boot(efi_system_table_t *sys_table,
>  
>  void *get_fdt(efi_system_table_t *sys_table);
>  
> +void efi_get_virtmap(efi_memory_desc_t *memory_map, unsigned long map_size,
> +		     unsigned long desc_size, efi_memory_desc_t *runtime_map,
> +		     int *count);
> +
>  #endif
> diff --git a/drivers/firmware/efi/libstub/fdt.c b/drivers/firmware/efi/libstub/fdt.c
> index c846a9608cbd..91da56c4fd54 100644
> --- a/drivers/firmware/efi/libstub/fdt.c
> +++ b/drivers/firmware/efi/libstub/fdt.c
> @@ -14,6 +14,8 @@
>  #include <linux/libfdt.h>
>  #include <asm/efi.h>
>  
> +#include "efistub.h"
> +
>  efi_status_t update_fdt(efi_system_table_t *sys_table, void *orig_fdt,
>  			unsigned long orig_fdt_size,
>  			void *fdt, int new_fdt_size, char *cmdline_ptr,
> @@ -193,9 +195,26 @@ efi_status_t allocate_new_fdt_and_exit_boot(efi_system_table_t *sys_table,
>  	unsigned long map_size, desc_size;
>  	u32 desc_ver;
>  	unsigned long mmap_key;
> -	efi_memory_desc_t *memory_map;
> +	efi_memory_desc_t *memory_map, *runtime_map;
>  	unsigned long new_fdt_size;
>  	efi_status_t status;
> +	int runtime_entry_count = 0;
> +
> +	/*
> +	 * Get a copy of the current memory map that we will use to prepare
> +	 * the input for SetVirtualAddressMap(). We don't have to worry about
> +	 * subsequent allocations adding entries, since they could not affect
> +	 * the number of EFI_MEMORY_RUNTIME regions.
> +	 */
> +	status = efi_get_memory_map(sys_table, &runtime_map, &map_size,
> +				    &desc_size, &desc_ver, &mmap_key);
> +	if (status != EFI_SUCCESS) {
> +		pr_efi_err(sys_table, "Unable to retrieve UEFI memory map.\n");
> +		return status;
> +	}
> +
> +	pr_efi(sys_table,
> +	       "Exiting boot services and installing virtual address map...\n");
>  
>  	/*
>  	 * Estimate size of new FDT, and allocate memory for it. We
> @@ -248,12 +267,48 @@ efi_status_t allocate_new_fdt_and_exit_boot(efi_system_table_t *sys_table,
>  		}
>  	}
>  
> +	/*
> +	 * Update the memory map with virtual addresses. The function will also
> +	 * populate @runtime_map with copies of just the EFI_MEMORY_RUNTIME
> +	 * entries so that we can pass it straight into SetVirtualAddressMap()
> +	 */
> +	efi_get_virtmap(memory_map, map_size, desc_size, runtime_map,
> +			&runtime_entry_count);
> +
>  	/* Now we are ready to exit_boot_services.*/
>  	status = sys_table->boottime->exit_boot_services(handle, mmap_key);
>  
> +	if (status == EFI_SUCCESS) {
> +		efi_set_virtual_address_map_t *svam;
>  
> -	if (status == EFI_SUCCESS)
> -		return status;
> +		/* Install the new virtual address map */
> +		svam = sys_table->runtime->set_virtual_address_map;
> +		status = svam(runtime_entry_count * desc_size, desc_size,
> +			      desc_ver, runtime_map);
> +
> +		/*
> +		 * We are beyond the point of no return here, so if the call to
> +		 * SetVirtualAddressMap() failed, we need to signal that to the
> +		 * incoming kernel but proceed normally otherwise.
> +		 */
> +		if (status != EFI_SUCCESS) {
> +			int l;
> +
> +			/*
> +			 * Set the virtual address field of all
> +			 * EFI_MEMORY_RUNTIME entries to 0. This will signal
> +			 * the incoming kernel that no virtual translation has
> +			 * been installed.
> +			 */
> +			for (l = 0; l < map_size; l += desc_size) {
> +				efi_memory_desc_t *p = (void *)memory_map + l;
> +
> +				if (p->attribute & EFI_MEMORY_RUNTIME)
> +					p->virt_addr = 0;
> +			}
> +		}
> +		return EFI_SUCCESS;
> +	}
>  
>  	pr_efi_err(sys_table, "Exit boot services failed.\n");
>  
> @@ -264,6 +319,7 @@ fail_free_new_fdt:
>  	efi_free(sys_table, new_fdt_size, *new_fdt_addr);
>  
>  fail:
> +	sys_table->boottime->free_pool(runtime_map);
>  	return EFI_LOAD_ERROR;
>  }
>  
> -- 
> 1.8.3.2

Acked-by: Leif Lindholm <leif.lindholm@linaro.org>
