Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754239AbaGOAMK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 20:12:10 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:54279 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753916AbaGOAMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 20:12:08 -0400
Date: Mon, 14 Jul 2014 20:12:04 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>, linuxppc-dev@lists.ozlabs.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Anton Blanchard <anton@samba.org>, Olof Johansson <olof@lixom.net>
Subject: [PATCH] powerpc: Revert removing of _INIT_GLOBAL(), _STATIC() and
 _INIT_STATIC()
Message-ID: <20140714201204.7b6fcd8e@gandalf.local.home>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I wanted to test some new ftrace code on my PASemi electra powerpc box.
But unfortunately it failed to build. It failed with this:

  LD      init/built-in.o
arch/powerpc/kernel/head_64.o:arch/powerpc/kernel/exceptions-64s.S:874:
  relocation truncated to fit: R_PPC64_REL14 against `.text'+1c90
Makefile:864: recipe for target 'vmlinux' failed


Bisecting it lead me down to this commit:

commit 6a3bab90cf78bc579638525cb76ac240f8253803
Author: Anton Blanchard <anton@samba.org>
Date:   Tue Feb 4 16:06:11 2014 +1100

    powerpc: Remove some unnecessary uses of _GLOBAL() and _STATIC()
    
    There is no need to create a function descriptor for functions
    called locally out of assembly.


And by reverting this and:

commit a0e971ffb9d9dae3b9892fb548bd2497db758f60
Author: Anton Blanchard <anton@samba.org>
Date:   Tue Feb 4 16:06:25 2014 +1100

    powerpc: Remove _INIT_GLOBAL(), _STATIC() and _INIT_STATIC()
    
    Now there are no users of _INIT_GLOBAL(), _STATIC() and
    _INIT_STATIC() we can remove them.

My box builds and boots again.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
diff --git a/arch/powerpc/include/asm/ppc_asm.h b/arch/powerpc/include/asm/ppc_asm.h
index 9ea266e..1baf197 100644
--- a/arch/powerpc/include/asm/ppc_asm.h
+++ b/arch/powerpc/include/asm/ppc_asm.h
@@ -217,6 +217,20 @@ name: \
 	addi r2,r2,(.TOC.-0b)@l; \
 	.localentry name,.-name
 
+#define _INIT_GLOBAL(name) \
+	__REF; \
+	.align 2 ; \
+	.globl name; \
+	.globl GLUE(.,name); \
+	.section ".opd","aw"; \
+name: \
+	.quad GLUE(.,name); \
+	.quad .TOC.@tocbase; \
+	.quad 0; \
+	.previous; \
+	.type GLUE(.,name),@function; \
+GLUE(.,name):
+
 #define _KPROBE(name) \
 	.section ".kprobes.text","a"; \
 	.align 2 ; \
@@ -265,6 +279,30 @@ GLUE(.,name):
 
 #endif
 
+#define _STATIC(name) \
+	.section ".text"; \
+	.align 2 ; \
+	.section ".opd","aw"; \
+name: \
+	.quad GLUE(.,name); \
+	.quad .TOC.@tocbase; \
+	.quad 0; \
+	.previous; \
+	.type GLUE(.,name),@function; \
+GLUE(.,name):
+
+#define _INIT_STATIC(name) \
+	__REF; \
+	.align 2 ; \
+	.section ".opd","aw"; \
+name: \
+	.quad GLUE(.,name); \
+	.quad .TOC.@tocbase; \
+	.quad 0; \
+	.previous; \
+	.type GLUE(.,name),@function; \
+GLUE(.,name):
+
 #else /* 32-bit */
 
 #define _ENTRY(n)	\
diff --git a/arch/powerpc/kernel/exceptions-64e.S b/arch/powerpc/kernel/exceptions-64e.S
index bb9cac6..ce0c55d 100644
--- a/arch/powerpc/kernel/exceptions-64e.S
+++ b/arch/powerpc/kernel/exceptions-64e.S
@@ -1580,14 +1580,14 @@ _GLOBAL(book3e_secondary_thread_init)
 	mflr	r28
 	b	3b
 
-init_core_book3e:
+_STATIC(init_core_book3e)
 	/* Establish the interrupt vector base */
 	LOAD_REG_IMMEDIATE(r3, interrupt_base_book3e)
 	mtspr	SPRN_IVPR,r3
 	sync
 	blr
 
-init_thread_book3e:
+_STATIC(init_thread_book3e)
 	lis	r3,(SPRN_EPCR_ICM | SPRN_EPCR_GICM)@h
 	mtspr	SPRN_EPCR,r3
 
diff --git a/arch/powerpc/kernel/exceptions-64s.S b/arch/powerpc/kernel/exceptions-64s.S
index a7d36b1..220c5a9 100644
--- a/arch/powerpc/kernel/exceptions-64s.S
+++ b/arch/powerpc/kernel/exceptions-64s.S
@@ -1586,7 +1586,7 @@ power4_fixup_nap:
  * Hash table stuff
  */
 	.align	7
-do_hash_page:
+_STATIC(do_hash_page)
 	std	r3,_DAR(r1)
 	std	r4,_DSISR(r1)
 
diff --git a/arch/powerpc/kernel/head_64.S b/arch/powerpc/kernel/head_64.S
index a95145d..b8986af 100644
--- a/arch/powerpc/kernel/head_64.S
+++ b/arch/powerpc/kernel/head_64.S
@@ -299,7 +299,7 @@ generic_secondary_common_init:
  * Assumes we're mapped EA == RA if the MMU is on.
  */
 #ifdef CONFIG_PPC_BOOK3S
-__mmu_off:
+_STATIC(__mmu_off)
 	mfmsr	r3
 	andi.	r0,r3,MSR_IR|MSR_DR
 	beqlr
@@ -324,7 +324,7 @@ __mmu_off:
  *                 DT block, r4 is a physical pointer to the kernel itself
  *
  */
-__start_initialization_multiplatform:
+_GLOBAL(__start_initialization_multiplatform)
 	/* Make sure we are running in 64 bits mode */
 	bl	enable_64b_mode
 
@@ -376,7 +376,7 @@ __start_initialization_multiplatform:
 	b	__after_prom_start
 #endif /* CONFIG_PPC_BOOK3E */
 
-__boot_from_prom:
+_INIT_STATIC(__boot_from_prom)
 #ifdef CONFIG_PPC_OF_BOOT_TRAMPOLINE
 	/* Save parameters */
 	mr	r31,r3
@@ -414,7 +414,7 @@ __boot_from_prom:
 	 * from OF while CONFIG_PPC_OF_BOOT_TRAMPOLINE isn't selected */
 	trap
 
-__after_prom_start:
+_STATIC(__after_prom_start)
 #ifdef CONFIG_RELOCATABLE
 	/* process relocations for the final address of the kernel */
 	lis	r25,PAGE_OFFSET@highest	/* compute virtual base of kernel */
@@ -674,7 +674,7 @@ _GLOBAL(start_secondary_resume)
 /*
  * This subroutine clobbers r11 and r12
  */
-enable_64b_mode:
+_GLOBAL(enable_64b_mode)
 	mfmsr	r11			/* grab the current MSR */
 #ifdef CONFIG_PPC_BOOK3E
 	oris	r11,r11,0x8000		/* CM bit set, we'll set ICM later */
@@ -715,7 +715,7 @@ p_toc:	.llong	__toc_start + 0x8000 - 0b
 /*
  * This is where the main kernel code starts.
  */
-start_here_multiplatform:
+_INIT_STATIC(start_here_multiplatform)
 	/* set up the TOC */
 	bl      relative_toc
 	tovirt(r2,r2)
