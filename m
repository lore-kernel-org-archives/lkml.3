Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756719AbaDHMOP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 08:14:15 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:52147 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756604AbaDHMOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 08:14:10 -0400
Date: Tue, 8 Apr 2014 13:14:00 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: matt.fleming@intel.com, ak@linux.intel.com, thomas@archlinux.org,
        viro@zeniv.linux.org.uk, geert@linux-m68k.org,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, tpowa@archlinux.org, hpa@zytor.com
Subject: Re: 3.13: <module> disagrees about version of symbol <symbol>
Message-ID: <20140408121400.GI5222@console-pimps.org>
References: <20140407173016.GU32556@tassilo.jf.intel.com>
 <5342E46B.4080603@archlinux.org>
 <53430646.40507@archlinux.org>
 <20140407204221.GW32556@tassilo.jf.intel.com>
 <CAL01qpvjZz-XnVT+S3E5E2XGcuFoetE5cwnArYfW-TwYZVKtKw@mail.gmail.com>
 <201404080646.BID87018.SOOVJMFOLFtQHF@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201404080646.BID87018.SOOVJMFOLFtQHF@I-love.SAKURA.ne.jp>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 08 Apr, at 06:46:49AM, Tetsuo Handa wrote:
> Fleming, Matt wrote:
> > On 7 April 2014 21:42, Andi Kleen <ak@linux.intel.com> wrote:
> > >
> > > This sounds like the UEFI boot corrupts some memory?
> > 
> > Hmpf, yeah. I'll take a look in the morning.
> > 
> > Thomas, you mention you're running in a 32-bit vm earlier in this
> > thread. Any chance you're using ovmf because that would make it much
> > easier to track this down?
> > 
> 
> I'm not familiar with UEFI boot, but it could happen because what
> I experienced with BIOS boot was an address dependent behavior.
> 
> https://lkml.org/lkml/2013/9/4/188

OK, that's a pretty good clue, thanks Tetsuo.

Thomas, could you try this patch? It seems the use of code32_start in
the EFI boot stub was totally wrong for the case where the boot stub
relocates the kernel - you're likely to hit this path if using the EFI
boot stub directly from the EFI shell or gummiboot.

It was pointing at the start of the kernel image and not the protected
mode code.


diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index 1e6146137f8e..65e7d7e0ef1b 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -1016,6 +1016,9 @@ void setup_graphics(struct boot_params *boot_params)
  * Because the x86 boot code expects to be passed a boot_params we
  * need to create one ourselves (usually the bootloader would create
  * one for us).
+ *
+ * The caller is responsible for filling out ->code32_start in the
+ * returned boot_params.
  */
 struct boot_params *make_boot_params(struct efi_config *c)
 {
@@ -1081,8 +1084,6 @@ struct boot_params *make_boot_params(struct efi_config *c)
 	hdr->vid_mode = 0xffff;
 	hdr->boot_flag = 0xAA55;
 
-	hdr->code32_start = (__u64)(unsigned long)image->image_base;
-
 	hdr->type_of_loader = 0x21;
 
 	/* Convert unicode cmdline to ascii */
diff --git a/arch/x86/boot/compressed/head_32.S b/arch/x86/boot/compressed/head_32.S
index de9d4200d305..cbed1407a5cd 100644
--- a/arch/x86/boot/compressed/head_32.S
+++ b/arch/x86/boot/compressed/head_32.S
@@ -59,6 +59,7 @@ ENTRY(efi_pe_entry)
 	call	make_boot_params
 	cmpl	$0, %eax
 	je	fail
+	movl	%esi, BP_code32_start(%eax)
 	popl	%ecx
 	pushl	%eax
 	pushl	%ecx
@@ -90,12 +91,7 @@ fail:
 	hlt
 	jmp	fail
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
index 57e58a5fa210..0d558ee899ae 100644
--- a/arch/x86/boot/compressed/head_64.S
+++ b/arch/x86/boot/compressed/head_64.S
@@ -261,6 +261,8 @@ ENTRY(efi_pe_entry)
 	cmpq	$0,%rax
 	je	fail
 	mov	%rax, %rsi
+	leaq	startup_32(%rip), %rax
+	movl	%eax, BP_code32_start(%rsi)
 	jmp	2f		/* Skip the relocation */
 
 handover_entry:
@@ -284,12 +286,7 @@ fail:
 	hlt
 	jmp	fail
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
