Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934358AbaDITol (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 15:44:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16894 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934320AbaDIToi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 15:44:38 -0400
Date: Wed, 9 Apr 2014 21:44:34 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <aarapov@redhat.com>, David Long <dave.long@linaro.org>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Jim Keniston <jkenisto@us.ibm.com>, Jonathan Lebon <jlebon@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH v2 4/6] uprobes/x86: Emulate rip-relative call's
Message-ID: <20140409194434.GA6235@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140409194401.GA5854@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

0xe8. Anything else?

Emulating of rip-relative call is trivial, we only need to additionally
push the ret-address. If this fails, we execute this instruction out of
line and this should trigger the trap, the probed application should die
or the same insn will be restarted if a signal handler expands the stack.
We do not even need ->post_xol() for this case.

But there is a corner (and almost theoretical) case: another thread can
expand the stack right before we execute this insn out of line. In this
case it hit the same problem we are trying to solve. So we simply turn
the probed insn into "call 1f; 1:" and add ->post_xol() which restores
->sp and restarts.

Many thanks to Jonathan who finally found the standalone reproducer,
otherwise I would never resolve the "random SIGSEGV's under systemtap"
bug-report. Now that the problem is clear we can write the simplified
test-case:

	void probe_func(void), callee(void);

	int failed = 1;

	asm (
		".text\n"
		".align 4096\n"
		".globl probe_func\n"
		"probe_func:\n"
		"call callee\n"
		"ret"
	);

	/*
	 * This assumes that:
	 *
	 *	- &probe_func = 0x401000 + a_bit, aligned = 0x402000
	 *
	 *	- xol_vma->vm_start = TASK_SIZE_MAX - PAGE_SIZE = 0x7fffffffe000
	 *	  as xol_add_vma() asks; the 1st slot = 0x7fffffffe080
	 *
	 * so we can target the non-canonical address from xol_vma using
	 * the simple math below, 100 * 4096 is just the random offset
	 */
	asm (".org . + 0x800000000000 - 0x7fffffffe080 - 5 - 1  + 100 * 4096\n");

	void callee(void)
	{
		failed = 0;
	}

	int main(void)
	{
		probe_func();
		return failed;
	}

It SIGSEGV's if you probe "probe_func" (although it's not very reliable,
randomize_va_space/etc can change the placement of xol area).

Reported-by: Jonathan Lebon <jlebon@redhat.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 arch/x86/include/asm/uprobes.h |    1 +
 arch/x86/kernel/uprobes.c      |   69 ++++++++++++++++++++++++++++++++++------
 2 files changed, 60 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/uprobes.h b/arch/x86/include/asm/uprobes.h
index cca62c5..9528117 100644
--- a/arch/x86/include/asm/uprobes.h
+++ b/arch/x86/include/asm/uprobes.h
@@ -51,6 +51,7 @@ struct arch_uprobe {
 		struct {
 			s32	disp;
 			u8	ilen;
+			u8	opc1;
 		}				ttt;
 	};
 };
diff --git a/arch/x86/kernel/uprobes.c b/arch/x86/kernel/uprobes.c
index 23a16a5..5a88022 100644
--- a/arch/x86/kernel/uprobes.c
+++ b/arch/x86/kernel/uprobes.c
@@ -461,34 +461,86 @@ static struct uprobe_xol_ops default_xol_ops = {
 	.post_xol = default_post_xol_op,
 };
 
+static bool ttt_is_call(struct arch_uprobe *auprobe)
+{
+	return auprobe->ttt.opc1 == 0xe8;
+}
+
 static bool ttt_emulate_op(struct arch_uprobe *auprobe, struct pt_regs *regs)
 {
-	regs->ip += auprobe->ttt.ilen + auprobe->ttt.disp;
+	unsigned long new_ip = regs->ip += auprobe->ttt.ilen;
+
+	if (ttt_is_call(auprobe)) {
+		unsigned long new_sp = regs->sp - sizeof_long();
+		if (copy_to_user((void __user *)new_sp, &new_ip, sizeof_long()))
+			return false;
+		regs->sp = new_sp;
+	}
+
+	regs->ip = new_ip + auprobe->ttt.disp;
 	return true;
 }
 
+static int ttt_post_xol_op(struct arch_uprobe *auprobe, struct pt_regs *regs)
+{
+	BUG_ON(!ttt_is_call(auprobe));
+	/*
+	 * We can only get here if ttt_emulate_op() failed to push the return
+	 * address _and_ another thread expanded our stack before the (mangled)
+	 * "call" insn was executed out-of-line. Just restore ->sp and restart.
+	 * We could also restore ->ip and try to call ttt_emulate_op() again.
+	 */
+	regs->sp += sizeof_long();
+	return -ERESTART;
+}
+
+static void ttt_clear_displacement(struct arch_uprobe *auprobe, struct insn *insn)
+{
+	/*
+	 * Turn this insn into "call 1f; 1:", this is what we will execute
+	 * out-of-line if ->emulate() fails.
+	 *
+	 * In the likely case this will lead to arch_uprobe_abort_xol(), but
+	 * see the comment in ->emulate(). So we need to ensure that the new
+	 * ->ip can't fall into non-canonical area and trigger #GP.
+	 *
+	 * We could turn it into (say) "pushf", but then we would need to
+	 * divorce ->insn[] and ->ixol[]. We need to preserve the 1st byte
+	 * of ->insn[] for set_orig_insn().
+	 */
+	memset(auprobe->insn + insn_offset_immediate(insn),
+		0, insn->immediate.nbytes);
+}
+
 static struct uprobe_xol_ops ttt_xol_ops = {
 	.emulate  = ttt_emulate_op,
+	.post_xol = ttt_post_xol_op,
 };
 
 /* Returns -ENOSYS if ttt_xol_ops doesn't handle this insn */
 static int ttt_setup_xol_ops(struct arch_uprobe *auprobe, struct insn *insn)
 {
+	u8 opc1 = OPCODE1(insn);
+
+	/* has the side-effect of processing the entire instruction */
+	insn_get_length(insn);
+	if (WARN_ON_ONCE(!insn_complete(insn)))
+		return -ENOEXEC;
 
-	switch (OPCODE1(insn)) {
+	switch (opc1) {
 	case 0xeb:	/* jmp 8 */
 	case 0xe9:	/* jmp 32 */
 	case 0x90:	/* prefix* + nop; same as jmp with .disp = 0 */
 		break;
+
+	case 0xe8:	/* call relative */
+		ttt_clear_displacement(auprobe, insn);
+		break;
 	default:
 		return -ENOSYS;
 	}
 
-	/* has the side-effect of processing the entire instruction */
-	insn_get_length(insn);
-	if (WARN_ON_ONCE(!insn_complete(insn)))
-		return -ENOEXEC;
-
+	auprobe->ttt.opc1 = opc1;
 	auprobe->ttt.ilen = insn->length;
 	auprobe->ttt.disp = insn->immediate.value;
 
@@ -532,9 +584,6 @@ int arch_uprobe_analyze_insn(struct arch_uprobe *auprobe, struct mm_struct *mm,
 	case 0xca:
 		fix_ip = false;
 		break;
-	case 0xe8:		/* call relative - Fix return addr */
-		fix_call = true;
-		break;
 	case 0x9a:		/* call absolute - Fix return addr, not ip */
 		fix_call = true;
 		fix_ip = false;
-- 
1.5.5.1

