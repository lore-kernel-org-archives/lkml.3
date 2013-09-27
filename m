Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753102Ab3I0ILG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 04:11:06 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:36704 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752924Ab3I0ILA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 04:11:00 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Jiang Liu <jiang.liu@huawei.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Javi Merino <javi.merino@arm.com>, Marc Zyngier <marc.zyngier@arm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Jiang Liu <liuj97@gmail.com>
Subject: [RFT PATCH v1 5/7] arm64: reuse FPSIMD hardware context if possible
Date: Fri, 27 Sep 2013 16:04:45 +0800
Message-Id: <1380269087-8520-6-git-send-email-liuj97@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1380269087-8520-1-git-send-email-liuj97@gmail.com>
References: <1380269087-8520-1-git-send-email-liuj97@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <jiang.liu@huawei.com>

Reuse FPSIMD hardware context if it hasn't been touched by other thread
yet, so we can get rid of unnecessary FPSIMD context restores. This is
especially useful when switching between kernel thread and user thread
because kernel thread usaually doesn't touch FPSIMD registers.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Jiang Liu <liuj97@gmail.com>
---
 arch/arm64/include/asm/fpsimd.h |  2 ++
 arch/arm64/kernel/fpsimd.c      | 24 ++++++++++++++++++++++++
 arch/arm64/kernel/smp.c         |  1 +
 3 files changed, 27 insertions(+)

diff --git a/arch/arm64/include/asm/fpsimd.h b/arch/arm64/include/asm/fpsimd.h
index 725b225..3490935 100644
--- a/arch/arm64/include/asm/fpsimd.h
+++ b/arch/arm64/include/asm/fpsimd.h
@@ -36,6 +36,7 @@ struct fpsimd_state {
 			u32 fpsr;
 			u32 fpcr;
 			bool on_hw;	/* soft state: whether loaded onto hw */
+			int last_cpu;
 		};
 	};
 };
@@ -64,6 +65,7 @@ extern void fpsimd_dup_state(struct fpsimd_state *src,
 extern void fpsimd_save_sigctx(struct fpsimd_state *state);
 extern void fpsimd_prepare_sigctx(struct fpsimd_state *ctx);
 extern void fpsimd_restore_sigctx(struct fpsimd_state *ctx);
+extern void fpsimd_disable_lazy_restore(void);
 
 #endif
 
diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index c14f5e9..267e54a 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -25,6 +25,7 @@
 #include <linux/signal.h>
 #include <linux/hardirq.h>
 #include <linux/jump_label.h>
+#include <linux/percpu.h>
 
 #include <asm/fpsimd.h>
 #include <asm/cputype.h>
@@ -37,6 +38,7 @@
 #define FPEXC_IDF	(1 << 7)
 
 static struct static_key fpsimd_lazy_mode = STATIC_KEY_INIT_FALSE;
+static DEFINE_PER_CPU(struct fpsimd_state *, fpsimd_owner);
 
 static inline void fpsimd_set_on_hw(struct fpsimd_state *state)
 {
@@ -53,6 +55,11 @@ static inline bool fpsimd_is_on_hw(struct fpsimd_state *state)
 	return state->on_hw;
 }
 
+static inline void fpsimd_set_last_cpu(struct fpsimd_state *state, int cpu)
+{
+	state->last_cpu = cpu;
+}
+
 /* Clear FP status register, so it doesn't affect new FP context */
 static inline void fpsimd_init_hw_state(void)
 {
@@ -83,12 +90,22 @@ static inline void fpsimd_disable_trap(void)
 		      : "=&r" (__val));
 }
 
+void fpsimd_disable_lazy_restore(void)
+{
+	this_cpu_write(fpsimd_owner, NULL);
+}
+
 /*
  * If lazy mode is enabled, caller needs to disable preemption
  * when calling fpsimd_load_state_lazy() and fpsimd_save_state_lazy().
  */
 static void fpsimd_load_state_lazy(struct fpsimd_state *state)
 {
+	/* Could we reuse the hardware context? */
+	if (state->last_cpu == smp_processor_id() &&
+	    __this_cpu_read(fpsimd_owner) == state)
+		return;
+
 	if (static_key_false(&fpsimd_lazy_mode)) {
 		fpsimd_clear_on_hw(state);
 		fpsimd_enable_trap();
@@ -105,6 +122,8 @@ static void fpsimd_save_state_lazy(struct fpsimd_state *state)
 	}
 
 	fpsimd_save_state(state);
+	fpsimd_set_last_cpu(state, smp_processor_id());
+	__this_cpu_write(fpsimd_owner, state);
 }
 
 /*
@@ -168,6 +187,7 @@ void fpsimd_flush_thread(void)
 #if (AARCH64_FPCR_DEFAULT_VAL != 0)
 	state->fpcr = AARCH64_FPCR_DEFAULT_VAL;
 #endif
+	fpsimd_set_last_cpu(state, -1);
 	fpsimd_load_state_lazy(state);
 	preempt_enable();
 }
@@ -188,6 +208,7 @@ void fpsimd_dup_state(struct fpsimd_state *src, struct fpsimd_state *dst)
 	} else {
 		fpsimd_save_state(dst);
 	}
+	fpsimd_set_last_cpu(dst, -1);
 }
 
 void fpsimd_save_sigctx(struct fpsimd_state *state)
@@ -200,6 +221,7 @@ void fpsimd_save_sigctx(struct fpsimd_state *state)
 /* The old FPSIMD context has been saved into sigframe when it's called. */
 void fpsimd_prepare_sigctx(struct fpsimd_state *ctx)
 {
+	__this_cpu_write(fpsimd_owner, NULL);
 	if (static_key_false(&fpsimd_lazy_mode)) {
 		preempt_disable();
 		if (fpsimd_is_on_hw(ctx)) {
@@ -220,6 +242,7 @@ void fpsimd_restore_sigctx(struct fpsimd_state *ctx)
 
 	preempt_disable();
 	*state = *ctx;
+	__this_cpu_write(fpsimd_owner, NULL);
 	fpsimd_load_state_lazy(state);
 	preempt_enable();
 }
@@ -242,6 +265,7 @@ void kernel_neon_begin(void)
 		fpsimd_disable_trap();
 
 	fpsimd_init_hw_state();
+	__this_cpu_write(fpsimd_owner, NULL);
 }
 EXPORT_SYMBOL(kernel_neon_begin);
 
diff --git a/arch/arm64/kernel/smp.c b/arch/arm64/kernel/smp.c
index 78db90d..398cf8c 100644
--- a/arch/arm64/kernel/smp.c
+++ b/arch/arm64/kernel/smp.c
@@ -183,6 +183,7 @@ asmlinkage void secondary_start_kernel(void)
 	 */
 	cpu_set_reserved_ttbr0();
 	flush_tlb_all();
+	fpsimd_disable_lazy_restore();
 
 	preempt_disable();
 	trace_hardirqs_off();
-- 
1.8.1.2

