Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964946AbaDIToi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 15:44:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17239 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934320AbaDITod (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 15:44:33 -0400
Date: Wed, 9 Apr 2014 21:44:31 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <aarapov@redhat.com>, David Long <dave.long@linaro.org>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Jim Keniston <jkenisto@us.ibm.com>, Jonathan Lebon <jlebon@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH v2 3/6] uprobes/x86: Emulate nop's using ops->emulate()
Message-ID: <20140409194431.GA6228@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140409194401.GA5854@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Finally we can kill the ugly (and very limited) code in __skip_sstep().
Just change ttt_setup_xol_ops() to treat "nop" as jmp to the next insn.

Thanks to lib/insn.c, it is clever enough. OPCODE1() == 0x90 includes
"(rep;)+ nop;" at least, and (afaics) much more.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 arch/x86/kernel/uprobes.c |   20 +-------------------
 1 files changed, 1 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kernel/uprobes.c b/arch/x86/kernel/uprobes.c
index 1cdc379..23a16a5 100644
--- a/arch/x86/kernel/uprobes.c
+++ b/arch/x86/kernel/uprobes.c
@@ -478,6 +478,7 @@ static int ttt_setup_xol_ops(struct arch_uprobe *auprobe, struct insn *insn)
 	switch (OPCODE1(insn)) {
 	case 0xeb:	/* jmp 8 */
 	case 0xe9:	/* jmp 32 */
+	case 0x90:	/* prefix* + nop; same as jmp with .disp = 0 */
 		break;
 	default:
 		return -ENOSYS;
@@ -710,29 +711,10 @@ void arch_uprobe_abort_xol(struct arch_uprobe *auprobe, struct pt_regs *regs)
 		regs->flags &= ~X86_EFLAGS_TF;
 }
 
-/*
- * Skip these instructions as per the currently known x86 ISA.
- * rep=0x66*; nop=0x90
- */
 static bool __skip_sstep(struct arch_uprobe *auprobe, struct pt_regs *regs)
 {
-	int i;
-
 	if (auprobe->ops->emulate)
 		return auprobe->ops->emulate(auprobe, regs);
-
-	/* TODO: move this code into ->emulate() hook */
-	for (i = 0; i < MAX_UINSN_BYTES; i++) {
-		if (auprobe->insn[i] == 0x66)
-			continue;
-
-		if (auprobe->insn[i] == 0x90) {
-			regs->ip += i + 1;
-			return true;
-		}
-
-		break;
-	}
 	return false;
 }
 
-- 
1.5.5.1

