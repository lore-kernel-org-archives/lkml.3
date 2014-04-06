Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754587AbaDFUQj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2014 16:16:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56989 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754513AbaDFUQb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2014 16:16:31 -0400
Date: Sun, 6 Apr 2014 22:16:32 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <aarapov@redhat.com>, David Long <dave.long@linaro.org>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Jim Keniston <jkenisto@us.ibm.com>, Jonathan Lebon <jlebon@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH 5/6] uprobes/x86: Emulate rip-relative conditional
	"short" jmp's
Message-ID: <20140406201632.GA514@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140406201524.GA32694@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Incomplete, lacks "jcxz". Simple to fix. Anything else?

Reported-by: Jonathan Lebon <jlebon@redhat.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 arch/x86/kernel/uprobes.c |   46 ++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 45 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/uprobes.c b/arch/x86/kernel/uprobes.c
index 9283024..797b8a4 100644
--- a/arch/x86/kernel/uprobes.c
+++ b/arch/x86/kernel/uprobes.c
@@ -466,18 +466,56 @@ static bool ttt_is_call(struct arch_uprobe *auprobe)
 	return auprobe->ttt.opc1 == 0xe8;
 }
 
+#define X86_COND_OPCODES			\
+	CASE(70, 71, XF(OF))			\
+	CASE(72, 73, XF(CF))			\
+	CASE(74, 75, XF(ZF))			\
+	CASE(78, 79, XF(SF))			\
+	CASE(7a, 7b, XF(PF))			\
+	CASE(76, 77, XF(CF) || XF(ZF))		\
+	CASE(7c, 7d, XF(SF) != XF(OF))		\
+	CASE(7e, 7f, XF(ZF) || XF(SF) != XF(OF))
+
+static bool ck_cond_opcode(struct arch_uprobe *auprobe, struct pt_regs *regs)
+{
+	unsigned long flags = regs->flags;
+	bool ret;
+
+	switch (auprobe->ttt.opc1) {
+	case 0x00:	/* not a conditional jmp */
+		return true;
+
+	#define XF(xf)	(!!(flags & X86_EFLAGS_ ## xf))
+	#define CASE(op_y, op_n, cond)	\
+		case 0x ## op_y: ret = (cond) != 0; break;	\
+		case 0x ## op_n: ret = (cond) == 0; break;
+
+	X86_COND_OPCODES
+	#undef CASE
+	#undef XF
+
+	default:
+		BUG();
+	}
+
+	return ret;
+}
+
 static bool ttt_emulate_op(struct arch_uprobe *auprobe, struct pt_regs *regs)
 {
 	unsigned long new_ip = regs->ip += auprobe->ttt.ilen;
+	unsigned long disp = auprobe->ttt.disp;
 
 	if (ttt_is_call(auprobe)) {
 		unsigned long new_sp = regs->sp - sizeof_long();
 		if (copy_to_user((void __user *)new_sp, &new_ip, sizeof_long()))
 			return false;
 		regs->sp = new_sp;
+	} else if (!ck_cond_opcode(auprobe, regs)) {
+		disp = 0;
 	}
 
-	regs->ip = new_ip + auprobe->ttt.disp;
+	regs->ip = new_ip + disp;
 	return true;
 }
 
@@ -534,8 +572,14 @@ static int ttt_setup_xol_ops(struct arch_uprobe *auprobe, struct insn *insn)
 
 	case 0xe8:	/* call relative */
 		ttt_clear_displacement(auprobe, insn);
+		/* fall through */
+	#define CASE(op_y, op_n, cond)	\
+			case 0x ## op_y: case 0x ## op_n:
+	X86_COND_OPCODES
+	#undef CASE
 		auprobe->ttt.opc1 = opc1;
 		break;
+
 	default:
 		return -ENOSYS;
 	}
-- 
1.5.5.1

