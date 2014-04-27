Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753406AbaD0Qwu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 12:52:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27644 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753253AbaD0Qws (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 12:52:48 -0400
Date: Sun, 27 Apr 2014 18:52:23 +0200
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
Subject: [PATCH 1/3] uprobes/x86: Rename *riprel* helpers to make the
	naming consistent
Message-ID: <20140427165223.GA4013@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140427165200.GA3956@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

handle_riprel_insn(), pre_xol_rip_insn() and handle_riprel_post_xol()
look confusing and inconsistent. Rename them into riprel_analyze(),
riprel_pre_xol(), and riprel_post_xol() respectively.

No changes in compiled code.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 arch/x86/kernel/uprobes.c |   24 +++++++++++-------------
 1 files changed, 11 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kernel/uprobes.c b/arch/x86/kernel/uprobes.c
index 4ae2406..a647808 100644
--- a/arch/x86/kernel/uprobes.c
+++ b/arch/x86/kernel/uprobes.c
@@ -268,8 +268,7 @@ static inline bool is_64bit_mm(struct mm_struct *mm)
  *  - There's never a SIB byte.
  *  - The displacement is always 4 bytes.
  */
-static void
-handle_riprel_insn(struct arch_uprobe *auprobe, struct insn *insn)
+static void riprel_analyze(struct arch_uprobe *auprobe, struct insn *insn)
 {
 	u8 *cursor;
 	u8 reg;
@@ -331,8 +330,7 @@ handle_riprel_insn(struct arch_uprobe *auprobe, struct insn *insn)
  * If we're emulating a rip-relative instruction, save the contents
  * of the scratch register and store the target address in that register.
  */
-static void
-pre_xol_rip_insn(struct arch_uprobe *auprobe, struct pt_regs *regs,
+static void riprel_pre_xol(struct arch_uprobe *auprobe, struct pt_regs *regs,
 				struct arch_uprobe_task *autask)
 {
 	if (auprobe->def.fixups & UPROBE_FIX_RIP_AX) {
@@ -346,8 +344,8 @@ pre_xol_rip_insn(struct arch_uprobe *auprobe, struct pt_regs *regs,
 	}
 }
 
-static void
-handle_riprel_post_xol(struct arch_uprobe *auprobe, struct pt_regs *regs, long *correction)
+static void riprel_post_xol(struct arch_uprobe *auprobe, struct pt_regs *regs,
+				long *correction)
 {
 	if (auprobe->def.fixups & (UPROBE_FIX_RIP_AX | UPROBE_FIX_RIP_CX)) {
 		struct arch_uprobe_task *autask;
@@ -376,14 +374,14 @@ static inline bool is_64bit_mm(struct mm_struct *mm)
 /*
  * No RIP-relative addressing on 32-bit
  */
-static void handle_riprel_insn(struct arch_uprobe *auprobe, struct insn *insn)
+static void riprel_analyze(struct arch_uprobe *auprobe, struct insn *insn)
 {
 }
-static void pre_xol_rip_insn(struct arch_uprobe *auprobe, struct pt_regs *regs,
+static void riprel_pre_xol(struct arch_uprobe *auprobe, struct pt_regs *regs,
 				struct arch_uprobe_task *autask)
 {
 }
-static void handle_riprel_post_xol(struct arch_uprobe *auprobe, struct pt_regs *regs,
+static void riprel_post_xol(struct arch_uprobe *auprobe, struct pt_regs *regs,
 					long *correction)
 {
 }
@@ -403,7 +401,7 @@ static inline int sizeof_long(void)
 
 static int default_pre_xol_op(struct arch_uprobe *auprobe, struct pt_regs *regs)
 {
-	pre_xol_rip_insn(auprobe, regs, &current->utask->autask);
+	riprel_pre_xol(auprobe, regs, &current->utask->autask);
 	return 0;
 }
 
@@ -423,7 +421,7 @@ static int default_post_xol_op(struct arch_uprobe *auprobe, struct pt_regs *regs
 	struct uprobe_task *utask = current->utask;
 	long correction = (long)(utask->vaddr - utask->xol_vaddr);
 
-	handle_riprel_post_xol(auprobe, regs, &correction);
+	riprel_post_xol(auprobe, regs, &correction);
 	if (auprobe->def.fixups & UPROBE_FIX_IP) {
 		regs->ip += correction;
 	} else if (auprobe->def.fixups & UPROBE_FIX_CALL) {
@@ -440,7 +438,7 @@ static int default_post_xol_op(struct arch_uprobe *auprobe, struct pt_regs *regs
 
 static void default_abort_op(struct arch_uprobe *auprobe, struct pt_regs *regs)
 {
-	handle_riprel_post_xol(auprobe, regs, NULL);
+	riprel_post_xol(auprobe, regs, NULL);
 }
 
 static struct uprobe_xol_ops default_xol_ops = {
@@ -652,7 +650,7 @@ int arch_uprobe_analyze_insn(struct arch_uprobe *auprobe, struct mm_struct *mm,
 		}
 		/* fall through */
 	default:
-		handle_riprel_insn(auprobe, &insn);
+		riprel_analyze(auprobe, &insn);
 	}
 
 	auprobe->def.ilen = insn.length;
-- 
1.5.5.1

