Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753329AbaB0Vgl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 16:36:41 -0500
Received: from mail.skyhub.de ([78.46.96.112]:40288 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751747AbaB0Vgi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 16:36:38 -0500
Date: Thu, 27 Feb 2014 22:36:29 +0100
From: Borislav Petkov <bp@alien8.de>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        ebiederm@xmission.com, hpa@zytor.com, mjg59@srcf.ucam.org,
        greg@kroah.com, jkosina@suse.cz
Subject: Re: [PATCH 08/11] kexec-bzImage: Support for loading bzImage using
 64bit entry
Message-ID: <20140227213629.GP18191@pd.tnic>
References: <1390849071-21989-1-git-send-email-vgoyal@redhat.com>
 <1390849071-21989-9-git-send-email-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1390849071-21989-9-git-send-email-vgoyal@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 27, 2014 at 01:57:48PM -0500, Vivek Goyal wrote:
> This is loader specific code which can load bzImage and set it up for
> 64bit entry. This does not take care of 32bit entry or real mode entry
> yet.
> 
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---

checkpatch: total: 4 errors, 2 warnings, 450 lines checked

...

> diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
> index cb648c8..fa9981d 100644
> --- a/arch/x86/kernel/Makefile
> +++ b/arch/x86/kernel/Makefile
> @@ -67,8 +67,10 @@ obj-$(CONFIG_DYNAMIC_FTRACE)	+= ftrace.o
>  obj-$(CONFIG_FUNCTION_GRAPH_TRACER) += ftrace.o
>  obj-$(CONFIG_FTRACE_SYSCALLS)	+= ftrace.o
>  obj-$(CONFIG_X86_TSC)		+= trace_clock.o
> +obj-$(CONFIG_KEXEC)		+= machine_kexec.o
>  obj-$(CONFIG_KEXEC)		+= machine_kexec_$(BITS).o
>  obj-$(CONFIG_KEXEC)		+= relocate_kernel_$(BITS).o crash.o
> +obj-$(CONFIG_KEXEC)		+= kexec-bzimage.o

Maybe use less obj-$(CONFIG_KEXEC) lines here.

>  obj-$(CONFIG_CRASH_DUMP)	+= crash_dump_$(BITS).o
>  obj-y				+= kprobes/
>  obj-$(CONFIG_MODULES)		+= module.o
> diff --git a/arch/x86/kernel/kexec-bzimage.c b/arch/x86/kernel/kexec-bzimage.c
> new file mode 100644
> index 0000000..cbfcd00
> --- /dev/null
> +++ b/arch/x86/kernel/kexec-bzimage.c
> @@ -0,0 +1,234 @@
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
> +	/*
> +	 * Temporary buffer to hold bootparams buffer. This should be
> +	 * freed once the bootparam segment has been loaded.
> +	 */
> +	void *bootparams_buf;
> +};

Why a struct if it is going to have only one member?

> +
> +int bzImage64_probe(const char *buf, unsigned long len)
> +{
> +	int ret = -ENOEXEC;
> +	struct setup_header *header;
> +
> +	if (len < 2 * 512) {

What's 2*512? Two sectors?

> +		pr_debug("File is too short to be a bzImage\n");
> +		return ret;
> +	}
> +
> +	header = (struct setup_header *)(buf + 0x1F1);

0x1F1 should need at least a comment or "offsetof(struct boot_params, hdr)"
or both, which would be best. :-)

> +	if (memcmp((char *)&header->header, "HdrS", 4) != 0) {
> +		pr_debug("Not a bzImage\n");

Actually, I think that means that there is no real mode kernel header
there, or we're using an old boot protocol version:

Documentation/x86/boot.txt

> +		return ret;
> +	}
> +
> +	if (header->boot_flag != 0xAA55) {
> +                /* No x86 boot sector present */

Comment is kinda redundant here :)

> +		pr_debug("No x86 boot sector present\n");
> +		return ret;
> +	}
> +
> +	if (header->version < 0x020C) {
> +                /* Must be at least protocol version 2.12 */

Ditto.

> +		pr_debug("Must be at least protocol version 2.12\n");
> +		return ret;
> +	}
> +
> +	if ((header->loadflags & 1) == 0) {

That must be LOADED_HIGH bit. Why does this bit mean it is a bzImage?

Ok, I see it in boot.txt:

"...
	When loading a zImage kernel ((loadflags & 0x01) == 0).
"

> +		/* Not a bzImage */
> +		pr_debug("zImage not a bzImage\n");
> +		return ret;
> +	}
> +
> +	if ((header->xloadflags & 3) != 3) {
> +	/* XLF_KERNEL_64 and XLF_CAN_BE_LOADED_ABOVE_4G should be set */

Use those defines in the code please instead of naked numbers.

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
> +void *bzImage64_load(struct kimage *image, char *kernel,
> +		unsigned long kernel_len,
> +		char *initrd, unsigned long initrd_len,
> +		char *cmdline, unsigned long cmdline_len)
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
> +
> +	header = (struct setup_header *)(kernel + 0x1F1);

See above.

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
> +	/*
> +	 * Load purgatory. For 64bit entry point, purgatory  code can be
> +	 * anywhere.
> +	 */
> +	ret = kexec_load_purgatory(image, 0x3000, -1, 1, &purgatory_load_addr);

Some defines like MIN_<something> and MAX_<something> could be more
readable here.

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
> +	/* Copy setup header onto bootparams. */
> +	setup_header_size = 0x0202 + kernel[0x0201] - 0x1F1;

More magic numbers :-\ Ok, I'm not going to comment on the rest of them
below but you get the idea - it would be much better to have descriptive
defines here instead of naked numbers.

> +
> +	/* Is there a limit on setup header size? */
> +	memcpy(&params->hdr, (kernel + 0x1F1), setup_header_size);
> +	ret = kexec_add_buffer(image, (char *)params, params_cmdline_sz,
> +			params_cmdline_sz, 16, 0x3000, -1, 1,
> +			&bootparam_load_addr);

Normally we do arg alignment below the opening brace of the function.
Ditto for a bunch of call sites below.


...

> diff --git a/arch/x86/kernel/machine_kexec.c b/arch/x86/kernel/machine_kexec.c
> new file mode 100644
> index 0000000..ac55890
> --- /dev/null
> +++ b/arch/x86/kernel/machine_kexec.c
> @@ -0,0 +1,136 @@
> +/*
> + * handle transition of Linux booting another kernel
> + *
> + * Copyright (C) 2014 Red Hat Inc.
> + * Authors:
> + * 	Vivek Goyal <vgoyal@redhat.com>
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

I think you mean i386 by x86, right?

> + *
> + * For the time being it compiles only for x86_64 as there are no image
> + * loaders implemented * for x86. This #ifdef can be removed once somebody
> + * decides to write an image loader on CONFIG_X86_32.
> + */
> +
> +#ifdef CONFIG_X86_64
> +
> +int kexec_setup_initrd(struct boot_params *boot_params,
> +		unsigned long initrd_load_addr, unsigned long initrd_len)
> +{
> +	boot_params->hdr.ramdisk_image = initrd_load_addr & 0xffffffffUL;
> +	boot_params->hdr.ramdisk_size = initrd_len & 0xffffffffUL;
> +
> +	boot_params->ext_ramdisk_image = initrd_load_addr >> 32;
> +	boot_params->ext_ramdisk_size = initrd_len >> 32;
> +
> +	return 0;
> +}
> +
> +int kexec_setup_cmdline(struct boot_params *boot_params,
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
> +
> +	return 0;
> +}
> +
> +static int setup_memory_map_entries(struct boot_params *params)
> +{
> +	unsigned int nr_e820_entries;
> +
> +	/* TODO: What about EFI */

Do you mean by that what do_add_efi_memmap() does? We add the efi
entries only when add_efi_memmap is supplied on the cmdline, see
200001eb140ea.

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

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
