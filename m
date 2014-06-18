Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753448AbaFRQGQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 12:06:16 -0400
Received: from mail.skyhub.de ([78.46.96.112]:35478 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752028AbaFRQGO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 12:06:14 -0400
Date: Wed, 18 Jun 2014 18:06:07 +0200
From: Borislav Petkov <bp@alien8.de>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        ebiederm@xmission.com, hpa@zytor.com, mjg59@srcf.ucam.org,
        greg@kroah.com, jkosina@suse.cz, dyoung@redhat.com,
        chaowang@redhat.com, bhe@redhat.com, akpm@linux-foundation.org,
        linux-efi <linux-efi@vger.kernel.org>
Subject: Re: [PATCH 13/13] kexec: Support kexec/kdump on EFI systems
Message-ID: <20140618160607.GI24024@pd.tnic>
References: <1401800822-27425-1-git-send-email-vgoyal@redhat.com>
 <1401800822-27425-14-git-send-email-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1401800822-27425-14-git-send-email-vgoyal@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Addomg linux-efi to CC for the efi bits. Please CC it on your next
submission.

Thanks.

On Tue, Jun 03, 2014 at 09:07:02AM -0400, Vivek Goyal wrote:
> This patch does two thigns. It passes EFI run time mappings to second
> kernel in bootparams efi_info. Second kernel parse this info and create
> new mappings in second kernel. That means mappings in first and second
> kernel will be same. This paves the way to enable EFI in kexec kernel.
> 
> This patch also prepares and passes EFI setup data through bootparams.
> This contains bunch of information about various tables and their
> addresses.
> 
> These information gathering and passing has been written along the lines
> of what current kexec-tools is doing to make kexec work with UEFI.
> 
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  arch/x86/include/asm/kexec.h       |  4 +-
>  arch/x86/kernel/kexec-bzimage.c    | 40 ++++++++++++----
>  arch/x86/kernel/machine_kexec.c    | 93 ++++++++++++++++++++++++++++++++++++--
>  drivers/firmware/efi/runtime-map.c | 21 +++++++++
>  include/linux/efi.h                | 19 ++++++++
>  5 files changed, 163 insertions(+), 14 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kexec.h b/arch/x86/include/asm/kexec.h
> index 4cbe5f7..d8461cf 100644
> --- a/arch/x86/include/asm/kexec.h
> +++ b/arch/x86/include/asm/kexec.h
> @@ -214,7 +214,9 @@ extern int kexec_setup_cmdline(struct kimage *image,
>  		unsigned long cmdline_offset, char *cmdline,
>  		unsigned long cmdline_len);
>  extern int kexec_setup_boot_parameters(struct kimage *image,
> -					struct boot_params *params);
> +		struct boot_params *params, unsigned long params_load_addr,
> +		unsigned int efi_map_offset, unsigned int efi_map_sz,
> +		unsigned int efi_setup_data_offset);
>  
>  
>  #endif /* __ASSEMBLY__ */
> diff --git a/arch/x86/kernel/kexec-bzimage.c b/arch/x86/kernel/kexec-bzimage.c
> index 8e762d3..55716e1 100644
> --- a/arch/x86/kernel/kexec-bzimage.c
> +++ b/arch/x86/kernel/kexec-bzimage.c
> @@ -15,10 +15,12 @@
>  #include <linux/kexec.h>
>  #include <linux/kernel.h>
>  #include <linux/mm.h>
> +#include <linux/efi.h>
>  
>  #include <asm/bootparam.h>
>  #include <asm/setup.h>
>  #include <asm/crash.h>
> +#include <asm/efi.h>
>  
>  #define MAX_ELFCOREHDR_STR_LEN	30	/* elfcorehdr=0x<64bit-value> */
>  
> @@ -106,7 +108,7 @@ void *bzImage64_load(struct kimage *image, char *kernel,
>  
>  	struct setup_header *header;
>  	int setup_sects, kern16_size, ret = 0;
> -	unsigned long setup_header_size, params_cmdline_sz;
> +	unsigned long setup_header_size, params_cmdline_sz, params_misc_sz;
>  	struct boot_params *params;
>  	unsigned long bootparam_load_addr, kernel_load_addr, initrd_load_addr;
>  	unsigned long purgatory_load_addr;
> @@ -116,6 +118,7 @@ void *bzImage64_load(struct kimage *image, char *kernel,
>  	struct kexec_entry64_regs regs64;
>  	void *stack;
>  	unsigned int setup_hdr_offset = offsetof(struct boot_params, hdr);
> +	unsigned int efi_map_offset, efi_map_sz, efi_setup_data_offset;
>  
>  	header = (struct setup_header *)(kernel + setup_hdr_offset);
>  	setup_sects = header->setup_sects;
> @@ -168,28 +171,47 @@ void *bzImage64_load(struct kimage *image, char *kernel,
>  
>  	pr_debug("Loaded purgatory at 0x%lx\n", purgatory_load_addr);
>  
> -	/* Load Bootparams and cmdline */
> +
> +	/*
> +	 * Load Bootparams and cmdline and space for efi stuff.
> +	 *
> +	 * Allocate memory together for multiple data structures so
> +	 * that they all can go in single area/segment and we don't
> +	 * have to create separate segment for each. Keeps things
> +	 * little bit simple
> +	 */
> +	efi_map_sz = get_efi_runtime_map_size();
> +	efi_map_sz = ALIGN(efi_map_sz, 16);
> +
>  	params_cmdline_sz = sizeof(struct boot_params) + cmdline_len +
>  				MAX_ELFCOREHDR_STR_LEN;
> -	params = kzalloc(params_cmdline_sz, GFP_KERNEL);
> +	params_cmdline_sz = ALIGN(params_cmdline_sz, 16);
> +	params_misc_sz = params_cmdline_sz + efi_map_sz +
> +				sizeof(struct setup_data) +
> +				sizeof(struct efi_setup_data);
> +
> +	params = kzalloc(params_misc_sz, GFP_KERNEL);
>  	if (!params) {
>  		ret = -ENOMEM;
>  		goto out_free_loader_data;
>  	}
>  
> +	efi_map_offset = params_cmdline_sz;
> +	efi_setup_data_offset = efi_map_offset + efi_map_sz;
> +
>  	/* Copy setup header onto bootparams. Documentation/x86/boot.txt */
>  	setup_header_size = 0x0202 + kernel[0x0201] - setup_hdr_offset;
>  
>  	/* Is there a limit on setup header size? */
>  	memcpy(&params->hdr, (kernel + setup_hdr_offset), setup_header_size);
>  
> -	ret = kexec_add_buffer(image, (char *)params, params_cmdline_sz,
> -			       params_cmdline_sz, 16, MIN_BOOTPARAM_ADDR,
> +	ret = kexec_add_buffer(image, (char *)params, params_misc_sz,
> +			       params_misc_sz, 16, MIN_BOOTPARAM_ADDR,
>  			       ULONG_MAX, 1, &bootparam_load_addr);
>  	if (ret)
>  		goto out_free_params;
> -	pr_debug("Loaded boot_param and command line at 0x%lx bufsz=0x%lx memsz=0x%lx\n",
> -		 bootparam_load_addr, params_cmdline_sz, params_cmdline_sz);
> +	pr_debug("Loaded boot_param, command line and misc at 0x%lx bufsz=0x%lx memsz=0x%lx\n",
> +		 bootparam_load_addr, params_misc_sz, params_misc_sz);
>  
>  	/* Load kernel */
>  	kernel_buf = kernel + kern16_size;
> @@ -254,7 +276,9 @@ void *bzImage64_load(struct kimage *image, char *kernel,
>  	if (ret)
>  		goto out_free_params;
>  
> -	ret = kexec_setup_boot_parameters(image, params);
> +	ret = kexec_setup_boot_parameters(image, params, bootparam_load_addr,
> +					  efi_map_offset, efi_map_sz,
> +					  efi_setup_data_offset);
>  	if (ret)
>  		goto out_free_params;
>  
> diff --git a/arch/x86/kernel/machine_kexec.c b/arch/x86/kernel/machine_kexec.c
> index 6a3821b..f31a4b5 100644
> --- a/arch/x86/kernel/machine_kexec.c
> +++ b/arch/x86/kernel/machine_kexec.c
> @@ -12,9 +12,11 @@
>  #include <linux/kernel.h>
>  #include <linux/kexec.h>
>  #include <linux/string.h>
> +#include <linux/efi.h>
>  #include <asm/bootparam.h>
>  #include <asm/setup.h>
>  #include <asm/crash.h>
> +#include <asm/efi.h>
>  
>  /*
>   * Common code for x86 and x86_64 used for kexec.
> @@ -67,11 +69,10 @@ int kexec_setup_cmdline(struct kimage *image, struct boot_params *params,
>  	return 0;
>  }
>  
> -static int setup_memory_map_entries(struct boot_params *params)
> +static int setup_e820_entries(struct boot_params *params)
>  {
>  	unsigned int nr_e820_entries;
>  
> -	/* TODO: What about EFI */
>  	nr_e820_entries = e820_saved.nr_map;
>  	if (nr_e820_entries > E820MAX)
>  		nr_e820_entries = E820MAX;
> @@ -83,8 +84,85 @@ static int setup_memory_map_entries(struct boot_params *params)
>  	return 0;
>  }
>  
> -int kexec_setup_boot_parameters(struct kimage *image,
> -				struct boot_params *params)
> +#ifdef CONFIG_EFI
> +static int setup_efi_info_memmap(struct boot_params *params,
> +				  unsigned long params_load_addr,
> +				  unsigned int efi_map_offset,
> +				  unsigned int efi_map_sz)
> +{
> +	void *efi_map = (void *)params + efi_map_offset;
> +	unsigned long efi_map_phys_addr = params_load_addr + efi_map_offset;
> +	struct efi_info *ei = &params->efi_info;
> +
> +	if (!efi_map_sz)
> +		return 0;
> +
> +	efi_runtime_map_copy(efi_map, efi_map_sz);
> +
> +	ei->efi_memmap = efi_map_phys_addr & 0xffffffff;
> +	ei->efi_memmap_hi = efi_map_phys_addr >> 32;
> +	ei->efi_memmap_size = efi_map_sz;
> +
> +	return 0;
> +}
> +
> +static int
> +prepare_add_efi_setup_data(struct boot_params *params,
> +		       unsigned long params_load_addr,
> +		       unsigned int efi_setup_data_offset)
> +{
> +	unsigned long setup_data_phys;
> +	struct setup_data *sd = (void *)params + efi_setup_data_offset;
> +	struct efi_setup_data *esd = (void *)sd + sizeof(struct setup_data);
> +
> +	esd->fw_vendor = efi.fw_vendor;
> +	esd->runtime = efi.runtime;
> +	esd->tables = efi.config_table;
> +	esd->smbios = efi.smbios;
> +
> +	sd->type = SETUP_EFI;
> +	sd->len = sizeof(struct efi_setup_data);
> +
> +	/* Add setup data */
> +	setup_data_phys = params_load_addr + efi_setup_data_offset;
> +	sd->next = params->hdr.setup_data;
> +	params->hdr.setup_data = setup_data_phys;
> +
> +	return 0;
> +}
> +
> +static int setup_efi_state(struct boot_params *params,
> +			unsigned long params_load_addr,
> +			unsigned int efi_map_offset, unsigned int efi_map_sz,
> +			unsigned int efi_setup_data_offset)
> +{
> +	struct efi_info *current_ei = &boot_params.efi_info;
> +	struct efi_info *ei = &params->efi_info;
> +
> +	if (!current_ei->efi_memmap_size)
> +		return 0;
> +
> +	ei->efi_loader_signature = current_ei->efi_loader_signature;
> +	ei->efi_systab = current_ei->efi_systab;
> +	ei->efi_systab_hi = current_ei->efi_systab_hi;
> +
> +	ei->efi_memdesc_version = current_ei->efi_memdesc_version;
> +	ei->efi_memdesc_size = get_efi_runtime_map_desc_size();
> +
> +	setup_efi_info_memmap(params, params_load_addr, efi_map_offset,
> +			      efi_map_sz);
> +	prepare_add_efi_setup_data(params, params_load_addr,
> +				   efi_setup_data_offset);
> +	return 0;
> +}
> +#endif /* CONFIG_EFI */
> +
> +int
> +kexec_setup_boot_parameters(struct kimage *image, struct boot_params *params,
> +			    unsigned long params_load_addr,
> +			    unsigned int efi_map_offset,
> +			    unsigned int efi_map_sz,
> +			    unsigned int efi_setup_data_offset)
>  {
>  	unsigned int nr_e820_entries;
>  	unsigned long long mem_k, start, end;
> @@ -114,7 +192,7 @@ int kexec_setup_boot_parameters(struct kimage *image,
>  	if (image->type == KEXEC_TYPE_CRASH)
>  		crash_setup_memmap_entries(image, params);
>  	else
> -		setup_memory_map_entries(params);
> +		setup_e820_entries(params);
>  
>  	nr_e820_entries = params->e820_entries;
>  
> @@ -135,6 +213,11 @@ int kexec_setup_boot_parameters(struct kimage *image,
>  		}
>  	}
>  
> +#ifdef CONFIG_EFI
> +	/* Setup EFI state */
> +	setup_efi_state(params, params_load_addr, efi_map_offset, efi_map_sz,
> +			efi_setup_data_offset);
> +#endif
>  	/* Setup EDD info */
>  	memcpy(params->eddbuf, boot_params.eddbuf,
>  				EDDMAXNR * sizeof(struct edd_info));
> diff --git a/drivers/firmware/efi/runtime-map.c b/drivers/firmware/efi/runtime-map.c
> index 97cdd16..40f2213 100644
> --- a/drivers/firmware/efi/runtime-map.c
> +++ b/drivers/firmware/efi/runtime-map.c
> @@ -138,6 +138,27 @@ add_sysfs_runtime_map_entry(struct kobject *kobj, int nr)
>  	return entry;
>  }
>  
> +int get_efi_runtime_map_size(void)
> +{
> +	return nr_efi_runtime_map * efi_memdesc_size;
> +}
> +
> +int get_efi_runtime_map_desc_size(void)
> +{
> +	return efi_memdesc_size;
> +}
> +
> +int efi_runtime_map_copy(void *buf, size_t bufsz)
> +{
> +	size_t sz = get_efi_runtime_map_size();
> +
> +	if (sz > bufsz)
> +		sz = bufsz;
> +
> +	memcpy(buf, efi_runtime_map, sz);
> +	return 0;
> +}
> +
>  void efi_runtime_map_setup(void *map, int nr_entries, u32 desc_size)
>  {
>  	efi_runtime_map = map;
> diff --git a/include/linux/efi.h b/include/linux/efi.h
> index 6c100ff..c2e5c4a 100644
> --- a/include/linux/efi.h
> +++ b/include/linux/efi.h
> @@ -1131,6 +1131,9 @@ int efivars_sysfs_init(void);
>  #ifdef CONFIG_EFI_RUNTIME_MAP
>  int efi_runtime_map_init(struct kobject *);
>  void efi_runtime_map_setup(void *, int, u32);
> +int get_efi_runtime_map_size(void);
> +int get_efi_runtime_map_desc_size(void);
> +int efi_runtime_map_copy(void *buf, size_t bufsz);
>  #else
>  static inline int efi_runtime_map_init(struct kobject *kobj)
>  {
> @@ -1139,6 +1142,22 @@ static inline int efi_runtime_map_init(struct kobject *kobj)
>  
>  static inline void
>  efi_runtime_map_setup(void *map, int nr_entries, u32 desc_size) {}
> +
> +static inline int get_efi_runtime_map_size(void)
> +{
> +	return 0;
> +}
> +
> +static inline int get_efi_runtime_map_desc_size(void)
> +{
> +	return 0;
> +}
> +
> +static inline int efi_runtime_map_copy(void *buf, size_t bufsz)
> +{
> +	return 0;
> +}
> +
>  #endif
>  
>  #endif /* _LINUX_EFI_H */
> -- 
> 1.9.0
> 
> 

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
