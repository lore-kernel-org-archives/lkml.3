Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759262Ab3K1LgQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 06:36:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47339 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758636Ab3K1LgL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 06:36:11 -0500
Date: Thu, 28 Nov 2013 19:35:14 +0800
From: Baoquan He <bhe@redhat.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        mjg59@srcf.ucam.org, greg@kroah.com, ebiederm@xmission.com,
        hpa@zytor.com
Subject: Re: [PATCH 5/6] kexec-bzImage: Support for loading bzImage using
 64bit entry
Message-ID: <20131128113514.GD4318@dhcp-16-252.nay.redhat.com>
References: <1384969851-7251-1-git-send-email-vgoyal@redhat.com>
 <1384969851-7251-6-git-send-email-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384969851-7251-6-git-send-email-vgoyal@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/20/13 at 12:50pm, Vivek Goyal wrote:
> This is loader specific code which can load bzImage and set it up for
> 64bit entry. This does not take care of 32bit entry or real mode entry
> yet.
> 
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  arch/x86/include/asm/kexec-bzimage.h |   12 +
>  arch/x86/include/asm/kexec.h         |   26 +++
>  arch/x86/kernel/Makefile             |    2 +
>  arch/x86/kernel/kexec-bzimage.c      |  375 ++++++++++++++++++++++++++++++++++
>  arch/x86/kernel/machine_kexec_64.c   |    4 +-
>  arch/x86/kernel/purgatory_entry_64.S |  119 +++++++++++
>  6 files changed, 537 insertions(+), 1 deletions(-)
>  create mode 100644 arch/x86/include/asm/kexec-bzimage.h
>  create mode 100644 arch/x86/kernel/kexec-bzimage.c
>  create mode 100644 arch/x86/kernel/purgatory_entry_64.S
> 
> diff --git a/arch/x86/include/asm/kexec-bzimage.h b/arch/x86/include/asm/kexec-bzimage.h
> new file mode 100644
> index 0000000..d556727
> --- /dev/null
> +++ b/arch/x86/include/asm/kexec-bzimage.h
> @@ -0,0 +1,12 @@
> +#ifndef _ASM_BZIMAGE_H
> +#define _ASM_BZIMAGE_H
> +
> +extern int bzImage64_probe(const char *buf, unsigned long len);
> +extern void *bzImage64_load(struct kimage *image, char *kernel,
> +		unsigned long kernel_len, char *initrd,
> +		unsigned long initrd_len, char *cmdline,
> +		unsigned long cmdline_len);
> +extern int bzImage64_prep_entry(struct kimage *image);
> +extern int bzImage64_cleanup(struct kimage *image);
> +
> +#endif  /* _ASM_BZIMAGE_H */
> diff --git a/arch/x86/include/asm/kexec.h b/arch/x86/include/asm/kexec.h
> index 17483a4..94f1257 100644
> --- a/arch/x86/include/asm/kexec.h
> +++ b/arch/x86/include/asm/kexec.h
> @@ -15,6 +15,9 @@
>  # define PAGES_NR		4
>  #endif
>  
> +#define KEXEC_PURGATORY_PAGE_SIZE	4096
> +#define KEXEC_PURGATORY_CODE_MAX_SIZE	2048
> +
>  # define KEXEC_CONTROL_CODE_MAX_SIZE	2048
>  
>  #ifndef __ASSEMBLY__
> @@ -141,6 +144,9 @@ relocate_kernel(unsigned long indirection_page,
>  		unsigned long page_list,
>  		unsigned long start_address,
>  		unsigned int preserve_context);
> +void purgatory_entry64(void);
> +extern unsigned long purgatory_entry64_regs;
> +extern struct desc_struct entry64_gdt;
>  #endif
>  
>  #define ARCH_HAS_KIMAGE_ARCH
> @@ -161,6 +167,26 @@ struct kimage_arch {
>  	pmd_t *pmd;
>  	pte_t *pte;
>  };
> +
> +struct kexec_entry64_regs {
> +	uint64_t rax;
> +	uint64_t rbx;
> +	uint64_t rcx;
> +	uint64_t rdx;
> +	uint64_t rsi;
> +	uint64_t rdi;
> +	uint64_t rsp;
> +	uint64_t rbp;
> +	uint64_t r8;
> +	uint64_t r9;
> +	uint64_t r10;
> +	uint64_t r11;
> +	uint64_t r12;
> +	uint64_t r13;
> +	uint64_t r14;
> +	uint64_t r15;
> +	uint64_t rip;
> +};
>  #endif
>  
>  typedef void crash_vmclear_fn(void);
> diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
> index 9b0a34e..5d074c2 100644
> --- a/arch/x86/kernel/Makefile
> +++ b/arch/x86/kernel/Makefile
> @@ -68,6 +68,7 @@ obj-$(CONFIG_FTRACE_SYSCALLS)	+= ftrace.o
>  obj-$(CONFIG_X86_TSC)		+= trace_clock.o
>  obj-$(CONFIG_KEXEC)		+= machine_kexec_$(BITS).o
>  obj-$(CONFIG_KEXEC)		+= relocate_kernel_$(BITS).o crash.o
> +obj-$(CONFIG_KEXEC)		+= kexec-bzimage.o
>  obj-$(CONFIG_CRASH_DUMP)	+= crash_dump_$(BITS).o
>  obj-y				+= kprobes/
>  obj-$(CONFIG_MODULES)		+= module.o
> @@ -122,4 +123,5 @@ ifeq ($(CONFIG_X86_64),y)
>  
>  	obj-$(CONFIG_PCI_MMCONFIG)	+= mmconf-fam10h_64.o
>  	obj-y				+= vsmp_64.o
> +	obj-$(CONFIG_KEXEC)		+= purgatory_entry_64.o
>  endif
> diff --git a/arch/x86/kernel/kexec-bzimage.c b/arch/x86/kernel/kexec-bzimage.c
> new file mode 100644
> index 0000000..a1032d4
> --- /dev/null
> +++ b/arch/x86/kernel/kexec-bzimage.c
> @@ -0,0 +1,375 @@
> +#include <linux/string.h>
> +#include <linux/printk.h>
> +#include <linux/errno.h>
> +#include <linux/slab.h>
> +#include <linux/kexec.h>
> +#include <linux/kernel.h>
> +#include <linux/mm.h>
> +
> +#include <asm/bootparam.h>
> +#include <asm/setup.h>
> +
> +#ifdef CONFIG_X86_64
> +
> +struct bzimage64_data {
> +	unsigned long kernel_load_addr;
> +	unsigned long bootparams_load_addr;
> +
> +	/*
> +	 * Temporary buffer to hold bootparams buffer. This should be
> +	 * freed once the bootparam segment has been loaded.
> +	 */
> +	void *bootparams_buf;
> +	struct page *purgatory_page;
> +};
> +
> +int bzImage64_probe(const char *buf, unsigned long len)
> +{
> +	int ret = -ENOEXEC;
> +	struct setup_header *header;
> +
> +	if (len < 2 * 512) {
> +		pr_debug("File is too short to be a bzImage\n");
> +		return ret;
> +	}
> +
> +	header = (struct setup_header *)(buf + 0x1F1);
> +	if (memcmp((char *)&header->header, "HdrS", 4) != 0) {
> +		pr_debug("Not a bzImage\n");
> +		return ret;
> +	}
> +
> +	if (header->boot_flag != 0xAA55) {
> +                /* No x86 boot sector present */
> +		pr_debug("No x86 boot sector present\n");
> +		return ret;
> +	}
> +
> +	if (header->version < 0x020C) {
> +                /* Must be at least protocol version 2.12 */
> +		pr_debug("Must be at least protocol version 2.12\n");
> +		return ret;
> +	}
> +
> +	if ((header->loadflags & 1) == 0) {
> +		/* Not a bzImage */
> +		pr_debug("zImage not a bzImage\n");
> +		return ret;
> +	}
> +
> +	if ((header->xloadflags & 3) != 3) {
> +		/* XLF_KERNEL_64 and XLF_CAN_BE_LOADED_ABOVE_4G should be set */
> +		pr_debug("Not a relocatable bzImage64\n");
> +		return ret;
> +	}
> +
> +        /* I've got a bzImage */
> +	pr_debug("It's a relocatable bzImage64\n");
> +	ret = 0;
> +
> +	return ret;
> +}
> +
> +static int setup_memory_map_entries(struct boot_params *params)
> +{
> +	unsigned int nr_e820_entries;
> +
> +	/* TODO: What about EFI */
> +	nr_e820_entries = e820_saved.nr_map;
> +	if (nr_e820_entries > E820MAX)
> +		nr_e820_entries = E820MAX;
> +
> +	params->e820_entries = nr_e820_entries;
> +	memcpy(&params->e820_map, &e820_saved.map,
> +			nr_e820_entries * sizeof(struct e820entry));
> +
> +	return 0;
> +}
> +
> +static void setup_linux_system_parameters(struct boot_params *params)
> +{
> +	unsigned int nr_e820_entries;
> +	unsigned long long mem_k, start, end;
> +	int i;
> +
> +	/* Get subarch from existing bootparams */
> +	params->hdr.hardware_subarch = boot_params.hdr.hardware_subarch;
> +
> +	/* Copying screen_info will do? */
> +	memcpy(&params->screen_info, &boot_params.screen_info,
> +				sizeof(struct screen_info));
> +
> +	/* Fill in memsize later */
> +	params->screen_info.ext_mem_k = 0;
> +	params->alt_mem_k = 0;
> +
> +	/* Default APM info */
> +	memset(&params->apm_bios_info, 0, sizeof(params->apm_bios_info));
> +
> +	/* Default drive info */
> +	memset(&params->hd0_info, 0, sizeof(params->hd0_info));
> +	memset(&params->hd1_info, 0, sizeof(params->hd1_info));
> +
> +	/* Default sysdesc table */
> +	params->sys_desc_table.length = 0;
> +
> +	setup_memory_map_entries(params);
> +	nr_e820_entries = params->e820_entries;
> +
> +	for(i = 0; i < nr_e820_entries; i++) {
> +		if (params->e820_map[i].type != E820_RAM)
> +			continue;
> +		start = params->e820_map[i].addr;
> +		end = params->e820_map[i].addr + params->e820_map[i].size - 1;
> +
> +		if ((start <= 0x100000) && end > 0x100000) {
> +			mem_k = (end >> 10) - (0x100000 >> 10);
> +			params->screen_info.ext_mem_k = mem_k;
> +			params->alt_mem_k = mem_k;
> +			if (mem_k > 0xfc00)
> +				params->screen_info.ext_mem_k = 0xfc00; /* 64M*/
> +			if (mem_k > 0xffffffff)
> +				params->alt_mem_k = 0xffffffff;
> +		}
> +	}
> +
> +	/* Setup EDD info */
> +	memcpy(params->eddbuf, boot_params.eddbuf,
> +				EDDMAXNR * sizeof(struct edd_info));
> +	params->eddbuf_entries = boot_params.eddbuf_entries;
> +
> +	memcpy(params->edd_mbr_sig_buffer, boot_params.edd_mbr_sig_buffer,
> +			EDD_MBR_SIG_MAX * sizeof(unsigned int));
> +}
> +
> +static void setup_initrd(struct boot_params *boot_params, unsigned long initrd_load_addr, unsigned long initrd_len)
> +{
> +	boot_params->hdr.ramdisk_image = initrd_load_addr & 0xffffffffUL;
> +	boot_params->hdr.ramdisk_size = initrd_len & 0xffffffffUL;
> +
> +	boot_params->ext_ramdisk_image = initrd_load_addr >> 32;
> +	boot_params->ext_ramdisk_size = initrd_len >> 32;
> +}
> +
> +static void setup_cmdline(struct boot_params *boot_params,
> +		unsigned long bootparams_load_addr,
> +		unsigned long cmdline_offset, char *cmdline,
> +		unsigned long cmdline_len)
> +{
> +	char *cmdline_ptr = ((char *)boot_params) + cmdline_offset;
> +	unsigned long cmdline_ptr_phys;
> +	uint32_t cmdline_low_32, cmdline_ext_32;
> +
> +	memcpy(cmdline_ptr, cmdline, cmdline_len);
> +	cmdline_ptr[cmdline_len - 1] = '\0';
> +
> +	cmdline_ptr_phys = bootparams_load_addr + cmdline_offset;
> +	cmdline_low_32 = cmdline_ptr_phys & 0xffffffffUL;
> +	cmdline_ext_32 = cmdline_ptr_phys >> 32;
> +
> +	boot_params->hdr.cmd_line_ptr = cmdline_low_32;
> +	if (cmdline_ext_32)
> +		boot_params->ext_cmd_line_ptr = cmdline_ext_32;
> +}
> +
> +void *bzImage64_load(struct kimage *image, char *kernel,
> +		unsigned long kernel_len,
> +		char *initrd, unsigned long initrd_len,
> +		char *cmdline, unsigned long cmdline_len)
> +{
> +
> +	struct setup_header *header;
> +	int setup_sects, kern16_size_needed, kern16_size, ret = 0;
> +	unsigned long setup_size, setup_header_size;
> +	struct boot_params *params;
> +	unsigned long bootparam_load_addr, kernel_load_addr, initrd_load_addr;
> +	unsigned long kernel_bufsz, kernel_memsz, kernel_align;
> +	char *kernel_buf;
> +	struct bzimage64_data *ldata;
> +
> +	header = (struct setup_header *)(kernel + 0x1F1);
> +	setup_sects = header->setup_sects;
> +	if (setup_sects == 0)
> +		setup_sects = 4;
> +
> +	kern16_size = (setup_sects + 1) * 512;
> +	if (kernel_len < kern16_size) {
> +		pr_debug("bzImage truncated\n");
> +		return ERR_PTR(-ENOEXEC);
> +	}
> +
> +	if (cmdline_len > header->cmdline_size) {
> +		pr_debug("Kernel command line too long\n");
> +		return ERR_PTR(-EINVAL);
> +	}
> +
> +	/* Allocate loader specific data */
> +	ldata = kzalloc(sizeof(struct bzimage64_data), GFP_KERNEL);
> +	if (!ldata)
> +		return ERR_PTR(-ENOMEM);
> +
> +	/* Argument/parameter segment */
> +	kern16_size_needed = kern16_size;
> +	if (kern16_size_needed < 4096)
> +		kern16_size_needed = 4096;
> +
> +	setup_size = kern16_size_needed + cmdline_len;
> +	params = kzalloc(setup_size, GFP_KERNEL);
> +	if (!params) {
> +		ret = -ENOMEM;
> +		goto out_free_loader_data;
> +	}
> +
> +	/* Copy setup header onto bootparams. */
> +	setup_header_size = 0x0202 + kernel[0x0201] - 0x1F1;
> +
> +	/* Is there a limit on setup header size? */
> +	memcpy(&params->hdr, (kernel + 0x1F1), setup_header_size);
> +	ret = kexec_add_buffer(image, (char *)params, setup_size,
> +			setup_size, 16, 0x3000, -1, 1, &bootparam_load_addr);
> +	if (ret)
> +		goto out_free_params;
> +	pr_debug("Loaded boot_param and command line at 0x%lx\n",
> +			bootparam_load_addr);
> +
> +	/* Load kernel */
> +	kernel_buf = kernel + kern16_size;
> +	kernel_bufsz =  kernel_len - kern16_size;
> +	kernel_memsz = ALIGN(header->init_size, 4096);
> +	kernel_align = header->kernel_alignment;
> +
> +	ret = kexec_add_buffer(image, kernel_buf,
> +			kernel_bufsz, kernel_memsz, kernel_align, 0x100000,
> +			-1, 1, &kernel_load_addr);
> +	if (ret)
> +		goto out_free_params;
> +
> +	pr_debug("Loaded 64bit kernel at 0x%lx sz = 0x%lx\n", kernel_load_addr,
> +				kernel_memsz);
> +
> +	/* Load initrd high */
> +	if (initrd) {
> +		ret = kexec_add_buffer(image, initrd, initrd_len, initrd_len,
> +			4096, 0x10000000, ULONG_MAX, 1, &initrd_load_addr);

Here the minimal starting addr to locate initrd is 256M, though it's
allocated from top to down, I am still wondering why.


> +		if (ret)
> +			goto out_free_params;
> +
> +		pr_debug("Loaded initrd at 0x%lx sz = 0x%lx\n",
> +					initrd_load_addr, initrd_len);
> +		setup_initrd(params, initrd_load_addr, initrd_len);
> +	}
> +
> +	setup_cmdline(params, bootparam_load_addr, kern16_size_needed,
> +			cmdline, cmdline_len);
> +
> +	/* bootloader info. Do we need a separate ID for kexec kernel loader? */
> +	params->hdr.type_of_loader = 0x0D << 4;
> +	params->hdr.loadflags = 0;
> +
> +	setup_linux_system_parameters(params);
> +
> +	/*
> +	 * Allocate a purgatory page. For 64bit entry point, purgatory
> +	 * code can be anywhere.
> +	 *
> +	 * Control page allocation logic goes through segment list to
> +	 * make sure allocated page is not destination page. So allocate
> +	 * control page after all required segment have been prepared.
> +	 */
> +	ldata->purgatory_page = kimage_alloc_control_pages(image,
> +					get_order(KEXEC_PURGATORY_PAGE_SIZE));
> +
> +	if (!ldata->purgatory_page) {
> +		printk(KERN_ERR "Could not allocate purgatory page\n");
> +		ret = -ENOMEM;
> +		goto out_free_params;
> +	}
> +
> +	/*
> +	 * Store pointer to params so that it could be freed after loading
> +	 * params segment has been loaded and contents have been copied
> +	 * somewhere else.
> +	 */
> +	ldata->bootparams_buf = params;
> +	ldata->kernel_load_addr = kernel_load_addr;
> +	ldata->bootparams_load_addr = bootparam_load_addr;
> +	return ldata;
> +
> +out_free_params:
> +	kfree(params);
> +out_free_loader_data:
> +	kfree(ldata);
> +	return ERR_PTR(ret);
> +}
> +
> +int bzImage64_prep_entry(struct kimage *image)
> +{
> +	struct bzimage64_data *ldata;
> +	char *purgatory_page;
> +	unsigned long regs_offset, gdt_offset, purgatory_page_phys;
> +	struct kexec_entry64_regs *regs;
> +	char *gdt_ptr;
> +	unsigned long long *gdt_addr;
> +
> +	if (!image->file_mode)
> +		return 0;
> +
> +	ldata = image->image_loader_data;
> +	if (!ldata)
> +		return -EINVAL;
> +
> +	/* Copy purgatory code to its control page */
> +	purgatory_page = page_address(ldata->purgatory_page);
> +
> +	/* Physical address of purgatory page */
> +	purgatory_page_phys = PFN_PHYS(page_to_pfn(ldata->purgatory_page));
> +
> +	memcpy(purgatory_page, purgatory_entry64,
> +			KEXEC_PURGATORY_CODE_MAX_SIZE);
> +
> +	/* Set registers appropriately */
> +	regs_offset =  (unsigned long)&purgatory_entry64_regs -
> +			(unsigned long)purgatory_entry64;
> +	regs = (struct kexec_entry64_regs *) (purgatory_page + regs_offset);
> +
> +	regs->rbx = 0; /* Bootstrap Processor */
> +	regs->rsi = ldata->bootparams_load_addr;
> +	regs->rip = ldata->kernel_load_addr + 0x200;
> +
> +	/* Fix up gdt */
> +	gdt_offset = (unsigned long)&entry64_gdt -
> +			(unsigned long)purgatory_entry64;
> +
> +	gdt_ptr = purgatory_page + gdt_offset;
> +
> +	/* Skip a word which contains size of gdt table */
> +	gdt_addr = (unsigned long long *)(gdt_ptr + 2);
> +
> +	*gdt_addr = (unsigned long long)gdt_ptr;
> +
> +	/*
> +	 * Update the relocated address of gdt. By the time we load gdt
> +	 * in purgatory, we are running using identity mapped tables.
> +	 * Load identity mapped address here.
> +	 */
> +	*gdt_addr = (unsigned long long)(purgatory_page_phys + gdt_offset);
> +
> +	/*
> +	 * Jump to purgatory after control page. By the time we jump to
> +	 * purgatory, we are using itentifiy mapped page tables
> +	 */
> +	kimage_set_start_addr(image, purgatory_page_phys);
> +	return 0;
> +}
> +
> +/* This cleanup function is called after various segments have been loaded */
> +int bzImage64_cleanup(struct kimage *image)
> +{
> +	struct bzimage64_data *ldata = image->image_loader_data;
> +
> +	kfree(ldata->bootparams_buf);
> +	ldata->bootparams_buf = NULL;
> +	return 0;
> +}
> +
> +#endif /* CONFIG_X86_64 */
> diff --git a/arch/x86/kernel/machine_kexec_64.c b/arch/x86/kernel/machine_kexec_64.c
> index fb41b73..a66ce1d 100644
> --- a/arch/x86/kernel/machine_kexec_64.c
> +++ b/arch/x86/kernel/machine_kexec_64.c
> @@ -21,10 +21,12 @@
>  #include <asm/tlbflush.h>
>  #include <asm/mmu_context.h>
>  #include <asm/debugreg.h>
> +#include <asm/kexec-bzimage.h>
>  
>  /* arch dependent functionality related to kexec file based syscall */
>  static struct kexec_file_type kexec_file_type[]={
> -	{"", NULL, NULL, NULL, NULL},
> +	{"bzImage64", bzImage64_probe, bzImage64_load, bzImage64_prep_entry,
> +	 bzImage64_cleanup},
>  };
>  
>  static int nr_file_types = sizeof(kexec_file_type)/sizeof(kexec_file_type[0]);
> diff --git a/arch/x86/kernel/purgatory_entry_64.S b/arch/x86/kernel/purgatory_entry_64.S
> new file mode 100644
> index 0000000..12a235f
> --- /dev/null
> +++ b/arch/x86/kernel/purgatory_entry_64.S
> @@ -0,0 +1,119 @@
> +/*
> + * Copyright (C) 2013  Red Hat Inc.
> + *
> + * Author(s): Vivek Goyal <vgoyal@redhat.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation (version 2 of the License).
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
> + */
> +
> +
> +/*
> + * One page for purgatory. Code occupies first KEXEC_PURGATORY_CODE_MAX_SIZE
> + * bytes. Rest is for data/stack etc.
> + */
> +#include <asm/page.h>
> +
> +	.text
> +	.align PAGE_SIZE
> +	.code64
> +	.globl purgatory_entry64, purgatory_entry64_regs, entry64_gdt
> +
> +
> +purgatory_entry64:
> +	/* Setup a gdt that should be preserved */
> +	lgdt entry64_gdt(%rip)
> +
> +	/* load the data segments */
> +	movl    $0x18, %eax     /* data segment */
> +	movl    %eax, %ds
> +	movl    %eax, %es
> +	movl    %eax, %ss
> +	movl    %eax, %fs
> +	movl    %eax, %gs
> +
> +	/* Setup new stack */
> +	leaq    stack_init(%rip), %rsp
> +	pushq   $0x10 /* CS */
> +	leaq    new_cs_exit(%rip), %rax
> +	pushq   %rax
> +	lretq
> +new_cs_exit:
> +
> +	/*
> +	 * Load the registers except rsp. rsp is already loaded with stack
> +	 * at the end of this page
> +	 */
> +	movq	rax(%rip), %rax
> +	movq	rbx(%rip), %rbx
> +	movq	rcx(%rip), %rcx
> +	movq	rdx(%rip), %rdx
> +	movq	rsi(%rip), %rsi
> +	movq	rdi(%rip), %rdi
> +	movq	rbp(%rip), %rbp
> +	movq	r8(%rip), %r8
> +	movq	r9(%rip), %r9
> +	movq	r10(%rip), %r10
> +	movq	r11(%rip), %r11
> +	movq	r12(%rip), %r12
> +	movq	r13(%rip), %r13
> +	movq	r14(%rip), %r14
> +	movq	r15(%rip), %r15
> +
> +	/* Jump to the new code... */
> +	jmpq	*rip(%rip)
> +
> +	.balign 16
> +purgatory_entry64_regs:
> +rax:	.quad 0x00000000
> +rbx:	.quad 0x00000000
> +rcx:	.quad 0x00000000
> +rdx:	.quad 0x00000000
> +rsi:	.quad 0x00000000
> +rdi:	.quad 0x00000000
> +rsp:	.quad 0x00000000
> +rbp:	.quad 0x00000000
> +r8:	.quad 0x00000000
> +r9:	.quad 0x00000000
> +r10:	.quad 0x00000000
> +r11:	.quad 0x00000000
> +r12:	.quad 0x00000000
> +r13:	.quad 0x00000000
> +r14:	.quad 0x00000000
> +r15:	.quad 0x00000000
> +rip:	.quad 0x00000000
> +
> +	/* GDT */
> +	.balign 16
> +entry64_gdt:
> +	/* 0x00 unusable segment
> +	 * 0x08 unused
> +	 * so use them as gdt ptr
> +	 */
> +	.word gdt_end - entry64_gdt - 1
> +	.quad entry64_gdt
> +	.word 0, 0, 0
> +
> +	/* 0x10 4GB flat code segment */
> +	.word 0xFFFF, 0x0000, 0x9A00, 0x00AF
> +
> +	/* 0x18 4GB flat data segment */
> +	.word 0xFFFF, 0x0000, 0x9200, 0x00CF
> +gdt_end:
> +
> +	.globl kexec_purgatory_code_size
> +.set kexec_purgatory_code_size, . - purgatory_entry64
> +
> +/* Fill rest of the page with zeros to be used as stack */
> +stack: .fill purgatory_entry64 + PAGE_SIZE - ., 1, 0
> +stack_init:
> -- 
> 1.7.7.6
> 
> 
> _______________________________________________
> kexec mailing list
> kexec@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kexec
