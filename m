Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756021AbaFPUG5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 16:06:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2005 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755965AbaFPUGy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 16:06:54 -0400
Date: Mon, 16 Jun 2014 16:06:08 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        ebiederm@xmission.com, hpa@zytor.com, mjg59@srcf.ucam.org,
        greg@kroah.com, jkosina@suse.cz, dyoung@redhat.com,
        chaowang@redhat.com, bhe@redhat.com, akpm@linux-foundation.org
Subject: Re: [PATCH 11/13] kexec-bzImage: Support for loading bzImage using
 64bit entry
Message-ID: <20140616200608.GD4515@redhat.com>
References: <1401800822-27425-1-git-send-email-vgoyal@redhat.com>
 <1401800822-27425-12-git-send-email-vgoyal@redhat.com>
 <20140615163515.GA17016@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140615163515.GA17016@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 15, 2014 at 06:35:15PM +0200, Borislav Petkov wrote:

[..]
> > +int bzImage64_probe(const char *buf, unsigned long len)
> > +{
> > +	int ret = -ENOEXEC;
> > +	struct setup_header *header;
> > +
> > +	/* kernel should be atleast two sector long */
> 
> 				    two sectors
> 
> > +	if (len < 2 * 512) {
> > +		pr_debug("File is too short to be a bzImage\n");
> 
> Those error messages are all pr_debug. Now, wouldn't we want to tell
> userspace what the problem is, *when* there is one?
> 
> I.e., pr_err or pr_info is much more helpful than pr_debug IMO.

There can be more than one loader and the one which claims first
to recognize the image will get to load the image. So once 32 bit
loader support comes in, it might happen that we ask 64bit loader
first and it rejects the image and then we ask 32bit loader.

So these message are really debug message which tells why loader
is not accepting an image. It might not be image destined for that
loader at all.

pr_debug() allows being verbose if user wants to for debugging purposes.
You just have to make sure that CONFIG_DYNAMIC_DEBUG=y and enable verbosity
in individual file.

echo 'file kexec-bzimage.c +p' > /sys/kernel/debug/dynamic_debug/control

> 
> > +		return ret;
> > +	}
> > +
> > +	header = (struct setup_header *)(buf + offsetof(struct boot_params,
> > +								hdr));
> 
> Just let that stick out. The 80 cols limit is not a hard one anyway,
> especially if it impairs readability.

Will do.

> 
> > +	if (memcmp((char *)&header->header, "HdrS", 4) != 0) {
> 
> Not strncmp? "HdrS" is a string...

As peter said, this is not string. So I will retain it.

> 
> > +		pr_debug("Not a bzImage\n");
> > +		return ret;
> > +	}
> > +
> > +	if (header->boot_flag != 0xAA55) {
> > +		pr_debug("No x86 boot sector present\n");
> > +		return ret;
> > +	}
> > +
> > +	if (header->version < 0x020C) {
> > +		pr_debug("Must be at least protocol version 2.12\n");
> > +		return ret;
> > +	}
> > +
> > +	if ((header->loadflags & LOADED_HIGH) == 0) {
> 
> 	if (!(header->loadflags.. ))

Will do.

> 
> > +		pr_debug("zImage not a bzImage\n");
> > +		return ret;
> > +	}
> > +
> > +	if (!(header->xloadflags & XLF_KERNEL_64)) {
> > +		pr_debug("Not a bzImage64. XLF_KERNEL_64 is not set.\n");
> > +		return ret;
> > +	}
> > +
> > +	if (!(header->xloadflags & XLF_CAN_BE_LOADED_ABOVE_4G)) {
> > +		pr_debug("XLF_CAN_BE_LOADED_ABOVE_4G is not set.\n");
> > +		return ret;
> > +	}
> 
> Just merge the two checks:
> 
> 	if ((header->xloadflags & (XLF_KERNEL_64 | XLF_CAN_BE_LOADED_ABOVE_4G)) !=
>                                   (XLF_KERNEL_64 | XLF_CAN_BE_LOADED_ABOVE_4G)) {
>                 pr_err("Not a bzImage, xloadflags: 0x%x\n", header->xloadflags);
>                 return ret;
>         }

I think I like separate checks better. That way I can output much better
debug message. Just saying xloadflags=0x%x does not tell anything about
what flags the loader is looking for (without looking at the code).

> 
> > +
> > +	/* I've got a bzImage */
> > +	pr_debug("It's a relocatable bzImage64\n");
> > +	ret = 0;
> > +
> > +	return ret;
> > +}
> > +
> > +void *bzImage64_load(struct kimage *image, char *kernel,
> > +		unsigned long kernel_len,
> > +		char *initrd, unsigned long initrd_len,
> > +		char *cmdline, unsigned long cmdline_len)
> 
> Arg alignment.

Will do.

[..]
> > +	header = (struct setup_header *)(kernel + setup_hdr_offset);
> > +	setup_sects = header->setup_sects;
> > +	if (setup_sects == 0)
> > +		setup_sects = 4;
> > +
> > +	kern16_size = (setup_sects + 1) * 512;
> > +	if (kernel_len < kern16_size) {
> > +		pr_debug("bzImage truncated\n");
> 
> Ditto for all those pr_debug's in here - I think we want to know why the
> bzImage load fails and pr_debug is not suitable for that.

Same here. We will potentially be trying multiple loaders and if every
loader prints messages for rejection by default, it is too much of info,
IMO.

> 
> > +		return ERR_PTR(-ENOEXEC);
> > +	}
> > +
> > +	if (cmdline_len > header->cmdline_size) {
> 
> As we talked, I think COMMAND_LINE_SIZE is perfectly fine and safe for
> all intents and purposes.

I still have concerns about using COMMAND_LINE_SIZE. If header information
is useful for a bootloader, then kernel is just a bootloader in this case
and if we really want to limit the size, it should be based on information
present in the header and not based on currently running kernel's limit.

> 
> > +		pr_debug("Kernel command line too long\n");
> > +		return ERR_PTR(-EINVAL);
> > +	}
> > +
> > +	/* Allocate loader specific data */
> > +	ldata = kzalloc(sizeof(struct bzimage64_data), GFP_KERNEL);
> > +	if (!ldata)
> > +		return ERR_PTR(-ENOMEM);
> 
> Why don't you move that allocation to the place right before it is being
> assigned to it? I.e., to the "ldata->bootparams_buf = params" line.

I like doing memory allocations early in the functions (as far as
possible) and error out if need be. If memory is available to begin
with for all the data structures needed by this function, it is kind
of pointless to do rest of the processing.

[..]
> > +	ret = kexec_add_buffer(image, (char *)params, params_cmdline_sz,
> > +			       params_cmdline_sz, 16, MIN_BOOTPARAM_ADDR,
> > +			       ULONG_MAX, 1, &bootparam_load_addr);
> > +	if (ret)
> > +		goto out_free_params;
> > +	pr_debug("Loaded boot_param and command line at 0x%lx bufsz=0x%lx memsz=0x%lx\n",
> > +		 bootparam_load_addr, params_cmdline_sz, params_cmdline_sz);
> > +
> > +	/* Load kernel */
> > +	kernel_buf = kernel + kern16_size;
> > +	kernel_bufsz =  kernel_len - kern16_size;
> > +	kernel_memsz = ALIGN(header->init_size, 4096);
> 
> PAGE_ALIGN

Will change.

> 
> > +	kernel_align = header->kernel_alignment;
> > +
> > +	ret = kexec_add_buffer(image, kernel_buf,
> > +			       kernel_bufsz, kernel_memsz, kernel_align,
> > +			       MIN_KERNEL_LOAD_ADDR, ULONG_MAX, 1,
> > +			       &kernel_load_addr);
> > +	if (ret)
> > +		goto out_free_params;
> > +
> > +	pr_debug("Loaded 64bit kernel at 0x%lx bufsz=0x%lx memsz=0x%lx\n",
> > +		 kernel_load_addr, kernel_memsz, kernel_memsz);
> > +
> > +	/* Load initrd high */
> > +	if (initrd) {
> > +		ret = kexec_add_buffer(image, initrd, initrd_len, initrd_len,
> > +				       PAGE_SIZE, MIN_INITRD_LOAD_ADDR,
> > +				       ULONG_MAX, 1, &initrd_load_addr);
> > +		if (ret)
> > +			goto out_free_params;
> > +
> > +		pr_debug("Loaded initrd at 0x%lx bufsz=0x%lx memsz=0x%lx\n",
> > +				initrd_load_addr, initrd_len, initrd_len);
> 
> emtpy line to split, pls.

Will do.

> 
> > +		ret = kexec_setup_initrd(params, initrd_load_addr, initrd_len);
> > +		if (ret)
> 
> This ret is unconditionally 0 - no need to check it.

Ok will change it.

> 
> > +			goto out_free_params;
> > +	}
> > +
> > +	ret = kexec_setup_cmdline(params, bootparam_load_addr,
> > +				  sizeof(struct boot_params), cmdline,
> > +				  cmdline_len);
> > +	if (ret)
> 
> Ditto.

Will change.

[..]
> > +	ret = kexec_purgatory_get_set_symbol(image, "entry64_regs", &regs64,
> > +					     sizeof(regs64), 0);
> > +	if (ret)
> > +		goto out_free_params;
> > +
> > +	ret = kexec_setup_boot_parameters(params);
> 
> Ditto.

Will change.

[..]
> > +/*
> > + * Common code for x86 and x86_64 used for kexec.
> > + *
> > + * For the time being it compiles only for x86_64 as there are no image
> > + * loaders implemented * for x86. This #ifdef can be removed once somebody
> > + * decides to write an image loader on CONFIG_X86_32.
> > + */
> > +
> > +#ifdef CONFIG_X86_64
> 
> Ok, this doesn't make any sense: this new machine_kexec.c is supposed to
> be common code and yet it has this 64-bit ifdef in there.
> 
> It should be the other way around, IMO: put it now in machine_kexec_64.c
> and if someone wants the 32-bit version, that someone should carve it
> out. This'll save you the needless ifdeffery now.

Hmm..., If you feel strongly about it, I can make this change. I thought
I just made it easier to share the code between 32bit and 64bit by this.

> 
> > +
> > +int kexec_setup_initrd(struct boot_params *params,
> > +		unsigned long initrd_load_addr, unsigned long initrd_len)
> > +{
> > +	params->hdr.ramdisk_image = initrd_load_addr & 0xffffffffUL;
> > +	params->hdr.ramdisk_size = initrd_len & 0xffffffffUL;
> 
> We have more readable GENMASK* macros for contiguous masks. This one
> will then look like:
> 
> 	params->hdr.ramdisk_image = initrd_load_addr & GENMASK(31, 0);
> 	params->hdr.ramdisk_size = initrd_len & GENMASK(31, 0);
> 
> and this way we know exactly about which bits are we talking about. :)

Ok, will use it.

> 
> > +
> > +	params->ext_ramdisk_image = initrd_load_addr >> 32;
> > +	params->ext_ramdisk_size = initrd_len >> 32;
> > +
> > +	return 0;
> > +}
> > +
> > +int kexec_setup_cmdline(struct boot_params *params,
> > +		unsigned long bootparams_load_addr,
> > +		unsigned long cmdline_offset, char *cmdline,
> > +		unsigned long cmdline_len)
> > +{
> > +	char *cmdline_ptr = ((char *)params) + cmdline_offset;
> > +	unsigned long cmdline_ptr_phys;
> > +	uint32_t cmdline_low_32, cmdline_ext_32;
> > +
> > +	memcpy(cmdline_ptr, cmdline, cmdline_len);
> > +	cmdline_ptr[cmdline_len - 1] = '\0';
> > +
> > +	cmdline_ptr_phys = bootparams_load_addr + cmdline_offset;
> > +	cmdline_low_32 = cmdline_ptr_phys & 0xffffffffUL;
> 
> GENMASK

Will change.

> 
> > +	cmdline_ext_32 = cmdline_ptr_phys >> 32;
> > +
> > +	params->hdr.cmd_line_ptr = cmdline_low_32;
> > +	if (cmdline_ext_32)
> > +		params->ext_cmd_line_ptr = cmdline_ext_32;
> > +
> > +	return 0;
> > +}
> > +
> > +static int setup_memory_map_entries(struct boot_params *params)
> > +{
> > +	unsigned int nr_e820_entries;
> > +
> > +	/* TODO: What about EFI */
> 
> You're removing this line in 13/13 so don't add it at all... ?

Yep. Will remove.

[..]
> > +	/* Setup EDD info */
> > +	memcpy(params->eddbuf, boot_params.eddbuf,
> > +				EDDMAXNR * sizeof(struct edd_info));
> 				^^^^^^^^^^^^^^
> 
> Shouldn't you just copy eddbuf_entries many instead of EDDMAXNR?
> 

I think it just makes it safer that we don't try to copy more than
size of destination, in case ->eddbuf_entries is not right or corrupted.

I see copy_edd() does similar thing.

memcpy(edd.edd_info, boot_params.eddbuf, sizeof(edd.edd_info));
edd.edd_info_nr = boot_params.eddbuf_entries;

So may be it is not a bad idea to copy based on max size of data
structures.

> > +	params->eddbuf_entries = boot_params.eddbuf_entries;
> > +

Thanks
Vivek
