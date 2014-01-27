Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754328AbaA0S7q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 13:59:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47422 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754233AbaA0S7E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 13:59:04 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, kexec@lists.infradead.org
Cc: ebiederm@xmission.com, hpa@zytor.com, mjg59@srcf.ucam.org, greg@kroah.com,
        jkosina@suse.cz, Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH 07/11] kexec: Create a relocatable object called purgatory
Date: Mon, 27 Jan 2014 13:57:47 -0500
Message-Id: <1390849071-21989-8-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1390849071-21989-1-git-send-email-vgoyal@redhat.com>
References: <1390849071-21989-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create a stand alone relocatable object purgatory which runs between two
kernels. This name, concept and some code has been taken from kexec-tools.
Idea is that this code runs after a crash and it runs in minimal environment.
So keep it separate from rest of the kernel and in long term we will have
to practically do no maintenance of this code.

This code also has the logic to do verify sha256 hashes of various
segments which have been loaded into memory. So first we verify that
the kernel we are jumping to is fine and has not been corrupted and
make progress only if checsums are verified.

This code also takes care of copying some memory contents to backup region.

sha256 hash related code has been taken from crypto/sha256_generic.c. I
could not call into functions exported by sha256_generic.c directly as
we don't link against the kernel. Purgatory is a stand alone object.

Also sha256_generic.c is supposed to work with higher level crypto
abstrations and API and there was no point in importing all that in
purgatory. So instead of doing #include on sha256_generic.c I just
copied relevant portions of code into arch/x86/purgatory/sha256.c. Now
we shouldn't have to touch this code at all. Do let me know if there are
better ways to handle it.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 arch/x86/Kbuild                    |   1 +
 arch/x86/Kconfig                   |   1 +
 arch/x86/Makefile                  |   6 +
 arch/x86/kernel/machine_kexec_64.c |  82 +++++++
 arch/x86/purgatory/Makefile        |  35 +++
 arch/x86/purgatory/entry64.S       | 111 +++++++++
 arch/x86/purgatory/purgatory.c     | 103 ++++++++
 arch/x86/purgatory/setup-x86_32.S  |  29 +++
 arch/x86/purgatory/setup-x86_64.S  |  68 ++++++
 arch/x86/purgatory/sha256.c        | 315 ++++++++++++++++++++++++
 arch/x86/purgatory/sha256.h        |  33 +++
 arch/x86/purgatory/stack.S         |  29 +++
 include/linux/kexec.h              |  31 +++
 kernel/kexec.c                     | 481 +++++++++++++++++++++++++++++++++++++
 14 files changed, 1325 insertions(+)
 create mode 100644 arch/x86/purgatory/Makefile
 create mode 100644 arch/x86/purgatory/entry64.S
 create mode 100644 arch/x86/purgatory/purgatory.c
 create mode 100644 arch/x86/purgatory/setup-x86_32.S
 create mode 100644 arch/x86/purgatory/setup-x86_64.S
 create mode 100644 arch/x86/purgatory/sha256.c
 create mode 100644 arch/x86/purgatory/sha256.h
 create mode 100644 arch/x86/purgatory/stack.S

diff --git a/arch/x86/Kbuild b/arch/x86/Kbuild
index e5287d8..faaeee7 100644
--- a/arch/x86/Kbuild
+++ b/arch/x86/Kbuild
@@ -16,3 +16,4 @@ obj-$(CONFIG_IA32_EMULATION) += ia32/
 
 obj-y += platform/
 obj-y += net/
+obj-$(CONFIG_KEXEC) += purgatory/
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index aa5aeed..532cc0b 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1605,6 +1605,7 @@ source kernel/Kconfig.hz
 config KEXEC
 	bool "kexec system call"
 	select BUILD_BIN2C
+	select CRYPTO_SHA256
 	---help---
 	  kexec is a system call that implements the ability to shutdown your
 	  current kernel, and to start another kernel.  It is like a reboot
diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 13b22e0..fedcd16 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -160,6 +160,11 @@ archscripts: scripts_basic
 archheaders:
 	$(Q)$(MAKE) $(build)=arch/x86/syscalls all
 
+archprepare:
+ifeq ($(CONFIG_KEXEC),y)
+	$(Q)$(MAKE) $(build)=arch/x86/purgatory arch/x86/purgatory/kexec-purgatory.c
+endif
+
 ###
 # Kernel objects
 
@@ -223,6 +228,7 @@ archclean:
 	$(Q)rm -rf $(objtree)/arch/x86_64
 	$(Q)$(MAKE) $(clean)=$(boot)
 	$(Q)$(MAKE) $(clean)=arch/x86/tools
+	$(Q)$(MAKE) $(clean)=arch/x86/purgatory
 
 PHONY += kvmconfig
 kvmconfig:
diff --git a/arch/x86/kernel/machine_kexec_64.c b/arch/x86/kernel/machine_kexec_64.c
index c91d72a..8866c5e 100644
--- a/arch/x86/kernel/machine_kexec_64.c
+++ b/arch/x86/kernel/machine_kexec_64.c
@@ -331,3 +331,85 @@ int arch_kimage_file_post_load_cleanup(struct kimage *image)
 		return kexec_file_type[idx].cleanup(image);
 	return 0;
 }
+
+/* Apply purgatory relocations */
+int arch_kexec_apply_relocations_add(Elf64_Shdr *sechdrs,
+				unsigned int nr_sections, unsigned int relsec)
+{
+	unsigned int i;
+	Elf64_Rela *rel = (void *)sechdrs[relsec].sh_offset;
+	Elf64_Sym *sym;
+	void *location;
+	Elf64_Shdr *section, *symtab;
+	unsigned long address, sec_base, value;
+
+	/* Section to which relocations apply */
+	section = &sechdrs[sechdrs[relsec].sh_info];
+
+	/* Associated symbol table */
+	symtab = &sechdrs[sechdrs[relsec].sh_link];
+
+	for (i = 0; i < sechdrs[relsec].sh_size / sizeof(*rel); i++) {
+
+		/*
+		 * This is location (->sh_offset) to update. This is temporary
+		 * buffer where section is currently loaded. This will finally
+		 * be loaded to a different address later (pointed to
+		 * by ->sh_addr. kexec takes care of moving it
+		 * (kexec_load_segment()).
+		 */
+		location = (void *)(section->sh_offset + rel[i].r_offset);
+
+		/* Final address of the location */
+		address = section->sh_addr + rel[i].r_offset;
+
+		sym = (Elf64_Sym *)symtab->sh_offset +
+				ELF64_R_SYM(rel[i].r_info);
+
+		if (sym->st_shndx == SHN_UNDEF || sym->st_shndx == SHN_COMMON)
+			return -ENOEXEC;
+
+		if (sym->st_shndx == SHN_ABS)
+			sec_base = 0;
+		else if (sym->st_shndx >= nr_sections)
+			return -ENOEXEC;
+		else
+			sec_base = sechdrs[sym->st_shndx].sh_addr;
+
+		value = sym->st_value;
+		value += sec_base;
+		value += rel[i].r_addend;
+
+		switch(ELF64_R_TYPE(rel[i].r_info)) {
+		case R_X86_64_NONE:
+			break;
+		case R_X86_64_64:
+			*(u64 *)location = value;
+			break;
+		case R_X86_64_32:
+			*(u32 *)location = value;
+			if (value != *(u32 *)location)
+				goto overflow;
+			break;
+		case R_X86_64_32S:
+			*(s32 *)location = value;
+			if ((s64)value != *(s32 *)location)
+				goto overflow;
+			break;
+		case R_X86_64_PC32:
+			value -= (u64)address;
+			*(u32 *)location = value;
+			break;
+		default:
+			pr_err("kexec: Unknown rela relocation: %llu\n",
+					ELF64_R_TYPE(rel[i].r_info));
+			return -ENOEXEC;
+		}
+	}
+	return 0;
+
+overflow:
+	pr_err("kexec: overflow in relocation type %d value 0x%lx\n",
+		(int)ELF64_R_TYPE(rel[i].r_info), value);
+        return -ENOEXEC;
+}
diff --git a/arch/x86/purgatory/Makefile b/arch/x86/purgatory/Makefile
new file mode 100644
index 0000000..c83c557
--- /dev/null
+++ b/arch/x86/purgatory/Makefile
@@ -0,0 +1,35 @@
+ifeq ($(CONFIG_X86_64),y)
+	purgatory-y := purgatory.o entry64.o stack.o setup-x86_64.o sha256.o
+else
+	purgatory-y := purgatory.o stack.o sha256.o setup-x86_32.o
+endif
+
+targets += $(purgatory-y)
+PURGATORY_OBJS = $(addprefix $(obj)/,$(purgatory-y))
+
+LDFLAGS_purgatory.ro := -e purgatory_start -r --no-undefined -nostdlib -z nodefaultlib
+targets += purgatory.ro
+
+# Default KBUILD_CFLAGS can have -pg option set when FTRACE is enabled. That
+# in turn leaves some undefined symbols like __fentry__ in purgatory and not
+# sure how to relocate those. Like kexec-tools, custom flags.
+
+ifeq ($(CONFIG_X86_64),y)
+KBUILD_CFLAGS	:= -fno-strict-aliasing -Wall -Wstrict-prototypes -fno-zero-initialized-in-bss -mcmodel=large -Os -fno-builtin -ffreestanding -c -MD
+else
+KBUILD_CFLAGS	:= -fno-strict-aliasing -Wall -Wstrict-prototypes -fno-zero-initialized-in-bss -Os -fno-builtin -ffreestanding -c -MD -m32
+endif
+
+$(obj)/purgatory.ro: $(PURGATORY_OBJS) FORCE
+		$(call if_changed,ld)
+
+targets += kexec-purgatory.c
+
+quiet_cmd_bin2c = BIN2C   $@
+      cmd_bin2c = cat $(obj)/purgatory.ro | $(srctree)/scripts/basic/bin2c kexec_purgatory > $(obj)/kexec-purgatory.c
+
+$(obj)/kexec-purgatory.c: $(obj)/purgatory.ro FORCE
+	$(call if_changed,bin2c)
+
+
+obj-$(CONFIG_KEXEC)	+= kexec-purgatory.o
diff --git a/arch/x86/purgatory/entry64.S b/arch/x86/purgatory/entry64.S
new file mode 100644
index 0000000..e405c0f
--- /dev/null
+++ b/arch/x86/purgatory/entry64.S
@@ -0,0 +1,111 @@
+/*
+ * Copyright (C) 2003,2004  Eric Biederman (ebiederm@xmission.com)
+ * Copyright (C) 2014  Red Hat Inc.
+
+ * Author(s): Vivek Goyal <vgoyal@redhat.com>
+ *
+ * This code has been taken from kexec-tools.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation (version 2 of the License).
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+	.text
+	.balign 16
+	.code64
+	.globl entry64, entry64_regs
+
+
+entry64:
+	/* Setup a gdt that should be preserved */
+	lgdt gdt(%rip)
+
+	/* load the data segments */
+	movl    $0x18, %eax     /* data segment */
+	movl    %eax, %ds
+	movl    %eax, %es
+	movl    %eax, %ss
+	movl    %eax, %fs
+	movl    %eax, %gs
+
+	/* Setup new stack */
+	leaq    stack_init(%rip), %rsp
+	pushq   $0x10 /* CS */
+	leaq    new_cs_exit(%rip), %rax
+	pushq   %rax
+	lretq
+new_cs_exit:
+
+	/* Load the registers */
+	movq	rax(%rip), %rax
+	movq	rbx(%rip), %rbx
+	movq	rcx(%rip), %rcx
+	movq	rdx(%rip), %rdx
+	movq	rsi(%rip), %rsi
+	movq	rdi(%rip), %rdi
+	movq    rsp(%rip), %rsp
+	movq	rbp(%rip), %rbp
+	movq	r8(%rip), %r8
+	movq	r9(%rip), %r9
+	movq	r10(%rip), %r10
+	movq	r11(%rip), %r11
+	movq	r12(%rip), %r12
+	movq	r13(%rip), %r13
+	movq	r14(%rip), %r14
+	movq	r15(%rip), %r15
+
+	/* Jump to the new code... */
+	jmpq	*rip(%rip)
+
+	.section ".rodata"
+	.balign 4
+entry64_regs:
+rax:	.quad 0x00000000
+rbx:	.quad 0x00000000
+rcx:	.quad 0x00000000
+rdx:	.quad 0x00000000
+rsi:	.quad 0x00000000
+rdi:	.quad 0x00000000
+rsp:	.quad 0x00000000
+rbp:	.quad 0x00000000
+r8:	.quad 0x00000000
+r9:	.quad 0x00000000
+r10:	.quad 0x00000000
+r11:	.quad 0x00000000
+r12:	.quad 0x00000000
+r13:	.quad 0x00000000
+r14:	.quad 0x00000000
+r15:	.quad 0x00000000
+rip:	.quad 0x00000000
+	.size entry64_regs, . - entry64_regs
+
+	/* GDT */
+	.section ".rodata"
+	.balign 16
+gdt:
+	/* 0x00 unusable segment
+	 * 0x08 unused
+	 * so use them as gdt ptr
+	 */
+	.word gdt_end - gdt - 1
+	.quad gdt
+	.word 0, 0, 0
+
+	/* 0x10 4GB flat code segment */
+	.word 0xFFFF, 0x0000, 0x9A00, 0x00AF
+
+	/* 0x18 4GB flat data segment */
+	.word 0xFFFF, 0x0000, 0x9200, 0x00CF
+gdt_end:
+stack:	.quad   0, 0
+stack_init:
diff --git a/arch/x86/purgatory/purgatory.c b/arch/x86/purgatory/purgatory.c
new file mode 100644
index 0000000..375cfb7
--- /dev/null
+++ b/arch/x86/purgatory/purgatory.c
@@ -0,0 +1,103 @@
+/*
+ * purgatory: Runs between two kernels
+ *
+ * Copyright (C) 2013 Red Hat Inc.
+ *
+ * Author:
+ *
+ * Vivek Goyal <vgoyal@redhat.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation (version 2 of the License).
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#include "sha256.h"
+
+struct sha_region {
+	unsigned long start;
+	unsigned long len;
+};
+
+unsigned long backup_dest = 0;
+unsigned long backup_src = 0;
+unsigned long backup_sz = 0;
+
+u8 sha256_digest[SHA256_DIGEST_SIZE] = { 0 };
+
+struct sha_region sha_regions[16] = {};
+
+/**
+ * memcpy - Copy one area of memory to another
+ * @dest: Where to copy to
+ * @src: Where to copy from
+ * @count: The size of the area.
+ */
+static void *memcpy(void *dest, const void *src, unsigned long count)
+{
+	char *tmp = dest;
+	const char *s = src;
+
+	while (count--)
+		*tmp++ = *s++;
+	return dest;
+}
+
+static int memcmp(const void *cs, const void *ct, size_t count)
+{
+	const unsigned char *su1, *su2;
+	int res = 0;
+
+	for (su1 = cs, su2 = ct; 0 < count; ++su1, ++su2, count--)
+		if ((res = *su1 - *su2) != 0)
+			break;
+	return res;
+}
+
+static int copy_backup_region(void)
+{
+	if (backup_dest)
+		memcpy((void *)backup_dest, (void *)backup_src, backup_sz);
+
+	return 0;
+}
+
+int verify_sha256_digest(void)
+{
+	struct sha_region *ptr, *end;
+	u8 digest[SHA256_DIGEST_SIZE];
+	struct sha256_state sctx;
+
+	sha256_init(&sctx);
+	end = &sha_regions[sizeof(sha_regions)/sizeof(sha_regions[0])];
+	for (ptr = sha_regions; ptr < end; ptr++)
+		sha256_update(&sctx, (uint8_t *)(ptr->start), ptr->len);
+
+	sha256_final(&sctx, digest);
+
+	if (memcmp(digest, sha256_digest, sizeof(digest)) != 0)
+		return 1;
+
+        return 0;
+}
+
+void purgatory(void)
+{
+	int ret;
+
+	ret = verify_sha256_digest();
+	if (ret) {
+		/* loop forever */
+		for(;;);
+	}
+	copy_backup_region();
+}
diff --git a/arch/x86/purgatory/setup-x86_32.S b/arch/x86/purgatory/setup-x86_32.S
new file mode 100644
index 0000000..a9d5aa5
--- /dev/null
+++ b/arch/x86/purgatory/setup-x86_32.S
@@ -0,0 +1,29 @@
+/*
+ * purgatory:  setup code
+ *
+ * Copyright (C) 2014 Red Hat Inc.
+ *
+ * This code has been taken from kexec-tools.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation (version 2 of the License).
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+	.text
+	.globl purgatory_start
+	.balign 16
+purgatory_start:
+	.code32
+
+	/* This is just a stub. Write code when 32bit support comes along */
+	call purgatory
diff --git a/arch/x86/purgatory/setup-x86_64.S b/arch/x86/purgatory/setup-x86_64.S
new file mode 100644
index 0000000..d23bc54
--- /dev/null
+++ b/arch/x86/purgatory/setup-x86_64.S
@@ -0,0 +1,68 @@
+/*
+ * purgatory:  setup code
+ *
+ * Copyright (C) 2003,2004  Eric Biederman (ebiederm@xmission.com)
+ * Copyright (C) 2014 Red Hat Inc.
+ *
+ * This code has been taken from kexec-tools.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation (version 2 of the License).
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+	.text
+	.globl purgatory_start
+	.balign 16
+purgatory_start:
+	.code64
+
+	/* Load a gdt so I know what the segment registers are */
+	lgdt	gdt(%rip)
+
+	/* load the data segments */
+	movl	$0x18, %eax	/* data segment */
+	movl	%eax, %ds
+	movl	%eax, %es
+	movl	%eax, %ss
+	movl	%eax, %fs
+	movl	%eax, %gs
+
+	/* Setup a stack */
+	leaq	lstack_end(%rip), %rsp
+
+	/* Call the C code */
+	call purgatory
+	jmp	entry64
+
+	.section ".rodata"
+	.balign 16
+gdt:	/* 0x00 unusable segment
+	 * 0x08 unused
+	 * so use them as the gdt ptr
+	 */
+	.word	gdt_end - gdt - 1
+	.quad	gdt
+	.word	0, 0, 0
+
+	/* 0x10 4GB flat code segment */
+	.word	0xFFFF, 0x0000, 0x9A00, 0x00AF
+
+	/* 0x18 4GB flat data segment */
+	.word	0xFFFF, 0x0000, 0x9200, 0x00CF
+gdt_end:
+
+	.bss
+	.balign 4096
+lstack:
+	.skip 4096
+lstack_end:
diff --git a/arch/x86/purgatory/sha256.c b/arch/x86/purgatory/sha256.c
new file mode 100644
index 0000000..990d17f
--- /dev/null
+++ b/arch/x86/purgatory/sha256.c
@@ -0,0 +1,315 @@
+/*
+ * SHA-256, as specified in
+ * http://csrc.nist.gov/groups/STM/cavp/documents/shs/sha256-384-512.pdf
+ *
+ * SHA-256 code by Jean-Luc Cooke <jlcooke@certainkey.com>.
+ *
+ * Copyright (c) Jean-Luc Cooke <jlcooke@certainkey.com>
+ * Copyright (c) Andrew McDonald <andrew@mcdonald.org.uk>
+ * Copyright (c) 2002 James Morris <jmorris@intercode.com.au>
+ * Copyright (c) 2014 Red Hat Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)
+ * any later version.
+ */
+
+#include <linux/bitops.h>
+#include <asm/byteorder.h>
+#include "sha256.h"
+
+
+/**
+ * memset - Fill a region of memory with the given value
+ * @s: Pointer to the start of the area.
+ * @c: The byte to fill the area with
+ * @count: The size of the area.
+ */
+static void *memset(void *s, int c, size_t count)
+{
+	char *xs = s;
+
+	while (count--)
+		*xs++ = c;
+	return s;
+}
+
+/**
+ * memcpy - Copy one area of memory to another
+ * @dest: Where to copy to
+ * @src: Where to copy from
+ * @count: The size of the area.
+ */
+static void *memcpy(void *dest, const void *src, size_t count)
+{
+	char *tmp = dest;
+	const char *s = src;
+
+	while (count--)
+		*tmp++ = *s++;
+	return dest;
+}
+
+static inline u32 Ch(u32 x, u32 y, u32 z)
+{
+	return z ^ (x & (y ^ z));
+}
+
+static inline u32 Maj(u32 x, u32 y, u32 z)
+{
+	return (x & y) | (z & (x | y));
+}
+
+#define e0(x)       (ror32(x, 2) ^ ror32(x,13) ^ ror32(x,22))
+#define e1(x)       (ror32(x, 6) ^ ror32(x,11) ^ ror32(x,25))
+#define s0(x)       (ror32(x, 7) ^ ror32(x,18) ^ (x >> 3))
+#define s1(x)       (ror32(x,17) ^ ror32(x,19) ^ (x >> 10))
+
+static inline void LOAD_OP(int I, u32 *W, const u8 *input)
+{
+	W[I] = __be32_to_cpu( ((__be32*)(input))[I] );
+}
+
+static inline void BLEND_OP(int I, u32 *W)
+{
+	W[I] = s1(W[I-2]) + W[I-7] + s0(W[I-15]) + W[I-16];
+}
+
+static void sha256_transform(u32 *state, const u8 *input)
+{
+	u32 a, b, c, d, e, f, g, h, t1, t2;
+	u32 W[64];
+	int i;
+
+	/* load the input */
+	for (i = 0; i < 16; i++)
+		LOAD_OP(i, W, input);
+
+	/* now blend */
+	for (i = 16; i < 64; i++)
+		BLEND_OP(i, W);
+
+	/* load the state into our registers */
+	a=state[0];  b=state[1];  c=state[2];  d=state[3];
+	e=state[4];  f=state[5];  g=state[6];  h=state[7];
+
+	/* now iterate */
+	t1 = h + e1(e) + Ch(e,f,g) + 0x428a2f98 + W[ 0];
+	t2 = e0(a) + Maj(a,b,c);    d+=t1;    h=t1+t2;
+	t1 = g + e1(d) + Ch(d,e,f) + 0x71374491 + W[ 1];
+	t2 = e0(h) + Maj(h,a,b);    c+=t1;    g=t1+t2;
+	t1 = f + e1(c) + Ch(c,d,e) + 0xb5c0fbcf + W[ 2];
+	t2 = e0(g) + Maj(g,h,a);    b+=t1;    f=t1+t2;
+	t1 = e + e1(b) + Ch(b,c,d) + 0xe9b5dba5 + W[ 3];
+	t2 = e0(f) + Maj(f,g,h);    a+=t1;    e=t1+t2;
+	t1 = d + e1(a) + Ch(a,b,c) + 0x3956c25b + W[ 4];
+	t2 = e0(e) + Maj(e,f,g);    h+=t1;    d=t1+t2;
+	t1 = c + e1(h) + Ch(h,a,b) + 0x59f111f1 + W[ 5];
+	t2 = e0(d) + Maj(d,e,f);    g+=t1;    c=t1+t2;
+	t1 = b + e1(g) + Ch(g,h,a) + 0x923f82a4 + W[ 6];
+	t2 = e0(c) + Maj(c,d,e);    f+=t1;    b=t1+t2;
+	t1 = a + e1(f) + Ch(f,g,h) + 0xab1c5ed5 + W[ 7];
+	t2 = e0(b) + Maj(b,c,d);    e+=t1;    a=t1+t2;
+
+	t1 = h + e1(e) + Ch(e,f,g) + 0xd807aa98 + W[ 8];
+	t2 = e0(a) + Maj(a,b,c);    d+=t1;    h=t1+t2;
+	t1 = g + e1(d) + Ch(d,e,f) + 0x12835b01 + W[ 9];
+	t2 = e0(h) + Maj(h,a,b);    c+=t1;    g=t1+t2;
+	t1 = f + e1(c) + Ch(c,d,e) + 0x243185be + W[10];
+	t2 = e0(g) + Maj(g,h,a);    b+=t1;    f=t1+t2;
+	t1 = e + e1(b) + Ch(b,c,d) + 0x550c7dc3 + W[11];
+	t2 = e0(f) + Maj(f,g,h);    a+=t1;    e=t1+t2;
+	t1 = d + e1(a) + Ch(a,b,c) + 0x72be5d74 + W[12];
+	t2 = e0(e) + Maj(e,f,g);    h+=t1;    d=t1+t2;
+	t1 = c + e1(h) + Ch(h,a,b) + 0x80deb1fe + W[13];
+	t2 = e0(d) + Maj(d,e,f);    g+=t1;    c=t1+t2;
+	t1 = b + e1(g) + Ch(g,h,a) + 0x9bdc06a7 + W[14];
+	t2 = e0(c) + Maj(c,d,e);    f+=t1;    b=t1+t2;
+	t1 = a + e1(f) + Ch(f,g,h) + 0xc19bf174 + W[15];
+	t2 = e0(b) + Maj(b,c,d);    e+=t1;    a=t1+t2;
+
+	t1 = h + e1(e) + Ch(e,f,g) + 0xe49b69c1 + W[16];
+	t2 = e0(a) + Maj(a,b,c);    d+=t1;    h=t1+t2;
+	t1 = g + e1(d) + Ch(d,e,f) + 0xefbe4786 + W[17];
+	t2 = e0(h) + Maj(h,a,b);    c+=t1;    g=t1+t2;
+	t1 = f + e1(c) + Ch(c,d,e) + 0x0fc19dc6 + W[18];
+	t2 = e0(g) + Maj(g,h,a);    b+=t1;    f=t1+t2;
+	t1 = e + e1(b) + Ch(b,c,d) + 0x240ca1cc + W[19];
+	t2 = e0(f) + Maj(f,g,h);    a+=t1;    e=t1+t2;
+	t1 = d + e1(a) + Ch(a,b,c) + 0x2de92c6f + W[20];
+	t2 = e0(e) + Maj(e,f,g);    h+=t1;    d=t1+t2;
+	t1 = c + e1(h) + Ch(h,a,b) + 0x4a7484aa + W[21];
+	t2 = e0(d) + Maj(d,e,f);    g+=t1;    c=t1+t2;
+	t1 = b + e1(g) + Ch(g,h,a) + 0x5cb0a9dc + W[22];
+	t2 = e0(c) + Maj(c,d,e);    f+=t1;    b=t1+t2;
+	t1 = a + e1(f) + Ch(f,g,h) + 0x76f988da + W[23];
+	t2 = e0(b) + Maj(b,c,d);    e+=t1;    a=t1+t2;
+
+	t1 = h + e1(e) + Ch(e,f,g) + 0x983e5152 + W[24];
+	t2 = e0(a) + Maj(a,b,c);    d+=t1;    h=t1+t2;
+	t1 = g + e1(d) + Ch(d,e,f) + 0xa831c66d + W[25];
+	t2 = e0(h) + Maj(h,a,b);    c+=t1;    g=t1+t2;
+	t1 = f + e1(c) + Ch(c,d,e) + 0xb00327c8 + W[26];
+	t2 = e0(g) + Maj(g,h,a);    b+=t1;    f=t1+t2;
+	t1 = e + e1(b) + Ch(b,c,d) + 0xbf597fc7 + W[27];
+	t2 = e0(f) + Maj(f,g,h);    a+=t1;    e=t1+t2;
+	t1 = d + e1(a) + Ch(a,b,c) + 0xc6e00bf3 + W[28];
+	t2 = e0(e) + Maj(e,f,g);    h+=t1;    d=t1+t2;
+	t1 = c + e1(h) + Ch(h,a,b) + 0xd5a79147 + W[29];
+	t2 = e0(d) + Maj(d,e,f);    g+=t1;    c=t1+t2;
+	t1 = b + e1(g) + Ch(g,h,a) + 0x06ca6351 + W[30];
+	t2 = e0(c) + Maj(c,d,e);    f+=t1;    b=t1+t2;
+	t1 = a + e1(f) + Ch(f,g,h) + 0x14292967 + W[31];
+	t2 = e0(b) + Maj(b,c,d);    e+=t1;    a=t1+t2;
+
+	t1 = h + e1(e) + Ch(e,f,g) + 0x27b70a85 + W[32];
+	t2 = e0(a) + Maj(a,b,c);    d+=t1;    h=t1+t2;
+	t1 = g + e1(d) + Ch(d,e,f) + 0x2e1b2138 + W[33];
+	t2 = e0(h) + Maj(h,a,b);    c+=t1;    g=t1+t2;
+	t1 = f + e1(c) + Ch(c,d,e) + 0x4d2c6dfc + W[34];
+	t2 = e0(g) + Maj(g,h,a);    b+=t1;    f=t1+t2;
+	t1 = e + e1(b) + Ch(b,c,d) + 0x53380d13 + W[35];
+	t2 = e0(f) + Maj(f,g,h);    a+=t1;    e=t1+t2;
+	t1 = d + e1(a) + Ch(a,b,c) + 0x650a7354 + W[36];
+	t2 = e0(e) + Maj(e,f,g);    h+=t1;    d=t1+t2;
+	t1 = c + e1(h) + Ch(h,a,b) + 0x766a0abb + W[37];
+	t2 = e0(d) + Maj(d,e,f);    g+=t1;    c=t1+t2;
+	t1 = b + e1(g) + Ch(g,h,a) + 0x81c2c92e + W[38];
+	t2 = e0(c) + Maj(c,d,e);    f+=t1;    b=t1+t2;
+	t1 = a + e1(f) + Ch(f,g,h) + 0x92722c85 + W[39];
+	t2 = e0(b) + Maj(b,c,d);    e+=t1;    a=t1+t2;
+
+	t1 = h + e1(e) + Ch(e,f,g) + 0xa2bfe8a1 + W[40];
+	t2 = e0(a) + Maj(a,b,c);    d+=t1;    h=t1+t2;
+	t1 = g + e1(d) + Ch(d,e,f) + 0xa81a664b + W[41];
+	t2 = e0(h) + Maj(h,a,b);    c+=t1;    g=t1+t2;
+	t1 = f + e1(c) + Ch(c,d,e) + 0xc24b8b70 + W[42];
+	t2 = e0(g) + Maj(g,h,a);    b+=t1;    f=t1+t2;
+	t1 = e + e1(b) + Ch(b,c,d) + 0xc76c51a3 + W[43];
+	t2 = e0(f) + Maj(f,g,h);    a+=t1;    e=t1+t2;
+	t1 = d + e1(a) + Ch(a,b,c) + 0xd192e819 + W[44];
+	t2 = e0(e) + Maj(e,f,g);    h+=t1;    d=t1+t2;
+	t1 = c + e1(h) + Ch(h,a,b) + 0xd6990624 + W[45];
+	t2 = e0(d) + Maj(d,e,f);    g+=t1;    c=t1+t2;
+	t1 = b + e1(g) + Ch(g,h,a) + 0xf40e3585 + W[46];
+	t2 = e0(c) + Maj(c,d,e);    f+=t1;    b=t1+t2;
+	t1 = a + e1(f) + Ch(f,g,h) + 0x106aa070 + W[47];
+	t2 = e0(b) + Maj(b,c,d);    e+=t1;    a=t1+t2;
+
+	t1 = h + e1(e) + Ch(e,f,g) + 0x19a4c116 + W[48];
+	t2 = e0(a) + Maj(a,b,c);    d+=t1;    h=t1+t2;
+	t1 = g + e1(d) + Ch(d,e,f) + 0x1e376c08 + W[49];
+	t2 = e0(h) + Maj(h,a,b);    c+=t1;    g=t1+t2;
+	t1 = f + e1(c) + Ch(c,d,e) + 0x2748774c + W[50];
+	t2 = e0(g) + Maj(g,h,a);    b+=t1;    f=t1+t2;
+	t1 = e + e1(b) + Ch(b,c,d) + 0x34b0bcb5 + W[51];
+	t2 = e0(f) + Maj(f,g,h);    a+=t1;    e=t1+t2;
+	t1 = d + e1(a) + Ch(a,b,c) + 0x391c0cb3 + W[52];
+	t2 = e0(e) + Maj(e,f,g);    h+=t1;    d=t1+t2;
+	t1 = c + e1(h) + Ch(h,a,b) + 0x4ed8aa4a + W[53];
+	t2 = e0(d) + Maj(d,e,f);    g+=t1;    c=t1+t2;
+	t1 = b + e1(g) + Ch(g,h,a) + 0x5b9cca4f + W[54];
+	t2 = e0(c) + Maj(c,d,e);    f+=t1;    b=t1+t2;
+	t1 = a + e1(f) + Ch(f,g,h) + 0x682e6ff3 + W[55];
+	t2 = e0(b) + Maj(b,c,d);    e+=t1;    a=t1+t2;
+
+	t1 = h + e1(e) + Ch(e,f,g) + 0x748f82ee + W[56];
+	t2 = e0(a) + Maj(a,b,c);    d+=t1;    h=t1+t2;
+	t1 = g + e1(d) + Ch(d,e,f) + 0x78a5636f + W[57];
+	t2 = e0(h) + Maj(h,a,b);    c+=t1;    g=t1+t2;
+	t1 = f + e1(c) + Ch(c,d,e) + 0x84c87814 + W[58];
+	t2 = e0(g) + Maj(g,h,a);    b+=t1;    f=t1+t2;
+	t1 = e + e1(b) + Ch(b,c,d) + 0x8cc70208 + W[59];
+	t2 = e0(f) + Maj(f,g,h);    a+=t1;    e=t1+t2;
+	t1 = d + e1(a) + Ch(a,b,c) + 0x90befffa + W[60];
+	t2 = e0(e) + Maj(e,f,g);    h+=t1;    d=t1+t2;
+	t1 = c + e1(h) + Ch(h,a,b) + 0xa4506ceb + W[61];
+	t2 = e0(d) + Maj(d,e,f);    g+=t1;    c=t1+t2;
+	t1 = b + e1(g) + Ch(g,h,a) + 0xbef9a3f7 + W[62];
+	t2 = e0(c) + Maj(c,d,e);    f+=t1;    b=t1+t2;
+	t1 = a + e1(f) + Ch(f,g,h) + 0xc67178f2 + W[63];
+	t2 = e0(b) + Maj(b,c,d);    e+=t1;    a=t1+t2;
+
+	state[0] += a; state[1] += b; state[2] += c; state[3] += d;
+	state[4] += e; state[5] += f; state[6] += g; state[7] += h;
+
+	/* clear any sensitive info... */
+	a = b = c = d = e = f = g = h = t1 = t2 = 0;
+	memset(W, 0, 64 * sizeof(u32));
+}
+
+int sha256_init(struct sha256_state *sctx)
+{
+	sctx->state[0] = SHA256_H0;
+	sctx->state[1] = SHA256_H1;
+	sctx->state[2] = SHA256_H2;
+	sctx->state[3] = SHA256_H3;
+	sctx->state[4] = SHA256_H4;
+	sctx->state[5] = SHA256_H5;
+	sctx->state[6] = SHA256_H6;
+	sctx->state[7] = SHA256_H7;
+	sctx->count = 0;
+
+	return 0;
+}
+
+int sha256_update(struct sha256_state *sctx, const u8 *data,
+					unsigned int len)
+{
+	unsigned int partial, done;
+	const u8 *src;
+
+	partial = sctx->count & 0x3f;
+	sctx->count += len;
+	done = 0;
+	src = data;
+
+	if ((partial + len) > 63) {
+		if (partial) {
+			done = -partial;
+			memcpy(sctx->buf + partial, data, done + 64);
+			src = sctx->buf;
+		}
+
+		do {
+			sha256_transform(sctx->state, src);
+			done += 64;
+			src = data + done;
+		} while (done + 63 < len);
+
+		partial = 0;
+	}
+	memcpy(sctx->buf + partial, src, len - done);
+
+	return 0;
+}
+
+int sha256_final(struct sha256_state *sctx, u8 *out)
+{
+	__be32 *dst = (__be32 *)out;
+	__be64 bits;
+	unsigned int index, pad_len;
+	int i;
+	static const u8 padding[64] = { 0x80, };
+
+	/* Save number of bits */
+	bits = cpu_to_be64(sctx->count << 3);
+
+	/* Pad out to 56 mod 64. */
+	index = sctx->count & 0x3f;
+	pad_len = (index < 56) ? (56 - index) : ((64+56) - index);
+	sha256_update(sctx, padding, pad_len);
+
+	/* Append length (before padding) */
+	sha256_update(sctx, (const u8 *)&bits, sizeof(bits));
+
+	/* Store state in digest */
+	for (i = 0; i < 8; i++)
+		dst[i] = cpu_to_be32(sctx->state[i]);
+
+	/* Zeroize sensitive information. */
+	memset(sctx, 0, sizeof(*sctx));
+
+	return 0;
+}
diff --git a/arch/x86/purgatory/sha256.h b/arch/x86/purgatory/sha256.h
new file mode 100644
index 0000000..74df8f4
--- /dev/null
+++ b/arch/x86/purgatory/sha256.h
@@ -0,0 +1,33 @@
+/*
+ *  Copyright (C) 2014 Red Hat Inc.
+ *
+ *  Author: Vivek Goyal <vgoyal@redhat.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+#ifndef SHA256_H
+#define SHA256_H
+
+
+#include <linux/types.h>
+#include <crypto/sha.h>
+
+extern int sha256_init(struct sha256_state *sctx);
+extern int sha256_update(struct sha256_state *sctx, const u8 *input,
+				unsigned int length);
+extern int sha256_final(struct sha256_state *sctx, u8* hash);
+
+#endif /* SHA256_H */
diff --git a/arch/x86/purgatory/stack.S b/arch/x86/purgatory/stack.S
new file mode 100644
index 0000000..aff1fa9
--- /dev/null
+++ b/arch/x86/purgatory/stack.S
@@ -0,0 +1,29 @@
+/*
+ * purgatory:  stack
+ *
+ * Copyright (C) 2014 Red Hat Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation (version 2 of the License).
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+	/* A stack for the loaded kernel.
+	 * Seperate and in the data section so it can be prepopulated.
+	 */
+	.data
+	.balign 4096
+	.globl stack, stack_end
+
+stack:
+	.skip 4096
+stack_end:
diff --git a/include/linux/kexec.h b/include/linux/kexec.h
index 51b56cd..d391ed7 100644
--- a/include/linux/kexec.h
+++ b/include/linux/kexec.h
@@ -10,6 +10,7 @@
 #include <linux/ioport.h>
 #include <linux/elfcore.h>
 #include <linux/elf.h>
+#include <linux/module.h>
 #include <asm/kexec.h>
 
 /* Verify architecture specific macros are defined */
@@ -95,6 +96,27 @@ struct compat_kexec_segment {
 };
 #endif
 
+struct kexec_sha_region {
+	unsigned long start;
+	unsigned long len;
+};
+
+struct purgatory_info {
+	/* Pointer to elf header of read only purgatory */
+	Elf_Ehdr *ehdr;
+
+	/* Pointer to purgatory sechdrs which are modifiable */
+	Elf_Shdr *sechdrs;
+	/*
+	 * Temporary buffer location where purgatory is loaded and relocated
+	 * This memory can be freed post image load
+	 */
+	void *purgatory_buf;
+
+	/* Address where purgatory is finally loaded and is executed from */
+	unsigned long purgatory_load_addr;
+};
+
 struct kimage {
 	kimage_entry_t head;
 	kimage_entry_t *entry;
@@ -143,6 +165,9 @@ struct kimage {
 
 	/* Image loader handling the kernel can store a pointer here */
 	void * image_loader_data;
+
+	/* Information for loading purgatory */
+	struct purgatory_info purgatory_info;
 };
 
 /*
@@ -197,6 +222,12 @@ extern asmlinkage long compat_sys_kexec_load(unsigned long entry,
 extern struct page *kimage_alloc_control_pages(struct kimage *image,
 						unsigned int order);
 extern void kimage_set_start_addr(struct kimage *image, unsigned long start);
+extern int kexec_load_purgatory(struct kimage *image, unsigned long min,
+		unsigned long max, int top_down, unsigned long *load_addr);
+extern int kexec_purgatory_get_set_symbol(struct kimage *image,
+		const char *name, void *buf, unsigned int size, bool get_value);
+extern void *kexec_purgatory_get_symbol_addr(struct kimage *image,
+					const char *name);
 
 extern void crash_kexec(struct pt_regs *);
 int kexec_should_crash(struct task_struct *);
diff --git a/kernel/kexec.c b/kernel/kexec.c
index b28578a..20169a4 100644
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -38,6 +38,9 @@
 #include <asm/io.h>
 #include <asm/sections.h>
 
+#include <crypto/hash.h>
+#include <crypto/sha.h>
+
 /* Per cpu memory for storing cpu states in case of system crash. */
 note_buf_t __percpu *crash_notes;
 
@@ -50,6 +53,15 @@ size_t vmcoreinfo_max_size = sizeof(vmcoreinfo_data);
 /* Flag to indicate we are going to kexec a new kernel */
 bool kexec_in_progress = false;
 
+/*
+ * Declare these symbols weak so that if architecture provides a purgatory,
+ * these will be overridden.
+ */
+char __weak kexec_purgatory[0];
+size_t __weak kexec_purgatory_size = 0;
+
+static int kexec_calculate_store_digests(struct kimage *image);
+
 /* Location of the reserved area for the crash kernel */
 struct resource crashk_res = {
 	.name  = "Crash kernel",
@@ -341,6 +353,15 @@ arch_kimage_file_post_load_cleanup(struct kimage *image)
 	return;
 }
 
+/* Apply relocations for rela section */
+int __attribute__ ((weak))
+arch_kexec_apply_relocations_add(Elf_Shdr *sechdrs, unsigned int nr_sections,
+					unsigned int relsec)
+{
+	printk(KERN_ERR "kexec: REL relocation unsupported\n");
+	return -ENOEXEC;
+}
+
 /*
  * Free up tempory buffers allocated which are not needed after image has
  * been loaded.
@@ -360,6 +381,12 @@ static void kimage_file_post_load_cleanup(struct kimage *image)
 	vfree(image->cmdline_buf);
 	image->cmdline_buf = NULL;
 
+	vfree(image->purgatory_info.purgatory_buf);
+	image->purgatory_info.purgatory_buf = NULL;
+
+	vfree(image->purgatory_info.sechdrs);
+	image->purgatory_info.sechdrs = NULL;
+
 	/* See if architcture has anything to cleanup post load */
 	arch_kimage_file_post_load_cleanup(image);
 }
@@ -1374,6 +1401,10 @@ SYSCALL_DEFINE5(kexec_file_load, int, kernel_fd, int, initrd_fd, const char __us
 	if (ret)
 		goto out;
 
+	ret = kexec_calculate_store_digests(image);
+	if (ret)
+		goto out;
+
 	for (i = 0; i < image->nr_segments; i++) {
 		struct kexec_segment *ksegment;
 
@@ -2137,6 +2168,456 @@ int kexec_add_buffer(struct kimage *image, char *buffer,
 	return 0;
 }
 
+/* Calculate and store the digest of segments */
+static int kexec_calculate_store_digests(struct kimage *image)
+{
+	struct crypto_shash *tfm;
+	struct shash_desc *desc;
+	int ret = 0, i, j, zero_buf_sz = 256, sha_region_sz;
+	size_t desc_size, nullsz;
+	char *digest = NULL;
+	void *zero_buf;
+	struct kexec_sha_region *sha_regions;
+
+	tfm = crypto_alloc_shash("sha256", 0, 0);
+	if (IS_ERR(tfm)) {
+		ret = PTR_ERR(tfm);
+		goto out;
+	}
+
+	desc_size = crypto_shash_descsize(tfm) + sizeof(*desc);
+	desc = kzalloc(desc_size, GFP_KERNEL);
+	if (!desc) {
+		ret = -ENOMEM;
+		goto out_free_tfm;
+	}
+
+	zero_buf = kzalloc(zero_buf_sz, GFP_KERNEL);
+	if (!zero_buf) {
+		ret = -ENOMEM;
+		goto out_free_desc;
+	}
+
+	sha_region_sz = KEXEC_SEGMENT_MAX * sizeof(struct kexec_sha_region);
+	sha_regions = vzalloc(sha_region_sz);
+	if (!sha_regions)
+		goto out_free_zero_buf;
+
+	desc->tfm   = tfm;
+	desc->flags = 0;
+
+	ret = crypto_shash_init(desc);
+	if (ret < 0)
+		goto out_free_sha_regions;
+
+	digest = kzalloc(SHA256_DIGEST_SIZE, GFP_KERNEL);
+	if (!digest) {
+		ret = -ENOMEM;
+		goto out_free_sha_regions;
+	}
+
+	/* Traverse through all segments */
+	for (j = i = 0; i < image->nr_segments; i++) {
+		struct kexec_segment *ksegment;
+		ksegment = &image->segment[i];
+
+		/*
+		 * Skip purgatory as it will be modified once we put digest
+		 * info in purgatory
+		 */
+		if (ksegment->kbuf == image->purgatory_info.purgatory_buf)
+			continue;
+
+		ret = crypto_shash_update(desc, ksegment->kbuf,
+						ksegment->bufsz);
+		if (ret)
+			break;
+
+		nullsz = ksegment->memsz - ksegment->bufsz;
+		while (nullsz) {
+			unsigned long bytes = nullsz;
+			if (bytes > zero_buf_sz)
+				bytes = zero_buf_sz;
+			ret = crypto_shash_update(desc, zero_buf, bytes);
+			if (ret)
+				break;
+			nullsz -= bytes;
+		}
+
+		if (ret)
+			break;
+
+		sha_regions[j].start = ksegment->mem;
+		sha_regions[j].len = ksegment->memsz;
+		j++;
+	}
+
+	if (!ret) {
+		ret = crypto_shash_final(desc, digest);
+		if (ret)
+			goto out_free_sha_regions;
+		ret = kexec_purgatory_get_set_symbol(image, "sha_regions",
+				sha_regions, sha_region_sz, 0);
+		if (ret)
+			goto out_free_sha_regions;
+
+		ret = kexec_purgatory_get_set_symbol(image, "sha256_digest",
+				digest, SHA256_DIGEST_SIZE, 0);
+		if (ret)
+			goto out_free_sha_regions;
+	}
+
+out_free_sha_regions:
+	vfree(sha_regions);
+out_free_zero_buf:
+	kfree(zero_buf);
+out_free_desc:
+	kfree(desc);
+out_free_tfm:
+	kfree(tfm);
+out:
+	kfree(digest);
+	return ret;
+}
+
+/* Actually load and relcoate purgatory. Lot of code taken from kexec-tools */
+static int elf_rel_load_relocate(struct kimage *image, unsigned long min,
+				unsigned long max, int top_down)
+{
+	struct purgatory_info *pi = &image->purgatory_info;
+	unsigned long align, buf_align, bss_align, buf_sz, bss_sz, bss_pad;
+	unsigned long memsz, entry, load_addr, data_addr, bss_addr, off;
+	unsigned char *buf_addr, *src;
+	int i, ret = 0, entry_sidx = -1;
+	Elf_Shdr *sechdrs, *sechdrs_c;
+
+	/*
+	 * sechdrs_c points to section headers in purgatory and are read
+	 * only. No modifications allowed.
+	 */
+	sechdrs_c = (void *)pi->ehdr + pi->ehdr->e_shoff;
+
+	/*
+	 * We can not modify sechdrs_c[] and its fields. It is read only.
+	 * Copy it over to a local copy where one can store some temporary
+	 * data and free it at the end. We need to modify ->sh_addr and
+	 * ->sh_offset fields to keep track permanent and temporary locations
+	 * of sections.
+	 */
+	sechdrs = vzalloc(pi->ehdr->e_shnum * sizeof(Elf_Shdr));
+	if (!sechdrs)
+		return -ENOMEM;
+
+	memcpy(sechdrs, sechdrs_c, pi->ehdr->e_shnum * sizeof(Elf_Shdr));
+
+	/*
+	 * We seem to have multiple copies of sections. First copy is which
+	 * is embedded in kernel in read only section. Some of these sections
+	 * will be copied to a temporary buffer and relocated. And these
+	 * sections will finally be copied to their final detination at
+	 * segment load time.
+	 *
+	 * Use ->sh_offset to reflect section address in memory. It will
+	 * point to original read only copy if section is not allocatable.
+	 * Otherwise it will point to temporary copy which will be relocated.
+	 *
+	 * Use ->sh_addr to contain final address of the section where it
+	 * will go during execution time.
+	 */
+	for (i = 0; i < pi->ehdr->e_shnum; i++) {
+		if (sechdrs[i].sh_type == SHT_NOBITS)
+			continue;
+
+		sechdrs[i].sh_offset = (unsigned long)pi->ehdr +
+						sechdrs[i].sh_offset;
+	}
+
+	entry = pi->ehdr->e_entry;
+	for (i = 0; i < pi->ehdr->e_shnum; i++) {
+		if (!(sechdrs[i].sh_flags & SHF_ALLOC))
+			continue;
+
+		if (!(sechdrs[i].sh_flags & SHF_EXECINSTR))
+			continue;
+
+		/* Make entry section relative */
+		if (sechdrs[i].sh_addr <= pi->ehdr->e_entry &&
+		    ((sechdrs[i].sh_addr + sechdrs[i].sh_size) >
+		     pi->ehdr->e_entry)) {
+			entry_sidx = i;
+			entry -= sechdrs[i].sh_addr;
+			break;
+		}
+	}
+
+	/* Find the RAM size requirements of relocatable object */
+	buf_align = 1;
+	bss_align = 1;
+	buf_sz = 0;
+	bss_sz = 0;
+
+	for (i = 0; i < pi->ehdr->e_shnum; i++) {
+		if (!(sechdrs[i].sh_flags & SHF_ALLOC))
+			continue;
+
+		align = sechdrs[i].sh_addralign;
+		if (sechdrs[i].sh_type != SHT_NOBITS) {
+			if (buf_align < align)
+				buf_align = align;
+			buf_sz = ALIGN(buf_sz, align);
+			buf_sz += sechdrs[i].sh_size;
+		} else {
+			if (bss_align < align)
+				bss_align = align;
+			bss_sz = ALIGN(bss_sz, align);
+			bss_sz += sechdrs[i].sh_size;
+		}
+	}
+
+	if (buf_align < bss_align)
+		buf_align = bss_align;
+	bss_pad = 0;
+	if (buf_sz & (bss_align - 1))
+		bss_pad = bss_align - (buf_sz & (bss_align - 1));
+
+	memsz = buf_sz + bss_pad + bss_sz;
+
+	/* Allocate buffer for purgatory */
+	pi->purgatory_buf = vzalloc(buf_sz);
+	if (!pi->purgatory_buf) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	/* Add buffer to segment list */
+	ret = kexec_add_buffer(image, pi->purgatory_buf, buf_sz, memsz,
+				buf_align, min, max, top_down,
+				&pi->purgatory_load_addr);
+	if (ret)
+		goto out;
+
+	/* Load SHF_ALLOC sections */
+	buf_addr = pi->purgatory_buf;
+	load_addr = pi->purgatory_load_addr;
+	data_addr = load_addr;
+	bss_addr = load_addr + buf_sz + bss_pad;
+
+	for (i = 0; i < pi->ehdr->e_shnum; i++) {
+		if (!(sechdrs[i].sh_flags & SHF_ALLOC))
+			continue;
+
+		align = sechdrs[i].sh_addralign;
+		if (sechdrs[i].sh_type != SHT_NOBITS) {
+			data_addr = ALIGN(data_addr, align);
+			off = data_addr - load_addr;
+			/* We have already modifed ->sh_offset to keep addr */
+			src = (char *) sechdrs[i].sh_offset;
+			memcpy(buf_addr + off, src, sechdrs[i].sh_size);
+
+			/* Store load address and source address of section */
+			sechdrs[i].sh_addr = data_addr;
+
+			/*
+			 * This section got copied to temporary buffer. Update
+			 * ->sh_offset accordingly.
+			 */
+			sechdrs[i].sh_offset = (unsigned long)(buf_addr + off);
+
+			/* Advance to the next address */
+			data_addr += sechdrs[i].sh_size;
+		} else {
+			bss_addr = ALIGN(bss_addr, align);
+			sechdrs[i].sh_addr = bss_addr;
+			bss_addr += sechdrs[i].sh_size;
+		}
+	}
+
+	/* update entry based on entry section position */
+	if (entry_sidx >= 0)
+		entry += sechdrs[entry_sidx].sh_addr;
+
+	/* Set the entry point of purgatory */
+	kimage_set_start_addr(image, entry);
+
+	/* Apply relocations */
+	for (i = 0; i < pi->ehdr->e_shnum; i++) {
+		Elf_Shdr *section, *symtab;
+
+		if (sechdrs[i].sh_type != SHT_RELA &&
+		    sechdrs[i].sh_type != SHT_REL)
+			continue;
+
+		if (sechdrs[i].sh_info > pi->ehdr->e_shnum ||
+		    sechdrs[i].sh_link > pi->ehdr->e_shnum) {
+			ret = -ENOEXEC;
+			goto out;
+		}
+
+		section = &sechdrs[sechdrs[i].sh_info];
+		symtab = &sechdrs[sechdrs[i].sh_link];
+
+		if (!(section->sh_flags & SHF_ALLOC))
+			continue;
+
+		if (symtab->sh_link > pi->ehdr->e_shnum)
+			/* Invalid section number? */
+			continue;
+
+		ret = -EOPNOTSUPP;
+		if (sechdrs[i].sh_type == SHT_RELA)
+			ret = arch_kexec_apply_relocations_add(sechdrs, pi->ehdr->e_shnum, i);
+		if (ret)
+			goto out;
+	}
+
+	pi->sechdrs = sechdrs;
+	return ret;
+out:
+	vfree(sechdrs);
+	vfree(pi->purgatory_buf);
+	return ret;
+}
+
+/* Load relocatable purgatory object and relocate it appropriately */
+int kexec_load_purgatory(struct kimage *image, unsigned long min,
+		unsigned long max, int top_down, unsigned long *load_addr)
+{
+	struct purgatory_info *pi = &image->purgatory_info;
+	int ret;
+
+	if (kexec_purgatory_size <= 0)
+		return -EINVAL;
+
+	if (kexec_purgatory_size < sizeof(Elf_Ehdr))
+		return -ENOEXEC;
+
+	pi->ehdr = (Elf_Ehdr *)kexec_purgatory;
+
+	if (memcmp(pi->ehdr->e_ident, ELFMAG, SELFMAG) != 0
+	    || pi->ehdr->e_type != ET_REL
+	    || !elf_check_arch(pi->ehdr)
+	    || pi->ehdr->e_shentsize != sizeof(Elf_Shdr))
+		return -ENOEXEC;
+
+	if (pi->ehdr->e_shoff >= kexec_purgatory_size
+	    || (pi->ehdr->e_shnum * sizeof(Elf_Shdr) >
+	    kexec_purgatory_size - pi->ehdr->e_shoff))
+		return -ENOEXEC;
+
+	ret = elf_rel_load_relocate(image, min, max, top_down);
+	if (ret)
+		return ret;
+
+	*load_addr = image->purgatory_info.purgatory_load_addr;
+	return 0;
+}
+
+static Elf_Sym *kexec_purgatory_find_symbol(struct purgatory_info *pi,
+						const char *name)
+{
+	Elf_Sym *syms;
+	Elf_Shdr *sechdrs;
+	Elf_Ehdr *ehdr;
+	int i, k;
+	const char *strtab;
+
+	if (!pi->sechdrs || !pi->ehdr)
+		return NULL;
+
+	sechdrs = pi->sechdrs;
+	ehdr = pi->ehdr;
+
+	for (i = 0; i < ehdr->e_shnum; i++) {
+		if (sechdrs[i].sh_type != SHT_SYMTAB)
+			continue;
+
+		if (sechdrs[i].sh_link > ehdr->e_shnum)
+			/* Invalid stratab section number */
+			continue;
+		strtab = (char *)sechdrs[sechdrs[i].sh_link].sh_offset;
+		syms = (Elf_Sym*)sechdrs[i].sh_offset;
+
+		/* Go through symbols for a match */
+		for (k = 0; k < sechdrs[i].sh_size/sizeof(Elf_Sym); k++) {
+			if (ELF_ST_BIND(syms[k].st_info) != STB_GLOBAL)
+				continue;
+
+			if (strcmp(strtab + syms[k].st_name, name) != 0)
+				continue;
+
+			if (syms[k].st_shndx == SHN_UNDEF ||
+			    syms[k].st_shndx > ehdr->e_shnum) {
+				pr_debug("Symbol: %s has bad section index %d."
+					 "\n", name, syms[k].st_shndx);
+				return NULL;
+			}
+
+			/* Found the symbol we are looking for */
+			return &syms[k];
+		}
+	}
+
+	return NULL;
+}
+
+void *kexec_purgatory_get_symbol_addr(struct kimage *image, const char *name)
+{
+	struct purgatory_info *pi = &image->purgatory_info;
+	Elf_Sym *sym;
+	Elf_Shdr *sechdr;
+
+	sym = kexec_purgatory_find_symbol(pi, name);
+	if (!sym)
+		return ERR_PTR(-EINVAL);
+
+	sechdr = &pi->sechdrs[sym->st_shndx];
+
+	/*
+	 * Returns the address where symbol will finally be loaded after
+	 * kexec_load_segment()
+	 */
+	return (void *)(sechdr->sh_addr + sym->st_value);
+}
+
+/*
+ * Get or set value of a symbol. If "get_value" is true, symbol value is
+ * returned in buf otherwise symbol value is set based on value in buf.
+ */
+int kexec_purgatory_get_set_symbol(struct kimage *image, const char *name,
+				void *buf, unsigned int size, bool get_value)
+{
+	Elf_Sym *sym;
+	Elf_Shdr *sechdrs;
+	struct purgatory_info *pi = &image->purgatory_info;
+	char *sym_buf;
+
+	sym = kexec_purgatory_find_symbol(pi, name);
+	if (!sym)
+		return -EINVAL;
+
+	if (sym->st_size != size) {
+		pr_debug("Symbol: %s size is not right\n", name);
+		return -EINVAL;
+	}
+
+	sechdrs = pi->sechdrs;
+
+	if (sechdrs[sym->st_shndx].sh_type == SHT_NOBITS) {
+		pr_debug("Symbol: %s is in a bss section. Cannot get/set\n",
+					name);
+		return -EINVAL;
+	}
+
+	sym_buf = (unsigned char *)sechdrs[sym->st_shndx].sh_offset +
+					sym->st_value;
+
+	if (get_value)
+		memcpy((void*)buf, sym_buf, size);
+	else
+		memcpy((void*)sym_buf, buf, size);
+
+	return 0;
+}
 
 /*
  * Move into place and start executing a preloaded standalone
-- 
1.8.4.2

