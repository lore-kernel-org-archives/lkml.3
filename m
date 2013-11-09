Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757090Ab3KITCW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 14:02:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16981 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756457Ab3KITCT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 14:02:19 -0500
Date: Sat, 9 Nov 2013 20:03:44 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] uprobes: Cleanup !CONFIG_UPROBES decls, unexport xol_area
Message-ID: <20131109190344.GA32281@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. Don't include asm/uprobes.h unconditionally, we only need
   it if CONFIG_UPROBES.

2. Move the definition of "struct xol_area" into uprobes.c.

   Perhaps we should simply kill struct uprobes_state, it buys
   nothing.

3. Kill the dummy definition of uprobe_get_swbp_addr(), nobody
   except handle_swbp() needs it.

4. Purely cosmetic, but move the decl of uprobe_get_swbp_addr()
   up, close to other __weak helpers.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 include/linux/uprobes.h |   31 ++++---------------------------
 kernel/events/uprobes.c |   19 +++++++++++++++++++
 2 files changed, 23 insertions(+), 27 deletions(-)

diff --git a/include/linux/uprobes.h b/include/linux/uprobes.h
index 366b8b2..fe0c0bb 100644
--- a/include/linux/uprobes.h
+++ b/include/linux/uprobes.h
@@ -33,10 +33,6 @@ struct mm_struct;
 struct inode;
 struct notifier_block;
 
-#ifdef CONFIG_ARCH_SUPPORTS_UPROBES
-# include <asm/uprobes.h>
-#endif
-
 #define UPROBE_HANDLER_REMOVE		1
 #define UPROBE_HANDLER_MASK		1
 
@@ -61,6 +57,8 @@ struct uprobe_consumer {
 };
 
 #ifdef CONFIG_UPROBES
+#include <asm/uprobes.h>
+
 enum uprobe_task_state {
 	UTASK_RUNNING,
 	UTASK_SSTEP,
@@ -93,24 +91,7 @@ struct uprobe_task {
 	unsigned int			depth;
 };
 
-/*
- * On a breakpoint hit, thread contests for a slot.  It frees the
- * slot after singlestep. Currently a fixed number of slots are
- * allocated.
- */
-struct xol_area {
-	wait_queue_head_t 	wq;		/* if all slots are busy */
-	atomic_t 		slot_count;	/* number of in-use slots */
-	unsigned long 		*bitmap;	/* 0 = free slot */
-	struct page 		*page;
-
-	/*
-	 * We keep the vma's vm_start rather than a pointer to the vma
-	 * itself.  The probed process or a naughty kernel module could make
-	 * the vma go away, and we must handle that reasonably gracefully.
-	 */
-	unsigned long 		vaddr;		/* Page(s) of instruction slots */
-};
+struct xol_area;
 
 struct uprobes_state {
 	struct xol_area		*xol_area;
@@ -120,6 +101,7 @@ extern int __weak set_swbp(struct arch_uprobe *aup, struct mm_struct *mm, unsign
 extern int __weak set_orig_insn(struct arch_uprobe *aup, struct mm_struct *mm, unsigned long vaddr);
 extern bool __weak is_swbp_insn(uprobe_opcode_t *insn);
 extern bool __weak is_trap_insn(uprobe_opcode_t *insn);
+extern unsigned long __weak uprobe_get_swbp_addr(struct pt_regs *regs);
 extern int uprobe_write_opcode(struct mm_struct *mm, unsigned long vaddr, uprobe_opcode_t);
 extern int uprobe_register(struct inode *inode, loff_t offset, struct uprobe_consumer *uc);
 extern int uprobe_apply(struct inode *inode, loff_t offset, struct uprobe_consumer *uc, bool);
@@ -131,7 +113,6 @@ extern void uprobe_end_dup_mmap(void);
 extern void uprobe_dup_mmap(struct mm_struct *oldmm, struct mm_struct *newmm);
 extern void uprobe_free_utask(struct task_struct *t);
 extern void uprobe_copy_process(struct task_struct *t, unsigned long flags);
-extern unsigned long __weak uprobe_get_swbp_addr(struct pt_regs *regs);
 extern int uprobe_post_sstep_notifier(struct pt_regs *regs);
 extern int uprobe_pre_sstep_notifier(struct pt_regs *regs);
 extern void uprobe_notify_resume(struct pt_regs *regs);
@@ -187,10 +168,6 @@ static inline bool uprobe_deny_signal(void)
 {
 	return false;
 }
-static inline unsigned long uprobe_get_swbp_addr(struct pt_regs *regs)
-{
-	return 0;
-}
 static inline void uprobe_free_utask(struct task_struct *t)
 {
 }
diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index acc0317..a7239eb 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -86,6 +86,25 @@ struct return_instance {
 };
 
 /*
+ * On a breakpoint hit, thread contests for a slot.  It frees the
+ * slot after singlestep. Currently a fixed number of slots are
+ * allocated.
+ */
+struct xol_area {
+	wait_queue_head_t 	wq;		/* if all slots are busy */
+	atomic_t 		slot_count;	/* number of in-use slots */
+	unsigned long 		*bitmap;	/* 0 = free slot */
+	struct page 		*page;
+
+	/*
+	 * We keep the vma's vm_start rather than a pointer to the vma
+	 * itself.  The probed process or a naughty kernel module could make
+	 * the vma go away, and we must handle that reasonably gracefully.
+	 */
+	unsigned long 		vaddr;		/* Page(s) of instruction slots */
+};
+
+/*
  * valid_vma: Verify if the specified vma is an executable vma
  * Relax restrictions while unregistering: vm_flags might have
  * changed after breakpoint was inserted.
-- 
1.5.5.1


