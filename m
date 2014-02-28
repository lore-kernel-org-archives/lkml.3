Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753224AbaB1R3F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 12:29:05 -0500
Received: from mail.skyhub.de ([78.46.96.112]:32854 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752972AbaB1R3B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 12:29:01 -0500
Date: Fri, 28 Feb 2014 18:28:57 +0100
From: Borislav Petkov <bp@alien8.de>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        ebiederm@xmission.com, hpa@zytor.com, mjg59@srcf.ucam.org,
        greg@kroah.com, jkosina@suse.cz
Subject: Re: [PATCH 11/11] kexec: Support for Kexec on panic using new system
 call
Message-ID: <20140228172857.GG4326@pd.tnic>
References: <1390849071-21989-1-git-send-email-vgoyal@redhat.com>
 <1390849071-21989-12-git-send-email-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1390849071-21989-12-git-send-email-vgoyal@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 27, 2014 at 01:57:51PM -0500, Vivek Goyal wrote:
> This patch adds support for loading a kexec on panic (kdump) kernel usning
> new system call. Right now this primarily works with bzImage loader only.
> But changes to ELF loader should be minimal as all the core infrastrcture
> is there.
> 
> Only thing preventing making ELF load in crash reseved memory is
> that kernel vmlinux is of type ET_EXEC and it expects to be loaded at
> address it has been compiled for. At that location current kernel is
> already running. One first needs to make vmlinux fully relocatable
> and export it is type ET_DYN and then modify this ELF loader to support
> images of type ET_DYN.
> 
> I am leaving it as a future TODO item.
> 
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

checkpatch: total: 2 errors, 10 warnings, 977 lines checked

> diff --git a/arch/x86/include/asm/kexec.h b/arch/x86/include/asm/kexec.h
> index 9bd6fec..a330d85 100644
> --- a/arch/x86/include/asm/kexec.h
> +++ b/arch/x86/include/asm/kexec.h
> @@ -25,6 +25,8 @@
>  #include <asm/ptrace.h>
>  #include <asm/bootparam.h>
>  
> +struct kimage;
> +
>  /*
>   * KEXEC_SOURCE_MEMORY_LIMIT maximum page get_free_page can return.
>   * I.e. Maximum page that is mapped directly into kernel memory,
> @@ -62,6 +64,10 @@
>  # define KEXEC_ARCH KEXEC_ARCH_X86_64
>  #endif
>  
> +/* Memory to backup during crash kdump */
> +#define KEXEC_BACKUP_SRC_START	(0UL)
> +#define KEXEC_BACKUP_SRC_END	(655360UL)	/* 640K */

I guess

#define KEXEC_BACKUP_SRC_END	(640 * 1024UL)

should be more clear.

>  /*
>   * CPU does not save ss and sp on stack if execution is already
>   * running in kernel mode at the time of NMI occurrence. This code
> @@ -161,8 +167,21 @@ struct kimage_arch {
>  	pud_t *pud;
>  	pmd_t *pmd;
>  	pte_t *pte;
> +	/* Details of backup region */
> +	unsigned long backup_src_start;
> +	unsigned long backup_src_sz;
> +
> +	/* Physical address of backup segment */
> +	unsigned long backup_load_addr;
> +
> +	/* Core ELF header buffer */
> +	unsigned long elf_headers;
> +	unsigned long elf_headers_sz;
> +	unsigned long elf_load_addr;
>  };
> +#endif /* CONFIG_X86_32 */
>  
> +#ifdef CONFIG_X86_64
>  struct kexec_entry64_regs {
>  	uint64_t rax;
>  	uint64_t rbx;
> @@ -189,11 +208,13 @@ extern crash_vmclear_fn __rcu *crash_vmclear_loaded_vmcss;
>  
>  extern int kexec_setup_initrd(struct boot_params *boot_params,
>  		unsigned long initrd_load_addr, unsigned long initrd_len);
> -extern int kexec_setup_cmdline(struct boot_params *boot_params,
> +extern int kexec_setup_cmdline(struct kimage *image,
> +		struct boot_params *boot_params,
>  		unsigned long bootparams_load_addr,
>  		unsigned long cmdline_offset, char *cmdline,
>  		unsigned long cmdline_len);
> -extern int kexec_setup_boot_parameters(struct boot_params *params);
> +extern int kexec_setup_boot_parameters(struct kimage *image,
> +					struct boot_params *params);
>  
>  
>  #endif /* __ASSEMBLY__ */
> diff --git a/arch/x86/kernel/crash.c b/arch/x86/kernel/crash.c
> index a57902e..8eabde4 100644
> --- a/arch/x86/kernel/crash.c
> +++ b/arch/x86/kernel/crash.c
> @@ -4,6 +4,9 @@
>   * Created by: Hariprasad Nellitheertha (hari@in.ibm.com)
>   *
>   * Copyright (C) IBM Corporation, 2004. All rights reserved.
> + * Copyright (C) Red Hat Inc., 2014. All rights reserved.
> + * Authors:
> + * 	Vivek Goyal <vgoyal@redhat.com>
>   *
>   */
>  
> @@ -16,6 +19,7 @@
>  #include <linux/elf.h>
>  #include <linux/elfcore.h>
>  #include <linux/module.h>
> +#include <linux/slab.h>
>  
>  #include <asm/processor.h>
>  #include <asm/hardirq.h>
> @@ -28,6 +32,45 @@
>  #include <asm/reboot.h>
>  #include <asm/virtext.h>
>  
> +/* Alignment required for elf header segment */
> +#define ELF_CORE_HEADER_ALIGN   4096
> +
> +/* This primarily reprsents number of split ranges due to exclusion */
> +#define CRASH_MAX_RANGES	16
> +
> +struct crash_mem_range {
> +	unsigned long long start, end;

u64?

> +};
> +
> +struct crash_mem {
> +	unsigned int nr_ranges;
> +	struct crash_mem_range ranges[CRASH_MAX_RANGES];
> +};
> +
> +/* Misc data about ram ranges needed to prepare elf headers */
> +struct crash_elf_data {
> +	struct kimage *image;
> +	/*
> +	 * Total number of ram ranges we have after various ajustments for
> +	 * GART, crash reserved region etc.
> +	 */
> +	unsigned int max_nr_ranges;
> +	unsigned long gart_start, gart_end;
> +
> +	/* Pointer to elf header */
> +	void *ehdr;
> +	/* Pointer to next phdr */
> +	void *bufp;
> +	struct crash_mem mem;
> +};
> +
> +/* Used while prepareing memory map entries for second kernel */

s/prepareing/preparing/

> +struct crash_memmap_data {
> +	struct boot_params *params;
> +	/* Type of memory */
> +	unsigned int type;
> +};
> +
>  int in_crash_kexec;
>  
>  /*
> @@ -137,3 +180,534 @@ void native_machine_crash_shutdown(struct pt_regs *regs)
>  #endif
>  	crash_save_cpu(regs, safe_smp_processor_id());
>  }
> +
> +#ifdef CONFIG_X86_64
> +
> +static int get_nr_ram_ranges_callback(unsigned long start_pfn,
> +				unsigned long nr_pfn, void *arg)
> +{
> +	int *nr_ranges = arg;
> +
> +	(*nr_ranges)++;
> +	return 0;
> +}
> +
> +static int get_gart_ranges_callback(u64 start, u64 end, void *arg)
> +{
> +	struct crash_elf_data *ced = arg;
> +
> +	ced->gart_start = start;
> +	ced->gart_end = end;
> +
> +	/* Not expecting more than 1 gart aperture */
> +	return 1;
> +}
> +
> +
> +/* Gather all the required information to prepare elf headers for ram regions */
> +static int fill_up_ced(struct crash_elf_data *ced, struct kimage *image)

All other functions have nice, spelled out names but not this one :)

Why not fill_up_crash_elf_data()?

> +{
> +	unsigned int nr_ranges = 0;
> +
> +	ced->image = image;
> +
> +	walk_system_ram_range(0, -1, &nr_ranges,
> +				get_nr_ram_ranges_callback);
> +
> +	ced->max_nr_ranges = nr_ranges;
> +
> +	/*
> +	 * We don't create ELF headers for GART aperture as an attempt
> +	 * to dump this memory in second kernel leads to hang/crash.
> +	 * If gart aperture is present, one needs to exclude that region
> +	 * and that could lead to need of extra phdr.
> +	 */
> +

superfluous newline.

> +	walk_ram_res("GART", IORESOURCE_MEM, 0, -1,
> +				ced, get_gart_ranges_callback);
> +
> +	/*
> +	 * If we have gart region, excluding that could potentially split
> +	 * a memory range, resulting in extra header. Account for  that.
> +	 */
> +	if (ced->gart_end)
> +		ced->max_nr_ranges++;
> +
> +	/* Exclusion of crash region could split memory ranges */
> +	ced->max_nr_ranges++;
> +
> +	/* If crashk_low_res is there, another range split possible */
> +	if (crashk_low_res.end != 0)
> +		ced->max_nr_ranges++;
> +
> +	return 0;
> +}

...

> +int load_crashdump_segments(struct kimage *image)
> +{
> +	unsigned long src_start, src_sz;
> +	unsigned long elf_addr, elf_sz;
> +	int ret;
> +
> +	/*
> +	 * Determine and load a segment for backup area. First 640K RAM
> +	 * region is backup source
> +	 */
> +
> +	ret = walk_system_ram_res(KEXEC_BACKUP_SRC_START, KEXEC_BACKUP_SRC_END,
> +				image, determine_backup_region);
> +
> +	/* Zero or postive return values are ok */
> +	if (ret < 0)
> +		return ret;
> +
> +	src_start = image->arch.backup_src_start;
> +	src_sz = image->arch.backup_src_sz;
> +
> +	/* Add backup segment. */
> +	if (src_sz) {
> +		ret = kexec_add_buffer(image, __va(src_start), src_sz, src_sz,
> +					PAGE_SIZE, 0, -1, 0,
> +					&image->arch.backup_load_addr);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	/* Prepare elf headers and add a segment */
> +	ret = prepare_elf_headers(image, &elf_addr, &elf_sz);
> +	if (ret)
> +		return ret;
> +
> +	image->arch.elf_headers = elf_addr;
> +	image->arch.elf_headers_sz = elf_sz;
> +
> +	ret = kexec_add_buffer(image, (char *)elf_addr, elf_sz, elf_sz,

For some reason, my compiler complains here:

arch/x86/kernel/crash.c: In function ‘load_crashdump_segments’:
arch/x86/kernel/crash.c:704:6: warning: ‘elf_sz’ may be used uninitialized in this function [-Wuninitialized]
arch/x86/kernel/crash.c:704:24: warning: ‘elf_addr’ may be used uninitialized in this function [-Wuninitialized]

It is likely bogus, though.

...

> -int kexec_setup_cmdline(struct boot_params *boot_params,
> +int kexec_setup_cmdline(struct kimage *image, struct boot_params *boot_params,
>  		unsigned long bootparams_load_addr,
>  		unsigned long cmdline_offset, char *cmdline,
>  		unsigned long cmdline_len)
>  {
>  	char *cmdline_ptr = ((char *)boot_params) + cmdline_offset;
> -	unsigned long cmdline_ptr_phys;
> +	unsigned long cmdline_ptr_phys, len;
>  	uint32_t cmdline_low_32, cmdline_ext_32;
>  
>  	memcpy(cmdline_ptr, cmdline, cmdline_len);
> +	if (image->type == KEXEC_TYPE_CRASH) {
> +		len = sprintf(cmdline_ptr + cmdline_len - 1,
> +			" elfcorehdr=0x%lx", image->arch.elf_load_addr);
> +		cmdline_len += len;
> +	}
>  	cmdline_ptr[cmdline_len - 1] = '\0';
>  
> +	pr_debug("Final command line is:%s\n", cmdline_ptr);

one space after ":"

The rest looks ok to me, but that doesn't mean a whole lot considering
my very limited kexec knowledge.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
