Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751561Ab3LKSzb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 13:55:31 -0500
Received: from mail.skyhub.de ([78.46.96.112]:49235 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750911Ab3LKSz3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 13:55:29 -0500
Date: Wed, 11 Dec 2013 19:55:20 +0100
From: Borislav Petkov <bp@alien8.de>
To: Dave Young <dyoung@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, x86@kernel.org,
        mjg59@srcf.ucam.org, hpa@zytor.com,
        James.Bottomley@HansenPartnership.com, vgoyal@redhat.com,
        ebiederm@xmission.com, horms@verge.net.au, kexec@lists.infradead.org,
        greg@kroah.com, matt@console-pimps.org, toshi.kani@hp.com
Subject: Re: [PATCH v5 08/14] efi: export efi runtime memory mapping to sysfs
Message-ID: <20131211185520.GG23793@pd.tnic>
References: <1386582147-9802-1-git-send-email-dyoung@redhat.com>
 <1386582147-9802-9-git-send-email-dyoung@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1386582147-9802-9-git-send-email-dyoung@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 09, 2013 at 05:42:21PM +0800, Dave Young wrote:
> kexec kernel will need exactly same mapping for
> efi runtime memory ranges. Thus here export the
> runtime ranges mapping to sysfs, kexec-tools
> will assemble them and pass to 2nd kernel via
> setup_data.
> 
> Introducing a new directory /sys/firmware/efi/runtime-map
> Just like /sys/firmware/memmap. Containing below attribute
> in each file of that directory:
> attribute  num_pages  phys_addr  type  virt_addr
> 
> Matt: s/efi-runtime-map.c/runtime-map.c
>       change dir name to runtime-map
> update to use desc_size in efi_runtime_map
> cleaup the code, add function efi_save_runtime_map
> improve err handling
> 
> Matt: changelog fix;
>       Documentation fixes.
>       only export runtime-map sysfs file in case CONFIG_KEXEC
> Add macros for sysfs _show functions
> move functions to front of .c, remove forward declarations.
> 
> Boris: Documentation grammer/spelling fix
>        better error handling for krealloc
>        other code improvements.
> move efi_runtime_map_init to subsys_initcall.
> set efi_kobj = NULL in case efisubsys_init fails. And then efi_runtime_map_init
> will bail out.
> Kconfig EFI_RUNTIME_MAP depends on X86 && KEXEC && EFI
> 
> Signed-off-by: Dave Young <dyoung@redhat.com>
> ---
>  .../ABI/testing/sysfs-firmware-efi-runtime-map     |  36 +++++
>  arch/x86/platform/efi/efi.c                        |  28 ++++
>  drivers/firmware/efi/Kconfig                       |  11 ++
>  drivers/firmware/efi/Makefile                      |   1 +
>  drivers/firmware/efi/efi.c                         |   4 +-
>  drivers/firmware/efi/runtime-map.c                 | 176 +++++++++++++++++++++
>  include/linux/efi.h                                |   6 +
>  7 files changed, 261 insertions(+), 1 deletion(-)
>  create mode 100644 Documentation/ABI/testing/sysfs-firmware-efi-runtime-map
>  create mode 100644 drivers/firmware/efi/runtime-map.c
> 
> diff --git a/Documentation/ABI/testing/sysfs-firmware-efi-runtime-map b/Documentation/ABI/testing/sysfs-firmware-efi-runtime-map
> new file mode 100644
> index 0000000..2ab7dd2
> --- /dev/null
> +++ b/Documentation/ABI/testing/sysfs-firmware-efi-runtime-map
> @@ -0,0 +1,36 @@
> +What:		/sys/firmware/efi/runtime-map/
> +Date:		December 2013
> +Contact:	Dave Young <dyoung@redhat.com>
> +Description:

This could start at the same line as Description

> +		Switching efi runtime services to virtual mode requires
> +		that all efi memory ranges which have the runtime attribute
> +		bit set to be mapped to virtual addresses.
> +
> +		The efi runtime services can only be switched to virtual
> +		mode once without rebooting. The kexec kernel must maintain
> +		the same physical to virtual address mappings as the first
> +		kernel. The mappings are exported to sysfs so userspace tools
> +		can reassemble them and pass them into the kexec kernel.
> +
> +		/sys/firmware/efi/runtime-map/ is the directory the kernel
> +		exports that information in.
> +
> +		subdirectories are named with the number of the memory range:
> +
> +			/sys/firmware/efi/runtime-map/0
> +			/sys/firmware/efi/runtime-map/1
> +			/sys/firmware/efi/runtime-map/2
> +			/sys/firmware/efi/runtime-map/3
> +			...
> +
> +		Each subdirectory contains five files:
> +
> +		attribute : The attributes of the memory range.
> +		num_pages : The size of the memory range in pages.
> +		phys_addr : The physical address of the memory range.
> +		type      : The type of the memory range.
> +		virt_addr : The virtual address of the memory range.
> +
> +		Above values are all hexadecimal numbers with the '0x' prefix.
> +

Superfluous newline.

> +Users:		Kexec
> diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
> index 3e8b760..8289e0c 100644
> --- a/arch/x86/platform/efi/efi.c
> +++ b/arch/x86/platform/efi/efi.c
> @@ -76,6 +76,9 @@ static __initdata efi_config_table_type_t arch_tables[] = {
>  	{NULL_GUID, NULL, NULL},
>  };
>  
> +void *efi_runtime_map;
> +int nr_efi_runtime_map;
> +
>  /*
>   * Returns 1 if 'facility' is enabled, 0 otherwise.
>   */
> @@ -810,6 +813,19 @@ static void __init efi_merge_regions(void)
>  	}
>  }
>  
> +static int __init save_runtime_map(efi_memory_desc_t *md, int idx)
> +{
> +	void *p;
> +	p = krealloc(efi_runtime_map, (idx + 1) * memmap.desc_size, GFP_KERNEL);
> +	if (!p)
> +		return -ENOMEM;
> +
> +	efi_runtime_map = p;
> +	memcpy(efi_runtime_map + idx * memmap.desc_size, md, memmap.desc_size);
> +
> +	return 0;
> +}
> +
>  /*
>   * Map efi memory ranges for runtime serivce and update new_memmap with virtual
>   * addresses.
> @@ -820,6 +836,7 @@ static void * __init efi_map_regions(int *count)
>  	void *p, *tmp, *new_memmap = NULL;
>  	unsigned long size;
>  	u64 end, systab;
> +	int err = 0;
>  
>  	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
>  		md = p;
> @@ -848,10 +865,21 @@ static void * __init efi_map_regions(int *count)
>  		new_memmap = tmp;
>  		memcpy(new_memmap + (*count * memmap.desc_size), md,
>  		       memmap.desc_size);
> +		if (md->type != EFI_BOOT_SERVICES_CODE &&
> +		    md->type != EFI_BOOT_SERVICES_DATA) {
> +			err = save_runtime_map(md, nr_efi_runtime_map);
> +			if (err)
> +				goto out_save_runtime;
> +			nr_efi_runtime_map++;
> +		}

So why don't you move that code to save_runtime_map?


It would looks like this:

...
                new_memmap = tmp;
                memcpy(new_memmap + (*count * memmap.desc_size), md,
                       memmap.desc_size);

                save_runtime_map(md);
                (*count)++;

 [nr_efi_runtime_map is global, no need to pass it to save_runtime_map() ]

and the EFI_BOOT* tests can be done in save_runtime_map and also the
error handling can happen there. This way efi_map_regions() won't
need to know about anything. This way, you can later move the whole
save_runtime_map() function to efi-kexec.c just by taking it without any
need for untangling.

> +out_save_runtime:
> +       kfree(efi_runtime_map);
> +       nr_efi_runtime_map = 0;
> +       efi_runtime_map = NULL;

This can go there too.

>  out_krealloc:
>  	kfree(new_memmap);
>  	return NULL;
> diff --git a/drivers/firmware/efi/Kconfig b/drivers/firmware/efi/Kconfig
> index 3150aa4..3d8d6f6 100644
> --- a/drivers/firmware/efi/Kconfig
> +++ b/drivers/firmware/efi/Kconfig
> @@ -39,4 +39,15 @@ config EFI_VARS_PSTORE_DEFAULT_DISABLE
>  config UEFI_CPER
>  	def_bool n
>  
> +config EFI_RUNTIME_MAP
> +	bool "Export efi runtime maps to sysfs" if EXPERT

What's with the EXPERT? It depends on KEXEC already.

> +	depends on X86 && EFI && KEXEC
> +	default y
> +	help
> +	  Export efi runtime memory maps to /sys/firmware/efi/runtime-map.
> +	  That memory map is used for example by kexec to set up efi virtual
> +	  mapping the 2nd kernel, but can also be used for debugging purposes.
> +
> +	  See also Documentation/ABI/testing/sysfs-firmware-efi-runtime-map.
> +
>  endmenu

...

> +static int __init efi_runtime_map_init(void)
> +{
> +	int i, j, ret = 0;
> +	struct efi_runtime_map_entry *entry;
> +
> +	if (!efi_kobj)
> +		return 0;
> +
> +	if (!efi_runtime_map)
> +		return 0;
> +
> +	map_entries = kzalloc(nr_efi_runtime_map * sizeof(entry), GFP_KERNEL);
> +	if (!map_entries) {
> +		ret = -ENOMEM;
> +		goto out;
> +	}
> +
> +	for (i = 0; i < nr_efi_runtime_map; i++) {
> +		entry = add_sysfs_runtime_map_entry(i);
> +		if (IS_ERR(entry)) {
> +			ret = PTR_ERR(entry);
> +			goto out_add_entry;
> +		}
> +		*(map_entries + i) = entry;
> +	}
> +
> +	return 0;
> +out_add_entry:
> +	for (j = i - 1; j > 0; j--) {
> +		entry = *(map_entries + j);
> +		kobject_put(&entry->kobj);
> +	}
> +	if (map_kset)
> +		kset_unregister(map_kset);
> +out:
> +	return ret;
> +}
> +
> +subsys_initcall(efi_runtime_map_init);

Let me repeat myself:

Why an initcall? Can't we run this from efisubsys_init()?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
