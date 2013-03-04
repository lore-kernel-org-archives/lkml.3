Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758251Ab3CDOkr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 09:40:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40494 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758094Ab3CDOkq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 09:40:46 -0500
From: Anton Arapov <anton@redhat.com>
To: Anton Arapov <anton@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Josh Stone <jistone@redhat.com>,
        Frank Eigler <fche@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Subject: [RFC PATCH v4 4/6] uretprobes: return probe entry, prepare uretprobe
Date: Mon,  4 Mar 2013 15:38:11 +0100
Message-Id: <1362407893-32505-5-git-send-email-anton@redhat.com>
In-Reply-To: <1362407893-32505-1-git-send-email-anton@redhat.com>
References: <1362407893-32505-1-git-send-email-anton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  When a uprobe with return consumer is hit, prepare_uretprobe function is
invoked. It creates return_instance, hijacks return address and replaces
it with the trampoline.

 N.B. it might be a good idea to introduce get_uprobe() to reflect
put_uprobe() later, but it is not a subject of this patchset.

v4:
 - get rid of area->rp_trampoline_vaddr as it always the same as ->vaddr
 - preallocate slot, as the first one in xol_add_vma()
 - cleanup ->return_uprobes list in uprobe_free_utask(), because the
   task can exit from inside the ret-probe'd function(s).
 - in find_active_uprobe(): Once we inserted "int3" we must ensure that
   handle_swbp() will be called even if this uprobe goes away. We have
   the reference but it only protects uprobe itself, it can't protect
   agains delete_uprobe().
   IOW, we must ensure that uprobe_pre_sstep_notifier() can't return 0.
v3:
 - protected uprobe with refcounter. See atomic_inc in prepare_uretprobe()
and put_uprobe() in a following patch in handle_uretprobe()
v2:
 - get rid of ->return_consumers member from struct uprobe, introduce
rp_handler() in consumer

Signed-off-by: Anton Arapov <anton@redhat.com>
---
 include/linux/uprobes.h |  4 +++
 kernel/events/uprobes.c | 67 ++++++++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 68 insertions(+), 3 deletions(-)

diff --git a/include/linux/uprobes.h b/include/linux/uprobes.h
index a28bdee..6b0a309 100644
--- a/include/linux/uprobes.h
+++ b/include/linux/uprobes.h
@@ -69,6 +69,10 @@ struct uprobe_task {
 	enum uprobe_task_state		state;
 	struct arch_uprobe_task		autask;
 
+	/*
+	 * list for tracking uprobes with return consumers
+	 */
+	struct hlist_head		return_uprobes;
 	struct uprobe			*active_uprobe;
 
 	unsigned long			xol_vaddr;
diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 69bf060..12acc10 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -57,6 +57,8 @@ static struct mutex uprobes_mmap_mutex[UPROBES_HASH_SZ];
 
 static struct percpu_rw_semaphore dup_mmap_sem;
 
+static unsigned long xol_get_insn_slot(unsigned char *insn);
+
 /* Have a copy of original instruction */
 #define UPROBE_COPY_INSN	0
 /* Can skip singlestep */
@@ -75,6 +77,12 @@ struct uprobe {
 	struct arch_uprobe	arch;
 };
 
+struct return_uprobe_i {
+	struct uprobe		*uprobe;
+	struct hlist_node	hlist;		/* node in list */
+	unsigned long		orig_ret_vaddr; /* original return address */
+};
+
 /*
  * valid_vma: Verify if the specified vma is an executable vma
  * Relax restrictions while unregistering: vm_flags might have
@@ -1085,6 +1093,7 @@ static int xol_add_vma(struct xol_area *area)
 {
 	struct mm_struct *mm = current->mm;
 	int ret = -EALREADY;
+	uprobe_opcode_t insn = UPROBE_SWBP_INSN;
 
 	down_write(&mm->mmap_sem);
 	if (mm->uprobes_state.xol_area)
@@ -1106,6 +1115,13 @@ static int xol_add_vma(struct xol_area *area)
 	smp_wmb();	/* pairs with get_xol_area() */
 	mm->uprobes_state.xol_area = area;
 	ret = 0;
+
+	/*
+	 * If we reached this place, we did allocate a new area. We want
+	 * pre-alloc a slot for the return probes here.
+	 */
+	xol_get_insn_slot(&insn);
+
  fail:
 	up_write(&mm->mmap_sem);
 
@@ -1306,6 +1322,9 @@ unsigned long __weak uprobe_get_swbp_addr(struct pt_regs *regs)
 void uprobe_free_utask(struct task_struct *t)
 {
 	struct uprobe_task *utask = t->utask;
+	struct hlist_head *head;
+	struct hlist_node *tmp;
+	struct return_uprobe_i *ri;
 
 	if (!utask)
 		return;
@@ -1313,6 +1332,13 @@ void uprobe_free_utask(struct task_struct *t)
 	if (utask->active_uprobe)
 		put_uprobe(utask->active_uprobe);
 
+	head = &utask->return_uprobes;
+	hlist_for_each_entry_safe(ri, tmp, head, hlist) {
+		put_uprobe(ri->uprobe);
+		hlist_del(&ri->hlist);
+		kfree(ri);
+	}
+
 	xol_free_insn_slot(t);
 	kfree(utask);
 	t->utask = NULL;
@@ -1336,11 +1362,37 @@ void uprobe_copy_process(struct task_struct *t)
  */
 static struct uprobe_task *get_utask(void)
 {
-	if (!current->utask)
+	if (!current->utask) {
 		current->utask = kzalloc(sizeof(struct uprobe_task), GFP_KERNEL);
+		if (current->utask)
+			INIT_HLIST_HEAD(&current->utask->return_uprobes);
+	}
 	return current->utask;
 }
 
+static void prepare_uretprobe(struct uprobe *uprobe, struct pt_regs *regs)
+{
+	struct return_uprobe_i *ri;
+	struct uprobe_task *utask;
+	struct xol_area *area;
+
+	ri = kzalloc(sizeof(struct return_uprobe_i), GFP_KERNEL);
+	if (!ri)
+		return;
+
+	area = get_xol_area();
+	utask = get_utask();
+	ri->orig_ret_vaddr = arch_uretprobe_hijack_return_addr(area->vaddr, regs);
+	if (likely(ri->orig_ret_vaddr)) {
+		/* TODO: uretprobe bypass logic */
+		atomic_inc(&uprobe->ref);
+		ri->uprobe = uprobe;
+		INIT_HLIST_NODE(&ri->hlist);
+		hlist_add_head(&ri->hlist, &utask->return_uprobes);
+	} else
+		kfree(ri);
+}
+
 /* Prepare to single-step probed instruction out of line. */
 static int
 pre_ssout(struct uprobe *uprobe, struct pt_regs *regs, unsigned long bp_vaddr)
@@ -1468,6 +1520,7 @@ static struct uprobe *find_active_uprobe(unsigned long bp_vaddr, int *is_swbp)
 	struct mm_struct *mm = current->mm;
 	struct uprobe *uprobe = NULL;
 	struct vm_area_struct *vma;
+	struct uprobe_task *utask;
 
 	down_read(&mm->mmap_sem);
 	vma = find_vma(mm, bp_vaddr);
@@ -1485,8 +1538,11 @@ static struct uprobe *find_active_uprobe(unsigned long bp_vaddr, int *is_swbp)
 		*is_swbp = -EFAULT;
 	}
 
-	if (!uprobe && test_and_clear_bit(MMF_RECALC_UPROBES, &mm->flags))
+	utask = get_utask();
+	if (!uprobe && hlist_empty(&utask->return_uprobes) &&
+	    test_and_clear_bit(MMF_RECALC_UPROBES, &mm->flags)) {
 		mmf_recalc_uprobes(mm);
+	}
 	up_read(&mm->mmap_sem);
 
 	return uprobe;
@@ -1494,12 +1550,17 @@ static struct uprobe *find_active_uprobe(unsigned long bp_vaddr, int *is_swbp)
 
 static void handler_chain(struct uprobe *uprobe, struct pt_regs *regs)
 {
+	int rc = 0;
 	struct uprobe_consumer *uc;
 	int remove = UPROBE_HANDLER_REMOVE;
 
 	down_read(&uprobe->register_rwsem);
 	for (uc = uprobe->consumers; uc; uc = uc->next) {
-		int rc = uc->handler(uc, regs);
+		if (uc->handler)
+			rc = uc->handler(uc, regs);
+
+		if (uc->rp_handler)
+			prepare_uretprobe(uprobe, regs); /* put bp at return */
 
 		WARN(rc & ~UPROBE_HANDLER_MASK,
 			"bad rc=0x%x from %pf()\n", rc, uc->handler);
-- 
1.8.1.2
