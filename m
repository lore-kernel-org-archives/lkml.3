Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753340Ab3I0IIs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 04:08:48 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:59010 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852Ab3I0IIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 04:08:44 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Jiang Liu <jiang.liu@huawei.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christopher Covington <cov@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Jiang Liu <liuj97@gmail.com>
Subject: [RFT PATCH v1 3/7] arm64: implement basic lazy save and restore for FPSIMD registers
Date: Fri, 27 Sep 2013 16:04:43 +0800
Message-Id: <1380269087-8520-4-git-send-email-liuj97@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1380269087-8520-1-git-send-email-liuj97@gmail.com>
References: <1380269087-8520-1-git-send-email-liuj97@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <jiang.liu@huawei.com>

Implement basic lazy save and restore for FPSIMD registers, which only
restore FPSIMD state on demand and save FPSIMD state if it has been
loaded on to hardware.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Jiang Liu <liuj97@gmail.com>
---
 arch/arm64/include/asm/fpsimd.h |  17 ++---
 arch/arm64/kernel/fpsimd.c      | 150 ++++++++++++++++++++++++++++++++++++++--
 arch/arm64/kernel/process.c     |   4 +-
 arch/arm64/kernel/signal.c      |  13 ++--
 arch/arm64/kernel/signal32.c    |  13 ++--
 5 files changed, 164 insertions(+), 33 deletions(-)

diff --git a/arch/arm64/include/asm/fpsimd.h b/arch/arm64/include/asm/fpsimd.h
index 4c2bc80..725b225 100644
--- a/arch/arm64/include/asm/fpsimd.h
+++ b/arch/arm64/include/asm/fpsimd.h
@@ -35,6 +35,7 @@ struct fpsimd_state {
 			__uint128_t vregs[32];
 			u32 fpsr;
 			u32 fpcr;
+			bool on_hw;	/* soft state: whether loaded onto hw */
 		};
 	};
 };
@@ -54,21 +55,15 @@ struct fpsimd_state {
 
 struct task_struct;
 
-/* Clear FP status register, so it doesn't affect new FP context */
-static inline void fpsimd_init_hw_state(void)
-{
-	int val = AARCH64_FPCR_DEFAULT_VAL;
-
-	asm ("msr fpcr, %x0\n"
-	     "msr fpsr, xzr\n"
-             : : "r"(val));
-}
-
 extern void fpsimd_save_state(struct fpsimd_state *state);
 extern void fpsimd_load_state(struct fpsimd_state *state);
-
 extern void fpsimd_thread_switch(struct task_struct *next);
 extern void fpsimd_flush_thread(void);
+extern void fpsimd_dup_state(struct fpsimd_state *src,
+			     struct fpsimd_state *dst);
+extern void fpsimd_save_sigctx(struct fpsimd_state *state);
+extern void fpsimd_prepare_sigctx(struct fpsimd_state *ctx);
+extern void fpsimd_restore_sigctx(struct fpsimd_state *ctx);
 
 #endif
 
diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index 12a25e5..2208ba3 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -4,6 +4,8 @@
  * Copyright (C) 2012 ARM Ltd.
  * Author: Catalin Marinas <catalin.marinas@arm.com>
  *
+ * Copyright (C) Jiang Liu <jiang.liu@huawei.com>
+ *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
@@ -22,6 +24,7 @@
 #include <linux/sched.h>
 #include <linux/signal.h>
 #include <linux/hardirq.h>
+#include <linux/jump_label.h>
 
 #include <asm/fpsimd.h>
 #include <asm/cputype.h>
@@ -33,13 +36,91 @@
 #define FPEXC_IXF	(1 << 4)
 #define FPEXC_IDF	(1 << 7)
 
+static struct static_key fpsimd_lazy_mode = STATIC_KEY_INIT_FALSE;
+
+static inline void fpsimd_set_on_hw(struct fpsimd_state *state)
+{
+	state->on_hw = true;
+}
+
+static inline void fpsimd_clear_on_hw(struct fpsimd_state *state)
+{
+	state->on_hw = false;
+}
+
+static inline bool fpsimd_is_on_hw(struct fpsimd_state *state)
+{
+	return state->on_hw;
+}
+
+/* Clear FP status register, so it doesn't affect new FP context */
+static inline void fpsimd_init_hw_state(void)
+{
+	int val = AARCH64_FPCR_DEFAULT_VAL;
+
+	asm ("msr fpcr, %x0\n"
+	     "msr fpsr, xzr\n"
+             : : "r"(val));
+}
+
+static inline void fpsimd_enable_trap(void)
+{
+	u32 __val;
+
+	asm volatile ("mrs %0, cpacr_el1\n"
+		      "and %w0, %w0, #0xFFCFFFFF\n"
+		      "msr cpacr_el1, %0"
+		      : "=&r" (__val));
+}
+
+static inline void fpsimd_disable_trap(void)
+{
+	u32 __val;
+
+	asm volatile ("mrs %0, cpacr_el1\n"
+		      "orr %w0, %w0, #0x000300000\n"
+		      "msr cpacr_el1, %0"
+		      : "=&r" (__val));
+}
+
+/*
+ * If lazy mode is enabled, caller needs to disable preemption
+ * when calling fpsimd_load_state_lazy() and fpsimd_save_state_lazy().
+ */
+static void fpsimd_load_state_lazy(struct fpsimd_state *state)
+{
+	if (static_key_false(&fpsimd_lazy_mode)) {
+		fpsimd_clear_on_hw(state);
+		fpsimd_enable_trap();
+	} else {
+		fpsimd_load_state(state);
+	}
+}
+
+static void fpsimd_save_state_lazy(struct fpsimd_state *state)
+{
+	if (static_key_false(&fpsimd_lazy_mode)) {
+		if (!fpsimd_is_on_hw(state))
+			return;
+	}
+
+	fpsimd_save_state(state);
+}
+
 /*
  * Trapped FP/ASIMD access.
  */
 void do_fpsimd_acc(unsigned int esr, struct pt_regs *regs)
 {
-	/* TODO: implement lazy context saving/restoring */
-	WARN_ON(1);
+	struct fpsimd_state *state = &current->thread.fpsimd_state;
+
+	if (static_key_false(&fpsimd_lazy_mode)) {
+		fpsimd_disable_trap();
+		fpsimd_load_state(state);
+		fpsimd_set_on_hw(state);
+	} else {
+		WARN_ON(1);
+	}
 }
 
 /*
@@ -73,9 +154,9 @@ void fpsimd_thread_switch(struct task_struct *next)
 {
 	/* check if not kernel threads */
 	if (current->mm)
-		fpsimd_save_state(&current->thread.fpsimd_state);
+		fpsimd_save_state_lazy(&current->thread.fpsimd_state);
 	if (next->mm)
-		fpsimd_load_state(&next->thread.fpsimd_state);
+		fpsimd_load_state_lazy(&next->thread.fpsimd_state);
 }
 
 void fpsimd_flush_thread(void)
@@ -87,7 +168,59 @@ void fpsimd_flush_thread(void)
 #if (AARCH64_FPCR_DEFAULT_VAL != 0)
 	state->fpcr = AARCH64_FPCR_DEFAULT_VAL;
 #endif
-	fpsimd_load_state(state);
+	fpsimd_load_state_lazy(state);
+	preempt_enable();
+}
+
+/*
+ * The 'src' has been copied into 'dst' when it's called , so only need to save
+ * the FPSIMD registers into 'dst' if 'src' has been loaded on hardware.
+ */
+void fpsimd_dup_state(struct fpsimd_state *src, struct fpsimd_state *dst)
+{
+	BUG_ON(src != &current->thread.fpsimd_state);
+	if (static_key_false(&fpsimd_lazy_mode)) {
+		preempt_disable();
+		if (fpsimd_is_on_hw(src))
+			fpsimd_save_state(dst);
+		fpsimd_clear_on_hw(dst);
+		preempt_enable();
+	} else {
+		fpsimd_save_state(dst);
+	}
+}
+
+void fpsimd_save_sigctx(struct fpsimd_state *state)
+{
+	preempt_disable();
+	fpsimd_save_state_lazy(state);
+	preempt_enable();
+}
+
+/* The old FPSIMD context has been saved into sigframe when it's called. */
+void fpsimd_prepare_sigctx(struct fpsimd_state *ctx)
+{
+	if (static_key_false(&fpsimd_lazy_mode)) {
+		preempt_disable();
+		if (fpsimd_is_on_hw(ctx)) {
+			fpsimd_init_hw_state();
+		} else {
+			ctx->fpsr = 0;
+			ctx->fpcr = AARCH64_FPCR_DEFAULT_VAL;
+		}
+		preempt_enable();
+	} else {
+		fpsimd_init_hw_state();
+	}
+}
+
+void fpsimd_restore_sigctx(struct fpsimd_state *ctx)
+{
+	struct fpsimd_state *state = &current->thread.fpsimd_state;
+
+	preempt_disable();
+	*state = *ctx;
+	fpsimd_load_state_lazy(state);
 	preempt_enable();
 }
 
@@ -103,7 +236,10 @@ void kernel_neon_begin(void)
 	preempt_disable();
 
 	if (current->mm)
-		fpsimd_save_state(&current->thread.fpsimd_state);
+		fpsimd_save_state_lazy(&current->thread.fpsimd_state);
+
+	if (static_key_false(&fpsimd_lazy_mode))
+		fpsimd_disable_trap();
 
 	fpsimd_init_hw_state();
 }
@@ -112,7 +248,7 @@ EXPORT_SYMBOL(kernel_neon_begin);
 void kernel_neon_end(void)
 {
 	if (current->mm)
-		fpsimd_load_state(&current->thread.fpsimd_state);
+		fpsimd_load_state_lazy(&current->thread.fpsimd_state);
 
 	preempt_enable();
 }
diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
index 7ae8a1f..0176fac 100644
--- a/arch/arm64/kernel/process.c
+++ b/arch/arm64/kernel/process.c
@@ -195,8 +195,10 @@ void release_thread(struct task_struct *dead_task)
 
 int arch_dup_task_struct(struct task_struct *dst, struct task_struct *src)
 {
-	fpsimd_save_state(&current->thread.fpsimd_state);
+	BUG_ON(src != current);
 	*dst = *src;
+	fpsimd_dup_state(&src->thread.fpsimd_state, &dst->thread.fpsimd_state);
+
 	return 0;
 }
 
diff --git a/arch/arm64/kernel/signal.c b/arch/arm64/kernel/signal.c
index 6d80612..b6fe0d1 100644
--- a/arch/arm64/kernel/signal.c
+++ b/arch/arm64/kernel/signal.c
@@ -51,8 +51,7 @@ static int preserve_fpsimd_context(struct fpsimd_context __user *ctx)
 	int err;
 
 	/* dump the hardware registers to the fpsimd_state structure */
-	fpsimd_save_state(fpsimd);
-	fpsimd_init_hw_state();
+	fpsimd_save_sigctx(fpsimd);
 
 	/* copy the FP and status/control registers */
 	err = __copy_to_user(ctx->vregs, fpsimd->vregs, sizeof(fpsimd->vregs));
@@ -63,6 +62,9 @@ static int preserve_fpsimd_context(struct fpsimd_context __user *ctx)
 	__put_user_error(FPSIMD_MAGIC, &ctx->head.magic, err);
 	__put_user_error(sizeof(struct fpsimd_context), &ctx->head.size, err);
 
+	if (!err)
+		fpsimd_prepare_sigctx(fpsimd);
+
 	return err ? -EFAULT : 0;
 }
 
@@ -87,11 +89,8 @@ static int restore_fpsimd_context(struct fpsimd_context __user *ctx)
 	__get_user_error(fpsimd.fpcr, &ctx->fpcr, err);
 
 	/* load the hardware registers from the fpsimd_state structure */
-	if (!err) {
-		preempt_disable();
-		fpsimd_load_state(&fpsimd);
-		preempt_enable();
-	}
+	if (!err)
+		fpsimd_restore_sigctx(&fpsimd);
 
 	return err ? -EFAULT : 0;
 }
diff --git a/arch/arm64/kernel/signal32.c b/arch/arm64/kernel/signal32.c
index cb2cb41..8b4cb89 100644
--- a/arch/arm64/kernel/signal32.c
+++ b/arch/arm64/kernel/signal32.c
@@ -247,8 +247,7 @@ static int compat_preserve_vfp_context(struct compat_vfp_sigframe __user *frame)
 	 * Note that this also saves V16-31, which aren't visible
 	 * in AArch32.
 	 */
-	fpsimd_save_state(fpsimd);
-	fpsimd_init_hw_state();
+	fpsimd_save_sigctx(fpsimd);
 
 	/* Place structure header on the stack */
 	__put_user_error(magic, &frame->magic, err);
@@ -276,6 +275,9 @@ static int compat_preserve_vfp_context(struct compat_vfp_sigframe __user *frame)
 	__put_user_error(0, &frame->ufp_exc.fpinst, err);
 	__put_user_error(0, &frame->ufp_exc.fpinst2, err);
 
+	if (!err)
+		fpsimd_prepare_sigctx(fpsimd);
+
 	return err ? -EFAULT : 0;
 }
 
@@ -311,11 +313,8 @@ static int compat_restore_vfp_context(struct compat_vfp_sigframe __user *frame)
 	 * We don't need to touch the exception register, so
 	 * reload the hardware state.
 	 */
-	if (!err) {
-		preempt_disable();
-		fpsimd_load_state(&fpsimd);
-		preempt_enable();
-	}
+	if (!err)
+		fpsimd_restore_sigctx(&fpsimd);
 
 	return err ? -EFAULT : 0;
 }
-- 
1.8.1.2

