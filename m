Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932925Ab3CVNJs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 09:09:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49861 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932344Ab3CVNJo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 09:09:44 -0400
From: Anton Arapov <anton@redhat.com>
To: Anton Arapov <anton@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Josh Stone <jistone@redhat.com>,
        Frank Eigler <fche@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        adrian.m.negreanu@intel.com, Torsten.Polle@gmx.de
Subject: [PATCH 5/7] uretprobes: return probe exit, invoke handlers
Date: Fri, 22 Mar 2013 14:09:02 +0100
Message-Id: <1363957745-6657-6-git-send-email-anton@redhat.com>
In-Reply-To: <1363957745-6657-1-git-send-email-anton@redhat.com>
References: <1363957745-6657-1-git-send-email-anton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Uretprobe handlers are invoked when the trampoline is hit, on completion the
trampoline is replaced with the saved return address and the uretprobe instance
deleted.

RFCv6 changes:
  - rework handle_uretprobe()

RFCv5 changes:
  - switch to simply linked list ->return_uprobes
  - rework handle_uretprobe()

RFCv4 changes:
  - check, whether utask is not NULL in handle_uretprobe()
  - get rid of area->rp_trampoline_vaddr
  - minor handle_uretprobe() fixups

RFCv3 changes:
  - protected uprobe with refcounter. See put_uprobe() in handle_uretprobe()
    that reflects increment in prepare_uretprobe()

RFCv2 changes:
  - get rid of ->return_consumers member from struct uprobe, introduce
    rp_handler() in consumer instead

Signed-off-by: Anton Arapov <anton@redhat.com>
---
 kernel/events/uprobes.c | 60 ++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 59 insertions(+), 1 deletion(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 4ea3e91..91edd2c 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -1623,6 +1623,56 @@ static void handler_chain(struct uprobe *uprobe, struct pt_regs *regs)
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
+	struct uprobe_task *utask;
+	struct return_instance *ri, *tmp;
+	unsigned long prev_ret_vaddr;
+
+	utask = get_utask();
+	if (!utask)
+		return;
+
+	ri = utask->return_instances;
+	if (!ri)
+		return;
+
+	instruction_pointer_set(regs, ri->orig_ret_vaddr);
+
+	while (ri) {
+		if (ri->uprobe->consumers)
+			handler_uretprobe_chain(ri->uprobe, regs);
+
+		put_uprobe(ri->uprobe);
+		tmp = ri;
+		prev_ret_vaddr = tmp->orig_ret_vaddr;
+		ri = ri->next;
+		kfree(tmp);
+
+		if (!ri || ri->dirty == false) {
+			/*
+			 * This is the first return uprobe (chronologically)
+			 * pushed for this particular instance of the probed
+			 * function.
+			 */
+			utask->return_instances = ri;
+			return;
+		}
+	}
+}
+
 /*
  * Run handler and ask thread to singlestep.
  * Ensure all non-fatal signals cannot interrupt thread while it singlesteps.
@@ -1631,11 +1681,19 @@ static void handle_swbp(struct pt_regs *regs)
 {
 	struct uprobe *uprobe;
 	unsigned long bp_vaddr;
+	struct xol_area *area;
 	int uninitialized_var(is_swbp);
 
 	bp_vaddr = uprobe_get_swbp_addr(regs);
-	uprobe = find_active_uprobe(bp_vaddr, &is_swbp);
+	area = get_xol_area();
+	if (area) {
+		if (bp_vaddr == get_trampoline_vaddr(area)) {
+			handle_uretprobe(area, regs);
+			return;
+		}
+	}
 
+	uprobe = find_active_uprobe(bp_vaddr, &is_swbp);
 	if (!uprobe) {
 		if (is_swbp > 0) {
 			/* No matching uprobe; signal SIGTRAP. */
-- 
1.8.1.4

