Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757478AbaCDNQe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 08:16:34 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:58514 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757065AbaCDNOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 08:14:43 -0500
From: Matt Fleming <matt@console-pimps.org>
To: linux-efi@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org,
        Matt Fleming <matt.fleming@intel.com>
Subject: [PATCH 09/13] x86/efi: Firmware agnostic handover entry points
Date: Tue,  4 Mar 2014 13:14:17 +0000
Message-Id: <1393938861-16797-10-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1393938861-16797-1-git-send-email-matt@console-pimps.org>
References: <1393938861-16797-1-git-send-email-matt@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@intel.com>

The EFI handover code only works if the "bitness" of the firmware and
the kernel match, i.e. 64-bit firmware and 64-bit kernel - it is not
possible to mix the two. This goes against the tradition that a 32-bit
kernel can be loaded on a 64-bit BIOS platform without having to do
anything special in the boot loader. Linux distributions, for one thing,
regularly run only 32-bit kernels on their live media.

Despite having only one 'handover_offset' field in the kernel header,
EFI boot loaders use two separate entry points to enter the kernel based
on the architecture the boot loader was compiled for,

    (1) 32-bit loader: handover_offset
    (2) 64-bit loader: handover_offset + 512

Since we already have two entry points, we can leverage them to infer
the bitness of the firmware we're running on, without requiring any boot
loader modifications, by making (1) and (2) valid entry points for both
CONFIG_X86_32 and CONFIG_X86_64 kernels.

To be clear, a 32-bit boot loader will always use (1) and a 64-bit boot
loader will always use (2). It's just that, if a single kernel image
supports (1) and (2) that image can be used with both 32-bit and 64-bit
boot loaders, and hence both 32-bit and 64-bit EFI.

(1) and (2) must be 512 bytes apart at all times, but that is already
part of the boot ABI and we could never change that delta without
breaking existing boot loaders anyhow.

Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
 arch/x86/boot/Makefile             |  2 +-
 arch/x86/boot/compressed/eboot.c   |  9 ++++--
 arch/x86/boot/compressed/head_32.S |  2 +-
 arch/x86/boot/compressed/head_64.S | 62 +++++++++++++++++++++++++++++++++-----
 arch/x86/boot/tools/build.c        | 22 +++++++++-----
 arch/x86/include/asm/efi.h         |  6 ++--
 6 files changed, 80 insertions(+), 23 deletions(-)

diff --git a/arch/x86/boot/Makefile b/arch/x86/boot/Makefile
index de7066918005..b9e320bd41c4 100644
--- a/arch/x86/boot/Makefile
+++ b/arch/x86/boot/Makefile
@@ -93,7 +93,7 @@ targets += voffset.h
 $(obj)/voffset.h: vmlinux FORCE
 	$(call if_changed,voffset)
 
-sed-zoffset := -e 's/^\([0-9a-fA-F]*\) . \(startup_32\|startup_64\|efi_pe_entry\|efi_stub_entry\|input_data\|_end\|z_.*\)$$/\#define ZO_\2 0x\1/p'
+sed-zoffset := -e 's/^\([0-9a-fA-F]*\) . \(startup_32\|startup_64\|efi32_stub_entry\|efi64_stub_entry\|efi_pe_entry\|input_data\|_end\|z_.*\)$$/\#define ZO_\2 0x\1/p'
 
 quiet_cmd_zoffset = ZOFFSET $@
       cmd_zoffset = $(NM) $< | sed -n $(sed-zoffset) > $@
diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index ab1f3a2f1e1e..5e1ba4fa3f79 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -1256,12 +1256,13 @@ static efi_status_t alloc_e820ext(u32 nr_desc, struct setup_data **e820ext,
 }
 
 static efi_status_t exit_boot(struct boot_params *boot_params,
-			      void *handle)
+			      void *handle, bool is64)
 {
 	struct efi_info *efi = &boot_params->efi_info;
 	unsigned long map_sz, key, desc_size;
 	efi_memory_desc_t *mem_map;
 	struct setup_data *e820ext;
+	const char *signature;
 	__u32 e820ext_size;
 	__u32 nr_desc, prev_nr_desc;
 	efi_status_t status;
@@ -1295,7 +1296,9 @@ get_map:
 		goto get_map; /* Allocated memory, get map again */
 	}
 
-	memcpy(&efi->efi_loader_signature, EFI_LOADER_SIGNATURE, sizeof(__u32));
+	signature = is64 ? EFI64_LOADER_SIGNATURE : EFI32_LOADER_SIGNATURE;
+	memcpy(&efi->efi_loader_signature, signature, sizeof(__u32));
+
 	efi->efi_systab = (unsigned long)sys_table;
 	efi->efi_memdesc_size = desc_size;
 	efi->efi_memdesc_version = desc_version;
@@ -1408,7 +1411,7 @@ struct boot_params *efi_main(struct efi_config *c,
 		hdr->code32_start = bzimage_addr;
 	}
 
-	status = exit_boot(boot_params, handle);
+	status = exit_boot(boot_params, handle, is64);
 	if (status != EFI_SUCCESS)
 		goto fail;
 
diff --git a/arch/x86/boot/compressed/head_32.S b/arch/x86/boot/compressed/head_32.S
index eed23c087d6c..cccc05f0681c 100644
--- a/arch/x86/boot/compressed/head_32.S
+++ b/arch/x86/boot/compressed/head_32.S
@@ -64,7 +64,7 @@ ENTRY(efi_pe_entry)
 	pushl	%ecx
 	jmp	2f		/* Skip efi_config initialization */
 
-ENTRY(efi_stub_entry)
+ENTRY(efi32_stub_entry)
 	add	$0x4, %esp
 	popl	%ecx
 	popl	%edx
diff --git a/arch/x86/boot/compressed/head_64.S b/arch/x86/boot/compressed/head_64.S
index 1bc206fa4bd0..37c741b0d2ac 100644
--- a/arch/x86/boot/compressed/head_64.S
+++ b/arch/x86/boot/compressed/head_64.S
@@ -178,6 +178,13 @@ ENTRY(startup_32)
 	 */
 	pushl	$__KERNEL_CS
 	leal	startup_64(%ebp), %eax
+#ifdef CONFIG_EFI_MIXED
+	movl	efi32_config(%ebp), %ebx
+	cmp	$0, %ebx
+	jz	1f
+	leal	handover_entry(%ebp), %eax
+1:
+#endif
 	pushl	%eax
 
 	/* Enter paged protected Mode, activating Long Mode */
@@ -188,6 +195,30 @@ ENTRY(startup_32)
 	lret
 ENDPROC(startup_32)
 
+#ifdef CONFIG_EFI_MIXED
+	.org 0x190
+ENTRY(efi32_stub_entry)
+	add	$0x4, %esp		/* Discard return address */
+	popl	%ecx
+	popl	%edx
+	popl	%esi
+
+	leal	(BP_scratch+4)(%esi), %esp
+	call	1f
+1:	pop	%ebp
+	subl	$1b, %ebp
+
+	movl	%ecx, efi32_config(%ebp)
+	movl	%edx, efi32_config+8(%ebp)
+	sgdtl	efi32_boot_gdt(%ebp)
+
+	leal	efi32_config(%ebp), %eax
+	movl	%eax, efi_config(%ebp)
+
+	jmp	startup_32
+ENDPROC(efi32_stub_entry)
+#endif
+
 	.code64
 	.org 0x200
 ENTRY(startup_64)
@@ -231,13 +262,7 @@ ENTRY(efi_pe_entry)
 	mov	%rax, %rsi
 	jmp	2f		/* Skip the relocation */
 
-ENTRY(efi_stub_entry)
-	movq	%rdi, efi64_config(%rip)	/* Handle */
-	movq	%rsi, efi64_config+8(%rip) /* EFI System table pointer */
-
-	leaq	efi64_config(%rip), %rax
-	movq	%rax, efi_config(%rip)
-
+handover_entry:
 	call	1f
 1:	popq	%rbp
 	subq	$1b, %rbp
@@ -247,7 +272,6 @@ ENTRY(efi_stub_entry)
 	 */
 	movq	efi_config(%rip), %rax
 	addq	%rbp, 88(%rax)
-	movq	%rdx, %rsi
 2:
 	movq	efi_config(%rip), %rdi
 	call	efi_main
@@ -336,6 +360,20 @@ preferred_addr:
 	leaq	relocated(%rbx), %rax
 	jmp	*%rax
 
+#ifdef CONFIG_EFI_STUB
+	.org 0x390
+ENTRY(efi64_stub_entry)
+	movq	%rdi, efi64_config(%rip)	/* Handle */
+	movq	%rsi, efi64_config+8(%rip) /* EFI System table pointer */
+
+	leaq	efi64_config(%rip), %rax
+	movq	%rax, efi_config(%rip)
+
+	movq	%rdx, %rsi
+	jmp	handover_entry
+ENDPROC(efi64_stub_entry)
+#endif
+
 	.text
 relocated:
 
@@ -404,6 +442,14 @@ gdt_end:
 efi_config:
 	.quad	0
 
+#ifdef CONFIG_EFI_MIXED
+	.global efi32_config
+efi32_config:
+	.fill	11,8,0
+	.quad	efi64_thunk
+	.byte	0
+#endif
+
 	.global efi64_config
 efi64_config:
 	.fill	11,8,0
diff --git a/arch/x86/boot/tools/build.c b/arch/x86/boot/tools/build.c
index bf262077ec92..4f07df5ac5d9 100644
--- a/arch/x86/boot/tools/build.c
+++ b/arch/x86/boot/tools/build.c
@@ -53,7 +53,8 @@ int is_big_kernel;
 
 #define PECOFF_RELOC_RESERVE 0x20
 
-unsigned long efi_stub_entry;
+unsigned long efi32_stub_entry;
+unsigned long efi64_stub_entry;
 unsigned long efi_pe_entry;
 unsigned long startup_64;
 
@@ -231,20 +232,26 @@ static void efi_stub_defaults(void)
 	/* Defaults for old kernel */
 #ifdef CONFIG_X86_32
 	efi_pe_entry = 0x10;
-	efi_stub_entry = 0x30;
 #else
 	efi_pe_entry = 0x210;
-	efi_stub_entry = 0x230;
 	startup_64 = 0x200;
 #endif
 }
 
 static void efi_stub_entry_update(void)
 {
-#ifdef CONFIG_X86_64 /* Yes, this is really how we defined it :( */
-	efi_stub_entry -= 0x200;
+	unsigned long addr = efi32_stub_entry;
+
+#ifdef CONFIG_X86_64
+	/* Yes, this is really how we defined it :( */
+	addr = efi64_stub_entry - 0x200;
+#endif
+
+#ifdef CONFIG_EFI_MIXED
+	if (efi32_stub_entry != addr)
+		die("32-bit and 64-bit EFI entry points do not match\n");
 #endif
-	put_unaligned_le32(efi_stub_entry, &buf[0x264]);
+	put_unaligned_le32(addr, &buf[0x264]);
 }
 
 #else
@@ -289,7 +296,8 @@ static void parse_zoffset(char *fname)
 	p = (char *)buf;
 
 	while (p && *p) {
-		PARSE_ZOFS(p, efi_stub_entry);
+		PARSE_ZOFS(p, efi32_stub_entry);
+		PARSE_ZOFS(p, efi64_stub_entry);
 		PARSE_ZOFS(p, efi_pe_entry);
 		PARSE_ZOFS(p, startup_64);
 
diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index d3c099f53ff2..6647efb6c6e8 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -19,9 +19,11 @@
  */
 #define EFI_OLD_MEMMAP		EFI_ARCH_1
 
+#define EFI32_LOADER_SIGNATURE	"EL32"
+#define EFI64_LOADER_SIGNATURE	"EL64"
+
 #ifdef CONFIG_X86_32
 
-#define EFI_LOADER_SIGNATURE	"EL32"
 
 extern unsigned long asmlinkage efi_call_phys(void *, ...);
 
@@ -57,8 +59,6 @@ extern unsigned long asmlinkage efi_call_phys(void *, ...);
 
 #else /* !CONFIG_X86_32 */
 
-#define EFI_LOADER_SIGNATURE	"EL64"
-
 extern u64 efi_call0(void *fp);
 extern u64 efi_call1(void *fp, u64 arg1);
 extern u64 efi_call2(void *fp, u64 arg1, u64 arg2);
-- 
1.8.5.3

