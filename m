Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756666Ab3JRP7b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 11:59:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47087 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756336Ab3JRP5a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 11:57:30 -0400
Date: Fri, 18 Oct 2013 17:50:18 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <aarapov@redhat.com>, David Smith <dsmith@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Martin Cermak <mcermak@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/6] uprobes: Teach __create_xol_area() to accept the
	predefined vaddr
Message-ID: <20131018155018.GA15033@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131018154947.GA15002@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently xol_add_vma() uses get_unmapped_area() for area->vaddr,
but the next patches need to use the fixed address. So this patch
adds the new "vaddr" argument to __create_xol_area() which should
be used as area->vaddr if it is nonzero.

xol_add_vma() doesn't bother to verify that the predefined addr is
not used, insert_vm_struct() should fail if find_vma_links() detects
the overlap with the existing vma.

Also, __create_xol_area() doesn't need __GFP_ZERO to allocate area.

Cc: stable@vger.kernel.org # 3.9+
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
---
 kernel/events/uprobes.c |   20 ++++++++++++--------
 1 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 0e3e956..c836135 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -1104,11 +1104,14 @@ static int xol_add_vma(struct mm_struct *mm, struct xol_area *area)
 	if (mm->uprobes_state.xol_area)
 		goto fail;
 
-	/* Try to map as high as possible, this is only a hint. */
-	area->vaddr = get_unmapped_area(NULL, TASK_SIZE - PAGE_SIZE, PAGE_SIZE, 0, 0);
-	if (area->vaddr & ~PAGE_MASK) {
-		ret = area->vaddr;
-		goto fail;
+	if (!area->vaddr) {
+		/* Try to map as high as possible, this is only a hint. */
+		area->vaddr = get_unmapped_area(NULL, TASK_SIZE - PAGE_SIZE,
+						PAGE_SIZE, 0, 0);
+		if (area->vaddr & ~PAGE_MASK) {
+			ret = area->vaddr;
+			goto fail;
+		}
 	}
 
 	ret = install_special_mapping(mm, area->vaddr, PAGE_SIZE,
@@ -1124,13 +1127,13 @@ static int xol_add_vma(struct mm_struct *mm, struct xol_area *area)
 	return ret;
 }
 
-static struct xol_area *__create_xol_area(void)
+static struct xol_area *__create_xol_area(unsigned long vaddr)
 {
 	struct mm_struct *mm = current->mm;
 	uprobe_opcode_t insn = UPROBE_SWBP_INSN;
 	struct xol_area *area;
 
-	area = kzalloc(sizeof(*area), GFP_KERNEL);
+	area = kmalloc(sizeof(*area), GFP_KERNEL);
 	if (unlikely(!area))
 		goto out;
 
@@ -1142,6 +1145,7 @@ static struct xol_area *__create_xol_area(void)
 	if (!area->page)
 		goto free_bitmap;
 
+	area->vaddr = vaddr;
 	init_waitqueue_head(&area->wq);
 	/* Reserve the 1st slot for get_trampoline_vaddr() */
 	set_bit(0, area->bitmap);
@@ -1172,7 +1176,7 @@ static struct xol_area *get_xol_area(void)
 	struct xol_area *area;
 
 	if (!mm->uprobes_state.xol_area)
-		__create_xol_area();
+		__create_xol_area(0);
 
 	area = mm->uprobes_state.xol_area;
 	smp_read_barrier_depends();	/* pairs with wmb in xol_add_vma() */
-- 
1.5.5.1

