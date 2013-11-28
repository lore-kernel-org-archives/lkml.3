Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758520Ab3K1L3V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 06:29:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25660 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758228Ab3K1L3T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 06:29:19 -0500
Date: Thu, 28 Nov 2013 19:28:16 +0800
From: Baoquan He <bhe@redhat.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        mjg59@srcf.ucam.org, greg@kroah.com, ebiederm@xmission.com,
        hpa@zytor.com
Subject: Re: [PATCH 6/6] kexec: Support for Kexec on panic using new system
 call
Message-ID: <20131128112816.GC4318@dhcp-16-252.nay.redhat.com>
References: <1384969851-7251-1-git-send-email-vgoyal@redhat.com>
 <1384969851-7251-7-git-send-email-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384969851-7251-7-git-send-email-vgoyal@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/20/13 at 12:50pm, Vivek Goyal wrote:
> This patch adds support for loading a kexec on panic (kdump) kernel usning
> new system call.
> 
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  arch/x86/include/asm/crash.h       |    9 +
>  arch/x86/include/asm/kexec.h       |   17 +
>  arch/x86/kernel/crash.c            |  585 ++++++++++++++++++++++++++++++++++++
>  arch/x86/kernel/kexec-bzimage.c    |   63 ++++-
>  arch/x86/kernel/machine_kexec_64.c |    1 +
>  kernel/kexec.c                     |   69 ++++-
>  6 files changed, 731 insertions(+), 13 deletions(-)
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
> +int crash_copy_backup_region(struct kimage *image);
> +int crash_setup_memmap_entries(struct kimage *image,
> +		struct boot_params *params);
> +
> +#endif /* _ASM_X86_CRASH_H */
> diff --git a/arch/x86/include/asm/kexec.h b/arch/x86/include/asm/kexec.h
> index 94f1257..9dc19fe 100644
> --- a/arch/x86/include/asm/kexec.h
> +++ b/arch/x86/include/asm/kexec.h
> @@ -64,6 +64,10 @@
>  # define KEXEC_ARCH KEXEC_ARCH_X86_64
>  #endif
>  
> +/* Memory to backup during crash kdump */
> +#define KEXEC_BACKUP_SRC_START	(0UL)
> +#define KEXEC_BACKUP_SRC_END	(655360UL)	/* 640K */
> +
>  /*
>   * CPU does not save ss and sp on stack if execution is already
>   * running in kernel mode at the time of NMI occurrence. This code
> @@ -166,8 +170,21 @@ struct kimage_arch {
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
> diff --git a/arch/x86/kernel/crash.c b/arch/x86/kernel/crash.c
> index 18677a9..d5d3118 100644
> --- a/arch/x86/kernel/crash.c
> +++ b/arch/x86/kernel/crash.c
> @@ -4,6 +4,9 @@
>   * Created by: Hariprasad Nellitheertha (hari@in.ibm.com)
>   *
>   * Copyright (C) IBM Corporation, 2004. All rights reserved.
> + * Copyright (C) Red Hat Inc., 2013. All rights reserved.
> + * Authors:
> + * 	Vivek Goyal <vgoyal@redhat.com>
>   *
>   */
>  
> @@ -17,6 +20,7 @@
>  #include <linux/elf.h>
>  #include <linux/elfcore.h>
>  #include <linux/module.h>
> +#include <linux/slab.h>
>  
>  #include <asm/processor.h>
>  #include <asm/hardirq.h>
> @@ -29,6 +33,45 @@
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
> +struct crash_memmap_data {
> +	struct boot_params *params;
> +	/* Type of memory */
> +	unsigned int type;
> +};
> +
>  int in_crash_kexec;
>  
>  /*
> @@ -138,3 +181,545 @@ void native_machine_crash_shutdown(struct pt_regs *regs)
>  #endif
>  	crash_save_cpu(regs, safe_smp_processor_id());
>  }
> +
> +#ifdef CONFIG_X86_64
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
> +				for(j = i; j < mem->nr_ranges - 1; j++) {
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
> +	if (!temp_range.end)
> +		return 0;
> +
> +	/* Split happened */
> +	if (i == CRASH_MAX_RANGES - 1) {
> +		printk("Too many crash ranges after split\n");
> +		return -ENOMEM;
> +	}
> +
> +	/* Location where new range should go */
> +	j = i + 1;
> +	if (j < mem->nr_ranges) {
> +		/* Move over all ranges one place */
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
> +		pr_debug("Crash PT_LOAD elf header. phdr=%p"
> +			" vaddr=0x%llx, paddr=0x%llx, sz=0x%llx e_phnum=%d"
> +			" p_offset=0x%llx\n", phdr, phdr->p_vaddr,
> +			phdr->p_paddr, phdr->p_filesz, ehdr->e_phnum,
> +			phdr->p_offset);
> +	}
> +
> +	return ret;
> +}
> +
> +static int prepare_elf64_headers(struct crash_elf_data *ced,
> +		unsigned long *addr, unsigned long *sz)
> +{
> +	Elf64_Ehdr *ehdr;
> +	Elf64_Phdr *phdr;
> +	unsigned long nr_cpus = NR_CPUS, nr_phdr, elf_sz;
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
> +	*addr = (unsigned long)buf;
> +	*sz = elf_sz;
> +	return 0;
> +}
> +
> +/* Prepare elf headers. Return addr and size */
> +static int prepare_elf_headers(struct kimage *image, unsigned long *addr,
> +					unsigned long *sz)
> +{
> +	struct crash_elf_data *ced;
> +	int ret;
> +
> +	ced = kzalloc(sizeof(*ced), GFP_KERNEL);
> +	if (!ced)
> +		return -ENOMEM;
> +
> +	ret = fill_up_ced(ced, image);
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
> +
> +	memcpy(&params->e820_map[nr_e820_entries], entry,
> +                        sizeof(struct e820entry));
> +	params->e820_entries++;
> +
> +	pr_debug("Add e820 entry to bootparams. addr=0x%llx size=0x%llx"
> +		" type=%d\n", entry->addr, entry->size, entry->type);
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
> +		if (ei.size < PAGE_SIZE) {
> +			continue;
> +		}
> +		add_e820_entry(params, &ei);
> +	}
> +
> +out:
> +	vfree(cmem);
> +	return ret;
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
> +	/* Zero of postive return values are ok */
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
> +			ELF_CORE_HEADER_ALIGN, 0, -1, 0,
> +			&image->arch.elf_load_addr);
> +	if (ret)
> +		kfree((void *)image->arch.elf_headers);
> +
> +	return ret;
> +}
> +
> +int crash_copy_backup_region(struct kimage *image)
> +{

Why need this func be called, backup region has been added into crash
segment by kexec_add_buffer, and then buffer copy is done in
kimage_load_crash_segment. I think this copy is handled twice. Please
correct me if I am wrong.



> +	unsigned long dest_start, src_start, src_sz;
> +
> +	dest_start = image->arch.backup_load_addr;
> +	src_start = image->arch.backup_src_start;
> +	src_sz = image->arch.backup_src_sz;
> +
> +	memcpy(__va(dest_start), __va(src_start), src_sz);
> +
> +	return 0;
> +}
> +#endif /* CONFIG_X86_64 */
> diff --git a/arch/x86/kernel/kexec-bzimage.c b/arch/x86/kernel/kexec-bzimage.c
> index a1032d4..606942c 100644
> --- a/arch/x86/kernel/kexec-bzimage.c
> +++ b/arch/x86/kernel/kexec-bzimage.c
> @@ -8,6 +8,9 @@
>  
>  #include <asm/bootparam.h>
>  #include <asm/setup.h>
> +#include <asm/crash.h>
> +
> +#define MAX_ELFCOREHDR_STR_LEN	30 	/* elfcorehdr=0x<64bit-value> */
>  
>  #ifdef CONFIG_X86_64
>  
> @@ -86,7 +89,8 @@ static int setup_memory_map_entries(struct boot_params *params)
>  	return 0;
>  }
>  
> -static void setup_linux_system_parameters(struct boot_params *params)
> +static void setup_linux_system_parameters(struct kimage *image,
> +			struct boot_params *params)
>  {
>  	unsigned int nr_e820_entries;
>  	unsigned long long mem_k, start, end;
> @@ -113,7 +117,10 @@ static void setup_linux_system_parameters(struct boot_params *params)
>  	/* Default sysdesc table */
>  	params->sys_desc_table.length = 0;
>  
> -	setup_memory_map_entries(params);
> +	if (image->type == KEXEC_TYPE_CRASH)
> +		crash_setup_memmap_entries(image, params);
> +	else
> +		setup_memory_map_entries(params);
>  	nr_e820_entries = params->e820_entries;
>  
>  	for(i = 0; i < nr_e820_entries; i++) {
> @@ -151,18 +158,23 @@ static void setup_initrd(struct boot_params *boot_params, unsigned long initrd_l
>  	boot_params->ext_ramdisk_size = initrd_len >> 32;
>  }
>  
> -static void setup_cmdline(struct boot_params *boot_params,
> +static void setup_cmdline(struct kimage *image, struct boot_params *boot_params,
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
> -
> +	pr_debug("Final command line is:%s\n", cmdline_ptr);
>  	cmdline_ptr_phys = bootparams_load_addr + cmdline_offset;
>  	cmdline_low_32 = cmdline_ptr_phys & 0xffffffffUL;
>  	cmdline_ext_32 = cmdline_ptr_phys >> 32;
> @@ -203,17 +215,34 @@ void *bzImage64_load(struct kimage *image, char *kernel,
>  		return ERR_PTR(-EINVAL);
>  	}
>  
> +	/*
> +	 * In case of crash dump, we will append elfcorehdr=<addr> to
> +	 * command line. Make sure it does not overflow
> +	 */
> +	if (cmdline_len + MAX_ELFCOREHDR_STR_LEN > header->cmdline_size) {
> +		ret = -EINVAL;
> +		pr_debug("Kernel command line too long\n");
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
>  	/* Argument/parameter segment */
>  	kern16_size_needed = kern16_size;
>  	if (kern16_size_needed < 4096)
>  		kern16_size_needed = 4096;
>  
> -	setup_size = kern16_size_needed + cmdline_len;
> +	setup_size = kern16_size_needed + cmdline_len + MAX_ELFCOREHDR_STR_LEN;
>  	params = kzalloc(setup_size, GFP_KERNEL);
>  	if (!params) {
>  		ret = -ENOMEM;
> @@ -259,14 +288,14 @@ void *bzImage64_load(struct kimage *image, char *kernel,
>  		setup_initrd(params, initrd_load_addr, initrd_len);
>  	}
>  
> -	setup_cmdline(params, bootparam_load_addr, kern16_size_needed,
> +	setup_cmdline(image, params, bootparam_load_addr, kern16_size_needed,
>  			cmdline, cmdline_len);
>  
>  	/* bootloader info. Do we need a separate ID for kexec kernel loader? */
>  	params->hdr.type_of_loader = 0x0D << 4;
>  	params->hdr.loadflags = 0;
>  
> -	setup_linux_system_parameters(params);
> +	setup_linux_system_parameters(image, params);
>  
>  	/*
>  	 * Allocate a purgatory page. For 64bit entry point, purgatory
> @@ -302,7 +331,7 @@ out_free_loader_data:
>  	return ERR_PTR(ret);
>  }
>  
> -int bzImage64_prep_entry(struct kimage *image)
> +static int prepare_purgatory(struct kimage *image)
>  {
>  	struct bzimage64_data *ldata;
>  	char *purgatory_page;
> @@ -362,6 +391,22 @@ int bzImage64_prep_entry(struct kimage *image)
>  	return 0;
>  }
>  
> +int bzImage64_prep_entry(struct kimage *image)
> +{
> +	if (!image->file_mode)
> +		return 0;
> +
> +	if (!image->image_loader_data)
> +		return -EINVAL;
> +
> +	prepare_purgatory(image);
> +
> +	if (image->type == KEXEC_TYPE_CRASH)
> +		crash_copy_backup_region(image);
> +
> +	return 0;
> +}
> +
>  /* This cleanup function is called after various segments have been loaded */
>  int bzImage64_cleanup(struct kimage *image)
>  {
> diff --git a/arch/x86/kernel/machine_kexec_64.c b/arch/x86/kernel/machine_kexec_64.c
> index a66ce1d..9d7a42d 100644
> --- a/arch/x86/kernel/machine_kexec_64.c
> +++ b/arch/x86/kernel/machine_kexec_64.c
> @@ -334,6 +334,7 @@ int arch_image_file_post_load_cleanup(struct kimage *image)
>  {
>  	int idx = image->file_handler_idx;
>  
> +	vfree((void *)image->arch.elf_headers);
>  	if (kexec_file_type[idx].cleanup)
>  		return kexec_file_type[idx].cleanup(image);
>  	return 0;
> diff --git a/kernel/kexec.c b/kernel/kexec.c
> index 50bcaa8..64184a7 100644
> --- a/kernel/kexec.c
> +++ b/kernel/kexec.c
> @@ -524,7 +524,6 @@ static int kimage_normal_alloc(struct kimage **rimage, unsigned long entry,
>  	*rimage = image;
>  	return 0;
>  
> -
>  out_free_control_pages:
>  	kimage_free_page_list(&image->control_pages);
>  out_free_image:
> @@ -532,6 +531,54 @@ out_free_image:
>  	return result;
>  }
>  
> +static int kimage_file_crash_alloc(struct kimage **rimage, int kernel_fd,
> +		int initrd_fd, const char __user *cmdline_ptr,
> +		unsigned long cmdline_len)
> +{
> +	int result;
> +	struct kimage *image;
> +
> +	/* Allocate and initialize a controlling structure */
> +	image = do_kimage_alloc_init();
> +	if (!image)
> +		return -ENOMEM;
> +
> +	image->file_mode = 1;
> +	image->file_handler_idx = -1;
> +
> +	/* Enable the special crash kernel control page allocation policy. */
> +	image->control_page = crashk_res.start;
> +	image->type = KEXEC_TYPE_CRASH;
> +
> +	result = kimage_file_prepare_segments(image, kernel_fd, initrd_fd,
> +			cmdline_ptr, cmdline_len);
> +	if (result)
> +		goto out_free_image;
> +
> +	result = sanity_check_segment_list(image);
> +	if (result)
> +		goto out_free_post_load_bufs;
> +
> +	result = -ENOMEM;
> +	image->control_code_page = kimage_alloc_control_pages(image,
> +					   get_order(KEXEC_CONTROL_PAGE_SIZE));
> +	if (!image->control_code_page) {
> +		printk(KERN_ERR "Could not allocate control_code_buffer\n");
> +		goto out_free_post_load_bufs;
> +	}
> +
> +	*rimage = image;
> +	return 0;
> +
> +out_free_post_load_bufs:
> +	kimage_file_post_load_cleanup(image);
> +	kfree(image->image_loader_data);
> +out_free_image:
> +	kfree(image);
> +	return result;
> +}
> +
> +
>  static int kimage_crash_alloc(struct kimage **rimage, unsigned long entry,
>  				unsigned long nr_segments,
>  				struct kexec_segment __user *segments)
> @@ -1130,7 +1177,12 @@ static int kimage_load_crash_segment(struct kimage *image,
>  			/* Zero the trailing part of the page */
>  			memset(ptr + uchunk, 0, mchunk - uchunk);
>  		}
> -		result = copy_from_user(ptr, buf, uchunk);
> +
> +		/* For file based kexec, source pages are in kernel memory */
> +		if (image->file_mode)
> +			memcpy(ptr, buf, uchunk);
> +		else
> +			result = copy_from_user(ptr, buf, uchunk);
>  		kexec_flush_icache_page(page);
>  		kunmap(page);
>  		if (result) {
> @@ -1358,7 +1410,11 @@ SYSCALL_DEFINE5(kexec_file_load, int, kernel_fd, int, initrd_fd, const char __us
>  	if (flags & KEXEC_FILE_UNLOAD)
>  		goto exchange;
>  
> -	ret = kimage_file_normal_alloc(&image, kernel_fd, initrd_fd,
> +	if (flags & KEXEC_FILE_ON_CRASH)
> +		ret = kimage_file_crash_alloc(&image, kernel_fd, initrd_fd,
> +				cmdline_ptr, cmdline_len);
> +	else
> +		ret = kimage_file_normal_alloc(&image, kernel_fd, initrd_fd,
>  				cmdline_ptr, cmdline_len);
>  	if (ret)
>  		goto out;
> @@ -2108,7 +2164,12 @@ int kexec_add_buffer(struct kimage *image, char *buffer,
>  	kbuf->top_down = top_down;
>  
>  	/* Walk the RAM ranges and allocate a suitable range for the buffer */
> -	walk_system_ram_res(0, -1, kbuf, walk_ram_range_callback);
> +	if (image->type == KEXEC_TYPE_CRASH)
> +		walk_ram_res("Crash kernel", IORESOURCE_MEM | IORESOURCE_BUSY,
> +				crashk_res.start, crashk_res.end, kbuf,
> +				walk_ram_range_callback);
> +	else
> +		walk_system_ram_res(0, -1, kbuf, walk_ram_range_callback);
>  
>  	kbuf->image = NULL;
>  	kfree(kbuf);
> -- 
> 1.7.7.6
> 
> 
> _______________________________________________
> kexec mailing list
> kexec@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kexec
