Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934380AbaDITor (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 15:44:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11021 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934320AbaDIToo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 15:44:44 -0400
Date: Wed, 9 Apr 2014 21:44:38 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <aarapov@redhat.com>, David Long <dave.long@linaro.org>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Jim Keniston <jkenisto@us.ibm.com>, Jonathan Lebon <jlebon@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH v2 5/6] uprobes/x86: Emulate rip-relative conditional
	"short" jmp's
Message-ID: <20140409194438.GA6238@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140409194401.GA5854@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Incomplete, lacks "jcxz". Simple to fix. Anything else?

Reported-by: Jonathan Lebon <jlebon@redhat.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 arch/x86/kernel/uprobes.c |   57 +++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 55 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/uprobes.c b/arch/x86/kernel/uprobes.c
index 5a88022..ab9342a 100644
--- a/arch/x86/kernel/uprobes.c
+++ b/arch/x86/kernel/uprobes.c
@@ -466,18 +466,69 @@ static bool ttt_is_call(struct arch_uprobe *auprobe)
 	return auprobe->ttt.opc1 == 0xe8;
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
+	switch (auprobe->ttt.opc1) {
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
 static bool ttt_emulate_op(struct arch_uprobe *auprobe, struct pt_regs *regs)
 {
 	unsigned long new_ip = regs->ip += auprobe->ttt.ilen;
+	unsigned long disp = (long)auprobe->ttt.disp;
 
 	if (ttt_is_call(auprobe)) {
 		unsigned long new_sp = regs->sp - sizeof_long();
 		if (copy_to_user((void __user *)new_sp, &new_ip, sizeof_long()))
 			return false;
 		regs->sp = new_sp;
+	} else if (!check_jmp_cond(auprobe, regs)) {
+		disp = 0;
 	}
 
-	regs->ip = new_ip + auprobe->ttt.disp;
+	regs->ip = new_ip + disp;
 	return true;
 }
 
@@ -536,8 +587,10 @@ static int ttt_setup_xol_ops(struct arch_uprobe *auprobe, struct insn *insn)
 	case 0xe8:	/* call relative */
 		ttt_clear_displacement(auprobe, insn);
 		break;
+
 	default:
-		return -ENOSYS;
+		if (!is_cond_jmp_opcode(opc1))
+			return -ENOSYS;
 	}
 
 	auprobe->ttt.opc1 = opc1;
-- 
1.5.5.1

