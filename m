Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755984Ab3LFOfY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 09:35:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63372 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754583Ab3LFOfV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 09:35:21 -0500
Message-ID: <1386340489.1861.175.camel@deneb.redhat.com>
Subject: Re: [PATCH 3/3] arm64: add EFI runtime services
From: Mark Salter <msalter@redhat.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "patches@linaro.org" <patches@linaro.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "matt.fleming@intel.com" <matt.fleming@intel.com>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        "roy.franz@linaro.org" <roy.franz@linaro.org>
Date: Fri, 06 Dec 2013 09:34:49 -0500
In-Reply-To: <20131205152510.GB974@darko.cambridge.arm.com>
References: <1385762712-17043-1-git-send-email-msalter@redhat.com>
	 <1385762712-17043-4-git-send-email-msalter@redhat.com>
	 <20131205152510.GB974@darko.cambridge.arm.com>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-12-05 at 15:25 +0000, Catalin Marinas wrote:
> On Fri, Nov 29, 2013 at 10:05:12PM +0000, Mark Salter wrote:
> > +
> > +#define efi_remap(cookie, size) __ioremap((cookie), (size), PAGE_KERNEL_EXEC)
> > +#define efi_ioremap(cookie, size) __ioremap((cookie), (size), \
> > +                                           __pgprot(PROT_DEVICE_nGnRE))
> > +#define efi_unmap(cookie) __iounmap((cookie))
> > +#define efi_iounmap(cookie) __iounmap((cookie))
> 
> I prefer to use the ioremap_*() functions rather than the lower-level
> __ioremap(). The ioremap_cache() should give us executable memory.

okay

> 
> Looking at the code, I think we have a bug with ioremap_cache() using
> MT_NORMAL since it doesn't have the shareability bit (Device memory does
> not require this on AArch64). PROT_DEFAULT should change to
> pgprot_default | PTE_DIRTY.
> 

ah, yes.

> > +       if (depth != 1 ||
> > +           (strcmp(uname, "chosen") != 0 && strcmp(uname, "chosen@0") != 0))
> > +               return 0;
> > +
> > +       pr_info("Getting EFI parameters from FDT.\n");
> > +
> > +       prop = of_get_flat_dt_prop(node, "linux,uefi-system-table", &len);
> > +       if (!prop) {
> > +               pr_err("No EFI system table in FDT\n");
> > +               return 0;
> > +       }
> > +       efi_system_table = of_read_ulong(prop, len/4);
> > +
> > +       prop = of_get_flat_dt_prop(node, "linux,uefi-mmap-start", &len);
> > +       if (!prop) {
> > +               pr_err("No EFI memmap in FDT\n");
> > +               return 0;
> > +       }
> > +       memmap.phys_map = (void *)of_read_ulong(prop, len/4);
> > +
> > +       prop = of_get_flat_dt_prop(node, "linux,uefi-mmap-size", &len);
> > +       if (!prop) {
> > +               pr_err("No EFI memmap size in FDT\n");
> > +               return 0;
> > +       }
> > +       size = of_read_ulong(prop, len/4);
> > +       memmap.map_end = memmap.phys_map + size;
> > +
> > +       /* reserve memmap */
> > +       memblock_reserve((u64)memmap.phys_map, size);
> > +
> > +       prop = of_get_flat_dt_prop(node, "linux,uefi-mmap-desc-size", &len);
> > +       if (!prop) {
> > +               pr_err("No EFI memmap descriptor size in FDT\n");
> > +               return 0;
> > +       }
> > +       memmap.desc_size = of_read_ulong(prop, len/4);
> > +
> > +       memmap.nr_map = size / memmap.desc_size;
> > +
> > +       prop = of_get_flat_dt_prop(node, "linux,uefi-mmap-desc-ver", &len);
> > +       if (!prop) {
> > +               pr_err("No EFI memmap descriptor version in FDT\n");
> > +               return 0;
> > +       }
> > +       memmap.desc_version = of_read_ulong(prop, len/4);
> > +
> > +       if (uefi_debug) {
> > +               pr_info("  EFI system table @ %p\n", (void *)efi_system_table);
> > +               pr_info("  EFI mmap @ %p-%p\n", memmap.phys_map,
> > +                       memmap.map_end);
> > +               pr_info("  EFI mmap descriptor size = 0x%lx\n",
> > +                       memmap.desc_size);
> > +               pr_info("  EFI mmap descriptor version = 0x%lx\n",
> > +                       memmap.desc_version);
> > +       }
> > +
> > +       return 1;
> > +}
> 
> Are these checks generic to other architectures? We may do with some
> helpers to avoid duplication.

That whole function could probably be shared.

> 
> > +
> > +#define PGD_END  (&idmap_pg_dir[sizeof(idmap_pg_dir)/sizeof(pgd_t)])
> 
> Just &idmap_pg_dir[PTRS_PER_PGD] would do (or idmap_pg_dir +
> ARRAY_SIZE(idmap_pg_dir)).

Should have been ARRAY_SIZE. I didn't want to use PTRS_PER_PGD in case
that changed.

> 
> > +#ifndef CONFIG_SMP
> > +#define PMD_FLAGS  (PMD_ATTRINDX(MT_NORMAL) | PMD_TYPE_SECT | PMD_SECT_AF)
> > +#else
> > +#define PMD_FLAGS  (PMD_ATTRINDX(MT_NORMAL) | PMD_TYPE_SECT | PMD_SECT_AF | \
> > +                   PMD_SECT_S)
> > +#endif
> > +
> > +static void __init create_idmap(unsigned long addr, unsigned long len)
> 
> I would change this to use the existing create_mapping() function which
> takes care of allocating pud/pmd/ptes. We shouldn't duplicate this
> functionality in two places. create_mapping() may need a slight change
> since it assumes swapper_pg_dir but it's not much. It also uses
> memblock_alloc() for early allocations.

I'll take a look at this.

> 
> > +static __init int memmap_walk(struct efi_memory_map *memmap,
> > +                             int (*func)(efi_memory_desc_t *, void *),
> > +                             void *private_data, int early)
> 
> Is this generic enough as a common helper between arm and arm64 (and
> maybe x86)?

Probably not as-is, but one could be made. 
> 
> > +static __init int reserve_region(efi_memory_desc_t *md, void *priv)
> [...]
> > +static __init void reserve_regions(void)
> [...]
> > +static int __init remap_region(efi_memory_desc_t *md, void *priv)
> [...]
> > +static int __init remap_regions(efi_memory_desc_t *map)
> 
> Same here (I haven't looked at the other implementations).

Only in arm/arm64 patches and they are different.

> 
> > +/*
> > + * Called from setup_arch with interrupts disabled.
> > + */
> > +void __init efi_enter_virtual_mode(void)
> > +{
> > +       void *newmap;
> > +       efi_status_t status;
> > +       u64 mapsize, total_freed = 0;
> > +       int count;
> > +
> > +       if (!efi_enabled(EFI_BOOT)) {
> > +               pr_info("EFI services will not be available.\n");
> > +               return;
> > +       }
> > +
> > +       pr_info("Remapping and enabling EFI services.\n");
> > +
> > +       mapsize = memmap.map_end - memmap.phys_map;
> > +       memmap.map = (__force void *)ioremap_cache((phys_addr_t)memmap.phys_map,
> > +                                                  mapsize);
> > +       memmap.map_end = memmap.map + mapsize;
> > +
> > +       /* Map the regions we reserved earlier */
> > +       newmap = alloc_bootmem(mapsize);
> 
> memblock_alloc() (also check the other bootmem uses in this patch, arm64
> is using memblock).

Okay, the bootmem function do use the memblock interface with some leak
detection added, but I can use memblock directly.

> 
> > +       if (newmap == NULL) {
> > +               pr_err("Failed to allocate new EFI memmap\n");
> > +               return;
> > +       }
> > +
> > +       count = remap_regions(newmap);
> > +       if (count <= 0) {
> > +               pr_err("Failed to remap EFI regions.\n");
> > +               return;
> > +       }
> > +
> > +       efi.memmap = &memmap;
> > +
> > +       efi.systab = (__force void *)efi_lookup_mapped_addr(efi_system_table);
> > +       if (efi.systab)
> > +               set_bit(EFI_SYSTEM_TABLES, &arm_efi_facility);
> > +
> > +       /*
> > +        * efi.systab->runtime is a pointer to something guaranteed by
> > +        * the UEFI specification to be 1:1 mapped.
> > +        */
> > +       runtime = (__force void *)efi_lookup_mapped_addr((u64)efi.systab->runtime);
> > +
> > +       /* Call SetVirtualAddressMap with the physical address of the map */
> > +       efi.set_virtual_address_map = runtime->set_virtual_address_map;
> > +
> > +       /* boot time idmap_pg_dir is incomplete, so fill in missing parts */
> > +       efi_setup_idmap();
> > +
> > +       cpu_switch_mm(idmap_pg_dir, &init_mm);
> > +       flush_tlb_all();
> > +       flush_cache_all();
> > +
> > +       status = efi.set_virtual_address_map(count * memmap.desc_size,
> > +                                            memmap.desc_size,
> > +                                            memmap.desc_version,
> > +                                            newmap);
> > +       cpu_set_reserved_ttbr0();
> > +       flush_tlb_all();
> > +       flush_cache_all();
> 
> What is the point of cache flusing here?

Paranoia based on not knowing what the firmware will be caching.
If it doesn't matter and there's nothing to worry about I can drop
it. 


