Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753421Ab3I0IMq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 04:12:46 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:64633 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751526Ab3I0IMm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 04:12:42 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Jiang Liu <jiang.liu@huawei.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Jiang Liu <liuj97@gmail.com>
Subject: [RFT PATCH v1 7/7] arm64: disable lazy load if FPSIMD registers are frequently used
Date: Fri, 27 Sep 2013 16:04:47 +0800
Message-Id: <1380269087-8520-8-git-send-email-liuj97@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1380269087-8520-1-git-send-email-liuj97@gmail.com>
References: <1380269087-8520-1-git-send-email-liuj97@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <jiang.liu@huawei.com>

Disable lazy load if FPSIMD registers are frequently used by the thread,
so we can reduce overhead of lazy FPSIMD restore for FPU extensive
applications. The thresholds are randomly chosen without thorough
benchmarks, we may need to tune it for really systems.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Jiang Liu <liuj97@gmail.com>
---
 arch/arm64/include/asm/fpsimd.h | 1 +
 arch/arm64/kernel/fpsimd.c      | 9 +++++++--
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/fpsimd.h b/arch/arm64/include/asm/fpsimd.h
index 3490935..de6e877 100644
--- a/arch/arm64/include/asm/fpsimd.h
+++ b/arch/arm64/include/asm/fpsimd.h
@@ -37,6 +37,7 @@ struct fpsimd_state {
 			u32 fpcr;
 			bool on_hw;	/* soft state: whether loaded onto hw */
 			int last_cpu;
+			int fpu_counter;
 		};
 	};
 };
diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index a81af5f..03e96b8 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -107,7 +107,7 @@ static void fpsimd_load_state_lazy(struct fpsimd_state *state,
 	    __this_cpu_read(fpsimd_owner) == state)
 		return;
 
-	if (static_key_false(&fpsimd_lazy_mode)) {
+	if (state->fpu_counter < 5 && static_key_false(&fpsimd_lazy_mode)) {
 		fpsimd_clear_on_hw(state);
 		fpsimd_enable_trap();
 	} else if (tsk_used_math(tsk)) {
@@ -124,8 +124,11 @@ static void fpsimd_save_state_lazy(struct fpsimd_state *state)
 		return;
 
 	if (static_key_false(&fpsimd_lazy_mode)) {
-		if (!fpsimd_is_on_hw(state))
+		if (!fpsimd_is_on_hw(state)) {
+			state->fpu_counter = clamp(state->fpu_counter - 1,
+						   0, 10);
 			return;
+		}
 	}
 
 	fpsimd_save_state(state);
@@ -144,6 +147,7 @@ void do_fpsimd_acc(unsigned int esr, struct pt_regs *regs)
 	fpsimd_load_state(state);
 	if (static_key_false(&fpsimd_lazy_mode)) {
 		fpsimd_set_on_hw(state);
+		state->fpu_counter++;
 		if (!used_math())
 			set_used_math();
 	} else {
@@ -213,6 +217,7 @@ void fpsimd_dup_state(struct fpsimd_state *src, struct fpsimd_state *dst)
 		preempt_disable();
 		if (fpsimd_is_on_hw(src))
 			fpsimd_save_state(dst);
+		dst->fpu_counter = 0;
 		fpsimd_clear_on_hw(dst);
 		preempt_enable();
 	} else if (used_math()) {
-- 
1.8.1.2

