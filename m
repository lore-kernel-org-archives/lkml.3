Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753599AbaD0Qwz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 12:52:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5728 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753350AbaD0Qww (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 12:52:52 -0400
Date: Sun, 27 Apr 2014 18:52:30 +0200
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
Subject: [PATCH 3/3] uprobes/x86: Simplify riprel_{pre,post}_xol() and make
	them similar
Message-ID: <20140427165230.GA4023@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140427165200.GA3956@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ignoring the "correction" logic riprel_pre_xol() and riprel_post_xol()
are very similar but look quite differently.

1. Add the "UPROBE_FIX_RIP_AX | UPROBE_FIX_RIP_CX" check at the start
   of riprel_pre_xol(), like the same check in riprel_post_xol().

2. Add the trivial scratch_reg() helper which returns the address of
   scratch register pre_xol/post_xol need to change.

3. Change these functions to use the new helper and avoid copy-and-paste
   under if/else branches.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 arch/x86/kernel/uprobes.c |   32 +++++++++++++++-----------------
 1 files changed, 15 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kernel/uprobes.c b/arch/x86/kernel/uprobes.c
index 9f6aba3..6a9cac1 100644
--- a/arch/x86/kernel/uprobes.c
+++ b/arch/x86/kernel/uprobes.c
@@ -326,22 +326,24 @@ static void riprel_analyze(struct arch_uprobe *auprobe, struct insn *insn)
 	}
 }
 
+static inline unsigned long *
+scratch_reg(struct arch_uprobe *auprobe, struct pt_regs *regs)
+{
+	return (auprobe->def.fixups & UPROBE_FIX_RIP_AX) ? &regs->ax : &regs->cx;
+}
+
 /*
  * If we're emulating a rip-relative instruction, save the contents
  * of the scratch register and store the target address in that register.
  */
 static void riprel_pre_xol(struct arch_uprobe *auprobe, struct pt_regs *regs)
 {
-	struct uprobe_task *utask = current->utask;
+	if (auprobe->def.fixups & (UPROBE_FIX_RIP_AX | UPROBE_FIX_RIP_CX)) {
+		struct uprobe_task *utask = current->utask;
+		unsigned long *sr = scratch_reg(auprobe, regs);
 
-	if (auprobe->def.fixups & UPROBE_FIX_RIP_AX) {
-		utask->autask.saved_scratch_register = regs->ax;
-		regs->ax = utask->vaddr;
-		regs->ax += auprobe->def.riprel_target;
-	} else if (auprobe->def.fixups & UPROBE_FIX_RIP_CX) {
-		utask->autask.saved_scratch_register = regs->cx;
-		regs->cx = utask->vaddr;
-		regs->cx += auprobe->def.riprel_target;
+		utask->autask.saved_scratch_register = *sr;
+		*sr = utask->vaddr + auprobe->def.riprel_target;
 	}
 }
 
@@ -349,14 +351,10 @@ static void riprel_post_xol(struct arch_uprobe *auprobe, struct pt_regs *regs,
 				long *correction)
 {
 	if (auprobe->def.fixups & (UPROBE_FIX_RIP_AX | UPROBE_FIX_RIP_CX)) {
-		struct arch_uprobe_task *autask;
-
-		autask = &current->utask->autask;
-		if (auprobe->def.fixups & UPROBE_FIX_RIP_AX)
-			regs->ax = autask->saved_scratch_register;
-		else
-			regs->cx = autask->saved_scratch_register;
+		struct uprobe_task *utask = current->utask;
+		unsigned long *sr = scratch_reg(auprobe, regs);
 
+		*sr = utask->autask.saved_scratch_register;
 		/*
 		 * The original instruction includes a displacement, and so
 		 * is 4 bytes longer than what we've just single-stepped.
-- 
1.5.5.1

