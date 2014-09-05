Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751624AbaIEU1u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 16:27:50 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:40126 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940AbaIEU1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 16:27:47 -0400
Date: Fri, 5 Sep 2014 21:27:44 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Michael Brown <mbrown@fensystems.co.uk>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Ulf Winkelvos <ulf@winkelvos.de>,
        Matt Fleming <matt.fleming@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        Seth Forshee <seth.forshee@canonical.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [REGRESSION] "efi: efistub: Convert into static library" and
 preparation patches
Message-ID: <20140905202744.GO3001@console-pimps.org>
References: <CAKv+Gu8OD3p+GSwB+SPRf3pKwZB2R1t6x1zK7czGCXj1QhB7_g@mail.gmail.com>
 <54073409.6030004@canonical.com>
 <CAKv+Gu9q1qTh6DZXsCG2tGVBn-uwuQKQa_6FEMmchDVFi5vJtw@mail.gmail.com>
 <20140903175948.GH3001@console-pimps.org>
 <CAKv+Gu9tejixb3Kb3YM_7sLcpKNuRHN+Dn+twFyCAXx99wYRCw@mail.gmail.com>
 <54084376.8090002@canonical.com>
 <540860F1.6060801@fensystems.co.uk>
 <CAKv+Gu8wALTqtNQK_855A7M5f2a+EB1JyLxo=j6G0T1cf8ZFog@mail.gmail.com>
 <CAKv+Gu_sLmkBHF-9GyPUgfAbLYirQTD4vk63o6HzdZhm6s_e0g@mail.gmail.com>
 <20140904213753.GM3001@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140904213753.GM3001@console-pimps.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 04 Sep, at 10:37:53PM, Matt Fleming wrote:
> 
> Thanks Ard, I'll take a look in the morning.

Maarten, could you try out this patch?

---

>From a058d81d9687671813560af72f34d63da3cc16bc Mon Sep 17 00:00:00 2001
From: Matt Fleming <matt.fleming@intel.com>
Date: Fri, 5 Sep 2014 14:52:26 +0100
Subject: [PATCH] x86/efi: Fixup GOT in all boot code paths

Maarten reported that his Macbook pro 8.2 stopped booting after commit
f23cf8bd5c1f49 ("efi/x86: efistub: Move shared dependencies to
<asm/efi.h>"), the main feature of which is changing the visibility of
symbol 'efi_early' from local to global.

By making 'efi_early' global we end up requiring an entry in the Global
Offset Table. Unfortunately, while we do include code to fixup GOT
entries in the early boot code, it's only called after we've executed
the EFI boot stub.

What this amounts to is that references to 'efi_early' in the EFI boot
stub don't point to the correct place.

Since we've got multiple boot entry points we need to be prepared to
fixup the GOT in multiple places, while ensuring that we never do it
more than once, otherwise the GOT entries will still point to the wrong
place.

Reported-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
 arch/x86/boot/compressed/head_32.S | 54 ++++++++++++++++++++++++++----------
 arch/x86/boot/compressed/head_64.S | 56 ++++++++++++++++++++++++++++----------
 2 files changed, 81 insertions(+), 29 deletions(-)

diff --git a/arch/x86/boot/compressed/head_32.S b/arch/x86/boot/compressed/head_32.S
index cbed1407a5cd..d6b8aa4c986c 100644
--- a/arch/x86/boot/compressed/head_32.S
+++ b/arch/x86/boot/compressed/head_32.S
@@ -30,6 +30,33 @@
 #include <asm/boot.h>
 #include <asm/asm-offsets.h>
 
+/*
+ * Adjust our own GOT
+ *
+ * The relocation base must be in %ebx
+ *
+ * It is safe to call this macro more than once, because in some of the
+ * code paths multiple invocations are inevitable, e.g. via the efi*
+ * entry points.
+ *
+ * Relocation is only performed the first time.
+ */
+.macro FIXUP_GOT
+	cmpb	$1, got_fixed(%ebx)
+	je	2f
+
+	leal	_got(%ebx), %edx
+	leal	_egot(%ebx), %ecx
+1:
+	cmpl	%ecx, %edx
+	jae	2f
+	addl	%ebx, (%edx)
+	addl	$4, %edx
+	jmp	1b
+2:
+	movb	$1, got_fixed(%ebx)
+.endm
+
 	__HEAD
 ENTRY(startup_32)
 #ifdef CONFIG_EFI_STUB
@@ -56,6 +83,9 @@ ENTRY(efi_pe_entry)
 	add	%esi, 88(%eax)
 	pushl	%eax
 
+	movl	%esi, %ebx
+	FIXUP_GOT
+
 	call	make_boot_params
 	cmpl	$0, %eax
 	je	fail
@@ -81,6 +111,10 @@ ENTRY(efi32_stub_entry)
 	leal	efi32_config(%esi), %eax
 	add	%esi, 88(%eax)
 	pushl	%eax
+
+	movl	%esi, %ebx
+	FIXUP_GOT
+
 2:
 	call	efi_main
 	cmpl	$0, %eax
@@ -190,19 +224,7 @@ relocated:
 	shrl	$2, %ecx
 	rep	stosl
 
-/*
- * Adjust our own GOT
- */
-	leal	_got(%ebx), %edx
-	leal	_egot(%ebx), %ecx
-1:
-	cmpl	%ecx, %edx
-	jae	2f
-	addl	%ebx, (%edx)
-	addl	$4, %edx
-	jmp	1b
-2:
-
+	FIXUP_GOT
 /*
  * Do the decompression, and jump to the new kernel..
  */
@@ -225,8 +247,12 @@ relocated:
 	xorl	%ebx, %ebx
 	jmp	*%eax
 
-#ifdef CONFIG_EFI_STUB
 	.data
+/* Have we relocated the GOT? */
+got_fixed:
+	.byte 0
+
+#ifdef CONFIG_EFI_STUB
 efi32_config:
 	.fill 11,8,0
 	.long efi_call_phys
diff --git a/arch/x86/boot/compressed/head_64.S b/arch/x86/boot/compressed/head_64.S
index 2884e0c3e8a5..50f69c7eaaf4 100644
--- a/arch/x86/boot/compressed/head_64.S
+++ b/arch/x86/boot/compressed/head_64.S
@@ -32,6 +32,33 @@
 #include <asm/processor-flags.h>
 #include <asm/asm-offsets.h>
 
+/*
+ * Adjust our own GOT
+ *
+ * The relocation base must be in %rbx
+ *
+ * It is safe to call this macro more than once, because in some of the
+ * code paths multiple invocations are inevitable, e.g. via the efi*
+ * entry points.
+ *
+ * Relocation is only performed the first time.
+ */
+.macro FIXUP_GOT
+	cmpb	$1, got_fixed(%rip)
+	je	2f
+
+	leaq	_got(%rip), %rdx
+	leaq	_egot(%rip), %rcx
+1:
+	cmpq	%rcx, %rdx
+	jae	2f
+	addq	%rbx, (%rdx)
+	addq	$8, %rdx
+	jmp	1b
+2:
+	movb	$1, got_fixed(%rip)
+.endm
+
 	__HEAD
 	.code32
 ENTRY(startup_32)
@@ -252,10 +279,13 @@ ENTRY(efi_pe_entry)
 	subq	$1b, %rbp
 
 	/*
-	 * Relocate efi_config->call().
+	 * Relocate efi_config->call() and the GOT entries.
 	 */
 	addq	%rbp, efi64_config+88(%rip)
 
+	movq	%rbp, %rbx
+	FIXUP_GOT
+
 	movq	%rax, %rdi
 	call	make_boot_params
 	cmpq	$0,%rax
@@ -271,10 +301,13 @@ handover_entry:
 	subq	$1b, %rbp
 
 	/*
-	 * Relocate efi_config->call().
+	 * Relocate efi_config->call() and the GOT entries.
 	 */
 	movq	efi_config(%rip), %rax
 	addq	%rbp, 88(%rax)
+
+	movq	%rbp, %rbx
+	FIXUP_GOT
 2:
 	movq	efi_config(%rip), %rdi
 	call	efi_main
@@ -385,19 +418,8 @@ relocated:
 	shrq	$3, %rcx
 	rep	stosq
 
-/*
- * Adjust our own GOT
- */
-	leaq	_got(%rip), %rdx
-	leaq	_egot(%rip), %rcx
-1:
-	cmpq	%rcx, %rdx
-	jae	2f
-	addq	%rbx, (%rdx)
-	addq	$8, %rdx
-	jmp	1b
-2:
-	
+	FIXUP_GOT
+
 /*
  * Do the decompression, and jump to the new kernel..
  */
@@ -437,6 +459,10 @@ gdt:
 	.quad   0x0000000000000000	/* TS continued */
 gdt_end:
 
+/* Have we relocated the GOT? */
+got_fixed:
+	.byte	0
+
 #ifdef CONFIG_EFI_STUB
 efi_config:
 	.quad	0
-- 
1.9.3

-- 
Matt Fleming, Intel Open Source Technology Center
