Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933601Ab3ICTeQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 15:34:16 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:33093 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932248Ab3ICTeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 15:34:13 -0400
Message-ID: <051168df528fe4456d63f5f65b041c147c26fe97.1378235373.git.cmetcalf@tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Tue, 3 Sep 2013 14:45:52 -0400
Subject: [PATCH 2/3] tile: don't assume user privilege is zero
To: Gleb Natapov <gleb@redhat.com>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Jan Kiszka <jan.kiszka@siemens.com>
In-Reply-To: <20130903173931.GO10142@redhat.com>
References: <52091682.8020004@siemens.com>
  <201308122037.r7CKbo99011833@farm-0021.internal.tilera.com>
  <20130825113953.GN8218@redhat.com>
  <521AAED7.4080407@tilera.com>
  <20130826120445.GD8218@redhat.com>
  <52261D26.7060206@tilera.com>
  <20130903173931.GO10142@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Technically, user privilege is anything less than kernel
privilege.  We modify the existing user_mode() macro to have
this semantic (and use it in a couple of places it wasn't being
used before), and add an IS_KERNEL_EX1() macro to the assembly
code as well.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/include/asm/processor.h |  4 ++--
 arch/tile/include/asm/ptrace.h    |  2 +-
 arch/tile/kernel/intvec_64.S      | 23 +++++++++++++++++------
 arch/tile/kernel/stack.c          |  2 +-
 arch/tile/mm/fault.c              |  4 ++--
 5 files changed, 23 insertions(+), 12 deletions(-)

diff --git a/arch/tile/include/asm/processor.h b/arch/tile/include/asm/processor.h
index 230b830..c72fcba 100644
--- a/arch/tile/include/asm/processor.h
+++ b/arch/tile/include/asm/processor.h
@@ -15,6 +15,8 @@
 #ifndef _ASM_TILE_PROCESSOR_H
 #define _ASM_TILE_PROCESSOR_H
 
+#include <arch/chip.h>
+
 #ifndef __ASSEMBLY__
 
 /*
@@ -25,7 +27,6 @@
 #include <asm/ptrace.h>
 #include <asm/percpu.h>
 
-#include <arch/chip.h>
 #include <arch/spr_def.h>
 
 struct task_struct;
@@ -347,7 +348,6 @@ extern int kdata_huge;
 
 /*
  * Provide symbolic constants for PLs.
- * Note that assembly code assumes that USER_PL is zero.
  */
 #define USER_PL 0
 #if CONFIG_KERNEL_PL == 2
diff --git a/arch/tile/include/asm/ptrace.h b/arch/tile/include/asm/ptrace.h
index 0d25c21..b9620c0 100644
--- a/arch/tile/include/asm/ptrace.h
+++ b/arch/tile/include/asm/ptrace.h
@@ -39,7 +39,7 @@ typedef unsigned long pt_reg_t;
 #define user_stack_pointer(regs) ((regs)->sp)
 
 /* Does the process account for user or for system time? */
-#define user_mode(regs) (EX1_PL((regs)->ex1) == USER_PL)
+#define user_mode(regs) (EX1_PL((regs)->ex1) < KERNEL_PL)
 
 /* Fill in a struct pt_regs with the current kernel registers. */
 struct pt_regs *get_pt_regs(struct pt_regs *);
diff --git a/arch/tile/kernel/intvec_64.S b/arch/tile/kernel/intvec_64.S
index 3b35bb4..f020f01 100644
--- a/arch/tile/kernel/intvec_64.S
+++ b/arch/tile/kernel/intvec_64.S
@@ -34,6 +34,16 @@
 
 #define PTREGS_OFFSET_SYSCALL PTREGS_OFFSET_REG(TREG_SYSCALL_NR)
 
+#if CONFIG_KERNEL_PL == 1 || CONFIG_KERNEL_PL == 2
+/*
+ * Set "result" non-zero if ex1 holds the PL of the kernel
+ * (with or without ICS being set).  Note this works only
+ * because we never find the PL at level 3.
+ */
+# define IS_KERNEL_EX1(result, ex1) andi result, ex1, CONFIG_KERNEL_PL
+#else
+# error Recode IS_KERNEL_EX1 for CONFIG_KERNEL_PL
+#endif
 
 	.macro  push_reg reg, ptr=sp, delta=-8
 	{
@@ -308,7 +318,7 @@ intvec_\vecname:
 	 */
 	{
 	 blbs   sp, 2f
-	 andi   r0, r0, SPR_EX_CONTEXT_1_1__PL_MASK  /* mask off ICS */
+	 IS_KERNEL_EX1(r0, r0)
 	}
 
 	.ifc    \vecnum, INT_DOUBLE_FAULT
@@ -641,11 +651,12 @@ intvec_\vecname:
 	/*
 	 * If we will be returning to the kernel, we will need to
 	 * reset the interrupt masks to the state they had before.
-	 * Set DISABLE_IRQ in flags iff we came from PL1 with irqs disabled.
+	 * Set DISABLE_IRQ in flags iff we came from kernel pl with
+	 * irqs disabled.
 	 */
 	mfspr   r32, SPR_EX_CONTEXT_K_1
 	{
-	 andi   r32, r32, SPR_EX_CONTEXT_1_1__PL_MASK  /* mask off ICS */
+	 IS_KERNEL_EX1(r22, r22)
 	 PTREGS_PTR(r21, PTREGS_OFFSET_FLAGS)
 	}
 	beqzt   r32, 1f       /* zero if from user space */
@@ -812,7 +823,7 @@ STD_ENTRY(interrupt_return)
 	 PTREGS_PTR(r29, PTREGS_OFFSET_EX1)
 	}
 	ld      r29, r29
-	andi    r29, r29, SPR_EX_CONTEXT_1_1__PL_MASK  /* mask off ICS */
+	IS_KERNEL_EX1(r29, r29)
 	{
 	 beqzt  r29, .Lresume_userspace
 	 move   r29, sp
@@ -936,7 +947,7 @@ STD_ENTRY(interrupt_return)
 	 PTREGS_PTR(r32, PTREGS_OFFSET_FLAGS)
 	}
 	{
-	 andi   r0, r0, SPR_EX_CONTEXT_1_1__PL_MASK
+	 IS_KERNEL_EX1(r0, r0)
 	 ld     r32, r32
 	}
 	bnez    r0, 1f
@@ -1007,7 +1018,7 @@ STD_ENTRY(interrupt_return)
 	pop_reg r21, sp, PTREGS_OFFSET_REG(31) - PTREGS_OFFSET_PC
 	{
 	 mtspr  SPR_EX_CONTEXT_K_1, lr
-	 andi   lr, lr, SPR_EX_CONTEXT_1_1__PL_MASK  /* mask off ICS */
+	 IS_KERNEL_EX1(lr, lr)
 	}
 	{
 	 mtspr  SPR_EX_CONTEXT_K_0, r21
diff --git a/arch/tile/kernel/stack.c b/arch/tile/kernel/stack.c
index 24fd223..362284a 100644
--- a/arch/tile/kernel/stack.c
+++ b/arch/tile/kernel/stack.c
@@ -103,7 +103,7 @@ static struct pt_regs *valid_fault_handler(struct KBacktraceIterator* kbt)
 	    p->sp >= sp) {
 		if (kbt->verbose)
 			pr_err("  <%s while in kernel mode>\n", fault);
-	} else if (EX1_PL(p->ex1) == USER_PL &&
+	} else if (user_mode(p) &&
 		   p->sp < PAGE_OFFSET && p->sp != 0) {
 		if (kbt->verbose)
 			pr_err("  <%s while in user mode>\n", fault);
diff --git a/arch/tile/mm/fault.c b/arch/tile/mm/fault.c
index 64eec3f..39c48cb 100644
--- a/arch/tile/mm/fault.c
+++ b/arch/tile/mm/fault.c
@@ -283,7 +283,7 @@ static int handle_page_fault(struct pt_regs *regs,
 	flags = (FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_KILLABLE |
 		 (write ? FAULT_FLAG_WRITE : 0));
 
-	is_kernel_mode = (EX1_PL(regs->ex1) != USER_PL);
+	is_kernel_mode = !user_mode(regs);
 
 	tsk = validate_current();
 
@@ -824,7 +824,7 @@ void do_page_fault(struct pt_regs *regs, int fault_num,
 	}
 
 #if CHIP_HAS_TILE_DMA() || CHIP_HAS_SN_PROC()
-	if (EX1_PL(regs->ex1) != USER_PL) {
+	if (!user_mode(regs)) {
 		struct async_tlb *async;
 		switch (fault_num) {
 #if CHIP_HAS_TILE_DMA()
-- 
1.8.3.1

