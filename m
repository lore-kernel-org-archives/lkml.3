Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754019AbaHTMBw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 08:01:52 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:58937 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752537AbaHTLoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 07:44:10 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 047/104] sparc64: Fix top-level fault handling bugs.
Date: Wed, 20 Aug 2014 13:43:10 +0200
Message-Id: <a91ce41d405b3cc59d6666ec91a5a3235f9cbcf6.1408535000.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <cbcbb4c4826ff594b091e143b0f049f13ab7a64e.1408535000.git.jslaby@suse.cz>
References: <cbcbb4c4826ff594b091e143b0f049f13ab7a64e.1408535000.git.jslaby@suse.cz>
In-Reply-To: <cover.1408535000.git.jslaby@suse.cz>
References: <cover.1408535000.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "David S. Miller" <davem@davemloft.net>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

[ Upstream commit 70ffc6ebaead783ac8dafb1e87df0039bb043596 ]

Make get_user_insn() able to cope with huge PMDs.

Next, make do_fault_siginfo() more robust when get_user_insn() can't
actually fetch the instruction.  In particular, use the MMU announced
fault address when that happens, instead of calling
compute_effective_address() and computing garbage.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/sparc/mm/fault_64.c | 82 ++++++++++++++++++++++++++++++------------------
 1 file changed, 52 insertions(+), 30 deletions(-)

diff --git a/arch/sparc/mm/fault_64.c b/arch/sparc/mm/fault_64.c
index 2ebec263d685..a99d0da04850 100644
--- a/arch/sparc/mm/fault_64.c
+++ b/arch/sparc/mm/fault_64.c
@@ -95,38 +95,51 @@ static unsigned int get_user_insn(unsigned long tpc)
 	pte_t *ptep, pte;
 	unsigned long pa;
 	u32 insn = 0;
-	unsigned long pstate;
 
-	if (pgd_none(*pgdp))
-		goto outret;
+	if (pgd_none(*pgdp) || unlikely(pgd_bad(*pgdp)))
+		goto out;
 	pudp = pud_offset(pgdp, tpc);
-	if (pud_none(*pudp))
-		goto outret;
-	pmdp = pmd_offset(pudp, tpc);
-	if (pmd_none(*pmdp))
-		goto outret;
+	if (pud_none(*pudp) || unlikely(pud_bad(*pudp)))
+		goto out;
 
 	/* This disables preemption for us as well. */
-	__asm__ __volatile__("rdpr %%pstate, %0" : "=r" (pstate));
-	__asm__ __volatile__("wrpr %0, %1, %%pstate"
-				: : "r" (pstate), "i" (PSTATE_IE));
-	ptep = pte_offset_map(pmdp, tpc);
-	pte = *ptep;
-	if (!pte_present(pte))
-		goto out;
+	local_irq_disable();
 
-	pa  = (pte_pfn(pte) << PAGE_SHIFT);
-	pa += (tpc & ~PAGE_MASK);
+	pmdp = pmd_offset(pudp, tpc);
+	if (pmd_none(*pmdp) || unlikely(pmd_bad(*pmdp)))
+		goto out_irq_enable;
+
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	if (pmd_trans_huge(*pmdp)) {
+		if (pmd_trans_splitting(*pmdp))
+			goto out_irq_enable;
 
-	/* Use phys bypass so we don't pollute dtlb/dcache. */
-	__asm__ __volatile__("lduwa [%1] %2, %0"
-			     : "=r" (insn)
-			     : "r" (pa), "i" (ASI_PHYS_USE_EC));
+		pa  = pmd_pfn(*pmdp) << PAGE_SHIFT;
+		pa += tpc & ~HPAGE_MASK;
 
+		/* Use phys bypass so we don't pollute dtlb/dcache. */
+		__asm__ __volatile__("lduwa [%1] %2, %0"
+				     : "=r" (insn)
+				     : "r" (pa), "i" (ASI_PHYS_USE_EC));
+	} else
+#endif
+	{
+		ptep = pte_offset_map(pmdp, tpc);
+		pte = *ptep;
+		if (pte_present(pte)) {
+			pa  = (pte_pfn(pte) << PAGE_SHIFT);
+			pa += (tpc & ~PAGE_MASK);
+
+			/* Use phys bypass so we don't pollute dtlb/dcache. */
+			__asm__ __volatile__("lduwa [%1] %2, %0"
+					     : "=r" (insn)
+					     : "r" (pa), "i" (ASI_PHYS_USE_EC));
+		}
+		pte_unmap(ptep);
+	}
+out_irq_enable:
+	local_irq_enable();
 out:
-	pte_unmap(ptep);
-	__asm__ __volatile__("wrpr %0, 0x0, %%pstate" : : "r" (pstate));
-outret:
 	return insn;
 }
 
@@ -152,7 +165,8 @@ show_signal_msg(struct pt_regs *regs, int sig, int code,
 }
 
 static void do_fault_siginfo(int code, int sig, struct pt_regs *regs,
-			     unsigned int insn, int fault_code)
+			     unsigned long fault_addr, unsigned int insn,
+			     int fault_code)
 {
 	unsigned long addr;
 	siginfo_t info;
@@ -160,10 +174,18 @@ static void do_fault_siginfo(int code, int sig, struct pt_regs *regs,
 	info.si_code = code;
 	info.si_signo = sig;
 	info.si_errno = 0;
-	if (fault_code & FAULT_CODE_ITLB)
+	if (fault_code & FAULT_CODE_ITLB) {
 		addr = regs->tpc;
-	else
-		addr = compute_effective_address(regs, insn, 0);
+	} else {
+		/* If we were able to probe the faulting instruction, use it
+		 * to compute a precise fault address.  Otherwise use the fault
+		 * time provided address which may only have page granularity.
+		 */
+		if (insn)
+			addr = compute_effective_address(regs, insn, 0);
+		else
+			addr = fault_addr;
+	}
 	info.si_addr = (void __user *) addr;
 	info.si_trapno = 0;
 
@@ -238,7 +260,7 @@ static void __kprobes do_kernel_fault(struct pt_regs *regs, int si_code,
 		/* The si_code was set to make clear whether
 		 * this was a SEGV_MAPERR or SEGV_ACCERR fault.
 		 */
-		do_fault_siginfo(si_code, SIGSEGV, regs, insn, fault_code);
+		do_fault_siginfo(si_code, SIGSEGV, regs, address, insn, fault_code);
 		return;
 	}
 
@@ -521,7 +543,7 @@ do_sigbus:
 	 * Send a sigbus, regardless of whether we were in kernel
 	 * or user mode.
 	 */
-	do_fault_siginfo(BUS_ADRERR, SIGBUS, regs, insn, fault_code);
+	do_fault_siginfo(BUS_ADRERR, SIGBUS, regs, address, insn, fault_code);
 
 	/* Kernel mode? Handle exceptions or die */
 	if (regs->tstate & TSTATE_PRIV)
-- 
2.0.4

