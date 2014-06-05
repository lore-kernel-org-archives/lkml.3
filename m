Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752045AbaFEUIh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 16:08:37 -0400
Received: from mail.skyhub.de ([78.46.96.112]:43082 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751644AbaFEUId (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 16:08:33 -0400
Date: Thu, 5 Jun 2014 22:05:23 +0200
From: Borislav Petkov <bp@alien8.de>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        ebiederm@xmission.com, hpa@zytor.com, mjg59@srcf.ucam.org,
        greg@kroah.com, jkosina@suse.cz, dyoung@redhat.com,
        chaowang@redhat.com, bhe@redhat.com, akpm@linux-foundation.org
Subject: Re: [PATCH 09/13] purgatory: Core purgatory functionality
Message-ID: <20140605200523.GB26110@pd.tnic>
References: <1401800822-27425-1-git-send-email-vgoyal@redhat.com>
 <1401800822-27425-10-git-send-email-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1401800822-27425-10-git-send-email-vgoyal@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 03, 2014 at 09:06:58AM -0400, Vivek Goyal wrote:
> Create a stand alone relocatable object purgatory which runs between two
> kernels. This name, concept and some code has been taken from kexec-tools.
> Idea is that this code runs after a crash and it runs in minimal environment.
> So keep it separate from rest of the kernel and in long term we will have
> to practically do no maintenance of this code.
> 
> This code also has the logic to do verify sha256 hashes of various
> segments which have been loaded into memory. So first we verify that
> the kernel we are jumping to is fine and has not been corrupted and
> make progress only if checsums are verified.
> 
> This code also takes care of copying some memory contents to backup region.
> 
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  arch/x86/Kbuild                   |   1 +
>  arch/x86/Makefile                 |   6 +++
>  arch/x86/purgatory/Makefile       |  35 +++++++++++++
>  arch/x86/purgatory/entry64.S      | 101 ++++++++++++++++++++++++++++++++++++++
>  arch/x86/purgatory/purgatory.c    |  71 +++++++++++++++++++++++++++
>  arch/x86/purgatory/setup-x86_32.S |  17 +++++++
>  arch/x86/purgatory/setup-x86_64.S |  58 ++++++++++++++++++++++
>  arch/x86/purgatory/stack.S        |  19 +++++++
>  arch/x86/purgatory/string.c       |  13 +++++
>  9 files changed, 321 insertions(+)
>  create mode 100644 arch/x86/purgatory/Makefile
>  create mode 100644 arch/x86/purgatory/entry64.S
>  create mode 100644 arch/x86/purgatory/purgatory.c
>  create mode 100644 arch/x86/purgatory/setup-x86_32.S
>  create mode 100644 arch/x86/purgatory/setup-x86_64.S
>  create mode 100644 arch/x86/purgatory/stack.S
>  create mode 100644 arch/x86/purgatory/string.c
> 
> diff --git a/arch/x86/Kbuild b/arch/x86/Kbuild
> index e5287d8..faaeee7 100644
> --- a/arch/x86/Kbuild
> +++ b/arch/x86/Kbuild
> @@ -16,3 +16,4 @@ obj-$(CONFIG_IA32_EMULATION) += ia32/
>  
>  obj-y += platform/
>  obj-y += net/
> +obj-$(CONFIG_KEXEC) += purgatory/
> diff --git a/arch/x86/Makefile b/arch/x86/Makefile
> index 33f71b0..0b25c6c 100644
> --- a/arch/x86/Makefile
> +++ b/arch/x86/Makefile
> @@ -186,6 +186,11 @@ archscripts: scripts_basic
>  archheaders:
>  	$(Q)$(MAKE) $(build)=arch/x86/syscalls all
>  
> +archprepare:
> +ifeq ($(CONFIG_KEXEC),y)
> +	$(Q)$(MAKE) $(build)=arch/x86/purgatory arch/x86/purgatory/kexec-purgatory.c
> +endif
> +
>  ###
>  # Kernel objects
>  
> @@ -249,6 +254,7 @@ archclean:
>  	$(Q)rm -rf $(objtree)/arch/x86_64
>  	$(Q)$(MAKE) $(clean)=$(boot)
>  	$(Q)$(MAKE) $(clean)=arch/x86/tools

ifeq ($(CONFIG_KEXEC),y)
	$(Q)$(MAKE) $(clean)=arch/x86/purgatory
endif

>  
>  PHONY += kvmconfig
>  kvmconfig:
> diff --git a/arch/x86/purgatory/Makefile b/arch/x86/purgatory/Makefile
> new file mode 100644
> index 0000000..8dbf8f5
> --- /dev/null
> +++ b/arch/x86/purgatory/Makefile
> @@ -0,0 +1,35 @@
> +ifeq ($(CONFIG_X86_64),y)
> +	purgatory-y := purgatory.o entry64.o stack.o setup-x86_64.o sha256.o string.o
> +else
> +	purgatory-y := purgatory.o stack.o sha256.o setup-x86_32.o
> +endif
> +
> +targets += $(purgatory-y)
> +PURGATORY_OBJS = $(addprefix $(obj)/,$(purgatory-y))
> +
> +LDFLAGS_purgatory.ro := -e purgatory_start -r --no-undefined -nostdlib -z nodefaultlib
> +targets += purgatory.ro
> +
> +# Default KBUILD_CFLAGS can have -pg option set when FTRACE is enabled. That
> +# in turn leaves some undefined symbols like __fentry__ in purgatory and not
> +# sure how to relocate those. Like kexec-tools, custom flags.
> +
> +ifeq ($(CONFIG_X86_64),y)
> +KBUILD_CFLAGS	:= -fno-strict-aliasing -Wall -Wstrict-prototypes -fno-zero-initialized-in-bss -mcmodel=large -Os -fno-builtin -ffreestanding -c -MD
> +else
> +KBUILD_CFLAGS	:= -fno-strict-aliasing -Wall -Wstrict-prototypes -fno-zero-initialized-in-bss -Os -fno-builtin -ffreestanding -c -MD -m32
> +endif

Those variable assignments have a lot of duplication, let's simplify
(diff ontop):


Index: b/arch/x86/purgatory/Makefile
===================================================================
--- a/arch/x86/purgatory/Makefile	2014-06-05 21:43:31.957252700 +0200
+++ b/arch/x86/purgatory/Makefile	2014-06-05 21:42:12.743256165 +0200
@@ -1,7 +1,7 @@
+purgatory-y := purgatory.o stack.o setup-x86_$(BITS).o sha256.o
+
 ifeq ($(CONFIG_X86_64),y)
-	purgatory-y := purgatory.o entry64.o stack.o setup-x86_64.o sha256.o string.o
-else
-	purgatory-y := purgatory.o stack.o sha256.o setup-x86_32.o
+	purgatory-y += entry64.o string.o
 endif
 
 targets += $(purgatory-y)
@@ -14,10 +14,12 @@ targets += purgatory.ro
 # in turn leaves some undefined symbols like __fentry__ in purgatory and not
 # sure how to relocate those. Like kexec-tools, custom flags.
 
+KBUILD_CFLAGS := -fno-strict-aliasing -Wall -Wstrict-prototypes -fno-zero-initialized-in-bss -fno-builtin -ffreestanding -c -MD -Os
+
 ifeq ($(CONFIG_X86_64),y)
-KBUILD_CFLAGS	:= -fno-strict-aliasing -Wall -Wstrict-prototypes -fno-zero-initialized-in-bss -mcmodel=large -Os -fno-builtin -ffreestanding -c -MD
+KBUILD_CFLAGS	+= -mcmodel=large
 else
-KBUILD_CFLAGS	:= -fno-strict-aliasing -Wall -Wstrict-prototypes -fno-zero-initialized-in-bss -Os -fno-builtin -ffreestanding -c -MD -m32
+KBUILD_CFLAGS	+= -m32
 endif
 
 $(obj)/purgatory.ro: $(PURGATORY_OBJS) FORCE

> +
> +$(obj)/purgatory.ro: $(PURGATORY_OBJS) FORCE
> +		$(call if_changed,ld)
> +
> +targets += kexec-purgatory.c
> +
> +quiet_cmd_bin2c = BIN2C   $@
> +      cmd_bin2c = cat $(obj)/purgatory.ro | $(srctree)/scripts/basic/bin2c kexec_purgatory > $(obj)/kexec-purgatory.c
> +
> +$(obj)/kexec-purgatory.c: $(obj)/purgatory.ro FORCE
> +	$(call if_changed,bin2c)
> +
> +
> +obj-$(CONFIG_KEXEC)	+= kexec-purgatory.o
> diff --git a/arch/x86/purgatory/entry64.S b/arch/x86/purgatory/entry64.S
> new file mode 100644
> index 0000000..219b50b
> --- /dev/null
> +++ b/arch/x86/purgatory/entry64.S
> @@ -0,0 +1,101 @@
> +/*
> + * Copyright (C) 2003,2004  Eric Biederman (ebiederm@xmission.com)
> + * Copyright (C) 2014  Red Hat Inc.
> +
> + * Author(s): Vivek Goyal <vgoyal@redhat.com>
> + *
> + * This code has been taken from kexec-tools.
> + *
> + * This source code is licensed under the GNU General Public License,
> + * Version 2.  See the file COPYING for more details.
> + */
> +
> +	.text
> +	.balign 16
> +	.code64
> +	.globl entry64, entry64_regs
> +
> +
> +entry64:
> +	/* Setup a gdt that should be preserved */
> +	lgdt gdt(%rip)
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
> +	/* Load the registers */
> +	movq	rax(%rip), %rax
> +	movq	rbx(%rip), %rbx
> +	movq	rcx(%rip), %rcx
> +	movq	rdx(%rip), %rdx
> +	movq	rsi(%rip), %rsi
> +	movq	rdi(%rip), %rdi
> +	movq    rsp(%rip), %rsp
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
> +	.section ".rodata"
> +	.balign 4
> +entry64_regs:
> +rax:	.quad 0x00000000

Simply 0x0? Or am I missing something?

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
> +	.size entry64_regs, . - entry64_regs
> +
> +	/* GDT */
> +	.section ".rodata"
> +	.balign 16
> +gdt:
> +	/* 0x00 unusable segment
> +	 * 0x08 unused
> +	 * so use them as gdt ptr
> +	 */
> +	.word gdt_end - gdt - 1
> +	.quad gdt
> +	.word 0, 0, 0
> +
> +	/* 0x10 4GB flat code segment */
> +	.word 0xFFFF, 0x0000, 0x9A00, 0x00AF
> +
> +	/* 0x18 4GB flat data segment */
> +	.word 0xFFFF, 0x0000, 0x9200, 0x00CF
> +gdt_end:
> +stack:	.quad   0, 0
> +stack_init:
> diff --git a/arch/x86/purgatory/purgatory.c b/arch/x86/purgatory/purgatory.c
> new file mode 100644
> index 0000000..3a808db
> --- /dev/null
> +++ b/arch/x86/purgatory/purgatory.c
> @@ -0,0 +1,71 @@
> +/*
> + * purgatory: Runs between two kernels
> + *
> + * Copyright (C) 2014 Red Hat Inc.
> + *
> + * Author:
> + *       Vivek Goyal <vgoyal@redhat.com>
> + *
> + * This source code is licensed under the GNU General Public License,
> + * Version 2.  See the file COPYING for more details.
> + */
> +
> +#include "sha256.h"
> +#include "../boot/string.h"
> +
> +struct sha_region {
> +	unsigned long start;
> +	unsigned long len;
> +};
> +
> +unsigned long backup_dest = 0;
> +unsigned long backup_src = 0;
> +unsigned long backup_sz = 0;
> +
> +u8 sha256_digest[SHA256_DIGEST_SIZE] = { 0 };
> +
> +struct sha_region sha_regions[16] = {};
> +
> +/*
> + * On x86, second kernel requries first 640K of memory to boot. Copy
> + * first 640K to a backup region in reserved memory range so that second
> + * kernel can use first 640K.
> + */
> +static int copy_backup_region(void)
> +{
> +	if (backup_dest)
> +		memcpy((void *)backup_dest, (void *)backup_src, backup_sz);
> +
> +	return 0;
> +}
> +
> +int verify_sha256_digest(void)
> +{
> +	struct sha_region *ptr, *end;
> +	u8 digest[SHA256_DIGEST_SIZE];
> +	struct sha256_state sctx;
> +
> +	sha256_init(&sctx);
> +	end = &sha_regions[sizeof(sha_regions)/sizeof(sha_regions[0])];
> +	for (ptr = sha_regions; ptr < end; ptr++)
> +		sha256_update(&sctx, (uint8_t *)(ptr->start), ptr->len);
> +
> +	sha256_final(&sctx, digest);
> +
> +	if (memcmp(digest, sha256_digest, sizeof(digest)) != 0)

	if (memcmp(...))
		return 1;

should be a bit cleaner.

> +		return 1;
> +
> +	return 0;
> +}
> +
> +void purgatory(void)
> +{
> +	int ret;
> +
> +	ret = verify_sha256_digest();
> +	if (ret) {
> +		/* loop forever */
> +		for (;;);

checkpatch bitches about this:

ERROR: trailing statements should be on next line
#303: FILE: arch/x86/purgatory/purgatory.c:68:
+               for (;;);

> +	}
> +	copy_backup_region();
> +}
-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
