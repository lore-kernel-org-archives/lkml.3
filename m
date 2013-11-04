Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752012Ab3KDQwS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 11:52:18 -0500
Received: from relay1.mentorg.com ([192.94.38.131]:37866 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719Ab3KDQwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 11:52:17 -0500
Date: Mon, 4 Nov 2013 16:52:11 +0000
From: "Joseph S. Myers" <joseph@codesourcery.com>
X-X-Sender: jsm28@digraph.polyomino.org.uk
To: <linuxppc-dev@lists.ozlabs.org>
CC: <linux-kernel@vger.kernel.org>, Liu Yu <yu.liu@freescale.com>,
        Kumar Gala <galak@kernel.crashing.org>,
        Shan Hai <shan.hai@windriver.com>
Subject: [PATCH 1/6] powerpc: fix exception clearing in e500 SPE float
 emulation
In-Reply-To: <Pine.LNX.4.64.1311041649250.4290@digraph.polyomino.org.uk>
Message-ID: <Pine.LNX.4.64.1311041651390.4290@digraph.polyomino.org.uk>
References: <Pine.LNX.4.64.1311041649250.4290@digraph.polyomino.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-OriginalArrivalTime: 04 Nov 2013 16:52:16.0421 (UTC) FILETIME=[37B79D50:01CED97E]
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

Signed-off-by: Joseph Myers <joseph@codesourcery.com>

---

Previous submission: <http://lkml.org/lkml/2013/10/4/495>.

diff --git a/arch/powerpc/include/asm/processor.h b/arch/powerpc/include/asm/processor.h
index ce4de5a..0b02e23 100644
--- a/arch/powerpc/include/asm/processor.h
+++ b/arch/powerpc/include/asm/processor.h
@@ -237,6 +237,8 @@ struct thread_struct {
 	unsigned long	evr[32];	/* upper 32-bits of SPE regs */
 	u64		acc;		/* Accumulator */
 	unsigned long	spefscr;	/* SPE & eFP status */
+	unsigned long	spefscr_last;	/* SPEFSCR value on last prctl
+					   call or trap return */
 	int		used_spe;	/* set if process has used spe */
 #endif /* CONFIG_SPE */
 #ifdef CONFIG_PPC_TRANSACTIONAL_MEM
@@ -303,7 +305,9 @@ struct thread_struct {
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
index 96d2fdf..e3b91f1 100644
--- a/arch/powerpc/kernel/process.c
+++ b/arch/powerpc/kernel/process.c
@@ -1151,6 +1151,7 @@ int set_fpexc_mode(struct task_struct *tsk, unsigned int val)
 	if (val & PR_FP_EXC_SW_ENABLE) {
 #ifdef CONFIG_SPE
 		if (cpu_has_feature(CPU_FTR_SPE)) {
+			tsk->thread.spefscr_last = mfspr(SPRN_SPEFSCR);
 			tsk->thread.fpexc_mode = val &
 				(PR_FP_EXC_SW_ENABLE | PR_FP_ALL_EXCEPT);
 			return 0;
@@ -1182,9 +1183,10 @@ int get_fpexc_mode(struct task_struct *tsk, unsigned long adr)
 
 	if (tsk->thread.fpexc_mode & PR_FP_EXC_SW_ENABLE)
 #ifdef CONFIG_SPE
-		if (cpu_has_feature(CPU_FTR_SPE))
+		if (cpu_has_feature(CPU_FTR_SPE)) {
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
