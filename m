Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751514AbaBZQAR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 11:00:17 -0500
Received: from mail.skyhub.de ([78.46.96.112]:33264 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750943AbaBZQAO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 11:00:14 -0500
Date: Wed, 26 Feb 2014 17:00:08 +0100
From: Borislav Petkov <bp@alien8.de>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        ebiederm@xmission.com, hpa@zytor.com, mjg59@srcf.ucam.org,
        greg@kroah.com, jkosina@suse.cz
Subject: Re: [PATCH 07/11] kexec: Create a relocatable object called purgatory
Message-ID: <20140226160008.GF22639@pd.tnic>
References: <1390849071-21989-1-git-send-email-vgoyal@redhat.com>
 <1390849071-21989-8-git-send-email-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1390849071-21989-8-git-send-email-vgoyal@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 27, 2014 at 01:57:47PM -0500, Vivek Goyal wrote:
> Create a stand alone relocatable object purgatory which runs between two
> kernels. This name, concept and some code has been taken from kexec-tools.

... and the concept probably originates from Dante's "Divine Comedy" :-P

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
> sha256 hash related code has been taken from crypto/sha256_generic.c. I
> could not call into functions exported by sha256_generic.c directly as
> we don't link against the kernel. Purgatory is a stand alone object.
> 
> Also sha256_generic.c is supposed to work with higher level crypto
> abstrations and API and there was no point in importing all that in
> purgatory. So instead of doing #include on sha256_generic.c I just
> copied relevant portions of code into arch/x86/purgatory/sha256.c. Now
> we shouldn't have to touch this code at all. Do let me know if there are
> better ways to handle it.

Ok, but what about configurable encryption algorithms? Maybe there are
people who don't want to use sha-2 and prefer something else instead.

> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

Also checkpatch:

...
total: 429 errors, 5 warnings, 1409 lines checked

> diff --git a/arch/x86/Makefile b/arch/x86/Makefile
> index 13b22e0..fedcd16 100644
> --- a/arch/x86/Makefile
> +++ b/arch/x86/Makefile
> @@ -160,6 +160,11 @@ archscripts: scripts_basic
>  archheaders:
>  	$(Q)$(MAKE) $(build)=arch/x86/syscalls all
>  
> +archprepare:
> +ifeq ($(CONFIG_KEXEC),y)
> +	$(Q)$(MAKE) $(build)=arch/x86/purgatory arch/x86/purgatory/kexec-purgatory.c
> +endif

I wonder if this could be put into arch/x86/boot/ and built there too...
But hpa said that already.

...

> diff --git a/arch/x86/purgatory/entry64.S b/arch/x86/purgatory/entry64.S
> new file mode 100644
> index 0000000..e405c0f
> --- /dev/null
> +++ b/arch/x86/purgatory/entry64.S
> @@ -0,0 +1,111 @@
> +/*
> + * Copyright (C) 2003,2004  Eric Biederman (ebiederm@xmission.com)
> + * Copyright (C) 2014  Red Hat Inc.
> +
> + * Author(s): Vivek Goyal <vgoyal@redhat.com>
> + *
> + * This code has been taken from kexec-tools.
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

Yeah, can we drop this boilerplate gunk and refer to COPYING instead.

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

Huh, is the purpose to simply clear the arch registers here?

	xor %reg,%reg

?

If so, you don't need the entry64_regs and below definitions at all.
>From the looks of it, though, something's populating those regs before
we jump to rip below...

> +
> +	/* Jump to the new code... */
> +	jmpq	*rip(%rip)
> +
> +	.section ".rodata"
> +	.balign 4
> +entry64_regs:
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
> index 0000000..375cfb7
> --- /dev/null
> +++ b/arch/x86/purgatory/purgatory.c
> @@ -0,0 +1,103 @@
> +/*
> + * purgatory: Runs between two kernels
> + *
> + * Copyright (C) 2013 Red Hat Inc.
> + *
> + * Author:
> + *
> + * Vivek Goyal <vgoyal@redhat.com>
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

Ditto for the boilerplate gunk.

> + */
> +
> +#include "sha256.h"
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
> +/**
> + * memcpy - Copy one area of memory to another
> + * @dest: Where to copy to
> + * @src: Where to copy from
> + * @count: The size of the area.
> + */
> +static void *memcpy(void *dest, const void *src, unsigned long count)
> +{
> +	char *tmp = dest;
> +	const char *s = src;
> +
> +	while (count--)
> +		*tmp++ = *s++;
> +	return dest;
> +}
> +
> +static int memcmp(const void *cs, const void *ct, size_t count)
> +{
> +	const unsigned char *su1, *su2;
> +	int res = 0;
> +
> +	for (su1 = cs, su2 = ct; 0 < count; ++su1, ++su2, count--)
> +		if ((res = *su1 - *su2) != 0)
> +			break;
> +	return res;
> +}
> +
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
> +		return 1;
> +
> +        return 0;
> +}
> +
> +void purgatory(void)
> +{
> +	int ret;
> +
> +	ret = verify_sha256_digest();

Yeah, again, hardcoding sha256 is kinda jucky. We probably should link
the needed crypto API stuff stuff and support multiple encryption algos.

> +	if (ret) {
> +		/* loop forever */
> +		for(;;);
> +	}
> +	copy_backup_region();

What is this thing supposed to do? I see in patch 11/11
arch_update_purgatory() does some preparations for KEXEC_TYPE_CRASH.

> +}
> diff --git a/arch/x86/purgatory/setup-x86_32.S b/arch/x86/purgatory/setup-x86_32.S
> new file mode 100644
> index 0000000..a9d5aa5
> --- /dev/null
> +++ b/arch/x86/purgatory/setup-x86_32.S
> @@ -0,0 +1,29 @@
> +/*
> + * purgatory:  setup code
> + *
> + * Copyright (C) 2014 Red Hat Inc.
> + *
> + * This code has been taken from kexec-tools.
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


Ditto on the boilerplate.

> + */
> +
> +	.text
> +	.globl purgatory_start
> +	.balign 16
> +purgatory_start:
> +	.code32
> +
> +	/* This is just a stub. Write code when 32bit support comes along */

I'm guessing we want to support 32-bit secure boot with kexec at some
point...

> +	call purgatory
> diff --git a/arch/x86/purgatory/setup-x86_64.S b/arch/x86/purgatory/setup-x86_64.S
> new file mode 100644
> index 0000000..d23bc54
> --- /dev/null
> +++ b/arch/x86/purgatory/setup-x86_64.S
> @@ -0,0 +1,68 @@
> +/*
> + * purgatory:  setup code
> + *
> + * Copyright (C) 2003,2004  Eric Biederman (ebiederm@xmission.com)
> + * Copyright (C) 2014 Red Hat Inc.
> + *
> + * This code has been taken from kexec-tools.
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

Boilerplate gunk.

...

Bah, that's a huge patch - it could use some splitting.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
