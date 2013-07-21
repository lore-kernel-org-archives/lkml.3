Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755515Ab3GUNo2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jul 2013 09:44:28 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34085 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755459Ab3GUNo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jul 2013 09:44:26 -0400
Date: Sun, 21 Jul 2013 06:43:43 -0700
From: tip-bot for Masami Hiramatsu <tipbot@zytor.com>
Message-ID: <tip-a7b0133ea94e4421a81702d5c0e6dcdbbbab8f6b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jkosina@suse.cz, jbaron@akamai.com, masami.hiramatsu.pt@hitachi.com,
        bpetkov@suse.de, rostedt@goodmis.org, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jkosina@suse.cz, jbaron@akamai.com, masami.hiramatsu.pt@hitachi.com,
        bpetkov@suse.de, rostedt@goodmis.org, tglx@linutronix.de,
        hpa@linux.intel.com
In-Reply-To: <20130718114750.26675.9174.stgit@mhiramat-M0-7522>
References: <20130718114750.26675.9174.stgit@mhiramat-M0-7522>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] kprobes/x86: Use text_poke_bp()
  instead of text_poke_smp*()
Git-Commit-ID: a7b0133ea94e4421a81702d5c0e6dcdbbbab8f6b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Sun, 21 Jul 2013 06:43:49 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a7b0133ea94e4421a81702d5c0e6dcdbbbab8f6b
Gitweb:     http://git.kernel.org/tip/a7b0133ea94e4421a81702d5c0e6dcdbbbab8f6b
Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
AuthorDate: Thu, 18 Jul 2013 20:47:50 +0900
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 19 Jul 2013 09:57:04 +0200

kprobes/x86: Use text_poke_bp() instead of text_poke_smp*()

Use text_poke_bp() for optimizing kprobes instead of
text_poke_smp*(). Since the number of kprobes is usually not so
large (<100) and text_poke_bp() is much lighter than
text_poke_smp() [which uses stop_machine()], this just stops
using batch processing.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Reviewed-by: Jiri Kosina <jkosina@suse.cz>
Cc: H. Peter Anvin <hpa@linux.intel.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Jason Baron <jbaron@akamai.com>
Cc: yrl.pp-manager.tt@hitachi.com
Cc: Borislav Petkov <bpetkov@suse.de>
Link: http://lkml.kernel.org/r/20130718114750.26675.9174.stgit@mhiramat-M0-7522
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/kprobes/common.h |   5 --
 arch/x86/kernel/kprobes/core.c   |   2 +-
 arch/x86/kernel/kprobes/opt.c    | 100 +++++++++------------------------------
 3 files changed, 23 insertions(+), 84 deletions(-)

diff --git a/arch/x86/kernel/kprobes/common.h b/arch/x86/kernel/kprobes/common.h
index 2e9d4b5..c6ee63f 100644
--- a/arch/x86/kernel/kprobes/common.h
+++ b/arch/x86/kernel/kprobes/common.h
@@ -82,14 +82,9 @@ extern void synthesize_reljump(void *from, void *to);
 extern void synthesize_relcall(void *from, void *to);
 
 #ifdef	CONFIG_OPTPROBES
-extern int arch_init_optprobes(void);
 extern int setup_detour_execution(struct kprobe *p, struct pt_regs *regs, int reenter);
 extern unsigned long __recover_optprobed_insn(kprobe_opcode_t *buf, unsigned long addr);
 #else	/* !CONFIG_OPTPROBES */
-static inline int arch_init_optprobes(void)
-{
-	return 0;
-}
 static inline int setup_detour_execution(struct kprobe *p, struct pt_regs *regs, int reenter)
 {
 	return 0;
diff --git a/arch/x86/kernel/kprobes/core.c b/arch/x86/kernel/kprobes/core.c
index 211bce4..cd49b2c 100644
--- a/arch/x86/kernel/kprobes/core.c
+++ b/arch/x86/kernel/kprobes/core.c
@@ -1068,7 +1068,7 @@ int __kprobes longjmp_break_handler(struct kprobe *p, struct pt_regs *regs)
 
 int __init arch_init_kprobes(void)
 {
-	return arch_init_optprobes();
+	return 0;
 }
 
 int __kprobes arch_trampoline_kprobe(struct kprobe *p)
diff --git a/arch/x86/kernel/kprobes/opt.c b/arch/x86/kernel/kprobes/opt.c
index d7d8a8c..d71e994 100644
--- a/arch/x86/kernel/kprobes/opt.c
+++ b/arch/x86/kernel/kprobes/opt.c
@@ -371,31 +371,6 @@ int __kprobes arch_prepare_optimized_kprobe(struct optimized_kprobe *op)
 	return 0;
 }
 
-#define MAX_OPTIMIZE_PROBES 256
-static struct text_poke_param *jump_poke_params;
-static struct jump_poke_buffer {
-	u8 buf[RELATIVEJUMP_SIZE];
-} *jump_poke_bufs;
-
-static void __kprobes setup_optimize_kprobe(struct text_poke_param *tprm,
-					    u8 *insn_buf,
-					    struct optimized_kprobe *op)
-{
-	s32 rel = (s32)((long)op->optinsn.insn -
-			((long)op->kp.addr + RELATIVEJUMP_SIZE));
-
-	/* Backup instructions which will be replaced by jump address */
-	memcpy(op->optinsn.copied_insn, op->kp.addr + INT3_SIZE,
-	       RELATIVE_ADDR_SIZE);
-
-	insn_buf[0] = RELATIVEJUMP_OPCODE;
-	*(s32 *)(&insn_buf[1]) = rel;
-
-	tprm->addr = op->kp.addr;
-	tprm->opcode = insn_buf;
-	tprm->len = RELATIVEJUMP_SIZE;
-}
-
 /*
  * Replace breakpoints (int3) with relative jumps.
  * Caller must call with locking kprobe_mutex and text_mutex.
@@ -403,32 +378,38 @@ static void __kprobes setup_optimize_kprobe(struct text_poke_param *tprm,
 void __kprobes arch_optimize_kprobes(struct list_head *oplist)
 {
 	struct optimized_kprobe *op, *tmp;
-	int c = 0;
+	u8 insn_buf[RELATIVEJUMP_SIZE];
 
 	list_for_each_entry_safe(op, tmp, oplist, list) {
+		s32 rel = (s32)((long)op->optinsn.insn -
+			((long)op->kp.addr + RELATIVEJUMP_SIZE));
+
 		WARN_ON(kprobe_disabled(&op->kp));
-		/* Setup param */
-		setup_optimize_kprobe(&jump_poke_params[c],
-				      jump_poke_bufs[c].buf, op);
+
+		/* Backup instructions which will be replaced by jump address */
+		memcpy(op->optinsn.copied_insn, op->kp.addr + INT3_SIZE,
+		       RELATIVE_ADDR_SIZE);
+
+		insn_buf[0] = RELATIVEJUMP_OPCODE;
+		*(s32 *)(&insn_buf[1]) = rel;
+
+		text_poke_bp(op->kp.addr, insn_buf, RELATIVEJUMP_SIZE,
+			     op->optinsn.insn);
+
 		list_del_init(&op->list);
-		if (++c >= MAX_OPTIMIZE_PROBES)
-			break;
 	}
-
-	text_poke_smp_batch(jump_poke_params, c);
 }
 
-static void __kprobes setup_unoptimize_kprobe(struct text_poke_param *tprm,
-					      u8 *insn_buf,
-					      struct optimized_kprobe *op)
+/* Replace a relative jump with a breakpoint (int3).  */
+void __kprobes arch_unoptimize_kprobe(struct optimized_kprobe *op)
 {
+	u8 insn_buf[RELATIVEJUMP_SIZE];
+
 	/* Set int3 to first byte for kprobes */
 	insn_buf[0] = BREAKPOINT_INSTRUCTION;
 	memcpy(insn_buf + 1, op->optinsn.copied_insn, RELATIVE_ADDR_SIZE);
-
-	tprm->addr = op->kp.addr;
-	tprm->opcode = insn_buf;
-	tprm->len = RELATIVEJUMP_SIZE;
+	text_poke_bp(op->kp.addr, insn_buf, RELATIVEJUMP_SIZE,
+		     op->optinsn.insn);
 }
 
 /*
@@ -439,29 +420,11 @@ extern void arch_unoptimize_kprobes(struct list_head *oplist,
 				    struct list_head *done_list)
 {
 	struct optimized_kprobe *op, *tmp;
-	int c = 0;
 
 	list_for_each_entry_safe(op, tmp, oplist, list) {
-		/* Setup param */
-		setup_unoptimize_kprobe(&jump_poke_params[c],
-					jump_poke_bufs[c].buf, op);
+		arch_unoptimize_kprobe(op);
 		list_move(&op->list, done_list);
-		if (++c >= MAX_OPTIMIZE_PROBES)
-			break;
 	}
-
-	text_poke_smp_batch(jump_poke_params, c);
-}
-
-/* Replace a relative jump with a breakpoint (int3).  */
-void __kprobes arch_unoptimize_kprobe(struct optimized_kprobe *op)
-{
-	u8 buf[RELATIVEJUMP_SIZE];
-
-	/* Set int3 to first byte for kprobes */
-	buf[0] = BREAKPOINT_INSTRUCTION;
-	memcpy(buf + 1, op->optinsn.copied_insn, RELATIVE_ADDR_SIZE);
-	text_poke_smp(op->kp.addr, buf, RELATIVEJUMP_SIZE);
 }
 
 int  __kprobes
@@ -481,22 +444,3 @@ setup_detour_execution(struct kprobe *p, struct pt_regs *regs, int reenter)
 	}
 	return 0;
 }
-
-int __kprobes arch_init_optprobes(void)
-{
-	/* Allocate code buffer and parameter array */
-	jump_poke_bufs = kmalloc(sizeof(struct jump_poke_buffer) *
-				 MAX_OPTIMIZE_PROBES, GFP_KERNEL);
-	if (!jump_poke_bufs)
-		return -ENOMEM;
-
-	jump_poke_params = kmalloc(sizeof(struct text_poke_param) *
-				   MAX_OPTIMIZE_PROBES, GFP_KERNEL);
-	if (!jump_poke_params) {
-		kfree(jump_poke_bufs);
-		jump_poke_bufs = NULL;
-		return -ENOMEM;
-	}
-
-	return 0;
-}
