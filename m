Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753377Ab3I0ILh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 04:11:37 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:43322 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751526Ab3I0ILa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 04:11:30 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Jiang Liu <jiang.liu@huawei.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Jiang Liu <liuj97@gmail.com>
Subject: [RFT PATCH v1 6/7] amd64: avoid saving and restoring FPSIMD registers until threads access them
Date: Fri, 27 Sep 2013 16:04:46 +0800
Message-Id: <1380269087-8520-7-git-send-email-liuj97@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1380269087-8520-1-git-send-email-liuj97@gmail.com>
References: <1380269087-8520-1-git-send-email-liuj97@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <jiang.liu@huawei.com>

Use PF_USED_MATH flag to mark whether the thread has accessed any FPSIMD
registers, so we could avoid saving and restroing FPSIMD registers until
threads access them. This may improve performance when lazy FPSIMD restore
is disabled.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Jiang Liu <liuj97@gmail.com>
---
 arch/arm64/kernel/fpsimd.c | 38 +++++++++++++++++++++++---------------
 1 file changed, 23 insertions(+), 15 deletions(-)

diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index 267e54a..a81af5f 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -99,7 +99,8 @@ void fpsimd_disable_lazy_restore(void)
  * If lazy mode is enabled, caller needs to disable preemption
  * when calling fpsimd_load_state_lazy() and fpsimd_save_state_lazy().
  */
-static void fpsimd_load_state_lazy(struct fpsimd_state *state)
+static void fpsimd_load_state_lazy(struct fpsimd_state *state,
+				   struct task_struct *tsk)
 {
 	/* Could we reuse the hardware context? */
 	if (state->last_cpu == smp_processor_id() &&
@@ -109,13 +110,19 @@ static void fpsimd_load_state_lazy(struct fpsimd_state *state)
 	if (static_key_false(&fpsimd_lazy_mode)) {
 		fpsimd_clear_on_hw(state);
 		fpsimd_enable_trap();
-	} else {
+	} else if (tsk_used_math(tsk)) {
+		fpsimd_disable_trap();
 		fpsimd_load_state(state);
+	} else {
+		fpsimd_enable_trap();
 	}
 }
 
 static void fpsimd_save_state_lazy(struct fpsimd_state *state)
 {
+	if (!used_math())
+		return;
+
 	if (static_key_false(&fpsimd_lazy_mode)) {
 		if (!fpsimd_is_on_hw(state))
 			return;
@@ -133,12 +140,14 @@ void do_fpsimd_acc(unsigned int esr, struct pt_regs *regs)
 {
 	struct fpsimd_state *state = &current->thread.fpsimd_state;
 
+	fpsimd_disable_trap();
+	fpsimd_load_state(state);
 	if (static_key_false(&fpsimd_lazy_mode)) {
-		fpsimd_disable_trap();
-		fpsimd_load_state(state);
 		fpsimd_set_on_hw(state);
+		if (!used_math())
+			set_used_math();
 	} else {
-		WARN_ON(1);
+		set_used_math();
 	}
 }
 
@@ -175,7 +184,7 @@ void fpsimd_thread_switch(struct task_struct *next)
 	if (current->mm)
 		fpsimd_save_state_lazy(&current->thread.fpsimd_state);
 	if (next->mm)
-		fpsimd_load_state_lazy(&next->thread.fpsimd_state);
+		fpsimd_load_state_lazy(&next->thread.fpsimd_state, next);
 }
 
 void fpsimd_flush_thread(void)
@@ -187,8 +196,9 @@ void fpsimd_flush_thread(void)
 #if (AARCH64_FPCR_DEFAULT_VAL != 0)
 	state->fpcr = AARCH64_FPCR_DEFAULT_VAL;
 #endif
+	clear_used_math();
 	fpsimd_set_last_cpu(state, -1);
-	fpsimd_load_state_lazy(state);
+	fpsimd_load_state_lazy(state, current);
 	preempt_enable();
 }
 
@@ -205,7 +215,7 @@ void fpsimd_dup_state(struct fpsimd_state *src, struct fpsimd_state *dst)
 			fpsimd_save_state(dst);
 		fpsimd_clear_on_hw(dst);
 		preempt_enable();
-	} else {
+	} else if (used_math()) {
 		fpsimd_save_state(dst);
 	}
 	fpsimd_set_last_cpu(dst, -1);
@@ -226,12 +236,12 @@ void fpsimd_prepare_sigctx(struct fpsimd_state *ctx)
 		preempt_disable();
 		if (fpsimd_is_on_hw(ctx)) {
 			fpsimd_init_hw_state();
-		} else {
+		} else if (used_math()) {
 			ctx->fpsr = 0;
 			ctx->fpcr = AARCH64_FPCR_DEFAULT_VAL;
 		}
 		preempt_enable();
-	} else {
+	} else if (used_math()) {
 		fpsimd_init_hw_state();
 	}
 }
@@ -243,7 +253,7 @@ void fpsimd_restore_sigctx(struct fpsimd_state *ctx)
 	preempt_disable();
 	*state = *ctx;
 	__this_cpu_write(fpsimd_owner, NULL);
-	fpsimd_load_state_lazy(state);
+	fpsimd_load_state_lazy(state, current);
 	preempt_enable();
 }
 
@@ -261,9 +271,7 @@ void kernel_neon_begin(void)
 	if (current->mm)
 		fpsimd_save_state_lazy(&current->thread.fpsimd_state);
 
-	if (static_key_false(&fpsimd_lazy_mode))
-		fpsimd_disable_trap();
-
+	fpsimd_disable_trap();
 	fpsimd_init_hw_state();
 	__this_cpu_write(fpsimd_owner, NULL);
 }
@@ -272,7 +280,7 @@ EXPORT_SYMBOL(kernel_neon_begin);
 void kernel_neon_end(void)
 {
 	if (current->mm)
-		fpsimd_load_state_lazy(&current->thread.fpsimd_state);
+		fpsimd_load_state_lazy(&current->thread.fpsimd_state, current);
 
 	preempt_enable();
 }
-- 
1.8.1.2

