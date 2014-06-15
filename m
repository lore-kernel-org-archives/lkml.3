Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751909AbaFOQfe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 12:35:34 -0400
Received: from mail.skyhub.de ([78.46.96.112]:55564 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751698AbaFOQfc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 12:35:32 -0400
Date: Sun, 15 Jun 2014 18:35:15 +0200
From: Borislav Petkov <bp@alien8.de>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        ebiederm@xmission.com, hpa@zytor.com, mjg59@srcf.ucam.org,
        greg@kroah.com, jkosina@suse.cz, dyoung@redhat.com,
        chaowang@redhat.com, bhe@redhat.com, akpm@linux-foundation.org
Subject: Re: [PATCH 11/13] kexec-bzImage: Support for loading bzImage using
 64bit entry
Message-ID: <20140615163515.GA17016@pd.tnic>
References: <1401800822-27425-1-git-send-email-vgoyal@redhat.com>
 <1401800822-27425-12-git-send-email-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1401800822-27425-12-git-send-email-vgoyal@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 03, 2014 at 09:07:00AM -0400, Vivek Goyal wrote:
> This is loader specific code which can load bzImage and set it up for
> 64bit entry. This does not take care of 32bit entry or real mode entry.
> 
> 32bit mode entry can be implemented if somebody needs it.
> 
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---

...

> diff --git a/arch/x86/kernel/kexec-bzimage.c b/arch/x86/kernel/kexec-bzimage.c
> new file mode 100644
> index 0000000..0750784
> --- /dev/null
> +++ b/arch/x86/kernel/kexec-bzimage.c
> @@ -0,0 +1,269 @@
> +/*
> + * Kexec bzImage loader
> + *
> + * Copyright (C) 2014 Red Hat Inc.
> + * Authors:
> + *      Vivek Goyal <vgoyal@redhat.com>
> + *
> + * This source code is licensed under the GNU General Public License,
> + * Version 2.  See the file COPYING for more details.
> + */
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
> +/*
> + * Defines lowest physical address for various segments. Not sure where
> + * exactly these limits came from. Current bzimage64 loader in kexec-tools
> + * uses these so I am retaining it. It can be changed over time as we gain
> + * more insight.
> + */
> +#define MIN_PURGATORY_ADDR	0x3000
> +#define MIN_BOOTPARAM_ADDR	0x3000
> +#define MIN_KERNEL_LOAD_ADDR	0x100000
> +#define MIN_INITRD_LOAD_ADDR	0x1000000
> +
> +#ifdef CONFIG_X86_64
> +
> +/*
> + * This is a place holder for all boot loader specific data structure which
> + * gets allocated in one call but gets freed much later during cleanup
> + * time. Right now there is only one field but it can grow as need be.
> + */
> +struct bzimage64_data {
> +	/*
> +	 * Temporary buffer to hold bootparams buffer. This should be
> +	 * freed once the bootparam segment has been loaded.
> +	 */
> +	void *bootparams_buf;
> +};
> +
> +int bzImage64_probe(const char *buf, unsigned long len)
> +{
> +	int ret = -ENOEXEC;
> +	struct setup_header *header;
> +
> +	/* kernel should be atleast two sector long */

				    two sectors

> +	if (len < 2 * 512) {
> +		pr_debug("File is too short to be a bzImage\n");

Those error messages are all pr_debug. Now, wouldn't we want to tell
userspace what the problem is, *when* there is one?

I.e., pr_err or pr_info is much more helpful than pr_debug IMO.

> +		return ret;
> +	}
> +
> +	header = (struct setup_header *)(buf + offsetof(struct boot_params,
> +								hdr));

Just let that stick out. The 80 cols limit is not a hard one anyway,
especially if it impairs readability.

> +	if (memcmp((char *)&header->header, "HdrS", 4) != 0) {

Not strncmp? "HdrS" is a string...

> +		pr_debug("Not a bzImage\n");
> +		return ret;
> +	}
> +
> +	if (header->boot_flag != 0xAA55) {
> +		pr_debug("No x86 boot sector present\n");
> +		return ret;
> +	}
> +
> +	if (header->version < 0x020C) {
> +		pr_debug("Must be at least protocol version 2.12\n");
> +		return ret;
> +	}
> +
> +	if ((header->loadflags & LOADED_HIGH) == 0) {

	if (!(header->loadflags.. ))

> +		pr_debug("zImage not a bzImage\n");
> +		return ret;
> +	}
> +
> +	if (!(header->xloadflags & XLF_KERNEL_64)) {
> +		pr_debug("Not a bzImage64. XLF_KERNEL_64 is not set.\n");
> +		return ret;
> +	}
> +
> +	if (!(header->xloadflags & XLF_CAN_BE_LOADED_ABOVE_4G)) {
> +		pr_debug("XLF_CAN_BE_LOADED_ABOVE_4G is not set.\n");
> +		return ret;
> +	}

Just merge the two checks:

	if ((header->xloadflags & (XLF_KERNEL_64 | XLF_CAN_BE_LOADED_ABOVE_4G)) !=
                                  (XLF_KERNEL_64 | XLF_CAN_BE_LOADED_ABOVE_4G)) {
                pr_err("Not a bzImage, xloadflags: 0x%x\n", header->xloadflags);
                return ret;
        }

> +
> +	/* I've got a bzImage */
> +	pr_debug("It's a relocatable bzImage64\n");
> +	ret = 0;
> +
> +	return ret;
> +}
> +
> +void *bzImage64_load(struct kimage *image, char *kernel,
> +		unsigned long kernel_len,
> +		char *initrd, unsigned long initrd_len,
> +		char *cmdline, unsigned long cmdline_len)

Arg alignment.

> +{
> +
> +	struct setup_header *header;
> +	int setup_sects, kern16_size, ret = 0;
> +	unsigned long setup_header_size, params_cmdline_sz;
> +	struct boot_params *params;
> +	unsigned long bootparam_load_addr, kernel_load_addr, initrd_load_addr;
> +	unsigned long purgatory_load_addr;
> +	unsigned long kernel_bufsz, kernel_memsz, kernel_align;
> +	char *kernel_buf;
> +	struct bzimage64_data *ldata;
> +	struct kexec_entry64_regs regs64;
> +	void *stack;
> +	unsigned int setup_hdr_offset = offsetof(struct boot_params, hdr);
> +
> +	header = (struct setup_header *)(kernel + setup_hdr_offset);
> +	setup_sects = header->setup_sects;
> +	if (setup_sects == 0)
> +		setup_sects = 4;
> +
> +	kern16_size = (setup_sects + 1) * 512;
> +	if (kernel_len < kern16_size) {
> +		pr_debug("bzImage truncated\n");

Ditto for all those pr_debug's in here - I think we want to know why the
bzImage load fails and pr_debug is not suitable for that.

> +		return ERR_PTR(-ENOEXEC);
> +	}
> +
> +	if (cmdline_len > header->cmdline_size) {

As we talked, I think COMMAND_LINE_SIZE is perfectly fine and safe for
all intents and purposes.

> +		pr_debug("Kernel command line too long\n");
> +		return ERR_PTR(-EINVAL);
> +	}
> +
> +	/* Allocate loader specific data */
> +	ldata = kzalloc(sizeof(struct bzimage64_data), GFP_KERNEL);
> +	if (!ldata)
> +		return ERR_PTR(-ENOMEM);

Why don't you move that allocation to the place right before it is being
assigned to it? I.e., to the "ldata->bootparams_buf = params" line.

This way you'll save yourself all the goto games on the error path and
do it only after everything else has succeeded.

> +
> +	/*
> +	 * Load purgatory. For 64bit entry point, purgatory  code can be
> +	 * anywhere.
> +	 */
> +	ret = kexec_load_purgatory(image, MIN_PURGATORY_ADDR, ULONG_MAX, 1,
> +					&purgatory_load_addr);
> +	if (ret) {
> +		pr_debug("Loading purgatory failed\n");
> +		goto out_free_loader_data;
> +	}
> +
> +	pr_debug("Loaded purgatory at 0x%lx\n", purgatory_load_addr);
> +
> +	/* Load Bootparams and cmdline */
> +	params_cmdline_sz = sizeof(struct boot_params) + cmdline_len;
> +	params = kzalloc(params_cmdline_sz, GFP_KERNEL);
> +	if (!params) {
> +		ret = -ENOMEM;
> +		goto out_free_loader_data;
> +	}
> +
> +	/* Copy setup header onto bootparams. Documentation/x86/boot.txt */
> +	setup_header_size = 0x0202 + kernel[0x0201] - setup_hdr_offset;
> +
> +	/* Is there a limit on setup header size? */
> +	memcpy(&params->hdr, (kernel + setup_hdr_offset), setup_header_size);
> +
> +	ret = kexec_add_buffer(image, (char *)params, params_cmdline_sz,
> +			       params_cmdline_sz, 16, MIN_BOOTPARAM_ADDR,
> +			       ULONG_MAX, 1, &bootparam_load_addr);
> +	if (ret)
> +		goto out_free_params;
> +	pr_debug("Loaded boot_param and command line at 0x%lx bufsz=0x%lx memsz=0x%lx\n",
> +		 bootparam_load_addr, params_cmdline_sz, params_cmdline_sz);
> +
> +	/* Load kernel */
> +	kernel_buf = kernel + kern16_size;
> +	kernel_bufsz =  kernel_len - kern16_size;
> +	kernel_memsz = ALIGN(header->init_size, 4096);

PAGE_ALIGN

> +	kernel_align = header->kernel_alignment;
> +
> +	ret = kexec_add_buffer(image, kernel_buf,
> +			       kernel_bufsz, kernel_memsz, kernel_align,
> +			       MIN_KERNEL_LOAD_ADDR, ULONG_MAX, 1,
> +			       &kernel_load_addr);
> +	if (ret)
> +		goto out_free_params;
> +
> +	pr_debug("Loaded 64bit kernel at 0x%lx bufsz=0x%lx memsz=0x%lx\n",
> +		 kernel_load_addr, kernel_memsz, kernel_memsz);
> +
> +	/* Load initrd high */
> +	if (initrd) {
> +		ret = kexec_add_buffer(image, initrd, initrd_len, initrd_len,
> +				       PAGE_SIZE, MIN_INITRD_LOAD_ADDR,
> +				       ULONG_MAX, 1, &initrd_load_addr);
> +		if (ret)
> +			goto out_free_params;
> +
> +		pr_debug("Loaded initrd at 0x%lx bufsz=0x%lx memsz=0x%lx\n",
> +				initrd_load_addr, initrd_len, initrd_len);

emtpy line to split, pls.

> +		ret = kexec_setup_initrd(params, initrd_load_addr, initrd_len);
> +		if (ret)

This ret is unconditionally 0 - no need to check it.

> +			goto out_free_params;
> +	}
> +
> +	ret = kexec_setup_cmdline(params, bootparam_load_addr,
> +				  sizeof(struct boot_params), cmdline,
> +				  cmdline_len);
> +	if (ret)

Ditto.

> +		goto out_free_params;
> +
> +	/* bootloader info. Do we need a separate ID for kexec kernel loader? */
> +	params->hdr.type_of_loader = 0x0D << 4;
> +	params->hdr.loadflags = 0;
> +
> +	/* Setup purgatory regs for entry */
> +	ret = kexec_purgatory_get_set_symbol(image, "entry64_regs", &regs64,
> +					     sizeof(regs64), 1);
> +	if (ret)
> +		goto out_free_params;
> +
> +	regs64.rbx = 0; /* Bootstrap Processor */
> +	regs64.rsi = bootparam_load_addr;
> +	regs64.rip = kernel_load_addr + 0x200;
> +	stack = kexec_purgatory_get_symbol_addr(image, "stack_end");
> +	if (IS_ERR(stack)) {
> +		pr_debug("Could not find address of symbol stack_end\n");
> +		ret = -EINVAL;
> +		goto out_free_params;
> +	}
> +
> +	regs64.rsp = (unsigned long)stack;
> +	ret = kexec_purgatory_get_set_symbol(image, "entry64_regs", &regs64,
> +					     sizeof(regs64), 0);
> +	if (ret)
> +		goto out_free_params;
> +
> +	ret = kexec_setup_boot_parameters(params);

Ditto.

> +	if (ret)
> +		goto out_free_params;
> +
> +	/*
> +	 * Store pointer to params so that it could be freed after loading
> +	 * params segment has been loaded and contents have been copied
> +	 * somewhere else.
> +	 */
> +	ldata->bootparams_buf = params;
> +	return ldata;
> +
> +out_free_params:
> +	kfree(params);
> +out_free_loader_data:
> +	kfree(ldata);
> +	return ERR_PTR(ret);
> +}
> +
> +/* This cleanup function is called after various segments have been loaded */
> +int bzImage64_cleanup(struct kimage *image)
> +{
> +	struct bzimage64_data *ldata = image->image_loader_data;
> +
> +	if (!ldata)
> +		return 0;
> +
> +	kfree(ldata->bootparams_buf);
> +	ldata->bootparams_buf = NULL;
> +
> +	return 0;
> +}
> +
> +#endif /* CONFIG_X86_64 */
> diff --git a/arch/x86/kernel/machine_kexec.c b/arch/x86/kernel/machine_kexec.c
> new file mode 100644
> index 0000000..7de3239
> --- /dev/null
> +++ b/arch/x86/kernel/machine_kexec.c
> @@ -0,0 +1,136 @@
> +/*
> + * handle transition of Linux booting another kernel
> + *
> + * Copyright (C) 2014 Red Hat Inc.
> + * Authors:
> + *      Vivek Goyal <vgoyal@redhat.com>
> + *
> + * This source code is licensed under the GNU General Public License,
> + * Version 2.  See the file COPYING for more details.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/string.h>
> +#include <asm/bootparam.h>
> +#include <asm/setup.h>
> +
> +/*
> + * Common code for x86 and x86_64 used for kexec.
> + *
> + * For the time being it compiles only for x86_64 as there are no image
> + * loaders implemented * for x86. This #ifdef can be removed once somebody
> + * decides to write an image loader on CONFIG_X86_32.
> + */
> +
> +#ifdef CONFIG_X86_64

Ok, this doesn't make any sense: this new machine_kexec.c is supposed to
be common code and yet it has this 64-bit ifdef in there.

It should be the other way around, IMO: put it now in machine_kexec_64.c
and if someone wants the 32-bit version, that someone should carve it
out. This'll save you the needless ifdeffery now.

> +
> +int kexec_setup_initrd(struct boot_params *params,
> +		unsigned long initrd_load_addr, unsigned long initrd_len)
> +{
> +	params->hdr.ramdisk_image = initrd_load_addr & 0xffffffffUL;
> +	params->hdr.ramdisk_size = initrd_len & 0xffffffffUL;

We have more readable GENMASK* macros for contiguous masks. This one
will then look like:

	params->hdr.ramdisk_image = initrd_load_addr & GENMASK(31, 0);
	params->hdr.ramdisk_size = initrd_len & GENMASK(31, 0);

and this way we know exactly about which bits are we talking about. :)

> +
> +	params->ext_ramdisk_image = initrd_load_addr >> 32;
> +	params->ext_ramdisk_size = initrd_len >> 32;
> +
> +	return 0;
> +}
> +
> +int kexec_setup_cmdline(struct boot_params *params,
> +		unsigned long bootparams_load_addr,
> +		unsigned long cmdline_offset, char *cmdline,
> +		unsigned long cmdline_len)
> +{
> +	char *cmdline_ptr = ((char *)params) + cmdline_offset;
> +	unsigned long cmdline_ptr_phys;
> +	uint32_t cmdline_low_32, cmdline_ext_32;
> +
> +	memcpy(cmdline_ptr, cmdline, cmdline_len);
> +	cmdline_ptr[cmdline_len - 1] = '\0';
> +
> +	cmdline_ptr_phys = bootparams_load_addr + cmdline_offset;
> +	cmdline_low_32 = cmdline_ptr_phys & 0xffffffffUL;

GENMASK

> +	cmdline_ext_32 = cmdline_ptr_phys >> 32;
> +
> +	params->hdr.cmd_line_ptr = cmdline_low_32;
> +	if (cmdline_ext_32)
> +		params->ext_cmd_line_ptr = cmdline_ext_32;
> +
> +	return 0;
> +}
> +
> +static int setup_memory_map_entries(struct boot_params *params)
> +{
> +	unsigned int nr_e820_entries;
> +
> +	/* TODO: What about EFI */

You're removing this line in 13/13 so don't add it at all... ?

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
> +int kexec_setup_boot_parameters(struct boot_params *params)
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
> +	for (i = 0; i < nr_e820_entries; i++) {
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
				^^^^^^^^^^^^^^

Shouldn't you just copy eddbuf_entries many instead of EDDMAXNR?



> +	params->eddbuf_entries = boot_params.eddbuf_entries;
> +

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
