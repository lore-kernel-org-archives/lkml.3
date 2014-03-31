Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751694AbaCaUq2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 16:46:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20933 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751510AbaCaUpG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 16:45:06 -0400
Date: Mon, 31 Mar 2014 21:44:15 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        David Long <dave.long@linaro.org>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Jim Keniston <jkenisto@us.ibm.com>, Jonathan Lebon <jlebon@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 7/7] uprobes/x86: Introduce uprobe_xol_ops and
	arch_uprobe->ops
Message-ID: <20140331194415.GA9307@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140331194337.GA9257@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce arch_uprobe->ops pointing to the "struct uprobe_xol_ops",
move the current UPROBE_FIX_{RIP*,IP,CALL} code into the default
set of methods and change arch_uprobe_pre/post_xol() accordingly.

This way we can add the new uprobe_xol_ops's to handle the insns
which need the special processing (rip-relative jmp/call at least).

TODO: An error from adjust_ret_addr() shouldn't be silently ignored,
we should teach arch_uprobe_post_xol() or handle_singlestep() paths
to restart the probed insn in this case. And probably "adjust" can
be simplified and turned into set_ret_addr(). It seems that we do
not really need copy_from_user(), we can always calculate the value
we need to write into *regs->sp.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 arch/x86/include/asm/uprobes.h |    7 ++-
 arch/x86/kernel/uprobes.c      |  107 +++++++++++++++++++++++++--------------
 2 files changed, 74 insertions(+), 40 deletions(-)

diff --git a/arch/x86/include/asm/uprobes.h b/arch/x86/include/asm/uprobes.h
index 3087ea9..9f8210b 100644
--- a/arch/x86/include/asm/uprobes.h
+++ b/arch/x86/include/asm/uprobes.h
@@ -33,12 +33,17 @@ typedef u8 uprobe_opcode_t;
 #define UPROBE_SWBP_INSN		0xcc
 #define UPROBE_SWBP_INSN_SIZE		   1
 
+struct uprobe_xol_ops;
+
 struct arch_uprobe {
-	u16				fixups;
 	union {
 		u8			insn[MAX_UINSN_BYTES];
 		u8			ixol[MAX_UINSN_BYTES];
 	};
+
+	u16				fixups;
+	const struct uprobe_xol_ops	*ops;
+
 #ifdef CONFIG_X86_64
 	unsigned long			rip_rela_target_address;
 #endif
diff --git a/arch/x86/kernel/uprobes.c b/arch/x86/kernel/uprobes.c
index 7dd65dc..a822de5 100644
--- a/arch/x86/kernel/uprobes.c
+++ b/arch/x86/kernel/uprobes.c
@@ -402,6 +402,64 @@ static int validate_insn_bits(struct arch_uprobe *auprobe, struct mm_struct *mm,
 }
 #endif /* CONFIG_X86_64 */
 
+struct uprobe_xol_ops {
+	bool	(*emulate)(struct arch_uprobe *, struct pt_regs *);
+	int	(*pre_xol)(struct arch_uprobe *, struct pt_regs *);
+	int	(*post_xol)(struct arch_uprobe *, struct pt_regs *);
+};
+
+static int default_pre_xol_op(struct arch_uprobe *auprobe, struct pt_regs *regs)
+{
+	pre_xol_rip_insn(auprobe, regs, &current->utask->autask);
+	return 0;
+}
+
+/*
+ * Adjust the return address pushed by a call insn executed out of line.
+ */
+static int adjust_ret_addr(unsigned long sp, long correction)
+{
+	int rasize, ncopied;
+	long ra = 0;
+
+	if (is_ia32_task())
+		rasize = 4;
+	else
+		rasize = 8;
+
+	ncopied = copy_from_user(&ra, (void __user *)sp, rasize);
+	if (unlikely(ncopied))
+		return -EFAULT;
+
+	ra += correction;
+	ncopied = copy_to_user((void __user *)sp, &ra, rasize);
+	if (unlikely(ncopied))
+		return -EFAULT;
+
+	return 0;
+}
+
+static int default_post_xol_op(struct arch_uprobe *auprobe, struct pt_regs *regs)
+{
+	struct uprobe_task *utask = current->utask;
+	long correction = (long)(utask->vaddr - utask->xol_vaddr);
+	int ret = 0;
+
+	handle_riprel_post_xol(auprobe, regs, &correction);
+	if (auprobe->fixups & UPROBE_FIX_IP)
+		regs->ip += correction;
+
+	if (auprobe->fixups & UPROBE_FIX_CALL)
+		ret = adjust_ret_addr(regs->sp, correction);
+
+	return ret;
+}
+
+static struct uprobe_xol_ops defaule_xop_ops = {
+	.pre_xol  = default_pre_xol_op,
+	.post_xol = default_post_xol_op,
+};
+
 /**
  * arch_uprobe_analyze_insn - instruction analysis including validity and fixups.
  * @mm: the probed address space.
@@ -462,6 +520,7 @@ int arch_uprobe_analyze_insn(struct arch_uprobe *auprobe, struct mm_struct *mm,
 	if (fix_call)
 		auprobe->fixups |= UPROBE_FIX_CALL;
 
+	auprobe->ops = &defaule_xop_ops;
 	return 0;
 }
 
@@ -483,33 +542,8 @@ int arch_uprobe_pre_xol(struct arch_uprobe *auprobe, struct pt_regs *regs)
 	if (test_tsk_thread_flag(current, TIF_BLOCKSTEP))
 		set_task_blockstep(current, false);
 
-	pre_xol_rip_insn(auprobe, regs, &utask->autask);
-	return 0;
-}
-
-/*
- * This function is called by arch_uprobe_post_xol() to adjust the return
- * address pushed by a call instruction executed out of line.
- */
-static int adjust_ret_addr(unsigned long sp, long correction)
-{
-	int rasize, ncopied;
-	long ra = 0;
-
-	if (is_ia32_task())
-		rasize = 4;
-	else
-		rasize = 8;
-
-	ncopied = copy_from_user(&ra, (void __user *)sp, rasize);
-	if (unlikely(ncopied))
-		return -EFAULT;
-
-	ra += correction;
-	ncopied = copy_to_user((void __user *)sp, &ra, rasize);
-	if (unlikely(ncopied))
-		return -EFAULT;
-
+	if (auprobe->ops->pre_xol)
+		return auprobe->ops->pre_xol(auprobe, regs);
 	return 0;
 }
 
@@ -558,11 +592,8 @@ bool arch_uprobe_xol_was_trapped(struct task_struct *t)
 int arch_uprobe_post_xol(struct arch_uprobe *auprobe, struct pt_regs *regs)
 {
 	struct uprobe_task *utask = current->utask;
-	long correction;
-	int result = 0;
 
 	WARN_ON_ONCE(current->thread.trap_nr != UPROBE_TRAP_NR);
-
 	current->thread.trap_nr = utask->autask.saved_trap_nr;
 	/*
 	 * arch_uprobe_pre_xol() doesn't save the state of TIF_BLOCKSTEP
@@ -574,15 +605,9 @@ int arch_uprobe_post_xol(struct arch_uprobe *auprobe, struct pt_regs *regs)
 	else if (!(auprobe->fixups & UPROBE_FIX_SETF))
 		regs->flags &= ~X86_EFLAGS_TF;
 
-	correction = (long)(utask->vaddr - utask->xol_vaddr);
-	handle_riprel_post_xol(auprobe, regs, &correction);
-	if (auprobe->fixups & UPROBE_FIX_IP)
-		regs->ip += correction;
-
-	if (auprobe->fixups & UPROBE_FIX_CALL)
-		result = adjust_ret_addr(regs->sp, correction);
-
-	return result;
+	if (auprobe->ops->post_xol)
+		return auprobe->ops->post_xol(auprobe, regs);
+	return 0;
 }
 
 /* callback routine for handling exceptions. */
@@ -640,6 +665,10 @@ static bool __skip_sstep(struct arch_uprobe *auprobe, struct pt_regs *regs)
 {
 	int i;
 
+	if (auprobe->ops->emulate)
+		return auprobe->ops->emulate(auprobe, regs);
+
+	/* TODO: move this code into ->emulate() hook */
 	for (i = 0; i < MAX_UINSN_BYTES; i++) {
 		if (auprobe->insn[i] == 0x66)
 			continue;
-- 
1.5.5.1

