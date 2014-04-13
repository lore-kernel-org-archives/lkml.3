Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755434AbaDMRqT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2014 13:46:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64490 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754983AbaDMRpq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2014 13:45:46 -0400
Date: Sun, 13 Apr 2014 19:45:39 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <aarapov@redhat.com>, David Long <dave.long@linaro.org>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Jim Keniston <jkenisto@us.ibm.com>, Jonathan Lebon <jlebon@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 05/15] uprobes/x86: move the UPROBE_FIX_{RIP,IP,CALL}
	code at the end of pre/post hooks
Message-ID: <20140413174539.GA11849@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140413174508.GA11811@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No functional changes. Preparation to simplify the review of the next
change. Just reorder the code in arch_uprobe_pre/post_xol() functions
so that UPROBE_FIX_{RIP_*,IP,CALL} logic goes to the end.

Also change arch_uprobe_pre_xol() to use utask instead of autask, to
make the code more symmetrical with arch_uprobe_post_xol().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Reviewed-by: Jim Keniston <jkenisto@us.ibm.com>
Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
---
 arch/x86/kernel/uprobes.c |   30 ++++++++++++++----------------
 1 files changed, 14 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kernel/uprobes.c b/arch/x86/kernel/uprobes.c
index c982ea0..b32053a 100644
--- a/arch/x86/kernel/uprobes.c
+++ b/arch/x86/kernel/uprobes.c
@@ -474,19 +474,18 @@ int arch_uprobe_analyze_insn(struct arch_uprobe *auprobe, struct mm_struct *mm,
  */
 int arch_uprobe_pre_xol(struct arch_uprobe *auprobe, struct pt_regs *regs)
 {
-	struct arch_uprobe_task *autask;
+	struct uprobe_task *utask = current->utask;
 
-	autask = &current->utask->autask;
-	autask->saved_trap_nr = current->thread.trap_nr;
+	regs->ip = utask->xol_vaddr;
+	utask->autask.saved_trap_nr = current->thread.trap_nr;
 	current->thread.trap_nr = UPROBE_TRAP_NR;
-	regs->ip = current->utask->xol_vaddr;
-	pre_xol_rip_insn(auprobe, regs, autask);
 
-	autask->saved_tf = !!(regs->flags & X86_EFLAGS_TF);
+	utask->autask.saved_tf = !!(regs->flags & X86_EFLAGS_TF);
 	regs->flags |= X86_EFLAGS_TF;
 	if (test_tsk_thread_flag(current, TIF_BLOCKSTEP))
 		set_task_blockstep(current, false);
 
+	pre_xol_rip_insn(auprobe, regs, &utask->autask);
 	return 0;
 }
 
@@ -560,22 +559,13 @@ bool arch_uprobe_xol_was_trapped(struct task_struct *t)
  */
 int arch_uprobe_post_xol(struct arch_uprobe *auprobe, struct pt_regs *regs)
 {
-	struct uprobe_task *utask;
+	struct uprobe_task *utask = current->utask;
 	long correction;
 	int result = 0;
 
 	WARN_ON_ONCE(current->thread.trap_nr != UPROBE_TRAP_NR);
 
-	utask = current->utask;
 	current->thread.trap_nr = utask->autask.saved_trap_nr;
-	correction = (long)(utask->vaddr - utask->xol_vaddr);
-	handle_riprel_post_xol(auprobe, regs, &correction);
-	if (auprobe->fixups & UPROBE_FIX_IP)
-		regs->ip += correction;
-
-	if (auprobe->fixups & UPROBE_FIX_CALL)
-		result = adjust_ret_addr(regs->sp, correction);
-
 	/*
 	 * arch_uprobe_pre_xol() doesn't save the state of TIF_BLOCKSTEP
 	 * so we can get an extra SIGTRAP if we do not clear TF. We need
@@ -586,6 +576,14 @@ int arch_uprobe_post_xol(struct arch_uprobe *auprobe, struct pt_regs *regs)
 	else if (!(auprobe->fixups & UPROBE_FIX_SETF))
 		regs->flags &= ~X86_EFLAGS_TF;
 
+	correction = (long)(utask->vaddr - utask->xol_vaddr);
+	handle_riprel_post_xol(auprobe, regs, &correction);
+	if (auprobe->fixups & UPROBE_FIX_IP)
+		regs->ip += correction;
+
+	if (auprobe->fixups & UPROBE_FIX_CALL)
+		result = adjust_ret_addr(regs->sp, correction);
+
 	return result;
 }
 
-- 
1.5.5.1

