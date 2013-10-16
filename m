Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759626Ab3JPDbs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 23:31:48 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:43212 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754861Ab3JPDbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 23:31:47 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Jiang Liu <jiang.liu@huawei.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christopher Covington <cov@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Jiang Liu <liuj97@gmail.com>
Subject: [PATCH v3 2/3] arm64: reduce duplicated code when saving/restoring FPSIMD for signal handling
Date: Wed, 16 Oct 2013 11:26:44 +0800
Message-Id: <1381894020-7912-2-git-send-email-liuj97@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1381894020-7912-1-git-send-email-liuj97@gmail.com>
References: <1381894020-7912-1-git-send-email-liuj97@gmail.com>
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
 arch/arm64/include/asm/fpsimd.h |  4 ++++
 arch/arm64/kernel/fpsimd.c      | 20 ++++++++++++++++++++
 arch/arm64/kernel/process.c     |  3 +--
 arch/arm64/kernel/signal.c      | 11 +++--------
 arch/arm64/kernel/signal32.c    |  9 +++------
 5 files changed, 31 insertions(+), 16 deletions(-)

diff --git a/arch/arm64/include/asm/fpsimd.h b/arch/arm64/include/asm/fpsimd.h
index b3c12fd..142084f 100644
--- a/arch/arm64/include/asm/fpsimd.h
+++ b/arch/arm64/include/asm/fpsimd.h
@@ -57,10 +57,14 @@ struct task_struct;
 extern void fpsimd_save_state(struct fpsimd_state *state);
 extern void fpsimd_load_state(struct fpsimd_state *state);
 
+extern void fpsimd_dup_task_struct(struct task_struct *dst,
+				   struct task_struct *src);
 extern void fpsimd_thread_switch(struct task_struct *next);
 extern void fpsimd_flush_thread(void);
 
 extern void fpsimd_init_sigctx(struct fpsimd_state *state);
+extern void fpsimd_save_sigctx(struct fpsimd_state *state);
+extern void fpsimd_restore_sigctx(struct fpsimd_state *state);
 
 #endif
 
diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index 9daee2c..f43dd58 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -84,6 +84,12 @@ void do_fpsimd_exc(unsigned int esr, struct pt_regs *regs)
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
@@ -110,6 +116,20 @@ void fpsimd_init_sigctx(struct fpsimd_state *state)
 	fpsimd_clear_fpsr();
 }
 
+void fpsimd_save_sigctx(struct fpsimd_state *state)
+{
+	/* dump the hardware registers to the fpsimd_state structure */
+	fpsimd_save_state(state);
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
index f2c83e8..596c8cf 100644
--- a/arch/arm64/kernel/signal.c
+++ b/arch/arm64/kernel/signal.c
@@ -50,8 +50,7 @@ static int preserve_fpsimd_context(struct fpsimd_context __user *ctx)
 	struct fpsimd_state *fpsimd = &current->thread.fpsimd_state;
 	int err;
 
-	/* dump the hardware registers to the fpsimd_state structure */
-	fpsimd_save_state(fpsimd);
+	fpsimd_save_sigctx(fpsimd);
 
 	/* copy the FP and status/control registers */
 	err = __copy_to_user(ctx->vregs, fpsimd->vregs, sizeof(fpsimd->vregs));
@@ -85,12 +84,8 @@ static int restore_fpsimd_context(struct fpsimd_context __user *ctx)
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
index e393174..4ce3768 100644
--- a/arch/arm64/kernel/signal32.c
+++ b/arch/arm64/kernel/signal32.c
@@ -247,7 +247,7 @@ static int compat_preserve_vfp_context(struct compat_vfp_sigframe __user *frame)
 	 * Note that this also saves V16-31, which aren't visible
 	 * in AArch32.
 	 */
-	fpsimd_save_state(fpsimd);
+	fpsimd_save_sigctx(fpsimd);
 
 	/* Place structure header on the stack */
 	__put_user_error(magic, &frame->magic, err);
@@ -310,11 +310,8 @@ static int compat_restore_vfp_context(struct compat_vfp_sigframe __user *frame)
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

