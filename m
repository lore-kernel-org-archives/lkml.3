Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751384AbaFEEPi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 00:15:38 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:61287 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326AbaFEEPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 00:15:36 -0400
From: Honggang Li <enjoymindful@gmail.com>
To: user-mode-linux-devel@lists.sourceforge.net,
        user-mode-linux-user@lists.sourceforge.net
Cc: richard@nod.at, linux-kernel@vger.kernel.org,
        Honggang Li <enjoymindful@gmail.com>
Subject: [PATCH] remove csum_partial_copy_generic_i386 to clean up exception table
Date: Thu,  5 Jun 2014 12:15:24 +0800
Message-Id: <1401941724-6703-2-git-send-email-enjoymindful@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1401941724-6703-1-git-send-email-enjoymindful@gmail.com>
References: <538F275B.7000508@nod.at>
 <1401941724-6703-1-git-send-email-enjoymindful@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/x86/um/checksum_32.S had been copy & paste from x86. When build
x86 uml, csum_partial_copy_generic_i386 mess up the exception table.
In fact, exception table dose not work in uml kernel.

And csum_partial_copy_generic_i386 never been called. So, delete it.

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

