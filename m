Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754502Ab3HPOfF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 10:35:05 -0400
Received: from relay3.sgi.com ([192.48.152.1]:34187 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752823Ab3HPOee (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 10:34:34 -0400
From: Alex Thorlton <athorlton@sgi.com>
To: linux-kernel@vger.kernel.org
Cc: Alex Thorlton <athorlton@sgi.com>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Dave Jones <davej@redhat.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Al Viro <viro@zeniv.linux.org.uk>, Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Kees Cook <keescook@chromium.org>, Robin Holt <holt@sgi.com>
Subject: [PATCH 6/8] x86: switch the 64bit uncached page clear to SSE/AVX v2
Date: Fri, 16 Aug 2013 09:34:02 -0500
Message-Id: <1376663644-153546-7-git-send-email-athorlton@sgi.com>
X-Mailer: git-send-email 1.7.12.4
In-Reply-To: <1376663644-153546-1-git-send-email-athorlton@sgi.com>
References: <87wqo050fc.fsf@tassilo.jf.intel.com>
 <1376663644-153546-1-git-send-email-athorlton@sgi.com>
In-Reply-To: <87wqo050fc.fsf@tassilo.jf.intel.com>
References: <87wqo050fc.fsf@tassilo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 arch/x86/lib/clear_page_nocache_64.S | 91 ++++++++++++++++++++++++++++++------
 1 file changed, 77 insertions(+), 14 deletions(-)

diff --git a/arch/x86/lib/clear_page_nocache_64.S b/arch/x86/lib/clear_page_nocache_64.S
index ee16d15..a6d938c 100644
--- a/arch/x86/lib/clear_page_nocache_64.S
+++ b/arch/x86/lib/clear_page_nocache_64.S
@@ -1,29 +1,92 @@
+/*
+ * Clear pages with cache bypass.
+ *
+ * Copyright (C) 2011, 2012 Intel Corporation
+ * Author: Andi Kleen
+ *
+ * This software may be redistributed and/or modified under the terms of
+ * the GNU General Public License ("GPL") version 2 only as published by the
+ * Free Software Foundation.
+ */
+
 #include <linux/linkage.h>
+#include <asm/alternative-asm.h>
+#include <asm/cpufeature.h>
 #include <asm/dwarf2.h>
 
+#define SSE_UNROLL 128
+
 /*
  * Zero a page avoiding the caches
  * rdi	page
  */
 ENTRY(clear_page_nocache)
 	CFI_STARTPROC
-	xorl   %eax,%eax
-	movl   $4096/64,%ecx
+	push   %rdi
+	call   kernel_fpu_begin
+	pop    %rdi
+	sub    $16,%rsp
+	CFI_ADJUST_CFA_OFFSET 16
+	movdqu %xmm0,(%rsp)
+	xorpd  %xmm0,%xmm0
+	movl   $4096/SSE_UNROLL,%ecx
 	.p2align 4
 .Lloop:
 	decl	%ecx
-#define PUT(x) movnti %rax,x*8(%rdi)
-	movnti %rax,(%rdi)
-	PUT(1)
-	PUT(2)
-	PUT(3)
-	PUT(4)
-	PUT(5)
-	PUT(6)
-	PUT(7)
-	leaq	64(%rdi),%rdi
+	.set x,0
+	.rept SSE_UNROLL/16
+	movntdq %xmm0,x(%rdi)
+	.set x,x+16
+	.endr
+	leaq	SSE_UNROLL(%rdi),%rdi
 	jnz	.Lloop
-	nop
-	ret
+	movdqu (%rsp),%xmm0
+	addq   $16,%rsp
+	CFI_ADJUST_CFA_OFFSET -16
+	jmp   kernel_fpu_end
 	CFI_ENDPROC
 ENDPROC(clear_page_nocache)
+
+#ifdef CONFIG_AS_AVX
+
+	.section .altinstr_replacement,"ax"
+1:	.byte 0xeb					/* jmp <disp8> */
+	.byte (clear_page_nocache_avx - clear_page_nocache) - (2f - 1b)
+	/* offset */
+2:
+	.previous
+	.section .altinstructions,"a"
+	altinstruction_entry clear_page_nocache,1b,X86_FEATURE_AVX,\
+	                     16, 2b-1b
+	.previous
+
+#define AVX_UNROLL 256 /* TUNE ME */
+
+ENTRY(clear_page_nocache_avx)
+	CFI_STARTPROC
+	push   %rdi
+	call   kernel_fpu_begin
+	pop    %rdi
+	sub    $32,%rsp
+	CFI_ADJUST_CFA_OFFSET 32
+	vmovdqu %ymm0,(%rsp)
+	vxorpd  %ymm0,%ymm0,%ymm0
+	movl   $4096/AVX_UNROLL,%ecx
+	.p2align 4
+.Lloop_avx:
+	decl	%ecx
+	.set x,0
+	.rept AVX_UNROLL/32
+	vmovntdq %ymm0,x(%rdi)
+	.set x,x+32
+	.endr
+	leaq	AVX_UNROLL(%rdi),%rdi
+	jnz	.Lloop_avx
+	vmovdqu (%rsp),%ymm0
+	addq   $32,%rsp
+	CFI_ADJUST_CFA_OFFSET -32
+	jmp   kernel_fpu_end
+	CFI_ENDPROC
+ENDPROC(clear_page_nocache_avx)
+
+#endif
-- 
1.7.12.4

