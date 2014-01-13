Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751255AbaAMFkj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 00:40:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12622 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750928AbaAMFkh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 00:40:37 -0500
Date: Mon, 13 Jan 2014 13:40:39 +0800
From: Dave Young <dyoung@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Linux EFI <linux-efi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>, Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Toshi Kani <toshi.kani@hp.com>
Subject: Re: [PATCH 4/4] efi: Make efi virtual runtime map passing more robust
Message-ID: <20140113054038.GB11237@dhcp-16-126.nay.redhat.com>
References: <1389473370-1940-1-git-send-email-bp@alien8.de>
 <1389473370-1940-5-git-send-email-bp@alien8.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389473370-1940-5-git-send-email-bp@alien8.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/11/14 at 09:49pm, Borislav Petkov wrote:
> From: Borislav Petkov <bp@suse.de>
> 
> Currently, running SetVirtualAddressMap() and passing the physical
> address of the virtual map array was working only by a lucky coincidence
> because the memory was present in the EFI page table too. Until Toshi
> went and booted this on a big HP box - the krealloc() manner of resizing
> the memmap we're doing did allocate from such physical addresses which
> were not mapped anymore and boom:
> 
> http://lkml.kernel.org/r/1386806463.1791.295.camel@misato.fc.hp.com
> 
> One way to take care of that issue is to reimplement the krealloc thing
> but with pages. We start with contiguous pages of order 1, i.e. 2 pages,
> and when we deplete that memory (shouldn't happen all that often but you
> know firmware) we realloc the next power-of-two pages.
> 
> Having the pages, it is much more handy and easy to map them into the
> EFI page table with the already existing mapping code which we're using
> for building the virtual mappings.
> 
> And, it doesn't matter all that much how much pages we've used as we're
> freeing them right after they've fulfilled their purpose at the end of
> the function anyway.
> 
> Reported-by: Toshi Kani <toshi.kani@hp.com>
> Signed-off-by: Borislav Petkov <bp@suse.de>
> ---
>  arch/x86/include/asm/efi.h     |  3 +-
>  arch/x86/platform/efi/efi.c    | 62 ++++++++++++++++++++++++++++++------------
>  arch/x86/platform/efi/efi_32.c |  6 +++-
>  arch/x86/platform/efi/efi_64.c | 31 +++++++++++++++++++--
>  4 files changed, 80 insertions(+), 22 deletions(-)
> 
> diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
> index 3b978c472d08..0e7973f7492e 100644
> --- a/arch/x86/include/asm/efi.h
> +++ b/arch/x86/include/asm/efi.h
> @@ -130,7 +130,8 @@ extern void efi_memory_uc(u64 addr, unsigned long size);
>  extern void __init efi_map_region(efi_memory_desc_t *md);
>  extern void __init efi_map_region_fixed(efi_memory_desc_t *md);
>  extern void efi_sync_low_kernel_mappings(void);
> -extern void efi_setup_page_tables(void);
> +extern int efi_setup_page_tables(unsigned long pa_memmap, unsigned num_pages);
> +extern void efi_cleanup_page_tables(unsigned long pa_memmap, unsigned num_pages);
>  extern void __init old_map_region(efi_memory_desc_t *md);
>  
>  struct efi_setup_data {
> diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
> index c34be4ce94c9..65a8c969db87 100644
> --- a/arch/x86/platform/efi/efi.c
> +++ b/arch/x86/platform/efi/efi.c
> @@ -948,14 +948,36 @@ static void __init efi_map_regions_fixed(void)
>  
>  }
>  
> +static void *realloc_pages(void *old_memmap, int old_shift)
> +{
> +	void *ret;
> +
> +	ret = (void *)__get_free_pages(GFP_KERNEL, old_shift + 1);
> +	if (!ret)
> +		goto out;
> +
> +	/*
> +	 * A first-time allocation doesn't have anything to copy.
> +	 */
> +	if (!old_memmap)
> +		return ret;
> +
> +	memcpy(ret, old_memmap, PAGE_SIZE << old_shift);
> +
> +out:
> +	__free_pages(old_memmap, old_shift);
> +	return ret;
> +}
> +
>  /*
> - * Map efi memory ranges for runtime serivce and update new_memmap with virtual
> - * addresses.
> + * Map the efi memory ranges of the runtime services and update new_mmap with
> + * virtual addresses.
>   */
> -static void * __init efi_map_regions(int *count)
> +static void * __init efi_map_regions(int *count, int *pg_shift)
>  {
> +	void *p, *new_memmap = NULL;
> +	unsigned long left = 0;
>  	efi_memory_desc_t *md;
> -	void *p, *tmp, *new_memmap = NULL;
>  
>  	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
>  		md = p;
> @@ -970,20 +992,23 @@ static void * __init efi_map_regions(int *count)
>  		efi_map_region(md);
>  		get_systab_virt_addr(md);
>  
> -		tmp = krealloc(new_memmap, (*count + 1) * memmap.desc_size,
> -			       GFP_KERNEL);
> -		if (!tmp)
> -			goto out;
> -		new_memmap = tmp;
> +		if (left < memmap.desc_size) {
> +			new_memmap = realloc_pages(new_memmap, *pg_shift);
> +			if (!new_memmap)
> +				return NULL;
> +
> +			left += PAGE_SIZE << *pg_shift;
> +			(*pg_shift)++;
> +		}
> +
>  		memcpy(new_memmap + (*count * memmap.desc_size), md,
>  		       memmap.desc_size);
> +
> +		left -= memmap.desc_size;

Adding a safeguard check for desc_size is better though currently it's impossible
for the desc_size > PAGE_SIZE?

>  		(*count)++;
>  	}
>  
>  	return new_memmap;
> -out:
> -	kfree(new_memmap);
> -	return NULL;
>  }
>  
>  /*
> @@ -1009,9 +1034,9 @@ out:
>   */
>  void __init efi_enter_virtual_mode(void)
>  {
> -	efi_status_t status;
> +	int err, count = 0, pg_shift = 0;
>  	void *new_memmap = NULL;
> -	int err, count = 0;
> +	efi_status_t status;
>  
>  	efi.systab = NULL;
>  
> @@ -1028,7 +1053,7 @@ void __init efi_enter_virtual_mode(void)
>  		efi_map_regions_fixed();
>  	} else {
>  		efi_merge_regions();
> -		new_memmap = efi_map_regions(&count);
> +		new_memmap = efi_map_regions(&count, &pg_shift);
>  		if (!new_memmap) {
>  			pr_err("Error reallocating memory, EFI runtime non-functional!\n");
>  			return;
> @@ -1041,7 +1066,9 @@ void __init efi_enter_virtual_mode(void)
>  
>  	BUG_ON(!efi.systab);
>  
> -	efi_setup_page_tables();
> +	if (efi_setup_page_tables(__pa(new_memmap), 1 << pg_shift))
> +		return;
> +
>  	efi_sync_low_kernel_mappings();
>  	dump_pagetable();
>  
> @@ -1083,7 +1110,8 @@ void __init efi_enter_virtual_mode(void)
>  	if (efi_enabled(EFI_OLD_MEMMAP) && (__supported_pte_mask & _PAGE_NX))
>  		runtime_code_page_mkexec();
>  
> -	kfree(new_memmap);
> +	efi_cleanup_page_tables(__pa(new_memmap), 1 << pg_shift);
> +	__free_pages(new_memmap, pg_shift);
>  
>  	/* clean DUMMY object */
>  	efi.set_variable(efi_dummy_name, &EFI_DUMMY_GUID,
> diff --git a/arch/x86/platform/efi/efi_32.c b/arch/x86/platform/efi/efi_32.c
> index 249b183cf417..d58a2015e22d 100644
> --- a/arch/x86/platform/efi/efi_32.c
> +++ b/arch/x86/platform/efi/efi_32.c
> @@ -40,7 +40,11 @@
>  static unsigned long efi_rt_eflags;
>  
>  void efi_sync_low_kernel_mappings(void) {}
> -void efi_setup_page_tables(void) {}
> +int efi_setup_page_tables(unsigned long pa_memmap, unsigned num_pages)
> +{
> +	return 0;
> +}
> +void efi_cleanup_page_tables(unsigned long pa_memmap, unsigned num_pages) {}
>  
>  void __init efi_map_region(efi_memory_desc_t *md)
>  {
> diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
> index 6284f158a47d..3d66844ea156 100644
> --- a/arch/x86/platform/efi/efi_64.c
> +++ b/arch/x86/platform/efi/efi_64.c
> @@ -137,12 +137,37 @@ void efi_sync_low_kernel_mappings(void)
>  		sizeof(pgd_t) * num_pgds);
>  }
>  
> -void efi_setup_page_tables(void)
> +int efi_setup_page_tables(unsigned long pa_memmap, unsigned num_pages)
>  {
> +	pgd_t *pgd;
> +
> +	if (efi_enabled(EFI_OLD_MEMMAP))
> +		return 0;
> +
> +	/*
> +	 * It can happen that the physical address of new_memmap lands in memory
> +	 * which is not mapped in the EFI page table. Therefore we need to go
> +	 * and ident-map those pages containing the map before calling
> +	 * phys_efi_set_virtual_address_map().
> +	 */
> +	if (kernel_map_pages_in_pgd(pgd, pa_memmap, pa_memmap, num_pages, _PAGE_NX)) {
> +		pr_err("Error ident-mapping new memmap (0x%lx)!\n", pa_memmap);
> +		return 1;
> +	}
> +
>  	efi_scratch.efi_pgt = (pgd_t *)(unsigned long)real_mode_header->trampoline_pgd;
> +	efi_scratch.use_pgd = true;
>  
> -	if (!efi_enabled(EFI_OLD_MEMMAP))
> -		efi_scratch.use_pgd = true;
> +	pgd = __va(efi_scratch.efi_pgt);
> +
> +	return 0;
> +}
> +
> +void efi_cleanup_page_tables(unsigned long pa_memmap, unsigned num_pages)
> +{
> +	pgd_t *pgd = (pgd_t *)__va(real_mode_header->trampoline_pgd);
> +
> +	kernel_unmap_pages_in_pgd(pgd, pa_memmap, num_pages);
>  }
>  
>  static void __init __map_region(efi_memory_desc_t *md, u64 va)
> -- 
> 1.8.5.2.192.g7794a68
> 
