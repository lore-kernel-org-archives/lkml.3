Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933988Ab3JOVIa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 17:08:30 -0400
Received: from mail-qe0-f49.google.com ([209.85.128.49]:49128 "EHLO
	mail-qe0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759836Ab3JOVEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 17:04:34 -0400
From: David Long <dave.long@linaro.org>
To: linux-arm-kernel@lists.infradead.org
Cc: Rabin Vincent <rabin@rab.in>, "Jon Medhurst (Tixy)" <tixy@linaro.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 02/13] uprobes: allow ignoring of probe hits
Date: Tue, 15 Oct 2013 17:04:17 -0400
Message-Id: <1381871068-27660-3-git-send-email-dave.long@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1381871068-27660-1-git-send-email-dave.long@linaro.org>
References: <1381871068-27660-1-git-send-email-dave.long@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "David A. Long" <dave.long@linaro.org>

Allow arches to decided to ignore a probe hit.  ARM will use this to
only call handlers if the conditions to execute a conditionally executed
instruction are satisfied.

Upleveled for v3.12-rc4.

Signed-off-by: David A. Long <dave.long@linaro.org>
---
 include/linux/uprobes.h |  1 +
 kernel/events/uprobes.c | 17 ++++++++++++-----
 2 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/include/linux/uprobes.h b/include/linux/uprobes.h
index 9fd60c5..80116c9 100644
--- a/include/linux/uprobes.h
+++ b/include/linux/uprobes.h
@@ -133,6 +133,7 @@ extern bool arch_uprobe_xol_was_trapped(struct task_struct *tsk);
 extern int  arch_uprobe_exception_notify(struct notifier_block *self, unsigned long val, void *data);
 extern void arch_uprobe_abort_xol(struct arch_uprobe *aup, struct pt_regs *regs);
 extern unsigned long arch_uretprobe_hijack_return_addr(unsigned long trampoline_vaddr, struct pt_regs *regs);
+extern bool __weak arch_uprobe_ignore(struct arch_uprobe *aup, struct pt_regs *regs);
 #else /* !CONFIG_UPROBES */
 struct uprobes_state {
 };
diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index ad8e1bd..3955172 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -1732,9 +1732,6 @@ static void handle_swbp(struct pt_regs *regs)
 		return;
 	}
 
-	/* change it in advance for ->handler() and restart */
-	instruction_pointer_set(regs, bp_vaddr);
-
 	/*
 	 * TODO: move copy_insn/etc into _register and remove this hack.
 	 * After we hit the bp, _unregister + _register can install the
@@ -1742,16 +1739,26 @@ static void handle_swbp(struct pt_regs *regs)
 	 */
 	smp_rmb(); /* pairs with wmb() in install_breakpoint() */
 	if (unlikely(!test_bit(UPROBE_COPY_INSN, &uprobe->flags)))
-		goto out;
+		goto restart;
 
 	handler_chain(uprobe, regs);
+
+	if (arch_uprobe_ignore(&uprobe->arch, regs))
+		goto out;
+
 	if (can_skip_sstep(uprobe, regs))
 		goto out;
 
 	if (!pre_ssout(uprobe, regs, bp_vaddr))
 		return;
 
-	/* can_skip_sstep() succeeded, or restart if can't singlestep */
+restart:
+	/*
+	 * cannot singlestep; cannot skip instruction;
+	 * re-execute the instruction.
+	 */
+	instruction_pointer_set(regs, bp_vaddr);
+
 out:
 	put_uprobe(uprobe);
 }
-- 
1.8.1.2

