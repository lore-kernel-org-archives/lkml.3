Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932975AbaIOWSY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 18:18:24 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51113 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932954AbaIOWSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:18:20 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 021/187] sparc64: Fix top-level fault handling bugs.
Date: Mon, 15 Sep 2014 15:07:11 -0700
Message-Id: <1410818997-9432-22-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410818997-9432-1-git-send-email-kamal@canonical.com>
References: <1410818997-9432-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "David S. Miller" <davem@davemloft.net>

[ Upstream commit 70ffc6ebaead783ac8dafb1e87df0039bb043596 ]

Make get_user_insn() able to cope with huge PMDs.

Next, make do_fault_siginfo() more robust when get_user_insn() can't
actually fetch the instruction.  In particular, use the MMU announced
fault address when that happens, instead of calling
compute_effective_address() and computing garbage.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/sparc/mm/fault_64.c | 82 ++++++++++++++++++++++++++++++------------------
 1 file changed, 52 insertions(+), 30 deletions(-)

diff --git a/arch/sparc/mm/fault_64.c b/arch/sparc/mm/fault_64.c
index 69bb818..a8ff0d1 100644
--- a/arch/sparc/mm/fault_64.c
+++ b/arch/sparc/mm/fault_64.c
@@ -96,38 +96,51 @@ static unsigned int get_user_insn(unsigned long tpc)
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
 
@@ -153,7 +166,8 @@ show_signal_msg(struct pt_regs *regs, int sig, int code,
 }
 
 static void do_fault_siginfo(int code, int sig, struct pt_regs *regs,
-			     unsigned int insn, int fault_code)
+			     unsigned long fault_addr, unsigned int insn,
+			     int fault_code)
 {
 	unsigned long addr;
 	siginfo_t info;
@@ -161,10 +175,18 @@ static void do_fault_siginfo(int code, int sig, struct pt_regs *regs,
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
 
@@ -239,7 +261,7 @@ static void __kprobes do_kernel_fault(struct pt_regs *regs, int si_code,
 		/* The si_code was set to make clear whether
 		 * this was a SEGV_MAPERR or SEGV_ACCERR fault.
 		 */
-		do_fault_siginfo(si_code, SIGSEGV, regs, insn, fault_code);
+		do_fault_siginfo(si_code, SIGSEGV, regs, address, insn, fault_code);
 		return;
 	}
 
@@ -525,7 +547,7 @@ do_sigbus:
 	 * Send a sigbus, regardless of whether we were in kernel
 	 * or user mode.
 	 */
-	do_fault_siginfo(BUS_ADRERR, SIGBUS, regs, insn, fault_code);
+	do_fault_siginfo(BUS_ADRERR, SIGBUS, regs, address, insn, fault_code);
 
 	/* Kernel mode? Handle exceptions or die */
 	if (regs->tstate & TSTATE_PRIV)
-- 
1.9.1

