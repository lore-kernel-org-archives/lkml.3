Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754047Ab3GPI4o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 04:56:44 -0400
Received: from cpsmtpb-ews10.kpnxchange.com ([213.75.39.15]:65341 "EHLO
	cpsmtpb-ews10.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753496Ab3GPI4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 04:56:41 -0400
Message-ID: <1373964998.2591.57.camel@x61.thuisdomein>
Subject: [PATCH] powerpc/8xx: Remove last traces of 8XX_MINIMAL_FPEMU
From: Paul Bolle <pebolle@tiscali.nl>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Date: Tue, 16 Jul 2013 10:56:38 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Jul 2013 08:56:38.0310 (UTC) FILETIME=[61D33460:01CE8202]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Kconfig symbol 8XX_MINIMAL_FPEMU was removed in commit 968219fa33
("powerpc/8xx: Remove 8xx specific "minimal FPU emulation""). But that
commit didn't remove all code depending on that symbol. Do so now.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Not even compile tested!

 arch/powerpc/include/asm/emulated_ops.h |   2 -
 arch/powerpc/kernel/Makefile            |   2 -
 arch/powerpc/kernel/softemu8xx.c        | 199 --------------------------------
 3 files changed, 203 deletions(-)
 delete mode 100644 arch/powerpc/kernel/softemu8xx.c

diff --git a/arch/powerpc/include/asm/emulated_ops.h b/arch/powerpc/include/asm/emulated_ops.h
index 63f2a22..5a8b82a 100644
--- a/arch/powerpc/include/asm/emulated_ops.h
+++ b/arch/powerpc/include/asm/emulated_ops.h
@@ -46,8 +46,6 @@ extern struct ppc_emulated {
 	struct ppc_emulated_entry unaligned;
 #ifdef CONFIG_MATH_EMULATION
 	struct ppc_emulated_entry math;
-#elif defined(CONFIG_8XX_MINIMAL_FPEMU)
-	struct ppc_emulated_entry 8xx;
 #endif
 #ifdef CONFIG_VSX
 	struct ppc_emulated_entry vsx;
diff --git a/arch/powerpc/kernel/Makefile b/arch/powerpc/kernel/Makefile
index a8619bf..d706e58 100644
--- a/arch/powerpc/kernel/Makefile
+++ b/arch/powerpc/kernel/Makefile
@@ -117,8 +117,6 @@ obj-$(CONFIG_DYNAMIC_FTRACE)	+= ftrace.o
 obj-$(CONFIG_FUNCTION_GRAPH_TRACER)	+= ftrace.o
 obj-$(CONFIG_FTRACE_SYSCALLS)	+= ftrace.o
 
-obj-$(CONFIG_8XX_MINIMAL_FPEMU) += softemu8xx.o
-
 ifneq ($(CONFIG_PPC_INDIRECT_IO),y)
 obj-y				+= iomap.o
 endif
diff --git a/arch/powerpc/kernel/softemu8xx.c b/arch/powerpc/kernel/softemu8xx.c
deleted file mode 100644
index 29b2f81..0000000
--- a/arch/powerpc/kernel/softemu8xx.c
+++ /dev/null
@@ -1,199 +0,0 @@
-/*
- * Software emulation of some PPC instructions for the 8xx core.
- *
- * Copyright (C) 1998 Dan Malek (dmalek@jlc.net)
- *
- * Software floating emuation for the MPC8xx processor.  I did this mostly
- * because it was easier than trying to get the libraries compiled for
- * software floating point.  The goal is still to get the libraries done,
- * but I lost patience and needed some hacks to at least get init and
- * shells running.  The first problem is the setjmp/longjmp that save
- * and restore the floating point registers.
- *
- * For this emulation, our working registers are found on the register
- * save area.
- */
-
-#include <linux/errno.h>
-#include <linux/sched.h>
-#include <linux/kernel.h>
-#include <linux/mm.h>
-#include <linux/stddef.h>
-#include <linux/unistd.h>
-#include <linux/ptrace.h>
-#include <linux/user.h>
-#include <linux/interrupt.h>
-
-#include <asm/pgtable.h>
-#include <asm/uaccess.h>
-#include <asm/io.h>
-
-/* Eventually we may need a look-up table, but this works for now.
-*/
-#define LFS	48
-#define LFD	50
-#define LFDU	51
-#define STFD	54
-#define STFDU	55
-#define FMR	63
-
-void print_8xx_pte(struct mm_struct *mm, unsigned long addr)
-{
-	pgd_t *pgd;
-	pmd_t *pmd;
-	pte_t *pte;
-
-	printk(" pte @ 0x%8lx: ", addr);
-	pgd = pgd_offset(mm, addr & PAGE_MASK);
-	if (pgd) {
-		pmd = pmd_offset(pud_offset(pgd, addr & PAGE_MASK),
-		                 addr & PAGE_MASK);
-		if (pmd && pmd_present(*pmd)) {
-			pte = pte_offset_kernel(pmd, addr & PAGE_MASK);
-			if (pte) {
-				printk(" (0x%08lx)->(0x%08lx)->0x%08lx\n",
-				        (long)pgd, (long)pte, (long)pte_val(*pte));
-#define pp ((long)pte_val(*pte))
-				printk(" RPN: %05lx PP: %lx SPS: %lx SH: %lx "
-				       "CI: %lx v: %lx\n",
-				       pp>>12,    /* rpn */
-				       (pp>>10)&3, /* pp */
-				       (pp>>3)&1, /* small */
-				       (pp>>2)&1, /* shared */
-				       (pp>>1)&1, /* cache inhibit */
-				       pp&1       /* valid */
-				       );
-#undef pp
-			}
-			else {
-				printk("no pte\n");
-			}
-		}
-		else {
-			printk("no pmd\n");
-		}
-	}
-	else {
-		printk("no pgd\n");
-	}
-}
-
-int get_8xx_pte(struct mm_struct *mm, unsigned long addr)
-{
-	pgd_t *pgd;
-	pmd_t *pmd;
-	pte_t *pte;
-	int retval = 0;
-
-	pgd = pgd_offset(mm, addr & PAGE_MASK);
-	if (pgd) {
-		pmd = pmd_offset(pud_offset(pgd, addr & PAGE_MASK),
-		                 addr & PAGE_MASK);
-		if (pmd && pmd_present(*pmd)) {
-			pte = pte_offset_kernel(pmd, addr & PAGE_MASK);
-			if (pte) {
-				retval = (int)pte_val(*pte);
-			}
-		}
-	}
-	return retval;
-}
-
-/*
- * We return 0 on success, 1 on unimplemented instruction, and EFAULT
- * if a load/store faulted.
- */
-int Soft_emulate_8xx(struct pt_regs *regs)
-{
-	u32 inst, instword;
-	u32 flreg, idxreg, disp;
-	int retval;
-	s16 sdisp;
-	u32 *ea, *ip;
-
-	retval = 0;
-
-	instword = *((u32 *)regs->nip);
-	inst = instword >> 26;
-
-	flreg = (instword >> 21) & 0x1f;
-	idxreg = (instword >> 16) & 0x1f;
-	disp = instword & 0xffff;
-
-	ea = (u32 *)(regs->gpr[idxreg] + disp);
-	ip = (u32 *)&current->thread.TS_FPR(flreg);
-
-	switch ( inst )
-	{
-	case LFD:
-		/* this is a 16 bit quantity that is sign extended
-		 * so use a signed short here -- Cort
-		 */
-		sdisp = (instword & 0xffff);
-		ea = (u32 *)(regs->gpr[idxreg] + sdisp);
-		if (copy_from_user(ip, ea, sizeof(double)))
-			retval = -EFAULT;
-		break;
-
-	case LFDU:
-		if (copy_from_user(ip, ea, sizeof(double)))
-			retval = -EFAULT;
-		else
-			regs->gpr[idxreg] = (u32)ea;
-		break;
-	case LFS:
-		sdisp = (instword & 0xffff);
-		ea = (u32 *)(regs->gpr[idxreg] + sdisp);
-		if (copy_from_user(ip, ea, sizeof(float)))
-			retval = -EFAULT;
-		break;
-	case STFD:
-		/* this is a 16 bit quantity that is sign extended
-		 * so use a signed short here -- Cort
-		 */
-		sdisp = (instword & 0xffff);
-		ea = (u32 *)(regs->gpr[idxreg] + sdisp);
-		if (copy_to_user(ea, ip, sizeof(double)))
-			retval = -EFAULT;
-		break;
-
-	case STFDU:
-		if (copy_to_user(ea, ip, sizeof(double)))
-			retval = -EFAULT;
-		else
-			regs->gpr[idxreg] = (u32)ea;
-		break;
-	case FMR:
-		/* assume this is a fp move -- Cort */
-		memcpy(ip, &current->thread.TS_FPR((instword>>11)&0x1f),
-		       sizeof(double));
-		break;
-	default:
-		retval = 1;
-		printk("Bad emulation %s/%d\n"
-		       " NIP: %08lx instruction: %08x opcode: %x "
-		       "A: %x B: %x C: %x code: %x rc: %x\n",
-		       current->comm,current->pid,
-		       regs->nip,
-		       instword,inst,
-		       (instword>>16)&0x1f,
-		       (instword>>11)&0x1f,
-		       (instword>>6)&0x1f,
-		       (instword>>1)&0x3ff,
-		       instword&1);
-		{
-			int pa;
-			print_8xx_pte(current->mm,regs->nip);
-			pa = get_8xx_pte(current->mm,regs->nip) & PAGE_MASK;
-			pa |= (regs->nip & ~PAGE_MASK);
-			pa = (unsigned long)__va(pa);
-			printk("Kernel VA for NIP %x ", pa);
-			print_8xx_pte(current->mm,pa);
-		}
-	}
-
-	if (retval == 0)
-		regs->nip += 4;
-
-	return retval;
-}
-- 
1.8.1.4

