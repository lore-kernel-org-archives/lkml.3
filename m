Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965475AbaFQVnV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 17:43:21 -0400
Received: from mail.skyhub.de ([78.46.96.112]:49139 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965209AbaFQVnR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 17:43:17 -0400
Date: Tue, 17 Jun 2014 23:43:10 +0200
From: Borislav Petkov <bp@alien8.de>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        ebiederm@xmission.com, hpa@zytor.com, mjg59@srcf.ucam.org,
        greg@kroah.com, jkosina@suse.cz, dyoung@redhat.com,
        chaowang@redhat.com, bhe@redhat.com, akpm@linux-foundation.org
Subject: Re: [PATCH 12/13] kexec: Support for Kexec on panic using new system
 call
Message-ID: <20140617214310.GC20603@pd.tnic>
References: <1401800822-27425-1-git-send-email-vgoyal@redhat.com>
 <1401800822-27425-13-git-send-email-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1401800822-27425-13-git-send-email-vgoyal@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 03, 2014 at 09:07:01AM -0400, Vivek Goyal wrote:
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
> ---
>  arch/x86/include/asm/crash.h       |   9 +
>  arch/x86/include/asm/kexec.h       |  25 +-
>  arch/x86/kernel/crash.c            | 581 +++++++++++++++++++++++++++++++++++++
>  arch/x86/kernel/kexec-bzimage.c    |  27 +-
>  arch/x86/kernel/machine_kexec.c    |  21 +-
>  arch/x86/kernel/machine_kexec_64.c |  40 +++
>  kernel/kexec.c                     |  83 +++++-
>  7 files changed, 770 insertions(+), 16 deletions(-)
>  create mode 100644 arch/x86/include/asm/crash.h
> 
> diff --git a/arch/x86/include/asm/crash.h b/arch/x86/include/asm/crash.h
> new file mode 100644
> index 0000000..2dd2eb8
> --- /dev/null
> +++ b/arch/x86/include/asm/crash.h
> @@ -0,0 +1,9 @@
> +#ifndef _ASM_X86_CRASH_H
> +#define _ASM_X86_CRASH_H
> +
> +int load_crashdump_segments(struct kimage *image);

I guess crash_load_segments(..) as you're prefixing the other exported
functions with "crash_".

> +int crash_copy_backup_region(struct kimage *image);
> +int crash_setup_memmap_entries(struct kimage *image,
> +		struct boot_params *params);
> +
> +#endif /* _ASM_X86_CRASH_H */

...

> diff --git a/arch/x86/kernel/crash.c b/arch/x86/kernel/crash.c
> index 507de80..b6a0974 100644
> --- a/arch/x86/kernel/crash.c
> +++ b/arch/x86/kernel/crash.c
> @@ -4,6 +4,9 @@
>   * Created by: Hariprasad Nellitheertha (hari@in.ibm.com)
>   *
>   * Copyright (C) IBM Corporation, 2004. All rights reserved.
> + * Copyright (C) Red Hat Inc., 2014. All rights reserved.
> + * Authors:
> + *      Vivek Goyal <vgoyal@redhat.com>
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

"represents"

> +#define CRASH_MAX_RANGES	16
> +
> +struct crash_mem_range {
> +	u64 start, end;
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

"adjustments"

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
> +/* Used while preparing memory map entries for second kernel */
> +struct crash_memmap_data {
> +	struct boot_params *params;
> +	/* Type of memory */
> +	unsigned int type;
> +};
> +
>  int in_crash_kexec;
>  
>  /*
> @@ -39,6 +82,7 @@ int in_crash_kexec;
>   */
>  crash_vmclear_fn __rcu *crash_vmclear_loaded_vmcss = NULL;
>  EXPORT_SYMBOL_GPL(crash_vmclear_loaded_vmcss);
> +unsigned long crash_zero_bytes;

Ah, that's the empty_zero_page...

>  
>  static inline void cpu_crash_vmclear_loaded_vmcss(void)
>  {
> @@ -135,3 +179,540 @@ void native_machine_crash_shutdown(struct pt_regs *regs)
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
> +static int fill_up_crash_elf_data(struct crash_elf_data *ced,
> +					struct kimage *image)
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

You mean "is not 0"?

> +	if (crashk_low_res.end != 0)
> +		ced->max_nr_ranges++;
> +
> +	return 0;

Returns unconditional 0 - make function void then.

> +}
> +
> +static int exclude_mem_range(struct crash_mem *mem,
> +		unsigned long long mstart, unsigned long long mend)
> +{
> +	int i, j;
> +	unsigned long long start, end;
> +	struct crash_mem_range temp_range = {0, 0};
> +
> +	for (i = 0; i < mem->nr_ranges; i++) {
> +		start = mem->ranges[i].start;
> +		end = mem->ranges[i].end;
> +
> +		if (mstart > end || mend < start)
> +			continue;
> +
> +		/* Truncate any area outside of range */
> +		if (mstart < start)
> +			mstart = start;
> +		if (mend > end)
> +			mend = end;
> +
> +		/* Found completely overlapping range */
> +		if (mstart == start && mend == end) {
> +			mem->ranges[i].start = 0;
> +			mem->ranges[i].end = 0;
> +			if (i < mem->nr_ranges - 1) {
> +				/* Shift rest of the ranges to left */
> +				for (j = i; j < mem->nr_ranges - 1; j++) {
> +					mem->ranges[j].start =
> +						mem->ranges[j+1].start;
> +					mem->ranges[j].end =
> +							mem->ranges[j+1].end;
> +				}
> +			}
> +			mem->nr_ranges--;
> +			return 0;
> +		}
> +
> +		if (mstart > start && mend < end) {
> +			/* Split original range */
> +			mem->ranges[i].end = mstart - 1;
> +			temp_range.start = mend + 1;
> +			temp_range.end = end;
> +		} else if (mstart != start)
> +			mem->ranges[i].end = mstart - 1;
> +		else
> +			mem->ranges[i].start = mend + 1;
> +		break;
> +	}
> +
> +	/* If a split happend, add the split in array */

"happened" ... "split to array"

> +	if (!temp_range.end)
> +		return 0;
> +
> +	/* Split happened */
> +	if (i == CRASH_MAX_RANGES - 1) {
> +		pr_err("Too many crash ranges after split\n");
> +		return -ENOMEM;
> +	}
> +
> +	/* Location where new range should go */
> +	j = i + 1;
> +	if (j < mem->nr_ranges) {
> +		/* Move over all ranges one place */

			...  all ranges one slot towards the end */

> +		for (i = mem->nr_ranges - 1; i >= j; i--)
> +			mem->ranges[i + 1] = mem->ranges[i];
> +	}
> +
> +	mem->ranges[j].start = temp_range.start;
> +	mem->ranges[j].end = temp_range.end;
> +	mem->nr_ranges++;
> +	return 0;
> +}
> +
> +/*
> + * Look for any unwanted ranges between mstart, mend and remove them. This
> + * might lead to split and split ranges are put in ced->mem.ranges[] array
> + */
> +static int elf_header_exclude_ranges(struct crash_elf_data *ced,
> +		unsigned long long mstart, unsigned long long mend)
> +{
> +	struct crash_mem *cmem = &ced->mem;
> +	int ret = 0;
> +
> +	memset(cmem->ranges, 0, sizeof(cmem->ranges));
> +
> +	cmem->ranges[0].start = mstart;
> +	cmem->ranges[0].end = mend;
> +	cmem->nr_ranges = 1;
> +
> +	/* Exclude crashkernel region */
> +	ret = exclude_mem_range(cmem, crashk_res.start, crashk_res.end);
> +	if (ret)
> +		return ret;
> +
> +	ret = exclude_mem_range(cmem, crashk_low_res.start, crashk_low_res.end);
> +	if (ret)
> +		return ret;
> +
> +	/* Exclude GART region */
> +	if (ced->gart_end) {
> +		ret = exclude_mem_range(cmem, ced->gart_start, ced->gart_end);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	return ret;
> +}
> +
> +static int prepare_elf64_ram_headers_callback(u64 start, u64 end, void *arg)
> +{
> +	struct crash_elf_data *ced = arg;
> +	Elf64_Ehdr *ehdr;
> +	Elf64_Phdr *phdr;
> +	unsigned long mstart, mend;
> +	struct kimage *image = ced->image;
> +	struct crash_mem *cmem;
> +	int ret, i;
> +
> +	ehdr = ced->ehdr;
> +
> +	/* Exclude unwanted mem ranges */
> +	ret = elf_header_exclude_ranges(ced, start, end);
> +	if (ret)
> +		return ret;
> +
> +	/* Go through all the ranges in ced->mem.ranges[] and prepare phdr */
> +	cmem = &ced->mem;
> +
> +	for (i = 0; i < cmem->nr_ranges; i++) {
> +		mstart = cmem->ranges[i].start;
> +		mend = cmem->ranges[i].end;
> +
> +		phdr = ced->bufp;
> +		ced->bufp += sizeof(Elf64_Phdr);
> +
> +		phdr->p_type = PT_LOAD;
> +		phdr->p_flags = PF_R|PF_W|PF_X;
> +		phdr->p_offset  = mstart;
> +
> +		/*
> +		 * If a range matches backup region, adjust offset to backup
> +		 * segment.
> +		 */
> +		if (mstart == image->arch.backup_src_start &&
> +		    (mend - mstart + 1) == image->arch.backup_src_sz)
> +			phdr->p_offset = image->arch.backup_load_addr;
> +
> +		phdr->p_paddr = mstart;
> +		phdr->p_vaddr = (unsigned long long) __va(mstart);
> +		phdr->p_filesz = phdr->p_memsz = mend - mstart + 1;
> +		phdr->p_align = 0;
> +		ehdr->e_phnum++;
> +		pr_debug("Crash PT_LOAD elf header. phdr=%p vaddr=0x%llx, paddr=0x%llx, sz=0x%llx e_phnum=%d p_offset=0x%llx\n",
> +			phdr, phdr->p_vaddr, phdr->p_paddr, phdr->p_filesz,
> +			ehdr->e_phnum, phdr->p_offset);
> +	}
> +
> +	return ret;
> +}
> +
> +static int prepare_elf64_headers(struct crash_elf_data *ced,
> +		void **addr, unsigned long *sz)
> +{
> +	Elf64_Ehdr *ehdr;
> +	Elf64_Phdr *phdr;
> +	unsigned long nr_cpus = num_possible_cpus(), nr_phdr, elf_sz;
> +	unsigned char *buf, *bufp;
> +	unsigned int cpu;
> +	unsigned long long notes_addr;
> +	int ret;
> +
> +	/* extra phdr for vmcoreinfo elf note */
> +	nr_phdr = nr_cpus + 1;
> +	nr_phdr += ced->max_nr_ranges;
> +
> +	/*
> +	 * kexec-tools creates an extra PT_LOAD phdr for kernel text mapping
> +	 * area on x86_64 (ffffffff80000000 - ffffffffa0000000).
> +	 * I think this is required by tools like gdb. So same physical
> +	 * memory will be mapped in two elf headers. One will contain kernel
> +	 * text virtual addresses and other will have __va(physical) addresses.
> +	 */
> +
> +	nr_phdr++;
> +	elf_sz = sizeof(Elf64_Ehdr) + nr_phdr * sizeof(Elf64_Phdr);
> +	elf_sz = ALIGN(elf_sz, ELF_CORE_HEADER_ALIGN);
> +
> +	buf = vzalloc(elf_sz);

Since you get zeroed memory, you can save yourself all assignments to 0
below and thus slim this already terse function.

> +	if (!buf)
> +		return -ENOMEM;
> +
> +	bufp = buf;
> +	ehdr = (Elf64_Ehdr *)bufp;
> +	bufp += sizeof(Elf64_Ehdr);
> +	memcpy(ehdr->e_ident, ELFMAG, SELFMAG);
> +	ehdr->e_ident[EI_CLASS] = ELFCLASS64;
> +	ehdr->e_ident[EI_DATA] = ELFDATA2LSB;
> +	ehdr->e_ident[EI_VERSION] = EV_CURRENT;
> +	ehdr->e_ident[EI_OSABI] = ELF_OSABI;
> +	memset(ehdr->e_ident + EI_PAD, 0, EI_NIDENT - EI_PAD);
> +	ehdr->e_type = ET_CORE;
> +	ehdr->e_machine = ELF_ARCH;
> +	ehdr->e_version = EV_CURRENT;
> +	ehdr->e_entry = 0;
> +	ehdr->e_phoff = sizeof(Elf64_Ehdr);
> +	ehdr->e_shoff = 0;
> +	ehdr->e_flags = 0;
> +	ehdr->e_ehsize = sizeof(Elf64_Ehdr);
> +	ehdr->e_phentsize = sizeof(Elf64_Phdr);
> +	ehdr->e_phnum = 0;
> +	ehdr->e_shentsize = 0;
> +	ehdr->e_shnum = 0;
> +	ehdr->e_shstrndx = 0;
> +
> +	/* Prepare one phdr of type PT_NOTE for each present cpu */
> +	for_each_present_cpu(cpu) {
> +		phdr = (Elf64_Phdr *)bufp;
> +		bufp += sizeof(Elf64_Phdr);
> +		phdr->p_type = PT_NOTE;
> +		phdr->p_flags = 0;
> +		notes_addr = per_cpu_ptr_to_phys(per_cpu_ptr(crash_notes, cpu));
> +		phdr->p_offset = phdr->p_paddr = notes_addr;
> +		phdr->p_vaddr = 0;
> +		phdr->p_filesz = phdr->p_memsz = sizeof(note_buf_t);
> +		phdr->p_align = 0;
> +		(ehdr->e_phnum)++;
> +	}
> +
> +	/* Prepare one PT_NOTE header for vmcoreinfo */
> +	phdr = (Elf64_Phdr *)bufp;
> +	bufp += sizeof(Elf64_Phdr);
> +	phdr->p_type = PT_NOTE;
> +	phdr->p_flags = 0;
> +	phdr->p_offset = phdr->p_paddr = paddr_vmcoreinfo_note();
> +	phdr->p_vaddr = 0;
> +	phdr->p_filesz = phdr->p_memsz = sizeof(vmcoreinfo_note);
> +	phdr->p_align = 0;
> +	(ehdr->e_phnum)++;
> +
> +#ifdef CONFIG_X86_64
> +	/* Prepare PT_LOAD type program header for kernel text region */
> +	phdr = (Elf64_Phdr *)bufp;
> +	bufp += sizeof(Elf64_Phdr);
> +	phdr->p_type = PT_LOAD;
> +	phdr->p_flags = PF_R|PF_W|PF_X;
> +	phdr->p_vaddr = (Elf64_Addr)_text;
> +	phdr->p_filesz = phdr->p_memsz = _end - _text;
> +	phdr->p_offset = phdr->p_paddr = __pa_symbol(_text);
> +	phdr->p_align = 0;
> +	(ehdr->e_phnum)++;
> +#endif
> +
> +	/* Prepare PT_LOAD headers for system ram chunks. */
> +	ced->ehdr = ehdr;
> +	ced->bufp = bufp;
> +	ret = walk_system_ram_res(0, -1, ced,
> +			prepare_elf64_ram_headers_callback);
> +	if (ret < 0)
> +		return ret;
> +
> +	*addr = buf;
> +	*sz = elf_sz;
> +	return 0;
> +}
> +
> +/* Prepare elf headers. Return addr and size */
> +static int prepare_elf_headers(struct kimage *image, void **addr,
> +					unsigned long *sz)
> +{
> +	struct crash_elf_data *ced;
> +	int ret;
> +
> +	ced = kzalloc(sizeof(*ced), GFP_KERNEL);
> +	if (!ced)
> +		return -ENOMEM;
> +
> +	ret = fill_up_crash_elf_data(ced, image);
> +	if (ret)
> +		goto out;
> +
> +	/* By default prepare 64bit headers */
> +	ret =  prepare_elf64_headers(ced, addr, sz);
> +out:
> +	kfree(ced);
> +	return ret;
> +}
> +
> +static int add_e820_entry(struct boot_params *params, struct e820entry *entry)
> +{
> +	unsigned int nr_e820_entries;
> +
> +	nr_e820_entries = params->e820_entries;
> +	if (nr_e820_entries >= E820MAX)
> +		return 1;

You're not testing for the error condition in any call site. Are we sure
we will never hit E820MAX?

> +
> +	memcpy(&params->e820_map[nr_e820_entries], entry,
> +			sizeof(struct e820entry));
> +	params->e820_entries++;
> +	return 0;
> +}
> +
> +static int memmap_entry_callback(u64 start, u64 end, void *arg)
> +{
> +	struct crash_memmap_data *cmd = arg;
> +	struct boot_params *params = cmd->params;
> +	struct e820entry ei;
> +
> +	ei.addr = start;
> +	ei.size = end - start + 1;
> +	ei.type = cmd->type;
> +	add_e820_entry(params, &ei);
> +
> +	return 0;
> +}
> +
> +static int memmap_exclude_ranges(struct kimage *image, struct crash_mem *cmem,
> +		unsigned long long mstart, unsigned long long mend)

Arg alignment... multiple occurrences in this patch.

> +{
> +	unsigned long start, end;
> +	int ret = 0;
> +
> +	memset(cmem->ranges, 0, sizeof(cmem->ranges));
> +
> +	cmem->ranges[0].start = mstart;
> +	cmem->ranges[0].end = mend;
> +	cmem->nr_ranges = 1;
> +
> +	/* Exclude Backup region */
> +	start = image->arch.backup_load_addr;
> +	end = start + image->arch.backup_src_sz - 1;
> +	ret = exclude_mem_range(cmem, start, end);
> +	if (ret)
> +		return ret;
> +
> +	/* Exclude elf header region */
> +	start = image->arch.elf_load_addr;
> +	end = start + image->arch.elf_headers_sz - 1;
> +	ret = exclude_mem_range(cmem, start, end);
> +	return ret;

	return exclude_mem_range(cmem, start, end);

> +}
> +
> +/* Prepare memory map for crash dump kernel */
> +int crash_setup_memmap_entries(struct kimage *image, struct boot_params *params)
> +{
> +	int i, ret = 0;
> +	unsigned long flags;
> +	struct e820entry ei;
> +	struct crash_memmap_data cmd;
> +	struct crash_mem *cmem;
> +
> +	cmem = vzalloc(sizeof(struct crash_mem));
> +	if (!cmem)
> +		return -ENOMEM;

You're getting zeroed memory already but you're zeroing it out again
above in memmap_exclude_ranges().

> +
> +	memset(&cmd, 0, sizeof(struct crash_memmap_data));
> +	cmd.params = params;
> +
> +	/* Add first 640K segment */
> +	ei.addr = image->arch.backup_src_start;
> +	ei.size = image->arch.backup_src_sz;
> +	ei.type = E820_RAM;
> +	add_e820_entry(params, &ei);
> +
> +	/* Add ACPI tables */
> +	cmd.type = E820_ACPI;
> +	flags = IORESOURCE_MEM | IORESOURCE_BUSY;
> +	walk_ram_res("ACPI Tables", flags, 0, -1, &cmd, memmap_entry_callback);
> +
> +	/* Add ACPI Non-volatile Storage */
> +	cmd.type = E820_NVS;
> +	walk_ram_res("ACPI Non-volatile Storage", flags, 0, -1, &cmd,
> +			memmap_entry_callback);
> +
> +	/* Add crashk_low_res region */
> +	if (crashk_low_res.end) {
> +		ei.addr = crashk_low_res.start;
> +		ei.size = crashk_low_res.end - crashk_low_res.start + 1;
> +		ei.type = E820_RAM;
> +		add_e820_entry(params, &ei);
> +	}
> +
> +	/* Exclude some ranges from crashk_res and add rest to memmap */
> +	ret = memmap_exclude_ranges(image, cmem, crashk_res.start,
> +						crashk_res.end);
> +	if (ret)
> +		goto out;
> +
> +	for (i = 0; i < cmem->nr_ranges; i++) {
> +		ei.addr = cmem->ranges[i].start;
> +		ei.size = cmem->ranges[i].end - ei.addr + 1;
> +		ei.type = E820_RAM;
> +
> +		/* If entry is less than a page, skip it */
> +		if (ei.size < PAGE_SIZE)
> +			continue;

You can do the size assignment and check first so that you don't have to
do the rest if it is a less than a page.

> +		add_e820_entry(params, &ei);
> +	}
> +
> +out:
> +	vfree(cmem);
> +	return ret;

This retval is not checked at the callsite in
kexec_setup_boot_parameters().

> +}
> +
> +static int determine_backup_region(u64 start, u64 end, void *arg)
> +{
> +	struct kimage *image = arg;
> +
> +	image->arch.backup_src_start = start;
> +	image->arch.backup_src_sz = end - start + 1;
> +
> +	/* Expecting only one range for backup region */
> +	return 1;
> +}
> +
> +int load_crashdump_segments(struct kimage *image)
> +{
> +	unsigned long src_start, src_sz, elf_sz;
> +	void *elf_addr;
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
> +		/*
> +		 * Ideally there is no source for backup segment. This is
> +		 * copied in purgatory after crash. Just add a zero filled
> +		 * segment for now to make sure checksum logic works fine.
> +		 */
> +		ret = kexec_add_buffer(image, (char *)&crash_zero_bytes,
> +				       sizeof(crash_zero_bytes), src_sz,
> +				       PAGE_SIZE, 0, -1, 0,
> +				       &image->arch.backup_load_addr);
> +		if (ret)
> +			return ret;
> +		pr_debug("Loaded backup region at 0x%lx backup_start=0x%lx memsz=0x%lx\n",
> +			 image->arch.backup_load_addr, src_start, src_sz);
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
> +			ELF_CORE_HEADER_ALIGN, 0, -1, 0,
> +			&image->arch.elf_load_addr);
> +	if (ret) {
> +		vfree((void *)image->arch.elf_headers);
> +		return ret;
> +	}
> +	pr_debug("Loaded ELF headers at 0x%lx bufsz=0x%lx memsz=0x%lx\n",
> +		 image->arch.elf_load_addr, elf_sz, elf_sz);
> +
> +	return ret;
> +}
> +
> +#endif /* CONFIG_X86_64 */
> diff --git a/arch/x86/kernel/kexec-bzimage.c b/arch/x86/kernel/kexec-bzimage.c
> index 0750784..8e762d3 100644
> --- a/arch/x86/kernel/kexec-bzimage.c
> +++ b/arch/x86/kernel/kexec-bzimage.c
> @@ -18,6 +18,9 @@
>  
>  #include <asm/bootparam.h>
>  #include <asm/setup.h>
> +#include <asm/crash.h>
> +
> +#define MAX_ELFCOREHDR_STR_LEN	30	/* elfcorehdr=0x<64bit-value> */
>  
>  /*
>   * Defines lowest physical address for various segments. Not sure where
> @@ -130,11 +133,28 @@ void *bzImage64_load(struct kimage *image, char *kernel,
>  		return ERR_PTR(-EINVAL);
>  	}
>  
> +	/*
> +	 * In case of crash dump, we will append elfcorehdr=<addr> to
> +	 * command line. Make sure it does not overflow
> +	 */
> +	if (cmdline_len + MAX_ELFCOREHDR_STR_LEN > header->cmdline_size) {
> +		ret = -EINVAL;

No need to assign anything to ret if you return ERR_PTR below.

> +		pr_debug("Kernel command line too long\n");

This error message needs to differ from the one above - say something
about "error appending elfcorehdr=...", for example.

> +		return ERR_PTR(-EINVAL);
> +	}
> +
>  	/* Allocate loader specific data */
>  	ldata = kzalloc(sizeof(struct bzimage64_data), GFP_KERNEL);
>  	if (!ldata)
>  		return ERR_PTR(-ENOMEM);
>  
> +	/* Allocate and load backup region */
> +	if (image->type == KEXEC_TYPE_CRASH) {
> +		ret = load_crashdump_segments(image);
> +		if (ret)
> +			goto out_free_loader_data;
> +	}
> +
>  	/*
>  	 * Load purgatory. For 64bit entry point, purgatory  code can be
>  	 * anywhere.
> @@ -149,7 +169,8 @@ void *bzImage64_load(struct kimage *image, char *kernel,
>  	pr_debug("Loaded purgatory at 0x%lx\n", purgatory_load_addr);
>  
>  	/* Load Bootparams and cmdline */
> -	params_cmdline_sz = sizeof(struct boot_params) + cmdline_len;
> +	params_cmdline_sz = sizeof(struct boot_params) + cmdline_len +
> +				MAX_ELFCOREHDR_STR_LEN;
>  	params = kzalloc(params_cmdline_sz, GFP_KERNEL);
>  	if (!params) {
>  		ret = -ENOMEM;
> @@ -201,7 +222,7 @@ void *bzImage64_load(struct kimage *image, char *kernel,
>  			goto out_free_params;
>  	}
>  
> -	ret = kexec_setup_cmdline(params, bootparam_load_addr,
> +	ret = kexec_setup_cmdline(image, params, bootparam_load_addr,
>  				  sizeof(struct boot_params), cmdline,
>  				  cmdline_len);
>  	if (ret)
> @@ -233,7 +254,7 @@ void *bzImage64_load(struct kimage *image, char *kernel,
>  	if (ret)
>  		goto out_free_params;
>  
> -	ret = kexec_setup_boot_parameters(params);
> +	ret = kexec_setup_boot_parameters(image, params);
>  	if (ret)
>  		goto out_free_params;
>  
> diff --git a/arch/x86/kernel/machine_kexec.c b/arch/x86/kernel/machine_kexec.c
> index 7de3239..6a3821b 100644
> --- a/arch/x86/kernel/machine_kexec.c
> +++ b/arch/x86/kernel/machine_kexec.c
> @@ -10,9 +10,11 @@
>   */
>  
>  #include <linux/kernel.h>
> +#include <linux/kexec.h>
>  #include <linux/string.h>
>  #include <asm/bootparam.h>
>  #include <asm/setup.h>
> +#include <asm/crash.h>
>  
>  /*
>   * Common code for x86 and x86_64 used for kexec.
> @@ -36,18 +38,24 @@ int kexec_setup_initrd(struct boot_params *params,
>  	return 0;
>  }
>  
> -int kexec_setup_cmdline(struct boot_params *params,
> +int kexec_setup_cmdline(struct kimage *image, struct boot_params *params,
>  		unsigned long bootparams_load_addr,
>  		unsigned long cmdline_offset, char *cmdline,
>  		unsigned long cmdline_len)
>  {
>  	char *cmdline_ptr = ((char *)params) + cmdline_offset;
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
> +	pr_debug("Final command line is: %s\n", cmdline_ptr);
>  	cmdline_ptr_phys = bootparams_load_addr + cmdline_offset;
>  	cmdline_low_32 = cmdline_ptr_phys & 0xffffffffUL;
>  	cmdline_ext_32 = cmdline_ptr_phys >> 32;
> @@ -75,7 +83,8 @@ static int setup_memory_map_entries(struct boot_params *params)
>  	return 0;
>  }
>  
> -int kexec_setup_boot_parameters(struct boot_params *params)
> +int kexec_setup_boot_parameters(struct kimage *image,
> +				struct boot_params *params)
>  {
>  	unsigned int nr_e820_entries;
>  	unsigned long long mem_k, start, end;
> @@ -102,7 +111,11 @@ int kexec_setup_boot_parameters(struct boot_params *params)
>  	/* Default sysdesc table */
>  	params->sys_desc_table.length = 0;
>  
> -	setup_memory_map_entries(params);
> +	if (image->type == KEXEC_TYPE_CRASH)
> +		crash_setup_memmap_entries(image, params);
> +	else
> +		setup_memory_map_entries(params);
> +
>  	nr_e820_entries = params->e820_entries;
>  
>  	for (i = 0; i < nr_e820_entries; i++) {
> diff --git a/arch/x86/kernel/machine_kexec_64.c b/arch/x86/kernel/machine_kexec_64.c
> index a66fae3..07e4b60 100644
> --- a/arch/x86/kernel/machine_kexec_64.c
> +++ b/arch/x86/kernel/machine_kexec_64.c
> @@ -179,6 +179,38 @@ static void load_segments(void)
>  		);
>  }
>  
> +/* Update purgatory as needed after various image segments have been prepared */
> +static int arch_update_purgatory(struct kimage *image)
> +{
> +	int ret = 0;
> +
> +	if (!image->file_mode)
> +		return 0;
> +
> +	/* Setup copying of backup region */
> +	if (image->type == KEXEC_TYPE_CRASH) {
> +		ret = kexec_purgatory_get_set_symbol(image, "backup_dest",
> +				&image->arch.backup_load_addr,
> +				sizeof(image->arch.backup_load_addr), 0);
> +		if (ret)
> +			return ret;
> +
> +		ret = kexec_purgatory_get_set_symbol(image, "backup_src",
> +				&image->arch.backup_src_start,
> +				sizeof(image->arch.backup_src_start), 0);
> +		if (ret)
> +			return ret;
> +
> +		ret = kexec_purgatory_get_set_symbol(image, "backup_sz",
> +				&image->arch.backup_src_sz,
> +				sizeof(image->arch.backup_src_sz), 0);

Arg alignment is funny.

> +		if (ret)
> +			return ret;
> +	}
> +
> +	return ret;
> +}
> +
>  int machine_kexec_prepare(struct kimage *image)
>  {
>  	unsigned long start_pgtable;
-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
