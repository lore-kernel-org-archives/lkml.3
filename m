Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161054AbaDSRDf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2014 13:03:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47519 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751510AbaDSRCG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2014 13:02:06 -0400
Date: Sat, 19 Apr 2014 19:01:55 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <aarapov@redhat.com>, David Long <dave.long@linaro.org>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Jim Keniston <jkenisto@us.ibm.com>, Jonathan Lebon <jlebon@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] uprobes/x86: Shift "insn_complete" from
	branch_setup_xol_ops() to uprobe_init_insn()
Message-ID: <20140419170155.GA30864@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140419170104.GA30667@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change uprobe_init_insn() to make insn_complete() == T, this makes
other insn_get_*() calls unnecessary.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 arch/x86/kernel/uprobes.c |   13 ++++---------
 1 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/uprobes.c b/arch/x86/kernel/uprobes.c
index 5876ba5..6748600 100644
--- a/arch/x86/kernel/uprobes.c
+++ b/arch/x86/kernel/uprobes.c
@@ -209,8 +209,11 @@ static int uprobe_init_insn(struct arch_uprobe *auprobe, struct insn *insn, bool
 	u32 volatile *good_insns;
 
 	insn_init(insn, auprobe->insn, x86_64);
+	/* has the side-effect of processing the entire instruction */
+	insn_get_length(insn);
+	if (WARN_ON_ONCE(!insn_complete(insn)))
+		return -ENOEXEC;
 
-	insn_get_opcode(insn);
 	if (is_prefix_bad(insn))
 		return -ENOTSUPP;
 
@@ -283,8 +286,6 @@ handle_riprel_insn(struct arch_uprobe *auprobe, struct insn *insn)
 	 * is the immediate operand.
 	 */
 	cursor = auprobe->insn + insn_offset_modrm(insn);
-	insn_get_length(insn);
-
 	/*
 	 * Convert from rip-relative addressing to indirect addressing
 	 * via a scratch register.  Change the r/m field from 0x5 (%rip)
@@ -563,11 +564,6 @@ static int branch_setup_xol_ops(struct arch_uprobe *auprobe, struct insn *insn)
 {
 	u8 opc1 = OPCODE1(insn);
 
-	/* has the side-effect of processing the entire instruction */
-	insn_get_length(insn);
-	if (WARN_ON_ONCE(!insn_complete(insn)))
-		return -ENOEXEC;
-
 	switch (opc1) {
 	case 0xeb:	/* jmp 8 */
 	case 0xe9:	/* jmp 32 */
@@ -643,7 +639,6 @@ int arch_uprobe_analyze_insn(struct arch_uprobe *auprobe, struct mm_struct *mm,
 		fix_ip = false;
 		break;
 	case 0xff:
-		insn_get_modrm(&insn);
 		switch (MODRM_REG(&insn)) {
 		case 2: case 3:			/* call or lcall, indirect */
 			fix_call = true;
-- 
1.5.5.1

