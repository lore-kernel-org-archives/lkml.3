Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752702AbaB1Qc1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 11:32:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56536 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751677AbaB1QcZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 11:32:25 -0500
Date: Fri, 28 Feb 2014 11:31:35 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        ebiederm@xmission.com, hpa@zytor.com, mjg59@srcf.ucam.org,
        greg@kroah.com, jkosina@suse.cz
Subject: Re: [PATCH 08/11] kexec-bzImage: Support for loading bzImage using
 64bit entry
Message-ID: <20140228163134.GG28744@redhat.com>
References: <1390849071-21989-1-git-send-email-vgoyal@redhat.com>
 <1390849071-21989-9-git-send-email-vgoyal@redhat.com>
 <20140227213629.GP18191@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140227213629.GP18191@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 27, 2014 at 10:36:29PM +0100, Borislav Petkov wrote:

Hi Boris,

Thanks for taking time to review this large patchset. Please find
my comments inline.

[..]
> > diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
> > index cb648c8..fa9981d 100644
> > --- a/arch/x86/kernel/Makefile
> > +++ b/arch/x86/kernel/Makefile
> > @@ -67,8 +67,10 @@ obj-$(CONFIG_DYNAMIC_FTRACE)	+= ftrace.o
> >  obj-$(CONFIG_FUNCTION_GRAPH_TRACER) += ftrace.o
> >  obj-$(CONFIG_FTRACE_SYSCALLS)	+= ftrace.o
> >  obj-$(CONFIG_X86_TSC)		+= trace_clock.o
> > +obj-$(CONFIG_KEXEC)		+= machine_kexec.o
> >  obj-$(CONFIG_KEXEC)		+= machine_kexec_$(BITS).o
> >  obj-$(CONFIG_KEXEC)		+= relocate_kernel_$(BITS).o crash.o
> > +obj-$(CONFIG_KEXEC)		+= kexec-bzimage.o
> 
> Maybe use less obj-$(CONFIG_KEXEC) lines here.

Ok, Will put some of them in single line.

[..]
> > +struct bzimage64_data {
> > +	/*
> > +	 * Temporary buffer to hold bootparams buffer. This should be
> > +	 * freed once the bootparam segment has been loaded.
> > +	 */
> > +	void *bootparams_buf;
> > +};
> 
> Why a struct if it is going to have only one member?

Well, I had started with a generic idea of bootloader being able to store
some data in image and retrieve it later. Finally it turned out to be only
one field in current implementation.

But I still like it as it allows storing more data down the line. There
is no other place where we can store bootloader specific data. So this
is the mechanism I created.

> 
> > +
> > +int bzImage64_probe(const char *buf, unsigned long len)
> > +{
> > +	int ret = -ENOEXEC;
> > +	struct setup_header *header;
> > +
> > +	if (len < 2 * 512) {
> 
> What's 2*512? Two sectors?

Yep, two sectors.

> 
> > +		pr_debug("File is too short to be a bzImage\n");
> > +		return ret;
> > +	}
> > +
> > +	header = (struct setup_header *)(buf + 0x1F1);
> 
> 0x1F1 should need at least a comment or "offsetof(struct boot_params, hdr)"
> or both, which would be best. :-)

Ok, I will put a comment.

> 
> > +	if (memcmp((char *)&header->header, "HdrS", 4) != 0) {
> > +		pr_debug("Not a bzImage\n");
> 
> Actually, I think that means that there is no real mode kernel header
> there, or we're using an old boot protocol version:

So Documentation/x86/boot.txt says following.


If the "HdrS" (0x53726448) magic number is not found at offset 0x202,
the boot protocol version is "old".  Loading an old kernel, the
following parameters should be assumed:

        Image type = zImage
        initrd not supported
        Real-mode kernel must be located at 0x90000.

So if it is old version then it is zImage (and not bzImage). So pr_debug()
message seems to be correct that image one is trying to load is not
bzImage and this loader will not handle this image.

> 
> Documentation/x86/boot.txt
> 
> > +		return ret;
> > +	}
> > +
> > +	if (header->boot_flag != 0xAA55) {
> > +                /* No x86 boot sector present */
> 
> Comment is kinda redundant here :)

Ok, will get rid of it.

> 
> > +		pr_debug("No x86 boot sector present\n");
> > +		return ret;
> > +	}
> > +
> > +	if (header->version < 0x020C) {
> > +                /* Must be at least protocol version 2.12 */
> 
> Ditto.

Will get rid of it.

> 
> > +		pr_debug("Must be at least protocol version 2.12\n");
> > +		return ret;
> > +	}
> > +
> > +	if ((header->loadflags & 1) == 0) {
> 
> That must be LOADED_HIGH bit. Why does this bit mean it is a bzImage?

Yep, that's LOADED_HIGH check. I think if LOADED_HIGH is not set, then
that means protected mode code needs to be loaded at 0x10000 and I think
that also means that it is zImage and not bzImage.

Atleast this loader does not handle anything which is that old where
protected mode code needs to be loaded at 0x10000.

> 
> Ok, I see it in boot.txt:
> 
> "...
> 	When loading a zImage kernel ((loadflags & 0x01) == 0).
> "
> 
> > +		/* Not a bzImage */
> > +		pr_debug("zImage not a bzImage\n");
> > +		return ret;
> > +	}
> > +
> > +	if ((header->xloadflags & 3) != 3) {
> > +	/* XLF_KERNEL_64 and XLF_CAN_BE_LOADED_ABOVE_4G should be set */
> 
> Use those defines in the code please instead of naked numbers.

Agreed. Using these defines is more readable. Will change it.


[..]
> > +void *bzImage64_load(struct kimage *image, char *kernel,
> > +		unsigned long kernel_len,
> > +		char *initrd, unsigned long initrd_len,
> > +		char *cmdline, unsigned long cmdline_len)
> > +{
> > +
> > +	struct setup_header *header;
> > +	int setup_sects, kern16_size, ret = 0;
> > +	unsigned long setup_header_size, params_cmdline_sz;
> > +	struct boot_params *params;
> > +	unsigned long bootparam_load_addr, kernel_load_addr, initrd_load_addr;
> > +	unsigned long purgatory_load_addr;
> > +	unsigned long kernel_bufsz, kernel_memsz, kernel_align;
> > +	char *kernel_buf;
> > +	struct bzimage64_data *ldata;
> > +	struct kexec_entry64_regs regs64;
> > +	void *stack;
> > +
> > +	header = (struct setup_header *)(kernel + 0x1F1);
> 
> See above.

Will comment or use offsetof().

[..]
> > +	/* Allocate loader specific data */
> > +	ldata = kzalloc(sizeof(struct bzimage64_data), GFP_KERNEL);
> > +	if (!ldata)
> > +		return ERR_PTR(-ENOMEM);
> > +
> > +	/*
> > +	 * Load purgatory. For 64bit entry point, purgatory  code can be
> > +	 * anywhere.
> > +	 */
> > +	ret = kexec_load_purgatory(image, 0x3000, -1, 1, &purgatory_load_addr);
> 
> Some defines like MIN_<something> and MAX_<something> could be more
> readable here.

Ok, atleast will use MAX_<something> for "-1". I might define one
internally to this file for representing minimum address of 0x3000.

> 
> > +	if (ret) {
> > +		pr_debug("Loading purgatory failed\n");
> > +		goto out_free_loader_data;
> > +	}
> > +
> > +	pr_debug("Loaded purgatory at 0x%lx\n", purgatory_load_addr);
> > +
> > +	/* Load Bootparams and cmdline */
> > +	params_cmdline_sz = sizeof(struct boot_params) + cmdline_len;
> > +	params = kzalloc(params_cmdline_sz, GFP_KERNEL);
> > +	if (!params) {
> > +		ret = -ENOMEM;
> > +		goto out_free_loader_data;
> > +	}
> > +
> > +	/* Copy setup header onto bootparams. */
> > +	setup_header_size = 0x0202 + kernel[0x0201] - 0x1F1;
> 
> More magic numbers :-\ Ok, I'm not going to comment on the rest of them
> below but you get the idea - it would be much better to have descriptive
> defines here instead of naked numbers.

That's how boot.txt defines it. Look at 64-bit BOOT PROTOCOL.

0x0202 + byte value at offset 0x0201

Now one can argue that create some new defines to represent those magic
numbers and include that file in kexec-bzimage loader. I will see what
can I do.

> 
> > +
> > +	/* Is there a limit on setup header size? */
> > +	memcpy(&params->hdr, (kernel + 0x1F1), setup_header_size);
> > +	ret = kexec_add_buffer(image, (char *)params, params_cmdline_sz,
> > +			params_cmdline_sz, 16, 0x3000, -1, 1,
> > +			&bootparam_load_addr);
> 
> Normally we do arg alignment below the opening brace of the function.
> Ditto for a bunch of call sites below.

Hmm.., I have seen all kinds of alignments. But anyway, if you prefer
that, I will change atleast some of them.

[..]
> > +#include <linux/kernel.h>
> > +#include <linux/string.h>
> > +#include <asm/bootparam.h>
> > +#include <asm/setup.h>
> > +
> > +/*
> > + * Common code for x86 and x86_64 used for kexec.
> 
> I think you mean i386 by x86, right?

Yes.

[..]
> > +static int setup_memory_map_entries(struct boot_params *params)
> > +{
> > +	unsigned int nr_e820_entries;
> > +
> > +	/* TODO: What about EFI */
> 
> Do you mean by that what do_add_efi_memmap() does? We add the efi
> entries only when add_efi_memmap is supplied on the cmdline, see
> 200001eb140ea.

I meant in general I have not done any EFI handling. I am not even
sure what needs to be done for EFI. I am just going through memory
map and filling up E820 map in bootparams so that second kernel knows
what are the memory areas available.

At some point of time we need to start passing EFI memory map to
second kernel. (All the new code you and dave young have added to
make kexec work on EFI systems).

I wanted to that in a separate patch. This patch series is alredy very
big. bzImage signing and verification also I am planning to post in a
separate series.

Thanks
Vivek
