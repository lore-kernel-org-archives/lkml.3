Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756020AbaDMRs6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2014 13:48:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12210 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755412AbaDMRqS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2014 13:46:18 -0400
Date: Sun, 13 Apr 2014 19:46:10 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <aarapov@redhat.com>, David Long <dave.long@linaro.org>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Jim Keniston <jkenisto@us.ibm.com>, Jonathan Lebon <jlebon@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 14/15] uprobes/x86: Emulate relative conditional "short"
	jmp's
Message-ID: <20140413174610.GA11898@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140413174508.GA11811@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Teach branch_emulate_op() to emulate the conditional "short" jmp's which
check regs->flags.

Note: this doesn't support jcxz/jcexz, loope/loopz, and loopne/loopnz.
They all are rel8 and thus they can't trigger the problem, but perhaps
we will add the support in future just for completeness.

Reported-by: Jonathan Lebon <jlebon@redhat.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Reviewed-by: Jim Keniston <jkenisto@us.ibm.com>
---
 arch/x86/kernel/uprobes.c |   57 +++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 55 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/uprobes.c b/arch/x86/kernel/uprobes.c
index 68034b0..b5f2fa4 100644
--- a/arch/x86/kernel/uprobes.c
+++ b/arch/x86/kernel/uprobes.c
@@ -466,9 +466,58 @@ static bool branch_is_call(struct arch_uprobe *auprobe)
 	return auprobe->branch.opc1 == 0xe8;
 }
 
+#define CASE_COND					\
+	COND(70, 71, XF(OF))				\
+	COND(72, 73, XF(CF))				\
+	COND(74, 75, XF(ZF))				\
+	COND(78, 79, XF(SF))				\
+	COND(7a, 7b, XF(PF))				\
+	COND(76, 77, XF(CF) || XF(ZF))			\
+	COND(7c, 7d, XF(SF) != XF(OF))			\
+	COND(7e, 7f, XF(ZF) || XF(SF) != XF(OF))
+
+#define COND(op_y, op_n, expr)				\
+	case 0x ## op_y: DO((expr) != 0)		\
+	case 0x ## op_n: DO((expr) == 0)
+
+#define XF(xf)	(!!(flags & X86_EFLAGS_ ## xf))
+
+static bool is_cond_jmp_opcode(u8 opcode)
+{
+	switch (opcode) {
+	#define DO(expr)	\
+		return true;
+	CASE_COND
+	#undef	DO
+
+	default:
+		return false;
+	}
+}
+
+static bool check_jmp_cond(struct arch_uprobe *auprobe, struct pt_regs *regs)
+{
+	unsigned long flags = regs->flags;
+
+	switch (auprobe->branch.opc1) {
+	#define DO(expr)	\
+		return expr;
+	CASE_COND
+	#undef	DO
+
+	default:	/* not a conditional jmp */
+		return true;
+	}
+}
+
+#undef	XF
+#undef	COND
+#undef	CASE_COND
+
 static bool branch_emulate_op(struct arch_uprobe *auprobe, struct pt_regs *regs)
 {
 	unsigned long new_ip = regs->ip += auprobe->branch.ilen;
+	unsigned long offs = (long)auprobe->branch.offs;
 
 	if (branch_is_call(auprobe)) {
 		unsigned long new_sp = regs->sp - sizeof_long();
@@ -484,9 +533,11 @@ static bool branch_emulate_op(struct arch_uprobe *auprobe, struct pt_regs *regs)
 		if (copy_to_user((void __user *)new_sp, &new_ip, sizeof_long()))
 			return false;
 		regs->sp = new_sp;
+	} else if (!check_jmp_cond(auprobe, regs)) {
+		offs = 0;
 	}
 
-	regs->ip = new_ip + auprobe->branch.offs;
+	regs->ip = new_ip + offs;
 	return true;
 }
 
@@ -547,8 +598,10 @@ static int branch_setup_xol_ops(struct arch_uprobe *auprobe, struct insn *insn)
 	case 0xe8:	/* call relative */
 		branch_clear_offset(auprobe, insn);
 		break;
+
 	default:
-		return -ENOSYS;
+		if (!is_cond_jmp_opcode(opc1))
+			return -ENOSYS;
 	}
 
 	auprobe->branch.opc1 = opc1;
-- 
1.5.5.1

