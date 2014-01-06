Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753059AbaAFIXG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 03:23:06 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:54347 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218AbaAFIWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 03:22:36 -0500
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: catalin.marinas@arm.com, will.deacon@arm.com, gregkh@linuxfoundation.org,
        akpm@linux-foundation.org, hpa@zytor.com, ak@linux.intel.com
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        herbert@gondor.apana.org.au, mingo@redhat.com, nico@linaro.org,
        x86@kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 7/8] arm64: add support for kernel mode NEON in atomic context
Date: Mon,  6 Jan 2014 09:22:15 +0100
Message-Id: <1388996536-27014-8-git-send-email-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1388996536-27014-1-git-send-email-ard.biesheuvel@linaro.org>
References: <1388996536-27014-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch modifies kernel_neon_begin() and kernel_neon_end(), so
they may be called from any context. To address the case where only
a couple of registers are needed, kernel_neon_begin_partial(u32) is
introduced which takes as a parameter the number of bottom 'n' NEON
q-registers required. To mark the end of such a partial section, the
regular kernel_neon_end() should be used.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/include/asm/fpsimd.h       | 17 ++++++++++++++
 arch/arm64/include/asm/fpsimdmacros.h | 37 ++++++++++++++++++++++++++++++
 arch/arm64/include/asm/neon.h         |  6 ++++-
 arch/arm64/kernel/entry-fpsimd.S      | 24 +++++++++++++++++++
 arch/arm64/kernel/fpsimd.c            | 43 +++++++++++++++++++++++------------
 5 files changed, 111 insertions(+), 16 deletions(-)

diff --git a/arch/arm64/include/asm/fpsimd.h b/arch/arm64/include/asm/fpsimd.h
index 609bc44ceb8d..dc9ef741c648 100644
--- a/arch/arm64/include/asm/fpsimd.h
+++ b/arch/arm64/include/asm/fpsimd.h
@@ -41,6 +41,19 @@ struct fpsimd_state {
 	unsigned int last_cpu;
 };
 
+/*
+ * Struct for stacking the bottom 'n' FP/SIMD registers.
+ * Mainly intended for kernel use of v8 Crypto Extensions which only
+ * needs a few registers and may need to execute in atomic context.
+ */
+struct fpsimd_partial_state {
+	u32		num_regs;
+	u32		fpsr;
+	u32		fpcr;
+	__uint128_t	vregs[32] __aligned(16);
+} __aligned(16);
+
+
 #if defined(__KERNEL__) && defined(CONFIG_COMPAT)
 /* Masks for extracting the FPSR and FPCR from the FPSCR */
 #define VFP_FPSCR_STAT_MASK	0xf800009f
@@ -57,6 +70,10 @@ struct task_struct;
 extern void fpsimd_save_state(struct fpsimd_state *state);
 extern void fpsimd_load_state(struct fpsimd_state *state);
 
+extern void fpsimd_save_partial_state(struct fpsimd_partial_state *state,
+				      u32 num_regs);
+extern void fpsimd_load_partial_state(struct fpsimd_partial_state *state);
+
 extern void fpsimd_thread_switch(struct task_struct *next);
 extern void fpsimd_flush_thread(void);
 extern void fpsimd_reload_fpstate(void);
diff --git a/arch/arm64/include/asm/fpsimdmacros.h b/arch/arm64/include/asm/fpsimdmacros.h
index bbec599c96bd..42990a82c671 100644
--- a/arch/arm64/include/asm/fpsimdmacros.h
+++ b/arch/arm64/include/asm/fpsimdmacros.h
@@ -62,3 +62,40 @@
 	ldr	w\tmpnr, [\state, #16 * 2 + 4]
 	msr	fpcr, x\tmpnr
 .endm
+
+.altmacro
+.macro	q2op, op, q1, q2, state
+	\op	q\q1, q\q2, [\state, # -16 * \q1 - 16]
+.endm
+
+.macro fpsimd_save_partial state, numnr, tmpnr1, tmpnr2
+	mrs	x\tmpnr1, fpsr
+	str	w\numnr, [\state]
+	mrs	x\tmpnr2, fpcr
+	stp	w\tmpnr1, w\tmpnr2, [\state, #4]
+	adr	x\tmpnr1, 0f
+	add	\state, \state, x\numnr, lsl #4
+	sub	x\tmpnr1, x\tmpnr1, x\numnr, lsl #1
+	br	x\tmpnr1
+	.irp	qa, 30, 28, 26, 24, 22, 20, 18, 16, 14, 12, 10, 8, 6, 4, 2, 0
+		qb = \qa + 1
+	q2op	stp, \qa, %qb, \state
+	.endr
+0:
+.endm
+
+.macro fpsimd_restore_partial state, tmpnr1, tmpnr2
+	ldp	w\tmpnr1, w\tmpnr2, [\state, #4]
+	msr	fpsr, x\tmpnr1
+	msr	fpcr, x\tmpnr2
+	adr	x\tmpnr1, 0f
+	ldr	w\tmpnr2, [\state]
+	add	\state, \state, x\tmpnr2, lsl #4
+	sub	x\tmpnr1, x\tmpnr1, x\tmpnr2, lsl #1
+	br	x\tmpnr1
+	.irp	qa, 30, 28, 26, 24, 22, 20, 18, 16, 14, 12, 10, 8, 6, 4, 2, 0
+		qb = \qa + 1
+	q2op	ldp, \qa, %qb, \state
+	.endr
+0:
+.endm
diff --git a/arch/arm64/include/asm/neon.h b/arch/arm64/include/asm/neon.h
index b0cc58a97780..21a9e35655b7 100644
--- a/arch/arm64/include/asm/neon.h
+++ b/arch/arm64/include/asm/neon.h
@@ -8,7 +8,11 @@
  * published by the Free Software Foundation.
  */
 
+#include <linux/types.h>
+
 #define cpu_has_neon()		(1)
 
-void kernel_neon_begin(void);
+#define kernel_neon_begin() 	kernel_neon_begin_partial(32)
+
+void kernel_neon_begin_partial(u32 num_regs);
 void kernel_neon_end(void);
diff --git a/arch/arm64/kernel/entry-fpsimd.S b/arch/arm64/kernel/entry-fpsimd.S
index 6a27cd6dbfa6..d358ccacfc00 100644
--- a/arch/arm64/kernel/entry-fpsimd.S
+++ b/arch/arm64/kernel/entry-fpsimd.S
@@ -41,3 +41,27 @@ ENTRY(fpsimd_load_state)
 	fpsimd_restore x0, 8
 	ret
 ENDPROC(fpsimd_load_state)
+
+#ifdef CONFIG_KERNEL_MODE_NEON
+
+/*
+ * Save the bottom n FP registers.
+ *
+ * x0 - pointer to struct fpsimd_partial_state
+ */
+ENTRY(fpsimd_save_partial_state)
+	fpsimd_save_partial x0, 1, 8, 9
+	ret
+ENDPROC(fpsimd_load_partial_state)
+
+/*
+ * Load the bottom n FP registers.
+ *
+ * x0 - pointer to struct fpsimd_partial_state
+ */
+ENTRY(fpsimd_load_partial_state)
+	fpsimd_restore_partial x0, 8, 9
+	ret
+ENDPROC(fpsimd_load_partial_state)
+
+#endif
diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index 5b13c17e799f..ac105da56c8c 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -143,30 +143,43 @@ void fpsimd_reload_fpstate(void)
 
 #ifdef CONFIG_KERNEL_MODE_NEON
 
+static DEFINE_PER_CPU(struct fpsimd_partial_state, hardirq_fpsimdstate);
+static DEFINE_PER_CPU(struct fpsimd_partial_state, softirq_fpsimdstate);
+
 /*
  * Kernel-side NEON support functions
  */
-void kernel_neon_begin(void)
+void kernel_neon_begin_partial(u32 num_regs)
 {
-	/* Avoid using the NEON in interrupt context */
-	BUG_ON(in_interrupt());
-	preempt_disable();
-
-	/*
-	 * Save the userland FPSIMD state if we have one and if we haven't done
-	 * so already. Clear fpsimd_last_cpu to indicate that there is no
-	 * longer userland context in the registers.
-	 */
-	if (current->mm && !test_and_set_thread_flag(TIF_FOREIGN_FPSTATE))
-		fpsimd_save_state(&current->thread.fpsimd_state);
-	__get_cpu_var(fpsimd_last_cpu) = NULL;
+	if (in_interrupt()) {
+		struct fpsimd_partial_state *s = this_cpu_ptr(
+			in_irq() ? &hardirq_fpsimdstate : &softirq_fpsimdstate);
 
+		BUG_ON(num_regs > 32);
+		fpsimd_save_partial_state(s, roundup(num_regs, 2));
+	} else {
+		/*
+		 * Save the userland FPSIMD state if we have one and if we
+		 * haven't done so already. Clear fpsimd_last_cpu to indicate
+		 * that there is no longer userland context in the registers.
+		 */
+		preempt_disable();
+		if (current->mm &&
+		    !test_and_set_thread_flag(TIF_FOREIGN_FPSTATE))
+			fpsimd_save_state(&current->thread.fpsimd_state);
+		__get_cpu_var(fpsimd_last_cpu) = NULL;
+	}
 }
-EXPORT_SYMBOL(kernel_neon_begin);
+EXPORT_SYMBOL(kernel_neon_begin_partial);
 
 void kernel_neon_end(void)
 {
-	preempt_enable();
+	if (in_interrupt()) {
+		struct fpsimd_partial_state *s = this_cpu_ptr(
+			in_irq() ? &hardirq_fpsimdstate : &softirq_fpsimdstate);
+		fpsimd_load_partial_state(s);
+	} else
+		preempt_enable();
 }
 EXPORT_SYMBOL(kernel_neon_end);
 
-- 
1.8.3.2

