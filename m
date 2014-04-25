Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754186AbaDYRtJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 13:49:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64992 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753089AbaDYRrr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 13:47:47 -0400
Date: Fri, 25 Apr 2014 19:47:28 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <aarapov@redhat.com>, David Long <dave.long@linaro.org>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Jim Keniston <jkenisto@us.ibm.com>, Jonathan Lebon <jlebon@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] uprobes/x86: Kill adjust_ret_addr(), simplify
	UPROBE_FIX_CALL logic
Message-ID: <20140425174728.GA7976@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140425174704.GA7898@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The only insn which could have both UPROBE_FIX_IP and UPROBE_FIX_CALL
was 0xe8 "call relative", and now it is handled by branch_xol_ops.

So we can change default_post_xol_op(UPROBE_FIX_CALL) to simply push
the address of next insn == utask->vaddr + insn.length, just we need
to record insn.length into the new auprobe->def.ilen member.

Note: if/when we teach branch_xol_ops to support jcxz/loopz we can
remove the "correction" logic, UPROBE_FIX_IP can use the same address.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 arch/x86/include/asm/uprobes.h |    1 +
 arch/x86/kernel/uprobes.c      |   24 +++---------------------
 2 files changed, 4 insertions(+), 21 deletions(-)

diff --git a/arch/x86/include/asm/uprobes.h b/arch/x86/include/asm/uprobes.h
index 9ce25ce..a040d49 100644
--- a/arch/x86/include/asm/uprobes.h
+++ b/arch/x86/include/asm/uprobes.h
@@ -54,6 +54,7 @@ struct arch_uprobe {
 			long	riprel_target;
 #endif
 			u8	fixups;
+			u8	ilen;
 		} 			def;
 	};
 };
diff --git a/arch/x86/kernel/uprobes.c b/arch/x86/kernel/uprobes.c
index 48d2623..4c60b7a 100644
--- a/arch/x86/kernel/uprobes.c
+++ b/arch/x86/kernel/uprobes.c
@@ -418,24 +418,6 @@ static int push_ret_address(struct pt_regs *regs, unsigned long ip)
 	return 0;
 }
 
-/*
- * Adjust the return address pushed by a call insn executed out of line.
- */
-static int adjust_ret_addr(unsigned long sp, long correction)
-{
-	int rasize = sizeof_long();
-	long ra;
-
-	if (copy_from_user(&ra, (void __user *)sp, rasize))
-		return -EFAULT;
-
-	ra += correction;
-	if (copy_to_user((void __user *)sp, &ra, rasize))
-		return -EFAULT;
-
-	return 0;
-}
-
 static int default_post_xol_op(struct arch_uprobe *auprobe, struct pt_regs *regs)
 {
 	struct uprobe_task *utask = current->utask;
@@ -446,10 +428,9 @@ static int default_post_xol_op(struct arch_uprobe *auprobe, struct pt_regs *regs
 		regs->ip += correction;
 
 	if (auprobe->def.fixups & UPROBE_FIX_CALL) {
-		if (adjust_ret_addr(regs->sp, correction)) {
-			regs->sp += sizeof_long();
+		regs->sp += sizeof_long();
+		if (push_ret_address(regs, utask->vaddr + auprobe->def.ilen))
 			return -ERESTART;
-		}
 	}
 	/* popf; tell the caller to not touch TF */
 	if (auprobe->def.fixups & UPROBE_FIX_SETF)
@@ -676,6 +657,7 @@ int arch_uprobe_analyze_insn(struct arch_uprobe *auprobe, struct mm_struct *mm,
 		handle_riprel_insn(auprobe, &insn);
 	}
 
+	auprobe->def.ilen = insn.length;
 	if (fix_ip)
 		auprobe->def.fixups |= UPROBE_FIX_IP;
 	if (fix_call)
-- 
1.5.5.1

