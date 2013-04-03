Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762374Ab3DCQBk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 12:01:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61604 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762267Ab3DCQBb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 12:01:31 -0400
From: Anton Arapov <anton@redhat.com>
To: Anton Arapov <anton@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Josh Stone <jistone@redhat.com>,
        Frank Eigler <fche@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        adrian.m.negreanu@intel.com, Torsten.Polle@gmx.de
Subject: [PATCH v1 5/9] uretprobes: Return probe entry, prepare_uretprobe()
Date: Wed,  3 Apr 2013 18:00:35 +0200
Message-Id: <1365004839-21982-6-git-send-email-anton@redhat.com>
In-Reply-To: <1365004839-21982-1-git-send-email-anton@redhat.com>
References: <1365004839-21982-1-git-send-email-anton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a uprobe with return probe consumer is hit, prepare_uretprobe()
function is invoked. It creates return_instance, hijacks return address
and replaces it with the trampoline.

* Return instances are kept as stack per uprobed task.
* Return instance is chained, when the original return address is
  trampoline's page vaddr (e.g. recursive call of the probed function).

v1 changes:
* preserve address of the breakpoint in return_instance.
* don't forget NULLify return_instances on free_utask.
* simplify prepare_uretprobe().

RFCv6 changes:
* rework prepare_uretprobe() logic in order to make further unwinding
  in handler_uretprobe() simplier.
* introduce the 'dirty' field.

RFCv5 changes:
* switch from hlist to simply linked list for tracking ->*return_uprobes.
* preallocate first slot xol_area for return probes, see xol_get_area()
  changes.
* add get_trampoline_vaddr() helper, to emphasize area->vaddr overload.

RFCv4 changes:
* get rid of area->rp_trampoline_vaddr as it always the same as ->vaddr.
* cleanup ->return_uprobes list in uprobe_free_utask(), because the
  task can exit from inside the ret-probe'd function(s).
* in find_active_uprobe(): Once we inserted "int3" we must ensure that
  handle_swbp() will be called even if this uprobe goes away. We have
  the reference but it only protects uprobe itself, it can't protect
  agains delete_uprobe().
  IOW, we must ensure that uprobe_pre_sstep_notifier() can't return 0.

RFCv3 changes:
* protected uprobe with refcounter. See atomic_inc in prepare_uretprobe()
  and put_uprobe() in a following patch in handle_uretprobe().

RFCv2 changes:
* get rid of ->return_consumers member from struct uprobe, introduce
  ret_handler() in consumer.

Signed-off-by: Anton Arapov <anton@redhat.com>
---
 include/linux/uprobes.h |  1 +
 kernel/events/uprobes.c | 92 ++++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 92 insertions(+), 1 deletion(-)

diff --git a/include/linux/uprobes.h b/include/linux/uprobes.h
index 4042cad..5f8960e 100644
--- a/include/linux/uprobes.h
+++ b/include/linux/uprobes.h
@@ -71,6 +71,7 @@ struct uprobe_task {
 	enum uprobe_task_state		state;
 	struct arch_uprobe_task		autask;
 
+	struct return_instance		*return_instances;
 	struct uprobe			*active_uprobe;
 
 	unsigned long			xol_vaddr;
diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index d3c8201..08ecfff 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -75,6 +75,15 @@ struct uprobe {
 	struct arch_uprobe	arch;
 };
 
+struct return_instance {
+	struct uprobe		*uprobe;
+	unsigned long		func;
+	unsigned long		orig_ret_vaddr; /* original return address */
+	bool			chained;	/* true, if instance is nested */
+
+	struct return_instance	*next;		/* keep as stack */
+};
+
 /*
  * valid_vma: Verify if the specified vma is an executable vma
  * Relax restrictions while unregistering: vm_flags might have
@@ -1294,6 +1303,7 @@ unsigned long __weak uprobe_get_swbp_addr(struct pt_regs *regs)
 void uprobe_free_utask(struct task_struct *t)
 {
 	struct uprobe_task *utask = t->utask;
+	struct return_instance *ri, *tmp;
 
 	if (!utask)
 		return;
@@ -1301,6 +1311,15 @@ void uprobe_free_utask(struct task_struct *t)
 	if (utask->active_uprobe)
 		put_uprobe(utask->active_uprobe);
 
+	ri = utask->return_instances;
+	while (ri) {
+		tmp = ri;
+		ri = ri->next;
+
+		put_uprobe(tmp->uprobe);
+		kfree(tmp);
+	}
+
 	xol_free_insn_slot(t);
 	kfree(utask);
 	t->utask = NULL;
@@ -1348,6 +1367,65 @@ static unsigned long get_trampoline_vaddr(void)
 	return trampoline_vaddr;
 }
 
+static void prepare_uretprobe(struct uprobe *uprobe, struct pt_regs *regs)
+{
+	struct return_instance *ri;
+	struct uprobe_task *utask;
+	unsigned long orig_ret_vaddr, trampoline_vaddr;
+	bool chained = false;
+
+	if (!get_xol_area())
+		return;
+
+	utask = get_utask();
+	if (!utask)
+		return;
+
+	ri = kzalloc(sizeof(struct return_instance), GFP_KERNEL);
+	if (!ri)
+		goto fail;
+
+	trampoline_vaddr = get_trampoline_vaddr();
+	orig_ret_vaddr = arch_uretprobe_hijack_return_addr(trampoline_vaddr, regs);
+	if (orig_ret_vaddr == -1)
+		goto fail;
+
+	/*
+	 * We don't want to keep trampoline address in stack, rather keep the
+	 * original return address of first caller thru all the consequent
+	 * instances. This also makes breakpoint unwrapping easier.
+	 */
+	if (orig_ret_vaddr == trampoline_vaddr) {
+		if (!utask->return_instances) {
+			/*
+			 * This situation is not possible. Likely we have an
+			 * attack from user-space.
+			 */
+			pr_warn("uprobe: unable to set uretprobe pid/tgid=%d/%d\n",
+						current->pid, current->tgid);
+			goto fail;
+		}
+
+		chained = true;
+		orig_ret_vaddr = utask->return_instances->orig_ret_vaddr;
+	}
+
+	atomic_inc(&uprobe->ref);
+	ri->uprobe = uprobe;
+	ri->func = instruction_pointer(regs);
+	ri->orig_ret_vaddr = orig_ret_vaddr;
+	ri->chained = chained;
+
+	/* add instance to the stack */
+	ri->next = utask->return_instances;
+	utask->return_instances = ri;
+
+	return;
+
+ fail:
+	kfree(ri);
+}
+
 /* Prepare to single-step probed instruction out of line. */
 static int
 pre_ssout(struct uprobe *uprobe, struct pt_regs *regs, unsigned long bp_vaddr)
@@ -1503,6 +1581,7 @@ static void handler_chain(struct uprobe *uprobe, struct pt_regs *regs)
 {
 	struct uprobe_consumer *uc;
 	int remove = UPROBE_HANDLER_REMOVE;
+	bool need_prep = false; /* prepare return uprobe, when needed */
 
 	down_read(&uprobe->register_rwsem);
 	for (uc = uprobe->consumers; uc; uc = uc->next) {
@@ -1513,9 +1592,16 @@ static void handler_chain(struct uprobe *uprobe, struct pt_regs *regs)
 			WARN(rc & ~UPROBE_HANDLER_MASK,
 				"bad rc=0x%x from %pf()\n", rc, uc->handler);
 		}
+
+		if (uc->ret_handler)
+			need_prep = true;
+
 		remove &= rc;
 	}
 
+	if (need_prep && !remove)
+		prepare_uretprobe(uprobe, regs); /* put bp at return */
+
 	if (remove && uprobe->consumers) {
 		WARN_ON(!uprobe_is_active(uprobe));
 		unapply_uprobe(uprobe, current->mm);
@@ -1634,7 +1720,11 @@ void uprobe_notify_resume(struct pt_regs *regs)
  */
 int uprobe_pre_sstep_notifier(struct pt_regs *regs)
 {
-	if (!current->mm || !test_bit(MMF_HAS_UPROBES, &current->mm->flags))
+	if (!current->mm)
+		return 0;
+
+	if (!test_bit(MMF_HAS_UPROBES, &current->mm->flags) &&
+	    (!current->utask || !current->utask->return_instances))
 		return 0;
 
 	set_thread_flag(TIF_UPROBE);
-- 
1.8.1.4

