Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758175Ab3HAXtR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 19:49:17 -0400
Received: from mail-gh0-f172.google.com ([209.85.160.172]:33941 "EHLO
	mail-gh0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753892Ab3HAXp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 19:45:59 -0400
From: David Long <dave.long@linaro.org>
To: linux-arm-kernel@lists.infradead.org
Cc: Rabin Vincent <rabin@rab.in>, "Jon Medhurst (Tixy)" <tixy@linaro.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/9] uprobes: allow ignoring of probe hits
Date: Thu,  1 Aug 2013 19:45:46 -0400
Message-Id: <1375400753-3454-3-git-send-email-dave.long@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1375400753-3454-1-git-send-email-dave.long@linaro.org>
References: <1375400753-3454-1-git-send-email-dave.long@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rabin Vincent <rabin@rab.in>

Allow arches to decided to ignore a probe hit.  ARM will use this to
only call handlers if the conditions to execute a conditionally executed
instruction are satisfied.

Upleveled for v3.10-rc7.

Signed-off-by: David A. Long <dave.long@linaro.org>
---
 include/linux/uprobes.h |  1 +
 kernel/events/uprobes.c | 17 ++++++++++++-----
 2 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/include/linux/uprobes.h b/include/linux/uprobes.h
index 4e3b847..7a7c035 100644
--- a/include/linux/uprobes.h
+++ b/include/linux/uprobes.h
@@ -133,6 +133,7 @@ extern int  arch_uprobe_post_xol(struct arch_uprobe *aup, struct pt_regs *regs);
 extern bool arch_uprobe_xol_was_trapped(struct task_struct *tsk);
 extern int  arch_uprobe_exception_notify(struct notifier_block *self, unsigned long val, void *data);
 extern void arch_uprobe_abort_xol(struct arch_uprobe *aup, struct pt_regs *regs);
+extern bool __weak arch_uprobe_ignore(struct arch_uprobe *aup, struct pt_regs *regs);
 #else /* !CONFIG_UPROBES */
 struct uprobes_state {
 };
diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index f356974..2f3a4cb 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -1734,9 +1734,6 @@ static void handle_swbp(struct pt_regs *regs)
 		return;
 	}
 
-	/* change it in advance for ->handler() and restart */
-	instruction_pointer_set(regs, bp_vaddr);
-
 	/*
 	 * TODO: move copy_insn/etc into _register and remove this hack.
 	 * After we hit the bp, _unregister + _register can install the
@@ -1744,16 +1741,26 @@ static void handle_swbp(struct pt_regs *regs)
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

