Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933272Ab3CVNKA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 09:10:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44755 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933227Ab3CVNJ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 09:09:57 -0400
From: Anton Arapov <anton@redhat.com>
To: Anton Arapov <anton@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Josh Stone <jistone@redhat.com>,
        Frank Eigler <fche@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        adrian.m.negreanu@intel.com, Torsten.Polle@gmx.de
Subject: [PATCH 2/7] uretprobes: extract fill_page() and trampoline implementation
Date: Fri, 22 Mar 2013 14:08:59 +0100
Message-Id: <1363957745-6657-3-git-send-email-anton@redhat.com>
In-Reply-To: <1363957745-6657-1-git-send-email-anton@redhat.com>
References: <1363957745-6657-1-git-send-email-anton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  - Split out fill_page() from xol_get_insn_slot().
  - Allocate trampoline page, as the very first one in uprobed
    task xol area, and fill it with breakpoint opcode.
  - Also introduce get_trampoline_vaddr() helper, to wrap the
    trampoline address extraction from area->vaddr. That removes
    confusion and eases the debug experience in case ->vaddr
    notion will be changed.

Signed-off-by: Anton Arapov <anton@redhat.com>
---
 kernel/events/uprobes.c | 35 ++++++++++++++++++++++++++---------
 1 file changed, 26 insertions(+), 9 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 3205a2e..86706d1 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -1080,6 +1080,21 @@ void uprobe_munmap(struct vm_area_struct *vma, unsigned long start, unsigned lon
 		set_bit(MMF_RECALC_UPROBES, &vma->vm_mm->flags);
 }
 
+static void fill_page(struct page *page, unsigned long offset, uprobe_opcode_t *insn)
+{
+	void *vaddr;
+
+	vaddr = kmap_atomic(page);
+	memcpy(vaddr + offset, insn, MAX_UINSN_BYTES);
+	kunmap_atomic(vaddr);
+
+	/*
+	 * We probably need flush_icache_user_range() but it needs vma.
+	 * This should work on supported architectures too.
+	 */
+	flush_dcache_page(page);
+}
+
 /* Slot allocation for XOL */
 static int xol_add_vma(struct xol_area *area)
 {
@@ -1122,6 +1137,7 @@ static struct xol_area *get_xol_area(void)
 {
 	struct mm_struct *mm = current->mm;
 	struct xol_area *area;
+	uprobe_opcode_t insn = UPROBE_SWBP_INSN;
 
 	area = mm->uprobes_state.xol_area;
 	if (area)
@@ -1139,6 +1155,10 @@ static struct xol_area *get_xol_area(void)
 	if (!area->page)
 		goto free_bitmap;
 
+	/* pre-allocate for return probes */
+	set_bit(0, area->bitmap);
+	fill_page(area->page, 0, &insn);
+
 	init_waitqueue_head(&area->wq);
 	if (!xol_add_vma(area))
 		return area;
@@ -1226,7 +1246,6 @@ static unsigned long xol_get_insn_slot(struct uprobe *uprobe)
 	struct xol_area *area;
 	unsigned long offset;
 	unsigned long xol_vaddr;
-	void *vaddr;
 
 	area = get_xol_area();
 	if (!area)
@@ -1238,14 +1257,7 @@ static unsigned long xol_get_insn_slot(struct uprobe *uprobe)
 
 	/* Initialize the slot */
 	offset = xol_vaddr & ~PAGE_MASK;
-	vaddr = kmap_atomic(area->page);
-	memcpy(vaddr + offset, uprobe->arch.insn, MAX_UINSN_BYTES);
-	kunmap_atomic(vaddr);
-	/*
-	 * We probably need flush_icache_user_range() but it needs vma.
-	 * This should work on supported architectures too.
-	 */
-	flush_dcache_page(area->page);
+	fill_page(area->page, offset, uprobe->arch.insn);
 
 	return xol_vaddr;
 }
@@ -1341,6 +1353,11 @@ static struct uprobe_task *get_utask(void)
 	return current->utask;
 }
 
+static unsigned long get_trampoline_vaddr(struct xol_area *area)
+{
+	return area->vaddr;
+}
+
 /* Prepare to single-step probed instruction out of line. */
 static int
 pre_ssout(struct uprobe *uprobe, struct pt_regs *regs, unsigned long bp_vaddr)
-- 
1.8.1.4

