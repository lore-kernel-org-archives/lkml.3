Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761886Ab3DCQD4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 12:03:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44996 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761098Ab3DCQDy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 12:03:54 -0400
From: Anton Arapov <anton@redhat.com>
To: Anton Arapov <anton@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Josh Stone <jistone@redhat.com>,
        Frank Eigler <fche@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        adrian.m.negreanu@intel.com, Torsten.Polle@gmx.de
Subject: [PATCH v1 2/9] uretprobes: Reserve the first slot in xol_vma for trampoline
Date: Wed,  3 Apr 2013 18:00:32 +0200
Message-Id: <1365004839-21982-3-git-send-email-anton@redhat.com>
In-Reply-To: <1365004839-21982-1-git-send-email-anton@redhat.com>
References: <1365004839-21982-1-git-send-email-anton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allocate trampoline page, as the very first one in uprobed
task xol area, and fill it with breakpoint opcode.

Also introduce get_trampoline_vaddr() helper, to wrap the
trampoline address extraction from area->vaddr. That removes
confusion and eases the debug experience in case ->vaddr
notion will be changed.

v1 changes:
* rework get_trampoline_vaddr() helper.
* init xol_area->slot_count.

Signed-off-by: Anton Arapov <anton@redhat.com>
---
 kernel/events/uprobes.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 27c964b..d3c8201 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -1109,6 +1109,7 @@ static struct xol_area *get_xol_area(void)
 {
 	struct mm_struct *mm = current->mm;
 	struct xol_area *area;
+	uprobe_opcode_t insn = UPROBE_SWBP_INSN;
 
 	area = mm->uprobes_state.xol_area;
 	if (area)
@@ -1126,7 +1127,12 @@ static struct xol_area *get_xol_area(void)
 	if (!area->page)
 		goto free_bitmap;
 
+	/* allocate first slot of task's xol_area for the return probes */
+	set_bit(0, area->bitmap);
+	copy_to_page(area->page, 0, &insn, UPROBE_SWBP_INSN_SIZE);
+	atomic_set(&area->slot_count, 1);
 	init_waitqueue_head(&area->wq);
+
 	if (!xol_add_vma(area))
 		return area;
 
@@ -1323,6 +1329,25 @@ static struct uprobe_task *get_utask(void)
 	return current->utask;
 }
 
+/*
+ * Current area->vaddr notion assume the trampoline address is always
+ * equal area->vaddr.
+ *
+ * Returns -1 in case the xol_area is not allocated.
+ */
+static unsigned long get_trampoline_vaddr(void)
+{
+	struct xol_area *area;
+	unsigned long trampoline_vaddr = -1;
+
+	area = current->mm->uprobes_state.xol_area;
+	smp_read_barrier_depends();
+	if (area)
+		trampoline_vaddr = area->vaddr;
+
+	return trampoline_vaddr;
+}
+
 /* Prepare to single-step probed instruction out of line. */
 static int
 pre_ssout(struct uprobe *uprobe, struct pt_regs *regs, unsigned long bp_vaddr)
-- 
1.8.1.4

