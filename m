Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753135Ab3IVMgB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 08:36:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7615 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752890Ab3IVMf6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 08:35:58 -0400
Date: Sun, 22 Sep 2013 20:35:15 +0800
From: Dave Young <dyoung@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>, Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Vivek Goyal <vgoyal@redhat.com>, linux-efi@vger.kernel.org
Subject: Re: [PATCH -v2] EFI: Runtime services virtual mapping
Message-ID: <20130922123515.GA7476@dhcp-16-126.nay.redhat.com>
References: <1379602494-26684-1-git-send-email-bp@alien8.de>
 <1379602494-26684-12-git-send-email-bp@alien8.de>
 <20130921113929.GB1587@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130921113929.GB1587@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/21/13 at 01:39pm, Borislav Petkov wrote:
> On Thu, Sep 19, 2013 at 04:54:54PM +0200, Borislav Petkov wrote:
> > From: Borislav Petkov <bp@suse.de>
> > 
> > We map the EFI regions needed for runtime services contiguously on
> > virtual addresses starting from -4G down for a total max space of 64G.
> > This way, we provide for stable runtime services addresses across
> > kernels so that a kexec'd kernel can still use them.
> > 
> > This way, they're mapped in a separate pagetable so that we don't
> > pollute the kernel namespace (you can see how the whole ioremapping and
> > saving and restoring of PGDs is gone now).
> 
> Ok, this one was not so good, let's try again:
> 
> This time I saved 32-bit and am switching the pagetable only after
> having built it properly. This boots fine again on baremetal and on OVMF
> with Matt's handover flags fix from yesterday.
> 
> Also, I've uploaded the whole series to
> git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git, branch
> efi-experimental

I tested your new patch, it works both with efi stub and grub boot in 1st kernel.

But it paniced in kexec boot with my kexec related patcheset, the patchset
contains 3 patch:
1. introduce cmdline kexecboot=<0|1|2>; 1 == kexec, 2 == kdump
2. export physical addr fw_vendor, runtime, tables to /sys/firmware/efi/systab
3. if kexecboot != 0, use fw_vendor, runtime, tables from bootparams; Also do not
   call SetVirtualAddressMao in case kexecboot.

The panic happens at the last line of efi_init:
        /* clean DUMMY object */
        efi.set_variable(efi_dummy_name, &EFI_DUMMY_GUID,
                         EFI_VARIABLE_NON_VOLATILE |
                         EFI_VARIABLE_BOOTSERVICE_ACCESS |
                         EFI_VARIABLE_RUNTIME_ACCESS,
                         0, NULL);

Below is the dmesg:
[    0.003359] pid_max: default: 32768 minimum: 301
[    0.004792] BUG: unable to handle kernel paging request at fffffffefde97e70
[    0.006666] IP: [<ffffffff8103a1db>] virt_efi_set_variable+0x40/0x54
[    0.006666] PGD 36981067 PUD 35828063 PMD 0 
[    0.006666] Oops: 0000 [#1] SMP 
[    0.006666] Modules linked in:
[    0.006666] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.12.0-rc1+ #10
[    0.006666] task: ffffffff81985490 ti: ffffffff81964000 task.ti: ffffffff81964000
[    0.006666] RIP: 0010:[<ffffffff8103a1db>]  [<ffffffff8103a1db>] virt_efi_set_variable+0x40/0x54
[    0.006666] RSP: 0000:ffffffff81965ee0  EFLAGS: 00010246
[    0.006666] RAX: fffffffefde97e18 RBX: ffffffff81999300 RCX: 0000000000000007
[    0.006666] RDX: ffffffff81965f20 RSI: ffffffff81999300 RDI: ffff88000009cc88
[    0.006666] RBP: ffffffff81965f08 R08: 0000000000000000 R09: 0000000000000000
[    0.006666] R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81965f20
[    0.006666] R13: 0000000000000000 R14: 0000000000000007 R15: 0000000000000000
[    0.006666] FS:  0000000000000000(0000) GS:ffff880035c00000(0000) knlGS:0000000000000000
[    0.006666] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    0.006666] CR2: fffffffefde97e70 CR3: 0000000036980000 CR4: 00000000000006b0
[    0.006666] Stack:
[    0.006666]  0000000000000000 ffffffffff475630 ffff88003582c000 000000000000000f
[    0.006666]  000000000000000f ffffffff81965f60 ffffffff81a98a7c ffffffff81b1a900
[    0.006666]  47ddbe4b4424ac57 a9929ff050ed979e 0000000000000000 a02eda84fa6789b9
[    0.006666] Call Trace:
[    0.006666]  [<ffffffff81a98a7c>] efi_enter_virtual_mode+0x30a/0x32c
[    0.006666]  [<ffffffff81a83ccf>] start_kernel+0x349/0x3da
[    0.006666]  [<ffffffff81a83794>] ? repair_env_string+0x58/0x58
[    0.006666]  [<ffffffff81a83120>] ? early_idt_handlers+0x120/0x120
[    0.006666]  [<ffffffff81a83498>] x86_64_start_reservations+0x2a/0x2c
[    0.006666]  [<ffffffff81a83590>] x86_64_start_kernel+0xf6/0xff
[    0.006666] Code: 55 49 89 cd 4c 89 45 d8 e8 db 05 00 00 48 8b 05 2c 6a a2 00 4c 8b 45 d8 44 89 f1 4c 89 e2 48 89 de 48 8b 40 58 4d 89 c1 4d 89 e8 <48> 8b 78 58 e8 7c 0a 00 00 41 5e 5b 41 5c 41 5d 41 5e 5d c3 55 
[    0.006666] RIP  [<ffffffff8103a1db>] virt_efi_set_variable+0x40/0x54
[    0.006666]  RSP <ffffffff81965ee0>
[    0.006666] CR2: fffffffefde97e70
[    0.006666] ---[ end trace e9fbc5020b26135e ]---
[    0.006666] Kernel panic - not syncing: Attempted to kill the idle task!
[    0.006666] Rebooting in 10 seconds..


> 
> ("-experimental" doesn't trigger Fengguang's robot :-))
> 
> Good luck! :-)
> 
> ---
> From 880fcee20209a122eda846e7f109776ed1c56de5 Mon Sep 17 00:00:00 2001
> From: Borislav Petkov <bp@suse.de>
> Date: Wed, 18 Sep 2013 17:35:42 +0200
> Subject: [PATCH] EFI: Runtime services virtual mapping
> 
> We map the EFI regions needed for runtime services contiguously on
> virtual addresses starting from -4G down for a total max space of 64G.
> This way, we provide for stable runtime services addresses across
> kernels so that a kexec'd kernel can still use them.
> 
> This way, they're mapped in a separate pagetable so that we don't
> pollute the kernel namespace (you can see how the whole ioremapping and
> saving and restoring of PGDs is gone now).
> 
> Signed-off-by: Borislav Petkov <bp@suse.de>
> ---
>  arch/x86/include/asm/efi.h           | 43 ++++++++++--------
>  arch/x86/include/asm/pgtable_types.h |  3 +-
>  arch/x86/platform/efi/efi.c          | 68 ++++++++++++-----------------
>  arch/x86/platform/efi/efi_32.c       | 29 +++++++++++-
>  arch/x86/platform/efi/efi_64.c       | 85 +++++++++++++++++++-----------------
>  arch/x86/platform/efi/efi_stub_64.S  | 53 ++++++++++++++++++++++
>  6 files changed, 181 insertions(+), 100 deletions(-)
> 
> diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
> index 0062a0125041..9a99e0499e4b 100644
> --- a/arch/x86/include/asm/efi.h
> +++ b/arch/x86/include/asm/efi.h
> @@ -69,24 +69,31 @@ extern u64 efi_call6(void *fp, u64 arg1, u64 arg2, u64 arg3,
>  	efi_call6((f), (u64)(a1), (u64)(a2), (u64)(a3),		\
>  		  (u64)(a4), (u64)(a5), (u64)(a6))
>  
> +#define _efi_call_virtX(x, f, ...)					\
> +({									\
> +	efi_status_t __s;						\
> +									\
> +	efi_sync_low_kernel_mappings();					\
> +	preempt_disable();						\
> +	__s = efi_call##x((void *)efi.systab->runtime->f, __VA_ARGS__);	\
> +	preempt_enable();						\
> +	__s;								\
> +})
> +
>  #define efi_call_virt0(f)				\
> -	efi_call0((efi.systab->runtime->f))
> -#define efi_call_virt1(f, a1)					\
> -	efi_call1((efi.systab->runtime->f), (u64)(a1))
> -#define efi_call_virt2(f, a1, a2)					\
> -	efi_call2((efi.systab->runtime->f), (u64)(a1), (u64)(a2))
> -#define efi_call_virt3(f, a1, a2, a3)					\
> -	efi_call3((efi.systab->runtime->f), (u64)(a1), (u64)(a2), \
> -		  (u64)(a3))
> -#define efi_call_virt4(f, a1, a2, a3, a4)				\
> -	efi_call4((efi.systab->runtime->f), (u64)(a1), (u64)(a2), \
> -		  (u64)(a3), (u64)(a4))
> -#define efi_call_virt5(f, a1, a2, a3, a4, a5)				\
> -	efi_call5((efi.systab->runtime->f), (u64)(a1), (u64)(a2), \
> -		  (u64)(a3), (u64)(a4), (u64)(a5))
> -#define efi_call_virt6(f, a1, a2, a3, a4, a5, a6)			\
> -	efi_call6((efi.systab->runtime->f), (u64)(a1), (u64)(a2), \
> -		  (u64)(a3), (u64)(a4), (u64)(a5), (u64)(a6))
> +	_efi_call_virtX(0, f)
> +#define efi_call_virt1(f, a1)				\
> +	_efi_call_virtX(1, f, (u64)(a1))
> +#define efi_call_virt2(f, a1, a2)			\
> +	_efi_call_virtX(2, f, (u64)(a1), (u64)(a2))
> +#define efi_call_virt3(f, a1, a2, a3)			\
> +	_efi_call_virtX(3, f, (u64)(a1), (u64)(a2), (u64)(a3))
> +#define efi_call_virt4(f, a1, a2, a3, a4)		\
> +	_efi_call_virtX(4, f, (u64)(a1), (u64)(a2), (u64)(a3), (u64)(a4))
> +#define efi_call_virt5(f, a1, a2, a3, a4, a5)		\
> +	_efi_call_virtX(5, f, (u64)(a1), (u64)(a2), (u64)(a3), (u64)(a4), (u64)(a5))
> +#define efi_call_virt6(f, a1, a2, a3, a4, a5, a6)	\
> +	_efi_call_virtX(6, f, (u64)(a1), (u64)(a2), (u64)(a3), (u64)(a4), (u64)(a5), (u64)(a6))
>  
>  extern void __iomem *efi_ioremap(unsigned long addr, unsigned long size,
>  				 u32 type, u64 attribute);
> @@ -101,6 +108,8 @@ extern void efi_call_phys_prelog(void);
>  extern void efi_call_phys_epilog(void);
>  extern void efi_unmap_memmap(void);
>  extern void efi_memory_uc(u64 addr, unsigned long size);
> +extern void __init efi_map_region(efi_memory_desc_t *md);
> +extern void efi_sync_low_kernel_mappings(void);
>  
>  #ifdef CONFIG_EFI
>  
> diff --git a/arch/x86/include/asm/pgtable_types.h b/arch/x86/include/asm/pgtable_types.h
> index 0ecac257fb26..a83aa44bb1fb 100644
> --- a/arch/x86/include/asm/pgtable_types.h
> +++ b/arch/x86/include/asm/pgtable_types.h
> @@ -382,7 +382,8 @@ static inline void update_page_count(int level, unsigned long pages) { }
>   */
>  extern pte_t *lookup_address(unsigned long address, unsigned int *level);
>  extern phys_addr_t slow_virt_to_phys(void *__address);
> -
> +extern int kernel_map_pages_in_pgd(pgd_t *pgd, u64 pfn, unsigned long address,
> +				   unsigned numpages, unsigned long page_flags);
>  #endif	/* !__ASSEMBLY__ */
>  
>  #endif /* _ASM_X86_PGTABLE_DEFS_H */
> diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
> index 538c1e6b7b2c..90459f5f587c 100644
> --- a/arch/x86/platform/efi/efi.c
> +++ b/arch/x86/platform/efi/efi.c
> @@ -12,6 +12,8 @@
>   *	Bibo Mao <bibo.mao@intel.com>
>   *	Chandramouli Narayanan <mouli@linux.intel.com>
>   *	Huang Ying <ying.huang@intel.com>
> + * Copyright (C) 2013 SuSE Labs
> + * 	Borislav Petkov <bp@suse.de> - runtime services VA mapping
>   *
>   * Copied from efi_32.c to eliminate the duplicated code between EFI
>   * 32/64 support code. --ying 2007-10-26
> @@ -81,6 +83,17 @@ static efi_system_table_t efi_systab __initdata;
>  unsigned long x86_efi_facility;
>  
>  /*
> + * Scratch space used for switching the pagetable in the EFI stub
> + */
> +struct efi_scratch {
> +	u64 r15;
> +	u64 prev_cr3;
> +	pgd_t *efi_pgt;
> +	bool use_pgd;
> +};
> +extern struct efi_scratch efi_scratch;
> +
> +/*
>   * Returns 1 if 'facility' is enabled, 0 otherwise.
>   */
>  int efi_enabled(int facility)
> @@ -797,22 +810,6 @@ void __init efi_set_executable(efi_memory_desc_t *md, bool executable)
>  		set_memory_nx(addr, npages);
>  }
>  
> -static void __init runtime_code_page_mkexec(void)
> -{
> -	efi_memory_desc_t *md;
> -	void *p;
> -
> -	/* Make EFI runtime service code area executable */
> -	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
> -		md = p;
> -
> -		if (md->type != EFI_RUNTIME_SERVICES_CODE)
> -			continue;
> -
> -		efi_set_executable(md, true);
> -	}
> -}
> -
>  /*
>   * We can't ioremap data in EFI boot services RAM, because we've already mapped
>   * it as RAM.  So, look it up in the existing EFI memory map instead.  Only
> @@ -862,10 +859,10 @@ void efi_memory_uc(u64 addr, unsigned long size)
>  void __init efi_enter_virtual_mode(void)
>  {
>  	efi_memory_desc_t *md, *prev_md = NULL;
> -	efi_status_t status;
> +	void *p, *new_memmap = NULL;
>  	unsigned long size;
> -	u64 end, systab, start_pfn, end_pfn;
> -	void *p, *va, *new_memmap = NULL;
> +	efi_status_t status;
> +	u64 end, systab;
>  	int count = 0;
>  
>  	efi.systab = NULL;
> @@ -874,7 +871,6 @@ void __init efi_enter_virtual_mode(void)
>  	 * We don't do virtual mode, since we don't do runtime services, on
>  	 * non-native EFI
>  	 */
> -
>  	if (!efi_is_native()) {
>  		efi_unmap_memmap();
>  		return;
> @@ -914,33 +910,18 @@ void __init efi_enter_virtual_mode(void)
>  		    md->type != EFI_BOOT_SERVICES_DATA)
>  			continue;
>  
> +		efi_map_region(md);
> +
>  		size = md->num_pages << PAGE_SHIFT;
>  		end = md->phys_addr + size;
>  
> -		start_pfn = PFN_DOWN(md->phys_addr);
> -		end_pfn = PFN_UP(end);
> -		if (pfn_range_is_mapped(start_pfn, end_pfn)) {
> -			va = __va(md->phys_addr);
> -
> -			if (!(md->attribute & EFI_MEMORY_WB))
> -				efi_memory_uc((u64)(unsigned long)va, size);
> -		} else
> -			va = efi_ioremap(md->phys_addr, size,
> -					 md->type, md->attribute);
> -
> -		md->virt_addr = (u64) (unsigned long) va;
> -
> -		if (!va) {
> -			pr_err("ioremap of 0x%llX failed!\n",
> -			       (unsigned long long)md->phys_addr);
> -			continue;
> -		}
> -
>  		systab = (u64) (unsigned long) efi_phys.systab;
>  		if (md->phys_addr <= systab && systab < end) {
>  			systab += md->virt_addr - md->phys_addr;
> +
>  			efi.systab = (efi_system_table_t *) (unsigned long) systab;
>  		}
> +
>  		new_memmap = krealloc(new_memmap,
>  				      (count + 1) * memmap.desc_size,
>  				      GFP_KERNEL);
> @@ -949,8 +930,15 @@ void __init efi_enter_virtual_mode(void)
>  		count++;
>  	}
>  
> +#ifdef CONFIG_X86_64
> +	efi_scratch.efi_pgt = (pgd_t *)(unsigned long)real_mode_header->trampoline_pgd;
> +	efi_scratch.use_pgd = true;
> +#endif
> +
>  	BUG_ON(!efi.systab);
>  
> +	efi_sync_low_kernel_mappings();
> +
>  	status = phys_efi_set_virtual_address_map(
>  		memmap.desc_size * count,
>  		memmap.desc_size,
> @@ -983,8 +971,6 @@ void __init efi_enter_virtual_mode(void)
>  	efi.query_variable_info = virt_efi_query_variable_info;
>  	efi.update_capsule = virt_efi_update_capsule;
>  	efi.query_capsule_caps = virt_efi_query_capsule_caps;
> -	if (__supported_pte_mask & _PAGE_NX)
> -		runtime_code_page_mkexec();
>  
>  	kfree(new_memmap);
>  
> diff --git a/arch/x86/platform/efi/efi_32.c b/arch/x86/platform/efi/efi_32.c
> index 40e446941dd7..661663b08eaf 100644
> --- a/arch/x86/platform/efi/efi_32.c
> +++ b/arch/x86/platform/efi/efi_32.c
> @@ -37,9 +37,36 @@
>   * claim EFI runtime service handler exclusively and to duplicate a memory in
>   * low memory space say 0 - 3G.
>   */
> -
>  static unsigned long efi_rt_eflags;
>  
> +void efi_sync_low_kernel_mappings(void) {}
> +
> +void __init efi_map_region(efi_memory_desc_t *md)
> +{
> +	u64 start_pfn, end_pfn, end;
> +	unsigned long size;
> +	void *va;
> +
> +	start_pfn = PFN_DOWN(md->phys_addr);
> +	size	  = md->num_pages << PAGE_SHIFT;
> +	end	  = md->phys_addr + size;
> +	end_pfn   = PFN_UP(end);
> +
> +	if (pfn_range_is_mapped(start_pfn, end_pfn)) {
> +		va = __va(md->phys_addr);
> +
> +		if (!(md->attribute & EFI_MEMORY_WB))
> +			efi_memory_uc((u64)(unsigned long)va, size);
> +	} else
> +		va = efi_ioremap(md->phys_addr, size,
> +				 md->type, md->attribute);
> +
> +	md->virt_addr = (u64) (unsigned long) va;
> +	if (!va)
> +		pr_err("ioremap of 0x%llX failed!\n",
> +		       (unsigned long long)md->phys_addr);
> +}
> +
>  void efi_call_phys_prelog(void)
>  {
>  	struct desc_ptr gdt_descr;
> diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
> index 39a0e7f1f0a3..db5230dd350e 100644
> --- a/arch/x86/platform/efi/efi_64.c
> +++ b/arch/x86/platform/efi/efi_64.c
> @@ -39,59 +39,64 @@
>  #include <asm/cacheflush.h>
>  #include <asm/fixmap.h>
>  
> -static pgd_t *save_pgd __initdata;
> -static unsigned long efi_flags __initdata;
> +void __init efi_call_phys_prelog(void) {}
> +void __init efi_call_phys_epilog(void) {}
>  
> -static void __init early_code_mapping_set_exec(int executable)
> +/*
> + * Add low kernel mappings for passing arguments to EFI functions.
> + */
> +void efi_sync_low_kernel_mappings(void)
>  {
> -	efi_memory_desc_t *md;
> -	void *p;
> +	unsigned num_pgds;
> +	pgd_t *pgd = (pgd_t *)__va(real_mode_header->trampoline_pgd);
>  
> -	if (!(__supported_pte_mask & _PAGE_NX))
> -		return;
> +	num_pgds = pgd_index(VMALLOC_START - 1) - pgd_index(PAGE_OFFSET);
>  
> -	/* Make EFI service code area executable */
> -	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
> -		md = p;
> -		if (md->type == EFI_RUNTIME_SERVICES_CODE ||
> -		    md->type == EFI_BOOT_SERVICES_CODE)
> -			efi_set_executable(md, executable);
> -	}
> +	memcpy(pgd + pgd_index(PAGE_OFFSET),
> +		init_mm.pgd + pgd_index(PAGE_OFFSET),
> +		sizeof(pgd_t) * num_pgds);
>  }
>  
> -void __init efi_call_phys_prelog(void)
> +/*
> + * We allocate runtime services regions top-down, starting from -4G, i.e.
> + * 0xffff_ffff_0000_0000 and limit EFI VA mapping space to 64G.
> + */
> +static u64 efi_va	 = -4 * (1UL << 30);
> +#define EFI_VA_END	 (-68 * (1UL << 30))
> +
> +static void __init __map_region(efi_memory_desc_t *md, u64 va)
>  {
> -	unsigned long vaddress;
> -	int pgd;
> -	int n_pgds;
> +	pgd_t *pgd = (pgd_t *)__va(real_mode_header->trampoline_pgd);
> +	unsigned long pf = 0, size;
> +	u64 end;
>  
> -	early_code_mapping_set_exec(1);
> -	local_irq_save(efi_flags);
> +	if (!(md->attribute & EFI_MEMORY_WB))
> +		pf |= _PAGE_PCD;
>  
> -	n_pgds = DIV_ROUND_UP((max_pfn << PAGE_SHIFT), PGDIR_SIZE);
> -	save_pgd = kmalloc(n_pgds * sizeof(pgd_t), GFP_KERNEL);
> +	size = md->num_pages << PAGE_SHIFT;
> +	end  = va + size;
>  
> -	for (pgd = 0; pgd < n_pgds; pgd++) {
> -		save_pgd[pgd] = *pgd_offset_k(pgd * PGDIR_SIZE);
> -		vaddress = (unsigned long)__va(pgd * PGDIR_SIZE);
> -		set_pgd(pgd_offset_k(pgd * PGDIR_SIZE), *pgd_offset_k(vaddress));
> -	}
> -	__flush_tlb_all();
> +	if(kernel_map_pages_in_pgd(pgd, md->phys_addr, va, md->num_pages, pf))
> +		pr_warning("Error mapping PA 0x%llx -> VA 0x%llx!\n",
> +			   md->phys_addr, va);
>  }
>  
> -void __init efi_call_phys_epilog(void)
> +void __init efi_map_region(efi_memory_desc_t *md)
>  {
> -	/*
> -	 * After the lock is released, the original page table is restored.
> -	 */
> -	int pgd;
> -	int n_pgds = DIV_ROUND_UP((max_pfn << PAGE_SHIFT) , PGDIR_SIZE);
> -	for (pgd = 0; pgd < n_pgds; pgd++)
> -		set_pgd(pgd_offset_k(pgd * PGDIR_SIZE), save_pgd[pgd]);
> -	kfree(save_pgd);
> -	__flush_tlb_all();
> -	local_irq_restore(efi_flags);
> -	early_code_mapping_set_exec(0);
> +	unsigned long size = md->num_pages << PAGE_SHIFT;
> +
> +	efi_va -= size;
> +	if (efi_va < EFI_VA_END) {
> +		pr_warning(FW_WARN "VA address range overflow!\n");
> +		return;
> +	}
> +
> +	/* Do the 1:1 map */
> +	__map_region(md, md->phys_addr);
> +
> +	/* Do the VA map */
> +	__map_region(md, efi_va);
> +	md->virt_addr = efi_va;
>  }
>  
>  void __iomem *__init efi_ioremap(unsigned long phys_addr, unsigned long size,
> diff --git a/arch/x86/platform/efi/efi_stub_64.S b/arch/x86/platform/efi/efi_stub_64.S
> index 4c07ccab8146..2bb9714bf713 100644
> --- a/arch/x86/platform/efi/efi_stub_64.S
> +++ b/arch/x86/platform/efi/efi_stub_64.S
> @@ -34,10 +34,47 @@
>  	mov %rsi, %cr0;			\
>  	mov (%rsp), %rsp
>  
> +	/* stolen from gcc */
> +	.macro FLUSH_TLB_ALL
> +	movq %r15, efi_scratch(%rip)
> +	movq %r14, efi_scratch+8(%rip)
> +	movq %cr4, %r15
> +	movq %r15, %r14
> +	andb $0x7f, %r14b
> +	movq %r14, %cr4
> +	movq %r15, %cr4
> +	movq efi_scratch+8(%rip), %r14
> +	movq efi_scratch(%rip), %r15
> +	.endm
> +
> +	.macro SWITCH_PGT
> +	cmpb $0, efi_scratch+24(%rip)
> +	je 1f
> +	movq %r15, efi_scratch(%rip)		# r15
> +	# save previous CR3
> +	movq %cr3, %r15
> +	movq %r15, efi_scratch+8(%rip)		# prev_cr3
> +	movq efi_scratch+16(%rip), %r15		# EFI pgt
> +	movq %r15, %cr3
> +	1:
> +	.endm
> +
> +	.macro RESTORE_PGT
> +	cmpb $0, efi_scratch+24(%rip)
> +	je 2f
> +	movq efi_scratch+8(%rip), %r15
> +	movq %r15, %cr3
> +	movq efi_scratch(%rip), %r15
> +	FLUSH_TLB_ALL
> +	2:
> +	.endm
> +
>  ENTRY(efi_call0)
>  	SAVE_XMM
>  	subq $32, %rsp
> +	SWITCH_PGT
>  	call *%rdi
> +	RESTORE_PGT
>  	addq $32, %rsp
>  	RESTORE_XMM
>  	ret
> @@ -47,7 +84,9 @@ ENTRY(efi_call1)
>  	SAVE_XMM
>  	subq $32, %rsp
>  	mov  %rsi, %rcx
> +	SWITCH_PGT
>  	call *%rdi
> +	RESTORE_PGT
>  	addq $32, %rsp
>  	RESTORE_XMM
>  	ret
> @@ -57,7 +96,9 @@ ENTRY(efi_call2)
>  	SAVE_XMM
>  	subq $32, %rsp
>  	mov  %rsi, %rcx
> +	SWITCH_PGT
>  	call *%rdi
> +	RESTORE_PGT
>  	addq $32, %rsp
>  	RESTORE_XMM
>  	ret
> @@ -68,7 +109,9 @@ ENTRY(efi_call3)
>  	subq $32, %rsp
>  	mov  %rcx, %r8
>  	mov  %rsi, %rcx
> +	SWITCH_PGT
>  	call *%rdi
> +	RESTORE_PGT
>  	addq $32, %rsp
>  	RESTORE_XMM
>  	ret
> @@ -80,7 +123,9 @@ ENTRY(efi_call4)
>  	mov %r8, %r9
>  	mov %rcx, %r8
>  	mov %rsi, %rcx
> +	SWITCH_PGT
>  	call *%rdi
> +	RESTORE_PGT
>  	addq $32, %rsp
>  	RESTORE_XMM
>  	ret
> @@ -93,7 +138,9 @@ ENTRY(efi_call5)
>  	mov %r8, %r9
>  	mov %rcx, %r8
>  	mov %rsi, %rcx
> +	SWITCH_PGT
>  	call *%rdi
> +	RESTORE_PGT
>  	addq $48, %rsp
>  	RESTORE_XMM
>  	ret
> @@ -109,8 +156,14 @@ ENTRY(efi_call6)
>  	mov %r8, %r9
>  	mov %rcx, %r8
>  	mov %rsi, %rcx
> +	SWITCH_PGT
>  	call *%rdi
> +	RESTORE_PGT
>  	addq $48, %rsp
>  	RESTORE_XMM
>  	ret
>  ENDPROC(efi_call6)
> +
> +	.data
> +ENTRY(efi_scratch)
> +	.fill 3,8,0
> -- 
> 1.8.4
> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> Sent from a fat crate under my desk. Formatting is fine.
> --
