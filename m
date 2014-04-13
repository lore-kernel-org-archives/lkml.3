Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755731AbaDMRqg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2014 13:46:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64264 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754928AbaDMRqO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2014 13:46:14 -0400
Date: Sun, 13 Apr 2014 19:46:07 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <aarapov@redhat.com>, David Long <dave.long@linaro.org>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Jim Keniston <jkenisto@us.ibm.com>, Jonathan Lebon <jlebon@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 13/15] uprobes/x86: Emulate relative call's
Message-ID: <20140413174607.GA11895@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140413174508.GA11811@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

See the previous "Emulate unconditional relative jmp's" which explains
why we can not execute "jmp" out-of-line, the same applies to "call".

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

It SIGSEGV's if you probe "probe_func" (although this is not very reliable,
randomize_va_space/etc can change the placement of xol area).

Note: as Denys Vlasenko pointed out, amd and intel treat "callw" (0x66 0xe8)
differently. This patch relies on lib/insn.c and thus implements the intel's
behaviour: 0x66 is simply ignored. Fortunately nothing sane should ever use
this insn, so we postpone the fix until we decide what should we do; emulate
or not, support or not, etc.

Reported-by: Jonathan Lebon <jlebon@redhat.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Reviewed-by: Jim Keniston <jkenisto@us.ibm.com>
---
 arch/x86/include/asm/uprobes.h |    1 +
 arch/x86/kernel/uprobes.c      |   80 +++++++++++++++++++++++++++++++++++-----
 2 files changed, 71 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/uprobes.h b/arch/x86/include/asm/uprobes.h
index e9fd4d5..93bee7b 100644
--- a/arch/x86/include/asm/uprobes.h
+++ b/arch/x86/include/asm/uprobes.h
@@ -51,6 +51,7 @@ struct arch_uprobe {
 		struct {
 			s32	offs;
 			u8	ilen;
+			u8	opc1;
 		}				branch;
 	};
 };
diff --git a/arch/x86/kernel/uprobes.c b/arch/x86/kernel/uprobes.c
index e228d95..68034b0 100644
--- a/arch/x86/kernel/uprobes.c
+++ b/arch/x86/kernel/uprobes.c
@@ -461,34 +461,97 @@ static struct uprobe_xol_ops default_xol_ops = {
 	.post_xol = default_post_xol_op,
 };
 
+static bool branch_is_call(struct arch_uprobe *auprobe)
+{
+	return auprobe->branch.opc1 == 0xe8;
+}
+
 static bool branch_emulate_op(struct arch_uprobe *auprobe, struct pt_regs *regs)
 {
-	regs->ip += auprobe->branch.ilen + auprobe->branch.offs;
+	unsigned long new_ip = regs->ip += auprobe->branch.ilen;
+
+	if (branch_is_call(auprobe)) {
+		unsigned long new_sp = regs->sp - sizeof_long();
+		/*
+		 * If it fails we execute this (mangled, see the comment in
+		 * branch_clear_offset) insn out-of-line. In the likely case
+		 * this should trigger the trap, and the probed application
+		 * should die or restart the same insn after it handles the
+		 * signal, arch_uprobe_post_xol() won't be even called.
+		 *
+		 * But there is corner case, see the comment in ->post_xol().
+		 */
+		if (copy_to_user((void __user *)new_sp, &new_ip, sizeof_long()))
+			return false;
+		regs->sp = new_sp;
+	}
+
+	regs->ip = new_ip + auprobe->branch.offs;
 	return true;
 }
 
+static int branch_post_xol_op(struct arch_uprobe *auprobe, struct pt_regs *regs)
+{
+	BUG_ON(!branch_is_call(auprobe));
+	/*
+	 * We can only get here if branch_emulate_op() failed to push the ret
+	 * address _and_ another thread expanded our stack before the (mangled)
+	 * "call" insn was executed out-of-line. Just restore ->sp and restart.
+	 * We could also restore ->ip and try to call branch_emulate_op() again.
+	 */
+	regs->sp += sizeof_long();
+	return -ERESTART;
+}
+
+static void branch_clear_offset(struct arch_uprobe *auprobe, struct insn *insn)
+{
+	/*
+	 * Turn this insn into "call 1f; 1:", this is what we will execute
+	 * out-of-line if ->emulate() fails. We only need this to generate
+	 * a trap, so that the probed task receives the correct signal with
+	 * the properly filled siginfo.
+	 *
+	 * But see the comment in ->post_xol(), in the unlikely case it can
+	 * succeed. So we need to ensure that the new ->ip can not fall into
+	 * the non-canonical area and trigger #GP.
+	 *
+	 * We could turn it into (say) "pushf", but then we would need to
+	 * divorce ->insn[] and ->ixol[]. We need to preserve the 1st byte
+	 * of ->insn[] for set_orig_insn().
+	 */
+	memset(auprobe->insn + insn_offset_immediate(insn),
+		0, insn->immediate.nbytes);
+}
+
 static struct uprobe_xol_ops branch_xol_ops = {
 	.emulate  = branch_emulate_op,
+	.post_xol = branch_post_xol_op,
 };
 
 /* Returns -ENOSYS if branch_xol_ops doesn't handle this insn */
 static int branch_setup_xol_ops(struct arch_uprobe *auprobe, struct insn *insn)
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
 	case 0x90:	/* prefix* + nop; same as jmp with .offs = 0 */
 		break;
+
+	case 0xe8:	/* call relative */
+		branch_clear_offset(auprobe, insn);
+		break;
 	default:
 		return -ENOSYS;
 	}
 
-	/* has the side-effect of processing the entire instruction */
-	insn_get_length(insn);
-	if (WARN_ON_ONCE(!insn_complete(insn)))
-		return -ENOEXEC;
-
+	auprobe->branch.opc1 = opc1;
 	auprobe->branch.ilen = insn->length;
 	auprobe->branch.offs = insn->immediate.value;
 
@@ -532,9 +595,6 @@ int arch_uprobe_analyze_insn(struct arch_uprobe *auprobe, struct mm_struct *mm,
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

