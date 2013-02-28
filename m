Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752765Ab3B1LBA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 06:01:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28291 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752437Ab3B1LA4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 06:00:56 -0500
From: Anton Arapov <anton@redhat.com>
To: Anton Arapov <anton@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Josh Stone <jistone@redhat.com>,
        Frank Eigler <fche@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Subject: [RFC PATCH v3 4/6] uretprobes: return probe entry, prepare uretprobe
Date: Thu, 28 Feb 2013 12:00:13 +0100
Message-Id: <1362049215-5780-5-git-send-email-anton@redhat.com>
In-Reply-To: <1362049215-5780-1-git-send-email-anton@redhat.com>
References: <1362049215-5780-1-git-send-email-anton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  When a uprobe with return consumer is hit, prepare_uretprobe function is
invoked. It creates return_instance, hijacks return address and replaces
it with the trampoline.

 N.B. it might be a good idea to introduce get_uprobe() to reflect
put_uprobe() later, but it is not a subject of this patchset.

v3:
 - protected uprobe with refcounter. See atomic_inc in prepare_uretprobe()
and put_uprobe() in a following patch in handle_uretprobe()
v2:
 - get rid of ->return_consumers member from struct uprobe, introduce
rp_handler() in consumer

Signed-off-by: Anton Arapov <anton@redhat.com>
---
 include/linux/uprobes.h |  5 +++++
 kernel/events/uprobes.c | 52 +++++++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 55 insertions(+), 2 deletions(-)

diff --git a/include/linux/uprobes.h b/include/linux/uprobes.h
index a28bdee..6aaa1ce 100644
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
@@ -92,6 +96,7 @@ struct xol_area {
 	 * the vma go away, and we must handle that reasonably gracefully.
 	 */
 	unsigned long 		vaddr;		/* Page(s) of instruction slots */
+	unsigned long		rp_trampoline_vaddr; /* trampoline address */
 };
 
 struct uprobes_state {
diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 69bf060..57f70cd 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -75,6 +75,12 @@ struct uprobe {
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
@@ -1336,11 +1342,48 @@ void uprobe_copy_process(struct task_struct *t)
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
+	unsigned long rp_trampoline_vaddr = 0;
+	uprobe_opcode_t insn = UPROBE_SWBP_INSN;
+
+	area = get_xol_area();
+	if (area)
+		rp_trampoline_vaddr = area->rp_trampoline_vaddr;
+	if (!rp_trampoline_vaddr) {
+		rp_trampoline_vaddr = xol_get_insn_slot(&insn);
+		if (!rp_trampoline_vaddr)
+			return;
+	}
+	area->rp_trampoline_vaddr = rp_trampoline_vaddr;
+
+	ri = kzalloc(sizeof(struct return_uprobe_i), GFP_KERNEL);
+	if (!ri)
+		return;
+
+	utask = get_utask();
+	ri->orig_ret_vaddr = arch_uretprobe_hijack_return_addr(rp_trampoline_vaddr, regs);
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
@@ -1494,12 +1537,17 @@ static struct uprobe *find_active_uprobe(unsigned long bp_vaddr, int *is_swbp)
 
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

