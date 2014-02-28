Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752305AbaB1O6h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 09:58:37 -0500
Received: from mail.skyhub.de ([78.46.96.112]:40877 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751628AbaB1O6g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 09:58:36 -0500
Date: Fri, 28 Feb 2014 15:58:32 +0100
From: Borislav Petkov <bp@alien8.de>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        ebiederm@xmission.com, hpa@zytor.com, mjg59@srcf.ucam.org,
        greg@kroah.com, jkosina@suse.cz
Subject: Re: [PATCH 10/11] kexec: Support for loading ELF x86_64 images
Message-ID: <20140228145832.GF4326@pd.tnic>
References: <1390849071-21989-1-git-send-email-vgoyal@redhat.com>
 <1390849071-21989-11-git-send-email-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1390849071-21989-11-git-send-email-vgoyal@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 27, 2014 at 01:57:50PM -0500, Vivek Goyal wrote:
> This patch provides support for kexec for loading ELF x86_64 images. I have
> tested it with loading vmlinux and it worked.

Can you please enlighten me what the use case for ELF kernel images is? bzImage
I understand but what produces ELF images?

I see that kexec_file_load() can receive ELF segments too but why are we
doing that?

> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  arch/x86/include/asm/kexec-elf.h   |  11 ++
>  arch/x86/kernel/Makefile           |   1 +
>  arch/x86/kernel/kexec-elf.c        | 231 +++++++++++++++++++++++++++++++++++++
>  arch/x86/kernel/machine_kexec_64.c |   2 +
>  4 files changed, 245 insertions(+)
>  create mode 100644 arch/x86/include/asm/kexec-elf.h
>  create mode 100644 arch/x86/kernel/kexec-elf.c
> 
> diff --git a/arch/x86/include/asm/kexec-elf.h b/arch/x86/include/asm/kexec-elf.h
> new file mode 100644
> index 0000000..afef382
> --- /dev/null
> +++ b/arch/x86/include/asm/kexec-elf.h
> @@ -0,0 +1,11 @@
> +#ifndef _ASM_KEXEC_ELF_H
> +#define _ASM_KEXEC_ELF_H
> +
> +extern int elf_x86_64_probe(const char *buf, unsigned long len);
> +extern void *elf_x86_64_load(struct kimage *image, char *kernel,
> +		unsigned long kernel_len, char *initrd,
> +		unsigned long initrd_len, char *cmdline,
> +		unsigned long cmdline_len);
> +extern int elf_x86_64_cleanup(struct kimage *image);
> +
> +#endif  /* _ASM_KEXEC_ELF_H */
> diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
> index fa9981d..2d77de7 100644
> --- a/arch/x86/kernel/Makefile
> +++ b/arch/x86/kernel/Makefile
> @@ -71,6 +71,7 @@ obj-$(CONFIG_KEXEC)		+= machine_kexec.o
>  obj-$(CONFIG_KEXEC)		+= machine_kexec_$(BITS).o
>  obj-$(CONFIG_KEXEC)		+= relocate_kernel_$(BITS).o crash.o
>  obj-$(CONFIG_KEXEC)		+= kexec-bzimage.o
> +obj-$(CONFIG_KEXEC)		+= kexec-elf.o

It looks like kexec could slowly grow its own dir now:

arch/x86/kexec/

or so.

>  obj-$(CONFIG_CRASH_DUMP)	+= crash_dump_$(BITS).o
>  obj-y				+= kprobes/
>  obj-$(CONFIG_MODULES)		+= module.o
> diff --git a/arch/x86/kernel/kexec-elf.c b/arch/x86/kernel/kexec-elf.c
> new file mode 100644
> index 0000000..ff1017c
> --- /dev/null
> +++ b/arch/x86/kernel/kexec-elf.c
> @@ -0,0 +1,231 @@
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
> +struct elf_x86_64_data {
> +	/*
> +	 * Temporary buffer to hold bootparams buffer. This should be
> +	 * freed once the bootparam segment has been loaded.
> +	 */
> +	void *bootparams_buf;
> +};
> +
> +int elf_x86_64_probe(const char *buf, unsigned long len)
> +{
> +	int ret = -ENOEXEC;
> +	Elf_Ehdr *ehdr;
> +
> +	if (len < sizeof(Elf_Ehdr)) {
> +		pr_debug("File is too short to be an ELF executable.\n");
> +		return ret;
> +	}
> +
> +	ehdr = (Elf_Ehdr *)buf;
> +
> +	if (memcmp(ehdr->e_ident, ELFMAG, SELFMAG) != 0
> +	    || ehdr->e_type != ET_EXEC || !elf_check_arch(ehdr)
> +	    || ehdr->e_phentsize != sizeof(Elf_Phdr))
> +		return -ENOEXEC;
> +
> +	if (ehdr->e_phoff >= len
> +	    || (ehdr->e_phnum * sizeof(Elf_Phdr) > len - ehdr->e_phoff))
> +		return -ENOEXEC;
> +
> +        /* I've got a bzImage */
> +	pr_debug("It's an elf_x86_64 image.\n");
> +	ret = 0;
> +
> +	return ret;

I think you can drop 'ret' here and return the error vals directly.

> +}
> +
> +static int elf_exec_load(struct kimage *image, char *kernel)
> +{
> +	Elf_Ehdr *ehdr;
> +	Elf_Phdr *phdrs;
> +	int i, ret;
> +	size_t filesz;
> +	char *buffer;
> +
> +	ehdr = (Elf_Ehdr *)kernel;
> +	phdrs = (void *)ehdr + ehdr->e_phoff;
> +
> +	for (i = 0; i < ehdr->e_phnum; i++) {
> +		if (phdrs[i].p_type != PT_LOAD)
> +			continue;

newline

> +		filesz = phdrs[i].p_filesz;
> +		if (filesz > phdrs[i].p_memsz)
> +			filesz = phdrs[i].p_memsz;
> +
> +		buffer = (char *)ehdr + phdrs[i].p_offset;
> +		ret = kexec_add_segment(image, buffer, filesz, phdrs[i].p_memsz,
> +						phdrs[i].p_paddr);
> +		if (ret)
> +			break;
> +	}
> +
> +	return ret;
> +}
> +
> +/* Fill in fields which are usually present in bzImage */
> +static int init_linux_parameters(struct boot_params *params)
> +{
> +	/*
> +	 * FIXME: It is odd that the information which comes from kernel
> +	 * has to be faked by loading kernel. I guess it is limitation of
> +	 * ELF format. Right now keeping it same as kexec-tools
> +	 * implementation. But this most likely needs fixing.
> +	 */
> +	memcpy(&params->hdr.header, "HdrS", 4);
> +	params->hdr.version = 0x0206;
> +	params->hdr.initrd_addr_max = 0x37FFFFFF;
> +	params->hdr.cmdline_size = 2048;
> +	return 0;
> +}

Why a separate function? Its body is small enough to be merged into
elf_x86_64_load.

> +
> +void *elf_x86_64_load(struct kimage *image, char *kernel,
> +		unsigned long kernel_len,
> +		char *initrd, unsigned long initrd_len,
> +		char *cmdline, unsigned long cmdline_len)
> +{

Btw, this functionality below looks very similar to the one in
bzImage64_load(). Can we share some of it?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
