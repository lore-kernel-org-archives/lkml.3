Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753993AbbAELkF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 06:40:05 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:19688 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753852AbbAELkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 06:40:03 -0500
From: Wang Nan <wangnan0@huawei.com>
To: <masami.hiramatsu.pt@hitachi.com>, <tixy@linaro.org>,
        <linux@arm.linux.org.uk>
CC: <lizefan@huawei.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH v19 11/11] ARM: optprobes: execute instruction during restoring if possible.
Date: Mon, 5 Jan 2015 19:34:47 +0800
Message-ID: <1420457687-710-1-git-send-email-wangnan0@huawei.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1420457284-76923-1-git-send-email-wangnan0@huawei.com>
References: <1420457284-76923-1-git-send-email-wangnan0@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.247]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes software emulation or simulation for most of probed
instructions. If the instruction doesn't use PC relative addressing,
it will be translated into following instructions in the restore code
in code template:

 ldmia {r0 - r14}  // restore all instruction except PC
 <instruction>     // direct execute the probed instruction
 b next_insn       // branch to next instruction.

Signed-off-by: Wang Nan <wangnan0@huawei.com>
Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
---
 arch/arm/include/asm/kprobes.h    |  3 +++
 arch/arm/include/asm/probes.h     |  1 +
 arch/arm/probes/kprobes/opt-arm.c | 52 +++++++++++++++++++++++++++++++++++++--
 3 files changed, 54 insertions(+), 2 deletions(-)

diff --git a/arch/arm/include/asm/kprobes.h b/arch/arm/include/asm/kprobes.h
index 50ff3bc..3ea9be5 100644
--- a/arch/arm/include/asm/kprobes.h
+++ b/arch/arm/include/asm/kprobes.h
@@ -57,6 +57,9 @@ extern __visible kprobe_opcode_t optprobe_template_call;
 extern __visible kprobe_opcode_t optprobe_template_end;
 extern __visible kprobe_opcode_t optprobe_template_sub_sp;
 extern __visible kprobe_opcode_t optprobe_template_add_sp;
+extern __visible kprobe_opcode_t optprobe_template_restore_begin;
+extern __visible kprobe_opcode_t optprobe_template_restore_orig_insn;
+extern __visible kprobe_opcode_t optprobe_template_restore_end;
 
 #define MAX_OPTIMIZED_LENGTH	4
 #define MAX_OPTINSN_SIZE				\
diff --git a/arch/arm/include/asm/probes.h b/arch/arm/include/asm/probes.h
index 27b65b7..f6b0bad 100644
--- a/arch/arm/include/asm/probes.h
+++ b/arch/arm/include/asm/probes.h
@@ -51,6 +51,7 @@ struct arch_probes_insn {
 #define set_register_nouse(m, n)	do {(m) = __set_register_flag(m, n, REG_NO_USE);} while(0)
 #define set_register_use(m, n)		do {(m) = __set_register_flag(m, n, REG_USE);} while(0)
 	unsigned long register_usage_flag;
+	bool kprobe_direct_exec;
 };
 
 #endif /* __ASSEMBLY__ */
diff --git a/arch/arm/probes/kprobes/opt-arm.c b/arch/arm/probes/kprobes/opt-arm.c
index 6a60df3..15b37c0 100644
--- a/arch/arm/probes/kprobes/opt-arm.c
+++ b/arch/arm/probes/kprobes/opt-arm.c
@@ -32,6 +32,14 @@
 #include "core.h"
 
 /*
+ * See register_usage_flag. If the probed instruction doesn't use PC,
+ * we can copy it into template and have it executed directly without
+ * simulation or emulation.
+ */
+#define ARM_REG_PC	15
+#define can_kprobe_direct_exec(m)	(!test_bit(ARM_REG_PC, &(m)))
+
+/*
  * NOTE: the first sub and add instruction will be modified according
  * to the stack cost of the instruction.
  */
@@ -66,7 +74,15 @@ asm (
 			"	orrne	r2, #1\n"
 			"	strne	r2, [sp, #60] @ set bit0 of PC for thumb\n"
 			"	msr	cpsr_cxsf, r1\n"
+			".global optprobe_template_restore_begin\n"
+			"optprobe_template_restore_begin:\n"
 			"	ldmia	sp, {r0 - r15}\n"
+			".global optprobe_template_restore_orig_insn\n"
+			"optprobe_template_restore_orig_insn:\n"
+			"	nop\n"
+			".global optprobe_template_restore_end\n"
+			"optprobe_template_restore_end:\n"
+			"	nop\n"
 			".global optprobe_template_val\n"
 			"optprobe_template_val:\n"
 			"1:	.long 0\n"
@@ -86,6 +102,12 @@ asm (
 	((unsigned long *)&optprobe_template_add_sp - (unsigned long *)&optprobe_template_entry)
 #define TMPL_SUB_SP \
 	((unsigned long *)&optprobe_template_sub_sp - (unsigned long *)&optprobe_template_entry)
+#define TMPL_RESTORE_BEGIN \
+	((unsigned long *)&optprobe_template_restore_begin - (unsigned long *)&optprobe_template_entry)
+#define TMPL_RESTORE_ORIGN_INSN \
+	((unsigned long *)&optprobe_template_restore_orig_insn - (unsigned long *)&optprobe_template_entry)
+#define TMPL_RESTORE_END \
+	((unsigned long *)&optprobe_template_restore_end - (unsigned long *)&optprobe_template_entry)
 
 /*
  * ARM can always optimize an instruction when using ARM ISA, except
@@ -155,8 +177,12 @@ optimized_callback(struct optimized_kprobe *op, struct pt_regs *regs)
 		__this_cpu_write(current_kprobe, NULL);
 	}
 
-	/* In each case, we must singlestep the replaced instruction. */
-	op->kp.ainsn.insn_singlestep(p->opcode, &p->ainsn, regs);
+	/*
+	 * We singlestep the replaced instruction only when it can't be
+	 * executed directly during restore.
+	 */
+	if (!p->ainsn.kprobe_direct_exec)
+		op->kp.ainsn.insn_singlestep(p->opcode, &p->ainsn, regs);
 
 	local_irq_restore(flags);
 }
@@ -238,6 +264,28 @@ int arch_prepare_optimized_kprobe(struct optimized_kprobe *op, struct kprobe *or
 	val = (unsigned long)optimized_callback;
 	code[TMPL_CALL_IDX] = val;
 
+	/* If possible, copy insn and have it executed during restore */
+	orig->ainsn.kprobe_direct_exec = false;
+	if (can_kprobe_direct_exec(orig->ainsn.register_usage_flag)) {
+		kprobe_opcode_t final_branch = arm_gen_branch(
+				(unsigned long)(&code[TMPL_RESTORE_END]),
+				(unsigned long)(op->kp.addr) + 4);
+		if (final_branch != 0) {
+			/*
+			 * Replace original 'ldmia sp, {r0 - r15}' with
+			 * 'ldmia {r0 - r14}', restore all registers except pc.
+			 */
+			code[TMPL_RESTORE_BEGIN] = __opcode_to_mem_arm(0xe89d7fff);
+
+			/* The original probed instruction */
+			code[TMPL_RESTORE_ORIGN_INSN] = __opcode_to_mem_arm(orig->opcode);
+
+			/* Jump back to next instruction */
+			code[TMPL_RESTORE_END] = __opcode_to_mem_arm(final_branch);
+			orig->ainsn.kprobe_direct_exec = true;
+		}
+	}
+
 	flush_icache_range((unsigned long)code,
 			   (unsigned long)(&code[TMPL_END_IDX]));
 
-- 
1.8.4

