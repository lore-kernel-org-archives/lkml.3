Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753514AbaD0Qww (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 12:52:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14110 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753350AbaD0Qwt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 12:52:49 -0400
Date: Sun, 27 Apr 2014 18:52:27 +0200
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
Subject: [PATCH 2/3] uprobes/x86: Kill the "autask" arg of riprel_pre_xol()
Message-ID: <20140427165227.GA4016@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140427165200.GA3956@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

default_pre_xol_op() passes &current->utask->autask to riprel_pre_xol()
and this is just ugly because it still needs to load current->utask to
read ->vaddr.

Remove this argument, change riprel_pre_xol() to use current->utask.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 arch/x86/kernel/uprobes.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/uprobes.c b/arch/x86/kernel/uprobes.c
index a647808..9f6aba3 100644
--- a/arch/x86/kernel/uprobes.c
+++ b/arch/x86/kernel/uprobes.c
@@ -330,16 +330,17 @@ static void riprel_analyze(struct arch_uprobe *auprobe, struct insn *insn)
  * If we're emulating a rip-relative instruction, save the contents
  * of the scratch register and store the target address in that register.
  */
-static void riprel_pre_xol(struct arch_uprobe *auprobe, struct pt_regs *regs,
-				struct arch_uprobe_task *autask)
+static void riprel_pre_xol(struct arch_uprobe *auprobe, struct pt_regs *regs)
 {
+	struct uprobe_task *utask = current->utask;
+
 	if (auprobe->def.fixups & UPROBE_FIX_RIP_AX) {
-		autask->saved_scratch_register = regs->ax;
-		regs->ax = current->utask->vaddr;
+		utask->autask.saved_scratch_register = regs->ax;
+		regs->ax = utask->vaddr;
 		regs->ax += auprobe->def.riprel_target;
 	} else if (auprobe->def.fixups & UPROBE_FIX_RIP_CX) {
-		autask->saved_scratch_register = regs->cx;
-		regs->cx = current->utask->vaddr;
+		utask->autask.saved_scratch_register = regs->cx;
+		regs->cx = utask->vaddr;
 		regs->cx += auprobe->def.riprel_target;
 	}
 }
@@ -377,8 +378,7 @@ static inline bool is_64bit_mm(struct mm_struct *mm)
 static void riprel_analyze(struct arch_uprobe *auprobe, struct insn *insn)
 {
 }
-static void riprel_pre_xol(struct arch_uprobe *auprobe, struct pt_regs *regs,
-				struct arch_uprobe_task *autask)
+static void riprel_pre_xol(struct arch_uprobe *auprobe, struct pt_regs *regs)
 {
 }
 static void riprel_post_xol(struct arch_uprobe *auprobe, struct pt_regs *regs,
@@ -401,7 +401,7 @@ static inline int sizeof_long(void)
 
 static int default_pre_xol_op(struct arch_uprobe *auprobe, struct pt_regs *regs)
 {
-	riprel_pre_xol(auprobe, regs, &current->utask->autask);
+	riprel_pre_xol(auprobe, regs);
 	return 0;
 }
 
-- 
1.5.5.1

