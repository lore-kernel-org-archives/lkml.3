Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752619AbaLCXor (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 18:44:47 -0500
Received: from mail-ig0-f182.google.com ([209.85.213.182]:53602 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000AbaLCXo2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 18:44:28 -0500
From: David Daney <ddaney.cavm@gmail.com>
To: linux-mips@linux-mips.org, ralf@linux-mips.org
Cc: Leonid Yegoshin <Leonid.Yegoshin@imgtec.com>, Zubair.Kakakhel@imgtec.com,
        geert+renesas@glider.be, peterz@infradead.org,
        paul.gortmaker@windriver.com, macro@linux-mips.org, chenhc@lemote.com,
        cl@linux.com, mingo@kernel.org, richard@nod.at, zajec5@gmail.com,
        james.hogan@imgtec.com, keescook@chromium.org, tj@kernel.org,
        alex@alex-smith.me.uk, pbonzini@redhat.com, blogic@openwrt.org,
        paul.burton@imgtec.com, qais.yousef@imgtec.com,
        linux-kernel@vger.kernel.org, markos.chandras@imgtec.com,
        dengcheng.zhu@imgtec.com, manuel.lauss@gmail.com,
        lars.persson@axis.com, David Daney <david.daney@cavium.com>
Subject: [PATCH 3/3] MIPS: Use full instruction emulation for FPU emulator delay slot emulation.
Date: Wed,  3 Dec 2014 15:44:18 -0800
Message-Id: <1417650258-2811-4-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1417650258-2811-1-git-send-email-ddaney.cavm@gmail.com>
References: <1417650258-2811-1-git-send-email-ddaney.cavm@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.daney@cavium.com>

Current delay slot handling does eXecute Out of Line (XOL) on the
stack, which prevents a non-executable stack.  Use the instruction
emulator instead.

Tested by booting 32-bit Debian on OCTEON.  More than 1700
instructions emulated to login to command line.

Signed-off-by: David Daney <david.daney@cavium.com>
---
 arch/mips/math-emu/cp1emu.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/arch/mips/math-emu/cp1emu.c b/arch/mips/math-emu/cp1emu.c
index cac529a..787de7a 100644
--- a/arch/mips/math-emu/cp1emu.c
+++ b/arch/mips/math-emu/cp1emu.c
@@ -694,11 +694,12 @@ do {									\
  * Emulate the single floating point instruction pointed at by EPC.
  * Two instructions if the instruction is in a branch delay slot.
  */
-
+int mips_insn_emul(struct pt_regs *regs, mips_instruction ir, void *__user *fault_addr);
 static int cop1Emulate(struct pt_regs *xcp, struct mips_fpu_struct *ctx,
 		struct mm_decoded_insn dec_insn, void *__user *fault_addr)
 {
 	unsigned long contpc = xcp->cp0_epc + dec_insn.pc_inc;
+	unsigned long origpc = xcp->cp0_epc;
 	unsigned int cond, cbit;
 	mips_instruction ir;
 	int likely, pc_inc;
@@ -1038,7 +1039,15 @@ emul:
 				 * Single step the non-cp1
 				 * instruction in the dslot
 				 */
-				return mips_dsemul(xcp, ir, contpc);
+				sig = mips_insn_emul(xcp, ir, fault_addr);
+				if (sig == 0) {
+					xcp->cp0_epc = contpc;
+					MIPS_FPU_EMU_INC_STATS(insn_emul);
+				} else {
+					xcp->cp0_epc = origpc;
+					pr_err("mips_insn_emul: %08x ->%d\n", (unsigned)ir, sig);
+				}
+				return sig;
 			} else if (likely) {	/* branch not taken */
 					/*
 					 * branch likely nullifies
-- 
1.7.11.7

