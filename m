Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752313Ab3JDWye (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 18:54:34 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:55837 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951Ab3JDWyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 18:54:33 -0400
Date: Fri, 4 Oct 2013 22:51:54 +0000
From: "Joseph S. Myers" <joseph@codesourcery.com>
X-X-Sender: jsm28@digraph.polyomino.org.uk
To: <linuxppc-dev@lists.ozlabs.org>
CC: <linux-kernel@vger.kernel.org>
Subject: [PATCH] powerpc: fix e500 SPE float rounding inexactness detection
Message-ID: <Pine.LNX.4.64.1310042250420.27874@digraph.polyomino.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-OriginalArrivalTime: 04 Oct 2013 22:52:04.0004 (UTC) FILETIME=[581D1E40:01CEC154]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joseph Myers <joseph@codesourcery.com>

The e500 SPE floating-point emulation code for the rounding modes
rounding to positive or negative infinity (which may not be
implemented in hardware) tries to avoid emulating rounding if the
result was inexact.  However, it tests inexactness using the sticky
bit with the cumulative result of previous operations, rather than
with the non-sticky bits relating to the operation that generated the
interrupt.  Furthermore, when a vector operation generates the
interrupt, it's possible that only one of the low and high parts is
inexact, and so only that part should have rounding emulated.  This
results in incorrect rounding of exact results in these modes when the
sticky bit is set from a previous operation.

(I'm not sure why the rounding interrupts are generated at all when
the result is exact, but empirically the hardware does generate them.)

This patch checks for inexactness using the correct bits of SPEFSCR,
and ensures that rounding only occurs when the relevant part of the
result was actually inexact.

Signed-off-by: Joseph Myers <joseph@codesourcery.com>

---

diff --git a/arch/powerpc/math-emu/math_efp.c b/arch/powerpc/math-emu/math_efp.c
index a73f088..ecdf35d 100644
--- a/arch/powerpc/math-emu/math_efp.c
+++ b/arch/powerpc/math-emu/math_efp.c
@@ -662,7 +680,8 @@ int speround_handler(struct pt_regs *regs)
 {
 	union dw_union fgpr;
 	int s_lo, s_hi;
-	unsigned long speinsn, type, fc;
+	int lo_inexact, hi_inexact;
+	unsigned long speinsn, type, fc, fptype;
 
 	if (get_user(speinsn, (unsigned int __user *) regs->nip))
 		return -EFAULT;
@@ -675,8 +694,12 @@ int speround_handler(struct pt_regs *regs)
 	__FPU_FPSCR = mfspr(SPRN_SPEFSCR);
 	pr_debug("speinsn:%08lx spefscr:%08lx\n", speinsn, __FPU_FPSCR);
 
+	fptype = (speinsn >> 5) & 0x7;
+
 	/* No need to round if the result is exact */
-	if (!(__FPU_FPSCR & FP_EX_INEXACT))
+	lo_inexact = __FPU_FPSCR & (SPEFSCR_FG | SPEFSCR_FX);
+	hi_inexact = __FPU_FPSCR & (SPEFSCR_FGH | SPEFSCR_FXH);
+	if (!(lo_inexact || (hi_inexact && fptype == VCT)))
 		return 0;
 
 	fc = (speinsn >> 21) & 0x1f;
@@ -687,7 +710,7 @@ int speround_handler(struct pt_regs *regs)
 
 	pr_debug("round fgpr: %08x  %08x\n", fgpr.wp[0], fgpr.wp[1]);
 
-	switch ((speinsn >> 5) & 0x7) {
+	switch (fptype) {
 	/* Since SPE instructions on E500 core can handle round to nearest
 	 * and round toward zero with IEEE-754 complied, we just need
 	 * to handle round toward +Inf and round toward -Inf by software.
@@ -710,11 +733,15 @@ int speround_handler(struct pt_regs *regs)
 
 	case VCT:
 		if (FP_ROUNDMODE == FP_RND_PINF) {
-			if (!s_lo) fgpr.wp[1]++; /* Z_low > 0, choose Z1 */
-			if (!s_hi) fgpr.wp[0]++; /* Z_high word > 0, choose Z1 */
+			if (lo_inexact && !s_lo)
+				fgpr.wp[1]++; /* Z_low > 0, choose Z1 */
+			if (hi_inexact && !s_hi)
+				fgpr.wp[0]++; /* Z_high word > 0, choose Z1 */
 		} else { /* round to -Inf */
-			if (s_lo) fgpr.wp[1]++; /* Z_low < 0, choose Z2 */
-			if (s_hi) fgpr.wp[0]++; /* Z_high < 0, choose Z2 */
+			if (lo_inexact && s_lo)
+				fgpr.wp[1]++; /* Z_low < 0, choose Z2 */
+			if (hi_inexact && s_hi)
+				fgpr.wp[0]++; /* Z_high < 0, choose Z2 */
 		}
 		break;
 

-- 
Joseph S. Myers
joseph@codesourcery.com
