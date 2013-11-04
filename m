Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752885Ab3KDQyx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 11:54:53 -0500
Received: from relay1.mentorg.com ([192.94.38.131]:38272 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800Ab3KDQyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 11:54:51 -0500
Date: Mon, 4 Nov 2013 16:54:46 +0000
From: "Joseph S. Myers" <joseph@codesourcery.com>
X-X-Sender: jsm28@digraph.polyomino.org.uk
To: <linuxppc-dev@lists.ozlabs.org>
CC: <linux-kernel@vger.kernel.org>, Liu Yu <yu.liu@freescale.com>,
        Kumar Gala <galak@kernel.crashing.org>,
        Shan Hai <shan.hai@windriver.com>
Subject: [PATCH 5/6] powerpc: fix e500 SPE float to integer and fixed-point
 conversions
In-Reply-To: <Pine.LNX.4.64.1311041649250.4290@digraph.polyomino.org.uk>
Message-ID: <Pine.LNX.4.64.1311041654190.4290@digraph.polyomino.org.uk>
References: <Pine.LNX.4.64.1311041649250.4290@digraph.polyomino.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-OriginalArrivalTime: 04 Nov 2013 16:54:51.0680 (UTC) FILETIME=[94424200:01CED97E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joseph Myers <joseph@codesourcery.com>

The e500 SPE floating-point emulation code has several problems in how
it handles conversions to integer and fixed-point fractional types.

There are the following 20 relevant instructions.  These can convert
to signed or unsigned 32-bit integers, either rounding towards zero
(as correct for C casts from floating-point to integer) or according
to the current rounding mode, or to signed or unsigned 32-bit
fixed-point values (values in the range [-1, 1) or [0, 1)).  For
conversion from double precision there are also instructions to
convert to 64-bit integers, rounding towards zero, although as far as
I know those instructions are completely theoretical (they are only
defined for implementations that support both SPE and classic 64-bit,
and I'm not aware of any such hardware even though the architecture
definition permits that combination).

#define EFSCTUI		0x2d4
#define EFSCTSI		0x2d5
#define EFSCTUF		0x2d6
#define EFSCTSF		0x2d7
#define EFSCTUIZ	0x2d8
#define EFSCTSIZ	0x2da

#define EVFSCTUI	0x294
#define EVFSCTSI	0x295
#define EVFSCTUF	0x296
#define EVFSCTSF	0x297
#define EVFSCTUIZ	0x298
#define EVFSCTSIZ	0x29a

#define EFDCTUIDZ	0x2ea
#define EFDCTSIDZ	0x2eb

#define EFDCTUI		0x2f4
#define EFDCTSI		0x2f5
#define EFDCTUF		0x2f6
#define EFDCTSF		0x2f7
#define EFDCTUIZ	0x2f8
#define EFDCTSIZ	0x2fa

The emulation code, for the instructions that come in variants
rounding either towards zero or according to the current rounding
direction, uses "if (func & 0x4)" as a condition for using _FP_ROUND
(otherwise _FP_ROUND_ZERO is used).  The condition is correct, but the
code it controls isn't.  Whether _FP_ROUND or _FP_ROUND_ZERO is used
makes no difference, as the effect of those soft-fp macros is to round
an intermediate floating-point result using the low three bits (the
last one sticky) of the working format.  As these operations are
dealing with a freshly unpacked floating-point input, those low bits
are zero and no rounding occurs.  The emulation code then uses the
FP_TO_INT_* macros for the actual integer conversion, with the effect
of always rounding towards zero; for rounding according to the current
rounding direction, it should be using FP_TO_INT_ROUND_*.

The instructions in question have semantics defined (in the Power ISA
documents) for out-of-range values and NaNs: out-of-range values
saturate and NaNs are converted to zero.  The emulation does nothing
to follow those semantics for NaNs (the soft-fp handling is to treat
them as infinities), and messes up the saturation semantics.  For
single-precision conversion to integers, (((func & 0x3) != 0) || SB_s)
is the condition used for doing a signed conversion.  The first part
is correct, but the second isn't: negative numbers should result in
saturation to 0 when converted to unsigned.  Double-precision
conversion to 64-bit integers correctly uses ((func & 0x1) == 0).
Double-precision conversion to 32-bit integers uses (((func & 0x3) !=
0) || DB_s), with correct first part and incorrect second part.  And
vector float conversion to integers uses (((func & 0x3) != 0) ||
SB0_s) (and similar for the other vector element), where the sign bit
check is again wrong.

The incorrect handling of negative numbers converted to unsigned was
introduced in commit afc0a07d4a283599ac3a6a31d7454e9baaeccca0.  The
rationale given there was a C testcase with cast from float to
unsigned int.  Conversion of out-of-range floating-point numbers to
integer types in C is undefined behavior in the base standard, defined
in Annex F to produce an unspecified value.  That is, the C testcase
used to justify that patch is incorrect - there is no ISO C
requirement for a particular value resulting from this conversion -
and in any case, the correct semantics for such emulation are the
semantics for the instruction (unsigned saturation, which is what it
does in hardware when the emulation is disabled).

The conversion to fixed-point values has its own problems.  That code
doesn't try to do a full emulation; it relies on the trap handler only
being called for arguments that are infinities, NaNs, subnormal or out
of range.  That's fine, but the logic ((vb.wp[1] >> 23) == 0xff &&
((vb.wp[1] & 0x7fffff) > 0)) for NaN detection won't detect negative
NaNs as being NaNs (the same applies for the double-precision case),
and subnormals are mapped to 0 rather than respecting the rounding
mode; the code should also explicitly raise the "invalid" exception.
The code for vectors works by executing the scalar float instruction
with the trapping disabled, meaning at least subnormals won't be
handled correctly.

As well as all those problems in the main emulation code, the rounding
handler - used to emulate rounding upward and downward when not
supported in hardware and when no higher priority exception occurred -
has its own problems.

* It gets called in some cases even for the instructions rounding to
  zero, and then acts according to the current rounding mode when it
  should just leave alone the truncated result provided by hardware.

* It presumes that the result is a single-precision, double-precision
  or single-precision vector as appropriate for the instruction type,
  determines the sign of the result accordingly, and then adjusts the
  result based on that sign and the rounding mode.

  - In the single-precision cases at least the sign determination for
    an integer result is the same as for a floating-point result; in
    the double-precision case, converted to 32-bit integer or fixed
    point, the sign of a double-precision value is in the high part of
    the register but it's the low part of the register that has the
    result of the conversion.

  - If the result is unsigned fixed-point, its sign may be wrongly
    determined as negative (does not actually cause problems, because
    inexact unsigned fixed-point results with the high bit set can
    only appear when converting from double, in which case the sign
    determination is instead wrongly using the high part of the
    register).

  - If the sign of the result is correctly determined as negative, any
    adjustment required to change the truncated result to one correct
    for the rounding mode should be in the opposite direction for
    two's-complement integers as for sign-magnitude floating-point
    values.

  - And if the integer result is zero, the correct sign can only be
    determined by examining the original operand, and not at all (as
    far as I can tell) if the operand and result are the same
    register.

This patch fixes all these problems (as far as possible, given the
inability to determine the correct sign in the rounding handler when
the truncated result is 0, the conversion is to a signed type and the
truncated result has overwritten the original operand).  Conversion to
fixed-point now uses full emulation, and does not use "asm" in the
vector case; the semantics are exactly those of converting to integer
according to the current rounding direction, once the exponent has
been adjusted, so the code makes such an adjustment then uses the
FP_TO_INT_ROUND macros.

The testcase I used for verifying that the instructions (other than
the theoretical conversions to 64-bit integers) produce the correct
results is at <http://lkml.org/lkml/2013/10/8/708>.

Signed-off-by: Joseph Myers <joseph@codesourcery.com>

---

Previous submission: <http://lkml.org/lkml/2013/10/8/705>.

diff --git a/arch/powerpc/math-emu/math_efp.c b/arch/powerpc/math-emu/math_efp.c
index ecdf35d..01a0abb 100644
--- a/arch/powerpc/math-emu/math_efp.c
+++ b/arch/powerpc/math-emu/math_efp.c
@@ -275,21 +275,13 @@ int do_spe_mathemu(struct pt_regs *regs)
 
 		case EFSCTSF:
 		case EFSCTUF:
-			if (!((vb.wp[1] >> 23) == 0xff && ((vb.wp[1] & 0x7fffff) > 0))) {
-				/* NaN */
-				if (((vb.wp[1] >> 23) & 0xff) == 0) {
-					/* denorm */
-					vc.wp[1] = 0x0;
-				} else if ((vb.wp[1] >> 31) == 0) {
-					/* positive normal */
-					vc.wp[1] = (func == EFSCTSF) ?
-						0x7fffffff : 0xffffffff;
-				} else { /* negative normal */
-					vc.wp[1] = (func == EFSCTSF) ?
-						0x80000000 : 0x0;
-				}
-			} else { /* rB is NaN */
-				vc.wp[1] = 0x0;
+			if (SB_c == FP_CLS_NAN) {
+				vc.wp[1] = 0;
+				FP_SET_EXCEPTION(FP_EX_INVALID);
+			} else {
+				SB_e += (func == EFSCTSF ? 31 : 32);
+				FP_TO_INT_ROUND_S(vc.wp[1], SB, 32,
+						(func == EFSCTSF));
 			}
 			goto update_regs;
 
@@ -306,16 +298,25 @@ int do_spe_mathemu(struct pt_regs *regs)
 		}
 
 		case EFSCTSI:
-		case EFSCTSIZ:
 		case EFSCTUI:
+			if (SB_c == FP_CLS_NAN) {
+				vc.wp[1] = 0;
+				FP_SET_EXCEPTION(FP_EX_INVALID);
+			} else {
+				FP_TO_INT_ROUND_S(vc.wp[1], SB, 32,
+						((func & 0x3) != 0));
+			}
+			goto update_regs;
+
+		case EFSCTSIZ:
 		case EFSCTUIZ:
-			if (func & 0x4) {
-				_FP_ROUND(1, SB);
+			if (SB_c == FP_CLS_NAN) {
+				vc.wp[1] = 0;
+				FP_SET_EXCEPTION(FP_EX_INVALID);
 			} else {
-				_FP_ROUND_ZERO(1, SB);
+				FP_TO_INT_S(vc.wp[1], SB, 32,
+						((func & 0x3) != 0));
 			}
-			FP_TO_INT_S(vc.wp[1], SB, 32,
-					(((func & 0x3) != 0) || SB_s));
 			goto update_regs;
 
 		default:
@@ -404,22 +405,13 @@ cmp_s:
 
 		case EFDCTSF:
 		case EFDCTUF:
-			if (!((vb.wp[0] >> 20) == 0x7ff &&
-			   ((vb.wp[0] & 0xfffff) > 0 || (vb.wp[1] > 0)))) {
-				/* not a NaN */
-				if (((vb.wp[0] >> 20) & 0x7ff) == 0) {
-					/* denorm */
-					vc.wp[1] = 0x0;
-				} else if ((vb.wp[0] >> 31) == 0) {
-					/* positive normal */
-					vc.wp[1] = (func == EFDCTSF) ?
-						0x7fffffff : 0xffffffff;
-				} else { /* negative normal */
-					vc.wp[1] = (func == EFDCTSF) ?
-						0x80000000 : 0x0;
-				}
-			} else { /* NaN */
-				vc.wp[1] = 0x0;
+			if (DB_c == FP_CLS_NAN) {
+				vc.wp[1] = 0;
+				FP_SET_EXCEPTION(FP_EX_INVALID);
+			} else {
+				DB_e += (func == EFDCTSF ? 31 : 32);
+				FP_TO_INT_ROUND_D(vc.wp[1], DB, 32,
+						(func == EFDCTSF));
 			}
 			goto update_regs;
 
@@ -437,21 +429,35 @@ cmp_s:
 
 		case EFDCTUIDZ:
 		case EFDCTSIDZ:
-			_FP_ROUND_ZERO(2, DB);
-			FP_TO_INT_D(vc.dp[0], DB, 64, ((func & 0x1) == 0));
+			if (DB_c == FP_CLS_NAN) {
+				vc.dp[0] = 0;
+				FP_SET_EXCEPTION(FP_EX_INVALID);
+			} else {
+				FP_TO_INT_D(vc.dp[0], DB, 64,
+						((func & 0x1) == 0));
+			}
 			goto update_regs;
 
 		case EFDCTUI:
 		case EFDCTSI:
+			if (DB_c == FP_CLS_NAN) {
+				vc.wp[1] = 0;
+				FP_SET_EXCEPTION(FP_EX_INVALID);
+			} else {
+				FP_TO_INT_ROUND_D(vc.wp[1], DB, 32,
+						((func & 0x3) != 0));
+			}
+			goto update_regs;
+
 		case EFDCTUIZ:
 		case EFDCTSIZ:
-			if (func & 0x4) {
-				_FP_ROUND(2, DB);
+			if (DB_c == FP_CLS_NAN) {
+				vc.wp[1] = 0;
+				FP_SET_EXCEPTION(FP_EX_INVALID);
 			} else {
-				_FP_ROUND_ZERO(2, DB);
+				FP_TO_INT_D(vc.wp[1], DB, 32,
+						((func & 0x3) != 0));
 			}
-			FP_TO_INT_D(vc.wp[1], DB, 32,
-					(((func & 0x3) != 0) || DB_s));
 			goto update_regs;
 
 		default:
@@ -556,37 +562,60 @@ cmp_d:
 			cmp = -1;
 			goto cmp_vs;
 
-		case EVFSCTSF:
-			__asm__ __volatile__ ("mtspr 512, %4\n"
-				"efsctsf %0, %2\n"
-				"efsctsf %1, %3\n"
-				: "=r" (vc.wp[0]), "=r" (vc.wp[1])
-				: "r" (vb.wp[0]), "r" (vb.wp[1]), "r" (0));
-			goto update_regs;
-
 		case EVFSCTUF:
-			__asm__ __volatile__ ("mtspr 512, %4\n"
-				"efsctuf %0, %2\n"
-				"efsctuf %1, %3\n"
-				: "=r" (vc.wp[0]), "=r" (vc.wp[1])
-				: "r" (vb.wp[0]), "r" (vb.wp[1]), "r" (0));
+		case EVFSCTSF:
+			if (SB0_c == FP_CLS_NAN) {
+				vc.wp[0] = 0;
+				FP_SET_EXCEPTION(FP_EX_INVALID);
+			} else {
+				SB0_e += (func == EVFSCTSF ? 31 : 32);
+				FP_TO_INT_ROUND_S(vc.wp[0], SB0, 32,
+						(func == EVFSCTSF));
+			}
+			if (SB1_c == FP_CLS_NAN) {
+				vc.wp[1] = 0;
+				FP_SET_EXCEPTION(FP_EX_INVALID);
+			} else {
+				SB1_e += (func == EVFSCTSF ? 31 : 32);
+				FP_TO_INT_ROUND_S(vc.wp[1], SB1, 32,
+						(func == EVFSCTSF));
+			}
 			goto update_regs;
 
 		case EVFSCTUI:
 		case EVFSCTSI:
+			if (SB0_c == FP_CLS_NAN) {
+				vc.wp[0] = 0;
+				FP_SET_EXCEPTION(FP_EX_INVALID);
+			} else {
+				FP_TO_INT_ROUND_S(vc.wp[0], SB0, 32,
+						((func & 0x3) != 0));
+			}
+			if (SB1_c == FP_CLS_NAN) {
+				vc.wp[1] = 0;
+				FP_SET_EXCEPTION(FP_EX_INVALID);
+			} else {
+				FP_TO_INT_ROUND_S(vc.wp[1], SB1, 32,
+						((func & 0x3) != 0));
+			}
+			goto update_regs;
+
 		case EVFSCTUIZ:
 		case EVFSCTSIZ:
-			if (func & 0x4) {
-				_FP_ROUND(1, SB0);
-				_FP_ROUND(1, SB1);
+			if (SB0_c == FP_CLS_NAN) {
+				vc.wp[0] = 0;
+				FP_SET_EXCEPTION(FP_EX_INVALID);
 			} else {
-				_FP_ROUND_ZERO(1, SB0);
-				_FP_ROUND_ZERO(1, SB1);
+				FP_TO_INT_S(vc.wp[0], SB0, 32,
+						((func & 0x3) != 0));
+			}
+			if (SB1_c == FP_CLS_NAN) {
+				vc.wp[1] = 0;
+				FP_SET_EXCEPTION(FP_EX_INVALID);
+			} else {
+				FP_TO_INT_S(vc.wp[1], SB1, 32,
+						((func & 0x3) != 0));
 			}
-			FP_TO_INT_S(vc.wp[0], SB0, 32,
-					(((func & 0x3) != 0) || SB0_s));
-			FP_TO_INT_S(vc.wp[1], SB1, 32,
-					(((func & 0x3) != 0) || SB1_s));
 			goto update_regs;
 
 		default:
@@ -681,14 +710,16 @@ int speround_handler(struct pt_regs *regs)
 	union dw_union fgpr;
 	int s_lo, s_hi;
 	int lo_inexact, hi_inexact;
-	unsigned long speinsn, type, fc, fptype;
+	int fp_result;
+	unsigned long speinsn, type, fb, fc, fptype, func;
 
 	if (get_user(speinsn, (unsigned int __user *) regs->nip))
 		return -EFAULT;
 	if ((speinsn >> 26) != 4)
 		return -EINVAL;         /* not an spe instruction */
 
-	type = insn_type(speinsn & 0x7ff);
+	func = speinsn & 0x7ff;
+	type = insn_type(func);
 	if (type == XCR) return -ENOSYS;
 
 	__FPU_FPSCR = mfspr(SPRN_SPEFSCR);
@@ -708,6 +739,65 @@ int speround_handler(struct pt_regs *regs)
 	fgpr.wp[0] = current->thread.evr[fc];
 	fgpr.wp[1] = regs->gpr[fc];
 
+	fb = (speinsn >> 11) & 0x1f;
+	switch (func) {
+	case EFSCTUIZ:
+	case EFSCTSIZ:
+	case EVFSCTUIZ:
+	case EVFSCTSIZ:
+	case EFDCTUIDZ:
+	case EFDCTSIDZ:
+	case EFDCTUIZ:
+	case EFDCTSIZ:
+		/*
+		 * These instructions always round to zero,
+		 * independent of the rounding mode.
+		 */
+		return 0;
+
+	case EFSCTUI:
+	case EFSCTUF:
+	case EVFSCTUI:
+	case EVFSCTUF:
+	case EFDCTUI:
+	case EFDCTUF:
+		fp_result = 0;
+		s_lo = 0;
+		s_hi = 0;
+		break;
+
+	case EFSCTSI:
+	case EFSCTSF:
+		fp_result = 0;
+		/* Recover the sign of a zero result if possible.  */
+		if (fgpr.wp[1] == 0)
+			s_lo = regs->gpr[fb] & SIGN_BIT_S;
+		break;
+
+	case EVFSCTSI:
+	case EVFSCTSF:
+		fp_result = 0;
+		/* Recover the sign of a zero result if possible.  */
+		if (fgpr.wp[1] == 0)
+			s_lo = regs->gpr[fb] & SIGN_BIT_S;
+		if (fgpr.wp[0] == 0)
+			s_hi = current->thread.evr[fb] & SIGN_BIT_S;
+		break;
+
+	case EFDCTSI:
+	case EFDCTSF:
+		fp_result = 0;
+		s_hi = s_lo;
+		/* Recover the sign of a zero result if possible.  */
+		if (fgpr.wp[1] == 0)
+			s_hi = current->thread.evr[fb] & SIGN_BIT_S;
+		break;
+
+	default:
+		fp_result = 1;
+		break;
+	}
+
 	pr_debug("round fgpr: %08x  %08x\n", fgpr.wp[0], fgpr.wp[1]);
 
 	switch (fptype) {
@@ -719,15 +809,30 @@ int speround_handler(struct pt_regs *regs)
 		if ((FP_ROUNDMODE) == FP_RND_PINF) {
 			if (!s_lo) fgpr.wp[1]++; /* Z > 0, choose Z1 */
 		} else { /* round to -Inf */
-			if (s_lo) fgpr.wp[1]++; /* Z < 0, choose Z2 */
+			if (s_lo) {
+				if (fp_result)
+					fgpr.wp[1]++; /* Z < 0, choose Z2 */
+				else
+					fgpr.wp[1]--; /* Z < 0, choose Z2 */
+			}
 		}
 		break;
 
 	case DPFP:
 		if (FP_ROUNDMODE == FP_RND_PINF) {
-			if (!s_hi) fgpr.dp[0]++; /* Z > 0, choose Z1 */
+			if (!s_hi) {
+				if (fp_result)
+					fgpr.dp[0]++; /* Z > 0, choose Z1 */
+				else
+					fgpr.wp[1]++; /* Z > 0, choose Z1 */
+			}
 		} else { /* round to -Inf */
-			if (s_hi) fgpr.dp[0]++; /* Z < 0, choose Z2 */
+			if (s_hi) {
+				if (fp_result)
+					fgpr.dp[0]++; /* Z < 0, choose Z2 */
+				else
+					fgpr.wp[1]--; /* Z < 0, choose Z2 */
+			}
 		}
 		break;
 
@@ -738,10 +843,18 @@ int speround_handler(struct pt_regs *regs)
 			if (hi_inexact && !s_hi)
 				fgpr.wp[0]++; /* Z_high word > 0, choose Z1 */
 		} else { /* round to -Inf */
-			if (lo_inexact && s_lo)
-				fgpr.wp[1]++; /* Z_low < 0, choose Z2 */
-			if (hi_inexact && s_hi)
-				fgpr.wp[0]++; /* Z_high < 0, choose Z2 */
+			if (lo_inexact && s_lo) {
+				if (fp_result)
+					fgpr.wp[1]++; /* Z_low < 0, choose Z2 */
+				else
+					fgpr.wp[1]--; /* Z_low < 0, choose Z2 */
+			}
+			if (hi_inexact && s_hi) {
+				if (fp_result)
+					fgpr.wp[0]++; /* Z_high < 0, choose Z2 */
+				else
+					fgpr.wp[0]--; /* Z_high < 0, choose Z2 */
+			}
 		}
 		break;
 

-- 
Joseph S. Myers
joseph@codesourcery.com
