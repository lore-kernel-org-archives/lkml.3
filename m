Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752817AbaB1RM3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 12:12:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22393 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752343AbaB1RM2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 12:12:28 -0500
Date: Fri, 28 Feb 2014 12:11:43 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        ebiederm@xmission.com, hpa@zytor.com, mjg59@srcf.ucam.org,
        greg@kroah.com, jkosina@suse.cz
Subject: Re: [PATCH 10/11] kexec: Support for loading ELF x86_64 images
Message-ID: <20140228171142.GI28744@redhat.com>
References: <1390849071-21989-1-git-send-email-vgoyal@redhat.com>
 <1390849071-21989-11-git-send-email-vgoyal@redhat.com>
 <20140228145832.GF4326@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140228145832.GF4326@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 28, 2014 at 03:58:32PM +0100, Borislav Petkov wrote:
> On Mon, Jan 27, 2014 at 01:57:50PM -0500, Vivek Goyal wrote:
> > This patch provides support for kexec for loading ELF x86_64 images. I have
> > tested it with loading vmlinux and it worked.
> 
> Can you please enlighten me what the use case for ELF kernel images is? bzImage
> I understand but what produces ELF images?

Before bzImage is generated, we produce an ELF vmlinux (linux-2.6/vmlinux).
And then this vmlinux is processed further to produce bzImage.

In theory you can load this vmlinux and boot into it using kexec system
call.

In general, Eric wanted to support ELF images hence I put in this patch.

> 
> I see that kexec_file_load() can receive ELF segments too but why are we
> doing that?

So kexec_file_load() does not know what kind of file it is. Whether an
ELF file or an bzImage file. It will just call all the image loaders and
see if some loader recognizes the file and claims it.

So idea is what kind of image one should be able to load using this
new system call and kexec into. 

My primary use case is bzImage. Others think that it should be generic
enough to be able to handle ELF too.

> 
> > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> > ---
> >  arch/x86/include/asm/kexec-elf.h   |  11 ++
> >  arch/x86/kernel/Makefile           |   1 +
> >  arch/x86/kernel/kexec-elf.c        | 231 +++++++++++++++++++++++++++++++++++++
> >  arch/x86/kernel/machine_kexec_64.c |   2 +
> >  4 files changed, 245 insertions(+)
> >  create mode 100644 arch/x86/include/asm/kexec-elf.h
> >  create mode 100644 arch/x86/kernel/kexec-elf.c
> > 
> > diff --git a/arch/x86/include/asm/kexec-elf.h b/arch/x86/include/asm/kexec-elf.h
> > new file mode 100644
> > index 0000000..afef382
> > --- /dev/null
> > +++ b/arch/x86/include/asm/kexec-elf.h
> > @@ -0,0 +1,11 @@
> > +#ifndef _ASM_KEXEC_ELF_H
> > +#define _ASM_KEXEC_ELF_H
> > +
> > +extern int elf_x86_64_probe(const char *buf, unsigned long len);
> > +extern void *elf_x86_64_load(struct kimage *image, char *kernel,
> > +		unsigned long kernel_len, char *initrd,
> > +		unsigned long initrd_len, char *cmdline,
> > +		unsigned long cmdline_len);
> > +extern int elf_x86_64_cleanup(struct kimage *image);
> > +
> > +#endif  /* _ASM_KEXEC_ELF_H */
> > diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
> > index fa9981d..2d77de7 100644
> > --- a/arch/x86/kernel/Makefile
> > +++ b/arch/x86/kernel/Makefile
> > @@ -71,6 +71,7 @@ obj-$(CONFIG_KEXEC)		+= machine_kexec.o
> >  obj-$(CONFIG_KEXEC)		+= machine_kexec_$(BITS).o
> >  obj-$(CONFIG_KEXEC)		+= relocate_kernel_$(BITS).o crash.o
> >  obj-$(CONFIG_KEXEC)		+= kexec-bzimage.o
> > +obj-$(CONFIG_KEXEC)		+= kexec-elf.o
> 
> It looks like kexec could slowly grow its own dir now:
> 
> arch/x86/kexec/

I was rather thinking of arch/x86/kernel/kexec. But that's for some other
day. Not part of this patchset. This is alredy too big and I don't want
to make any changes which are nice to have and bloat the patch size.

> 
> or so.
> 
> >  obj-$(CONFIG_CRASH_DUMP)	+= crash_dump_$(BITS).o
> >  obj-y				+= kprobes/
> >  obj-$(CONFIG_MODULES)		+= module.o
> > diff --git a/arch/x86/kernel/kexec-elf.c b/arch/x86/kernel/kexec-elf.c
> > new file mode 100644
> > index 0000000..ff1017c
> > --- /dev/null
> > +++ b/arch/x86/kernel/kexec-elf.c
> > @@ -0,0 +1,231 @@
> > +#include <linux/string.h>
> > +#include <linux/printk.h>
> > +#include <linux/errno.h>
> > +#include <linux/slab.h>
> > +#include <linux/kexec.h>
> > +#include <linux/kernel.h>
> > +#include <linux/mm.h>
> > +
> > +#include <asm/bootparam.h>
> > +#include <asm/setup.h>
> > +
> > +#ifdef CONFIG_X86_64
> > +
> > +struct elf_x86_64_data {
> > +	/*
> > +	 * Temporary buffer to hold bootparams buffer. This should be
> > +	 * freed once the bootparam segment has been loaded.
> > +	 */
> > +	void *bootparams_buf;
> > +};
> > +
> > +int elf_x86_64_probe(const char *buf, unsigned long len)
> > +{
> > +	int ret = -ENOEXEC;
> > +	Elf_Ehdr *ehdr;
> > +
> > +	if (len < sizeof(Elf_Ehdr)) {
> > +		pr_debug("File is too short to be an ELF executable.\n");
> > +		return ret;
> > +	}
> > +
> > +	ehdr = (Elf_Ehdr *)buf;
> > +
> > +	if (memcmp(ehdr->e_ident, ELFMAG, SELFMAG) != 0
> > +	    || ehdr->e_type != ET_EXEC || !elf_check_arch(ehdr)
> > +	    || ehdr->e_phentsize != sizeof(Elf_Phdr))
> > +		return -ENOEXEC;
> > +
> > +	if (ehdr->e_phoff >= len
> > +	    || (ehdr->e_phnum * sizeof(Elf_Phdr) > len - ehdr->e_phoff))
> > +		return -ENOEXEC;
> > +
> > +        /* I've got a bzImage */
> > +	pr_debug("It's an elf_x86_64 image.\n");
> > +	ret = 0;
> > +
> > +	return ret;
> 
> I think you can drop 'ret' here and return the error vals directly.

Yep, will simplify this one.

> 
> > +}
> > +
> > +static int elf_exec_load(struct kimage *image, char *kernel)
> > +{
> > +	Elf_Ehdr *ehdr;
> > +	Elf_Phdr *phdrs;
> > +	int i, ret;
> > +	size_t filesz;
> > +	char *buffer;
> > +
> > +	ehdr = (Elf_Ehdr *)kernel;
> > +	phdrs = (void *)ehdr + ehdr->e_phoff;
> > +
> > +	for (i = 0; i < ehdr->e_phnum; i++) {
> > +		if (phdrs[i].p_type != PT_LOAD)
> > +			continue;
> 
> newline

What's that?

> 
> > +		filesz = phdrs[i].p_filesz;
> > +		if (filesz > phdrs[i].p_memsz)
> > +			filesz = phdrs[i].p_memsz;
> > +
> > +		buffer = (char *)ehdr + phdrs[i].p_offset;
> > +		ret = kexec_add_segment(image, buffer, filesz, phdrs[i].p_memsz,
> > +						phdrs[i].p_paddr);
> > +		if (ret)
> > +			break;
> > +	}
> > +
> > +	return ret;
> > +}
> > +
> > +/* Fill in fields which are usually present in bzImage */
> > +static int init_linux_parameters(struct boot_params *params)
> > +{
> > +	/*
> > +	 * FIXME: It is odd that the information which comes from kernel
> > +	 * has to be faked by loading kernel. I guess it is limitation of
> > +	 * ELF format. Right now keeping it same as kexec-tools
> > +	 * implementation. But this most likely needs fixing.
> > +	 */
> > +	memcpy(&params->hdr.header, "HdrS", 4);
> > +	params->hdr.version = 0x0206;
> > +	params->hdr.initrd_addr_max = 0x37FFFFFF;
> > +	params->hdr.cmdline_size = 2048;
> > +	return 0;
> > +}
> 
> Why a separate function? Its body is small enough to be merged into
> elf_x86_64_load.

Actually this logic shows the limitation of ELF format kernel image.
This information should be exported by the image so that loader can
do some verifications. But instead loader is hardcoding this info and
faking things.

For example, it should be kernel which tells what's the maximum command
line size it can handle and then loader can return error if user specified
command line size is greater than what new kernel can handle.

Similarly, what's the max address initrd can be loaded at.

Actually I have copied this code from kexec-tools. And I am wondering
if some of this is 

I am not sure why we set hdr.version and hdr.header. Are there any
assumptions in booth path kernel is making. May be some other code
down the line is parsing it or it is completely redundant. I think
I will play with removing setting of hdr.version and hdr.header and
see how does it go.

so I put it in a separate function because user space code had it
that way. Also because I did not like this part of the code and this
looks like a limitation of ELF format, I wanted to isolate it in
a separate function so that it is easy to spot it.

> 
> > +
> > +void *elf_x86_64_load(struct kimage *image, char *kernel,
> > +		unsigned long kernel_len,
> > +		char *initrd, unsigned long initrd_len,
> > +		char *cmdline, unsigned long cmdline_len)
> > +{
> 
> Btw, this functionality below looks very similar to the one in
> bzImage64_load(). Can we share some of it?

It looks similar but values with which some of the functions are called
are different. I will see if there are some obivious candidate to share
the code. It is not a lot of code to begin with.

Thanks
Vivek
