Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757854Ab3FGXEE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 19:04:04 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:61101 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757614Ab3FGXDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 19:03:50 -0400
From: David Daney <ddaney.cavm@gmail.com>
To: linux-mips@linux-mips.org, ralf@linux-mips.org, kvm@vger.kernel.org,
        Sanjay Lal <sanjayl@kymasys.com>
Cc: linux-kernel@vger.kernel.org, David Daney <david.daney@cavium.com>
Subject: [PATCH 11/31] MIPS: Rearrange branch.c so it can be used by kvm code.
Date: Fri,  7 Jun 2013 16:03:15 -0700
Message-Id: <1370646215-6543-12-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1370646215-6543-1-git-send-email-ddaney.cavm@gmail.com>
References: <1370646215-6543-1-git-send-email-ddaney.cavm@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.daney@cavium.com>

Introduce __compute_return_epc_for_insn0() entry point.

Signed-off-by: David Daney <david.daney@cavium.com>
---
 arch/mips/include/asm/branch.h |  7 +++++
 arch/mips/kernel/branch.c      | 63 +++++++++++++++++++++++++++++++-----------
 2 files changed, 54 insertions(+), 16 deletions(-)

diff --git a/arch/mips/include/asm/branch.h b/arch/mips/include/asm/branch.h
index e28a3e0..b3de685 100644
--- a/arch/mips/include/asm/branch.h
+++ b/arch/mips/include/asm/branch.h
@@ -37,6 +37,13 @@ static inline unsigned long exception_epc(struct pt_regs *regs)
 
 #define BRANCH_LIKELY_TAKEN 0x0001
 
+extern int __compute_return_epc(struct pt_regs *regs);
+extern int __compute_return_epc_for_insn(struct pt_regs *regs,
+					 union mips_instruction insn);
+extern int __compute_return_epc_for_insn0(struct pt_regs *regs,
+					  union mips_instruction insn,
+					  unsigned int (*get_fcr31)(void));
+
 static inline int compute_return_epc(struct pt_regs *regs)
 {
 	if (get_isa16_mode(regs->cp0_epc)) {
diff --git a/arch/mips/kernel/branch.c b/arch/mips/kernel/branch.c
index 46c2ad0..e47145b 100644
--- a/arch/mips/kernel/branch.c
+++ b/arch/mips/kernel/branch.c
@@ -195,17 +195,18 @@ int __MIPS16e_compute_return_epc(struct pt_regs *regs)
 }
 
 /**
- * __compute_return_epc_for_insn - Computes the return address and do emulate
+ * __compute_return_epc_for_insn0 - Computes the return address and do emulate
  *				    branch simulation, if required.
  *
  * @regs:	Pointer to pt_regs
  * @insn:	branch instruction to decode
- * @returns:	-EFAULT on error and forces SIGBUS, and on success
+ * @returns:	-EFAULT on error, and on success
  *		returns 0 or BRANCH_LIKELY_TAKEN as appropriate after
  *		evaluating the branch.
  */
-int __compute_return_epc_for_insn(struct pt_regs *regs,
-				   union mips_instruction insn)
+int __compute_return_epc_for_insn0(struct pt_regs *regs,
+				   union mips_instruction insn,
+				   unsigned int (*get_fcr31)(void))
 {
 	unsigned int bit, fcr31, dspcontrol;
 	long epc = regs->cp0_epc;
@@ -281,7 +282,7 @@ int __compute_return_epc_for_insn(struct pt_regs *regs,
 
 		case bposge32_op:
 			if (!cpu_has_dsp)
-				goto sigill;
+				return -EFAULT;
 
 			dspcontrol = rddsp(0x01);
 
@@ -364,13 +365,7 @@ int __compute_return_epc_for_insn(struct pt_regs *regs,
 	 * And now the FPA/cp1 branch instructions.
 	 */
 	case cop1_op:
-		preempt_disable();
-		if (is_fpu_owner())
-			asm volatile("cfc1\t%0,$31" : "=r" (fcr31));
-		else
-			fcr31 = current->thread.fpu.fcr31;
-		preempt_enable();
-
+		fcr31 = get_fcr31();
 		bit = (insn.i_format.rt >> 2);
 		bit += (bit != 0);
 		bit += 23;
@@ -434,11 +429,47 @@ int __compute_return_epc_for_insn(struct pt_regs *regs,
 	}
 
 	return ret;
+}
+EXPORT_SYMBOL_GPL(__compute_return_epc_for_insn0);
 
-sigill:
-	printk("%s: DSP branch but not DSP ASE - sending SIGBUS.\n", current->comm);
-	force_sig(SIGBUS, current);
-	return -EFAULT;
+static unsigned int __get_fcr31(void)
+{
+	unsigned int fcr31;
+
+	preempt_disable();
+	if (is_fpu_owner())
+		asm volatile(
+			".set push\n"
+			"\t.set mips1\n"
+			"\tcfc1\t%0,$31\n"
+			"\t.set pop" : "=r" (fcr31));
+	else
+		fcr31 = current->thread.fpu.fcr31;
+	preempt_enable();
+	return fcr31;
+}
+
+/**
+ * __compute_return_epc_for_insn - Computes the return address and do emulate
+ *				    branch simulation, if required.
+ *
+ * @regs:	Pointer to pt_regs
+ * @insn:	branch instruction to decode
+ * @returns:	-EFAULT on error and forces SIGBUS, and on success
+ *		returns 0 or BRANCH_LIKELY_TAKEN as appropriate after
+ *		evaluating the branch.
+ */
+int __compute_return_epc_for_insn(struct pt_regs *regs,
+				   union mips_instruction insn)
+{
+	int r =  __compute_return_epc_for_insn0(regs, insn, __get_fcr31);
+
+	if (r < 0) {
+		printk("%s: DSP branch but not DSP ASE - sending SIGBUS.\n", current->comm);
+		force_sig(SIGBUS, current);
+	}
+
+	return r;
 }
 EXPORT_SYMBOL_GPL(__compute_return_epc_for_insn);
 
-- 
1.7.11.7

