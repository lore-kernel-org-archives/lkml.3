Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752516Ab3KDQxU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 11:53:20 -0500
Received: from relay1.mentorg.com ([192.94.38.131]:38011 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752147Ab3KDQxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 11:53:19 -0500
Date: Mon, 4 Nov 2013 16:53:14 +0000
From: "Joseph S. Myers" <joseph@codesourcery.com>
X-X-Sender: jsm28@digraph.polyomino.org.uk
To: <linuxppc-dev@lists.ozlabs.org>
CC: <linux-kernel@vger.kernel.org>, Liu Yu <yu.liu@freescale.com>,
        Kumar Gala <galak@kernel.crashing.org>,
        Shan Hai <shan.hai@windriver.com>
Subject: [PATCH 2/6] powerpc: fix e500 SPE float rounding inexactness detection
In-Reply-To: <Pine.LNX.4.64.1311041649250.4290@digraph.polyomino.org.uk>
Message-ID: <Pine.LNX.4.64.1311041652190.4290@digraph.polyomino.org.uk>
References: <Pine.LNX.4.64.1311041649250.4290@digraph.polyomino.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-OriginalArrivalTime: 04 Nov 2013 16:53:18.0670 (UTC) FILETIME=[5CD20EE0:01CED97E]
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

Previous submission: <http://lkml.org/lkml/2013/10/4/497>.

diff --git a/arch/powerpc/math-emu/math_efp.c b/arch/powerpc/math-emu/math_efp.c
index 59835c6..ecdf35d 100644
--- a/arch/powerpc/math-emu/math_efp.c
+++ b/arch/powerpc/math-emu/math_efp.c
@@ -680,7 +680,8 @@ int speround_handler(struct pt_regs *regs)
 {
 	union dw_union fgpr;
 	int s_lo, s_hi;
-	unsigned long speinsn, type, fc;
+	int lo_inexact, hi_inexact;
+	unsigned long speinsn, type, fc, fptype;
 
 	if (get_user(speinsn, (unsigned int __user *) regs->nip))
 		return -EFAULT;
@@ -693,8 +694,12 @@ int speround_handler(struct pt_regs *regs)
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
@@ -705,7 +710,7 @@ int speround_handler(struct pt_regs *regs)
 
 	pr_debug("round fgpr: %08x  %08x\n", fgpr.wp[0], fgpr.wp[1]);
 
-	switch ((speinsn >> 5) & 0x7) {
+	switch (fptype) {
 	/* Since SPE instructions on E500 core can handle round to nearest
 	 * and round toward zero with IEEE-754 complied, we just need
 	 * to handle round toward +Inf and round toward -Inf by software.
@@ -728,11 +733,15 @@ int speround_handler(struct pt_regs *regs)
 
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
