Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755444AbaDGOuv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 10:50:51 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:38915 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754760AbaDGOut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 10:50:49 -0400
From: ling.ma.program@gmail.com
To: mingo@redhat.com
Cc: tglx@linutronix.de, hpa@zytor.com, neleai@seznam.cz,
        linux-kernel@vger.kernel.org, Ling Ma <ling.ml@alibaba-inc.com>
Subject: [PATCH RFC] x86:Improve memset with general 64bit instruction
Date: Mon,  7 Apr 2014 10:50:37 -0400
Message-Id: <1396882237-27608-1-git-send-email-ling.ma@alipay.com>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ling Ma <ling.ml@alibaba-inc.com>

In this patch we manage to reduce miss branch prediction by 
avoiding using branch instructions and force destination to be aligned
with general 64bit instruction. 
Below compared results shows we improve performance up to 1.8x
(We modified test suit from Ondra, send after this patch)

Bytes: ORG_TIME: NEW_TIME: ORG vs NEW:
7       0.51    0.48    1.06
16      0.55    0.38    1.44
18      0.61    0.44    1.38
21      0.62    0.47    1.31
25      0.64    0.45    1.42
30      0.65    0.45    1.44
36      0.66    0.44    1.50
38      0.67    0.46    1.45
62      0.70    0.44    1.59
75      0.71    0.44    1.61
85      0.73    0.46    1.58
120     0.78    0.44    1.77
193     0.81    0.46    1.76
245     0.84    0.52    1.61
256     0.83    0.45    1.84
356     0.86    0.55    1.56
601     0.98    0.65    1.50
958     1.14    0.81    1.40
1024    1.19    0.86    1.38
2048    1.69    1.34    1.26
Signed-off-by: Ling Ma <ling.ml@alibaba-inc.com>
---
 arch/x86/include/asm/alternative-asm.h |   4 +-
 arch/x86/lib/memset_64.S               | 172 +++++++++++++++++++++------------
 2 files changed, 110 insertions(+), 66 deletions(-)

diff --git a/arch/x86/include/asm/alternative-asm.h b/arch/x86/include/asm/alternative-asm.h
index 372231c..aaac545 100644
--- a/arch/x86/include/asm/alternative-asm.h
+++ b/arch/x86/include/asm/alternative-asm.h
@@ -22,8 +22,8 @@
 	.long \orig - .
 	.long \alt - .
 	.word \feature
-	.byte \orig_len
-	.byte \alt_len
+	.word \orig_len
+	.word \alt_len
 .endm
 
 #endif  /*  __ASSEMBLY__  */
diff --git a/arch/x86/lib/memset_64.S b/arch/x86/lib/memset_64.S
index 2dcb380..3eca27c 100644
--- a/arch/x86/lib/memset_64.S
+++ b/arch/x86/lib/memset_64.S
@@ -59,77 +59,121 @@
 ENTRY(memset)
 ENTRY(__memset)
 	CFI_STARTPROC
-	movq %rdi,%r10
-
-	/* expand byte value  */
 	movzbl %sil,%ecx
-	movabs $0x0101010101010101,%rax
-	imulq  %rcx,%rax
-
-	/* align dst */
-	movl  %edi,%r9d
-	andl  $7,%r9d
-	jnz  .Lbad_alignment
-	CFI_REMEMBER_STATE
-.Lafter_bad_alignment:
-
-	movq  %rdx,%rcx
-	shrq  $6,%rcx
-	jz	 .Lhandle_tail
-
+	mov $0x0101010101010101,%rsi
+	imulq  %rsi,%rcx
+	movq %rdi,%rax
+	lea	(%rdi, %rdx), %r8
+	cmp	$128, %rdx
+	ja	.Lmore128bytes
+	cmp	$64, %edx
+	jb	.Lless_64bytes
+	/*
+	 * Move data from 65 bytes to 128 bytes.
+	 */
+	mov %rcx, 0x00(%rdi)
+	mov %rcx, 0x08(%rdi)
+	mov %rcx, 0x10(%rdi)
+	mov %rcx, 0x18(%rdi)
+	mov %rcx, 0x20(%rdi)
+	mov %rcx, 0x28(%rdi)
+	mov %rcx, 0x30(%rdi)
+	mov %rcx, 0x38(%rdi)
+	mov %rcx, -0x40(%r8)
+	mov %rcx, -0x38(%r8)
+	mov %rcx, -0x30(%r8)
+	mov %rcx, -0x28(%r8)
+	mov %rcx, -0x20(%r8)
+	mov %rcx, -0x18(%r8)
+	mov %rcx, -0x10(%r8)
+	mov %rcx, -0x08(%r8)
+	ret
 	.p2align 4
-.Lloop_64:
-	decq  %rcx
-	movq  %rax,(%rdi)
-	movq  %rax,8(%rdi)
-	movq  %rax,16(%rdi)
-	movq  %rax,24(%rdi)
-	movq  %rax,32(%rdi)
-	movq  %rax,40(%rdi)
-	movq  %rax,48(%rdi)
-	movq  %rax,56(%rdi)
-	leaq  64(%rdi),%rdi
-	jnz    .Lloop_64
-
-	/* Handle tail in loops. The loops should be faster than hard
-	   to predict jump tables. */
+.Lless_64bytes:
+	cmp	$32, %edx
+	jb	.Lless_32bytes
+	/*
+	 * Move data from 33 bytes to 64 bytes.
+	 */
+	mov %rcx, 0x00(%rdi)
+	mov %rcx, 0x08(%rdi)
+	mov %rcx, 0x10(%rdi)
+	mov %rcx, 0x18(%rdi)
+	mov %rcx, -0x20(%r8)
+	mov %rcx, -0x18(%r8)
+	mov %rcx, -0x10(%r8)
+	mov %rcx, -0x08(%r8)
+	ret
 	.p2align 4
-.Lhandle_tail:
-	movl	%edx,%ecx
-	andl    $63&(~7),%ecx
-	jz 		.Lhandle_7
-	shrl	$3,%ecx
+.Lless_32bytes:
+	cmp	$16, %edx
+	jb	.Lless_16bytes
+	mov %rcx, 0x00(%rdi)
+	mov %rcx, 0x08(%rdi)
+	mov %rcx, -0x10(%r8)
+	mov %rcx, -0x08(%r8)
+	ret
 	.p2align 4
-.Lloop_8:
-	decl   %ecx
-	movq  %rax,(%rdi)
-	leaq  8(%rdi),%rdi
-	jnz    .Lloop_8
-
-.Lhandle_7:
-	andl	$7,%edx
-	jz      .Lende
+.Lless_16bytes:
+	cmp	$8, %edx
+	jb	.Lless_8bytes
+	mov %rcx, (%rdi)
+	mov %rcx, -0x08(%r8)
+	ret
 	.p2align 4
-.Lloop_1:
-	decl    %edx
-	movb 	%al,(%rdi)
-	leaq	1(%rdi),%rdi
-	jnz     .Lloop_1
-
-.Lende:
-	movq	%r10,%rax
+.Lless_8bytes:
+	cmp	$4, %edx
+	jb	.Lless_4bytes
+	mov %ecx, (%rdi)
+	mov %ecx, -0x04(%r8)
+	.p2align 4
+.Lless_4bytes:
+	cmp	$2, %edx
+	jb	.Lless_2bytes
+	mov	%cx, (%rdi)
+	mov	%cx, -0x02(%r8)
+	ret
+	.p2align 4
+.Lless_2bytes:
+	cmp	$1, %edx
+	jb	.Lless_1bytes
+	mov	%cl, (%rdi)
+.Lless_1bytes:
 	ret
 
-	CFI_RESTORE_STATE
-.Lbad_alignment:
-	cmpq $7,%rdx
-	jbe	.Lhandle_7
-	movq %rax,(%rdi)	/* unaligned store */
-	movq $8,%r8
-	subq %r9,%r8
-	addq %r8,%rdi
-	subq %r8,%rdx
-	jmp .Lafter_bad_alignment
+	.p2align 4
+.Lmore128bytes:
+	mov	%rcx, (%rdi)
+	mov	%rdi, %r9
+	and	$-0x08, %rdi
+	add	$0x08, %rdi
+	sub	%rdi, %r9
+	add	%r9, %rdx
+	sub	$0x40, %rdx
+.Lgobble_64_loop:
+	mov		%rcx, 0x00(%rdi)
+	mov		%rcx, 0x08(%rdi)
+	mov		%rcx, 0x10(%rdi)
+	mov		%rcx, 0x18(%rdi)
+	mov		%rcx, 0x20(%rdi)
+	mov		%rcx, 0x28(%rdi)
+	mov		%rcx, 0x30(%rdi)
+	mov		%rcx, 0x38(%rdi)
+	lea	0x40(%rdi), %rdi
+	sub	$0x40, %rdx
+	jae	.Lgobble_64_loop
+	/*
+	 * Move data from 0 bytes to 63 bytes.
+	 */
+	mov		%rcx, -0x40(%r8)
+	mov		%rcx, -0x38(%r8)
+	mov		%rcx, -0x30(%r8)
+	mov		%rcx, -0x28(%r8)
+	mov		%rcx, -0x20(%r8)
+	mov		%rcx, -0x18(%r8)
+	mov		%rcx, -0x10(%r8)
+	mov		%rcx, -0x08(%r8)
+	ret
 .Lfinal:
 	CFI_ENDPROC
 ENDPROC(memset)
-- 
1.8.1.4

