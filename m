Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751237Ab3LJXHx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 18:07:53 -0500
Received: from relay1.mentorg.com ([192.94.38.131]:62561 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061Ab3LJXHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 18:07:52 -0500
Date: Tue, 10 Dec 2013 23:07:45 +0000
From: "Joseph S. Myers" <joseph@codesourcery.com>
X-X-Sender: jsm28@digraph.polyomino.org.uk
To: Scott Wood <scottwood@freescale.com>
CC: <linuxppc-dev@lists.ozlabs.org>, Liu Yu <yu.liu@freescale.com>,
        <linux-kernel@vger.kernel.org>, Shan Hai <shan.hai@windriver.com>
Subject: [PATCHv2 1/6] powerpc: fix exception clearing in e500 SPE float
 emulation
In-Reply-To: <1386376365.7375.209.camel@snotra.buserror.net>
Message-ID: <Pine.LNX.4.64.1312102305570.23521@digraph.polyomino.org.uk>
References: <Pine.LNX.4.64.1311041649250.4290@digraph.polyomino.org.uk> 
 <Pine.LNX.4.64.1311041651390.4290@digraph.polyomino.org.uk> 
 <1385159644.1403.532.camel@snotra.buserror.net> 
 <Pine.LNX.4.64.1311230053360.12354@digraph.polyomino.org.uk>
 <1386376365.7375.209.camel@snotra.buserror.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-OriginalArrivalTime: 10 Dec 2013 23:07:50.0112 (UTC) FILETIME=[A5B6FE00:01CEF5FC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joseph Myers <joseph@codesourcery.com>

The e500 SPE floating-point emulation code clears existing exceptions
(__FPU_FPSCR &= ~FP_EX_MASK;) before ORing in the exceptions from the
emulated operation.  However, these exception bits are the "sticky",
cumulative exception bits, and should only be cleared by the user
program setting SPEFSCR, not implicitly by any floating-point
instruction (whether executed purely by the hardware or emulated).
The spurious clearing of these bits shows up as missing exceptions in
glibc testing.

Fixing this, however, is not as simple as just not clearing the bits,
because while the bits may be from previous floating-point operations
(in which case they should not be cleared), the processor can also set
the sticky bits itself before the interrupt for an exception occurs,
and this can happen in cases when IEEE 754 semantics are that the
sticky bit should not be set.  Specifically, the "invalid" sticky bit
is set in various cases with non-finite operands, where IEEE 754
semantics do not involve raising such an exception, and the
"underflow" sticky bit is set in cases of exact underflow, whereas
IEEE 754 semantics are that this flag is set only for inexact
underflow.  Thus, for correct emulation the kernel needs to know the
setting of these two sticky bits before the instruction being
emulated.

When a floating-point operation raises an exception, the kernel can
note the state of the sticky bits immediately afterwards.  Some
<fenv.h> functions that affect the state of these bits, such as
fesetenv and feholdexcept, need to use prctl with PR_GET_FPEXC and
PR_SET_FPEXC anyway, and so it is natural to record the state of those
bits during that call into the kernel and so avoid any need for a
separate call into the kernel to inform it of a change to those bits.
Thus, the interface I chose to use (in this patch and the glibc port)
is that one of those prctl calls must be made after any userspace
change to those sticky bits, other than through a floating-point
operation that traps into the kernel anyway.  feclearexcept and
fesetexceptflag duly make those calls, which would not be required
were it not for this issue.

The previous EGLIBC port, and the uClibc code copied from it, is
fundamentally broken as regards any use of prctl for floating-point
exceptions because it didn't use the PR_FP_EXC_SW_ENABLE bit in its
prctl calls (and did various worse things, such as passing a pointer
when prctl expected an integer).  If you avoid anything where prctl is
used, the clearing of sticky bits still means it will never give
anything approximating correct exception semantics with existing
kernels.  I don't believe the patch makes things any worse for
existing code that doesn't try to inform the kernel of changes to
sticky bits - such code may get incorrect exceptions in some cases,
but it would have done so anyway in other cases.

Signed-off-by: Joseph Myers <joseph@codesourcery.com>

---

> OK -- please mention this in the changelog.

The description of brokenness of existing code attempting to use
floating-point exceptions on e500 is now included above.

> I don't know of a formal place for it, but there should at least be a
> code comment somewhere.

This version now adds a comment alongside the relevant settings of
spefscr_last.

The other patches in this series (2-6) remain independent of this one
(and as previously noted, with no dependencies except that patch 5
depends on patch 2) and so are not resent.

diff --git a/arch/powerpc/include/asm/processor.h b/arch/powerpc/include/asm/processor.h
index fc14a38..91441d9 100644
--- a/arch/powerpc/include/asm/processor.h
+++ b/arch/powerpc/include/asm/processor.h
@@ -256,6 +256,8 @@ struct thread_struct {
 	unsigned long	evr[32];	/* upper 32-bits of SPE regs */
 	u64		acc;		/* Accumulator */
 	unsigned long	spefscr;	/* SPE & eFP status */
+	unsigned long	spefscr_last;	/* SPEFSCR value on last prctl
+					   call or trap return */
 	int		used_spe;	/* set if process has used spe */
 #endif /* CONFIG_SPE */
 #ifdef CONFIG_PPC_TRANSACTIONAL_MEM
@@ -317,7 +319,9 @@ struct thread_struct {
 	(_ALIGN_UP(sizeof(init_thread_info), 16) + (unsigned long) &init_stack)
 
 #ifdef CONFIG_SPE
-#define SPEFSCR_INIT .spefscr = SPEFSCR_FINVE | SPEFSCR_FDBZE | SPEFSCR_FUNFE | SPEFSCR_FOVFE,
+#define SPEFSCR_INIT \
+	.spefscr = SPEFSCR_FINVE | SPEFSCR_FDBZE | SPEFSCR_FUNFE | SPEFSCR_FOVFE, \
+	.spefscr_last = SPEFSCR_FINVE | SPEFSCR_FDBZE | SPEFSCR_FUNFE | SPEFSCR_FOVFE,
 #else
 #define SPEFSCR_INIT
 #endif
diff --git a/arch/powerpc/kernel/process.c b/arch/powerpc/kernel/process.c
index 3386d8a..b08c0d0 100644
--- a/arch/powerpc/kernel/process.c
+++ b/arch/powerpc/kernel/process.c
@@ -1175,6 +1175,19 @@ int set_fpexc_mode(struct task_struct *tsk, unsigned int val)
 	if (val & PR_FP_EXC_SW_ENABLE) {
 #ifdef CONFIG_SPE
 		if (cpu_has_feature(CPU_FTR_SPE)) {
+			/*
+			 * When the sticky exception bits are set
+			 * directly by userspace, it must call prctl
+			 * with PR_GET_FPEXC (with PR_FP_EXC_SW_ENABLE
+			 * in the existing prctl settings) or
+			 * PR_SET_FPEXC (with PR_FP_EXC_SW_ENABLE in
+			 * the bits being set).  <fenv.h> functions
+			 * saving and restoring the whole
+			 * floating-point environment need to do so
+			 * anyway to restore the prctl settings from
+			 * the saved environment.
+			 */
+			tsk->thread.spefscr_last = mfspr(SPRN_SPEFSCR);
 			tsk->thread.fpexc_mode = val &
 				(PR_FP_EXC_SW_ENABLE | PR_FP_ALL_EXCEPT);
 			return 0;
@@ -1206,9 +1219,22 @@ int get_fpexc_mode(struct task_struct *tsk, unsigned long adr)
 
 	if (tsk->thread.fpexc_mode & PR_FP_EXC_SW_ENABLE)
 #ifdef CONFIG_SPE
-		if (cpu_has_feature(CPU_FTR_SPE))
+		if (cpu_has_feature(CPU_FTR_SPE)) {
+			/*
+			 * When the sticky exception bits are set
+			 * directly by userspace, it must call prctl
+			 * with PR_GET_FPEXC (with PR_FP_EXC_SW_ENABLE
+			 * in the existing prctl settings) or
+			 * PR_SET_FPEXC (with PR_FP_EXC_SW_ENABLE in
+			 * the bits being set).  <fenv.h> functions
+			 * saving and restoring the whole
+			 * floating-point environment need to do so
+			 * anyway to restore the prctl settings from
+			 * the saved environment.
+			 */
+			tsk->thread.spefscr_last = mfspr(SPRN_SPEFSCR);
 			val = tsk->thread.fpexc_mode;
-		else
+		} else
 			return -EINVAL;
 #else
 		return -EINVAL;
diff --git a/arch/powerpc/math-emu/math_efp.c b/arch/powerpc/math-emu/math_efp.c
index a73f088..59835c6 100644
--- a/arch/powerpc/math-emu/math_efp.c
+++ b/arch/powerpc/math-emu/math_efp.c
@@ -630,9 +630,27 @@ update_ccr:
 	regs->ccr |= (IR << ((7 - ((speinsn >> 23) & 0x7)) << 2));
 
 update_regs:
-	__FPU_FPSCR &= ~FP_EX_MASK;
+	/*
+	 * If the "invalid" exception sticky bit was set by the
+	 * processor for non-finite input, but was not set before the
+	 * instruction being emulated, clear it.  Likewise for the
+	 * "underflow" bit, which may have been set by the processor
+	 * for exact underflow, not just inexact underflow when the
+	 * flag should be set for IEEE 754 semantics.  Other sticky
+	 * exceptions will only be set by the processor when they are
+	 * correct according to IEEE 754 semantics, and we must not
+	 * clear sticky bits that were already set before the emulated
+	 * instruction as they represent the user-visible sticky
+	 * exception status.  "inexact" traps to kernel are not
+	 * required for IEEE semantics and are not enabled by default,
+	 * so the "inexact" sticky bit may have been set by a previous
+	 * instruction without the kernel being aware of it.
+	 */
+	__FPU_FPSCR
+	  &= ~(FP_EX_INVALID | FP_EX_UNDERFLOW) | current->thread.spefscr_last;
 	__FPU_FPSCR |= (FP_CUR_EXCEPTIONS & FP_EX_MASK);
 	mtspr(SPRN_SPEFSCR, __FPU_FPSCR);
+	current->thread.spefscr_last = __FPU_FPSCR;
 
 	current->thread.evr[fc] = vc.wp[0];
 	regs->gpr[fc] = vc.wp[1];


-- 
Joseph S. Myers
joseph@codesourcery.com
