Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754643Ab3JMOWN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Oct 2013 10:22:13 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:60556 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754536Ab3JMOWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Oct 2013 10:22:12 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Jiang Liu <jiang.liu@huawei.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christopher Covington <cov@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Jiang Liu <liuj97@gmail.com>
Subject: [RFT PATCH v2 3/4] arm64: reduce duplicated code when saving/restoring FPSIMD for signal handling
Date: Sun, 13 Oct 2013 22:20:19 +0800
Message-Id: <1381674029-430-3-git-send-email-liuj97@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1381674029-430-1-git-send-email-liuj97@gmail.com>
References: <1381674029-430-1-git-send-email-liuj97@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <jiang.liu@huawei.com>

Reduce duplicated code when saving/restoring FPSIMD for signal
handling, it also helps to concentrate all FPSIMD hardware related
code into fpsimd.c.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Jiang Liu <liuj97@gmail.com>
---
 arch/arm64/include/asm/fpsimd.h | 18 ++++--------------
 arch/arm64/kernel/fpsimd.c      | 35 +++++++++++++++++++++++++++++++++++
 arch/arm64/kernel/process.c     |  3 +--
 arch/arm64/kernel/signal.c      | 12 +++---------
 arch/arm64/kernel/signal32.c    | 10 +++-------
 5 files changed, 46 insertions(+), 32 deletions(-)

diff --git a/arch/arm64/include/asm/fpsimd.h b/arch/arm64/include/asm/fpsimd.h
index b2dc30f..6f034082f 100644
--- a/arch/arm64/include/asm/fpsimd.h
+++ b/arch/arm64/include/asm/fpsimd.h
@@ -54,25 +54,15 @@ struct fpsimd_state {
 
 struct task_struct;
 
-static inline void fpsimd_init_hw_state(void)
-{
-	int val = AARCH64_FPCR_DEFAULT_VAL;
-
-	asm ("msr fpcr, %x0\n"
-	     "msr fpsr, xzr\n"
-             : : "r"(val));
-}
-
-static inline void fpsimd_clear_fpsr(void)
-{
-	asm ("msr fpsr, xzr\n");
-}
-
 extern void fpsimd_save_state(struct fpsimd_state *state);
 extern void fpsimd_load_state(struct fpsimd_state *state);
 
+extern void fpsimd_dup_task_struct(struct task_struct *dst,
+				   struct task_struct *src);
 extern void fpsimd_thread_switch(struct task_struct *next);
 extern void fpsimd_flush_thread(void);
+extern void fpsimd_prepare_sigctx(struct fpsimd_state *state);
+extern void fpsimd_restore_sigctx(struct fpsimd_state *state);
 
 #endif
 
diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index 12a25e5..604fe9f 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -33,6 +33,20 @@
 #define FPEXC_IXF	(1 << 4)
 #define FPEXC_IDF	(1 << 7)
 
+static inline void fpsimd_init_hw_state(void)
+{
+	int val = AARCH64_FPCR_DEFAULT_VAL;
+
+	asm ("msr fpcr, %x0\n"
+	     "msr fpsr, xzr\n"
+             : : "r"(val));
+}
+
+static inline void fpsimd_clear_fpsr(void)
+{
+	asm ("msr fpsr, xzr\n");
+}
+
 /*
  * Trapped FP/ASIMD access.
  */
@@ -69,6 +83,12 @@ void do_fpsimd_exc(unsigned int esr, struct pt_regs *regs)
 	send_sig_info(SIGFPE, &info, current);
 }
 
+void fpsimd_dup_task_struct(struct task_struct *dst, struct task_struct *src)
+{
+	fpsimd_save_state(&src->thread.fpsimd_state);
+	*dst = *src;
+}
+
 void fpsimd_thread_switch(struct task_struct *next)
 {
 	/* check if not kernel threads */
@@ -91,6 +111,21 @@ void fpsimd_flush_thread(void)
 	preempt_enable();
 }
 
+void fpsimd_prepare_sigctx(struct fpsimd_state *state)
+{
+	/* dump the hardware registers to the fpsimd_state structure */
+	fpsimd_save_state(state);
+	fpsimd_clear_fpsr();
+}
+
+void fpsimd_restore_sigctx(struct fpsimd_state *state)
+{
+	/* load the hardware registers from the fpsimd_state structure */
+	preempt_disable();
+	fpsimd_load_state(state);
+	preempt_enable();
+}
+
 #ifdef CONFIG_KERNEL_MODE_NEON
 
 /*
diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
index 7ae8a1f..6796080 100644
--- a/arch/arm64/kernel/process.c
+++ b/arch/arm64/kernel/process.c
@@ -195,8 +195,7 @@ void release_thread(struct task_struct *dead_task)
 
 int arch_dup_task_struct(struct task_struct *dst, struct task_struct *src)
 {
-	fpsimd_save_state(&current->thread.fpsimd_state);
-	*dst = *src;
+	fpsimd_dup_task_struct(dst, src);
 	return 0;
 }
 
diff --git a/arch/arm64/kernel/signal.c b/arch/arm64/kernel/signal.c
index 4ee231e..1597a33 100644
--- a/arch/arm64/kernel/signal.c
+++ b/arch/arm64/kernel/signal.c
@@ -50,9 +50,7 @@ static int preserve_fpsimd_context(struct fpsimd_context __user *ctx)
 	struct fpsimd_state *fpsimd = &current->thread.fpsimd_state;
 	int err;
 
-	/* dump the hardware registers to the fpsimd_state structure */
-	fpsimd_save_state(fpsimd);
-	fpsimd_clear_fpsr();
+	fpsimd_prepare_sigctx(fpsimd);
 
 	/* copy the FP and status/control registers */
 	err = __copy_to_user(ctx->vregs, fpsimd->vregs, sizeof(fpsimd->vregs));
@@ -86,12 +84,8 @@ static int restore_fpsimd_context(struct fpsimd_context __user *ctx)
 	__get_user_error(fpsimd.fpsr, &ctx->fpsr, err);
 	__get_user_error(fpsimd.fpcr, &ctx->fpcr, err);
 
-	/* load the hardware registers from the fpsimd_state structure */
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
index cf85c36..f910d3b 100644
--- a/arch/arm64/kernel/signal32.c
+++ b/arch/arm64/kernel/signal32.c
@@ -247,8 +247,7 @@ static int compat_preserve_vfp_context(struct compat_vfp_sigframe __user *frame)
 	 * Note that this also saves V16-31, which aren't visible
 	 * in AArch32.
 	 */
-	fpsimd_save_state(fpsimd);
-	fpsimd_clear_fpsr();
+	fpsimd_prepare_sigctx(fpsimd);
 
 	/* Place structure header on the stack */
 	__put_user_error(magic, &frame->magic, err);
@@ -311,11 +310,8 @@ static int compat_restore_vfp_context(struct compat_vfp_sigframe __user *frame)
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

