Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759049Ab3JPDbS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 23:31:18 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:35959 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753265Ab3JPDbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 23:31:17 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Jiang Liu <jiang.liu@huawei.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Jiang Liu <liuj97@gmail.com>
Subject: [PATCH v3 1/3] arm64: restore FPSIMD to default state for kernel and signal contexts
Date: Wed, 16 Oct 2013 11:26:43 +0800
Message-Id: <1381894020-7912-1-git-send-email-liuj97@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <jiang.liu@huawei.com>

Restore FPSIMD control and status registers to default values
when creating new FPSIMD contexts for kernel context and reset
FPSIMD status register when creating FPSIMD context for signal
handling, otherwise the stale value in FPSIMD control and status
registers may affect the new kernal or signal handling contexts.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Jiang Liu <liuj97@gmail.com>
---
 arch/arm64/include/asm/fpsimd.h |  4 ++++
 arch/arm64/kernel/fpsimd.c      | 30 ++++++++++++++++++++++++++++--
 arch/arm64/kernel/signal.c      |  1 +
 3 files changed, 33 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/fpsimd.h b/arch/arm64/include/asm/fpsimd.h
index c43b4ac..b3c12fd 100644
--- a/arch/arm64/include/asm/fpsimd.h
+++ b/arch/arm64/include/asm/fpsimd.h
@@ -50,6 +50,8 @@ struct fpsimd_state {
 #define VFP_STATE_SIZE		((32 * 8) + 4)
 #endif
 
+#define	AARCH64_FPCR_DEFAULT_VAL	0
+
 struct task_struct;
 
 extern void fpsimd_save_state(struct fpsimd_state *state);
@@ -58,6 +60,8 @@ extern void fpsimd_load_state(struct fpsimd_state *state);
 extern void fpsimd_thread_switch(struct task_struct *next);
 extern void fpsimd_flush_thread(void);
 
+extern void fpsimd_init_sigctx(struct fpsimd_state *state);
+
 #endif
 
 #endif
diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index bb785d2..9daee2c 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -33,6 +33,21 @@
 #define FPEXC_IXF	(1 << 4)
 #define FPEXC_IDF	(1 << 7)
 
+static inline void fpsimd_init_hw_state(void)
+{
+	int val = AARCH64_FPCR_DEFAULT_VAL;
+
+	asm volatile ("msr fpcr, %x0\n"
+		      "msr fpsr, xzr\n"
+		      : : "r"(val) : "memory");
+}
+
+static inline void fpsimd_clear_fpsr(void)
+{
+	asm volatile ("msr fpsr, xzr\n"
+		      : : : "memory");
+}
+
 /*
  * Trapped FP/ASIMD access.
  */
@@ -80,12 +95,21 @@ void fpsimd_thread_switch(struct task_struct *next)
 
 void fpsimd_flush_thread(void)
 {
+	struct fpsimd_state *state = &current->thread.fpsimd_state;
+
 	preempt_disable();
-	memset(&current->thread.fpsimd_state, 0, sizeof(struct fpsimd_state));
-	fpsimd_load_state(&current->thread.fpsimd_state);
+	memset(state, 0, sizeof(struct fpsimd_state));
+	if (AARCH64_FPCR_DEFAULT_VAL)
+		state->fpcr = AARCH64_FPCR_DEFAULT_VAL;
+	fpsimd_load_state(state);
 	preempt_enable();
 }
 
+void fpsimd_init_sigctx(struct fpsimd_state *state)
+{
+	fpsimd_clear_fpsr();
+}
+
 #ifdef CONFIG_KERNEL_MODE_NEON
 
 /*
@@ -99,6 +123,8 @@ void kernel_neon_begin(void)
 
 	if (current->mm)
 		fpsimd_save_state(&current->thread.fpsimd_state);
+
+	fpsimd_init_hw_state();
 }
 EXPORT_SYMBOL(kernel_neon_begin);
 
diff --git a/arch/arm64/kernel/signal.c b/arch/arm64/kernel/signal.c
index 890a591..f2c83e8 100644
--- a/arch/arm64/kernel/signal.c
+++ b/arch/arm64/kernel/signal.c
@@ -320,6 +320,7 @@ static void handle_signal(unsigned long sig, struct k_sigaction *ka,
 	 * handler.
 	 */
 	user_fastforward_single_step(tsk);
+	fpsimd_init_sigctx(&tsk->thread.fpsimd_state);
 
 	signal_delivered(sig, info, ka, regs, 0);
 }
-- 
1.8.1.2

