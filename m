Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752818AbaFIFqP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 01:46:15 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:46898 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796AbaFIFqE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 01:46:04 -0400
Date: Mon, 9 Jun 2014 13:45:56 +0800
From: Real Name <enjoymindful@gmail.com>
To: Richard Weinberger <richard@nod.at>
Cc: user-mode-linux-devel@lists.sourceforge.net,
        user-mode-linux-user@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, jdike@addtoit.com
Subject: Re: [PATCH] remove csum_partial_copy_generic_i386 to clean up
 exception table
Message-ID: <20140609054556.GA2465@name>
References: <538F275B.7000508@nod.at>
 <1401941724-6703-1-git-send-email-enjoymindful@gmail.com>
 <1401941724-6703-2-git-send-email-enjoymindful@gmail.com>
 <5390E5FD.5030400@nod.at>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="DocE+STaALJfprDB"
Content-Disposition: inline
In-Reply-To: <5390E5FD.5030400@nod.at>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--DocE+STaALJfprDB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jun 05, 2014 at 11:49:49PM +0200, Richard Weinberger wrote:
> Am 05.06.2014 06:15, schrieb Honggang Li:
> > arch/x86/um/checksum_32.S had been copy & paste from x86. When build
> > x86 uml, csum_partial_copy_generic_i386 mess up the exception table.
> > In fact, exception table dose not work in uml kernel.
> 
> Are you sure that exception tables do not work on UML?
> I said, I'm not sure. Can you please find out?

I think we can't test the exception table with linux-next uml kernel, because
the exception table is broken.

The *old* linux-2.4.xx uml kernel has a good exception table. 
1) install one redhat-9.0 virtual machine
2) build and booting into linux-2.4.25. You can't run uml kernel with default
redhat-9.0 kernel, because there is one bug.
3) build linux-2.4.20 uml kernel (with uml-patch-2.4.20-8)
4) run linux-2.4.20/linux ubda=/root/root_fs.rh-7.2-server.pristine.20020312 mem=64m
(The root_fs and uml-patch are available from the *old* uml website.)


The exception table records of the old kernel belong to csum_partial_copy_generic_i386 too.

# objjdump --full-contents --section=__ex_table arch/um/sys-i386/checksum.o          

arch/um/sys-i386/checksum.o:     file format elf32-i386

Contents of section __ex_table:
 0000 c7000000 00000000 cd000000 1b000000  ................
 0010 e4000000 00000000 e6000000 00000000  ................
 0020 eb000000 1b000000 ef000000 1b000000  ................
 0030 f2000000 00000000 f5000000 00000000  ................
 0040 fa000000 1b000000 ff000000 1b000000  ................
 0050 02010000 00000000 05010000 00000000  ................
 0060 0a010000 1b000000 0f010000 1b000000  ................
 0070 12010000 00000000 15010000 00000000  ................
 0080 1a010000 1b000000 1f010000 1b000000  ................
 0090 3c010000 00000000 40010000 1b000000  <.......@.......
 00a0 58010000 00000000 5e010000 1b000000  X.......^.......
 00b0 69010000 00000000 6b010000 1b000000  i.......k......

[root@rht9 linux-2.4.20]# objdump --full-contents --section=__ex_table arch/um/kern>

arch/um/kernel/checksum.o:     file format elf32-i386

[root@rht9 linux-2.4.20]# objdump --full-contents --section=__ex_table linux

linux:     file format elf32-i386

Contents of section __ex_table:
 a0203c20 5b680ea0 2cd31ba0 61680ea0 47d31ba0  [h..,...ah..G...
 a0203c30 78680ea0 2cd31ba0 7a680ea0 2cd31ba0  xh..,...zh..,...
 a0203c40 7f680ea0 47d31ba0 83680ea0 47d31ba0  .h..G....h..G...
 a0203c50 86680ea0 2cd31ba0 89680ea0 2cd31ba0  .h..,....h..,...
 a0203c60 8e680ea0 47d31ba0 93680ea0 47d31ba0  .h..G....h..G...
 a0203c70 96680ea0 2cd31ba0 99680ea0 2cd31ba0  .h..,....h..,...
 a0203c80 9e680ea0 47d31ba0 a3680ea0 47d31ba0  .h..G....h..G...
 a0203c90 a6680ea0 2cd31ba0 a9680ea0 2cd31ba0  .h..,....h..,...
 a0203ca0 ae680ea0 47d31ba0 b3680ea0 47d31ba0  .h..G....h..G...
 a0203cb0 d0680ea0 2cd31ba0 d4680ea0 47d31ba0  .h..,....h..G...
 a0203cc0 ec680ea0 2cd31ba0 f2680ea0 47d31ba0  .h..,....h..G...
 a0203cd0 fd680ea0 2cd31ba0 ff680ea0 47d31ba0  .h..,....h..G...

**************************************************************************

The exception table of linux-3.1x.y is broken. The complier tool chain create
bad exception table. I think this should be a bug.

linux-3.12.6]$ objdump --full-contents --section=__ex_table ./linux

./linux:     file format elf32-i386

Contents of section __ex_table:
 82a5048 3e6fdcff bcbaf6ff 396fdcff b4baf6ff  >o......9o......
 82a5058 336fdcff acbaf6ff 306fdcff bfbaf6ff  3o......0o......
 82a5068 2b6fdcff 9cbaf6ff 286fdcff afbaf6ff  +o......(o......
 82a5078 236fdcff 8cbaf6ff 206fdcff 9fbaf6ff  #o...... o......
 82a5088 1b6fdcff 7cbaf6ff 186fdcff 8fbaf6ff  .o..|....o......
 82a5098 136fdcff 6cbaf6ff 106fdcff 7fbaf6ff  .o..l....o......
 82a50a8 0b6fdcff 5cbaf6ff 086fdcff 6fbaf6ff  .o..\....o..o...
 82a50b8 036fdcff 4cbaf6ff 006fdcff 5fbaf6ff  .o..L....o.._...
 82a50c8 fb6edcff 3cbaf6ff f86edcff 4fbaf6ff  .n..<....n..O...
 82a50d8 f36edcff 2cbaf6ff f06edcff 3fbaf6ff  .n..,....n..?...
 82a50e8 eb6edcff 1cbaf6ff e86edcff 2fbaf6ff  .n.......n../...
 82a50f8 e36edcff 0cbaf6ff e06edcff 1fbaf6ff  .n.......n......
 82a5108 db6edcff fcb9f6ff d86edcff 0fbaf6ff  .n.......n......
 82a5118 d36edcff ecb9f6ff d06edcff ffb9f6ff  .n.......n......
 82a5128 cb6edcff dcb9f6ff c86edcff efb9f6ff  .n.......n......
 82a5138 c36edcff ccb9f6ff c06edcff dfb9f6ff  .n.......n......
 82a5148 bb6edcff bcb9f6ff b86edcff cfb9f6ff  .n.......n......
 82a5158 ce6edcff acb9f6ff cc6edcff bfb9f6ff  .n.......n......
 82a5168 cf6edcff 9cb9f6ff c96edcff afb9f6ff  .n.......n......

> 
> In arch/um/kernel/trap.c:segv() we have the mechanism for it:
>         else if (!is_user && arch_fixup(ip, regs))
>                 goto out;
>

The kcov analysis proof that this piece of code never been executed.
 
> The interesting question is, is this by design or was it just copy&pasted from x86
> many moons ago? :)

Hi, Jeff
 Could you please answer this question, as you are the author? thanks 

> 
> > And csum_partial_copy_generic_i386 never been called. So, delete it.
> 
> I like such clean ups. :-)

Could you please pick up the attached patch. I update the comment of the patch.

Thank you.
> 
> Thanks,
> //richard

--DocE+STaALJfprDB
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-uml-remove-csum_partial_copy_generic_i386.patch"

>From 1056e896c40c32c58ac670c02dae6295d09b9bea Mon Sep 17 00:00:00 2001
From: Honggang Li <enjoymindful@gmail.com>
Date: Thu, 5 Jun 2014 10:43:40 +0800
Subject: [PATCH] uml: remove csum_partial_copy_generic_i386

arch/x86/um/checksum_32.S had been copy & paste from x86. It has been
defined as a local function. Because this very old function never been
called, remove it to clean up arch/x86/um/checksum_32.S

Signed-off-by: Honggang Li <enjoymindful@gmail.com>
---
 arch/x86/um/checksum_32.S | 239 ----------------------------------------------
 1 file changed, 239 deletions(-)

diff --git a/arch/x86/um/checksum_32.S b/arch/x86/um/checksum_32.S
index 8d0c420..fa4b8b9 100644
--- a/arch/x86/um/checksum_32.S
+++ b/arch/x86/um/checksum_32.S
@@ -214,242 +214,3 @@ csum_partial:
 	ret
 				
 #endif
-
-/*
-unsigned int csum_partial_copy_generic (const char *src, char *dst,
-				  int len, int sum, int *src_err_ptr, int *dst_err_ptr)
- */ 
-
-/*
- * Copy from ds while checksumming, otherwise like csum_partial
- *
- * The macros SRC and DST specify the type of access for the instruction.
- * thus we can call a custom exception handler for all access types.
- *
- * FIXME: could someone double-check whether I haven't mixed up some SRC and
- *	  DST definitions? It's damn hard to trigger all cases.  I hope I got
- *	  them all but there's no guarantee.
- */
-
-#define SRC(y...)			\
-	9999: y;			\
-	_ASM_EXTABLE(9999b, 6001f)
-
-#define DST(y...)			\
-	9999: y;			\
-	_ASM_EXTABLE(9999b, 6002f)
-
-.align 4
-
-#ifndef CONFIG_X86_USE_PPRO_CHECKSUM
-
-#define ARGBASE 16		
-#define FP		12
-
-csum_partial_copy_generic_i386:
-	subl  $4,%esp	
-	pushl %edi
-	pushl %esi
-	pushl %ebx
-	movl ARGBASE+16(%esp),%eax	# sum
-	movl ARGBASE+12(%esp),%ecx	# len
-	movl ARGBASE+4(%esp),%esi	# src
-	movl ARGBASE+8(%esp),%edi	# dst
-
-	testl $2, %edi			# Check alignment. 
-	jz 2f				# Jump if alignment is ok.
-	subl $2, %ecx			# Alignment uses up two bytes.
-	jae 1f				# Jump if we had at least two bytes.
-	addl $2, %ecx			# ecx was < 2.  Deal with it.
-	jmp 4f
-SRC(1:	movw (%esi), %bx	)
-	addl $2, %esi
-DST(	movw %bx, (%edi)	)
-	addl $2, %edi
-	addw %bx, %ax	
-	adcl $0, %eax
-2:
-	movl %ecx, FP(%esp)
-	shrl $5, %ecx
-	jz 2f
-	testl %esi, %esi
-SRC(1:	movl (%esi), %ebx	)
-SRC(	movl 4(%esi), %edx	)
-	adcl %ebx, %eax
-DST(	movl %ebx, (%edi)	)
-	adcl %edx, %eax
-DST(	movl %edx, 4(%edi)	)
-
-SRC(	movl 8(%esi), %ebx	)
-SRC(	movl 12(%esi), %edx	)
-	adcl %ebx, %eax
-DST(	movl %ebx, 8(%edi)	)
-	adcl %edx, %eax
-DST(	movl %edx, 12(%edi)	)
-
-SRC(	movl 16(%esi), %ebx 	)
-SRC(	movl 20(%esi), %edx	)
-	adcl %ebx, %eax
-DST(	movl %ebx, 16(%edi)	)
-	adcl %edx, %eax
-DST(	movl %edx, 20(%edi)	)
-
-SRC(	movl 24(%esi), %ebx	)
-SRC(	movl 28(%esi), %edx	)
-	adcl %ebx, %eax
-DST(	movl %ebx, 24(%edi)	)
-	adcl %edx, %eax
-DST(	movl %edx, 28(%edi)	)
-
-	lea 32(%esi), %esi
-	lea 32(%edi), %edi
-	dec %ecx
-	jne 1b
-	adcl $0, %eax
-2:	movl FP(%esp), %edx
-	movl %edx, %ecx
-	andl $0x1c, %edx
-	je 4f
-	shrl $2, %edx			# This clears CF
-SRC(3:	movl (%esi), %ebx	)
-	adcl %ebx, %eax
-DST(	movl %ebx, (%edi)	)
-	lea 4(%esi), %esi
-	lea 4(%edi), %edi
-	dec %edx
-	jne 3b
-	adcl $0, %eax
-4:	andl $3, %ecx
-	jz 7f
-	cmpl $2, %ecx
-	jb 5f
-SRC(	movw (%esi), %cx	)
-	leal 2(%esi), %esi
-DST(	movw %cx, (%edi)	)
-	leal 2(%edi), %edi
-	je 6f
-	shll $16,%ecx
-SRC(5:	movb (%esi), %cl	)
-DST(	movb %cl, (%edi)	)
-6:	addl %ecx, %eax
-	adcl $0, %eax
-7:
-5000:
-
-# Exception handler:
-.section .fixup, "ax"							
-
-6001:
-	movl ARGBASE+20(%esp), %ebx	# src_err_ptr
-	movl $-EFAULT, (%ebx)
-
-	# zero the complete destination - computing the rest
-	# is too much work 
-	movl ARGBASE+8(%esp), %edi	# dst
-	movl ARGBASE+12(%esp), %ecx	# len
-	xorl %eax,%eax
-	rep ; stosb
-
-	jmp 5000b
-
-6002:
-	movl ARGBASE+24(%esp), %ebx	# dst_err_ptr
-	movl $-EFAULT,(%ebx)
-	jmp 5000b
-
-.previous
-
-	popl %ebx
-	popl %esi
-	popl %edi
-	popl %ecx			# equivalent to addl $4,%esp
-	ret	
-
-#else
-
-/* Version for PentiumII/PPro */
-
-#define ROUND1(x) \
-	SRC(movl x(%esi), %ebx	)	;	\
-	addl %ebx, %eax			;	\
-	DST(movl %ebx, x(%edi)	)	; 
-
-#define ROUND(x) \
-	SRC(movl x(%esi), %ebx	)	;	\
-	adcl %ebx, %eax			;	\
-	DST(movl %ebx, x(%edi)	)	;
-
-#define ARGBASE 12
-		
-csum_partial_copy_generic_i386:
-	pushl %ebx
-	pushl %edi
-	pushl %esi
-	movl ARGBASE+4(%esp),%esi	#src
-	movl ARGBASE+8(%esp),%edi	#dst	
-	movl ARGBASE+12(%esp),%ecx	#len
-	movl ARGBASE+16(%esp),%eax	#sum
-#	movl %ecx, %edx  
-	movl %ecx, %ebx  
-	movl %esi, %edx
-	shrl $6, %ecx     
-	andl $0x3c, %ebx  
-	negl %ebx
-	subl %ebx, %esi  
-	subl %ebx, %edi  
-	lea  -1(%esi),%edx
-	andl $-32,%edx
-	lea 3f(%ebx,%ebx), %ebx
-	testl %esi, %esi 
-	jmp *%ebx
-1:	addl $64,%esi
-	addl $64,%edi 
-	SRC(movb -32(%edx),%bl)	; SRC(movb (%edx),%bl)
-	ROUND1(-64) ROUND(-60) ROUND(-56) ROUND(-52)	
-	ROUND (-48) ROUND(-44) ROUND(-40) ROUND(-36)	
-	ROUND (-32) ROUND(-28) ROUND(-24) ROUND(-20)	
-	ROUND (-16) ROUND(-12) ROUND(-8)  ROUND(-4)	
-3:	adcl $0,%eax
-	addl $64, %edx
-	dec %ecx
-	jge 1b
-4:	movl ARGBASE+12(%esp),%edx	#len
-	andl $3, %edx
-	jz 7f
-	cmpl $2, %edx
-	jb 5f
-SRC(	movw (%esi), %dx         )
-	leal 2(%esi), %esi
-DST(	movw %dx, (%edi)         )
-	leal 2(%edi), %edi
-	je 6f
-	shll $16,%edx
-5:
-SRC(	movb (%esi), %dl         )
-DST(	movb %dl, (%edi)         )
-6:	addl %edx, %eax
-	adcl $0, %eax
-7:
-.section .fixup, "ax"
-6001:	movl	ARGBASE+20(%esp), %ebx	# src_err_ptr	
-	movl $-EFAULT, (%ebx)
-	# zero the complete destination (computing the rest is too much work)
-	movl ARGBASE+8(%esp),%edi	# dst
-	movl ARGBASE+12(%esp),%ecx	# len
-	xorl %eax,%eax
-	rep; stosb
-	jmp 7b
-6002:	movl ARGBASE+24(%esp), %ebx	# dst_err_ptr
-	movl $-EFAULT, (%ebx)
-	jmp  7b			
-.previous				
-
-	popl %esi
-	popl %edi
-	popl %ebx
-	ret
-				
-#undef ROUND
-#undef ROUND1		
-		
-#endif
-- 
1.8.3.1


--DocE+STaALJfprDB--
