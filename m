Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751979AbaL2EMY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2014 23:12:24 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:10505 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751863AbaL2EMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2014 23:12:19 -0500
From: Wang Nan <wangnan0@huawei.com>
To: <masami.hiramatsu.pt@hitachi.com>, <tixy@linaro.org>,
        <linux@arm.linux.org.uk>
CC: <lizefan@huawei.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH v18 11/11] ARM: optprobes: execute instruction during restoring if possible.
Date: Mon, 29 Dec 2014 12:07:33 +0800
Message-ID: <1419826053-27988-1-git-send-email-wangnan0@huawei.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <54A07FBE.3010206@hitachi.com>
References: <54A07FBE.3010206@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.247]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020201.54A0D4CF.0110,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: 5ae8ad57a6232b44f13c16ff5250df8d
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
---
 arch/arm/include/asm/kprobes.h    |  3 +++
 arch/arm/include/asm/probes.h     |  1 +
 arch/arm/probes/kprobes/opt-arm.c | 51 +++++++++++++++++++++++++++++++++++++--
 3 files changed, 53 insertions(+), 2 deletions(-)

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
index ee04067..9a5c706 100644
--- a/arch/arm/include/asm/probes.h
+++ b/arch/arm/include/asm/probes.h
@@ -53,6 +53,7 @@ struct arch_probes_insn {
 #define set_register_nouse(m, n)	do {(m) = __set_register_flag(m, n, REG_NO_USE);} while(0)
 #define set_register_use(m, n)		do {(m) = __set_register_flag(m, n, REG_USE);} while(0)
 	int register_usage_mask;
+	bool kprobe_direct_exec;
 };
 
 #endif /* __ASSEMBLY__ */
diff --git a/arch/arm/probes/kprobes/opt-arm.c b/arch/arm/probes/kprobes/opt-arm.c
index 6a60df3..3af42cc 100644
--- a/arch/arm/probes/kprobes/opt-arm.c
+++ b/arch/arm/probes/kprobes/opt-arm.c
@@ -32,6 +32,13 @@
 #include "core.h"
 
 /*
+ * See register_usage_mask. If the probed instruction doesn't use PC,
+ * we can copy it into template and have it executed directly without
+ * simulation or emulation.
+ */
+#define can_kprobe_direct_exec(m)	(!((m) & __register_usage_mask(15)))
+
+/*
  * NOTE: the first sub and add instruction will be modified according
  * to the stack cost of the instruction.
  */
@@ -66,7 +73,15 @@ asm (
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
@@ -86,6 +101,12 @@ asm (
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
@@ -155,8 +176,12 @@ optimized_callback(struct optimized_kprobe *op, struct pt_regs *regs)
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
@@ -238,6 +263,28 @@ int arch_prepare_optimized_kprobe(struct optimized_kprobe *op, struct kprobe *or
 	val = (unsigned long)optimized_callback;
 	code[TMPL_CALL_IDX] = val;
 
+	/* If possible, copy insn and have it executed during restore */
+	orig->ainsn.kprobe_direct_exec = false;
+	if (can_kprobe_direct_exec(orig->ainsn.register_usage_mask)) {
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

