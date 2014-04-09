Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758369AbaDIIZw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 04:25:52 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:48203 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756557AbaDIIZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 04:25:49 -0400
Date: Wed, 9 Apr 2014 09:25:36 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Thomas =?iso-8859-1?Q?B=E4chler?= <thomas@archlinux.org>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, matt.fleming@intel.com,
        ak@linux.intel.com, viro@zeniv.linux.org.uk, geert@linux-m68k.org,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, tpowa@archlinux.org, hpa@zytor.com
Subject: Re: 3.13: <module> disagrees about version of symbol <symbol>
Message-ID: <20140409082536.GJ5222@console-pimps.org>
References: <20140407173016.GU32556@tassilo.jf.intel.com>
 <5342E46B.4080603@archlinux.org>
 <53430646.40507@archlinux.org>
 <20140407204221.GW32556@tassilo.jf.intel.com>
 <CAL01qpvjZz-XnVT+S3E5E2XGcuFoetE5cwnArYfW-TwYZVKtKw@mail.gmail.com>
 <201404080646.BID87018.SOOVJMFOLFtQHF@I-love.SAKURA.ne.jp>
 <20140408121400.GI5222@console-pimps.org>
 <53444681.1070902@archlinux.org>
 <53445660.1010908@archlinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53445660.1010908@archlinux.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 08 Apr, at 10:04:48PM, Thomas Bächler wrote:
> 
> Hello again Matt,
> 
> with linux.git master, I cannot reproduce the problem at all (with or
> without your patch). In fact, all the 0x0 CRCs on symbols are gone, and
> those were the symbols that were broken after all.
> 
> FWIW, with your patch the kernel still boots.
 
Could you try this version? It's against v3.14,


diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index a7677babf946..78cbb2db5a85 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -425,6 +425,9 @@ void setup_graphics(struct boot_params *boot_params)
  * Because the x86 boot code expects to be passed a boot_params we
  * need to create one ourselves (usually the bootloader would create
  * one for us).
+ *
+ * The caller is responsible for filling out ->code32_start in the
+ * returned boot_params.
  */
 struct boot_params *make_boot_params(void *handle, efi_system_table_t *_table)
 {
@@ -483,8 +486,6 @@ struct boot_params *make_boot_params(void *handle, efi_system_table_t *_table)
 	hdr->vid_mode = 0xffff;
 	hdr->boot_flag = 0xAA55;
 
-	hdr->code32_start = (__u64)(unsigned long)image->image_base;
-
 	hdr->type_of_loader = 0x21;
 
 	/* Convert unicode cmdline to ascii */
diff --git a/arch/x86/boot/compressed/head_32.S b/arch/x86/boot/compressed/head_32.S
index 9116aac232c7..f45ab7a36fb6 100644
--- a/arch/x86/boot/compressed/head_32.S
+++ b/arch/x86/boot/compressed/head_32.S
@@ -50,6 +50,13 @@ ENTRY(efi_pe_entry)
 	pushl	%eax
 	pushl	%esi
 	pushl	%ecx
+
+	call	reloc
+reloc:
+	popl	%ecx
+	subl	reloc, %ecx
+	movl	%ecx, BP_code32_start(%eax)
+
 	sub	$0x4, %esp
 
 ENTRY(efi_stub_entry)
@@ -63,12 +70,7 @@ ENTRY(efi_stub_entry)
 	hlt
 	jmp	1b
 2:
-	call	3f
-3:
-	popl	%eax
-	subl	$3b, %eax
-	subl	BP_pref_address(%esi), %eax
-	add	BP_code32_start(%esi), %eax
+	movl	BP_code32_start(%esi), %eax
 	leal	preferred_addr(%eax), %eax
 	jmp	*%eax
 
diff --git a/arch/x86/boot/compressed/head_64.S b/arch/x86/boot/compressed/head_64.S
index c5c1ae0997e7..b10fa66a2540 100644
--- a/arch/x86/boot/compressed/head_64.S
+++ b/arch/x86/boot/compressed/head_64.S
@@ -217,6 +217,8 @@ ENTRY(efi_pe_entry)
 	cmpq	$0,%rax
 	je	1f
 	mov	%rax, %rdx
+	leaq	startup_32(%rip), %rax
+	movl	%eax, BP_code32_start(%rdx)
 	popq	%rsi
 	popq	%rdi
 
@@ -230,12 +232,7 @@ ENTRY(efi_stub_entry)
 	hlt
 	jmp	1b
 2:
-	call	3f
-3:
-	popq	%rax
-	subq	$3b, %rax
-	subq	BP_pref_address(%rsi), %rax
-	add	BP_code32_start(%esi), %eax
+	movl	BP_code32_start(%esi), %eax
 	leaq	preferred_addr(%rax), %rax
 	jmp	*%rax
 

-- 
Matt Fleming, Intel Open Source Technology Center
