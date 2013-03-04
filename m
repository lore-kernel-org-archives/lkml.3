Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758174Ab3CDOjM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 09:39:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52821 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756870Ab3CDOjJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 09:39:09 -0500
From: Anton Arapov <anton@redhat.com>
To: Anton Arapov <anton@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Josh Stone <jistone@redhat.com>,
        Frank Eigler <fche@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Subject: [RFC PATCH v4 5/6] uretprobes: invoke return probe handlers
Date: Mon,  4 Mar 2013 15:38:12 +0100
Message-Id: <1362407893-32505-6-git-send-email-anton@redhat.com>
In-Reply-To: <1362407893-32505-1-git-send-email-anton@redhat.com>
References: <1362407893-32505-1-git-send-email-anton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Uretprobe handlers are invoked when the trampoline is hit, on completion the
trampoline is replaced with the saved return address and the uretprobe instance
deleted.

v4:
 - check, whether utask is not NULL in handle_uretprobe()
   ? do we want a printk() for this case?
 - get rid of area->rp_trampoline_vaddr
 - minor handle_uretprobe() fixups
v3:
 - protected uprobe with refcounter. See put_uprobe() in handle_uretprobe()
that reflects increment in prepare_uretprobe()
v2:
 - get rid of ->return_consumers member from struct uprobe, introduce
rp_handler() in consumer instead

Signed-off-by: Anton Arapov <anton@redhat.com>
---
 arch/x86/include/asm/uprobes.h |  5 ++++
 kernel/events/uprobes.c        | 57 ++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 60 insertions(+), 2 deletions(-)

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
index 12acc10..e86b6ea 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -1574,6 +1574,55 @@ static void handler_chain(struct uprobe *uprobe, struct pt_regs *regs)
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
+static void handle_uretprobe(struct xol_area *area, struct pt_regs *regs)
+{
+	struct hlist_head *head;
+	struct hlist_node *tmp;
+	struct return_uprobe_i *ri;
+	struct uprobe_task *utask;
+	unsigned long orig_ret_vaddr;
+
+	/* TODO: uretprobe bypass logic */
+
+	utask = get_utask();
+	if (!utask) {
+		/* TODO:RFC task is not probed, do we want printk here? */
+		return;
+	}
+	head = &utask->return_uprobes;
+	hlist_for_each_entry_safe(ri, tmp, head, hlist) {
+		if (ri->uprobe->consumers) {
+			instruction_pointer_set(regs, ri->orig_ret_vaddr);
+			handler_uretprobe_chain(ri->uprobe, regs);
+		}
+
+		orig_ret_vaddr = ri->orig_ret_vaddr;
+		put_uprobe(ri->uprobe);
+		hlist_del(&ri->hlist);
+		kfree(ri);
+
+		if (orig_ret_vaddr != area->vaddr)
+			return;
+	}
+
+	/* TODO: change the message */
+	printk(KERN_ERR "uprobe: no instance found! pid/tgid=%d/%d",
+			current->pid, current->tgid);
+	send_sig(SIGSEGV, current, 0);
+}
+
 /*
  * Run handler and ask thread to singlestep.
  * Ensure all non-fatal signals cannot interrupt thread while it singlesteps.
@@ -1581,6 +1630,7 @@ static void handler_chain(struct uprobe *uprobe, struct pt_regs *regs)
 static void handle_swbp(struct pt_regs *regs)
 {
 	struct uprobe *uprobe;
+	struct xol_area *area;
 	unsigned long bp_vaddr;
 	int uninitialized_var(is_swbp);
 
@@ -1589,8 +1639,11 @@ static void handle_swbp(struct pt_regs *regs)
 
 	if (!uprobe) {
 		if (is_swbp > 0) {
-			/* No matching uprobe; signal SIGTRAP. */
-			send_sig(SIGTRAP, current, 0);
+			area = get_xol_area();
+			if (area && bp_vaddr == area->vaddr)
+				handle_uretprobe(area, regs);
+			else
+				send_sig(SIGTRAP, current, 0);
 		} else {
 			/*
 			 * Either we raced with uprobe_unregister() or we can't
-- 
1.8.1.2

