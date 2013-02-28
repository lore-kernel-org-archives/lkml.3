Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753252Ab3B1LBp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 06:01:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64641 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752497Ab3B1LA6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 06:00:58 -0500
From: Anton Arapov <anton@redhat.com>
To: Anton Arapov <anton@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Josh Stone <jistone@redhat.com>,
        Frank Eigler <fche@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Subject: [RFC PATCH v3 5/6] uretprobes: invoke return probe handlers
Date: Thu, 28 Feb 2013 12:00:14 +0100
Message-Id: <1362049215-5780-6-git-send-email-anton@redhat.com>
In-Reply-To: <1362049215-5780-1-git-send-email-anton@redhat.com>
References: <1362049215-5780-1-git-send-email-anton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Uretprobe handlers are invoked when the trampoline is hit, on completion the
trampoline is replaced with the saved return address and the uretprobe instance
deleted.

v3:
 - protected uprobe with refcounter. See put_uprobe() in handle_uretprobe()
that reflects increment in prepare_uretprobe()
v2:
 - get rid of ->return_consumers member from struct uprobe, introduce
rp_handler() in consumer instead

Signed-off-by: Anton Arapov <anton@redhat.com>
---
 arch/x86/include/asm/uprobes.h |  5 +++++
 kernel/events/uprobes.c        | 50 ++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 53 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/uprobes.h b/arch/x86/include/asm/uprobes.h
index c353555..fa9d9de 100644
--- a/arch/x86/include/asm/uprobes.h
+++ b/arch/x86/include/asm/uprobes.h
@@ -56,4 +56,9 @@ extern bool arch_uprobe_xol_was_trapped(struct task_struct *tsk);
 extern int  arch_uprobe_exception_notify(struct notifier_block *self, unsigned long val, void *data);
 extern void arch_uprobe_abort_xol(struct arch_uprobe *aup, struct pt_regs *regs);
 extern unsigned long arch_uretprobe_hijack_return_addr(unsigned long rp_trampoline_vaddr, struct pt_regs *regs);
+
+static inline unsigned long arch_uretprobe_get_sp(struct pt_regs *regs)
+{
+	return (unsigned long)regs->sp;
+}
 #endif	/* _ASM_UPROBES_H */
diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 57f70cd..deacb35 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -1561,6 +1561,52 @@ static void handler_chain(struct uprobe *uprobe, struct pt_regs *regs)
 	up_read(&uprobe->register_rwsem);
 }
 
+static void handler_uretprobe_chain(struct uprobe *uprobe, struct pt_regs *regs)
+{
+	struct uprobe_consumer *uc;
+
+	down_read(&uprobe->register_rwsem);
+	for (uc = uprobe->consumers; uc; uc = uc->next) {
+		if (uc->rp_handler)
+			uc->rp_handler(uc, regs);
+	}
+	up_read(&uprobe->register_rwsem);
+}
+
+static void handle_uretprobe(struct pt_regs *regs)
+{
+	struct hlist_head *head;
+	struct hlist_node *tmp;
+	struct xol_area *area;
+	struct return_uprobe_i *ri;
+	struct uprobe_task *utask;
+
+	/* TODO: uretprobe bypass logic */
+
+	area = get_xol_area();
+	utask = get_utask();
+	head = &utask->return_uprobes;
+	hlist_for_each_entry_safe(ri, tmp, head, hlist) {
+		if (ri->uprobe->consumers) {
+			instruction_pointer_set(regs, ri->orig_ret_vaddr);
+			handler_uretprobe_chain(ri->uprobe, regs);
+		}
+
+		put_uprobe(ri->uprobe);
+		hlist_del(&ri->hlist);
+		kfree(ri);
+
+		if (ri->orig_ret_vaddr != area->rp_trampoline_vaddr)
+			return;
+	}
+
+	/* TODO: change the message */
+	printk(KERN_ERR "uprobe: no instance found! pid/tgid=%d/%d",
+			current->pid, current->tgid);
+	/* TODO: May be sigtrap? if possible to restore utask */
+	send_sig(SIGSEGV, current, 0);
+}
+
 /*
  * Run handler and ask thread to singlestep.
  * Ensure all non-fatal signals cannot interrupt thread while it singlesteps.
@@ -1576,8 +1622,8 @@ static void handle_swbp(struct pt_regs *regs)
 
 	if (!uprobe) {
 		if (is_swbp > 0) {
-			/* No matching uprobe; signal SIGTRAP. */
-			send_sig(SIGTRAP, current, 0);
+			/* No matching uprobe; Try with uretprobe */
+			handle_uretprobe(regs);
 		} else {
 			/*
 			 * Either we raced with uprobe_unregister() or we can't
-- 
1.8.1.2

