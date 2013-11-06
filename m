Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755234Ab3KFTR4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 14:17:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16733 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752017Ab3KFTRz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 14:17:55 -0500
Date: Wed, 6 Nov 2013 20:19:13 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        David Long <dave.long@linaro.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] uprobes: preparations for arm port
Message-ID: <20131106191913.GA18661@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo, please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/oleg/misc uprobes/core


I have also attached the cumulative diff below. As you can see,
the changes are really simple and there are no functional changes.

However I think it makes sense to merge this now, this way the
upcoming arm port doesn't (almost) need the changes outside of
arch/arm and thus it would be simpler to route everything via
arm trees.


David A. Long (1):
      uprobes: Move function declarations out of arch

Oleg Nesterov (3):
      uprobes: Kill module_init() and module_exit()
      uprobes: Introduce arch_uprobe->ixol
      uprobes: Export write_opcode() as uprobe_write_opcode()

 arch/powerpc/include/asm/uprobes.h |    8 +-------
 arch/x86/include/asm/uprobes.h     |   12 ++++--------
 include/linux/uprobes.h            |    9 +++++++++
 kernel/events/uprobes.c            |   24 ++++++++++--------------
 4 files changed, 24 insertions(+), 29 deletions(-)

diff --git a/arch/powerpc/include/asm/uprobes.h b/arch/powerpc/include/asm/uprobes.h
index 2301602..75c6ecd 100644
--- a/arch/powerpc/include/asm/uprobes.h
+++ b/arch/powerpc/include/asm/uprobes.h
@@ -37,6 +37,7 @@ typedef ppc_opcode_t uprobe_opcode_t;
 struct arch_uprobe {
 	union {
 		u8	insn[MAX_UINSN_BYTES];
+		u8	ixol[MAX_UINSN_BYTES];
 		u32	ainsn;
 	};
 };
@@ -45,11 +46,4 @@ struct arch_uprobe_task {
 	unsigned long	saved_trap_nr;
 };
 
-extern int  arch_uprobe_analyze_insn(struct arch_uprobe *aup, struct mm_struct *mm, unsigned long addr);
-extern int  arch_uprobe_pre_xol(struct arch_uprobe *aup, struct pt_regs *regs);
-extern int  arch_uprobe_post_xol(struct arch_uprobe *aup, struct pt_regs *regs);
-extern bool arch_uprobe_xol_was_trapped(struct task_struct *tsk);
-extern int  arch_uprobe_exception_notify(struct notifier_block *self, unsigned long val, void *data);
-extern void arch_uprobe_abort_xol(struct arch_uprobe *aup, struct pt_regs *regs);
-extern unsigned long arch_uretprobe_hijack_return_addr(unsigned long trampoline_vaddr, struct pt_regs *regs);
 #endif	/* _ASM_UPROBES_H */
diff --git a/arch/x86/include/asm/uprobes.h b/arch/x86/include/asm/uprobes.h
index 6e51979..3087ea9 100644
--- a/arch/x86/include/asm/uprobes.h
+++ b/arch/x86/include/asm/uprobes.h
@@ -35,7 +35,10 @@ typedef u8 uprobe_opcode_t;
 
 struct arch_uprobe {
 	u16				fixups;
-	u8				insn[MAX_UINSN_BYTES];
+	union {
+		u8			insn[MAX_UINSN_BYTES];
+		u8			ixol[MAX_UINSN_BYTES];
+	};
 #ifdef CONFIG_X86_64
 	unsigned long			rip_rela_target_address;
 #endif
@@ -49,11 +52,4 @@ struct arch_uprobe_task {
 	unsigned int			saved_tf;
 };
 
-extern int  arch_uprobe_analyze_insn(struct arch_uprobe *aup, struct mm_struct *mm, unsigned long addr);
-extern int  arch_uprobe_pre_xol(struct arch_uprobe *aup, struct pt_regs *regs);
-extern int  arch_uprobe_post_xol(struct arch_uprobe *aup, struct pt_regs *regs);
-extern bool arch_uprobe_xol_was_trapped(struct task_struct *tsk);
-extern int  arch_uprobe_exception_notify(struct notifier_block *self, unsigned long val, void *data);
-extern void arch_uprobe_abort_xol(struct arch_uprobe *aup, struct pt_regs *regs);
-extern unsigned long arch_uretprobe_hijack_return_addr(unsigned long trampoline_vaddr, struct pt_regs *regs);
 #endif	/* _ASM_UPROBES_H */
diff --git a/include/linux/uprobes.h b/include/linux/uprobes.h
index 9e0d5a6..319eae7 100644
--- a/include/linux/uprobes.h
+++ b/include/linux/uprobes.h
@@ -30,6 +30,7 @@
 struct vm_area_struct;
 struct mm_struct;
 struct inode;
+struct notifier_block;
 
 #ifdef CONFIG_ARCH_SUPPORTS_UPROBES
 # include <asm/uprobes.h>
@@ -108,6 +109,7 @@ extern int __weak set_swbp(struct arch_uprobe *aup, struct mm_struct *mm, unsign
 extern int __weak set_orig_insn(struct arch_uprobe *aup, struct mm_struct *mm, unsigned long vaddr);
 extern bool __weak is_swbp_insn(uprobe_opcode_t *insn);
 extern bool __weak is_trap_insn(uprobe_opcode_t *insn);
+extern int uprobe_write_opcode(struct mm_struct *mm, unsigned long vaddr, uprobe_opcode_t);
 extern int uprobe_register(struct inode *inode, loff_t offset, struct uprobe_consumer *uc);
 extern int uprobe_apply(struct inode *inode, loff_t offset, struct uprobe_consumer *uc, bool);
 extern void uprobe_unregister(struct inode *inode, loff_t offset, struct uprobe_consumer *uc);
@@ -125,6 +127,13 @@ extern void uprobe_notify_resume(struct pt_regs *regs);
 extern bool uprobe_deny_signal(void);
 extern bool arch_uprobe_skip_sstep(struct arch_uprobe *aup, struct pt_regs *regs);
 extern void uprobe_clear_state(struct mm_struct *mm);
+extern int  arch_uprobe_analyze_insn(struct arch_uprobe *aup, struct mm_struct *mm, unsigned long addr);
+extern int  arch_uprobe_pre_xol(struct arch_uprobe *aup, struct pt_regs *regs);
+extern int  arch_uprobe_post_xol(struct arch_uprobe *aup, struct pt_regs *regs);
+extern bool arch_uprobe_xol_was_trapped(struct task_struct *tsk);
+extern int  arch_uprobe_exception_notify(struct notifier_block *self, unsigned long val, void *data);
+extern void arch_uprobe_abort_xol(struct arch_uprobe *aup, struct pt_regs *regs);
+extern unsigned long arch_uretprobe_hijack_return_addr(unsigned long trampoline_vaddr, struct pt_regs *regs);
 #else /* !CONFIG_UPROBES */
 struct uprobes_state {
 };
diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index ae9e1d2..0ac346a 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -245,12 +245,12 @@ static int verify_opcode(struct page *page, unsigned long vaddr, uprobe_opcode_t
  * the architecture. If an arch has variable length instruction and the
  * breakpoint instruction is not of the smallest length instruction
  * supported by that architecture then we need to modify is_trap_at_addr and
- * write_opcode accordingly. This would never be a problem for archs that
- * have fixed length instructions.
+ * uprobe_write_opcode accordingly. This would never be a problem for archs
+ * that have fixed length instructions.
  */
 
 /*
- * write_opcode - write the opcode at a given virtual address.
+ * uprobe_write_opcode - write the opcode at a given virtual address.
  * @mm: the probed process address space.
  * @vaddr: the virtual address to store the opcode.
  * @opcode: opcode to be written at @vaddr.
@@ -261,7 +261,7 @@ static int verify_opcode(struct page *page, unsigned long vaddr, uprobe_opcode_t
  * For mm @mm, write the opcode at @vaddr.
  * Return 0 (success) or a negative errno.
  */
-static int write_opcode(struct mm_struct *mm, unsigned long vaddr,
+int uprobe_write_opcode(struct mm_struct *mm, unsigned long vaddr,
 			uprobe_opcode_t opcode)
 {
 	struct page *old_page, *new_page;
@@ -315,7 +315,7 @@ put_old:
  */
 int __weak set_swbp(struct arch_uprobe *auprobe, struct mm_struct *mm, unsigned long vaddr)
 {
-	return write_opcode(mm, vaddr, UPROBE_SWBP_INSN);
+	return uprobe_write_opcode(mm, vaddr, UPROBE_SWBP_INSN);
 }
 
 /**
@@ -330,7 +330,7 @@ int __weak set_swbp(struct arch_uprobe *auprobe, struct mm_struct *mm, unsigned
 int __weak
 set_orig_insn(struct arch_uprobe *auprobe, struct mm_struct *mm, unsigned long vaddr)
 {
-	return write_opcode(mm, vaddr, *(uprobe_opcode_t *)auprobe->insn);
+	return uprobe_write_opcode(mm, vaddr, *(uprobe_opcode_t *)auprobe->insn);
 }
 
 static int match_uprobe(struct uprobe *l, struct uprobe *r)
@@ -577,7 +577,7 @@ static int prepare_uprobe(struct uprobe *uprobe, struct file *file,
 	if (ret)
 		goto out;
 
-	/* write_opcode() assumes we don't cross page boundary */
+	/* uprobe_write_opcode() assumes we don't cross page boundary */
 	BUG_ON((uprobe->offset & ~PAGE_MASK) +
 			UPROBE_SWBP_INSN_SIZE > PAGE_SIZE);
 
@@ -1264,7 +1264,8 @@ static unsigned long xol_get_insn_slot(struct uprobe *uprobe)
 		return 0;
 
 	/* Initialize the slot */
-	copy_to_page(area->page, xol_vaddr, uprobe->arch.insn, MAX_UINSN_BYTES);
+	copy_to_page(area->page, xol_vaddr,
+			uprobe->arch.ixol, sizeof(uprobe->arch.ixol));
 	/*
 	 * We probably need flush_icache_user_range() but it needs vma.
 	 * This should work on supported architectures too.
@@ -1941,9 +1942,4 @@ static int __init init_uprobes(void)
 
 	return register_die_notifier(&uprobe_exception_nb);
 }
-module_init(init_uprobes);
-
-static void __exit exit_uprobes(void)
-{
-}
-module_exit(exit_uprobes);
+__initcall(init_uprobes);

