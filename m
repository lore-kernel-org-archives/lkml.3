Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753546Ab3GIIGB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 04:06:01 -0400
Received: from mail1.windriver.com ([147.11.146.13]:42896 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753582Ab3GIICr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 04:02:47 -0400
From: Tiejun Chen <tiejun.chen@windriver.com>
To: <benh@kernel.crashing.org>
CC: <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>
Subject: [v3][PATCH 2/8] powerpc/book3e: support CONFIG_RELOCATABLE
Date: Tue, 9 Jul 2013 16:03:21 +0800
Message-ID: <1373357007-30785-3-git-send-email-tiejun.chen@windriver.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1373357007-30785-1-git-send-email-tiejun.chen@windriver.com>
References: <1373357007-30785-1-git-send-email-tiejun.chen@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

book3e is different with book3s since 3s includes the exception
vectors code in head_64.S as it relies on absolute addressing
which is only possible within this compilation unit. So we have
to get that label address with got.

And when boot a relocated kernel, we should reset ipvr properly again
after .relocate.

Signed-off-by: Tiejun Chen <tiejun.chen@windriver.com>
---
 arch/powerpc/include/asm/exception-64e.h |   11 +++++++++++
 arch/powerpc/kernel/exceptions-64e.S     |   18 +++++++++++++++++-
 arch/powerpc/kernel/head_64.S            |   25 +++++++++++++++++++++++++
 3 files changed, 53 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/include/asm/exception-64e.h b/arch/powerpc/include/asm/exception-64e.h
index 51fa43e..371a77f 100644
--- a/arch/powerpc/include/asm/exception-64e.h
+++ b/arch/powerpc/include/asm/exception-64e.h
@@ -214,10 +214,21 @@ exc_##label##_book3e:
 #define TLB_MISS_STATS_SAVE_INFO_BOLTED
 #endif
 
+#ifndef CONFIG_RELOCATABLE
 #define SET_IVOR(vector_number, vector_offset)	\
 	li	r3,vector_offset@l; 		\
 	ori	r3,r3,interrupt_base_book3e@l;	\
 	mtspr	SPRN_IVOR##vector_number,r3;
+#else /* !CONFIG_RELOCATABLE */
+/* In relocatable case the value of the constant expression 'expr' is only
+ * offset. So instead, we should loads the address of label 'name'.
+ */
+#define SET_IVOR(vector_number, vector_offset)	\
+	LOAD_REG_ADDR(r3,interrupt_base_book3e);\
+	rlwinm	r3,r3,0,15,0;			\
+	ori	r3,r3,vector_offset@l;		\
+	mtspr	SPRN_IVOR##vector_number,r3;
+#endif /* CONFIG_RELOCATABLE */
 
 #endif /* _ASM_POWERPC_EXCEPTION_64E_H */
 
diff --git a/arch/powerpc/kernel/exceptions-64e.S b/arch/powerpc/kernel/exceptions-64e.S
index a518e48..be3b4b1 100644
--- a/arch/powerpc/kernel/exceptions-64e.S
+++ b/arch/powerpc/kernel/exceptions-64e.S
@@ -1097,7 +1097,15 @@ skpinv:	addi	r6,r6,1				/* Increment */
  * r4 = MAS0 w/TLBSEL & ESEL for the temp mapping
  */
 	/* Now we branch the new virtual address mapped by this entry */
+#ifdef CONFIG_RELOCATABLE
+	/* We have to find out address from lr. */
+	bl	1f		/* Find our address */
+1:	mflr	r6
+	addi	r6,r6,(2f - 1b)
+	tovirt(r6,r6)
+#else
 	LOAD_REG_IMMEDIATE(r6,2f)
+#endif
 	lis	r7,MSR_KERNEL@h
 	ori	r7,r7,MSR_KERNEL@l
 	mtspr	SPRN_SRR0,r6
@@ -1348,9 +1356,17 @@ _GLOBAL(book3e_secondary_thread_init)
 	mflr	r28
 	b	3b
 
-_STATIC(init_core_book3e)
+_GLOBAL(init_core_book3e)
 	/* Establish the interrupt vector base */
+#ifdef CONFIG_RELOCATABLE
+/* In relocatable case the value of the constant expression 'expr' is only
+ * offset. So instead, we should loads the address of label 'name'.
+ */
+	tovirt(r2,r2)
+	LOAD_REG_ADDR(r3, interrupt_base_book3e)
+#else
 	LOAD_REG_IMMEDIATE(r3, interrupt_base_book3e)
+#endif
 	mtspr	SPRN_IVPR,r3
 	sync
 	blr
diff --git a/arch/powerpc/kernel/head_64.S b/arch/powerpc/kernel/head_64.S
index b61363d..550f8fb 100644
--- a/arch/powerpc/kernel/head_64.S
+++ b/arch/powerpc/kernel/head_64.S
@@ -414,12 +414,25 @@ _STATIC(__after_prom_start)
 	/* process relocations for the final address of the kernel */
 	lis	r25,PAGE_OFFSET@highest	/* compute virtual base of kernel */
 	sldi	r25,r25,32
+#if defined(CONFIG_PPC_BOOK3E)
+	tovirt(r26,r26)			/* on booke, we already run at PAGE_OFFSET */
+#endif
 	lwz	r7,__run_at_load-_stext(r26)
+#if defined(CONFIG_PPC_BOOK3E)
+	tophys(r26,r26)			/* Restore for the remains. */
+#endif
 	cmplwi	cr0,r7,1	/* flagged to stay where we are ? */
 	bne	1f
 	add	r25,r25,r26
 1:	mr	r3,r25
 	bl	.relocate
+#if defined(CONFIG_PPC_BOOK3E)
+	/* In relocatable case we always have to load the address of label 'name'
+	 * to set IVPR. So after .relocate we have to update IVPR with current
+	 * address of label.
+	 */
+	bl	.init_core_book3e
+#endif
 #endif
 
 /*
@@ -447,12 +460,24 @@ _STATIC(__after_prom_start)
  * variable __run_at_load, if it is set the kernel is treated as relocatable
  * kernel, otherwise it will be moved to PHYSICAL_START
  */
+#if defined(CONFIG_PPC_BOOK3E)
+	tovirt(r26,r26)			/* on booke, we already run at PAGE_OFFSET */
+#endif
 	lwz	r7,__run_at_load-_stext(r26)
+#if defined(CONFIG_PPC_BOOK3E)
+	tophys(r26,r26)			/* Restore for the remains. */
+#endif
 	cmplwi	cr0,r7,1
 	bne	3f
 
+#ifdef CONFIG_PPC_BOOK3E
+	LOAD_REG_ADDR(r5, __end_interrupts)
+	LOAD_REG_ADDR(r11, _stext)
+	sub	r5,r5,r11
+#else
 	/* just copy interrupts */
 	LOAD_REG_IMMEDIATE(r5, __end_interrupts - _stext)
+#endif
 	b	5f
 3:
 #endif
-- 
1.7.9.5

