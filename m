Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755269AbaICR7y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 13:59:54 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:34949 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754277AbaICR7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 13:59:52 -0400
Date: Wed, 3 Sep 2014 18:59:48 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Ulf Winkelvos <ulf@winkelvos.de>,
        Matt Fleming <matt.fleming@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        Seth Forshee <seth.forshee@canonical.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [REGRESSION] "efi: efistub: Convert into static library" and
 preparation patches
Message-ID: <20140903175948.GH3001@console-pimps.org>
References: <5405E186.2080406@canonical.com>
 <20140902192941.GB3001@console-pimps.org>
 <CAKv+Gu_eSe+FeNkGm+w3sSsRn2_hr70xLVBieZgyhawAv6PQvw@mail.gmail.com>
 <5406D0DB.90401@canonical.com>
 <CAKv+Gu8OD3p+GSwB+SPRf3pKwZB2R1t6x1zK7czGCXj1QhB7_g@mail.gmail.com>
 <54073409.6030004@canonical.com>
 <CAKv+Gu9q1qTh6DZXsCG2tGVBn-uwuQKQa_6FEMmchDVFi5vJtw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKv+Gu9q1qTh6DZXsCG2tGVBn-uwuQKQa_6FEMmchDVFi5vJtw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 03 Sep, at 05:37:26PM, Ard Biesheuvel wrote:
> 
> Will do, thanks.
> 
> @Matt: so there is two ways to fix this, the patch above addressing
> this single instance, and alternatively, adding a #pragma GCC
> visiblilty push(hidden) to all .c files under libstub/, *before* the
> #includes. The latter would catch future problems regarding newly
> introduced global variables, but it may be a bit overkill in this
> case, as libstub is not expected to be in flux in the foreseeable
> future.
> 
> Any preferences?

Any reason we can't reuse the existing GOT fixup code in the early x86
boot code? We're not executing it before the EFI boot stub atm, which is
the reason Maarten is hitting these difficulties.

Maarten, does the following help?

If not, Ard please go ahead with option #2 above. Overkill yes, but I've
done the single __attribute__() hacks in other projects and someone
(usually me) always eventually forgets to tag some instance.

---

diff --git a/arch/x86/boot/compressed/head_64.S b/arch/x86/boot/compressed/head_64.S
index 2884e0c3e8a5..7618857fcc60 100644
--- a/arch/x86/boot/compressed/head_64.S
+++ b/arch/x86/boot/compressed/head_64.S
@@ -32,6 +32,21 @@
 #include <asm/processor-flags.h>
 #include <asm/asm-offsets.h>
 
+/*
+ * Adjust our own GOT
+ */
+.macro FIXUP_GOT
+	leaq	_got(%rip), %rdx
+	leaq	_egot(%rip), %rcx
+1:
+	cmpq	%rcx, %rdx
+	jae	2f
+	addq	%rbx, (%rdx)
+	addq	$8, %rdx
+	jmp	1b
+2:
+.endm
+
 	__HEAD
 	.code32
 ENTRY(startup_32)
@@ -256,6 +271,8 @@ ENTRY(efi_pe_entry)
 	 */
 	addq	%rbp, efi64_config+88(%rip)
 
+	FIXUP_GOT
+
 	movq	%rax, %rdi
 	call	make_boot_params
 	cmpq	$0,%rax
@@ -275,6 +292,7 @@ handover_entry:
 	 */
 	movq	efi_config(%rip), %rax
 	addq	%rbp, 88(%rax)
+	FIXUP_GOT
 2:
 	movq	efi_config(%rip), %rdi
 	call	efi_main
@@ -385,19 +403,8 @@ relocated:
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

-- 
Matt Fleming, Intel Open Source Technology Center
