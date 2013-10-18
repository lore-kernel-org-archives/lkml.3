Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756566Ab3JRP6N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 11:58:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58408 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756059Ab3JRP6K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 11:58:10 -0400
Date: Fri, 18 Oct 2013 17:50:15 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <aarapov@redhat.com>, David Smith <dsmith@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Martin Cermak <mcermak@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/6] uprobes: Introduce __create_xol_area()
Message-ID: <20131018155015.GA15030@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131018154947.GA15002@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No functional changes, preparation.

Extract the code which actually allocates/installs the new area
into the new helper, __create_xol_area().

While at it remove the unnecessary "ret = ENOMEM" and "ret = 0"
in xol_add_vma(), they both have no effect.

Cc: stable@vger.kernel.org # 3.9+
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
---
 kernel/events/uprobes.c |   47 +++++++++++++++++++++++++----------------------
 1 files changed, 25 insertions(+), 22 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index db7a1dc..0e3e956 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -1096,16 +1096,14 @@ void uprobe_munmap(struct vm_area_struct *vma, unsigned long start, unsigned lon
 }
 
 /* Slot allocation for XOL */
-static int xol_add_vma(struct xol_area *area)
+static int xol_add_vma(struct mm_struct *mm, struct xol_area *area)
 {
-	struct mm_struct *mm = current->mm;
 	int ret = -EALREADY;
 
 	down_write(&mm->mmap_sem);
 	if (mm->uprobes_state.xol_area)
 		goto fail;
 
-	ret = -ENOMEM;
 	/* Try to map as high as possible, this is only a hint. */
 	area->vaddr = get_unmapped_area(NULL, TASK_SIZE - PAGE_SIZE, PAGE_SIZE, 0, 0);
 	if (area->vaddr & ~PAGE_MASK) {
@@ -1120,28 +1118,17 @@ static int xol_add_vma(struct xol_area *area)
 
 	smp_wmb();	/* pairs with get_xol_area() */
 	mm->uprobes_state.xol_area = area;
-	ret = 0;
  fail:
 	up_write(&mm->mmap_sem);
 
 	return ret;
 }
 
-/*
- * get_xol_area - Allocate process's xol_area if necessary.
- * This area will be used for storing instructions for execution out of line.
- *
- * Returns the allocated area or NULL.
- */
-static struct xol_area *get_xol_area(void)
+static struct xol_area *__create_xol_area(void)
 {
 	struct mm_struct *mm = current->mm;
-	struct xol_area *area;
 	uprobe_opcode_t insn = UPROBE_SWBP_INSN;
-
-	area = mm->uprobes_state.xol_area;
-	if (area)
-		goto ret;
+	struct xol_area *area;
 
 	area = kzalloc(sizeof(*area), GFP_KERNEL);
 	if (unlikely(!area))
@@ -1155,13 +1142,13 @@ static struct xol_area *get_xol_area(void)
 	if (!area->page)
 		goto free_bitmap;
 
-	/* allocate first slot of task's xol_area for the return probes */
+	init_waitqueue_head(&area->wq);
+	/* Reserve the 1st slot for get_trampoline_vaddr() */
 	set_bit(0, area->bitmap);
-	copy_to_page(area->page, 0, &insn, UPROBE_SWBP_INSN_SIZE);
 	atomic_set(&area->slot_count, 1);
-	init_waitqueue_head(&area->wq);
+	copy_to_page(area->page, 0, &insn, UPROBE_SWBP_INSN_SIZE);
 
-	if (!xol_add_vma(area))
+	if (!xol_add_vma(mm, area))
 		return area;
 
 	__free_page(area->page);
@@ -1170,9 +1157,25 @@ static struct xol_area *get_xol_area(void)
  free_area:
 	kfree(area);
  out:
+ 	return NULL;
+}
+
+/*
+ * get_xol_area - Allocate process's xol_area if necessary.
+ * This area will be used for storing instructions for execution out of line.
+ *
+ * Returns the allocated area or NULL.
+ */
+static struct xol_area *get_xol_area(void)
+{
+	struct mm_struct *mm = current->mm;
+	struct xol_area *area;
+
+	if (!mm->uprobes_state.xol_area)
+		__create_xol_area();
+
 	area = mm->uprobes_state.xol_area;
- ret:
-	smp_read_barrier_depends();     /* pairs with wmb in xol_add_vma() */
+	smp_read_barrier_depends();	/* pairs with wmb in xol_add_vma() */
 	return area;
 }
 
-- 
1.5.5.1

