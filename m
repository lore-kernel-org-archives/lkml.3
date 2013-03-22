Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933078Ab3CVNJt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 09:09:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2198 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932765Ab3CVNJo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 09:09:44 -0400
From: Anton Arapov <anton@redhat.com>
To: Anton Arapov <anton@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Josh Stone <jistone@redhat.com>,
        Frank Eigler <fche@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        adrian.m.negreanu@intel.com, Torsten.Polle@gmx.de
Subject: [PATCH 4/7] uretprobes: return probe entry, prepare_uretprobe()
Date: Fri, 22 Mar 2013 14:09:01 +0100
Message-Id: <1363957745-6657-5-git-send-email-anton@redhat.com>
In-Reply-To: <1363957745-6657-1-git-send-email-anton@redhat.com>
References: <1363957745-6657-1-git-send-email-anton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  When a uprobe with return probe consumer is hit, prepare_uretprobe()
function is invoked. It creates return_instance, hijacks return address
and replaces it with the trampoline.

  - Return instances are kept as stack per uprobed task.
  - Return instance is dirty, when the original return address is
    trampoline's page vaddr (e.g. recursive call of the probed function).

 N.B. it might be a good idea to introduce get_uprobe() to reflect
put_uprobe() later, but it is not a subject of this patchset.

RFCv6 changes:
 - rework prepare_uretprobe() logic in order to make further unwinding
   in handler_uretprobe() simplier.
 - introduce the 'dirty' field.

RFCv5 changes:
 - switch from hlist to simply linked list for tracking ->*return_uprobes.
 - revert (*) from v4.
 - preallocate first slot xol_area for return probes, see xol_get_area()
   changes.
 - add get_trampoline_vaddr() helper, to emphasize area->vaddr overload.

RFCv4 changes:
 - get rid of area->rp_trampoline_vaddr as it always the same as ->vaddr.
 - cleanup ->return_uprobes list in uprobe_free_utask(), because the
   task can exit from inside the ret-probe'd function(s).
 - in find_active_uprobe(): Once we inserted "int3" we must ensure that
   handle_swbp() will be called even if this uprobe goes away. We have
   the reference but it only protects uprobe itself, it can't protect
   agains delete_uprobe().
   IOW, we must ensure that uprobe_pre_sstep_notifier() can't return 0.

RFCv3 changes:
 - protected uprobe with refcounter. See atomic_inc in prepare_uretprobe()
   and put_uprobe() in a following patch in handle_uretprobe().

RFCv2 changes:
 - get rid of ->return_consumers member from struct uprobe, introduce
   rp_handler() in consumer.

Signed-off-by: Anton Arapov <anton@redhat.com>
---
 include/linux/uprobes.h |  1 +
 kernel/events/uprobes.c | 91 ++++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 91 insertions(+), 1 deletion(-)

diff --git a/include/linux/uprobes.h b/include/linux/uprobes.h
index a28bdee..145d466 100644
--- a/include/linux/uprobes.h
+++ b/include/linux/uprobes.h
@@ -69,6 +69,7 @@ struct uprobe_task {
 	enum uprobe_task_state		state;
 	struct arch_uprobe_task		autask;
 
+	struct return_instance		*return_instances;
 	struct uprobe			*active_uprobe;
 
 	unsigned long			xol_vaddr;
diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 86706d1..4ea3e91 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -75,6 +75,14 @@ struct uprobe {
 	struct arch_uprobe	arch;
 };
 
+struct return_instance {
+	struct uprobe		*uprobe;
+	unsigned long		orig_ret_vaddr; /* original return address */
+	bool			dirty;		/* true, if instance is nested */
+
+	struct return_instance	*next;		/* keep as stack */
+};
+
 /*
  * valid_vma: Verify if the specified vma is an executable vma
  * Relax restrictions while unregistering: vm_flags might have
@@ -1318,6 +1326,7 @@ unsigned long __weak uprobe_get_swbp_addr(struct pt_regs *regs)
 void uprobe_free_utask(struct task_struct *t)
 {
 	struct uprobe_task *utask = t->utask;
+	struct return_instance *ri, *tmp;
 
 	if (!utask)
 		return;
@@ -1325,6 +1334,15 @@ void uprobe_free_utask(struct task_struct *t)
 	if (utask->active_uprobe)
 		put_uprobe(utask->active_uprobe);
 
+	ri = utask->return_instances;
+	while (ri) {
+		put_uprobe(ri->uprobe);
+
+		tmp = ri;
+		ri = ri->next;
+		kfree(tmp);
+	}
+
 	xol_free_insn_slot(t);
 	kfree(utask);
 	t->utask = NULL;
@@ -1358,6 +1376,71 @@ static unsigned long get_trampoline_vaddr(struct xol_area *area)
 	return area->vaddr;
 }
 
+static void prepare_uretprobe(struct uprobe *uprobe, struct pt_regs *regs)
+{
+	struct return_instance *ri;
+	struct uprobe_task *utask;
+	struct xol_area *area;
+	unsigned long trampoline_vaddr;
+	unsigned long prev_ret_vaddr, ret_vaddr;
+
+	area = get_xol_area();
+	if (!area)
+		return;
+
+	utask = get_utask();
+	if (!utask)
+		return;
+
+	prev_ret_vaddr = -1;
+	if (utask->return_instances)
+		prev_ret_vaddr = utask->return_instances->orig_ret_vaddr;
+
+	ri = kzalloc(sizeof(struct return_instance), GFP_KERNEL);
+	if (!ri)
+		return;
+
+	ri->dirty = false;
+	trampoline_vaddr = get_trampoline_vaddr(area);
+	ret_vaddr = arch_uretprobe_hijack_return_addr(trampoline_vaddr, regs);
+
+	/*
+	 * We don't want to keep trampoline address in stack, rather keep the
+	 * original return address of first caller thru all the consequent
+	 * instances. This also makes breakpoint unwrapping easier.
+	 */
+	if (ret_vaddr == trampoline_vaddr) {
+		if (likely(prev_ret_vaddr != -1)) {
+			ri->dirty = true;
+			ret_vaddr = prev_ret_vaddr;
+		} else {
+			/*
+			 * This situation is not possible. Likely we have an
+			 * attack from user-space. Die.
+			 */
+			printk(KERN_ERR "uprobe: something went wrong "
+				"pid/tgid=%d/%d", current->pid, current->tgid);
+			send_sig(SIGSEGV, current, 0);
+			kfree(ri);
+			return;
+		}
+	}
+
+	if (likely(ret_vaddr != -1)) {
+		atomic_inc(&uprobe->ref);
+		ri->uprobe = uprobe;
+		ri->orig_ret_vaddr = ret_vaddr;
+
+		/* add instance to the stack */
+		ri->next = utask->return_instances;
+		utask->return_instances = ri;
+
+		return;
+	}
+
+	kfree(ri);
+}
+
 /* Prepare to single-step probed instruction out of line. */
 static int
 pre_ssout(struct uprobe *uprobe, struct pt_regs *regs, unsigned long bp_vaddr)
@@ -1513,20 +1596,26 @@ static void handler_chain(struct uprobe *uprobe, struct pt_regs *regs)
 {
 	struct uprobe_consumer *uc;
 	int remove = UPROBE_HANDLER_REMOVE;
+	bool prep = false; /* prepare return uprobe, when needed */
 	int rc = 0;
 
 	down_read(&uprobe->register_rwsem);
 	for (uc = uprobe->consumers; uc; uc = uc->next) {
 		if (uc->handler)
 			rc = uc->handler(uc, regs);
-		else
+		else {
+			prep |= true;
 			remove = 0;
+		}
 
 		WARN(rc & ~UPROBE_HANDLER_MASK,
 			"bad rc=0x%x from %pf()\n", rc, uc->handler);
 		remove &= rc;
 	}
 
+	if (prep)
+		prepare_uretprobe(uprobe, regs); /* put bp at return */
+
 	if (remove && uprobe->consumers) {
 		WARN_ON(!uprobe_is_active(uprobe));
 		unapply_uprobe(uprobe, current->mm);
-- 
1.8.1.4

