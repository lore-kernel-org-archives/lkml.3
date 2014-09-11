Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756502AbaIKNOR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 09:14:17 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51509 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755374AbaIKMeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 08:34:04 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "David S. Miller" <davem@davemloft.net>
Date: Thu, 11 Sep 2014 13:32:13 +0100
Message-ID: <lsq.1410438733.621467145@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 111/131] sparc64: Fix top-level fault handling bugs.
In-Reply-To: <lsq.1410438733.176537304@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.63-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: "David S. Miller" <davem@davemloft.net>

[ Upstream commit 70ffc6ebaead783ac8dafb1e87df0039bb043596 ]

Make get_user_insn() able to cope with huge PMDs.

Next, make do_fault_siginfo() more robust when get_user_insn() can't
actually fetch the instruction.  In particular, use the MMU announced
fault address when that happens, instead of calling
compute_effective_address() and computing garbage.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/sparc/mm/fault_64.c | 86 ++++++++++++++++++++++++++++++------------------
 1 file changed, 54 insertions(+), 32 deletions(-)

diff --git a/arch/sparc/mm/fault_64.c b/arch/sparc/mm/fault_64.c
index 504c062..6ac702f 100644
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
-
-	/* This disables preemption for us as well. */
-	__asm__ __volatile__("rdpr %%pstate, %0" : "=r" (pstate));
-	__asm__ __volatile__("wrpr %0, %1, %%pstate"
-				: : "r" (pstate), "i" (PSTATE_IE));
-	ptep = pte_offset_map(pmdp, tpc);
-	pte = *ptep;
-	if (!pte_present(pte))
+	if (pud_none(*pudp) || unlikely(pud_bad(*pudp)))
 		goto out;
 
-	pa  = (pte_pfn(pte) << PAGE_SHIFT);
-	pa += (tpc & ~PAGE_MASK);
-
-	/* Use phys bypass so we don't pollute dtlb/dcache. */
-	__asm__ __volatile__("lduwa [%1] %2, %0"
-			     : "=r" (insn)
-			     : "r" (pa), "i" (ASI_PHYS_USE_EC));
+	/* This disables preemption for us as well. */
+	local_irq_disable();
 
+	pmdp = pmd_offset(pudp, tpc);
+	if (pmd_none(*pmdp) || unlikely(pmd_bad(*pmdp)))
+		goto out_irq_enable;
+
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	if (pmd_trans_huge(*pmdp)) {
+		if (pmd_trans_splitting(*pmdp))
+			goto out_irq_enable;
+
+		pa  = pmd_pfn(*pmdp) << PAGE_SHIFT;
+		pa += tpc & ~HPAGE_MASK;
+
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
 
@@ -154,7 +167,8 @@ show_signal_msg(struct pt_regs *regs, int sig, int code,
 extern unsigned long compute_effective_address(struct pt_regs *, unsigned int, unsigned int);
 
 static void do_fault_siginfo(int code, int sig, struct pt_regs *regs,
-			     unsigned int insn, int fault_code)
+			     unsigned long fault_addr, unsigned int insn,
+			     int fault_code)
 {
 	unsigned long addr;
 	siginfo_t info;
@@ -162,10 +176,18 @@ static void do_fault_siginfo(int code, int sig, struct pt_regs *regs,
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
 
@@ -240,7 +262,7 @@ static void __kprobes do_kernel_fault(struct pt_regs *regs, int si_code,
 		/* The si_code was set to make clear whether
 		 * this was a SEGV_MAPERR or SEGV_ACCERR fault.
 		 */
-		do_fault_siginfo(si_code, SIGSEGV, regs, insn, fault_code);
+		do_fault_siginfo(si_code, SIGSEGV, regs, address, insn, fault_code);
 		return;
 	}
 
@@ -492,7 +514,7 @@ do_sigbus:
 	 * Send a sigbus, regardless of whether we were in kernel
 	 * or user mode.
 	 */
-	do_fault_siginfo(BUS_ADRERR, SIGBUS, regs, insn, fault_code);
+	do_fault_siginfo(BUS_ADRERR, SIGBUS, regs, address, insn, fault_code);
 
 	/* Kernel mode? Handle exceptions or die */
 	if (regs->tstate & TSTATE_PRIV)

